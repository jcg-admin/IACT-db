.. meta::
   :artefacto: GOB_01
   :tipo: Politica
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-01:

=================================
GOB_01: Modelo de Gobernanza IACT
=================================


Proposito
---------

Este documento define el **modelo de gobernanza** del sistema documental IACT,
estableciendo la estructura de autoridad, los niveles de decision, las cadenas
de escalamiento y los principios rectores que rigen toda la documentacion
del proyecto.

.. important::

   **Pregunta Clave que Responde:**

   "¿Quien tiene autoridad para decidir que en este proyecto?"

----

1. Principios Rectores
----------------------

El modelo de gobernanza IACT se fundamenta en cinco principios inmutables:

1.1 Principio de Congelamiento por Defecto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   "Por defecto, cerrado. Por excepcion, abierto."

   - La estructura documental esta CONGELADA por defecto
   - Cualquier cambio estructural requiere justificacion explicita
   - El descongelamiento es una EXCEPCION, no la norma

**Justificacion:** Protege la estabilidad estructural, reduce complejidad
cognitiva y mantiene trazabilidad simple.

1.2 Principio de Autoridad Explicita
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   "Toda decision tiene un responsable identificable."

   - No existen decisiones anonimas o difusas
   - Cada tipo de artefacto tiene un Owner definido
   - Cada proceso tiene roles RACI asignados

**Justificacion:** Elimina ambiguedad y permite auditoria.

1.3 Principio de Trazabilidad Total
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   "Todo cambio es rastreable hasta su origen."

   - Cada artefacto tiene historial de cambios
   - Cada decision se documenta con justificacion
   - Los enlaces entre artefactos son bidireccionales

**Justificacion:** Permite auditorias y analisis de impacto.

1.4 Principio de Minima Sorpresa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   "La estructura debe ser predecible e intuitiva."

   - Nomenclatura consistente en todo el sistema
   - Ubicaciones logicas y coherentes
   - Patrones repetibles entre dominios

**Justificacion:** Reduce curva de aprendizaje y errores.

1.5 Principio de Separacion de Responsabilidades
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   "Cada rol tiene responsabilidades claras y no superpuestas."

   - Owner de dominio != Aprobador de artefacto
   - Autor != Revisor
   - Quien propone != Quien aprueba

**Justificacion:** Garantiza revision cruzada y calidad.

----

2. Niveles de Decision
----------------------

El sistema IACT reconoce tres niveles jerarquicos de decision:

2.1 Nivel Estrategico
^^^^^^^^^^^^^^^^^^^^^

**Autoridades:** PMO, Sponsor, Comite de Arquitectura

**Ambito de Decisiones:**

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Decision
     - Ejemplo
   * - Crear o eliminar Dominios
     - "Crear dominio compliance/"
   * - Politicas de gobernanza global
     - "Adoptar versionado semantico"
   * - Cambios estructurales mayores
     - "Reorganizar jerarquia de 5 a 6 dominios"
   * - Asignacion de Owners de dominio
     - "PMO es owner de normativa/"
   * - Aprobacion de excepciones criticas
     - "Permitir subdominios adicionales"

**Frecuencia:** Decisiones raras (1-2 por trimestre)

**Documentacion:** Acta de comite + ADR si aplica

2.2 Nivel Tactico
^^^^^^^^^^^^^^^^^

**Autoridades:** Arquitecto de Documentacion, Tech Lead, Owner de Dominio

**Ambito de Decisiones:**

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Decision
     - Ejemplo
   * - Crear o eliminar Subdominios
     - "Crear subdominio integraciones/"
   * - Descongelar Subdominios
     - "Descongelar estandares/ para crear subcarpeta"
   * - Definir estandares tecnicos
     - "Adoptar formato RST para todo"
   * - Aprobar artefactos de alto impacto
     - "Aprobar BR que afecta multiples UC"
   * - Asignar Owners de subdominio
     - "BA Lead es owner de casos_uso/"

**Frecuencia:** Decisiones ocasionales (2-4 por mes)

**Documentacion:** Registro en historial + justificacion

2.3 Nivel Operativo
^^^^^^^^^^^^^^^^^^^

**Autoridades:** Business Analyst, Developer, QA, Tech Writer

**Ambito de Decisiones:**

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Decision
     - Ejemplo
   * - Crear artefactos individuales
     - "Crear UC_025_Exportar_Reporte.rst"
   * - Modificar contenido de artefactos
     - "Agregar flujo alterno a UC_010"
   * - Correcciones menores
     - "Corregir typo en FR-10.3"
   * - Proponer cambios estructurales
     - "Solicitar nueva seccion en dominio"

**Frecuencia:** Decisiones diarias

**Documentacion:** Historial de cambios del artefacto

----

3. Estructura de Autoridad por Dominio
--------------------------------------

