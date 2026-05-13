.. meta::
 :artefacto: METODOLOGIA_ANALISIS_DOMINIO_UC
 :tipo: Estándar
 :dominio: normativa
 :subdominio: estandares
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

================================================================
Metodología de Análisis de Dominio para UCs
================================================================

.. note::

 Estándar metodológico que prescribe **cómo extraer clases,
 operaciones y atributos a partir del lenguaje del dominio**
 (entrevistas con clientes y descripciones de casos de uso).

 Aplica al documentar los **97 UCs** del proyecto IACT per
 :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`. Es paso
 **upstream** de
 :doc:`/normativa/estandares/metodologia-oop-para-ucs` —
 primero se descubren las clases, luego se aplican las seis
 dimensiones OOP.

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 **Ejemplos canónicos aplicados al dominio IACT:** ver
 :doc:`/requisitos/_metodologia-aplicacion/analisis-dominio`
 para la técnica aplicada al dominio real (sustantivos del
 ecosistema call center IVR / RBAC / ETL).

----

1. La técnica — sustantivos, verbos, adjetivos
==============================================

**Principio fundamental** (UML, Schmuller cap. 3):

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Categoría gramatical
   - Se convierte en
   - Notación PlantUML
 * - **Sustantivos**
   - Clases
   - ``class Nombre``
 * - **Verbos**
   - Operaciones (métodos)
   - ``+ verbo()``
 * - **Adjetivos**
   - Atributos (propiedades)
   - ``- adjetivo : Boolean``

Para los fundamentos de esta técnica ver
:doc:`/base-cognitiva/_uml/uml-03-uso-orientacion-objetos`
§ "Qué hacen las clases y cómo encontrarlas" (ejemplo del
entrenador de baloncesto).

----

2. Ejemplo completo — sistema de Ecommerce
==========================================

2.1 Conversación con el cliente
-------------------------------

  *"Necesito un sistema donde los clientes pueden ver un
  catálogo de productos, agregar items a un carrito de compras,
  y crear una orden. El cliente puede aplicar un cupón de
  descuento en el checkout. Después de la compra, el sistema
  debe enviar una confirmación por email. El administrador
  puede gestionar productos, reportes y usuarios."*

2.2 Extracción de sustantivos
-----------------------------

::

 Cliente, Catálogo, Producto, Carrito, Compras, Orden,
 Cupón, Descuento, Checkout, Email, Confirmación,
 Administrador, Reportes, Usuarios

→ **Clases candidatas:**

::

 Cliente / Catalogo / Producto / Carrito / Orden / Cupon /
 Descuento / Email / Administrador / Reporte / Usuario

2.3 Extracción de verbos
------------------------

::

 Ver (catálogo)        → +verCatalogo()
 Agregar (al carrito)  → +agregarAlCarrito(producto, cantidad)
 Crear (orden)         → +crearOrden(carrito, direccion)
 Aplicar (cupón)       → +aplicarCupon(codigo)
 Enviar (email)        → +enviarEmail(template, destinatario)
 Gestionar (productos) → +crearProducto() / +editarProducto() / ...
 Comprar               → +procesarCompra()

2.4 Extracción de adjetivos
---------------------------

::

 Activo (usuario)      → is_active : Boolean
 Disponible (producto) → available : Boolean
 Confirmado (orden)    → confirmed : Boolean

2.5 Diagrama de clases del dominio Ecommerce (PlantUML)
-------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Usuario {
     - id : Integer
     - email : String
     - password_hash : String
     - nombre : String
     - is_active : Boolean
     - ordenes : List<Orden>
     + registrarse(email, password)
     + login(email, password)
     + logout()
     + changePassword(old, new)
     + verHistorialOrdenes()
     + crearOrden()
   }

   class Catalogo {
     - id : Integer
     - nombre : String
     - productos : List<Producto>
     - categorias : List<Categoria>
     + verProductos()
     + buscarProducto(termino)
     + filtrarPorCategoria(categoria)
     + filtrarPorPrecio(min, max)
     + ordenarResultados(campo)
   }

   class Producto {
     - id : Integer
     - sku : String
     - nombre : String
     - descripcion : String
     - precio : Decimal
     - stock : Integer
     - categoria : Categoria
     - resenas : List<Resena>
     + getDetalles()
     + updateStock(cantidad)
     + agregarResena(text, rating)
   }

   class Categoria {
     - id : Integer
     - nombre : String
     - slug : String
     - productos : List<Producto>
   }

   class Carrito {
     - id : Integer
     - owner : Usuario
     - items : List<CartItem>
     - created_at : DateTime
     + agregarItem(producto, cantidad)
     + removerItem(producto)
     + cambiarCantidad(producto, nuevaCant)
     + calcularTotal()
     + vaciarCarrito()
   }

   class CartItem {
     - id : Integer
     - producto : Producto
     - cantidad : Integer
     - precio_unitario : Decimal
     + calcularSubtotal()
   }

   class Orden {
     - id : Integer
     - numero_orden : String
     - cliente : Usuario
     - status : String
     - subtotal : Decimal
     - impuesto : Decimal
     - total : Decimal
     - items : List<OrdenItem>
     - pago : Pago
     - direccion : DireccionEnvio
     - created_at : DateTime
     + crearDesdeCarrito(carrito)
     + calcularTotal()
     + updateStatus(newStatus)
     + solicitarDevolucion()
     + descargarFactura()
   }

   class OrdenItem {
     - id : Integer
     - producto : Producto
     - cantidad : Integer
     - precio_unitario : Decimal
   }

   class Pago {
     - id : Integer
     - orden : Orden
     - monto : Decimal
     - status : String
     - stripe_charge_id : String
     - processed_at : DateTime
     + procesarPago(token)
     + reembolsar()
   }

   class Cupon {
     - id : Integer
     - codigo : String
     - descuento_percent : Decimal
     - fecha_vencimiento : DateTime
     - usos_limite : Integer
     - usos_actual : Integer
     + aplicarA(orden)
     + validar()
     + incrementarUsos()
   }

   class DireccionEnvio {
     - id : Integer
     - usuario : Usuario
     - calle : String
     - ciudad : String
     - estado : String
     - codigoPostal : String
     - pais : String
     + validar()
     + verificarCobertura()
   }

   class Email {
     - id : Integer
     - destinatario : String
     - asunto : String
     - cuerpo : String
     - plantilla : String
     - enviado_at : DateTime
     + generar(template, datos)
     + enviar()
     + registrarEnvio()
   }

   class Resena {
     - id : Integer
     - autor : Usuario
     - producto : Producto
     - rating : Integer
     - texto : String
     - aprobada : Boolean
     + crearResena()
     + aceptarResena()
     + rechazarResena()
   }

   class Administrador {
     - id : Integer
     - nombre_admin : String
     - roles : List<Rol>
     + crearProducto()
     + editarProducto(id)
     + eliminarProducto(id)
     + verReportes()
     + gestionarUsuarios()
   }

   class Reporte {
     - id : Integer
     - tipo : String
     - nombre : String
     - generado_at : DateTime
     + generar()
     + exportarCSV()
     + exportarPDF()
   }

   Usuario "1" --> "*" Orden
   Usuario "1" --> "1" Carrito
   Carrito "1" --> "*" CartItem
   CartItem "1" --> "1" Producto
   Orden "1" --> "*" OrdenItem
   OrdenItem "1" --> "1" Producto
   Orden "1" --> "1" Pago
   Orden "1" --> "1" DireccionEnvio
   Producto "1" --> "1" Categoria
   Producto "*" --> "*" Resena
   Cupon "1" --> "*" Orden
   Catalogo "1" --> "*" Producto
   Catalogo "1" --> "*" Categoria
   Usuario <|-- Administrador
   @enduml

----

3. Estructura UML completa de una clase
=======================================

Una clase completa especifica **atributos, operaciones,
responsabilidades y restricciones**:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Usuario {
     .. atributos básicos ..
     - id : Integer
     - email : String
     - password_hash : String
     .. atributos personales ..
     - nombre : String
     - apellido : String
     - telefono : String = "+1234567890"
     .. atributos de estado ..
     - is_active : Boolean = true
     - is_verified : Boolean = false
     - created_at : DateTime
     - updated_at : DateTime
     - last_login : DateTime
     == operaciones de autenticación ==
     + login(email : String, password : String) : Boolean
     + logout()
     + changePassword(old : String, new : String) : void
     + forgotPassword(email : String) : void
     == operaciones de perfil ==
     + updateProfile(nombre, telefono) : void
     + getProfile() : UserProfile
     + deleteAccount() : void
     -- responsabilidades --
     mantener identidad segura del usuario
     facilitar autenticación y autorización
     proteger datos personales
   }
   note right of Usuario
     {email: formato válido RFC5322}
     {password: mínimo 8 caracteres}
     {is_active: true | false}
   end note
   @enduml

**Convención de visibilidad:**

- ``+`` público (cualquier clase puede acceder)
- ``-`` privado (sólo la clase original)
- ``#`` protegido (clase y subclases)

----

4. Descubrimiento por tema (extracto de los 13 docs)
====================================================

4.1 Tema ACCESS (autenticación)
-------------------------------

**Sustantivos:**

::

 Usuario, Contraseña, Sesión, Token, Rol, Permiso, Grupo,
 AuditLog, Email, Verificación

**Clases derivadas:** ``User``, ``Role``, ``Permission``,
``Group``, ``Session``, ``AuditLog``, ``EmailVerification``.

**Verbos:**

::

 Registrarse, Login, Logout, Cambiar contraseña, Recuperar,
 Asignar, Revocar, Bloquear, Auditar

**Operaciones derivadas:** ``+registrarse()``, ``+login()``,
``+logout()``, ``+changePassword()``, ``+forgotPassword()``,
``+assignRole()``, ``+revokeRole()``, ``+blockUser()``,
``+auditChanges()``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class User {
     - id : Integer
     - email : String
     - password_hash : String
     - is_active : Boolean
     + login(email, password) : Boolean
     + logout()
     + changePassword(old, new)
   }

   class Role {
     - id : Integer
     - nombre : String
     - permisos : List<Permission>
     + addPermission(perm)
     + removePermission(perm)
   }

   class Permission {
     - id : Integer
     - codigo : String
     - descripcion : String
   }

   class AuditLog {
     - id : Integer
     - user_id : Integer
     - accion : String
     - timestamp : DateTime
     + registrar(user, accion)
   }

   User "1" --> "*" Role
   Role "1" --> "*" Permission
   User "1" --> "*" AuditLog
   @enduml

4.2 Tema CATÁLOGO (productos)
-----------------------------

**Sustantivos:** Producto, Categoría, Descripción, Precio,
Stock, Imagen, Atributo, Variante, Reseña, Rating.

**Clases:** ``Product``, ``Category``, ``ProductImage``,
``ProductAttribute``, ``ProductVariant``, ``Review``, ``Stock``.

**Verbos:** Ver, Buscar, Filtrar, Ordenar, Crear, Editar,
Eliminar, Agregar imagen, Crear variante.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Product {
     - id : Integer
     - sku : String
     - nombre : String
     - precio : Decimal
     - stock : Integer
     - categoria : Category
     + getDetalles() : ProductDetail
     + updateStock(qty)
     + addImage(url)
     + createVariant()
   }

   class Category {
     - id : Integer
     - nombre : String
     - productos : List<Product>
   }

   class ProductImage {
     - id : Integer
     - product_id : Integer
     - url : String
     - orden : Integer
   }

   class Stock {
     - id : Integer
     - product_id : Integer
     - cantidad : Integer
     - warehouse : String
     + updateCantidad(qty)
   }

   Product "1" --> "*" ProductImage
   Product "1" --> "*" Stock
   Product "1" --> "1" Category
   @enduml

4.3 Tema ÓRDENES (pedidos)
--------------------------

**Sustantivos:** Orden, Item, Cliente, Estado, Total, Impuesto,
Descuento, Dirección, Entrega, Rastreo.

**Clases:** ``Order``, ``OrderItem``, ``OrderStatus``,
``ShippingAddress``, ``Tracking``, ``Invoice``.

**Verbos:** Crear, Calcular, Actualizar estado, Solicitar
devolución, Descargar factura, Rastrear.

  El descubrimiento detallado de cada uno de los 13 temas vive
  en cada uno de los documentos de
  :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc` (DOC-14..26).

