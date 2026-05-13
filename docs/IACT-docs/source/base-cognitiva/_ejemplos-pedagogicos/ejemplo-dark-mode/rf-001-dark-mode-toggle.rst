.. meta::
 :artefacto: RF-001-dark-mode-toggle
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

RF-001: Toggle de Modo Visual
=============================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``rm-specification`` (Requirements Management — Specification)
 con sintaxis Given/When/Then.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - RF-001
 * - **Nombre**
   - Toggle de Modo Visual
 * - **Origen**
   - :doc:`rn-001-dark-mode`
 * - **Prioridad**
   - Alta
 * - **Complejidad**
   - Baja

2. Especificación Given/When/Then
=================================

**Escenario nominal:**

::

 Given: el usuario está autenticado y tiene una sesión activa
 When: el usuario interactúa con el control de toggle de modo visual
 Then: la interfaz cambia inmediatamente al modo seleccionado
 And: el cambio se aplica sin recarga de la página
 And: la preferencia se envía al backend para persistir (RF-002)

**Escenario alternativo (modo por defecto):**

::

 Given: el usuario nunca ha configurado su modo visual
 When: ingresa al producto por primera vez
 Then: se aplica el modo CLARO (default)
 And: el toggle muestra el estado correcto

**Escenario error (failure modo backend):**

::

 Given: usuario cambia su modo visual
 When: la API de persistencia falla
 Then: el cambio visual SÍ se aplica localmente (UX no se bloquea)
 And: el sistema reintenta la persistencia en background
 And: si falla 3 veces, se notifica al usuario sin revertir el cambio

3. Criterios de aceptación
==========================

1. El toggle es accesible (WCAG AA — keyboard navigable, ARIA labels).
2. El cambio visual aplica en menos de 100ms.
3. El toggle muestra el estado actual con contraste suficiente.
4. La transición entre modos no genera flicker o flashing.

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
   - :doc:`rn-001-dark-mode`
 * - **Documento siguiente**
   - :doc:`rf-002-dark-mode-persistence`
