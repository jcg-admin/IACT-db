### 2.7 Diagrama Maestro de la Jerarquía

```
┌──────────────────────────────────────────────────────────────────────────┐
│                   PROYECTO IACT - FLUJO COMPLETO                          │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  STAKEHOLDER: "Necesitamos prevenir que consultas grandes saturen        │
│                el servidor de Analytics"                                  │
│                                    │                                      │
│                                    ↓ IDENTIFICA                           │
│                                                                           │
│  BRQ-RPT-001: Prevenir Sobrecarga Servidor                               │
│  ═══════════════════════════════════════                                 │
│  Objetivo medible: 0 incidentes saturación en Q1-2026                    │
│  KPI: CPU <80%, latencia p95 <3s                                         │
│                                    │                                      │
│                                    ↓ SE IMPLEMENTA CON                    │
│                                                                           │
│  BR-IACT-028: Aprobación Consultas Grandes                               │
│  ═══════════════════════════════════════════                             │
│  "Consultas >10K registros requieren aprobación supervisor"              │
│  Tipo: Restricción | Observable: Sí                                      │
│                                    │                                      │
│                         ┌──────────┴──────────┐                          │
│                         ↓                      ↓                          │
│                                                                           │
│  UC-IACT-RPT-01:                  UC-IACT-RPT-09:                        │
│  Consultar Reporte                Aprobar/Rechazar Consulta              │
│  ══════════════════                ═══════════════════════               │
│  Paso 7: Ejecuta COUNT(*)         Actor: Supervisor                      │
│  Paso 8: Si >10K → FA-1           Precondición: Request pendiente        │
│  FA-1: Solicita aprobación        Paso 3: Supervisor aprueba/rechaza    │
│                                    Paso 5: Notifica analista             │
│         │                                  │                              │
│         ↓ DERIVA EN                        ↓ DERIVA EN                    │
│                                                                           │
│  FR-RPT-01-07:                    FR-RPT-09-03:                          │
│  Calcular COUNT(*)                Actualizar Estado Request              │
│  ══════════════════                ═══════════════════════               │
│  Query: SELECT COUNT(*)...         UPDATE requests                       │
│  Timeout: 5 segundos               SET status = :decision                │
│  Index: (call_date,...)            WHERE request_id = :id                │
│                                                                           │
│         │                                  │                              │
│         ↓ SE IMPLEMENTA EN                 ↓ SE IMPLEMENTA EN             │
│                                                                           │
│  reports/services.py              requests/services.py                   │
│  ════════════════════              ═══════════════════                   │
│  calculate_query_count()           update_request_status()               │
│  ↓ retorna count                   ↓ retorna updated_request             │
│                                                                           │
│         │                                  │                              │
│         ↓ SE VALIDA CON                    ↓ SE VALIDA CON                │
│                                                                           │
│  tests/test_reports.py            tests/test_requests.py                 │
│  ══════════════════════            ══════════════════════                │
│  test_count_under_10k()            test_supervisor_approves()            │
│  test_count_over_10k()             test_supervisor_rejects()             │
│  test_count_timeout()              test_notification_sent()              │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

<a name="3-transformaciones-clave"></a>

## 3. TRANSFORMACIONES CLAVE

### 3.1 BR → UC: La Transformación Principal

**Pregunta fundamental:** ¿Cómo conviertes una regla de negocio en lenguaje natural en un caso de uso estructurado?

**Respuesta:** Depende del **TIPO de BR**.

### 3.2 Los 5 Tipos de BR y Sus Transformaciones

#### Tipo 1: RESTRICCIONES → PRECONDICIONES / FLUJOS ALTERNOS

**Ejemplo: BR-IACT-087**

```yaml
BR-IACT-087: Nivel de Seguridad para Funciones Críticas
Tipo: Restricción
Enunciado:
  "Solo usuarios con nivel de seguridad ≥3 pueden asignar
   funciones marcadas como críticas a otros usuarios."

Observable:
  - Usuario con nivel 2 intenta asignar función crítica
  - Sistema muestra: "Nivel de seguridad insuficiente"
