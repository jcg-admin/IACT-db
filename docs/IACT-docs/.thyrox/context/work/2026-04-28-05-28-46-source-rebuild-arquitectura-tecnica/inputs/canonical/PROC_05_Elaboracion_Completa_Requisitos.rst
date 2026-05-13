.. meta::
   :artefacto: PROC_05
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :estado: Borrador
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-05:

==============================================================================
PROC_05: Elaboracion Completa de Requisitos (Flujo BR → UC → FR)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 3

----

1. Proposito
------------

Este procedimiento define el **flujo completo y auditable** para elaborar
requisitos del sistema IACT, desde la identificacion de restricciones del
cliente (CNST) hasta la derivacion de requisitos funcionales (FR) verificables.

**Alcance:**

- Creacion de Business Rules (BR)
- Creacion de Business Requirements (BReq)
- Creacion de Casos de Uso (UC)
- Derivacion de Functional Requirements (FR)
- Establecimiento de trazabilidad completa

----

2. Referencias Normativas
-------------------------

Este procedimiento se basa en las siguientes fuentes normativas:

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - Documento
     - Proposito
     - Version
   * - DEFINICIONES_OFICIALES
     - Estructura documental, estados, jerarquia
     - v2.0.0
   * - ARBOL_COMPLETO
     - Estructura de carpetas y subdominios
     - v2.0.0
   * - FND_03
     - Estructura de Casos de Uso
     - v1.1.0
   * - FND_05
     - Jerarquia 4 Niveles (BR→BReq→UC→FR)
     - v1.0.0
   * - FND_06
     - Derivacion vs Transformacion
     - v1.0.0
   * - FND_07
     - Requisitos Funcionales SMART
     - v1.0.0
   * - PARTE_1
     - Identificar Reglas de Negocio
     - v2.0
   * - PARTE_2
     - Transformar BR en UC
     - v2.0
   * - PARTE_3
     - Identificar UC Adicionales
     - v1.0
   * - PARTE_4
     - Especificar FR
     - v1.0

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Rol
     - Codigo RACI
     - Responsabilidad
   * - Business Analyst Lead
     - R (Responsible)
     - Ejecuta el procedimiento, crea artefactos
   * - Product Owner
     - A (Accountable)
     - Aprueba requisitos, valida alineacion negocio
   * - Arquitecto Documentacion
     - C (Consulted)
     - Valida estructura y formato
   * - PMO
     - I (Informed)
     - Recibe notificacion de cambios

----

4. Entradas Requeridas
----------------------

Antes de iniciar este procedimiento, se requiere:

.. code-block:: text

   ENTRADAS OBLIGATORIAS:
   
   1. Restricciones del Cliente (CNST_*)
      Ubicacion: arquitectura_tecnica/restricciones/
      Estado: Aprobado
      
   2. Documentos de Elicitacion
      - Actas de reunion con stakeholders
      - Documentos de politicas corporativas
      - Regulaciones aplicables
      
   3. Plantillas Disponibles
      Ubicacion: normativa/estandares/plantillas/
      - TPL_Regla_Negocio.rst
      - TPL_Caso_Uso.rst
      - TPL_Requisito_Funcional.rst

----

5. Salidas Producidas
---------------------

Al completar este procedimiento, se generan:

.. code-block:: text

   SALIDAS:
   
   1. Business Rules (BR_*)
      Ubicacion: requisitos/reglas_negocio/
      Cantidad tipica: 3-10 por proyecto
      
   2. Business Requirements (BReq_*)
      Ubicacion: requisitos/requisitos_negocio/
      Cantidad tipica: 3-5 por proyecto
      
   3. Casos de Uso (UC_*)
      Ubicacion: requisitos/casos_uso/
      Cantidad tipica: 20-100 por proyecto
      
   4. Requisitos Funcionales (FR_*)
      Ubicacion: requisitos/requisitos_funcionales/
      Cantidad tipica: 100-500 por proyecto
      
   5. Matriz de Trazabilidad Actualizada
      Ubicacion: requisitos/rtm/

