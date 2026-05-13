---
id: N-001
tipo: necesidad
titulo: Obtener visibilidad de metricas operativas del IVR en tiempo casi real
dominio: backend
owner: equipo-analytics
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
fecha_aprobacion: 2025-11-06
sponsor: director-operaciones
stakeholders:
 - gerente-call-center
 - coordinadores-operaciones
 - analistas-negocio
 - director-operaciones
 - supervisores-atencion
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "6.2"
valor_negocio: alto
urgencia: critica
date: 2025-11-13
---

# N-001: Obtener visibilidad de metricas operativas del IVR en tiempo casi real

## 1. Descripcion de la Necesidad

### 1.1 Problema u Oportunidad

El sistema de IVR (Interactive Voice Response) del call center procesa miles de llamadas diarias, generando metricas criticas para la operacion del negocio. Sin embargo, actualmente existe una brecha significativa entre cuando ocurren los eventos en el IVR y cuando los gerentes y analistas pueden visualizar y actuar sobre esa informacion.

**Problemas actuales identificados:**

- **Rezago de datos**: Las metricas del IVR tienen un rezago de 12-24 horas antes de estar disponibles para consulta
- **Reportes manuales**: Los analistas dedican 10-15 horas/semana generando reportes manualmente desde la BD del IVR
- **Deteccion tardia de problemas**: Los problemas operativos (picos de llamadas, colas largas, servicios caidos) se detectan tarde
- **Decisiones basadas en datos obsoletos**: Los gerentes toman decisiones sin conocer el estado actual de las operaciones
- **Falta de visibilidad consolidada**: No existe un dashboard centralizado con las metricas clave del IVR

**Impacto en el negocio:**

Cuantitativo:
- 10-15 horas/semana de analistas generando reportes manualmente (costo: aproximadamente $800/semana)
- Tiempo promedio de deteccion de problemas: 8-12 horas (cuando deberia ser <1 hora)
- Decisiones operativas basadas en datos de hace 12-24 horas (obsoletos)
- 3-5 escalamientos semanales por problemas no detectados a tiempo

Cualitativo:
- Frustracion de gerentes por falta de visibilidad
- Incapacidad de responder preguntas de negocio en tiempo oportuno
- Perdida de oportunidades de mejora operativa
- Desmotivacion de analistas por trabajo manual repetitivo

### 1.2 Situacion Actual (As-Is)

**Proceso actual de obtencion de metricas:**

1. **Generacion de datos**: El IVR registra eventos de llamadas en su base de datos legacy (MySQL)
2. **Acceso manual**: Analistas ejecutan queries SQL directamente contra la BD del IVR (riesgoso)
3. **Extraccion**: Datos exportados a Excel manualmente
4. **Transformacion**: Limpieza y calculo de metricas en hojas de calculo
5. **Reporte**: Envio de reportes por email o presentaciones PowerPoint
6. **Toma de decision**: Gerentes reciben informacion 12-24 horas despues del evento

**Caracteristicas de la situacion actual:**

- Frecuencia de actualizacion: Manual, 1-2 veces por dia
- Tiempo de generacion de reporte: 2-3 horas por analista
- Acceso a datos: Limitado a personal tecnico con conocimiento SQL
- Visibilidad: Reportes estaticos, no dashboard interactivo
- Historico: Consultas complejas requieren dias de trabajo
- Exportaciones: Proceso manual propenso a errores

**Sistemas involucrados:**

- BD IVR Legacy (MySQL): Tablas `tbl_historico_t1_YYYY`, `tbl_historico_t2_YYYY`, `tbl_historico_t3_YYYY`
- Excel: Herramienta principal de analistas
- Email/PowerPoint: Distribucion de reportes

### 1.3 Situacion Deseada (To-Be)

**Proceso objetivo:**

