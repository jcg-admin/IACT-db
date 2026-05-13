.. _uc-usr-02-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Repository / DAO
-----------------------

``UserRepository`` y ``AssignmentRepository``
abstraen el acceso a datos. La capa de
aplicacion no conoce el motor de persistencia.

10.1.2 Specification
--------------------

Filtros componibles (state, AGR, fecha, search)
evaluados como ``Specification`` y combinados
en una ``QueryBuilder`` antes de invocar al
repositorio.

10.1.3 Strategy
---------------

``MaskingStrategy`` para campos sensibles del
listado. Politicas distintas (full mask /
partial mask / domain only) injectables.

10.1.4 Chain of Responsibility
------------------------------

Pipeline: authentication → permission(list_users
o view_users) → throttle → filter validator →
view.

10.1.5 Observer
---------------

``AuditLog`` observa lecturas focalizadas
(P-16). Multiples consumidores (auditor,
alertas).

10.2 Patrones IACT especificos
==============================

10.2.1 P-15 RBAC granular (lectura vs accion)
---------------------------------------------

``list_users`` y ``view_users`` separadas. Un
investigador puede tener solo ``view_users``
si conoce el ID del target. Un dashboard
operacional solo necesita ``list_users``.

10.2.2 P-16 Audit selectivo en lecturas
---------------------------------------

NO se audita cada GET de listado amplio
(volumen alto, baja relevancia). SI se audita:

- Listado focalizado (filter user_id) →
  USERS_VIEWED_FOR_USER.
- Detalle individual → USER_DETAIL_VIEWED.

Tradeoff: balance entre volumen de audit log y
trazabilidad de investigaciones.

10.2.3 P-19 Field masking en listados
-------------------------------------

Listados muestran proyeccion reducida (sin PII
directa). Detalle muestra campos completos
(privilegio mayor justifica). CNST-026 aplica
diferenciado por endpoint.

10.2.4 P-20 Whitelist anti-SQLi en filtros
------------------------------------------

Los parametros de filtro (state, ordering,
search target) se validan contra whitelist
antes de incorporarse al query. NUNCA se
concatena input al query string.

10.3 Anti-patrones evitados
===========================

10.3.1 Auditar todas las lecturas
---------------------------------

**No aplica**: P-16 — el volumen de audit es
inviable si cada GET amplio se registra.

10.3.2 Listado sin paginacion
-----------------------------

**No aplica**: paginacion obligatoria, max 200
por pagina.

10.3.3 Email completo en listado
--------------------------------

**No aplica**: P-19 + CNST-026. Email mascarado
en listado.

10.3.4 ORDER BY arbitrario
--------------------------

**No aplica**: P-20 whitelist obligatoria
(CA-12 anti-SQLi).

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
   - UserRepository / AssignmentRepository
 * - Specification
   - GoF
   - Filtros componibles
 * - Strategy
   - GoF
   - MaskingStrategy
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Observer
   - GoF
   - AuditLog
 * - P-15 RBAC granular
   - IACT
   - list_users vs view_users
 * - P-16 Audit selectivo
   - IACT
   - Solo lecturas focalizadas
 * - P-19 Field masking
   - IACT
   - Listado vs detalle
 * - P-20 Whitelist anti-SQLi
   - IACT
   - Filtros y ordering
