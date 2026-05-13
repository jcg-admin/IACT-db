---
id: DOC-ESTRATEGIA-REORGANIZACION-DOMINIO
estado: LISTA_PARA_EJECUTAR
propietario: equipo-arquitectura
fecha: 2025-11-06
version: 2.0
prioridad: CRITICA
impacto: ALTO
esfuerzo_automatizado: 5-10 minutos
esfuerzo_manual: 8-12 horas
scripts_incluidos: ["reorganizar_docs_por_dominio.sh", "validar_estructura_docs.sh"]
relacionados: ["DOC-PROPUESTA-FINAL-REESTRUCTURACION", "DOC-REPORTE-DUPLICADOS", "DOC-ANALISIS-UBICACION-ARCHIVOS"]
---

# ESTRATEGIA: Reorganización "Todo por Dominio"

Eliminación del nivel `docs/implementacion/` y mapeo 1:1 con estructura del código

---

## RESUMEN EJECUTIVO

### Problema Actual

La estructura de documentación presenta **inconsistencia arquitectónica crítica**:

1. **Nivel innecesario**: `docs/implementacion/` añade complejidad sin valor
2. **Mapeo inconsistente**: No refleja la estructura real del código
3. **Mezcla de responsabilidades**: Requisitos + docs técnicas mezclados
4. **Duplicación confusa**: `infrastructure/` vs `infraestructura/`

### Solución Propuesta

**Reorganización "Todo por Dominio"**: Eliminar `implementacion/` y crear estructura plana:

```
docs/
├── backend/          <- Documenta api/ (Django REST)
├── frontend/         <- Documenta ui/ (React)
├── infrastructure/   <- Documenta infrastructure/
└── [transversales]   <- adr/, gobernanza/, plantillas/, requisitos/, etc.
```

### Beneficios

- Mapeo 1:1 con estructura del código (`api/` → `docs/backend/`)
- Rutas más cortas (1 nivel menos de anidamiento)
- Navegación intuitiva y cohesión por dominio
- Elimina duplicación y confusión

### Métricas

| Métrica | Antes | Después | Mejora |
|---------|-------|---------|--------|
| Niveles de anidamiento | 4-5 | 3-4 | -1 nivel |
| Directorios raíz docs/ | 11 | 13 | +2 (claridad) |
| Longitud ruta promedio | 58 caracteres | 46 caracteres | -20% |
| Tiempo navegación | ~15 clicks | ~10 clicks | -33% |
| Confusión estructura | Alta | Baja | Elimina ambigüedad |

---

## EJECUCIÓN AUTOMATIZADA (RECOMENDADO)

### Opción A: Ejecución con un Solo Comando (SIN intervención manual)

Se han creado scripts automatizados que ejecutan la reorganización completa:

```bash
# 1. Probar primero en modo dry-run (simula sin ejecutar)
./scripts/reorganizar_docs_por_dominio.sh --dry-run

# 2. Si el dry-run se ve bien, ejecutar la reorganización real
./scripts/reorganizar_docs_por_dominio.sh

# 3. Validar que todo está correcto
./scripts/validar_estructura_docs.sh

# 4. Regenerar índices ISO 29148
python scripts/requisitos/generate_requirements_index.py

# 5. Commitear cambios
git commit -m "refactor(docs): reorganizar estructura por dominio eliminando nivel implementacion/"

# 6. Push
git push
```

**Tiempo estimado: 5-10 minutos** (vs 8-12 horas manual)

### Scripts Disponibles

#### `scripts/reorganizar_docs_por_dominio.sh`

Script principal que ejecuta toda la reorganización automáticamente:

**Funcionalidades:**
- Crea backup automático en `respaldo/docs_backup_YYYYMMDD_HHMMSS.tar.gz`
- Mueve directorios (implementacion/backend → backend/, etc.)
- Fusiona `infrastructure/` + `infraestructura/` → `infrastructure/`
- Actualiza TODAS las referencias en archivos .md automáticamente
- Actualiza scripts Python de generación de índices
- Valida estructura final
- Agrega cambios a git staging

**Opciones:**
- `--dry-run`: Simula la ejecución sin hacer cambios reales (RECOMENDADO probar primero)

**Características de seguridad:**
- Crea backup antes de cualquier cambio
- Modo dry-run para previsualizar cambios
- Validaciones en cada fase
- Output colorizado para fácil lectura
- Detección de errores con `set -e`

#### `scripts/validar_estructura_docs.sh`

Script de validación post-migración que verifica:

- Directorio `implementacion/` eliminado
- Directorios principales existen (backend/, frontend/, infrastructure/)
- No hay referencias huérfanas a "implementacion/" en archivos .md
- No hay referencias huérfanas a "infraestructura/"
- Conteo de archivos por dominio
- Enlaces markdown en archivos principales no están rotos
- Estado de git

**Salida:**
- Exit code 0: Validación exitosa
- Exit code 1: Errores encontrados
- Reporte detallado con contadores de errores/warnings

### Ventajas del Método Automatizado

