.. meta::
   :artefacto: TXM_03
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

.. _txm-03:

======================================
TXM_03: Taxonomia de Reglas de Negocio
======================================


Proposito
---------

Este documento presenta la **clasificacion jerarquica** de los tipos de
Reglas de Negocio (Business Rules) utilizados en IACT. Define los 5 tipos
principales, sus caracteristicas distintivas y criterios de clasificacion.

----

1. Vista General de la Taxonomia
--------------------------------

.. code-block:: text

   REGLA DE NEGOCIO (BR)
   │
   ├── POR TIPO (Clasificacion Primaria)
   │   │
   │   ├── HECHO (Fact)
   │   │   └── Verdad estructural del dominio
   │   │
   │   ├── RESTRICCION (Constraint)
   │   │   └── Limitacion obligatoria
   │   │
   │   ├── DESENCADENADOR (Trigger)
   │   │   └── SI condicion ENTONCES accion observable
   │   │
   │   ├── INFERENCIA (Inference)
   │   │   └── SI condicion ENTONCES nuevo hecho interno
   │   │
   │   └── CALCULO (Calculation)
   │       └── Formula o algoritmo
   │
   ├── POR MODALIDAD SBVR
   │   │
   │   ├── ALETICA (Estructural)
   │   │   └── Lo que ES (verdades)
   │   │
   │   └── DEONTICA (Comportamental)
   │       ├── Obligacion (DEBE)
   │       ├── Prohibicion (NO DEBE)
   │       └── Permiso (PUEDE)
   │
   └── POR ORIGEN
       │
       ├── EXTERNA
       │   ├── Legal/Regulatoria
       │   ├── Contractual
       │   └── Estandar Industrial
       │
       └── INTERNA
           ├── Politica Organizacional
           ├── Procedimiento Operativo
           └── Mejor Practica

----

2. Tipo 1: Hecho (Fact)
-----------------------

2.1 Definicion
^^^^^^^^^^^^^^

Un **Hecho** es una verdad sobre el dominio que estructura el modelo
de datos y las relaciones entre entidades.

.. code-block:: text

   CARACTERISTICAS:
   - Describe lo que ES (no lo que debe ser)
   - Estructura el modelo conceptual
   - No puede violarse (si se viola, hay error en el modelo)
   - Modalidad: ALETICA

   KEYWORDS:
   "es", "tiene", "pertenece", "existe", "cada"

   PATRON:
   "[Concepto] ES/TIENE [caracteristica/relacion]"

2.2 Subtipos
^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Subtipo
     - Descripcion
   * - **Hecho de Identidad**
     - Define unicidad (cada X tiene exactamente un Y)
   * - **Hecho de Existencia**
     - Define obligatoriedad de relacion
   * - **Hecho de Cardinalidad**
     - Define cantidad de relaciones (1:N, N:M)
   * - **Hecho de Estado**
     - Define valores posibles de un atributo

2.3 Ejemplos IACT
^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_011: Modelo RBAC Flat (Hecho de Estructura)
   "El sistema IACT implementa modelo RBAC Flat sin herencia de roles"

   Subtipo: Hecho de Estructura
   Impacto: Define arquitectura de seguridad

   ---

   BR_HEC_001: Unicidad de Username (Hecho de Identidad)
   "Cada usuario tiene exactamente un username unico"

   Subtipo: Hecho de Identidad
   Impacto: Constraint UNIQUE en BD

   ---

   BR_HEC_002: Usuario-Segmento (Hecho de Cardinalidad)
   "Cada usuario pertenece a exactamente un segmento de datos"

   Subtipo: Hecho de Cardinalidad
   Impacto: FK NOT NULL en tabla users

2.4 Transformacion
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   HECHO → Modelo de Datos + Validaciones de Integridad

   NO genera Caso de Uso directamente.
   Genera constraints y estructura de BD.

----

3. Tipo 2: Restriccion (Constraint)
-----------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

Una **Restriccion** es una limitacion obligatoria sobre lo que puede
o no puede ocurrir en el sistema.

