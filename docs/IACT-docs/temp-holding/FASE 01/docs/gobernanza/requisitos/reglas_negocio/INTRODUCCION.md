# Introducción a las Reglas de Negocio

**Documento:** Parte 1 - Fundamentos y Conceptos Clave
**Versión:** 1.0
**Última actualización:** 2025-11-14

---

## Tabla de Contenidos

1. [¿Qué es una Regla de Negocio?](#qué-es-una-regla-de-negocio)
2. [Funciones de las Reglas de Negocio](#funciones-de-las-reglas-de-negocio)
3. [Jerarquía de Requerimientos](#jerarquía-de-requerimientos)
4. [Influencia en Tipos de Requerimientos](#influencia-en-tipos-de-requerimientos)
5. [Ejemplos Aplicados a IACT](#ejemplos-aplicados-a-iact)

---

## ¿Qué es una Regla de Negocio?

### Definición Formal

> **Concepto Clave:** Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.

Cada organización opera de acuerdo con un extenso conjunto de políticas, leyes y estándares de la industria. En pocas palabras, las **reglas de negocio** son estas políticas, leyes y estándares bajo los que se rigen las organizaciones.

### Contexto de Industria

Industrias como la banca, la aviación, la fabricación de dispositivos médicos y **centros de contacto (call centers)** deben cumplir con un volumen significativo de regulaciones gubernamentales.

### Ejemplo Práctico: Gestión de Residuos en Emergencia Sanitaria

Durante situaciones de emergencia sanitaria, existen regulaciones específicas que todas las organizaciones deben atender:

- Tratamiento de residuos bacteriológicos
- Protocolos de movimiento y captación
- Procedimientos de eliminación segura

Estos constituyen estándares, políticas o reglas que se implementan para el manejo adecuado de residuos.

---

## Funciones de las Reglas de Negocio

> **Concepto Clave:** Las reglas de negocio también se conocen colectivamente como "lógica de negocio" y tienen dos funciones principales:

### 1. Restricción de Acceso

Restringen **quién puede realizar ciertos casos de uso** del sistema.

**Ejemplos:**
- Solo supervisores pueden acceder a reportes financieros
- Únicamente administradores pueden eliminar registros de llamadas
- Gerentes pueden aprobar descuentos mayores al 10%

### 2. Control de Funcionalidad

Dictan **qué funcionalidad debe continuar el sistema** para cumplir con las normas pertinentes.

**Ejemplos:**
- El sistema debe encriptar datos personales según LFPDPPP
- Todas las transacciones financieras deben registrar auditoría
- Las grabaciones de llamadas deben conservarse por 90 días

---

## Jerarquía de Requerimientos

```
┌─────────────────────────────────────────────────────────────┐
│                  JERARQUÍA DE REQUERIMIENTOS                │
├─────────────────────────────────────────────────────────────┤
│  Nivel 1: REGLAS DE NEGOCIO                                │
│  (Políticas, Leyes, Estándares)                            │
│                         |                                   │
│                         v                                   │
│  Nivel 2: REQUERIMIENTOS DE NEGOCIO                        │
│  (Objetivos organizacionales)                              │
│                         |                                   │
│                         v                                   │
│  Nivel 3: REQUERIMIENTOS DE USUARIO                        │
│  (Necesidades específicas del usuario)                     │
│                         |                                   │
│                         v                                   │
│  Nivel 4: REQUERIMIENTOS FUNCIONALES                       │
│  (Funcionalidades del sistema)                             │
│                         |                                   │
│                         v                                   │
│  Nivel 5: ATRIBUTOS DE CALIDAD                            │
│  (Características no funcionales)                          │
└─────────────────────────────────────────────────────────────┘
```

### Relación entre Niveles

Las **reglas de negocio** constituyen el nivel más alto y ejercen influencia directa sobre todos los demás niveles. Esta influencia se manifiesta de manera cascada:

1. Las **reglas de negocio** definen restricciones y políticas
2. Los **requerimientos de negocio** se derivan de estas reglas
3. Los **requerimientos de usuario** implementan las políticas
4. Los **requerimientos funcionales** codifican la lógica de negocio
5. Los **atributos de calidad** garantizan el cumplimiento

---

## Influencia en Tipos de Requerimientos

### Tabla de Influencia Directa

| Tipo de Requerimiento | Cómo Influyen las Reglas de Negocio | Ejemplo Práctico IACT |
|----------------------|-------------------------------------|----------------------|
| **Requerimientos de Negocio** | Las regulaciones gubernamentales pueden conducir a objetivos de negocio necesarios para un proyecto | El sistema de call center debe cumplir con LFPDPPP para protección de datos personales de clientes en un período de 6 meses |
| **Requerimientos de Usuario** | Las políticas de privacidad dictan qué usuarios pueden y no pueden realizar ciertas tareas con el sistema | Los supervisores están autorizados a acceder a grabaciones de llamadas de cualquier agente para fines de capacitación |
| **Requerimientos Funcionales** | Las políticas empresariales establecen procesos específicos que el sistema debe implementar | **Política:** Toda llamada debe clasificarse antes de cerrar. **Funcionalidad:** El sistema bloqueará el cierre de llamada hasta que el agente seleccione una clasificación del catálogo predefinido |
| **Atributos de Calidad** | Las regulaciones de agencias gubernamentales pueden dictar ciertos requisitos de seguridad que deben aplicarse a través de la funcionalidad del sistema | El sistema debe encriptar todos los datos personales (nombre, RFC, CURP, dirección) usando AES-256 antes de almacenarlos en la base de datos |

---

## Ejemplos Aplicados a IACT

### 1. Requerimientos de Negocio

**Regla de Negocio:**
Las regulaciones de la LFPDPPP (Ley Federal de Protección de Datos Personales en Posesión de los Particulares) nos dictan que los datos personales de clientes deben protegerse y que el cliente debe consentir explícitamente su uso.

**Requerimiento de Negocio Derivado:**
El sistema de call center debe implementar un mecanismo de consentimiento explícito para uso de datos personales en un período de 6 meses.

### 2. Requerimientos de Usuario

**Regla de Negocio:**
Solo los supervisores pueden acceder a reportes de rendimiento individual de agentes.

**Requerimiento de Usuario Derivado:**
La funcionalidad de generación de reportes de rendimiento individual está restringida por rol de usuario, definiendo claramente qué puede hacer cada tipo de usuario:

- **Supervisor:** Puede ver reportes de todos los agentes
- **Gerente:** Puede ver reportes de todos los supervisores y agentes
- **Agente:** Solo puede ver su propio reporte

### 3. Requerimientos Funcionales

**Regla de Negocio (Política Organizacional):**
Para registrar una venta exitosa, el agente debe capturar: nombre completo del cliente, producto vendido, monto, y número de confirmación.

**Requerimiento Funcional Derivado:**
Cuando un agente intenta cerrar una llamada como "Venta Exitosa", el sistema validará que los siguientes campos estén completos:
- Nombre completo del cliente
- Producto vendido (selección de catálogo)
- Monto de venta (número positivo)
- Número de confirmación (alfanumérico, 10 caracteres)

Si algún campo está vacío, el sistema mostrará un mensaje de error y no permitirá cerrar la llamada.

### 4. Atributos de Calidad

**Regla de Negocio (Regulación de Seguridad):**
En México, la LFPDPPP y agencias como el INAI establecen requisitos de seguridad específicos para protección de datos personales.

**Atributo de Calidad Derivado:**
El sistema debe mantener logs de auditoría que registren:
- Quién accedió a datos personales de clientes
- Cuándo se accedió (timestamp)
- Qué datos se consultaron
- Desde qué IP/dispositivo

Estos logs deben conservarse por un mínimo de 2 años y ser inmutables.

---

## Contexto Legal Mexicano

### LFPDPPP (Ley Federal de Protección de Datos Personales)

**Aplicación en IACT:**
- **Datos sensibles:** RFC, CURP, dirección, teléfono
- **Consentimiento:** Debe ser explícito, informado y por escrito
- **Derechos ARCO:** Acceso, Rectificación, Cancelación, Oposición
- **Avisos de Privacidad:** Obligatorios al capturar datos

### Regulaciones de Call Centers

**Estándares de Industria:**
- Grabación de llamadas (con consentimiento)
- Conservación de registros (90-180 días típicamente)
- Protección de información del cliente
- No llamar a números en REUS (Registro Público de Usuarios que no desean recibir publicidad)

---

## Conclusión

Las reglas de negocio constituyen el nivel más alto en la jerarquía de requerimientos y ejercen una influencia directa y determinante sobre todos los demás tipos de requerimientos. Comprender esta influencia es fundamental para el análisis efectivo de requerimientos y el diseño de sistemas que cumplan con las normativas y políticas organizacionales.

En el contexto del proyecto IACT (sistema de call center), las reglas de negocio están particularmente relacionadas con:

1. **Protección de datos personales** (LFPDPPP)
2. **Seguridad de información**
3. **Trazabilidad de operaciones**
4. **Control de acceso por roles**
5. **Cumplimiento regulatorio**

---

## Documentos Relacionados

- [Tipos de Reglas: Hechos y Restricciones](HECHOS_RESTRICCIONES.md)
- [Tipos Avanzados: Activadores, Inferencias y Cálculos](TIPOS_AVANZADOS.md)
- [Aplicación en el Proyecto IACT](APLICACION_IACT.md)
- [Constitución del Proyecto](../../../../.constitucion.yaml)

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