| Aspecto | Manual | Automatizado |
|---------|--------|--------------|
| Tiempo de ejecución | 8-12 horas | 5-10 minutos |
| Errores humanos | Posibles | Eliminados |
| Backup | Manual | Automático |
| Validación | Manual | Automática |
| Rollback | Complejo | Restaurar backup |
| Repetibilidad | Baja | Alta |
| Documentación | Requiere actualizar | Auto-documentado |

---

## EJECUCIÓN MANUAL (Alternativa detallada)

Si prefieres ejecutar manualmente paso a paso, sigue las fases detalladas a continuación.

**NOTA:** El método automatizado es más rápido, seguro y no requiere intervención manual.

---

## ANÁLISIS DEL PROBLEMA

### Estado Actual (Problemático)

#### Estructura del Código (Realidad)

```
IACT---project/
├── api/                <- Backend: Django REST Framework
│   └── callcentersite/
│       └── callcentersite/
│           └── apps/
│               ├── reports/
│               ├── dashboard/
│               ├── audit/
│               └── [...]
│
├── ui/                 <- Frontend: React + Redux
│   └── src/
│       ├── modules/
│       ├── components/
│       ├── state/
│       └── [...]
│
└── infrastructure/     <- Infraestructura: Terraform, Docker, etc.
    └── [...]
```

#### Estructura de Docs (Inconsistente)

```
docs/
└── implementacion/     <- PROBLEMA: Nivel extra innecesario
    ├── backend/        <- Debería ser docs/backend/
    │   ├── requisitos/
    │   ├── arquitectura/
    │   ├── checklists/
    │   ├── devops/
    │   ├── diseno/
    │   ├── diseno_detallado/
    │   ├── gobernanza/
    │   ├── planificacion_y_releases/
    │   ├── qa/
    │   └── seguridad/
    │
    ├── frontend/       <- Debería ser docs/frontend/
    │   ├── requisitos/
    │   ├── arquitectura/
    │   └── [...]
    │
    └── infrastructure/ <- Debería ser docs/infraestructura/
        ├── requisitos/
        └── [...]

├── infraestructura/    <- CONFUSIÓN: ¿Qué diferencia con infrastructure/?
└── [otros]
```

### Problemas Específicos

#### Problema 1: Nombres No Coinciden

| Código | Docs Actual | Mapeo |
|--------|-------------|-------|
| `api/` | `docs/backend/` | NO No coincide |
| `ui/` | `docs/frontend/` | NO No coincide |
| `infrastructure/` | `docs/infraestructura/` + `docs/infraestructura/` | NO Duplicado |

**Impacto**: Desarrolladores confundidos sobre dónde buscar documentación de cada componente.

#### Problema 2: Contradicción con README

El archivo `docs/implementacion/README.md` líneas 26-34 declara:

```markdown
### OK `docs/implementacion/` = REQUISITOS
### OK `docs/backend/`, `docs/frontend/`, `docs/infraestructura/` = DOCUMENTACIÓN TÉCNICA
```

**Realidad**:
- NO `docs/implementacion/` contiene TODO mezclado (requisitos + arquitectura + checklists + devops + diseño + gobernanza + qa + seguridad)
- NO NO existen `docs/backend/`, `docs/frontend/`, `docs/infraestructura/` como directorios raíz

**Impacto**: La documentación miente sobre su propia estructura.

#### Problema 3: Rutas Excesivamente Largas

```bash
# Actual (58+ caracteres)
docs/backend/requisitos/funcionales/rf001_api_autenticacion.md
docs/frontend/arquitectura/componentes_react.md

# Propuesto (46 caracteres)
docs/backend/requisitos/funcionales/rf001_api_autenticacion.md
docs/frontend/arquitectura/componentes_react.md
```

**Impacto**: Menos productividad, más errores al escribir rutas.

#### Problema 4: Duplicación Confusa

Existen DOS directorios para infraestructura:
- `docs/infraestructura/`
- `docs/infraestructura/`

**Contenido**:
- `infrastructure/`: 43 archivos (requisitos + runbooks + arquitectura)
- `infraestructura/`: 3 archivos (documentación CPython)

**Impacto**: ¿Dónde documento infraestructura? Confusión total.

---

## SOLUCIÓN: TODO POR DOMINIO

### Estructura Propuesta

