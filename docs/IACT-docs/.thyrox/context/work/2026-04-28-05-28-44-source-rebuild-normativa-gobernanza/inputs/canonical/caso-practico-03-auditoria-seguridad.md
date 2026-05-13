---
title: Caso Práctico 3 - Sistema de Auditoría de Seguridad
date: 2025-11-16
domain: backend
status: active
caso_numero: 3
relacionado:
  - ../05a_casos_practicos_iact.md
  - ../01_marco_conceptual_iact.md
---

# Caso Práctico 3: Sistema de Auditoría de Seguridad

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente
**Dominio:** Call Center - Sistema IACT

---

## 3.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Auditoría y Cumplimiento
**Objetivo:** Registrar y analizar eventos de seguridad para detección de amenazas, cumplimiento regulatorio e investigación de incidentes

**Stakeholders:**
- Oficial de Seguridad (monitoreo de eventos)
- Auditores externos (cumplimiento)
- Administradores (investigación de incidentes)
- Oficiales de Cumplimiento (reportes regulatorios)

---

## 3.2 Proceso de Negocio

**PROC-AUDIT-001: Proceso de Registro y Análisis de Eventos de Seguridad**

```
INICIO
  |
  v
[Evento de seguridad ocurre en el sistema]
  |
  v
[Capturar contexto del evento: tipo, usuario, recurso, timestamp, IP]
  |
  v
[Clasificar criticidad: INFO|WARNING|CRITICAL]
  |
  v
[Registrar evento en tabla audit_log (inmutable)]
  |
  v
[¿Evento es CRITICAL?]
  |
  |--No--> [Continuar operación normal] --> FIN
  |
  |--Si--> [Evaluar reglas de detección de amenazas]
            |
            v
         [¿Patrón sospechoso detectado?]
            |
            |--No--> FIN
            |
            |--Si--> [Generar alerta de seguridad]
                     |
                     v
                  [Notificar a oficial de seguridad]
                     |
                     v
                  [Registrar alerta en tabla security_alerts]
                     |
                     v
                  [¿Requiere bloqueo automático?]
                     |
                     |--No--> FIN
                     |
                     |--Si--> [Bloquear cuenta/IP]
                              |
                              v
                           [Notificar a administrador]
                              |
                              v
                           FIN
```

**Actores:**
- Sistema (generador de eventos)
- Módulo de Auditoría (registro)
- Módulo de Detección de Amenazas (análisis)
- Oficial de Seguridad (investigación)

---

## 3.3 Casos de Uso Derivados

**UC-020: Registrar Evento de Auditoría**

| Caso de Uso | UC-020: Registrar Evento de Auditoría |
|-------------|--------------------------------------|
| **Actor Principal** | Sistema (automático) |
| **Stakeholders** | - Oficial de Seguridad: Requiere eventos completos<br>- Auditor: Necesita trazabilidad<br>- Administrador: Usa para investigación |
| **Precondiciones** | - Evento de seguridad ha ocurrido<br>- Módulo de auditoría operativo<br>- Conexión a base de datos disponible |
| **Postcondiciones Éxito** | - Evento registrado en audit_log<br>- Timestamp asignado<br>- Evento inmutable (no modificable) |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Sistema detecta evento de seguridad (login, acceso, cambio, error) |
| 2 | Sistema captura contexto completo del evento |
| 3 | Sistema genera UUID único para el evento |
| 4 | Sistema clasifica criticidad (INFO/WARNING/CRITICAL) |
| 5 | Sistema serializa metadata adicional en formato JSON |
| 6 | Sistema inserta registro en tabla audit_log |
| 7 | Sistema confirma persistencia del registro |

**Tipos de Eventos Auditados:**

