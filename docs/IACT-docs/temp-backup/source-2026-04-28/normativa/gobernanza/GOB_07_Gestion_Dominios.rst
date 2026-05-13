.. meta::
   :artefacto: GOB_07
   :tipo: Politica
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-07:

===========================
GOB_07: Gestion de Dominios
===========================


Proposito
---------

Este documento define las **politicas de gestion estructural** del sistema
documental IACT, estableciendo las reglas para crear, modificar y gestionar
dominios, subdominios y subcarpetas, incluyendo el proceso de congelamiento
y descongelamiento.

.. important::

   **Pregunta Clave que Responde:**

   "¿Como esta organizada la documentacion y como puedo modificar esa estructura?"

.. note::

   Este artefacto complementa las definiciones oficiales del modelo documental
   estableciendo los procesos de gobernanza para la gestion estructural.

----

1. Jerarquia Documental
-----------------------

1.1 Niveles de la Estructura
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El sistema documental IACT tiene una jerarquia de **5 niveles maximo**:

.. code-block:: text

   JERARQUIA DOCUMENTAL IACT
   =========================

   RAIZ (documentacion/)
   │
   ├── DOMINIO PRIMARIO (Nivel 1)              5 dominios
   │   ├── index.rst                           (obligatorio)
   │   │
   │   ├── SUBDOMINIO (Nivel 2)                21 subdominios
   │   │   ├── index.rst                       (obligatorio)
   │   │   │
   │   │   ├── ARTEFACTO (Nivel 3)             Si CONGELADO
   │   │   │   └── PREFIJO_NNN_Nombre.rst
   │   │   │
   │   │   └── SUBCARPETA (Nivel 3)            Si DESCONGELADO
   │   │       ├── index.rst                   (si >10 archivos)
   │   │       │
   │   │       ├── ARTEFACTO (Nivel 4)
   │   │       │   └── PREFIJO_NNN_Nombre.rst
   │   │       │
   │   │       └── SECCION (Nivel 4)           Opcional
   │   │           └── ARTEFACTO (Nivel 5)     Excepcional
   │   │
   │   └── ...
   │
   └── ...

1.2 Profundidad Tipica
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Escenario
     - Niveles
     - Ejemplo
   * - Tipico (congelado)
     - 3
     - requisitos/casos_uso/UC_001.rst
   * - Descongelado simple
     - 4
     - estandares/plantillas/TPL_Requisito.rst
   * - Descongelado + seccion
     - 5
     - decisiones/2024/ADR_001.rst

**Objetivo de diseño:** Mantener 3 niveles como maximo tipico.

----

2. Definicion de Componentes
----------------------------

2.1 Dominio Primario
^^^^^^^^^^^^^^^^^^^^

**Definicion:** Unidad arquitectonica mayor que agrupa artefactos por un
proposito macro unico, gobernable y auditable independientemente.

**Caracteristicas Obligatorias:**

.. code-block:: text

   1. Proposito macro unico y estable
   2. Gobernable como bloque (PMO puede aprobar/auditar)
   3. Aprobacion formal independiente
   4. Auditable como unidad completa
   5. Owner RACI definido
   6. Ciclo de vida propio
   7. index.rst obligatorio en su raiz
   8. Estabilidad estructural (no cambia frecuentemente)

**Lo que NO es un Dominio:**

- Una simple carpeta organizativa
- Una categoria tematica sin gobernanza
- Un contenedor temporal o transitorio
- Una estructura que cambia frecuentemente

**Regla:** Dominios NO pueden contener Dominios.

2.2 Subdominio
^^^^^^^^^^^^^^

**Definicion:** Unidad interna de un Dominio con proposito semantico propio,
que organiza artefactos de un tipo especifico, sin gobernanza independiente.

**Caracteristicas Obligatorias:**

.. code-block:: text

   1. Proposito semantico claro
   2. Organiza tipo especifico de conocimiento
   3. Participa en trazabilidad
   4. Tiene prefijo de artefacto asociado
   5. index.rst obligatorio
   6. Aprobacion via Dominio padre
   7. Owner heredado o especifico

**Estados de Subdominio:**

- **CONGELADO:** Estructura plana, solo artefactos directos (por defecto)
- **DESCONGELADO:** Permite subcarpetas organizativas (por excepcion)

**Regla:** Subdominios NO pueden contener Subdominios.