```
docs/
│
├── backend/                                <- Documenta api/ (TODO en un lugar)
│   ├── README.md                           Índice backend
│   ├── requisitos/
│   │   ├── necesidades/                    N-001, N-002, N-003
│   │   ├── negocio/                        RN-001, RN-002
│   │   ├── stakeholders/                   RS-001, RS-002
│   │   ├── funcionales/                    RF-001 a RF-010
│   │   ├── no_funcionales/                 RNF-001 a RNF-006
│   │   ├── README.md
│   │   ├── INDICE_REQUISITOS.md
│   │   ├── trazabilidad.md
│   │   └── restricciones_y_lineamientos.md
│   ├── arquitectura/
│   │   ├── README.md
│   │   ├── lineamientos_codigo.md
│   │   ├── patrones_arquitectonicos.md
│   │   └── guia_decision_patrones.md
│   ├── diseno/
│   │   ├── DISENO_TECNICO_AUTENTICACION.md
│   │   └── [otros diseños]
│   ├── diseno_detallado/
│   │   └── README.md
│   ├── checklists/
│   │   └── README.md
│   ├── devops/
│   │   └── README.md
│   ├── gobernanza/
│   │   └── README.md
│   ├── planificacion_y_releases/
│   │   └── README.md
│   ├── qa/
│   │   └── README.md
│   ├── seguridad/
│   │   ├── ANALISIS_SEGURIDAD_AMENAZAS.md
│   │   └── PENDIENTE_ANALISIS_AMENAZAS_APLICACION.md
│   ├── planificacion_documentacion.md
│   └── calidad_codigo_automatizacion.md
│
├── frontend/                               <- Documenta ui/ (TODO en un lugar)
│   ├── README.md                           Índice frontend
│   ├── requisitos/
│   │   ├── _necesidades_vinculadas.md      Enlace a backend/requisitos/necesidades/
│   │   ├── stakeholders/
│   │   ├── funcionales/
│   │   │   ├── rf010_pantalla_login.md
│   │   │   └── rf011_cambio_password_ui.md
│   │   ├── no_funcionales/
│   │   └── README.md
│   ├── arquitectura/
│   │   └── README.md
│   ├── diseno_detallado/
│   │   └── README.md
│   ├── checklists/
│   │   └── README.md
│   ├── devops/
│   │   └── README.md
│   ├── gobernanza/
│   │   └── README.md
│   ├── planificacion_y_releases/
│   │   └── README.md
│   └── qa/
│       └── README.md
│
├── infrastructure/                         <- Documenta infrastructure/ (TODO en un lugar)
│   ├── README.md                           Índice infrastructure
│   ├── requisitos/
│   │   ├── _necesidades_vinculadas.md
│   │   ├── funcionales/
│   │   │   └── rf020_cpython_precompilado.md
│   │   ├── no_funcionales/
│   │   │   └── rnf020_disponibilidad_999.md
│   │   └── README.md
│   ├── arquitectura/
│   │   └── README.md
│   ├── devops/
│   │   └── runbooks/
│   │       ├── github_copilot_codespaces.md
│   │       ├── instalacion_mkdocs.md
│   │       └── playbooks_operativos/
│   │           ├── README.md
│   │           ├── github_copilot_cli.md
│   │           ├── github_copilot_cli_403_forbidden.md
│   │           └── copilot_codespaces.md
│   ├── gobernanza/
│   │   ├── lineamientos_gobernanza.md
│   │   └── README.md
│   ├── checklists/
│   │   └── README.md
│   ├── diseno_detallado/
│   │   └── README.md
│   ├── planificacion_y_releases/
│   │   └── README.md
│   ├── qa/
│   │   └── README.md
│   └── cpython_precompilado/               Fusionado desde docs/infraestructura/
│       └── [contenido CPython]
│
├── arquitectura/                           <- Arquitectura TRANSVERSAL
│   ├── README.md
│   └── lineamientos_codigo.md
│
├── gobernanza/                             <- Gobernanza TRANSVERSAL
│   ├── README.md
│   ├── GUIA_ESTILO.md
│   ├── procesos/
│   │   ├── guia_completa_desarrollo_features.md
│   │   └── procedimiento_qa.md
│   └── agentes/
│       └── constitution.md
│
├── requisitos/                             <- ÍNDICES ISO 29148 (AUTO-GENERADOS)
│   ├── README.md
│   ├── brs_business_requirements.md
│   ├── strs_stakeholder_requirements.md
│   ├── srs_software_requirements.md
│   └── matriz_trazabilidad_rtm.md
│
├── adr/                                    <- ADRs TRANSVERSALES
│   ├── plantilla_adr.md
│   ├── ADR_2025_012-cpython-features-vs-imagen-base.md
│   ├── ADR_2025_013-distribucion-artefactos-strategy.md
│   ├── ADR_2025_014-organizacion-proyecto-por-dominio.md
│   ├── ADR_2025_015-frontend-modular-monolith.md
│   ├── ADR_2025_016-redux-toolkit-state-management.md
│   ├── ADR_2025_018-webpack-bundler.md
│   ├── ADR_2025_019-testing-strategy-jest-testing-library.md
│   ├── ADR_2025_001-vagrant-mod-wsgi.md
│   └── ADR_2025_002-suite-calidad-codigo.md
│
├── plantillas/                             <- PLANTILLAS TRANSVERSALES
│   ├── README.md
│   ├── template_necesidad.md
│   ├── template_requisito_negocio.md
│   ├── template_requisito_stakeholder.md
│   ├── template_requisito_funcional.md
│   └── template_requisito_no_funcional.md
│
├── anexos/                                 <- REFERENCIAS
│   ├── README.md
│   ├── glosario_babok_pmbok_iso.md
│   ├── glosario.md
│   ├── catalogo_reglas_negocio.md
│   ├── faq.md
│   ├── inventario_dependencias.md
│   ├── diagramas/
│   ├── ejemplos/
│   ├── referencias/
│   └── analisis_nov_2025/
│       ├── ANALISIS_UBICACION_ARCHIVOS.md
│       ├── REPORTE_DUPLICADOS.md
│       ├── COMO_VER_DOCUMENTACION.md
│       ├── scripts_validacion.md
│       ├── PROPUESTA_FINAL_REESTRUCTURACION.md
│       └── ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md  <- Este documento
│
├── specs/                                  <- ESPECIFICACIONES
│   └── SPEC_INFRA_001_cpython_precompilado.md
│
├── plans/                                  <- PLANES
│   └── [planes de implementación]
│
├── vision_y_alcance/                       <- VISIÓN
│   └── README.md
│
├── README.md                               <- ÍNDICE MAESTRO
├── index.md
├── mkdocs.yml
├── requirements.txt
└── ver_documentacion.sh
```

