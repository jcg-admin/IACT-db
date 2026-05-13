.. _uc-perm-01-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

.. note::

 NFRs identicos a UC_ACC_04 (mismo backend).
 Esta parte documenta NFRs especificos de la
 vista PERM.

6.1 Performance
===============

Backend: identico a UC_ACC_04 (P50 ≤ 250 ms).

Vista PERM agrega:

- **Catalogo de AGRs**: listado paginado P50
  ≤ 200 ms.
- **Preview composicion**: P50 ≤ 100 ms (solo
  lectura).
- **Users-por-AGR count**: con cache O(1).

6.2 Seguridad
=============

Backend: identica a UC_ACC_04.

Vista PERM:

- Boton "Asignar AGR" en catalogo visible
  solo con ``assign_function_groups``.
- Preview siempre disponible (read-only).

6.3 Confiabilidad
=================

Backend: identica.

Vista PERM:

- Cache de Users-por-AGR invalidado
  post-asignacion (consistencia visual).

6.4 Auditabilidad
=================

Backend: AuditEvent ``AGR_ASSIGNED`` identico
a UC_ACC_04. Audit no distingue origen UI
(ACC vs PERM) — irrelevante para compliance.

6.5 Usabilidad
==============

Diferenciador clave: **vista catalogo vs
vista User**.

- ACC entra desde detalle del User (busca el
  AGR).
- PERM entra desde catalogo del AGR (busca
  el User).
- Ambas validas; diferentes audiencias.

UC_PERM_01 prioriza:

- Composicion del AGR explicita en modal.
- Counts de cobertura.
- Filtros por categoria de AGR.

6.6 Mantenibilidad
==================

Frontend separado: una vista por modulo. Pero
ambas vistas comparten el client API que
pega contra el mismo endpoint backend.

6.7 Cumplimiento
================

Identico a UC_ACC_04.
