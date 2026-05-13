```yml
project: IACT-docs
work_package: 2026-05-01-18-50-27-uc-perm-01-spec-completa
created_at: 2026-05-01 18:50:27
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-18-44-50-uc-acc-09-spec-completa
target_uc: UC_PERM_01 Asignar Grupo a Usuario (vista PERM)
position_in_program: 17 de 61 UCs (cluster PERM 1/10 — abre)
```

# WP — UC_PERM_01 Spec Completa (17 de 61, abre cluster PERM)

UC_PERM_01 es **vista alternativa** del flujo de asignacion
de AGRs (mismo que UC_ACC_04). Coexistencia ACC ↔ PERM
documentada en ADR-GOB-008. La diferencia es:

- ACC: vista funcional del modulo de Acceso.
- PERM: vista RBAC orientada al catalogo de permisos.

Funcion canonica subyacente:
``assign_function_groups`` (la misma que UC_ACC_04).

Trazabilidad: BReq-004. La spec se enfoca en delegar al UC
backing y documentar las diferencias de enfoque.