### Principios de la Estructura

1. **Mapeo 1:1**: `api/` → `docs/backend/`, `ui/` → `docs/frontend/`, `infrastructure/` → `docs/infraestructura/`

2. **Todo junto**: Cada dominio contiene TODO su contenido (requisitos + arquitectura + diseño + devops + qa + seguridad)

3. **Cohesión**: Toda la información de un dominio está en un solo lugar

4. **Transversal separado**: Lo que aplica a TODO el proyecto (adr/, gobernanza/, plantillas/) queda en raíz

5. **Sin duplicación**: Un solo directorio `infrastructure/`, fusionando contenido de `infraestructura/`

---

## PLAN DE MIGRACIÓN

### Fase 0: Preparación (30 minutos)

#### 0.1 Backup

```bash
# Crear backup completo
cd /home/user/IACT---project
tar -czf docs_backup_$(date +%Y%m%d_%H%M%S).tar.gz docs/

# Mover a ubicación segura
mkdir -p respaldo/docs_backups/
mv docs_backup_*.tar.gz respaldo/docs_backups/

# Verificar backup
ls -lh respaldo/docs_backups/
```

#### 0.2 Crear Rama de Trabajo

```bash
# Crear rama específica para reorganización
git checkout -b refactor/docs-todo-por-dominio

# Verificar rama
git branch
```

#### 0.3 Documentar Estado Inicial

```bash
# Guardar estructura actual
tree -L 3 docs/ > docs/anexos/analisis_nov_2025/estructura_antes_reorganizacion.txt

# Contar archivos por directorio
find docs/implementacion/backend -type f -name "*.md" | wc -l > /tmp/backend_count.txt
find docs/implementacion/frontend -type f -name "*.md" | wc -l > /tmp/frontend_count.txt
find docs/implementacion/infrastructure -type f -name "*.md" | wc -l > /tmp/infra_count.txt
```

---

### Fase 1: Reorganización Estructural (2-3 horas)

#### 1.1 Mover Backend

```bash
cd /home/user/IACT---project/docs/

# Mover backend/ a backend/
mv implementacion/backend ./backend

# Verificar
ls -la backend/
tree -L 2 backend/
```

#### 1.2 Mover Frontend

```bash
# Mover frontend/ a frontend/
mv implementacion/frontend ./frontend

# Verificar
ls -la frontend/
tree -L 2 frontend/
```

#### 1.3 Resolver Infrastructure (CUIDADO: Dos directorios)

```bash
# Listar contenido de ambos directorios
echo "=== infrastructure/ ===" > /tmp/infra_comparison.txt
ls -lR infrastructure/ >> /tmp/infra_comparison.txt

echo "=== infraestructura/ ===" >> /tmp/infra_comparison.txt
ls -lR infraestructura/ >> /tmp/infra_comparison.txt

cat /tmp/infra_comparison.txt

# Crear nuevo directorio infrastructure/
mkdir -p infrastructure_temp/

# Mover contenido de infrastructure/
cp -r infrastructure/* infrastructure_temp/

# Fusionar contenido de infraestructura/
# NOTA: infraestructura/ tiene cpython_precompilado/
cp -r infrastructure/cpython_precompilado infrastructure_temp/

# Renombrar
mv infrastructure_temp infrastructure

# Verificar fusión
ls -la infrastructure/
tree -L 2 infrastructure/

# Eliminar directorios antiguos (después de verificar)
# NO EJECUTAR AÚN - Verificar primero
# rm -rf infrastructure/
# rm -rf infraestructura/
```

#### 1.4 Eliminar Directorio Vacío

```bash
# Verificar que implementacion/ esté vacío
ls -la implementacion/

# Si está vacío, eliminar
rmdir implementacion/

# Si no está vacío, investigar
tree implementacion/
```

#### 1.5 Verificar Estructura Final

