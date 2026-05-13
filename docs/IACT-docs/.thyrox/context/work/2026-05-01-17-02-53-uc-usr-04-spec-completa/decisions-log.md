```yml
created_at: 2026-05-01 17:10:00
project: IACT-docs
work_package: 2026-05-01-17-02-53-uc-usr-04-spec-completa
phase: Phase 7 — DESIGN/SPECIFY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Decisions log — UC_USR_04 Spec Completa

## DEC-USR04-01: Funciones RBAC son canonicas, AGRs son conveniencia

**Origen**: input del usuario en sesion del WP — *"porque estas
poniendo UC admin ahi ya estas mal porque no estas respetando lo que
nosotros decimos acerca de los titulos, tendrias que poner UC con
funcion {nombre de funcion} recuerdas lo del RBAC? en este punto
puede que quieras mencionar los grupos pero eso no seria correcto,
lo que seria correcto son las funciones"*.

**Decision**: en TODOS los UCs:

- El **Actor Principal** se nombra como
  ``User con funcion {nombre_funcion}`` o
  ``Invocante con funcion {nombre_funcion}``.
- **NUNCA** "Admin con AGR-XXX" como descriptor canonico.
- La **dependencia canonica** del UC es la funcion (atomica,
  controlable, audithable). El AGR es una agrupacion predefinida
  para facilitar la asignacion masiva, pero el UC NO depende de
  un AGR especifico.
- Cuando se mencione el AGR, debe ser explicito que es agrupacion
  de conveniencia, no requisito.
- En la seccion "Funciones RBAC" del UC, se lista la funcion
  canonica.
- Opcionalmente, una nota informativa indica el AGR predefinido
  donde la funcion esta agrupada (ej. AGR-006 user_admin_group
  contiene esta funcion en el catalogo predefinido).

**Justificacion**: la metodologia RBAC del proyecto (per
``modelo-rbac-iact``) define funciones como elementos atomicos.
Los AGRs son agrupaciones de conveniencia. Acoplar un UC a un AGR
viola P-15 (RBAC granular) y crea dependencia oculta — si un AGR
se reconfigura para ya no contener la funcion X, el UC dejaria de
ser ejecutable por miembros de ese AGR aun cuando el sistema
podria configurar otro AGR custom con la funcion X.

**Aplica a este UC y a TODOS los UCs futuros del programa**.

**Deuda historica detectada**:

- UC_AUTH_01..05 (Phase del cluster AUTH ya completado) —
  referencias a "AGR-006 user_admin_group" en titulos y
  descripciones. Refactor pendiente.
- UC_USR_01..03 (cluster USR splitted) — mismo patron.
  Refactor pendiente.

**WP futuro registrado**:
``uc-rbac-references-cleanup`` — refactor de UCs ya escritos para
usar funciones canonicas en titulos y descripciones, manteniendo
mencion a AGRs como informativa.

## DEC-USR04-02: Idempotencia configurable

UC_USR_04 ofrece dos politicas para FA-02 (User ya ELIMINATED):

- **Default idempotente**: 200 OK con mensaje "ya eliminado",
  AuditEvent USER_ELIMINATE_NOOP.
- **Strict** (setting ``STRICT_ELIMINATION=true``): 409 CONFLICT.

**Razon**: organizaciones distintas tienen politicas distintas.
La opcion strict permite detectar replays/concurrencia que en
default se silencian.

## DEC-USR04-03: Mailbox-or-abort softer (vs UC_USR_01 / UC_AUTH_03)

A diferencia de UC_USR_01 y UC_AUTH_03 donde el InternalMessage
es **el unico canal** de entrega de credenciales (sin mailbox no
hay operacion), en UC_USR_04 el mailbox es **notificacion
informativa**. La eliminacion procede aun si el mailbox INSERT
falla; el AuditEvent registra ``mailbox_failed=true`` para
trazabilidad.

**Justificacion**: la eliminacion no entrega secretos. La
operacion administrativa destructiva debe completarse aun cuando
la notificacion al User falle (la priorizacion es la accion
sobre la notificacion).

## DEC-USR04-04: P-11 anti-self-elimination obligatorio

EX-04 hard. Admin no puede eliminarse a si mismo. Defensa contra
escalada y lockout. Si requiere su propia eliminacion, debe
solicitarlo a otro admin con la funcion ``deactivate_users``.

## DEC-USR04-05: Datos historicos preservados

Todos los datos pertenecientes al User (mensajes, AuditEvents
generados, registros de actividad) **NO se borran** tras la
eliminacion logica. Permanecen referenciados al user_id ELIMINATED
para:

- Trazabilidad historica (auditoria de actividad pre-eliminacion).
- Integridad referencial (foreign keys).
- Cumplimiento regulatorio (CNST-006 retencion 2 anios).

El email y el username **NO quedan libres** — siguen reservados
al User ELIMINATED. Defensa contra impersonacion.

## Hallazgos

- **H-USR04-01**: deuda en UCs previos (UC_AUTH_01..05 +
  UC_USR_01..03) referencian "Admin con AGR-006" — deuda
  registrada para WP de cleanup.
- **H-USR04-02**: el UC monolitico v4.0.0 menciona "el registro
  permanece en base de datos (baja logica)" sin mencionar
  explicitamente la preservacion del email/username — esta spec
  lo formaliza (DEC-USR04-05).
