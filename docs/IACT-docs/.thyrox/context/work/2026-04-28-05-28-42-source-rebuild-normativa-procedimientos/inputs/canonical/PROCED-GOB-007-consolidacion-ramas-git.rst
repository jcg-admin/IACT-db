PROCED-GOB-007: Consolidacion de Ramas Git
==========================================

**ID:** PROCED-GOB-007 **Version:** 1.0.0 **Fecha:** 2025-11-17
**Categoria:** Control de Version / Git / Mantenimiento

--------------

1. PROPOSITO
------------

1.1 Objetivo
~~~~~~~~~~~~

Establecer un procedimiento sistematico para analizar, consolidar y
limpiar ramas Git del proyecto, manteniendo el repositorio organizado y
actualizado.

1.2 Problemas que Resuelve
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Acumulacion de ramas obsoletas o completamente integradas
-  Dificultad para identificar el estado real del proyecto
-  Trabajo duplicado en multiples ramas
-  Falta de claridad sobre que cambios estan activos vs integrados
-  Fragmentacion del conocimiento entre ramas

1.3 Beneficios Esperados
~~~~~~~~~~~~~~~~~~~~~~~~

-  Repositorio limpio y mantenible
-  Rama consolidada con todo el trabajo actualizado
-  Reduccion minima de 50% en numero de ramas activas
-  Mejor visibilidad del estado del proyecto
-  Facilita onboarding de nuevos desarrolladores

--------------

2. ALCANCE
----------

2.1 Incluye
~~~~~~~~~~~

-  Analisis de todas las ramas feature/, fix/, docs/, claude/, copilot/
-  Identificacion de ramas completamente integradas
-  Identificacion de cambios unicos pendientes de integracion
-  Creacion de plan de consolidacion
-  Ejecucion de integraciones y limpieza
-  Validacion y documentacion de resultados

2.2 Excluye
~~~~~~~~~~~

-  Ramas protegidas: main, docs
-  Rama principal de desarrollo: develop (se mantiene, no se elimina)
-  Ramas con trabajo en progreso activo (< 7 dias)
-  Ramas bloqueadas por PRs abiertos

2.3 Frecuencia de Ejecucion
~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  **Regular:** Cada 3 meses (trimestral)
-  **Ad-hoc:** Cuando numero de ramas activas > 15
-  **Emergencia:** Antes de releases importantes

--------------

3. ROLES Y RESPONSABILIDADES
----------------------------

3.1 Matriz RACI
~~~~~~~~~~~~~~~

+---------------------------------+----------+-----------+---------------+------------+
| Actividad                       | Analista | Tech Lead | Desarrollador | Arquitecto |
+=================================+==========+===========+===============+============+
| Ejecutar analisis de ramas      | R        | C         | I             | I          |
+---------------------------------+----------+-----------+---------------+------------+
| Generar plan de consolidacion   | R        | A         | I             | C          |
+---------------------------------+----------+-----------+---------------+------------+
| Aprobar plan                    | I        | A         | I             | C          |
+---------------------------------+----------+-----------+---------------+------------+
| Ejecutar tareas de integracion  | I        | C         | R             | I          |
+---------------------------------+----------+-----------+---------------+------------+
| Validar resultados              | C        | A         | R             | C          |
+---------------------------------+----------+-----------+---------------+------------+
| Documentar lecciones aprendidas | R        | A         | C             | I          |
+---------------------------------+----------+-----------+---------------+------------+

**Leyenda:** - R: Responsable de ejecutar - A: Aprobador final - C:
Consultado durante proceso - I: Informado de resultados

3.2 Perfiles Requeridos
~~~~~~~~~~~~~~~~~~~~~~~

**Analista (quien ejecuta analisis):** - Conocimiento avanzado de Git -
Capacidad de analisis de codigo - Familiaridad con estructura del
proyecto

**Desarrollador Ejecutor:** - Permisos de escritura en repositorio -
Experiencia con Git merge/rebase - Conocimiento de rollback y
recuperacion

--------------

4. PREREQUISITOS
----------------

4.1 Tecnicos
~~~~~~~~~~~~

-  ☐ Acceso al repositorio con permisos de escritura
-  ☐ Git 2.x o superior instalado
-  ☐ Conexion estable a repositorio remoto
-  ☐ Bash shell disponible (Linux/Mac/WSL)

4.2 Organizacionales
~~~~~~~~~~~~~~~~~~~~