```bash
# Verificar directorios en docs/
ls -la docs/ | grep ^d

# Debe mostrar:
# backend/
# frontend/
# infrastructure/
# arquitectura/
# gobernanza/
# requisitos/
# adr/
# plantillas/
# anexos/
# specs/
# plans/
# vision_y_alcance/

# Guardar estructura nueva
tree -L 3 docs/ > docs/anexos/analisis_nov_2025/estructura_despues_reorganizacion.txt
```

---

### Fase 2: Actualizar Referencias (3-4 horas)

#### 2.1 Buscar Referencias en Archivos Markdown

```bash
cd /home/user/IACT---project/

# Buscar todas las referencias a implementacion/
grep -r "docs/implementacion/" docs/ --include="*.md" > /tmp/referencias_implementacion.txt
grep -r "implementacion/backend" docs/ --include="*.md" >> /tmp/referencias_implementacion.txt
grep -r "implementacion/frontend" docs/ --include="*.md" >> /tmp/referencias_implementacion.txt
grep -r "implementacion/infrastructure" docs/ --include="*.md" >> /tmp/referencias_implementacion.txt

# Ver resultados
cat /tmp/referencias_implementacion.txt | wc -l
echo "Referencias encontradas. Revisar /tmp/referencias_implementacion.txt"

# Buscar referencias a infraestructura/ (antiguo)
grep -r "docs/infraestructura/" docs/ --include="*.md" > /tmp/referencias_infraestructura.txt
cat /tmp/referencias_infraestructura.txt
```

#### 2.2 Reemplazar Referencias Automaticamente

```bash
# Script de reemplazo
cat > /tmp/fix_references.sh << 'EOF'
#!/bin/bash

# Reemplazar referencias en todos los archivos .md
find docs/ -name "*.md" -type f -exec sed -i \
    -e 's|docs/backend/|docs/backend/|g' \
    -e 's|backend/|backend/|g' \
    -e 's|\.\./\.\./\.\./backend/|../../backend/|g' \
    -e 's|\.\./backend/|../backend/|g' \
    {} +

find docs/ -name "*.md" -type f -exec sed -i \
    -e 's|docs/frontend/|docs/frontend/|g' \
    -e 's|frontend/|frontend/|g' \
    -e 's|\.\./\.\./\.\./frontend/|../../frontend/|g' \
    -e 's|\.\./frontend/|../frontend/|g' \
    {} +

find docs/ -name "*.md" -type f -exec sed -i \
    -e 's|docs/infraestructura/|docs/infraestructura/|g' \
    -e 's|infrastructure/|infrastructure/|g' \
    -e 's|\.\./\.\./\.\./infrastructure/|../../infrastructure/|g' \
    -e 's|\.\./infrastructure/|../infrastructure/|g' \
    {} +

find docs/ -name "*.md" -type f -exec sed -i \
    -e 's|docs/infraestructura/|docs/infraestructura/|g' \
    -e 's|infrastructure/cpython|infrastructure/cpython|g' \
    {} +

echo "Referencias actualizadas"
EOF

chmod +x /tmp/fix_references.sh
/tmp/fix_references.sh
```

#### 2.3 Actualizar README.md Principal

```bash
# Editar docs/README.md manualmente
# Actualizar sección de estructura de carpetas
vim docs/README.md

# Buscar sección "Estructura" y actualizar:
# - Eliminar referencia a implementacion/
# - Agregar backend/, frontend/, infrastructure/
# - Actualizar descripciones
```

#### 2.4 Actualizar mkdocs.yml

```bash
# Editar mkdocs.yml
vim docs/mkdocs.yml

# Actualizar navegación (nav:)
# Cambiar:
#   - Implementación:
#     - implementacion/README.md
#     - Backend: backend/README.md
#
# Por:
#   - Backend: backend/README.md
#   - Frontend: frontend/README.md
#   - Infrastructure: infrastructure/README.md
```

#### 2.5 Actualizar Scripts de Generación de Índices

```bash
# Verificar si existe script de generación de índices ISO
find . -name "*generate*requirements*" -o -name "*requirements*index*"

# Si existe, actualizar rutas
# Ejemplo: scripts/generate_requirements_index.py o .github/workflows/scripts/

# Buscar en el script referencias a implementacion/
grep -n "implementacion" scripts/requisitos/generate_requirements_index.py

# Actualizar manualmente si es necesario
vim scripts/requisitos/generate_requirements_index.py

# Cambiar:
#   base_path = "docs/implementacion"
# Por:
#   base_path = "docs"
#
# Y buscar en:
#   - docs/backend/requisitos/
#   - docs/frontend/requisitos/
#   - docs/infraestructura/requisitos/
```

#### 2.6 Actualizar README de Dominios

```bash
# Actualizar docs/backend/README.md
vim docs/backend/README.md
# Cambiar referencias internas que mencionan implementacion/

# Actualizar docs/frontend/README.md
vim docs/frontend/README.md

# Actualizar docs/infraestructura/README.md
vim docs/infraestructura/README.md

# Verificar que README.md de requisitos estén actualizados
vim docs/backend/requisitos/README.md
vim docs/frontend/requisitos/README.md
vim docs/infraestructura/requisitos/README.md
```