----

5. Paquetes UML — organización arquitectónica
=============================================

Los **paquetes** organizan clases en grupos lógicos
(``Authentication``, ``Catalog``, ``Orders``, ``Payments``,
``Notifications``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Authentication" {
     class User
     class Role
     class Permission
   }

   package "Catalog" {
     class Product
     class Category
     class Stock
   }

   package "Orders" {
     class Order
     class OrderItem
     class Shipment
   }

   package "Payments" {
     class Payment
     class Transaction
     class Invoice
   }

   package "Notifications" {
     class Email
     class SMS
     class Notification
   }
   @enduml

**Nombres de ruta** (*fully qualified names*):

::

 Authentication::User
 Authentication::Role
 Catalog::Product
 Catalog::Category
 Orders::Order
 Payments::Payment
 Notifications::Email

----

6. Metodología de cinco pasos por UC
====================================

6.1 Paso 1 — extraer sustantivos del UC
---------------------------------------

Identificar **todos los sustantivos** en la descripción del UC.
Cada sustantivo es una clase candidata.

**Ejemplo — UC_ORD_01 (Crear orden):**

  *"El cliente selecciona productos del carrito, proporciona
  dirección de envío, aplica cupón si tiene, y procesa el pago
  para crear la orden."*

::

 Cliente   → class Cliente (heredar de User)
 Carrito   → class Carrito (ya existe)
 Producto  → class Producto (ya existe)
 Dirección → class DireccionEnvio (nueva)
 Cupón     → class Cupon (nueva)
 Pago      → class Pago (nueva)
 Orden     → class Orden (nueva)

