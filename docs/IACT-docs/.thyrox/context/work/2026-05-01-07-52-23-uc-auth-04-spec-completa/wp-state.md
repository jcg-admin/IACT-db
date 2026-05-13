```yml
project: IACT-docs
work_package: 2026-05-01-07-52-23-uc-auth-04-spec-completa
created_at: 2026-05-01 07:52:23
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-07-43-53-uc-auth-03-spec-completa
target_uc: UC_AUTH_04 Cambiar Contrasena
position_in_program: 4 de 61 UCs
```

# WP — UC_AUTH_04 Spec Completa (4 de 61)

UC voluntario / forzado: el User cambia su propia contrasena.
Forzado cuando first_login=true (post UC_USR_01 o UC_AUTH_03) o
cuando el password expira (politica). CNSTs aplicables: CNST-003
sesiones persistidas, CNST-009, CNST-013, CNST-025, CNST-026.

## Definicion de exito

- 13 archivos en
  ``source/requisitos/casos-uso/auth/uc-auth-04/``
- Monolitico eliminado
- Toctree padre actualizado
- Build sin warnings introducidas
