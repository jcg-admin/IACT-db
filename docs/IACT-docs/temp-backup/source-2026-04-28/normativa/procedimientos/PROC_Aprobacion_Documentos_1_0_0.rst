.. meta::
   :artefacto: PROC_Aprobacion_Documentos
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
   :anterior: PROC_003_Aprobacion_Documentos

.. _proc-aprobacion-documentos:

====================================================
PROC_Aprobacion_Documentos: Aprobacion de Documentos
====================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Aprobacion_Documentos
   * - **Nombre**
     - Aprobacion Formal de Documentos
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada documento revisado
   * - **Duracion Estimada**
     - 5-15 minutos
   * - **Estado**
     - Vigente
   * - **Nota**
     - Renombrado desde PROC_003_Aprobacion_Documentos

----

1. Proposito
------------

Este procedimiento establece el flujo de aprobacion formal para documentos
del modelo documental que han pasado la revision.

**Objetivo:** Formalizar la aceptacion de documentos y cambiar su estado
a "Aprobado", habilitandolos para uso oficial.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Artefactos que han pasado PROC_Revision_Artefactos
- Documentos normativos (STD, POL, PROC)
- Artefactos criticos (BR, UC, FR)

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Documentos de trabajo (analisis, notas)
- Artefactos en estado Borrador

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Revisor
     - Envia documento para aprobacion
     - Lectura
   * - Aprobador
     - Autoriza documento
     - Aprobacion
   * - Administrador Doc
     - Actualiza estado y publica
     - Escritura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Documento ha pasado PROC_Revision_Artefactos
- [ ] Sin hallazgos criticos pendientes
- [ ] Aprobador identificado y disponible

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Documento revisado
     - Artefacto con revision aprobada
     - Si
   * - Reporte de revision
     - Resultado de PROC_Revision_Artefactos
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Aprobacion
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Recibir documento revisado;
   :Verificar reporte de revision;

   if (Revision aprobada?) then (si)
       :Presentar a Aprobador;
       
       if (Aprobador autoriza?) then (si)
           :Actualizar estado a Aprobado;
           :Actualizar meta tags;
           :Registrar aprobacion;
           :Publicar documento;
           :Notificar stakeholders;
       else (no)
           :Documentar motivo rechazo;
           :Devolver para correccion;
       endif
   else (no)
       :Devolver a revision;
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Verificar Revision**

- **Responsable**: Administrador Doc
- **Accion**: Confirmar que revision fue aprobada:

  .. code-block:: text

     Verificar:
     - Reporte de revision existe
     - Resultado: Aprobado
     - Sin hallazgos criticos pendientes

- **Resultado**: Revision confirmada
- **Verificacion**: Documentacion completa

**Paso 2: Presentar a Aprobador**

- **Responsable**: Administrador Doc
- **Accion**: Enviar documento para autorizacion:

  .. code-block:: text

     SOLICITUD DE APROBACION
     
     Documento: [ID]
     Tipo: [Tipo de artefacto]
     Autor: [Nombre]
     Revisor: [Nombre]
     Fecha revision: [Fecha]
     
     Solicita: Aprobacion formal

- **Resultado**: Solicitud enviada
- **Verificacion**: Aprobador notificado

**Paso 3: Autorizacion del Aprobador**

- **Responsable**: Aprobador
- **Accion**: Revisar y decidir:

  - Revisar documento brevemente
  - Revisar reporte de revision
  - Autorizar o rechazar

- **Resultado**: Decision tomada
- **Verificacion**: Autorizacion documentada

**Paso 4: Actualizar Estado**

- **Responsable**: Administrador Doc
- **Accion**: Cambiar estado en meta tags:

  .. code-block:: rst

     .. meta::
        :estado: Aprobado           <- Actualizar
        :fecha_aprobacion: 2026-01-07  <- Agregar
        :aprobado_por: [Nombre]        <- Agregar

- **Resultado**: Estado actualizado
- **Verificacion**: Meta tags correctos

**Paso 5: Registrar Aprobacion**

- **Responsable**: Administrador Doc
- **Accion**: Agregar al registro:

  .. code-block:: text

     REGISTRO DE APROBACIONES
     
.. list-table::
   :header-rows: 1

   * - Documento
     - Tipo
     - Fecha
     - Aprobador
   * - BR_020
     - BR
     - 2026-01-07
     - Arquitecto

- **Resultado**: Aprobacion registrada
- **Verificacion**: Entrada agregada

**Paso 6: Publicar Documento**

- **Responsable**: Administrador Doc
- **Accion**: Mover a ubicacion oficial:

  - Si estaba en /tmp, copiar a destino final
  - Actualizar index.rst correspondiente
  - Regenerar documentacion Sphinx

- **Resultado**: Documento publicado
- **Verificacion**: Accesible en ubicacion oficial

**Paso 7: Notificar Stakeholders**

- **Responsable**: Administrador Doc
- **Accion**: Comunicar aprobacion:

  .. code-block:: text

     NOTIFICACION DE APROBACION
     
     Documento: [ID] - [Nombre]
     Estado: APROBADO
     Fecha: [Fecha]
     Ubicacion: [Ruta]

- **Resultado**: Stakeholders notificados
- **Verificacion**: Comunicacion enviada

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Documento aprobado
     - Con estado Aprobado
     - Ubicacion oficial
   * - Registro de aprobacion
     - Entrada en registro
     - Registro central

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Estado del documento = Aprobado
- [ ] Meta tags actualizados
- [ ] Registro de aprobacion actualizado
- [ ] Documento en ubicacion oficial
- [ ] Index.rst actualizado
- [ ] Stakeholders notificados

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Revision previa aprobada
- [ ] Autorizacion del Aprobador obtenida
- [ ] Estado actualizado a Aprobado
- [ ] Documento accesible en ubicacion oficial

9.2 Niveles de Aprobacion
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Tipo de Documento
     - Aprobador
     - Notas
   * - POL (Politicas)
     - Director
     - Maximo nivel
   * - STD (Estandares)
     - Arquitecto Doc
     - Nivel tecnico
   * - PROC (Procedimientos)
     - Arquitecto Doc
     - Nivel tecnico
   * - BR, UC, FR
     - QA Lead
     - Nivel operativo
   * - TPL (Templates)
     - Arquitecto Doc
     - Nivel tecnico

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Aprobador no disponible
     - Aprobador suplente autorizado
   * - Rechazo sin justificacion
     - Solicitar motivos especificos
   * - Urgencia
     - Aprobacion via email, formalizar despues

----

11. Referencias
---------------

- PROC_Revision_Artefactos
- PROC_Congelamiento_Subdominio
- STD_006: Versionado Semantico

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
     - Renombrado desde PROC_003, nueva nomenclatura

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
