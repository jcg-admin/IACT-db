.. meta::
   :artefacto: PROC_Descongelamiento_Subdominio
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

.. _proc-descongelamiento-subdominio:

========================================================
PROC_Descongelamiento_Subdominio: Descongelar Subdominio
========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Descongelamiento_Subdominio
   * - **Nombre**
     - Descongelar Subdominio del Modelo Documental
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Cuando se requieren cambios en subdominio congelado
   * - **Duracion Estimada**
     - 10-15 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece como descongelar (unfreeze) un subdominio
previamente congelado para permitir modificaciones controladas.

**Objetivo:** Permitir cambios necesarios en subdominios estables
manteniendo trazabilidad y control.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Subdominios con estado [CONGELADO]
- Cuando se requiere agregar, modificar o eliminar artefactos
- Correcciones criticas en artefactos congelados

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Subdominios ya descongelados
- Subdominios que nunca fueron congelados

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Arquitecto Doc
     - Aprueba y ejecuta descongelamiento
     - Escritura en modelo
   * - Solicitante
     - Justifica necesidad de cambio
     - N/A

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Subdominio tiene estado [CONGELADO]
- [ ] Justificacion de cambio documentada
- [ ] Aprobacion del Arquitecto Doc obtenida

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Subdominio congelado
     - Carpeta con estado [CONGELADO]
     - Si
   * - Justificacion de cambio
     - Razon del descongelamiento
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Descongelamiento
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Recibir solicitud de cambio;
   :Validar justificacion;

   if (Justificacion valida?) then (si)
       :Documentar razon;
       :Actualizar index.rst;
       :Marcar como DESCONGELADO en modelo;
       :Registrar descongelamiento;
       :Notificar equipo;
       :Realizar cambios necesarios;
       :Ejecutar PROC_Congelamiento cuando termine;
   else (no)
       :Rechazar solicitud;
       stop
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Validar Justificacion**

- **Responsable**: Arquitecto Doc
- **Accion**: Evaluar razon del descongelamiento:

  .. code-block:: text

     Razones validas:
     - Correccion de error critico
     - Adicion de artefacto faltante
     - Actualizacion por cambio de requisito aprobado
     - Mejora estructural necesaria
     
     Razones invalidas:
     - Cambio estetico menor
     - Preferencia personal
     - Sin justificacion documentada

- **Resultado**: Solicitud aprobada/rechazada
- **Verificacion**: Justificacion documentada

**Paso 2: Documentar Razon**

- **Responsable**: Arquitecto Doc
- **Accion**: Registrar motivo:

  .. code-block:: text

     DESCONGELAMIENTO: requisitos/reglas_negocio/
     Fecha: 2026-01-07
     Solicitante: [Nombre]
     Razon: Agregar BR_021 por nuevo requisito de seguridad
     Aprobado por: Arquitecto Doc

- **Resultado**: Razon documentada
- **Verificacion**: Registro completo

**Paso 3: Actualizar Index del Subdominio**

- **Responsable**: Arquitecto Doc
- **Accion**: Cambiar marca de estado:

  .. code-block:: rst

                                            
     Reglas de Negocio (BR) - [DESCONGELADO]
                                            
     
     .. warning:: **Estado: DESCONGELADO**
     
        Este subdominio fue descongelado el 2026-01-07.
        Razon: Agregar BR_021 por nuevo requisito de seguridad.
        Recongelar al completar cambios.

- **Resultado**: Index actualizado
- **Verificacion**: Estado cambiado

**Paso 4: Actualizar Modelo Documental**

- **Responsable**: Arquitecto Doc
- **Accion**: Cambiar marca en arbol:

  .. code-block:: text

     requisitos/
     ├── reglas_negocio/           # [DESCONGELADO] 20 BR
     │   ├── index.rst
     │   └── ...

- **Resultado**: Modelo actualizado
- **Verificacion**: Marca [DESCONGELADO] presente

**Paso 5: Registrar Descongelamiento**

- **Responsable**: Arquitecto Doc
- **Accion**: Agregar al registro:

  .. code-block:: text

     REGISTRO DE DESCONGELAMIENTOS
     
.. list-table::
   :header-rows: 1

   * - Subdominio
     - Fecha
     - Razon
     - Responsable
   * - reglas_negocio
     - 2026-01-07
     - Agregar BR_021
     - Arquitecto

- **Resultado**: Registro actualizado
- **Verificacion**: Entrada agregada

**Paso 6: Notificar Equipo**

- **Responsable**: Arquitecto Doc
- **Accion**: Comunicar descongelamiento:

  .. code-block:: text

     NOTIFICACION DE DESCONGELAMIENTO
     
     Subdominio: requisitos/reglas_negocio/
     Fecha: 2026-01-07
     Razon: Agregar BR_021
     
     El subdominio esta disponible para modificaciones.
     Recongelar al completar cambios.

- **Resultado**: Equipo notificado
- **Verificacion**: Comunicacion enviada

**Paso 7: Realizar Cambios**

- **Responsable**: Equipo asignado
- **Accion**: Ejecutar cambios justificados
- **Resultado**: Cambios realizados
- **Verificacion**: Solo cambios autorizados

**Paso 8: Recongelar**

- **Responsable**: Arquitecto Doc
- **Accion**: Al completar cambios, ejecutar PROC_Congelamiento_Subdominio
- **Resultado**: Subdominio recongelado
- **Verificacion**: Estado [CONGELADO] restaurado

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - index.rst actualizado
     - Con marca [DESCONGELADO]
     - [subdominio]/
   * - Registro de descongelamiento
     - Documentacion del cambio
     - Registro central

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Subdominio marcado como [DESCONGELADO]
- [ ] Razon documentada
- [ ] Equipo notificado
- [ ] Listo para recibir cambios

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Justificacion valida y documentada
- [ ] Index actualizado con estado y razon
- [ ] Modelo documental actualizado
- [ ] Registro de descongelamiento completo

9.2 Tiempo Maximo Descongelado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::
   
   Un subdominio no debe permanecer descongelado mas de 5 dias habiles.
   Si los cambios requieren mas tiempo, documentar extension.

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Subdominio no estaba congelado
     - No requiere descongelamiento
   * - Justificacion insuficiente
     - Solicitar mas detalle o rechazar
   * - Cambios exceden lo justificado
     - Documentar cambios adicionales

----

11. Referencias
---------------

- PROC_Congelamiento_Subdominio
- PROC_Cambio_Requisitos
- MODELO_DOCUMENTAL_IACT

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
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
