.. _uc-perm-08-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Cache hit
====================

Camino mayoritario: response < 5 ms.

4.2 FA-02: User sin funciones
=============================

User recien creado, sin AGRs ni
concesiones.

Resultado: ``domains: []``. NO error — el
frontend muestra "Sin acceso aun. Contacte a
admin." (mensaje canonico).

4.3 FA-03: Locale no soportado
==============================

User pide ``locale=fr`` no soportado.
Fallback: ``es`` (default). Header
``Content-Language: es`` en response.

4.4 FA-04: Function sin metadata de menu
========================================

Function existe en catalogo pero NO tiene
metadata jerárquica (e.g.
``execute_bulk_etl_job`` — funcion interna,
no de menu).

Resultado: NO aparece en menu — pero el
endpoint sigue protegido por UC_PERM_07.
Esto es intencional: hay funciones internas
que no son navegables (cron, jobs, system).

4.5 FA-05: Cache invalidate por evento
======================================

Al modificarse permisos del User
(UC_ACC_01/02/06, UC_PERM_05/06):

::

   MenuCache.invalidate(user_id=U)

Proxima carga del menu del User U es
miss → recalcula. Garantiza que cambios se
reflejen al refrescar.

4.6 FA-06: User multi-segmento
==============================

User en multiples segmentos
(``segment_codes`` lista). El segmento
filtra view_* por cada segmento; el menu
resultante incluye dashboards / reportes de
TODOS los segmentos del User. Sin
deduplicacion necesaria — sections distintas
si entidad / scope distintos.

4.7 FA-07: Hot reload de FunctionRegistry
=========================================

Si admin agrega Function al registry (poco
frecuente), MenuCache global se invalida →
todos los Users reciben proximo menu con la
nueva entrada (si tienen el permiso).

4.8 FA-08: Idea de UC futuro — Menu de OTRO User (admin)
========================================================

Si soporte tecnico necesita ver "el menu que
veria User X" para diagnosticar issues, NO
es UC_PERM_08 (solo own menu).
**UC potencial nuevo**: UC_PERM_08b
"Generar Menu de Otro User"

- funcion canonica:
  ``view_user_menu_simulation``
- backing en AGR-009 auditor / soporte
- modo read-only
- audit obligatorio (P-39 audit reforzado).

Documentado aqui como derivado pero no
implementado en este UC.

4.9 Resumen
===========

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Cache hit
   - response inmediato
   - mayoritario
 * - FA-02
   - User sin funciones
   - domains=[]
   - mensaje frontend
 * - FA-03
   - Locale no soportado
   - fallback es
   - Content-Language
 * - FA-04
   - Function sin meta
   - no aparece en menu
   - endpoint sigue guarded
 * - FA-05
   - Invalidate evento
   - miss en proxima
   - P-29
 * - FA-06
   - Multi-segmento
   - menu union
   - sin dedup
 * - FA-07
   - Hot reload registry
   - global invalidate
   - poco frecuente
 * - FA-08
   - Menu de otro User
   - UC futuro
   - UC_PERM_08b
