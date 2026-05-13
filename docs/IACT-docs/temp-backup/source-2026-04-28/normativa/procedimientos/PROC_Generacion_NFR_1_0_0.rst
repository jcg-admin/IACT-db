.. meta::
   :artefacto: PROC_Generacion_NFR
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-generacion-nfr:

============================================================
PROC_Generacion_NFR: Generacion de Requisitos No Funcionales
============================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_NFR
   * - **Nombre**
     - Generacion de Requisitos No Funcionales
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada NFR a documentar
   * - **Duracion Estimada**
     - 20-40 minutos por NFR
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Requisitos No Funcionales
(NFR) siguiendo el template TPL_NFR.

**Objetivo:** Crear NFR con metricas cuantificables, metodos de medicion
y valores objetivo claros.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Requisitos de rendimiento, seguridad, usabilidad
- Requisitos de disponibilidad, escalabilidad
- Restricciones de calidad del sistema

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Requisitos funcionales (usar PROC_Generacion_FR)
- Reglas de negocio (usar PROC_Generacion_BR)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Arquitecto
     - Genera NFR siguiendo TPL
     - Escritura en no_funcionales/
   * - DevOps
     - Valida viabilidad tecnica
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Categoria del NFR identificada
- [ ] TPL_NFR revisado
- [ ] Estructura /tmp/no_funcionales/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_NFR_No_Funcionales_1_0_0.rst
     - Template de NFR
     - Si
   * - BReq relacionado
     - Objetivo de negocio origen
     - No

----

6. Procedimiento
----------------

6.1 Categorias de NFR (ISO 25010)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Categoria
     - Subcategorias
   * - Rendimiento
     - Tiempo respuesta, throughput, utilizacion recursos
   * - Seguridad
     - Autenticacion, autorizacion, integridad, auditoria
   * - Usabilidad
     - Facilidad uso, accesibilidad, estetica
   * - Confiabilidad
     - Disponibilidad, tolerancia fallos, recuperabilidad
   * - Mantenibilidad
     - Modularidad, reusabilidad, analizabilidad
   * - Portabilidad
     - Adaptabilidad, instalabilidad, reemplazabilidad

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Determinar Nomenclatura**

- **Responsable**: Arquitecto
- **Accion**: Asignar ID con prefijo de categoria:

  .. code-block:: text

     Formato: NFR_[CAT]_[NNN]
     
     Prefijos:
     - PERF: Rendimiento
     - SEC: Seguridad
     - USA: Usabilidad
     - REL: Confiabilidad
     - MNT: Mantenibilidad
     - PRT: Portabilidad
     
     Ejemplos:
     - NFR_PERF_001: Tiempo de respuesta API
     - NFR_SEC_001: Cifrado de datos
     - NFR_REL_001: Disponibilidad 99.5%

- **Resultado**: ID asignado
- **Verificacion**: Prefijo correcto

**Paso 2: Redactar Descripcion**

- **Responsable**: Arquitecto
- **Accion**: Describir el requisito:

  .. code-block:: rst

     **Descripcion:**
     
     El sistema DEBE [caracteristica de calidad] para [beneficio].
     
     Ejemplo:
     "El sistema DEBE responder a peticiones API en menos de 500ms
     para garantizar una experiencia de usuario fluida."

- **Resultado**: Descripcion clara
- **Verificacion**: Caracteristica identificable

**Paso 3: Definir Metrica**

- **Responsable**: Arquitecto
- **Accion**: Especificar metrica cuantificable:

  .. code-block:: rst

     **Metrica:**
     
     - Nombre: [Nombre de la metrica]
     - Unidad: [ms, %, req/s, etc.]
     - Formula: [Como se calcula]

- **Resultado**: Metrica definida
- **Verificacion**: Metrica medible

**Paso 4: Establecer Valores Objetivo**

- **Responsable**: Arquitecto
- **Accion**: Definir umbrales:

  .. code-block:: rst

     **Valores Objetivo:**
     
     .. list-table::
        :header-rows: 1
     
        * - Nivel
          - Valor
          - Descripcion
        * - Minimo
          - [valor]
          - Limite inferior aceptable
        * - Objetivo
          - [valor]
          - Valor deseado
        * - Optimo
          - [valor]
          - Mejor caso posible

- **Resultado**: Umbrales definidos
- **Verificacion**: 3 niveles especificados

**Paso 5: Definir Metodo de Medicion**

- **Responsable**: Arquitecto
- **Accion**: Especificar como medir:

  .. code-block:: rst

     **Metodo de Medicion:**
     
     - Herramienta: [nombre]
     - Frecuencia: [cuando medir]
     - Ambiente: [donde medir]
     - Procedimiento: [como ejecutar medicion]

- **Resultado**: Metodo definido
- **Verificacion**: Procedimiento replicable

**Paso 6: Especificar Condiciones**

- **Responsable**: Arquitecto
- **Accion**: Definir contexto de medicion:

  .. code-block:: rst

     **Condiciones de Medicion:**
     
     - Carga: [usuarios concurrentes, transacciones/s]
     - Ambiente: [produccion, staging]
     - Datos: [volumen de datos]
     - Red: [condiciones de red]

- **Resultado**: Condiciones especificadas
- **Verificacion**: Contexto reproducible

**Paso 7: Documentar Impacto**

- **Responsable**: Arquitecto
- **Accion**: Relacionar con arquitectura:

  .. code-block:: rst

     **Impacto en Arquitectura:**
     
     - Componentes afectados: [lista]
     - Decisiones de diseno: [ADR relacionados]
     - Trade-offs: [compromisos]

- **Resultado**: Impacto documentado
- **Verificacion**: Componentes identificados

**Paso 8: Guardar y Validar**

- **Responsable**: Arquitecto
- **Accion**: Guardar y validar:

  .. code-block:: bash

     # Guardar
     /tmp/no_funcionales/NFR_PERF_001_Tiempo_Respuesta.rst
     
     # Validar
     sphinx-build -b html -W /tmp/no_funcionales/ /tmp/build/

- **Resultado**: NFR guardado y validado
- **Verificacion**: Sin errores Sphinx

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - NFR_[CAT]_[NNN].rst
     - Requisito No Funcional
     - /tmp/no_funcionales/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] NFR creado con metrica cuantificable
- [ ] Valores objetivo con 3 niveles
- [ ] Metodo de medicion especificado
- [ ] Condiciones de medicion claras

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue formato NFR_[CAT]_[NNN]
- [ ] Metrica es cuantificable
- [ ] Valores minimo/objetivo/optimo definidos
- [ ] Metodo de medicion replicable
- [ ] Condiciones de medicion especificadas

9.2 Errores Comunes
^^^^^^^^^^^^^^^^^^^

- NFR sin metrica cuantificable
- Valores objetivo sin unidades
- Metodo de medicion ambiguo
- Sin condiciones de contexto

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Metrica no medible
     - Reformular o buscar proxy medible
   * - Sin herramienta disponible
     - Documentar medicion manual

----

11. Referencias
---------------

- TPL_NFR_No_Funcionales_1_0_0.rst
- ISO 25010: Calidad de Software
- CNST relacionadas

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
