.. _uc-perm-08-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - P50 (cache hit)
   - ≤ 5 ms
   - 90%+ del trafico
 * - P50 (cache miss)
   - ≤ 50 ms
   - bulk + arbol
 * - P95
   - ≤ 80 ms
   - tail
 * - Cache hit ratio
   - ≥ 85%
   - login + reload tipico
 * - Tamano response
   - ≤ 50 KB
   - User comun

6.2 Seguridad
=============

- El menu **filtra por permiso** pero NO
  sustituye verificacion en cada endpoint.
- NO incluir descripciones detalladas de
  funciones (info-disclosure de capacidades).
- Function code en response (necesario para
  routing) pero NO el SQL ni internals.

6.3 Confiabilidad
=================

- Disponibilidad ≥ 99.9% (caida → User
  sin menu, pero sigue pudiendo ir a URLs
  conocidas).
- Cache distribuido + local fallback.

6.4 Auditabilidad
=================

- NO se audita generacion del menu (P-51).
- Se auditan solo cambios en
  FunctionRegistry (UC_LOG / admin).

6.5 Usabilidad
==============

- Labels traducidos por locale.
- Domains/sections vacios suprimidos
  (no mostrar "Reportes" si User no tiene
  ninguna).
- Orden estable (mismo User → mismo orden
  cada llamada).

6.6 Mantenibilidad
==================

- FunctionRegistry editable sin code change.
- Agregar funcion al registry → aparece en
  menu de Users con permiso (cache reload).

6.7 Internacionalizacion
========================

- Locales soportados: es, en (extensible).
- Fallback determinista: locale solicitado →
  default → es.
