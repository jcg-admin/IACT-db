# Casos de Uso - Proyecto IACT

**Documento:** Metodología y Especificación de Casos de Uso
**Versión:** 1.0
**Última actualización:** 2025-11-14
**Relacionado:** [Reglas de Negocio](reglas_negocio/README.md)

---

## Tabla de Contenidos

1. [¿Qué es un Caso de Uso?](#qué-es-un-caso-de-uso)
2. [Especificar vs Ilustrar](#especificar-vs-ilustrar)
3. [Nomenclatura y Actores](#nomenclatura-y-actores)
4. [Elementos de un Caso de Uso](#elementos-de-un-caso-de-uso)
5. [Formatos y Grados de Formalidad](#formatos-y-grados-de-formalidad)
6. [Casos de Uso IACT](#casos-de-uso-iact)
7. [Relación con Reglas de Negocio](#relación-con-reglas-de-negocio)

---

## ¿Qué es un Caso de Uso?

> **Concepto Clave:** Un caso de uso describe una secuencia de interacciones entre un sistema y un actor que resulta en que el actor logre algún resultado de valor.

Un caso de uso es un término de ingeniería de software que describe **cómo un usuario utiliza un sistema para lograr un objetivo en particular**. Es la relación e interacción entre actores y el sistema.

### Historia

Los casos de uso fueron introducidos en 1986 por **Ivar Jacobson**, uno de los principales contribuidores de UML y el Proceso Unificado.

---

## Especificar vs Ilustrar

> **IMPORTANTE:** Los casos de uso son documentos de texto, NO diagramas.

### Diferencia Fundamental

- **Especificar Casos de Uso:** Escribir documentos de texto con escenarios y pasos
- **Ilustrar Diagramas UML:** Crear vistas gráficas con actores, casos de uso y relaciones

```
┌─────────────────────────────────────────────────────────┐
│  ESPECIFICAR CASOS DE USO  ≠  DIAGRAMAS UML            │
├─────────────────────────────────────────────────────────┤
│  Documentos de texto       │  Ilustraciones/fotografías │
│  Escenarios y pasos        │  Actores (figuras de palo) │
│  Flujos alternos           │  Óvalos (casos de uso)     │
│  Precondiciones            │  Flechas (relaciones)      │
│  Postcondiciones           │  Límite del sistema        │
└─────────────────────────────────────────────────────────┘
```

### Qué vs Cómo

> **Principio de Especificación:** Los casos de uso especifican **QUÉ** debe hacer el sistema, sin decidir **CÓMO** se hará.

**Correcto:**
✅ "El sistema guarda una venta"

**Incorrecto:**
❌ "El sistema escribe la venta en base de datos SQL con INSERT"

---

## Nomenclatura y Actores

### Nomenclatura de Casos de Uso

> **Regla Obligatoria:** Los nombres de casos de uso se escriben SIEMPRE como:
>
> **VERBO + OBJETO**

#### Ejemplos IACT

| Caso de Uso | Verbo | Objeto |
|-------------|-------|--------|
| Registrar Llamada | Registrar | Llamada |
| Asignar Agente | Asignar | Agente |
| Transferir Llamada | Transferir | Llamada |
| Generar Reporte | Generar | Reporte |
| Crear Campaña | Crear | Campaña |
| Actualizar Cliente | Actualizar | Cliente |

### Actores

> **Concepto Clave:** Un actor es un ente (persona, sistema, dispositivo) que interactúa con el sistema para ejecutar un caso de uso.

#### Tipos de Actores

**Actores Primarios:**
- Tienen objetivos específicos cumplidos mediante el uso del sistema
- **Ejecutan y disparan** el caso de uso
- Ejemplo: Agente, Supervisor, Gerente

**Actores Secundarios (de Apoyo):**
- Proporcionan servicios o información al sistema
- Brindan soporte pero no ejecutan el caso de uso
- Ejemplo: Sistema IVR, Base de Datos, Servicio de Notificaciones

#### Buenas Prácticas

- **Capitalizar nombres** de actores en especificaciones: AGENTE, SUPERVISOR
- Un actor puede ser primario en un caso de uso y secundario en otro

---

## Elementos de un Caso de Uso

### 1. Identificación

| Elemento | Descripción | Ejemplo |
|----------|-------------|---------|
| **ID** | Identificador único | UC-001 |
| **Nombre** | Verbo + Objeto | Registrar Llamada Entrante |
| **Creado por** | Autor del caso de uso | Equipo de Análisis |
| **Fecha** | Fecha de creación | 2025-11-14 |

### 2. Actores

- **Actores Primarios:** Quién ejecuta el caso de uso
- **Actores Secundarios:** Quién proporciona soporte

### 3. Precondiciones

> **Concepto:** Estado que debe ser cierto ANTES de empezar el escenario.

**Ejemplo:**
- Caso de Uso: Ingresar al Sistema
- Precondición: El usuario debe tener una cuenta registrada

**Importante:** Puede haber **0 o más** precondiciones.

### 4. Curso Normal (Happy Path)

> **Concepto:** Camino o trayectoria típica de éxito que satisface los intereses de las partes.

También llamado **"camino feliz"**. NO incluye condiciones ni ramificaciones, solo el flujo exitoso principal.

### 5. Cursos Alternos y Excepciones

**Curso Alterno:** Otros escenarios de éxito o fracaso que requieren una extensión.

Una extensión tiene dos partes:
1. **Condición:** Algo detectado por el sistema
2. **Manipulación:** Secuencia de pasos para manejar la condición

**Excepción:** Caso especial dentro de un flujo alterno.

### 6. Postcondiciones

> **Concepto:** Estado que debe ser cierto al finalizar con éxito el caso de uso.

**Ejemplo:**
- Caso de Uso: Ingresar al Sistema
- Postcondición: El usuario ingresó al sistema y tiene sesión activa

### 7. Información Adicional

- **Prioridad:** Alta, Media, Baja
- **Frecuencia:** Diaria, Semanal, Mensual
- **Reglas de Negocio:** IDs de reglas relacionadas
- **Requisitos Especiales:** Requerimientos no funcionales específicos

---

## Formatos y Grados de Formalidad

### Grados de Formalidad

**1. Breves:**
- Resumen en un párrafo del escenario principal

**2. Casuales:**
- Párrafos informales cubriendo varios escenarios

**3. Completos:**
- Todos los pasos y variaciones escritos en detalle
- Secciones de precondiciones y postcondiciones
- **Este es el formato usado en IACT**

### Formato de Dos Columnas

```
┌──────────────────────────────┬────────────────────────────────┐
│  ACCIONES DEL ACTOR          │  RESPONSABILIDADES DEL SISTEMA │
├──────────────────────────────┼────────────────────────────────┤
│ 1. Actor realiza acción      │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 2. Sistema responde            │
├──────────────────────────────┼────────────────────────────────┤
│ 3. Actor proporciona datos   │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 4. Sistema valida y procesa    │
└──────────────────────────────┴────────────────────────────────┘
```

---

## Casos de Uso IACT

### UC-001: Registrar Llamada Entrante

**ID:** UC-001
**Nombre:** Registrar Llamada Entrante
**Actores Primarios:** Sistema IVR
**Actores Secundarios:** Base de Datos, Agente Disponible
**Prioridad:** Alta
**Frecuencia:** Continua (24/7)
**Reglas de Negocio:** BR-H01, BR-R02, BR-D01, BR-C01

#### Descripción

El sistema registra una llamada entrante desde el IVR y la asigna a un agente disponible según reglas de distribución.

#### Desencadenador

Una llamada entra al sistema IVR.

#### Precondiciones

- Existe al menos un agente en estado "disponible"
- El sistema IVR está operativo
- La base de datos PostgreSQL está accesible

#### Curso Normal

```
┌──────────────────────────────┬────────────────────────────────┐
│  ACCIONES DEL SISTEMA IVR    │  RESPONSABILIDADES DEL SISTEMA │
├──────────────────────────────┼────────────────────────────────┤
│ 1. IVR detecta llamada       │                                │
│    entrante con ANI          │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 2. Sistema valida ANI y crea   │
│                              │    registro de llamada         │
│                              │    (BR-H01: Hecho)             │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 3. Sistema busca agente        │
│                              │    disponible (BR-R02)         │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 4. Sistema asigna llamada a    │
│                              │    agente disponible           │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 5. Sistema notifica a agente   │
│                              │    (Ver 5.1)                   │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 6. Sistema inicia grabación    │
│                              │    (BR-R08: Consentimiento)    │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 7. Sistema actualiza estado    │
│                              │    llamada a "en_curso"        │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 8. Sistema registra timestamp  │
│                              │    inicio (BR-C01: AHT)        │
└──────────────────────────────┴────────────────────────────────┘
```

#### Flujos Alternos

**5.1 Si agente no responde en 20 segundos:**
- 5.1.1 Sistema cancela asignación
- 5.1.2 Sistema marca agente como "no_disponible"
- 5.1.3 Sistema busca siguiente agente disponible
- 5.1.4 Sistema registra evento de no respuesta
- 5.1.5 **Regresa al paso 4**

**5.2 Si no hay agentes disponibles:**
- 5.2.1 Sistema coloca llamada en cola
- 5.2.2 Sistema reproduce mensaje de espera
- 5.2.3 Sistema monitorea tiempo en cola (**BR-D02**)
- 5.2.4 **SI** tiempo_espera > 5 minutos **ENTONCES** escalar a supervisor
- 5.2.5 Cuando agente disponible → **Regresa al paso 4**

**5.3 Si cliente abandona antes de asignación:**
- 5.3.1 Sistema registra llamada como "abandonada"
- 5.3.2 Sistema calcula tiempo de espera
- 5.3.3 Sistema actualiza métricas de abandono (BR-C07)
- 5.3.4 Caso de uso termina

#### Postcondiciones

- Llamada registrada en base de datos
- Llamada asignada a agente o en cola
- Grabación iniciada (si procede)
- Métricas actualizadas

### UC-002: Transferir Llamada

**ID:** UC-002
**Nombre:** Transferir Llamada
**Actores Primarios:** SUPERVISOR
**Actores Secundarios:** Agente Origen, Agente Destino, Sistema
**Prioridad:** Alta
**Frecuencia:** Diaria
**Reglas de Negocio:** BR-R03, BR-R04, BR-H02, BR-D02, BR-C02

#### Descripción

Un supervisor transfiere una llamada de un agente a otro, manteniendo la continuidad de la grabación y actualizando métricas.

#### Desencadenador

Supervisor indica necesidad de transferir una llamada activa.

#### Precondiciones

- Supervisor autenticado y autorizado (**BR-R03**)
- Existe una llamada en estado "en_curso"
- Existe al menos un agente destino disponible

#### Curso Normal

```
┌──────────────────────────────┬────────────────────────────────┐
│  ACCIONES DEL SUPERVISOR     │  RESPONSABILIDADES DEL SISTEMA │
├──────────────────────────────┼────────────────────────────────┤
│ 1. Supervisor selecciona     │                                │
│    llamada a transferir      │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 2. Sistema valida permisos     │
│                              │    (BR-R03: Restricción)       │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 3. Sistema muestra lista de    │
│                              │    agentes disponibles         │
├──────────────────────────────┼────────────────────────────────┤
│ 4. Supervisor selecciona     │                                │
│    agente destino            │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 5. Sistema valida              │
│                              │    disponibilidad agente       │
│                              │    (BR-R04: Debe estar libre)  │
│                              │    (Ver 5.1)                   │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 6. Sistema guarda agente_      │
│                              │    anterior en historial       │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 7. Sistema reasigna llamada    │
│                              │    manteniendo grabación       │
│                              │    (BR-H02: Hecho)             │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 8. Sistema notifica a agente   │
│                              │    destino (BR-D02)            │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 9. Sistema actualiza estado a  │
│                              │    "transferida"               │
├──────────────────────────────┼────────────────────────────────┤
│                              │10. Sistema calcula tiempo en   │
│                              │    transferencia (BR-C02)      │
└──────────────────────────────┴────────────────────────────────┘
```

#### Flujos Alternos

**5.1 Si agente destino no disponible:**
- 5.1.1 Sistema muestra mensaje de error
- 5.1.2 Sistema sugiere otros agentes disponibles
- 5.1.3 **Regresa al paso 3**

#### Postcondiciones

- Llamada transferida exitosamente
- Grabación continua mantenida
- Historial actualizado con transferencia
- Métricas de tiempo actualizadas
- Agente destino atendiendo llamada

### UC-003: Generar Reporte de Rendimiento

**ID:** UC-003
**Nombre:** Generar Reporte de Rendimiento de Equipo
**Actores Primarios:** GERENTE
**Actores Secundarios:** Base de Datos PostgreSQL
**Prioridad:** Media
**Frecuencia:** Diaria/Semanal
**Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02

#### Descripción

Un gerente genera un reporte de rendimiento de un equipo específico, incluyendo métricas individuales de agentes y promedios del equipo.

#### Desencadenador

Gerente solicita reporte de rendimiento.

#### Precondiciones

- Gerente autenticado con rol "Gerente" (**BR-R05**)
- Existe data de llamadas en el rango de fechas seleccionado

#### Curso Normal

```
┌──────────────────────────────┬────────────────────────────────┐
│  ACCIONES DEL GERENTE        │  RESPONSABILIDADES DEL SISTEMA │
├──────────────────────────────┼────────────────────────────────┤
│ 1. Gerente accede al módulo  │                                │
│    de reportes               │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 2. Sistema valida permisos     │
│                              │    (BR-R05: Solo gerentes)     │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 3. Sistema muestra formulario  │
│                              │    de selección                │
├──────────────────────────────┼────────────────────────────────┤
│ 4. Gerente selecciona:       │                                │
│    - Equipo                  │                                │
│    - Rango de fechas         │                                │
├──────────────────────────────┼────────────────────────────────┤
│ 5. Gerente solicita          │                                │
│    generación de reporte     │                                │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 6. Sistema calcula métricas    │
│                              │    individuales para cada      │
│                              │    agente:                     │
│                              │    - AHT (BR-C03)              │
│                              │    - FCR (BR-C04)              │
│                              │    - CSAT                      │
│                              │    - Total llamadas            │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 7. Sistema clasifica           │
│                              │    rendimiento de cada agente  │
│                              │    (BR-I01: Inferencia)        │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 8. Sistema calcula promedios   │
│                              │    del equipo                  │
├──────────────────────────────┼────────────────────────────────┤
│                              │ 9. Sistema genera reporte en   │
│                              │    formato seleccionado        │
├──────────────────────────────┼────────────────────────────────┤
│                              │10. Sistema muestra reporte     │
├──────────────────────────────┼────────────────────────────────┤
│ 11. Gerente revisa y         │                                │
│     puede exportar           │                                │
└──────────────────────────────┴────────────────────────────────┘
```

#### Postcondiciones

- Reporte generado exitosamente
- Métricas calculadas y clasificadas
- Reporte disponible para visualización y exportación

---

## Relación con Reglas de Negocio

### Mapeo Reglas → Casos de Uso

Los casos de uso **implementan** las reglas de negocio en flujos de trabajo específicos:

| Tipo de Regla | Cómo Aparece en Caso de Uso | Ejemplo |
|---------------|------------------------------|---------|
| **Hechos** | Precondiciones, datos del sistema | "Cada llamada debe tener agente asignado" |
| **Restricciones** | Validaciones, permisos | "Solo supervisores pueden transferir" |
| **Desencadenadores** | Flujos alternos, acciones automáticas | "Si espera > 5min, escalar" |
| **Inferencias** | Cálculos de estado, clasificaciones | "Clasificar rendimiento de agente" |
| **Cálculos** | Métricas, totales | "Calcular AHT del periodo" |

### Trazabilidad

Cada caso de uso debe referenciar las reglas de negocio que implementa:

```
UC-001: Registrar Llamada Entrante
Reglas de Negocio:
- BR-H01: Cada llamada tiene agente asignado
- BR-R02: Agente debe estar disponible
- BR-D01: Notificación a agente
- BR-C01: Registro de timestamp para AHT
```

### Validación con Business Rules Validator

El agente `business_rules_validator_agent.py` puede extenderse para validar:
- Referencias correctas entre casos de uso y reglas de negocio
- Consistencia entre especificaciones y diagramas UML
- Completitud de precondiciones/postcondiciones

---

## Diagramas UML de Casos de Uso

### Elementos del Diagrama

```
┌────────────────────────────────────────────┐
│        SISTEMA IACT CALL CENTER            │
│                                            │
│   👤 ────────▶ ╭──────────────────╮        │
│  Agente        │ Registrar Llamada│        │
│                ╰──────────────────╯        │
│                                            │
│                ╭──────────────────╮        │
│                │ Transferir       │◀───👤  │
│                │ Llamada          │   Super│
│                ╰──────────────────╯   visor│
│                                            │
│                ╭──────────────────╮        │
│   👤 ────────▶ │ Generar Reporte  │        │
│ Gerente        ╰──────────────────╯        │
│                         │                  │
│                         │                  │
│                         ▼                  │
│                     ┌──────┐               │
│                     │  BD  │               │
│                     └──────┘               │
└────────────────────────────────────────────┘
```

### Interpretación de Flechas

> **IMPORTANTE:** La dirección de las flechas determina el tipo de actor.

**Flecha Actor → Caso de Uso:**
- El actor es **primario** (ejecuta el caso de uso)
- Ejemplo: Agente → Registrar Llamada

**Flecha Caso de Uso → Actor:**
- El actor es **secundario** (proporciona soporte)
- Ejemplo: Generar Reporte → Base de Datos

---

## Resumen

### Conceptos Clave

1. **Casos de uso son texto**, diagramas UML son ilustraciones
2. **Nomenclatura obligatoria:** Verbo + Objeto
3. **Actores primarios ejecutan**, secundarios apoyan
4. **Especificar QUÉ**, no CÓMO
5. **Escenarios = instancias** de casos de uso
6. **Precondiciones (0+)** antes, **postcondiciones** después
7. **Curso normal + flujos alternos** con extensiones
8. **Trazabilidad** con reglas de negocio

### Relación con Desarrollo

```
Reglas de Negocio
      ↓
Casos de Uso (UC-001, UC-002...)
      ↓
Requerimientos Funcionales
      ↓
Implementación (Django + React)
      ↓
Tests (validación de reglas y casos de uso)
```

---

## Documentos Relacionados

- [Reglas de Negocio - README](REGLAS_NEGOCIO/README.md)
- [Introducción a Reglas de Negocio](REGLAS_NEGOCIO/INTRODUCCION.md)
- [Hechos y Restricciones](REGLAS_NEGOCIO/HECHOS_RESTRICCIONES.md)
- [Tipos Avanzados](REGLAS_NEGOCIO/TIPOS_AVANZADOS.md)
- [Aplicación IACT](REGLAS_NEGOCIO/APLICACION_IACT.md)
- [Constitución del Proyecto](../../.constitucion.yaml)

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
