.. meta::
   :artefacto: TPL_001
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _tpl-001:

==============================================================================
TPL_001: Plantilla de Regla de Negocio (BR)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Esta plantilla define la estructura estandar para documentar Reglas de Negocio
(Business Rules) en el proyecto IACT. Basada en FND_02 y metodologia SBVR.

----

Instrucciones de Uso
--------------------

1. Copiar este archivo como ``BR_NNN_Nombre_Descriptivo.rst``
2. Reemplazar todos los marcadores ``[PLACEHOLDER]`` con valores reales
3. Eliminar secciones opcionales no aplicables
4. Mantener formato RST valido

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
      :version: [X.Y.Z]
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: [Nombre]
      :clasificacion: Interno

   .. _br-[nnn]:

   ==============================================================================
   BR_[NNN]: [Nombre Descriptivo de la Regla]
   ==============================================================================

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
        - [Nombre descriptivo corto]
      * - **Tipo**
        - [Hecho | Restriccion | Desencadenador | Inferencia | Calculo]
      * - **Categoria**
        - [Operacional | Estructural | Seguridad | Compliance]
      * - **Criticidad**
        - [Alta | Media | Baja]
      * - **Estado**
        - [Vigente | Revision | Obsoleta]

   ----

   1. Definicion Formal
   --------------------

   1.1 Enunciado de la Regla
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. note:: **Regla de Negocio BR_[NNN]**

      [Enunciado formal de la regla en lenguaje natural estructurado.
      Usar formato: "SUJETO + VERBO MODAL + PREDICADO"]

      Ejemplo: "Todo usuario DEBE autenticarse antes de acceder al dashboard."

   1.2 Formulacion SBVR
   ^^^^^^^^^^^^^^^^^^^^

   .. code-block:: text

      VOCABULARIO:
        - [Termino 1]: [Definicion]
        - [Termino 2]: [Definicion]

      REGLA:
        Es [obligatorio | prohibido | permitido] que [condicion]
        [cuando | si | siempre que] [contexto]

   1.3 Justificacion
   ^^^^^^^^^^^^^^^^^

   [Explicar POR QUE existe esta regla. Cual es el riesgo si no se cumple?
   Que problema de negocio resuelve?]

   ----

   2. Clasificacion
   ----------------

   2.1 Tipo de Regla
   ^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 0

      * - **Tipo**
        - [Seleccionar uno]
      * - 
        - [ ] **Hecho**: Define estructura o relacion del dominio
      * - 
        - [ ] **Restriccion**: Limita acciones o valores permitidos
      * - 
        - [ ] **Desencadenador**: Genera comportamiento observable (SI...ENTONCES)
      * - 
        - [ ] **Inferencia**: Deriva hechos internos no observables
      * - 
        - [ ] **Calculo**: Transforma datos mediante algoritmo

   2.2 Naturaleza
   ^^^^^^^^^^^^^^

   - **Estatica/Dinamica**: [Estatica - rara vez cambia | Dinamica - cambia frecuentemente]
   - **Automatizable**: [Si | No | Parcial]
   - **Alcance**: [Sistema completo | Modulo especifico | Rol especifico]

   ----

   3. Origen y Autoridad
   ---------------------

   3.1 Fuente Primaria
   ^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Documento**
        - [Nombre del documento fuente]
      * - **Seccion**
        - [Seccion o pagina especifica]
      * - **Version**
        - [Version del documento]
      * - **Fecha**
        - [Fecha del documento]
      * - **Tipo Fuente**
        - [CNST | Politica | Regulacion | Contrato | Estandar]

   3.2 Autoridad de Modificacion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Responsable**: [Rol o persona que puede modificar]
   - **Proceso de Cambio**: [Descripcion del proceso para modificar]
   - **Frecuencia de Revision**: [Anual | Semestral | Cuando aplique]

   ----

   4. Aplicacion en Sistema
   ------------------------

   4.1 Donde Aplica
   ^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Componente
        - Descripcion de Aplicacion
      * - [Modulo/Componente 1]
        - [Como se aplica la regla aqui]
      * - [Modulo/Componente 2]
        - [Como se aplica la regla aqui]

   4.2 Actores Afectados
   ^^^^^^^^^^^^^^^^^^^^^

   - **Roles**: [Lista de roles afectados por la regla]
   - **Sistemas Externos**: [Sistemas que deben cumplir la regla]

   4.3 Excepciones
   ^^^^^^^^^^^^^^^

   [Describir casos donde la regla NO aplica, si existen.
   Si no hay excepciones, indicar "Sin excepciones definidas."]

   ----

   5. Trazabilidad
   ---------------

   5.1 Restricciones Origen (CNST)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - CNST
        - Relacion
      * - CNST_[NNN]
        - [Descripcion de como CNST origina esta BR]

   5.2 Requisitos de Negocio Derivados (BReq)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - BReq
        - Descripcion
      * - BReq_[NNN]
        - [Requisito de negocio que implementa esta BR]

   5.3 Casos de Uso Afectados (UC)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - UC
        - Donde Aplica
      * - UC_[NNN]
        - [Precondicion | Validacion | Flujo Alterno | Postcondicion]

   ----

   6. Verificacion
   ---------------

   6.1 Criterios de Cumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   La regla se considera cumplida cuando:

   1. [Criterio verificable 1]
   2. [Criterio verificable 2]
   3. [Criterio verificable N]

   6.2 Metodo de Verificacion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Tipo**: [Manual | Automatizado | Mixto]
   - **Frecuencia**: [Continua | Por transaccion | Periodica]
   - **Responsable**: [Rol que verifica cumplimiento]

   6.3 Consecuencias de Incumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   [Describir que sucede si la regla no se cumple:
   - Mensaje de error al usuario
   - Bloqueo de operacion
   - Registro en auditoria
   - Notificacion a supervisor]

   ----

   7. Historial de Cambios
   -----------------------

   .. list-table::
      :widths: 15 15 20 50
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Descripcion del Cambio
      * - 1.0.0
        - [YYYY-MM-DD]
        - [Nombre]
        - Version inicial

----

Ejemplo de Uso
--------------

Ver ``BR_001_Inmutabilidad_Fuente.rst`` para un ejemplo completo de aplicacion
de esta plantilla.

----

Referencias
-----------

- FND_02: Reglas de Negocio (definiciones y clasificacion)
- FND_05: Jerarquia de Requisitos (relacion BR con otros artefactos)
- SBVR: Semantics of Business Vocabulary and Rules (OMG)
- ESTRUCTURA v2.0.0: Modelo Documental IACT

----

*Plantilla version 1.0.0 - Proyecto IACT Dashboard Analytics*