----

6. Flujo del Procedimiento
--------------------------

.. code-block:: text

   ┌─────────────────────────────────────────────────────────────────────────┐
   │                     FLUJO COMPLETO DE REQUISITOS                        │
   │                                                                         │
   │  FASE 0          FASE 1         FASE 2         FASE 3         FASE 4   │
   │  ────────        ────────       ────────       ────────       ──────── │
   │                                                                         │
   │  CNST_ ──────►  BR_ ─────────► BReq_ ────────► UC_ ─────────► FR_      │
   │  (Cliente)      (Reglas)       (Objetivos)     (Casos)        (Func.)  │
   │                                                                         │
   │  Restricciones  Politicas      Necesidades     Interacciones  Atomicos │
   │  tecnicas       dominio        stakeholder     usuario-sist   verific. │
   │                                                                         │
   │                      │               │              │                   │
   │                      ▼               ▼              ▼                   │
   │                  ┌───────────────────────────────────────┐              │
   │                  │        RTM (Trazabilidad)             │              │
   │                  │  CNST → BR → BReq → UC → FR → TST     │              │
   │                  └───────────────────────────────────────┘              │
   │                                                                         │
   └─────────────────────────────────────────────────────────────────────────┘

----

7. FASE 0: Verificar Restricciones (CNST)
-----------------------------------------

7.1 Objetivo
^^^^^^^^^^^^

Confirmar que las restricciones del cliente estan documentadas y aprobadas
antes de derivar reglas de negocio.

7.2 Pasos
^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 0.1
     - Ubicar carpeta ``arquitectura_tecnica/restricciones/``
     - BA Lead
     - Ruta confirmada
   * - 0.2
     - Verificar existencia de CNST_* aprobados
     - BA Lead
     - Lista de CNST
   * - 0.3
     - Revisar que cada CNST tenga: ID, Definicion, Fuente, Justificacion
     - BA Lead
     - Checklist OK
   * - 0.4
     - Identificar CNST que generaran BR
     - BA Lead
     - Mapeo CNST→BR

7.3 Criterio de Salida
^^^^^^^^^^^^^^^^^^^^^^

- Al menos 1 CNST aprobado existe
- Mapeo CNST→BR identificado

7.4 Ejemplo IACT
^^^^^^^^^^^^^^^^

.. code-block:: text

   CNST Existentes:
   - CNST_003: BD IVR solo lectura
   - CNST_004: Sincronizacion nocturna 00:00-06:00
   - CNST_005: 17 roles predefinidos, sin jerarquia
   
   Mapeo Identificado:
   - CNST_003 → BR_001 (Inmutabilidad)
   - CNST_004 → BR_002 (ETL Programado)
   - CNST_005 → BR_003 (RBAC Flat)

----

8. FASE 1: Crear Business Rules (BR)
------------------------------------

8.1 Objetivo
^^^^^^^^^^^^

Documentar las reglas del dominio que el sistema debe cumplir, derivadas
de restricciones del cliente y politicas organizacionales.

8.2 Fuentes Normativas
^^^^^^^^^^^^^^^^^^^^^^

- FND_02: Reglas de Negocio
- PARTE_1: Identificar Reglas de Negocio

8.3 Pasos
^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 1.1
     - Crear carpeta ``requisitos/reglas_negocio/`` si no existe
     - BA Lead
     - Carpeta creada
   * - 1.2
     - Copiar plantilla ``TPL_Regla_Negocio.rst``
     - BA Lead
     - Archivo base
   * - 1.3
     - Asignar ID secuencial: BR_001, BR_002, ...
     - BA Lead
     - ID unico
   * - 1.4
     - Redactar definicion formal (SBVR si aplica)
     - BA Lead
     - Definicion clara
   * - 1.5
     - Clasificar tipo: Restriccion, Desencadenador, Hecho, Calculo
     - BA Lead
     - Tipo asignado
   * - 1.6
     - Documentar fuente (CNST, politica, regulacion)
     - BA Lead
     - Trazabilidad origen
   * - 1.7
     - Agregar al index.rst del subdominio
     - BA Lead
     - Index actualizado
   * - 1.8
     - Solicitar revision de Arquitecto
     - BA Lead
     - Revision solicitada
   * - 1.9
     - Incorporar feedback y aprobar
     - PO
     - BR aprobado