3.1 Matriz de Owners
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 25 25 25

   * - Dominio
     - Owner Principal
     - Owner Secundario
     - Aprobador Final
   * - base_cognitiva/
     - Arquitecto Doc
     - Tech Lead
     - PMO
   * - normativa/
     - PMO
     - Arquitecto Doc
     - Sponsor
   * - requisitos/
     - BA Lead
     - Product Owner
     - PMO
   * - arquitectura_tecnica/
     - Tech Lead
     - Arquitecto
     - PMO
   * - usuario_gestion/
     - Tech Writer
     - PMO
     - PMO

3.2 Responsabilidades del Owner
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El Owner de un dominio o subdominio tiene las siguientes responsabilidades:

.. code-block:: text

   OBLIGATORIAS:
   - Mantener coherencia interna del dominio
   - Revisar y aprobar artefactos antes de publicacion
   - Garantizar cumplimiento de estandares
   - Mantener indice (index.rst) actualizado
   - Responder consultas sobre el dominio

   OPCIONALES:
   - Delegar revision a expertos tematicos
   - Proponer mejoras estructurales
   - Capacitar a nuevos miembros

3.3 Subdominios y sus Owners
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 25 25 20

   * - Subdominio
     - Dominio Padre
     - Owner
     - Estado
   * - _metadata/
     - base_cognitiva
     - PMO
     - Congelado
   * - glosario/
     - base_cognitiva
     - Arquitecto Doc
     - Congelado
   * - _fundamentos_conceptuales/
     - base_cognitiva
     - Arquitecto Doc
     - Congelado
   * - _ontologia_sbvr/
     - base_cognitiva
     - Arquitecto Doc
     - Congelado
   * - _taxonomias_y_metamodelos/
     - base_cognitiva
     - Arquitecto Doc
     - Descongelado
   * - procedimientos/
     - normativa
     - PMO
     - Congelado
   * - estandares/
     - normativa
     - Arquitecto Doc
     - Descongelado
   * - gobernanza/
     - normativa
     - PMO
     - Congelado
   * - restricciones/
     - normativa
     - Tech Lead
     - Congelado
   * - reglas_negocio/
     - requisitos
     - BA Lead
     - Congelado
   * - casos_uso/
     - requisitos
     - BA Lead
     - Congelado
   * - requisitos_funcionales/
     - requisitos
     - BA Lead
     - Congelado

----

4. Cadena de Escalamiento
-------------------------

4.1 Cuando Escalar
^^^^^^^^^^^^^^^^^^

Una decision debe escalarse al nivel superior cuando:

.. code-block:: text

   ESCALAR A NIVEL TACTICO (desde Operativo):
   - Cambio afecta mas de 3 artefactos
   - Cambio modifica estructura de subdominio
   - Conflicto entre artefactos de diferentes subdominios
   - Duda sobre interpretacion de estandares

   ESCALAR A NIVEL ESTRATEGICO (desde Tactico):
   - Cambio afecta mas de 1 dominio
   - Cambio requiere nuevo subdominio
   - Conflicto entre Owners de diferentes dominios
   - Excepcion a politicas de gobernanza
   - Impacto en cronograma o recursos significativo

4.2 Proceso de Escalamiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PASO 1: Documentar
   - Describir la decision requerida
   - Listar opciones consideradas
   - Indicar impacto estimado

   PASO 2: Notificar
   - Comunicar al nivel superior
   - Proporcionar documentacion
   - Establecer urgencia (Alta/Media/Baja)

   PASO 3: Esperar Resolucion
   - Nivel superior analiza
   - Puede solicitar informacion adicional
   - Emite decision documentada

   PASO 4: Implementar
   - Ejecutar decision
   - Documentar en historial
   - Comunicar a afectados

4.3 Tiempos de Respuesta
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 25 25 25

   * - Nivel
     - Urgencia Alta
     - Urgencia Media
     - Urgencia Baja
   * - Tactico
     - 4 horas
     - 24 horas
     - 72 horas
   * - Estrategico
     - 24 horas
     - 72 horas
     - 1 semana

----

5. Roles Documentales
---------------------

5.1 Catalogo de Roles
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Rol
     - Responsabilidad Principal
     - Nivel de Decision
   * - **PMO**
     - Gobernanza global, aprobaciones finales, politicas
     - Estrategico
   * - **Arquitecto Doc**
     - Estructura documental, coherencia, estandares
     - Tactico
   * - **BA Lead**
     - Requisitos, reglas de negocio, casos de uso
     - Tactico
   * - **Tech Lead**
     - Arquitectura tecnica, decisiones de diseno
     - Tactico
   * - **Business Analyst**
     - Crear y mantener artefactos de requisitos
     - Operativo
   * - **Developer**
     - Documentacion tecnica, diseno detallado
     - Operativo
   * - **Tech Writer**
     - Manuales de usuario, guias
     - Operativo
   * - **QA**
     - Validacion, evidencia, pruebas
     - Operativo
   * - **Auditor**
     - Verificacion de cumplimiento
     - Tactico

5.2 Incompatibilidades de Roles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para garantizar revision cruzada, los siguientes roles son incompatibles
en el mismo artefacto:

.. code-block:: text

   INCOMPATIBILIDADES:
   - Autor != Aprobador (mismo artefacto)
   - Creador de BR != Unico revisor de UC derivado
   - Owner de dominio != Unico auditor de ese dominio

   EXCEPCION:
   - En equipos pequenos (<3 personas), PMO puede actuar
     como respaldo cuando no hay alternativa

----

6. Procesos de Gobernanza
-------------------------

Este modelo de gobernanza se implementa mediante los siguientes procesos
documentados en artefactos separados:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Proceso
     - Artefacto
     - Proposito
   * - Roles y RACI
     - :ref:`gob-02`
     - Matriz detallada de responsabilidades
   * - Control de Calidad
     - :ref:`gob-03`
     - Criterios y checklists de calidad
   * - Gestion de Cambios
     - :ref:`gob-04`
     - Proceso para modificar artefactos aprobados
   * - Control de Versiones
     - :ref:`gob-05`
     - Estrategia de versionado semantico
   * - Trazabilidad SDLC
     - :ref:`gob-06`
     - Mantenimiento de enlaces entre fases
   * - Gestion de Dominios
     - :ref:`gob-07`
     - Definiciones y descongelamiento

----

7. Auditoria y Cumplimiento
---------------------------

7.1 Verificacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento de este modelo se verifica mediante:

.. code-block:: text

   VERIFICACION AUTOMATICA:
   - Sphinx build sin errores (estructura valida)
   - Metadata completa en todos los artefactos
   - Enlaces internos validos
   - Nomenclatura conforme a estandares

   VERIFICACION MANUAL:
   - Revision de historiales de cambios
   - Auditoria de aprobaciones
   - Verificacion de roles RACI
   - Muestreo de calidad documental

7.2 Frecuencia de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Tipo
     - Frecuencia
     - Responsable
   * - Build automatico
     - Cada commit
     - CI/CD
   * - Revision de Owner
     - Semanal
     - Owner de dominio
   * - Auditoria PMO
     - Mensual
     - PMO
   * - Auditoria externa
     - Por milestone SDLC
     - Auditor designado

7.3 No Conformidades
^^^^^^^^^^^^^^^^^^^^

Ante hallazgos de no conformidad:

.. code-block:: text

   SEVERIDAD CRITICA:
   - Artefacto sin metadata
   - Aprobacion sin revision
   - Cambio estructural no autorizado
   --> Accion: Correccion inmediata + escalamiento a PMO

   SEVERIDAD MAYOR:
   - Historial incompleto
   - Enlaces rotos
   - Nomenclatura incorrecta
   --> Accion: Correccion en 48 horas

   SEVERIDAD MENOR:
   - Typos
   - Formato inconsistente
   - Metadata incompleta no critica
   --> Accion: Correccion en proxima actualizacion

----

8. Diagrama del Modelo
----------------------

.. code-block:: text

                        ┌─────────────────────┐
                        │      SPONSOR        │
                        │  (Aprobador Final)  │
                        └──────────┬──────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                    │
              ▼                    ▼                    ▼
   ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
   │       PMO        │ │    ARQUITECTO    │ │    TECH LEAD     │
   │                  │ │   DOCUMENTACION  │ │                  │
   │ - Gobernanza     │ │                  │ │ - Arquitectura   │
   │ - Politicas      │ │ - Estructura     │ │ - Decisiones     │
   │ - Aprobaciones   │ │ - Estandares     │ │ - Diseno         │
   └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘
            │                    │                    │
            │         NIVEL ESTRATEGICO / TACTICO     │
   ─────────┼────────────────────┼────────────────────┼──────────
            │             NIVEL OPERATIVO             │
            │                    │                    │
            ▼                    ▼                    ▼
   ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
   │    BA / BA LEAD  │ │   TECH WRITER    │ │    DEVELOPER     │
   │                  │ │                  │ │                  │
   │ - Requisitos     │ │ - Manuales       │ │ - Diseno Det.    │
   │ - BR, UC, FR     │ │ - Guias          │ │ - Codigo         │
   └──────────────────┘ └──────────────────┘ └──────────────────┘
                                   │
                                   ▼
                        ┌──────────────────┐
                        │        QA        │
                        │                  │
                        │ - Validacion     │
                        │ - Evidencia      │
                        └──────────────────┘

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`gob-04` - Gestion de Cambios Documentales
- :ref:`gob-05` - Control de Versiones
- :ref:`meta-02` - Clasificacion Documental
- :ref:`meta-03` - Fases del Ciclo de Vida SDLC

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 9001:2015 - Sistemas de Gestion de Calidad
- ISO 15489 - Gestion de Documentos
- PMBOK - Project Management Body of Knowledge

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
     - 2025-12-22
     - Equipo IACT
     - Version inicial. Define modelo de gobernanza con 5 principios, 3 niveles de decision, matriz de owners, cadena de escalamiento y roles documentales.

----

**Trazabilidad:** Este artefacto es la raiz del subdominio gobernanza/.
Define la autoridad que legitima todos los demas artefactos normativos.
Es referenciado por GOB_02 a GOB_10 y por todos los procesos de aprobacion
del sistema documental IACT.