```

**Transformación a UC:**

```
UC-IACT-ACC-01: Asignar Funciones a Usuario
  
  PRECONDICIÓN (derivada de BR-IACT-087):
    1. Usuario admin autenticado
    2. Usuario admin tiene función ACC-001 (asigna_funciones)
    3. Si funciones a asignar incluyen críticas:
       → Usuario admin debe tener nivel_seguridad ≥ 3
  
  PASO 4: Identificar Funciones Críticas
    Sistema verifica cuáles funciones tienen es_critica = TRUE
  
  FLUJO ALTERNO FA-3 (derivado de BR-IACT-087):
    En paso 4, si hay funciones críticas Y nivel_admin < 3:
      4a. Sistema muestra error:
          "Nivel de seguridad insuficiente para asignar funciones críticas.
           Nivel requerido: 3. Nivel actual: X."
      4b. Sistema lista funciones denegadas
      4c. Sistema regresa a selección de funciones (paso 3)
```

**Patrón:**
```
Restricción en BR
  ↓
Precondición en UC (validación antes)
  +
Flujo Alterno en UC (qué pasa si falla validación)
```

#### Tipo 2: CÁLCULOS → REQUISITOS FUNCIONALES

**Ejemplo: BR-IACT-053**

```yaml
BR-IACT-053: Cálculo de Promedio de Duración
Tipo: Cálculo
Enunciado:
  "El promedio de duración de llamadas se calcula como la suma
   de todas las duraciones dividida por el número total de llamadas,
   excluyendo llamadas con duración = 0 (abandonadas sin conexión)."

Fórmula:
  promedio_duracion = SUM(call_duration WHERE call_duration > 0) 
                      / COUNT(*) WHERE call_duration > 0
```

**Transformación a UC:**

```
UC-IACT-RPT-02: Consultar Promedio de Duración

  PASO 8: Calcular Promedio de Duración
    Sistema ejecuta cálculo según BR-IACT-053
    
  [NO genera flujo alterno, solo FR]
```

**Transformación a FR:**

```yaml
FR-RPT-02-08: Calcular Promedio Duración de Llamadas
Derivado de: UC-IACT-RPT-02 paso 8
Implementa: BR-IACT-053

Query SQL:
  SELECT 
    AVG(call_duration) as avg_duration
  FROM analytics_calls
  WHERE call_date BETWEEN :start AND :end
    AND call_duration > 0  -- Excluir abandonadas sin conexión
    AND segment_id = :user_segment

Validación:
  - avg_duration >= 0
  - avg_duration <= 7200 (2 horas, límite físico razonable)
  - Redondeo: 2 decimales
  - Unidad: segundos

Caso Especial:
  Si COUNT(*) WHERE call_duration > 0 = 0:
    → Retornar NULL (no 0, para diferenciar)
```

**Patrón:**
```
Cálculo en BR
  ↓
Paso en UC (menciona que se calcula)
  ↓
FR específico con fórmula SQL/código exacto
```

#### Tipo 3: DESENCADENADORES → CASOS DE USO COMPLETOS

**Ejemplo: BR-IACT-031**

```yaml
BR-IACT-031: Notificación de Sesión por Expirar
Tipo: Desencadenador (Trigger)
Enunciado:
  "El sistema debe notificar al usuario cuando su sesión haya estado
   inactiva durante 12 minutos, advirtiéndole que expirará en 3 minutos
   más si no realiza alguna acción."

Observable:
  Usuario recibe notificación: "Su sesión expirará en 3 minutos por inactividad"
  
Timing:
  T+0:   Usuario autenticado, última actividad registrada
  T+12min: Sistema notifica (BR-IACT-031)
  T+15min: Sistema marca sesión EXPIRED (BR-IACT-046)
```

**Transformación:**

```
BR-IACT-031 → GENERA UN UC COMPLETO

UC-IACT-AUTH-07: Notificar Sesión por Expirar
═══════════════════════════════════════════════

Actor Principal: Sistema (Scheduler/Background Job)
Actor Secundario: Usuario (receptor de notificación)
Trigger: Cron job cada 1 minuto
Frecuencia: Continua

PRECONDICIONES
  1. Sistema de notificaciones activo
  2. Tabla user_sessions actualizada
  3. Scheduler ejecutándose

FLUJO NORMAL
  1. Sistema (Scheduler) ejecuta cada 1 minuto
  2. Sistema consulta sesiones con:
     - estado = 'ACTIVA'
     - last_activity BETWEEN (NOW() - 13 min) AND (NOW() - 12 min)
  3. Para cada sesión encontrada:
     3a. Sistema crea notificación:
         Título: "Sesión por Expirar"
         Mensaje: "Su sesión expirará en 3 minutos por inactividad"
         Prioridad: WARNING
         Destinatario: user_id de la sesión
     3b. Sistema envía vía InternalMessage (CNST-001: NO email)
     3c. Sistema actualiza session.notified_expiry = TRUE
     3d. Sistema audita evento (nivel INFO)

