```yml
project: IACT-docs
work_package: 2026-05-01-07-17-48-uc-auth-02-spec-completa
created_at: 2026-05-01 07:17:48
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-07-00-34-uc-auth-01-spec-completa
target_uc: UC_AUTH_02 Cerrar Sesion
position_in_program: 2 de 61 UCs
```

# WP — UC_AUTH_02 Spec Completa (2 de 61)

Aplica el patrón establecido en UC_AUTH_01 al
caso de uso UC_AUTH_02 (Cerrar Sesion). UC simple
(complejidad BAJA, 1 día estimado).

## Insumos canónicos

- ``source/requisitos/casos-uso/auth/uc-auth-02-cerrar-sesion.rst``
  v4.0.0 (a reemplazar).
- ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  v1.0.0 (clases ``Session``, ``AuditEvent``).
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0.
- ``source/normativa/restricciones/cnst-*.rst``
  (CNST canónicos vigentes).
- WP UC_AUTH_01 spec completa (modelo a replicar).

## Convenciones

Mismas que UC_AUTH_01:
- Identifiers EN, prosa ES.
- Archivos sin prefijo numérico (kebab-case
  descriptivo).
- 12 partes en archivos separados + index.

## Definición de éxito

- 13 archivos publicados en
  ``source/requisitos/casos-uso/auth/uc-auth-02/``.
- Old monolithic eliminado.
- Toctree actualizado.
- Build incremental 0/0/0.
