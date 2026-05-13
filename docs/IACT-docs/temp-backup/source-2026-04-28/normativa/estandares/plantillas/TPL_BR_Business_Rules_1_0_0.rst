.. meta::
   :artefacto: TPL_BR
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-br:

============================================
TPL_BR: Plantilla de Regla de Negocio v1.0.0
============================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Reglas de Negocio (BR)**
en el proyecto IACT siguiendo la metodología SBVR (Semantics of Business Vocabulary
and Business Rules).

**Características:**

- Formulación SBVR con vocabulario controlado
- Clasificación en 5 tipos según TXM_03
- Trazabilidad hacia CNST y UC
- Estructura de 8 secciones obligatorias

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicación:**

::

   requisitos/reglas_negocio/BR_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``BR_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Clasificar según TXM_03 (5 tipos)
5. Completar formulación SBVR
6. Verificar trazabilidad hacia CNST (si aplica)
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   BR_[NNN]

   Donde:
   - BR: Prefijo fijo (Business Rule)
   - [NNN]: Número secuencial de 3 dígitos (001-999)

**Ejemplos:**

::

   BR_001  → Primera regla de negocio
   BR_010  → Décima regla de negocio
   BR_016  → Regla de cálculo (Tasa de Abandono)

**Nombre de Archivo:**

::

   BR_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - BR_001_Fuente_Operacional_Inmutable.rst
   - BR_010_Auditoria_Inmutable.rst
   - BR_016_Tasa_Abandono.rst

----

Clasificación de BR (TXM_03)
----------------------------

Toda BR debe clasificarse en uno de estos 5 tipos:

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Tipo
     - Descripción
     - Ejemplo IACT
   * - **Restricción**
     - Limita valores, acciones o estados permitidos
     - BR_001: No modificar datos en fuente IVR
   * - **Desencadenador**
     - SI condición ENTONCES acción automática
     - BR_002: SI 2:00AM ENTONCES ejecutar ETL
   * - **Hecho**
     - Define verdad estructural del dominio
     - BR_006: El sistema usa RBAC flat
   * - **Inferencia**
     - Deriva nuevos hechos de existentes
     - BR_003: SI sin login 90d ENTONCES inactivo
   * - **Cálculo**
     - Define fórmula matemática
     - BR_016: Tasa = (Abandonadas/Total) × 100

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: BR_[NNN]
      :tipo: Regla de Negocio
      :dominio: requisitos
      :subdominio: reglas_negocio
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _br-[nnn]:

                                            
   BR_[NNN]: [Nombre de la Regla de Negocio]
                                            

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - BR_[NNN]
      * - **Nombre**
        - [Nombre descriptivo de la regla]
      * - **Tipo**
        - [Restricción|Desencadenador|Hecho|Inferencia|Cálculo]
      * - **Categoría**
        - [Seguridad|Datos|Operacional|Auditoría|KPI]
      * - **Criticidad**
        - [Crítica|Alta|Media|Baja]
      * - **Estado**
        - Vigente

   ----

   1. Definición Formal
   --------------------

   1.1 Enunciado de la Regla
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. note:: **Regla de Negocio BR_[NNN]**

      [Enunciado claro y conciso de la regla en lenguaje natural.
      Debe ser comprensible para stakeholders no técnicos.]

   1.2 Formulación SBVR
   ^^^^^^^^^^^^^^^^^^^^

   .. code-block:: text

      VOCABULARIO:
        - [termino_1]: [Definición del término]
        - [termino_2]: [Definición del término]

      REGLA:
        Es [OBLIGATORIO|PROHIBIDO|PERMITIDO] que [sujeto] [verbo] [predicado].
        
        [Para Desencadenador:]
        SI [condición] ENTONCES [acción].
        
        [Para Cálculo:]
        [variable] ES IGUAL A [fórmula].

   1.3 Justificación
   ^^^^^^^^^^^^^^^^^

   [Por qué existe esta regla. Qué problema resuelve o qué riesgo mitiga.
   Incluir contexto de negocio si es necesario.]

   ----

   2. Clasificación
   ----------------

   2.1 Tipo de Regla
   ^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 0

      * - **Tipo**
        - **[Tipo seleccionado]**
      * - 
        - [ ] Restricción: Limita valores o acciones
      * - 
        - [ ] Desencadenador: SI/ENTONCES automático
      * - 
        - [ ] Hecho: Verdad estructural
      * - 
        - [ ] Inferencia: Deriva hechos
      * - 
        - [X] **[Tipo]**: [Descripción específica]

   2.2 Naturaleza
   ^^^^^^^^^^^^^^

   - **Estática/Dinámica**: [Estática - no cambia | Dinámica - depende de contexto]
   - **Automatizable**: [Sí - el sistema la aplica | No - requiere intervención]
   - **Alcance**: [MOD_xxx, MOD_yyy | Sistema completo]

   ----

   3. Origen y Autoridad
   ---------------------

   3.1 Fuente Primaria
   ^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Documento**
        - [CNST_NNN_Nombre.rst | Normativa externa | Decisión de diseño]
      * - **Sección**
        - [Sección específica del documento origen]
      * - **Versión**
        - [X.Y.Z]
      * - **Tipo Fuente**
        - [CNST|Normativa|Stakeholder|Técnica]

   3.2 Autoridad de Modificación
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Responsable**: [Rol o persona que puede modificar]
   - **Proceso de Cambio**: [PROC de cambio requerido]
   - **Frecuencia de Revisión**: [Anual|Semestral|Por evento]

   ----

   4. Aplicación en Sistema
   ------------------------

   4.1 Donde Aplica
   ^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Componente
        - Descripción de Aplicación
      * - UC_[MOD]_[NN]
        - [Cómo se aplica en este UC]
      * - UC_[MOD]_[NN]
        - [Cómo se aplica en este UC]

   4.2 Donde NO Aplica
   ^^^^^^^^^^^^^^^^^^^

   - [Contexto o componente donde esta regla no aplica]
   - [Excepciones documentadas]

   ----

   5. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **CNST Origen**
        - CNST_[NNN]: [Nombre] (si aplica)
      * - **BReq Relacionado**
        - BReq_[MOD]: [Nombre]
      * - **UC que Implementan**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **BR Relacionadas**
        - BR_[NNN], BR_[NNN] (si hay dependencias)

   ----

   6. Verificación
   ---------------

   6.1 Criterios de Cumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [ ] [Criterio verificable 1]
   - [ ] [Criterio verificable 2]
   - [ ] [Criterio verificable 3]

   6.2 Método de Verificación
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Tipo**: [Automático|Manual|Mixto]
   - **Frecuencia**: [Continuo|Diario|Por evento]
   - **Responsable**: [Rol que verifica]

   ----

   7. Implementación Técnica
   -------------------------

   7.1 Componentes Involucrados
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: text

      [Módulo/Clase/Función que implementa la regla]

   7.2 Código de Referencia
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: python

      # Ejemplo de implementación
      # BR_[NNN]: [Nombre de la regla]
      
      def [funcion_que_implementa]():
                              
          Implementa BR_[NNN].
                              
          pass

   ----

   8. Historial de Cambios
   -----------------------

   .. list-table::
      :widths: 15 15 70
      :header-rows: 1

      * - Versión
        - Fecha
        - Descripción del Cambio
      * - 1.0.0
        - [YYYY-MM-DD]
        - Versión inicial

   ----

   *Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada BR DEBE incluir mínimo estas 8 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, tipo, categoría, criticidad
   * - 1
     - Definición Formal
     - Enunciado, formulación SBVR, justificación
   * - 2
     - Clasificación
     - Tipo TXM_03, naturaleza, alcance
   * - 3
     - Origen y Autoridad
     - Fuente primaria, autoridad de cambio
   * - 4
     - Aplicación en Sistema
     - Donde aplica y donde NO aplica
   * - 5
     - Trazabilidad
     - CNST, BReq, UC relacionados
   * - 6
     - Verificación
     - Criterios y método de cumplimiento
   * - 7
     - Implementación Técnica
     - Componentes y código de referencia
   * - 8
     - Historial
     - Control de versiones de la BR

