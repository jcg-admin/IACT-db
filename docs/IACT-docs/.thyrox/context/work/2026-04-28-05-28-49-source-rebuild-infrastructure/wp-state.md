```yml
project: IACT-docs
work_package: 2026-04-28-05-28-49-source-rebuild-infrastructure
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #10 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:49
current_phase: Phase 1 — DISCOVER (DIFERIDO)
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: DIFERIDO — 2026-04-29 (heavy: 205 inputs, 236 variantes en temp-holding/. Iteracion futura cuando se priorice infra)
```

# WP-hijo #10 — Source Rebuild: infrastructure (Ubuntu + Apache)

## Propósito

Crear cajón nuevo `source/infrastructure/` para Ubuntu + Apache
con estructura **skeleton-first**: 3 archivos.

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- **H5:** WP #7 cerrado.

## Decisiones del padre que aplican

- **Idea 9 + Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de CNST de infra y ADRs DEVOPS** | `source/normativa/restricciones/CNST_008_Infraestructura_Deployment.rst` + ADR-DEVOPS-* en gobernanza. Las CNSTs deben quedar en restricciones/ pero pueden referenciarse desde infrastructure/. |
| **Triage Ubuntu vs Apache** | Convenciones distintas: server-setup, vhosts, mod_wsgi, mod_ssl, networking, security hardening. |

## Acceptance criteria

- ✅ 3 archivos skeleton.
- ✅ `overview.rst`: server topology, Ubuntu base config, Apache
  como reverse proxy + WSGI. SIN scripts.
- ✅ `conventions.rst`: naming de hosts, paths, vhosts; security
  baseline; logging.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** 3 archivos skeleton.

**Out-of-scope:** Scripts ansible/shell, configuraciones Apache
concretas, runbooks (van en `operations/` — WP #12).

## Estado

**Borrador (no iniciado).** Spawneado por T-017.