6.2 Paso 2 — extraer verbos del UC
----------------------------------

::

 Seleccionar  → Product.select()
 Proporcionar → Cliente.provideDireccion()
 Aplicar      → Cupon.aplicar(orden)
 Procesar     → Pago.procesarPago()
 Crear        → Orden.crear(cliente, carrito, pago)

6.3 Paso 3 — diagrama de clases involucradas
--------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class User {
     - id : Integer
     - email : String
   }

   class Cliente {
     - nombre : String
     - direccion : DireccionEnvio
     + crearOrden(carrito) : Orden
   }

   class Carrito {
     - items : List<CartItem>
     - total : Decimal
     + getTotal() : Decimal
   }

   class Orden {
     - numero : String
     - cliente : Cliente
     - items : List<OrdenItem>
     - pago : Pago
     - status : String
     + crear(cliente, carrito) : Orden
     + calcularTotal() : Decimal
   }

   class Pago {
     - monto : Decimal
     - status : String
     - stripe_id : String
     + procesarPago(token) : Boolean
   }

   class Cupon {
     - codigo : String
     - descuento : Decimal
     + aplicar(orden) : void
   }

   User <|-- Cliente
   Orden "1" --> "1" Pago
   Orden "1" --> "*" CartItem
   Cupon "1" --> "1" Orden
   @enduml

