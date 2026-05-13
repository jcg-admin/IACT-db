# Análisis de Cobertura de Requisitos vs Implementación Backend

**Fecha:** 2025-11-11
**Analizador:** Requirements Coverage Analysis
**Método:** Mapeo bidireccional requisitos <-> código

---

## Resumen Ejecutivo

**HALLAZGO CRÍTICO:** Existe una brecha significativa entre la implementación del backend y los requisitos documentados. El módulo más grande y problemático del sistema (dora_metrics) NO tiene requisitos funcionales documentados.

### Métricas Clave

- **Apps Django Backend:** 26 apps identificadas
- **Requisitos Funcionales Documentados:** 16 RF
- **Apps SIN requisitos:** 20+ apps (77%)
- **Módulos críticos sin requisitos:** dora_metrics, data_centralization

---

## 1. Cobertura de Requisitos por Módulo Backend

### 1.1 Módulos CON Cobertura de Requisitos

| Módulo Backend | Requisitos Relacionados | Estado Cobertura |
|----------------|------------------------|------------------|
| authentication | RF-001, RF-002, RF-005, RF-006, RF-007, RF-008, RF-009, RF-010 | Buena (8 RF) |
| permissions | RF-001, RF-002, RF-003 | Parcial (3 RF) |
| users | RF-001, RF-005, RF-010 | Parcial (compartido con auth) |
| audit | RS-001, RNF-001 | Básica (2 req) |

### 1.2 Módulos SIN Cobertura de Requisitos

| Módulo Backend | Líneas Código | Score Calidad | Urgencia Documentación |
|----------------|---------------|---------------|------------------------|
| **dora_metrics** | ~4,000+ | 0.55/1.00 | CRÍTICA |
| **data_centralization** | ~1,500+ | 0.65/1.00 | ALTA |
| **dashboard** | ~800+ | No analizado | ALTA |
| **reportes** | ~600+ | No analizado | ALTA |
| **etl** | ~500+ | No analizado | ALTA |
| analytics | ~400+ | No analizado | MEDIA |
| notifications | ~300+ | No analizado | MEDIA |
| alertas | ~200+ | No analizado | MEDIA |
| metricas | ~200+ | No analizado | MEDIA |
| llamadas | ~150+ | No analizado | BAJA |
| tickets | ~100+ | No analizado | BAJA |
| clientes | ~100+ | No analizado | BAJA |
| equipos | ~80+ | No analizado | BAJA |
| horarios | ~60+ | No analizado | BAJA |
| politicas | ~50+ | No analizado | BAJA |
| presupuestos | ~40+ | No analizado | BAJA |
| excepciones | ~30+ | No analizado | BAJA |
| configuracion | ~20+ | No analizado | BAJA |
| ivr_legacy | ~15+ | No analizado | BAJA |
| common | ~10+ | No analizado | BAJA |

**Total módulos sin requisitos:** 20+ módulos (77% del backend)

---

## 2. Análisis del GAP Crítico: dora_metrics

### 2.1 Implementación Actual

**Módulo:** `api/callcentersite/dora_metrics/`

**Archivos principales:**
- `views.py` - 981 líneas (God Class con 36 métodos)
- `auto_remediation.py` - 455 líneas
- `advanced_analytics.py` - 547 líneas
- `data_ecosystem.py` - 634 líneas
- `models.py` - ~200 líneas estimadas
- `serializers.py` - ~150 líneas estimadas

**Total estimado:** ~4,000+ líneas de código

**Funcionalidad implementada (inferida del análisis arquitectural):**
- Sistema de métricas DORA (Deployment Frequency, Lead Time, MTTR, Change Failure Rate)
- Auto-remediación de problemas
- Analytics avanzados con ML
- Integración de ecosistema de datos
- Dashboards y visualizaciones
- Reportes y exportaciones

### 2.2 Requisitos Documentados

**Requisitos específicos de dora_metrics:** 0

**Búsqueda realizada:**
- Grep por "dora" en `docs/backend/requisitos/`: 0 resultados
- Grep por "DORA" en `docs/backend/requisitos/`: 0 resultados
- Grep por "deployment frequency": 0 resultados
- Grep por "lead time": 0 resultados
- Grep por "MTTR": 0 resultados
- Grep por "change failure": 0 resultados

### 2.3 Impacto del GAP

**Riesgos identificados:**

1. **Trazabilidad inexistente:** No se puede trazar el código a necesidades de negocio
2. **Validación imposible:** No hay criterios de aceptación documentados
3. **Mantenimiento dificultado:** Desarrolladores no saben QUÉ debe hacer el sistema
4. **Refactoring arriesgado:** Sin requisitos, cualquier cambio puede romper funcionalidad esperada
5. **Testing incompleto:** Sin especificaciones, tests no validan comportamiento correcto
6. **Onboarding lento:** Nuevos desarrolladores no entienden el propósito del módulo

**Costos estimados:**

