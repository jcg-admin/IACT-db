.. meta::
 :artefacto: RN-001-dark-mode
 :tipo: Regla de Negocio
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: analisis
 :skill_aplicada: ba-requirements-analysis
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

RN-001: Soporte de Modo Visual Configurable por Usuario
=======================================================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``ba-requirements-analysis`` (BABOK — Requirements Analysis y
 Design Definition) para transformar la necesidad
 :doc:`bn-001-dark-mode` en regla de negocio formal.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - RN-001
 * - **Nombre**
   - Soporte de Modo Visual Configurable
 * - **Tipo**
   - Restricción operativa
 * - **Categoría**
   - UX / Accesibilidad
 * - **Estado**
   - Vigente (a partir de v1.5.0)
 * - **Origen**
   - :doc:`bn-001-dark-mode` (necesidad)

2. Enunciado formal (SBVR)
==========================

::

 VOCABULARIO:
 - Modo visual: ACTIVO_CLARO | ACTIVO_OSCURO
 - Preferencia de modo: la elección persistente del usuario

 REGLA:
 ES OBLIGATORIO que el sistema permita al usuario seleccionar
 entre los modos visuales disponibles.

 ES OBLIGATORIO que la preferencia del usuario persista entre
 sesiones y se aplique en todas las pantallas del producto.

 ES PROHIBIDO que el sistema imponga un modo visual fijo sin
 dejar al usuario la opción de cambiarlo.

3. Justificación
================

- **Origen:** necesidad BN-001 validada con factibilidad GO.
- **Impacto:** UX inclusiva para usuarios nocturnos (~15% de la
  base).
- **Alineación normativa:** WCAG AA (contraste mínimo en ambos modos).

4. Aplicación
=============

**Donde aplica:**

- Todas las pantallas del producto IACT (frontend).
- Componente de configuración de usuario (settings).
- API de preferencias de usuario.

**Excepciones:** ninguna.

5. Trazabilidad downstream
==========================

RN-001 deriva en los siguientes requisitos funcionales:

- :doc:`rf-001-dark-mode-toggle` — toggle UI para cambiar modo.
- :doc:`rf-002-dark-mode-persistence` — persistencia de la
  preferencia.

Y casos de uso:

- :doc:`uc-001-activar-dark-mode` — flujo end-user.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``ba-requirements-analysis``
 * - **Fase SDLC**
   - Análisis
 * - **Documento previo**
   - :doc:`feasibility-report-dark-mode`
 * - **Documento siguiente**
   - :doc:`rf-001-dark-mode-toggle`