POSTCONDICIONES
  - Usuario recibe notificación en buzón interno
  - Sesión marcada como notified_expiry = TRUE
  - Evento auditado

FLUJOS ALTERNOS
  FA-1: Usuario Realiza Acción Después de Notificación
    Si usuario hace click/request antes de 15 min:
      → last_activity se actualiza
      → Sesión NO expira
      → notified_expiry se resetea a FALSE

DERIVADO DE: BR-IACT-031
RELACIONADO CON: 
  - UC-IACT-AUTH-08: Marcar Sesión Expirada (BR-IACT-046)
  - FR-AUTH-07-02: Query sesiones por expirar
  - FR-AUTH-07-03: Crear InternalMessage
```

**Patrón:**
```
Desencadenador en BR
  ↓
UC COMPLETO (11+ pasos)
  ↓
Múltiples FR derivados
  ↓
Scheduler/Background job en código
```

#### Tipo 4: INFERENCIAS → REQUISITOS FUNCIONALES DIRECTOS

**Ejemplo: BR-IACT-046**

```yaml
BR-IACT-046: Marcar Sesión como Expirada
Tipo: Inferencia (Deducción)
Enunciado:
  "Una sesión se considera EXPIRADA si han transcurrido más de
   15 minutos desde la última actividad registrada."

Observable: NO directamente observable por usuario
  (Solo visible en BD: campo session.estado cambia a 'EXPIRED')

Timing:
  T+15min: Sistema marca sesión EXPIRED (BR-IACT-046)
           ↓
           Usuario NO ve nada (sucede en background)
           ↓
           Próximo request: Sistema rechaza con "Sesión expirada"
```

**Transformación:**

```
BR-IACT-046 → NO genera UC completo

UC-IACT-AUTH-08: Marcar Sesiones Expiradas
═══════════════════════════════════════════

Actor: Sistema (Background Job)
Trigger: Cron job cada 1 minuto
Complejidad: BAJA (solo UPDATE)

FLUJO NORMAL
  1. Sistema ejecuta cada 1 minuto
  2. Sistema ejecuta UPDATE:
     
     UPDATE user_sessions
     SET estado = 'EXPIRED',
         expired_at = NOW()
     WHERE estado = 'ACTIVA'
       AND last_activity < NOW() - INTERVAL '15 minutes'
  
  3. Sistema audita cantidad de sesiones marcadas

POSTCONDICIONES
  - Sesiones inactivas >15 min marcadas como EXPIRED
  - Evento auditado

[UC muy simple, casi solo el FR]
```

**O directamente:**

```yaml
FR-AUTH-08-02: Marcar Sesiones Inactivas como Expiradas
Derivado de: BR-IACT-046 (directamente)
Prioridad: ALTA

Query SQL:
  UPDATE user_sessions
  SET estado = 'EXPIRED',
      expired_at = CURRENT_TIMESTAMP
  WHERE estado = 'ACTIVA'
    AND last_activity < (CURRENT_TIMESTAMP - INTERVAL '15 minutes')
  RETURNING session_id;

Ejecución:
  - Scheduler: Cada 1 minuto
  - Timeout: 5 segundos
  - Log: Registrar cantidad de sesiones expiradas

Validación:
  - Solo sesiones ACTIVAS se marcan
  - Campo expired_at se actualiza
  - Auditoría con cantidad afectada
```

**Patrón:**
```
Inferencia en BR
  ↓
UC simple (casi vacío) o directamente FR
  ↓
UPDATE/cálculo automático en BD
  ↓
Background job
```

**DIFERENCIA CRÍTICA: Desencadenadores vs Inferencias**

```
DESENCADENADOR (BR-IACT-031):
  ✅ Observable por usuario → Usuario RECIBE notificación
  ✅ Genera UC completo con 11 pasos
  ✅ Actor secundario: Usuario
  ✅ Acción visible: Notificación aparece
  