6.4 Paso 4 — especificar responsabilidades
------------------------------------------

::

 Orden:
   - Representar una compra completada del cliente.
   - Garantizar que contenga todos los detalles de la
     transacción.
   - Mantener integridad de datos de pago.
   - Permitir rastreo del envío.

 Pago:
   - Procesar transacciones monetarias con seguridad.
   - Comunicarse con Stripe de forma segura.
   - Mantener cumplimiento PCI-DSS.
   - Registrar cambios en auditoría.

6.5 Paso 5 — especificar restricciones
--------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Orden {
     - numero_orden : String
     - status : OrderStatus
     - total : Decimal
   }
   note right of Orden
     {numero_orden: único, autoincremental}
     {status: PENDING|CONFIRMED|SHIPPED|DELIVERED|CANCELLED}
     {total: >= 0.00}
     {cada OrdenItem.cantidad >= 1}
     {total = SUM(OrdenItem.precio_unitario × cantidad) + tax}
   end note

   class Pago {
     - monto : Decimal
     - status : PaymentStatus
   }
   note right of Pago
     {monto: > 0}
     {status: PENDING|AUTHORIZED|CAPTURED|REFUNDED|FAILED}
     {monto == Orden.total}
   end note
   @enduml

----

7. Formato de cada documento UC
===============================