2.3 Subcarpeta Organizativa
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Subdivision interna de un Subdominio DESCONGELADO que agrupa
artefactos de un subtipo especifico con prefijo propio.

**Caracteristicas Obligatorias:**

.. code-block:: text

   1. Introduce prefijo nuevo o subtipo
   2. Solo existe en Subdominios DESCONGELADOS
   3. Requiere descongelamiento previo
   4. Aprobacion de Arquitecto + Owner para crear
   5. index.rst obligatorio si >10 archivos
   6. Puede tener template especifico

**Regla:** Subcarpetas NO pueden contener Subcarpetas.

2.4 Seccion
^^^^^^^^^^^

**Definicion:** Agrupacion tematica opcional dentro de un Subdominio o
Subcarpeta, sin impacto en gobernanza o trazabilidad.

**Caracteristicas:**

.. code-block:: text

   1. NO introduce prefijo nuevo
   2. Solo agrupa por tema/modulo/año
   3. NO requiere descongelamiento
   4. NO tiene index.rst obligatorio
   5. Puede crearse/eliminarse libremente
   6. Sirve solo para orden y legibilidad

**Cuando usar:** >30 artefactos que pueden agruparse por tema claro.

2.5 Artefacto
^^^^^^^^^^^^^

**Definicion:** Unidad minima de informacion documental, representada por
un archivo individual con ID unico.

**Caracteristicas Obligatorias:**

.. code-block:: text

   1. Es un archivo individual
   2. Tiene ID unico (PREFIJO_NNN_Nombre.ext)
   3. Tiene proposito claro y unico
   4. Es versionable (Git)
   5. Es referenciable (:ref:)
   6. Participa en trazabilidad
   7. Vive dentro de Subdominio o Subcarpeta

----

3. Modelo IACT Actual
---------------------

3.1 Arquitectura General
^^^^^^^^^^^^^^^^^^^^^^^^

**Formula:** 5 Dominios + 21 Subdominios + 6 Subcarpetas

.. code-block:: text

   DOMINIOS PRIMARIOS (5):

   1. base_cognitiva/      - Base semantica y conceptual
   2. normativa/           - Reglas, estandares, gobernanza
   3. requisitos/          - Producto funcional (BR, UC, FR)
   4. arquitectura_tecnica/- Diseño estructural y operacional
   5. usuario_gestion/     - Documentacion usuario y proyecto

3.2 Detalle por Dominio
^^^^^^^^^^^^^^^^^^^^^^^

**DOMINIO #1: base_cognitiva/ (6 subdominios)**

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Subdominio
     - Prefijo
     - Estado
     - Owner
   * - _metadata/
     - META\_
     - Congelado
     - PMO
   * - glosario/
     - GLOS\_
     - Congelado
     - Arq Doc
   * - fundamentos_conceptuales/
     - FND\_
     - Congelado
     - Arq Doc
   * - ontologia_sbvr/
     - SBVR\_
     - Congelado
     - Arq Doc
   * - taxonomias_y_metamodelos/
     - TXM\_, MTM\_
     - Descongelado
     - Arq Doc
   * - metodologias_analiticas/
     - MET\_
     - Congelado
     - Arq Doc

**DOMINIO #2: normativa/ (4 subdominios)**

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Subdominio
     - Prefijo
     - Estado
     - Owner
   * - procedimientos/
     - PROC\_
     - Congelado
     - PMO
   * - estandares/
     - STD\_, TPL\_
     - Descongelado
     - Arq Doc
   * - gobernanza/
     - GOB\_
     - Congelado
     - PMO
   * - restricciones/
     - CNST\_
     - Congelado
     - Tech Lead

**DOMINIO #3: requisitos/ (5 subdominios)**

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Subdominio
     - Prefijo
     - Estado
     - Owner
   * - reglas_negocio/
     - BR\_
     - Congelado
     - BA Lead
   * - casos_uso/
     - UC\_
     - Congelado
     - BA Lead
   * - requisitos_funcionales/
     - FR\_
     - Congelado
     - BA Lead
   * - requisitos_no_funcionales/
     - NFR\_
     - Congelado
     - Tech Lead
   * - rtm/
     - RTM\_, COV\_
     - Congelado
     - BA Lead