| Categoría | Eventos | Criticidad |
|-----------|---------|-----------|
| Autenticación | LOGIN_SUCCESS, LOGIN_FAILED, LOGIN_BLOCKED, LOGOUT | WARNING/CRITICAL |
| Autorización | PERMISSION_GRANTED, PERMISSION_DENIED | INFO/WARNING |
| Gestión de Usuarios | USER_CREATED, USER_UPDATED, USER_DELETED, ROLE_CHANGED | WARNING |
| Datos Sensibles | SENSITIVE_DATA_ACCESSED, SENSITIVE_DATA_EXPORTED | CRITICAL |
| Configuración | CONFIG_CHANGED, PERMISSION_CHANGED | WARNING |
| Errores | SYSTEM_ERROR, DATABASE_ERROR, INTEGRATION_ERROR | CRITICAL |

**UC-021: Detectar Patrón Sospechoso**

| Caso de Uso | UC-021: Detectar Patrón Sospechoso |
|-------------|-----------------------------------|
| **Actor Principal** | Módulo de Detección de Amenazas (automático) |
| **Precondiciones** | - Eventos de auditoría registrados<br>- Reglas de detección configuradas |
| **Postcondiciones Éxito** | - Alerta generada si patrón detectado<br>- Oficial de seguridad notificado<br>- Acción correctiva ejecutada (si aplicable) |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Sistema analiza eventos recientes (ventana de 15 minutos) |
| 2 | Sistema aplica reglas de detección de amenazas |
| 3 | Sistema identifica patrón sospechoso |
| 4 | Sistema genera alerta con severidad (LOW/MEDIUM/HIGH) |
| 5 | Sistema registra alerta en security_alerts |
| 6 | Sistema notifica a oficial de seguridad (email/Slack) |
| 7 | Sistema ejecuta acción correctiva automática (si configurada) |

**Patrones de Amenaza Detectados:**

| Patrón | Descripción | Regla | Acción |
|--------|-------------|-------|--------|
| Fuerza Bruta | >5 LOGIN_FAILED en 5 min desde misma IP | 5/5min | Bloquear IP temporalmente |
| Escalación de Privilegios | Múltiples PERMISSION_DENIED + cambio de rol | 10/15min | Alertar admin |
| Acceso Anómalo | Login desde país/IP inusual | GeoIP check | Alertar usuario y admin |
| Extracción Masiva | >100 SENSITIVE_DATA_ACCESSED en 10 min | 100/10min | Bloquear cuenta |
| Manipulación de Auditoría | Intento de DELETE en audit_log | 1 intento | Bloquear inmediatamente |

---

## 3.4 Requisitos Derivados

**RF-020: Registro Inmutable de Eventos de Auditoría**

```
ID: RF-020
Título: Registro Inmutable de Eventos de Auditoría
Prioridad: MUST (MoSCoW)
Categoría: Auditoría - Cumplimiento

Descripción:
El sistema debe registrar todos los eventos de seguridad en una tabla
inmutable (solo INSERT) con integridad criptográfica.

Criterios de Aceptación:
1. Todos los eventos de seguridad deben registrarse automáticamente
2. Registros deben ser inmutables (no UPDATE, no DELETE)
3. Tabla audit_log debe tener trigger que bloquee modificaciones
4. Cada registro debe tener hash SHA-256 para verificar integridad
5. Registros deben persistirse de forma síncrona (antes de responder)

Estructura del Registro:
CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type VARCHAR(50) NOT NULL,
  event_category VARCHAR(20) NOT NULL,
  severity VARCHAR(10) NOT NULL,
  user_id UUID,
  user_email VARCHAR(255),
  resource VARCHAR(255),
  action VARCHAR(50),
  result VARCHAR(20),
  ip_address INET,
  user_agent TEXT,
  metadata JSONB,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  integrity_hash VARCHAR(64) NOT NULL
);

-- Trigger para prevenir modificaciones
CREATE TRIGGER prevent_audit_modification
  BEFORE UPDATE OR DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION prevent_modification();

Cálculo de Hash:
hash = SHA256(
  event_type + user_id + resource + action +
  timestamp + secret_key
)

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-020
- Prueba: TS-RF-020-001
```

**RF-021: Detección Automática de Amenazas**

