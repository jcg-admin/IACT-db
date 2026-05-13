.. meta::
 :artefacto: UML_GUIA_RAPIDA
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

================================================================
Guía rápida — Cuándo usar cada diagrama UML
================================================================

.. note::

 **Cheat-sheet** de los 9 tipos de diagramas UML que el proyecto
 utiliza, con su propósito, audiencia, perspectiva y enlace a la
 lección completa correspondiente. Diagramas en **PlantUML**
 (política del proyecto, no Mermaid).

 Esta guía complementa la serie pedagógica
 :doc:`UML_01..UML_13 <index>` (Schmuller adaptado). Para el
 detalle conceptual de cada diagrama, seguir el enlace a la
 lección en cada sección.

 Para **ejemplos de cada uno de los 9 diagramas aplicados al
 dominio real del proyecto IACT** (UC_RPT, UC_PIP, UC_ALR,
 UC_PERM, stack React + Django + MySQL + IVR + APScheduler),
 consultar
 :doc:`/requisitos/_metodologia-aplicacion/diagramas-uml`.

 **Atribución:** material basado en *Aprendiendo UML en 24
 horas* — Hora 1 (Schmuller, 2000). UML es resultado del
 trabajo de **Grady Booch**, **James Rumbaugh** e
 **Ivar Jacobson**.

----

Concepto clave
==============

  Un modelo UML **no requiere TODOS los diagramas**. Cada
  diagrama se dirige a una **perspectiva diferente** y a
  **personas diferentes** involucradas en el proyecto.

  Un modelo UML indica **qué** hace el sistema, **no cómo** lo
  hace. El *qué* es el diseño (los diagramas UML); el *cómo* es
  la implementación (el código).

----

¿Por qué tantos diagramas?
==========================

Un sistema cuenta con **diversas personas implicadas** que
tienen **enfoques particulares** en diversos aspectos.

**Ejemplo — sistema de lavadora:**

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Persona implicada
   - Perspectiva del sistema
 * - Ingeniero de motor
   - Perspectiva mecánica (eje, RPM, transmisión)
 * - Escritor de instrucciones
   - Perspectiva de usabilidad (cómo explicar el manual)
 * - Diseñador industrial
   - Perspectiva de forma (proporciones, materiales)
 * - Usuario
   - Experiencia (sólo quiere lavar su ropa)

El escrupuloso diseño de un sistema involucra **todas las
posibles perspectivas**, y cada diagrama UML le da una forma
de incorporar una perspectiva en particular. El objetivo es
satisfacer a cada persona implicada.

----

Los 9 diagramas — referencia rápida
===================================

1. Diagrama de clases
---------------------

**Propósito:** estructura estática del sistema (las cosas que
existen). Atributos + operaciones + relaciones entre clases.

**Cuándo usarlo:** cuando necesites mostrar qué clases existen
y cómo se estructuran.

**Lección completa:**
:doc:`uml-03-uso-orientacion-objetos`,
:doc:`uml-04-uso-relaciones`,
:doc:`uml-05-agregacion-composicion-interfaces`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     - marca : String
     - modelo : String
     - capacidad : Float
     + agregarRopa()
     + activarse()
     + sacarRopa()
   }
   @enduml

----

2. Diagrama de objetos
----------------------

**Propósito:** instancias específicas de clases (casos
concretos, no categorías).

  - **Clase** = molde genérico
  - **Objeto** = instancia específica del molde

**Cuándo usarlo:** cuando quieres mostrar un caso específico
o un ejemplo de cómo funciona una clase en la práctica.

**Lección completa:**
:doc:`uml-03-uso-orientacion-objetos`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object "miLavadora : Lavadora" as ml {
     marca = "Laundatorium"
     modelo = "Washmeister"
     numero_serie = "GL57774"
     capacidad = 7.0
   }
   @enduml

----

3. Diagrama de casos de uso
---------------------------

**Propósito:** qué hace el sistema desde el punto de vista del
usuario. Actor + caso de uso + relaciones.

**Cuándo usarlo:** cuando hablas con usuarios/clientes sobre
**qué** debe hacer el sistema (requisitos de negocio).

  Un caso de uso es una **descripción de acciones desde el
  punto de vista del usuario**, no de la implementación
  técnica.

**Lección completa:**
:doc:`uml-06-introduccion-casos-uso`,
:doc:`uml-07-diagramas-casos-uso`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Usuario
   rectangle "Lavadora" {
     usecase "Lavar ropa" as UC
   }
   Usuario --> UC
   @enduml

----

4. Diagrama de estados
----------------------

