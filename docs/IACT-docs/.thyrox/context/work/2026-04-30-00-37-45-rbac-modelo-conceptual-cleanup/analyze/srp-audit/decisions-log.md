```yml
created_at: 2026-04-30 03:06:29
project: IACT-docs
work_package: 2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Bitácora de decisiones — Z.2 Cleanup → v5.4.0

> Registro cronológico de análisis, alternativas evaluadas, preguntas
> del ejecutor, respuestas y justificación de cada decisión tomada
> que llevaron al modelo v5.4.0.

---

## D-01 — Renames `delete_*` (no eliminar nada)

### Análisis previo

El ejecutor observó: "no se puede hacer `delete_alerts`, solo se puede
tener un estatus on/off". Trigger: revisión del modelo v5.3.0 propuesta
de bump.

### Búsqueda realizada

Grep en source/normativa/restricciones/ por términos: soft delete, baja
lógica, status on/off, paranoid, tombstone.

Hallazgo: BR-009 Bajas Lógicas existe pero su alcance declarado es
"MOD_Users" únicamente (líneas 88, 115).

### Funciones que violan el principio

- USR-003 `delete_users` — descripción dice "Baja lógica de usuarios"
  pero el verbo `delete` contradice la semántica.
- ALR-005 `delete_alerts` — hard delete real, sin equivalente soft
  documentado.

### Alternativas evaluadas

| Opción | Descripción | Resultado |
|--------|-------------|-----------|
| Mantener nombres + actualizar BR-009 alcance | Conservar `delete_*`, ampliar BR-009 | Rechazado: nombre confunde implementadores |
| Renombrar funciones + actualizar BR-009 | `delete_users` → `deactivate_users`, `delete_alerts` → `disable_alerts` + BR-009 global | **APROBADO** |

### Decisión

**Renames con preservación de IDs (USR-003 y ALR-005).** Más:
extender BR-009 a alcance global de todos los módulos.

### Por qué

1. Nombre debe reflejar comportamiento real (soft delete = deactivate).
2. Preservar IDs preserva trazabilidad de UCs ya corregidos en commit fd9ef31.
3. BR-009 global asegura que el principio aplique consistentemente
   a futuros módulos (no solo MOD_Users).

### Aprobación

Ejecutor (2026-04-30): "SI, SI, SI" a las 3 preguntas (renames +
BR-009 global + ALR-007 acknowledge).

---

## D-02 — Cat E uc-alr-03 acknowledge

### Análisis previo

uc-alr-03 cita ALR-003 `reconoce_alertas`. Modelo v5.3.0 declara
ALR-003 = `configure_team_alerts`. Concepto "acknowledge" no existe
en modelo canónico.

### Búsqueda realizada

Grep en temp-holding/ por: acknowledge_alert, reconoce_alerta,
manage_subscription, alert_subscription, suscripci.

Hallazgo: modelo histórico (pre-v5.2.0) tenía:
- ALR-003 reconoce_alertas (= acknowledge)
- ALR-005 gestiona_suscripciones (= subscription mgmt)

v5.2.0 los eliminó deliberadamente. v5.3.0 hereda esa eliminación.

### Análisis semántico de uc-alr-03

Lectura del UC:
- Marca alerta como ACKNOWLEDGED (state transition: ACTIVE → ACKNOWLEDGED → RESOLVED)
- Closed-loop operativo: registra quién y cuándo
- Workflow distinto a configure_alerts / pause_alerts / delete_alerts

### Alternativas evaluadas

| Opción | Descripción | Trade-off |
|--------|-------------|-----------|
| Eliminar UC | Refactorizar como state transition implícito | Pierde semántica útil; UC sin función backing |
| Mapeo forzado a ALR-002 configure_alerts | Mapear "ack" a "configurar" | Semánticamente débil; corrompe trazabilidad |
| Agregar ALR-007 `acknowledge_alert` (NUEVA) | Bump v5.4.0 con +1 función | Closed-loop alerts es operacional distinguible — JUSTIFICADO |

### Decisión

**Agregar ALR-007 `acknowledge_alert`** al modelo v5.4.0.

### Por qué

1. Acknowledge ES state transition operativo distinto de configure /
   pause / disable.
2. Negocio: closed-loop alerts requiere registro de "quién y cuándo
   reconoció" — auditable.
3. No duplica ALR-003 configure_team_alerts (concepto ortogonal).
4. Bump menor (+1 función) con justificación sólida.

### Aprobación

Ejecutor: "Apruebas agregar ALR-007 acknowledge_alert? SI"

---

## D-03 — Cat E uc-alr-05 suscripciones (split SRP)

### Análisis previo

uc-alr-05 cita ALR-005 `gestiona_suscripciones`. Modelo v5.3.0 dice
ALR-005 = `delete_alerts`. Concepto "subscription management" no
existe.

Lectura UC: "Suscribir usuarios a tipos de alertas + nivel severidad
mínimo + suscripción por segmento."

### Alternativas evaluadas (round 1)

| Opción | Descripción | Trade-off |
|--------|-------------|-----------|
| 3a Mapeo a ALR-003 configure_team_alerts | Reusar función existente | Semántica forzada — subscriptions ≠ team config |
| 3b Agregar ALR-008 `manage_alert_subscriptions` | +1 función nueva | Captura concepto pero "manage_*" es overload |

### Pregunta del ejecutor (round 2)

Ejecutor recibió análisis SRP donde se identificó que `manage_*` viola
SRP por cubrir múltiples ops. Ejecutor: "ALR-008 suscripciones → split"

### Alternativas evaluadas (round 2)

| Opción | Descripción | Resultado |
|--------|-------------|-----------|
| C1 Mantener `manage_alert_subscriptions` monolítica | 1 función, cubre subscribe + unsubscribe + configure_severity | Rechazado por overload SRP |
| C2 Split estricto en 3 funciones | ALR-008 subscribe / ALR-009 unsubscribe / ALR-010 configure_subscription_severity | **APROBADO** |

### Decisión

**Split en 3 funciones nuevas (C2):**
- ALR-008 `subscribe_to_alert`
- ALR-009 `unsubscribe_from_alert`
- ALR-010 `configure_subscription_severity`

### Por qué

1. **Consistencia metodológica con SRP aplicado a Logs** (L4-SRP).
   Si separamos logs por tipo (app/etl/infra), también debemos separar
   suscripciones por operación.
2. SoD posible: un rol puede subscribir pero no configurar severidad.
3. Granularidad RBAC útil aunque cueste +2 funciones vs C1.

### Aprobación

Ejecutor: "ALR-008 suscripciones → split"

---

## D-04 — UC uc-alr-05 (1 UC vs 3 UCs)

### Pregunta planteada

Si la función ALR-008 se splitó en 3 (D-03), ¿uc-alr-05 también se
splitea en 3 UCs (subscribe/unsubscribe/configure) o se mantiene
como 1 UC con flujos alternativos?

### Alternativas evaluadas

| Opción | Descripción | Análisis Larman |
|--------|-------------|-----------------|
| 3 UCs separados | uc-alr-05 subscribe, uc-alr-06 unsubscribe, uc-alr-07 configure | Larman dice consolidar operaciones de gestión |
| 1 UC con flujos alternativos | uc-alr-05 "Gestionar Suscripciones" con FA-subscribe, FA-unsubscribe, FA-configure | Coherente con principio "un UC por tipo de operación" |

### Decisión

**1 UC con flujos alternativos.**

### Por qué

1. **Larman aplicado consistentemente.** Las 3 operaciones constituyen
   "gestión de suscripciones" como UC business.
2. **Capa RBAC ortogonal:** las 3 funciones RBAC permiten SoD; el UC
   permite documentar el flujo business completo.
3. **Mismo principio que uc-rpt-04 consolidado** (1 UC export para
   3 funciones RBAC RPT-004/005/006).

### Aprobación

Ejecutor: "1 UC con flujos alternativos"

---

## D-05 — Logs L4-SRP (split en 3 conceptos)

### Análisis previo

Ejecutor: "se debe considerar lo de los logs, si no mal recuerdo,
existen varios tipos, los de la aplicación, los del etl, y los de la
infraestructura."

### Búsqueda realizada

- Grep en source/ por tipos de log
- Lectura de ARQ-MOD-008 sys-logs.rst
- Verificación CNSTs relacionados (CNST-024, CNST-025, CNST-026)

### Hallazgos

ARQ-MOD-008 declara alcance:
- Logs de aplicación (errores 500, INFO/WARN/ERROR)
- Logs de infraestructura (timeouts, up/down)
- Logs de ETL (mencionados implícitamente)
- Health endpoints (estado puntual servicios)
- Métricas técnicas agregadas (CPU, memoria, latencia)

ARQ-MOD-008 declara 4 UCs implícitos: UC_080 (app logs), UC_081
(health), UC_082 (paquete logs), UC_083 (métricas técnicas).

Modelo v5.3.0 tiene UNA función LOG-001 `view_technical_logs` que se
usa en uc-log-01 (sistema) y uc-log-02 (ETL como instancia filtrada).

### Crítica del ejecutor

Cuando propuse L4 con LOG-001 cubriendo app+ETL+infra:

> "LOG-001 genérico está bien para los 3 tipos de logs, NO está bien,
> en donde queda lo de responsabilidad única"

Crítica válida: SRP requiere una función = una responsabilidad.

### Alternativas evaluadas

| Opción | Descripción | Análisis SRP |
|--------|-------------|--------------|
| L1 Status quo (LOG-001 genérico) | 3 funciones existentes | Viola SRP — LOG-001 cubre 3 conceptos |
| L2 Granular por tipo | +2 funciones (etl, infra) | Cumple SRP pero no cubre health/metrics |
| L3 Solo agregar UCs faltantes | Sin cambios RBAC | No resuelve SRP |
| L4 Híbrido (manteniendo LOG-001 genérico) | LOG-001 cubre 3 + agregar health/metrics | **RECHAZADO por ejecutor** — viola SRP |
| **L4-SRP** (corregido) | Split LOG-001 a application + etl + infra + agregar health/metrics | **APROBADO** |

### Decisión

**L4-SRP completo:**
- LOG-001 rename `view_technical_logs` → `view_application_logs` (SRP)
- LOG-004 `view_etl_logs` (NUEVA)
- LOG-005 `view_infrastructure_logs` (NUEVA)
- LOG-006 `view_system_health` (NUEVA, gap UC_081)
- LOG-007 `view_technical_metrics` (NUEVA, gap UC_083)

UCs: crear uc-log-05 (infra), uc-log-06 (health), uc-log-07 (metrics).
Re-mapear uc-log-02 ETL a LOG-004 (deja de ser instancia de LOG-001).

### Por qué

1. **SRP estricto** aplicado consistentemente.
2. **Health y metrics NO son logs** (estado puntual / agregaciones, no
   eventos secuenciales). Tener funciones distintas evita overload.
3. **SoD por tipo de log** posible si el negocio lo requiere
   (admin pipeline solo ve ETL, sysadmin solo ve infra).
4. **Cobertura completa de ARQ-MOD-008** (los 4 UCs implícitos).

### Aprobación

Ejecutor: "Apruebas la L4-SRP completa? SI"

---

## D-06 — SRP global audit (otros módulos)

### Solicitud del ejecutor

"y revisa otros módulos para detectar más violaciones de SRP"

### Análisis realizado

Auditoría de los 8 módulos del modelo v5.3.0 buscando funciones
con verbos `manage_*`, `handle_*` u otros indicadores de overload.

Resultados detallados en `srp-violations-analysis.md` § Hallazgo 2.

### Decisiones por módulo

| Módulo | Hallazgo | Decisión |
|--------|----------|----------|
| MOD_Auth | AUTH-001 `manage_sessions` borderline | A2 — split rename |
| MOD_Users | Sin violaciones | Sin cambio |
| MOD_Access | ACC-005 `manage_separation_rules` viola SRP | B2 — split estricto |
| MOD_Pipeline | Sin violaciones | Sin cambio |
| MOD_Reports | RPT-001 borderline (instancias filtradas) | Mantener — son filtros, no responsabilidades |
| MOD_Alerts | ALR-008 propuesta viola SRP | C2 — split estricto (ver D-03) |
| MOD_Audit | Sin violaciones | Sin cambio |
| MOD_Logs | LOG-001 viola SRP | L4-SRP (ver D-05) |

### Por qué

Auditoría preventiva antes de cerrar v5.4.0 evita iteraciones futuras.
"Hacerlo bien una vez" es más barato que "patches sucesivos".

### Aprobación

Ejecutor: "AUTH-001 → A2 (split rename)" + "ACC-005 → B2 (split estricto +2 funciones)" + "ALR-008 suscripciones → split"

---

## D-07 — Larman: UCs de exportación por formato

### Análisis previo

Búsqueda profunda en temp-holding por: límites Excel, tipos de
reporte, principios de diseño UC.

### Hallazgo principal

Documento "Introducción a las Técnicas de Larman" (temp-holding/
FASE 01/Ingeniería de Requerimientos) declara:

> PATRÓN RECOMENDADO: Un UC por tipo de reporte, NO por formato.
> Correcto: UC-601 Generar Reporte OSHA — puede exportar PDF/Excel/Word.
> Incorrecto: UC-601a en PDF, UC-601b en Excel, UC-601c en Word.

### Estado actual de source/

uc-rpt-04 Exportar CSV / uc-rpt-05 Excel / uc-rpt-06 PDF — VIOLAN
Larman (UCs por formato).

### Pregunta planteada al ejecutor

¿Mantener separación (defensible por SRP RBAC) o consolidar (alineación
Larman)?

### Respuesta del ejecutor

> "NO queremos que se viole, pero se quiere A: cada una cumple SRP
> estricto (cada función una responsabilidad)... el problema de la
> cantidad de registros no está en los formatos, un reporte ya sea
> Excel/PDF/CSV puede tener más de 100K, el problema es que se tengan
> los recursos del sistema para que se efectúe su descarga sin afectar
> otros recursos, quizá con hilos."

### Re-interpretación

El ejecutor distingue 2 dimensiones que el modelo confunde:

| Dimensión | Capa | Resolución |
|-----------|------|------------|
| Quién puede exportar y en qué formato | RBAC (SRP/SoD) | RPT-004/005/006 separadas — MANTENER |
| Cuándo exportar | UC business (Larman) | UN UC con flujos alternativos por formato — CONSOLIDAR |
| Cómo soporta el sistema cargas grandes | Constraints de recursos | Async + throttling abstracto — REESCRIBIR |

### Decisión

**Consolidar uc-rpt-04 + uc-rpt-05 + uc-rpt-06 → uc-rpt-04
"Exportar Reporte"** con flujos alternativos por formato.

**Mantener** RPT-004/005/006 como funciones RBAC separadas.

### Por qué

1. Larman aplica a **business UCs**, SRP aplica a **RBAC functions**.
2. Son **capas ortogonales** — una sola operación de negocio
   ("exportar reporte") puede usar múltiples permisos según contexto.
3. SoD operacional preservada: "Bob puede CSV pero no PDF" sigue
   funcionando porque las funciones RBAC son distintas.

### Aprobación

Ejecutor: "Apruebas la consolidación uc-rpt-04/05/06 → uc-rpt-04 (Larman)? SI"

---

## D-08 — CNST-020 reescribir abstracto

### Análisis del ejecutor

> "el problema de la cantidad de registros no está en los formatos...
> el problema es que se tengan los recursos del sistema para que se
> efectúe su descarga sin afectar otros recursos, quizá con hilos."

### Hallazgos en source/

CNST-020 actual declara:
1. **Tabla arbitraria por formato** (CSV 100K, Excel 50K, PDF 10K).
2. **Tecnología específica** ("Mecanismo: Celery + Redis broker").

Ambos violan principios:
1. Cifras sin justificación empírica medida.
2. CNST normativa NO debe acoplar tecnología — eso es ADR.

### Indicación adicional del ejecutor

> "Sin embargo no te cases con una tecnología como Celery, tienes que
> ser abstracto, puede que Celery esté como una restricción, entonces
> se tienen que analizar alternativas."

### Alternativas tecnológicas identificadas (para ADR de implementación)

- Celery + Redis/RabbitMQ
- RQ (Redis Queue)
- Dramatiq
- django-background-tasks (más simple)
- Native asyncio + worker pool (Python ≥3.11)
- AWS SQS + Lambda (cloud-native)
- PostgreSQL LISTEN/NOTIFY (cero infraestructura adicional)

### Decisión

**Reescribir CNST-020 abstracto:**
1. Eliminar tabla "100K/50K/10K por formato".
2. Eliminar quota diaria por formato (10/5/3).
3. Reemplazar con principios:
   - Async para >umbral (referencia CNST-019).
   - Aislamiento de recursos (worker pool dedicado).
   - Throttling anti-abuse abstracto.
   - Cifras concretas y tecnología en ADR de implementación.

### Por qué

1. **CNST normativa** = qué proteger. **ADR implementación** = cómo y
   con qué números/tecnología.
2. Cifras arbitrarias sin medición empírica son "realismo performativo"
   (regla del proyecto).
3. Acoplar Celery viola separation of concerns.

### Aprobación

Ejecutor: "SI, sin embargo no te cases con una tecnología como Celery"

---

## D-09 — Daily quota anti-abuse

### Pregunta del ejecutor

> "¿Mantengo daily quota por formato (10/5/3 día/usuario) como
> anti-abuse, o lo elimino también?... porque ya está en la
> consolidación uc-rpt-04/05/06 → uc-rpt-04 (Larman), o tu que opinas"

### Análisis

Confusión a clarificar:
- UC consolidation (Larman) = capa business.
- Daily quota (anti-abuse) = capa operacional.
- Son ortogonales — la consolidación NO implementa throttling.

### Alternativas

| Opción | Descripción | Trade-off |
|--------|-------------|-----------|
| Mantener quota por formato (10/5/3) | Status quo | Cifras arbitrarias por formato |
| Quota genérico anti-abuse (sin distinguir formato) | Max N concurrent + max M daily total | Coherente con D-08 |
| Eliminar todo quota | Sin throttling | Riesgo scraping/abuse |

### Decisión

**Eliminar quota por formato. Mantener quota genérico anti-abuse:**
- Concurrent jobs por usuario (max N simultáneos)
- Quota diaria total (max M jobs/día sin distinguir formato)
- Cifras concretas en ADR de implementación

### Por qué

1. Quota por formato = cifras arbitrarias (misma crítica que D-08).
2. Anti-abuse genuino se mide en CARGA del sistema, no en formato.
3. Consistencia con D-08 (separar normativa de implementación).

### Aprobación

Ejecutor: "eliminarlo cierto" — confirma eliminación del quota por formato.

---

## D-10 — Tipos de reporte faltantes

### Análisis

Búsqueda en temp-holding identificó tipos de reporte mencionados
históricamente que NO existen como UCs en source/:
- Reporte trimestral de llamadas (UC-017 histórico)
- Reporte de transferencias por centro (UC-019 histórico)
- Reporte de menús IVR / problemáticos
- Reporte de clientes únicos

### Análisis cobertura por UCs existentes

| Tipo histórico | UC existente que lo cubre |
|----------------|--------------------------|
| Trimestral / mensual / anual | uc-rpt-03 históricos (rango + agregación) |
| Métricas agentes | uc-rpt-12 |
| Métricas colas | uc-rpt-13 |
| Métricas campañas | uc-rpt-14 |

### Tipos faltantes (domain distinto, no son filtros)

| UC propuesto | Domain | Justificación |
|--------------|--------|---------------|
| uc-rpt-15 Transferencias por Centro | Transferencias entre centros | UC-019 histórico, domain distinto a llamadas |
| uc-rpt-16 Menús IVR | Análisis menús problemáticos | Mencionado en frontend/analisis_api_frontend |
| uc-rpt-17 Clientes Únicos | Métricas de cliente (recurrencia) | Mencionado en frontend/analisis_api_frontend |

### Decisión

**Crear los 3 UCs (uc-rpt-15, uc-rpt-16, uc-rpt-17)** mapeados a
RPT-001 view_reports (instancias por scope distinto).

### Por qué

1. Cubren dominios distintos (no son filtros del mismo dato).
2. Trazabilidad a temp-holding histórico.
3. Sin agregar funciones RBAC nuevas (RPT-001 los cubre como
   instancias).

### Aprobación

Ejecutor: "Los tipos de reporte, agrego UCs nuevos para los faltantes"

---

## D-11 — BR-011 reescribir alineado

### Hallazgo

BR-011 actual: "100,000 registros máximo por exportación" (genérico,
sin distinguir formato). Contradice CNST-020 (que distingue por formato)
y será inconsistente tras D-08 (eliminar cifras arbitrarias).

### Decisión

**Reescribir BR-011 alineándolo con CNST-019/020 corregidos:**
- Eliminar el "100,000 registros máximo".
- Reemplazar por: "Las exportaciones DEBEN respetar las restricciones
  de procesamiento asíncrono (CNST-019) y throttling anti-abuse
  (CNST-020)."

### Por qué

1. BR-011 debe ser **business rule** (qué se permite/prohíbe), no
   replicar parámetros técnicos de CNST.
2. Single source of truth: cifras solo en ADR de implementación;
   constraints en CNST; reglas business en BR.

### Aprobación

Ejecutor: "Apruebas reescribir BR-011 alineándolo con CNST-019/020 corregidos? SI"

---

## Resumen de decisiones aprobadas

| ID | Decisión | Aprobado |
|----|----------|----------|
| D-01 | Renames `delete_*` + BR-009 alcance global | ✓ |
| D-02 | + ALR-007 `acknowledge_alert` | ✓ |
| D-03 | + ALR-008/009/010 split SRP suscripciones | ✓ |
| D-04 | uc-alr-05 = 1 UC con flujos alternativos | ✓ |
| D-05 | LOG-001 split + LOG-004..007 + 3 UCs nuevos | ✓ |
| D-06 | AUTH-001/004 split rename + ACC-005 split estricto | ✓ |
| D-07 | Consolidar uc-rpt-04/05/06 → uc-rpt-04 | ✓ |
| D-08 | Reescribir CNST-020 abstracto sin cifras ni tecnología | ✓ |
| D-09 | Eliminar quota por formato; mantener anti-abuse genérico | ✓ |
| D-10 | Crear uc-rpt-15/16/17 (tipos faltantes) | ✓ |
| D-11 | Reescribir BR-011 alineado | ✓ |

**Resultado:** v5.4.0 = 63 funciones (51 + 12 nuevas; 0 eliminadas;
6 renames). 12 cambios consolidados aprobados.