INFERENCIA (BR-IACT-046):
  ❌ NO observable por usuario → Solo campo BD cambia
  ❌ NO genera UC completo → Solo FR directo
  ❌ Sin actor secundario → Solo sistema
  ❌ Sin acción visible → UPDATE silencioso
```

#### Tipo 5: DEFINICIONES → GLOSARIO

**Ejemplo: BR-IACT-001**

```yaml
BR-IACT-001: Definición de Cliente Activo
Tipo: Definición
Enunciado:
  "Un cliente se considera 'activo' si ha realizado al menos
   una llamada en los últimos 30 días naturales."

Propósito: Clarificar término de negocio
```

**Transformación:**

```
BR-IACT-001 → NO genera UC ni FR

Se documenta en GLOSARIO DEL PROYECTO:

GLOSARIO.rst
════════════

Cliente Activo
──────────────
Definición: Cliente con al menos 1 llamada en últimos 30 días
Fuente: BR-IACT-001
Uso: Reportes de actividad, segmentación

Query referencia:
  SELECT customer_id
  FROM customers c
  WHERE EXISTS (
    SELECT 1 FROM calls
    WHERE customer_id = c.customer_id
      AND call_date >= CURRENT_DATE - INTERVAL '30 days'
  )
```

**Patrón:**
```
Definición en BR
  ↓
Entrada en Glosario
  ↓
Uso consistente en toda la documentación
```

### 3.3 Desencadenadores vs Inferencias: La Diferencia CRÍTICA

**Esta es la distinción MÁS IMPORTANTE en PARTE 1.**

```
┌──────────────────────────────────────────────────────────────┐
│          DESENCADENADOR vs INFERENCIA                         │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  DESENCADENADOR (Trigger)                                     │
│  ════════════════════════                                     │
│  Inicio de acción OBSERVABLE por actor externo               │
│                                                               │
│  Ejemplo: BR-IACT-031 (Notificar sesión por expirar)         │
│                                                               │
│  Características:                                             │
│    ✅ Usuario VE/RECIBE algo                                  │
│    ✅ Genera UC completo (11+ pasos)                          │
│    ✅ Actor secundario: Usuario                               │
│    ✅ Interacción usuario-sistema                             │
│                                                               │
│  Timeline:                                                    │
│    T+12min: Sistema envía notificación                        │
│             ↓                                                 │
│             Usuario RECIBE mensaje en buzón                   │
│             ↓                                                 │
│             Usuario puede ACTUAR (hacer click, ignorar)       │
│                                                               │
│ ───────────────────────────────────────────────────────────  │
│                                                               │
│  INFERENCIA (Inference)                                       │
│  ═══════════════════                                          │
│  Deducción de estado SIN interacción observable              │
│                                                               │
│  Ejemplo: BR-IACT-046 (Marcar sesión expirada)               │
│                                                               │
│  Características:                                             │
│    ❌ Usuario NO ve nada                                      │
│    ❌ NO genera UC completo → Solo FR                         │
│    ❌ Sin actor secundario                                    │
│    ❌ Solo cambio de estado en BD                             │
│                                                               │
│  Timeline:                                                    │
│    T+15min: Sistema UPDATE estado_sesion = 'EXPIRED'          │
│             ↓                                                 │
│             Campo en BD cambia                                │
│             ↓                                                 │
│             Usuario NO se entera (hasta próximo request)      │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

**Test de Observabilidad:**

```
Pregunta: "¿El usuario VE o RECIBE algo como resultado de esta BR?"

SI → Desencadenador → UC completo
  Ejemplos:
    - Notificación aparece
    - Email llega (si no fuera CNST-001)
    - Popup se muestra
    - Dashboard se actualiza en tiempo real

NO → Inferencia → FR directo
  Ejemplos:
    - Campo BD cambia
    - Flag se actualiza
    - Timestamp se registra
    - Estado se calcula
```

**Ejemplo Completo de la Diferencia:**

