---
id: GUIA-DEV-001
tipo: guia
categoria: gobernanza
subcategoria: quickstart
version: 1.0.0
fecha_creacion: 2025-11-07
autor: equipo-documentacion
estado: activo
---

# Quick Start - Sistema de Guias Operativas

Esta guia te ayuda a empezar a usar el sistema de guias operativas del proyecto IACT.

## Para Desarrolladores Nuevos

### Primer Dia - Setup Basico (30-60 min)

1. **Lee el indice de guias:**
   - Abre: [docs/guias/README.md](README.md)

2. **Sigue las guias de onboarding en orden:**
   - [Configurar Entorno de Desarrollo Local](onboarding/onboarding_001.md) - 15 min
   - [Ejecutar Proyecto Localmente](onboarding/onboarding_002.md) - 10 min
   - [Estructura del Proyecto IACT](onboarding/onboarding_003.md) - 8 min
   - [Configurar Variables de Entorno](onboarding/onboarding_004.md) - 7 min

3. **Si tienes problemas:**
   - [Problemas Comunes de Setup](troubleshooting/troubleshooting_001.md) - 15 min

### Primera Semana - Workflow de Desarrollo

4. **Aprende el workflow Git:**
   - [Crear Feature Branch](workflows/workflows_001.md) - 5 min
   - [Hacer Commits Convencionales](workflows/workflows_002.md) - 7 min

5. **Aprende a ejecutar tests:**
   - [Ejecutar Tests Backend Localmente](testing/testing_001.md) - 8 min
   - [Ejecutar Tests Frontend Localmente](testing/testing_002.md) - 8 min

6. **Crea tu primer PR:**
   - [Crear Pull Request](workflows/workflows_003.md) - 10 min
   - [Interpretar Resultados de CI/CD](workflows/workflows_004.md) - 8 min

## Para Desarrolladores Experimentados

Si ya conoces el stack tecnologico, empieza aqui:

1. [Estructura del Proyecto IACT](onboarding/onboarding_003.md)
2. [Crear Feature Branch](workflows/workflows_001.md)
3. [Validar Restricciones Criticas](deployment/deployment_002.md)
4. [Workflow de Deployment](deployment/deployment_001.md)

## Para QA Engineers

1. [Ejecutar Tests Backend Localmente](testing/testing_001.md)
2. [Ejecutar Tests Frontend Localmente](testing/testing_002.md)
3. [Validar Test Pyramid](testing/testing_003.md)
4. [Validar Restricciones Criticas](deployment/deployment_002.md)

## Para DevOps Engineers

1. [Workflow de Deployment](deployment/deployment_001.md)
2. [Interpretar Resultados de CI/CD](workflows/workflows_004.md)
3. [Validar Restricciones Criticas](deployment/deployment_002.md)

## Para Mantenedores de Guias

### Como Generar Nuevas Guias

```bash
# Generar todas las guias P0
python scripts/generate_guides.py --priority P0

# Generar guias de categoria especifica
python scripts/generate_guides.py --category onboarding

# Dry-run (no escribe archivos)
python scripts/generate_guides.py --priority P1 --dry-run

# Ver reporte de coverage
python scripts/generate_guides.py --report
```

### Como Ver Metricas

```bash
# Metricas de documentacion
python scripts/dora_metrics.py --docs-only

# Metricas en JSON
python scripts/dora_metrics.py --docs-only --format json
```

### Como Validar Guias

El workflow CI automaticamente valida guias en PRs:
- `.github/workflows/validate-guides.yml`

### Como Actualizar una Guia

1. Lee la guia actual
2. Edita el archivo .md
3. Sigue el template: `docs/plantillas/guia-template.md`
4. Actualiza fecha en frontmatter
5. Crea PR

### Como Crear una Nueva Guia

**Opcion 1: Automatica (recomendado)**

1. Edita `scripts/generate_guides.py`
2. Agrega metadata de la nueva guia en `get_p0_guides_metadata()`
3. Ejecuta: `python scripts/generate_guides.py --priority P0`

**Opcion 2: Manual**