**Propósito:** los estados en los que un objeto puede estar y
cómo transiciona entre ellos. Estado + transición + evento.

**Cuándo usarlo:** cuando necesitas mostrar cómo algo cambia de
estado a lo largo del tiempo (ej.: orden pasando de *pendiente*
→ *confirmada* → *enviada* → *entregada*).

**Lección completa:** :doc:`uml-08-diagramas-estados`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Apagada
   Apagada --> Remojo : encender()
   Remojo --> Lavado
   Lavado --> Enjuague
   Enjuague --> Centrifugado
   Centrifugado --> Apagada
   Apagada --> [*]
   @enduml

----

5. Diagrama de secuencias
-------------------------

**Propósito:** cómo interactúan objetos entre sí a lo largo del
tiempo. Participantes (rectángulos arriba) + mensajes (flechas)
+ tiempo (vertical, arriba→abajo).

**Cuándo usarlo:** cuando necesitas mostrar el **flujo
temporal** de interacciones (quién habla con quién, en qué
orden, qué se intercambian).

**Lección completa:** :doc:`uml-09-diagramas-secuencias`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant Manguera as M
   participant Tambor   as T
   participant Drenaje  as D

   M -> T : llenar()
   note right of T : reposar 5 min
   T -> M : cerrar()
   T -> T : girar 15 min
   T -> D : drenar()
   @enduml

----

6. Diagrama de actividades
--------------------------

**Propósito:** flujo de trabajo o decisiones dentro de un
proceso. Actividades + decisiones (sí/no) + sincronización.

**Cuándo usarlo:** cuando necesitas mostrar **procesos
complejos con decisiones** (similar a un diagrama de flujo).

**Lección completa:** :doc:`uml-11-diagramas-actividades`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Agregar ropa;
   :Agregar detergente;
   if ([ropa sucia]) then (sí)
     :Activar lavadora;
     :Llenar (1-2 min);
     :Remojar (5 min);
     :Lavar (15 min);
     :Enjuagar;
     :Centrifugar (5 min);
     :Sacar ropa;
   else (no)
   endif
   stop
   @enduml

----

7. Diagrama de colaboraciones
-----------------------------

**Propósito:** cómo los objetos trabajan juntos para cumplir un
objetivo. Objetos + enlaces + mensajes numerados.

**Cuándo usarlo:** cuando quieres mostrar la **arquitectura de
interacción** entre componentes (quién trabaja con quién).

**Lección completa:** :doc:`uml-10-diagramas-colaboraciones`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object Cronometro
   object Manguera
   object Tambor

   Cronometro -> Manguera : "2: detener agua"
   Cronometro -> Tambor   : "3: activar giro"
   Manguera   -> Tambor   : "1: abrir / llenar"
   @enduml

----

8. Diagrama de componentes
--------------------------

**Propósito:** bloques de software reutilizables y sus
dependencias. Componentes + interfaces + dependencias.

**Cuándo usarlo:** cuando hablas de **arquitectura de
software** (qué módulos/componentes existen y cómo dependen
unos de otros).

**Lección completa:** :doc:`uml-12-diagramas-componentes`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "Interfaz de Usuario" as UI
   component "Controlador Principal" as Ctrl
   component "Motor de Lavado" as Motor

   UI ..> Ctrl : <<usa>>
   Ctrl ..> Motor : <<usa>>
   @enduml

----

9. Diagrama de distribución
---------------------------

**Propósito:** arquitectura física del sistema (dónde se
ejecuta cada cosa). Nodos (cubos) + conexiones + artefactos.

**Cuándo usarlo:** cuando necesitas mostrar **cómo se
despliega** el sistema en producción (dónde viven las
máquinas, cómo se conectan).

**Lección completa:** :doc:`uml-13-diagramas-distribucion`.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "Cliente" <<dispositivo>> as C {
     component "Navegador"
   }
   node "Servidor Web" <<procesador>> as W {
     component "Apache + Django"
   }
   node "BD" <<procesador>> as DB {
     database "MySQL"
   }
   cloud "Stripe API" as S

   C -- W : <<HTTPS>>
   W -- DB : <<JDBC>>
   W -- S  : <<HTTPS>>
   @enduml

----

Otras características UML
=========================

Paquetes — agrupar elementos relacionados
-----------------------------------------

Notación: carpeta con nombre.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Autenticación" {
     class User
     class Role
     class Permission
   }
   @enduml

Notas — explicaciones / comentarios
-----------------------------------

Notación: rectángulo con esquina doblada, conectado con línea
discontinua.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Cliente
   note right of Cliente
     Esta clase hereda de User.
   end note
   @enduml