```
ID: RF-021
Título: Detección Automática de Patrones de Amenaza
Prioridad: SHOULD (MoSCoW)
Categoría: Seguridad - Detección de Amenazas

Descripción:
El sistema debe analizar eventos de auditoría en tiempo real para
detectar patrones sospechosos y generar alertas automáticas.

Criterios de Aceptación:
1. Análisis debe ejecutarse en ventanas de tiempo (5, 10, 15 min)
2. Sistema debe detectar al menos 5 patrones predefinidos
3. Alertas deben generarse en menos de 30 segundos desde detección
4. Alertas deben incluir evidencia (eventos relacionados)
5. Acciones correctivas deben ejecutarse automáticamente si configuradas

Reglas de Detección:

REGLA 1: Fuerza Bruta
- Condición: >5 LOGIN_FAILED desde misma IP en 5 min
- Severidad: HIGH
- Acción: Bloquear IP por 1 hora

REGLA 2: Escalación de Privilegios
- Condición: >10 PERMISSION_DENIED + ROLE_CHANGED en 15 min
- Severidad: CRITICAL
- Acción: Bloquear cuenta + notificar admin

REGLA 3: Acceso Anómalo
- Condición: Login desde país no habitual (últimos 90 días)
- Severidad: MEDIUM
- Acción: Notificar usuario + requerir 2FA

REGLA 4: Extracción Masiva
- Condición: >100 SENSITIVE_DATA_ACCESSED en 10 min
- Severidad: CRITICAL
- Acción: Bloquear cuenta + alerta inmediata

REGLA 5: Manipulación de Auditoría
- Condición: Cualquier intento UPDATE/DELETE en audit_log
- Severidad: CRITICAL
- Acción: Bloquear cuenta permanentemente

Estructura de Alerta:
{
  "id": "uuid",
  "patternType": "BRUTE_FORCE | PRIVILEGE_ESCALATION | ...",
  "severity": "LOW | MEDIUM | HIGH | CRITICAL",
  "detectedAt": "timestamp",
  "userId": "uuid",
  "evidenceEvents": ["eventId1", "eventId2", ...],
  "automaticActionTaken": "IP_BLOCKED | ACCOUNT_SUSPENDED | ...",
  "notifiedTo": ["security@company.com"]
}

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-021
- Prueba: TS-RF-021-001 a TS-RF-021-005
```

**RF-022: Generación de Reportes de Auditoría**

```
ID: RF-022
Título: Generación de Reportes de Auditoría
Prioridad: SHOULD (MoSCoW)
Categoría: Auditoría - Reportes

Descripción:
El sistema debe permitir generar reportes de auditoría filtrados por
fecha, usuario, tipo de evento y severidad para análisis y cumplimiento.

Criterios de Aceptación:
1. Soportar filtros: fecha_inicio, fecha_fin, userId, eventType, severity
2. Generar reportes en formatos: PDF, CSV, JSON
3. Incluir métricas agregadas (total eventos, por tipo, por severidad)
4. Permitir exportación de hasta 10,000 eventos por reporte
5. Reportes deben generarse en menos de 10 segundos

Filtros Disponibles:
- Rango de fechas (obligatorio, máx 90 días)
- Usuario específico (opcional)
- Tipo de evento (opcional, multi-selección)
- Severidad (opcional, multi-selección)
- Resultado (SUCCESS/FAILURE)

Métricas Incluidas:
- Total de eventos en el período
- Distribución por tipo de evento (gráfico)
- Distribución por severidad (gráfico)
- Top 10 usuarios con más eventos
- Top 10 IPs con más eventos
- Tendencia temporal (eventos por día)

Formato del Reporte:

PDF:
- Encabezado con logo y período
- Sección de métricas agregadas
- Tabla de eventos con paginación
- Firma digital del sistema

CSV:
- Headers con nombres de columnas
- Filas con datos de eventos
- UTF-8 encoding

JSON:
- Array de objetos evento
- Metadata del reporte

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-022 (Generar Reporte de Auditoría)
- Prueba: TS-RF-022-001
```

