---
id: N-002
tipo: necesidad
titulo: Datos actualizados para toma de decisiones oportunas
dominio: backend
owner: equipo-backend
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
sponsor: gerente-operaciones
stakeholders:
 - gerente-operaciones
 - analistas-negocio
 - gerentes-callcenter
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "6.2"
valor_negocio: alto
urgencia: alta
date: 2025-11-13
---

# N-002: Datos actualizados para toma de decisiones oportunas

## 1. Descripcion de la Necesidad

### 1.1 Problema u Oportunidad

El sistema IACT analiza metricas operativas de call center extrayendo datos de sistema IVR legacy. Actualmente, los datos presentados en dashboard estan desactualizados (rezago de 12-24 horas), impidiendo a gerentes y analistas tomar decisiones oportunas sobre asignacion de recursos, identificacion de problemas, y optimizacion de operaciones.

**Impacto actual:**
- Gerentes toman decisiones con datos de ayer (rezago 12-24 horas)
- Problemas operativos detectados con 1 dia de retraso
- Imposibilidad de realizar ajustes en tiempo cercano al real
- 10-15 decisiones suboptimas por semana por falta de datos frescos

### 1.2 Situacion Actual (As-Is)

**Proceso actual:**
- ETL manual ejecutado 1 vez/dia (overnight)
- Datos IVR extraidos en batch diario
- Sin validacion automatica de calidad de datos
- Errores ETL detectados manualmente (1-2 dias despues)

**Impacto negativo:**
- Datos dashboard obsoletos (12-24 horas rezago)
- Decisiones basadas en informacion desactualizada
- 15-20 horas/mes investigando errores ETL

### 1.3 Situacion Deseada (To-Be)

**Proceso objetivo:**
- ETL automatizado cada 6-12 horas
- Validacion automatica de datos IVR
- Alertas automaticas ante errores ETL
- Datos dashboard con rezago menor 12 horas

**Beneficios esperados:**
- Reduccion de rezago de 24h a 6-12h (mejora 50-75%)
- Deteccion de problemas operativos en mismo dia
- Reduccion de 80% en tiempo investigacion errores ETL

---

## 2. Alcance

### 2.1 En Alcance

- Proceso ETL automatizado cada 6-12 horas
- Extraccion de datos desde BD IVR (readonly)
- Transformacion y validacion de datos
- Carga en BD Analytics MySQL
- Alertas via buzon interno ante errores

### 2.2 Fuera de Alcance

- Modificaciones en BD IVR legacy (CRITICO: readonly)
- ETL en tiempo real (streaming)
- Machine Learning para predicciones

### 2.3 Restricciones

- **CRITICO**: BD IVR readonly - ZERO escritura
- ETL debe completar en menor 30 minutos
- NO usar email para alertas (solo buzon interno)

---

## 3. Derivacion a Requisitos

### 3.1 Requisitos de Negocio

- RN-002: Sistema ETL automatizado para datos actualizados

### 3.2 Requisitos de Stakeholders

- RS-003: Analistas necesitan datos frescos (rezago menor 12h)

### 3.3 Requisitos Funcionales

- RF-007: Proceso ETL configurable cada 6-12 horas
- RF-008: Validacion automatica de datos IVR

### 3.4 Requisitos No Funcionales

- RNF-003: ETL debe completar en menos de 30 minutos

---

## 4. Trazabilidad

### 4.1 Trazabilidad Downward

- RN-002, RS-003, RF-007, RF-008, RNF-003

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
