.. meta::
   :artefacto: TXM_01
   :tipo: Taxonomia
   :dominio: base_cognitiva
   :subdominio: _taxonomias_y_metamodelos
   :subcarpeta: taxonomias
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _txm-01:

===============================
TXM_01: Taxonomia de Requisitos
===============================


Proposito
---------

Este documento presenta la **clasificacion jerarquica** de todos los tipos
de requisitos utilizados en el proyecto IACT. Define categorias, subtipos
y criterios de clasificacion.

.. note::

   **Taxonomia vs Metamodelo:**

   - Taxonomia (TXM): Clasifica conceptos en categorias jerarquicas
   - Metamodelo (MTM): Define estructura formal y relaciones (UML)

   Este documento es una TAXONOMIA (clasificacion jerarquica).

----

1. Vista General de la Taxonomia
--------------------------------

.. code-block:: text

   REQUISITO
   │
   ├── REQUISITO DE NEGOCIO (Business Requirement)
   │   │
   │   ├── Regla de Negocio (BR)
   │   │   ├── Hecho (Fact)
   │   │   ├── Restriccion (Constraint)
   │   │   ├── Desencadenador (Trigger)
   │   │   ├── Inferencia (Inference)
   │   │   └── Calculo (Calculation)
   │   │
   │   └── Objetivo de Negocio (BReq)
   │       ├── Objetivo Estrategico
   │       └── Objetivo Operacional
   │
   ├── REQUISITO DE USUARIO (User Requirement)
   │   │
   │   └── Caso de Uso (UC)
   │       ├── UC de Gestion
   │       ├── UC de Consulta
   │       ├── UC de Proceso
   │       └── UC de Sistema
   │
   ├── REQUISITO FUNCIONAL (Functional Requirement)
   │   │
   │   └── FR por Categoria
   │       ├── FR de Validacion
   │       ├── FR de Procesamiento
   │       ├── FR de Presentacion
   │       ├── FR de Integracion
   │       └── FR de Seguridad
   │
   ├── REQUISITO NO FUNCIONAL (Non-Functional Requirement)
   │   │
   │   ├── Calidad de Producto
   │   │   ├── Rendimiento
   │   │   ├── Seguridad
   │   │   ├── Usabilidad
   │   │   └── Confiabilidad
   │   │
   │   └── Calidad de Proceso
   │       ├── Mantenibilidad
   │       ├── Portabilidad
   │       └── Compatibilidad
   │
   └── RESTRICCION (Constraint)
       │
       ├── Restriccion Tecnica
       ├── Restriccion de Negocio
       └── Restriccion Regulatoria

----

2. Nivel 0: Requisitos de Negocio
---------------------------------

2.1 Reglas de Negocio (BR)
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Declaraciones que definen o restringen algun aspecto del
negocio, independientes del sistema de software.

**Prefijo:** BR_NNN

**Subtipos:**

.. list-table::
   :header-rows: 1
   :widths: 20 35 45

   * - Subtipo
     - Definicion
     - Ejemplo IACT
   * - **Hecho**
     - Verdad sobre el dominio que estructura el modelo
     - "Cada usuario pertenece a exactamente un segmento"
   * - **Restriccion**
     - Limitacion obligatoria sobre comportamiento
     - "Solo R001 puede crear usuarios"
   * - **Desencadenador**
     - Condicion que genera accion observable
     - "Si metrica > umbral, notificar destinatarios"
   * - **Inferencia**
     - Condicion que genera nuevo hecho interno
     - "Si 90 dias sin login, marcar inactivo"
   * - **Calculo**
     - Formula o algoritmo de negocio
     - "Tasa abandono = abandonadas / total * 100"

**Criterio de Clasificacion:**