8.4 Estructura del Artefacto BR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: rst

   .. meta::
      :artefacto: BR_NNN
      :tipo: Regla de Negocio
      :dominio: requisitos
      :subdominio: reglas_negocio
      :estado: [Borrador|En Revision|Aprobado]
      :version: 1.0.0

   .. _br-nnn:

   ==============================================================================
   BR_NNN: [Nombre Descriptivo]
   ==============================================================================

   1. Definicion Formal
   --------------------
   
   **Enunciado SBVR:**
   
   Es [obligatorio|prohibido|necesario] que [sujeto] [verbo] [complemento]
   [cuando condicion].

   2. Clasificacion
   ----------------
   
   - **Tipo:** [Restriccion|Desencadenador|Hecho|Calculo|Inferencia]
   - **Modalidad:** [Aletrica|Deontica]
   - **Origen:** [CNST_NNN|Politica X|Regulacion Y]

   3. Justificacion
   ----------------
   
   [Por que existe esta regla]

   4. Trazabilidad
   ---------------
   
   **Deriva de:** CNST_NNN
   **Genera:** BReq_NNN, UC_NNN

8.5 Criterio de Salida Fase 1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Todos los BR derivados de CNST estan documentados
- Cada BR tiene estado "Aprobado"
- index.rst de reglas_negocio actualizado
- Mapeo BR→BReq identificado

----

9. FASE 2: Crear Business Requirements (BReq)
---------------------------------------------

9.1 Objetivo
^^^^^^^^^^^^

Documentar las necesidades de alto nivel del negocio que justifican
el proyecto, derivadas de las reglas de negocio.

9.2 Fuentes Normativas
^^^^^^^^^^^^^^^^^^^^^^

- FND_05: Jerarquia 4 Niveles (Nivel 1: BReq)
- BReq_001, BReq_002, BReq_003 existentes como referencia

9.3 Pasos
^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 2.1
     - Crear carpeta ``requisitos/requisitos_negocio/`` si no existe
     - BA Lead
     - Carpeta creada
   * - 2.2
     - Identificar necesidades de stakeholders derivadas de BR
     - BA Lead
     - Lista necesidades
   * - 2.3
     - Asignar ID secuencial: BReq_001, BReq_002, ...
     - BA Lead
     - ID unico
   * - 2.4
     - Redactar enunciado: "El negocio NECESITA que..."
     - BA Lead
     - Enunciado formal
   * - 2.5
     - Documentar contexto y problema que resuelve
     - BA Lead
     - Justificacion
   * - 2.6
     - Identificar restricciones aplicables (BR que limitan)
     - BA Lead
     - Lista BR aplicables
   * - 2.7
     - Definir criterios de exito medibles
     - BA Lead
     - KPIs definidos
   * - 2.8
     - Establecer trazabilidad hacia arriba (BR) y abajo (UC)
     - BA Lead
     - Matriz trazabilidad
   * - 2.9
     - Agregar al index.rst del subdominio
     - BA Lead
     - Index actualizado
   * - 2.10
     - Aprobar con PO
     - PO
     - BReq aprobado

