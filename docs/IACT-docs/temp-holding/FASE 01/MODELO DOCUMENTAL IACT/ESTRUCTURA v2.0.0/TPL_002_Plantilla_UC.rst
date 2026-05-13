.. meta::
   :artefacto: TPL_002
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _tpl-002:

==============================================================================
TPL_002: Plantilla de Caso de Uso (UC)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Esta plantilla define la estructura estandar para documentar Casos de Uso
(Use Cases) en el proyecto IACT. Basada en FND_03 y metodologia Larman.

----

Instrucciones de Uso
--------------------

1. Copiar este archivo como ``UC_NNN_Nombre_Descriptivo.rst``
2. Reemplazar todos los marcadores ``[PLACEHOLDER]`` con valores reales
3. El nombre debe seguir formato: Verbo + Objeto (ej: "Consultar_Dashboard")
4. Mantener formato RST valido

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: UC_[NNN]
      :tipo: Caso de Uso
      :dominio: requisitos
      :subdominio: casos_uso
      :estado: [Borrador|Revision|Aprobado]
      :version: [X.Y.Z]
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: [Nombre]
      :clasificacion: Interno

   .. _uc-[nnn]:

   ==============================================================================
   UC_[NNN]: [Verbo] [Objeto]
   ==============================================================================

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - UC_[NNN]
      * - **Nombre**
        - [Verbo + Objeto descriptivo]
      * - **Actor Primario**
        - [Rol que inicia el caso de uso]
      * - **Actores Secundarios**
        - [Roles que participan pero no inician]
      * - **Nivel**
        - [Usuario | Subfuncion | Resumen]
      * - **Complejidad**
        - [Alta | Media | Baja]

   ----

   1. Descripcion
   --------------

   1.1 Objetivo
   ^^^^^^^^^^^^

   [Descripcion clara del objetivo que el actor primario desea lograr
   al ejecutar este caso de uso. Una o dos oraciones.]

   1.2 Alcance
   ^^^^^^^^^^^

   - **Sistema**: IACT Dashboard Analytics
   - **Modulo**: [Modulo especifico donde aplica]
   - **Nivel de Detalle**: [Descripcion del alcance funcional]

   ----

   2. Contexto
   -----------

   2.1 Precondiciones
   ^^^^^^^^^^^^^^^^^^

   Condiciones que DEBEN ser verdaderas ANTES de iniciar el caso de uso:

   1. [Precondicion 1 - ej: Usuario autenticado con rol X]
   2. [Precondicion 2 - ej: Datos necesarios existen en sistema]
   3. [Precondicion N]

   2.2 Trigger (Disparador)
   ^^^^^^^^^^^^^^^^^^^^^^^^

   [Evento que inicia el caso de uso]

   Ejemplos:
   - "Usuario selecciona opcion 'Nuevo Registro' en menu"
   - "Sistema detecta hora 00:00 (medianoche)"
   - "Usuario accede a URL /dashboard"

   2.3 Postcondiciones de Exito
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   Condiciones que seran verdaderas DESPUES de completar exitosamente:

   1. [Postcondicion 1 - ej: Registro creado en base de datos]
   2. [Postcondicion 2 - ej: Notificacion enviada a usuario]
   3. [Postcondicion N]

   2.4 Garantias Minimas
   ^^^^^^^^^^^^^^^^^^^^^

   Condiciones garantizadas incluso si el caso de uso falla:

   1. [Garantia 1 - ej: No se pierden datos existentes]
   2. [Garantia 2 - ej: Transaccion hace rollback si falla]

   ----

   3. Actores
   ----------

   3.1 Actor Primario
   ^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Rol**
        - [Nombre del rol]
      * - **Descripcion**
        - [Descripcion breve del rol]
      * - **Objetivo**
        - [Que quiere lograr este actor]

   3.2 Actores Secundarios
   ^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 30 50
      :header-rows: 1

      * - Rol
        - Tipo
        - Participacion
      * - [Rol 1]
        - [Humano | Sistema | Tiempo]
        - [Como participa en el UC]
      * - [Rol 2]
        - [Humano | Sistema | Tiempo]
        - [Como participa en el UC]

   ----

   4. Flujo Normal
   ---------------

   Secuencia principal de pasos cuando todo funciona correctamente:

   .. list-table::
      :widths: 10 15 75
      :header-rows: 1

      * - Paso
        - Actor
        - Accion
      * - 1
        - [Actor]
        - [Descripcion de la accion]
      * - 2
        - Sistema
        - [Respuesta del sistema]
      * - 3
        - [Actor]
        - [Siguiente accion]
      * - ...
        - ...
        - ...
      * - N
        - Sistema
        - [Accion final - postcondicion alcanzada]

   **Formato alternativo (texto):**

   .. code-block:: text

      FLUJO NORMAL:

      1. [Actor] [accion]
      2. Sistema [respuesta]
      3. [Actor] [accion]
         3.1 [Subpaso si necesario]
         3.2 [Subpaso si necesario]
      4. Sistema [validacion/proceso]
      5. Sistema [resultado final]

   ----

   5. Flujos Alternos
   ------------------

   5.1 FA-1: [Nombre del Flujo Alterno]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Condicion**: [Cuando se activa este flujo]

   **Punto de bifurcacion**: Paso [N] del flujo normal

   .. code-block:: text

      [N]a. [Condicion que activa el flujo alterno]
      [N]b. Sistema [accion alternativa]
      [N]c. [Siguiente paso]
      [N]d. [Retorna a paso X | UC termina]

   5.2 FA-2: [Nombre del Flujo Alterno]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Condicion**: [Cuando se activa este flujo]

   **Punto de bifurcacion**: Paso [N] del flujo normal

   .. code-block:: text

      [N]a. [Condicion]
      [N]b. [Accion]
      [N]c. [Resultado]

   ----

   6. Excepciones
   --------------

   6.1 EX-1: [Nombre de la Excepcion]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Condicion**: [Error o situacion excepcional]

   **Manejo**:

   .. code-block:: text

      *a. [En cualquier momento / En paso N]
      *b. Sistema detecta [error/condicion]
      *c. Sistema [accion de recuperacion]
      *d. Sistema muestra mensaje: "[Mensaje al usuario]"
      *e. UC termina [sin cambios | con rollback]

   ----

   7. Requisitos Especiales
   ------------------------

   7.1 Requisitos No Funcionales
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - Tipo
        - Requisito
      * - Performance
        - [ej: Respuesta < 2 segundos]
      * - Seguridad
        - [ej: Requiere autenticacion, datos encriptados]
      * - Usabilidad
        - [ej: Maximo 3 clics para completar]
      * - Disponibilidad
        - [ej: 99.9% uptime]

   7.2 Restricciones de Interfaz
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Restriccion de UI 1]
   - [Restriccion de UI 2]

   ----

   8. Reglas de Negocio Aplicadas
   ------------------------------

   .. list-table::
      :widths: 15 25 60
      :header-rows: 1

      * - BR
        - Nombre
        - Donde Aplica
      * - BR_[NNN]
        - [Nombre BR]
        - [Precondicion | Paso N | Flujo Alterno | Postcondicion]
      * - BR_[NNN]
        - [Nombre BR]
        - [Donde aplica]

   ----

   9. Trazabilidad
   ---------------

   9.1 Origen
   ^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - Artefacto
        - Relacion
      * - BReq_[NNN]
        - [Requisito de negocio que este UC implementa]
      * - BR_[NNN]
        - [Regla de negocio que origina este UC (si aplica)]

   9.2 Derivados
   ^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - Artefacto
        - Descripcion
      * - FR_[NNN].01
        - [Primer FR derivado de este UC]
      * - FR_[NNN].02
        - [Segundo FR derivado]
      * - FR_[NNN].NN
        - [N-esimo FR derivado]

   ----

   10. Informacion Adicional
   -------------------------

   10.1 Frecuencia de Uso
   ^^^^^^^^^^^^^^^^^^^^^^

   - **Frecuencia**: [Muy frecuente | Frecuente | Ocasional | Raro]
   - **Estimacion**: [N veces por dia/semana/mes]
   - **Usuarios concurrentes**: [Estimacion]

   10.2 Problemas Abiertos
   ^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 10 70 20
      :header-rows: 1

      * - ID
        - Descripcion
        - Estado
      * - PA-1
        - [Duda o decision pendiente]
        - [Abierto | Resuelto]

   10.3 Supuestos
   ^^^^^^^^^^^^^^

   1. [Supuesto 1]
   2. [Supuesto 2]

   ----

   11. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 15 15 20 50
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Descripcion del Cambio
      * - 1.0.0
        - [YYYY-MM-DD]
        - [Nombre]
        - Version inicial

----

Ejemplo de Uso
--------------

Ver ``UC_001_Consultar_Dashboard.rst`` para un ejemplo completo de aplicacion
de esta plantilla.

----

Referencias
-----------

- FND_03: Casos de Uso (definiciones y estructura)
- FND_06: Derivacion de Casos de Uso
- Larman, C. "Applying UML and Patterns"
- ESTRUCTURA v2.0.0: Modelo Documental IACT

----

*Plantilla version 1.0.0 - Proyecto IACT Dashboard Analytics*