**DOMINIO #4: arquitectura_tecnica/ (3 subdominios)**

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Subdominio
     - Prefijo
     - Estado
     - Owner
   * - arquitectura/
     - ARQ\_, ADR\_
     - Descongelado
     - Arquitecto
   * - diseño_detallado/
     - DES\_, API\_
     - Descongelado
     - Tech Lead
   * - despliegue/
     - DEP\_
     - Congelado
     - DevOps

**DOMINIO #5: usuario_gestion/ (3 subdominios)**

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Subdominio
     - Prefijo
     - Estado
     - Owner
   * - manuales_usuarios/
     - MAN\_
     - Congelado
     - Tech Writer
   * - pm/
     - PM\_
     - Congelado
     - PMO
   * - evidencia/
     - EVD\_
     - Congelado
     - QA

3.3 Estadisticas Actuales
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 50 25

   * - Metrica
     - Cantidad
   * - Dominios Primarios
     - 5
   * - Subdominios (nivel 2)
     - 21
   * - Subdominios CONGELADOS
     - 17
   * - Subdominios DESCONGELADOS
     - 4
   * - Subcarpetas Organizativas
     - 6
   * - Indices totales (index.rst)
     - 33
   * - Profundidad maxima
     - 4 niveles
   * - Profundidad tipica
     - 3 niveles

----

4. Estados de Subdominios
-------------------------

4.1 Estado CONGELADO (Por Defecto)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Subdominio con estructura plana sin subdivisiones internas.

.. code-block:: text

   CARACTERISTICAS:

   ✅ Artefactos directamente bajo el subdominio
   ✅ Estructura simple: subdominio/ARTEFACTO.rst
   ✅ Validacion automatica trivial
   ✅ Baja complejidad cognitiva
   ✅ Facil navegacion y trazabilidad

**Ejemplo:**

.. code-block:: text

   requisitos/casos_uso/            ← CONGELADO
   ├── index.rst
   ├── UC_001_Login.rst
   ├── UC_002_Dashboard.rst
   └── UC_003_Reporte.rst

**Regla:** Todos los Subdominios estan CONGELADOS por defecto.

4.2 Estado DESCONGELADO (Por Excepcion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Subdominio autorizado para contener Subcarpetas Organizativas.

.. code-block:: text

   CARACTERISTICAS:

   ⚠️ Permite subcarpetas internas con prefijos especializados
   ⚠️ Estructura jerarquica: subdominio/subcarpeta/ARTEFACTO.rst
   ⚠️ Validacion automatica mas compleja
   ⚠️ Mayor complejidad, pero mejor organizacion cuando >30 artefactos

**Ejemplo:**

.. code-block:: text

   normativa/estandares/            ← DESCONGELADO
   ├── index.rst
   ├── STD_01_Nomenclatura.rst
   └── plantillas/                  ← SUBCARPETA
       ├── TPL_Requisito.rst
       └── TPL_Caso_Uso.rst

**Regla:** Solo descongelar mediante proceso formal (ver seccion 5).

4.3 Principio de Diseño
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PRINCIPIO OPEN/CLOSED APLICADO A GOBERNANZA:

   "El sistema es CERRADO por defecto (congelado),
    ABIERTO solo por extension controlada (descongelamiento formal)."

   JUSTIFICACION:
   ✅ Protege estabilidad estructural
   ✅ Reduce carga cognitiva
   ✅ Simplifica trazabilidad
   ✅ Evita crecimiento especulativo
   ✅ Mantiene validacion automatica simple
   ✅ Previene fragmentacion prematura

   REGLA: Solo descongelar cuando el DOLOR de no hacerlo
          supere el COSTO de hacerlo.

----

5. Proceso de Descongelamiento
------------------------------

5.1 Criterios de Elegibilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Un Subdominio puede descongelarse si cumple **AL MENOS UNA** condicion:

**a) Cambio de Autoridad Normativa**

.. code-block:: text

   Diferentes subtipos requieren owners diferentes.

   Ejemplo:
   estandares/ contiene:
   - Estandares (STD\_) → Owner: Arquitecto Doc
   - Plantillas (TPL\_) → Owner: Tech Writer

   Justificacion: Diferentes responsables requieren separacion

**b) Cambio de Ciclo de Vida**

.. code-block:: text

   Artefactos tienen ciclos radicalmente diferentes.

   Ejemplo:
   arquitectura/ contiene:
   - Vistas (ARQ\_) → Ciclo: Diseño inicial, actualizacion rara
   - ADRs (ADR\_) → Ciclo: Continuo, cada decision nueva

   Justificacion: Ciclos diferentes justifican separacion

