.. meta::
 :artefacto: HLD-dark-mode
 :tipo: Diseño Alto Nivel
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: diseno
 :skill_aplicada: bpa-design
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

=====================================
HLD: Diseño Alto Nivel — Dark Mode
=====================================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``bpa-design`` (Business Process Architecture — Design phase)
 para diseño de alto nivel del componente Dark Mode.

1. Componentes involucrados
===========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - ThemeProvider (frontend)
   - Estado global del tema actual; provee al árbol de componentes.
 * - ThemeToggle (UI)
   - Componente UI con el control de cambio de modo.
 * - PreferencesAPI (backend)
   - REST endpoint para consultar y persistir preferencia.
 * - UserPreferences (BD)
   - Tabla que almacena ``theme_preference`` por usuario.

2. Diagrama de componentes
==========================

::

    +---------------------+      +-------------------+
    |   ThemeToggle (UI)  |----->| ThemeProvider     |
    +---------------------+      | (Context React)   |
                                 +-------------------+
                                          |
                                          v
                                 +-------------------+
                                 | PreferencesAPI    |
                                 | (Express /Node)   |
                                 +-------------------+
                                          |
                                          v
                                 +-------------------+
                                 | UserPreferences   |
                                 | (PostgreSQL)      |
                                 +-------------------+

3. Flujo de datos
=================

**Cambio de modo:**

::

 ThemeToggle.onClick
   → ThemeProvider.setTheme(new_theme)
       → render con nuevo tema (CSS variables)
       → POST /api/preferences/theme {theme}
           → UserPreferences UPDATE
               → 200 OK

**Carga inicial en login:**

::

 App.mount
   → GET /api/preferences/theme
       → SELECT theme_preference WHERE user_id=?
           → 200 {theme}
   → ThemeProvider.setTheme(theme) ANTES del primer render

4. Decisiones de diseño
=======================

- **CSS variables vs styled-components:** CSS variables (mejor
  performance, switching nativo).
- **Storage:** PostgreSQL (consistencia cross-device) + cache
  local opcional para FOUC mitigation.
- **Default cuando no hay preferencia:** respetar
  ``prefers-color-scheme`` del SO; fallback CLARO.

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``bpa-design``
 * - **Fase SDLC**
   - Diseño
 * - **UC backing**
   - :doc:`uc-001-activar-dark-mode`
 * - **Documento siguiente**
   - :doc:`lld-dark-mode`