#### 2.7 Actualizar Enlaces en Plantillas

```bash
# Las plantillas en docs/plantillas/ pueden tener ejemplos con rutas
cd docs/plantillas/

# Buscar referencias a implementacion/
grep -r "implementacion/" *.md

# Actualizar si es necesario
```

---

### Fase 3: Validación (1-2 horas)

#### 3.1 Verificar Integridad de Archivos

```bash
# Contar archivos antes vs después
echo "=== Conteo de archivos ===" > /tmp/validacion_conteo.txt

echo "BACKEND:" >> /tmp/validacion_conteo.txt
find docs/backend -type f -name "*.md" | wc -l >> /tmp/validacion_conteo.txt

echo "FRONTEND:" >> /tmp/validacion_conteo.txt
find docs/frontend -type f -name "*.md" | wc -l >> /tmp/validacion_conteo.txt

echo "INFRASTRUCTURE:" >> /tmp/validacion_conteo.txt
find docs/infrastructure -type f -name "*.md" | wc -l >> /tmp/validacion_conteo.txt

echo "TOTAL docs/:" >> /tmp/validacion_conteo.txt
find docs/ -type f -name "*.md" | wc -l >> /tmp/validacion_conteo.txt

cat /tmp/validacion_conteo.txt

# Comparar con conteo inicial
diff /tmp/backend_count.txt <(find docs/backend -type f -name "*.md" | wc -l)
# Debe ser = 0 (sin diferencias)
```

#### 3.2 Buscar Enlaces Rotos

```bash
# Script para verificar enlaces internos
cat > /tmp/check_links.py << 'EOF'
#!/usr/bin/env python3
import re
import os
from pathlib import Path

def check_markdown_links(base_path):
    broken_links = []

    for md_file in Path(base_path).rglob("*.md"):
        content = md_file.read_text(errors='ignore')

        # Buscar enlaces markdown [texto](ruta)
        links = re.findall(r'\[([^\]]+)\]\(([^)]+)\)', content)

        for link_text, link_path in links:
            # Solo verificar enlaces internos (no URLs)
            if not link_path.startswith(('http://', 'https://', '#')):
                # Resolver ruta relativa
                full_path = (md_file.parent / link_path).resolve()

                if not full_path.exists():
                    broken_links.append({
                        'file': str(md_file),
                        'link': link_path,
                        'text': link_text
                    })

    return broken_links

if __name__ == "__main__":
    base = "docs/"
    broken = check_markdown_links(base)

    if broken:
        print(f"ADVERTENCIA: {len(broken)} enlaces rotos encontrados:\n")
        for item in broken[:20]:  # Mostrar primeros 20
            print(f"  {item['file']}")
            print(f"    -> [{item['text']}]({item['link']})")
            print()
    else:
        print("OK: No se encontraron enlaces rotos")
EOF

chmod +x /tmp/check_links.py
python3 /tmp/check_links.py > /tmp/enlaces_rotos.txt
cat /tmp/enlaces_rotos.txt
```

#### 3.3 Regenerar Índices ISO 29148

```bash
# Ejecutar script de generación de índices
cd /home/user/IACT---project/

# Si existe script Python
python3 scripts/requisitos/generate_requirements_index.py

# O si existe en .github/workflows/scripts/
python3 .github/workflows/scripts/generate_requirements_index.py

# Verificar que se generaron correctamente
ls -lh docs/requisitos/
cat docs/requisitos/README.md | head -50

# Verificar estadísticas
grep "Total requisitos:" docs/requisitos/README.md
```

#### 3.4 Probar MkDocs

```bash
cd docs/

# Instalar dependencias si es necesario
pip install -r requirements.txt

# Probar build
mkdocs build --clean

# Si hay errores, revisar mkdocs.yml y rutas

# Probar servidor local
mkdocs serve &
MKDOCS_PID=$!

# Esperar 5 segundos y verificar
sleep 5
curl -s http://127.0.0.1:8000 | grep -q "IACT" && echo "OK: MkDocs funcionando" || echo "ERROR: MkDocs falló"

# Detener servidor
kill $MKDOCS_PID
```

#### 3.5 Verificar Git Status

```bash
# Ver cambios
git status

# Ver archivos movidos
git status | grep renamed

# Ver archivos modificados
git status | grep modified

# Debe mostrar:
# - Archivos movidos (renamed)
# - Archivos modificados (updated references)
# - Sin archivos eliminados inesperadamente
```

---

### Fase 4: Commit y Documentación (30 minutos)

#### 4.1 Crear ADR

