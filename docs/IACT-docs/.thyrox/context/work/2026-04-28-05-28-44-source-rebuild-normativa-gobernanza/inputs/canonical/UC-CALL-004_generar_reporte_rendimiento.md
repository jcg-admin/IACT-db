---
id: UC-CALL-004
tipo: caso_de_uso
nombre: Generar Reporte de Rendimiento de Equipo
actor_primario: GERENTE
nivel: usuario
prioridad: media
estado: aprobado
dominio: reportes
trazabilidad_upward:
  - RN-REPORT-001    # Reportería de gestión
  - BR-R05           # Restricción: Solo gerentes pueden generar reportes completos
  - BR-C03           # Cálculo: AHT (Average Handle Time)
  - BR-C04           # Cálculo: FCR (First Call Resolution)
  - BR-I01           # Inferencia: Clasificación de rendimiento
trazabilidad_downward:
  - RF-REPORT-001    # API generar reporte
  - RF-REPORT-002    # API exportar reporte
  - TEST-REPORT-001  # Test generación completa
  - TEST-REPORT-002  # Test validación permisos
fecha_creacion: 2025-11-14
owner: equipo-reportes
reglas_negocio_aplicadas:
  - tipo: restriccion
    id: BR-R05
    descripcion: "Solo gerentes pueden generar reportes completos de equipos"
  - tipo: calculo
    id: BR-C03
    descripcion: "Calcular AHT por agente y promedio de equipo"
  - tipo: calculo
    id: BR-C04
    descripcion: "Calcular FCR por agente y promedio de equipo"
  - tipo: calculo
    id: BR-C08
    descripcion: "Calcular CSAT (Customer Satisfaction)"
  - tipo: inferencia
    id: BR-I01
    descripcion: "Clasificar rendimiento de agente (Excelente/Bueno/Aceptable/Requiere Mejora)"
  - tipo: inferencia
    id: BR-I02
    descripcion: "Identificar agentes que requieren capacitación"
---

# UC-CALL-004: Generar Reporte de Rendimiento de Equipo

## Identificación

- **ID**: UC-CALL-004
- **Nombre**: Generar Reporte de Rendimiento de Equipo
- **Actor primario**: GERENTE
- **Nivel**: Usuario (sea level)
- **Prioridad**: Media
- **Dominio**: Reportes y Analytics

## Resumen

Un gerente genera un reporte de rendimiento de un equipo específico, incluyendo métricas individuales de cada agente (AHT, FCR, CSAT) y promedios del equipo. El sistema clasifica automáticamente el rendimiento de cada agente e identifica aquellos que requieren capacitación o reconocimiento.

**Objetivo del actor**: Evaluar el desempeño del equipo, identificar áreas de mejora y tomar decisiones de gestión basadas en datos.

**Alcance**: Incluye selección de equipo y período, cálculo de métricas, clasificación de rendimiento y exportación. NO incluye métricas financieras (ROI, costos).

## Actores

### Actor primario
- **Rol**: GERENTE
- **Descripción**: Usuario con permisos de gerencia que supervisa uno o más equipos
- **Capacidades requeridas**: `reportes.generar`, `equipos.consultar`

### Actores secundarios
- **Base de Datos PostgreSQL**: Almacena histórico de llamadas y métricas
- **Sistema de Exportación**: Genera archivos PDF/Excel

## Precondiciones

1. **BR-R05**: Gerente autenticado con rol "Gerente" o superior
2. Existe data de llamadas en el rango de fechas seleccionado (al menos 24 horas)
3. Equipo seleccionado tiene al menos un agente asignado

## Flujo Principal

| Actor (GERENTE) | Sistema |
|-----------------|---------|
| 1. Gerente accede al módulo de reportes | |
| | 2. **BR-R05**: Sistema valida permisos de gerente |
| | 3. Sistema muestra formulario de selección |
| 4. Gerente selecciona equipo del dropdown | |
| | 5. Sistema carga lista de agentes del equipo |
| 6. Gerente define rango de fechas (inicio y fin) | |
| 7. Gerente selecciona formato de salida (HTML/PDF/Excel) | |
| 8. Gerente hace clic en "Generar Reporte" | |
| | 9. Sistema valida que rango de fechas sea válido |
| | 10. Sistema inicia cálculo de métricas (puede tardar) |
| | 11. Sistema muestra barra de progreso |
| | **Para cada agente del equipo:** |
| | 12. **BR-C03**: Sistema calcula AHT = Σ(duracion) / count(llamadas) |
| | 13. **BR-C04**: Sistema calcula FCR = count(resueltas_primer_contacto) / count(total) × 100 |
| | 14. **BR-C08**: Sistema calcula CSAT promedio |
| | 15. Sistema cuenta total de llamadas atendidas |
| | 16. **BR-I01**: Sistema clasifica rendimiento basado en umbrales |
| | **Fin del loop** |
| | 17. Sistema calcula promedios del equipo completo |
| | 18. **BR-I02**: Sistema identifica agentes que requieren capacitación |
| | 19. Sistema genera reporte en formato seleccionado |
| | 20. Sistema muestra reporte en pantalla |