**c) Aparicion de Reglas Incompatibles**

.. code-block:: text

   Prefijos que no pueden convivir sin generar confusion.

   Ejemplo:
   diseño_detallado/ contiene:
   - APIs (API\_) → Template: Especificacion REST
   - Modelos (DSC_MOD\_) → Template: Esquema de datos

   Justificacion: Templates incompatibles requieren separacion

**d) Evidencia Empirica de Complejidad**

.. code-block:: text

   Criterios objetivos:
   - >30 artefactos en el Subdominio
   - Indice del Subdominio >200 lineas
   - Baja legibilidad incluso con nomenclatura correcta
   - Quejas sostenidas del equipo sobre navegacion

5.2 Aprobaciones Requeridas
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 25 20 20

   * - Rol
     - Responsabilidad
     - Obligatorio
     - Veto
   * - Arquitecto de Documentacion
     - Impacto estructural
     - SI
     - SI
   * - PMO
     - Impacto en gobernanza
     - SI
     - SI
   * - Owner del Dominio
     - Aprobacion final
     - SI
     - SI
   * - Tech Lead
     - Impacto tecnico
     - Recomendado
     - NO

5.3 Proceso Formal
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO DE DESCONGELAMIENTO
   ===========================

   PASO 1: Solicitud
   - Owner del Subdominio documenta justificacion
   - Identifica criterio(s) aplicable(s)
   - Propone estructura con subcarpetas
   - Propone prefijos nuevos

   PASO 2: Revision Arquitectonica
   - Arquitecto evalua impacto estructural
   - Verifica consistencia con modelo
   - Valida prefijos propuestos

   PASO 3: Revision de Gobernanza
   - PMO evalua impacto en trazabilidad
   - Verifica impacto en auditorias
   - Valida owners propuestos

   PASO 4: Aprobacion
   - Owner del Dominio aprueba
   - Requiere unanimidad (Arq + PMO + Owner)

   PASO 5: Documentacion
   - Actualizar GOB_07 seccion 6 (Registro)
   - Crear index.rst en subcarpetas
   - Actualizar indices padre

5.4 Documentacion Obligatoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Al descongelar, registrar en seccion 6:

.. code-block:: text

   REGISTRO DE DESCONGELAMIENTO:

   1. Nombre del Subdominio
   2. Fecha de descongelamiento
   3. Criterio(s) aplicable(s) (a, b, c, o d)
   4. Justificacion detallada
   5. Subcarpetas creadas
   6. Prefijos introducidos
   7. Firmas de aprobacion

----

6. Registro de Subdominios Descongelados
----------------------------------------

