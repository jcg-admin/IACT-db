Resumen de documentación HLD/ADR de agentes SDLC
================================================

ESTO SE PUEDE CONVERTIR EN PROCEDIMIENTO, SE TIENE QUE QUITAR LO
RELACIONADO A LA IA

Propósito
---------

Este archivo resume la documentación clave de alto nivel (HLD), las
decisiones de arquitectura (ADR) y las guías operativas de los agentes
SDLC disponibles en el proyecto IACT. Sirve como guía rápida para
localizar los artefactos que soportan la gobernanza de agentes
(RNF-PROC-001) y la validación de planes (ADR-AI-020).

Guía principal del CLI SDLC
---------------------------

-  **Referencia:** ``docs/scripts/sdlc_process_guide.md``
-  **Aspectos destacados:**

   -  Describe el CLI ``sdlc_agent.py``, sus fases y los agentes que
      ejecuta en cada etapa del pipeline SDLC.
   -  Incluye un diagrama de componentes que muestra la relación entre
      el CLI, los agentes (``scripts/ai/agents/``) y el cargador de
      Constitution, así como el árbol de artefactos generados en
      ``docs/sdlc_outputs/``.
   -  Explica el flujo de ejecución por fases (``--phase`` y
      ``--pipeline``) y los beneficios de automatizar la generación de
      artefactos SDLC.

Referencia completa de agentes
------------------------------

-  **Referencia:** ``docs/scripts/sdlc_automation_reference.md``
-  **Aspectos destacados:**

   -  Lista más de 20 agentes AI e identifica responsabilidades,
      inputs/outputs y dependencias entre agentes (por ejemplo,
      ``SDLCOrchestratorAgent`` depende de Planner, Feasibility, Design,
      Testing y Deployment).
   -  Documenta rutas de archivo de cada agente y ejemplos de uso en
      código Python para integrarlos en flujos personalizados.

Decisiones de arquitectura relevantes
-------------------------------------

-  **Referencia:**
   ``docs/gobernanza/adr/ADR-AI-020-plan-validation-consensus.md``
-  **Aspectos destacados:**

   -  Establece un esquema de cinco rutas de razonamiento con umbral de
      consenso del 80% para aprobar planes SDLC.
   -  Justifica la elección frente a alternativas (3 rutas/66% vs. 7
      rutas/85%) y alinea la política con RNF-PROC-001.
   -  Define implementación y pruebas obligatorias
      (``plan_validation_agent.py`` y ``test_plan_validation_agent.py``)
      y telemetría en ``logs_data/``.

Uso sugerido
------------

1. **Planeación y validación:** Use el CLI descrito en
   ``sdlc_process_guide.md`` para ejecutar fases o el pipeline completo.
   Aplique las políticas de consenso de ``ADR-AI-020`` para validar
   planes antes de aprobarlos.
2. **Integración o extensión de agentes:** Consulte
   ``sdlc_automation_reference.md`` para ubicar el agente adecuado y sus
   dependencias antes de modificar o añadir capacidades.
3. **Trazabilidad:** Relacione cualquier cambio en agentes SDLC con
   ``ADR-AI-020`` (validación de planes) y RNF-PROC-001 (gobernanza de
   agentes), registrando referencias en commits y PRs.
