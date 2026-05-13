Diagramas de Referencia
=======================

Este espacio almacena diagramas técnicos, arquitectónicos y de proceso
del proyecto IACT.

Página padre
------------

-  `Anexos <../README.md>`__

Información clave
-----------------

Tipos de Diagramas
~~~~~~~~~~~~~~~~~~

**Arquitectura:** - Diagramas C4 (Context, Container, Component, Code) -
Diagramas de infraestructura - Topología de red - Diagramas de
deployment

**Procesos:** - Diagramas de flujo - Diagramas de secuencia - Diagramas
de actividad - BPMN (Business Process Model and Notation)

**Datos:** - Diagramas ER (Entity-Relationship) - Esquemas de base de
datos - Modelos de datos

**UML:** - Diagramas de clases - Diagramas de paquetes - Diagramas de
estados

Formato Recomendado
~~~~~~~~~~~~~~~~~~~

**Mermaid (Preferido):**

.. code:: mermaid

   graph LR
       A[Usuario] --> B[API Gateway]
       B --> C[Backend Django]
       C --> D[PostgreSQL]
       C --> E[MariaDB]

**Ventajas de Mermaid:** - OK: Texto plano (versionable en Git) - OK:
Renderiza en GitHub, MkDocs, VS Code - OK: Fácil de mantener y
actualizar - OK: No requiere herramientas externas

**Otros formatos aceptados:** - PlantUML (.puml) - Draw.io (.drawio) -
exportar también como SVG - Imágenes (PNG, SVG) - con fuente editable

Estructura de Archivos
~~~~~~~~~~~~~~~~~~~~~~

::

   diagramas/
   ├── arquitectura/
   │   ├── c4-context.mmd
   │   ├── c4-container.mmd
   │   └── infraestructura.mmd
   ├── procesos/
   │   ├── etl-flow.mmd
   │   └── deployment-flow.mmd
   ├── datos/
   │   ├── er-analytics.mmd
   │   └── er-ivr.mmd
   └── uml/
       ├── clases-servicios.mmd
       └── secuencia-etl.mmd

Convenciones de Nombrado
~~~~~~~~~~~~~~~~~~~~~~~~

::

   {tipo}-{descripcion}.{extension}

   Ejemplos:
   - c4-context-iact.mmd
   - sequence-etl-process.mmd
   - er-analytics-database.mmd
   - flow-deployment-prod.mmd

Ejemplos
~~~~~~~~

**Diagrama C4 - Context:**

.. code:: mermaid

   C4Context
       title Sistema IACT - Diagrama de Contexto

       Person(usuario, "Analista", "Usuario del dashboard")
       System(iact, "IACT Platform", "Plataforma de analítica de call center")
       System_Ext(ivr, "Sistema IVR", "Sistema telefónico existente")

       Rel(usuario, iact, "Consulta métricas", "HTTPS")
       Rel(iact, ivr, "Extrae datos", "MySQL")

**Diagrama de Secuencia - ETL:**

.. code:: mermaid

   sequenceDiagram
       participant Scheduler
       participant ETL
       participant IVR_DB
       participant Analytics_DB

       Scheduler->>ETL: Trigger daily job
       ETL->>IVR_DB: Extract calls data
       IVR_DB-->>ETL: Raw data
       ETL->>ETL: Transform & calculate metrics
       ETL->>Analytics_DB: Load processed data
       Analytics_DB-->>ETL: Confirmation
       ETL-->>Scheduler: Job complete

Buenas Prácticas
----------------

1. **Versionado**: Incluir fecha o versión en el nombre del archivo
2. **Documentación**: Agregar descripción en comentario al inicio
3. **Simplicidad**: Un diagrama por concepto
4. **Actualización**: Marcar diagramas obsoletos claramente
5. **Fuente**: Guardar archivos editables (no solo imágenes)

Herramientas Recomendadas
-------------------------

-  **Mermaid Live Editor**: https://mermaid.live
-  **VS Code Extension**: Mermaid Preview
-  **PlantUML**: https://plantuml.com
-  **Draw.io**: https://app.diagrams.net

--------------

Diagramas UML PlantUML Disponibles
----------------------------------

Estructura de Carpetas
~~~~~~~~~~~~~~~~~~~~~~

::

   docs/anexos/diagramas/
   ├── casos_de_uso/                   # Diagramas de Casos de Uso (UML)
   ├── secuencia/                      # Diagramas de Secuencia (UML)
   ├── actividad/                      # Diagramas de Actividad (UML)
   └── contexto/                       # Diagramas de Contexto

Catálogo de Diagramas UML
~~~~~~~~~~~~~~~~~~~~~~~~~

Diagramas de Contexto
^^^^^^^^^^^^^^^^^^^^^

+-----------------+-------------------------+-------------------------+
| Archivo         | Descripción             | Relacionado             |
+=================+=========================+=========================+
| `sistema        | Vista general del       | DOC-ARQ-INDEX           |
| _iact_contexto. | Sistema IACT con        |                         |
| puml <contexto/ | actores y sistemas      |                         |
| sistema_iact_co | externos                |                         |
| ntexto.puml>`__ |                         |                         |
+-----------------+-------------------------+-------------------------+

Diagramas de Casos de Uso
^^^^^^^^^^^^^^^^^^^^^^^^^