.. code-block:: text

   CARACTERISTICAS:
   - Describe lo que DEBE o NO DEBE suceder
   - Puede violarse (el sistema debe prevenirlo)
   - Modalidad: DEONTICA

   KEYWORDS:
   "debe", "no debe", "solo", "unicamente", "requiere"

   PATRON:
   "[Sujeto] DEBE/NO DEBE [accion] [condicion]"
   "SOLO [sujeto] PUEDE [accion]"

3.2 Subtipos
^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Subtipo
     - Descripcion
   * - **Obligacion**
     - Algo que DEBE hacerse
   * - **Prohibicion**
     - Algo que NO DEBE hacerse
   * - **Restriccion de Acceso**
     - Quien PUEDE hacer algo
   * - **Restriccion de Tiempo**
     - Cuando PUEDE hacerse algo

3.3 Ejemplos IACT
^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_015: Separacion de Funciones (Prohibicion)
   "Un usuario NO DEBE tener simultaneamente roles R016 y R017"

   Subtipo: Prohibicion (SoD)
   Impacto: Validacion al asignar roles
   Genera: UC-010 (flujo alterno de validacion SoD)

   ---

   BR_001: Fuente Operacional Inmutable (Prohibicion)
   "El sistema IACT NO DEBE modificar datos en BD MySQL del IVR"

   Subtipo: Prohibicion
   Impacto: Usuario BD con solo SELECT

   ---

   BR_RES_001: Solo Admin Gestiona Usuarios (Restriccion de Acceso)
   "SOLO usuarios con rol R001 pueden crear, modificar o eliminar usuarios"

   Subtipo: Restriccion de Acceso
   Impacto: Validacion de permisos en UC-006, UC-007, UC-008

3.4 Transformacion
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION → Precondiciones/Postcondiciones en UC + Validaciones FR

   Genera validaciones en flujos de Casos de Uso.
   Genera FR de validacion y control de acceso.

----

4. Tipo 3: Desencadenador (Trigger)
-----------------------------------

4.1 Definicion
^^^^^^^^^^^^^^

Un **Desencadenador** es una regla con formato SI...ENTONCES donde el
ENTONCES produce una **accion observable** externamente.

.. code-block:: text

   CARACTERISTICAS:
   - Formato: SI [condicion] ENTONCES [accion observable]
   - La accion es visible para actores externos
   - Genera comportamiento del sistema
   - Modalidad: DEONTICA (obligacion condicional)

   KEYWORDS:
   "si", "cuando", "entonces", "notificar", "enviar", "mostrar"

   PATRON:
   "SI [condicion] ENTONCES sistema DEBE [accion observable]"

4.2 Criterio Distintivo
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ¿Como distinguir DESENCADENADOR de INFERENCIA?

   Pregunta clave:
   "¿El ENTONCES produce algo VISIBLE para un actor externo?"

   SI es visible → DESENCADENADOR
   - Notificacion
   - Cambio en UI
   - Mensaje
   - Reporte
   - Alerta

   NO es visible → INFERENCIA
   - Cambio de estado interno
   - Actualizacion de flag
   - Calculo interno

4.3 Ejemplos IACT
^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_002: Sincronizacion ETL (Desencadenador Temporal)
   "SI hora = 00:00 ENTONCES sistema DEBE ejecutar sincronizacion ETL"

   Condicion: Hora del dia (temporal)
   Accion Observable: Ejecucion de proceso visible en logs
   Genera: UC-ETL (Sincronizar Datos)

   ---

   BR_TRG_001: Alerta por Umbral (Desencadenador de Negocio)
   "SI metrica supera umbral configurado ENTONCES sistema DEBE
    notificar a destinatarios via buzon interno"

   Condicion: Valor de metrica
   Accion Observable: Notificacion a usuarios
   Genera: UC-038 (Disparar Alerta)

   ---

   BR_TRG_002: Bloqueo por Intentos Fallidos (Desencadenador de Seguridad)
   "SI usuario falla 3 intentos de login ENTONCES sistema DEBE
    bloquear cuenta y notificar a administrador"

   Condicion: Contador de intentos
   Accion Observable: Bloqueo + Notificacion
   Genera: Flujo alterno en UC-005 (Login)

