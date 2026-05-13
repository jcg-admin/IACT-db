.. meta::
   :artefacto: SBVR_03
   :tipo: Ontologia
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: Business Analyst Lead
   :clasificacion: Interno

.. _ontologia-sbvr-index:
.. _sbvr_03_vocabulario_controlado:

================================
SBVR_03 · Vocabulario Controlado
================================

1. Propósito
------------

Este documento establece el vocabulario controlado para la especificación
de reglas de negocio en el proyecto IACT. Define los términos permitidos,
sus sinónimos aceptados y términos prohibidos, garantizando consistencia
y eliminando ambigüedad en la documentación de requisitos.

----------------------
2. Uso del Vocabulario
----------------------

2.1. Cuándo Consultar
^^^^^^^^^^^^^^^^^^^^^

Este documento debe consultarse:

- Al escribir nuevas reglas de negocio (BR_xxx)
- Al revisar reglas existentes
- Al especificar casos de uso (UC_xxx)
- Durante validación de requisitos

2.2. Reglas de Aplicación
^^^^^^^^^^^^^^^^^^^^^^^^^

- Usar siempre el término preferido (primera columna)
- Los sinónimos son aceptables pero el término preferido es mejor
- Los términos prohibidos no deben usarse nunca
- Si se necesita un término nuevo, solicitar aprobación al BA Lead

-------------------------
3. Vocabulario de Actores
-------------------------

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Término Preferido
     - Sinónimos Aceptados
     - Términos Prohibidos
   * - Usuario
     - Usuario del Sistema
     - Operador, Empleado, Persona, User
   * - Cliente
     - Llamante, Cliente Final
     - Consumidor, Abonado, Subscriber
   * - Sistema IACT
     - IACT, Sistema, Plataforma IACT
     - Aplicación, Software, App
   * - Sistema IVR
     - IVR, Plataforma IVR
     - Centralita, PBX, Call Center

-------------------
4. Vocabulario RBAC
-------------------

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Término Preferido
     - Sinónimos Aceptados
     - Términos Prohibidos
   * - Rol Funcional
     - Rol, Rol RBAC
     - Perfil de acceso, Grupo, Privilegio
   * - Perfil
     - Perfil de Usuario, Perfil de Módulos
     - Tipo de usuario, Categoría
   * - Segmento de Datos
     - Segmento
     - Partición, División, Área de datos
   * - Permiso
     - Autorización
     - Derecho, Acceso, Privilegio
   * - Sesión
     - Sesión de Usuario
     - Conexión, Login activo

4.1. Valores de Rol Funcional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los 18 roles funcionales definidos en el modelo RBAC:

**Gestión de Usuarios:**

- USERS_FULL_MANAGER
- USERS_VIEWER
- USERS_TEAM_MANAGER

**Reportes:**

- REPORTS_VIEWER
- REPORTS_EXPORTER
- REPORTS_ADVANCED_VIEWER
- REPORTS_CREATOR

**Visualización:**

- DASHBOARD_VIEWER
- DASHBOARD_CREATOR

**Análisis:**

- DATA_ANALYST

**Alertas:**

- ALERTS_VIEWER
- ALERTS_CONFIGURATOR
- ALERTS_TEAM_CONFIGURATOR
- ALERTS_ADMIN

**Administración:**

- MODULES_MANAGER
- SYSTEM_ADMIN
- AUDIT_VIEWER
- SUPPORT_VIEWER

4.2. Valores de Perfil
^^^^^^^^^^^^^^^^^^^^^^

Los 4 perfiles base del sistema:

- BÁSICO
- ANALISTA
- ADMINISTRADOR_SEGMENTO
- ADMINISTRADOR

4.3. Valores de Segmento de Datos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los 6 segmentos definidos:

.. list-table::
   :widths: 15 30 55
   :header-rows: 1

   * - Código
     - Nombre
     - Descripción
   * - OP
     - DATOS_OPERATIVOS
     - Datos de operación del IVR (llamadas, menús, opciones)
   * - FI
     - DATOS_FINANCIEROS
     - Datos para análisis de costos y facturación
   * - TE
     - DATOS_TECNICOS
     - Datos técnicos de infraestructura y rendimiento
   * - SU
     - DATOS_SUPERVISION
     - Datos para supervisión y control
   * - CA
     - DATOS_CALIDAD
     - Datos de métricas de calidad del servicio
   * - GE
     - DATOS_CONSOLIDADOS
     - Datos agregados para toma de decisiones

-------------------------
5. Vocabulario de Negocio
-------------------------

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Término Preferido
     - Sinónimos Aceptados
     - Términos Prohibidos
   * - Llamada
     - Llamada Telefónica
     - Comunicación, Contacto, Interacción telefónica
   * - Evento IVR
     - Evento
     - Acción, Registro, Log entry
   * - Menú IVR
     - Menú, Nodo IVR
     - Opción, Pantalla, Step
   * - Métrica
     - Indicador, KPI
     - Dato, Número, Estadística
   * - Dashboard
     - Tablero, Panel de Control
     - Pantalla, Vista, Screen
   * - Reporte
     - Informe
     - Documento, Listado, Export

--------------------------
6. Vocabulario de Acciones
--------------------------

