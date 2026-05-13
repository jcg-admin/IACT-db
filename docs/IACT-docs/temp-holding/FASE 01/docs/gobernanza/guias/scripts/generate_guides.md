---
title: Script: generate_guides.py
date: 2025-11-13
domain: general
status: active
---

# Script: generate_guides.py

**Ubicacion:** `scripts/generate_guides.py`
**Proposito:** Generar guias operativas automaticamente desde templates
**Ownership:** Tech Lead, Doc Lead
**Prioridad:** P1 (ALTO - Automatizacion de documentacion)

## Descripcion

Script Python que genera automaticamente guias operativas completas basandose en templates predefinidos y metadata estructurada. Acelera la creacion de documentacion consistente y de alta calidad.

## Uso

### Sintaxis Basica

```bash
# Generar guias P0 (onboarding prioritario)
python scripts/generate_guides.py --priority P0

# Generar guias de categoria especifica
python scripts/generate_guides.py --category onboarding

# Generar todas las guias
python scripts/generate_guides.py --priority all

# Dry-run (simular sin escribir archivos)
python scripts/generate_guides.py --priority P0 --dry-run

# Ver reporte de coverage
python scripts/generate_guides.py --report
```

## Argumentos

| Argumento | Opciones | Default | Descripcion |
|-----------|----------|---------|-------------|
| --priority | P0, P1, P2, P3, all | P0 | Prioridad de guias a generar |
| --category | onboarding, workflows, testing, deployment, troubleshooting, all | - | Categoria especifica |
| --dry-run | - | False | Simular sin escribir archivos |
| --report | - | False | Generar solo reporte de coverage |

## Categorias de Guias

### 1. Onboarding (7 guias P0)

Guias para nuevos desarrolladores:
- `GUIA-ONBOARDING-001`: Configurar Entorno de Desarrollo Local
- `GUIA-ONBOARDING-002`: Ejecutar Proyecto Localmente
- `GUIA-ONBOARDING-003`: Estructura del Proyecto IACT
- `GUIA-ONBOARDING-004`: Configurar Variables de Entorno
- `GUIA-ONBOARDING-005`: Usar Agentes SDLC - Planning
- `GUIA-ONBOARDING-006`: Validar Documentacion
- `GUIA-ONBOARDING-007`: Generar Indices de Requisitos

### 2. Workflows (4 guias P0)

Flujos de trabajo Git y CI/CD:
- `GUIA-WORKFLOWS-001`: Crear Feature Branch
- `GUIA-WORKFLOWS-002`: Hacer Commits Convencionales
- `GUIA-WORKFLOWS-003`: Crear Pull Request
- `GUIA-WORKFLOWS-004`: Interpretar Resultados de CI/CD

### 3. Testing (3 guias P0)

Ejecucion y validacion de tests:
- `GUIA-TESTING-001`: Ejecutar Tests Backend Localmente
- `GUIA-TESTING-002`: Ejecutar Tests Frontend Localmente
- `GUIA-TESTING-003`: Validar Test Pyramid

### 4. Deployment (2 guias P0)

Deployment y validaciones:
- `GUIA-DEPLOYMENT-001`: Workflow de Deployment
- `GUIA-DEPLOYMENT-002`: Validar Restricciones Criticas

### 5. Troubleshooting (1 guia P0)

Solucion de problemas comunes:
- `GUIA-TROUBLESHOOTING-001`: Problemas Comunes de Setup

**Total P0:** 20 guias criticas para onboarding

## Estructura de Metadata

Cada guia se define con:

```python
GuideMetadata(
    id="GUIA-CATEGORY-###",
    titulo="Titulo Descriptivo",
    categoria="onboarding|workflows|testing|deployment|troubleshooting",
    audiencia="desarrollador-nuevo|desarrollador|tech-lead",
    prioridad="P0|P1|P2|P3",
    tiempo_lectura=10,  # minutos
    descripcion="Breve descripcion de la guia",
    pasos=[
        {
            "titulo": "Paso 1",
            "descripcion": "Que hacer",
            "comando": "comando shell",
            "output": "output esperado"
        }
    ],
    prerequisitos=["Pre-requisito 1", "Pre-requisito 2"],
    validaciones=["Validacion 1", "Validacion 2"],
    troubleshooting=[
        {
            "titulo": "Error Comun",
            "sintomas": "Como se ve el error",
            "causa": "Por que ocurre",
            "solucion": "Como resolverlo"
        }
    ],
    proximos_pasos=["Siguiente guia", "Otra accion"],
    referencias={
        "Documentacion": "path/to/doc.md",
        "Script": "path/to/script.sh"
    },
    mantenedores=["tech-lead", "devops-lead"]
)
```

## Template de Guia

El script usa `docs/plantillas/guia-template.md` que contiene:

