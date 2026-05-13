---
id: UC-CALL-003
tipo: caso_de_uso
nombre: Transferir Llamada
actor_primario: SUPERVISOR
nivel: usuario
prioridad: alta
estado: aprobado
dominio: llamadas
trazabilidad_upward:
  - RN-CALL-002      # Gestión de transferencias
  - BR-R03           # Restricción: Solo supervisores pueden transferir
  - BR-R04           # Restricción: Agente destino debe estar disponible
  - BR-H02           # Hecho: Transferencia mantiene grabación continua
trazabilidad_downward:
  - RF-CALL-007      # API transferir llamada
  - RF-CALL-008      # API validar disponibilidad agente
  - TEST-CALL-006    # Test transferencia exitosa
  - TEST-CALL-007    # Test validación de permisos
fecha_creacion: 2025-11-14
owner: equipo-call-center
reglas_negocio_aplicadas:
  - tipo: restriccion
    id: BR-R03
    descripcion: "Solo supervisores pueden reasignar llamadas"
  - tipo: restriccion
    id: BR-R04
    descripcion: "Agente destino debe estar disponible"
  - tipo: hecho
    id: BR-H02
    descripcion: "Llamada transferida mantiene grabación continua"
  - tipo: desencadenador
    id: BR-D02
    descripcion: "Notificar a agente destino de nueva llamada"
  - tipo: calculo
    id: BR-C02
    descripcion: "Actualizar tiempo en transferencia"
---

# UC-CALL-003: Transferir Llamada

## Identificación

- **ID**: UC-CALL-003
- **Nombre**: Transferir Llamada
- **Actor primario**: SUPERVISOR
- **Nivel**: Usuario (sea level)
- **Prioridad**: Alta
- **Dominio**: Gestión de Llamadas

## Resumen

Un supervisor transfiere una llamada activa de un agente a otro, manteniendo la continuidad de la grabación y actualizando métricas. El sistema valida permisos del supervisor, disponibilidad del agente destino y mantiene el historial completo de la transferencia.

**Objetivo del actor**: Reasignar una llamada a un agente más calificado o disponible para mejorar la atención al cliente.

**Alcance**: Incluye selección de agente destino, validación de disponibilidad y ejecución de transferencia. NO incluye escalaciones a otros departamentos.

## Actores

### Actor primario
- **Rol**: SUPERVISOR
- **Descripción**: Usuario con permisos de supervisión que puede reasignar llamadas
- **Capacidades requeridas**: `llamadas.transferir`, `equipo.gestionar`

### Actores secundarios
- **Agente Origen**: Agente que actualmente tiene la llamada
- **Agente Destino**: Agente que recibirá la llamada
- **Sistema de Grabación**: Mantiene grabación continua durante transferencia
- **Base de Datos PostgreSQL**: Registra historial de transferencia

## Precondiciones

1. **BR-R03**: Supervisor autenticado con rol "Supervisor" o superior
2. Existe una llamada en estado "en_curso"
3. **BR-R04**: Existe al menos un agente disponible diferente al agente origen

## Flujo Principal

| Actor (SUPERVISOR) | Sistema |
|--------------------|---------|
| 1. Supervisor navega al módulo de gestión de llamadas activas | |
| | 2. Sistema muestra lista de llamadas en curso del equipo |
| 3. Supervisor selecciona llamada a transferir | |
| | 4. **BR-R03**: Sistema valida permisos del supervisor |
| | 5. Sistema muestra información de la llamada actual |
| | 6. Sistema muestra lista de agentes disponibles |
| 7. Supervisor selecciona agente destino | |
| | 8. **BR-R04**: Sistema valida que agente destino tiene estado="disponible" |
| 9. [OPCIONAL] Supervisor ingresa motivo de transferencia | |
| 10. Supervisor confirma transferencia | |
| | 11. Sistema guarda `agente_anterior` en historial |
| | 12. **BR-H02**: Sistema mantiene grabación activa (sin interrupciones) |
| | 13. Sistema actualiza `agente_id` de la llamada |
| | 14. Sistema actualiza estado a "transferida" |
| | 15. Sistema actualiza estado agente origen a "disponible" |
| | 16. Sistema actualiza estado agente destino a "en_llamada" |
| | 17. **BR-D02**: Sistema notifica a agente destino vía WebSocket |
| | 18. **BR-C02**: Sistema calcula y guarda `tiempo_transferencia` |
| | 19. Sistema registra evento en auditoría |
| | 20. Sistema muestra confirmación de éxito |

