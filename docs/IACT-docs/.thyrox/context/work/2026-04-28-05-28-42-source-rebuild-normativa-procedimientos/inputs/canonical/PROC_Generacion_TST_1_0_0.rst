.. meta::
   :artefacto: PROC_Generacion_TST
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-generacion-tst:

==================================================
PROC_Generacion_TST: Generacion de Casos de Prueba
==================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_TST
   * - **Nombre**
     - Generacion de Casos de Prueba
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada FR a verificar
   * - **Duracion Estimada**
     - 15-30 minutos por TST
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Casos de Prueba (TST)
a partir de Requisitos Funcionales (FR). Cada TST verifica que un FR
se implementa correctamente.

**Objetivo:** Crear TST completos con codigo pytest ejecutable que
garanticen la verificacion de cada FR.

**Ratio esperado:** 1 FR -> 1-2 TST

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Generacion de TST derivados de FR existentes
- Pruebas de todos los tipos (Unitaria, Integracion, Funcional, etc.)
- TST de todos los modulos IACT

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Pruebas no funcionales (NFR) - procedimiento separado
- Pruebas de rendimiento - herramientas especializadas
- TST sin FR padre (no permitido)

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
     - Genera TST siguiendo TPL
     - Escritura en pruebas/
   * - Desarrollador
     - Revisa codigo pytest
     - Lectura de TST

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] FR origen existe y esta aprobado
- [ ] PROC_Revision_TPL_Previo_Generacion ejecutado (TPL_TST)
- [ ] Criterio de Aceptacion del FR disponible (DADO/CUANDO/ENTONCES)
- [ ] Estructura de directorios /tmp/pruebas/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_TST_Pruebas_1_0_0.rst
     - Template de TST
     - Si
   * - FR_[ID].rst
     - Requisito Funcional origen
     - Si
   * - UC_[NNN].rst
     - Caso de Uso relacionado
     - No

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Generacion de TST
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
       DiamondBackgroundColor #FFF9C4
       DiamondBorderColor #F57C00
   }

   start

   :Abrir FR origen;
   :Extraer Criterio de Aceptacion;

   :Copiar plantilla TPL_TST;
   :Completar Identificacion;
   :Definir Precondiciones;
   :Especificar Datos de Prueba;
   :Definir Pasos de Ejecucion;
   :Especificar Resultado Esperado;

   :Escribir codigo pytest;
   note right: Basado en DADO/CUANDO/ENTONCES

   :Guardar en /tmp/pruebas/;
   :Validar sintaxis RST;
   :Ejecutar pytest (si posible);

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Extraer Informacion del FR**

- **Responsable**: Tester
- **Accion**: Del FR origen, extraer:

  1. ID del FR
  2. Nombre del FR
  3. UC padre
  4. Criterio de Aceptacion (DADO/CUANDO/ENTONCES)
  5. BR aplicables

  .. code-block:: text

     Ejemplo FR_UC001_03:
     
     Criterio de Aceptacion:
     DADO un usuario con credenciales verificadas exitosamente
     CUANDO el sistema genera el token JWT
     ENTONCES se crea un token valido con toda la informacion requerida

- **Resultado**: Informacion para TST disponible
- **Verificacion**: Criterio de Aceptacion completo

**Paso 2: Determinar Nomenclatura del TST**

- **Responsable**: Tester
- **Accion**: Aplicar nomenclatura segun TPL_TST:

  .. code-block:: text

     Formato ID: TST_[MOD]_[NNN]
     
     Donde:
     - TST: Prefijo fijo
     - [MOD]: Codigo del modulo (AUTH, USR, ACC, etc.)
     - [NNN]: Numero secuencial de 3 digitos
     
     Ejemplos:
     - TST_AUTH_001
     - TST_AUTH_002
     - TST_USR_001

- **Resultado**: ID del TST definido
- **Verificacion**: ID unico en el modulo

**Paso 3: Copiar y Completar Plantilla**

- **Responsable**: Tester
- **Accion**: Desde TPL_TST, copiar seccion Plantilla y completar:

  **3.1 Seccion Resumen:**

  .. code-block:: rst

     * - **ID**
       - TST_AUTH_003
     * - **Nombre**
       - Verificar generacion de token JWT
     * - **Tipo**
       - Unitaria
     * - **FR Verificado**
       - FR_UC001_03
     * - **Automatizado**
       - Si
     * - **Estado**
       - Pendiente

  **3.2 Seccion Precondiciones:**

  .. code-block:: rst

     - [ ] Usuario de prueba existe en BD
     - [ ] Credenciales verificadas (mock o fixture)
     - [ ] SECRET_KEY configurada

  **3.3 Seccion Datos de Prueba:**

  .. code-block:: rst

     **Datos de Entrada:**
     
     - user_id: "uuid-test-001"
     - username: "test_user"
     - roles: ["ROL-003"]
     - segment_id: 1
     
     **Datos de Contexto:**
     
     - SECRET_KEY: "test-secret-key-256-bits"

