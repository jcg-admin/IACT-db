```yml
project: IACT-docs
work_package: 2026-05-01-23-20-25-new-ucs-from-uml06
created_at: 2026-05-01 23:20:25
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-19-56-50-uc-perm-07-spec-completa
target_uc: nuevos UCs derivados del principio UML-06
```

# WP — Nuevos UCs derivados del principio UML-06

## Motivo

`source/base-cognitiva/_uml/uml-06-introduccion-casos-uso.rst`
establece el principio: **el caso de uso refleja lo que el
usuario de la máquina desea, no la implementación interna**.

Los 61 UCs existentes (AUTH, USR, ACC, PERM, RPT, ALR, PIP,
AUD, LOG) son **admin/back-office**. Cubren la gestión del
sistema RBAC y los reportes, pero NO el uso operacional de
la máquina por sus tres tipos principales de usuarios:

- **Agente/Operador**: responde llamadas.
- **Supervisor**: monitorea operación en vivo.
- **Cliente/Caller**: llama al call center.

## UCs a crear

### Cluster OPR (Operador) — 10 UCs

- UC_OPR_01: Cambiar estado del agente (available, break, etc.)
- UC_OPR_02: Atender llamada entrante
- UC_OPR_03: Realizar llamada saliente
- UC_OPR_04: Hold / unhold llamada
- UC_OPR_05: Transferir llamada (warm / cold)
- UC_OPR_06: Ingresar disposition / wrap-up
- UC_OPR_07: Solicitar break / pausa
- UC_OPR_08: Ver propio dashboard
- UC_OPR_09: Ver propio historial de llamadas
- UC_OPR_10: Recibir notificacion supervisor

### Cluster SUP (Supervisor Live) — 3 UCs

- UC_SUP_01: Monitorear agente (whisper)
- UC_SUP_02: Barge-in en llamada
- UC_SUP_03: Mensaje broadcast al equipo

### Cluster CLI (Cliente Caller) — 5 UCs

- UC_CLI_01: Iniciar llamada al call center
- UC_CLI_02: Navegar IVR
- UC_CLI_03: Esperar en cola
- UC_CLI_04: Solicitar callback
- UC_CLI_05: Calificar atencion (post-call)

Total: **18 nuevos UCs** que cierran el ciclo user-perspective.
Estructura: 12-part canónica.
Función backing: nueva por UC, granular.
