---
id: RS-002
tipo: stakeholder
titulo: Reportes automatizados de compliance
dominio: backend
owner: equipo-ba
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
fecha_aprobacion: 2025-11-06

stakeholder_primario: compliance-officer
stakeholder_tipo: gerente

trazabilidad_upward:
 - N-001
 - RN-001

trazabilidad_downward:
 - RF-002
 - RF-003
 - RNF-001

stakeholders_secundarios:
 - auditor-interno
 - legal

contexto_uso: Preparación de auditorías trimestrales
frecuencia_uso: mensual
criticidad_operacional: alta

iso29148_clause: "9.4"
babok_knowledge_area: "Requirements Analysis and Design Definition"
verificacion_metodo: demonstration

categoria_ux: usabilidad
impacto_experiencia: alto
date: 2025-11-13
---

# RS-002: Reportes automatizados de compliance

## 1. Descripción del Requisito de Stakeholder

### 1.1 Declaración del Requisito

**Como** Compliance Officer,
**Necesito** generar automáticamente reportes de compliance (GDPR, SOC2, ISO 27001) que muestren trazabilidad completa de accesos y modificaciones en datos sensibles,
**Para** reducir de 40 horas a 8 horas el tiempo de preparación para auditorías trimestrales y demostrar compliance verificable.

### 1.2 Descripción Narrativa

El Compliance Officer es responsable de preparar evidencias para auditorías externas trimestrales (GDPR, SOC2, ISO 27001). Actualmente, este proceso es 100% manual, requiere 40 horas de análisis de logs dispersos en múltiples sistemas, y resulta en reportes inconsistentes que deben ser re-trabajados.

**¿Qué necesita el stakeholder?**
- Generación automática de reportes de compliance con 1 click
- Reporte GDPR: accesos a datos personales, modificaciones, eliminaciones
- Reporte SOC2: controles de acceso, intentos no autorizados, cambios en permisos
- Reporte ISO 27001: log completo de eventos de seguridad
- Exportación en PDF y CSV para auditores externos

**¿Por qué lo necesita?**
- Reducir trabajo manual de 40h a 8h por auditoría (80% reducción)
- Garantizar consistencia y completitud de evidencias
- Demostrar compliance verificable ante auditores

**¿Cuándo y dónde lo necesita?**
- 1 semana antes de cada auditoría trimestral
- Acceso desde oficina o remoto para revisión previa a entrega

---

## 2. Perfil del Stakeholder

| Atributo | Valor |
|----------|-------|
| Nombre/Rol | Compliance Officer |
| Departamento/Área | Legal/Compliance |
| Nivel jerárquico | Gerencial |
| Experiencia técnica | Media |
| Frecuencia de interacción con sistema | Mensual (pre-auditoría) |
| Canales de acceso | Desktop, Laptop |
| Idioma preferido | Español |

**Puntos de dolor actuales:**
- Extracción manual de logs de múltiples sistemas (8 horas)
- Análisis manual en Excel (20 horas)
- Formateo de reportes para auditores (12 horas)
- Riesgo de información incompleta o incorrecta

---

## 3. Criterios de Aceptación del Stakeholder

### 3.1 Criterios en Formato Gherkin

#### Escenario 1: Generación de reporte GDPR

```gherkin
Given soy Compliance Officer autenticado
 And existen registros de auditoría de los últimos 90 días
When selecciono "Generar Reporte GDPR"
 And selecciono rango de fechas (último trimestre)
 And hago click en "Generar"
Then el sistema genera reporte en <60 segundos
 And el reporte incluye:
 - Total de accesos a datos personales
 - Modificaciones en datos personales (con before/after)
 - Eliminaciones de datos (GDPR Right to be Forgotten)
 - Desglose por tipo de dato (nombre, email, teléfono, dirección)
And puedo exportar en PDF y CSV
```

#### Escenario 2: Generación de reporte SOC2 (controles de acceso)

```gherkin
Given soy Compliance Officer autenticado
When selecciono "Generar Reporte SOC2"
 And selecciono rango de fechas
Then el sistema genera reporte que incluye:
 - Total de intentos de login (exitosos y fallidos)
 - Intentos de acceso no autorizado (con detalles)
 - Cambios en permisos de usuarios
 - Accesos a recursos críticos
And cada evento muestra: timestamp, usuario, acción, resultado, IP
```

#### Escenario 3: Validación de completitud del reporte

```gherkin
Given he generado un reporte de compliance
When reviso el reporte
Then veo un resumen ejecutivo con:
 - Rango de fechas cubierto
 - Total de eventos auditados
 - Porcentaje de cobertura (100% esperado)
 - Fecha/hora de generación del reporte
And el reporte incluye firma digital para verificar integridad
```

---

## 4. Valor para el Stakeholder

### 4.1 Beneficios Directos

| Beneficio | Descripción | Impacto | Medición |
|-----------|-------------|---------|----------|
| Ahorro de tiempo | Reducir preparación auditoría de 40h a 8h | Alto | 32 horas ahorradas/trimestre |
| Consistencia | Reportes estandarizados sin errores manuales | Alto | 0 re-trabajos por errores |
| Confianza auditores | Evidencias completas y verificables | Alto | Satisfacción auditor 9/10 |

### 4.2 Impacto en el Trabajo del Stakeholder

