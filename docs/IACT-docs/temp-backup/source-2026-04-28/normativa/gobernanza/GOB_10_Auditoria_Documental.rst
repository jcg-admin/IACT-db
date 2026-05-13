.. meta::
   :artefacto: GOB_10
   :tipo: Proceso
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-10:

============================
GOB_10: Auditoria Documental
============================


Proposito
---------

Este documento define el **proceso de auditoria documental** del sistema IACT,
estableciendo los tipos de auditoria, frecuencia, checklists de verificacion,
formato de reportes y acciones correctivas para garantizar el cumplimiento
de los estandares de gobernanza.

.. important::

   **Pregunta Clave que Responde:**

   "¿Como verificamos que la documentacion cumple con los estandares?"

----

1. Tipos de Auditoria
---------------------

1.1 Catalogo de Auditorias
^^^^^^^^^^^^^^^^^^^^^^^^^^

El sistema IACT reconoce **cuatro tipos** de auditoria documental:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo
     - Objetivo
     - Alcance
   * - **Completitud**
     - Verificar que los artefactos tienen toda la informacion requerida
     - Metadata, secciones obligatorias, contenido minimo
   * - **Calidad**
     - Evaluar cumplimiento de criterios de calidad
     - Criterios GOB_03, formato, consistencia
   * - **Trazabilidad**
     - Verificar integridad de enlaces entre artefactos
     - RTM, referencias cruzadas, dependencias
   * - **Clasificacion**
     - Validar correcta clasificacion de seguridad
     - Niveles asignados, controles aplicados

1.2 Matriz de Auditorias por Dominio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 15 15 15 15

   * - Dominio
     - Completitud
     - Calidad
     - Trazabilidad
     - Clasificacion
   * - base_cognitiva/
     - Trimestral
     - Semestral
     - Anual
     - Anual
   * - normativa/
     - Trimestral
     - Trimestral
     - Semestral
     - Semestral
   * - requisitos/
     - Mensual
     - Trimestral
     - Mensual
     - Trimestral
   * - arquitectura_tecnica/
     - Trimestral
     - Trimestral
     - Trimestral
     - Trimestral
   * - usuario_gestion/
     - Semestral
     - Semestral
     - Semestral
     - Anual

----

2. Frecuencia y Disparadores
----------------------------

2.1 Auditorias Programadas
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   AUDITORIAS REGULARES:

   MENSUAL:
   - Completitud de requisitos/ (BR\_, UC\_, FR\_)
   - Trazabilidad de requisitos/

   TRIMESTRAL:
   - Completitud de todos los dominios
   - Calidad de normativa/ y arquitectura_tecnica/
   - Trazabilidad de arquitectura_tecnica/

   SEMESTRAL:
   - Calidad de base_cognitiva/ y usuario_gestion/
   - Clasificacion de normativa/

   ANUAL:
   - Auditoria completa de todo el sistema
   - Revision de politicas de gobernanza

2.2 Auditorias por Evento
^^^^^^^^^^^^^^^^^^^^^^^^^

Se disparan auditorias adicionales ante:

.. code-block:: text

   EVENTOS DISPARADORES:

   - Milestone SDLC (LCO, LCA, IOC, FOC):
     → Auditoria completa del dominio relevante

   - Release de documentacion:
     → Auditoria de calidad y trazabilidad

   - Incidente de clasificacion:
     → Auditoria de clasificacion del dominio afectado

   - Hallazgo de no conformidad critica:
     → Auditoria focalizada en el area afectada

   - Solicitud de PMO o Sponsor:
     → Auditoria bajo demanda (alcance definido)

2.3 Calendario Anual de Auditorias
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CALENDARIO TIPO:

   ENE: Completitud Q1, Clasificacion anual
   FEB: --
   MAR: Completitud Q1, Calidad trimestral
   ABR: Completitud Q2, Trazabilidad trimestral
   MAY: --
   JUN: Completitud Q2, Calidad semestral, Clasificacion semestral
   JUL: Completitud Q3, Trazabilidad trimestral
   AGO: --
   SEP: Completitud Q3, Calidad trimestral
   OCT: Completitud Q4, Trazabilidad trimestral
   NOV: --
   DIC: Auditoria anual completa, Revision de gobernanza

----

3. Checklists de Auditoria
--------------------------

