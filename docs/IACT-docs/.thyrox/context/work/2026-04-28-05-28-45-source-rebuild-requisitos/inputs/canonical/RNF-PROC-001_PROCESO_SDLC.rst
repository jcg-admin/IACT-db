RNF-PROC-001_PROCESO_SDLC.md
============================

Requisito No Funcional: Gobernanza del Proceso SDLC (sin agentes IA)
--------------------------------------------------------------------

+-----------------------------------+-----------------------------------+
| Campo                             | Valor                             |
+===================================+===================================+
| **ID RNF**                        | RNF-PROC-001                      |
+-----------------------------------+-----------------------------------+
| **Dominio**                       | Proceso / Gobernanza SDLC         |
+-----------------------------------+-----------------------------------+
| **Alcance**                       | Planificación, diseño,            |
|                                   | construcción, pruebas y           |
|                                   | despliegue ejecutados por el      |
|                                   | equipo de desarrollo (sin agentes |
|                                   | IA).                              |
+-----------------------------------+-----------------------------------+
| **Implementación**                | Guías de proceso y checklists     |
|                                   | operativos documentados en        |
|                                   | ``docs/gobernanza/`` y scripts de |
|                                   | soporte manuales                  |
|                                   | (``scripts/run_all_tests.sh``,    |
|                                   | pipelines CI/CD).                 |
+-----------------------------------+-----------------------------------+

--------------

1. Propósito y Obligaciones
---------------------------

-  **Estandarizar la ejecución del SDLC** mediante guías y workflows
   documentados, asegurando que cada fase se trace en el RTM y en los
   artefactos de entrega.
-  **Cumplir la Constitución del proyecto** y las normas de seguridad y
   calidad antes de emitir artefactos funcionales.
-  **Mantener trazabilidad manual** hacia las fases ejecutadas y los
   outputs depositados en ``docs/`` o generados por CI/CD.

2. Flujo Mínimo de Cumplimiento
-------------------------------

+-----------------------+-----------------------+-----------------------+
| Paso                  | Acción requerida      | Evidencia generada    |
+=======================+=======================+=======================+
| **1**                 | Seleccionar la fase a | Registro en           |
|                       | ejecutar (planning,   | issue/ticket con la   |
|                       | design, testing,      | fase y fecha.         |
|                       | deployment) y seguir  |                       |
|                       | la guía               |                       |
|                       | correspondiente.      |                       |
+-----------------------+-----------------------+-----------------------+
| **2**                 | Validar requisitos    | Checklist completado  |
|                       | previos               | en la guía o en el    |
|                       | (dependencias,        | PR.                   |
|                       | credenciales,         |                       |
|                       | entorno) antes de     |                       |
|                       | ejecutar scripts o    |                       |
|                       | pipelines.            |                       |
+-----------------------+-----------------------+-----------------------+
| **3**                 | Almacenar artefactos  | Archivos versionados  |
|                       | producidos            | en el repo con        |
|                       | (diagramas, planes de | referencia al ticket. |
|                       | prueba, reportes) en  |                       |
|                       | el subdirectorio      |                       |
|                       | indicado por la guía. |                       |
+-----------------------+-----------------------+-----------------------+
| **4**                 | Registrar en el RTM y | Entrada en el índice  |
|                       | en el Índice de       | correspondiente.      |
|                       | Trazabilidad la fase, |                       |
|                       | responsables y        |                       |
|                       | entregables           |                       |
|                       | asociados.            |                       |
+-----------------------+-----------------------+-----------------------+

3. Controles Operativos
-----------------------

-  **Parámetros y contexto**: cada ejecución de scripts debe indicar
   entorno, fechas o rango de datos usados.
-  **Validaciones previas**: verificar versión de Python y dependencias
   antes de correr automatizaciones locales o CI.
-  **Trazabilidad bidireccional**: cada artefacto generado debe citar
   este RNF en su frontmatter o bloque de trazabilidad e indicar el
   responsable que lo ejecutó.