1. Copia template: `cp docs/plantillas/guia-template.md docs/guias/categoria/nueva-guia.md`
2. Reemplaza todos los placeholders `{VARIABLE}`
3. Completa contenido
4. Crea PR

## Comandos Utiles

### Buscar Guias

```bash
# Listar todas las guias
find docs/guias -name "*.md" ! -name "README.md" ! -name "METRICS.md"

# Buscar guia por palabra clave
grep -r "deployment" docs/guias/ --include="*.md"

# Contar guias por categoria
ls docs/guias/onboarding/*.md | wc -l
```

### Estadisticas

```bash
# Total de guias
find docs/guias -name "*.md" ! -name "README.md" ! -name "METRICS.md" | wc -l

# Guias por categoria
for dir in docs/guias/*/; do
  echo "$(basename $dir): $(ls $dir/*.md 2>/dev/null | wc -l) guias"
done

# Coverage actual
python scripts/dora_metrics.py --docs-only
```

## Feedback y Contribuciones

### Reportar Problema con una Guia

1. Crea issue en GitHub
2. Label: `documentation`
3. Titulo: `[GUIA] Nombre de la guia - problema`
4. Incluye:
   - Guia afectada
   - Seccion con problema
   - Error o mejora sugerida

### Proponer Nueva Guia

1. Verifica que no exista en [docs/guias/README.md](README.md)
2. Crea issue con:
   - Titulo propuesto
   - Audiencia objetivo
   - Por que es necesaria
   - Prioridad sugerida (P1/P2/P3)

## Recursos

### Documentos Clave

- [Indice completo de guias](README.md)
- [Metricas de adoption](METRICS.md)
- [Template de guia](../plantillas/guia-template.md)
- [Reporte de implementacion](../../IMPLEMENTATION_REPORT.md)

### Scripts

- [Generador de guias](../../scripts/generate_guides.py)
- [Metricas DORA](../../scripts/dora_metrics.py)

### Workflows

- [Validacion de guias](../../.github/workflows/validate-guides.yml)

## Preguntas Frecuentes

### Por que 147 guias?

Basado en el analisis completo del proyecto documentado en:
`docs/gobernanza/ANALISIS_GUIAS_WORKFLOWS.md`

Desglose:
- 48 guias de workflows CI/CD (16 workflows × 3 guias c/u)
- 88 guias de scripts de automatizacion (88 scripts × 1 guia c/u)
- 6 guias de agentes SDLC
- 7 guias de fases SDLC
- 4 guias transversales por rol

### Cuantas guias hay ahora?

**17 guias P0 completadas (11.6% del total)**

Ver metricas actuales:
```bash
python scripts/dora_metrics.py --docs-only
```

### Cuando estaran las 147 guias?

**Roadmap:**
- Semana 1 (Nov 7-14): 20 guias P0 (criticas)
- Semanas 2-3 (Nov 15-28): +40 guias P1 (alta prioridad)
- Mes 2 (Diciembre): +50 guias P2 (media prioridad)
- Mes 3 (Enero): +37 guias P3 (baja prioridad)

**Total: 147 guias en 3 meses**

### Como se mide adoption?

1. Encuesta mensual al equipo
2. Tracking de views en GitHub Pages
3. Tracking de preguntas en Slack #dev-help
4. Feedback directo en issues

Ver: [docs/guias/METRICS.md](METRICS.md#metodologia-de-medicion)

### Quien mantiene las guias?

**Owners por categoria:**
- Onboarding: @doc-lead @tech-lead
- Workflows: @tech-lead @devops-lead
- Testing: @qa-lead @tech-lead
- Deployment: @devops-lead @tech-lead
- Troubleshooting: @tech-lead @devops-lead

Ver: `.github/CODEOWNERS`

---

**Siguiente paso:** Empieza con [Configurar Entorno de Desarrollo Local](onboarding/onboarding_001.md)

**Necesitas ayuda?** Pregunta en Slack #dev-help o crea un issue

**Mantenedores:** @doc-lead, @tech-lead
**Ultima actualizacion:** 2025-11-07
