#!/usr/bin/env python3
"""
Thyrox Bootstrap — One-shot installer para proyectos Claude Code.

Genera agentes nativos en .claude/agents/ a partir del registry YAML + templates,
y actualiza .mcp.json con los MCP servers de Thyrox.

Uso:
    python .thyrox/registry/bootstrap.py --stack react,nodejs,postgresql
    python .thyrox/registry/bootstrap.py --stack react --force
    python .thyrox/registry/bootstrap.py --stack react --model claude
"""

import argparse
import json
import os
import sys
from pathlib import Path


# ─── Constantes ──────────────────────────────────────────────────────────────

REGISTRY_DIR = Path(__file__).parent
PROJECT_ROOT = REGISTRY_DIR.parent.parent  # .thyrox/registry/ → .thyrox/ → repo root
AGENTS_DIR = PROJECT_ROOT / ".claude" / "agents"
MEMORY_DIR = PROJECT_ROOT / ".claude" / "memory"
MCP_JSON = PROJECT_ROOT / ".mcp.json"
PROJECT_STATE = PROJECT_ROOT / ".thyrox" / "context" / "project-state.md"

SUPPORTED_MODELS = ["claude"]
TECH_CATEGORIES = {
    "react": "frontend",
    "webpack": "frontend",
    "nodejs": "backend",
    "python": "backend",
    "fastapi": "backend",
    "django": "backend",
    "postgresql": "database",
    "mysql": "database",
    "mongodb": "database",
    "redis": "database",
}

CORE_AGENTS = ["task-planner", "task-executor", "tech-detector", "skill-generator"]

# ─── Política de generación de coordinator agents ────────────────────────────
#
# DECISIÓN: Los coordinator agents NO se generan dinámicamente desde bootstrap.py.
# Son archivos estáticos en .claude/agents/ mantenidos manualmente (o via script).
#
# Justificación:
#   1. Los coordinators tienen lógica compleja (retornos condicionales, ciclos,
#      iteraciones) que no se puede expresar solo con campos del registry YAML.
#   2. Cada coordinator tiene secciones únicas: Principios ESIA, Checkpoint de
#      sponsor, Gemba, Ciclo estratégico — lógica que varía por metodología.
#   3. Los YAML de registry describen los pasos, no la lógica de orquestación.
#
# Cuándo crear un nuevo coordinator:
#   - Al agregar una nueva metodología a .thyrox/registry/methodologies/{flow}.yml
#   - Usar dmaic-coordinator.md como template base (patrón más completo)
#   - Seguir el schema: skills[], isolation:worktree, background:true, color:
#   - Agregar sección "Cierre — artifact-ready signal" con lista de artefactos
#
# Convención de naming:
#   {flow-id}-coordinator.md  → lean-coordinator.md, pps-coordinator.md, etc.
#
# ─────────────────────────────────────────────────────────────────────────────

MCP_SERVERS = {
    "thyrox-memory": {
        "command": "python",
        "args": [".thyrox/registry/mcp/memory_server.py"],
        "env": {
            "MEMORY_INDEX_PATH": ".claude/memory/thyrox.faiss"
        }
    },
    "thyrox-executor": {
        "command": "python",
        "args": [".thyrox/registry/mcp/executor_server.py"]
    }
}

# Dependencias Python requeridas por cada MCP server
MCP_SERVER_DEPS = {
    "thyrox-memory": ["faiss", "sentence_transformers"],
    "thyrox-executor": [],
}


# ─── Helpers ─────────────────────────────────────────────────────────────────

def read_project_name() -> str:
    """Lee el nombre del proyecto desde project-state.md, o retorna placeholder."""
    if PROJECT_STATE.exists():
        content = PROJECT_STATE.read_text()
        for line in content.splitlines():
            if line.lower().startswith("# ") or "nombre:" in line.lower() or "name:" in line.lower():
                name = line.lstrip("#").strip().split(":")[-1].strip()
                if name:
                    return name
    return "{{PROJECT_NAME}}"


