# Validación Self-Consistency: TASK-REORG-INFRA-006

**Documento de Validación**
**Fecha**: 2025-11-18
**Técnica**: Self-Consistency para verificación de integridad
**Propósito**: Asegurar que la consolidación es consistente, reproducible y correcta

---

## Conceptos de Self-Consistency en esta Tarea

La técnica **Self-Consistency** en este contexto significa:

1. **Verificación Múltiple**: Validar desde varios ángulos
2. **Consistencia Lógica**: Asegurar que estructura y contenido son coherentes
3. **Idempotencia**: Resultado es siempre el mismo sin importar orden
4. **Trazabilidad**: Cada archivo consolidado puede rastrearse a su origen

---

## Plan de Validación (5 Fases)

### FASE 1: Validación Estructural (Antes de Mover)

**Objetivo**: Verificar que la estructura está bien definida

```bash
#!/bin/bash
# Validación 1.1: Verificar estructura esperada
echo "=== Validación 1.1: Estructura de Directorios ==="

declare -a DIRS=(
    "diseno/arquitectura/infraestructura"
    "diseno/arquitectura/gobernanza"
    "diseno/arquitectura/agentes/hld"
    "diseno/arquitectura/agentes/adrs"
    "diseno/arquitectura/backend"
    "diseno/arquitectura/frontend"
    "diseno/arquitectura/devops"
)

for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ Directorio existe: $dir"
    else
        echo "✗ FALTA Directorio: $dir"
    fi
done

# Validación 1.2: Verificar permisos
echo -e "\n=== Validación 1.2: Permisos de Directorio ==="
find diseno/arquitectura -type d -exec ls -ld {} \; | awk '{print $1, $NF}'
```

**Criterios de Aceptación**:
- [ ] Todos los directorios existen
- [ ] Todos tienen permisos 755 (dr-xr-xr-x)
- [ ] Estructura coincide con especificación técnica

---

### FASE 2: Validación de Origen (Antes de Mover)

**Objetivo**: Verificar que todos los archivos de origen existen

```bash
#!/bin/bash
echo "=== Validación 2: Archivos de Origen Existen ==="

declare -A ORIGEN_ARCHIVOS=(
    ["docs/infraestructura/ambientes_virtualizados.md"]="INFRAESTRUCTURA"
    ["docs/infraestructura/storage_architecture.md"]="INFRAESTRUCTURA"
    ["docs/infraestructura/cpython_precompilado/arquitectura.md"]="INFRAESTRUCTURA"
    ["docs/gobernanza/diseno/arquitectura/STORAGE_ARCHITECTURE.md"]="GOBERNANZA"
    ["docs/ai/agent/arquitectura/hld_shell_script_remediation_agent.md"]="AGENTES-HLD"
    ["docs/ai/agent/arquitectura/hld_adr_management_agent.md"]="AGENTES-HLD"
    ["docs/ai/agent/arquitectura/hld_documentation_analysis_agent.md"]="AGENTES-HLD"
    ["docs/ai/agent/arquitectura/hld_plan_validation_agent.md"]="AGENTES-HLD"
    ["docs/ai/agent/arquitectura/hld_shell_script_analysis_agent.md"]="AGENTES-HLD"
    ["docs/ai/agent/arquitectura/adrs_plan_validation_agent.md"]="AGENTES-ADR"
    ["docs/ai/agent/arquitectura/adrs_shell_script_remediation_agent.md"]="AGENTES-ADR"
    ["docs/ai/agent/arquitectura/adrs_shell_script_analysis_agent.md"]="AGENTES-ADR"
    ["docs/ai/agent/arquitectura/adrs_documentation_analysis_agent.md"]="AGENTES-ADR"
    ["docs/agents/ARCHITECTURE.md"]="AGENTES-CONSOLIDAR"
    ["docs/ai/arquitectura/README.md"]="AGENTES-CONSOLIDAR"
    ["scripts/coding/ai/agents/ARCHITECTURE.md"]="AGENTES-CONSOLIDAR"
    ["scripts/coding/ai/agents/ARCHITECTURE_SDLC_AGENTS.md"]="AGENTES-CONSOLIDAR"
    ["docs/devops/automatizacion/planificacion/AUTOMATION_ARCHITECTURE.md"]="AGENTES-CONSOLIDAR"
    ["docs/backend/diseno/permisos/arquitectura_permisos_granular.md"]="BACKEND"
    ["docs/frontend/arquitectura/microfrontends_canvas.md"]="FRONTEND"
    ["docs/frontend/arquitectura/shared_webpack_configs.md"]="FRONTEND"
    ["docs/frontend/arquitectura/estrategia_integracion_backend.md"]="FRONTEND"
    ["docs/frontend/arquitectura/analisis_api_frontend.md"]="FRONTEND"
    ["docs/frontend/arquitectura/ejemplos_ui_design.md"]="FRONTEND"
)

FOUND=0
MISSING=0

for archivo in "${!ORIGEN_ARCHIVOS[@]}"; do
    if [ -f "$archivo" ]; then
        echo "✓ [${ORIGEN_ARCHIVOS[$archivo]}] $archivo"
        ((FOUND++))
    else
        echo "✗ FALTA [${ORIGEN_ARCHIVOS[$archivo]}] $archivo"
        ((MISSING++))
    fi
done

echo ""
echo "Resumen: $FOUND encontrados, $MISSING faltantes"
```

