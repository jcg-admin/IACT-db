.. meta::
 :artefacto: PROC_GOB_008
 :tipo: Procedimiento
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-30
 :autor: Equipo IACT
 :clasificacion: Interno

PROC-GOB-008: Reorganización de Estructura Documental por Dominio
=================================================================

Propósito
---------

Definir el proceso estándar para reorganizar la estructura de
documentación de cualquier dominio técnico (``docs/infraestructura/``,
``docs/frontend/``, ``docs/devops/``, etc.) alineándola con el modelo
consolidado de ``docs/gobernanza/``.

Alcance
-------

Este proceso aplica a: - Reorganización de documentación existente en
cualquier dominio - Creación de estructura documental para nuevos
dominios - Alineación de estructura con estándares de gobernanza -
Mejora de la navegabilidad y trazabilidad documental

Contexto y Justificación
------------------------

La estructura de ``docs/gobernanza/`` ha sido consolidada siguiendo
mejores prácticas de: - ISO/IEC/IEEE 29148:2018 (trazabilidad de
requisitos) - Architecture Decision Records (ADR) - Separación clara
entre procesos y procedimientos - Organización por tipo de contenido

Este proceso documenta la metodología exitosa aplicada en
``docs/backend/`` (QA-ANALISIS-ESTRUCTURA-BACKEND-001) para replicarla
en otros dominios.

Estructura Objetivo
-------------------

Basado en ``docs/gobernanza/``, cada dominio debe incluir:

::

 docs/{DOMINIO}/
 ├── adr/ # Architecture Decision Records
 ├── catalogos/ # Catálogos de componentes
 ├── checklists/ # Listas de verificación
 ├── ci_cd/ # CI/CD específico del dominio
 ├── diseno/ # Diseño consolidado
 │ ├── api/
 │ ├── arquitectura/
 │ ├── database/
 │ ├── detallado/
 │ └── {subcarpetas específicas del dominio}
 ├── ejemplos/ # Ejemplos de código
 ├── estilos/ # Guías de estilo
 ├── glosarios/ # Glosario técnico
 ├── gobernanza/ # Gobernanza específica del dominio
 ├── guias/ # Guías técnicas
 ├── metodologias/ # Metodologías aplicadas
 ├── planificacion/ # Planificación consolidada
 ├── plans/ # Planes de implementación
 ├── plantillas/ # Plantillas de documentos
 ├── procedimientos/ # Procedimientos operativos
 ├── procesos/ # Procesos high-level
 ├── qa/ # Quality Assurance y análisis
 ├── referencias/ # Referencias técnicas
 ├── requisitos/ # Requisitos del dominio
 ├── seguridad/ # Seguridad específica
 ├── sesiones/ # Sesiones de trabajo
 ├── solicitudes/ # Solicitudes y cambios
 ├── templates/ # Templates adicionales
 ├── testing/ # Testing y pruebas
 ├── trazabilidad/ # Matrices de trazabilidad
 └── vision_y_alcance/ # Visión estratégica

Roles y Responsabilidades
-------------------------

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Rol
   - Responsabilidades
 * - **Tech Lead del Dominio**
   - Aprobar plan de reorganización; validar estructura propuesta;
     comunicar al equipo
 * - **Arquitecto de Software**
   - Revisar decisiones arquitectónicas (ADRs); validar trazabilidad
     técnica
 * - **Quality Assurance**
   - Ejecutar validaciones FASE 4; verificar cumplimiento de estándares
 * - **Agente de IA Especializado**
   - Crear análisis QA inicial; generar tareas detalladas; ejecutar
     fases con evidencias
 * - **Equipo de Gobernanza**
   - Proporcionar plantillas y estándares; revisar conformidad

Flujo del Proceso
-----------------

FASE 0: Preparación y Análisis Inicial
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Duración estimada:** 1 semana

1. **Crear carpeta de análisis QA**

 .. code:: bash

    mkdir -p docs/{dominio}/qa/QA-ANALISIS-ESTRUCTURA-{DOMINIO}-001/

