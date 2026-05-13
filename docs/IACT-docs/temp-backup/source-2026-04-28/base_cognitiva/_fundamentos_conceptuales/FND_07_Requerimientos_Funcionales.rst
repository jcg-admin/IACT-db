.. meta::
   :artefacto: FND_07
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2025-12-19
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-07:

==================================
FND_07: Requerimientos Funcionales
==================================


Proposito
---------

Este documento define QUE ES un Requerimiento Funcional (FR) en el contexto
del proyecto IACT, sus caracteristicas, como se escriben correctamente y
como se derivan de los Casos de Uso.

----

1. Definicion Formal
--------------------

1.1 Que es un Requerimiento Funcional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Un **Requerimiento Funcional (Functional Requirement - FR)** es una
especificacion precisa, verificable y sin ambiguedades de una capacidad,
comportamiento o funcion que el sistema debe proveer.

.. note::

   **Definicion operativa para IACT:**

   Un FR es una declaracion atomica que describe UNA capacidad especifica
   que el sistema DEBE tener, derivada de un paso de Caso de Uso.

1.2 Caracteristicas Clave
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Precision**
     - Sin ambiguedad, una sola interpretacion posible
   * - **Verificabilidad**
     - Se puede probar si se cumple o no (binario)
   * - **Atomicidad**
     - Una sola capacidad por FR
   * - **Independencia**
     - Verificable sin depender de secuencia

1.3 Nivel de Abstraccion
^^^^^^^^^^^^^^^^^^^^^^^^

Los FR estan en el **nivel medio** de abstraccion:

.. code-block:: text

   ABSTRACCION ALTA (Business Rules):
   "Passwords deben ser seguros"
              |
              v
   ABSTRACCION MEDIA (Functional Requirements) <-- NIVEL CORRECTO
   "Sistema DEBE hashear passwords con bcrypt cost=12"
              |
              v
   ABSTRACCION BAJA (Implementacion):
   "class UserService { hash(pwd) { return bcrypt(pwd, 12); }}"

   FR es suficientemente especifico para implementar,
   pero sin atarse a tecnologia especifica.

----

2. Origen de los FR
-------------------

2.1 Fuentes de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^

Los FR se derivan de multiples fuentes:

.. code-block:: text

   FUENTE 1: Business Rules

   BR-015: "Productos clase 5 requieren aprobacion nivel 2"
       |
       v
   FR-204.3: "Si producto.clase_peligrosidad = 5,
              sistema DEBE requerir aprobador con nivel >= 2"

   ---------------------------------------------------------

   FUENTE 2: Casos de Uso (principal)

   UC-40 Paso 6: "Sistema valida formato CAS Number"
       |
       v
   FR-40.6: "Sistema DEBE validar CAS con regex"
   FR-40.7: "Sistema DEBE validar checksum CAS"

   ---------------------------------------------------------

   FUENTE 3: Stakeholders

   Stakeholder Legal: "Necesitamos auditoria completa"
       |
       v
   FR-40.25: "Sistema DEBE registrar en AuditoriaLog:
              usuario, accion, timestamp, IP, datos"

2.2 Relacion UC -> FR
^^^^^^^^^^^^^^^^^^^^^

Cada paso del Caso de Uso donde el sistema actua genera uno o mas FR:

.. code-block:: text

   UC-40: Registrar Producto

   Paso 5: "Sistema valida datos ingresados"
       |
       +---> FR-40.6: Validar formato CAS Number
       +---> FR-40.7: Validar checksum CAS
       +---> FR-40.8: Validar nombre no vacio
       +---> FR-40.9: Validar nombre <= 200 caracteres
       +---> FR-40.10: Validar categoria existe
       +---> FR-40.11: Validar clase peligrosidad 1-5

   1 paso UC vago -> 6 FR atomicos y verificables

----

3. Caracteristicas SMART
------------------------

Un buen FR cumple con el criterio SMART:

3.1 S - Specific (Especifico)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El FR debe ser claro, concreto y sin ambiguedad.

.. code-block:: text

   INCORRECTO (no especifico):
   "El sistema debe validar los datos"

   Problemas:
   - Que datos? (nombre, email, fecha...)
   - Como validar? (formato, longitud, unicidad...)
   - Cuando validar? (al escribir, al enviar...)

   CORRECTO (especifico):
   FR-40.6: "El sistema DEBE validar que el CAS Number
             tenga el formato XXX-XX-X, donde:
             - Primer bloque: 2 a 7 digitos
             - Segundo bloque: exactamente 2 digitos
             - Tercer bloque: exactamente 1 digito
             - Separadores: guiones (-)"

3.2 M - Measurable (Medible)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El FR debe poder verificarse objetivamente.

.. code-block:: text

   INCORRECTO (no medible):
   "El sistema debe responder rapidamente"

   CORRECTO (medible):
   FR-17.3: "La consulta de reportes DEBE responder
             en menos de 2 segundos (95th percentile)"

   Criterio de aceptacion claro:
   - Ejecutar 100 consultas
   - 95 deben completar en < 2 segundos
   - Cumple: SI/NO