1. **ETL Automatizado**: Proceso batch cada 6-12 horas extrae datos del IVR (readonly, sin impacto)
2. **Transformacion**: Limpieza, normalizacion y calculo automatico de metricas
3. **Carga**: Datos cargados en BD Analytics optimizada para consultas
4. **Dashboard**: Gerentes y analistas acceden a dashboard web con metricas actualizadas
5. **Alertas**: Notificaciones automaticas cuando metricas exceden umbrales
6. **Exportaciones**: Generacion automatica de reportes CSV/Excel/PDF

**Beneficios esperados:**

Cuantitativos:
- Reduccion rezago de datos: de 24h a 6-12h (mejora 50-75%)
- Reduccion tiempo generacion reportes: de 15h/semana a 3h/semana (ahorro 80%)
- Tiempo deteccion problemas: de 8-12h a <1h (mejora 92%)
- ROI estimado: 320% en 3 anos (payback 11 meses)

Cualitativos:
- Visibilidad en tiempo casi real de operaciones
- Decisiones basadas en datos actuales (6-12h vs 24h)
- Dashboard accesible para todo el equipo (no solo tecnicos)
- Reduccion de escalamientos por deteccion temprana
- Mayor satisfaccion de gerentes y analistas
- Capacidad de responder preguntas de negocio en minutos (vs dias)

**Criterios de exito:**

- Dashboard principal carga en <3 segundos
- Datos actualizados cada 6-12 horas automaticamente
- 10 widgets priorizados disponibles
- Exportaciones CSV/Excel/PDF automatizadas
- Reduccion 80% tiempo manual en reportes
- 100% trazabilidad de origen de datos

---

## 2. Justificacion de Negocio

### 2.1 Impacto en el Negocio

| Dimension | Impacto Actual | Impacto Esperado |
|-----------|----------------|-------------------|
| **Financiero** | $3,200/mes en tiempo analistas reportes manuales | Ahorro $2,560/mes (reduccion 80%) |
| **Operacional** | Deteccion problemas 8-12 horas despues | Deteccion <1 hora (alertas automaticas) |
| **Cliente** | Problemas no detectados impactan experiencia | Deteccion temprana, resolucion proactiva |
| **Estrategico** | Decisiones basadas en datos obsoletos (24h) | Decisiones basadas en datos casi actuales (6-12h) |

### 2.2 Costo de No Hacer Nada

**Costos tangibles anuales:**

- Tiempo analistas reportes manuales: $38,400/ano (15h/semana x $50/h x 52 semanas)
- Escalamientos por deteccion tardia: $12,000/ano (50 escalamientos x $240 c/u)
- Oportunidades perdidas de mejora: $25,000/ano (estimado)

**Costo total: $75,400/ano**

**Costos intangibles:**

- Frustracion de gerentes por falta de visibilidad
- Desmotivacion de analistas por trabajo repetitivo
- Perdida de competitividad operativa
- Riesgo de incumplimiento SLA por deteccion tardia

---

## 3. Alcance

### 3.1 En Alcance

- Sistema ETL automatizado para extraccion de datos del IVR (readonly)
- Dashboard web con 10 widgets priorizados
- Filtros de fecha (15 presets rapidos + rango personalizado)
- Sistema de alertas por buzón interno (NO email)
- Exportaciones automaticas: CSV, Excel, PDF
- Base de datos Analytics para almacenamiento
- API REST para acceso programatico
- Sistema de permisos y roles (RBAC)
- Segmentacion de datos por usuario
- Auditoria completa de accesos

### 3.2 Fuera de Alcance

- Real-time updates (WebSockets, SSE)
- Modificacion de datos del IVR
- Integracion con sistemas externos (CRM, ERP)
- Notificaciones por email
- Aplicacion movil nativa
- BI avanzado (Machine Learning, predicciones)
- Modificacion del IVR legacy

### 3.3 Supuestos

1. BD IVR estara disponible 24/7 con usuario readonly
2. Estructura de tablas IVR se mantendra estable (tbl_historico_tX_YYYY)
3. ETL cada 6-12 horas es suficiente (no real-time)
4. Dashboard actualizado manualmente por usuario (F5) es aceptable
5. Infraestructura para MySQL Analytics esta disponible
6. Equipo tiene acceso a Dev Containers con CPython 3.12.6

