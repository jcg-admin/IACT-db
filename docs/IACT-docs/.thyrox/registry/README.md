# THYROX Registry

El registry es la fuente de verdad para los tres tipos de artefactos que THYROX genera automáticamente. Cada tipo tiene un propósito distinto y un flujo de generación propio.

---

## Los tres flujos

### Flujo A — Agents (comportamiento)

**Qué son:** Definiciones de agentes spawnables — subprocesos Claude con herramientas específicas y conocimiento técnico embebido.

**Formato:** `agents/*.yml`

**Generador:** `bootstrap.py`

**Salida:** `.claude/agents/*.md` (agentes nativos Claude Code)

**Invocación:** `Agent tool → subagent_type: "nombre-agente"`

```
agents/task-planner.yml  ──┐
agents/task-executor.yml ──┤
agents/tech-detector.yml ──┤─→ bootstrap.py ──→ .claude/agents/*.md
agents/skill-generator.yml─┤
agents/nodejs-expert.yml ──┤
agents/react-expert.yml  ──┤
agents/postgresql-expert.yml┘
```

Uso: `python .claude/registry/bootstrap.py --stack nodejs,react`

Ver [`agents/README.md`](agents/README.md) para el formato de los YMLs.

---

### Flujo B — Skill Templates (datos/metodología)

**Qué son:** Templates de metodología SDLC por stack tecnológico — guías fase-por-fase para trabajar en proyectos con un framework específico.

**Formato:** `{layer}/{framework}.template.md`

**Generador:** `_generator.sh`

**Salida:**
- `.claude/skills/{layer}-{framework}/SKILL.md` — guía fase-por-fase
- `.claude/guidelines/{layer}-{framework}.instructions.md` — reglas siempre-on

**Invocación:** `Skill tool → {layer}-{framework}` o auto-carga via `.instructions.md`

```
backend/nodejs.template.md    ──┐
frontend/react.template.md    ──┤─→ _generator.sh ──→ .claude/skills/
db/postgresql.template.md     ──┘                     .claude/guidelines/
```

Uso: `.claude/registry/_generator.sh backend nodejs`

---

### Flujo C — MCP Servers (runtime)

**Qué son:** Servidores MCP que exponen capacidades de ejecución y memoria a Claude durante la sesión.

**Formato:** `mcp/*.py`

**Activación:** Declarados en `.mcp.json` — Claude Code los arranca automáticamente.

**Herramientas expuestas:**
- `mcp__thyrox-executor__exec_cmd` — ejecuta comandos shell
- `mcp__thyrox-executor__exec_python` — ejecuta código Python
- `mcp__thyrox-memory__store` / `retrieve` — memoria persistente (FAISS)

```
mcp/executor_server.py  ──┐
mcp/memory_server.py    ──┤─→ .mcp.json ──→ Claude Code arranca los servidores
mcp/thyrox_core.py      ──┘                  en cada sesión
```

Ver [`mcp/README.md`](mcp/README.md) para detalles de cada servidor.

---

## Separación datos/comportamiento

Inspirado en [mise](https://mise.jdx.dev):

| Tipo | Naturaleza | Análogo en mise |
|------|-----------|-----------------|
| `agents/*.yml` | **Comportamiento** — define quién puede ejecutar qué | Backends (npm, cargo, github) |
| `{layer}/*.template.md` | **Datos** — define qué metodología aplicar | Registry TOML por tool |
| `mcp/*.py` | **Runtime** — infraestructura de capacidades | Herramientas instaladas por mise |

La separación física ya existe en el directorio. Esta tabla documenta la separación semántica.

---

## Estructura completa

```
.claude/registry/
├── README.md              ← Este archivo
├── bootstrap.py           ← Genera .claude/agents/ desde agents/*.yml
├── _generator.sh          ← Genera .claude/skills/ desde templates
├── agents/                ← Flujo A: definiciones de agentes
│   ├── README.md
│   ├── task-planner.yml
│   ├── task-executor.yml
│   ├── tech-detector.yml
│   ├── skill-generator.yml
│   ├── nodejs-expert.yml
│   ├── react-expert.yml
│   └── postgresql-expert.yml
├── backend/               ← Flujo B: templates de metodología
│   └── nodejs.template.md
├── frontend/
│   └── react.template.md
├── db/
│   └── postgresql.template.md
└── mcp/                   ← Flujo C: servidores de runtime
    ├── README.md
    ├── thyrox_core.py
    ├── executor_server.py
    └── memory_server.py
```

---

## Capas válidas para templates

| Capa | Ejemplos |
|------|----------|
| `frontend` | react, vue, nextjs, svelte |
| `backend` | nodejs, python, go, java |
| `db` | postgresql, mysql, mongodb, redis |
| `infra` | docker, kubernetes, terraform |
| `mobile` | reactnative, flutter |
| `testing` | cypress, playwright, jest |

## Cómo extender el registry

- **Agregar un agente nuevo** → crear `agents/{nombre}.yml`. Ver [`agents/README.md`](agents/README.md).
- **Agregar un tech skill nuevo** → crear `{layer}/{framework}.template.md`. Ver el formato de templates en el README anterior.
- **Modificar un servidor MCP** → ver [`mcp/README.md`](mcp/README.md).
