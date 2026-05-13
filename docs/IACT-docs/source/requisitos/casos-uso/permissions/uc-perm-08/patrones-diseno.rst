.. _uc-perm-08-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-29**
   - Cache invalidate
   - menu cache invalidado por
     eventos de cambio de permisos
 * - **P-51**
   - Read-no-audit
   - generacion no audita
 * - **P-52** (nuevo)
   - UI-filter not security
   - filtro visual NO sustituye
     enforcement
 * - **P-53** (nuevo)
   - Registry-driven UI
   - metadata jerarquica vive
     en catalogo, no en code

10.2 P-52: UI-filter is not security
====================================

**Problema**: equipos pueden asumir que
"si no aparece en el menu, el User no puede
acceder". Este pensamiento crea brechas si
el endpoint no esta gated.

**Regla**:

- TODO endpoint debe verificar permiso
  via UC_PERM_07.
- El menu **complementa** la UX (oculta lo
  no autorizado) pero NO es la barrera.
- Si pasa el menu pero no esta protegido en
  endpoint → bug critico de seguridad.

**Implementacion**:

- Code review check: cada endpoint tiene
  decorator / guard.
- Test de seguridad: para cada accion del
  menu, intentar ejecutarla con User sin
  permiso → DEBE devolver 403.

10.3 P-53: Registry-driven UI metadata
======================================

**Problema**: hard-codear domain / section
de cada funcion en frontend o backend code
acopla cambios.

**Solucion**: metadata vive en
``Function`` (DB), editable sin deploy.

- Agregar funcion + metadata → aparece en
  menu de Users con permiso, sin code change.
- Renombrar label → cambio en BD; cache
  invalidate global → siguiente request lo
  refleja.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - Cache invalidate (P-29)
   - FA-05, PASO 9
 * - Read-no-audit (P-51)
   - PASO 11, NFR 6.4
 * - UI-filter (P-52)
   - CA-13, info-1.3
 * - Registry-driven (P-53)
   - PASO 7, datos 7.3