### 3.4 Restricciones

**Tecnicas:**
1. BD IVR: Solo SELECT, zero escritura (CRITICO)
2. Sesiones: Almacenadas en MySQL, NO Redis
3. Notificaciones: Solo buzon interno, NO email
4. Actualizacion: Via ETL batch, NO real-time
5. JWT tokens: Access 15min, refresh 7 dias

**Operacionales:**
6. ETL no debe impactar performance del IVR (ejecutar en ventanas de baja carga)
7. Dashboard debe soportar 50 usuarios concurrentes
8. Exportaciones limitadas por rol (cuotas diarias)

**Regulatorias:**
9. Auditoria completa de accesos (ISO 27001)
10. Retencion de datos: 3 anos online

---

## 4. Stakeholders Afectados

| Stakeholder | Rol | Interes | Impacto | Influencia |
|-------------|-----|---------|---------|------------|
| Director de Operaciones | Sponsor | Alto - Visibilidad estrategica | Positivo - Mejor toma decisiones | Alta |
| Gerente Call Center | Usuario primario | Alto - Metricas en tiempo casi real | Positivo - Deteccion temprana problemas | Alta |
| Coordinadores Operaciones | Usuarios frecuentes | Alto - Dashboard diario | Positivo - Reduccion trabajo manual | Media |
| Analistas Negocio | Usuarios intensivos | Alto - Menos reportes manuales | Positivo - Mas tiempo analisis vs reportes | Media |
| Supervisores Atencion | Usuarios ocasionales | Medio - Consulta metricas equipo | Positivo - Visibilidad rendimiento | Media |
| Equipo Tecnico IVR | Proveedor datos | Medio - Asegurar zero impacto IVR | Neutral - Si ETL es readonly | Alta |
| Auditoria Interna | Regulador | Medio - Trazabilidad accesos | Positivo - Mejor auditoria | Media |

---

## 5. Criterios de Exito

### 5.1 Metricas de Exito (KPIs)

| KPI | Baseline Actual | Target | Metodo de Medicion |
|-----|-----------------|--------|--------------------|
| Rezago de datos | 24 horas | 6-12 horas | Timestamp ultima actualizacion dashboard |
| Tiempo generacion reportes | 15 h/semana | 3 h/semana | Time tracking analistas |
| Tiempo deteccion problemas | 8-12 horas | <1 hora | Logs alertas vs logs incidentes |
| Carga dashboard | N/A | <3 segundos | Metricas performance (P95) |
| Adopcion usuarios | 0% | >80% gerentes/analistas | Analytics uso sistema |
| Satisfaccion usuarios | No medido | >8/10 | Encuesta trimestral |
| Exportaciones automaticas | 0/semana | >20/semana | Contador exportaciones |

### 5.2 Criterios de Aceptacion del Negocio

1. **Dashboard funcional**: 10 widgets priorizados implementados y cargando en <3 segundos
2. **ETL automatizado**: Ejecucion cada 6-12 horas sin intervencion manual, con validacion de datos
3. **Reduccion trabajo manual**: Analistas reportan reduccion 80% tiempo reportes (de 15h a 3h/semana)
4. **Adopcion**: Minimo 80% de gerentes y coordinadores usan dashboard semanalmente
5. **Zero impacto IVR**: Confirmacion equipo tecnico IVR que no hay degradacion performance
6. **Trazabilidad**: 100% accesos auditados y trazables

---

## 6. Analisis de Alternativas

### 6.1 Opciones Evaluadas

#### Opcion 1: Dashboard IACT (Recomendada)
- **Descripcion**: Sistema custom con Django + DRF, ETL batch, dashboard widgets
- **Pros**:
 - Control total sobre funcionalidad
 - Cumple TODAS las restricciones (no email, readonly IVR, sesiones BD)
 - Integracion nativa con BD IVR legacy
 - ETL configurable (6-12h) sin real-time complejo