def read_yaml_frontmatter(path: Path) -> dict:
    """
    Extrae el bloque YAML de un archivo Markdown con frontmatter.
    Soporta tanto --- como el bloque de código ```yml.
    Retorna dict con las claves encontradas.
    """
    if not path.exists():
        return {}

    content = path.read_text()
    result = {}

    # Intentar frontmatter estándar ---
    if content.startswith("---"):
        lines = content.splitlines()
        end = -1
        for i, line in enumerate(lines[1:], 1):
            if line.strip() == "---":
                end = i
                break
        if end > 0:
            for line in lines[1:end]:
                if ":" in line:
                    key, _, val = line.partition(":")
                    result[key.strip()] = val.strip()
        return result

    # Intentar bloque ```yml
    import re
    match = re.search(r"```ya?ml\s*\n(.*?)\n```", content, re.DOTALL)
    if match:
        for line in match.group(1).splitlines():
            if ":" in line:
                key, _, val = line.partition(":")
                result[key.strip()] = val.strip()

    return result


def parse_tools_from_yml(yml_path: Path) -> list[str]:
    """Extrae la lista de tools del YAML del registry."""
    if not yml_path.exists():
        return []

    content = yml_path.read_text()
    tools = []
    in_tools = False

    for line in content.splitlines():
        stripped = line.strip()
        if stripped.startswith("tools:"):
            in_tools = True
            continue
        if in_tools:
            if stripped.startswith("-"):
                tools.append(stripped.lstrip("- ").strip())
            elif stripped and not stripped.startswith("#"):
                # Otra clave YAML — salir del bloque tools
                in_tools = False

    return tools


def parse_system_prompt(yml_path: Path) -> str:
    """Extrae el system_prompt del YAML del registry."""
    if not yml_path.exists():
        return ""

    content = yml_path.read_text()
    lines = content.splitlines()
    in_prompt = False
    prompt_lines = []
    indent = 0

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("system_prompt:"):
            in_prompt = True
            rest = stripped[len("system_prompt:"):].strip()
            if rest and rest not in ("|", ">"):
                return rest
            # Bloque multilínea — detectar indentación
            indent = len(line) - len(line.lstrip()) + 2
            continue
        if in_prompt:
            if line and not line.startswith(" " * indent) and not line.startswith("\t"):
                break
            prompt_lines.append(line[indent:] if len(line) > indent else line)

    return "\n".join(prompt_lines).strip()


def parse_field(yml_path: Path, field: str) -> str:
    """Extrae un campo simple del YAML. Soporta block scalars (> y |)."""
    if not yml_path.exists():
        return ""

    content = yml_path.read_text()
    lines = content.splitlines()

    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith(f"{field}:"):
            value = stripped[len(f"{field}:"):].strip()
            # Block scalar (> o |): recolectar líneas siguientes indentadas
            if value in (">", "|", ""):
                block_lines = []
                indent = None
                for j in range(i + 1, len(lines)):
                    bline = lines[j]
                    if not bline.strip():
                        block_lines.append("")
                        continue
                    # Detectar indentación del primer bloque
                    if indent is None:
                        indent = len(bline) - len(bline.lstrip())
                    if len(bline) - len(bline.lstrip()) < indent:
                        break  # Fin del bloque
                    block_lines.append(bline.strip())
                return " ".join(l for l in block_lines if l).strip()
            return value
    return ""


# ─── Verificación de dependencias ────────────────────────────────────────────

def check_python_deps() -> dict[str, bool]:
    """Verifica dependencias Python para MCP servers."""
    import importlib.util
    deps = {
        "faiss": importlib.util.find_spec("faiss") is not None,
        "sentence_transformers": importlib.util.find_spec("sentence_transformers") is not None,
    }
    for dep, available in deps.items():
        if not available:
            print(f"  [WARN] {dep} no disponible — MCP server thyrox-memory no funcionará")
    return deps


