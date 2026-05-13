```yml
project: IACT-docs
work_package: 2026-05-01-16-36-56-uc-usr-01-spec-completa
created_at: 2026-05-01 16:36:56
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
target_uc: UC_USR_01 Crear Usuario
position_in_program: 6 de 61 UCs
```

# WP — UC_USR_01 Spec Completa (6 de 61)

UC admin (AGR-006 user_admin_group) que crea cuentas de usuario.
CNSTs criticos: CNST-001 prohibicion email, CNST-002 buzon
obligatorio, CNST-029 username autogenerado / first_login,
CNST-025 auditoria.

**Trazabilidad BReq**: per WP previo (2026-05-01-15-44-20),
BRQ-USR-001 (legacy) → BReq-004 (canonico — Cumplimiento de
Seguridad y Auditoria).

## Definicion de exito

- 13 archivos en source/requisitos/casos-uso/users/uc-usr-01/
- Monolitico eliminado
- Toctree padre actualizado
- Build sin warnings introducidas