.. code-block:: text

   ¿La regla describe una verdad del dominio?
       SI → HECHO
       NO → Continuar

   ¿La regla limita lo que puede/no puede hacerse?
       SI → RESTRICCION
       NO → Continuar

   ¿La regla tiene formato SI...ENTONCES?
       SI → ¿El ENTONCES es observable externamente?
           SI → DESENCADENADOR
           NO → INFERENCIA
       NO → Continuar

   ¿La regla define una formula o algoritmo?
       SI → CALCULO
       NO → Revisar clasificacion

2.2 Objetivos de Negocio (BReq)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Metas de alto nivel que justifican la existencia del proyecto.

**Prefijo:** BReq_NNN

**Subtipos:**

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Subtipo
     - Descripcion
   * - **Estrategico**
     - Alineado con vision organizacional, largo plazo
   * - **Operacional**
     - Mejora de procesos, corto/mediano plazo

**Ejemplo IACT:**

.. code-block:: text

   BReq_001 (Estrategico):
   "Proporcionar visibilidad en tiempo real de metricas IVR
    para mejorar la toma de decisiones operacionales"

   BReq_002 (Operacional):
   "Reducir tiempo de generacion de reportes de 4 horas a 5 minutos"

----

3. Nivel 2: Requisitos de Usuario
---------------------------------

3.1 Casos de Uso (UC)
^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Narrativas de interaccion actor-sistema para lograr un objetivo.

**Prefijo:** UC_NNN (UC-NNN en referencias cortas)

**Subtipos por Naturaleza:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Subtipo
     - Descripcion
     - Ejemplos IACT
   * - **UC de Gestion**
     - CRUD de entidades del sistema
     - UC-006 Crear Usuario, UC-010 Asignar Rol
   * - **UC de Consulta**
     - Visualizacion y busqueda de informacion
     - UC-017 Consultar Reporte, UC-025 Ver Dashboard
   * - **UC de Proceso**
     - Ejecucion de procesos de negocio
     - UC-022 Exportar CSV, UC-037 Configurar Alerta
   * - **UC de Sistema**
     - Procesos automaticos sin actor humano
     - UC-ETL Sincronizar Datos, UC-ALERT Evaluar Umbrales

**Subtipos por Dominio Funcional:**

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Dominio
     - Cantidad
     - Rango UC
   * - Gestion de Usuarios
     - 8
     - UC-005 a UC-011, UC-041, UC-042
   * - Reportes
     - 8
     - UC-017 a UC-024
   * - Dashboards
     - 6
     - UC-025 a UC-030
   * - Analisis
     - 5
     - UC-031 a UC-035
   * - Alertas
     - 5
     - UC-036 a UC-040
   * - Administracion
     - 6
     - UC-012 a UC-016, UC-043

----

4. Nivel 3: Requisitos Funcionales
----------------------------------

4.1 FR por Categoria
^^^^^^^^^^^^^^^^^^^^

**Definicion:** Especificaciones atomicas de capacidades del sistema.

**Prefijo:** FR-UC.SEQ (ejemplo: FR-10.5)

**Subtipos:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Categoria
     - Descripcion
     - Ejemplos
   * - **Validacion**
     - Verificar datos de entrada
     - FR-10.6 Validar SoD, FR-40.6 Validar CAS
   * - **Procesamiento**
     - Logica de negocio y calculos
     - FR-17.5 Calcular totales, FR-35.3 Agregar metricas
   * - **Presentacion**
     - Mostrar informacion al usuario
     - FR-25.1 Mostrar grafico, FR-17.8 Formatear reporte
   * - **Integracion**
     - Comunicacion con otros sistemas
     - FR-ETL.1 Leer BD IVR, FR-ETL.5 Insertar datos
   * - **Seguridad**
     - Control de acceso y auditoria
     - FR-05.3 Validar sesion, FR-05.8 Registrar accion

**Nomenclatura:**

.. code-block:: text

   FR-[UC].[SEQ]

   Donde:
   - UC:  Numero del Caso de Uso de origen (2-3 digitos)
   - SEQ: Secuencial dentro del UC (1-2 digitos)

   Ejemplos:
   - FR-10.1:  Primer FR del UC-010
   - FR-10.15: Decimoquinto FR del UC-010
   - FR-017.5: Quinto FR del UC-017