- **Contras**:
 - Desarrollo custom (tiempo inicial)
 - Mantenimiento interno
- **Costo estimado**: $80,000 desarrollo + $15,000/ano mantenimiento
- **Tiempo estimado**: 6 meses

#### Opcion 2: BI Comercial (Tableau, Power BI)
- **Descripcion**: Licencias BI comercial con conectores a MySQL
- **Pros**:
 - Herramienta madura
 - Menos desarrollo custom
 - Visualizaciones avanzadas
- **Contras**:
 - Costo licencias perpetuo (~$70/usuario/mes = $50,400/ano para 60 usuarios)
 - NO cumple restricciones (requiere real-time, email notifications)
 - Menor control sobre permisos granulares
 - Complejidad segmentacion de datos
- **Costo estimado**: $50,400/ano licencias + $30,000 configuracion inicial
- **Tiempo estimado**: 4 meses

#### Opcion 3: Reportes Excel Mejorados (Status Quo+)
- **Descripcion**: Macros VBA, conexiones ODBC, templates mejorados
- **Pros**:
 - Bajo costo inicial
 - Analistas familiarizados con Excel
- **Contras**:
 - Sigue siendo manual
 - No resuelve problema de rezago
 - No dashboard centralizado
 - Propenso a errores
 - No escalable
- **Costo estimado**: $5,000
- **Tiempo estimado**: 2 meses

### 6.2 Recomendacion

**Opcion seleccionada**: Opcion 1 - Dashboard IACT

**Justificacion**:

1. **Cumplimiento restricciones**: Unica opcion que cumple 100% restricciones tecnicas (no email, BD readonly, sesiones BD, no real-time)
2. **ROI superior**: Payback 11 meses vs Tableau perpetuo $50k/ano
3. **Control total**: Permisos granulares, segmentacion, auditoria customizada
4. **Sostenibilidad**: Mantenimiento interno, no dependencia vendor
5. **Especificidad**: Diseñado especificamente para flujo IVR del call center

---

## 7. Roadmap de Implementacion

### 7.1 Fases Propuestas

| Fase | Descripcion | Duracion | Dependencias |
|------|-------------|----------|--------------|
| Fase 1 | Autenticacion y permisos (RBAC) | 6 semanas | Ninguna |
| Fase 2 | ETL automatizado (IVR readonly → Analytics) | 8 semanas | Fase 1 |
| Fase 3 | Dashboard con 10 widgets priorizados | 10 semanas | Fase 2 |
| Fase 4 | Sistema de alertas (buzon interno) | 4 semanas | Fase 3 |
| Fase 5 | Exportaciones CSV/Excel/PDF | 4 semanas | Fase 3 |
| Fase 6 | Optimizaciones y ajustes | 4 semanas | Fase 5 |

**Duracion total: 24 semanas (6 meses)**

### 7.2 Hitos Principales

- Semana 6: Autenticacion y RBAC funcionando
- Semana 14: ETL automatizado extrayendo datos IVR
- Semana 24: Dashboard completo en produccion con 10 widgets
- Semana 28: Alertas y exportaciones funcionando
- Semana 32: Sistema optimizado y estable

---

## 8. Derivacion a Requisitos

Esta necesidad se descompone en los siguientes requisitos:

### 8.1 Requisitos de Negocio (Business Requirements)

- RN-001: Sistema de analytics de IVR con datos actualizados cada 6-12 horas

### 8.2 Requisitos de Stakeholders

- RS-001: Gerentes requieren dashboard con metricas consolidadas
- RS-002: Analistas requieren exportaciones automaticas
- RS-003: Auditoria requiere trazabilidad completa de accesos

### 8.3 Requisitos Funcionales

- RF-007: Proceso ETL automatizado configurable
- RF-008: Validacion de datos extraidos del IVR
- RF-012: Dashboard con 10 widgets priorizados
- RF-013: Filtros de fecha (15 presets + rango personalizado)
- RF-014: Exportacion CSV/Excel/PDF
- RF-015: Sistema de alertas por buzon interno

