```yml
created_at: 2026-05-01 16:55:00
project: IACT-docs
work_package: 2026-05-01-16-36-56-uc-usr-01-spec-completa
phase: Phase 7 — DESIGN/SPECIFY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Decisions log — UC_USR_01 Spec Completa

## DEC-USR01-01: Trazabilidad BReq legacy → canonico

Aplica DEC-03 del WP previo (mapeo metodologia). El UC referencia
``BReq satisfecho: BReq-004`` (canonico, segun mapping) y conserva
nota a ``BRQ-USR-001`` (legacy) para preservar trazabilidad
historica con el monolitico v4.0.0.

## DEC-USR01-02: Estructura 12 partes

Aplica el patron establecido en UC_AUTH_01..05: 13 archivos
(1 index + 12 partes). Sin prefijos numericos en nombres
(``std-007-convencion-naming``).

## DEC-USR01-03: Implementacion abstracta (no casarse con stack)

**Origen**: input del usuario en sesion del WP — *"recuerda, que
tienen que respetar las restricciones y nunca te cases con una
tecnologia, porque eso esta mal, es mas importante lo abstracto,
de eso va el diseño cierto, poder implementarlo sin importar el
lenguaje de programacion, etc"*.

**Decision**: la **Parte 11 — Implementacion tecnica** y la
**Parte 12 — Testing** se reescriben en terminos abstractos:

- Parte 11 expresa **componentes logicos** (HTTPEndpoint,
  AuthenticationGuard, UserRepository, etc.), **contratos**
  (signaturas con pre/post-condiciones), **pseudocodigo del
  flujo**, **mapeo excepcion → status HTTP** y **restricciones
  cross-cutting** (logging, atomicidad, no-leak).
- Parte 12 expresa los tests en **pseudocodigo Given/When/Then**
  alineado con los Criterios de Aceptacion (Parte 9).
- Las implementaciones concretas en stacks (Python/Django, Node,
  Java, .NET) son **informativas** y viven en
  ``arquitectura-tecnica/`` o en los modulos del backend, NO en
  el UC.

**Justificacion**: el UC es nivel 3 de la jerarquia (FND_05 §4) —
describe **el QUE hace el sistema desde la perspectiva del
usuario**, no el COMO interno. La implementacion concreta es nivel
5 (CODE). Mezclar niveles viola el principio de responsabilidad
unica de la metodologia base-cognitiva.

**Aplica a este UC y a TODOS los UCs futuros del programa**.

**Deuda detectada (no se resuelve en este WP)**:

- UC_AUTH_01..05 (5 UCs ya splitteados) tienen Parte 11
  con codigo Django/Python concreto. Refactor a abstracto
  pendiente — **WP futuro** ``uc-auth-spec-abstract-refactor``.

## DEC-USR01-04: Restricciones cross-cutting explicitas

Cada UC declara explicitamente como cumple las restricciones
canonicas en la Parte 11 § Restricciones cross-cutting:

- **Logging sin secretos**: SecretsRedactor abstracto,
  implementacion stack-specific.
- **CNST-001 sin canales externos**: politica de build/lint que
  rechaza imports de email/SMS/webhook.
- **CNST-002 mailbox obligatorio**: dentro del bloque atomico.
- **CNST-025 audit obligatorio**: dentro del bloque atomico.
- **CNST-026 sin PII en payload**: validable por test.

## DEC-USR01-05: FR derivados como tabla preliminar

La Parte 7 § 7.7 lista 12 FR derivados preliminares
(FR-USR-01-01..12) en formato tabla. La generacion detallada de
cada FR queda como **WP futuro**
``wp-fr-coverage-from-uc-derivation`` per DEC-10 del WP previo
(metodologia mapeo).

## DEC-USR01-06: Naming en pseudocodigo

El pseudocodigo usa identificadores en ingles (``UserRepository``,
``insert``, ``raise``) — coherente con la convencion del proyecto
"identifiers EN, prosa ES" (CLAUDE.md raiz, convenciones).

## Hallazgos

- **H-USR01-01**: deuda en UC_AUTH_01..05 (codigo Django concreto
  en Parte 11) — registrar para WP futuro.
- **H-USR01-02**: la trazabilidad UC → BR podria ser explicita en
  cada paso del flujo (no solo en Parte 1.4 § Reglas de Negocio).
  Propuesta: anotar BR aplicada por paso del flujo. Defer.

## Definicion de exito de este WP (cumplida)

- 13 archivos en source/requisitos/casos-uso/users/uc-usr-01/ ✅
- Monolitico eliminado ✅
- Toctree padre actualizado ✅
- Build sin warnings introducidas ✅
- Implementacion abstracta sin casarse con stack ✅
- Testing pseudocodigo Given/When/Then ✅