3.3 A - Achievable (Alcanzable)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El FR debe ser tecnicamente factible.

.. code-block:: text

   INCORRECTO (no alcanzable):
   "El sistema DEBE predecir con 100% precision
    las llamadas del proximo mes"

   CORRECTO (alcanzable):
   FR-35.1: "El sistema DEBE calcular promedio movil
             de llamadas de ultimos 30 dias"

3.4 R - Relevant (Relevante)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El FR debe tener trazabilidad clara hacia una necesidad de negocio.

.. code-block:: text

   INCORRECTO (no relevante):
   FR-999: "Sistema DEBE integrarse con TikTok"

   Sin trazabilidad:
   - No hay UC que lo requiera
   - No hay BR que lo justifique
   - No aporta valor al negocio IACT

   CORRECTO (relevante):
   FR-40.6: Validar CAS Number
                                
       | Deriva de: UC-40 paso 6
                                               
       | Deriva de: BR-012 "CAS debe ser unico"
                                               
       | Deriva de: Necesidad "Catalogo confiable"

   Cadena completa -> FR es relevante

3.5 T - Time-bound (Con Plazo)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El FR debe estar asignado a un release especifico.

.. code-block:: text

   ASIGNACION DE FR A RELEASES:

   Release 1 (MVP): 120 FR Must Have
     FR-110.1 a FR-110.15: Login (basico)
     FR-40.1 a FR-40.25: CRUD Producto (basico)
     Deadline: 15 febrero 2025

   Release 2: 90 FR Should Have
     FR-110.16 a FR-110.25: Login (MFA, LDAP)
     FR-40.26 a FR-40.40: Validaciones avanzadas
     Deadline: 15 abril 2025

----

4. Reglas de Escritura (INCOSE)
-------------------------------

4.1 Lenguaje Imperativo
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CORRECTO:
   "El sistema DEBE validar..."
   "El sistema NO DEBE permitir..."

   INCORRECTO:
   "El sistema validara..." (futuro)
   "El sistema podria validar..." (condicional)

4.2 Evitar Palabras Ambiguas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Palabra Prohibida
     - Alternativa
   * - "Y/O"
     - Separar en FR distintos
   * - "Etc."
     - Listar todos los casos
   * - "Adecuado", "suficiente"
     - Especificar cantidad exacta
   * - "Rapido", "lento"
     - Especificar tiempo en segundos
   * - "Normal", "tipico"
     - Definir explicitamente

4.3 Un Requerimiento, Una Oracion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   INCORRECTO (4 requerimientos en 1):
   "El sistema DEBE validar formato CAS y verificar
    unicidad y calcular checksum y normalizar entrada"

   CORRECTO (separados):
   FR-40.6: Sistema DEBE validar formato CAS
   FR-40.7: Sistema DEBE verificar unicidad CAS
   FR-40.8: Sistema DEBE calcular checksum CAS
   FR-40.9: Sistema DEBE normalizar CAS (sin espacios)

4.4 Especificar Unidades y Limites
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CORRECTO:
   "Longitud maxima: 200 caracteres"
   "Timeout: 3 segundos"
   "Rango: 1-5 (inclusivo)"

   INCORRECTO:
   "Campo largo"
   "Timeout corto"
   "Numero pequeño"

----

5. Template de FR
-----------------

5.1 Formato Estandar IACT
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR-[UC].[SEQ]: [Titulo Descriptivo]

   El sistema [DEBE|NO DEBE] [verbo] [objeto] [condiciones].

   Campos adicionales:
     Origen:        UC-NNN, Paso N / BR-NNN
     Prioridad:     Must Have | Should Have | Could Have
     Release:       R1 | R2 | R3
     Criterio:      [Como verificar que se cumple]
     Notas:         [Observaciones adicionales]

5.2 Ejemplo Completo
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR-40.6: Validar Formato CAS Number

   El sistema DEBE validar que el CAS Number ingresado tenga
   el formato XXX-XX-X, donde:
   - Primer bloque: 2 a 7 digitos
   - Segundo bloque: exactamente 2 digitos
   - Tercer bloque: exactamente 1 digito
   - Separadores: guiones (-)

   Regex: ^[0-9]{2,7}-[0-9]{2}-[0-9]$

   Si formato invalido:
   - Mostrar mensaje: "CAS Number invalido. Formato: XXX-XX-X"
   - Resaltar campo en rojo
   - Prevenir submit del formulario

   Origen:      UC-40, Paso 5
   Prioridad:   Must Have
   Release:     R1
   Criterio:    Test con casos validos e invalidos
   Notas:       Validar client-side Y server-side

----

6. Beneficios de FR Bien Escritos
---------------------------------