3.1 Checklist de Completitud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   AUDITORIA DE COMPLETITUD
   ========================

   DOMINIO/SUBDOMINIO: ________________
   FECHA: ________________
   AUDITOR: ________________

   ESTRUCTURA:
   [ ] Existe index.rst en el subdominio
   [ ] Todos los artefactos listados en index.rst existen
   [ ] No hay artefactos huerfanos (no listados)

   POR CADA ARTEFACTO:
   [ ] Bloque .. meta:: presente
   [ ] Campo :artefacto: correcto (formato PREFIJO_NNN)
   [ ] Campo :tipo: presente y valido
   [ ] Campo :dominio: correcto
   [ ] Campo :subdominio: correcto
   [ ] Campo :estado: presente y valido
   [ ] Campo :version: en formato X.Y.Z
   [ ] Campo :fecha_creacion: presente (YYYY-MM-DD)
   [ ] Campo :ultimo_cambio: presente (YYYY-MM-DD)
   [ ] Campo :autor: identificado
   [ ] Campo :clasificacion: presente y valido
   [ ] Etiqueta de referencia (.. _prefijo-nn:) presente
   [ ] Titulo principal con formato correcto
   [ ] Seccion "Proposito" presente
   [ ] Seccion "Historial de Cambios" presente
   [ ] Al menos una entrada en historial

   RESULTADO:
   Total artefactos: ____
   Conformes: ____
   No conformes: ____
   Tasa de conformidad: ____%

3.2 Checklist de Calidad
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   AUDITORIA DE CALIDAD
   ====================

   DOMINIO/SUBDOMINIO: ________________
   FECHA: ________________
   AUDITOR: ________________

   COMPILACION:
   [ ] Sphinx compila sin errores
   [ ] Sphinx compila sin warnings criticos
   [ ] Todos los enlaces internos resuelven

   CONTENIDO (muestra de N artefactos):
   [ ] Proposito es claro y especifico
   [ ] Contenido completo segun tipo de artefacto
   [ ] Usa vocabulario controlado (SBVR_05)
   [ ] Ejemplos presentes donde corresponde
   [ ] Sin contenido placeholder (TODO, TBD)
   [ ] Sin typos evidentes
   [ ] Formato consistente

   CRITERIOS ESPECIFICOS (segun tipo):
   [ ] BR\_: Tiene definicion, fuente, keywords correctos
   [ ] UC\_: Tiene actor, flujo principal, postcondiciones
   [ ] FR\_: Formato FR-UC.SEQ, criterio de aceptacion
   [ ] GOB\_: Proceso claro, roles identificados

   RESULTADO:
   Errores Sphinx: ____
   Warnings: ____
   Artefactos muestreados: ____
   Conformes: ____
   Observaciones: ____

3.3 Checklist de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   AUDITORIA DE TRAZABILIDAD
   =========================

   DOMINIO: ________________
   FECHA: ________________
   AUDITOR: ________________

   MATRIZ RTM:
   [ ] RTM existe y esta actualizada
   [ ] Fecha de ultima actualizacion < 30 dias

   COBERTURA:
   [ ] Todos los BR tienen al menos 1 UC asociado
   [ ] Todos los UC tienen al menos 1 FR derivado
   [ ] Todos los FR referencian su UC de origen
   [ ] ADRs referencian requisitos que justifican

   ENLACES:
   [ ] Referencias :ref: resuelven correctamente
   [ ] No hay referencias a artefactos eliminados
   [ ] Referencias bidireccionales donde aplica

   CONSISTENCIA:
   [ ] IDs en RTM coinciden con artefactos reales
   [ ] Estados en RTM coinciden con estados reales
   [ ] Versiones en RTM coinciden con versiones reales

   RESULTADO:
   BR sin UC: ____
   UC sin FR: ____
   Enlaces rotos: ____
   Inconsistencias RTM: ____
   Cobertura: ____%

