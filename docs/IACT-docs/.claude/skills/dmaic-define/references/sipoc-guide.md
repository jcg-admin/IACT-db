# SIPOC Guide — DMAIC:Define

Guía paso a paso para construir el SIPOC, con ejemplos y errores comunes.

---

## Qué es el SIPOC

El SIPOC es un mapa de alto nivel del proceso que define el alcance del proyecto DMAIC. No es un mapa detallado — es un resumen en 5-7 pasos del proceso que produce el output afectado por el problema.

| Letra | Componente | Descripción |
|-------|-----------|-------------|
| **S** | Suppliers (Proveedores) | Quiénes proveen los inputs al proceso |
| **I** | Inputs (Entradas) | Qué materiales, información o recursos entran al proceso |
| **P** | Process (Proceso) | Los pasos del proceso (5-7 pasos máximo) |
| **O** | Outputs (Salidas) | Qué produce el proceso |
| **C** | Customers (Clientes) | Quiénes reciben los outputs |

**Propósito del SIPOC en Define:**
- Define el scope del proyecto: qué parte del proceso está incluida
- Identifica a los stakeholders relevantes (S y C)
- Establece el punto de partida para el Process Map detallado de Measure

---

## Orden correcto de construcción

**Regla:** NO empezar por los Suppliers. El orden correcto es de afuera hacia adentro y luego hacia atrás:

```
1 → Process (qué hace el proceso — 5-7 pasos)
2 → Outputs (qué produce ese proceso)
3 → Customers (quién usa esos outputs)
4 → Inputs (qué necesita el proceso para funcionar)
5 → Suppliers (quién provee esos inputs)
```

**Por qué este orden:** El proceso es el centro del SIPOC. Definirlo primero evita que el equipo liste inputs y proveedores de cosas irrelevantes para el proceso en cuestión.

---

## Paso a paso detallado

### Paso 1: Definir el proceso (P)

Identificar 5-7 pasos de alto nivel que cubren el proceso de inicio a fin:

**Reglas:**
- Máximo 7 pasos — si hay más, el scope es demasiado amplio o se está descendiendo al nivel de actividades
- Cada paso comienza con un verbo activo: "Recibir", "Validar", "Procesar", "Empacar", "Despachar"
- Los pasos deben ser secuenciales y cubrir el proceso de punta a punta

**Ejemplo — proceso de fulfillment de pedidos:**
1. Recibir pedido del cliente
2. Verificar disponibilidad de inventario
3. Asignar ruta de despacho
4. Preparar y empacar el pedido
5. Despachar y generar tracking
6. Confirmar entrega al cliente

### Paso 2: Identificar los Outputs (O)

¿Qué produce este proceso?

- Listar los outputs principales (productos, servicios, documentos)
- Incluir el output del CTQ — el que está fallando
- Si hay múltiples outputs, priorizar los relacionados con el problema

**Ejemplo:** Pedido entregado al cliente · Confirmación de entrega · Factura emitida

### Paso 3: Identificar los Customers (C)

¿Quién recibe los outputs?

- Cliente externo (el consumidor final)
- Clientes internos (el siguiente paso del proceso)
- Departamentos que usan los outputs

**Ejemplo:** Cliente final · Área de facturación · Área de servicio al cliente

### Paso 4: Identificar los Inputs (I)

¿Qué necesita el proceso para funcionar?

- Para cada paso del proceso, preguntarse: ¿qué necesita este paso para ejecutarse?
- Listar materiales, información, sistemas, aprobaciones

**Ejemplo:** Orden de compra · Inventario disponible · Dirección de entrega válida · Sistema de asignación de rutas

### Paso 5: Identificar los Suppliers (S)

¿Quién provee cada input?

- Para cada input, identificar la fuente
- Puede ser departamento interno, sistema, proveedor externo

**Ejemplo:** Cliente (orden de compra) · Sistema ERP (inventario) · Google Maps / sistema de rutas (rutas) · Proveedores de transporte

---

## Ejemplo completo — SIPOC de fulfillment

| S — Suppliers | I — Inputs | P — Process | O — Outputs | C — Customers |
|---------------|-----------|------------|-------------|--------------|
| Cliente | Orden de compra | 1. Recibir pedido | Pedido confirmado | Cliente final |
| Sistema ERP | Stock disponible | 2. Verificar inventario | Confirmación de disponibilidad | Área de despacho |
| Proveedor de transporte | Vehículos disponibles | 3. Asignar ruta | Ruta asignada | Transportista |
| Área de almacén | Productos físicos | 4. Preparar y empacar | Paquete preparado | Transportista |
| Sistema de tracking | Código de tracking | 5. Despachar | Tracking activo | Cliente |
| Servicio al cliente | Registro de confirmación | 6. Confirmar entrega | Cierre de pedido | Área de facturación |

---

## Errores comunes al construir SIPOC

| Error | Descripción | Corrección |
|-------|-------------|------------|
| **Demasiados pasos** | 15-20 pasos en el proceso | Agrupar actividades relacionadas; máximo 7 |
| **Scope demasiado amplio** | Incluir procesos que no afectan el CTQ | Preguntar: ¿este paso impacta directamente el CTQ? |
| **Empezar por los Suppliers** | Los proveedores se definen en función de los inputs, que dependen del proceso | Seguir el orden correcto: Process → Outputs → Customers → Inputs → Suppliers |
| **Confundir Inputs con Outputs** | Los Inputs de un paso son los Outputs del paso anterior | Verificar el flujo: el Output de P1 debe ser un Input de P2 |
| **Omitir clientes internos** | Listar solo al cliente final externo | Incluir departamentos internos que dependen de los outputs |
| **SIPOC como detalle operativo** | Incluir excepciones, condiciones especiales, variantes del proceso | El SIPOC es el camino principal (happy path); el detalle va en el Process Map de Measure |
| **Proveedores externos solo** | Listar solo proveedores externos | Incluir sistemas internos y departamentos como Suppliers |

---

## SIPOC como herramienta de scope

El SIPOC delimita el scope del proyecto DMAIC. Usarlo para responder explícitamente:

| Pregunta de scope | Respuesta con SIPOC |
|------------------|---------------------|
| ¿Dónde empieza el proceso? | En el primer Input / primer paso del P |
| ¿Dónde termina el proceso? | En el último Output / último paso del P |
| ¿Qué queda fuera del scope? | Lo que esté antes del primer Supplier o después del último Customer |
| ¿Quién necesita estar en el proyecto? | Los dueños de los pasos del P + los S y C clave |

**Regla de scope:** Si un paso del proceso no aparece en el SIPOC, no está en scope del proyecto DMAIC. Usarlo para resistir el scope creep durante Analyze e Improve.
