---
id: UC-CALL-001
tipo: caso_de_uso
nombre: Registrar Llamada Entrante
actor_primario: Sistema IVR
nivel: sistema
prioridad: alta
estado: aprobado
dominio: llamadas
trazabilidad_upward:
  - RN-CALL-001      # Gestión integral de llamadas
  - BR-H01           # Hecho: Cada llamada tiene agente asignado
  - BR-R02           # Restricción: Agente debe estar disponible
  - BR-D01           # Desencadenador: Notificación a agente
trazabilidad_downward:
  - RF-CALL-001      # API registro de llamadas
  - RF-CALL-002      # API asignación de agentes
  - RF-CALL-003      # API gestión de cola
  - TEST-CALL-001    # Test flujo normal
  - TEST-CALL-002    # Test sin agentes disponibles
  - TEST-CALL-003    # Test abandono de llamada
fecha_creacion: 2025-11-14
owner: equipo-call-center
reglas_negocio_aplicadas:
  - tipo: hecho
    id: BR-H01
    descripcion: "Cada llamada debe asociarse a un agente específico"
  - tipo: restriccion
    id: BR-R02
    descripcion: "Agente debe estar en estado disponible para recibir llamadas"
  - tipo: restriccion
    id: BR-R08
    descripcion: "Grabación requiere consentimiento del cliente (LFPDPPP)"
  - tipo: desencadenador
    id: BR-D01
    descripcion: "Notificar a agente cuando se asigna llamada"
  - tipo: desencadenador
    id: BR-D02
    descripcion: "Si tiempo_espera > 5min entonces escalar a supervisor"
  - tipo: calculo
    id: BR-C01
    descripcion: "Registrar timestamps para cálculo de AHT"
  - tipo: calculo
    id: BR-C07
    descripcion: "Actualizar métricas de tasa de abandono"
---

# UC-CALL-001: Registrar Llamada Entrante

## Identificación

- **ID**: UC-CALL-001
- **Nombre**: Registrar Llamada Entrante
- **Actor primario**: Sistema IVR
- **Nivel**: Sistema (fish level)
- **Prioridad**: Alta
- **Dominio**: Gestión de Llamadas

## Resumen

El sistema IVR detecta una llamada entrante, registra la información en la base de datos PostgreSQL, busca un agente disponible y asigna la llamada. Si no hay agentes disponibles, la llamada se coloca en cola con monitoreo de tiempo de espera. El sistema mantiene trazabilidad completa para cálculo de métricas (AHT, tasa de abandono).

**Objetivo del sistema**: Registrar llamada entrante y asignarla al agente disponible más adecuado en menos de 20 segundos.

**Alcance**: Incluye detección de llamada, registro, asignación a agente y gestión de cola. NO incluye la atención de la llamada por el agente (caso de uso separado UC-CALL-002).

## Actores

### Actor primario
- **Rol**: Sistema IVR
- **Descripción**: Sistema telefónico interactivo que detecta llamadas entrantes y proporciona ANI (Automatic Number Identification)
- **Interfaz**: API REST `/api/ivr/incoming-call/`

### Actores secundarios
- **Base de Datos PostgreSQL**: Almacena registros de llamadas y estados de agentes
- **Sistema de Notificaciones**: Envía alertas a agentes y supervisores
- **Agente Disponible**: Recibe notificación y atiende la llamada

## Precondiciones

**Cumplimiento de Reglas de Negocio:**

1. **BR-H01 (Hecho)**: Existe configuración de equipo de agentes en el sistema
2. **BR-R02 (Restricción)**: Al menos un agente debe estar en estado "disponible" O existe cola configurada
3. **Infraestructura**: Sistema IVR operativo y conectado a API
4. **Base de Datos**: PostgreSQL accesible (puerto 5432)
5. **Redis**: Cache operativo para gestión de estados

## Flujo Principal

**Escenario de éxito: Asignación directa a agente disponible**

| Actor (Sistema IVR) | Sistema (IACT Call Center) |
|---------------------|----------------------------|
| 1. IVR detecta llamada entrante con ANI (número telefónico) | |
| 2. IVR envía POST `/api/ivr/incoming-call/` con payload: `{ani: "5512345678", ivr_id: "IVR-01"}` | |
| | 3. **BR-H01**: Sistema crea registro de Llamada con estado "detectada" |
| | 4. Sistema consulta cache Redis para lista de agentes disponibles |
| | 5. **BR-R02**: Sistema valida que existe al menos un agente con estado="disponible" |
| | 6. Sistema selecciona agente según algoritmo (round-robin o skill-based) |
| | 7. **BR-H01**: Sistema asigna llamada a agente (campo `agente_id`) |
| | 8. Sistema actualiza estado llamada a "asignada" |
| | 9. **BR-D01**: Sistema envía notificación WebSocket a agente |
| | 10. Sistema actualiza estado agente a "en_llamada" |
| | 11. **BR-C01**: Sistema registra `timestamp_inicio` y `timestamp_asignacion` |
| | 12. **BR-R08**: Sistema inicia grabación (si cliente consintió) |
| | 13. Sistema retorna `200 OK` con `call_id` y `agent_id` |
| 14. IVR conecta llamada con extensión del agente | |

**Postcondición exitosa**: Llamada registrada, asignada y conectada en menos de 20 segundos.

## Flujos Alternos