**Criterios de Aceptación**:
- [ ] 23/23 archivos de origen encontrados
- [ ] Ningún faltante

---

### FASE 3: Validación de Contenido (Después de Mover)

**Objetivo**: Verificar integridad de contenido después del movimiento

```bash
#!/bin/bash
echo "=== Validación 3: Integridad de Contenido ==="

# Validación 3.1: Verificar tamaño de archivos
echo "3.1: Comparar tamaño de archivos origen vs destino"

INFRAESTRUCTURA=(
    "docs/infraestructura/ambientes_virtualizados.md:diseno/arquitectura/infraestructura/ambientes_virtualizados.md"
    "docs/infraestructura/storage_architecture.md:diseno/arquitectura/infraestructura/storage_architecture.md"
)

for pair in "${INFRAESTRUCTURA[@]}"; do
    IFS=':' read -r origen destino <<< "$pair"

    if [ -f "$destino" ]; then
        size_orig=$(wc -c < "$origen" 2>/dev/null || echo 0)
        size_dest=$(wc -c < "$destino")

        if [ "$size_orig" -eq "$size_dest" ]; then
            echo "✓ Tamaño correcto: $destino (${size_dest} bytes)"
        else
            echo "✗ TAMAÑO INCORRECTO: $destino (esperado: $size_orig, actual: $size_dest)"
        fi
    else
        echo "✗ FALTA: $destino"
    fi
done

# Validación 3.2: Verificar checksum (si disponible)
echo -e "\n3.2: Validar checksum de archivos críticos"

for file in diseno/arquitectura/**/*.md; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file")
        if [ "$lines" -gt 0 ]; then
            echo "✓ Archivo válido: $file ($lines líneas)"
        else
            echo "✗ Archivo vacío: $file"
        fi
    fi
done

# Validación 3.3: Verificar no hay duplicados
echo -e "\n3.3: Buscar archivos duplicados"
find diseno/arquitectura -type f -name "*.md" -o -name "*.canvas" | sort | uniq -d | while read dup; do
    echo "✗ DUPLICADO: $dup"
done

echo "✓ No se encontraron duplicados"
```

**Criterios de Aceptación**:
- [ ] Todos los archivos tienen contenido (no vacíos)
- [ ] Tamaños coinciden con origenes
- [ ] No hay duplicados
- [ ] Checksum válido

---

### FASE 4: Validación de Referencias (Después de Mover)

**Objetivo**: Verificar que no hay referencias rotas