- **Deuda técnica:** Alta (score 0.55/1.00 indica problemas arquitecturales graves)
- **Esfuerzo de comprensión:** ~40 horas para entender 4,000 líneas sin documentación
- **Riesgo de regresión:** Alto (cambios pueden romper funcionalidad no documentada)

---

## 3. Relación con Necesidades Documentadas

### 3.1 Necesidades de Negocio Existentes

**N-001:** Obtener visibilidad de métricas operativas del IVR en tiempo casi real
- **Relacionado con:** dashboard, etl, analytics, reportes
- **NO menciona:** dora_metrics específicamente

**N-002:** Datos actualizados para toma de decisiones
- **Relacionado con:** dashboard, analytics
- **NO menciona:** dora_metrics

**N-003:** Visibilidad de métricas operativas
- **Relacionado con:** dashboard, metricas
- **NO menciona:** dora_metrics

### 3.2 Interpretación

Las necesidades documentadas (N-001, N-002, N-003) se enfocan en:
- Métricas operativas del IVR (llamadas, colas, tiempos)
- Dashboard de visualización
- Analytics de datos del call center

**NO cubren:**
- Métricas DORA (métricas de ingeniería de software)
- Auto-remediación
- Advanced analytics con ML
- Data ecosystem integration

**Pregunta crítica:** ¿dora_metrics es un módulo fuera del alcance original del proyecto IACT?

---

## 4. Casos de Uso Documentados vs Implementados

### 4.1 Casos de Uso con Diagramas (pero sin especificación completa)

| ID | Nombre | Diagramas | Especificación | Estado |
|----|--------|-----------|----------------|--------|
| UC-001 | Generar Reporte de Métricas | Sí (3 diagramas) | NO | Incompleto |
| UC-002 | Registrar Llamada Entrante | Sí (3 diagramas) | NO | Incompleto |
| UC-003 | Consultar Estado de Pedido | Sí (3 diagramas) | NO | Incompleto |

**Diagrama types disponibles:**
- Use Case Diagram (.puml)
- Sequence Diagram (.puml)
- Activity Diagram (.puml)

**Faltante:**
- Especificación textual completa (frontmatter YAML, flujos, precondiciones, postcondiciones)
- Casos de uso para funcionalidad DORA
- Casos de uso para ETL
- Casos de uso para alertas/notificaciones

### 4.2 Casos de Uso Implementados (código) pero NO Documentados

**Inferidos del código (dora_metrics):**
- UC-DM-001: Calcular métricas DORA
- UC-DM-002: Ejecutar auto-remediación
- UC-DM-003: Analizar tendencias con ML
- UC-DM-004: Integrar datos del ecosistema
- UC-DM-005: Generar dashboard DORA
- UC-DM-006: Exportar reportes DORA

**Inferidos del código (otros módulos):**
- UC-ETL-001: Ejecutar extracción de datos IVR
- UC-ETL-002: Validar calidad de datos
- UC-DASH-001: Visualizar métricas en dashboard
- UC-REP-001: Generar reporte CSV/Excel/PDF
- UC-ALERT-001: Configurar alertas
- UC-ALERT-002: Recibir notificaciones

**Total casos de uso sin documentar:** 12+ casos críticos

---

## 5. Problemas de Calidad de Datos en Requisitos

### 5.1 Inconsistencias en IDs

**Problema:** IDs duplicados en SRS (Software Requirements Specification)

```
RF-001: Sistema de evaluación de permisos (backend)
RF-001: Login con credenciales (backend) # DUPLICADO

RF-002: Generación de tokens JWT (backend)
RF-002: Gestión de permisos granulares (backend) # DUPLICADO

RF-003: Bloqueo automático tras 5 intentos fallidos
RF-003: Obtener permisos efectivos usuario # DUPLICADO

RF-004: Sesión única con cierre sesiones previas
RF-004: Segmentación de usuarios # DUPLICADO

RF-005: Logout manual con invalidación tokens
RF-005: Login con credenciales locales # DUPLICADO

RF-006: Recuperación de password sin email
RF-006: Generación y validación tokens JWT # DUPLICADO
```

**Causa:** Múltiples fuentes de requisitos sin consolidación (autenticación legacy vs nueva)

**Impacto:**
- Confusión sobre qué requisito es válido
- Imposible generar RTM (Requirements Traceability Matrix) correcto
- Tests pueden validar requisito equivocado

### 5.2 Trazabilidad Corrupta

**Problema:** Campo `deriva_de` con datos malformados

```yaml
# En docs/requisitos/srs_software_requirements.md línea 56
deriva_de: [, N, -, 0, 0, 1, ,, , R, N, -, 0, 0, 1, ,, , R, S, -, 0, 0, 2, ]
```

**Esperado:**
```yaml
deriva_de:
 - N-001
 - RN-001
 - RS-002
```

**Causa:** Error en script de generación de índices (`generar_indices.py`)

**Impacto:**
- RTM inservible
- Imposible rastrear origen de requisitos
- Auditoría de cumplimiento ISO 29148 fallará

### 5.3 Estado Inconsistente

