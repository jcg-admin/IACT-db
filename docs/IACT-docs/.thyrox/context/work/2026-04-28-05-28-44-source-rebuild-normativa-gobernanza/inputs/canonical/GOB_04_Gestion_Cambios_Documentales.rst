.. meta::
   :artefacto: GOB_04
   :tipo: Proceso
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-04:

=======================================
GOB_04: Gestion de Cambios Documentales
=======================================


Proposito
---------

Este documento define el **proceso de gestion de cambios** para artefactos
documentales ya aprobados en el sistema IACT, estableciendo los pasos,
aprobaciones y registros necesarios para modificar documentacion oficial.

.. important::

   **Pregunta Clave que Responde:**

   "¿Como modifico un documento que ya esta aprobado?"

----

1. Principios de Gestion de Cambios
-----------------------------------

1.1 Filosofia del Cambio Controlado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PRINCIPIO: Todo cambio a documentacion aprobada debe ser:

   - JUSTIFICADO   : Tiene una razon valida
   - EVALUADO      : Se analiza su impacto
   - APROBADO      : Por la autoridad competente
   - REGISTRADO    : En el historial del artefacto
   - COMUNICADO    : A los interesados

1.2 Objetivos del Control de Cambios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Mantener integridad de la documentacion aprobada
- Prevenir cambios no autorizados
- Preservar trazabilidad historica
- Facilitar auditoria de modificaciones
- Cumplir con ISO 9001 (control de documentos)

----

2. Tipos de Cambio
------------------

2.1 Clasificacion por Impacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 25 30 30

   * - Tipo
     - Descripcion
     - Ejemplos
     - Aprobacion
   * - **MENOR**
     - Correccion sin cambio de significado
     - Typos, formato, enlaces rotos
     - Autor directo
   * - **MODERADO**
     - Nuevo contenido o modificacion parcial
     - Nueva seccion, nuevos ejemplos, clarificaciones
     - Owner subdominio
   * - **MAYOR**
     - Cambio estructural o de proposito
     - Reorganizacion, cambio de alcance, fusion/division
     - Owner dominio + PMO
   * - **CRITICO**
     - Afecta multiples artefactos o dominios
     - Cambio de nomenclatura, reestructuracion masiva
     - PMO + Sponsor

2.2 Matriz de Decision de Tipo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ¿El cambio modifica el SIGNIFICADO?
       │
       ├── NO ──► ¿Solo corrige errores obvios?
       │              │
       │              ├── SI ──► MENOR (PATCH)
       │              │
       │              └── NO ──► MODERADO (MINOR)
       │
       └── SI ──► ¿Cambia estructura o proposito?
                      │
                      ├── NO ──► MODERADO (MINOR)
                      │
                      └── SI ──► ¿Afecta otros artefactos?
                                     │
                                     ├── NO ──► MAYOR (MAJOR)
                                     │
                                     └── SI ──► CRITICO

2.3 Ejemplos por Tipo
^^^^^^^^^^^^^^^^^^^^^

**Cambio MENOR:**

.. code-block:: text

   - Corregir "usuairo" por "usuario"
   - Arreglar enlace roto :ref:`gob-02`
   - Mejorar indentacion de codigo
   - Actualizar fecha en referencia externa

**Cambio MODERADO:**

.. code-block:: text

   - Agregar seccion de "Casos Especiales"
   - Incluir 5 nuevos ejemplos
   - Expandir descripcion de un proceso
   - Agregar diagrama explicativo
   - Clarificar ambiguedad reportada

**Cambio MAYOR:**

.. code-block:: text

   - Cambiar estructura de 5 a 8 secciones
   - Modificar proposito del artefacto
   - Eliminar seccion completa
   - Cambiar nomenclatura de IDs internos

**Cambio CRITICO:**

.. code-block:: text

   - Renombrar prefijo BR\_ a BRL_
   - Fusionar dos subdominios
   - Cambiar jerarquia de dominios
   - Modificar esquema de versionado

----

3. Proceso de Solicitud de Cambio
---------------------------------

