.. meta::
   :artefacto: GOB_03
   :tipo: Proceso
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.1
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-03:

=====================================
GOB_03: Control de Calidad Documental
=====================================


Proposito
---------

Este documento define los **criterios de calidad**, **checklists de verificacion**
y **procesos de revision** que garantizan que todos los artefactos del sistema
documental IACT cumplan con los estandares establecidos antes de su aprobacion.

.. important::

   **Pregunta Clave que Responde:**

   "¿Como se si un documento esta listo para aprobar?"

----

1. Principios de Calidad Documental
-----------------------------------

1.1 Definicion de Calidad
^^^^^^^^^^^^^^^^^^^^^^^^^

Un artefacto documental es de **calidad** cuando:

.. code-block:: text

   COMPLETO    - Contiene toda la informacion requerida
   CORRECTO    - La informacion es precisa y verificable
   CONSISTENTE - Usa terminologia y formato uniforme
   CLARO       - Es comprensible para su audiencia
   TRAZABLE    - Tiene enlaces validos a artefactos relacionados

1.2 Niveles de Calidad
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Nivel
     - Descripcion
     - Criterio de Paso
   * - **Minimo**
     - Requisitos obligatorios
     - 100% de criterios minimos cumplidos
   * - **Estandar**
     - Calidad esperada normal
     - Minimo + 80% de criterios estandar
   * - **Excelente**
     - Calidad superior
     - Estandar + criterios opcionales

----

2. Criterios Universales (Todos los Artefactos)
-----------------------------------------------

2.1 Criterios Minimos Obligatorios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo artefacto IACT **DEBE** cumplir estos criterios para ser aprobado:

**Estructura:**

.. code-block:: text

   [CU-01] Bloque .. meta:: presente y completo
   [CU-02] Campo :artefacto: con ID correcto (PREFIJO_NNN)
   [CU-03] Campo :version: en formato X.Y.Z (>= 1.0.0 si Aprobado)
   [CU-04] Campo :estado: con valor valido

.. note::

   La version de un artefacto con estado APROBADO debe ser >= 1.0.0.
   Ver :ref:`gob-05` seccion 3 para reglas completas de versionado.
   [CU-05] Campo :fecha_creacion: en formato YYYY-MM-DD
   [CU-06] Campo :ultimo_cambio: en formato YYYY-MM-DD
   [CU-07] Campo :autor: identificado
   [CU-08] Campo :clasificacion: con nivel valido
   [CU-09] Etiqueta de referencia (.. _prefijo-nn:)
   [CU-10] Titulo principal con formato correcto (===)

**Contenido:**

.. code-block:: text

   [CU-11] Seccion "Proposito" presente
   [CU-12] Seccion "Historial de Cambios" presente
   [CU-13] Al menos una entrada en historial
   [CU-14] Sin errores de compilacion Sphinx
   [CU-15] Sin enlaces rotos internos

2.2 Valores Validos por Campo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Campo :estado:**

.. code-block:: text

   Valores permitidos:
   - Borrador
   - En_Revision
   - Aprobado
   - Obsoleto
   - Archivado

**Campo :clasificacion:**

.. code-block:: text

   Valores permitidos:
   - Publico
   - Interno
   - Confidencial
   - Restringido

**Campo :tipo:**

.. code-block:: text

   Valores permitidos por dominio:

   base_cognitiva:
   - Metadata, Glosario, Fundamento, Ontologia, Taxonomia, Metamodelo

   normativa:
   - Politica, Proceso, Estandar, Restriccion, Matriz

   requisitos:
   - Regla_Negocio, Caso_Uso, Requisito_Funcional, Requisito_No_Funcional

2.3 Criterios Estandar
^^^^^^^^^^^^^^^^^^^^^^

Criterios esperados para calidad normal:

