.. meta::
 :artefacto: UC-001-activar-dark-mode
 :tipo: Caso de Uso
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

===========================
UC-001: Activar Modo Oscuro
===========================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Caso de uso end-user
 derivado de :doc:`rn-001-dark-mode` y los requisitos
 :doc:`rf-001-dark-mode-toggle` y :doc:`rf-002-dark-mode-persistence`.
 Aplica el skill ``rm-specification``.

1. Resumen
==========

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC-001
 * - **Nombre**
   - Activar Modo Oscuro
 * - **Actor Principal**
   - Usuario autenticado del producto IACT
 * - **Prioridad**
   - Alta
 * - **Origen RF**
   - :doc:`rf-001-dark-mode-toggle`, :doc:`rf-002-dark-mode-persistence`

2. Precondiciones
=================

- El usuario tiene sesión activa.
- El frontend ha cargado completamente.

3. Flujo Normal
===============

.. list-table::
 :widths: 10 25 65
 :header-rows: 1

 * - Paso
   - Actor
   - Acción
 * - 1
   - Usuario
   - Localiza el toggle de modo visual en el header.
 * - 2
   - Usuario
   - Hace click en el toggle.
 * - 3
   - Sistema
   - Aplica el nuevo modo a la UI inmediatamente (RF-001).
 * - 4
   - Sistema
   - Envía la preferencia al backend (RF-002).
 * - 5
   - Sistema
   - Confirma persistencia.
 * - 6
   - Usuario
   - Cierra y vuelve a abrir el sistema en otro día.
 * - 7
   - Sistema
   - Carga la preferencia almacenada y aplica el modo.

4. Postcondiciones
==================

- La preferencia del usuario está almacenada.
- El modo visual configurado se aplica en todas las pantallas.

5. Flujos alternativos
======================

- **FA-1:** El backend de persistencia no responde → cambio
  visual local persiste, reintento en background (RF-002).

6. Excepciones
==============

- **EX-1:** Error de red durante el cambio → notificar al
  usuario sin revertir el cambio visual.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``rm-specification``
 * - **Fase SDLC**
   - Especificación
 * - **RF backing**
   - :doc:`rf-001-dark-mode-toggle`, :doc:`rf-002-dark-mode-persistence`
 * - **Documento siguiente**
   - :doc:`hld-dark-mode`
