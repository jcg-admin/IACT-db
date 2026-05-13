---
title: Marco Conceptual - Reglas de Negocio en Ingeniería de Requerimientos
date: 2025-11-13
domain: gobernanza
tipo: marco_conceptual
status: active
---

# Reglas de Negocio en Ingeniería de Requerimientos

## Parte 1: Fundamentos y Tipos

### ¿Qué es una Regla de Negocio?

> Concepto Clave: Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.

Cada organización opera de acuerdo con un extenso conjunto de políticas, leyes y estándares de la industria. En pocas palabras, decimos que las **reglas de negocio** son estas políticas, leyes y estándares bajo los que se rigen las organizaciones.

> Nota contextual importante: Industrias como la banca, la aviación y la fabricación de dispositivos médicos deben cumplir con un volumen significativo de regulaciones gubernamentales.

### Ejemplo Práctico: Gestión de Residuos en Emergencia Sanitaria

Durante situaciones de emergencia sanitaria, existen regulaciones específicas que todas las organizaciones deben atender:

- Tratamiento de residuos bacteriológicos
- Protocolos de movimiento y captación
- Procedimientos de eliminación segura

Estos constituyen estándares, políticas o reglas que se implementan para el manejo adecuado de residuos.

### Jerarquía de Requerimientos

```
┌─────────────────────────────────────────────────────────────┐
│                    JERARQUÍA DE REQUERIMIENTOS              │
├─────────────────────────────────────────────────────────────┤
│  Nivel 1: REGLAS DE NEGOCIO                                │
│  (Políticas, Leyes, Estándares)                            │
│                         │                                   │
│                         ▼                                   │
│  Nivel 2: REQUERIMIENTOS DE NEGOCIO                        │
│  (Objetivos organizacionales)                              │
│                         │                                   │
│                         ▼                                   │
│  Nivel 3: REQUERIMIENTOS DE USUARIO                        │
│  (Necesidades específicas del usuario)                     │
│                         │                                   │
│                         ▼                                   │
│  Nivel 4: REQUERIMIENTOS FUNCIONALES                       │
│  (Funcionalidades del sistema)                             │
│                         │                                   │
│                         ▼                                   │
│  Nivel 5: ATRIBUTOS DE CALIDAD                            │
│  (Características no funcionales)                          │
└─────────────────────────────────────────────────────────────┘
```

### Funciones de las Reglas de Negocio

> Concepto Clave: Las reglas de negocio también se conocen colectivamente como "lógica de negocio" y tienen dos funciones principales:

1. **Restricción de acceso**: Restringen quién puede realizar ciertos casos de uso
2. **Control de funcionalidad**: Dictan qué funcionalidad debe continuar el sistema para cumplir con las normas pertinentes

### Influencia de las Reglas de Negocio en los Tipos de Requerimientos

Las **reglas de negocio** influyen de manera directa sobre varios tipos de requerimientos:

| Tipo de Requerimiento | Cómo Influyen las Reglas de Negocio | Ejemplo Práctico |
|---|---|---|
| **Requerimientos de Negocio** | Las regulaciones gubernamentales pueden conducir a objetivos de negocio necesarios para un proyecto | El sistema de seguimiento de químicos debe permitir el cumplimiento de todas las regulaciones federales y estatales sobre el uso de químicos y su eliminación en un período de 5 meses |
| **Requerimientos de Usuario** | Las políticas de privacidad dictan qué usuarios pueden y no pueden realizar ciertas tareas con el sistema | Los gerentes de laboratorio están autorizados a generar informes de exposición química para cualquier persona |
| **Requerimientos Funcionales** | Las políticas empresariales establecen procesos específicos que el sistema debe implementar | Política: todos los proveedores deben estar registrados y aprobados antes de que se pague una factura. Funcionalidad: cuando una factura es recibida por un proveedor no registrado, el sistema enviará un email al proveedor con un PDF editable para darse de alta |
| **Atributos de Calidad** | Las regulaciones de agencias gubernamentales pueden dictar ciertos requisitos de seguridad que deben aplicarse a través de la funcionalidad del sistema | El sistema debe mantener registros de entrenamiento de seguridad que se deben verificar para garantizar que los usuarios están debidamente capacitados antes de poder solicitar un producto químico peligroso |

---

## 5 Tipos de Reglas de Negocio

### 1. HECHOS

> Concepto Clave: Los hechos son declaraciones que son verdaderas sobre el negocio en un punto específico del tiempo.

Un hecho describe asociaciones o relaciones entre términos comerciales importantes. Los hechos son elementos inmutables que definen la realidad del negocio y no pueden ser cambiados arbitrariamente.