```markdown
# {TITULO}

**Categoria:** {CATEGORIA}
**Audiencia:** {AUDIENCIA}
**Prioridad:** {PRIORIDAD}
**Tiempo de lectura:** {MINUTOS} minutos
**Fecha:** {FECHA}

## Descripcion

{DESCRIPCION_BREVE}

## Pre-requisitos

{PREREQUISITOS}

## Pasos

{PASOS_DETALLADOS}

## Validaciones

{VALIDACIONES}

## Troubleshooting

{TROUBLESHOOTING}

## Proximos Pasos

{PROXIMOS_PASOS}

## Referencias

{REFERENCIAS}

## Ownership

**Mantenedores:** {MANTENEDORES}
```

## Output

### Generacion Exitosa

```
================================================================================
GENERANDO GUIAS P0 DE ONBOARDING
================================================================================

Generada: docs/guias/onboarding/configurar_entorno_desarrollo_local.md
Generada: docs/guias/onboarding/ejecutar_proyecto_localmente.md
Generada: docs/guias/onboarding/estructura_proyecto_iact.md
Generada: docs/guias/workflows/crear_feature_branch.md
Generada: docs/guias/workflows/hacer_commits_convencionales.md
Generada: docs/guias/workflows/crear_pull_request.md
Generada: docs/guias/workflows/interpretar_resultados_cicd.md
Generada: docs/guias/testing/ejecutar_tests_backend_localmente.md
Generada: docs/guias/testing/ejecutar_tests_frontend_localmente.md
Generada: docs/guias/testing/validar_test_pyramid.md
Generada: docs/guias/deployment/workflow_deployment.md
Generada: docs/guias/deployment/validar_restricciones_criticas.md
Generada: docs/guias/troubleshooting/problemas_comunes_setup.md

================================================================================
RESUMEN DE GENERACION
================================================================================

Guias generadas: 20/20
Completitud: 100%
Guias omitidas: 0

Guias creadas en:
  - docs/guias/onboarding/configurar_entorno_desarrollo_local.md
  - docs/guias/onboarding/ejecutar_proyecto_localmente.md
  - docs/guias/onboarding/estructura_proyecto_iact.md
  - docs/guias/workflows/crear_feature_branch.md
  - docs/guias/workflows/hacer_commits_convencionales.md
  ... y 15 mas

================================================================================
```

### Modo Dry-Run

```bash
python scripts/generate_guides.py --priority P0 --dry-run
```

Output:
```
[DRY-RUN] Guardaria guia en: docs/guias/onboarding/configurar_entorno_desarrollo_local.md
[DRY-RUN] Guardaria guia en: docs/guias/onboarding/ejecutar_proyecto_localmente.md
...

Guias generadas: 20/20
Completitud: 100%
```

### Reporte de Coverage

```bash
python scripts/generate_guides.py --report
```

Output:
```json
{
  "timestamp": "2025-11-07T10:30:00Z",
  "guides_generated": 20,
  "guides_skipped": 0,
  "total_planned": 147,
  "p0_completed": 20,
  "p0_target": 20,
  "completion_percentage": 100.0
}
```

## Directorio de Salida

Guias generadas en:
```
docs/guias/
├── onboarding/
│   ├── configurar_entorno_desarrollo_local.md
│   ├── ejecutar_proyecto_localmente.md
│   ├── estructura_proyecto_iact.md
│   ├── configurar_variables_entorno.md
│   ├── usar_agentes_sdlc_planning.md
│   ├── validar_documentacion.md
│   └── generar_indices_requisitos.md
├── workflows/
│   ├── crear_feature_branch.md
│   ├── hacer_commits_convencionales.md
│   ├── crear_pull_request.md
│   └── interpretar_resultados_cicd.md
├── testing/
│   ├── ejecutar_tests_backend_localmente.md
│   ├── ejecutar_tests_frontend_localmente.md
│   └── validar_test_pyramid.md
├── deployment/
│   ├── workflow_deployment.md
│   └── validar_restricciones_criticas.md
└── troubleshooting/
    └── problemas_comunes_setup.md
```

## Troubleshooting

### Template no encontrado

**Error:**
```
FileNotFoundError: Template no encontrado: docs/plantillas/guia-template.md
```

**Causa:** Template de guia no existe

**Solucion:**
```bash
# Verificar que template existe:
ls docs/plantillas/guia-template.md

# Si no existe, crear desde ejemplo:
cp docs/plantillas/template_general.md docs/plantillas/guia-template.md
```

### Error al escribir archivo

**Error:**
```
PermissionError: [Errno 13] Permission denied: 'docs/guias/onboarding/file.md'
```

**Causa:** Sin permisos de escritura

**Solucion:**
```bash
# Dar permisos de escritura:
chmod +w docs/guias/

# O ejecutar con permisos:
sudo python scripts/generate_guides.py --priority P0
```

### Metadata invalida

**Error:**
```
ERROR generando GUIA-ONBOARDING-001: Missing required field: 'prerequisitos'
```

**Causa:** Metadata de guia incompleta

