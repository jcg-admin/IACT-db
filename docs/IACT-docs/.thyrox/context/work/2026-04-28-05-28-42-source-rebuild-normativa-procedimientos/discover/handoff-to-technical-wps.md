```yml
created_at: 2026-04-28 08:25:00
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
phase: Phase 11 — TRACK (artefacto handoff)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Handoff a WPs técnicos — Procedimientos en temp-holding

Documento de handoff que registra los procedimientos
**específicos de tier técnico** que existen en
`temp-holding/FASE 01/docs/` pero que **no se incorporaron** al
dominio `source/normativa/procedimientos/` por estar fuera de
scope (procedimientos metodológicos vs. procedimientos
técnicos del producto).

Estos archivos quedan **transferidos a su WP técnico
correspondiente** para que sean inspeccionados, convertidos de
Markdown a RST, y publicados en el cajón técnico apropiado
cuando ese WP se ejecute.

## 1. Procedimientos de Infraestructura → WP #10 source-rebuild-infrastructure

**Procesos (`temp-holding/FASE 01/docs/infraestructura/procesos/`):**

- ``PROC-INFRA-001-gestion-infraestructura-vm.md``
- ``PROC-INFRA-002-gestion-configuracion-devcontainers.md``
- ``PROC-INFRA-003-hardening-seguridad-infraestructura.md``
- ``PROC-INFRA-004-backup-recuperacion-infraestructura.md``
- ``PROC-INFRA-005-monitoreo-observabilidad-infraestructura.md``

**Procedimientos detallados
(`temp-holding/FASE 01/docs/infraestructura/procedimientos/`):**

- ``PROCED-INFRA-001-provision-vm-vagrant.md``
- ``PROCED-INFRA-002-configurar-devcontainer-host.md``
- ``PROCED-INFRA-003-ejecutar-pipeline-cicd.md``
- ``PROCED-INFRA-004-backup-restauracion-vm.md``
- ``PROCED-INFRA-005-troubleshooting-devcontainer.md``
- ``PROCED-INFRA-006-actualizar-toolchain-cpython.md``

**Total infraestructura:** 11 archivos.

## 2. Procedimientos de Backend → WP #8 source-rebuild-backend

**Procesos (`temp-holding/FASE 01/docs/backend/procesos/`):**

- ``PROC-BACK-001-desarrollo-features.md``
- ``PROC-BACK-002-gestion-dependencias.md``
- ``PROC-BACK-003-code-review-backend.md``
- ``PROC-BACK-004-testing-estrategia.md``
- ``PROC-BACK-005-deployment-proceso.md``

**Procedimientos detallados
(`temp-holding/FASE 01/docs/backend/procedimientos/`):**

- ``PROCED-BACK-001-ejecutar-tests-backend.md``
- ``PROCED-BACK-002-deployment-staging.md``
- ``PROCED-BACK-003-rollback-deployment.md``
- ``PROCED-BACK-004-actualizar-dependencias.md``

Plus: ``temp-holding/FASE 01/docs/backend/procedures/PROC-BACKEND-001-ejemplo.md`` (verificar si es ejemplo descartable).

**Total backend:** 9-10 archivos.

## 3. Acción esperada del WP destinatario

Cuando los WPs #8 (backend) y #10 (infrastructure) se ejecuten:

1. Inspeccionar cada archivo MD listado arriba.
2. Convertir contenido valioso a RST (Decision 4 strategy v2.0:
   sin Markdown).
3. Aplicar STD_007 (naming) y STD_006 (versión en metadata).
4. Publicar en el cajón técnico correspondiente:

   - Para infraestructura: ``source/infrastructure/runbooks/``
     o ``source/infrastructure/procedimientos/`` (subcajón a
     decidir en su DISCOVER).
   - Para backend: ``source/backend/procedimientos/`` o
     equivalente.

5. **Importante:** estos procedimientos cubren gaps mencionados
   en otros WPs (deploy-prod, rollback, incident-response,
   troubleshooting, hardening). Su incorporación tiene
   prioridad alta dentro del scope de los WPs técnicos.

## 4. No-incorporación al dominio actual: justificación

Los procedimientos en ``source/normativa/procedimientos/`` son
**metodológicos** (cómo se trabaja documentalmente: derivación
de artefactos, generación, revisión, validación, gobernanza).
Los procedimientos de tier técnico (cómo se hace deploy de
backend, cómo se aprovisiona una VM) son **operacionales del
producto** y pertenecen al cajón técnico, no al metodológico.

Esta separación se alinea con la arquitectura v2.0 del rebuild
(strategy v2.0 Idea 8: 3 capas ortogonales — methodology /
spec+tech / lifecycle).

## 5. Status de transferencia

| WP destinatario | # archivos | Status |
|-----------------|-----------:|--------|
| #8 backend | 9-10 | Pendiente — apertura de WP futura |
| #10 infrastructure | 11 | Pendiente — apertura de WP futura |

Este documento queda como **referencia de input obligatoria**
para los DISCOVER de WP #8 y WP #10.