```
TIMELINE COMPLETO: Expiración de Sesión

T+0 min:
  Usuario autenticado
  Session {estado: 'ACTIVA', last_activity: 14:00:00}

T+12 min (14:12:00):
  ┌─────────────────────────────────────────────┐
  │ BR-IACT-031 (DESENCADENADOR)               │
  │ ═══════════════════════════                 │
  │ → UC-IACT-AUTH-07 ejecuta                   │
  │ → Sistema crea InternalMessage              │
  │ → Usuario RECIBE notificación               │
  │   "Su sesión expirará en 3 minutos"         │
  │                                              │
  │ ✅ OBSERVABLE: Usuario ve notificación      │
  └─────────────────────────────────────────────┘

T+13 min (14:13:00):
  Usuario hace click en la app
  → last_activity actualizado a 14:13:00
  → Sesión se mantiene ACTIVA

T+28 min (14:28:00):
  Usuario NO ha hecho nada en 15 minutos
  
  ┌─────────────────────────────────────────────┐
  │ BR-IACT-046 (INFERENCIA)                    │
  │ ═══════════════════                         │
  │ → FR-AUTH-08-02 ejecuta                     │
  │ → UPDATE estado = 'EXPIRED'                 │
  │ → Campo BD cambia                           │
  │                                              │
  │ ❌ NO OBSERVABLE: Usuario no ve nada        │
  │    (solo se entera en próximo request)      │
  └─────────────────────────────────────────────┘

T+30 min (14:30:00):
  Usuario intenta hacer request
  → Sistema consulta session.estado
  → Encuentra 'EXPIRED'
  → Rechaza request con "Sesión expirada. Inicie sesión"
  
  ✅ AHORA SÍ es observable (error de sesión expirada)
  Pero NO fue observable en T+28 cuando cambió el estado
```

### 3.4 Trazabilidad Bidireccional

**Hacia Adelante (Forward Tracing):**

```
BR-IACT-028
  ↓ genera
UC-IACT-RPT-01 (Consultar Reporte)
  ↓ paso 8 deriva
FR-RPT-01-07 (Calcular COUNT(*))
  ↓ implementado en
reports/services.py::calculate_query_count()
  ↓ validado con
tests/test_reports.py::test_count_over_10k()
```

**Hacia Atrás (Backward Tracing):**

```
test_count_over_10k() FALLA
  ↑ valida
FR-RPT-01-07 (especificación incorrecta?)
  ↑ derivado de
UC-IACT-RPT-01 paso 8 (flujo incorrecto?)
  ↑ implementa
BR-IACT-028 (regla mal entendida?)
```

**Matriz de Trazabilidad (RTM):**

```
| BR          | BReq       | UC              | FR             | Código                  | Test                    |
|-------------|------------|-----------------|----------------|-------------------------|-------------------------|
| BR-IACT-028 | BRQ-RPT-001| UC-IACT-RPT-01  | FR-RPT-01-07   | calculate_query_count() | test_count_over_10k()   |
|             |            | UC-IACT-RPT-09  | FR-RPT-01-09   | create_approval_request | test_approval_created() |
|             |            |                 | FR-RPT-09-03   | update_request_status() | test_supervisor_approves|
| BR-IACT-031 | BRQ-SEC-005| UC-IACT-AUTH-07 | FR-AUTH-07-02  | get_expiring_sessions() | test_notification_sent()|
|             |            |                 | FR-AUTH-07-03  | create_internal_message | test_message_created()  |
| BR-IACT-046 | BRQ-SEC-005| UC-IACT-AUTH-08 | FR-AUTH-08-02  | mark_sessions_expired() | test_session_marked()   |
| BR-IACT-087 | BRQ-SEC-008| UC-IACT-ACC-01  | FR-ACC-01-04   | validate_security_level | test_level_insufficient |
```

### 3.5 Propagación de Cambios

**Escenario:** PO dice "Cambió la regla. Ahora son 5,000 registros en lugar de 10,000"

```
IMPACTO CASCADE:

BR-IACT-028
  Cambio: "consultas >10,000" → "consultas >5,000"
  ↓
UC-IACT-RPT-01
  Paso 8: "count > 10000" → "count > 5000"
  ↓
FR-RPT-01-07
  Decisión: "IF count > 10000" → "IF count > 5000"
  ↓
reports/services.py
  Línea 47: if count > 10000: → if count > 5000:
  ↓
tests/test_reports.py
  Test: count = 8000 (antes pasaba, ahora falla)
  Ajustar: count = 4000 (pasa) y count = 6000 (falla)
  ↓
UC-IACT-RPT-09 (Aprobar/Rechazar)
  Sin cambios (solo afecta si se dispara)
```

**Sin trazabilidad:** Cambias BR, olvidas actualizar tests → Bug en producción

**Con trazabilidad:** Cambias BR, RTM te muestra exactamente qué afecta → Cambio controlado

---

