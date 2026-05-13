.. meta::
   :artefacto: PROC_Derivacion_FR_CODE
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Derivacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-derivacion-fr-code:

==================================================
PROC_Derivacion_FR_CODE: Derivacion de FR a Codigo
==================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Derivacion_FR_CODE
   * - **Nombre**
     - Derivacion de Requisitos Funcionales a Codigo
   * - **Categoria**
     - Derivacion
   * - **Ratio**
     - 1 FR -> N archivos/funciones
   * - **Duracion**
     - Variable segun complejidad

----

1. Proposito
------------

Establecer la trazabilidad entre Requisitos Funcionales (FR) y el
codigo que los implementa, permitiendo verificar cobertura de implementacion.

----

2. Alcance
----------

**Aplica A:** Mapeo FR -> codigo Python/Django.

**No Aplica A:** Codigo de infraestructura, configuracion.

----

3. Estructura de Codigo IACT
----------------------------

::

   apps/
   ├── auth/
   │   ├── views.py      <- FR de autenticacion
   │   ├── services.py   <- Logica de negocio
   │   └── serializers.py
   ├── users/
   │   ├── views.py      <- FR de usuarios
   │   └── ...
   └── ...

----

4. Procedimiento
----------------

**Paso 1: Identificar FR a Implementar**

Seleccionar FR del modulo a desarrollar.

**Paso 2: Determinar Componentes**

Mapear FR a componentes de codigo:

.. code-block:: text

   FR_UC001_03: Generar token JWT
   
   Componentes:
   - apps/auth/services.py::JWTService.generate_token()
   - apps/auth/views.py::LoginView.post()

**Paso 3: Implementar Codigo**

Desarrollar siguiendo el FR como especificacion.

**Paso 4: Documentar Trazabilidad**

En docstring del codigo, referenciar FR:

.. code-block:: python

   def generate_token(self, user):
                                  
       Genera token JWT para usuario autenticado.
       
       Implements: FR_UC001_03
       BR: BR_005 (Sesion Unica)
                                
       ...

**Paso 5: Actualizar RTM_FR_CODE**

Registrar mapeo en matriz de trazabilidad.

----

5. Matriz de Trazabilidad
-------------------------

.. list-table::
   :header-rows: 1

   * - FR
     - Archivo
     - Funcion/Clase
   * - FR_UC001_01
     - auth/serializers.py
     - LoginSerializer.validate_username
   * - FR_UC001_02
     - auth/services.py
     - AuthService.verify_credentials
   * - FR_UC001_03
     - auth/services.py
     - JWTService.generate_token

----

6. Artefactos de Salida
-----------------------

- Codigo implementado con docstrings
- RTM_FR_CODE actualizada

----

7. Verificacion
---------------

- [ ] Cada FR tiene codigo asociado
- [ ] Docstrings referencian FR
- [ ] RTM_FR_CODE completa
- [ ] TST del FR pasan

----

8. Referencias
--------------

- PROC_Generacion_FR
- PROC_Generacion_RTM
- STD_004: Convenciones Python

----

9. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*
