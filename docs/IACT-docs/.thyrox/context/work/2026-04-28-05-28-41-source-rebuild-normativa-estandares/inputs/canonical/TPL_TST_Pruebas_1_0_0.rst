.. meta::
   :artefacto: TPL_TST
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-tst:

===========================================
TPL_TST: Plantilla de Caso de Prueba v1.0.0
===========================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Casos de Prueba (TST)**
en el proyecto IACT. Los casos de prueba verifican que los Requisitos Funcionales (FR)
se implementen correctamente.

**Características:**

- Derivados de Requisitos Funcionales (FR)
- Formato de datos de prueba estructurado
- Resultados esperados verificables
- Trazabilidad completa hacia FR y UC
- Ratio aproximado: 1 FR → 1-2 TST

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)
- Framework de testing: pytest (recomendado)

**Ubicación:**

::

   evidencia/pruebas/[modulo]/TST_[MOD]_[NNN].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``TST_[MOD]_[NNN].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Completar datos de prueba y resultados esperados
5. Verificar trazabilidad hacia FR padre
6. Implementar código de prueba correspondiente
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   TST_[MOD]_[NNN]

   Donde:
   - TST: Prefijo fijo (Test)
   - [MOD]: Código de módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
   - [NNN]: Número secuencial de 3 dígitos (001-999)

**Ejemplos:**

::

   TST_AUTH_001  → Primer test del módulo Auth
   TST_AUTH_002  → Segundo test del módulo Auth
   TST_USR_015   → Test 15 del módulo Users
   TST_ACC_042   → Test 42 del módulo Access

**Nombre de Archivo:**

::

   TST_[MOD]_[NNN].rst

   Ejemplos:
   - TST_AUTH_001.rst
   - TST_USR_015.rst
   - TST_ACC_042.rst

----