- **Resultado**: Secciones de datos completas
- **Verificacion**: Datos suficientes para prueba

**Paso 4: Definir Pasos de Ejecucion**

- **Responsable**: Tester
- **Accion**: Convertir DADO/CUANDO/ENTONCES a pasos:

  .. code-block:: rst

     .. list-table::
        :widths: 10 50 40
        :header-rows: 1
     
        * - Paso
          - Accion
          - Resultado Esperado
        * - 1
          - Preparar usuario con credenciales verificadas
          - Objeto User disponible
        * - 2
          - Invocar metodo generate_jwt_token(user)
          - Token JWT retornado
        * - 3
          - Decodificar token
          - Payload contiene user_id, roles, exp

- **Resultado**: Pasos de ejecucion definidos
- **Verificacion**: Pasos son ejecutables

**Paso 5: Escribir Codigo pytest**

- **Responsable**: Tester
- **Accion**: Implementar prueba en Python:

  .. code-block:: python

     import pytest
     from datetime import datetime, timedelta
     from apps.auth.services import JWTService
     
     
     class TestGenerarTokenJWT:
         """TST_AUTH_003: Verificar generacion de token JWT."""
         
         @pytest.fixture
         def verified_user(self, db):
             """DADO un usuario con credenciales verificadas."""
             return User.objects.create(
                 username="test_user",
                 is_active=True
             )
         
         def test_genera_token_valido(self, verified_user):
                                                           
             CUANDO el sistema genera el token JWT
             ENTONCES se crea un token valido.
                                              
             # Arrange
             service = JWTService()
             
             # Act
             token = service.generate_token(verified_user)
             
             # Assert
             assert token is not None
             assert isinstance(token, str)
             assert len(token.split('.')) == 3  # Header.Payload.Signature
         
         def test_token_contiene_claims_requeridos(self, verified_user):
             """Verificar claims del token."""
             service = JWTService()
             token = service.generate_token(verified_user)
             payload = service.decode_token(token)
             
             assert 'sub' in payload  # user_id
             assert 'username' in payload
             assert 'roles' in payload
             assert 'exp' in payload
         
         def test_token_expira_en_8_horas(self, verified_user):
             """Verificar expiracion de 8 horas."""
             service = JWTService()
             token = service.generate_token(verified_user)
             payload = service.decode_token(token)
             
             exp = datetime.fromtimestamp(payload['exp'])
             expected = datetime.now() + timedelta(hours=8)
             
             # Tolerancia de 1 minuto
             assert abs((exp - expected).total_seconds()) < 60

- **Resultado**: Codigo pytest implementado
- **Verificacion**: Sintaxis Python valida

**Paso 6: Guardar y Validar**

- **Responsable**: Tester
- **Accion**: Guardar archivo y validar:

  .. code-block:: bash

     # Guardar TST
     /tmp/pruebas/auth/TST_AUTH_003_Generar_Token_JWT.rst
     
     # Validar RST
     sphinx-build -b html -W /tmp/pruebas/ /tmp/build/
     
     # Ejecutar pytest (si codigo disponible)
     pytest tests/test_auth/test_jwt.py -v

- **Resultado**: TST validado
- **Verificacion**: Sin errores de sintaxis

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - TST_[MOD]_[NNN]_[Nombre].rst
     - Caso de Prueba documentado
     - /tmp/pruebas/[mod]/
   * - test_[nombre].py
     - Codigo pytest (opcional)
     - tests/test_[mod]/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] TST creado con todas las secciones obligatorias
- [ ] Codigo pytest incluido (formato DADO/CUANDO/ENTONCES)
- [ ] Trazabilidad a FR completada
- [ ] Sintaxis RST validada

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue nomenclatura TST_[MOD]_[NNN]
- [ ] FR verificado especificado
- [ ] Tipo de prueba definido
- [ ] Precondiciones listadas
- [ ] Datos de prueba especificados
- [ ] Codigo pytest presente
- [ ] Criterios exito/fallo claros

9.2 Checklist de Secciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Verificar
   * - 1
     - Objetivo
     - Claro y relacionado con FR
   * - 2
     - Precondiciones
     - Checklist completo
   * - 3
     - Datos de Prueba
     - Entrada y contexto
   * - 4
     - Pasos de Ejecucion
     - Tabla accion/resultado
   * - 5
     - Resultado Esperado
     - Criterios exito/fallo
   * - 6
     - Codigo de Prueba
     - pytest implementado
   * - 7
     - Trazabilidad
     - FR, UC, BR enlazados

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
   * - Codigo no ejecutable
     - Documentar como "manual" temporalmente
   * - Multiples escenarios en un FR
     - Crear TST separado por escenario

----

11. Referencias
---------------

- TPL_TST_Pruebas_1_0_0.rst
- PROC_Derivacion_FR_TST
- pytest documentation: https://docs.pytest.org/
- FND_01: Concepto de Requisito

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
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
