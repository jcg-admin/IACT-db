---
id: N-003
tipo: necesidad
titulo: Visibilidad de metricas operativas en tiempo casi real
dominio: backend
owner: equipo-backend
prioridad: media
estado: aprobado
fecha_creacion: 2025-11-06
sponsor: director-operaciones
stakeholders:
 - director-operaciones
 - gerentes-callcenter
 - analistas-negocio
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "6.2"
valor_negocio: medio
urgencia: media
date: 2025-11-13
---

# N-003: Visibilidad de metricas operativas en tiempo casi real

## 1. Descripcion de la Necesidad

### 1.1 Problema u Oportunidad

Gerentes y directores necesitan visibilidad consolidada de metricas operativas del call center para monitorear performance, identificar tendencias y tomar decisiones. Actualmente, los datos estan dispersos en multiples reportes y requieren analisis manual, consumiendo 10-15 horas/semana en generacion de reportes.

**Impacto actual:**
- 10-15 horas/semana generando reportes manualmente
- Metricas dispersas en multiples fuentes
- Falta dashboard consolidado para decision makers
- Imposibilidad de filtrar por periodos personalizados

### 1.2 Situacion Deseada (To-Be)

**Proceso objetivo:**
- Dashboard con 10 widgets configurables
- Filtros de fecha (15 presets: hoy, ayer, ultimos 7 dias, etc.)
- Exportacion CSV/Excel/PDF
- Actualizacion automatica cada 6-12 horas (via ETL)

**Beneficios esperados:**
- Reduccion de 80% en tiempo generacion reportes (de 15h a 3h/semana)
- Visibilidad consolidada en dashboard unico
- Decision makers con informacion al alcance

---

## 2. Alcance

### 2.1 En Alcance

- Dashboard con 10 widgets de metricas
- 15 filtros de fecha predefinidos
- Exportacion CSV/Excel/PDF
- Actualizacion via ETL (NO real-time)

### 2.2 Fuera de Alcance

- Dashboard en tiempo real (limitacion: ETL batch)
- Alertas push/email (solo buzon interno)

### 2.3 Restricciones

- Dashboard NO es real-time (actualizacion cada 6-12h via ETL)
- Exportaciones deben generarse en menos de 30 segundos

---

## 3. Derivacion a Requisitos

### 3.1 Requisitos de Negocio

- RN-003: Dashboard analitico para visibilidad operativa

### 3.2 Requisitos de Stakeholders

- RS-004: Gerentes necesitan metricas consolidadas

### 3.3 Requisitos Funcionales

- RF-012: Dashboard con 10 widgets configurables
- RF-013: Filtros de fecha (15 presets)
- RF-014: Exportacion CSV/Excel/PDF

### 3.4 Requisitos No Funcionales

- RNF-004: Dashboard carga en menos de 3 segundos

---

## 4. Trazabilidad

### 4.1 Trazabilidad Downward

- RN-003, RS-004, RF-012, RF-013, RF-014, RNF-004

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
