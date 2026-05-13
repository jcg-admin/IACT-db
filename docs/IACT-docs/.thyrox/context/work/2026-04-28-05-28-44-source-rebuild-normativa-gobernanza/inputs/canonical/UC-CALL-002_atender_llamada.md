---
id: UC-CALL-002
tipo: caso_de_uso
nombre: Atender Llamada
actor_primario: AGENTE
nivel: usuario
prioridad: alta
estado: aprobado
dominio: llamadas
trazabilidad_upward:
  - RN-CALL-001      # Gestión integral de llamadas
  - BR-H03           # Hecho: Toda llamada debe clasificarse al cerrar
  - BR-R09           # Restricción: Agente debe estar logueado
  - BR-D04           # Desencadenador: Actualizar métricas al cerrar
trazabilidad_downward:
  - RF-CALL-004      # API atender llamada
  - RF-CALL-005      # API clasificar llamada
  - RF-CALL-006      # API cerrar llamada
  - TEST-CALL-004    # Test atención completa
  - TEST-CALL-005    # Test clasificación obligatoria
fecha_creacion: 2025-11-14
owner: equipo-call-center
reglas_negocio_aplicadas:
  - tipo: hecho
    id: BR-H03
    descripcion: "Toda llamada debe clasificarse antes de cerrar"
  - tipo: restriccion
    id: BR-R09
    descripcion: "Solo el agente asignado puede atender su llamada"
  - tipo: restriccion
    id: BR-R10
    descripcion: "Llamada no puede cerrarse sin clasificación"
  - tipo: desencadenador
    id: BR-D04
    descripcion: "Actualizar métricas de agente al cerrar llamada"
  - tipo: calculo
    id: BR-C02
    descripcion: "Calcular duración total de llamada"
  - tipo: calculo
    id: BR-C03
    descripcion: "Actualizar AHT del agente"
  - tipo: calculo
    id: BR-C04
    descripcion: "Actualizar FCR si corresponde"
  - tipo: inferencia
    id: BR-I03
    descripcion: "Determinar si requiere seguimiento"
---

# UC-CALL-002: Atender Llamada

## Identificación

- **ID**: UC-CALL-002
- **Nombre**: Atender Llamada
- **Actor primario**: AGENTE
- **Nivel**: Usuario (sea level)
- **Prioridad**: Alta
- **Dominio**: Gestión de Llamadas

## Resumen

Un agente atiende una llamada que le fue asignada por el sistema, registra información relevante durante la conversación, clasifica la llamada al finalizar y cierra el registro. El sistema calcula métricas automáticamente (duración, AHT, FCR) y determina si requiere seguimiento.

**Objetivo del actor**: Atender efectivamente la necesidad del cliente y registrar la interacción completa con clasificación adecuada.

**Alcance**: Incluye aceptación de llamada, registro de notas, clasificación y cierre. NO incluye transferencias (UC-CALL-003) ni escalaciones.

## Actores

### Actor primario
- **Rol**: AGENTE
- **Descripción**: Operador de call center que atiende llamadas entrantes
- **Capacidades requeridas**: `llamadas.atender`, `llamadas.clasificar`

### Actores secundarios
- **Sistema de Grabación**: Registra audio de la conversación
- **Base de Datos PostgreSQL**: Almacena clasificación y notas
- **Sistema de Métricas**: Calcula KPIs en tiempo real

## Precondiciones

1. **BR-R09**: Agente está autenticado y logueado en el sistema
2. **BR-H01**: Existe una llamada asignada al agente (desde UC-CALL-001)
3. Agente tiene estado "en_llamada"
4. Sistema de grabación operativo

## Flujo Principal