Estereotipos — extender UML
---------------------------

Notación: nombre entre ``«…»`` (paréntesis angulares dobles).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   interface IAuthenticable <<interface>> {
     + login()
     + logout()
   }
   @enduml

----

Tabla resumen — cuándo usar cada diagrama
=========================================

.. list-table::
 :widths: 20 30 25 25
 :header-rows: 1

 * - Diagrama
   - Propósito
   - Audiencia
   - Perspectiva
 * - **Clases**
   - Estructura estática
   - Desarrolladores
   - Técnica
 * - **Objetos**
   - Instancias concretas
   - Desarrolladores
   - Técnica
 * - **Casos de uso**
   - Requisitos funcionales
   - Usuarios / Clientes
   - Negocio
 * - **Estados**
   - Transiciones de estado
   - Analistas
   - Lógica
 * - **Secuencias**
   - Interacciones temporales
   - Desarrolladores
   - Técnica
 * - **Actividades**
   - Flujos de proceso
   - Analistas
   - Procesos
 * - **Colaboraciones**
   - Arquitectura de interacción
   - Arquitectos
   - Diseño
 * - **Componentes**
   - Módulos de software
   - Arquitectos
   - Diseño
 * - **Distribución**
   - Arquitectura física
   - DevOps / Arquitectos
   - Infraestructura

----

Perspectivas estáticas vs dinámicas
===================================

**Perspectivas ESTÁTICAS** (muestran estructura):

- **Diagrama de clases** — qué existe.
- **Diagrama de objetos** — instancias específicas.
- **Diagrama de componentes** — bloques de código.
- **Diagrama de distribución** — dónde se ejecuta.

**Perspectivas DINÁMICAS** (muestran comportamiento y cambio):

- **Diagrama de casos de uso** — qué hace el sistema.
- **Diagrama de estados** — cómo cambia de estado.
- **Diagrama de secuencias** — cómo interactúan en el tiempo.
- **Diagrama de actividades** — flujos de trabajo.
- **Diagrama de colaboraciones** — cómo trabajan juntos.

----

Principios fundamentales
========================

**1. No es necesario usar todos los diagramas.**

  *"En un modelo UML no es necesario que aparezcan todos los
  diagramas. De hecho, la mayoría de los modelos UML contienen
  un subconjunto de los diagramas."*

  Decisión: usá los que tu equipo necesita para comunicar la
  visión del sistema.

**2. UML indica QUÉ, no CÓMO.**

  *"Un modelo UML indica QUÉ supuestamente hará el sistema, mas
  NO CÓMO lo hará."*

  - El **QUÉ** = diseño (diagramas UML).
  - El **CÓMO** = implementación (el código).

**3. Satisfacer a todas las perspectivas.**

  *"El escrupuloso diseño de un sistema involucra todas las
  posibles perspectivas, y el diagrama UML le da una forma de
  incorporar una perspectiva en particular."*

----

Mapa audiencia → diagrama
=========================

Cada persona involucrada en el proyecto tiene una **perspectiva
diferente**:

.. list-table::
 :widths: 28 72
 :header-rows: 1

 * - Audiencia
   - Diagramas que más le aportan
 * - **USUARIO**
   - Casos de uso (qué hace el sistema)
 * - **ANALISTA**
   - Estados (transiciones), Actividades (flujos)
 * - **ARQUITECTO**
   - Componentes (módulos), Distribución
     (infraestructura), Colaboraciones (interacción)
 * - **DESARROLLADOR**
   - Clases (estructura), Secuencias (interacciones),
     Colaboraciones (patrones)
 * - **GERENTE DE PROYECTO**
   - Vista global de todos los anteriores

----

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation)
 * - **Origen**
   - Adaptado de "GUÍA-UML-DIAGRAMAS-FUNDAMENTALES" (cheat-sheet
     interno), reescrita en PlantUML.
 * - **Lecciones completas referenciadas**
   - :doc:`uml-01-introduccion`,
     :doc:`uml-03-uso-orientacion-objetos`,
     :doc:`uml-04-uso-relaciones`,
     :doc:`uml-05-agregacion-composicion-interfaces`,
     :doc:`uml-06-introduccion-casos-uso`,
     :doc:`uml-07-diagramas-casos-uso`,
     :doc:`uml-08-diagramas-estados`,
     :doc:`uml-09-diagramas-secuencias`,
     :doc:`uml-10-diagramas-colaboraciones`,
     :doc:`uml-11-diagramas-actividades`,
     :doc:`uml-12-diagramas-componentes`,
     :doc:`uml-13-diagramas-distribucion`
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
