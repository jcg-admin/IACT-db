.. _uc-perm-01-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

.. note::

 Flujos alternos backend identicos a
 :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
 Parte 4. La vista PERM agrega flujos UI
 propios listados aqui.

4.1 FA-01..FA-05: heredados de UC_ACC_04
========================================

Idempotencia, expires_at, AGR custom,
re-asignacion post revoke, subset ya directo.
Comportamiento backend identico.

4.2 FA-06 (PERM): seleccionar User desde catalogo
=================================================

**Activador**: invoker abre AGR primero,
luego selecciona destino.

**Diferencia (vs UC_ACC_04 que entra desde
User)**: orden inverso de seleccion. Solo UI;
backend identico.

4.3 FA-07 (PERM): bulk-asignacion (futuro)
==========================================

**Activador**: invoker selecciona MULTIPLES
Users + un AGR.

**Diferencia**: UI envia N requests
secuenciales o un endpoint bulk
``POST /api/access-groups/{id}/bulk-assign/``.
**Fuera de scope** de este UC; documentado
como flujo alterno potencial.

4.4 FA-08 (PERM): preview de composicion + impact
=================================================

**Activador**: antes de confirmar, invoker
ve preview con:

- Funciones que aporta (que no tiene el User).
- Funciones que ya tiene directas (skip).
- Posibles conflictos SoD detectables
  client-side.

**Implementacion**: GET preview-only que NO
persiste. Defensa pre-write para audiencia
de governance.

4.5 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01..FA-05
   - heredados UC_ACC_04
   - identicos
   - segun cada uno
 * - FA-06
   - Seleccion desde AGR
   - UI inversa
   - 201
 * - FA-07
   - Bulk multi-User (futuro)
   - N requests / bulk endpoint
   - n/a aqui
 * - FA-08
   - Preview pre-write
   - GET preview-only
   - 200 OK preview