3.1 Flujo General
^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌──────────────┐
   │  SOLICITANTE │
   │   (Detecta   │
   │   necesidad) │
   └──────┬───────┘
          │
          │ 1. Documenta solicitud
          ▼
   ┌──────────────┐
   │  SOLICITUD   │
   │  DE CAMBIO   │
   │   (RFC)      │
   └──────┬───────┘
          │
          │ 2. Evalua impacto
          ▼
   ┌──────────────┐
   │   ANALISIS   │
   │  DE IMPACTO  │
   └──────┬───────┘
          │
          │ 3. Determina tipo y aprobador
          ▼
   ┌──────────────┐      ┌──────────────┐
   │  APROBACION  │◄─────│  RECHAZO     │
   │              │      │  (Justificado)│
   └──────┬───────┘      └──────────────┘
          │
          │ 4. Implementa cambio
          ▼
   ┌──────────────┐
   │IMPLEMENTACION│
   │  (Autor)     │
   └──────┬───────┘
          │
          │ 5. Verifica y cierra
          ▼
   ┌──────────────┐
   │ VERIFICACION │
   │  Y CIERRE    │
   └──────────────┘

3.2 Paso 1: Documentar Solicitud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El solicitante debe completar:

.. code-block:: text

   SOLICITUD DE CAMBIO DOCUMENTAL (RFC)
   ====================================

   Fecha: YYYY-MM-DD
   Solicitante: [nombre]

   ARTEFACTO AFECTADO:
   - ID: [ej: GOB_02]
   - Version actual: [ej: 1.2.0]
   - Ubicacion: [ruta completa]

   DESCRIPCION DEL CAMBIO:
   [Descripcion clara y especifica de que se quiere cambiar]

   JUSTIFICACION:
   [Por que es necesario este cambio]

   TIPO PROPUESTO:
   [ ] MENOR    [ ] MODERADO    [ ] MAYOR    [ ] CRITICO

   URGENCIA:
   [ ] Alta (< 24h)    [ ] Media (< 72h)    [ ] Baja (< 1 semana)

   ARTEFACTOS RELACIONADOS:
   [Lista de otros artefactos que podrian verse afectados]

3.3 Paso 2: Analisis de Impacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El Owner o Arquitecto evalua:

.. code-block:: text

   ANALISIS DE IMPACTO
   ===================

   RFC: [referencia]
   Evaluador: [nombre]
   Fecha: YYYY-MM-DD

   1. IMPACTO EN TRAZABILIDAD:
      [ ] No afecta trazabilidad
      [ ] Requiere actualizar RTM
      [ ] Rompe enlaces existentes (listar cuales)

   2. ARTEFACTOS AFECTADOS:
      - [ID_1]: [tipo de impacto]
      - [ID_2]: [tipo de impacto]

   3. ESFUERZO ESTIMADO:
      [ ] Bajo (< 1 hora)
      [ ] Medio (1-4 horas)
      [ ] Alto (> 4 horas)

   4. RIESGOS IDENTIFICADOS:
      - [riesgo 1]
      - [riesgo 2]

   5. TIPO CONFIRMADO:
      [ ] MENOR    [ ] MODERADO    [ ] MAYOR    [ ] CRITICO

   6. RECOMENDACION:
      [ ] APROBAR    [ ] RECHAZAR    [ ] DIFERIR

   JUSTIFICACION:
   [Explicacion de la recomendacion]

3.4 Paso 3: Aprobacion
^^^^^^^^^^^^^^^^^^^^^^

Segun tipo de cambio:

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Tipo
     - Aprobador
     - Proceso
   * - MENOR
     - Autor
     - Autoservicio, solo registrar en historial
   * - MODERADO
     - Owner Subdominio
     - Revisar RFC + Impacto, aprobar via buzon interno
   * - MAYOR
     - Owner Dominio + PMO
     - Revisar RFC + Impacto, reunion si necesario
   * - CRITICO
     - PMO + Sponsor
     - Presentacion formal, acta de decision

**Formato de Aprobacion:**

.. code-block:: text

   APROBACION DE CAMBIO
   ====================

   RFC: [referencia]
   Fecha: YYYY-MM-DD

   DECISION: [ ] APROBADO    [ ] RECHAZADO    [ ] DIFERIDO

   APROBADORES:
   - [Nombre 1]: [Rol] - [Firma/Confirmacion]
   - [Nombre 2]: [Rol] - [Firma/Confirmacion]

   CONDICIONES (si aplica):
   [Condiciones especiales para la implementacion]

   FECHA LIMITE IMPLEMENTACION: YYYY-MM-DD

3.5 Paso 4: Implementacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

El autor implementa el cambio:

.. code-block:: text

   CHECKLIST DE IMPLEMENTACION:

   [ ] Crear copia de respaldo del artefacto actual
   [ ] Aplicar cambios segun RFC aprobado
   [ ] Actualizar campo :version: segun GOB_05
   [ ] Actualizar campo :ultimo_cambio:
   [ ] Agregar entrada en Historial de Cambios
   [ ] Verificar compilacion Sphinx sin errores
   [ ] Verificar enlaces internos
   [ ] Actualizar artefactos relacionados (si aplica)

