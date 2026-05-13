.. meta::
   :artefacto: FND_03
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.2.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-03:

==============================================================================
FND_03: Casos de Uso
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Este documento define QUE ES un Caso de Uso (Use Case) en el contexto del
proyecto IACT, su estructura, componentes y relacion con otros artefactos
de requisitos.

----

1. Definicion Formal
--------------------

1.1 Que es un Caso de Uso
^^^^^^^^^^^^^^^^^^^^^^^^^

Un **Caso de Uso (Use Case - UC)** es una descripcion de una secuencia de
interacciones entre un actor y el sistema para lograr un objetivo especifico.
Describe comportamientos del sistema desde la perspectiva del usuario.

.. note::

   **Definicion operativa para IACT:**

   Un UC es una narrativa que describe COMO un usuario interactua con el
   sistema para completar una tarea de negocio, incluyendo el flujo normal
   y los flujos alternativos.

1.2 Caracteristicas de un Caso de Uso
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Narrativo**
     - Cuenta una historia: "El usuario hace X, sistema responde Y"
   * - **Alto nivel**
     - Describe interaccion completa, no detalles atomicos
   * - **Orientado a actor**
     - Perspectiva del usuario, no del sistema
   * - **Secuencial**
     - Pasos ordenados en flujo temporal
   * - **Contextualizado**
     - Incluye precondiciones y postcondiciones
   * - **Multi-camino**
     - Flujo normal mas flujos alternativos

1.3 UC vs FR: Diferencia Fundamental
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Caso de Uso (UC)
     - Requisito Funcional (FR)
   * - Vista
     - Narrativa (historia)
     - Atomica (declaracion)
   * - Nivel
     - Alto (interaccion completa)
     - Bajo (comportamiento especifico)
   * - Orientacion
     - Actor (usuario)
     - Sistema (implementacion)
   * - Dependencia
     - Secuencia importa
     - Independiente
   * - Verificacion
     - Escenario end-to-end
     - Test unitario/aislado
   * - Ejemplo
     - "UC-043: Configurar SoD"
     - "FR-043.1: Sistema DEBE mostrar lista SoD"

----

2. Estructura de un Caso de Uso
-------------------------------

2.1 Template Estandar IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ============================================================
   UC-NNN: Nombre del Caso de Uso
   ============================================================

   METADATA:
     ID:              UC-NNN
     Nombre:          [Titulo descriptivo]
     Actor Primario:  [Agrupador RBAC]
     Prioridad:       Alta | Media | Baja
     Estado:          Borrador | Aprobado | Implementado
     Version:         X.Y.Z

   DESCRIPCION:
     [Parrafo que explica el objetivo del caso de uso]

   PRECONDICIONES:
     1. [Condicion que debe cumplirse antes de iniciar]
     2. [Otra condicion]

   POSTCONDICIONES (Exito):
     1. [Estado del sistema despues de ejecucion exitosa]
     2. [Otro resultado esperado]

   FLUJO NORMAL:
     1. Actor [accion]
     2. Sistema [respuesta]
     3. Actor [accion]
     4. Sistema [respuesta]
     ...

   FLUJOS ALTERNOS:
     [Na]: [Nombre del alterno]
       Na.1. [Condicion]
       Na.2. [Accion alternativa]
       Na.3. Retorna a paso N

   EXCEPCIONES:
     [Ea]: [Nombre de la excepcion]
       Ea.1. [Condicion de error]
       Ea.2. Sistema [manejo del error]
       Ea.3. Caso de uso termina

   TRAZABILIDAD:
     Business Rules:  [BR_NNN]
     BReq:            [BReq-NNN]
     FR Derivados:    [FR-NNN.1 a FR-NNN.N]

2.2 Ejemplo Completo
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ============================================================
   UC-043: Configurar SoD
   ============================================================

   METADATA:
     ID:              UC-043
     Nombre:          Configurar Segregacion de Funciones
     Actor Primario:  AGR-008 (admin_seguridad)
     Prioridad:       Alta
     Estado:          Aprobado
     Version:         1.0.0

   DESCRIPCION:
     Permite al administrador de seguridad crear, modificar o
     eliminar restricciones de Segregacion de Funciones (SoD)
     que impiden asignar funciones conflictivas a un usuario.

   PRECONDICIONES:
     1. Usuario autenticado con AGR-008 (admin_seguridad)
     2. Existen funciones definidas en catalogo RBAC

   POSTCONDICIONES (Exito):
     1. Restriccion SoD creada/modificada en sistema
     2. Evento registrado en auditoria
     3. Administradores notificados

   FLUJO NORMAL:
     1. Admin Seguridad selecciona "Gestionar SoD"
     2. Sistema muestra lista de restricciones actuales
     3. Admin selecciona "Crear nueva restriccion"
     4. Sistema muestra formulario de configuracion
     5. Admin define nombre de la restriccion
     6. Admin selecciona funciones para Grupo A
     7. Admin selecciona funciones para Grupo B
     8. Sistema valida que no hay conflictos existentes
     9. Admin confirma creacion
    10. Sistema guarda restriccion SoD
    11. Sistema registra en auditoria
    12. Sistema notifica a administradores

   FLUJOS ALTERNOS:
     3a: Modificar restriccion existente
       3a.1. Admin selecciona restriccion de la lista
       3a.2. Sistema muestra formulario con datos actuales
       3a.3. Retorna a paso 5

     3b: Eliminar restriccion
       3b.1. Admin selecciona restriccion y "Eliminar"
       3b.2. Sistema solicita confirmacion
       3b.3. Admin confirma eliminacion
       3b.4. Sistema elimina restriccion
       3b.5. Retorna a paso 11

   EXCEPCIONES:
     8a: Conflicto con usuarios existentes
       8a.1. Sistema detecta usuarios que violarian nueva SoD
       8a.2. Sistema muestra lista de usuarios afectados
       8a.3. Sistema impide guardar hasta resolver
       8a.4. Retorna a paso 6

     1a: Sin permisos
       1a.1. Sistema detecta falta de AGR-008
       1a.2. Sistema muestra mensaje de acceso denegado
       1a.3. Caso de uso termina

   TRAZABILIDAD:
     Business Rules:  BR_007 (Separacion de Funciones SoD)
     BReq:            BReq-004 (Cumplimiento Seguridad)
     FR Derivados:    FR-043.1 a FR-043.5