Cada documento generado per
:doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc` debe contener:

::

 DOC-XX: UC_[TEMA] (nombre)

 ├─ 1. DESCUBRIMIENTO DE DOMINIO
 │    ├─ Sustantivos identificados
 │    ├─ Verbos identificados
 │    └─ Adjetivos / restricciones
 │
 ├─ 2. DIAGRAMA DE CLASES UML (PlantUML)
 │    ├─ Clases involucradas
 │    ├─ Atributos por clase
 │    ├─ Operaciones por clase
 │    └─ Relaciones entre clases
 │
 ├─ 3. PAQUETES Y ORGANIZACIÓN
 │    └─ Nombre de ruta completo (Package::Class)
 │
 ├─ 4. RESPONSABILIDADES
 │    ├─ Por clase
 │    └─ Por UC
 │
 ├─ 5. RESTRICCIONES Y REGLAS
 │    ├─ Restricciones (notación informal {…})
 │    └─ Reglas de negocio
 │
 ├─ 6. ESPECIFICACIÓN DEL CASO DE USO
 │    ├─ Precondiciones
 │    ├─ Flujo principal
 │    ├─ Flujos alternativos
 │    └─ Postcondiciones
 │
 ├─ 7. DIAGRAMAS PLANTUML
 │    ├─ Diagrama de casos de uso
 │    ├─ Diagrama de clases
 │    ├─ Diagrama de secuencias
 │    ├─ Diagrama de actividades
 │    └─ Diagrama de estados (si aplica)
 │
 └─ 8. CASOS DE PRUEBA DERIVADOS
      ├─ Por clase
      ├─ Por operación
      └─ Por restricción

----

8. Checklist de calidad — análisis de dominio
=============================================

**Análisis de dominio:**

- [ ] Sustantivos identificados correctamente
- [ ] Verbos mapeados a operaciones
- [ ] Adjetivos convertidos en atributos
- [ ] Clases organizadas en paquetes

**Diseño de clases:**

- [ ] Cada clase tiene responsabilidad clara
- [ ] Atributos con tipos correctos
- [ ] Operaciones con firma completa (parámetros + tipo de
  retorno)
- [ ] Relaciones entre clases documentadas (asociación,
  composición, agregación, herencia)

**Diagramas UML (PlantUML):**

- [ ] Diagrama de casos de uso con actores
- [ ] Diagrama de clases con paquetes
- [ ] Diagrama de secuencias para flujos críticos
- [ ] Diagrama de estados para transiciones (si aplica)
- [ ] Diagrama de actividades para flujos complejos (si
  aplica)

**Calidad:**

- [ ] Coherencia con otros UCs del mismo paquete
- [ ] Nomenclatura consistente: ``PascalCase`` para clases,
  ``camelCase`` para atributos y operaciones
- [ ] Restricciones explícitas en notas o entre llaves ``{…}``
- [ ] Documentación completa según la plantilla canónica

----

9. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation and Collaboration)
 * - **Origen del estándar**
   - Adaptado de "INTEGRACIÓN UML + OOP + ANÁLISIS DE DOMINIO +
     MERMAID v4.0.0" (propuesta interna), reescrito para
     PlantUML.
 * - **Fundamento UML**
   - :doc:`/base-cognitiva/_uml/uml-03-uso-orientacion-objetos`
     (técnica original de Schmuller con el ejemplo del
     entrenador de baloncesto)
 * - **Metodología hermana (OOP)**
   - :doc:`/normativa/estandares/metodologia-oop-para-ucs`
 * - **Plantilla aplicable**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Plan de aplicación**
   - :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
