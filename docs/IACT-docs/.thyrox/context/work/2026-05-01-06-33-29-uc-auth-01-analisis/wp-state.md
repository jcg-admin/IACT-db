```yml
project: IACT-docs
work_package: 2026-05-01-06-33-29-uc-auth-01-analisis
created_at: 2026-05-01 06:33:29
current_phase: Phase 11 — TRACK (closed)
closed_at: 2026-05-01 07:30:00
status: Cerrado v1.0.0 — 3 análisis registrados, transición a spec completa
author: NestorMonroy
flow: rm
methodology_step: cerrado
predecessor_wp: 2026-05-01-06-24-28-promote-matriz-dependencias-to-source
target_uc: UC_AUTH_01 Iniciar Sesion
```

# WP — Análisis de UC_AUTH_01 (CRÍTICO 1 de 8)

## Propósito

Primero de los 8 WPs analíticos individuales sobre los UCs
CRÍTICOS del catálogo IACT. Aplica la metodología de
:doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`
(adaptación Schmuller Hora 6) al UC más fundamental del
sistema: **UC_AUTH_01 Iniciar Sesion**.

> **Importante**: este WP es **analítico**, no productivo de
> spec completa. No genera los flujos detallados, ni los
> diagramas de secuencia/actividad. Esos viven en otro WP
> posterior. Aquí se hace el análisis previo: actores,
> escenarios candidatos, inclusiones/extensiones, dependencias,
> decisiones pendientes para diseño.

## Contexto

UC_AUTH_01 es uno de los 8 CRÍTICOS según
:doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact` § 1.2.1:
sin él, el sistema no opera. Es la entrada universal — pre-condición
T-01 para los 59 UCs no públicos del catálogo.

## Insumos

- ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  (UC vigente).
- ``source/base-cognitiva/_uml/uml-06-introduccion-casos-uso.rst``
  (metodología).
- ``source/arquitectura-tecnica/modelo-dominio-iact.rst`` v1.0.0
  (clases ``User``, ``Session``, ``InternalMailbox``, ``AuditEvent``).
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst`` v5.4.0
  (funciones AUTH).
- ``source/arquitectura-tecnica/matriz-dependencias-uc-iact.rst``
  v1.0.0 (criticidad y dependencias del UC).

## Scope

### IN

- Análisis de actores primarios y secundarios.
- Conjunto candidato de escenarios (sin desarrollar flujos
  completos).
- Inclusiones ``<<include>>`` y extensiones ``<<extend>>``
  identificadas.
- Dependencias del UC contra otros UCs y contra clases del
  modelo de dominio.
- Análisis de criticidad heredado de la matriz.
- Identificación de decisiones pendientes para Stage 7 DESIGN
  futuro.

### OUT

- Redacción de los flujos detallados (Flujo Normal, Flujos
  Alternos, Excepciones).
- Diagramas de secuencia / actividad / estados.
- Modificación del UC vigente en ``source/``.
- Implementación.

## Entregables

Dos análisis complementarios sobre UC_AUTH_01:

1. ``analyze/uc-auth-01-analisis-uml-06.md`` — aplica la
   metodología introductoria de
   :doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`
   (actores, escenarios candidatos, inclusiones / extensiones,
   beneficiarios, vista del usuario).
2. ``analyze/uc-auth-01-analisis-uml-07.md`` — aplica la
   metodología de diagramas de
   :doc:`/base-cognitiva/_uml/uml-07-diagramas-casos-uso`
   (representación gráfica, secuencia de pasos en escenarios,
   relaciones entre casos de uso, lugar en el proceso de
   análisis, aplicación al modelo IACT).

## Definición de éxito

- Conjunto candidato de escenarios identificado y justificado.
- Mapeo a clases del modelo de dominio explícito.
- Inclusiones / extensiones tipificadas.
- Decisiones pendientes para diseño documentadas.
- Cero hallazgos SPECULATIVE (gate I-012).

## Cierre

WP cerrado por orden del ejecutor (I-011) tras revisión del
análisis.
