---
id: RNF-BACK-061
tipo: atributo_calidad
subtipo: mantenibilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-061: Complejidad Ciclomática (< 10)

## Categoría

Mantenibilidad

## Descripción

El sistema backend debe mantener funciones y métodos con complejidad ciclomática baja (< 10) para garantizar código mantenible, testeable, y fácil de entender.

## Métrica Medible

**Métrica**: Complejidad ciclomática máxima por función

**Valor objetivo**: < 10 por función/método

**Condiciones**:
- Medido con radon o mccabe
- Aplica a todas las funciones y métodos
- Medido en código de apps (no migrations)

## Método de Medición

**Herramienta de medición**: radon (herramienta Python)

**Frecuencia de medición**: Por cada PR (CI/CD)

**Proceso de medición**:
1. Ejecutar: `radon cc apps/ -a -nb`
2. Identificar funciones con complexity > 10
3. Verificar que no hay funciones con complexity > 10
4. Generar reporte de complejidad promedio

**Responsable de medición**: CI/CD automatizado + Backend

## Criterios de Aceptación

**Escala de complejidad ciclomática**:
- **1-5**: Simple (A o B) - Excelente
- **6-10**: Moderada (C) - Aceptable
- **11-20**: Compleja (D) - Advertencia
- **21-50**: Muy compleja (E) - Inaceptable
- **50+**: Extremadamente compleja (F) - Crítico

**Criterios**:
1. **Límite estricto**: Ninguna función con complexity > 10
2. **Promedio**: Complejidad promedio < 5
3. **Nuevos PRs**: No introducen funciones con complexity > 10
4. **Refactoring**: Funciones con complexity > 10 deben ser refactorizadas

**Umbrales**:
- **Mínimo aceptable**: < 15 (no ideal pero tolerable)
- **Objetivo**: < 10
- **Óptimo**: < 5 (código muy simple)

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNEG-QUALITY-002 (Código mantenible)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-310: radon configurado en CI/CD
- RF-BACK-311: Linter falla si complexity > 10
- RF-BACK-312: Guía de refactoring para reducir complexity

**Tests**: TS-RNF-061-001 (Test no hay funciones con complexity > 10)

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Extraer funciones pequeñas de funciones grandes
- Usar patrones como Strategy para reducir if/else complejos
- Extraer validación a funciones separadas
- Preferir composición sobre funciones monolíticas

**Componentes/Patrones requeridos**:
- radon: Herramienta de análisis de complejidad
- CI/CD checks: Validación automática
- Code review: Revisar complejidad en PRs
- Refactoring guidelines: Documentar cómo reducir complejidad

## Prioridad**: Media

**Riesgos**: Código complejo es difícil de mantener, testear y debuggear

## Estado de Cumplimiento**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: ~15 funciones con complexity > 10

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Configurar radon en CI/CD
- Refactorizar funciones con complexity > 10
- Documentar patterns de refactoring
- Bloquear PRs que introducen complejidad alta

## Dependencias

**Dependencias técnicas**:
- radon (instalado vía pip)
- CI/CD pipeline
- Pre-commit hooks (opcional)

**Dependencias de otros RNF**:
- RNF-BACK-060: Cobertura tests (código simple es más fácil de testear)

## Notas Adicionales

**Cómo reducir complejidad ciclomática**:
1. **Extract Method**: Extraer bloques de código a funciones separadas
2. **Guard Clauses**: Usar early returns para reducir anidamiento
3. **Strategy Pattern**: Reemplazar if/else largos con dispatch tables
4. **Decompose Conditional**: Extraer condiciones complejas a funciones con nombre descriptivo

**Ejemplo de refactoring**:
```python
# ANTES (complexity = 12)
def process_llamada(llamada):
 if llamada.estado == 'nueva':
 if llamada.tipo == 'entrante':
 if llamada.prioridad == 'alta':
 # ... lógica compleja
 else:
 # ... más lógica
 else:
 # ... aún más lógica
 else:
 # ... mucha más lógica

# DESPUÉS (complexity = 3 por función)
def process_llamada(llamada):
 if llamada.estado != 'nueva':
 return process_llamada_existente(llamada)

 if llamada.tipo == 'entrante':
 return process_llamada_entrante(llamada)

 return process_llamada_saliente(llamada)

def process_llamada_entrante(llamada):
 if llamada.prioridad == 'alta':
 return process_llamada_alta_prioridad(llamada)
 return process_llamada_normal_prioridad(llamada)
```

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 10 |

## Aprobación

**Especificado por**: Equipo de Arquitectura + Backend IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