3.6 Paso 5: Verificacion y Cierre
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VERIFICACION DE CAMBIO
   ======================

   RFC: [referencia]
   Verificador: [nombre - diferente al autor]
   Fecha: YYYY-MM-DD

   VERIFICACIONES:
   [ ] Cambio implementado segun RFC
   [ ] Version incrementada correctamente
   [ ] Historial actualizado
   [ ] Sphinx compila sin errores
   [ ] Enlaces funcionan
   [ ] Artefactos relacionados actualizados

   RESULTADO: [ ] CONFORME    [ ] NO CONFORME

   OBSERVACIONES:
   [Si no conforme, detallar que falta]

   CIERRE:
   [ ] RFC cerrado exitosamente
   Fecha cierre: YYYY-MM-DD

----

4. Cambios de Emergencia
------------------------

4.1 Definicion de Emergencia
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Un cambio de emergencia aplica cuando:

.. code-block:: text

   CRITERIOS DE EMERGENCIA:

   - Error critico que impide uso del sistema
   - Informacion incorrecta que causa confusion grave
   - Vulnerabilidad de seguridad documentada
   - Requisito legal/regulatorio inmediato
   - Bloqueo de proceso critico de negocio

4.2 Proceso Abreviado
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CAMBIO DE EMERGENCIA - Proceso Express
   ======================================

   1. Notificar a PMO inmediatamente (buzon interno urgente)

   2. Documentar minimo:
      - Artefacto afectado
      - Descripcion del problema
      - Cambio propuesto
      - Justificacion de urgencia

   3. Aprobacion verbal de PMO o Owner disponible

   4. Implementar cambio

   5. Documentar RFC completo dentro de 24 horas

   6. Validacion post-implementacion obligatoria

4.3 Registro de Emergencia
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGISTRO DE CAMBIO DE EMERGENCIA
   ================================

   Fecha/Hora: YYYY-MM-DD HH:MM
   Solicitante: [nombre]

   ARTEFACTO: [ID]

   PROBLEMA DETECTADO:
   [Descripcion breve del problema critico]

   CAMBIO APLICADO:
   [Que se cambio]

   APROBACION VERBAL:
   - Otorgada por: [nombre]
   - Fecha/Hora: [timestamp]

   DOCUMENTACION COMPLETA:
   [ ] Pendiente - Fecha limite: [fecha]
   [ ] Completada - RFC: [referencia]

----

5. Rechazo de Cambios
---------------------

5.1 Motivos Validos de Rechazo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MOTIVOS PARA RECHAZAR UN CAMBIO:

   - No tiene justificacion suficiente
   - Impacto negativo mayor que beneficio
   - Rompe trazabilidad sin solucion viable
   - Contradice politicas de gobernanza
   - Recursos insuficientes para implementar
   - Timing inadecuado (ej: cerca de release)
   - Ya existe otro RFC para el mismo cambio

5.2 Comunicacion del Rechazo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   NOTIFICACION DE RECHAZO
   =======================

   RFC: [referencia]
   Fecha: YYYY-MM-DD

   Estimado [solicitante],

   Su solicitud de cambio ha sido RECHAZADA.

   MOTIVO:
   [Explicacion clara y respetuosa del rechazo]

   ALTERNATIVAS SUGERIDAS:
   [Si aplica, sugerir opciones alternativas]

   APELACION:
   Si considera que esta decision debe reconsiderarse,
   puede escalar a [siguiente nivel] dentro de [plazo].

   Atentamente,
   [Aprobador]

5.3 Proceso de Apelacion
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   APELACION (si el solicitante no esta de acuerdo):

   1. Enviar apelacion escrita dentro de 5 dias habiles

   2. Incluir:
      - RFC original
      - Motivo del rechazo
      - Argumentos para reconsiderar
      - Nueva informacion (si existe)

   3. Escalamiento:
      - Si rechazo fue de Owner Subdominio → Owner Dominio
      - Si rechazo fue de Owner Dominio → PMO
      - Si rechazo fue de PMO → Sponsor (ultima instancia)

   4. Decision de apelacion es FINAL

----

6. Registro y Auditoria
-----------------------

6.1 Registro en Historial del Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo cambio aprobado debe registrarse:

.. code-block:: rst

   Historial de Cambios
   --------------------

   .. list-table::
      :header-rows: 1
      :widths: 15 15 20 50

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 1.2.0
        - 2025-12-22
        - J. Perez
        - RFC-045: Agregada seccion 5 sobre casos especiales.
          Aprobado por M. Garcia (Owner).
      * - 1.1.1
        - 2025-12-20
        - A. Lopez
        - Corregidos typos en seccion 3 (cambio menor).