**Problema:** Requisitos marcados como "aprobado" pero módulo tiene score 0.55/1.00

```
RF-001: Login con credenciales - Estado: aprobado
RF-002: Generación tokens JWT - Estado: aprobado
...
```

**Pero:**
- Código tiene 68 violaciones SOLID
- 9 issues críticos
- 174 issues alta prioridad

**Interpretación:**
- Requisitos están aprobados (QUÉ)
- Implementación es deficiente (CÓMO)
- Necesita refactoring manteniendo requisitos

---

## 6. Recomendaciones Prioritarias

### 6.1 URGENTE (Esta semana)

1. **Documentar dora_metrics:**
 - Crear N-004: Necesidad de métricas DORA
 - Crear RN-004: Requisito de negocio para ingeniería de software
 - Crear RF-020 a RF-030: Requisitos funcionales DORA (10-15 RF)
 - Crear UC-DM-001 a UC-DM-006: Casos de uso DORA

2. **Completar especificaciones UC existentes:**
 - UC-001: Generar Reporte de Métricas (agregar especificación textual)
 - UC-002: Registrar Llamada Entrante (agregar especificación textual)
 - UC-003: Consultar Estado de Pedido (agregar especificación textual)

3. **Corregir IDs duplicados:**
 - Renumerar requisitos conflictivos
 - Consolidar autenticación legacy + nueva
 - Regenerar índices con IDs únicos

### 6.2 ALTA PRIORIDAD (Próximas 2 semanas)

4. **Documentar módulos críticos:**
 - data_centralization (RF-031 a RF-040)
 - dashboard (RF-041 a RF-050)
 - reportes (RF-051 a RF-055)
 - etl (RF-056 a RF-065)

5. **Crear casos de uso faltantes:**
 - UC-ETL-001 a UC-ETL-002 (ETL)
 - UC-DASH-001 (Dashboard)
 - UC-REP-001 (Reportes)
 - UC-ALERT-001 a UC-ALERT-002 (Alertas)

6. **Corregir trazabilidad:**
 - Fix script `generar_indices.py`
 - Regenerar StRS, BRS, SRS con trazabilidad correcta
 - Validar RTM completo

### 6.3 MEDIA PRIORIDAD (Próximo mes)

7. **Documentar módulos restantes:**
 - analytics, notifications, alertas, metricas (RF-066 a RF-080)
 - Módulos auxiliares (llamadas, tickets, clientes, etc.) (RF-081+)

8. **Crear matriz de cobertura:**
 - Mapeo Código → Requisitos
 - Mapeo Requisitos → Tests
 - Identificar código huérfano (sin requisitos)

---

## 7. Métricas de Éxito

| Métrica | Actual | Target | Fecha Target |
|---------|--------|--------|--------------|
| Apps con requisitos | 4/26 (15%) | 26/26 (100%) | 2025-12-31 |
| Requisitos funcionales | 16 RF | 80+ RF | 2025-12-15 |
| Casos de uso completos | 0/3 (0%) | 15/15 (100%) | 2025-12-01 |
| IDs duplicados | 6 duplicados | 0 duplicados | 2025-11-18 |
| Trazabilidad corrupta | ~10 requisitos | 0 requisitos | 2025-11-18 |
| Cobertura dora_metrics | 0% | 100% | 2025-11-25 |

---

## 8. Próximos Pasos Inmediatos

### Paso 1: Entender dora_metrics (2 horas)
- [ ] Leer código `dora_metrics/views.py`
- [ ] Identificar funcionalidad principal
- [ ] Listar endpoints API
- [ ] Mapear modelos de datos

### Paso 2: Documentar necesidad DORA (1 hora)
- [ ] Crear `N-004_metricas_dora_ingenieria_software.md`
- [ ] Justificación de negocio
- [ ] Alcance y restricciones

### Paso 3: Crear requisitos funcionales DORA (4 horas)
- [ ] RF-020 a RF-030 (10-15 requisitos)
- [ ] Vinculación con código existente
- [ ] Criterios de aceptación

### Paso 4: Completar UC-001, UC-002, UC-003 (3 horas)
- [ ] Agregar especificación textual con formato YAML
- [ ] Flujos principales y alternos
- [ ] Vincular con requisitos

### Paso 5: Corregir problemas de calidad (2 horas)
- [ ] Fix IDs duplicados
- [ ] Fix trazabilidad corrupta
- [ ] Regenerar índices

**Tiempo total estimado:** 12 horas

---

## Referencias

- [Backend Analysis Results](./README.md)
- [Architecture Analysis](./analisis_arquitectura_completo.puml)
- [Stakeholder Requirements](../../requisitos/strs_stakeholder_requirements.md)
- [Business Requirements](../../requisitos/brs_business_requirements.md)
- [Software Requirements](../../requisitos/srs_software_requirements.md)
- [Use Case Guide](../../gobernanza/casos_de_uso_guide.md)

---

**Generado:** 2025-11-11
**Autor:** Requirements Coverage Analysis
**Estado:** Análisis completado, recomendaciones pendientes de implementación