6.1 taxonomias_y_metamodelos/ (DESCONGELADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - Dominio padre
     - base_cognitiva/
   * - Fecha
     - 2024-10-15 (diseño inicial)
   * - Criterio
     - (c) Reglas incompatibles
   * - Justificacion
     - TXM\_ (clasificacion jerarquica) y MTM\_ (estructura UML/ER) son conceptos distintos con templates incompatibles.
   * - Subcarpetas
     - taxonomias/ (TXM\_), metamodelos/ (MTM\_)
   * - Aprobaciones
     - Arq Doc, PMO, BA Lead

6.2 estandares/ (DESCONGELADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - Dominio padre
     - normativa/
   * - Fecha
     - 2024-10-20 (diseño inicial)
   * - Criterio
     - (a) Cambio de autoridad + (d) Complejidad prevista
   * - Justificacion
     - STD\_ (Arquitecto) y TPL\_ (Tech Writer) tienen owners diferentes. Se previeron >25 artefactos.
   * - Subcarpetas
     - plantillas/ (TPL\_)
   * - Aprobaciones
     - Arq Doc, PMO

6.3 arquitectura/ (DESCONGELADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - Dominio padre
     - arquitectura_tecnica/
   * - Fecha
     - 2024-10-22 (diseño inicial)
   * - Criterio
     - (b) Cambio de ciclo de vida
   * - Justificacion
     - ARQ\_ (vistas, rara actualizacion) y ADR\_ (continuo) tienen ciclos diferentes.
   * - Subcarpetas
     - decisiones/ (ADR\_)
   * - Aprobaciones
     - Arq Doc, PMO, Tech Lead

6.4 diseño_detallado/ (DESCONGELADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - Dominio padre
     - arquitectura_tecnica/
   * - Fecha
     - 2024-10-22 (diseño inicial)
   * - Criterio
     - (c) Reglas incompatibles
   * - Justificacion
     - API\_ (especificaciones REST), DSC_MOD\_ (esquemas), DSC_INT\_ (flujos) tienen templates incompatibles.
   * - Subcarpetas
     - apis/ (API\_), modelos/ (DSC_MOD\_)
   * - Aprobaciones
     - Arq Doc, PMO, Tech Lead

----

7. Proceso de Recongelamiento
-----------------------------

7.1 Cuando Recongelar
^^^^^^^^^^^^^^^^^^^^^

Un Subdominio descongelado PUEDE recongelarse si:

.. code-block:: text

   - Las Subcarpetas Organizativas se eliminan
   - Artefactos se mueven al nivel del Subdominio
   - Se justifica que la complejidad disminuyo
   - Ya no aplican los criterios originales

7.2 Proceso
^^^^^^^^^^^

.. code-block:: text

   PROCESO DE RECONGELAMIENTO:

   1. Migrar artefactos de subcarpetas al subdominio
   2. Actualizar referencias (:ref:) afectadas
   3. Eliminar subcarpetas vacias
   4. Actualizar indice del subdominio
   5. Obtener mismas aprobaciones que descongelamiento
   6. Actualizar registro en seccion 6

----

8. Creacion de Estructuras
--------------------------

8.1 Crear Nuevo Dominio
^^^^^^^^^^^^^^^^^^^^^^^

**Restriccion:** Operacion excepcional. Los 5 dominios actuales cubren
todas las necesidades previstas.

.. code-block:: text

   PROCESO (si fuera necesario):

   1. Justificacion exhaustiva ante Sponsor
   2. Analisis de impacto en todo el sistema
   3. Aprobacion de PMO + Sponsor
   4. Definir Owner, subdominios, prefijos
   5. Crear estructura con index.rst
   6. Actualizar documentacion de modelo

8.2 Crear Nuevo Subdominio
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO:

   1. Identificar Dominio padre
   2. Definir proposito semantico claro
   3. Proponer prefijo de artefactos
   4. Obtener aprobacion de Owner del Dominio
   5. Crear carpeta con index.rst
   6. Actualizar indice del Dominio padre
   7. Estado inicial: CONGELADO

8.3 Crear Subcarpeta Organizativa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Prerequisito:** Subdominio padre debe estar DESCONGELADO.

.. code-block:: text

   PROCESO:

   1. Verificar que Subdominio esta descongelado
   2. Si no, ejecutar proceso de descongelamiento primero
   3. Definir prefijo de la subcarpeta
   4. Crear carpeta con index.rst (si >10 archivos)
   5. Actualizar indice del Subdominio padre

8.4 Crear Seccion
^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO (simple, sin aprobacion formal):

   1. Crear carpeta con nombre descriptivo
   2. Mover artefactos correspondientes
   3. Actualizar indice del contenedor padre
   4. NO requiere index.rst obligatorio

----

9. Regla de Oro
---------------

.. code-block:: text

   "Dominio gobierna.
    Subdominio organiza y significa.
    Subcarpeta especializa (solo si descongelado).
    Seccion clasifica (opcional).
    Artefacto informa."

**Corolarios:**

1. Si no sabes donde va → **Subdominio** (casi nunca necesitas Dominio o Subcarpeta)

2. Si duele la navegacion → **Seccion primero** (antes de descongelar)

3. Si introduces prefijo nuevo → **Subcarpeta** (requiere descongelamiento)

4. Si el archivo tiene ID → **Artefacto** (obvio pero critico)

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`meta-05` - Estructura Documental

Fuentes Externas
^^^^^^^^^^^^^^^^

- DEFINICIONES_OFICIALES_MODELO_DOCUMENTAL_IACT_v_2_0_0.md

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Version inicial. Jerarquia documental. Modelo 5+21+6. Estados congelado/descongelado. Proceso de descongelamiento. Registro de subdominios descongelados.

----

**Trazabilidad:** Este artefacto define la estructura del sistema documental
IACT y los procesos para modificarla. Es la referencia normativa para cualquier
cambio estructural. Complementa las DEFINICIONES_OFICIALES y es referenciado
por GOB_10 para auditorias de estructura.