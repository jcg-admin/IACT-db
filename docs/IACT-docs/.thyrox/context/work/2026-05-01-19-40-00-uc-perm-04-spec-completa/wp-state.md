```yml
project: IACT-docs
work_package: 2026-05-01-19-40-00-uc-perm-04-spec-completa
created_at: 2026-05-01 19:36:36
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-19-32-30-uc-perm-03-spec-completa
target_uc: UC_PERM_04 Revocar Permiso Excepcional
position_in_program: 20 de 61 (cluster PERM 4/10)
```

# WP — UC_PERM_04 Spec Completa (20 de 61)

Revocacion explicita de ExceptionalPermission antes de su
expiracion natural. Funcion canonica
``revoke_exceptional_permission`` (P-15 distinta de
``grant_exceptional_permission``).

Sin backing ACC directo (UC_ACC_08 abre, cron expira; este UC
introduce revocacion explicita anticipada). Trazabilidad:
BReq-004.
