```yml
project: IACT-docs
work_package: 2026-05-01-19-56-50-uc-perm-07-spec-completa
created_at: 2026-05-01 19:56:50
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-20-00-00-uc-perm-06-spec-completa
target_uc: UC_PERM_07 Verificar Permiso de Usuario
position_in_program: 23 de 61 (cluster PERM 7/10)
```

# WP — UC_PERM_07 Spec Completa (23 de 61)

UC de servicio crítico: el permission check.
Vista admin (consulta explícita) + uso interno
sistema (decorators, middleware).

Función canonica: ``view_assignments`` para
endpoint admin. Para uso interno — service
sin RBAC adicional (no auto-protegido para
evitar recursión).

Trazabilidad: BReq-004.
