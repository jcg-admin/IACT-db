ADR-014: Organización del Proyecto por Dominio
==============================================

ESTO NO SE CONSIDERA, YA QUE SE ESTA UTILIZADO OTRA ORGANIZACION
VALIDAR, QUE SE PUEDE ACTUALIZAR A LO QUE SE ESTA IMPLEMENTANDO
ACTUALMENTE

**Estado:** Aceptado **Fecha:** 2025-11-06 **Decisor:** Equipo
Desarrollo **Relacionado:** Estructura general del proyecto
**Actualizado:** 2025-11-06

--------------

Contexto
--------

El proyecto IACT es un sistema complejo que incluye múltiples
componentes: backend (API Django), frontend (React - futuro),
infraestructura (Vagrant, DevContainers, build systems), y documentación
técnica.

Problema
~~~~~~~~

Tradicionalmente, los proyectos se organizan por **tipo de archivo**
(seguir convenciones como src/, tests/, scripts/, docs/), pero esto
puede generar problemas de cohesión cuando el proyecto crece:

-  Archivos relacionados funcionalmente están dispersos en diferentes
   directorios raíz
-  Dificulta la navegación: para trabajar en infraestructura, hay que
   tocar scripts/, tests/, docs/, artifacts/
-  Escalabilidad limitada: cuando se agregan nuevos dominios (ui/,
   api/), la raíz se satura
-  Falta de boundaries claros entre dominios

Opciones Evaluadas
~~~~~~~~~~~~~~~~~~

Se consideraron 3 enfoques principales:

1. **Organización por dominio** (opción seleccionada)
2. Organización por tipo de archivo (convención tradicional)
3. Organización híbrida (mix de ambas)

--------------

Decisión
--------

**Usaremos organización por DOMINIO** en la raíz del proyecto.

Cada dominio principal tendrá su propio directorio que contendrá TODO lo
relacionado con ese dominio: código, tests, scripts específicos, y
artefactos generados.

Estructura Resultante
~~~~~~~~~~~~~~~~~~~~~

::

   /IACT---project/
   ├── api/                      # Dominio: Backend Django
   │   ├── (código de API)
   │   ├── tests/               # (futuro: tests de API)
   │   └── scripts/             # (futuro: scripts específicos de API)
   │
   ├── ui/                       # Dominio: Frontend React (futuro)
   │   ├── (código de UI)
   │   ├── tests/               # (futuro: tests de UI)
   │   └── scripts/             # (futuro: scripts de build UI)
   │
   ├── infrastructure/           # Dominio: Infraestructura
   │   ├── cpython/             # Subdomain: CPython (builder, feature, artifacts)
   │   ├── devcontainer/        # Configuración DevContainer
   │   ├── artifacts/           # Outputs compartidos (no CPython)
   │   ├── scripts/             # Scripts de infraestructura no-CPython
   │   ├── tests/               # Tests de infraestructura no-CPython
   │   ├── vagrant/             # VMs de infraestructura no-CPython
   │   └── box/
   │
   ├── docs/                     # Dominio: Documentación
   │   ├── specs/
   │   ├── adr/
   │   ├── infraestructura/
   │   ├── api/
   │   └── gobernanza/
   │
   ├── features/                 # Features de DevContainer (convención)
   │
   ├── scripts/                  # Scripts cross-cutting
   │   ├── dev/                 # Herramientas de desarrollo
   │   ├── ai/                  # Generación con IA
   │   └── templates/           # Templates compartidos
   │
   ├── .devcontainer/            # Convención VS Code
   ├── .github/                  # Convención GitHub
   └── respaldo/                 # Temporal/legacy

--------------

Justificación
-------------

Por qué Organización por Dominio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Cohesión:** - Todo lo relacionado con infraestructura está en
``infrastructure/`` - Fácil encontrar: scripts →
``infrastructure/scripts/``, tests → ``infrastructure/tests/`` -
Boundaries claros entre dominios

**Escalabilidad:** - Cuando se agregue ``ui/``, tendrá su propia
estructura completa - No satura la raíz con directorios genéricos
(scripts/, tests/, artifacts/) - Cada dominio puede evolucionar
independientemente

**Navegación:** - “Trabajar en infraestructura” = entrar a
``infrastructure/`` - “Trabajar en API” = entrar a ``api/`` - No saltar
entre 5 directorios raíz diferentes

**Consistencia con arquitectura:** - Refleja la arquitectura del sistema
(dominios separados) - Facilita modularización futura - Permite equipos
especializados por dominio