+------+--------------+----------------+------------------------------+
| ID   | Nombre       | Archivo        | Actor Primario               |
+======+==============+================+==============================+
| UC   | Generar      | `UC-001_       | Analista de Negocio          |
| -001 | Reporte de   | generar_report |                              |
|      | Métricas     | e_metricas.pum |                              |
|      |              | l <casos_de_us |                              |
|      |              | o/UC-001_gener |                              |
|      |              | ar_reporte_met |                              |
|      |              | ricas.puml>`__ |                              |
+------+--------------+----------------+------------------------------+
| UC   | Registrar    | `UC-002_regi   | Agente de Servicio           |
| -002 | Llamada      | strar_llamada_ |                              |
|      | Entrante     | entrante.puml  |                              |
|      |              | <casos_de_uso/ |                              |
|      |              | UC-002_registr |                              |
|      |              | ar_llamada_ent |                              |
|      |              | rante.puml>`__ |                              |
+------+--------------+----------------+------------------------------+
| UC   | Consultar    | `UC-00         | Cliente                      |
| -003 | Estado de    | 3_consultar_es |                              |
|      | Pedido       | tado_pedido.pu |                              |
|      |              | ml <casos_de_u |                              |
|      |              | so/UC-003_cons |                              |
|      |              | ultar_estado_p |                              |
|      |              | edido.puml>`__ |                              |
+------+--------------+----------------+------------------------------+

Diagramas de Secuencia
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 12 22 28 38

   * - ID
     - Nombre
     - Archivo
     - Casos cubiertos
   * - UC-001-SEQ
     - Generar Reporte - Secuencia
     - ``UC-001_generar_reporte_metricas_seq.puml`` (secuencia/)
     - Flujo principal + PDF + Email
   * - UC-002-SEQ
     - Registrar Llamada - Secuencia
     - ``UC-002_registrar_llamada_entrante_seq.puml`` (secuencia/)
     - Flujo principal + CRM sync
   * - UC-003-SEQ
     - Consultar Pedido - Secuencia
     - ``UC-003_consultar_estado_pedido_seq.puml`` (secuencia/)
     - Flujo principal + Historial + SMS

Diagramas de Actividad
^^^^^^^^^^^^^^^^^^^^^^

+------+-------------+---------------+--------------------------------+
| ID   | Nombre      | Archivo       | Flujos cubiertos               |
+======+=============+===============+================================+
| UC   | Generar     | `UC-00        | Principal + Alternos +         |
| -001 | Reporte -   | 1_generar_rep | Excepciones                    |
| -ACT | Actividad   | orte_metricas |                                |
|      |             | _act.puml <ac |                                |
|      |             | tividad/UC-00 |                                |
|      |             | 1_generar_rep |                                |
|      |             | orte_metricas |                                |
|      |             | _act.puml>`__ |                                |
+------+-------------+---------------+--------------------------------+
| UC   | Registrar   | `UC-002_re    | Principal + Validaciones + CRM |
| -002 | Llamada -   | gistrar_llama |                                |
| -ACT | Actividad   | da_entrante_a |                                |
|      |             | ct.puml <acti |                                |
|      |             | vidad/UC-002_ |                                |
|      |             | registrar_lla |                                |
|      |             | mada_entrante |                                |
|      |             | _act.puml>`__ |                                |
+------+-------------+---------------+--------------------------------+
| UC   | Consultar   | `UC-          | Principal + Notificaciones +   |
| -003 | Pedido -    | 003_consultar | Errores                        |
| -ACT | Actividad   | _estado_pedid |                                |
|      |             | o_act.puml <a |                                |
|      |             | ctividad/UC-0 |                                |
|      |             | 03_consultar_ |                                |
|      |             | estado_pedido |                                |
|      |             | _act.puml>`__ |                                |
+------+-------------+---------------+--------------------------------+

Convenciones PlantUML
~~~~~~~~~~~~~~~~~~~~~

**Nomenclatura de archivos**: - Casos de Uso:
``UC-{número}_{nombre}.puml`` - Secuencia:
``UC-{número}_{nombre}_seq.puml`` - Actividad:
``UC-{número}_{nombre}_act.puml`` - Contexto: ``{sistema}_{tipo}.puml``

**Paleta de colores estándar**:

.. code:: plantuml

   !define PRIMARY_COLOR #2C3E50
   !define SECONDARY_COLOR #3498DB
   !define SUCCESS_COLOR #27AE60
   !define WARNING_COLOR #F39C12
   !define ERROR_COLOR #E74C3C

**Renderizado**:

.. code:: bash

   # Instalar PlantUML
   brew install plantuml  # macOS
   apt-get install plantuml  # Ubuntu

   # Generar SVG
   plantuml -tsvg archivo.puml

   # Generar PNG
   plantuml -tpng archivo.puml

**VSCode Extension**:

.. code:: bash

   code --install-extension jebbs.plantuml

--------------

Recursos relacionados
---------------------

-  `Guía de Casos de Uso <../../gobernanza/casos_de_uso_guide.md>`__
-  `Arquitectura <../../arquitectura/README.md>`__
-  `Diseño Detallado <../../diseno_detallado/README.md>`__
-  `Ejemplos Completos <../ejemplos/README.md>`__