6.1. Verbos para Reglas Aléticas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Verbo Preferido
     - Sinónimos Aceptados
     - Verbos Prohibidos
   * - es
     - son
     - representa, constituye
   * - tiene
     - tienen, posee
     - cuenta con, dispone de
   * - pertenece a
     - forma parte de
     - está en, se encuentra en
   * - contiene
     - incluye
     - tiene dentro, guarda
   * - se define como
     - significa
     - quiere decir, equivale a
   * - se deriva de
     - se calcula como
     - proviene de, sale de

6.2. Verbos para Reglas Deónticas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Verbo Preferido
     - Sinónimos Aceptados
     - Verbos Prohibidos
   * - debe
     - deben, tiene que
     - debería, tendría que, hay que
   * - no debe
     - no deben
     - no debería, no tendría que
   * - puede
     - pueden, está permitido
     - podría, le es posible
   * - no puede
     - no pueden, está prohibido
     - no podría, le está vedado
   * - requiere
     - necesita, exige
     - pide, demanda, solicita

6.3. Verbos de Operación
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Verbo Preferido
     - Sinónimos Aceptados
     - Verbos Prohibidos
   * - crear
     - registrar
     - hacer, generar, añadir
   * - modificar
     - actualizar, editar
     - cambiar, alterar, tocar
   * - eliminar
     - borrar, dar de baja
     - quitar, remover, sacar
   * - consultar
     - ver, visualizar
     - mirar, revisar, chequear
   * - exportar
     - descargar
     - sacar, bajar, extraer
   * - autenticar
     - iniciar sesión
     - loguearse, entrar, acceder
   * - asignar
     - otorgar
     - dar, poner, setear

---------------------------------
7. Vocabulario de Cuantificadores
---------------------------------

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Término Preferido
     - Sinónimos Aceptados
     - Términos Prohibidos
   * - cada
     - todo, todos los
     - cualquier
   * - exactamente un
     - uno y solo uno
     - un único, solamente uno
   * - al menos un
     - uno o más, mínimo uno
     - algún, alguno
   * - como máximo
     - hasta, no más de
     - máximo, a lo sumo
   * - ningún
     - ninguno, cero
     - ni uno, nada de

-----------------------------
8. Vocabulario de Condiciones
-----------------------------

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Término Preferido
     - Sinónimos Aceptados
     - Términos Prohibidos
   * - si
     - cuando, en caso de que
     - siempre y cuando
   * - solo si
     - únicamente si, solamente si
     - nada más si
   * - excepto si
     - a menos que, salvo que
     - excepto cuando
   * - siempre que
     - cada vez que
     - todas las veces que
   * - antes de
     - previamente a
     - anterior a
   * - después de
     - posteriormente a, luego de
     - posterior a

-------------------------------
9. Términos Técnicos Permitidos
-------------------------------

Los siguientes términos técnicos están permitidos en reglas de negocio
cuando se refieren a conceptos específicos del sistema:

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Término
     - Contexto de Uso
   * - timestamp
     - Marca temporal de un evento
   * - log de auditoría
     - Registro de acciones para trazabilidad
   * - hash
     - Solo en contexto de contraseñas (nunca el valor)
   * - token
     - Identificador de sesión
   * - API
     - Interfaz de integración externa
   * - CSV, Excel, PDF
     - Formatos de exportación
   * - timeout
     - Tiempo límite de sesión o operación

---------------------------
10. Checklist de Validación
---------------------------

Al escribir o revisar una regla de negocio, verificar:

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - 1
     - Todos los sustantivos están en el vocabulario de actores, RBAC o negocio
   * - 2
     - Los verbos corresponden al tipo de regla (alética o deóntica)
   * - 3
     - No se usan términos prohibidos
   * - 4
     - Los cuantificadores son precisos (no ambiguos)
   * - 5
     - Las condiciones usan conectores del vocabulario
   * - 6
     - Los valores de Rol, Perfil y Segmento son exactos
   * - 7
     - Los términos técnicos están en la lista permitida

-------------------------
11. Proceso de Ampliación
-------------------------

Para agregar un nuevo término al vocabulario controlado:

1. Identificar necesidad durante escritura de BR
2. Verificar que no existe término equivalente
3. Proponer término con definición clara
4. Enviar solicitud al BA Lead
5. BA Lead revisa con Arquitecto de Documentación
6. Si se aprueba, se actualiza SBVR_01 y SBVR_03
7. Se notifica al equipo el nuevo término

---------------
12. Referencias
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Conceptos Nucleares
     - :doc:`SBVR_01_Conceptos_Nucleares`
   * - Tipos de Regla
     - :doc:`SBVR_02_Fact_Types`
   * - Modelo RBAC
     - Ver sección de Arquitectura (RBAC Flat NIST)
   * - Glosario IACT
     - Ver glosario del sistema

--------------------
Historial de Cambios
--------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-18
     - BA Lead
     - Versión inicial con vocabulario alineado a modelo RBAC

----

**Trazabilidad:** Checklist obligatorio al escribir nuevas reglas de negocio.
Evita términos ambiguos o inconsistentes en requisitos/reglas_negocio/.


.. toctree::
   :hidden:
   :maxdepth: 1

   SBVR_01_Conceptos_Nucleares
   SBVR_02_Fact_Types
   SBVR_03_Reglas_Estructurales
   SBVR_04_Reglas_Operativas
   SBVR_05_Vocabulario_Controlado