# ─── Generadores ─────────────────────────────────────────────────────────────

def generate_agent_md(name: str, description: str, tools: list[str], body: str) -> str:
    """Genera el contenido de un archivo .claude/agents/*.md.

    NOTA: model NO se incluye — campo prohibido en agentes nativos Claude Code.
    """
    tools_yaml = "\n".join(f"  - {t}" for t in tools)
    return f"""---
name: {name}
description: {description}
tools:
{tools_yaml}
---

{body}
"""


def install_core_agents(force: bool, model: str) -> tuple[list[str], int]:
    """
    Instala los 4 agentes core desde .claude/agents/ ya existentes.
    Si el archivo ya existe y no hay --force, reporta skip.
    Retorna (lista de agentes instalados, número de fallos).
    """
    installed = []
    failed = 0
    source_dir = AGENTS_DIR

    # Los agentes core ya existen como .md en .claude/agents/
    # Solo verificar que están presentes con frontmatter correcto
    for agent_name in CORE_AGENTS:
        agent_path = source_dir / f"{agent_name}.md"
        if agent_path.exists():
            if not force:
                print(f"  [OK] {agent_name:<20} → ya existe — skip")
            else:
                print(f"  [OK] {agent_name:<20} → ya existe (--force: manteniendo)")
            installed.append(agent_name)
        else:
            print(f"  [FAIL] {agent_name:<20} → no encontrado en .claude/agents/")
            failed += 1

    return installed, failed


def install_tech_agent(tech: str, force: bool, model: str, project_name: str) -> tuple[bool, int]:
    """
    Genera .claude/agents/{tech}-expert.md desde registry YAML + template.
    Retorna (instalado: bool, failed: int) — failed=1 si hubo error real, 0 si solo skip.
    """
    dest = AGENTS_DIR / f"{tech}-expert.md"

    if dest.exists() and not force:
        print(f"  [OK] {tech}-expert{' ' * max(0, 18 - len(tech))} → ya existe — skip")
        return False, 0

    # Buscar YAML en registry
    yml_path = REGISTRY_DIR / "agents" / f"{tech}-expert.yml"
    if not yml_path.exists():
        print(f"  [FAIL] {tech}-expert{' ' * max(0, 18 - len(tech))} → no hay YAML en registry/agents/{tech}-expert.yml")
        return False, 1

    # Leer campos del YAML
    name = parse_field(yml_path, "name") or f"{tech}-expert"
    description = parse_field(yml_path, "description") or f"Experto en {tech}"
    tools = parse_tools_from_yml(yml_path)
    system_prompt = parse_system_prompt(yml_path)

    # Buscar template de skill
    category = TECH_CATEGORIES.get(tech, "")
    template_body = ""
    if category:
        template_path = REGISTRY_DIR / category / f"{tech}.skill.template.md"
        if template_path.exists():
            template_body = template_path.read_text()
            template_body = template_body.replace("{{PROJECT_NAME}}", project_name)

    # Componer body: system_prompt + template
    body_parts = []
    if system_prompt:
        body_parts.append(system_prompt)
    if template_body:
        body_parts.append(template_body)

    body = "\n\n---\n\n".join(body_parts) if body_parts else f"# {name}\n\nAgente experto en {tech}."

    # Escribir el archivo
    content = generate_agent_md(name, description, tools, body)
    action = "sobreescrito" if dest.exists() else "creado"
    dest.write_text(content)
    print(f"  [OK] {tech}-expert{' ' * max(0, 18 - len(tech))} → .claude/agents/{tech}-expert.md ({action})")
    return True, 0


