.. meta::
 :artefacto: RNF-PROC-001
 :tipo: Requisito No Funcional
 :dominio: requisitos
 :subdominio: requisitos-no-funcionales
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _rnf-proc-001:

==================================================================
RNF-PROC-001: Gobernanza del Proceso SDLC (sin agentes IA)
==================================================================

.. list-table::
   :header-rows: 1

   * - Campo
     - Valor
   * - **ID RNF**
     - RNF-PROC-001
   * - **Dominio**
     - Proceso / Gobernanza SDLC
   * - **Alcance**
     - Planificación, diseño, construcción, pruebas y despliegue ejecutados por el equipo de desarrollo (sin agentes IA).
   * - **Implementación**
     - Guías de proceso y checklists operativos documentados en ``docs/gobernanza/`` y scripts de soporte manuales (``scripts/run_all_tests.sh``, pipelines CI/CD).

--------------

1. Propósito y Obligaciones
---------------------------

- **Estandarizar la ejecución del SDLC** mediante guías y workflows
  documentados, asegurando que cada fase se trace en el RTM y en los
  artefactos de entrega.
- **Cumplir la Constitución del proyecto** y las normas de seguridad y
  calidad antes de emitir artefactos funcionales.
- **Mantener trazabilidad manual** hacia las fases ejecutadas y los
  outputs depositados en ``docs/`` o generados por CI/CD.

2. Flujo Mínimo de Cumplimiento
-------------------------------

.. list-table::
   :header-rows: 1

   * - Paso
     - Acción requerida
     - Evidencia generada
   * - **1**
     - Seleccionar la fase a ejecutar (planning, design, testing, deployment) y seguir la guía correspondiente.
     - Registro en issue/ticket con la fase y fecha.
   * - **2**
     - Validar requisitos previos (dependencias, credenciales, entorno) antes de ejecutar scripts o pipelines.
     - Checklist completado en la guía o en el PR.
   * - **3**
     - Almacenar artefactos producidos (diagramas, planes de prueba, reportes) en el subdirectorio indicado por la guía.
     - Archivos versionados en el repo con referencia al ticket.
   * - **4**
     - Registrar en el RTM y en el Índice de Trazabilidad la fase, responsables y entregables asociados.
     - Entrada en el índice correspondiente.

3. Controles Operativos
-----------------------

- **Parámetros y contexto**: cada ejecución de scripts debe indicar
  entorno, fechas o rango de datos usados.
- **Validaciones previas**: verificar versión de Python y dependencias
  antes de correr automatizaciones locales o CI.
- **Trazabilidad bidireccional**: cada artefacto generado debe citar
  este RNF en su frontmatter o bloque de trazabilidad e indicar el
  responsable que lo ejecutó.