6.2 Registro Centralizado de RFCs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Mantener registro de todas las solicitudes:

.. code-block:: text

   REGISTRO DE RFCs - {AÑO}
   ========================

.. list-table::
   :header-rows: 1

   * - RFC
     - Fecha
     - Artefacto
     - Tipo
     - Estado
     - Aprobador
   * - RFC-001
     - 2025-01-15
     - GOB_02
     - MODERADO
     - Cerrado
     - M. Garcia
   * - RFC-002
     - 2025-01-20
     - BR_015
     - MENOR
     - Cerrado
     - Auto
   * - RFC-003
     - 2025-02-01
     - UC_010
     - MAYOR
     - En proceso
     - Pendiente
   * - RFC-004
     - 2025-02-05
     - FND_03
     - MODERADO
     - Rechazado
     - A. Lopez

6.3 Metricas de Gestion de Cambios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Metrica
     - Formula
     - Meta
   * - Tiempo promedio de aprobacion
     - Suma tiempos / Total RFCs
     - < 48 horas
   * - Tasa de aprobacion
     - Aprobados / Total RFCs
     - > 80%
   * - Cambios de emergencia
     - Emergencias / Total cambios
     - < 5%
   * - RFCs con documentacion completa
     - Completos / Total RFCs
     - 100%

----

7. Casos Especiales
-------------------

7.1 Cambio que Afecta Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si el cambio rompe enlaces de trazabilidad:

.. code-block:: text

   PROCESO ADICIONAL:

   1. Identificar todos los artefactos afectados

   2. Planificar actualizacion de RTM

   3. Incluir en RFC:
      - Lista de enlaces a actualizar
      - Responsable de cada actualizacion
      - Cronograma de actualizacion

   4. No cerrar RFC hasta que TODOS los enlaces
      esten actualizados y verificados

7.2 Cambio en Artefacto Referenciado por Muchos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si el artefacto es referenciado por > 10 artefactos:

.. code-block:: text

   PROCESO ADICIONAL:

   1. Generar lista de artefactos que referencian

   2. Evaluar impacto en cada uno

   3. Notificar a todos los Owners afectados

   4. Considerar periodo de transicion:
      - Mantener version anterior disponible
      - Deprecar gradualmente
      - Comunicar cronograma

7.3 Reversion de Cambio (Rollback)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si un cambio aprobado causa problemas:

.. code-block:: text

   PROCESO DE ROLLBACK:

   1. Documentar problema causado por el cambio

   2. Crear nuevo RFC para reversion
      - Tipo: Segun impacto de la reversion
      - Justificacion: Problema causado

   3. Implementar reversion:
      - NO decrementar version
      - Crear nueva version con contenido anterior
      - Documentar: "Revertido a contenido de vX.Y.Z"

   4. Analizar causa raiz del problema

   5. Documentar lecciones aprendidas

----

8. Responsabilidades
--------------------

8.1 Matriz RACI para Gestion de Cambios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 15 15 15 15 15

   * - Actividad
     - Solicit.
     - Owner Sub
     - Owner Dom
     - PMO
     - Autor
   * - Crear RFC
     - R
     - I
     - I
     - I
     - C
   * - Analizar impacto
     - C
     - R
     - C
     - I
     - C
   * - Aprobar MENOR
     - I
     - I
     - I
     - I
     - R/A
   * - Aprobar MODERADO
     - I
     - R/A
     - I
     - I
     - I
   * - Aprobar MAYOR
     - I
     - C
     - R/A
     - A
     - I
   * - Aprobar CRITICO
     - I
     - C
     - C
     - R/A
     - I
   * - Implementar cambio
     - I
     - C
     - I
     - I
     - R
   * - Verificar cambio
     - I
     - R
     - I
     - I
     - I

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`gob-05` - Control de Versiones

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 9001:2015 - Control de Documentos
- ITIL - Change Management

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
     - Version inicial. Tipos de cambio (MENOR/MODERADO/MAYOR/CRITICO). Proceso de 5 pasos. Cambios de emergencia. Rechazo y apelacion. Registro y auditoria.

----

**Trazabilidad:** Este artefacto define el proceso para modificar cualquier
artefacto aprobado del sistema documental IACT. Es referenciado cuando se
requiere cambiar documentacion oficial. Las versiones resultantes se gestionan
segun :ref:`gob-05`.