**Solucion:** Verificar que metadata tiene todos los campos requeridos:
```python
# Campos obligatorios:
- id
- titulo
- categoria
- audiencia
- prioridad
- tiempo_lectura
- descripcion
- pasos
- prerequisitos
- validaciones
- troubleshooting
- proximos_pasos
- referencias
- mantenedores
```

## Arquitectura del Script

```python
# Flujo principal:

1. Parsear argumentos CLI
   |
   v
2. Inicializar DocumentationGuideGenerator
   |
   v
3. Si --report: generar reporte y salir
   |
   v
4. Cargar template desde docs/plantillas/guia-template.md
   |
   v
5. Obtener metadata de guias P0:
   - get_p0_guides_metadata()
   - Retorna lista de 20 GuideMetadata
   |
   v
6. Para cada GuideMetadata:
   |
   +-- a. Generar contenido desde template
   |      - Reemplazar placeholders
   |      - Insertar pasos, validaciones, troubleshooting
   |
   +-- b. Determinar path de salida
   |      - docs/guias/{categoria}/{id}.md
   |
   +-- c. Escribir archivo (o skip si --dry-run)
   |
   v
7. Generar reporte resumen:
   - Guias generadas
   - Guias omitidas
   - Porcentaje de completitud
   |
   v
8. Exit 0 (SUCCESS)
```

## Extender con Nuevas Guias

### Agregar nueva guia P0:

1. Editar `get_p0_guides_metadata()` en `generate_guides.py`

2. Agregar nuevo `GuideMetadata`:
```python
guides.append(GuideMetadata(
    id="GUIA-CATEGORY-008",
    titulo="Mi Nueva Guia",
    categoria="onboarding",
    audiencia="desarrollador-nuevo",
    prioridad="P0",
    tiempo_lectura=10,
    descripcion="Descripcion de la guia",
    pasos=[
        {
            "titulo": "Paso 1",
            "descripcion": "Que hacer",
            "comando": "comando shell",
            "output": "output esperado"
        }
    ],
    prerequisitos=["Pre-req 1"],
    validaciones=["Validacion 1"],
    troubleshooting=[
        {
            "titulo": "Error X",
            "sintomas": "Sintomas",
            "causa": "Causa",
            "solucion": "Solucion"
        }
    ],
    proximos_pasos=["Siguiente paso"],
    referencias={"Doc": "path"},
    mantenedores=["owner"]
))
```

3. Ejecutar generador:
```bash
python scripts/generate_guides.py --priority P0
```

4. Verificar guia generada:
```bash
cat docs/guias/{categoria}/mi_nueva_guia.md
```

## Integracion en CI/CD

### Auto-generar guias en PR

```yaml
# .github/workflows/docs-generation.yml

name: Auto-generate Guides

on:
  pull_request:
    paths:
      - 'scripts/generate_guides.py'
      - 'docs/plantillas/guia-template.md'

jobs:
  generate-guides:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Generate guides
        run: |
          python scripts/generate_guides.py --priority P0

      - name: Commit generated guides
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add docs/guias/
          git commit -m "docs: auto-generate guides [skip ci]" || echo "No changes"
          git push
```

## Mejores Practicas

1. **Mantener template actualizado:**
   - Template es base para todas las guias
   - Cambios en template afectan todas las guias generadas

2. **Metadata completa:**
   - No dejar campos vacios
   - Pasos deben tener comando + output esperado
   - Troubleshooting debe cubrir errores comunes

3. **Regenerar despues de cambios:**
   ```bash
   # Despues de modificar template o metadata:
   python scripts/generate_guides.py --priority P0
   git diff docs/guias/  # Ver cambios
   ```

4. **Dry-run para validar:**
   ```bash
   # Antes de generar, validar con dry-run:
   python scripts/generate_guides.py --priority P0 --dry-run
   ```

5. **Versionado:**
   - Guias generadas van en git
   - Commitear guias generadas junto con cambios en script

## Road map

### Guias Planeadas

**Total:** 147 guias operativas

**Por prioridad:**
- **P0:** 20 guias (COMPLETO)
- **P1:** 40 guias (TODO)
- **P2:** 50 guias (TODO)
- **P3:** 37 guias (TODO)

**Por categoria:**
- Onboarding: 15 guias
- Workflows: 20 guias
- Testing: 25 guias
- Deployment: 18 guias
- Troubleshooting: 30 guias
- Operations: 20 guias
- Security: 19 guias

## Referencias

- Codigo fuente: `scripts/generate_guides.py`
- Template: `docs/plantillas/guia-template.md`
- Guias generadas: `docs/guias/`
- SDLC Process: `docs/gobernanza/procesos/SDLC_PROCESS.md`

## Ownership

- **Maintainer:** Tech Lead, Doc Lead
- **Reviewers:** Arquitecto Senior
- **Contributors:** All team members (agregar nuevas guias)

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0.0
