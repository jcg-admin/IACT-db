.. meta::
 :artefacto: DEBT_001
 :tipo: Deuda Tecnica
 :dominio: risks-technical-debt
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

=========================
Deuda Tecnica del Rebuild
=========================

Deuda tecnica documentada durante las iteraciones del rebuild
``source/`` (WPs hijos #1..#16 del padre source-rebuild-strategy).

Cada item incluye severidad, WP de origen, accion propuesta y estado.

Catalogo de deuda activa
========================

.. list-table::
 :widths: 12 18 50 20
 :header-rows: 1

 * - ID
   - Origen
   - Descripcion
   - Estado
 * - DEBT-001
   - iteracion correspondiente
   - Migracion backend ``Capacidad`` → ``Function`` (D-RBAC-2 + D-RBAC-8). Fuera del scope del rebuild documental.
   - Activa (backend team)
 * - DEBT-002
   - iteracion correspondiente deferido (F-DR-5)
   - UC_PERM_01..10 mantienen vocabulario tabla-PERM (UsuarioGrupo, AuditoriaPermiso) en flujos. Migracion vinculada a DEBT-001.
   - Diferida
 * - DEBT-003
   - iteracion correspondiente
   - source/requisitos/requisitos_no_funcionales/ tiene 2 NFRs canonicos. El inventario propuso 28 NFRs ISO 25010 — 26 pendientes.
   - Activa (proximo WP de NFRs)
 * - DEBT-004
   - WP #7 v1 amplia
   - 15+ archivos de arquitectura_tecnica (arquitectura/, despliegue/, diseno_detallado/, plantuml-guide/) pendientes de migracion en v2.
   - Activa (iteracion correspondiente)
 * - DEBT-005
   - Deep-review Fase 3 (F3-DR-5)
   - source/requisitos/requisitos_funcionales/ toctree expone subdirs UC en cajon FR — confusion categorial.
   - Diferida (reorganizacion futura)
 * - DEBT-006
   - WP #7 v1 audit
   - 13 versiones legacy MODELO_DOCUMENTAL_IACT en inputs. Migrar 1 reciente o documentar como "archivado".
   - Pendiente decision
 * - DEBT-007
   - WP #7 v1 audit
   - ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.rst no migrado. Profundiza el analisis de los 8 modulos arquitectonicos.
   - Pendiente iteracion correspondiente

Trazabilidad
============

- ``cross-wp-deep-audit-2026-04-29.rst`` (WP padre track/) — audit master
- ``deep-review-fases-1-2-2026-04-29.rst`` (WP padre track/) — review independiente 1
- ``deep-review-fase-3-2026-04-29.rst`` (WP padre track/) — review independiente 2
- ``v1-omisiones-temp-holding.rst`` (WP #7 track/) — audit omisiones