9.4 Estructura del Artefacto BReq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: rst

   .. meta::
      :artefacto: BReq_NNN
      :tipo: Requisito de Negocio
      :dominio: requisitos
      :subdominio: requisitos_negocio
      :estado: [Borrador|En Revision|Aprobado]

   .. _breq-nnn:

   ==============================================================================
   BReq_NNN: [Nombre Descriptivo]
   ==============================================================================

   1. Enunciado del Requisito
   --------------------------
   
   El negocio NECESITA que [actores] puedan [accion] para [objetivo],
   cumpliendo con [restricciones BR].

   2. Contexto
   -----------
   
   [Situacion actual, problema que resuelve]

   3. Restricciones Aplicables
   ---------------------------
   
   - BR_NNN: [Como limita]
   - BR_NNN: [Como limita]

   4. Criterios de Exito
   ---------------------
   
   - [KPI 1]: [Valor objetivo]
   - [KPI 2]: [Valor objetivo]

   5. Trazabilidad
   ---------------
   
   **Deriva de:** BR_NNN, BR_NNN
   **Implementado por:** UC_NNN → FR_NNN

9.5 Criterio de Salida Fase 2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Todos los BReq identificados estan documentados
- Cada BReq tiene al menos 1 BR como origen
- Cada BReq tiene al menos 1 UC como implementacion
- index.rst de requisitos_negocio actualizado

----

10. FASE 3: Crear Casos de Uso (UC)
-----------------------------------

10.1 Objetivo
^^^^^^^^^^^^^

Documentar las interacciones usuario-sistema que implementan los
requisitos de negocio.

10.2 Fuentes Normativas
^^^^^^^^^^^^^^^^^^^^^^^

- FND_03: Casos de Uso
- PARTE_2: Transformar BR en UC
- PARTE_3: Identificar UC Adicionales

10.3 Fuentes de UC
^^^^^^^^^^^^^^^^^^

Los UC provienen de multiples fuentes:

.. code-block:: text

   FUENTE 1: BR Tipo Desencadenador (22% de UC)
   ─────────────────────────────────────────────
   SI [condicion] ENTONCES [comportamiento observable]
   → Genera UC completo
   
   Ejemplo: BR "SI solicitud >$500 ENTONCES requiere aprobacion"
            → UC "Aprobar Solicitud"

   FUENTE 2: Tecnica CRUD (40% de UC)
   ──────────────────────────────────
   Por cada entidad del dominio:
   - Create → UC Crear [Entidad]
   - Read   → UC Consultar [Entidad], UC Ver Detalle [Entidad]
   - Update → UC Modificar [Entidad]
   - Delete → UC Desactivar [Entidad]
   
   Ejemplo: Entidad "Usuario"
            → UC Crear Usuario, UC Listar Usuarios, UC Modificar Usuario...

   FUENTE 3: Eventos del Sistema - Larman (15% de UC)
   ──────────────────────────────────────────────────
   Por cada actor, identificar eventos que genera:
   - Autenticacion, Sesiones, Notificaciones
   
   Ejemplo: Actor "Usuario"
            → UC Iniciar Sesion, UC Cerrar Sesion, UC Recuperar Contrasena

   FUENTE 4: Interfaz UI-Driven (15% de UC)
   ────────────────────────────────────────
   Mockups y prototipos revelan interacciones:
   - Dashboards, Filtros, Exportaciones
   
   Ejemplo: Mockup Dashboard
            → UC Consultar Dashboard, UC Filtrar Metricas, UC Exportar PDF

   FUENTE 5: Stakeholders Directos (8% de UC)
   ──────────────────────────────────────────
   Necesidades operacionales explicitas:
   - Reportes, Administracion, Auditoria

