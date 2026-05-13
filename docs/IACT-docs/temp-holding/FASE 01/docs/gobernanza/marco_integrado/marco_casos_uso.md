---
title: Marco Conceptual - Casos de Uso en Ingeniería de Requerimientos
date: 2025-11-13
domain: gobernanza
tipo: marco_conceptual
status: active
---

# Casos de Uso en Ingeniería de Requerimientos

## Guía Completa de Gobernanza

---

## 1. ¿Qué es un Caso de Uso?

> Concepto Clave: Un caso de uso describe una secuencia de interacciones entre un sistema y un actor que resulta en que el actor sea capaz de lograr algún resultado de valor.

En pocas palabras, un caso de uso es un término de ingeniería de software y de sistemas que describe cómo un usuario utiliza un sistema para lograr un objetivo en particular.

Un **caso de uso** describe una forma en la cual un actor del mundo real interactúa con un sistema. Esta relación e interacción que existe entre los actores y el sistema se muestra dentro de los casos de uso.

### Historia y Origen

> Nota contextual importante: Los casos de uso se introdujeron en 1986 por Ivar Jacobson, quien es uno de los principales contribuidores de UML y el Proceso Unificado.

---

## 2. Diferencia Fundamental: Especificar vs. Ilustrar

> **CRÍTICO - Confusión Muy Común**
>
> **Los casos de uso son documentos de texto, NO son diagramas.**
>
> Aquí hay una confusión: muchas personas dicen que van a "ilustrar" o "dibujar" casos de uso, pero NO es así.
>
> **Los casos de uso es la acción de escribir documentos de texto.**

Pero también tenemos lo que es el **modelado de casos de uso** o el **modelado de diagramas de casos de uso**, que sí es donde nosotros dibujamos.

A través de UML, UML nos da diferentes tipos de herramientas para modelar sistemas. Uno de ellos son los **diagramas de casos de uso**, en donde nosotros ilustramos:

- Los nombres de los casos de uso
- Los actores que se relacionan con estos casos de uso
- Todo en una sola vista, como si fuera una sola fotografía

> Concepto Clave: Hay que diferenciar claramente: una cosa es especificar casos de uso (donde nosotros escribimos texto) y otra cosa es ilustrar diagramas UML de casos de uso (donde nosotros creamos esta vista o esta fotografía).

---

## 3. Nomenclatura de Casos de Uso

> **Regla Obligatoria**
>
> **Los nombres de casos de uso se escriben SIEMPRE en forma de:**
>
> **VERBO + OBJETO**
>
> Es decir, la forma en que nosotros nombramos a los casos de uso es utilizando esta nomenclatura:
>
> **ACCIÓN + OBJETO**

### Ejemplos Completos de Nomenclatura

**Kiosco de registro en aeropuerto:**

1. **Registrar Vuelo** (o "Hacer Check-in")
   - "Registrar" = verbo
   - "Vuelo" = objeto

2. **Imprimir Pases de Abordar**
   - "Imprimir" = acción
   - "Pases de abordar" = objeto

3. **Cambiar Asientos**
   - "Cambiar" = verbo
   - "Asientos" = objeto

4. **Registrar Equipaje**
   - "Registrar" = verbo
   - "Equipaje" = objeto

5. **Comprar Actualización de Asiento**
   - "Comprar actualización" = verbo
   - "Asiento" = objeto

---

## 4. Términos Fundamentales

### 4.1 Actores

> Concepto Clave: Un actor es un ente. Puede ser una persona, otro sistema, un dispositivo de hardware o una base de datos que interactúan con el sistema para ejecutar un caso de uso.

**Buena Práctica:** Capitalizar los nombres de los actores en las especificaciones (ponerlos en MAYÚSCULAS).

#### Tipos de Actores

**Actores Primarios:**
- Tienen objetivos específicos que están cumplidos mediante el uso de los servicios del sistema
- Son aquellos que **ejecutan casos de uso**
- Son aquellos que **disparan el caso de uso**

**Actores Secundarios (o de Apoyo):**
- Proporcionan un servicio (información, base de datos, etc.)
- Brindan soporte pero NO ejecutan el caso de uso

### 4.2 Escenarios

> Concepto Clave: Un escenario (también llamado flujo o curso) es una secuencia específica de acciones o interacciones entre actores y el sistema.

**Características:**
- Es una **historia particular** al usar el sistema
- Es un **camino a través del caso de uso**
- También llamados **instancias de caso de uso**

**Relación:**
- Un caso de uso = Colección de escenarios
- Un escenario = Instancia específica de un caso de uso

---

## 5. Principio Fundamental: Qué vs. Cómo