## Flujos Alternos

### FA-1: Agente destino no disponible al momento de transferir
**Momento**: Paso 8
**Condición**: Agente cambió estado a "no_disponible" entre selección y confirmación

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 8.a. **BR-R04**: Sistema detecta que agente ya no está disponible |
| | 8.b. Sistema muestra error: "Agente {nombre} ya no está disponible" |
| | 8.c. Sistema actualiza lista de agentes disponibles |
| 8.d. Supervisor selecciona otro agente disponible | |
| | **Retorna a paso 7** |

### FA-2: Transferencia caliente (warm transfer)
**Momento**: Antes del paso 10
**Condición**: Supervisor requiere briefing entre agentes

**Acción**:
| Actor | Sistema |
|-------|---------|
| 10.a. Supervisor selecciona "Transferencia caliente" | |
| | 10.b. Sistema establece conferencia tripartita temporal |
| | 10.c. Sistema mantiene ambos agentes en "en_llamada" |
| 10.d. Agente origen explica situación a agente destino | |
| 10.e. Supervisor confirma completar transferencia | |
| | 10.f. Sistema desconecta agente origen |
| | **Continúa en paso 11** |

## Flujos de Excepción

### FE-1: Supervisor sin permisos suficientes
**Momento**: Paso 4
**Condición de error**: Usuario no tiene rol "Supervisor" ni capacidad `llamadas.transferir`

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 4.e1. **BR-R03**: Sistema detecta falta de permisos |
| | 4.e2. Sistema registra intento en auditoría |
| | 4.e3. Sistema muestra error: "No tiene permisos para transferir llamadas" |
| | 4.e4. Sistema impide acceso a funcionalidad de transferencia |

**Resultado**: Caso de uso termina sin transferencia.

### FE-2: Llamada finaliza durante proceso de transferencia
**Momento**: Entre pasos 7 y 10
**Condición de error**: Cliente o agente origen cuelgan durante selección

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 10.e1. Sistema detecta que llamada cambió a "finalizada" |
| | 10.e2. Sistema cancela proceso de transferencia |
| | 10.e3. Sistema muestra mensaje: "Llamada finalizada. Transferencia cancelada" |
| | 10.e4. Sistema libera agente origen (estado="disponible") |

**Resultado**: Caso de uso termina. Llamada cerrada normalmente por UC-CALL-002.

## Postcondiciones

### Postcondición de éxito
1. Llamada transferida al agente destino
2. **BR-H02**: Grabación continua mantenida (sin gaps)
3. Historial completo registrado (agente_anterior, motivo, timestamp)
4. Agente origen liberado (estado="disponible")
5. Agente destino atendiendo (estado="en_llamada")
6. **BR-C02**: Tiempo de transferencia calculado
7. Evento registrado en auditoría

## Requisitos Especiales

### Performance
- **RNF-020**: Transferencia debe completarse en menos de 5 segundos
- **RNF-021**: No debe haber pérdida de audio durante transferencia

### Seguridad
- **RNF-022**: Todas las transferencias deben quedar auditadas
- **RNF-023**: Supervisor solo puede transferir llamadas de su equipo

### Usabilidad
- **RNF-024**: Sistema debe mostrar skills del agente destino para decisión informada

---

**Documentos relacionados:**
- [UC-CALL-001: Registrar Llamada Entrante](UC-CALL-001_registrar_llamada_entrante.md)
- [UC-CALL-002: Atender Llamada](UC-CALL-002_atender_llamada.md)
- [Reglas de Negocio](../../requisitos/REGLAS_NEGOCIO/README.md)

**Creado por**: Equipo de Call Center
**Fecha**: 2025-11-14