### 8.4 Requisitos No Funcionales

- RNF-003: ETL debe completar en <30 minutos
- RNF-004: Dashboard carga en <3 segundos
- RNF-005: Disponibilidad 99.9% (8.76h downtime/ano)

---

## 9. Trazabilidad

### 9.1 Trazabilidad Upward (Origen)

Esta necesidad esta alineada con:

- **Objetivo estrategico**: OE-2025-01 "Mejorar eficiencia operativa mediante datos y analytics"
- **Iniciativa corporativa**: INIT-ANALYTICS-2025 "Transformacion digital call center"
- **Pain point**: Falta de visibilidad operativa en tiempo oportuno

### 9.2 Trazabilidad Downward (Derivados)

Esta necesidad genera:

- **Requisitos de negocio**: RN-001
- **Requisitos de stakeholders**: RS-001, RS-002, RS-003
- **Requisitos funcionales**: RF-007, RF-008, RF-012, RF-013, RF-014, RF-015
- **Requisitos no funcionales**: RNF-003, RNF-004, RNF-005
- **Proyecto**: IACT - IVR Analytics & Customer Tracking
- **Entregables**: Dashboard web, ETL automatizado, API REST, sistema alertas

---

## 10. Riesgos Identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigacion |
|----|--------|--------------|---------|------------|
| R-01 | Estructura BD IVR cambia sin aviso | Media | Alto | Adapter pattern, versionado queries, alertas validacion |
| R-02 | ETL impacta performance IVR | Baja | Critico | Usuario readonly, ejecutar ventanas baja carga, monitoreo |
| R-03 | Adopcion baja por resistencia cambio | Media | Medio | Training, champions, feedback loops, iteraciones |
| R-04 | Datos IVR con calidad baja (nulls, duplicados) | Alta | Medio | Validaciones exhaustivas, limpieza automatica, reportes calidad |
| R-05 | Dashboard lento con grandes volumenes | Media | Alto | Indices, cache, paginacion, optimizacion queries |

---

## 11. Aprobaciones

| Rol | Nombre | Fecha | Firma/Aprobacion |
|-----|--------|-------|------------------|
| Sponsor | Director Operaciones | 2025-11-06 | Aprobado |
| BA Lead | Business Analyst Lead | 2025-11-06 | Aprobado |
| PMO | Project Management Office | 2025-11-06 | Aprobado |
| Tech Lead | Technical Lead Backend | 2025-11-06 | Revisado |
| Gerente Call Center | Gerente Call Center | 2025-11-06 | Aprobado |

---

## 12. Referencias

### 12.1 Documentos Relacionados

- Analisis sistema IVR legacy: `docs/arquitectura/ivr_legacy_analysis.md`
- Codigo ETL: `api/callcentersite/callcentersite/apps/etl/`
- Codigo Dashboard: `api/callcentersite/callcentersite/apps/dashboard/`
- Codigo Reports: `api/callcentersite/callcentersite/apps/reports/`

### 12.2 Estandares Aplicados

- **BABOK v3**: Knowledge Area - Business Analysis Planning and Monitoring
- **ISO/IEC/IEEE 29148:2018**: Clause 6.2 - Business Analysis Process
- **PMBOK Guide 7th Ed**: Principle-Based Approach to Project Management

---

## Control de Cambios

| Version | Fecha | Autor | Descripcion del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-06 | BA Team | Creacion inicial - Necesidad principal sistema IACT |

---

**Notas:**

Esta es la necesidad de negocio FUNDAMENTAL del sistema IACT. Todo el sistema (ETL, dashboard, reportes, alertas) deriva de esta necesidad de obtener visibilidad de las metricas operativas del IVR en tiempo casi real (6-12 horas vs 24 horas actual).

El sistema NO es para prevenir fraude - es para analytics y tracking de operaciones del call center.