4.4 Transformacion
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   DESENCADENADOR → Caso de Uso Completo (o flujo alterno)

   Es el UNICO tipo de BR que genera directamente un UC.
   El UC describe la interaccion completa del comportamiento.

----

5. Tipo 4: Inferencia (Inference)
---------------------------------

5.1 Definicion
^^^^^^^^^^^^^^

Una **Inferencia** es una regla con formato SI...ENTONCES donde el
ENTONCES produce un **cambio interno** no observable directamente.

.. code-block:: text

   CARACTERISTICAS:
   - Formato: SI [condicion] ENTONCES [nuevo hecho interno]
   - El resultado NO es visible externamente
   - Cambia estado interno del sistema
   - Modalidad: ALETICA (deriva verdad de otra verdad)

   KEYWORDS:
   "si", "entonces", "marcar como", "clasificar como", "considerar"

   PATRON:
   "SI [condicion] ENTONCES [entidad] ES/TIENE [nuevo estado]"

5.2 Criterio Distintivo
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   INFERENCIA: El resultado es un NUEVO HECHO interno.

   - No hay notificacion
   - No hay mensaje al usuario
   - No hay cambio visible en UI
   - Solo cambia un estado/flag/clasificacion interna

5.3 Ejemplos IACT
^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_003: Usuario Inactivo por Tiempo (Inferencia)
   "SI usuario no inicia sesion por 90 dias
    ENTONCES usuario ES marcado como INACTIVO"

   Condicion: Dias sin actividad
   Resultado Interno: Cambio de estado (flag)
   NO genera UC (es proceso interno batch)
   Genera: FR de logica de negocio

   ---

   BR_INF_001: Clasificacion de Llamada Larga (Inferencia)
   "SI duracion de llamada > 300 segundos
    ENTONCES llamada ES clasificada como LARGA"

   Condicion: Duracion
   Resultado Interno: Clasificacion
   Uso: Para filtros y reportes (no visible al momento)

   ---

   BR_INF_002: Cuenta Premium (Inferencia)
   "SI usuario tiene mas de 100 consultas mensuales
    ENTONCES usuario ES considerado USUARIO_FRECUENTE"

   Condicion: Conteo de uso
   Resultado Interno: Clasificacion para reportes

5.4 Transformacion
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   INFERENCIA → Logica Interna (FR) + Posible Job Batch

   NO genera Caso de Uso.
   Genera FR de logica de negocio interna.
   Puede generar proceso batch/scheduled.

----

6. Tipo 5: Calculo (Calculation)
--------------------------------

6.1 Definicion
^^^^^^^^^^^^^^

Un **Calculo** es una formula o algoritmo que transforma datos de entrada
en un resultado.

.. code-block:: text

   CARACTERISTICAS:
   - Define formula matematica o algoritmo
   - Transforma datos de entrada en salida
   - Determinista (misma entrada = misma salida)
   - Modalidad: ALETICA (verdad matematica)

   KEYWORDS:
   "igual a", "se calcula como", "formula", "suma de", "promedio"

   PATRON:
   "[Resultado] = [formula con variables]"

6.2 Subtipos
^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Subtipo
     - Descripcion
   * - **Formula Simple**
     - Operaciones aritmeticas basicas
   * - **Agregacion**
     - SUM, AVG, COUNT, MAX, MIN
   * - **Derivacion**
     - Calculo basado en otros calculos
   * - **Algoritmo**
     - Logica mas compleja con condiciones

6.3 Ejemplos IACT
^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_CAL_001: Tasa de Abandono (Agregacion)
   "Tasa de Abandono = (Llamadas Abandonadas / Total Llamadas) * 100"

   Tipo: Agregacion + Formula
   Variables: Llamadas abandonadas, Total llamadas
   Resultado: Porcentaje

   ---

   BR_CAL_002: Tiempo Promedio de Espera (Agregacion)
   "Tiempo Promedio = SUM(tiempo_espera) / COUNT(llamadas)"

   Tipo: Agregacion
   Variables: tiempo_espera por llamada
   Resultado: Segundos (promedio)

   ---

   BR_CAL_003: Indice de Eficiencia (Derivacion)
   "Indice Eficiencia = (Llamadas Completadas / Total) * (1 - Tasa Transferencia)"

   Tipo: Derivacion (usa otros calculos)
   Variables: Completadas, Total, Tasa Transferencia
   Resultado: Indice 0-1

