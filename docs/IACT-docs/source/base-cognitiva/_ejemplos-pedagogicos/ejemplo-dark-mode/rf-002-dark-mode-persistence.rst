.. meta::
 :artefacto: RF-002-dark-mode-persistence
 :tipo: Requisito Funcional
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: especificacion
 :skill_aplicada: rm-specification
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

RF-002: Persistencia de Preferencia de Modo Visual
==================================================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``rm-specification`` con sintaxis Given/When/Then.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - RF-002
 * - **Nombre**
   - Persistencia de Preferencia de Modo Visual
 * - **Origen**
   - :doc:`rn-001-dark-mode`
 * - **Prioridad**
   - Alta
 * - **Complejidad**
   - Media

2. Especificación Given/When/Then
=================================

**Persistencia al cambio:**

::

 Given: el usuario cambia su modo visual (RF-001)
 When: el cambio se aplica localmente
 Then: el sistema envía la preferencia al backend
 And: el backend almacena la preferencia (db-user-preferences)
 And: confirma persistencia con HTTP 200

**Recuperación en login:**

::

 Given: el usuario inicia una nueva sesión
 When: el frontend carga
 Then: consulta la preferencia almacenada
 And: aplica el modo visual antes del primer render
 And: NO hay flash of unstyled content (FOUC)

**Cross-device consistency:**

::

 Given: el usuario tiene preferencia almacenada (modo OSCURO)
 When: ingresa desde otro dispositivo
 Then: se aplica el modo OSCURO almacenado
 And: la experiencia es consistente entre dispositivos

3. Criterios de aceptación
==========================

1. La preferencia se persiste en menos de 500ms tras el cambio.
2. La preferencia se recupera en menos de 200ms en login.
3. No hay FOUC en ningún navegador soportado.
4. Si el usuario no tiene preferencia, se respeta
   ``prefers-color-scheme`` del SO antes de fallback CLARO.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``rm-specification``
 * - **Fase SDLC**
   - Especificación
 * - **Documento previo**
   - :doc:`rf-001-dark-mode-toggle`
 * - **Documento siguiente**
   - :doc:`uc-001-activar-dark-mode`
