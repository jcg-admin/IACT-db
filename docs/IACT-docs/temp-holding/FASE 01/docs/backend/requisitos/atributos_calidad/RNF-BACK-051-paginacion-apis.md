---
id: RNF-BACK-051
tipo: atributo_calidad
subtipo: usabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-051: Paginación APIs (default 20, max 100)

## Categoría

Usabilidad

## Descripción

El sistema backend debe implementar paginación consistente en todas las APIs que retornan listas, con valores por defecto razonables para evitar respuestas demasiado grandes y problemas de performance.

## Métrica Medible

**Métrica**: Porcentaje de endpoints de lista con paginación

**Valor objetivo**: 100% de endpoints de lista con paginación

**Condiciones**:
- Page size default: 20 items
- Page size máximo: 100 items
- Formato de paginación: cursor o page number
- Metadata incluida: total count, next, previous

## Método de Medición

**Herramienta de medición**: Auditoría de endpoints

**Frecuencia de medición**: Por cada release

**Proceso de medición**:
1. Listar todos los endpoints que retornan listas
2. Probar cada endpoint sin parámetros de paginación
3. Verificar que retorna máximo 20 items
4. Verificar metadata de paginación presente
5. Calcular: (Endpoints con paginación / Total endpoints lista) * 100

**Responsable de medición**: Backend + QA

## Criterios de Aceptación

**Formato de respuesta paginada**:
```json
{
 "count": 245,
 "next": "http://api.example.com/llamadas/?page=2",
 "previous": null,
 "results": [
 { "id": 1, "...": "..." },
 { "id": 2, "...": "..." }
 ]
}
```

**Criterios**:
1. **Default Page Size**: 20 items
2. **Max Page Size**: 100 items (rechaza requests > 100)
3. **Metadata**: count, next, previous incluidos
4. **Query Params**: ?page=N o ?cursor=XXX
5. **Todos los list endpoints**: Sin excepciones

**Umbrales**:
- **Mínimo aceptable**: 90% endpoints paginados
- **Objetivo**: 100% endpoints paginados
- **Óptimo**: 100% + cursor pagination para mejor performance

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNF-BACK-010 (Tiempo respuesta API)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-280: REST_FRAMEWORK['PAGE_SIZE'] = 20
- RF-BACK-281: REST_FRAMEWORK['MAX_PAGE_SIZE'] = 100
- RF-BACK-282: PageNumberPagination o CursorPagination

**Tests**: TS-RNF-051-001 (Test paginación configurada)

## Impacto en Arquitectura

**Componentes requeridos**:
- DRF Pagination: PageNumberPagination
- Settings: PAGE_SIZE, MAX_PAGE_SIZE
- Documentation: Documentar parámetros de paginación

## Prioridad**: Alta

**Riesgos**: Respuestas gigantes causan timeouts y mala UX

## Estado de Cumplimiento**: Implementado

**Última medición**: 100% endpoints con paginación

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 20/100 |