-  ☐ Bloque de tiempo reservado (3-4 horas)
-  ☐ Notificacion al equipo sobre consolidacion planificada
-  ☐ No hay trabajo critico en progreso en ramas a consolidar
-  ☐ Backlog de PRs revisado y cerrado

4.3 Conocimientos
~~~~~~~~~~~~~~~~~

-  ☐ Git: merge, rebase, cherry-pick, reset
-  ☐ Resolucion de conflictos
-  ☐ Estrategias de rollback
-  ☐ Estructura del proyecto IACT

--------------

5. PROCEDIMIENTO DETALLADO
--------------------------

ETAPA 1: ANALISIS DE RAMAS (60 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 1.1: Actualizar Referencias Locales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   git fetch --all --prune

**Criterio de Exito:** Referencias remotas actualizadas sin errores

Paso 1.2: Listar Ramas Activas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Crear script de analisis
   git branch -r | grep -v 'main\|docs\|HEAD' > /tmp/ramas_activas.txt

**Criterio de Exito:** Lista de ramas generada

Paso 1.3: Analizar Cada Rama
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada rama en la lista:

.. code:: bash

   # Ver commits unicos
   git log <rama-base>..<rama-analizar> --oneline

   # Ver archivos modificados
   git diff --name-status <rama-base>...<rama-analizar>

   # Ver estadisticas
   git diff --stat <rama-base>...<rama-analizar>

**Documentar:** - Commits unicos - Archivos modificados - Lineas
agregadas/eliminadas - Ultima fecha de modificacion

Paso 1.4: Clasificar Ramas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Clasificar cada rama en: - **INTEGRADAS:** 0 commits unicos, 0 archivos
modificados - **CON CAMBIOS P1:** Cambios criticos (codigo funcional) -
**CON CAMBIOS P2:** Cambios importantes (documentacion, tests) - **CON
CAMBIOS P3:** Cambios menores (typos, README) - **EVALUAR:** Requiere
revision manual

Paso 1.5: Generar Reporte de Analisis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Crear documento en estructura:

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/
   ├── ANALISIS-RAMAS-YYYY-MM-DD.md
   └── (otros archivos se agregaran en siguientes pasos)

**Template:** Usar QA-ANALISIS-RAMAS-001 como referencia

**Contenido minimo:** - Inventario completo de ramas - Clasificacion por
estado - Metricas (commits unicos, archivos, lineas) - Recomendaciones
de consolidacion

**Artefacto:** ANALISIS-RAMAS-YYYY-MM-DD.md

--------------

ETAPA 2: PLANIFICACION (45 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 2.1: Priorizar Integraciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ordenar ramas con cambios por: 1. Criticidad (P1 > P2 > P3) 2. Impacto
(lineas de codigo) 3. Complejidad (conflictos esperados)

Paso 2.2: Identificar Dependencias
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Detectar: - Ramas que dependen de otras - Conflictos potenciales entre
ramas - Orden de integracion optimo

Paso 2.3: Definir Fases de Ejecucion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Organizar en fases: - **Fase 1:** Preparacion (backup, validacion) -
**Fase 2:** Integraciones criticas (P1) - **Fase 3:** Integraciones
secundarias (P2) - **Fase 4:** Integraciones menores (P3) - **Fase 5:**
Limpieza de ramas - **Fase 6:** Validacion final

Paso 2.4: Estimar Esfuerzo
^^^^^^^^^^^^^^^^^^^^^^^^^^

Por cada fase: - Tiempo estimado - Riesgos identificados - Estrategias
de mitigacion

Paso 2.5: Generar Plan de Consolidacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Crear documento:

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/PLAN-CONSOLIDACION-RAMAS-YYYY-MM-DD.md

**Contenido minimo:** - Objetivo y justificacion - Fases detalladas -
Cronograma - Matriz de riesgos - Criterios de validacion - Plan de
rollback

**Artefacto:** PLAN-CONSOLIDACION-RAMAS-YYYY-MM-DD.md

--------------

ETAPA 3: DESGLOSE EN TAREAS (30 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 3.1: Extraer Tareas del Plan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada fase, identificar tareas atomicas: - Una tarea = Una operacion
Git completa - Duracion maxima por tarea: 30 minutos - Dependencias
claras entre tareas

Paso 3.2: Crear Archivos de Tareas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada tarea, crear archivo:

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/TASK-NNN-descripcion.md

**Estructura de cada TASK:**

.. code:: markdown

   ---
   id: TASK-QA-RAMAS-NNN
   tipo: tarea
   fase: FASE_X
   prioridad: CRITICA|ALTA|MEDIA|BAJA
   duracion_estimada: Xmin
   dependencias: [TASK-NNN, ...]
                                

   # Objetivo
   # Prerequisitos
   # Pasos de Ejecucion (con comandos exactos)
   # Criterios de Exito
   # Validacion
   # Rollback
   # Evidencias a Capturar
   # Checklist

Paso 3.3: Vincular con Agentes (Opcional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si aplica, referenciar agentes del proyecto: -
automation_coherence_analyzer_agent - automation_schema_validator_agent
- documentation_consistency_verifier_agent

Paso 3.4: Actualizar INDICE.md
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Documentar todas las tareas creadas en:

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/INDICE.md

**Artefactos:** TASK-001.md a TASK-NNN.md + INDICE.md

--------------

ETAPA 4: APROBACION (15 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 4.1: Presentar Plan a Tech Lead
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  Compartir ANALISIS y PLAN
-  Revisar riesgos identificados
-  Confirmar cronograma

Paso 4.2: Obtener Aprobaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Firmas requeridas: - [ ] Tech Lead - [ ] Arquitecto (si hay cambios
arquitectonicos) - [ ] QA Lead (si afecta testing)

Paso 4.3: Notificar al Equipo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Comunicar: - Fecha y hora de ejecucion - Ramas que seran afectadas -
Tiempo estimado - Punto de contacto

--------------

ETAPA 5: EJECUCION (60-120 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 5.1: Crear Backup de Seguridad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   git tag -a backup-consolidacion-YYYY-MM-DD -m "Backup pre-consolidacion"
   git push origin backup-consolidacion-YYYY-MM-DD

**CRITICO:** No continuar sin backup exitoso

Paso 5.2: Ejecutar Tareas Secuencialmente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada TASK-NNN.md:

1. Leer tarea completa
2. Verificar prerequisitos
3. Ejecutar pasos documentados
4. Validar criterios de exito
5. Capturar evidencias
6. Marcar como completada
7. Continuar con siguiente tarea

**Reglas:** - NO saltar tareas - NO improvisar comandos - SI hay error:
aplicar rollback de la tarea - SI rollback falla: restaurar desde backup

Paso 5.3: Documentar Problemas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si surgen problemas: - Documentar en seccion “Problemas Encontrados” -
Incluir: descripcion, causa, solucion aplicada - Actualizar tiempo real
vs estimado

Paso 5.4: Validar Continuamente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tras cada fase: - Ejecutar git status (debe estar limpio) - Verificar
git log (commits esperados) - Correr tests (si hay suite de tests)

--------------

ETAPA 6: VALIDACION FINAL (30 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 6.1: Checklist de Validacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Todas las tareas marcadas como completadas
-  ☐ git status muestra working tree clean
-  ☐ Numero de ramas reducido segun objetivo
-  ☐ Rama consolidada tiene commits esperados
-  ☐ Tests base pasan (si aplica)
-  ☐ No hay archivos huerfanos en raiz

Paso 6.2: Validacion Tecnica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Contar ramas antes/despues
   git branch -r | grep -v 'main\|docs\|HEAD' | wc -l

   # Verificar integridad
   git fsck

   # Ver commits nuevos en rama consolidada
   git log --since="1 day ago" --oneline

Paso 6.3: Sincronizar con develop (si aplica)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   git checkout develop
   git merge <rama-consolidada> --no-ff
   git push origin develop

--------------

ETAPA 7: DOCUMENTACION (20 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Paso 7.1: Crear Reporte de Ejecucion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/REPORTE-EJECUCION-YYYY-MM-DD.md

**Contenido:** - Fecha y hora de ejecucion - Tareas completadas
(N/total) - Tiempo real vs estimado - Problemas encontrados y soluciones
- Metricas finales (ramas eliminadas, commits integrados) - Lecciones
aprendidas

Paso 7.2: Actualizar Lecciones Aprendidas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En PLAN-CONSOLIDACION-RAMAS-YYYY-MM-DD.md: - Seccion 9: Completar con
experiencias reales - Que funciono bien - Que no funciono - Mejoras para
proxima vez

Paso 7.3: Notificar Completacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Comunicar al equipo: - Consolidacion completada exitosamente - Ramas
eliminadas (lista) - Rama consolidada actualizada - Proxima
consolidacion programada

--------------

6. ARTEFACTOS GENERADOS
-----------------------

6.1 Carpeta Principal
~~~~~~~~~~~~~~~~~~~~~

::

   docs/gobernanza/qa/QA-ANALISIS-RAMAS-NNN/

Donde NNN = numero secuencial (001, 002, …)

6.2 Archivos Requeridos
~~~~~~~~~~~~~~~~~~~~~~~

====================================== ======== ======= ===========
Archivo                                Tipo     Cuando  Responsable
====================================== ======== ======= ===========
INDICE.md                              Indice   Inicio  Analista
ANALISIS-RAMAS-YYYY-MM-DD.md           Analisis Etapa 1 Analista
PLAN-CONSOLIDACION-RAMAS-YYYY-MM-DD.md Plan     Etapa 2 Analista
TASK-NNN-\*.md                         Tareas   Etapa 3 Analista
REPORTE-EJECUCION-YYYY-MM-DD.md        Reporte  Etapa 7 Ejecutor
====================================== ======== ======= ===========

6.3 Artefactos Git
~~~~~~~~~~~~~~~~~~

=================================== ========================
Artefacto                           Proposito
=================================== ========================
Tag backup-consolidacion-YYYY-MM-DD Punto de restauracion
Commits de merge                    Integraciones realizadas
Ramas eliminadas                    Documentadas en reporte
=================================== ========================

--------------

7. CRITERIOS DE EXITO
---------------------

7.1 Cuantitativos
~~~~~~~~~~~~~~~~~

-  ☐ Reduccion minima 50% en numero de ramas activas
-  ☐ Todas las tareas del plan completadas (100%)
-  ☐ 0 conflictos de merge sin resolver
-  ☐ Tiempo real dentro de +20% del estimado

7.2 Cualitativos
~~~~~~~~~~~~~~~~

-  ☐ Rama consolidada funcional y estable
-  ☐ Tests base pasando (si aplica)
-  ☐ Equipo notificado y satisfecho
-  ☐ Documentacion completa y clara

7.3 Metricas de Calidad
~~~~~~~~~~~~~~~~~~~~~~~

-  ☐ Tag de backup creado exitosamente
-  ☐ Working tree limpio (git status)
-  ☐ No archivos huerfanos en raiz
-  ☐ Lecciones aprendidas documentadas

--------------

8. RIESGOS Y MITIGACIONES
-------------------------

8.1 Riesgos Tecnicos
~~~~~~~~~~~~~~~~~~~~

+--------+--------------+---------+------------+---------------------+
| Riesgo | Probabilidad | Impacto | Mitigacion | Plan Contingencia   |
+========+==============+=========+============+=====================+
| Conf   | MEDIA        | ALTO    | Analisis   | Resolucion manual + |
| lictos |              |         | previo de  | backup              |
| de     |              |         | conflictos |                     |
| merge  |              |         |            |                     |
| com    |              |         |            |                     |
| plejos |              |         |            |                     |
+--------+--------------+---------+------------+---------------------+
| P      | BAJA         | CRITICO | Tag backup | Restaurar desde     |
| erdida |              |         | o          | backup              |
| de     |              |         | bligatorio |                     |
| t      |              |         |            |                     |
| rabajo |              |         |            |                     |
| por    |              |         |            |                     |
| error  |              |         |            |                     |
+--------+--------------+---------+------------+---------------------+
| Tests  | MEDIA        | MEDIO   | Validar    | Revertir            |
| fallan |              |         | tras cada  | integracion         |
| post   |              |         | fase       | problematica        |
| -integ |              |         |            |                     |
| racion |              |         |            |                     |
+--------+--------------+---------+------------+---------------------+
| Falta  | MEDIA        | BAJO    | Buffer 20% | Completar en        |
| tiempo |              |         | adicional  | siguiente sesion    |
| es     |              |         |            |                     |
| timado |              |         |            |                     |
+--------+--------------+---------+------------+---------------------+

8.2 Riesgos Organizacionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+-------------+---------------------+--------------+------------------+
| Riesgo      | Probabilidad        | Impacto      | Mitigacion       |
+=============+=====================+==============+==================+
| Falta       | BAJA                | ALTO         | Involucrar desde |
| aprobacion  |                     |              | analisis         |
| de          |                     |              |                  |
| s           |                     |              |                  |
| takeholders |                     |              |                  |
+-------------+---------------------+--------------+------------------+
| Trabajo     | MEDIA               | ALTO         | Validar con      |
| activo en   |                     |              | equipo antes     |
| ramas a     |                     |              |                  |
| eliminar    |                     |              |                  |
+-------------+---------------------+--------------+------------------+
| I           | BAJA                | MEDIO        | Bloque de tiempo |
| nterrupcion |                     |              | reservado        |
| durante     |                     |              |                  |
| ejecucion   |                     |              |                  |
+-------------+---------------------+--------------+------------------+

--------------

9. MEJORES PRACTICAS
--------------------

9.1 Antes de Ejecutar
~~~~~~~~~~~~~~~~~~~~~

1. Ejecutar en horario de baja actividad
2. Notificar con 24h de anticipacion
3. Revisar PRs abiertos
4. Confirmar que tests base pasan

9.2 Durante Ejecucion
~~~~~~~~~~~~~~~~~~~~~

1. NO improvisar comandos Git
2. Seguir tareas secuencialmente
3. Validar tras cada fase
4. Documentar problemas inmediatamente

9.3 Despues de Ejecutar
~~~~~~~~~~~~~~~~~~~~~~~

1. Mantener tag de backup 30 dias
2. Compartir lecciones aprendidas
3. Actualizar este procedimiento si necesario
4. Programar proxima consolidacion

--------------

10. HERRAMIENTAS Y REFERENCIAS
------------------------------

10.1 Herramientas Requeridas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Git 2.x+
-  Bash shell
-  Editor de texto (Markdown)
-  pytest (opcional, para tests)

10.2 Templates de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  QA-ANALISIS-RAMAS-001 (ejemplo completo)
-  PLAN-CONSOLIDACION-RAMAS-2025-11-17.md
-  TASK-001-crear-backup-seguridad.md

10.3 Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  PROCED-GOB-002: Actualizar documentacion
-  PROCED-GOB-005: Analisis de impacto de cambios
-  docs/gobernanza/metodologias/: Metodologias SDLC

10.4 Comandos Git Utiles
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver ramas no mergeadas
   git branch -r --no-merged main

   # Ver ramas mergeadas
   git branch -r --merged main

   # Eliminar rama remota
   git push origin --delete <rama>

   # Restaurar desde backup
   git reset --hard backup-consolidacion-YYYY-MM-DD

--------------

11. CONTROL DE CAMBIOS
----------------------

Version 1.0.0 (2025-11-17)
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Creacion inicial del procedimiento
-  Basado en ejecucion exitosa de QA-ANALISIS-RAMAS-001
-  7 etapas definidas
-  14 tareas ejemplo documentadas

Proximas Versiones
~~~~~~~~~~~~~~~~~~

-  v1.1.0: Incorporar lecciones aprendidas de segunda ejecucion
-  v1.2.0: Automatizar pasos repetitivos con scripts
-  v2.0.0: Integracion con CI/CD para validacion automatica

--------------

12. APROBACIONES
----------------

=============== =========== ================ ==========
Rol             Nombre      Firma            Fecha
=============== =========== ================ ==========
Autor           Claude Code \_\_\_\_\_\_\_\_ 2025-11-17
Revisor Tecnico [Pendiente] \_\_\_\_\_\_\_\_ YYYY-MM-DD
Aprobador       Tech Lead   \_\_\_\_\_\_\_\_ YYYY-MM-DD
=============== =========== ================ ==========

--------------

13. ANEXOS
----------

Anexo A: Ejemplo de Ejecucion Exitosa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ver: docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/

**Resultado:** - 17 ramas analizadas - 12 ramas eliminadas (70%
reduccion) - 5,500 lineas de codigo integradas - 2h 20min tiempo total -
0 conflictos criticos

Anexo B: Checklist Rapido
~~~~~~~~~~~~~~~~~~~~~~~~~

**Pre-Ejecucion:** - [ ] Fetch actualizado - [ ] Lista de ramas generada
- [ ] Analisis completado - [ ] Plan aprobado - [ ] Equipo notificado

**Ejecucion:** - [ ] Backup creado - [ ] Tareas ejecutadas
secuencialmente - [ ] Validacion tras cada fase - [ ] Problemas
documentados

**Post-Ejecucion:** - [ ] Validacion final OK - [ ] Reporte creado - [ ]
Equipo notificado - [ ] Proxima consolidacion programada

--------------

**Procedimiento creado:** 2025-11-17 **Ultima revision:** 2025-11-17
**Proxima revision programada:** 2026-02-17 (3 meses) **Estado:** ACTIVO
**Version:** 1.0.0
