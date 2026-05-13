.. _uc-acc-03-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Repository / DAO
-----------------------

``AssignmentRepository``,
``AGRRepository``,
``ExceptionalPermissionRepository`` y
``SoDRuleRepository``.

10.1.2 Composite (consolidacion de fuentes)
-------------------------------------------

El ``EffectivePermissionsAggregator``
combina 3 fuentes (direct + via_agr +
exceptional) en un set unico con metadata.

10.1.3 Strategy
---------------

- ``DeduplicationStrategy``: como combinar
  multiples sources de la misma funcion
  (preservar todas vs preservar la "mas
  fuerte").
- ``SelfViewPolicy``: cuando self-view
  exime de ``view_assignments``.

10.1.4 Visitor
--------------

Para construir la respuesta navegando el
``effective_set`` y ejecutando logica
distinta por tipo de source.

10.1.5 Chain of Responsibility
------------------------------

Pipeline:
authentication → permission(view_assignments
o self) → throttle → user existence →
aggregator.

10.1.6 Observer
---------------

AuditLog observa
``EFFECTIVE_PERMISSIONS_VIEWED`` (P-16).

10.2 Patrones IACT especificos
==============================

10.2.1 P-15 RBAC granular
-------------------------

``view_assignments`` distinta de
``assign_functions`` y ``revoke_functions``.
Lectura puede otorgarse sin escritura
(perfil auditor).

10.2.2 P-16 Audit selectivo en lecturas
---------------------------------------

Vista de un User especifico se audita
(focalizada). Listado masivo eventual NO se
auditaria (volumen).

10.2.3 P-19 Field masking
-------------------------

Response NO contiene email/full_name del
target completo. Solo username + user_id +
metadata de funciones.

10.2.4 P-33 Self-view permission bypass
---------------------------------------

**Aplica a**: cualquier User puede ver SUS
PROPIOS permisos sin requerir
``view_assignments``. La self-view se
considera privilegio implicito (necesario
para que el User entienda sus propias
capacidades).

Implementacion: en pre-check, si
``user_id == invoker.id``, skip permission
check.

10.2.5 P-34 SoD detection informativa post-hoc
----------------------------------------------

**Aplica a**: PASO 12. UC_ACC_03 detecta
violaciones SoD pero NO bloquea (eso es
write-time en UC_ACC_01). La deteccion
post-hoc detecta inconsistencias originadas
por:

- Cambios retroactivos en SoDRules
  (UC_ACC_05).
- Bugs historicos donde la validacion no
  se aplico.
- Migracion / importacion de datos.

10.3 Anti-patrones evitados
===========================

10.3.1 Lectura masiva sin paginacion
------------------------------------

**No aplica**: si en el futuro se agrega
endpoint masivo, paginacion + cache + audit
distinto.

10.3.2 Email en payload de listado
----------------------------------

**No aplica**: P-19 + CNST-026.

10.3.3 Auditar cada self-view
-----------------------------

**Aplica con condicion**: SI se audita
self-view (con flag ``self_view=true``)
porque es interesante para correlacion
(¿user X miro sus permisos antes de un
comportamiento sospechoso?). Pero el volumen
es manejable.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Repository
   - GoF
   - Multiple repos
 * - Composite
   - GoF
   - Aggregator
 * - Strategy
   - GoF
   - Dedup / SelfView
 * - Visitor
   - GoF
   - Construccion respuesta
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Observer
   - GoF
   - AuditLog
 * - P-15 RBAC granular
   - IACT
   - view_assignments atomica
 * - P-16 Audit selectivo
   - IACT
   - lectura focalizada
 * - P-19 Field masking
   - IACT
   - sin email/full_name
 * - P-33 Self-view bypass
   - IACT
   - User ve sus propios permisos
 * - P-34 SoD detection post-hoc
   - IACT
   - informativo, no bloqueo