3.4 Checklist de Clasificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   AUDITORIA DE CLASIFICACION
   ==========================

   DOMINIO/SUBDOMINIO: ________________
   FECHA: ________________
   AUDITOR: ________________

   ASIGNACION:
   [ ] Todos los artefactos tienen :clasificacion:
   [ ] Valores son validos (Publico/Interno/Confidencial/Restringido)
   [ ] Clasificacion >= clasificacion minima del dominio

   CONTENIDO vs CLASIFICACION:
   [ ] Artefactos con datos personales son >= Restringido
   [ ] Artefactos con credenciales son >= Confidencial
   [ ] Artefactos con arquitectura son >= Confidencial
   [ ] No hay material sub-clasificado evidente

   CONTROLES:
   [ ] Artefactos Confidencial/Restringido en ubicacion correcta
   [ ] Accesos corresponden a clasificacion

   CAMBIOS:
   [ ] Cambios de clasificacion estan documentados
   [ ] Aprobaciones de cambio estan registradas

   RESULTADO:
   Sin clasificacion: ____
   Posible sub-clasificacion: ____
   Controles incorrectos: ____

----

4. Proceso de Auditoria
-----------------------

4.1 Flujo del Proceso
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌──────────────┐
   │ PLANIFICAR   │
   │              │
   │ - Alcance    │
   │ - Recursos   │
   │ - Calendario │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │  EJECUTAR    │
   │              │
   │ - Checklists │
   │ - Muestreo   │
   │ - Evidencia  │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │  REPORTAR    │
   │              │
   │ - Hallazgos  │
   │ - Severidad  │
   │ - Metricas   │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │   REMEDIAR   │
   │              │
   │ - Plan accion│
   │ - Seguimiento│
   │ - Cierre     │
   └──────────────┘

4.2 Planificacion
^^^^^^^^^^^^^^^^^

.. code-block:: text

   PLAN DE AUDITORIA
   =================

   ID Auditoria: AUD-YYYY-NNN
   Tipo: [Completitud/Calidad/Trazabilidad/Clasificacion]

   ALCANCE:
   - Dominio(s): ________________
   - Subdominio(s): ________________
   - Periodo cubierto: ________________

   RECURSOS:
   - Auditor principal: ________________
   - Auditor secundario: ________________ (si aplica)
   - Herramientas: Sphinx, scripts de validacion

   CALENDARIO:
   - Inicio: YYYY-MM-DD
   - Fin estimado: YYYY-MM-DD
   - Entrega reporte: YYYY-MM-DD

   MUESTREO (si aplica):
   - Poblacion total: N artefactos
   - Tamaño muestra: n artefactos
   - Metodo: [Aleatorio/Estratificado/Dirigido]

4.3 Ejecucion
^^^^^^^^^^^^^

.. code-block:: text

   GUIA DE EJECUCION:

   1. PREPARACION:
      - Obtener ultima version del repositorio
      - Ejecutar Sphinx build para detectar errores
      - Generar lista de artefactos en alcance

   2. REVISION AUTOMATICA:
      - Ejecutar scripts de validacion de metadata
      - Ejecutar linkcheck de Sphinx
      - Recopilar metricas automaticas

   3. REVISION MANUAL:
      - Aplicar checklist correspondiente
      - Documentar hallazgos con evidencia
      - Clasificar severidad de cada hallazgo

   4. VERIFICACION CRUZADA:
      - Segundo auditor valida muestra de hallazgos
      - Resolver discrepancias

4.4 Clasificacion de Hallazgos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 35 25 25

   * - Severidad
     - Criterio
     - Plazo Remediacion
     - Escalamiento
   * - **Critica**
     - Violacion de seguridad, datos expuestos, bloqueo total
     - Inmediato (< 24h)
     - PMO + Sponsor
   * - **Alta**
     - Incumplimiento grave, trazabilidad rota, clasificacion incorrecta
     - 48 horas
     - PMO
   * - **Media**
     - Metadata incompleta, enlaces rotos, formato incorrecto
     - 1 semana
     - Owner dominio
   * - **Baja**
     - Typos, mejoras de formato, observaciones menores
     - Proxima actualizacion
     - Autor

----

5. Formato de Reporte
---------------------