**Antes (sin este requisito):**
- Tiempo invertido: 40 horas/trimestre en preparación manual
- Errores: 20-30% de reportes requieren re-trabajo
- Frustración: Trabajo manual repetitivo de bajo valor

**Después (con este requisito):**
- Tiempo invertido: 8 horas/trimestre (generar + revisar)
- Errores: <5% requieren ajustes menores
- Satisfacción: Tiempo liberado para análisis estratégico

---

## 5. Escenarios de Uso

### 5.1 Escenario Principal de Uso

**Título:** Preparación para auditoría trimestral GDPR

**Actor:** Compliance Officer

**Precondiciones:**
- Compliance Officer autenticado
- Sistema de auditoría con datos de último trimestre

**Flujo Principal:**
1. Compliance Officer accede a módulo "Reportes de Compliance"
2. Selecciona "Reporte GDPR Q4 2025"
3. Configura rango de fechas: 2025-10-01 a 2025-12-31
4. Hace click en "Generar Reporte"
5. Sistema procesa datos y genera reporte en 45 segundos
6. Compliance Officer revisa resumen ejecutivo
7. Exporta reporte en PDF para auditor externo
8. Guarda copia en CSV para análisis interno

**Postcondiciones:**
- Reporte generado y exportado
- Tiempo total: <10 minutos (vs. 40 horas manual)

**Frecuencia de uso:** 4 veces/año (1 por trimestre)

---

## 6. Requisitos de Información

### 6.1 Información que el Stakeholder Necesita Ver en Reportes

| Dato/Información | Propósito | Formato Preferido | Detalle |
|------------------|-----------|-------------------|---------|
| Accesos a datos personales | Compliance GDPR Art. 5 | Tabla con paginación | Usuario, timestamp, tipo dato, acción |
| Modificaciones datos sensibles | Trazabilidad cambios | Tabla con before/after | Old values → New values |
| Intentos acceso no autorizado | Evidencia controles SOC2 | Lista ordenada por fecha | Usuario, recurso, resultado, IP |
| Métricas resumen | Vista ejecutiva | Widgets numéricos | Totales, promedios, tendencias |

---

## 7. Derivación a Requisitos de Sistema/Software

### 7.1 Requisitos Funcionales Derivados

- **RF-002**: Auditoría inmutable de acciones críticas (backend)
 - Proporciona datos fuente para reportes

- **RF-003**: Trazabilidad de cambios en datos sensibles (backend)
 - Captura old_values/new_values para reportes GDPR

- **RF-011**: Interfaz generación reportes compliance (frontend)
 - UI para seleccionar tipo reporte, rango fechas, exportar

### 7.2 Requisitos No Funcionales Derivados

- **RNF-001**: Performance - generación reporte en <60 segundos
- **RNF-002**: Seguridad - reportes solo accesibles por roles autorizados

---

## 8. Validación con el Stakeholder

### 8.1 Plan de Validación

| Hito | Actividad de Validación | Método | Stakeholder(s) | Fecha | Estado |
|------|-------------------------|--------|----------------|-------|--------|
| Hito 1 | Revisión templates reportes | Workshop | Compliance Officer, Auditor Interno | 2025-11-27 | Pendiente |
| Hito 2 | Demo generación reportes | Prototipo | Compliance Officer | 2025-12-18 | Pendiente |
| Hito 3 | Validación con auditor externo | UAT con auditor real | Compliance Officer, Auditor Externo | 2026-01-15 | Pendiente |

---

## 9. Trazabilidad

### 9.1 Trazabilidad Upward (Origen)

| Tipo | ID | Título | Justificación |
|------|----|----|---------------|
| Necesidad | N-001 | Garantizar seguridad operacional y cumplimiento normativo | RS-002 aborda necesidad mediante reportes automatizados |
| Req. Negocio | RN-001 | Sistema de seguridad y auditoría conforme a ISO 27001 | RS-002 implementa capacidad de reporting para compliance |

### 9.2 Trazabilidad Downward (Implementación)

**Requisitos Funcionales:**
- RF-002: Auditoría inmutable de acciones críticas
- RF-003: Trazabilidad de cambios en datos sensibles
- RF-011: Interfaz generación reportes compliance (frontend)

**Requisitos No Funcionales:**
- RNF-001: Performance generación <60s
- RNF-002: Seguridad acceso a reportes

---

## 10. Aprobaciones

| Rol | Nombre | Fecha | Firma/Estado |
|-----|--------|-------|--------------|
| Stakeholder Primario | Compliance Officer | 2025-11-06 | Aprobado |
| Product Owner | Product Manager | 2025-11-06 | Aprobado |
| Business Analyst | BA Lead | 2025-11-06 | Documentado |

---

## 11. Referencias

### 11.1 Documentos Relacionados

- Necesidad origen: ../necesidades/n001_garantizar_seguridad_cumplimiento_normativo.md
- Requisito negocio: ../negocio/rn001_sistema_seguridad_auditoria_conforme_iso27001.md

### 11.2 Estándares Aplicados

- ISO/IEC/IEEE 29148:2018: Clause 9.4 - Stakeholder Requirements Specification
- GDPR: Articles 5, 30 (Records of Processing Activities)
- SOC2: CC6.1, CC6.2, CC6.3
- ISO 27001:2013: A.12.4.1 (Event Logging)

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio | Stakeholder Notificado |
|---------|-------|-------|------------------------|------------------------|
| 1.0 | 2025-11-06 | BA Team | Creación inicial derivado de RN-001 | Sí |
