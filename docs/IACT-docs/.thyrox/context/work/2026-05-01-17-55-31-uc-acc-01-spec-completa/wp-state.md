```yml
project: IACT-docs
work_package: 2026-05-01-17-55-31-uc-acc-01-spec-completa
created_at: 2026-05-01 17:55:31
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-17-02-53-uc-usr-04-spec-completa
target_uc: UC_ACC_01 Asignar Funciones a Usuario
position_in_program: 10 de 61 UCs (cluster ACC 1/7)
```

# WP — UC_ACC_01 Spec Completa (10 de 61, abre cluster ACC)

UC con funcion ``assign_functions`` que asigna funciones RBAC
individuales a un User. Side-effect critico: validacion de SoD
(separation of duties) per BR-007 + CNST-005 antes de aceptar la
asignacion.

Trazabilidad: BRQ-ACC-001 → BReq-004 (Cumplimiento Seguridad).
Aplica DEC-USR01-03 (abstract spec) + DEC-USR04-01 (funciones
canonicas, AGR de conveniencia).