Por qué NO Organización por Tipo de Archivo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Contra:** - Dispersión: infraestructura necesitaría tocar scripts/,
tests/, artifacts/ en raíz - Raíz saturada: artifacts/, tests/,
scripts/, features/, docs/, api/, ui/, etc. - Boundaries difusos: ¿un
test de infraestructura va en tests/ o infrastructure/? - No escala:
agregar nuevos dominios satura aún más la raíz

**Ejemplos problemáticos con tipo de archivo:**

::

   /
   ├── scripts/
   │   ├── api/          # Scripts de API
   │   ├── infra/        # Scripts de infra
   │   └── ui/           # Scripts de UI
   ├── tests/
   │   ├── api/          # Tests de API
   │   ├── infra/        # Tests de infra
   │   └── ui/           # Tests de UI
   └── artifacts/
       ├── api/          # Artifacts de API
       ├── infra/        # Artifacts de infra
       └── ui/           # Artifacts de UI

Resultado: para trabajar en infraestructura hay que tocar 3+ directorios
raíz.

--------------

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Cohesión mejorada**: Todo lo de un dominio junto
2. **Escalabilidad**: Agregar dominios no satura raíz
3. **Navegación clara**: Un dominio = un directorio
4. **Modularización**: Boundaries claros entre dominios
5. **Onboarding más fácil**: Estructura intuitiva
6. **Migración futura facilitada**: Cada dominio puede convertirse en
   repo separado si es necesario

Negativas (mitigadas)
~~~~~~~~~~~~~~~~~~~~~

1. **Duplicación de estructura**: Cada dominio tiene tests/, scripts/

   -  **Mitigación**: Scripts cross-cutting en scripts/ raíz

2. **Convenciones tradicionales**: Difiere de proyectos tipo src/,
   tests/

   -  **Mitigación**: Es más moderno y escalable (usado por monorepos)

3. **Descubrimiento inicial**: Desarrolladores nuevos deben aprender
   estructura

   -  **Mitigación**: Este ADR + README documentan la decisión

Neutrales
~~~~~~~~~