.. code-block:: text

   [CE-01] Usa vocabulario controlado (SBVR_05)
   [CE-02] Titulos de seccion descriptivos
   [CE-03] Tablas con encabezados claros
   [CE-04] Ejemplos ilustrativos donde aplique
   [CE-05] Referencias a documentos relacionados
   [CE-06] Sin typos ni errores gramaticales evidentes
   [CE-07] Formato consistente (listas, codigo, etc.)
   [CE-08] Longitud apropiada (ni muy corto ni excesivo)

----

3. Criterios Especificos por Tipo de Artefacto
----------------------------------------------

3.1 Reglas de Negocio (BR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CRITERIOS MINIMOS BR:
   [BR-01] Campo :tipo_br: presente (Hecho/Restriccion/Trigger/Inferencia/Calculo)
   [BR-02] Definicion clara de la regla
   [BR-03] Fuente documentada
   [BR-04] Usa keywords DEBE/NO DEBE/PUEDE correctamente

   CRITERIOS ESTANDAR BR:
   [BR-05] Modalidad especificada (Aletica/Deontica)
   [BR-06] Justificacion de negocio
   [BR-07] Ejemplos de aplicacion
   [BR-08] Excepciones documentadas (si aplica)
   [BR-09] Referencia a UC derivados (si es Trigger)

**Ejemplo de BR con Calidad Minima:**

.. code-block:: rst

   .. meta::
      :artefacto: BR_015
      :tipo_br: Restriccion
      :modalidad: Deontica
      ...

   BR_015: Separacion de Funciones
   ===============================

   Definicion
   ----------
   Un usuario con rol de administrador de usuarios NO DEBE
   tener simultaneamente rol de auditor del sistema.

   Fuente
   ------
   Politica de Seguridad Corporativa, Seccion 4.2

3.2 Casos de Uso (UC\_)
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CRITERIOS MINIMOS UC:
   [UC-01] Actor primario identificado
   [UC-02] Objetivo/meta del caso de uso
   [UC-03] Precondiciones listadas
   [UC-04] Flujo principal con minimo 3 pasos
   [UC-05] Postcondiciones listadas
   [UC-06] Al menos 1 BR referenciada

   CRITERIOS ESTANDAR UC:
   [UC-07] Flujos alternativos documentados
   [UC-08] Flujos de excepcion documentados
   [UC-09] Trigger/disparador especificado
   [UC-10] Frecuencia estimada
   [UC-11] Stakeholders secundarios identificados
   [UC-12] Reglas de negocio en contexto

**Plantilla de Flujo Principal:**

.. code-block:: text

   FLUJO PRINCIPAL:
   1. [Actor] inicia el caso de uso mediante [accion]
   2. Sistema valida [condicion]
   3. Sistema ejecuta [proceso]
   4. Sistema presenta [resultado] al actor
   5. Actor confirma [accion final]
   6. Sistema registra [auditoria]

3.3 Requisitos Funcionales (FR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CRITERIOS MINIMOS FR:
   [FR-01] ID en formato FR-UC.SEQ (ej: FR-10.3)
   [FR-02] Enunciado atomico (una sola capacidad)
   [FR-03] Verbo en forma "El sistema DEBE..."
   [FR-04] Criterio de aceptacion verificable
   [FR-05] UC de origen referenciado

   CRITERIOS ESTANDAR FR:
   [FR-06] Paso del UC de origen indicado
   [FR-07] Prioridad asignada (Alta/Media/Baja)
   [FR-08] Complejidad estimada
   [FR-09] Dependencias con otros FR

**Ejemplo de FR con Calidad Minima:**

.. code-block:: rst

   FR-10.3: Validar Rol Existente
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Enunciado:** El sistema DEBE verificar que el rol a asignar
   exista en el catalogo de roles antes de proceder con la asignacion.

   **Origen:** UC-010, Paso 3

   **Criterio de Aceptacion:** Dado un rol_id, el sistema retorna
   TRUE si existe en tabla roles, FALSE en caso contrario.

3.4 Artefactos de Gobernanza (GOB\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CRITERIOS MINIMOS GOB:
   [GOB-01] Proposito claramente definido
   [GOB-02] Alcance especificado
   [GOB-03] Roles involucrados identificados
   [GOB-04] Proceso o politica descrito paso a paso

   CRITERIOS ESTANDAR GOB:
   [GOB-05] Diagrama de flujo o proceso
   [GOB-06] Excepciones documentadas
   [GOB-07] Metricas de cumplimiento
   [GOB-08] Referencias a otros GOB relacionados

3.5 Restricciones (CNST\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CRITERIOS MINIMOS CNST:
   [CNST-01] Restriccion claramente enunciada
   [CNST-02] Justificacion/origen de la restriccion
   [CNST-03] Impacto documentado
   [CNST-04] Componentes afectados listados

   CRITERIOS ESTANDAR CNST:
   [CNST-05] Alternativas consideradas
   [CNST-06] Mitigaciones posibles
   [CNST-07] Fecha de vigencia
   [CNST-08] Condiciones de revision

----

4. Checklists de Verificacion
-----------------------------

4.1 Checklist Pre-Envio a Revision
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El **Autor** debe verificar antes de enviar a revision:

.. code-block:: text

   CHECKLIST AUTOR (antes de enviar):

   ESTRUCTURA:
   [ ] Bloque meta completo con todos los campos
   [ ] Etiqueta de referencia presente
   [ ] Titulo principal correcto
   [ ] Secciones obligatorias presentes
   [ ] Historial de cambios actualizado

   CONTENIDO:
   [ ] Proposito claro y especifico
   [ ] Contenido completo segun tipo de artefacto
   [ ] Ejemplos donde corresponda
   [ ] Sin contenido placeholder (TODO, TBD, etc.)

   FORMATO:
   [ ] Sphinx compila sin errores
   [ ] Sphinx compila sin warnings criticos
   [ ] Enlaces internos funcionan
   [ ] Tablas renderizadas correctamente

   CALIDAD:
   [ ] Revision ortografica realizada
   [ ] Vocabulario controlado usado
   [ ] Consistencia con artefactos relacionados

4.2 Checklist de Revision
^^^^^^^^^^^^^^^^^^^^^^^^^

El **Revisor** debe verificar:

.. code-block:: text

   CHECKLIST REVISOR:

   CUMPLIMIENTO:
   [ ] Criterios minimos universales (CU-01 a CU-15)
   [ ] Criterios minimos especificos del tipo
   [ ] Criterios estandar (al menos 80%)

   PRECISION:
   [ ] Informacion es correcta y verificable
   [ ] No hay contradicciones internas
   [ ] Consistente con artefactos referenciados

   CLARIDAD:
   [ ] Comprensible para audiencia objetivo
   [ ] Sin ambiguedades
   [ ] Ejemplos son utiles y correctos

   TRAZABILIDAD:
   [ ] Referencias a otros artefactos son validas
   [ ] Relaciones bidireccionales verificadas

   DECISION:
   [ ] APROBAR - Cumple todos los criterios
   [ ] DEVOLVER - Requiere correcciones (listar)
   [ ] RECHAZAR - Problemas fundamentales (justificar)

4.3 Checklist Pre-Aprobacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El **Aprobador** (Owner/PMO) debe verificar:

.. code-block:: text

   CHECKLIST APROBADOR:

   PROCESO:
   [ ] Revision completada por revisor autorizado
   [ ] Observaciones del revisor atendidas
   [ ] Version correcta (no duplicada)

   GOBERNANZA:
   [ ] Autor tiene permiso para crear este tipo
   [ ] Clasificacion de seguridad apropiada
   [ ] No viola restricciones existentes

   IMPACTO:
   [ ] Trazabilidad no se rompe
   [ ] Consistente con artefactos aprobados
   [ ] No genera conflictos con otros en revision

   APROBACION:
   [ ] Cambiar estado a "Aprobado"
   [ ] Actualizar fecha de ultimo cambio
   [ ] Notificar a interesados

----

5. Proceso de Revision
----------------------

5.1 Flujo de Revision
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌─────────────┐
   │   AUTOR     │
   │  (Crea)     │
   └──────┬──────┘
          │
          │ Checklist Autor ✓
          ▼
   ┌─────────────┐
   │  BORRADOR   │
   │             │
   └──────┬──────┘
          │
          │ Enviar a revision
          ▼
   ┌─────────────┐
   │ EN_REVISION │◄────────────────┐
   │             │                 │
   └──────┬──────┘                 │
          │                        │
          │ Checklist Revisor      │
          ▼                        │
   ┌─────────────┐                 │
   │  REVISOR    │                 │
   │ (Evalua)    │                 │
   └──────┬──────┘                 │
          │                        │
     ┌────┴────┐                   │
     │         │                   │
     ▼         ▼                   │
  APRUEBA   DEVUELVE ──────────────┘
     │      (con comentarios)
     │
     │ Checklist Aprobador ✓
     ▼
   ┌─────────────┐
   │  APROBADOR  │
   │  (Owner)    │
   └──────┬──────┘
          │
          ▼
   ┌─────────────┐
   │  APROBADO   │
   │             │
   └─────────────┘

5.2 Tiempos de Revision
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 25 25 20

   * - Tipo de Artefacto
     - Revision
     - Aprobacion
     - Total Max
   * - BR\_, UC\_, FR\_
     - 48 horas
     - 24 horas
     - 72 horas
   * - GOB\_, STD\_, PROC\_
     - 72 horas
     - 48 horas
     - 120 horas
   * - FND\_, SBVR\_, TXM\_, MTM\_
     - 72 horas
     - 48 horas
     - 120 horas
   * - CNST\_
     - 48 horas
     - 24 horas
     - 72 horas
   * - META\_
     - 24 horas
     - 24 horas
     - 48 horas

5.3 Roles en el Proceso
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Rol
     - Responsabilidad
     - Puede Ser
   * - **Autor**
     - Crea el artefacto, aplica correcciones
     - Cualquier usuario con permiso de escritura
   * - **Revisor**
     - Evalua calidad tecnica y contenido
     - Par del autor o experto tematico
   * - **Aprobador**
     - Aprobacion final, cambia estado
     - Owner del dominio/subdominio o PMO

5.4 Comunicacion de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Aprobacion:**

.. code-block:: text

   Notificacion via buzon interno:

   Asunto: [APROBADO] {ID_Artefacto} - {Nombre}

   El artefacto {ID} ha sido aprobado.
   Version: {version}
   Aprobador: {nombre}
   Fecha: {fecha}

   El artefacto esta disponible en: {ubicacion}

**Devolucion:**

.. code-block:: text

   Notificacion via buzon interno:

   Asunto: [REVISION] {ID_Artefacto} - Requiere cambios

   El artefacto {ID} requiere correcciones:

   OBSERVACIONES:
   1. {observacion_1}
   2. {observacion_2}
   ...

   Por favor, realice las correcciones y reenvie a revision.
   Revisor: {nombre}
   Fecha limite sugerida: {fecha}

----

6. Metricas de Calidad
----------------------

6.1 Indicadores de Calidad
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 25 20 20

   * - Metrica
     - Formula
     - Meta
     - Frecuencia
   * - Tasa de Aprobacion Primera Vez
     - Aprobados 1ra vez / Total enviados
     - >= 70%
     - Mensual
   * - Tiempo Promedio de Revision
     - Suma tiempos / Cantidad revisiones
     - < 48 horas
     - Semanal
   * - Artefactos con Metadata Completa
     - Con metadata / Total artefactos
     - 100%
     - Continuo
   * - Enlaces Rotos
     - Enlaces rotos / Total enlaces
     - 0%
     - Cada build
   * - Cobertura de Trazabilidad
     - Con trazabilidad / Total BR+UC+FR
     - >= 95%
     - Mensual

6.2 Reporte de Calidad
^^^^^^^^^^^^^^^^^^^^^^

Generado mensualmente por QA:

.. code-block:: text

   REPORTE DE CALIDAD DOCUMENTAL - {MES} {AÑO}
                                              

   1. VOLUMETRIA
      - Artefactos totales: {n}
      - Nuevos este mes: {n}
      - Modificados este mes: {n}

   2. ESTADO DE ARTEFACTOS
      - Aprobados: {n} ({%})
      - En revision: {n} ({%})
      - Borrador: {n} ({%})

   3. METRICAS DE CALIDAD
      - Aprobacion 1ra vez: {%}
      - Tiempo promedio revision: {horas} hrs
      - Metadata completa: {%}
      - Enlaces rotos: {n}

   4. HALLAZGOS
      - {lista de problemas encontrados}

   5. ACCIONES RECOMENDADAS
      - {lista de acciones}

----

7. Errores Comunes y Como Evitarlos
-----------------------------------

7.1 Errores de Estructura
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - Error
     - Ejemplo
     - Solucion
   * - Metadata incompleta
     - Falta :clasificacion:
     - Usar plantilla completa
   * - Etiqueta duplicada
     - Dos archivos con .. _uc-010:
     - Verificar unicidad antes de crear
   * - Titulo mal formateado
     - Usar --- en lugar de ===
     - Seguir convencion RST

7.2 Errores de Contenido
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - Error
     - Ejemplo
     - Solucion
   * - Proposito vago
     - "Este doc es sobre usuarios"
     - Ser especifico y accionable
   * - Sin ejemplos
     - Definiciones abstractas
     - Incluir al menos 1 ejemplo
   * - Vocabulario no controlado
     - "deberia" en lugar de "DEBERIA"
     - Consultar SBVR_05

7.3 Errores de Proceso
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - Error
     - Ejemplo
     - Solucion
   * - Saltar revision
     - Autor aprueba su propio doc
     - Respetar flujo de revision
   * - Historial no actualizado
     - Version 1.1.0 sin entrada
     - Actualizar historial SIEMPRE
   * - Version incorrecta
     - Cambio mayor con +0.0.1
     - Seguir GOB_05

----

8. Herramientas de Verificacion
-------------------------------

8.1 Verificacion Automatica (Sphinx Build)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Verificar compilacion
   sphinx-build -W -b html source/ build/

   # -W: Warnings como errores
   # Debe completar sin errores para aprobar

8.2 Verificacion de Metadata
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # Script de verificacion (conceptual)
   def verificar_metadata(archivo):
       campos_requeridos = [
           'artefacto', 'tipo', 'dominio', 'subdominio',
           'estado', 'version', 'fecha_creacion',
           'ultimo_cambio', 'autor', 'clasificacion'
       ]
       # Verificar presencia de todos los campos
       # Verificar valores validos
       # Retornar lista de errores

8.3 Verificacion de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Sphinx linkcheck
   sphinx-build -b linkcheck source/ build/

   # Reporta enlaces rotos internos y externos

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`gob-05` - Control de Versiones
- :ref:`sbvr-05` - Vocabulario Controlado

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 9001:2015 - Sistemas de Gestion de Calidad
- IEEE 730 - Software Quality Assurance

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
   * - 1.0.1
     - 2025-12-22
     - Equipo IACT
     - Agregada referencia cruzada a GOB_05 en criterio CU-03 para reglas de versionado.
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Version inicial. Criterios universales y especificos. Checklists de autor, revisor y aprobador. Proceso de revision. Metricas de calidad.

----

**Trazabilidad:** Este artefacto define los criterios de calidad que deben
cumplir todos los artefactos del sistema documental IACT. Es utilizado por
revisores y aprobadores segun la matriz RACI de GOB_02. Las versiones se
gestionan segun GOB_05.
