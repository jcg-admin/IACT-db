.. _uc-perm-07-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: AGR otorga
=====================

**DADO** User en AGR con funcion F,
**CUANDO** check(F),
**ENTONCES** allowed=true,
origin=GRANTED_BY_AGR.

9.2 CA-02: Revocacion gana
==========================

**DADO** User en AGR con F + revocacion
excepcional ACTIVA para F,
**ENTONCES** allowed=false,
origin=REVOKED_EXCEPTIONAL.

9.3 CA-03: Concesion sin AGR
============================

**DADO** User sin AGR para F + concesion
ACTIVA,
**ENTONCES** allowed=true,
origin=GRANTED_EXCEPTIONAL.

9.4 CA-04: Sin nada
===================

**DADO** ningun match,
**ENTONCES** allowed=false,
origin=DENIED_NO_GRANT.

9.5 CA-05: AGR INACTIVE no cuenta
=================================

**DADO** User en AGR INACTIVE con F,
**ENTONCES** allowed=false (DENIED).

9.6 CA-06: Assignment expirado no cuenta
========================================

**DADO** Assignment.valid_until < now,
**ENTONCES** allowed=false.

9.7 CA-07: Concesion expirada no cuenta
=======================================

**DADO** ExceptionalPermission GRANT con
valid_until < now,
**ENTONCES** allowed=false.

9.8 CA-08: Multi-AGR retorna lista
==================================

**DADO** F otorgada por A, B, C,
**ENTONCES** via_agr_codes = [A, B, C].

9.9 CA-09: Cache hit
====================

**DADO** mismo (user, F) consultado dentro
de TTL,
**ENTONCES** cache=true en response.

9.10 CA-10: Cache invalidate por evento
=======================================

**DADO** invalidate(U) emitido,
**ENTONCES** proximo check para U es miss.

9.11 CA-11: Bulk
================

**DADO** check_bulk con 50 codes,
**ENTONCES** results.length = 50, una sola
query a BD para misses.

9.12 CA-12: Funcion no existe 400
=================================

**DADO** function_code no en catalogo,
**ENTONCES** 400 FUNCTION_NOT_FOUND.

9.13 CA-13: User no existe 404
==============================

**ENTONCES** 404.

9.14 CA-14: Sin permiso admin 403
=================================

**DADO** caller sin view_assignments en
endpoint admin,
**ENTONCES** 403.

9.15 CA-15: Fail-closed en BD timeout
=====================================

**DADO** BD timeout,
**ENTONCES** error 503; el caller (decorator)
DENIEGA la accion.

9.16 CA-16: Sin audit por invocacion
====================================

**DADO** N invocaciones,
**ENTONCES** 0 AuditEvents emitidos por
UC_PERM_07.

9.17 CA-17: TTL ajustado por valid_until
========================================

**DADO** concesion con valid_until = now+30s,
**ENTONCES** TTL del cache <= 30s.

9.18 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Algoritmo de precedencia
   - Funcional
 * - CA-05..07
   - Estado/expiracion respeta
   - Funcional
 * - CA-08
   - Multi-AGR
   - Funcional
 * - CA-09..10, 17
   - Cache + TTL
   - Performance
 * - CA-11
   - Bulk
   - Performance
 * - CA-12..14
   - Errores
   - Robustez
 * - CA-15
   - Fail-closed
   - Seguridad
 * - CA-16
   - Sin audit invocacion
   - Performance
