```yml
project: IACT-docs
work_package: 2026-05-01-18-07-06-uc-acc-02-spec-completa
created_at: 2026-05-01 18:07:06
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-17-55-31-uc-acc-01-spec-completa
target_uc: UC_ACC_02 Revocar Funciones de Usuario
position_in_program: 11 de 61 UCs (cluster ACC 2/7)
```

# WP — UC_ACC_02 Spec Completa (11 de 61)

UC con funcion ``revoke_functions`` — operacion **inversa** de
UC_ACC_01. Transiciona Assignments ACTIVE → REVOKED preservando
historial. Defensa anti-lockout: si la revocacion deja al User
sin funciones criticas (segun politica), warning explicito.

Trazabilidad: BRQ-ACC-002 → BReq-004. Aplica DEC-USR01-03 +
DEC-USR04-01.