| Actor (AGENTE) | Sistema |
|----------------|---------|
| 1. Agente recibe notificación de llamada asignada | |
| 2. Agente acepta la llamada | |
| | 3. Sistema actualiza estado llamada a "en_curso" |
| | 4. **BR-R08**: Sistema inicia/continúa grabación |
| | 5. Sistema muestra información del cliente (si existe) |
| 6. Agente atiende al cliente y registra notas | |
| 7. Agente ingresa notas de la conversación | |
| | 8. Sistema guarda notas en tiempo real (campo `notas`) |
| 9. Agente selecciona clasificación de llamada | |
| | 10. **BR-R10**: Sistema valida que clasificación fue seleccionada |
| 11. Agente marca si se resolvió en primer contacto | |
| 12. Agente confirma cierre de llamada | |
| | 13. Sistema registra `timestamp_fin` |
| | 14. **BR-C02**: Sistema calcula `duracion = timestamp_fin - timestamp_inicio` |
| | 15. **BR-H03**: Sistema guarda clasificación |
| | 16. Sistema actualiza estado llamada a "finalizada" |
| | 17. Sistema actualiza estado agente a "disponible" |
| | 18. **BR-D04**: Sistema dispara tarea Celery para actualizar métricas |
| | 19. **BR-I03**: Sistema determina si `requiere_seguimiento` |
| | 20. Sistema muestra confirmación de cierre |

## Flujos Alternos

### FA-1: Cliente cuelga antes de clasificación
**Momento**: Antes del paso 9
**Condición**: Sistema detecta desconexión del cliente

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 9.a. Sistema detecta desconexión |
| | 9.b. Sistema muestra modal: "Cliente desconectado. Debe clasificar antes de cerrar" |
| 9.c. Agente selecciona clasificación | |
| | **Continúa en paso 10** |

### FA-2: Llamada requiere seguimiento
**Momento**: Paso 19
**Condición**: **BR-I03**: resolucion_primer_contacto=False AND cliente.categoria IN ['VIP', 'Premium']

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 19.a. **BR-I03**: Sistema evalúa if requiere_seguimiento |
| | 19.b. Sistema marca llamada con flag `requiere_seguimiento=True` |
| | 19.c. Sistema crea tarea en módulo de seguimientos |
| | 19.d. Sistema notifica a supervisor |
| | **Continúa en paso 20** |

## Flujos de Excepción

### FE-1: Intento de cierre sin clasificación
**Momento**: Paso 10
**Condición de error**: Agente intenta cerrar sin seleccionar clasificación

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 10.e1. **BR-R10**: Sistema detecta clasificación vacía |
| | 10.e2. Sistema muestra error: "Debe seleccionar una clasificación antes de cerrar" |
| | 10.e3. Sistema impide cierre de llamada |
| 10.e4. Agente selecciona clasificación | |
| | **Retorna a paso 10** |

### FE-2: Error al calcular métricas
**Momento**: Paso 18
**Condición de error**: Celery task falla al actualizar métricas

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 18.e1. Sistema detecta fallo en tarea Celery |
| | 18.e2. Sistema registra error en log |
| | 18.e3. Sistema reintenta tarea (3 intentos con backoff) |
| | 18.e4. Si falla definitivamente: Sistema envía alerta a DevOps |
| | 18.e5. Sistema continúa con flujo normal (no bloquea al agente) |
| | **Continúa en paso 19** |

**Nota**: El cálculo de métricas es asíncrono y no debe bloquear al agente.

## Postcondiciones

### Postcondición de éxito
1. Llamada cerrada con estado="finalizada"
2. **BR-H03**: Clasificación registrada (no nula)
3. **BR-C02**: Duración calculada y guardada
4. Agente liberado (estado="disponible")
5. **BR-D04**: Métricas actualizadas (AHT, FCR)
6. **BR-I03**: Flag `requiere_seguimiento` evaluado

## Requisitos Especiales

### Usabilidad
- **RNF-010**: Interfaz debe permitir guardar notas cada 30 segundos automáticamente
- **RNF-011**: Clasificaciones más comunes deben estar a máximo 2 clicks

### Performance
- **RNF-012**: Guardado de notas debe ser instantáneo (<500ms)
- **RNF-013**: Cálculo de métricas debe ser asíncrono (no bloquea UI)

---

**Documentos relacionados:**
- [UC-CALL-001: Registrar Llamada Entrante](UC-CALL-001_registrar_llamada_entrante.md)
- [UC-CALL-003: Transferir Llamada](UC-CALL-003_transferir_llamada.md)
- [Reglas de Negocio](../../requisitos/REGLAS_NEGOCIO/README.md)

**Creado por**: Equipo de Call Center
**Fecha**: 2025-11-14