6.4 Transformacion
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CALCULO → FR Especifico con Algoritmo

   Genera FR que especifica la formula exacta.
   Se convierte en paso dentro de un UC.

----

7. Comparacion de Tipos
-----------------------

7.1 Tabla Comparativa
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 17 17 17 17 17

   * - Aspecto
     - Hecho
     - Restriccion
     - Trigger
     - Inferencia
     - Calculo
   * - Modalidad
     - Aletica
     - Deontica
     - Deontica
     - Aletica
     - Aletica
   * - Describe
     - Lo que ES
     - Lo que DEBE
     - SI→Accion
     - SI→Estado
     - Formula
   * - Violable
     - No
     - Si
     - Si
     - No
     - No
   * - Genera UC
     - No
     - Parcial
     - **SI**
     - No
     - No
   * - Genera FR
     - Validacion
     - Validacion
     - Multiples
     - Logica
     - Algoritmo

7.2 Arbol de Decision
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ¿La BR tiene formato SI...ENTONCES?
   │
   ├─ NO → ¿Define una verdad estructural?
   │       │
   │       ├─ SI → HECHO
   │       │
   │       └─ NO → ¿Define una formula/algoritmo?
   │               │
   │               ├─ SI → CALCULO
   │               │
   │               └─ NO → ¿Limita lo que puede hacerse?
   │                       │
   │                       └─ SI → RESTRICCION
   │
   └─ SI → ¿El ENTONCES es visible externamente?
           │
           ├─ SI → DESENCADENADOR
           │       (genera UC)
           │
           └─ NO → INFERENCIA
                   (logica interna)

----

8. Matriz de Transformacion
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 25 25 30

   * - Tipo BR
     - Genera UC?
     - Genera FR
     - Otros Artefactos
   * - Hecho
     - No
     - Validacion integridad
     - Constraints BD, Modelo
   * - Restriccion
     - Parcial (flujo alterno)
     - Validacion acceso
     - Precondiciones UC
   * - Desencadenador
     - **SI (completo)**
     - Multiples por paso
     - Eventos, Notificaciones
   * - Inferencia
     - No
     - Logica interna
     - Jobs batch
   * - Calculo
     - No (paso en UC)
     - Algoritmo especifico
     - Stored procedures

----

9. Estadisticas IACT
--------------------

9.1 BR Identificadas por Tipo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Tipo
     - Cantidad
     - Ejemplos
   * - Hecho
     - 2
     - BR_011 (RBAC Flat), BR_HEC_001 (Unicidad)
   * - Restriccion
     - 3
     - BR_001 (Inmutable), BR_015 (SoD), BR_RES_001
   * - Desencadenador
     - 2
     - BR_002 (ETL), BR_TRG_001 (Alertas)
   * - Inferencia
     - 1
     - BR_003 (Inactivo 90 dias)
   * - Calculo
     - ~5
     - Metricas de dashboard
   * - **Total**
     - **~13**
     - Base identificada

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-02` - Reglas de Negocio (fundamentos)
- :ref:`txm-01` - Taxonomia de Requisitos
- :ref:`sbvr-03` - Reglas Estructurales (aleticas)
- :ref:`sbvr-04` - Reglas Operativas (deonticas)

Fuentes
^^^^^^^

- OMG SBVR 1.5 Specification
- Ronald Ross: "Business Rule Concepts"
- Barbara von Halle: "The Business Rule Revolution"

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
     - Version inicial con 5 tipos de BR

----

**Trazabilidad:** Esta taxonomia clasifica los tipos de Business Rules
y define como cada tipo se transforma en otros artefactos. Es fundamental
para el proceso de derivacion documentado en :ref:`fnd-06` y aplicado
en requisitos/reglas_negocio/.