> **CRÍTICO - Principio de Especificación**
>
> Los escenarios de caso de uso NO deben describir el funcionamiento interno de un sistema, sus componentes o su diseño.
>
> **Deben especificar lo que el sistema debe hacer sin decidir cómo se hará.**

**Ejemplos:**

✅ **CORRECTO:**
- "El sistema guarda una venta"

❌ **INCORRECTO:**
- "El sistema escribe la venta dentro de una base de datos SQL, un INSERT de SQL"

> Concepto Clave: Debemos decir QUÉ se debe hacer, mas NO CÓMO.

---

## 6. Grados de Formalidad

Los casos de uso se describen en diferentes grados de formalidad:

**1. Breves**
- Resumen en un párrafo del escenario principal completo

**2. Casuales**
- Formatos de párrafo informal múltiple
- Párrafos que cubren varios escenarios

**3. Completos**
- Todos los pasos y variaciones escritos en detalle
- Secciones de apoyo: precondiciones y garantías de éxito

> **ESTÁNDAR IACT: Este proyecto usa formato COMPLETO**

---

## 7. Formato de Dos Columnas

### UC-001: Procesar Venta

```
┌─────────────────────────────────────────────────────────────────────────┐
│  CASO DE USO: PROCESAR VENTA                                           │
│  Actores Primarios: Cajero                                             │
│  Actores Secundarios: Sistema de Inventario                            │
├─────────────────────────────────┬───────────────────────────────────────┤
│     ACCIONES DEL ACTOR          │  RESPONSABILIDADES DEL SISTEMA        │
├─────────────────────────────────┼───────────────────────────────────────┤
│ 1. El cliente llega al POS con  │                                       │
│    los bienes que desea comprar │                                       │
├─────────────────────────────────┼───────────────────────────────────────┤
│ 2. El cajero comienza una       │                                       │
│    nueva venta                  │                                       │
├─────────────────────────────────┼───────────────────────────────────────┤
│ 3. El cajero introduce el       │ 4. El sistema guarda cada artículo y  │
│    identificador del artículo   │    muestra descripción y total        │
├─────────────────────────────────┼───────────────────────────────────────┤
│       El cajero repite los pasos 3 y 4                                  │
├─────────────────────────────────┼───────────────────────────────────────┤
│                                 │ 5. El sistema muestra el total con    │
│                                 │    impuestos calculados               │
├─────────────────────────────────┼───────────────────────────────────────┤
│ 6. El cajero le dice al cliente │                                       │
│    el total y le pregunta el    │                                       │
│    método de pago               │                                       │
├─────────────────────────────────┼───────────────────────────────────────┤
│ 7. El cliente paga              │ 8. El sistema maneja el tipo de pago  │
└─────────────────────────────────┴───────────────────────────────────────┘
```

---

## 8. Diagramas UML de Casos de Uso

### Elementos del Diagrama

**1. Actores:** Figuras de palo (👤)

**2. Casos de Uso:** Óvalos

**3. Relaciones:** Flechas

**4. Límite del Sistema:** Rectángulo

### Dirección de las Flechas (MUY IMPORTANTE)

> **CRÍTICO - Interpretación de Direcciones**
>
> **Si la flecha va de un actor hacia un caso de uso:**
> - El actor es el que **dispara o ejecuta** este caso de uso
> - Este actor es el **actor principal**
>
> **Si la flecha va del caso de uso hacia el actor:**
> - Este actor es un **actor secundario o de soporte**
> - NO es el actor principal

### Diagrama Ejemplo

```
                    ┌─────────────────────────────────────────────┐
                    │           LÍMITE DEL SISTEMA                │
                    │                                             │
    ┌─────┐         │      ╭──────────────────╮                   │
    │ 👤  │─────────┼─────▶│  Registrar Vuelo │                   │
    │Solic│         │      ╰──────────────────╯                   │
    └─────┘         │                                             │
                    │      ╭──────────────────╮         ┌─────┐   │
                    │      │ Cambiar Asientos │◀────────│ 👤  │   │
                    │      ╰──────────────────╯         │Base │   │
                    │                                   │Datos│   │
                    └─────────────────────────────────────────────┘
```

---

## 9. Elementos de Información en Casos de Uso

### 9.1 Precondiciones

> Concepto Clave: Una precondición es el estado que siempre debe ser cierto ANTES de empezar el escenario dentro del caso.

**IMPORTANTE:** Una precondición puede existir o NO puede existir. NO es necesario que en la especificación existan precondiciones. **Puede haber 0 o más.**

### 9.2 Postcondiciones

> Concepto Clave: La postcondición es el estado que siempre debe ser cierto al finalizar CON ÉXITO del caso de uso.

