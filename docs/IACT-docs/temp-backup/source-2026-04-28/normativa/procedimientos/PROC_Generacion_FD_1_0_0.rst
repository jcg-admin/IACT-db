.. meta::
   :artefacto: PROC_Generacion_FD
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-fd:

===================================================
PROC_Generacion_FD: Generacion de Fichas de Dominio
===================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_FD
   * - **Nombre**
     - Generacion de Fichas de Dominio
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 20-40 minutos por FD

----

1. Proposito
------------

Generar Fichas de Dominio (FD) que documentan entidades, atributos
y relaciones del modelo de datos.

----

2. Alcance
----------

**Aplica A:** Entidades del modelo de dominio.

**No Aplica A:** Tablas auxiliares, configuracion.

----

3. Procedimiento
----------------

**Paso 1: Identificar Entidad**

Seleccionar entidad del modelo de dominio.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: FD_[NNN]
   Archivo: FD_[NNN]_[Entidad].rst

**Paso 3: Documentar Atributos**

.. code-block:: rst

   .. list-table::
      :header-rows: 1
   
      * - Atributo
        - Tipo
        - Obligatorio
        - Descripcion
      * - id
        - UUID
        - Si
        - Identificador unico
      * - username
        - String(50)
        - Si
        - Nombre de usuario

**Paso 4: Documentar Relaciones**

- Entidades relacionadas
- Tipo de relacion (1:1, 1:N, N:M)
- Cardinalidad

**Paso 5: Documentar Restricciones**

- Unique constraints
- Check constraints
- Foreign keys

**Paso 6: Incluir Diagrama**

.. code-block:: rst

   .. uml::
   
      @startuml
      entity User {
        * id: UUID
                  
        * username: String
        * email: String
        is_active: Boolean
      }
      @enduml

**Paso 7: Guardar y Validar**

----

4. Artefactos de Salida
-----------------------

- FD_[NNN]_[Entidad].rst

----

5. Verificacion
---------------

- [ ] Atributos con tipos
- [ ] Relaciones documentadas
- [ ] Diagrama incluido
- [ ] MOD relacionado

----

6. Referencias
--------------

- TPL_FD
- MOD del modulo

----

7. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*
