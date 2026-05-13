---
id: RNF-BACK-060
tipo: atributo_calidad
subtipo: mantenibilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-060: Cobertura de Tests (>= 80%)

## Categoría

Mantenibilidad

## Descripción

El sistema backend debe mantener una cobertura de tests automatizados de al menos 80% para garantizar que el código es testeable, facilitar refactoring seguro, y prevenir regresiones.

## Métrica Medible

**Métrica**: Porcentaje de cobertura de líneas de código

**Valor objetivo**: >= 80% cobertura de líneas

**Condiciones**:
- Medido con coverage.py
- Cobertura de líneas (line coverage)
- Excluyendo migraciones, settings, __init__.py
- Medido en código de apps (no libraries)

## Método de Medición

**Herramienta de medición**: coverage.py + pytest-cov

**Frecuencia de medición**: Por cada PR (CI/CD)

**Proceso de medición**:
1. Ejecutar: `pytest --cov=apps --cov-report=term-missing`
2. Parsear output de coverage
3. Verificar que coverage total >= 80%
4. Bloquear PR si coverage < 80%

**Responsable de medición**: CI/CD automatizado + QA

## Criterios de Aceptación

**Criterios**:
1. **Cobertura global**: >= 80% de líneas
2. **Apps críticas**: >= 90% (permisos, autenticación, llamadas)
3. **Nuevos PRs**: No reducen cobertura total
4. **Tests pasando**: 100% de tests pasan
5. **Tipos de tests**: Unit + Integration + E2E

**Distribución de tests**:
- Unit tests: 70% (tests rápidos, aislados)
- Integration tests: 25% (tests de APIs completas)
- E2E tests: 5% (flujos críticos end-to-end)

**Umbrales**:
- **Mínimo aceptable**: >= 70% cobertura
- **Objetivo**: >= 80% cobertura
- **Óptimo**: >= 90% cobertura

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNEG-QUALITY-001 (Garantizar calidad de software)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-300: pytest configurado como test runner
- RF-BACK-301: coverage.py configurado en pytest.ini
- RF-BACK-302: CI/CD ejecuta tests y reporta coverage
- RF-BACK-303: Bloqueo de PR si coverage < 80%

**Tests**: N/A (esta métrica SE MIDE con tests)

## Impacto en Arquitectura

**Componentes requeridos**:
- pytest: Test runner
- pytest-cov: Plugin de coverage
- pytest-django: Integración con Django
- CI/CD: GitHub Actions o similar
- Coverage reporting: Codecov o Coveralls

## Prioridad**: Alta

**Riesgos**: Regresiones frecuentes sin tests adecuados

## Estado de Cumplimiento**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: 62% cobertura

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Escribir tests para apps con < 70% coverage
- Configurar CI/CD para bloquear PRs con < 80%
- Implementar tests para ivr_legacy (actualmente 0%)

## Dependencias

**Dependencias técnicas**:
- pytest
- pytest-cov
- pytest-django
- coverage.py
- CI/CD pipeline

**Dependencias de otros RNF**:
- RNF-BACK-061: Complejidad ciclomática (código complejo es difícil de testear)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | >= 80% |