----

5. Requisitos No Funcionales
----------------------------

5.1 Calidad de Producto (ISO 25010)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CALIDAD DE PRODUCTO
   │
   ├── RENDIMIENTO (Performance)
   │   ├── Tiempo de respuesta
   │   ├── Throughput
   │   └── Utilizacion de recursos
   │
   ├── SEGURIDAD (Security)
   │   ├── Confidencialidad
   │   ├── Integridad
   │   ├── No repudio
   │   └── Autenticidad
   │
   ├── USABILIDAD (Usability)
   │   ├── Facilidad de aprendizaje
   │   ├── Eficiencia de uso
   │   └── Satisfaccion del usuario
   │
   └── CONFIABILIDAD (Reliability)
       ├── Disponibilidad
       ├── Tolerancia a fallos
       └── Recuperabilidad

**Ejemplos IACT:**

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Categoria
     - Ejemplo
   * - Rendimiento
     - "Consulta de reporte debe responder en < 2 segundos (P95)"
   * - Seguridad
     - "Sesiones expiran tras 30 minutos de inactividad"
   * - Usabilidad
     - "Dashboard debe cargar en < 3 segundos"
   * - Confiabilidad
     - "Sistema disponible 99.5% en horario laboral"

5.2 Calidad de Proceso
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CALIDAD DE PROCESO
   │
   ├── MANTENIBILIDAD (Maintainability)
   │   ├── Modularidad
   │   ├── Reusabilidad
   │   ├── Analizabilidad
   │   └── Testeabilidad
   │
   ├── PORTABILIDAD (Portability)
   │   ├── Adaptabilidad
   │   ├── Instalabilidad
   │   └── Reemplazabilidad
   │
   └── COMPATIBILIDAD (Compatibility)
       ├── Coexistencia
       └── Interoperabilidad

----

6. Restricciones
----------------

6.1 Tipos de Restricciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Prefijo:** CNST_NNN

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo
     - Descripcion
     - Ejemplo IACT
   * - **Tecnica**
     - Limitaciones de tecnologia o arquitectura
     - "BD origen MySQL solo lectura"
   * - **Negocio**
     - Politicas organizacionales
     - "Sin envio de correo electronico externo"
   * - **Regulatoria**
     - Leyes, normas, estandares
     - "Logs de auditoria inmutables (compliance)"

6.2 Restricciones IACT Conocidas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CNST_001: Sin Correo Electronico Externo
   Tipo:     Negocio
   Impacto:  Toda comunicacion via buzon interno

   CNST_002: BD IVR Solo Lectura
   Tipo:     Tecnica
   Impacto:  IACT no puede modificar fuente operacional

   CNST_003: Sesion Unica por Usuario
   Tipo:     Seguridad
   Impacto:  Una sola sesion activa permitida

   CNST_004: Auditoria Inmutable
   Tipo:     Regulatoria
   Impacto:  Logs no modificables ni eliminables

----

7. Matriz de Clasificacion
--------------------------

7.1 Por Nivel de Abstraccion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 20 25 20 20

   * - Nivel
     - Tipo
     - Prefijo
     - Pregunta
     - Estabilidad
   * - 0
     - Business Rule
     - BR\_
     - Por que restriccion?
     - Muy alta
   * - 1
     - Business Req.
     - BReq\_
     - Por que proyecto?
     - Alta
   * - 2
     - User Req.
     - UC\_
     - Que hace usuario?
     - Media
   * - 3
     - Functional Req.
     - FR-
     - Como sistema?
     - Baja
   * - -
     - Non-Functional
     - NFR\_
     - Que tan bien?
     - Variable
   * - -
     - Constraint
     - CNST\_
     - Que limita?
     - Muy alta

