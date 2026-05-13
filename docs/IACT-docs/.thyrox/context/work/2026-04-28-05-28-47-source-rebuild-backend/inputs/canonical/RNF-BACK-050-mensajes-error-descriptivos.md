---
id: RNF-BACK-050
tipo: atributo_calidad
subtipo: usabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-050: Mensajes de Error Descriptivos (i18n)

## Categoría

Usabilidad

## Descripción

El sistema backend debe retornar mensajes de error descriptivos y útiles que permitan al frontend mostrar información clara al usuario sobre qué salió mal y cómo corregirlo, con soporte de internacionalización.

## Métrica Medible

**Métrica**: Porcentaje de errores con mensajes descriptivos

**Valor objetivo**: 100% de errores con mensaje descriptivo

**Condiciones**:
- Mensaje indica QUÉ falló
- Mensaje indica CÓMO corregir (cuando sea posible)
- Código de error consistente (ERR-XXX-###)
- Soporte español e inglés (i18n)

## Método de Medición

**Herramienta de medición**: Auditoría de responses de API

**Frecuencia de medición**: Por cada release

**Proceso de medición**:
1. Provocar errores comunes (validación, permisos, etc.)
2. Revisar JSON de respuesta de error
3. Verificar que contiene: code, message, details
4. Verificar que message es descriptivo
5. Calcular: (Errores con mensaje / Total errores) * 100

**Responsable de medición**: Backend + QA

## Criterios de Aceptación

**Formato de error estándar**:
```json
{
 "error": {
 "code": "ERR-VALIDATION-001",
 "message": "El campo 'email' no tiene un formato válido",
 "details": {
 "field": "email",
 "value": "usuario@invalid",
 "expected": "Formato email válido (ej: usuario@example.com)"
 },
 "timestamp": "2025-01-17T10:30:45Z"
 }
}
```

**Criterios**:
1. **Code**: Código de error único (ERR-CATEGORY-###)
2. **Message**: Mensaje descriptivo en lenguaje natural
3. **Details**: Información adicional para debugging
4. **i18n**: Mensaje en español o inglés según Accept-Language
5. **HTTP Status**: Status code apropiado (400, 401, 403, 404, etc.)

**Umbrales**:
- **Mínimo aceptable**: 80% errores con mensaje
- **Objetivo**: 100% errores con mensaje
- **Óptimo**: 100% + i18n completo

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNEG-UX-001 (Experiencia de usuario clara)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-270: Exception handler custom en DRF
- RF-BACK-271: Clase ErrorResponse estándar
- RF-BACK-272: Traducción de mensajes con django-i18n

**Tests**: TS-RNF-050-001 (Test formato de errores)

## Impacto en Arquitectura

**Componentes requeridos**:
- DRF Custom Exception Handler
- ErrorResponse class
- django.utils.translation para i18n
- Documentación de códigos de error

## Prioridad**: Media

**Riesgos**: UX pobre si errores no son claros

## Estado de Cumplimiento**: Parcialmente implementado

**Última medición**: ~60% errores con mensaje descriptivo

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 100% |
