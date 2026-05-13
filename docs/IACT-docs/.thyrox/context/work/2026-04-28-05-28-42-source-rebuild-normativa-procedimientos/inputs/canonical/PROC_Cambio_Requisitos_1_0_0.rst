.. meta::
   :artefacto: PROC_Cambio_Requisitos
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno
   :anterior: PROC_001_Cambio_Requisitos

.. _proc-cambio-requisitos:

========================================================
PROC_Cambio_Requisitos: Gestion de Cambios en Requisitos
========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Cambio_Requisitos
   * - **Nombre**
     - Gestion de Cambios en Requisitos
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada solicitud de cambio
   * - **Duracion Estimada**
     - Variable segun impacto
   * - **Estado**
     - Vigente
   * - **Nota**
     - Renombrado desde PROC_001_Cambio_Requisitos

----

1. Proposito
------------

Este procedimiento establece el flujo formal para solicitar, evaluar,
aprobar e implementar cambios en los requisitos del proyecto IACT.

**Objetivo:** Gestionar cambios de manera controlada, evaluando impacto
y manteniendo trazabilidad.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Cambios en BReq (Objetivos de Negocio)
- Cambios en BR (Reglas de Negocio)
- Cambios en UC (Casos de Uso)
- Cambios en FR (Requisitos Funcionales)
- Cambios en NFR (Requisitos No Funcionales)

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Correcciones de typos (no requiere proceso formal)
- Cambios en documentacion de soporte

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Solicitante
     - Inicia solicitud de cambio
     - Lectura de requisitos
   * - Analista
     - Evalua impacto del cambio
     - Lectura de todos los artefactos
   * - CCB (Change Control Board)
     - Aprueba o rechaza cambios
     - Aprobacion de cambios
   * - Implementador
     - Ejecuta cambios aprobados
     - Escritura en requisitos

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Requisito a cambiar identificado
- [ ] Razon del cambio documentada
- [ ] Stakeholders afectados identificados

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Solicitud de Cambio (RFC)
     - Formulario con detalles del cambio
     - Si
   * - Requisito actual
     - Artefacto a modificar
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Cambio de Requisitos
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Recibir Solicitud de Cambio;
   :Registrar RFC;
   :Analizar Impacto;

   if (Impacto aceptable?) then (si)
       :Elevar a CCB;
       
       if (CCB aprueba?) then (si)
           :Asignar implementador;
           :Implementar cambio;
           :Actualizar trazabilidad;
           :Verificar cambio;
           :Cerrar RFC;
       else (no)
           :Documentar rechazo;
           :Cerrar RFC;
       endif
   else (no)
       :Rechazar por impacto;
       :Cerrar RFC;
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Recibir y Registrar RFC**

- **Responsable**: Analista
- **Accion**: Documentar solicitud:

  .. code-block:: text

     RFC-[YYYY]-[NNN]
     Fecha: YYYY-MM-DD
     Solicitante: [Nombre]
     Requisito afectado: [ID]
     Descripcion del cambio: [Detalle]
     Justificacion: [Razon]

- **Resultado**: RFC registrado
- **Verificacion**: ID unico asignado

**Paso 2: Analizar Impacto**

- **Responsable**: Analista
- **Accion**: Evaluar impacto en:

  - Artefactos derivados (UC -> FR -> TST)
  - Artefactos relacionados (BR, CNST)
  - Codigo implementado
  - Cronograma

- **Resultado**: Analisis de impacto
- **Verificacion**: Todos los impactos identificados

**Paso 3: Evaluacion CCB**

- **Responsable**: CCB
- **Accion**: Revisar RFC y analisis, decidir:

  - Aprobar
  - Aprobar con condiciones
  - Rechazar
  - Solicitar mas informacion

- **Resultado**: Decision documentada
- **Verificacion**: Acta de CCB

**Paso 4: Implementar Cambio**

- **Responsable**: Implementador
- **Accion**: Ejecutar cambio segun procedimientos:

  - Si subdominio congelado: PROC_Descongelamiento primero
  - Aplicar versionado semantico
  - Actualizar artefactos derivados

- **Resultado**: Cambio implementado
- **Verificacion**: Artefactos actualizados

**Paso 5: Actualizar Trazabilidad**

- **Responsable**: Implementador
- **Accion**: Actualizar RTM y referencias
- **Resultado**: Trazabilidad consistente
- **Verificacion**: Sin referencias rotas

**Paso 6: Cerrar RFC**

- **Responsable**: Analista
- **Accion**: Documentar cierre:

  .. code-block:: text

     RFC-[YYYY]-[NNN] - CERRADO
     Fecha cierre: YYYY-MM-DD
     Estado: Implementado / Rechazado
     Artefactos modificados: [Lista]

- **Resultado**: RFC cerrado
- **Verificacion**: Registro completo

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - RFC cerrado
     - Solicitud con resolucion
     - Registro de RFCs
   * - Requisito(s) actualizado(s)
     - Artefactos modificados
     - Ubicacion original

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] RFC cerrado con estado final
- [ ] Cambios implementados (si aprobado)
- [ ] Trazabilidad actualizada
- [ ] Stakeholders notificados

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] RFC tiene ID unico
- [ ] Analisis de impacto completo
- [ ] Decision CCB documentada
- [ ] Cambios verificados

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Cambio urgente
     - CCB puede aprobar via email, documentar post-facto
   * - Impacto desconocido
     - Solicitar analisis adicional
   * - Conflicto de cambios
     - CCB prioriza

----

11. Referencias
---------------

- PROC_Revision_Artefactos
- PROC_Aprobacion_Documentos
- PROC_Descongelamiento_Subdominio

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
     - Renombrado desde PROC_001, nueva nomenclatura

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
