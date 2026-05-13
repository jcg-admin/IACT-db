.. meta::
   :artefacto: PROC_Derivacion_FR_TST
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Derivacion
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-derivacion-fr-tst:

==========================================================
PROC_Derivacion_FR_TST: Derivacion de FR a Casos de Prueba
==========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Derivacion_FR_TST
   * - **Nombre**
     - Derivacion de Requisitos Funcionales a Casos de Prueba
   * - **Categoria**
     - Derivacion
   * - **Frecuencia**
     - Por cada modulo con FR completados
   * - **Duracion Estimada**
     - 2-4 horas por modulo
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece la metodologia para derivar Casos de Prueba (TST)
desde Requisitos Funcionales (FR). Garantiza cobertura completa de pruebas
para cada FR del sistema.

**Objetivo:** Trazabilidad FR -> TST y cobertura de verificacion al 100%.

**Ratio esperado:** 1 FR -> 1-2 TST

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Derivacion sistematica de TST desde FR existentes
- Sesiones de derivacion por modulo completo
- Verificacion de cobertura FR -> TST

2.2 No Aplica A
^^^^^^^^^^^^^^^

- TST sin FR padre (no permitido)
- Pruebas de NFR (procedimiento separado)
- Pruebas de performance o carga

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Tester
     - Ejecuta derivacion, genera TST
     - Escritura en pruebas/
   * - QA Lead
     - Valida cobertura y calidad
     - Lectura de FR, TST

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] FR del modulo generados y aprobados
- [ ] Cada FR tiene Criterio de Aceptacion (DADO/CUANDO/ENTONCES)
- [ ] Estructura /tmp/pruebas/[mod]/ creada
- [ ] TPL_TST revisado

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - FR_[ID].rst
     - Requisitos Funcionales del modulo
     - Si
   * - TPL_TST_Pruebas_1_0_0.rst
     - Template de TST
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Derivacion FR a TST
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Seleccionar modulo;
   :Listar FR del modulo;

   while (Mas FR?) is (si)
       :Abrir FR;
       :Extraer Criterio de Aceptacion;
       :Contar escenarios;
       
       if (Multiples escenarios?) then (si)
           :Crear 1 TST por escenario;
       else (no)
           :Crear 1 TST;
       endif
       
       :Ejecutar PROC_Generacion_TST;
   endwhile (no)

   :Calcular cobertura;
   :Generar index.rst;
   stop
   @enduml

6.2 Estrategia de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** Cada FR genera minimo 1 TST. Multiples escenarios = multiples TST.

**Tipos de TST por Tipo de FR:**

.. list-table::
   :widths: 25 25 50
   :header-rows: 1

   * - Tipo FR
     - Tipo TST
     - Ejemplo
   * - Validacion
     - Unitaria
     - test_valida_formato_username
   * - Proceso
     - Integracion
     - test_genera_token_jwt
   * - Interfaz
     - Funcional
     - test_muestra_formulario
   * - Datos
     - Unitaria
     - test_guarda_sesion_bd
   * - Auditoria
     - Integracion
     - test_registra_evento
   * - Seguridad
     - Funcional
     - test_bloquea_cuenta

6.3 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Listar FR del Modulo**

- **Responsable**: Tester
- **Accion**: Obtener lista de FR:

  .. code-block:: bash

     find funcionales/[mod] -name "FR_*.rst" | sort

- **Resultado**: Lista de FR a cubrir
- **Verificacion**: Cantidad correcta

**Paso 2: Analizar Criterio de Aceptacion**

- **Responsable**: Tester
- **Accion**: Extraer escenarios de cada FR:

  .. code-block:: text

     FR_UC001_03: Generar token JWT
     
     Escenario 1: Generacion exitosa
     DADO usuario autenticado
     CUANDO genera token
     ENTONCES token valido creado
     
     Escenario 2: Token unico
     DADO dos logins consecutivos
     CUANDO genera tokens
     ENTONCES cada token tiene jti diferente

