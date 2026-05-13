.. meta::
 :artefacto: DB-user-preferences
 :tipo: Esquema Base de Datos
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: diseno
 :skill_aplicada: db-postgresql
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

===============================
DB Schema: User Preferences
===============================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``db-postgresql`` para diseño de schema relacional.

1. Tabla ``user_preferences``
=============================

.. code-block:: sql

 CREATE TABLE user_preferences (
   user_id           BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
   theme_preference  VARCHAR(10) NOT NULL DEFAULT 'light'
                     CHECK (theme_preference IN ('light', 'dark')),
   created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
 );

 CREATE INDEX idx_user_preferences_updated
   ON user_preferences (updated_at);

2. Decisiones de diseño
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Decisión
   - Justificación
 * - Tabla separada (no columna en ``users``)
   - Permite agregar más preferencias sin alterar tabla central.
 * - ``theme_preference VARCHAR(10)`` con CHECK
   - Type safety simple; expansible si se agregan modos futuros.
 * - ``DEFAULT 'light'``
   - Coherente con default declarado en RF-002.
 * - ``ON DELETE CASCADE``
   - Si se da de baja al usuario, sus preferencias también
     (no hay valor en preservarlas).
 * - ``updated_at`` con índice
   - Soporta queries de auditoría/analítica futuras.

3. Migrations
=============

.. code-block:: sql

 -- migration: 20260501-add-user-preferences.sql

 BEGIN;

 CREATE TABLE user_preferences (...);
 CREATE INDEX ...;

 -- Backfill: ningún registro existente; tabla nueva sin datos.

 COMMIT;

4. Queries esperadas
====================

.. code-block:: postgresql

 -- Q1: Recuperar tema del usuario (en login)
 SELECT theme_preference
 FROM user_preferences
 WHERE user_id = $1;

 -- Q2: Persistir cambio de tema (UPSERT)
 INSERT INTO user_preferences (user_id, theme_preference)
 VALUES ($1, $2)
 ON CONFLICT (user_id) DO UPDATE
 SET theme_preference = EXCLUDED.theme_preference,
     updated_at = NOW();

5. Performance esperada
=======================

- **Q1:** O(1) — primary key lookup; <1ms.
- **Q2:** O(1) — UPSERT con PK; <2ms.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``db-postgresql``
 * - **Fase SDLC**
   - Diseño
 * - **LLD backing**
   - :doc:`lld-dark-mode`
 * - **Documento siguiente**
   - :doc:`api-reference-preferences`