## Flujos Alternos

### FA-1: Exportar a archivo
**Momento**: Después del paso 20
**Condición**: Gerente desea guardar reporte como archivo

**Acción**:
| Actor | Sistema |
|-------|---------|
| 20.a. Gerente hace clic en "Exportar" | |
| | 20.b. Sistema genera archivo en formato seleccionado (PDF/Excel) |
| | 20.c. Sistema descarga archivo al navegador |
| | 20.d. Sistema registra exportación en auditoría |

### FA-2: Comparación con período anterior
**Momento**: Paso 8
**Condición**: Gerente selecciona opción "Comparar con período anterior"

**Acción**:
| Actor | Sistema |
|-------|---------|
| 8.a. Gerente marca checkbox "Comparar con período anterior" | |
| | 8.b. Sistema calcula métricas para período anterior del mismo tamaño |
| | 8.c. Sistema calcula deltas (diferencias) |
| | 8.d. Sistema muestra flechas ↑↓ indicando mejoras/empeoramientos |
| | **Continúa en paso 9** |

### FA-3: Filtrar por agente específico
**Momento**: Paso 5
**Condición**: Gerente solo quiere ver un agente en lugar de todo el equipo

**Acción**:
| Actor | Sistema |
|-------|---------|
| 5.a. Gerente selecciona agente específico del dropdown | |
| | 5.b. Sistema ajusta cálculos solo para ese agente |
| | 5.c. Sistema omite promedios de equipo |
| | **Continúa en paso 6** |

## Flujos de Excepción

### FE-1: Sin datos suficientes en el período
**Momento**: Paso 10
**Condición de error**: Menos de 10 llamadas en el período seleccionado

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 10.e1. Sistema detecta insuficiencia de datos |
| | 10.e2. Sistema muestra advertencia: "Período tiene menos de 10 llamadas. Resultados pueden no ser representativos" |
| | 10.e3. Sistema muestra opción: "Continuar" o "Cambiar fechas" |
| 10.e4. Gerente decide continuar o ajustar fechas | |
| | 10.e5a. Si continuar → **Sigue en paso 11** |
| | 10.e5b. Si cambiar fechas → **Retorna a paso 6** |

### FE-2: Timeout en cálculo de métricas
**Momento**: Paso 10-16
**Condición de error**: Cálculo excede 60 segundos (dataset muy grande)

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 10.e1. Sistema detecta timeout después de 60 segundos |
| | 10.e2. Sistema cancela cálculo síncrono |
| | 10.e3. Sistema crea tarea Celery para procesamiento asíncrono |
| | 10.e4. Sistema muestra mensaje: "Reporte en proceso. Recibirá email cuando esté listo" |
| | 10.e5. Sistema envía email con link de descarga cuando complete |

**Resultado**: Caso de uso termina. Reporte se generará en background.

## Postcondiciones

### Postcondición de éxito
1. Reporte generado con métricas de todos los agentes seleccionados
2. **BR-C03, BR-C04, BR-C08**: Métricas calculadas (AHT, FCR, CSAT)
3. **BR-I01**: Rendimiento clasificado para cada agente
4. **BR-I02**: Agentes que requieren capacitación identificados
5. Reporte visible en pantalla y opcionalmente exportado
6. Generación registrada en auditoría

## Requisitos Especiales

### Performance
- **RNF-030**: Reporte de 100 agentes con 30 días de data debe generarse en menos de 30 segundos
- **RNF-031**: Para datasets grandes (>1000 agentes), usar procesamiento asíncrono

### Usabilidad
- **RNF-032**: Reporte debe incluir visualizaciones (gráficas de barras/líneas)
- **RNF-033**: Debe permitir drill-down para ver llamadas individuales

### Compliance
- **RNF-034**: Exportaciones deben quedar auditadas con usuario, fecha y equipo consultado

---

**Documentos relacionados:**
- [Reglas de Negocio - Cálculos](../../requisitos/REGLAS_NEGOCIO/TIPOS_AVANZADOS.md#5-cálculos-computacionales)
- [Reglas de Negocio - Inferencias](../../requisitos/REGLAS_NEGOCIO/TIPOS_AVANZADOS.md#4-inferencias)
- [Aplicación IACT - Métricas](../../requisitos/REGLAS_NEGOCIO/APLICACION_IACT.md#cálculos-de-rendimiento-de-agentes)

**Creado por**: Equipo de Reportes
**Fecha**: 2025-11-14
