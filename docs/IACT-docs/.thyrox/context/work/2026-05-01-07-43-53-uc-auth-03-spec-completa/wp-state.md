```yml
project: IACT-docs
work_package: 2026-05-01-07-43-53-uc-auth-03-spec-completa
created_at: 2026-05-01 07:43:53
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-07-17-48-uc-auth-02-spec-completa
target_uc: UC_AUTH_03 Recuperar Contrasena
position_in_program: 3 de 61 UCs
```

# WP — UC_AUTH_03 Spec Completa (3 de 61)

UC de admin (AGR-006 user_admin_group) que genera password
temporal para usuario que olvido sus credenciales. CNSTs criticos:
CNST-001 (prohibicion email/SMTP), CNST-002 (buzon interno
obligatorio), CNST-025 (auditoria inmutable).

## Insumos canonicos

- ``source/requisitos/casos-uso/auth/uc-auth-03-recuperar-contrasena.rst``
  v4.0.0 (a reemplazar).
- ``source/normativa/restricciones/cnst-001-*``,
  ``cnst-002-*``, ``cnst-025-*``.
- ``source/arquitectura-tecnica/modelo-dominio-iact.rst`` v1.0.0.
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst`` v5.4.0
  (AGR-006 user_admin_group).

## Convenciones

- Identifiers EN, prosa ES.
- AGR canonico ingles: user_admin_group (NO agr_admin_usuarios).
- Sin prefijos numericos en nombres.

## Definicion de exito

- 13 archivos en
  ``source/requisitos/casos-uso/auth/uc-auth-03/``.
- Monolitico eliminado.
- Toctree padre actualizado.
- Build sin warnings introducidas por UC_AUTH_03.
