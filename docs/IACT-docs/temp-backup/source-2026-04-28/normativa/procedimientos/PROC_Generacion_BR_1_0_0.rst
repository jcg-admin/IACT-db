.. meta::
   :artefacto: PROC_Generacion_BR
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

.. _proc-generacion-br:

===================================================
PROC_Generacion_BR: Generacion de Reglas de Negocio
===================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_BR
   * - **Nombre**
     - Generacion de Reglas de Negocio
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada BR a documentar
   * - **Duracion Estimada**
     - 15-30 minutos por BR
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Reglas de Negocio (BR)
siguiendo el template TPL_BR y la taxonomia TXM_03.

**Objetivo:** Crear BR completas con declaracion formal, condiciones,
acciones y trazabilidad a BReq y UC.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Creacion de nuevas BR derivadas de BReq
- BR de todos los tipos segun TXM_03
- BR de todos los modulos IACT

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Modificacion de BR existentes (usar PROC_Cambio_Requisitos)
- Restricciones tecnicas (usar PROC_Generacion_CNST)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Analista
     - Genera BR siguiendo TPL
     - Escritura en reglas_negocio/
   * - Experto Dominio
     - Valida logica de negocio
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] BReq origen identificado
- [ ] TPL_BR revisado (PROC_Revision_TPL_Previo_Generacion)
- [ ] TXM_03 (Tipos de Reglas) consultada
- [ ] Estructura /tmp/reglas_negocio/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_BR_Business_Rules_1_0_0.rst
     - Template de BR
     - Si
   * - BReq_[NNN].rst
     - Objetivo de negocio origen
     - Si
   * - TXM_03
     - Taxonomia de tipos de BR
     - Si

----

6. Procedimiento
----------------

6.1 Tipos de BR (TXM_03)
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 50 30
   :header-rows: 1

   * - Tipo
     - Descripcion
     - Ejemplo
   * - Restriccion
     - Limita valores o acciones
     - Password minimo 8 caracteres
   * - Derivacion
     - Calcula valor desde otros
     - Estado = f(intentos, tiempo)
   * - Validacion
     - Verifica condicion
     - Email formato valido
   * - Autorizacion
     - Define permisos
     - Solo admin puede crear usuarios
   * - Proceso
     - Define flujo obligatorio
     - Login invalida sesiones previas

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar Tipo de BR**

- **Responsable**: Analista
- **Accion**: Clasificar BR segun TXM_03:

  .. code-block:: text

     Preguntas de clasificacion:
     
     - Limita un valor? -> Restriccion
     - Calcula un resultado? -> Derivacion
     - Verifica una condicion? -> Validacion
     - Define quien puede hacer algo? -> Autorizacion
     - Define un flujo obligatorio? -> Proceso

- **Resultado**: Tipo identificado
- **Verificacion**: Tipo valido segun TXM_03

**Paso 2: Determinar Nomenclatura**

- **Responsable**: Analista
- **Accion**: Asignar ID secuencial:

  .. code-block:: text

     Formato: BR_[NNN]
     
     Donde [NNN] es numero secuencial de 3 digitos.
     
     Archivo: BR_[NNN]_[Nombre_Descriptivo].rst
     
     Ejemplos:
     - BR_001_Sesion_Unica_Por_Usuario.rst
     - BR_015_Bloqueo_Por_Intentos_Fallidos.rst

- **Resultado**: ID asignado
- **Verificacion**: ID unico en catalogo

**Paso 3: Redactar Declaracion Formal**

- **Responsable**: Analista
- **Accion**: Escribir declaracion en formato SBVR:

  .. code-block:: text

     Formato:
     "El sistema DEBE [accion] CUANDO [condicion] PARA [proposito]"
     
     Ejemplo BR_005:
     "El sistema DEBE invalidar todas las sesiones previas del usuario
     CUANDO este inicia una nueva sesion PARA garantizar que solo
     exista una sesion activa por usuario."

- **Resultado**: Declaracion formal
- **Verificacion**: Formato DEBE/CUANDO/PARA

**Paso 4: Especificar Condiciones y Acciones**

- **Responsable**: Analista
- **Accion**: Detallar logica:

  .. code-block:: rst

     **Condicion de Activacion:**
     
     - Usuario inicia sesion exitosamente
     - Existen sesiones previas del usuario
     
     **Accion a Ejecutar:**
     
     1. Buscar sesiones activas del user_id
     2. Marcar como invalidas (is_active = False)
     3. Registrar evento de invalidacion

- **Resultado**: Logica detallada
- **Verificacion**: Condiciones y acciones claras

**Paso 5: Definir Excepciones**

- **Responsable**: Analista
- **Accion**: Documentar casos especiales:

  .. code-block:: rst

     **Excepciones:**
     
     - No aplica a sesiones de API (tokens de servicio)
     - Administradores pueden tener multiples sesiones

- **Resultado**: Excepciones documentadas
- **Verificacion**: Excepciones justificadas

**Paso 6: Completar Trazabilidad**

- **Responsable**: Analista
- **Accion**: Enlazar con artefactos relacionados:

  .. code-block:: rst

     **Trazabilidad:**
     
     * - **BReq Origen**
       - BReq_004: Cumplimiento de Seguridad
     * - **UC que Aplican**
       - UC_001: Iniciar Sesion
     * - **FR Derivados**
       - FR_UC001_04: Invalidar sesiones previas
     * - **CNST Relacionadas**
       - CNST_002: Gestion de Sesiones en BD

- **Resultado**: Trazabilidad completa
- **Verificacion**: Referencias validas

**Paso 7: Guardar y Validar**

- **Responsable**: Analista
- **Accion**: Guardar en /tmp y validar:

  .. code-block:: bash

     # Guardar
     /tmp/reglas_negocio/BR_005_Sesion_Unica.rst
     
     # Validar sintaxis
     sphinx-build -b html -W /tmp/reglas_negocio/ /tmp/build/

- **Resultado**: BR guardada y validada
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
   * - BR_[NNN]_[Nombre].rst
     - Regla de Negocio generada
     - /tmp/reglas_negocio/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] BR creada con todas las secciones
- [ ] Tipo segun TXM_03 especificado
- [ ] Declaracion formal en formato SBVR
- [ ] Trazabilidad a BReq y UC completada
- [ ] Sintaxis RST validada

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue formato BR_[NNN]
- [ ] Tipo valido segun TXM_03
- [ ] Declaracion usa DEBE/CUANDO/PARA
- [ ] Condiciones y acciones especificadas
- [ ] BReq origen identificado

9.2 Checklist de Secciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Meta tags completos
- [ ] Resumen (ID, nombre, tipo, modulo)
- [ ] Declaracion formal
- [ ] Condiciones de activacion
- [ ] Acciones a ejecutar
- [ ] Excepciones
- [ ] Trazabilidad
- [ ] Historial

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Tipo no claro
     - Consultar con experto de dominio
   * - BR duplicada
     - Verificar si es variante, consolidar
   * - Sin BReq origen
     - Documentar como BR autonoma

----

11. Referencias
---------------

- TPL_BR_Business_Rules_1_0_0.rst
- TXM_03: Taxonomia de Reglas de Negocio
- PROC_Derivacion_BReq_BR

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
