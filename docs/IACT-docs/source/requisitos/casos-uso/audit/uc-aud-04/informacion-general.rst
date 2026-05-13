.. _uc-aud-04-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_AUD_04
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC**
   - ``generate_compliance_report``

1.1 Proposito
=============

Reporte estandar de compliance para
auditorías externas (SOX, ISO, etc.):
plantillas predefinidas, formato fijo,
firmado digitalmente.

1.2 Templates soportados
========================

- **PRIVILEGED_ACCESS**: Users con
  funciones criticas + asignaciones
  recientes.
- **CONFIG_CHANGES**: cambios a AGRs
  predefinidos + concesiones excepcionales.
- **LOGIN_PATTERNS**: distribucion de
  login_failures por IP / username.
- **SENSITIVE_DATA_ACCESS**: queries a
  ``view_audit_log`` y similares.

1.3 Restricciones
=================

CNST-001/002, CNST-008, CNST-009, CNST-013,
CNST-025, CNST-026.

1.4 Audit reforzado P-39 + meta-audit.

1.5 Out of scope
================

- Modificar templates (config / ADR).