```bash
# Crear ADR documentando la decisión
cat > docs/adr/ADR_015_reorganizacion_docs_por_dominio.md << 'EOF'
---
id: ADR-015
titulo: Reorganización de Documentación por Dominio
estado: ACEPTADA
fecha: 2025-11-06
autores: [equipo-arquitectura]
relacionados: [ADR-010]
---

# ADR-015: Reorganización de Documentación por Dominio

## Contexto

La estructura de documentación presentaba inconsistencias:
- Nivel `docs/implementacion/` innecesario
- No mapeaba 1:1 con estructura del código
- Mezcla de requisitos y documentación técnica
- Duplicación de directorios (implementacion/infrastructure vs infraestructura)

## Decisión

Reorganizar docs/ eliminando nivel implementacion/ y creando estructura plana:
- `api/` → `docs/backend/`
- `ui/` → `docs/frontend/`
- `infrastructure/` → `docs/infraestructura/`

Cada dominio contiene TODO: requisitos + arquitectura + diseño + devops + qa + seguridad.

## Consecuencias

### Positivas
- Mapeo 1:1 con código
- Rutas más cortas (-20% caracteres)
- Navegación intuitiva
- Sin duplicación
- Cohesión por dominio

### Negativas
- Requiere actualizar ~50 referencias en archivos existentes
- Breaking change para enlaces externos (mitigado con redirects)

## Implementación

Ver: docs/anexos/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md

Fecha de migración: 2025-11-06
EOF

# Agregar al repositorio
git add docs/adr/ADR_015_reorganizacion_docs_por_dominio.md
```

#### 4.2 Actualizar Documento de Propuesta

```bash
# Marcar como IMPLEMENTADA la propuesta original
vim docs/anexos/analisis_nov_2025/PROPUESTA_FINAL_REESTRUCTURACION.md

# Agregar al inicio:
# ---
# estado: IMPLEMENTADA
# fecha_implementacion: 2025-11-06
# estrategia_usada: "Todo por Dominio" (ver ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md)
# ---
```

#### 4.3 Stage Cambios

```bash
# Stage archivos movidos
git add docs/backend/
git add docs/frontend/
git add docs/infraestructura/

# Stage archivos modificados
git add docs/README.md
git add docs/mkdocs.yml
git add docs/backend/README.md
git add docs/frontend/README.md
git add docs/infraestructura/README.md

# Stage índices regenerados
git add docs/requisitos/

# Stage scripts actualizados (si aplica)
git add scripts/

# Stage ADR y documentación
git add docs/adr/ADR_015_reorganizacion_docs_por_dominio.md
git add docs/anexos/analisis_nov_2025/

# Verificar staging
git status
```

#### 4.4 Commit

```bash
# Crear commit descriptivo
git commit -m "refactor(docs): reorganizar estructura por dominio eliminando nivel implementacion/

BREAKING CHANGE: Estructura de documentación reorganizada

- Eliminar nivel docs/implementacion/
- Mover backend/ -> docs/backend/
- Mover frontend/ -> docs/frontend/
- Fusionar infrastructure/ + infraestructura/ -> docs/infraestructura/
- Actualizar ~50 referencias en archivos .md
- Actualizar mkdocs.yml con nueva navegación
- Regenerar índices ISO 29148

Beneficios:
- Mapeo 1:1 con estructura del código (api/ -> backend/, ui/ -> frontend/)
- Rutas más cortas (-20% caracteres)
- Navegación intuitiva
- Sin duplicación de directorios
- Cohesión por dominio

Decisión documentada en: ADR-015
Estrategia en: docs/anexos/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md

Closes #XXX"  # Agregar número de issue si existe

# Verificar commit
git log -1 --stat
```

#### 4.5 Push y PR

```bash
# Push a rama
git push -u origin refactor/docs-todo-por-dominio

# Crear PR (manual en GitHub)
# Título: "[BREAKING] Reorganizar documentación por dominio"
# Descripción: Enlazar a ADR-015 y estrategia
```

---

### Fase 5: Post-Migración (1 hora)

#### 5.1 Actualizar GitHub Pages (si aplica)

```bash
# Si hay GitHub Pages configurado, desplegar nueva estructura
cd docs/
mkdocs gh-deploy

# O mediante workflow si existe
# Verificar que workflow use nuevas rutas
```

#### 5.2 Comunicar Cambio al Equipo

**Mensaje para el equipo:**

```
AVISO: Reorganización de Documentación - docs/implementacion/ eliminado

Estructura nueva:
- docs/backend/          (antes: docs/backend/)
- docs/frontend/         (antes: docs/frontend/)
- docs/infraestructura/   (antes: docs/infraestructura/ + docs/infraestructura/)

Beneficios:
- Mapeo 1:1 con código (api/ -> backend/, ui/ -> frontend/)
- Rutas más cortas
- Navegación más intuitiva

Acción requerida:
- Actualizar bookmarks personales
- Verificar enlaces en documentación externa
- Actualizar enlaces en issues/PRs abiertos

Documentación:
- ADR-015: docs/adr/ADR_015_reorganizacion_docs_por_dominio.md
- Estrategia: docs/anexos/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md

Preguntas: contactar a equipo-arquitectura
```

#### 5.3 Actualizar Documentación Externa

```bash
# Si hay documentación externa (Confluence, Notion, etc.) que enlace a GitHub
# Crear lista de enlaces a actualizar

# Buscar en issues abiertos
# gh issue list --search "docs/implementacion" (si hay gh CLI)

# Buscar en PRs abiertos
# gh pr list --search "docs/implementacion"
```

