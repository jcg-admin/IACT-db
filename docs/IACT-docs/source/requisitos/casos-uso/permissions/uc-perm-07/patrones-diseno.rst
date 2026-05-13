.. _uc-perm-07-parte-10:

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
 * - **P-08**
   - Fail-closed
   - error / timeout ⇒ DENIED
 * - **P-15**
   - RBAC granular
   - endpoint admin requiere
     ``view_assignments``
 * - **P-29**
   - Cache invalidate post-COMMIT
   - escalado: invalidate cascade
 * - **P-44**
   - Visibility audit prio
   - admin endpoint con
     volumen anomalo audit
 * - **P-50** (nuevo)
   - Precedence-based authorization
   - revoke > grant_excep > AGR
 * - **P-51** (nuevo)
   - Read-no-audit
   - read crítico no audita por
     escala; se audita la accion que
     consume el resultado

10.2 P-50: Precedence-based authorization
=========================================

**Problema**: en sistemas con multiples
fuentes de permisos (AGR, concesiones,
revocaciones), las decisiones ambiguas
pueden generar tanto false positives
(otorga lo que no debe) como false negatives
(bloquea lo permitido).

**Solucion**: orden estricto de precedencia
documentado, con la regla mas restrictiva
ganando ante igualdad.

Implementacion: revocacion > concesion >
AGR > deny.

**Justificacion**:

- Revocaciones existen por razones de
  seguridad / compliance — no deben poder
  bypassearse via grupos.
- Concesiones existen para casos
  excepcionales — over-ride al AGR.
- AGR es el caso comun.
- Sin match ⇒ deny (P-08 fail-closed).

**Empate** (mismo periodo de validez): la
mas restrictiva (revoke). Determinismo
absoluto.

10.3 P-51: Read-no-audit
========================

**Problema**: auditar cada permission check
genera 100M-1B AuditEvents/dia, infeasible
para storage y query.

**Solucion**: NO auditar por invocacion del
check. Auditar la accion que CONSUMIO el
resultado.

**Trade-off**:

- (+) Storage / performance manejable.
- (-) Pierdes el rastro de "consultaron F
  pero no la usaron" (probing).

**Mitigaciones del lado obscuro**:

- Metricas agregadas (hits, misses, denies)
  por User → detecta anomalia.
- Endpoint admin (consulta humana) SI se
  audita en UC_PERM_09 con volumen.

10.4 P-08 + P-15 reforzados
===========================

- P-08: cualquier excepcion en el algoritmo
  cae a ``allowed=false``. Pruebas de
  fault-injection obligatorias.
- P-15: ``view_assignments`` esta en
  AGR-008 (``daily_audit_group``) y
  AGR-009 (auditor) — no se otorga
  ad-hoc.

10.5 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - Fail-closed (P-08)
   - PASO 7-9, EX-07
 * - RBAC granular (P-15)
   - PASO 3
 * - Cache cascade (P-29)
   - FA-05, PASO 10
 * - P-50 Precedence
   - PASOS 6-9
 * - P-51 Read-no-audit
   - PASO 12, NFR 6.5
 * - P-44 audit volumen anomalo
   - NFR 6.5
