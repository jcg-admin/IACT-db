.. meta::
 :artefacto: BN-001-dark-mode
 :tipo: Necesidad de Negocio
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: descubrimiento
 :skill_aplicada: ba-elicitation
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

===========================================
BN-001: Modo Oscuro para Usuarios Nocturnos
===========================================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``ba-elicitation`` (BABOK — Elicitation y colaboración) para
 capturar la necesidad de un stakeholder.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BN-001
 * - **Nombre**
   - Modo Oscuro para Usuarios Nocturnos
 * - **Origen**
   - Product Manager (entrevista 2026-04-15)
 * - **Stakeholder primario**
   - Usuarios finales del producto IACT
 * - **Stakeholder secundario**
   - Equipo de Producto, Soporte
 * - **Prioridad**
   - Media

2. Necesidad expresada
======================

**Cita textual del stakeholder:**

   "Tenemos varios usuarios que trabajan turno nocturno (call
   center 24/7). Se nos quejan de que la interfaz blanca les
   genera fatiga visual y dolor de cabeza tras 6+ horas de uso.
   Necesitamos un modo oscuro como mínimo, idealmente con la
   posibilidad de que el usuario lo configure y persistir su
   elección."

3. Análisis BABOK (skill: ba-elicitation)
==========================================

Aplicando el skill ``ba-elicitation``:

3.1 Identificación de stakeholders
----------------------------------

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Stakeholder
   - Tipo
   - Interés
 * - Operadores nocturnos
   - Beneficiario directo
   - Reducir fatiga visual
 * - Product Manager
   - Sponsor
   - Mejorar satisfacción
 * - Soporte
   - Beneficiario indirecto
   - Reducir tickets relacionados
 * - Frontend Eng
   - Implementador
   - Diseño técnico viable

3.2 Técnica de elicitación aplicada
-----------------------------------

- **Técnica:** Entrevista semi-estructurada + Job Stories.
- **Job Story canónica:**

   *Cuando estoy trabajando en turno nocturno y la interfaz es
   muy brillante, quiero poder cambiar a un modo oscuro para
   reducir la fatiga visual y poder mantener mi atención
   durante el turno completo.*

3.3 Validación de la necesidad
------------------------------

- **Evidencia cuantitativa:** 12 tickets de soporte en últimos
  3 meses mencionando "fatiga visual", "interfaz muy brillante",
  o solicitando "modo oscuro".
- **Evidencia cualitativa:** 3 usuarios entrevistados confirman
  el problema y describen workarounds (bajar brillo del monitor,
  extensiones de browser).

4. Criterios de éxito
=====================

La necesidad estará satisfecha cuando:

1. El usuario puede activar/desactivar modo oscuro sin requerir
   recarga de la página.
2. La preferencia persiste entre sesiones.
3. La preferencia se aplica en todas las pantallas del producto.
4. Los colores del modo oscuro cumplen WCAG AA contraste mínimo.

5. Prioridad y urgencia
=======================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Severidad del problema**
   - Media (afecta UX, no bloquea operación)
 * - **Frecuencia del problema**
   - Diaria (turno nocturno)
 * - **Cobertura**
   - ~15% de la base de usuarios
 * - **MoSCoW**
   - Should Have (mejora valuable, no crítica)

6. Restricciones expresadas por el stakeholder
==============================================

- **Plazo deseado:** próximo release (Q3 2026).
- **Presupuesto:** dentro del backlog regular (no requiere ADR
  de presupuesto especial).
- **Compatibilidad:** debe funcionar en navegadores soportados
  por el producto.

7. Próximos pasos del proceso
=============================

1. Generar reporte de factibilidad técnica:
   :doc:`feasibility-report-dark-mode`.
2. Si factibilidad = GO, derivar regla de negocio:
   :doc:`rn-001-dark-mode`.
3. Especificar requisitos funcionales:
   :doc:`rf-001-dark-mode-toggle`,
   :doc:`rf-002-dark-mode-persistence`.

8. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``ba-elicitation``
 * - **Fase SDLC**
   - Descubrimiento
 * - **Documento siguiente**
   - :doc:`feasibility-report-dark-mode`