7.2 Por Origen
^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Origen
     - Tipos de Requisitos
     - Ejemplo
   * - **Externo**
     - BR (regulaciones), CNST (regulatorio)
     - Leyes, contratos, estandares
   * - **Organizacional**
     - BR (politicas), BReq, CNST (negocio)
     - Politicas internas, objetivos
   * - **Usuario**
     - UC, NFR (usabilidad)
     - Necesidades de stakeholders
   * - **Sistema**
     - FR, NFR (tecnico), CNST (tecnico)
     - Derivados de UC y arquitectura

7.3 Por Verificabilidad
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Metodo
     - Tipos de Requisitos
     - Descripcion
   * - **Inspeccion**
     - BR, CNST
     - Revision documental
   * - **Demostracion**
     - UC
     - Ejecutar caso de uso
   * - **Test**
     - FR, NFR
     - Pruebas automatizadas/manuales
   * - **Analisis**
     - BReq, NFR (rendimiento)
     - Metricas y mediciones

----

8. Estadisticas IACT
--------------------

8.1 Conteo por Tipo
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Tipo
     - Cantidad
     - Notas
   * - Business Rules (BR)
     - 6
     - Identificadas en analisis RBAC
   * - Casos de Uso (UC)
     - 38
     - Derivados de BR + CRUD + Larman
   * - Functional Req. (FR)
     - ~300 est.
     - Pendiente derivacion completa
   * - Non-Functional (NFR)
     - ~20 est.
     - Pendiente especificacion
   * - Constraints (CNST)
     - 4
     - Conocidas actualmente

8.2 Proporcion Tipica
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Proporcion esperada en proyecto bien especificado:

   BR    :  5-20   (pocas, estables)
   BReq  :  3-10   (objetivos de alto nivel)
   UC    : 30-100  (comportamientos observables)
   FR    :200-1000 (especificaciones atomicas)
   NFR   : 20-50   (atributos de calidad)
   CNST  :  5-15   (limitaciones)

   Ratio tipico UC:FR = 1:8 (cada UC genera ~8 FR promedio)

----

9. Criterios de Clasificacion
-----------------------------

9.1 Arbol de Decision
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ¿El requisito existe independiente del sistema?
   │
   ├─ SI → ¿Es una politica/regulacion/restriccion?
   │       │
   │       ├─ SI → BUSINESS RULE (BR)
   │       │       → Clasificar subtipo (Hecho/Restriccion/Trigger/...)
   │       │
   │       └─ NO → ¿Es un objetivo de negocio?
   │               │
   │               └─ SI → BUSINESS REQUIREMENT (BReq)
   │
   └─ NO → ¿Describe interaccion usuario-sistema?
           │
           ├─ SI → CASO DE USO (UC)
           │       → Clasificar por dominio funcional
           │
           └─ NO → ¿Es una capacidad atomica del sistema?
                   │
                   ├─ SI → ¿Describe QUE hace el sistema?
                   │       │
                   │       ├─ SI → FUNCTIONAL REQUIREMENT (FR)
                   │       │
                   │       └─ NO → ¿Describe QUE TAN BIEN lo hace?
                   │               │
                   │               └─ SI → NON-FUNCTIONAL (NFR)
                   │
                   └─ NO → ¿Es una limitacion impuesta?
                           │
                           └─ SI → CONSTRAINT (CNST)

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-07` - Requerimientos Funcionales
- :ref:`mtm-01` - Metamodelo de Requisitos (diagrama UML)

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830-1998: Software Requirements Specifications
- ISO/IEC 25010: Systems and Software Quality
- Karl Wiegers: "Software Requirements"

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
     - 2025-12-20
     - Equipo IACT
     - Version inicial con taxonomia completa

----

**Trazabilidad:** Esta taxonomia clasifica todos los tipos de requisitos
usados en IACT. Complementa :ref:`mtm-01` que define las relaciones
formales entre estos tipos. Es referenciada por todos los artefactos
en el dominio requisitos/.