10.4 Pasos
^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 3.1
     - Crear carpeta ``requisitos/casos_uso/`` si no existe
     - BA Lead
     - Carpeta creada
   * - 3.2
     - Inventariar UC de todas las fuentes (BR, CRUD, Larman, UI, Stakeholders)
     - BA Lead
     - Lista completa UC
   * - 3.3
     - Eliminar duplicados y fusionar similares
     - BA Lead
     - Lista consolidada
   * - 3.4
     - Asignar ID secuencial: UC_001, UC_002, ...
     - BA Lead
     - IDs asignados
   * - 3.5
     - **[DECISION]** Elegir estructura: plana o con secciones
     - BA Lead + Arq
     - Estructura definida
   * - 3.6
     - Por cada UC: copiar TPL_Caso_Uso.rst
     - BA Lead
     - Archivos creados
   * - 3.7
     - Completar identificacion (ID, nombre, actor primario)
     - BA Lead
     - Identificacion OK
   * - 3.8
     - Redactar precondiciones y trigger
     - BA Lead
     - Contexto definido
   * - 3.9
     - Documentar flujo normal (3-10 pasos)
     - BA Lead
     - Happy path
   * - 3.10
     - Identificar y documentar flujos alternos
     - BA Lead
     - Alternos documentados
   * - 3.11
     - Documentar excepciones
     - BA Lead
     - Excepciones cubiertas
   * - 3.12
     - Redactar postcondiciones
     - BA Lead
     - Estado final definido
   * - 3.13
     - Agregar trazabilidad (BR origen, FR destino)
     - BA Lead
     - Links establecidos
   * - 3.14
     - Actualizar index.rst del subdominio
     - BA Lead
     - Index completo
   * - 3.15
     - Solicitar revision de Arquitecto
     - BA Lead
     - Revision solicitada
   * - 3.16
     - Aprobar con PO
     - PO
     - UC aprobado

10.5 Estructura del Artefacto UC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Segun FND_03:

.. code-block:: rst

   .. meta::
      :artefacto: UC_NNN
      :tipo: Caso de Uso
      :dominio: requisitos
      :subdominio: casos_uso
      :estado: [Borrador|En Revision|Aprobado]

   .. _uc-nnn:

   ==============================================================================
   UC_NNN: [Verbo] [Objeto]
   ==============================================================================

   1. Identificacion
   -----------------

   .. list-table::
      :widths: 25 75

      * - ID
        - UC_NNN
      * - Nombre
        - [Verbo + Objeto]
      * - Actor Primario
        - [Rol que inicia]
      * - Actores Secundarios
        - [Otros roles o "Ninguno"]
      * - Prioridad
        - [Critica|Alta|Media|Baja]

   2. Contexto
   -----------

   **Objetivo:** [Meta del actor]

   **Precondiciones:**

   1. [Condicion que debe ser verdadera ANTES]
   2. [Otra condicion]

   **Trigger:** [Evento que inicia el UC]

   3. Flujo Normal
   ---------------

   .. code-block:: text

      1. Actor [accion]
      2. Sistema [respuesta]
      3. Actor [accion]
      4. Sistema [respuesta]
      ...
      N. Sistema [estado final]

   4. Flujos Alternos
   ------------------

   **FA-1: [Nombre del alterno]**

   .. code-block:: text

      Xa. [Condicion que dispara]
      Xb. Sistema [accion alternativa]
      Xc. [Continua en paso Y | UC termina]

   5. Excepciones
   --------------

   **EX-1: [Nombre de la excepcion]**

   .. code-block:: text

      *a. [Error detectado]
      *b. Sistema [manejo del error]
      *c. UC termina

   6. Postcondiciones
   ------------------

   **Exito:**
   - [Estado del sistema tras ejecucion exitosa]

   **Fallo:**
   - [Estado del sistema si UC falla]

   7. Reglas de Negocio Aplicadas
   ------------------------------

   - BR_NNN: [Como se aplica en este UC]

   8. Trazabilidad
   ---------------

   **Deriva de:** BReq_NNN
   **Genera:** FR_NNN_01, FR_NNN_02, ...

10.6 Decision: Estructura Plana vs Secciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Segun DEFINICIONES_OFICIALES v2.0.0, Seccion 4:

.. code-block:: text

   OPCION A: ESTRUCTURA PLANA (por defecto)
   ─────────────────────────────────────────
   casos_uso/
   ├── index.rst
   ├── UC_001_Iniciar_Sesion.rst
   ├── UC_002_Cerrar_Sesion.rst
   ├── ...
   └── UC_042_Gestionar_Permisos.rst
   
   Usar cuando: <30 UC

   OPCION B: ESTRUCTURA CON SECCIONES (permitido si >30 UC)
   ────────────────────────────────────────────────────────
   casos_uso/
   ├── index.rst
   ├── autenticacion/           ← SECCION (NO es subcarpeta)
   │   ├── UC_001_Iniciar_Sesion.rst
   │   ├── UC_002_Cerrar_Sesion.rst
   │   └── ...
   ├── usuarios/                ← SECCION
   │   ├── UC_010_Crear_Usuario.rst
   │   └── ...
   └── dashboard/               ← SECCION
       └── UC_050_Consultar.rst
   
   Usar cuando: >30 UC y mejora legibilidad
   
   NOTA: Secciones NO introducen nuevo prefijo,
         NO requieren descongelamiento,
         Owner puede crearlas libremente.

10.7 Criterio de Salida Fase 3
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Todos los UC identificados estan documentados
- Cada UC sigue estructura FND_03
- Cada UC tiene trazabilidad a BReq/BR
- index.rst de casos_uso actualizado
- Estructura (plana o secciones) aprobada

----

11. FASE 4: Derivar Requisitos Funcionales (FR)
-----------------------------------------------

11.1 Objetivo
^^^^^^^^^^^^^

Derivar requisitos funcionales atomicos y verificables de cada paso
de los casos de uso.

11.2 Fuentes Normativas
^^^^^^^^^^^^^^^^^^^^^^^

- FND_06: Derivacion vs Transformacion
- FND_07: Requisitos Funcionales SMART
- PARTE_4: Especificar FR

11.3 Principio Fundamental
^^^^^^^^^^^^^^^^^^^^^^^^^^

Segun FND_06:

.. code-block:: text

   DERIVAR (correcto):
   - Hacer explicito lo IMPLICITO
   - Los FR ya estan DENTRO del UC
   - Solo se documentan atomicamente
   
   NO TRANSFORMAR (incorrecto):
   - NO estamos convirtiendo en algo diferente
   - NO estamos inventando nuevos requisitos

11.4 Pasos
^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 4.1
     - Crear carpeta ``requisitos/requisitos_funcionales/`` si no existe
     - BA Lead
     - Carpeta creada
   * - 4.2
     - Seleccionar UC aprobado para derivar FR
     - BA Lead
     - UC seleccionado
   * - 4.3
     - Por cada paso del Flujo Normal donde SISTEMA actua:
     - BA Lead
     - Lista pasos
   * - 4.4
     - Identificar capacidades IMPLICITAS en el paso
     - BA Lead
     - Capacidades listadas
   * - 4.5
     - Por cada capacidad, crear FR atomico
     - BA Lead
     - FR creados
   * - 4.6
     - Asignar ID: FR_[UC]_NN (ej: FR_001_01, FR_001_02)
     - BA Lead
     - IDs asignados
   * - 4.7
     - Redactar enunciado SMART
     - BA Lead
     - Enunciado formal
   * - 4.8
     - Definir criterio de aceptacion verificable
     - BA Lead
     - Criterio definido
   * - 4.9
     - Repetir para Flujos Alternos y Excepciones
     - BA Lead
     - FR alternos
   * - 4.10
     - Establecer trazabilidad UC.paso → FR
     - BA Lead
     - Links establecidos
   * - 4.11
     - Actualizar index.rst del subdominio
     - BA Lead
     - Index actualizado
   * - 4.12
     - Aprobar con PO
     - PO
     - FR aprobados

11.5 Proceso de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC_001: Iniciar Sesion
   
   Paso 3: "Sistema valida credenciales"
           │
           │ ANALISIS: ¿Que capacidades implica?
           │
           ├─► Capacidad 1: Verificar que usuario existe
           │   → FR_001_01: Sistema DEBE verificar existencia de username en BD
           │
           ├─► Capacidad 2: Comparar password
           │   → FR_001_02: Sistema DEBE comparar password hasheado con bcrypt
           │
           ├─► Capacidad 3: Verificar cuenta activa
           │   → FR_001_03: Sistema DEBE verificar que cuenta.estado = 'activo'
           │
           └─► Capacidad 4: Manejar credenciales invalidas
               → FR_001_04: SI credenciales invalidas, Sistema DEBE incrementar
                            contador de intentos fallidos
               → FR_001_05: SI intentos >= 5, Sistema DEBE bloquear cuenta 30 min

   1 paso UC → 5 FR atomicos