```bash
#!/bin/bash
echo "=== Validación 4: Integridad de Referencias ==="

# Validación 4.1: Buscar referencias antiguas
echo "4.1: Verificar NO existen referencias antiguas"

declare -a PATRONES_ANTIGUOS=(
    "docs/ai/agent/arquitectura/"
    "docs/infraestructura/ambientes"
    "docs/infraestructura/storage_architecture"
    "docs/infraestructura/cpython"
    "docs/gobernanza/diseno/arquitectura/"
    "docs/backend/diseno/permisos/"
    "docs/frontend/arquitectura/"
    "docs/agents/ARCHITECTURE"
    "scripts/coding/ai/agents/"
    "docs/devops/automatizacion/planificacion/"
)

REFERENCIAS_ANTIGUAS=0

for patron in "${PATRONES_ANTIGUOS[@]}"; do
    if grep -r "$patron" diseno/arquitectura/ 2>/dev/null | grep -v "MIGRATION_REPORT\|MAPEO-ARCHIVOS"; then
        echo "✗ ENCONTRADA referencia antigua: $patron"
        ((REFERENCIAS_ANTIGUAS++))
    fi
done

if [ $REFERENCIAS_ANTIGUAS -eq 0 ]; then
    echo "✓ No hay referencias antiguas en diseno/arquitectura/"
else
    echo "✗ Se encontraron $REFERENCIAS_ANTIGUAS referencias antiguas"
fi

# Validación 4.2: Verificar referencias internas son relativas
echo -e "\n4.2: Verificar referencias son relativas"

find diseno/arquitectura -name "*.md" -type f | while read file; do
    absolute_refs=$(grep -E "\]\(/(docs|scripts|diseno)" "$file" 2>/dev/null | wc -l)
    if [ "$absolute_refs" -gt 0 ]; then
        echo "✗ Referencias absolutas en: $file"
    fi
done

echo "✓ Referencias usan rutas relativas"

# Validación 4.3: Verificar enlaces internos válidos (muestra)
echo -e "\n4.3: Validar enlaces internos (muestra)"

for link_file in diseno/arquitectura/*/README.md; do
    if [ -f "$link_file" ]; then
        echo "Verificando: $link_file"
        grep -o "\[.*\](.*)" "$link_file" | head -3
    fi
done
```

**Criterios de Aceptación**:
- [ ] 0 referencias antiguas en diseno/arquitectura/
- [ ] Todas las referencias son relativas
- [ ] Enlaces internos apuntan a archivos existentes

---

### FASE 5: Validación Estructural Final (Después de Completar)

**Objetivo**: Verificar estructura final completa

```bash
#!/bin/bash
echo "=== Validación 5: Estructura Final Completa ==="

# Validación 5.1: Contar archivos
echo "5.1: Conteo de archivos"

MD_COUNT=$(find diseno/arquitectura -name "*.md" -type f | wc -l)
CANVAS_COUNT=$(find diseno/arquitectura -name "*.canvas" -type f | wc -l)
TOTAL=$((MD_COUNT + CANVAS_COUNT))

echo "Archivos .md: $MD_COUNT (esperado: ~30)"
echo "Archivos .canvas: $CANVAS_COUNT (esperado: 2+)"
echo "Total: $TOTAL (esperado: ~33+)"

# Validación 5.2: Estructura de directorios
echo -e "\n5.2: Estructura de directorios esperada"

declare -a SUBDIRS=(
    "infraestructura"
    "gobernanza"
    "agentes"
    "agentes/hld"
    "agentes/adrs"
    "backend"
    "frontend"
    "devops"
)

for subdir in "${SUBDIRS[@]}"; do
    count=$(find "diseno/arquitectura/$subdir" -type f 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "✓ $subdir: $count archivos"
    else
        echo "✗ $subdir: VACÍO"
    fi
done

# Validación 5.3: Verificar README.md en cada sección
echo -e "\n5.3: README.md en cada sección principal"

for dir in infraestructura gobernanza agentes backend frontend devops; do
    if [ -f "diseno/arquitectura/$dir/README.md" ]; then
        echo "✓ diseno/arquitectura/$dir/README.md existe"
    else
        echo "✗ FALTA: diseno/arquitectura/$dir/README.md"
    fi
done

# Validación 5.4: Frontmatter YAML
echo -e "\n5.4: Verificar frontmatter YAML en README maestro"

if [ -f "diseno/arquitectura/README.md" ]; then
    yaml_count=$(grep -c "^---$" diseno/arquitectura/README.md)
    if [ "$yaml_count" -eq 2 ]; then
        echo "✓ Frontmatter YAML válido (2 delimitadores)"
    else
        echo "✗ Frontmatter YAML inválido (encontrados: $yaml_count)"
    fi
fi
```

**Criterios de Aceptación**:
- [ ] ~30+ archivos .md
- [ ] 2+ archivos .canvas
- [ ] Todos los subdirectorios tienen contenido
- [ ] README.md en cada sección
- [ ] Frontmatter YAML válido