2. **Generar análisis de situación actual**

   - Comparar ``docs/{dominio}/`` vs ``docs/gobernanza/``
   - Identificar gaps estructurales
   - Documentar problemas actuales
   - **Output:** ``README.rst`` en carpeta QA

3. **Crear índice maestro**

   - Documentar propósito del análisis
   - Listar documentos a generar
   - Definir métricas clave
   - **Output:** ``INDICE.rst``

4. **Elaborar plan de reorganización**

   - Estructura objetivo
   - 4 fases de ejecución
   - 60-70 tareas estimadas
   - Timeline y recursos
   - **Output:**
     ``PLAN-REORGANIZACION-ESTRUCTURA-{DOMINIO}-YYYY-MM-DD.rst``

5. **Listar todas las tareas**

   - Desglose completo por fase
   - Duraciones estimadas
   - Dependencias entre tareas
   - **Output:** ``LISTADO-COMPLETO-TAREAS.rst``

FASE 1: Preparación (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Duración estimada:** 1 semana **Tareas:** 5-10

**Entregables:** - [ ] Backup completo creado (git tag) - [ ] 13
carpetas nuevas creadas - [ ] READMEs en carpetas nuevas - [ ] .gitkeep
actualizado - [ ] Mapeo de migración documentado

**Criterios de entrada:** - Plan aprobado por Tech Lead - Backup
preparado - Equipo notificado

**Criterios de salida:** - Estructura base creada - Documentación
inicial presente - Mapeo validado

FASE 2: Reorganización Crítica (Semanas 2-3)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Duración estimada:** 2 semanas **Tareas:** 25-35

**Entregables:** - [ ] 5+ ADRs formales creados en ``gobernanza/adr/`` -
[ ] Carpeta ``diseno/`` consolidada (api, arquitectura, database,
detallado, permisos) - [ ] Carpeta ``planificacion/`` consolidada - [ ]
Carpeta ``sesiones/`` reorganizada - [ ] Carpeta ``qa/`` expandida

**Actividades clave:** 1. **Crear ADRs formales (TASK-006 a TASK-010)**
- Identificar decisiones arquitectónicas documentadas - Crear ADRs con
formato estándar - Agregar metadatos YAML - Crear INDICE_ADRs -
Validar ADRs creados

2. **Consolidar diseño (TASK-011 a TASK-024)**

   - Crear subcarpetas en diseno/
   - Mover contenido a ubicaciones correctas
   - Crear READMEs por subcarpeta
   - Actualizar README principal
   - Validar consolidación

3. **Consolidar planificación (TASK-025 a TASK-030)**

   - Mover feasibility, planning, análisis
   - Consolidar releases
   - Validar estructura

**Criterios de salida:** - Diseño consolidado y documentado - ADRs
formales creados - Contenido legacy migrado

FASE 3: Contenido Nuevo (Semanas 4-5)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Duración estimada:** 2 semanas **Tareas:** 25-30

**Entregables:** - [ ] 4-5 catálogos técnicos creados - [ ] 5+ procesos
(PROC-{DOMINIO}-XXX) creados - [ ] 4-6 procedimientos
(PROCED-{DOMINIO}-XXX) creados - [ ] 5+ matrices de trazabilidad creadas
- [ ] Plantillas creadas (ADR, procedimiento, requisito) - [ ]
VISION-{DOMINIO}-2025.rst creado - [ ] ROADMAP-{DOMINIO}-2025.rst creado -
[ ] Metodologías documentadas - [ ] Referencias técnicas creadas - [ ]
CI/CD documentado

**Actividades clave:**

1. **Catalogos (TASK-031 a TASK-034)**

   - CATALOGO-APIs.rst
   - CATALOGO-SERVICIOS.rst
   - CATALOGO-MODELOS.rst
   - CATALOGO-ENDPOINTS.rst

2. **Procesos (TASK-035 a TASK-038)**

   - PROC-{DOMINIO}-001: Desarrollo de features
   - PROC-{DOMINIO}-002: Gestión de dependencias
   - PROC-{DOMINIO}-003+: Procesos específicos del dominio
   - INDICE_PROCESOS.rst

3. **Trazabilidad (TASK-039 a TASK-042)**

   - MATRIZ-requisitos-tests.rst
   - MATRIZ-requisitos-codigo.rst
   - Matrices específicas del dominio

4. **Plantillas (TASK-044 a TASK-045)**

   - plantilla-adr-{dominio}.rst
   - plantilla-procedimiento-{dominio}.rst
   - plantilla-requisito-funcional.rst

5. **Visión y Estrategia (TASK-046 a TASK-047)**

   - VISION-{DOMINIO}-2025.rst
   - ROADMAP-{DOMINIO}-2025.rst

6. **Metodologías (TASK-048 a TASK-050)**

   - Metodologías aplicadas (TDD, Clean Architecture, etc.)
   - README.rst metodologías

7. **Referencias (TASK-051 a TASK-053)**

   - Referencias técnicas de frameworks
   - APIs externas
   - Estándares

8. **CI/CD (TASK-054)**

   - Pipeline específico del dominio
   - Tests automatizados
   - Deployment workflows

**Criterios de salida:** - Catálogos completos y actualizados - Procesos
y procedimientos documentados - Trazabilidad implementada - Contenido
estratégico creado

FASE 4: Validación y Limpieza (Semana 6)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Duración estimada:** 1 semana **Tareas:** 10-15

**Entregables:** - [ ] Validación de integridad de enlaces (TASK-055) -
[ ] Validación de READMEs (TASK-056) - [ ] Validación de metadatos YAML
(TASK-057) - [ ] Validación de nomenclatura (TASK-058) - [ ] Limpieza
completa de emojis/iconos - [ ] Carpetas legacy eliminadas (TASK-059) -
[ ] README principal actualizado (TASK-060) - [ ] INDEX actualizado
(TASK-061) - [ ] CHANGELOG creado (TASK-062) - [ ] GUIA_NAVEGACION
creada (TASK-063) - [ ] Gobernanza actualizada (TASK-064) - [ ]
Lecciones aprendidas documentadas (TASK-065)

**Validaciones automatizadas:**

1. **TASK-055: Integridad de enlaces**

 .. code:: bash

    # Script de validación de enlaces
    # Output: reporte JSON con enlaces válidos/rotos
    # Target: 90%+ enlaces válidos

2. **TASK-056: Presencia de READMEs**

 .. code:: bash

    # Validar 100% directorios con README
    # Output: lista de directorios sin README

3. **TASK-057: Metadatos YAML**

 .. code:: bash

    # Validar frontmatter YAML en .rst
    # Target: 90%+ archivos con YAML válido

4. **TASK-058: Nomenclatura**

 .. code:: bash

    # Validar snake_case en archivos/directorios
    # Target: 98%+ cumplimiento

5. **Limpieza de emojis/iconos**

 .. code:: bash

    # Procesar TODOS los .rst
    # Reemplazar: OK→OK, [OK]→[OK], [NO]→[ERROR], [ALERTA]️→[WARNING]
    # Eliminar emojis decorativos
    # Output: REPORTE-LIMPIEZA-EMOJIS.rst

**Criterios de salida:** - 90%+ enlaces válidos - 100% directorios con
README - 90%+ metadatos YAML válidos - 98%+ nomenclatura correcta - 0
emojis/iconos en documentación

Inputs
------

.. list-table::
   :header-rows: 1

   * - Input
     - Descripción
     - Fuente
   * - Estructura actual
     - Carpeta ``docs/{dominio}/`` existente
     - Repositorio
   * - Modelo de referencia
     - Estructura ``docs/gobernanza/``
     - Repositorio
   * - Metodología
     - PROCED-GOB-007 (consolidación)
     - Gobernanza
   * - Restricciones del proyecto
     - Lineamientos técnicos específicos
     - docs/{dom inio}/requisitos/

Outputs
-------

.. list-table::
   :header-rows: 1

   * - Output
     - Descripción
     - Ubicación
   * - Análisis QA
     - Documentación completa del análisis
     - docs/{dominio }/qa/QA-ANALISIS-ESTR UCTURA-{DOMINIO}-001/
   * - Plan de reorganización
     - Plan ejecutable detallado
     - doc s/{dominio}/qa/…/PLAN-REORGANIZACION-\*.rst
   * - 60-70 tareas
     - Tareas individuales con evidencias
     - docs/{do minio}/qa/…/TASK-XXX/
   * - Estructura reorganizada
     - Carpetas alineadas con gobernanza
     - docs/{dominio}/
   * - Contenido nuevo
     - Catálogos, procesos, procedimientos, ADRs
     - Diversas ubicaciones
   * - Reportes de validación
     - Resultados FASE 4
     - docs/{domini o}/qa/…/REPORTE-\*.rst
   * - Commit final
     - Commit comprehensivo documentando todo
     - Git

Herramientas y Técnicas
-----------------------

Herramientas
~~~~~~~~~~~~

- **Git**: Control de versiones y backup
- **Agentes de IA especializados**: Automatización de creación de
  tareas y contenido
- **Scripts de validación**: Bash/Python para FASE 4
- **Markdown**: Formato de documentación

Técnicas de Prompting (para Agentes de IA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Auto-CoT** (Chain of Thought automático): Razonamiento paso a paso
- **Self-Consistency**: Validación múltiple de soluciones
- **Tree-of-Thought**: Exploración de alternativas
- **Chain-of-Verification**: Verificación en cadena
- **Self-Refine**: Refinamiento iterativo
- **Tabular CoT**: Razonamiento tabular
- **Decomposed Prompting**: Descomposición de tareas complejas

Criterios de Entrada
--------------------

- [ ] Plan de reorganización aprobado por Tech Lead del dominio
- [ ] Backup creado (git tag local)
- [ ] Equipo notificado del inicio
- [ ] Restricciones del proyecto documentadas

Criterios de Salida
-------------------

Cuantitativos
~~~~~~~~~~~~~

- [ ] 13 carpetas nuevas creadas
- [ ] 60-70 tareas completadas (100%)
- [ ] 5+ ADRs formales creados
- [ ] 4+ catálogos técnicos creados
- [ ] 5+ procesos creados
- [ ] 4+ procedimientos creados
- [ ] 5+ matrices de trazabilidad creadas
- [ ] 90%+ enlaces válidos
- [ ] 100% directorios con README
- [ ] 90%+ metadatos YAML válidos
- [ ] 0 emojis/iconos en documentación

Cualitativos
~~~~~~~~~~~~

- [ ] Estructura alineada con docs/gobernanza/
- [ ] Fácil navegación por desarrolladores
- [ ] Trazabilidad completa implementada
- [ ] Plantillas documentadas y accesibles
- [ ] Equipo capacitado en nueva estructura

Métricas y KPIs
---------------

.. list-table::
   :header-rows: 1

   * - Métrica
     - Target
     - Cálculo
   * - Cobertura de READMEs
     - 100%
     - (dirs_con_readme / total_dirs) \* 100
   * - Validez de enlaces
     - 90%+
     - (enlaces_validos / total_enlaces) \* 100
   * - Metadatos YAML válidos
     - 90%+
     - (archivos_yaml_valido / total_md) \* 100
   * - Nomenclatura correcta
     - 98%+
     - (archivos_snake_case / total_archivos) \* 100
   * - Tareas completadas
     - 100%
     - (tareas_completadas / total_tareas) \* 100
   * - Calidad estructural
     - 7+/10
     - Evaluación comparativa vs gobernanza

Restricciones y Lineamientos
----------------------------

Restricciones Generales del Proyecto
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **NO emojis** en documentación (regla estricta)
- **NO iconos** en documentación (regla estricta)
- Considerar restricciones técnicas específicas del dominio

Lineamientos de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Usar **snake_case** para nombres de archivos y directorios
- Incluir **metadatos YAML** en frontmatter de documentos principales
- Mantener **READMEs** en todos los directorios
- Seguir formato de **Conventional Commits** para commits
- Documentar **evidencias** de ejecución de tareas

Procedimiento de Rollback
-------------------------

En caso de necesitar revertir la reorganización:

.. code:: bash

 # 1. Identificar tag de backup
 git tag -l "backup-reorganizacion-{dominio}-*"

 # 2. Crear branch desde tag
 git checkout -b rollback-{dominio} {tag-backup}

 # 3. Revisar estado previo
 git log --oneline -5

 # 4. Si se confirma rollback necesario
 git checkout {branch-actual}
 git reset --hard {tag-backup}

 # 5. Comunicar al equipo
 # 6. Analizar causa de rollback
 # 7. Documentar lecciones aprendidas

Riesgos y Mitigaciones
----------------------

.. list-table::
   :header-rows: 1

   * - Riesgo
     - Probabilidad
     - Impacto
     - Mitigación
   * - Enlaces rotos tras reor ganización
     - ALTA
     - MEDIO
     - Script validación automatizado (TASK-055)
   * - Pérdida de contenido
     - BAJA
     - CRÍTICO
     - Backup obligatorio (git tag) antes de iniciar
   * - Confusión del equipo
     - MEDIA
     - MEDIO
     - Sesión capacitación + GUIA_NAVEGACION
   * - Tiempo in suficiente
     - MEDIA
     - MEDIO
     - Buffer 20% en estimaciones
   * - Emojis olvidados
     - MEDIA
     - BAJO
     - Validación automatizada + reporte
   * - Metadatos YAML inválidos
     - ALTA
     - MEDIO
     - Validación automatizada + corrección iterativa

Lecciones Aprendidas (de docs/backend/)
---------------------------------------

Éxitos
~~~~~~

1. **Uso masivo de agentes en paralelo**: Reducción 70% tiempo ejecución
2. **Técnicas de prompting avanzadas**: Auto-CoT y Self-Consistency
   aumentaron calidad
3. **Validaciones automatizadas FASE 4**: Identificación temprana de
   problemas
4. **Documentación de evidencias**: Trazabilidad completa del proceso

Áreas de Mejora
~~~~~~~~~~~~~~~

1. **Metadatos YAML**: Solo 0.18% válidos inicialmente - necesita más
   atención
2. **Enlaces rotos**: 44.97% válidos - crear script prevención desde
   inicio
3. **READMEs**: 62.4% cobertura inicial - incluir en checklist de
   creación de carpetas

Recomendaciones
~~~~~~~~~~~~~~~

1. Crear plantilla YAML estándar antes de FASE 1
2. Ejecutar validación de enlaces después de cada fase (no solo FASE 4)
3. Generar READMEs automáticamente con script al crear carpetas
4. Mantener checklist visible durante ejecución

Ejemplos por Dominio
--------------------

Infraestructura
~~~~~~~~~~~~~~~

.. code:: yaml

 Contenido específico:
 - CATALOGO-SERVIDORES.rst
 - CATALOGO-SERVICIOS-CLOUD.rst
 - PROC-INFRA-001-gestion-servidores.rst
 - PROCED-INFRA-001-configurar-servidor-web.rst
 - ADR-INFRA-001-kubernetes-vs-docker-swarm.rst

 Restricciones:
 - NO exposición de credenciales
 - NO IPs públicas en documentación

Frontend
~~~~~~~~

.. code:: yaml

 Contenido específico:
 - CATALOGO-COMPONENTES.rst
 - CATALOGO-RUTAS.rst
 - PROC-FRONT-001-desarrollo-componentes.rst
 - PROCED-FRONT-001-build-produccion.rst
 - ADR-FRONT-001-react-vs-vue.rst

 Restricciones:
 - NO secretos en código cliente
 - Performance: bundle size, lazy loading

DevOps
~~~~~~

.. code:: yaml

 Contenido específico:
 - CATALOGO-PIPELINES.rst
 - CATALOGO-HERRAMIENTAS.rst
 - PROC-DEVOPS-001-pipeline-ci-cd.rst
 - PROCED-DEVOPS-001-deployment-kubernetes.rst
 - ADR-DEVOPS-001-jenkins-vs-gitlab-ci.rst

 Restricciones:
 - NO secretos en repositorio
 - Ambientes: dev, staging, prod

Referencias
-----------

Documentos Modelo
~~~~~~~~~~~~~~~~~

- ``docs/gobernanza/`` - Estructura de referencia
- ``docs/gobernanza/procedimientos/PROCED-GOB-007-consolidacion-ramas-git.rst``
  - Metodología
- ``docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/`` - Ejemplo
   exitoso

Plantillas
~~~~~~~~~~

- Plantilla de ADR: ``docs/gobernanza/adr/plantilla-adr.rst``
- Plantilla de procedimiento: ver PROCED-GOB-007
- Plantilla de proceso: este documento

Estándares
~~~~~~~~~~

- ISO/IEC/IEEE 29148:2018 (Trazabilidad de requisitos)
- Conventional Commits
- Snake_case nomenclatura
- Markdown CommonMark

Template de Prompt Completo para Agentes
----------------------------------------

.. code:: markdown

 REORGANIZACIÓN DE ESTRUCTURA DE DOCUMENTACIÓN - {DOMINIO}

 OBJETIVO:
 Reorganizar docs/{dominio}/ siguiendo modelo docs/gobernanza/

 REGLAS ESTRICTAS:
 1. NO emojis en ningún archivo
 2. NO iconos en ningún archivo
 3. Considerar restricciones: {listar restricciones específicas}

 EJECUTAR:
 1. Crear análisis QA en docs/{dominio}/qa/QA-ANALISIS-ESTRUCTURA-{DOMINIO}-001/
 2. Crear TODAS las tareas (60-70) usando Task tool en PARALELO
 3. Ejecutar FASE 1-4 con agentes especializados
 4. Limpiar emojis/iconos (CRÍTICO)
 5. Documentar procesos y procedimientos
 6. Verificar vs gobernanza
 7. Commit y push

 REFERENCIAS:
 - Modelo: docs/gobernanza/
 - Metodología: PROCED-GOB-007
 - Ejemplo: docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/

 USAR Task tool masivamente y en paralelo.

Checklist de Ejecución
----------------------

Preparación
~~~~~~~~~~~

- [ ] Plan aprobado
- [ ] Backup creado
- [ ] Equipo notificado
- [ ] Carpeta QA creada
- [ ] Análisis completado
- [ ] Plan documentado
- [ ] Tareas listadas

FASE 1
~~~~~~

- [ ] Backup (git tag)
- [ ] 13 carpetas creadas
- [ ] READMEs iniciales
- [ ] .gitkeep actualizado
- [ ] Mapeo documentado

FASE 2
~~~~~~

- [ ] 5+ ADRs creados
- [ ] diseño/ consolidado
- [ ] planificacion/ consolidado
- [ ] sesiones/ reorganizado
- [ ] qa/ expandido

FASE 3
~~~~~~

- [ ] 4+ catálogos creados
- [ ] 5+ procesos creados
- [ ] 4+ procedimientos creados
- [ ] 5+ matrices trazabilidad
- [ ] Plantillas creadas
- [ ] Visión y roadmap
- [ ] Metodologías
- [ ] Referencias
- [ ] CI/CD documentado

FASE 4
~~~~~~

- [ ] Enlaces validados (90%+)
- [ ] READMEs validados (100%)
- [ ] YAML validado (90%+)
- [ ] Nomenclatura validada (98%+)
- [ ] Emojis eliminados (100%)
- [ ] Legacy eliminado
- [ ] Documentación actualizada

Finalización
~~~~~~~~~~~~

- [ ] CHANGELOG creado
- [ ] GUIA_NAVEGACION creada
- [ ] Lecciones documentadas
- [ ] Commit creado
- [ ] Push exitoso
- [ ] PR creado

Historial de Cambios
--------------------

Versión 1.0.0 (2025-11-18)
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Creación del proceso
- Documentación de 4 fases
- Inclusión de lecciones aprendidas de docs/backend/
- Templates y ejemplos agregados

--------------

**Proceso creado:** 2025-11-18 **Última actualización:** 2025-11-18
**Estado:** Activo **Responsable:** Equipo de Gobernanza **Próxima
revisión:** 2025-12-18
