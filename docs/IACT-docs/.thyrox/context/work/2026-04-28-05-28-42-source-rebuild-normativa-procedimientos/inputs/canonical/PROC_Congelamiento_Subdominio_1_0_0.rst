.. meta::
   :artefacto: PROC_Congelamiento_Subdominio
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

.. _proc-congelamiento-subdominio:

==================================================
PROC_Congelamiento_Subdominio: Congelar Subdominio
==================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Congelamiento_Subdominio
   * - **Nombre**
     - Congelar Subdominio del Modelo Documental
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada subdominio completado
   * - **Duracion Estimada**
     - 15-30 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece como congelar (freeze) un subdominio del modelo
documental cuando sus artefactos estan completos y aprobados.

**Objetivo:** Proteger artefactos estables de cambios accidentales y
comunicar que el subdominio esta listo para uso.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Subdominios con artefactos completados
- Carpetas que no requieren cambios frecuentes
- Cualquier nivel: dominio, subdominio, modulo

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Subdominios en desarrollo activo
- Artefactos individuales (se congela el subdominio completo)

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
     - Aprueba y ejecuta congelamiento
     - Escritura en modelo
   * - QA Lead
     - Valida completitud antes de congelar
     - Lectura de artefactos

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Todos los artefactos del subdominio generados
- [ ] Artefactos revisados y aprobados
- [ ] Index.rst del subdominio actualizado
- [ ] Sin errores de validacion Sphinx

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Subdominio a congelar
     - Carpeta con artefactos
     - Si
   * - index.rst
     - Indice del subdominio
     - Si
   * - MODELO_DOCUMENTAL_IACT
     - Para actualizar estado
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Congelamiento
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Verificar completitud;

   if (Artefactos completos?) then (si)
       :Validar con Sphinx;
       
       if (Sin errores?) then (si)
           :Actualizar index.rst;
           :Marcar como CONGELADO en modelo;
           :Documentar fecha de congelamiento;
           :Notificar equipo;
       else (no)
           :Corregir errores;
           stop
       endif
   else (no)
       :Completar artefactos faltantes;
       stop
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Verificar Completitud**

- **Responsable**: QA Lead
- **Accion**: Confirmar que todos los artefactos existen:

  .. code-block:: bash

     # Contar artefactos
     find [subdominio]/ -name "*.rst" | wc -l
     
     # Verificar contra inventario esperado
     # Ejemplo: reglas_negocio debe tener 20 BR

- **Resultado**: Inventario completo
- **Verificacion**: Cantidad = esperado

**Paso 2: Validar Sintaxis**

- **Responsable**: QA Lead
- **Accion**: Ejecutar validacion Sphinx:

  .. code-block:: bash

     sphinx-build -b html -W docs/ docs/_build/
     
     # -W convierte warnings en errores

- **Resultado**: Sin errores
- **Verificacion**: Build exitoso

**Paso 3: Actualizar Index del Subdominio**

- **Responsable**: Arquitecto Doc
- **Accion**: Agregar marca de congelamiento:

  .. code-block:: rst

                                         
     Reglas de Negocio (BR) - [CONGELADO]
                                         
     
     .. note:: **Estado: CONGELADO**
     
        Este subdominio fue congelado el 2026-01-07.
        Para modificaciones, ejecutar PROC_Descongelamiento_Subdominio.

- **Resultado**: Index marcado
- **Verificacion**: Nota visible

**Paso 4: Actualizar Modelo Documental**

- **Responsable**: Arquitecto Doc
- **Accion**: Marcar subdominio en arbol:

  .. code-block:: text

     requisitos/
     ├── reglas_negocio/           # [CONGELADO] 20 BR
     │   ├── index.rst
     │   ├── BR_001_...
     │   └── ...

- **Resultado**: Modelo actualizado
- **Verificacion**: Marca [CONGELADO] presente

**Paso 5: Documentar en Registro**

- **Responsable**: Arquitecto Doc
- **Accion**: Agregar al registro de congelamientos:

  .. code-block:: text

     REGISTRO DE CONGELAMIENTOS
     
.. list-table::
   :header-rows: 1

   * - Subdominio
     - Artefactos
     - Fecha
     - Responsable
   * - reglas_negocio
     - 20 BR
     - 2026-01-07
     - Equipo IACT
   * - restricciones
     - 10 CNST
     - 2026-01-06
     - Equipo IACT

- **Resultado**: Registro actualizado
- **Verificacion**: Entrada agregada

**Paso 6: Notificar Equipo**

- **Responsable**: Arquitecto Doc
- **Accion**: Comunicar congelamiento:

  .. code-block:: text

     NOTIFICACION DE CONGELAMIENTO
     
     Subdominio: requisitos/reglas_negocio/
     Artefactos: 20 BR
     Fecha: 2026-01-07
     
     A partir de esta fecha, cualquier cambio requiere:
     1. Ejecutar PROC_Descongelamiento_Subdominio
     2. Realizar cambios
     3. Ejecutar PROC_Congelamiento_Subdominio

- **Resultado**: Equipo notificado
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
   * - index.rst actualizado
     - Con marca de congelamiento
     - [subdominio]/
   * - MODELO_DOCUMENTAL actualizado
     - Con estado [CONGELADO]
     - raiz/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Subdominio marcado como [CONGELADO]
- [ ] Index.rst con nota de congelamiento
- [ ] Modelo documental actualizado
- [ ] Registro de congelamiento actualizado
- [ ] Equipo notificado

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Todos los artefactos presentes
- [ ] Validacion Sphinx sin errores
- [ ] Marca [CONGELADO] en index y modelo
- [ ] Fecha de congelamiento documentada

9.2 Subdominios Tipicamente Congelados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 40 30 30
   :header-rows: 1

   * - Subdominio
     - Artefactos
     - Cuando Congelar
   * - reglas_negocio/
     - BR
     - Cuando BR completas
   * - restricciones/
     - CNST
     - Cuando CNST definidas
   * - procedimientos/
     - PROC
     - Cuando PROC estables

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Artefacto faltante descubierto
     - Completar antes de congelar
   * - Error de Sphinx
     - Corregir, re-validar
   * - Cambio urgente post-congelamiento
     - Ejecutar PROC_Descongelamiento primero

----

11. Referencias
---------------

- PROC_Descongelamiento_Subdominio
- PROC_Actualizacion_Modelo_Documental
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
