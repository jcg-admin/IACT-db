```yml
project: IACT-docs
work_package: 2026-05-01-18-29-22-uc-acc-05-spec-completa
created_at: 2026-05-01 18:29:22
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-18-22-43-uc-acc-04-spec-completa
target_uc: UC_ACC_05 Gestionar Reglas SoD
position_in_program: 14 de 61 UCs (cluster ACC 5/7)
```

# WP — UC_ACC_05 Spec Completa (14 de 61)

UC con dos sub-operaciones:
- ``view_separation_rules`` (lectura — listar reglas SoD)
- ``manage_separation_rules`` (CRUD — crear, modificar, retirar
  reglas SoD)

P-15 RBAC granular separa lectura y gestion (auditor puede tener
solo lectura). Las reglas SoD configuradas via este UC son
consumidas por UC_ACC_01, UC_ACC_04, UC_PERM_03 al validar
write-time (CNST-005).

Trazabilidad: BRQ-ACC-005 → BReq-004.
