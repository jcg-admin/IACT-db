.. _uc-rpt-11-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

Unit, integration, E2E, security, audit.

12.2 Tests unitarios
====================

UT-01: ShareValidator OK con target user.
UT-02: ShareValidator OK con target AGR.
UT-03: ShareValidator rechaza target ==
owner.
UT-04: ShareValidator rechaza expires_at
en pasado.

12.3 Tests de integracion
=========================

IT-01: Share to user → ShareEntry creado +
audit.
IT-02: Share to AGR → todos los users con
AGR pueden aplicar.
IT-03: Apply: receptor ve datos de SU
segmento.
IT-04: Permission read: clone bloqueado.
IT-05: Permission clone: clone OK.
IT-06: Expired → 403.
IT-07: Revoked → 403.
IT-08: Cascade delete: borrar view borra
shares.
IT-09: Receptor sin segmento al apply →
400.
IT-10: Mailbox notify enviado.
IT-11: Receptor mute → no mailbox pero
share creado.

12.4 Tests E2E
==============

E2E-01: Owner comparte view con team;
miembros aplican y ven datos propios.
E2E-02: Owner revoca; receptores pierden
acceso.

12.5 Tests de seguridad
=======================

SEC-01: NO email externo (CNST-001).
SEC-02: Receptor cross-segmento no
recibe datos cross.
SEC-03: Receptor no puede edit, solo
clone.
SEC-04: User sin share_reports → 403.

12.6 Tests de audit
===================

AU-01: REPORT_SHARED emitido con detalle.
AU-02: REPORT_SHARE_APPLIED emitido al
aplicar.
AU-03: REPORT_SHARE_REVOKED emitido.

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..03
   - Tipos
   - IT-01, IT-02
 * - CA-04
   - Scope receptor
   - IT-03, SEC-02
 * - CA-05..06
   - Permissions
   - IT-04, IT-05, SEC-03
 * - CA-07..08
   - TTL/revoke
   - IT-06, IT-07
 * - CA-09
   - Cascade
   - IT-08
 * - CA-10
   - Sin segmento
   - IT-09
 * - CA-11
   - Sin permiso
   - SEC-04
 * - CA-12
   - Audit
   - AU-01..03
 * - CA-13..14
   - Notify / no email
   - IT-10, SEC-01

12.8 Cobertura
==============

- 4 unit
- 11 integration
- 2 E2E
- 4 security
- 3 audit
- 100% de los 14 CAs
