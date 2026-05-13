PROCED-GOB-009: Procedimiento para Refactorizaciones de Código con TDD
======================================================================

1. Propósito
------------

Establecer un proceso estandarizado para ejecutar refactorizaciones de
código usando metodologia Test-Driven Development (TDD), garantizando
zero regresiones funcionales y manteniendo calidad del código.

2. Alcance
----------

**Aplica a:** - Refactorizaciones de calidad (mejoras sin cambio
funcional) - Modernizacion de sintaxis (PEP 585, ES6+, etc.) -
Extraccion de constantes y eliminacion de magic numbers - Reorganizacion
de código sin cambio de comportamiento

**NO aplica a:** - Nuevas funcionalidades (usar proceso de desarrollo
normal) - Cambios breaking que modifican APIs publicas - Hotfixes
urgentes de produccion

3. Roles y Responsabilidades
----------------------------

**Desarrollador/Agente:** - Ejecutar el procedimiento completo - Generar
evidencias en cada fase - Ejecutar rollback si es necesario

**Tech Lead:** - Aprobar refactorizaciones propuestas - Revisar analisis
de impacto

**QA:** - Validar que tests pasan - Verificar evidencias completas

4. Prerequisitos
----------------

Antes de iniciar refactorización: - [ ] Tests automatizados existen (o
crear smoke tests basicos) - [ ] Rama de desarrollo limpia y actualizada
- [ ] Version de runtime compatible (Python 3.9+, Node 16+, etc.) - [ ]
Backup strategy definida (tag o branch) - [ ] Commits identificados con
cambios a aplicar

4.1. Estrategia para Versiones Multiples
----------------------------------------

Cuando existan refactorizaciones del mismo tipo en multiples
commits/versiones, seguir esta matriz de decision:

Matriz de Decision
~~~~~~~~~~~~~~~~~~

+--------------------+--------------------+----------------------------+
| Escenario          | Estrategia         | Justificacion              |
+====================+====================+============================+
| Versiones          | Aplicar solo la    | Evita duplicacion, usa     |
| identicas (mismo   | mas reciente       | version mas validada       |
| diff)              |                    |                            |
+--------------------+--------------------+----------------------------+
| Versiones          | Aplicar ambas      | Acumula mejoras, valida    |
| compatibles (no    | secuencialmente    | cada una con TDD           |
| conflicto)         |                    |                            |
+--------------------+--------------------+----------------------------+
| Versiones en       | Analisis manual +  | Requiere juicio tecnico,   |
| conflicto (mismo   | elegir mejor       | documentar decision        |
| codigo)            |                    |                            |
+--------------------+--------------------+----------------------------+
| Versiones          | Aplicar solo       | Eficiencia, version final  |
| incrementales (v1  | version final      | incluye mejoras previas    |
| < v2 < v3)         |                    |                            |
+--------------------+--------------------+----------------------------+

Proceso de Resolucion
~~~~~~~~~~~~~~~~~~~~~

**Paso 1: Identificacion**

.. code:: bash

   # Comparar diffs entre commits
   git show <commit-1> -- archivo.py > /tmp/diff1.txt
   git show <commit-2> -- archivo.py > /tmp/diff2.txt
   diff /tmp/diff1.txt /tmp/diff2.txt

**Paso 2: Clasificacion** - Identicos: diff vacio - Compatibles: diff
muestra cambios en lineas diferentes - Conflicto: diff muestra cambios
en mismas lineas - Incrementales: version posterior incluye cambios de
anterior

**Paso 3: Decision Documentada**

.. code:: markdown

   ## Decision sobre Versiones Multiples

   **Commits analizados:**
   - abc1234: [descripcion]
   - def5678: [descripcion]

   **Clasificacion:** [Identicos|Compatibles|Conflicto|Incrementales]

   **Decision:** Aplicar [commit elegido] porque [justificacion]

   **Descartados:** [commits no aplicados] porque [razon]

**Paso 4: Validacion** - Aplicar commit elegido - Ejecutar TDD completo
(RED-REFACTOR-GREEN-VALIDATE) - Documentar en analisis por que se
descartaron otros

Ejemplo Real (QA-REFACTOR-MCP-002)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Situacion:** 2 commits con extraccion constante PLAYWRIGHT_MCP_VERSION
- Commit 0d1e1f2 (origin/copilot/sub-pr-216-another-one) - Commit [otro]
(origin/copilot/sub-pr-216)