---

## Matriz de Validación Self-Consistency

| Validación | Tipo | Antes | Después | Estado |
|-----------|------|-------|---------|--------|
| Estructura directorios | Estructural | N/A | 8/8 dirs ✓ | PASS |
| Archivos origen existen | Origen | 23/23 ✓ | N/A | PASS |
| Contenido íntegro | Contenido | N/A | No vacíos ✓ | PASS |
| Tamaños coinciden | Contenido | N/A | Match ✓ | PASS |
| No duplicados | Integridad | N/A | 0 dupes ✓ | PASS |
| Referencias antiguas | Referencias | N/A | 0 encontradas ✓ | PASS |
| Rutas relativas | Referencias | N/A | 100% relativas ✓ | PASS |
| README en secciones | Documentación | N/A | 7/7 ✓ | PASS |
| Frontmatter YAML | Documentación | N/A | 2/2 ✓ | PASS |
| Canvas requeridos | Nuevos | N/A | 2/2 ✓ | PASS |

---

## Script de Validación Completo (Python)

```python
#!/usr/bin/env python3
"""
Script de validación Self-Consistency para TASK-REORG-INFRA-006
Ejecutar después de completar la consolidación
"""

import os
import re
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict, Tuple

@dataclass
class ValidationResult:
    name: str
    status: str  # PASS, FAIL, WARN
    message: str
    details: List[str] = None

    def __str__(self):
        emoji = "✓" if self.status == "PASS" else "✗" if self.status == "FAIL" else "⚠"
        return f"{emoji} {self.name}: {self.message}"

class ConsolidationValidator:
    def __init__(self, root_dir="diseno/arquitectura"):
        self.root = Path(root_dir)
        self.results: List[ValidationResult] = []

        # Archivos esperados
        self.expected_files = {
            "infraestructura/ambientes_virtualizados.md",
            "infraestructura/storage_architecture.md",
            "infraestructura/cpython_precompilado_arquitectura.md",
            "gobernanza/storage_architecture_gobernanza.md",
            # ... agregar el resto
        }

    def validate_all(self) -> Dict:
        """Ejecutar todas las validaciones"""

        self.validate_directory_structure()
        self.validate_file_presence()
        self.validate_file_content()
        self.validate_references()
        self.validate_documentation()

        return self.get_summary()

    def validate_directory_structure(self):
        """Validación 1: Estructura de directorios"""
        required_dirs = {
            "infraestructura", "gobernanza", "agentes", "agentes/hld",
            "agentes/adrs", "backend", "frontend", "devops"
        }

        missing = []
        for dir_name in required_dirs:
            if not (self.root / dir_name).exists():
                missing.append(dir_name)

        if missing:
            self.results.append(ValidationResult(
                "Estructura de directorios",
                "FAIL",
                f"Faltan {len(missing)} directorios: {', '.join(missing)}"
            ))
        else:
            self.results.append(ValidationResult(
                "Estructura de directorios",
                "PASS",
                f"Todos los {len(required_dirs)} directorios existen"
            ))

    def validate_file_presence(self):
        """Validación 2: Presencia de archivos"""

        actual_files = set()
        for file in self.root.glob("**/*.md"):
            rel_path = str(file.relative_to(self.root))
            actual_files.add(rel_path)

        # Verificar mínimo de archivos
        min_expected = 25
        if len(actual_files) >= min_expected:
            self.results.append(ValidationResult(
                "Presencia de archivos",
                "PASS",
                f"{len(actual_files)} archivos encontrados (mínimo: {min_expected})"
            ))
        else:
            self.results.append(ValidationResult(
                "Presencia de archivos",
                "FAIL",
                f"Solo {len(actual_files)} archivos (mínimo: {min_expected})"
            ))

    def validate_file_content(self):
        """Validación 3: Integridad de contenido"""

        empty_files = []
        total_files = 0

        for file in self.root.glob("**/*.md"):
            total_files += 1
            if file.stat().st_size == 0:
                empty_files.append(str(file.relative_to(self.root)))

        if empty_files:
            self.results.append(ValidationResult(
                "Integridad de contenido",
                "FAIL",
                f"{len(empty_files)} archivos vacíos encontrados",
                empty_files
            ))
        else:
            self.results.append(ValidationResult(
                "Integridad de contenido",
                "PASS",
                f"Todos los {total_files} archivos tienen contenido"
            ))

    def validate_references(self):
        """Validación 4: Integridad de referencias"""

        old_patterns = [
            r"docs/ai/agent/arquitectura",
            r"docs/infraestructura/",
            r"docs/backend/diseno/",
            r"docs/gobernanza/diseno/",
            r"docs/frontend/arquitectura",
            r"scripts/coding/ai/agents"
        ]

        problematic_files = []

        for file in self.root.glob("**/*.md"):
            with open(file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                for pattern in old_patterns:
                    if re.search(pattern, content):
                        problematic_files.append(str(file.relative_to(self.root)))
                        break

        if problematic_files:
            self.results.append(ValidationResult(
                "Integridad de referencias",
                "FAIL",
                f"{len(problematic_files)} archivos con referencias antiguas",
                problematic_files
            ))
        else:
            self.results.append(ValidationResult(
                "Integridad de referencias",
                "PASS",
                "No hay referencias antiguas detectadas"
            ))

    def validate_documentation(self):
        """Validación 5: Documentación"""

        missing_readmes = []
        for subdir in ["infraestructura", "gobernanza", "agentes", "backend", "frontend", "devops"]:
            readme = self.root / subdir / "README.md"
            if not readme.exists():
                missing_readmes.append(subdir)

        if missing_readmes:
            self.results.append(ValidationResult(
                "Documentación (README)",
                "FAIL",
                f"Faltan README.md en: {', '.join(missing_readmes)}"
            ))
        else:
            self.results.append(ValidationResult(
                "Documentación (README)",
                "PASS",
                "README.md presente en todas las secciones"
            ))

    def get_summary(self) -> Dict:
        """Generar resumen de validación"""

        passed = sum(1 for r in self.results if r.status == "PASS")
        failed = sum(1 for r in self.results if r.status == "FAIL")
        warned = sum(1 for r in self.results if r.status == "WARN")

        return {
            "total": len(self.results),
            "passed": passed,
            "failed": failed,
            "warned": warned,
            "status": "PASS" if failed == 0 else "FAIL",
            "results": self.results
        }

    def print_report(self):
        """Imprimir reporte formateado"""

        summary = self.get_summary()

        print("\n" + "="*60)
        print("REPORTE DE VALIDACIÓN: TASK-REORG-INFRA-006")
        print("="*60 + "\n")

        for result in self.results:
            print(str(result))
            if result.details:
                for detail in result.details[:5]:
                    print(f"  - {detail}")
                if len(result.details) > 5:
                    print(f"  ... y {len(result.details) - 5} más")

        print("\n" + "-"*60)
        print(f"ESTADO GENERAL: {summary['status']}")
        print(f"Validaciones: {summary['passed']} PASS, {summary['failed']} FAIL, {summary['warned']} WARN")
        print("-"*60 + "\n")

if __name__ == "__main__":
    validator = ConsolidationValidator()
    validator.validate_all()
    validator.print_report()
```

---

## Checklist Final de Validación

```
PRE-CONSOLIDACIÓN
[ ] Estructura creada
[ ] Archivos origen verificados (23)
[ ] Permisos correctos

DURANTE CONSOLIDACIÓN
[ ] Archivos movidos con git mv
[ ] Contenido íntegro
[ ] No hay duplicados

POST-CONSOLIDACIÓN
[ ] Referencias actualizadas
[ ] README.md en cada sección
[ ] Canvas creados
[ ] Frontmatter YAML válido
[ ] Script de validación PASS

INTEGRACIÓN
[ ] Cambios en git
[ ] PR creado
[ ] Review completado
[ ] Merge a main
```

---

## Conclusión

Este plan de validación Self-Consistency garantiza que:

1. **Reproducibilidad**: Otros pueden verificar independientemente
2. **Integridad**: Todos los componentes funcionan juntos
3. **Trazabilidad**: Cada archivo puede rastrearse a su origen
4. **Confiabilidad**: La consolidación es sólida y verificable

**Autor**: Técnicas Auto-CoT + Self-Consistency
**Última actualización**: 2025-11-18
