.. meta::
 :artefacto: CNST_033
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-033:

====================================
CNST-033: Vocabulario Unificado RBAC
====================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_033
 * - **Categoria**
   - RBAC
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Alto
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^

En toda la documentacion del proyecto IACT (archivos ``.rst``,
``.rst``, glosarios, comentarios) se DEBE usar el termino canonico
**"Funcion"** para referirse a la unidad atomica del sistema RBAC.
En todo el codigo (modelos Django, funciones SQL, variables, metodos,
clases) se DEBE usar el termino **"Function"** (en ingles).

Esta PROHIBIDA la coexistencia de "Capacidad" y "Funcion" (o
"Capacity" y "Function") en docs o codigo del mismo modulo.

1.2 Justificacion
^^^^^^^^^^^^^^^^^

El sistema RBAC IACT tiene dos vistas que coexisten (decision de
arquitectura D-RBAC-1 y ADR-GOB-008): la vista funcional MOD_Access
(modelo legacy v5.2.1 que usaba "Funcion") y la vista tecnica
MOD_Permissions (sistema PERM granular implementado que usaba
"Capacidad"). Sin esta restriccion, ambos terminos coexisten en docs
y codigo, causando confusion y drift de conceptos.

La eleccion de "Funcion" como canonico se basa en:

- Consistencia con MODELO_RBAC_IACT_v5_2_1 (modelo conceptual del
  proyecto).
- "Funcion" describe **que hace** (action), alineado con la filosofia
  "Sin Pretensiones" del proyecto.
- "Capacidad" sugiere atributo del usuario (lo que puede hacer); el
  modelo IACT define la accion atomica, no la propiedad del actor.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Decision arquitectonica (D-RBAC-1, D-RBAC-6)
- **Documento:** rbac-formalization.rst § 2 (WP #6 requisitos)
- **Fecha:** 2026-04-29

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

Tabla de equivalencias entre vocabularios. **El termino canonico es
el de la columna izquierda**.

.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Termino canonico (docs)
   - Termino en codigo
   - Termino legacy v5.2.1
   - Termino PERM granular (deprecated)
 * - Funcion
   - Function
   - Funcion (``functions``)
   - Capacidad (``Capacidad``)
 * - Grupo de Permisos
   - FunctionGroup
   - Grupo (``function_groups``)
   - GrupoPermiso
 * - Membresia
   - GroupMembership
   - ``function_group_membership``
   - GrupoCapacidad
 * - Asignacion de Grupo
   - UserGroupAssignment
   - ``user_function_group_assignments``
   - UsuarioGrupo
 * - Asignacion Directa
   - DirectFunctionAssignment
   - ``user_function_assignments``
   - (parte de ``PermisoExcepcional``)
 * - Permiso Excepcional / Temporal
   - TemporaryPermission
   - (asignacion directa con expires_at)
   - ``PermisoExcepcional``
 * - Regla SoD
   - SeparationOfDutiesRule
   - ``function_separation_rules``
   - (sin equivalente)
 * - Verificacion de Permiso
   - has_permission
   - ``usuario_tiene_permiso``
   - ``verificar_permiso_y_auditar``
 * - Menu Dinamico
   - get_user_menu
   - (no existia en v5.2.1)
   - ``obtener_menu_usuario``
 * - AuditoriaPermiso
   - PermissionAudit
   - (no existia en v5.2.1)
   - ``AuditoriaPermiso``

2.2 Convencion de idioma (referencia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Tipo de elemento
   - Idioma
   - Ejemplo
 * - Modelos Django, clases, metodos
   - Ingles
   - ``class FunctionGroup``
 * - Funciones SQL nativas (PostgreSQL)
   - Ingles
   - ``user_has_permission``
 * - Variables, atributos
   - Ingles
   - ``user_id``, ``expires_at``
 * - Codigos de funciones (capabilities)
   - Ingles
   - ``manage_sessions``, ``view_reports``
 * - Comentarios, docstrings, help_text
   - Espanol
   - ``"""Grupo de funciones que se asignan juntas."""``
 * - Documentacion (.rst)
   - Espanol
   - "El sistema permite..."

Origen: `:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`` § "ESTANDAR DE NOMENCLATURA
v5.2.1" (pendiente migracion a source en WP #7 arquitectura-tecnica).

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Linter custom que valida vocabulario en docstrings y comentarios
- Code review checklist
- Glosario canonico (:doc:`/base-cognitiva/glosario` § H)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

(transversal — aplica a TODOS los modulos del sistema)

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

(transversal — aplica a TODOS los UCs)

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Usar "Capacidad" en docs nuevos
- Usar "Capacidad" en comentarios de codigo nuevos
- Mezclar "Funcion" y "Capacidad" en el mismo archivo
- Renombrar a otro termino (ej: "Permission" en codigo) sin ADR formal

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas hoy. Pendiente catalogo BRs IACT.

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

 # CORRECTO
 class Function(models.Model):
 """Funcion atomica del sistema RBAC."""
 code = models.CharField(max_length=50)
 help_text = "Identificador unico de la funcion (ej: manage_sessions)"

 # INCORRECTO (vocabulario mezclado)
 class Capacidad(models.Model):
 """Function atomica del sistema RBAC."""
 capacity_code = models.CharField(max_length=50)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

 # Buscar usos prohibidos del termino legacy en codigo
 grep -rn "Capacidad\|Capacity" backend/ src/ docs/ \\
 | grep -v "deprecated\|legacy" \\
 && echo "VIOLACION CNST_033" || echo "OK"

6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Documentos historicos / archivados (no se reescribe el pasado).
- Migracion gradual: en codigo legacy se permite alias deprecated por
  un periodo de transicion (max 6 meses) marcado con comentario
  ``# DEPRECATED: usar Function en codigo nuevo``.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cambios al vocabulario canonico requieren actualizar este CNST y
ADR-GOB-008. Ver
:doc:`/normativa/procedimientos/proc-req-015-excepciones-cnst`.

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- 0 ocurrencias de "Capacidad" en docs nuevos del proyecto.
- 0 ocurrencias de "Capacity" en codigo nuevo (excepto alias
  deprecated marcados).
- Code review aprueba uso consistente de "Function" en codigo y
  "Funcion" en docs.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Mixto
- **Frecuencia:** Continuo (linter en CI) + Code review
- **Herramienta:** ruff/grep + checklist

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-029-rbac-modelo-plano`,
     :doc:`cnst-032-menu-dinamico-obligatorio`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - Transversal (todos los UCs deben usar vocabulario canonico)
 * - **MODs afectados**
   - Transversal
 * - **ADRs relacionados**
   - ADR-GOB-008 (RBAC Coexistencia, pendiente iteracion correspondiente)
 * - **Glosario canonico**
   - :doc:`/base-cognitiva/glosario` § H

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2026-04-29
   - NestorMonroy
   - Version inicial. Restriccion creada en iteracion correspondiente tras decisiones
     D-RBAC-1 y D-RBAC-6 del WP #6.