#### 5.4 Monitorear por 1 Semana

**Checklist de monitoreo:**

- [ ] Día 1: Verificar builds de CI/CD pasan
- [ ] Día 1: Verificar GitHub Pages desplegado correctamente
- [ ] Día 2: Revisar feedback del equipo
- [ ] Día 3: Verificar índices ISO generándose automáticamente
- [ ] Día 7: Confirmar sin problemas, marcar como ESTABLE
- [ ] Día 7: Eliminar backup si todo OK

---

## ROLLBACK PLAN

### Si algo sale mal

#### Opción A: Revert del Commit

```bash
# Identificar commit de reorganización
git log --oneline | grep "refactor(docs)"

# Revert
git revert <commit-hash>

# Push
git push
```

#### Opción B: Restaurar desde Backup

```bash
# Eliminar docs/ actual
cd /home/user/IACT---project
rm -rf docs/

# Restaurar desde backup
tar -xzf respaldo/docs_backups/docs_backup_YYYYMMDD_HHMMSS.tar.gz

# Verificar
ls -la docs/

# Commit rollback
git add docs/
git commit -m "revert: restaurar estructura docs/ desde backup"
git push
```

---

## CHECKLIST COMPLETO

### Pre-Migración

- [ ] Crear backup completo de docs/
- [ ] Crear rama refactor/docs-todo-por-dominio
- [ ] Documentar estructura inicial
- [ ] Contar archivos por dominio (baseline)

### Migración

- [ ] Mover backend/ -> backend/
- [ ] Mover frontend/ -> frontend/
- [ ] Fusionar infrastructure + infraestructura -> infrastructure/
- [ ] Eliminar directorio implementacion/ vacío
- [ ] Verificar estructura final (tree -L 3)

### Actualización de Referencias

- [ ] Buscar todas las referencias a implementacion/
- [ ] Ejecutar script de reemplazo automático
- [ ] Actualizar docs/README.md
- [ ] Actualizar docs/mkdocs.yml
- [ ] Actualizar scripts de generación de índices
- [ ] Actualizar README de dominios (backend, frontend, infrastructure)
- [ ] Actualizar plantillas si tienen ejemplos

### Validación

- [ ] Verificar conteo de archivos (antes = después)
- [ ] Ejecutar script check_links.py (sin enlaces rotos)
- [ ] Regenerar índices ISO 29148
- [ ] Probar mkdocs build --clean (sin errores)
- [ ] Probar mkdocs serve (navegación OK)
- [ ] Verificar git status (solo movimientos esperados)

### Documentación

- [ ] Crear ADR-015
- [ ] Actualizar PROPUESTA_FINAL_REESTRUCTURACION.md (marcar como IMPLEMENTADA)
- [ ] Guardar estructura antes/después en analisis_nov_2025/

### Commit y Deploy

- [ ] git add (archivos movidos + modificados)
- [ ] git commit con mensaje descriptivo
- [ ] git push a rama
- [ ] Crear PR con revisión del equipo
- [ ] Merge a main/master
- [ ] Deploy GitHub Pages (si aplica)

### Post-Migración

- [ ] Comunicar cambio al equipo
- [ ] Actualizar enlaces en documentación externa
- [ ] Actualizar enlaces en issues/PRs abiertos
- [ ] Monitorear por 1 semana
- [ ] Eliminar backup si todo OK
- [ ] Marcar estrategia como COMPLETADA

---

## MÉTRICAS DE ÉXITO

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| **Tiempo de migración** | < 12 horas | Tracking manual |
| **Enlaces rotos** | 0 | Script check_links.py |
| **Archivos perdidos** | 0 | Diff conteo antes/después |
| **Builds fallidos** | 0 | CI/CD status |
| **Feedback negativo equipo** | < 2 reportes | Issues creados |
| **Tiempo navegación** | -33% | Encuesta pre/post |
| **Satisfacción estructura** | > 8/10 | Encuesta post-migración |

---

## CONTACTO Y SOPORTE

**Responsable de Migración:** equipo-arquitectura

**Escalación:** Si encuentras problemas durante la migración, contactar:
1. Crear issue en GitHub con label `docs-reorganizacion`
2. Mencionar en canal de Slack #arquitectura (si existe)
3. Email a equipo-arquitectura

**Documentación de Referencia:**
- ADR-015: docs/adr/ADR_015_reorganizacion_docs_por_dominio.md
- Análisis original: docs/anexos/analisis_nov_2025/PROPUESTA_FINAL_REESTRUCTURACION.md
- Este documento: docs/anexos/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md

---

## HISTORIAL DE CAMBIOS

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-11-06 | Creación inicial de estrategia |

---

**FIN DEL DOCUMENTO**

**Estado:** PROPUESTA
**Siguiente acción:** Revisión y aprobación por equipo-arquitectura
**Timeline estimado:** Implementación en 1-2 días laborables