11.6 Estructura del Artefacto FR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Segun FND_07:

.. code-block:: rst

   .. meta::
      :artefacto: FR_NNN_NN
      :tipo: Requisito Funcional
      :dominio: requisitos
      :subdominio: requisitos_funcionales
      :estado: [Borrador|En Revision|Aprobado]

   .. _fr-nnn-nn:

   ==============================================================================
   FR_NNN_NN: [Nombre Descriptivo]
   ==============================================================================

   1. Enunciado
   ------------

   El sistema DEBE [verbo] [objeto] [condicion].

   2. Criterios SMART
   ------------------

   - **S** (Specific): [Por que es especifico]
   - **M** (Measurable): [Como se mide]
   - **A** (Achievable): [Por que es alcanzable]
   - **R** (Relevant): [Relacion con objetivo negocio]
   - **T** (Traceable): [Link a UC origen]

   3. Criterio de Aceptacion
   -------------------------

   DADO [precondicion]
   CUANDO [accion]
   ENTONCES [resultado esperado]

   4. Trazabilidad
   ---------------

   **Deriva de:** UC_NNN, Paso N
   **Prueba:** TC_NNN_NN

11.7 Ratio Esperado
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RATIO UC:FR TIPICO
   
   UC simple (CRUD):     1 UC → 8-15 FR
   UC medio (workflow):  1 UC → 15-30 FR
   UC complejo (segur.): 1 UC → 30-50 FR
   
   EJEMPLO IACT:
   42 UC × 12 FR/UC promedio = ~500 FR

11.8 Criterio de Salida Fase 4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Todos los UC aprobados tienen FR derivados
- Cada FR cumple criterios SMART
- Cada FR tiene criterio de aceptacion
- Trazabilidad UC → FR establecida
- index.rst de requisitos_funcionales actualizado

----

12. FASE 5: Actualizar RTM
--------------------------

12.1 Objetivo
^^^^^^^^^^^^^

Mantener la matriz de trazabilidad actualizada con todas las relaciones.

12.2 Pasos
^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 5 50 25 20

   * - #
     - Accion
     - Responsable
     - Salida
   * - 5.1
     - Abrir ``requisitos/rtm/RTM_01_Matriz_Trazabilidad_Global.rst``
     - BA Lead
     - Archivo abierto
   * - 5.2
     - Agregar filas para nuevos BR
     - BA Lead
     - BR en RTM
   * - 5.3
     - Agregar filas para nuevos BReq
     - BA Lead
     - BReq en RTM
   * - 5.4
     - Agregar filas para nuevos UC
     - BA Lead
     - UC en RTM
   * - 5.5
     - Agregar columnas FR para cada UC
     - BA Lead
     - FR en RTM
   * - 5.6
     - Verificar que no hay artefactos huerfanos
     - BA Lead
     - Validacion OK
   * - 5.7
     - Calcular metricas de cobertura
     - BA Lead
     - Metricas calculadas
   * - 5.8
     - Aprobar RTM actualizada
     - PO
     - RTM aprobada

12.3 Estructura RTM
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌──────────┬──────────┬───────────┬──────────┬─────────────────┬──────────┐
   │ CNST     │ BR       │ BReq      │ UC       │ FR              │ TST      │
   ├──────────┼──────────┼───────────┼──────────┼─────────────────┼──────────┤
   │ CNST_003 │ BR_001   │ BReq_001  │ UC_050   │ FR_050_01..05   │ TST_050  │
   │ CNST_004 │ BR_002   │ BReq_001  │ UC_050   │ FR_050_06..10   │ TST_050  │
   │ CNST_004 │ BR_002   │ BReq_002  │ UC_070   │ FR_070_01..08   │ TST_070  │
   │ CNST_005 │ BR_003   │ BReq_003  │ UC_010   │ FR_010_01..15   │ TST_010  │
   │ CNST_005 │ BR_003   │ BReq_003  │ UC_020   │ FR_020_01..12   │ TST_020  │
   └──────────┴──────────┴───────────┴──────────┴─────────────────┴──────────┘

