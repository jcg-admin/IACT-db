.. meta::
   :artefacto: DATABASES_CONVENTIONS
   :tipo: Convenciones del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Bases de Datos — Convenciones
============================================

Convenciones que aplican a ambos motores cuando se crean tablas,
índices, queries o migrations propias de IACT (en PostgreSQL).
Para MySQL no aplica naming nuevo de IACT — el sistema origen
define la estructura y IACT consume tal cual.

Naming en PostgreSQL
====================

Tablas
------

- ``snake_case`` plural: ``users``, ``call_records``, ``report_runs``.
- Sin prefijos de aplicación (``app_``, ``iact_``) — la database
  pertenece al producto.
- Sin sufijos redundantes (``_table``, ``_data``).
- Junction tables para M:N: ``{left}_{right}`` orden alfabético
  (ej: ``role_user``, no ``user_role``).

Columnas
--------

- ``snake_case``.
- Primary key: siempre ``id`` (BIGSERIAL) salvo justificación.
- Foreign key: ``{tabla_singular}_id`` (ej: ``user_id``,
  ``call_record_id``).
- Booleans: prefijos ``is_``, ``has_`` o adjetivos directos
  (``is_active``, ``has_been_processed``).
- Timestamps: ``created_at``, ``updated_at``, ``deleted_at``
  (soft delete).
- No abreviaturas no estándar (``description`` no ``descr``).

Índices
-------

- Naming: ``ix_{table}_{cols_sep_por_underscore}``
  (ej: ``ix_users_email``, ``ix_call_records_user_id_created_at``).
- Único: ``uq_{table}_{cols}`` (ej: ``uq_users_email``).
- Composite indexes: el orden de columnas refleja el patrón de
  query más frecuente (``WHERE col_a = ? AND col_b > ?`` →
  índice ``(col_a, col_b)``).

Constraints
-----------

- FK con ``ON DELETE`` explícito (``CASCADE``, ``RESTRICT``,
  ``SET NULL``) según el modelo de dominio.
- ``NOT NULL`` por defecto, ``NULL`` solo cuando representa
  ausencia semántica.
- ``CHECK`` constraints para invariantes de dominio
  verificables a nivel de DB.

Schema management (PostgreSQL via Django)
=========================================

Migrations
----------

- Generadas con ``python manage.py makemigrations``.
- Una migration por cambio lógico, no por commit.
- Naming descriptivo: ``0042_add_role_to_user.py``,
  ``0043_create_audit_log.py``.
- Migration con ``RunPython`` (data migration) cuando hay backfill
  necesario, separadas de schema migrations.

Migrations destructivas
-----------------------

DROP COLUMN, DROP TABLE y RENAME requieren proceso documentado
(ver :doc:`/operations/overview`):

1. Migration aditiva (nueva columna/tabla con default).
2. Deploy + backfill.
3. Cambio de código para usar lo nuevo.
4. Deploy.
5. Migration destructiva (drop antiguo).
6. Deploy.

Nunca combinar add + drop en una sola migration en producción.

Datos sensibles
---------------

- PII (personal identifiable information) cifrada at-rest cuando
  aplica (ver restricciones en :doc:`/normativa/restricciones/index`).
- Logs de auditoría inmutables (append-only) — restricción
  específica de seguridad.

Queries
=======

- En código backend: usar ORM Django (no SQL crudo) salvo
  justificación documentada.
- Cuando se necesita SQL crudo, usar ``cursor`` con bindings
  parametrizados — nunca f-string interpolation.
- N+1 queries: prevenir con ``select_related`` (FK) y
  ``prefetch_related`` (M:N).
- Queries de reporte complejas: considerar materialized views.

Backup y restore
================

- **PostgreSQL:** ``pg_dump`` regular (frecuencia según política
  RPO en NFRs).
- **MySQL:** no aplica desde IACT (el sistema origen es
  responsable).
- Verificación periódica de restore (no solo backup).
- Rotación / retención según política (ver
  :doc:`/operations/overview`).

Conexiones
==========

- Pool de conexiones gestionado por Django settings.
- Timeout explícito en queries para evitar locks largos
  (CNST aplicable).
- Read replicas (si se introducen): routing transparente con
  ``DATABASE_ROUTERS``.

Auditoría
=========

- Logging de operaciones críticas (write/update/delete sensibles)
  a tabla ``audit_log`` append-only o sistema externo inmutable.
- Detalle de qué se audita y formato: ver
  :doc:`/normativa/restricciones/index`.