----

Formulación SBVR por Tipo
-------------------------

**Restricción:**

.. code-block:: text

   Es OBLIGATORIO que [sujeto] [no] [verbo] [objeto].
   Es PROHIBIDO que [sujeto] [verbo] [objeto].
   
   Ejemplo:
   Es OBLIGATORIO que el sistema NO modifique datos en la base IVR.

**Desencadenador:**

.. code-block:: text

   SI [condición] ENTONCES [acción].
   
   Ejemplo:
   SI son las 2:00 AM ENTONCES el sistema ejecuta proceso ETL.

**Hecho:**

.. code-block:: text

   [Sujeto] [es/tiene/usa] [predicado].
   
   Ejemplo:
   El sistema IACT usa modelo RBAC flat sin jerarquía.

**Inferencia:**

.. code-block:: text

   SI [hecho_existente] ENTONCES [hecho_derivado].
   
   Ejemplo:
   SI usuario no tiene login en 90 días ENTONCES usuario es inactivo.

**Cálculo:**

.. code-block:: text

   [Variable] ES IGUAL A [fórmula].
   
   Ejemplo:
   Tasa_Abandono ES IGUAL A (Llamadas_Abandonadas / Total_Llamadas) × 100.

----

Validación
----------

Antes de aprobar una BR, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura BR_[NNN]
- [ ] Tipo clasificado según TXM_03
- [ ] Formulación SBVR completa
- [ ] Justificación documentada
- [ ] CNST referenciado (si deriva de restricción técnica)
- [ ] UC de aplicación listados
- [ ] Criterios de verificación definidos
- [ ] Historial de cambios iniciado

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- FND_02: Reglas de Negocio (definición conceptual)
- TXM_03: Taxonomía de Reglas de Negocio (5 tipos)
- SBVR_01-05: Ontología SBVR del proyecto
- STD_006: Versionado Semántico
- CNST_001-010: Restricciones arquitectónicas

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial de plantilla BR con metodología SBVR
