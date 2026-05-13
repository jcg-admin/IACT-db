---
id: GUIA-onboarding-005
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 10 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Usar Agentes SDLC - Planning

## Proposito

Aprende a usar el SDLCPlannerAgent para convertir feature requests en GitHub issues estructurados.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Python 3.11+ instalado
- [ ] GitHub CLI (gh) instalado
- [ ] GITHUB_TOKEN configurado

## Tiempo estimado

Tiempo de lectura: 10 minutos
Tiempo de ejecucion: 20 minutos

## Pasos

### 1. Preparar feature request

Prepara una descripción clara de la feature que quieres implementar.

**Comando**:
```bash
# Ejemplo:
# 'Implementar sistema de notificaciones push para usuarios'
```

**Output esperado**:
```
Feature request definido
```

### 2. Ejecutar SDLCPlannerAgent

Ejecuta el agente para generar el issue estructurado.

**Comando**:
```bash
python scripts/ai/agents/sdlc_planner.py \
  --input "Feature: Sistema de notificaciones push" \
  --output docs/sdlc_outputs/planning/
```

**Output esperado**:
```
Issue generado en docs/sdlc_outputs/planning/issue-XXX.md
```

### 3. Revisar issue generado

Revisa que el issue tenga toda la información necesaria.

**Comando**:
```bash
cat docs/sdlc_outputs/planning/issue-XXX.md
```

**Output esperado**:
```
Issue con:
- User story
- Acceptance criteria
- Story points
- Labels
```

### 4. Crear issue en GitHub

Usa el contenido generado para crear el issue en GitHub.

**Comando**:
```bash
gh issue create --title "Feature: Notificaciones push" \
  --body-file docs/sdlc_outputs/planning/issue-XXX.md \
  --label feature,planning
```

**Output esperado**:
```
Issue #XXX creado en GitHub
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Agente ejecuta sin errores
- [ ] Issue generado contiene user story
- [ ] Issue contiene acceptance criteria
- [ ] Issue creado en GitHub

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: GITHUB_TOKEN no configurado

**Sintomas**:
```
Error: GITHUB_TOKEN required
```

**Causa**: Variable de entorno faltante

**Solucion**:
```bash
Crea personal access token en GitHub:
# Settings -> Developer settings -> Personal access tokens
# Crea token con scope 'repo'
export GITHUB_TOKEN='tu_token'
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Usar SDLCFeasibilityAgent para análisis de viabilidad
2. Usar SDLCDesignAgent para diseño técnico
3. Iniciar fase de Implementation

## Referencias

- SDLCPlannerAgent: `scripts/ai/agents/sdlc_planner.py`
- SDLC Process: `docs/gobernanza/procesos/SDLC_PROCESS.md`
- Agentes SDLC: `docs/gobernanza/procesos/AGENTES_SDLC.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @arquitecto-senior
**Ultima actualizacion**: 2025-11-07