1. **features/ en raíz**: Mantenido por convención de DevContainers
2. **scripts/ raíz**: Mantiene herramientas cross-cutting (dev/, ai/)
3. **.devcontainer/, .github/**: Convenciones de herramientas externas

--------------

Migración Realizada
-------------------

La reorganización se aplicó al dominio ``infrastructure/`` moviendo:

.. code:: bash

   artifacts/           → infrastructure/artifacts/
   tests/integration/   → infrastructure/tests/
   scripts/infra/       → infrastructure/scripts/

**Archivos actualizados:** 16 - Vagrantfile (synced folders) - Makefile
(paths de targets) - Scripts wrapper (paths internos) - Tests (variables
BASE_DIR, SCRIPTS_INFRA_DIR, ARTIFACTS_DIR) - Features (ejemplos de
artifactUrl) - Documentación (todas las referencias)

**Commit:** ``341f95d`` - refactor: reorganizar proyecto por dominio

Fase 2: Reorganización de CPython como Subdomain
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se reorganizó todo CPython en ``infrastructure/cpython/`` como
subdomain:

.. code:: bash

   infrastructure/vagrant/cpython-builder/  → infrastructure/cpython/
   features/cpython-prebuilt/               → infrastructure/cpython/installer/
   infrastructure/artifacts/cpython/        → infrastructure/cpython/artifacts/
   infrastructure/scripts/build_cpython.sh  → infrastructure/cpython/scripts/build_cpython.sh
   infrastructure/scripts/validate-*.sh     → infrastructure/cpython/scripts/validate-*.sh
   infrastructure/tests/test_cpython_*.py   → infrastructure/cpython/tests/test_cpython_*.py

Fase 3: Consolidación Completa en Builder
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se consolidó TODOS los componentes CPython dentro de ``builder/`` para
máxima cohesión:

.. code:: bash

   infrastructure/cpython/feature/     → infrastructure/cpython/builder/installer/
   infrastructure/cpython/artifacts/   → infrastructure/cpython/builder/artifacts/
   infrastructure/cpython/scripts/     → infrastructure/cpython/builder/scripts/ (renombrados a *-wrapper.sh)
   infrastructure/cpython/tests/       → infrastructure/cpython/builder/tests/

**Renombramiento semántico**: ``feature/`` → ``installer/`` para
reflejar mejor su función real (instalador de CPython en Dev Container).

Fase 4: Simplificación - Eliminación de ``builder/``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aplicando principio YAGNI (You Aren’t Gonna Need It), se eliminó el
nivel ``builder/`` innecesario:

.. code:: bash

   infrastructure/cpython/builder/*    → infrastructure/cpython/

**Razón**: TODO el contenido de cpython/ era parte del “builder”. No
había ni habrá otros componentes fuera de builder/, por lo tanto el
directorio agregaba complejidad sin valor.

**Resultado**: Path más simple y directo - ``infrastructure/cpython/``
contiene TODO directamente.

**Archivos actualizados:** 30+ - Makefile (todos los targets CPython) -
Vagrantfile (synced folders, documentación) - Scripts wrapper
(PROJECT_ROOT, VAGRANT_DIR, ARTIFACT_PATH) - Tests (BASE_DIR,
FEATURE_DIR, paths) - devcontainer_feature.json (documentationURL) -
Documentación (6 archivos en docs/)

**Resultado**: Máxima cohesión de CPython - todo en un solo lugar.

--------------

Ejemplos de Uso Futuro
----------------------

Agregar Tests de API
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Antes (tipo de archivo):
   tests/
     ├── api/
     │   └── test_endpoints.py
     └── infra/
         └── test_vagrant.py

   # Después (por dominio):
   api/
     └── tests/
         └── test_endpoints.py

   infrastructure/
     └── tests/
         └── test_vagrant.py

Agregar Scripts de UI
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Después (por dominio):
   ui/
     ├── src/
     ├── scripts/
     │   ├── build.sh         # Build de producción
     │   └── analyze.sh       # Análisis de bundle
     └── tests/

Scripts Cross-Cutting
~~~~~~~~~~~~~~~~~~~~~

Scripts que sirven a TODOS los dominios permanecen en raíz:

.. code:: bash

   scripts/
     ├── dev/
     │   ├── check_all.sh        # Valida todo el proyecto
     │   ├── validate_spec.sh    # Valida specs
     │   └── generate_plan.sh    # Genera planes
     ├── ai/
     │   └── run_test_generation.sh
     └── templates/
         └── bash_script_template.sh

--------------

Decisiones Complementarias
--------------------------

Features en Raíz
~~~~~~~~~~~~~~~~

**Decisión**: ``features/`` permanece en raíz **Razón**: Convención de
DevContainers Specification - DevContainers espera features en
``./features/`` o ``.devcontainer/features/`` - Mantener convención
facilita adopción e integración

.. _scripts-cross-cutting-1:

Scripts Cross-Cutting
~~~~~~~~~~~~~~~~~~~~~

**Decisión**: ``scripts/`` raíz para herramientas cross-domain
**Razón**: - Algunos scripts sirven a TODO el proyecto (check_all,
validate_spec) - Evita duplicación innecesaria - Herramientas de
desarrollo no pertenecen a un dominio específico

Excepciones de Convenciones Externas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Mantener en raíz**: - ``.devcontainer/`` - Convención VS Code -
``.github/`` - Convención GitHub Actions - ``.git/`` - Obvio

**Razón**: Herramientas externas esperan estas ubicaciones

Subdominios dentro de infrastructure/
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Decisión**: CPython organizado como subdominio en
``infrastructure/cpython/`` **Razón**: Máxima cohesión de componentes
relacionados

Cuando un dominio (como infrastructure) contiene subsistemas complejos
con múltiples componentes (builder, feature, artifacts, scripts, tests),
es mejor organizarlos como subdominios.

**Estructura de infrastructure/cpython/** (Fase 4 - Simplificación
Final):

::

   infrastructure/
   └── cpython/                    # Subdomain: Todo CPython (sin nivel extra)
       ├── Vagrantfile             # VM de compilación
       ├── bootstrap.sh            # Provisioning de VM
       ├── scripts/                # TODOS los scripts (VM + host wrapper)
       │   ├── build_cpython.sh          # Script de compilación (VM)
       │   ├── validate_build.sh         # Validación (VM)
       │   ├── build_wrapper.sh          # Wrapper host → VM
       │   ├── validate_wrapper.sh       # Wrapper host → VM
       │   └── feature_install.sh        # Instalación en DevContainer
       ├── installer/              # Instalador para Dev Container
       │   ├── devcontainer_feature.json
       │   ├── install.sh          # Symlink → ../scripts/feature_install.sh
       │   └── README.md
       ├── artifacts/              # Binarios compilados (.tgz)
       │   ├── ARTIFACTS.md
       │   └── .gitkeep
       ├── tests/                  # Tests de integración
       │   ├── test_cpython_build_system.py
       │   └── test_cpython_feature.py
       ├── utils/                  # Utilidades de compilación
       ├── config/                 # Configuraciones
       ├── logs/                   # Logs de compilación
       └── README.md

**Ventajas del subdomain simplificado (Fase 4)**: 1. **Máxima
simplicidad**: TODO CPython directamente en ``cpython/`` - sin niveles
extra 2. **YAGNI aplicado**: Eliminado ``builder/`` innecesario (no
había otros componentes fuera) 3. **Escalabilidad**: Permite agregar
infrastructure/go/, infrastructure/node/ en el futuro 4. **Navegación
directa**: “Trabajar en CPython” = “cd infrastructure/cpython/” y listo
5. **Modularización**: Cada subdomain puede tener su propia
documentación y README 6. **Boundaries claros**: Separación completa
entre subsistemas de infraestructura 7. **Eliminación total de
dispersión**: Todo unificado en un solo lugar 8. **Convención
DevContainer respetada**: Symlink installer/install.sh mantiene
compatibilidad 9. **Nomenclatura descriptiva**: ``installer/`` describe
claramente su función (instalar CPython en DevContainer) 10.
**Pragmatismo**: CPython ES el builder, no hay distinción práctica

**Aplicación**: - COMPLETADO Fase 2: Migración de CPython a subdomain
(2025-11-06) - COMPLETADO Fase 3: Consolidación completa en builder/
(2025-11-06) - COMPLETADO Fase 4: Simplificación - eliminación de
builder/ innecesario (2025-11-06) - Todos los componentes en
infrastructure/cpython/ (path más corto y directo) - Referencias
actualizadas en 40+ archivos: - Makefile (todos los targets cpython) -
devcontainer.json (feature path, artifact URL) - Vagrantfile
(comentarios, paths) - Scripts wrapper (PROJECT_ROOT: 4→3 niveles,
VAGRANT_DIR) - Tests (VAGRANT_DIR, INSTALLER_DIR paths) - 15+ archivos
de documentación (\*.md)

--------------

Referencias
-----------

Patrones Similares en la Industria
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Monorepos modernos:** - Nx (Angular/React): Organiza por ``apps/`` y
``libs/`` - Turborepo: Organiza por ``packages/`` (dominios) - Lerna:
Múltiples ``packages/`` independientes

**Arquitectura de software:** - DDD (Domain-Driven Design): Organiza por
dominios de negocio - Clean Architecture: Separación por layers/dominios
- Microservicios: Cada servicio es un dominio separado

**Proyectos referencia:** - Kubernetes: Organizado por dominios (api/,
cmd/, pkg/) - Terraform: Organizado por providers (dominios)

Documentación del Proyecto
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Este ADR documenta la decisión y justificación
-  README principal debe incluir mapa de navegación
-  Cada dominio (``api/``, ``ui/``, ``infrastructure/``) debe tener su
   propio README

--------------

Preguntas Frecuentes
--------------------

¿Por qué no seguir la convención src/, tests/ tradicional?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Esa convención funciona bien para proyectos pequeños con un solo
dominio. IACT tiene múltiples dominios (api, ui, infrastructure) que
crecerán independientemente. Organización por dominio escala mejor.

¿Qué pasa con scripts que afectan múltiples dominios?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Van en ``scripts/`` raíz. Ejemplos: - ``scripts/dev/check_all.sh`` -
Valida todo el proyecto - ``scripts/ai/`` - Herramientas de IA
cross-cutting

¿Dónde van tests end-to-end que tocan API + UI?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Opción 1: En un nuevo directorio ``e2e/`` raíz Opción 2: En el dominio
principal que se está testeando Decisión pendiente según caso de uso
real.

¿Esto complica el proyecto?
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Inicialmente puede parecer más complejo, pero: - Facilita navegación a
largo plazo - Reduce búsqueda: “trabajar en X” = “cd X/” - Escala mejor
que saturar la raíz

--------------

Estado de Implementación
------------------------

-  COMPLETADO: Migración de ``infrastructure/`` a dominio (2025-11-06)
-  COMPLETADO: Reorganización de CPython como subdomain
   ``infrastructure/cpython/`` (2025-11-06)
-  PENDIENTE: README principal actualizado con mapa de navegación
-  PENDIENTE: Documentar en guía de desarrollo
-  PENDIENTE: Aplicar a ``api/`` cuando se agreguen tests/scripts
-  PENDIENTE: Aplicar a ``ui/`` cuando se implemente

--------------

**Mantenido por**: Equipo Desarrollo IACT **Última revisión**:
2025-11-06