**Ejemplos:**
- Cada contenedor de productos químicos tiene un identificador de código de barras único
- Cada orden debe tener un costo de envío
- Todos los alumnos deben tener una matrícula para ser estudiantes de la universidad

### 2. RESTRICCIONES

> Concepto Clave: Una restricción es una sentencia que restringe las acciones que el sistema o los usuarios pueden realizar, definiendo qué se puede hacer y qué no se puede hacer.

**Indicadores lingüísticos:**
- **Debe**: Obligación
- **No debe**: Prohibición
- **No puede**: Limitación
- **Solo puede**: Restricción exclusiva

**Ejemplos:**
- Un solicitante de préstamo que es menor de 18 años debe tener un padre o tutor legal como cosignatario
- Un usuario de la biblioteca puede tener un máximo de 10 artículos en espera en cualquier momento
- La correspondencia no puede mostrar más de cuatro dígitos del número de seguro social

**Representación: Matriz de Roles y Permisos**

```
┌─────────────────┬─────────────┬─────────────┬─────────────┐
│   OPERACIÓN     │ADMINISTRADOR│    STAFF    │   USUARIO   │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Ver registro    │      ✓      │      ✓      │      ✓      │
│ Editar registro │      ✓      │      ✓      │      ✗      │
│ Eliminar        │      ✓      │      ✗      │      ✗      │
│ Buscar catálogo │      ✓      │      ✓      │      ✓      │
│ Generar reportes│      ✓      │      ✓      │      ✗      │
│ Configurar      │      ✓      │      ✗      │      ✗      │
└─────────────────┴─────────────┴─────────────┴─────────────┘
```

### 3. DESENCADENADORES DE ACCIÓN (ACTIVADORES)

> Concepto Clave: Un desencadenador de acción es una regla que activa alguna actividad si las condiciones específicas son verdaderas.

**Patrón:** SI [condición] ENTONCES [acción]

**Ejemplos:**
- Si el almacén de productos químicos tiene contenedores de un producto solicitado en stock, entonces ofrece los contenedores al solicitante
- Si se ha alcanzado la fecha de vencimiento en un envase del producto químico, entonces se notifica a la persona que está a cargo

### 4. INFERENCIAS

> Concepto Clave: Las inferencias crean un hecho nuevo a partir de otros hechos existentes.

**Diferencia clave con Activadores:**
- **Activadores**: Desencadenan COMPORTAMIENTOS (acciones)
- **Inferencias**: Crean NUEVOS HECHOS (conocimiento)

**Ejemplos:**
- Si un pago no se recibe dentro de los 30 días después de que se debe, entonces la cuenta es marcada como deudora
- Si un vendedor nuevo no puede enviar un artículo ordenado dentro de los cinco días al recibir la orden, entonces la orden es marcada como cancelada

### 5. CÁLCULOS COMPUTACIONALES

> Concepto Clave: Los cálculos computacionales transforman datos existentes en nuevos datos utilizando fórmulas matemáticas o algoritmos específicos.

**Ejemplo de representación tabular:**

```
┌─────────────────────────────────────────────────────────────┐
│              TABLA DE DESCUENTOS POR VOLUMEN               │
├─────────────┬─────────────────┬─────────────────────────────┤
│IDENTIFICADOR│ CANTIDAD COMPRA │    PORCENTAJE DESCUENTO     │
├─────────────┼─────────────────┼─────────────────────────────┤
│   DISC-1    │      1 - 5      │             0%              │
│   DISC-2    │     6 - 10      │            10%              │
│   DISC-3    │    11 - 20      │            20%              │
│   DISC-4    │   21 o más      │            30%              │
└─────────────┴─────────────────┴─────────────────────────────┘
```

---

## Aplicación en el Proyecto IACT

Este marco conceptual se aplica a TODOS los dominios del proyecto:

- `do../gobernanza/marco_integrado/reglas_negocio/`
- `docs/backend/requisitos/reglas_negocio/`
- `docs/frontend/requisitos/reglas_negocio/`
- `docs/infraestructura/requisitos/reglas_negocio/`

Cada dominio debe documentar sus reglas de negocio específicas siguiendo esta clasificación de 5 tipos.

## Referencias

Este documento establece el estándar de gobernanza para la documentación de reglas de negocio en todo el proyecto IACT.

- Marco completo: `docs/gobernanza/marco_integrado/`
- Guía de uso: `docs/gobernanza/procesos/guia_documentacion_requisitos.md`