**Decision:** Aplicar 0d1e1f2 porque es version mas reciente y validada

**Documentacion:** En ANALISIS-REFACTORIZACIONES-YYYY-MM-DD.md seccion
“Refactorizaciones Pendientes”

5. Fases del Procedimiento
--------------------------

FASE 1: ANALISIS (60-90 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Entender cambios y crear plan ejecutable

**Pasos:** 1. Identificar commits con refactorizaciones deseadas 2.
Analizar impacto: - Archivos afectados - Líneas modificadas - Tipo de
cambios (imports, tipos, valores) - Riesgos potenciales 3. Crear
documento ANALISIS-REFACTORIZACIONES-YYYY-MM-DD.md con: - Estado actual
del código - Refactorizaciones pendientes (detalle por commit) -
Analisis de compatibilidad - Matriz de riesgos - Métricas (lineas,
archivos, tiempo estimado) 4. Ubicar en:
docs/ai/refactorizaciones/QA-REFACTOR-XXX-NNN/

**Salidas:** - Documento de analisis completo - Identificacion clara de
cambios - Matriz de riesgos documentada

FASE 2: PLANIFICACION (60-90 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Crear plan ejecutable con metodologia TDD

**Pasos:** 1. Definir fases del plan (tipicamente 5): - Preparacion -
Refactorizacion(es) con TDD - Validacion final - Commit y push 2. Crear
PLAN-INTEGRACION-REFACTORIZACIONES-YYYY-MM-DD.md con: - Metodologia TDD
explicita - Fases y tareas detalladas - Matriz RACI - Dependencias entre
tareas - Estrategia de rollback - Criterios de exito 3. Desglosar en
tareas individuales (formato TASK-NNN) 4. Cada tarea debe incluir: -
Tipo TDD: preparacion|red|refactor|green|validate|commit - Prerequisitos
- Pasos de ejecucion con comandos bash exactos - Criterios de exito
medibles - Validaciones especificas - Rollback documentado - Evidencias
requeridas

**Salidas:** - Plan completo con 10-20 tareas - Todas las tareas en
carpetas individuales con evidencias/ - Tiempo estimado total

FASE 2.5: CREACION DE TAREAS (60-120 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Crear documentacion detallada de cada tarea con comandos
ejecutables

**Estrategia:** Usar agentes especializados en paralelo (4 agentes
simultaneos)

**Pasos:** 1. Dividir tareas en 4 grupos balanceados 2. Lanzar 4 agentes
en paralelo usando Task tool 3. Cada agente crea 3-5 tareas con
estructura completa 4. Validar que todas las tareas tengan estructura
consistente 5. Crear INDICE.md con resumen de todas las tareas

**Estructura por tarea (README.md de 200-400 lineas):**

.. code:: markdown

   ---
   id: TASK-NNN
   tipo: [preparacion|red|refactor|green|validate|commit]
   fase: [1-7]
   prerequisitos: [TASK-MMM, ...]
   estimacion: [5-30] minutos
   prioridad: [alta|media|baja]
                               

   # TASK-NNN: [Titulo Descriptivo]

   ## 1. Objetivo

   [Descripcion clara de que se va a lograr]

   ## 2. Prerequisitos

   - [ ] TASK-MMM completada exitosamente
   - [ ] [Otros prerequisitos tecnicos]

   ## 3. Comandos de Ejecucion

   ### Paso 1: [Nombre del paso]

   bash
   cd /ruta/absoluta/proyecto
   comando --flags argumentos


   ### Paso 2: [Siguiente paso]

   bash
   otro-comando --opcion valor


   ## 4. Criterios de Exito

   - [ ] [Criterio medible 1]
   - [ ] [Criterio medible 2]
   - [ ] [Criterio medible 3]

   ## 5. Validaciones

   bash
   # Validacion 1
   comando-validacion | grep "expected output"

   # Validacion 2
   test-command --verify


   ## 6. Evidencias Requeridas

   - evidencias/nombre-archivo.log (captura de comando X)
   - evidencias/resultado-validacion.txt (salida de validacion Y)

   ## 7. Rollback en Caso de Fallo

   bash
   # Si falla este paso, ejecutar:
   git reset --hard HEAD
   # o
   git revert <commit-hash>


   ## 8. Notas Adicionales

   [Observaciones importantes, advertencias, contexto adicional]

**Tiempo estimado:** - Preparacion de agentes: 5-10 min - Ejecucion
paralela (4 agentes): 40-80 min - Validacion y ajustes: 15-30 min -
Total: 60-120 min

**Salidas:** - 10-20 carpetas TASK-NNN-nombre/ con README.md completo -
Cada tarea lista para ejecutar sin ambiguedad - INDICE.md con navegacion
rapida

FASE 3: PREPARACION (10-20 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Crear backup y validar estado inicial

**Tareas tipicas:** 1. TASK-001: Crear backup de seguridad (tag o branch
local) 2. TASK-002: Verificar tests existentes y documentar baseline 3.
TASK-003: Validar entorno (version runtime, dependencias)

**Criterios de exito:** - Backup creado exitosamente - Tests baseline
documentados (N tests passing) - Entorno compatible validado

FASE 4: REFACTORIZACION CON TDD (40-60 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Aplicar refactorizaciones usando ciclo TDD estricto

Para CADA refactorización:

**TASK-NNN: [TDD-RED] Ejecutar Tests Pre-Refactorizacion**

.. code:: bash

   pytest <modulo> -v > evidencias/baseline-pre-refactor.log

-  Establecer baseline de tests (cuantos pasan)
-  Documentar estado actual del código
-  Guardar snapshot del archivo si es necesario

**TASK-NNN+1: [TDD-REFACTOR] Aplicar Refactorizacion**

.. code:: bash

   git cherry-pick <commit-hash>
   # o aplicacion manual si hay conflictos

-  Aplicar cambios de refactorizacion
-  Resolver conflictos si existen
-  Validar sintaxis basica

**TASK-NNN+2: [TDD-GREEN] Validar Tests Post-Refactorizacion**

.. code:: bash

   pytest <modulo> -v > evidencias/tests-post-refactor.log
   diff evidencias/baseline-pre-refactor.log evidencias/tests-post-refactor.log

-  CRITERIO CRITICO: Mismo numero de tests pasando
-  Si tests fallan: ROLLBACK INMEDIATO
-  Comparar con baseline

**TASK-NNN+3: [TDD-VALIDATE] Validaciones Adicionales** - Type checking
(mypy, pyright, tsc) - Smoke tests funcionales - Import checks -
Validaciones especificas del cambio

**Criterios para continuar:** - Tests: 100% passing (mismo que baseline)
- Validaciones: PASS - Sin regresiones detectadas

**Criterios para ROLLBACK:** - Cualquier test que fallo - Errores de
sintaxis o imports - Regresion funcional detectada

FASE 5: VALIDACION FINAL (15-25 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Validacion integral del sistema

**Tareas tipicas:** 1. TASK-NNN: Ejecutar suite COMPLETA de tests (no
solo modulo) 2. TASK-NNN+1: Validar imports y sintaxis de todos archivos
3. TASK-NNN+2: Documentar cambios en evidencias consolidadas

**Criterios de exito:** - Suite completa: 100% passing - 0 errores
sintaxis - Evidencias consolidadas creadas

FASE 6: COMMIT Y PUSH (5-10 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Objetivo:** Persistir cambios en repositorio

**Tareas:** 1. TASK-NNN: Commit con mensaje descriptivo \```bash git
commit -m “refactor:

-  Cambio 1 (commit original: abc1234)
-  Cambio 2 (commit original: def5678)
-  Validado con TDD (N tests passing)
-  Zero regresiones funcionales”

::

   2. TASK-NNN+1: Push a rama remota con retry logic

   **Criterios de exito:**
   - Commit creado con mensaje convencional
   - Push exitoso
   - Rama remota actualizada

   ### FASE 7: SINCRONIZACION CON MAIN (5-15 min)

   **Objetivo:** Sincronizar rama de desarrollo con rama principal para evitar conflictos futuros

   **Cuándo ejecutar:** Despues de push exitoso, especialmente si el trabajo tomo varios dias

   **Tareas:**
   1. TASK-NNN: Fetch y merge de rama principal (develop o main)
   2. TASK-NNN+1: Resolver conflictos si existen
   3. TASK-NNN+2: Re-ejecutar suite de tests post-merge
   4. TASK-NNN+3: Push de rama sincronizada

   **Comandos:**
   ```bash
   # Paso 1: Fetch rama principal
   git fetch origin develop

   # Paso 2: Merge con estrategia
   git merge origin/develop --no-ff -m "sync: merge develop into feature branch"

   # Paso 3: Si hay conflictos, resolverlos manualmente
   # git status
   # git add <archivos-resueltos>
   # git merge --continue

   # Paso 4: Validar tests post-merge
   pytest tests/ -v

   # Paso 5: Push sincronizado
   git push -u origin <rama-feature>

**Criterios de exito:** - Merge exitoso sin conflictos, o conflictos
resueltos correctamente - Tests: 100% passing post-merge - Rama feature
actualizada con ultimos cambios de main - Push exitoso de rama
sincronizada

**Criterios para SKIP:** - Rama main no ha cambiado desde que inicio el
trabajo - Trabajo completo en menos de 2 horas (bajo riesgo de
desincronizacion) - No hay otros desarrolladores trabajando en paralelo

**Rollback si falla:**

.. code:: bash

   # Si merge falla o tests fallan post-merge
   git merge --abort  # Si aun en proceso de merge

   # O si ya se commiteo el merge problematico
   git reset --hard HEAD~1  # Volver a estado pre-merge
   git push -f origin <rama-feature>  # Force push solo si necesario

**Notas importantes:** - Esta fase previene “integration hell” al
sincronizar tempranamente - Si hay conflictos complejos, considerar
re-aplicar refactorizaciones sobre develop actualizado - Documentar
resolucion de conflictos en evidencias/sync-conflicts-resolution.md

6. Metodologia TDD
------------------

Ciclo TDD para Refactorizaciones:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   1. RED (Baseline)
      ├── Ejecutar tests existentes
      ├── Documentar cuantos pasan (N tests)
      └── Guardar estado actual

   2. REFACTOR (Cambio)
      ├── Aplicar refactorizacion
      ├── Resolver conflictos
      └── Validar sintaxis basica

   3. GREEN (Validacion)
      ├── Ejecutar tests nuevamente
      ├── Comparar con baseline
      └── MISMO numero de tests pasando (CRITICO)

   4. VALIDATE (Adicional)
      ├── Type checking
      ├── Smoke tests
      └── Validaciones especificas

   5. Decision
      ├── Si TODO OK → Continuar
      └── Si FALLO → ROLLBACK INMEDIATO

Principios TDD Aplicados:
~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Tests primero:** Siempre verificar baseline antes de cambiar
2. **Cambios incrementales:** Una refactorización a la vez
3. **Validacion continua:** Tests despues de cada cambio
4. **Rollback rapido:** No continuar si tests fallan
5. **Evidencias obligatorias:** Cada paso documentado

6.1. Ejemplos de Smoke Tests
----------------------------

Los smoke tests son validaciones rapidas funcionales que complementan
los tests automatizados.

Smoke Tests para Refactorizaciones Python
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**1. Validacion de Imports**

.. code:: bash

   # Test: Todos los imports funcionan
   python -c "from scripts.coding.ai.mcp.registry import MCPRegistry; print('OK')"

   # Test: Modulo se importa sin errores
   python -m scripts.coding.ai.mcp.registry --help 2>&1 | grep -q "usage" && echo "PASS" || echo "FAIL"

**2. Validacion de Sintaxis Basica**

.. code:: bash

   # Compilar modulo para detectar errores sintaxis
   python -m py_compile scripts/coding/ai/mcp/registry.py
   echo $?  # Debe ser 0

**3. Smoke Test Funcional Basico**

.. code:: bash

   # Test: Funcion principal ejecuta sin crash
   python -c "
   from scripts.coding.ai.mcp.registry import MCPRegistry
   registry = MCPRegistry()
   assert registry is not None
   print('Smoke test: PASS')
                            

**4. Type Checking Incremental**

.. code:: bash

   # Solo archivo modificado, no todo el proyecto
   mypy scripts/coding/ai/mcp/registry.py --strict
   # o
   pyright scripts/coding/ai/mcp/registry.py

Smoke Tests para Refactorizaciones JavaScript/TypeScript
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**1. Validacion de Sintaxis**

.. code:: bash

   # TypeScript: Compilar sin ejecutar
   tsc --noEmit src/registry.ts

   # JavaScript: Validar con ESLint
   eslint src/registry.js --max-warnings 0

**2. Smoke Test de Imports**

.. code:: bash

   # Node.js: Cargar modulo sin ejecutar
   node -e "require('./src/registry'); console.log('PASS')"

   # ES Modules
   node --input-type=module -e "import './src/registry.js'; console.log('PASS')"

**3. Validacion de Build**

.. code:: bash

   # Build del proyecto sin publicar
   npm run build

   # Verificar salida existe
   test -f dist/registry.js && echo "PASS" || echo "FAIL"

Smoke Tests Generales
~~~~~~~~~~~~~~~~~~~~~

**1. Git Diff Validation**

.. code:: bash

   # Verificar que solo archivos esperados cambiaron
   git diff --name-only HEAD~1 HEAD | wc -l
   # Debe ser numero esperado de archivos (ej: 1)

   # Verificar que cambios son del tipo esperado
   git diff HEAD~1 HEAD | grep "^+" | grep -v "^+++" | head -5

**2. Line Count Validation**

.. code:: bash

   # Verificar que numero de lineas cambio segun esperado
   # Ejemplo: PEP 585 debe reducir imports
   wc -l scripts/coding/ai/mcp/registry.py
   # Comparar con valor esperado

**3. Dependency Validation**

.. code:: bash

   # Python: Verificar que no se agregaron dependencias nuevas
   pip freeze | wc -l  # Debe ser igual que antes

   # JavaScript: Verificar package.json sin cambios
   git diff package.json | wc -l  # Debe ser 0

Cuándo Usar Smoke Tests
~~~~~~~~~~~~~~~~~~~~~~~

**Usar smoke tests cuando:** - Tests automatizados no existen - Tests
automatizados tardan mucho (>5 min) - Refactorizacion es muy simple
(bajo riesgo) - Necesitas validacion rapida antes de tests completos

**NO reemplazar tests automatizados:** - Smoke tests son
complementarios, no sustitutos - Siempre ejecutar suite completa en
validacion final - Tests automatizados tienen mayor cobertura

Ejemplo de Secuencia Completa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Paso 1: Smoke test pre-refactorizacion
   python -c "from module import Foo; print('Baseline OK')"

   # Paso 2: Aplicar refactorizacion
   git cherry-pick abc1234

   # Paso 3: Smoke tests post-refactorizacion
   python -m py_compile module.py                    # Sintaxis OK
   python -c "from module import Foo; print('OK')"   # Imports OK
   mypy module.py --strict                           # Types OK

   # Paso 4: Tests automatizados completos
   pytest tests/test_module.py -v

   # Paso 5: Si todo OK, continuar. Si falla, rollback

7. Gestion de Evidencias
------------------------

Estructura de Evidencias:
~~~~~~~~~~~~~~~~~~~~~~~~~

::

   QA-REFACTOR-XXX-NNN/
   ├── ANALISIS-REFACTORIZACIONES-YYYY-MM-DD.md
   ├── PLAN-INTEGRACION-REFACTORIZACIONES-YYYY-MM-DD.md
   ├── INDICE.md
   ├── TASK-001-nombre/
   │   ├── TASK-001-nombre.md
   │   └── evidencias/
   │       ├── backup-tag-created.log
   │       └── commit-hash.txt
   ├── TASK-002-nombre/
   │   └── evidencias/
   │       ├── baseline-tests.log
   │       └── test-count.txt
   └── ...

Evidencias Requeridas por Fase:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Preparacion:** - backup-tag-created.log - baseline-tests.log -
python-version.txt

**Refactorizacion (por cada una):** - baseline-pre-refactor.log -
refactor-applied.log - tests-post-refactor.log - validation-results.log

**Validacion Final:** - suite-completa-tests.log - import-validation.log
- CONSOLIDADO-EVIDENCIAS.md

**Commit/Push:** - commit-message.txt - commit-hash.txt -
push-result.log

8. Estrategia de Rollback
-------------------------

Rollback por Fase:
~~~~~~~~~~~~~~~~~~

**Si falla PREPARACION:**

.. code:: bash

   # Eliminar tag/branch de backup si existe
   git tag -d backup-refactor-YYYY-MM-DD
   # o
   git branch -d backup-refactor-YYYY-MM-DD

**Si falla REFACTORIZACION:**

.. code:: bash

   # Opcion 1: Revert del commit
   git revert <commit-hash>

   # Opcion 2: Reset hard a backup
   git reset --hard backup-refactor-YYYY-MM-DD

   # Opcion 3: Cherry-pick inverso
   git cherry-pick --abort  # si en progreso

**Si falla VALIDACION FINAL:**

.. code:: bash

   # Reset a backup completo
   git reset --hard backup-refactor-YYYY-MM-DD

   # Limpiar working directory
   git clean -fd

Criterios para Ejecutar Rollback:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  **INMEDIATO:** Tests fallan despues de refactorizacion
-  **INMEDIATO:** Errores de sintaxis o imports
-  **INMEDIATO:** Regresion funcional detectada
-  **EVALUACION:** Type checker reporta nuevos errores (puede ser falso
   positivo)

9. Riesgos Comunes y Mitigaciones
---------------------------------

+-------+------------+--------+------------------+--------------------+
| R     | Pr         | I      | Mitigacion       | Mitigacion         |
| iesgo | obabilidad | mpacto | Primaria         | Secundaria         |
+=======+============+========+==================+====================+
| Tests | MEDIA      | MEDIO  | Crear smoke      | Validacion manual  |
| no    |            |        | tests basicos    | exhaustiva         |
| ex    |            |        |                  |                    |
| isten |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+
| Ru    | BAJA       | ALTO   | Validar version  | ABORTAR si         |
| ntime |            |        | temprano         | incompatible       |
| in    |            |        |                  |                    |
| compa |            |        |                  |                    |
| tible |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+
| Confl | MEDIA      | MEDIO  | Aplicacion       | Documentar         |
| ictos |            |        | manual con diff  | resolucion         |
| c     |            |        |                  |                    |
| herry |            |        |                  |                    |
| -pick |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+
| Tests | BAJA       | ALTO   | Rollback         | Analizar causa y   |
| f     |            |        | inmediato        | reintentar         |
| allan |            |        |                  |                    |
| pos   |            |        |                  |                    |
| t-ref |            |        |                  |                    |
| actor |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+
| Regr  | BAJA       | ALTO   | Suite completa + | Code review        |
| esion |            |        | smoke tests      | adicional          |
| no    |            |        |                  |                    |
| dete  |            |        |                  |                    |
| ctada |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+
| Type  | MEDIA      | BAJO   | Validacion       | Actualizar         |
| ch    |            |        | manual           | configuracion      |
| ecker |            |        |                  |                    |
| f     |            |        |                  |                    |
| alsos |            |        |                  |                    |
| posi  |            |        |                  |                    |
| tivos |            |        |                  |                    |
+-------+------------+--------+------------------+--------------------+

10. Criterios de Exito
----------------------

Una refactorización es exitosa cuando:

**Tecnicos:** - [ ] Todas las refactorizaciones aplicadas sin conflictos
- [ ] 100% tests passing (mismo que baseline o mejor) - [ ] 0
regresiones funcionales - [ ] Type checking: 0 errores nuevos - [ ]
Sintaxis e imports: validados OK

**Proceso:** - [ ] Metodologia TDD seguida estrictamente - [ ]
Evidencias completas en todas las tareas - [ ] Rollback strategy
ejecutable probada - [ ] Cada fase cumple criterios de salida

**Persistencia:** - [ ] Cambios commiteados con mensaje descriptivo - [
] Commit pusheado a rama remota - [ ] Documentacion actualizada si
necesario

11. Métricas y Reporting
------------------------

Métricas a Capturar:
~~~~~~~~~~~~~~~~~~~~

**Código:** - Archivos afectados - Líneas modificadas - Commits
aplicados - Tipo de cambios

**Tests:** - Tests baseline - Tests post-refactor - Delta
(mejora/regresion) - Tiempo de ejecucion

**Tiempo:** - Tiempo estimado vs real - Tiempo por fase - Tiempo total

**Calidad:** - Riesgos identificados - Riesgos materializados -
Rollbacks ejecutados

Documento de Cierre:
~~~~~~~~~~~~~~~~~~~~

Al finalizar, crear CONSOLIDADO-EVIDENCIAS.md con: - Resumen ejecutivo -
Refactorizaciones aplicadas - Estado final de tests - Problemas
encontrados y resoluciones - Métricas completas - Lecciones aprendidas

12. Frecuencia de Uso
---------------------

**Ad-hoc:** Cuando se requiera refactorizar código

**Triggers comunes:** - Actualizacion de version de runtime (Python 3.9
→ 3.11) - Adopcion de nuevos estandares (PEP 585, ES2022) - Code review
detecta magic numbers o code smells - Consolidacion de trabajo de
multiples ramas - Mejora de mantenibilidad identificada

13. Herramientas Recomendadas
-----------------------------

**Testing:** - pytest (Python) - jest/vitest (JavaScript) - unittest
(Python stdlib)

**Type Checking:** - mypy (Python) - pyright (Python) - tsc (TypeScript)

**Validacion:** - python -m py_compile (syntax) - eslint (JavaScript) -
ruff/flake8 (Python linting)

**Git:** - git cherry-pick (aplicar commits) - git revert (rollback) -
git tag (backup)

13.1. Conventional Commits
--------------------------

Todos los commits de refactorizacion deben seguir el formato de
Conventional Commits.

Formato Basico
~~~~~~~~~~~~~~

::

   <tipo>(<scope>): <descripcion corta>

   [cuerpo opcional con detalles]

   [footer opcional con metadata]

Tipos de Commit para Refactorizaciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**refactor:** Cambios de codigo que no modifican comportamiento

.. code:: bash

   git commit -m "refactor(mcp): modernizar type annotations a PEP 585

   - Cambiar Dict[str, str] a dict[str, str]
   - Cambiar Mapping[str, Any] a dict[str, Any]
   - Eliminar imports innecesarios de typing
   - Validado con TDD (13/13 tests passing)
   - Zero regresiones funcionales

   Commit original: 2ca3d25
   Refs: QA-REFACTOR-MCP-002"

**style:** Cambios de formato (no afectan codigo ejecutable)

.. code:: bash

   git commit -m "style(registry): aplicar formateo black"

**chore:** Cambios de mantenimiento (dependencias, configuracion)

.. code:: bash

   git commit -m "chore(deps): actualizar playwright MCP version

   - Extraer version a constante PLAYWRIGHT_MCP_VERSION = 0.0.40
   - Mejor mantenibilidad y documentacion de pinning

   Commit original: 0d1e1f2"

**docs:** Solo cambios de documentacion

.. code:: bash

   git commit -m "docs(refactor): documentar procedimiento TDD en PROCED-GOB-009"

Estructura de Mensaje para Refactorizaciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Linea 1 (Subject):** Max 72 caracteres

::

   refactor(scope): descripcion imperativa presente

**Cuerpo (Body):** Detalles de cambios

::

   - Lista de cambios aplicados (bullet points)
   - Resultado de validacion TDD
   - Zero regresiones funcionales
   - Metricas relevantes (tests passing, lineas modificadas)

**Footer:** Metadata adicional

::

   Commit original: <hash>
   Refs: <ID-documento>
   Co-authored-by: <nombre>

Ejemplos Completos
~~~~~~~~~~~~~~~~~~

**Ejemplo 1: Refactorizacion Simple**

.. code:: bash

   git commit -m "$(cat <<'EOF'
   refactor(mcp): extraer constante PLAYWRIGHT_MCP_VERSION

   - Agregar constante PLAYWRIGHT_MCP_VERSION = "0.0.40"
   - Reemplazar hardcoded version en install command
   - Mejor mantenibilidad y documentacion de pinning
   - Validado con TDD (13/13 tests passing)
   - Zero regresiones funcionales

   Commit original: 0d1e1f2
   Refs: QA-REFACTOR-MCP-002
   EOF
   )"

**Ejemplo 2: Refactorizacion Multiple**

.. code:: bash

   git commit -m "$(cat <<'EOF'
   refactor(mcp): integrar 2 mejoras de calidad del MCP registry

   - Extraer PLAYWRIGHT_MCP_VERSION constant (commit: 0d1e1f2)
   - Modernizar type annotations a PEP 585 (commit: 2ca3d25)
   - 11 lineas modernizadas, 1 import eliminado
   - Validado con TDD metodologia estricta
   - Suite completa: 13/13 tests passing (+3 vs baseline)
   - Zero regresiones funcionales

   Commits originales:
   - 0d1e1f2: Playwright constant extraction
   - 2ca3d25: PEP 585 type annotations

   Refs: QA-REFACTOR-MCP-002
   Tiempo total: 180 minutos (16 tareas TDD)
   EOF
   )"

**Ejemplo 3: Refactorizacion con Sincronizacion**

.. code:: bash

   git commit -m "$(cat <<'EOF'
   sync: merge develop into feature branch

   Sincronizar refactorizaciones MCP con ultimos cambios de develop.

   - 0 conflictos
   - Tests: 13/13 passing post-merge
   - Rama actualizada para PR

   Refs: QA-REFACTOR-MCP-002/TASK-017
   EOF
   )"

Scopes Comunes
~~~~~~~~~~~~~~

-  ``mcp``: Model Context Protocol
-  ``registry``: Registros y catalogos
-  ``api``: APIs y endpoints
-  ``tests``: Suite de tests
-  ``deps``: Dependencias
-  ``config``: Configuracion
-  ``scripts``: Scripts de automatizacion
-  ``docs``: Documentacion

Validacion de Mensaje
~~~~~~~~~~~~~~~~~~~~~

**Herramienta:** commitlint (opcional)

.. code:: bash

   # Instalar commitlint
   npm install -g @commitlint/cli @commitlint/config-conventional

   # Validar mensaje
   echo "refactor(mcp): test message" | commitlint

**Validacion manual:**

.. code:: bash

   # Checklist:
   # - [ ] Tipo valido (refactor, style, chore, docs)
   # - [ ] Scope presente y descriptivo
   # - [ ] Descripcion en imperativo presente (max 72 chars)
   # - [ ] Cuerpo con detalles de cambios
   # - [ ] Footer con commit original y refs
   # - [ ] Menciona validacion TDD
   # - [ ] Menciona zero regresiones

Referencias
~~~~~~~~~~~

-  Conventional Commits: https://www.conventionalcommits.org/
-  Angular Convention:
   https://github.com/angular/angular/blob/main/CONTRIBUTING.md
-  Commitlint: https://commitlint.js.org/

14. Plantillas de Referencia
----------------------------

**Analisis:**
docs/ai/refactorizaciones/QA-REFACTOR-MCP-002/ANALISIS-REFACTORIZACIONES-2025-11-17.md

**Plan:**
docs/ai/refactorizaciones/QA-REFACTOR-MCP-002/PLAN-INTEGRACION-REFACTORIZACIONES-2025-11-17.md

**Tareas:** docs/ai/refactorizaciones/QA-REFACTOR-MCP-002/TASK-NNN-\*/

15. Historial de Cambios
------------------------

+------------------------+-------------------+------------------------+
| Version                | Fecha             | Cambios                |
+========================+===================+========================+
| 1.1.0                  | 2025-11-18        | Actualizacion basada   |
|                        |                   | en reporte de          |
|                        |                   | verificacion           |
|                        |                   | (REPORTE-VERIFICAC     |
|                        |                   | ION-PROCED-GOB-009.md) |
|                        |                   | - Correccion de 4 gaps |
|                        |                   | criticos: (1) Tiempos  |
|                        |                   | reales FASE 1:         |
|                        |                   | 60-90min, FASE 2:      |
|                        |                   | 60-90min, nueva FASE   |
|                        |                   | 2.5: 60-120min (2)     |
|                        |                   | Template detallado de  |
|                        |                   | tareas con metadata    |
|                        |                   | YAML (3) Estrategia    |
|                        |                   | para versiones         |
|                        |                   | multiples con matriz   |
|                        |                   | de decision (4) Nueva  |
|                        |                   | FASE 7 para            |
|                        |                   | sincronizacion con     |
|                        |                   | main. Ademas: ejemplos |
|                        |                   | de smoke tests y       |
|                        |                   | seccion de             |
|                        |                   | Conventional Commits   |
+------------------------+-------------------+------------------------+
| 1.0.0                  | 2025-11-17        | Creacion inicial       |
|                        |                   | basada en              |
|                        |                   | QA-REFACTOR-MCP-002    |
+------------------------+-------------------+------------------------+

.. _referencias-1:

16. Referencias
---------------

-  **Caso de estudio:** QA-REFACTOR-MCP-002 (2 refactorizaciones, 16
   tareas, 100% exitoso)
-  **PEP 585:** Type Hinting Generics In Standard Collections
-  **TDD:** Test-Driven Development (Kent Beck)
-  **Conventional Commits:** https://www.conventionalcommits.org/

--------------

**Procedimiento creado:** 2025-11-17 **Ultima revision:** 2025-11-18
**Próxima revisión:** 2026-11-17 (o después de 5 usos) **Mantenedor:**
Tech Lead Team
