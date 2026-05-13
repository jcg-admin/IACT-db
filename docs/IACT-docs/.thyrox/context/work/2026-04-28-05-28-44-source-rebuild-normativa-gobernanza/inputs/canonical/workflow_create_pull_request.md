---
id: GUIA-WORKFLOW-CREATE-PULL-REQUEST
tipo: guia_operativa
categoria: workflows
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 10 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: []
---

# Crear Pull Request

## Proposito

Aprende a crear un Pull Request que pase todos los checks de CI/CD y sea fácil de revisar.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Feature branch con commits (Ver GUIA-WORKFLOWS-002)
- [ ] Tests pasando localmente (Ver GUIA-TESTING-001)
- [ ] Cambios pusheados a remote

## Tiempo estimado

Tiempo de lectura: 10 minutos
Tiempo de ejecucion: 20 minutos

## Pasos

### 1. Push de tu branch

Sube tus cambios al repositorio remoto.

**Comando**:
```bash
git push origin feature/TASK-123-descripcion
```

**Output esperado**:
```
Branch pushed to remote
```

### 2. Crear PR desde GitHub

Ve a GitHub y crea el Pull Request.

**Comando**:
```bash
# Abre: https://github.com/2-Coatl/IACT---project/pulls
# Click en 'New Pull Request'
# Selecciona tu branch
```

**Output esperado**:
```
PR creado
```

### 3. Completar template de PR

Llena el template con toda la información requerida.

**Comando**:
```bash
# Completa:
# - Descripción del cambio
# - Issues relacionados (#123)
# - Checklist de testing
# - Screenshots si aplica
```

**Output esperado**:
```
Template completado
```

### 4. Esperar checks de CI

Espera a que pasen todos los checks automáticos.

**Comando**:
```bash
# GitHub Actions ejecutará:
# - Linting
# - Tests
# - Build
# - Security scans
```

**Output esperado**:
```
All checks passed
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] PR tiene título descriptivo
- [ ] Template está completamente llenado
- [ ] Todos los checks de CI pasan
- [ ] PR está asignado a reviewers
- [ ] Labels correctos aplicados (feature, bug, etc)

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: CI falla en linting

**Sintomas**:
```
Lint check failed
```

**Causa**: Código no cumple estándares de estilo

**Solucion**:
```bash
Ejecuta linter localmente y corrige:
cd api && flake8 .
cd frontend && npm run lint
```

### Error 2: Tests fallan en CI

**Sintomas**:
```
Test check failed
```

**Causa**: Tests no pasan en entorno CI

**Solucion**:
```bash
Ejecuta tests localmente:
./scripts/ci/backend_test.sh
./scripts/ci/frontend_test.sh
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Interpretar resultados de CI/CD (Ver GUIA-WORKFLOWS-004)
2. Incorporar feedback de code review
3. Merge y deployment (Ver GUIA-DEPLOYMENT-001)

## Referencias

- Template de PR: `.github/pull_request_template.md`
- Workflow de CI: `.github/workflows/backend-ci.yml`
- Proceso de code review: `docs/gobernanza/procesos/SDLC_PROCESS.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @qa-lead
**Ultima actualizacion**: 2025-11-07