- **Resultado**: Lista de escenarios = TST a crear
- **Verificacion**: Cada escenario identificado

**Paso 3: Mapear FR a TST**

- **Responsable**: Tester
- **Accion**: Crear mapeo FR -> TST:

  .. code-block:: text

     FR_UC001_01 -> TST_AUTH_001 (1 escenario)
     FR_UC001_02 -> TST_AUTH_002 (1 escenario)
     FR_UC001_03 -> TST_AUTH_003, TST_AUTH_004 (2 escenarios)
     FR_UC001_04 -> TST_AUTH_005 (1 escenario)
     FR_UC001_05 -> TST_AUTH_006 (1 escenario)

- **Resultado**: Mapeo completo
- **Verificacion**: Todos los FR mapeados

**Paso 4: Generar TST**

- **Responsable**: Tester
- **Accion**: Por cada TST, ejecutar PROC_Generacion_TST
- **Resultado**: Archivos TST creados
- **Verificacion**: TST en /tmp/pruebas/[mod]/

**Paso 5: Verificar Cobertura**

- **Responsable**: Tester
- **Accion**: Calcular cobertura:

  .. code-block:: text

     Cobertura MOD_Auth:
     - FR totales: 21
     - FR con TST: 21
     - TST totales: 25
     - Cobertura: 100%
     - Ratio: 1.19 TST/FR

- **Resultado**: Metricas de cobertura
- **Verificacion**: Cobertura >= 100%

**Paso 6: Generar Index del Modulo**

- **Responsable**: Tester
- **Accion**: Crear index.rst para pruebas:

  .. code-block:: rst

                               
     Casos de Prueba - MOD_Auth
                               
     
     .. toctree::
        :maxdepth: 1
     
        TST_AUTH_001_Validar_formato_username
        TST_AUTH_002_Verificar_credenciales
        TST_AUTH_003_Generar_token_exitoso
        TST_AUTH_004_Token_unico
        ...

- **Resultado**: Index creado
- **Verificacion**: Todos los TST listados

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - TST_[MOD]_[NNN].rst
     - Casos de Prueba (multiples)
     - /tmp/pruebas/[mod]/
   * - index.rst
     - Indice del modulo
     - /tmp/pruebas/[mod]/
   * - Matriz de cobertura
     - FR vs TST
     - Documento de trabajo

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Cada FR tiene al menos 1 TST
- [ ] Cobertura FR -> TST = 100%
- [ ] Index del modulo actualizado
- [ ] Metricas calculadas

----

9. Verificacion y Validacion
----------------------------

9.1 Matriz de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 15 15 15 15 20
   :header-rows: 1

   * - Modulo
     - FR
     - TST
     - Ratio
     - Cobertura
     - Estado
   * - MOD_Auth
     - 21
     - ~25
     - 1.2
     - 100%
     - Pendiente
   * - MOD_Users
     - 17
     - ~20
     - 1.2
     - 100%
     - Pendiente
   * - MOD_Access
     - 30
     - ~36
     - 1.2
     - 100%
     - Pendiente
   * - ...
     - ...
     - ...
     - ...
     - ...
     - ...

9.2 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] 100% de FR tienen TST asociado
- [ ] Ratio TST/FR entre 1.0 y 2.0
- [ ] Cada TST tiene codigo pytest
- [ ] Index lista todos los TST

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - FR sin Criterio de Aceptacion
     - Solicitar completar FR primero
   * - Cobertura < 100%
     - Identificar FR faltantes, generar TST
   * - Ratio > 2.0
     - Revisar si hay TST duplicados

----

11. Referencias
---------------

- PROC_Generacion_TST
- TPL_TST_Pruebas_1_0_0.rst
- RTM_FR_TST (cuando se genere)
- FND_04: Trazabilidad

----

12. Historial de Cambios
------------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.1.0
     - 2026-01-07
     - Equipo IACT
     - Version completa corregida
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial (incompleta)

----

*Documento version 1.1.0 - Proyecto IACT Dashboard Analytics*