Tipos de Prueba
---------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Tipo
     - Descripción
     - Ejemplo
   * - **Unitaria**
     - Verifica función/método aislado
     - Validar formato de username
   * - **Integración**
     - Verifica interacción entre componentes
     - Login completo con BD
   * - **Funcional**
     - Verifica comportamiento end-to-end
     - Flujo completo de UC
   * - **Regresión**
     - Verifica que cambios no rompan existente
     - Re-ejecutar suite tras cambio
   * - **Seguridad**
     - Verifica controles de seguridad
     - Intentos de acceso no autorizado
   * - **Rendimiento**
     - Verifica tiempos de respuesta
     - Tiempo de generación de reporte

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: TST_[MOD]_[NNN]
      :tipo: Caso de Prueba
      :dominio: evidencia
      :subdominio: pruebas/[modulo]
      :modulo: MOD_[Modulo]
      :fr_padre: FR_UC[MOD]_[NN]_[NN]
      :estado: [Diseñado|Implementado|Ejecutado|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _tst-[mod]-[nnn]:

                                               
   TST_[MOD]_[NNN]: [Nombre del Caso de Prueba]
                                               

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
        - TST_[MOD]_[NNN]
      * - **Nombre**
        - [Nombre descriptivo del caso de prueba]
      * - **Tipo**
        - [Unitaria|Integración|Funcional|Regresión|Seguridad|Rendimiento]
      * - **FR Verificado**
        - FR_UC[MOD]_[NN]_[NN]: [Nombre del FR]
      * - **Prioridad**
        - [Alta|Media|Baja]
      * - **Automatizado**
        - [Sí|No|Parcial]
      * - **Estado**
        - [Diseñado|Implementado|Ejecutado|Aprobado]

   ----

   1. Objetivo
   -----------

   [Descripción del objetivo del caso de prueba en 1-2 oraciones.
   Responde: ¿Qué se está verificando con esta prueba?]

   ----

   2. Precondiciones
   -----------------

   Antes de ejecutar esta prueba, verificar:

   - [ ] [Precondición 1: Estado del sistema requerido]
   - [ ] [Precondición 2: Datos de prueba disponibles]
   - [ ] [Precondición 3: Usuario/permisos configurados]
   - [ ] [Precondición 4: Dependencias activas]

   ----

   3. Datos de Prueba
   ------------------

   3.1 Datos de Entrada
   ^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 35 40
      :header-rows: 1

      * - Campo
        - Valor
        - Descripción
      * - [campo_1]
        - [valor_1]
        - [Descripción del dato]
      * - [campo_2]
        - [valor_2]
        - [Descripción del dato]
      * - [campo_n]
        - [valor_n]
        - [Descripción del dato]

   3.2 Datos de Contexto
   ^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Elemento
        - Valor/Estado
      * - Usuario de prueba
        - [username_test]
      * - Rol asignado
        - [agr_xxx]
      * - Centro/Segmento
        - [Centro de prueba]
      * - Fecha/Hora sistema
        - [Si es relevante]

   ----

   4. Pasos de Ejecución
   ---------------------

   .. list-table::
      :widths: 8 50 42
      :header-rows: 1

      * - Paso
        - Acción
        - Resultado Esperado
      * - 1
        - [Acción a realizar]
        - [Qué debe ocurrir]
      * - 2
        - [Siguiente acción]
        - [Qué debe ocurrir]
      * - 3
        - [Siguiente acción]
        - [Qué debe ocurrir]
      * - N
        - [Acción final]
        - [Resultado final esperado]

   ----

   5. Resultado Esperado
   ---------------------

   5.1 Criterio de Éxito
   ^^^^^^^^^^^^^^^^^^^^^

   La prueba es **EXITOSA** si:

   - [ ] [Criterio 1: Condición verificable]
   - [ ] [Criterio 2: Condición verificable]
   - [ ] [Criterio 3: Condición verificable]

   5.2 Criterio de Fallo
   ^^^^^^^^^^^^^^^^^^^^^

   La prueba es **FALLIDA** si:

   - [ ] [Condición de fallo 1]
   - [ ] [Condición de fallo 2]

   5.3 Datos de Salida Esperados
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 35 40
      :header-rows: 1

      * - Campo
        - Valor Esperado
        - Validación
      * - [campo_salida_1]
        - [valor_esperado_1]
        - [Cómo validar]
      * - [campo_salida_2]
        - [valor_esperado_2]
        - [Cómo validar]

   ----

   6. Código de Prueba
   -------------------

   6.1 Implementación pytest
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: python

      # tests/test_[modulo]/test_[nombre].py
      
      import pytest
      from apps.[modulo].services import [Service]
      
      
      class TestTST[MOD][NNN]:
                              
          TST_[MOD]_[NNN]: [Nombre del caso de prueba]
          
          Verifica: FR_UC[MOD]_[NN]_[NN]
                                        
          
          @pytest.fixture
          def setup_data(self):
              """Datos de prueba según sección 3."""
              return {
                  '[campo_1]': '[valor_1]',
                  '[campo_2]': '[valor_2]',
              }
          
          def test_[nombre_descriptivo](self, setup_data):
                                                          
              Pasos:
              1. [Paso 1]
              2. [Paso 2]
              
              Resultado esperado: [Descripción]
                                               
              # Arrange
              [preparación]
              
              # Act
              result = [acción]
              
              # Assert
              assert [condición_1], "Mensaje si falla"
              assert [condición_2], "Mensaje si falla"

   6.2 Comando de Ejecución
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: bash

      # Ejecutar este test específico
      pytest tests/test_[modulo]/test_[nombre].py::TestTST[MOD][NNN] -v
      
      # Ejecutar con coverage
      pytest tests/test_[modulo]/test_[nombre].py --cov=apps.[modulo]

   ----

   7. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **FR Verificado**
        - FR_UC[MOD]_[NN]_[NN]: [Nombre]
      * - **UC Relacionado**
        - UC_[MOD]_[NN]: [Nombre]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **CNST Verificadas**
        - CNST_[NNN], CNST_[NNN]

   ----

   8. Registro de Ejecución
   ------------------------

   .. list-table::
      :widths: 12 12 15 15 46
      :header-rows: 1

      * - Fecha
        - Ejecutor
        - Resultado
        - Build
        - Observaciones
      * - [YYYY-MM-DD]
        - [Nombre]
        - [PASS|FAIL]
        - [#build]
        - [Notas de la ejecución]

   ----

   9. Defectos Relacionados
   ------------------------

   .. list-table::
      :widths: 15 50 20 15
      :header-rows: 1

      * - ID Defecto
        - Descripción
        - Estado
        - Severidad
      * - [DEF-NNN]
        - [Descripción del defecto encontrado]
        - [Abierto|Cerrado]
        - [Alta|Media|Baja]

   ----

   10. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Versión
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Versión inicial

   ----

   *Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada TST DEBE incluir mínimo estas 10 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, tipo, FR verificado, estado
   * - 1
     - Objetivo
     - Qué se verifica
   * - 2
     - Precondiciones
     - Checklist antes de ejecutar
   * - 3
     - Datos de Prueba
     - Entrada y contexto
   * - 4
     - Pasos de Ejecución
     - Acciones y resultados esperados
   * - 5
     - Resultado Esperado
     - Criterios éxito/fallo, datos salida
   * - 6
     - Código de Prueba
     - Implementación pytest
   * - 7
     - Trazabilidad
     - FR, UC, BR, CNST relacionados
   * - 8
     - Registro de Ejecución
     - Historial de ejecuciones
   * - 9
     - Defectos Relacionados
     - Bugs encontrados
   * - 10
     - Historial
     - Control de versiones

----

Convenciones pytest
-------------------

**Estructura de archivos:**

::

   tests/
   ├── conftest.py                    # Fixtures compartidas
   ├── test_auth/
   │   ├── test_login.py              # TST_AUTH_001 a TST_AUTH_010
   │   ├── test_logout.py             # TST_AUTH_011 a TST_AUTH_020
   │   └── test_password.py           # TST_AUTH_021 a TST_AUTH_030
   ├── test_users/
   │   └── ...
   └── test_access/
       └── ...

**Nomenclatura de funciones:**

::

   def test_[accion]_[condicion]_[resultado_esperado]():
   
   Ejemplos:
   - test_login_valid_credentials_returns_token()
   - test_login_invalid_password_returns_401()
   - test_create_user_duplicate_username_raises_error()

----

Validación
----------

Antes de aprobar un TST, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura TST_[MOD]_[NNN]
- [ ] FR padre existe y está referenciado
- [ ] Tipo de prueba clasificado
- [ ] Precondiciones son verificables
- [ ] Datos de prueba completos
- [ ] Pasos de ejecución claros
- [ ] Criterios de éxito/fallo definidos
- [ ] Código pytest implementado
- [ ] Trazabilidad completa

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/
   
   # Ejecutar tests
   pytest tests/ -v --tb=short

----

Referencias
-----------

- FND_07: Requerimientos Funcionales (FR que se verifican)
- TPL_FR: Plantilla de FR (para entender criterios)
- STD_006: Versionado Semántico
- pytest: https://docs.pytest.org/

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
     - Versión inicial de plantilla TST con pytest
