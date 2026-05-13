---
id: GUIA-testing-002
tipo: guia_operativa
categoria: testing
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 8 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Ejecutar Tests Frontend Localmente

## Proposito

Aprende a ejecutar tests unitarios, de integración y E2E del frontend React.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Frontend configurado (Ver GUIA-ONBOARDING-001)
- [ ] Node modules instalados
- [ ] Backend corriendo para tests E2E

## Tiempo estimado

Tiempo de lectura: 8 minutos
Tiempo de ejecucion: 16 minutos

## Pasos

### 1. Ejecutar tests unitarios

Ejecuta tests unitarios con Jest.

**Comando**:
```bash
cd frontend
npm run test:unit
```

**Output esperado**:
```
Tests passed
```

### 2. Ejecutar tests con coverage

Genera reporte de cobertura de código.

**Comando**:
```bash
npm run test:coverage
```

**Output esperado**:
```
Coverage: 85%
```

### 3. Ejecutar tests E2E

Ejecuta tests end-to-end con Cypress/Playwright.

**Comando**:
```bash
npm run test:e2e
```

**Output esperado**:
```
E2E tests passed
```

### 4. Ejecutar tests en modo watch

Ejecuta tests en modo watch para desarrollo.

**Comando**:
```bash
npm run test:watch
```

**Output esperado**:
```
Watching for file changes...
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Tests unitarios pasan
- [ ] Coverage >= 80%
- [ ] Tests E2E pasan
- [ ] No hay warnings en consola

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Tests E2E fallan por timeout

**Sintomas**:
```
Timeout waiting for element
```

**Causa**: Backend no está corriendo o es lento

**Solucion**:
```bash
Inicia backend primero:
cd api && python manage.py runserver
# O aumenta timeout en cypress.config.js
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Validar test pyramid (Ver GUIA-TESTING-003)
2. Escribir nuevos tests
3. Ejecutar todos los tests antes de PR

## Referencias

- Jest docs: `https://jestjs.io/`
- Script CI frontend: `scripts/ci/frontend_test.sh`
- Test pyramid: `docs/gobernanza/ci_cd/workflows/test-pyramid.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @qa-lead, @frontend-lead
**Ultima actualizacion**: 2025-11-07