----

13. Metricas de Proceso
-----------------------

13.1 Metricas de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   METRICA 1: Cobertura BR → UC
   ────────────────────────────
   Formula: (BR con al menos 1 UC) / (Total BR) × 100%
   Objetivo: 100%
   
   METRICA 2: Cobertura UC → FR
   ────────────────────────────
   Formula: (UC con al menos 3 FR) / (Total UC) × 100%
   Objetivo: 100%
   
   METRICA 3: Ratio FR/UC
   ──────────────────────
   Formula: (Total FR) / (Total UC)
   Objetivo: 8-15 para UC simples, 15-30 para complejos
   
   METRICA 4: Artefactos Huerfanos
   ───────────────────────────────
   Formula: Artefactos sin trazabilidad hacia arriba
   Objetivo: 0

13.2 Tiempos Estimados
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   TIEMPO POR ARTEFACTO:
   
   - BR:    30-60 min (incluye revision)
   - BReq:  45-90 min (incluye revision)
   - UC:    60-120 min (incluye flujos alternos)
   - FR:    10-20 min cada uno
   
   TIEMPO TOTAL ESTIMADO (42 UC):
   
   - Fase 0: 2 horas
   - Fase 1: 3 BR × 45 min = 2.5 horas
   - Fase 2: 3 BReq × 60 min = 3 horas
   - Fase 3: 42 UC × 90 min = 63 horas (~8 dias)
   - Fase 4: 500 FR × 15 min = 125 horas (~16 dias)
   - Fase 5: 4 horas
   
   TOTAL: ~200 horas (~5 semanas)

----

14. Checklist de Validacion Final
---------------------------------

.. code-block:: text

   FASE 0: CNST
   □ Restricciones CNST existen y estan aprobadas
   □ Mapeo CNST → BR identificado

   FASE 1: BR
   □ Todos los BR tienen estado "Aprobado"
   □ Cada BR tiene tipo clasificado
   □ Cada BR tiene fuente documentada
   □ index.rst de reglas_negocio actualizado

   FASE 2: BReq
   □ Todos los BReq derivan de al menos 1 BR
   □ Cada BReq tiene criterios de exito
   □ index.rst de requisitos_negocio actualizado

   FASE 3: UC
   □ Todos los UC siguen estructura FND_03
   □ Cada UC tiene actor primario definido
   □ Cada UC tiene flujo normal de 3-10 pasos
   □ Cada UC tiene al menos 1 flujo alterno
   □ Cada UC tiene postcondiciones
   □ Estructura (plana/secciones) aprobada
   □ index.rst de casos_uso actualizado

   FASE 4: FR
   □ Cada UC tiene al menos 3 FR derivados
   □ Cada FR cumple criterios SMART
   □ Cada FR tiene criterio de aceptacion
   □ index.rst de requisitos_funcionales actualizado

   FASE 5: RTM
   □ Todos los artefactos estan en RTM
   □ No hay artefactos huerfanos
   □ Metricas de cobertura = 100%

----

15. Historial de Cambios
------------------------

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
     - Creacion inicial del procedimiento completo

----

Referencias
-----------

- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-05` - Jerarquia 4 Niveles
- :ref:`fnd-06` - Derivacion vs Transformacion
- :ref:`fnd-07` - Requisitos Funcionales
- DEFINICIONES_OFICIALES_MODELO_DOCUMENTAL_IACT_v2.0.0
- ARBOL_COMPLETO_IACT_v2.0.0
