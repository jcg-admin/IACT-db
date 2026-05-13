---
id: RNF-BACK-015
tipo: atributo_calidad
subtipo: rendimiento
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-015: Tiempo de Generación de Reportes

## Categoría

Rendimiento

## Descripción

El sistema backend debe generar reportes de analytics y llamadas en tiempos razonables, permitiendo a los usuarios obtener información sin esperas prolongadas, incluso con volúmenes significativos de datos.

## Métrica Medible

**Métrica**: Tiempo de generación de reporte completo (PDF/Excel)

**Valor objetivo**: < 5 segundos para 10,000 registros

**Condiciones**:
- Reporte estándar de llamadas con filtros básicos
- Dataset de hasta 10,000 registros
- Generación de PDF o Excel
- Medido desde request hasta archivo disponible para descarga

## Método de Medición

**Herramienta de medición**:
- Timing logs en endpoint de reportes
- APM para medir tiempo de procesamiento
- Tests funcionales automatizados

**Frecuencia de medición**: Por cada release + tests funcionales

**Proceso de medición**:
1. Ejecutar generación de reporte con 10k registros
2. Medir tiempo desde request hasta archivo generado
3. Repetir con diferentes filtros y formatos
4. Calcular promedio de tiempos
5. Verificar que promedio < 5s

**Responsable de medición**: Equipo Backend + QA

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. Reportes de hasta 10k registros generados en < 5 segundos
2. Reportes de hasta 50k registros generados en < 30 segundos
3. Reportes > 50k registros se procesan de forma asíncrona con notificación

**Umbrales**:
- **Mínimo aceptable**: < 10 segundos para 10k registros
- **Objetivo**: < 5 segundos para 10k registros
- **Óptimo**: < 3 segundos para 10k registros

## Alcance

**Aplica a**: Endpoints de generación de reportes

**Módulos/Componentes afectados**:
- `/api/reports/llamadas/` - Reportes de llamadas
- `/api/reports/analytics/` - Reportes analíticos
- `/api/reports/agentes/` - Reportes de agentes
- Generadores de PDF (ReportLab) y Excel (openpyxl)

**Excepciones**:
- Reportes históricos > 50k registros (procesados asíncronamente)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-REPORT-001: Generar Reporte de Llamadas
- UC-REPORT-002: Exportar Datos a Excel
- UC-ANALYTICS-003: Descargar Métricas Período

**Derivado de Reglas de Negocio**:
- RN-REPORT-001: Reportes deben generarse on-demand

**Relacionado con Requerimientos de Negocio**:
- RNEG-BACK-005: Facilitar extracción de datos para análisis

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-060: Implementar generación incremental de reportes
- RF-BACK-061: Procesamiento asíncrono para reportes grandes
- RF-BACK-062: Optimizar queries de agregación para reportes

**Tests de Validación**:
- TS-RNF-015-001: Test generación PDF 10k registros
- TS-RNF-015-002: Test generación Excel 10k registros
- TS-RNF-015-003: Test procesamiento asíncrono 50k registros

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Procesamiento síncrono para reportes pequeños (< 10k)
- Procesamiento asíncrono con APScheduler para reportes grandes
- Generación incremental (streaming) de archivos grandes
- Almacenamiento temporal de reportes generados

**Componentes/Patrones requeridos**:
- APScheduler: Jobs asíncronos para reportes grandes
- ReportLab: Generación eficiente de PDF
- openpyxl: Generación optimizada de Excel
- File Storage: Almacenamiento temporal de reportes

## Validación

**Tipo de validación**: Tests funcionales de performance

**Frecuencia de validación**: Por cada release

**Criterio de éxito de validación**:
Reporte de 10k registros generado en promedio < 5s en 5 intentos

**Acción si no se cumple**:
- Profiling de generación de reportes
- Optimizar queries de datos
- Optimizar generación de PDF/Excel

## Prioridad y Riesgos

**Prioridad**: Media

**Justificación de prioridad**:
Los reportes son importantes pero no críticos para operación diaria

**Riesgos si no se cumple**:
- Frustración de usuarios al esperar reportes
- Timeouts en navegador para reportes grandes
- Uso ineficiente de tiempo de supervisores

**Impacto de no cumplimiento**: Medio

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Implementar generación asíncrona
- Optimizar queries de reportes
- Implementar tests de performance

## Dependencias

**Dependencias técnicas**:
- ReportLab para PDF
- openpyxl para Excel
- APScheduler para procesamiento asíncrono

**Dependencias de otros RNF**:
- RNF-BACK-013: Latencia queries BD

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 5s para 10k |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
