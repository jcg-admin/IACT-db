.. meta::
   :artefacto: PROC_Generacion_VIEW
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-view:

==========================================================
PROC_Generacion_VIEW: Generacion de Vistas Arquitectonicas
==========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_VIEW
   * - **Nombre**
     - Generacion de Vistas Arquitectonicas
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 30-60 minutos por VIEW

----

1. Proposito
------------

Generar Vistas Arquitectonicas (VIEW) que documentan perspectivas
del sistema segun modelo 4+1.

----

2. Alcance
----------

**Aplica A:** Vistas del modelo 4+1.

**No Aplica A:** Diagramas operativos temporales.

----

3. Tipos de Vistas (4+1)
------------------------

.. list-table::
   :header-rows: 1

   * - Vista
     - Perspectiva
     - Diagramas
   * - Logica
     - Funcionalidad
     - Clases, secuencia
   * - Desarrollo
     - Organizacion codigo
     - Paquetes, componentes
   * - Proceso
     - Comportamiento runtime
     - Actividad, estados
   * - Fisica
     - Deployment
     - Infraestructura
   * - Escenarios
     - Casos de uso
     - UC, interaccion

----

4. Procedimiento
----------------

**Paso 1: Identificar Vista**

Seleccionar perspectiva a documentar.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: VIEW_[Tipo]_[NNN]
   
   Ejemplos:
   - VIEW_Logica_001
   - VIEW_Proceso_001
   - VIEW_Fisica_001

**Paso 3: Crear Diagrama Principal**

Usar PlantUML segun tipo:

.. code-block:: rst

   .. uml::
   
      @startuml
      package "MOD_Auth" {
        [AuthService]
        [JWTService]
      }
      package "MOD_Users" {
        [UserService]
      }
      [AuthService] --> [UserService]
      @enduml

**Paso 4: Documentar Elementos**

Describir componentes del diagrama.

**Paso 5: Documentar Relaciones**

Explicar conexiones y dependencias.

**Paso 6: Vincular ADR**

Referenciar decisiones relacionadas.

**Paso 7: Guardar y Validar**

----

5. Artefactos de Salida
-----------------------

- VIEW_[Tipo]_[NNN].rst

----

6. Verificacion
---------------

- [ ] Diagrama PlantUML valido
- [ ] Elementos documentados
- [ ] ADR referenciadas

----

7. Referencias
--------------

- TPL_VIEW
- Modelo 4+1
- ADR relacionadas

----

8. Historial
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