6.1 Estadisticas de Industria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CAPERS JONES (2017) - Defectos por origen:

   +----------------------+-----------+
   | Fase                 | % Defectos|
   +----------------------+-----------+
   | Requerimientos       | 40-50%    |
   | Diseno               | 25-30%    |
   | Codificacion         | 15-20%    |
   | Testing              | 5-10%     |
   +----------------------+-----------+

   Costo de correccion por fase:

   +----------------------+-------+----------+
   | Fase                 | Costo | Ejemplo  |
   +----------------------+-------+----------+
   | Requerimientos       | 1x    | $100     |
   | Diseno               | 5x    | $500     |
   | Codificacion         | 10x   | $1,000   |
   | Testing              | 20x   | $2,000   |
   | Produccion           | 100x  | $10,000  |
   +----------------------+-------+----------+

   CONCLUSION:
   Invertir 2x en requerimientos ahorra 50x en produccion

6.2 Impacto por Rol
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   DESARROLLADORES:
   Sin FR detallados:
     - Hacen suposiciones incorrectas
     - Implementan multiples veces (retrabajos)
     - Generan bugs por malentendidos

   Con FR detallados:
     - Implementan correctamente en primera iteracion
     - Ahorran 30-40% de tiempo de desarrollo

   ---------------------------------------------------------

   QA/TESTERS:
   Sin FR detallados:
     - No saben que probar exactamente
     - Ambiguedad: es bug o feature?

   Con FR detallados:
     - Test cases derivan directamente de FR
     - Criterios claros de aceptacion

   ---------------------------------------------------------

   STAKEHOLDERS:
   Sin FR detallados:
     - "Eso no es lo que pedi"
     - Insatisfaccion y conflictos

   Con FR detallados:
     - Expectativas alineadas desde inicio
     - Sistema cumple lo especificado

----

7. FR en el Contexto IACT
-------------------------

7.1 Nomenclatura
^^^^^^^^^^^^^^^^

Los FR en IACT siguen la convencion:

.. code-block:: text

   FORMATO: FR-[UC].[SEQ]

   Donde:
   - FR: Prefijo fijo (Functional Requirement)
   - UC: Numero del Caso de Uso de origen
   - SEQ: Secuencial dentro del UC

   Ejemplos:
   - FR-10.1: Primer FR derivado de UC-010
   - FR-10.2: Segundo FR derivado de UC-010
   - FR-17.5: Quinto FR derivado de UC-017

7.2 Ubicacion en el Modelo IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   requisitos/
       |
       +--- funcionales/
                |
                +--- index.rst
                +--- FR_UC010_Asignar_Roles.rst
                +--- FR_UC017_Consultar_Reporte.rst
                +--- ...

7.3 Relacion con Otros Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR (Regla de Negocio)
       |
       v
   UC (Caso de Uso)
       |
       v
   FR (Requisito Funcional) <-- Este nivel
       |
       v
   TEST (Caso de Prueba)
       |
       v
   CODIGO (Implementacion)

----

8. Ejemplos IACT
----------------

8.1 FR de Validacion
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR-10.6: Validar Compatibilidad SoD

   El sistema DEBE verificar que el rol a asignar no tenga
   conflicto de Separacion de Funciones (SoD) con los roles
   actuales del usuario.

   Consulta: Tabla de incompatibilidades role_conflicts

   Si existe conflicto:
   - Bloquear asignacion
   - Mostrar: "Rol [X] incompatible con rol existente [Y]"

   Origen:      UC-010, Paso 6 / BR_015
   Prioridad:   Must Have (seguridad)
   Release:     R1

8.2 FR de Consulta
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR-17.3: Filtrar Reporte por Rango de Fechas

   El sistema DEBE permitir filtrar el reporte trimestral
   por un rango de fechas especificado por el usuario.

   Parametros:
   - fecha_inicio: date (obligatorio)
   - fecha_fin: date (obligatorio)

   Validaciones:
   - fecha_inicio <= fecha_fin
   - Rango maximo: 365 dias

   Origen:      UC-017, Paso 3
   Prioridad:   Must Have
   Release:     R1

8.3 FR de Notificacion
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR-10.10: Notificar Asignacion de Rol

   El sistema DEBE notificar al usuario cuando se le asigne
   un nuevo rol, utilizando el buzon interno del sistema.

   Contenido notificacion:
   - Asunto: "Nuevo rol asignado: [nombre_rol]"
   - Cuerpo: Fecha, rol, permisos otorgados
   - NO enviar email externo (CNST_001)

   Origen:      UC-010, Paso 10 / CNST_001
   Prioridad:   Should Have
   Release:     R1

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-04` - Trazabilidad
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-06` - Derivacion vs Transformacion

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830-1998: Software Requirements Specifications
- ISO/IEC 25010: Systems and Software Quality Requirements
- INCOSE: Guide to Writing Requirements
- Karl Wiegers: "Software Requirements" (3rd Edition)

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
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:** Este artefacto define el concepto de FR que es el nivel
mas bajo de la jerarquia de requisitos (Nivel 3). Los FR son el puente
entre requisitos de usuario (UC) e implementacion. Referenciado por
todos los artefactos en requisitos/funcionales/.