5.1 Estructura del Reporte
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

                                  
   REPORTE DE AUDITORIA DOCUMENTAL
                                  

   ID: AUD-YYYY-NNN
   Tipo: [Completitud/Calidad/Trazabilidad/Clasificacion]
   Fecha: YYYY-MM-DD
   Auditor: [nombre]

                       
   1. RESUMEN EJECUTIVO
                       

   Alcance: [descripcion breve]

   Resultado General: [ ] CONFORME  [ ] NO CONFORME  [ ] PARCIAL

   Hallazgos por Severidad:
   - Criticos: N
   - Altos: N
   - Medios: N
   - Bajos: N

   Principales Observaciones:
   1. [observacion 1]
   2. [observacion 2]
   3. [observacion 3]

                           
   2. ALCANCE Y METODOLOGIA
                           

   Dominios auditados: [lista]
   Periodo cubierto: [fechas]
   Artefactos en alcance: N
   Artefactos muestreados: n (si aplica)
   Metodo de muestreo: [descripcion]

   Checklists aplicados:
   - [checklist 1]
   - [checklist 2]

   Herramientas utilizadas:
   - Sphinx build
   - [otras]

                          
   3. HALLAZGOS DETALLADOS
                          

   HALLAZGO #1
   -----------
   Severidad: [Critica/Alta/Media/Baja]
   Tipo: [Completitud/Calidad/Trazabilidad/Clasificacion]
   Artefacto(s): [lista de IDs afectados]

   Descripcion:
   [Descripcion clara del hallazgo]

   Evidencia:
   [Referencia a evidencia: linea, archivo, screenshot]

   Criterio Incumplido:
   [Referencia a GOB_03, GOB_05, etc.]

   Recomendacion:
   [Accion correctiva sugerida]

   [Repetir para cada hallazgo]

              
   4. METRICAS
              

   Tasa de conformidad general: ___%

   Por dominio:
   - base_cognitiva/: ___%
   - normativa/: ___%
   - requisitos/: ___%
   - arquitectura_tecnica/: ___%

   Comparativa con auditoria anterior:
   - Anterior: ___%
   - Actual: ___%
   - Tendencia: [Mejora/Estable/Deterioro]

                    
   5. PLAN DE ACCION
                    

   | # | Hallazgo | Responsable | Fecha Limite | Estado |
   |---|----------|-------------|--------------|--------|
   | 1 | H-001    | [nombre]    | YYYY-MM-DD   | Abierto|
   | 2 | H-002    | [nombre]    | YYYY-MM-DD   | Abierto|

                
   6. CONCLUSION
                

   [Parrafo de conclusion general]

   Proxima auditoria programada: YYYY-MM-DD

         
   FIRMAS
         

   Auditor: ________________  Fecha: ________

   Revisado por: ________________  Fecha: ________

----

6. Seguimiento y Cierre
-----------------------

6.1 Proceso de Remediacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   SEGUIMIENTO DE HALLAZGOS:

   1. ASIGNACION:
      - Auditor asigna responsable por hallazgo
      - Responsable confirma recepcion
      - Se establece fecha limite

   2. REMEDIACION:
      - Responsable implementa correccion
      - Documenta acciones tomadas
      - Notifica finalizacion

   3. VERIFICACION:
      - Auditor verifica correccion
      - Si OK: Cierra hallazgo
      - Si NO: Devuelve con observaciones

   4. CIERRE:
      - Todos los hallazgos cerrados
      - Auditoria marcada como completada
      - Metricas actualizadas

6.2 Estados de Hallazgos
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ESTADOS VALIDOS:

   ABIERTO     → Hallazgo identificado, pendiente asignar
   ASIGNADO    → Responsable asignado, en proceso
   EN_REVISION → Correccion aplicada, pendiente verificar
   CERRADO     → Verificado y conforme
   DIFERIDO    → Postergado con justificacion (requiere PMO)
   ESCALADO    → Requiere intervencion de nivel superior

6.3 Metricas de Seguimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Metrica
     - Formula
     - Meta
   * - Tiempo promedio de cierre
     - Suma dias / Hallazgos cerrados
     - < 7 dias
   * - Hallazgos vencidos
     - Vencidos / Total abiertos
     - 0%
   * - Tasa de reapertura
     - Reabiertos / Cerrados
     - < 5%
   * - Hallazgos criticos abiertos
     - Criticos sin cerrar
     - 0

----

7. Herramientas de Auditoria
----------------------------

7.1 Validacion Automatica
^^^^^^^^^^^^^^^^^^^^^^^^^

**Sphinx Build:**

.. code-block:: bash

   # Compilar con warnings como errores
   sphinx-build -W -b html source/ build/

   # Verificar enlaces
   sphinx-build -b linkcheck source/ build/

**Script de Validacion de Metadata:**