### 9.3 Curso Normal (Happy Path)

El curso normal describe el camino o trayectoria típica de éxito que satisface los intereses de las partes interesadas.

También llamado **happy path** o **camino feliz**.

### 9.4 Cursos Alternos o Caminos Secundarios

Indican los otros escenarios, tanto de éxito como de fracaso.

**Extensión:** Tiene dos partes:
1. **Condición:** Algo que puede ser detectada por el sistema
2. **Manipulación:** La secuencia de pasos a seguir para manejar esta condición

---

## 10. Estructura Completa de Especificación

### UC-04: Solicitar Producto Químico

**ID:** UC-04

**Nombre:** Solicitar Producto Químico (verbo + objeto)

**Creado por:** [Autor]

**Fecha de creación:** [YYYY-MM-DD]

**Actores Primarios:** Solicitante

**Actores Secundarios:** Comprador, Base de Datos

**Descripción:** [Descripción general]

**Desencadenador (Trigger):** El solicitante indica una solicitud de un producto químico

**Precondiciones:**
- El solicitante debe estar autenticado en el sistema
- Debe existir un catálogo de productos químicos disponible

**Postcondiciones:**
- La solicitud del producto químico ha sido registrada
- Se ha notificado al comprador sobre la solicitud

**Flujo Normal:**
1. El solicitante accede al módulo de solicitudes
2. El sistema muestra el catálogo de productos químicos disponibles
3. El solicitante selecciona el producto químico deseado
4. El sistema valida la disponibilidad del producto (**Ver 4.1**)
5. El sistema muestra el total con información adicional
6. El solicitante confirma la solicitud
7. El sistema registra la solicitud
8. El sistema notifica al comprador

**Flujos Alternos:**

**4.1 Si el producto no está disponible:**
- 4.1.1 El sistema muestra un mensaje de producto no disponible
- 4.1.2 El sistema sugiere productos alternativos
- 4.1.3 El solicitante puede seleccionar un producto alternativo
- 4.1.4 Regresa al paso 5

**Excepciones:**

**4.1.1 Si no se encuentra en el catálogo:**
- El sistema muestra mensaje de error
- El sistema permite al solicitante solicitar la inclusión del producto
- El caso de uso termina

**Prioridad:** Alta

**Frecuencia de uso:** Diaria

**Reglas de negocio relacionadas:** BR-28, BR-31

---

## 11. Aplicación en el Proyecto IACT

Este marco conceptual se aplica a TODOS los dominios del proyecto:

- `do../gobernanza/marco_integrado/requerimientos_usuario/casos_uso/`
- `docs/backend/requisitos/requerimientos_usuario/casos_uso/`
- `docs/frontend/requisitos/requerimientos_usuario/casos_uso/`
- `docs/infraestructura/requisitos/requerimientos_usuario/casos_uso/`

### Estructura Estándar en cada Dominio

```
requerimientos_usuario/
├── README.md
├── casos_uso/
│   ├── README.md
│   ├── UC-001-{verbo_objeto}.md
│   ├── UC-NNN-{verbo_objeto}.md
│   ├── diagramas_uml/
│   ├── diagramas_actividad/
│   ├── actores.md
│   └── trazabilidad_uc_rn.md
├── escenarios/
├── historias_usuario/
└── perfiles_usuario.md
```

---

## 12. Principios Fundamentales (Resumen)

1. **ESPECIFICAR vs. ILUSTRAR**
   - Especificar = ESCRIBIR texto
   - Ilustrar = DIBUJAR diagramas UML

2. **QUÉ vs. CÓMO**
   - Especificar QUÉ debe hacer el sistema
   - NO especificar CÓMO se implementará

3. **NOMENCLATURA**
   - SIEMPRE: VERBO + OBJETO

4. **DIRECCIÓN DE FLECHAS**
   - Actor → Caso de Uso: Actor PRIMARIO
   - Caso de Uso → Actor: Actor SECUNDARIO

5. **PRECONDICIONES**
   - Pueden ser 0 o más
   - NO son obligatorias

6. **FORMATO COMPLETO**
   - Este proyecto usa formato completo
   - Dos columnas: Actor | Sistema

7. **TRAZABILIDAD**
   - ID único para cada caso de uso
   - Relacionar con reglas de negocio (BR-NN)
   - Derivar de requerimientos de negocio
   - Implementar en requerimientos funcionales

---

## Referencias

Este documento establece el estándar de gobernanza para la documentación de casos de uso en todo el proyecto IACT.

- Marco completo: `docs/gobernanza/marco_integrado/`
- Reglas de negocio: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- Guía de uso: `docs/gobernanza/procesos/guia_documentacion_requisitos.md`