### FA-1: Agente no responde en 20 segundos
**Momento**: Después del paso 9 del flujo principal
**Condición**: Agente no acepta llamada en timeout configurado
**Reglas aplicadas**: BR-D03 (Desencadenador: Reasignación automática)

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 9.a. Sistema detecta timeout de 20 segundos sin respuesta |
| | 9.b. Sistema cancela asignación actual |
| | 9.c. **BR-R05**: Sistema marca agente como "no_disponible" temporalmente |
| | 9.d. Sistema registra evento "agente_no_responde" en auditoría |
| | 9.e. **BR-D03**: Sistema busca siguiente agente disponible |
| | 9.f. Si existe otro agente → **Retorna a paso 6** |
| | 9.g. Si NO existe otro agente → **Ir a FA-2** |

**Retorna a**: Paso 6 o FA-2

### FA-2: No hay agentes disponibles - Gestión de Cola
**Momento**: Paso 5 del flujo principal
**Condición**: Query a Redis retorna 0 agentes con estado="disponible"
**Reglas aplicadas**: BR-D02 (Desencadenador: Escalación por tiempo)

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 5.a. Sistema detecta que no hay agentes disponibles |
| | 5.b. Sistema coloca llamada en cola (modelo `ColaLlamada`) |
| | 5.c. Sistema calcula posición en cola |
| | 5.d. Sistema retorna `202 Accepted` con posición en cola |
| | 5.e. IVR reproduce mensaje: "Todos los agentes están ocupados. Posición en cola: N" |
| | 5.f. **BR-D02**: Sistema inicia monitoreo de tiempo en cola (Celery task) |
| | 5.g. Sistema espera hasta que un agente se libere |
| | 5.h. Cuando agente disponible → **Retorna a paso 6** |

**Monitoreo paralelo (BR-D02)**:
```python
# Celery task ejecutándose en paralelo
if llamada.tiempo_en_cola > 300:  # 5 minutos
    escalar_a_supervisor(llamada_id)
```

**Retorna a**: Paso 6 cuando hay agente disponible

### FA-3: Cliente abandona llamada antes de asignación
**Momento**: En cualquier momento antes del paso 14
**Condición**: IVR detecta desconexión del cliente
**Reglas aplicadas**: BR-C07 (Cálculo: Tasa de abandono)

**Acción**:
| Actor (IVR) | Sistema |
|-------------|---------|
| 3.a. IVR detecta desconexión del cliente | |
| 3.b. IVR envía DELETE `/api/ivr/calls/{call_id}/` | |
| | 3.c. Sistema actualiza estado llamada a "abandonada" |
| | 3.d. Sistema registra `timestamp_abandono` |
| | 3.e. **BR-C07**: Sistema calcula tiempo_espera = timestamp_abandono - timestamp_inicio |
| | 3.f. **BR-C07**: Sistema actualiza métrica `tasa_abandono` del día |
| | 3.g. Si llamada estaba asignada: Sistema libera agente (estado="disponible") |
| | 3.h. Si llamada en cola: Sistema la remueve de ColaLlamada |
| | 3.i. Sistema retorna `200 OK` |

**Resultado**: Caso de uso termina. Llamada marcada como abandonada con métricas actualizadas.

## Flujos de Excepción

### FE-1: Base de datos PostgreSQL no accesible
**Momento**: Paso 3 del flujo principal
**Condición de error**: ConnectionError al intentar crear registro de Llamada
**Reglas aplicadas**: BR-R06 (Restricción: Graceful degradation)

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 3.e1. Sistema detecta excepción `psycopg2.OperationalError` |
| | 3.e2. Sistema intenta reconexión (3 reintentos con backoff exponencial) |
| | 3.e3. Si falla: Sistema registra error en log |
| | 3.e4. **BR-R06**: Sistema retorna `503 Service Unavailable` |
| 3.e5. IVR reproduce mensaje: "El sistema no está disponible. Intente más tarde" | |
| 3.e6. IVR desconecta llamada | |

**Resultado**: Caso de uso termina sin registro. Alerta enviada a equipo DevOps.

## Postcondiciones

### Postcondición de éxito (Flujo Principal)
1. **BR-H01**: Llamada registrada en tabla `llamadas` con `call_id` único
2. **BR-H01**: Llamada asignada a agente específico (campo `agente_id` no nulo)
3. Agente notificado y estado cambiado a "en_llamada"
4. **BR-C01**: Timestamps registrados (`timestamp_inicio`, `timestamp_asignacion`)
5. **BR-R08**: Grabación iniciada (si aplicable)
6. Cliente conectado con agente en menos de 20 segundos

## Requisitos Especiales

### Performance (Atributos de Calidad)
- **RNF-001**: Tiempo de asignación < 20 segundos (percentil 95)
- **RNF-002**: Throughput mínimo: 100 llamadas/segundo
- **RNF-003**: Disponibilidad: 99.9% (downtime máximo 43 minutos/mes)

### Seguridad
- **RNF-004**: API autenticada con JWT token del sistema IVR
- **RNF-005**: **BR-R08**: Cumplimiento LFPDPPP para grabaciones

---

**Documentos relacionados:**
- [Reglas de Negocio](../../requisitos/REGLAS_NEGOCIO/README.md)
- [UC-CALL-002: Atender Llamada](UC-CALL-002_atender_llamada.md)
- [Aplicación IACT](../../requisitos/REGLAS_NEGOCIO/APLICACION_IACT.md)

**Creado por**: Equipo de Call Center
**Fecha**: 2025-11-14
**Última revisión**: 2025-11-14