def update_mcp_json(force: bool, deps: dict[str, bool] | None = None) -> None:
    """Actualiza .mcp.json con los MCP servers de Thyrox.

    Si deps contiene dependencias faltantes, omite los servers que las requieren.
    """
    if deps is None:
        deps = {}

    existing = {}
    if MCP_JSON.exists():
        try:
            existing = json.loads(MCP_JSON.read_text())
        except json.JSONDecodeError:
            existing = {}

    mcp_servers = existing.get("mcpServers", {})

    changed = False
    for server_name, config in MCP_SERVERS.items():
        # Verificar si las dependencias requeridas por este server están disponibles
        required_deps = MCP_SERVER_DEPS.get(server_name, [])
        missing = [d for d in required_deps if not deps.get(d, True)]
        if missing:
            print(f"  [SKIP] {server_name} — dependencias faltantes: {', '.join(missing)}")
            continue

        if server_name not in mcp_servers or force:
            mcp_servers[server_name] = config
            changed = True

    if changed:
        existing["mcpServers"] = mcp_servers
        MCP_JSON.write_text(json.dumps(existing, indent=2) + "\n")
        print(f"  [OK] .mcp.json actualizado")
    else:
        print(f"  [OK] .mcp.json — MCP servers ya configurados — skip")


def ensure_memory_dir() -> None:
    """Crea .claude/memory/ si no existe."""
    MEMORY_DIR.mkdir(parents=True, exist_ok=True)


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Thyrox Bootstrap — inicializa agentes y MCP servers para Claude Code"
    )
    parser.add_argument(
        "--stack",
        required=True,
        help="Stack de tecnologías separadas por coma (ej: react,nodejs,postgresql)"
    )
    parser.add_argument(
        "--model",
        default="claude",
        help="Modelo a usar para los agentes (default: claude)"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Sobreescribir agentes existentes"
    )

    args = parser.parse_args()

    # Validar modelo
    if args.model not in SUPPORTED_MODELS:
        print(f"ERROR: modelo '{args.model}' no soportado en v3.")
        print(f"       Modelos soportados: {', '.join(SUPPORTED_MODELS)}")
        if args.model == "openai":
            print("       modelo openai no soportado en v3 — usar --model claude")
        return 1

    # Parsear stack
    techs = [t.strip().lower() for t in args.stack.split(",") if t.strip()]
    if not techs:
        print("ERROR: --stack no puede estar vacío")
        return 1

    project_name = read_project_name()

    print(f"\nThyrox Bootstrap v3")
    print(f"Stack: {', '.join(techs)}")
    print(f"Model: {args.model}")
    print(f"Force: {args.force}")
    print(f"Proyecto: {project_name}")
    print()

    # 1. Crear directorios necesarios
    AGENTS_DIR.mkdir(parents=True, exist_ok=True)
    ensure_memory_dir()

    # 2. Verificar dependencias Python para MCP servers
    print("Verificando dependencias MCP:")
    deps = check_python_deps()
    print()

    # 3. Agentes core
    print("Agentes core:")
    core_installed, core_failures = install_core_agents(force=args.force, model=args.model)
    print()

    # 4. Agentes de tecnología
    print("Agentes de tecnología:")
    tech_installed = 0
    tech_failures = 0
    for tech in techs:
        installed, failed = install_tech_agent(
            tech=tech,
            force=args.force,
            model=args.model,
            project_name=project_name,
        )
        if installed:
            tech_installed += 1
        tech_failures += failed
    print()

    # 5. MCP servers
    print("MCP Servers:")
    update_mcp_json(force=args.force, deps=deps)
    print()

    # 6. Resumen
    total_failures = core_failures + tech_failures
    installed_this_run = len(core_installed) + tech_installed
    total_on_disk = len(list(AGENTS_DIR.glob("*.md")))
    print(f"Bootstrap completado.")
    print(f"  Agentes core:            {len(core_installed)}/{len(CORE_AGENTS)}")
    print(f"  Agentes de tech:         {tech_installed}/{len(techs)}")
    print(f"  Instalados esta ejecución: {installed_this_run}")
    print(f"  Total en .claude/agents/: {total_on_disk}")
    if total_failures > 0:
        print(f"  Fallos: {total_failures}")
    print()
    print("Siguiente paso: reinicia Claude Code para activar los agentes y MCP servers.")

    return 1 if total_failures > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
