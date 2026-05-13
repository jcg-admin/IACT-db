---
id: GUIA-testing-003
tipo: guia_operativa
categoria: testing
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 6 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Validar Test Pyramid

## Proposito

Aprende a validar que tu código cumple con la pirámide de tests (60% unit, 30% integration, 10% E2E).

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Tests backend ejecutados (Ver GUIA-TESTING-001)
- [ ] Tests frontend ejecutados (Ver GUIA-TESTING-002)
- [ ] pytest-json-report instalado

## Tiempo estimado

Tiempo de lectura: 6 minutos
Tiempo de ejecucion: 12 minutos

## Pasos

### 1. Ejecutar validación de pyramid

Ejecuta el script que valida la distribución de tests.

**Comando**:
```bash
./scripts/ci/test_pyramid_check.sh
```

**Output esperado**:
```
Test pyramid validation: PASSED
Unit: 62%, Integration: 28%, E2E: 10%
```

### 2. Revisar reporte detallado

Revisa el reporte JSON generado con detalles.

**Comando**:
```bash
cat test-pyramid-report.json | jq .
```

**Output esperado**:
```
JSON con distribución de tests
```

### 3. Identificar desbalances

Si falla, identifica qué categoría está desbalanceada.

**Comando**:
```bash
# El script te dirá:
# - Demasiados tests E2E (>10%)
# - Pocos tests unitarios (<60%)
# - etc
```

**Output esperado**:
```
Causa del desbalance identificada
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Pyramid check pasa
- [ ] Unit tests: 60% ± 10%
- [ ] Integration tests: 30% ± 10%
- [ ] E2E tests: 10% ± 5%

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Demasiados tests E2E

**Sintomas**:
```
E2E tests: 25% (expected ~10%)
```

**Causa**: Algunos tests E2E deberían ser integration

**Solucion**:
```bash
Revisa tests E2E y mueve los que no necesiten navegador completo a integration tests
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Ajustar distribución de tests si falla
2. Crear PR (Ver GUIA-WORKFLOWS-003)

## Referencias

- Test Pyramid: `https://martinfowler.com/bliki/TestPyramid.html`
- Workflow test-pyramid.yml: `.github/workflows/test-pyramid.yml`
- Script validación: `scripts/ci/test_pyramid_check.sh`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @qa-lead
**Ultima actualizacion**: 2025-11-07