---

## 3.5 Procedimientos Operacionales

**PROC-AUDIT-REVIEW-001: Procedimiento de Revisión de Eventos de Seguridad**

**Objetivo:** Guiar al oficial de seguridad en la revisión periódica de eventos de auditoría.

**Alcance:** Aplicable a oficiales de seguridad y administradores

**Responsable:** Oficial de Seguridad

**Frecuencia:** Diaria (eventos CRITICAL), Semanal (eventos WARNING), Mensual (todos)

**Pasos Detallados:**

| Paso | Pantalla | Acción | Sistema |
|------|----------|--------|---------|
| 1 | Dashboard Seguridad | Navegar a "Auditoría y Seguridad" | Sistema carga dashboard con métricas del día |
| 2 | Métricas | Revisar panel de alertas activas | Sistema muestra alertas críticas no resueltas |
| 3 | Alertas CRITICAL | Hacer clic en alerta con severidad CRITICAL | Sistema muestra detalles y eventos relacionados |
| 4 | Investigación | Revisar eventos de evidencia (expandir JSON) | Sistema presenta timeline de eventos |
| 5 | Análisis | Determinar si es amenaza real o falso positivo | - |
| 6a | Si amenaza real | Hacer clic en "Escalar Incidente" | Sistema crea ticket de incidente |
| 6b | Si falso positivo | Hacer clic en "Marcar como Falso Positivo" | Sistema actualiza alerta y ajusta regla |
| 7 | Acciones | Ejecutar acciones correctivas (bloquear usuario, resetear contraseña) | Sistema ejecuta y registra acciones |
| 8 | Documentación | Agregar notas de investigación | Sistema guarda notas en la alerta |
| 9 | Reporte | Generar reporte de eventos del día | Sistema genera PDF con eventos CRITICAL |
| 10 | Envío | Enviar reporte a stakeholders | Sistema envía email con reporte adjunto |

**Checklist de Revisión Diaria:**

- [ ] Revisar todas las alertas CRITICAL generadas en las últimas 24 horas
- [ ] Investigar cualquier patrón de fuerza bruta (LOGIN_FAILED múltiples)
- [ ] Verificar accesos desde IPs/países inusuales
- [ ] Revisar intentos de escalación de privilegios
- [ ] Analizar eventos de acceso a datos sensibles
- [ ] Confirmar que no hay intentos de manipulación de auditoría
- [ ] Documentar incidentes y acciones tomadas
- [ ] Generar y enviar reporte diario a CISO

---

## 3.6 Trazabilidad Completa

**Matriz de Trazabilidad: Caso Auditoría**

| Proceso | Caso de Uso | Requisito Funcional | Procedimiento | Prueba |
|---------|-------------|---------------------|---------------|--------|
| PROC-AUDIT-001 | UC-020 | RF-020 | - | TS-RF-020-001 |
| PROC-AUDIT-001 | UC-021 | RF-021 | PROC-AUDIT-REVIEW-001 | TS-RF-021-001 |
| PROC-AUDIT-001 | UC-022 | RF-022 | PROC-AUDIT-REVIEW-001 | TS-RF-022-001 |

**Flujo de Transformación:**

```
PROCESO DE NEGOCIO (PROC-AUDIT-001)
         |
         v
CASOS DE USO
- UC-020: Registrar Evento
- UC-021: Detectar Amenaza
- UC-022: Generar Reporte
         |
         v
REQUISITOS FUNCIONALES
- RF-020: Registro inmutable
- RF-021: Detección automática
- RF-022: Reportes de auditoría
         |
         v
PROCEDIMIENTOS OPERACIONALES
(PROC-AUDIT-REVIEW-001)
         |
         v
IMPLEMENTACIÓN Y PRUEBAS
```

---

**Referencias:**
- Documento maestro: `../05a_casos_practicos_iact.md`
- Marco conceptual: `../01_marco_conceptual_iact.md`
- Metodología de análisis: `../04_metodologia_analisis_iact.md`
