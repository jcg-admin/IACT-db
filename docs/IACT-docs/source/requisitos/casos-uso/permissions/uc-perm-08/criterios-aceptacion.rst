.. _uc-perm-08-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Menu para User con multiples dominios
================================================

**DADO** User con funciones en vistas y
administracion,
**ENTONCES** menu tiene 2 domains.

9.2 CA-02: User sin funciones
=============================

**DADO** User sin AGRs ni excepciones,
**ENTONCES** ``domains: []`` (no error).

9.3 CA-03: Function REVOKED no aparece
======================================

**DADO** revocacion excepcional sobre F,
**ENTONCES** F no aparece en menu (vino
de UC_PERM_07).

9.4 CA-04: Function GRANT excepcional aparece
=============================================

**DADO** concesion sobre F sin AGR,
**ENTONCES** F aparece en menu.

9.5 CA-05: Function sin metadata no aparece
===========================================

**DADO** F con menu_visible=false,
**ENTONCES** no aparece (aun teniendo
permiso).

9.6 CA-06: Locale es default
============================

**DADO** sin Accept-Language ni query,
**ENTONCES** locale=es.

9.7 CA-07: Locale en
====================

**DADO** ``?locale=en``,
**ENTONCES** labels en ingles.

9.8 CA-08: Locale fallback
==========================

**DADO** locale no soportado,
**ENTONCES** fallback es; sin error.

9.9 CA-09: Cache hit
====================

**DADO** misma request dentro de TTL,
**ENTONCES** cache=true.

9.10 CA-10: Cache invalidate por evento
=======================================

**DADO** UC_ACC_01 asigno AGR a User,
**ENTONCES** proxima carga del menu del
User refleja el cambio.

9.11 CA-11: Orden estable
=========================

**DADO** dos invocaciones consecutivas,
**ENTONCES** mismo orden de domains /
sections / actions.

9.12 CA-12: Domain vacio suprimido
==================================

**DADO** registry tiene 5 domains pero User
solo permisos en 2,
**ENTONCES** menu retorna solo 2 domains.

9.13 CA-13: Sin permiso UI != sin permiso real
==============================================

**DADO** funcion oculta en menu,
**CUANDO** User construye URL directa,
**ENTONCES** endpoint devuelve 403
(UC_PERM_07).

9.14 CA-14: BD timeout 503
==========================

**DADO** BD timeout en bulk check,
**ENTONCES** 503; NO menu vacio.

9.15 CA-15: Sin audit por invocacion
====================================

**DADO** N invocaciones,
**ENTONCES** 0 AuditEvents emitidos por
UC_PERM_08.

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Estructura basica
   - Funcional
 * - CA-03..05
   - Filtrado por permiso/registry
   - Funcional
 * - CA-06..08
   - I18n
   - Usabilidad
 * - CA-09..10
   - Cache + invalidate
   - Performance
 * - CA-11..12
   - UX (orden, supresion)
   - Usabilidad
 * - CA-13
   - UI != security
   - Seguridad
 * - CA-14
   - Fail explicito
   - Robustez
 * - CA-15
   - Sin audit
   - Performance
