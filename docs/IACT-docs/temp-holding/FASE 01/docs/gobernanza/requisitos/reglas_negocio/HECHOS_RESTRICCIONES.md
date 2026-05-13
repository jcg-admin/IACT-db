# Tipos de Reglas de Negocio: Hechos y Restricciones

**Documento:** Parte 2 - Hechos y Restricciones
**Versión:** 1.0
**Última actualización:** 2025-11-14

---

## Tabla de Contenidos

1. [Clasificación de Reglas de Negocio](#clasificación-de-reglas-de-negocio)
2. [Hechos (Facts)](#1-hechos-facts)
3. [Restricciones (Constraints)](#2-restricciones-constraints)
4. [Matriz de Roles y Permisos](#matriz-de-roles-y-permisos)
5. [Aplicación en IACT](#aplicación-en-iact)

---

## Clasificación de Reglas de Negocio

> **Concepto Clave:** Los cinco tipos de reglas de negocio son: Hechos, Restricciones, Desencadenadores de Acción, Inferencias y Cálculos Computacionales.

### Los Cinco Tipos

1. **Hechos:** Declaraciones que son ciertas acerca del negocio
2. **Restricciones:** Restringen las acciones que los sistemas o usuarios pueden realizar
3. **Desencadenadores de Acción:** Desencadenan comportamientos bajo ciertas condiciones
4. **Inferencias:** Establecen nuevos conocimientos basados en la verdad de ciertas condiciones
5. **Cálculos Computacionales:** Realizan cálculos utilizando fórmulas matemáticas o algoritmos

Este documento cubre los dos primeros tipos en detalle.

---

## 1. HECHOS (Facts)

### Definición

> **Concepto Clave:** Los hechos son declaraciones que son verdaderas sobre el negocio en un punto específico del tiempo.

Un hecho describe **asociaciones o relaciones** entre términos comerciales importantes. Los hechos son elementos **inmutables** que definen la realidad del negocio y no pueden ser cambiados arbitrariamente.

### Características de los Hechos

- Son **declaraciones verdaderas** sobre el negocio
- Describen **relaciones entre términos comerciales**
- Son **inmutables** por naturaleza
- Establecen **asociaciones fundamentales**

### Ejemplos Generales

#### Sistema de Gestión de Químicos (Ejemplo Original)

- Cada contenedor de productos químicos tiene un identificador de código de barras único
- Cada orden debe tener un costo de envío
- Cada artículo en una orden presenta una combinación específica de producto químico, grado, tamaño del envase y número de contenedores

#### Sistema Universitario

- Todos los alumnos deben tener una matrícula para ser estudiantes de la universidad
- Para ser alumno de la universidad, se debe estar registrado oficialmente

### Ejemplos Aplicados a IACT (Call Center)

#### Hechos sobre Agentes IVR

- Cada agente IVR debe tener una extensión telefónica única
- Cada agente debe estar asignado a exactamente un equipo de trabajo
- Cada agente tiene un supervisor directo asignado
- Cada sesión de agente debe registrar hora de inicio y hora de fin

#### Hechos sobre Llamadas

- Cada llamada registrada debe asociarse a un agente específico
- Cada llamada tiene una duración medida en segundos
- Cada llamada debe tener un estado: en_curso, finalizada, abandonada, transferida
- Cada llamada finalizada debe tener una clasificación de resultado

#### Hechos sobre Campañas

- Cada campaña debe tener una fecha de inicio y una fecha de finalización
- Cada campaña se asocia a uno o más productos/servicios
- Cada campaña puede tener múltiples scripts de llamada
- Cada contacto en una campaña puede tener múltiples intentos de llamada

#### Hechos sobre Base de Datos

- MariaDB (puerto 3306) contiene datos de IVR en modo solo lectura
- PostgreSQL (puerto 5432) contiene datos analíticos y operacionales
- Cada consulta a MariaDB debe usar el router de base de datos apropiado
- Cada tabla debe tener una clave primaria definida

---

## 2. RESTRICCIONES (Constraints)

### Definición

> **Concepto Clave:** Una restricción es una sentencia que restringe las acciones que el sistema o los usuarios pueden realizar, definiendo qué se puede hacer y qué no se puede hacer.

### Palabras Clave para Identificar Restricciones

Cuando encontramos estas frases o palabras en la documentación, prácticamente están describiendo una restricción:

| Indicador | Función | Ejemplo de Uso |
|-----------|---------|----------------|
| **Debe** | Obligación | "El usuario **debe** proporcionar credenciales" |
| **No debe** | Prohibición | "El sistema **no debe** mostrar datos confidenciales" |
| **No puede** | Limitación | "Un usuario **no puede** tener más de 10 sesiones activas" |
| **Solo puede** | Restricción exclusiva | "Solo **puede** acceder el administrador" |

### Ejemplos Generales

#### Sistema Financiero
Un solicitante de préstamo que es menor de 18 años **debe** tener un padre o tutor legal como cosignatario en el préstamo.

#### Sistema de Biblioteca
Un usuario de la biblioteca **puede** tener un máximo de 10 artículos en espera en cualquier momento.

#### Seguridad de Datos Personales
La correspondencia **no puede** mostrar más de cuatro dígitos del número de seguro social del asegurado.

**Ejemplo práctico:** Cuando realizas un pago en una tienda en línea, solo ves los últimos cuatro dígitos de tu tarjeta de crédito. Esta es una regla de negocio o política organizacional que establece no mostrar el número completo de la tarjeta.

### Ejemplos Aplicados a IACT (Call Center)

#### Restricciones de Acceso por Rol

**Agentes:**
- Un agente **no puede** acceder a grabaciones de llamadas de otros agentes
- Un agente **debe** estar logueado para recibir llamadas
- Un agente **no puede** tener más de 5 llamadas en cola simultáneamente
- Un agente **solo puede** ver su propio tablero de rendimiento

**Supervisores:**
- Un supervisor **puede** acceder a grabaciones de llamadas de agentes bajo su supervisión
- Un supervisor **debe** aprobar cambios de horario de sus agentes
- Un supervisor **no puede** eliminar registros históricos de llamadas
- Un supervisor **puede** reasignar llamadas entre agentes de su equipo

**Gerentes:**
- Un gerente **puede** generar reportes de cualquier equipo
- Un gerente **debe** autorizar descuentos superiores al 10%
- Un gerente **no puede** modificar configuraciones del sistema sin aprobación IT
- Un gerente **solo puede** acceder a datos financieros si tiene rol adicional de "Finanzas"

#### Restricciones Operacionales

**Llamadas:**
- Una llamada **no puede** durar más de 60 minutos sin aprobación de supervisor
- Una llamada abandonada **debe** registrar tiempo de espera
- Una llamada transferida **debe** mantener la grabación continua
- Una llamada **no puede** cerrarse sin seleccionar una clasificación

**Campañas:**
- Una campaña inactiva **no puede** recibir nuevas llamadas
- Una campaña **debe** tener al menos un script asociado antes de activarse
- Una campaña **no puede** tener fechas de inicio posteriores a fechas de fin
- Una campaña eliminada **no debe** aparecer en reportes activos

#### Restricciones de Seguridad y Privacidad

**Datos Personales:**
- Los datos de RFC y CURP **no deben** mostrarse completos en la interfaz (solo últimos 4 dígitos)
- Los números telefónicos de clientes **no pueden** ser exportados por agentes regulares
- Las direcciones de clientes **solo pueden** ser visualizadas por usuarios autorizados
- Los datos personales **deben** encriptarse en la base de datos (AES-256)

**Auditoría:**
- Toda modificación de datos personales **debe** registrarse en log de auditoría
- Los logs de auditoría **no pueden** ser eliminados por ningún usuario
- El acceso a logs de auditoría **solo puede** realizarse por el equipo de seguridad
- Los intentos fallidos de login **deben** bloquearse después de 5 intentos

---

## Matriz de Roles y Permisos

### Propósito

> **Concepto Clave:** La matriz de roles y permisos es una representación tabular concisa de las restricciones de acceso del sistema.

Una manera eficiente de documentar restricciones es a través de una **matriz de roles y permisos**, donde simplemente marcamos qué operaciones puede realizar cierto perfil, stakeholder o rol.

### Ejemplo: Matriz General

```
┌─────────────────┬─────────────┬─────────────┬─────────────┐
│   OPERACIÓN     │ADMINISTRADOR│    STAFF    │   USUARIO   │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Ver registro    │      SI     │      SI     │      SI     │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Editar registro │      SI     │      SI     │      NO     │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Eliminar        │      SI     │      NO     │      NO     │
│ registro        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Buscar en       │      SI     │      SI     │      SI     │
│ catálogo        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Generar         │      SI     │      SI     │      NO     │
│ reportes        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Configurar      │      SI     │      NO     │      NO     │
│ sistema         │             │             │             │
└─────────────────┴─────────────┴─────────────┴─────────────┘
```

### Matriz de Roles y Permisos - IACT Call Center

```
┌─────────────────────────────┬───────┬────────────┬─────────┬────────────┐
│         OPERACIÓN           │AGENTE │ SUPERVISOR │ GERENTE │ ADMIN IT   │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Recibir llamadas            │  SI   │     SI     │   NO    │     NO     │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Transferir llamadas         │  SI   │     SI     │   SI    │     NO     │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Ver grabaciones propias     │  SI   │     SI     │   SI    │     SI     │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Ver grabaciones de otros    │  NO   │  SI (equipo│   SI    │     SI     │
│                             │       │    propio) │         │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Generar reportes            │  NO   │  SI (equipo│   SI    │     NO     │
│ individuales                │       │    propio) │ (todos) │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Generar reportes            │  NO   │     NO     │   SI    │     SI     │
│ financieros                 │       │            │         │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Modificar campañas          │  NO   │     NO     │   SI    │     SI     │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Reasignar agentes           │  NO   │  SI (equipo│   SI    │     NO     │
│                             │       │    propio) │ (todos) │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Acceder a datos personales  │  SI   │     SI     │   SI    │     NO     │
│ de clientes                 │(vista │  (vista    │ (vista  │            │
│                             │  base)│  completa) │completa)│            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Exportar datos de clientes  │  NO   │     NO     │   SI    │     NO     │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Modificar configuración     │  NO   │     NO     │   NO    │     SI     │
│ del sistema                 │       │            │         │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Acceder a logs de           │  NO   │     NO     │   NO    │     SI     │
│ auditoría                   │       │            │         │            │
├─────────────────────────────┼───────┼────────────┼─────────┼────────────┤
│ Gestionar usuarios          │  NO   │     NO     │   SI    │     SI     │
│                             │       │            │(gerentes│  (todos)   │
│                             │       │            │   only) │            │
└─────────────────────────────┴───────┴────────────┴─────────┴────────────┘
```

### Ventajas de la Matriz

1. **Claridad visual:** Permite ver de un vistazo qué puede hacer cada rol
2. **Documentación concisa:** Evita descripciones largas en lenguaje natural
3. **Fácil mantenimiento:** Cambios de permisos se reflejan fácilmente
4. **Comunicación efectiva:** Stakeholders entienden rápidamente las restricciones
5. **Base para desarrollo:** Los desarrolladores pueden implementar controles de acceso directamente

---

## Aplicación en IACT

### Proceso de Identificación de Hechos

**Paso 1:** Identificar entidades principales del dominio
- Agentes, Llamadas, Campañas, Clientes, Equipos

**Paso 2:** Definir relaciones entre entidades
- Un agente pertenece a un equipo
- Una llamada se asocia a un agente
- Una campaña contiene múltiples llamadas

**Paso 3:** Documentar atributos obligatorios
- Cada agente debe tener: nombre, extensión, equipo
- Cada llamada debe tener: timestamp, duración, agente

**Paso 4:** Establecer cardinalidades
- Un agente → muchas llamadas (1:N)
- Un equipo → muchos agentes (1:N)
- Una campaña → muchas llamadas (1:N)

### Proceso de Identificación de Restricciones

**Paso 1:** Revisar políticas organizacionales
- Políticas de seguridad
- Políticas de privacidad
- Políticas operacionales

**Paso 2:** Analizar regulaciones aplicables
- LFPDPPP (protección de datos)
- Regulaciones de telecomunicaciones
- Estándares de industria de call centers

**Paso 3:** Identificar roles de usuario
- Agente, Supervisor, Gerente, Admin IT

**Paso 4:** Definir permisos por rol
- Crear matriz de roles y permisos
- Documentar excepciones
- Establecer escalaciones

**Paso 5:** Implementar controles de acceso
- Django permissions framework
- React role-based components
- Validaciones en API REST

---

## Resumen

### Hechos

- Son **verdades inmutables** del negocio
- **Describen relaciones** entre elementos
- **No se pueden cambiar** arbitrariamente
- Establecen la **base de conocimiento** del sistema

### Restricciones

- **Limitan acciones** de usuarios y sistemas
- Se identifican con palabras como **debe**, **no debe**, **no puede**, **solo puede**
- Se documentan eficientemente con **matrices de roles y permisos**
- Definen **qué está permitido y qué no** en el sistema

> **Nota Importante:** La correcta identificación y documentación de hechos y restricciones es fundamental para el desarrollo de sistemas que cumplan con las expectativas del negocio y las regulaciones aplicables.

---

## Documentos Relacionados

- [Introducción a las Reglas de Negocio](INTRODUCCION.md)
- [Tipos Avanzados: Activadores, Inferencias y Cálculos](TIPOS_AVANZADOS.md)
- [Aplicación en el Proyecto IACT](APLICACION_IACT.md)
- [Constitución del Proyecto - Reglas R1-R6](../../../../.constitucion.yaml)

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