.. code-block:: python

   # Conceptual - verificar campos requeridos
   def validar_metadata(archivo):
       campos_requeridos = [
           'artefacto', 'tipo', 'dominio', 'subdominio',
           'estado', 'version', 'fecha_creacion',
           'ultimo_cambio', 'autor', 'clasificacion'
       ]
       # Parsear archivo RST
       # Extraer bloque meta
       # Verificar presencia y formato de campos
       # Retornar lista de errores

7.2 Reportes Automaticos
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REPORTES GENERABLES:

   - Lista de artefactos por dominio/estado
   - Artefactos sin metadata completa
   - Enlaces rotos
   - Artefactos sin actualizar > 90 dias
   - Estadisticas de versionado
   - Cobertura de trazabilidad

----

8. Roles y Responsabilidades
----------------------------

8.1 Rol del Auditor
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PERFIL DEL AUDITOR:

   - Rol RBAC: R017 (AUDIT_VIEWER)
   - Independiente del area auditada
   - Conocimiento de estandares de gobernanza
   - Acceso de lectura a todos los dominios

   RESPONSABILIDADES:
   - Planificar y ejecutar auditorias
   - Documentar hallazgos con evidencia
   - Clasificar severidad objetivamente
   - Dar seguimiento a remediacion
   - Mantener confidencialidad

8.2 Matriz RACI de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 14 14 14 14 14

   * - Actividad
     - Auditor
     - Owner
     - PMO
     - Autor
     - QA
   * - Planificar auditoria
     - R
     - C
     - A
     - I
     - C
   * - Ejecutar auditoria
     - R
     - I
     - I
     - I
     - C
   * - Clasificar hallazgos
     - R
     - C
     - A
     - I
     - C
   * - Asignar responsables
     - R
     - A
     - I
     - I
     - I
   * - Remediar hallazgos
     - I
     - A
     - I
     - R
     - C
   * - Verificar remediacion
     - R
     - I
     - I
     - I
     - C
   * - Cerrar auditoria
     - R
     - I
     - A
     - I
     - I

----

9. Indicadores de Desempeño
---------------------------

9.1 KPIs de Auditoria
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - KPI
     - Descripcion
     - Meta
   * - Cobertura de auditoria
     - % de dominios auditados segun plan
     - 100%
   * - Conformidad general
     - % artefactos sin hallazgos
     - >= 90%
   * - Cierre en plazo
     - % hallazgos cerrados a tiempo
     - >= 95%
   * - Recurrencia
     - % hallazgos repetidos
     - < 10%
   * - Tiempo de ciclo
     - Dias desde inicio a cierre
     - < 30 dias

9.2 Dashboard de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   DASHBOARD DE AUDITORIA - [Periodo]
                                     

   ESTADO GENERAL: [Verde/Amarillo/Rojo]

   ┌─────────────────────────────────────────┐
   │  Auditorias del Periodo                 │
   │                                         │
   │  Planificadas: 12                       │
   │  Ejecutadas:   10  ████████░░ 83%       │
   │  Pendientes:    2                       │
   └─────────────────────────────────────────┘

   ┌─────────────────────────────────────────┐
   │  Hallazgos                              │
   │                                         │
   │  Criticos:  0  ✓                        │
   │  Altos:     3  ██░░░░░░░░               │
   │  Medios:   12  ████████░░               │
   │  Bajos:    25  ██████████               │
   │                                         │
   │  Abiertos: 15  Cerrados: 25             │
   └─────────────────────────────────────────┘

   ┌─────────────────────────────────────────┐
   │  Conformidad por Dominio                │
   │                                         │
   │  base_cognitiva:     95% ██████████░    │
   │  normativa:          92% █████████░░    │
   │  requisitos:         88% █████████░░    │
   │  arquitectura:       90% █████████░░    │
   │  usuario_gestion:    94% █████████░░    │
   └─────────────────────────────────────────┘

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`gob-05` - Control de Versiones
- :ref:`gob-08` - Estados Documentales
- :ref:`gob-09` - Politica de Clasificacion

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 19011 - Directrices para Auditoria de Sistemas de Gestion
- ISO 9001:2015 - Auditoria Interna

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
     - Version inicial. 4 tipos de auditoria. Checklists completos. Formato de reporte. Proceso de seguimiento. KPIs.

----

**Trazabilidad:** Este artefacto define el proceso de auditoria para verificar
cumplimiento de todos los estandares de gobernanza IACT. Referencia GOB_03
para criterios de calidad, GOB_05 para versionado, GOB_08 para estados y
GOB_09 para clasificacion.
