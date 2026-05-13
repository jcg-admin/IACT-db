```yml
project: IACT-docs
work_package: 2026-05-01-07-00-34-uc-auth-01-spec-completa
created_at: 2026-05-01 07:00:34
current_phase: Phase 7 — DESIGN/SPECIFY
status: Activo (loop autónomo per directiva del ejecutor)
author: NestorMonroy
flow: rm
methodology_step: rm-specification
predecessor_wp: 2026-05-01-06-33-29-uc-auth-01-analisis
target_uc: UC_AUTH_01 Iniciar Sesion
position_in_program: 1 de 61 UCs
```

# WP — UC_AUTH_01 Spec Completa (1 de 61)

## Propósito

Producir la **especificación completa de 12
partes** de UC_AUTH_01 (primer crítico) como
modelo de referencia para los 60 UCs restantes.
La spec se distribuye en 13 archivos (1 index +
12 partes) en
``source/requisitos/casos-uso/auth/uc-auth-01/``,
reemplazando al monolítico
``uc-auth-01-iniciar-sesion.rst`` v4.0.0.

## Insumos

- ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  v4.0.0 (versión a reemplazar — fuente de
  contenido base).
- ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  v1.0.0 (clases ``User``, ``Session``,
  ``InternalMailbox``, ``AuditEvent``).
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0 (funciones AUTH-001..004).
- ``source/arquitectura-tecnica/matriz-dependencias-uc-iact.rst``
  v1.0.0 (criticidad, transversales, patrones).
- ``source/normativa/restricciones/cnst-001..cnst-030.rst``
  (CNST canónicos vigentes).
- WP predecesor:
  ``2026-05-01-06-33-29-uc-auth-01-analisis``
  (3 análisis con 17 hallazgos, 6 decisiones).

## Modo de ejecución

El ejecutor delegó decisiones autónomas y modo
loop. Sin pausas para confirmación salvo
conflicto arquitectónico, riesgo de pérdida de
información, o build failure.

## Scope

### IN

- 13 archivos RST en
  ``source/requisitos/casos-uso/auth/uc-auth-01/``.
- 12 partes completas con identificadores en
  inglés (clases, funciones RBAC, enums) y prosa
  en español (NOM_001 § 2.3).
- Citas a CNST canónicos vigentes per
  ``source/normativa/restricciones/``.
- Diagramas PlantUML per UML_06 / UML_07 / UML_09
  / UML_11 (no Mermaid).
- Eliminación del archivo monolítico v4.0.0
  ``uc-auth-01-iniciar-sesion.rst``.
- Actualización del toctree en
  ``source/requisitos/casos-uso/auth/index.rst``.
- Build incremental ``make html`` 0/0/0.

### OUT

- Modificación del modelo de dominio canónico.
- Modificación del modelo RBAC.
- Spec de otros UCs (cada uno tiene su WP).
- Implementación de código (Python / JavaScript).

## Definición de éxito

- 13 archivos publicados en
  ``source/requisitos/casos-uso/auth/uc-auth-01/``.
- Old file ``uc-auth-01-iniciar-sesion.rst``
  eliminado (git rm).
- Toctree actualizado.
- Build incremental ``make html`` 0/0/0.
- Convención: identifiers EN, prosa ES.
- Cero menciones de CNST con significados obsoletos.

## Cierre

WP cerrado por orden del ejecutor (I-011) cuando
build sea verde y los 13 archivos estén
publicados.
