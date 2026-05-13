.. meta::
   :artefacto: GOB_08
   :tipo: Politica
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-08:

============================
GOB_08: Estados Documentales
============================


Proposito
---------

Este documento define los **estados validos** del ciclo de vida documental,
las **transiciones permitidas** entre estados y las **autorizaciones requeridas**
para cada cambio de estado en el sistema IACT.

.. important::

   **Pregunta Clave que Responde:**

   "¿En que estado esta este documento y a que estados puede pasar?"

----

1. Estados del Ciclo de Vida
----------------------------

1.1 Catalogo de Estados
^^^^^^^^^^^^^^^^^^^^^^^

El sistema IACT reconoce **cinco estados** oficiales para artefactos:

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - Estado
     - Definicion
     - Version Tipica
   * - **BORRADOR**
     - En creacion o modificacion activa. No revisado formalmente.
     - 0.x.x
   * - **EN_REVISION**
     - Enviado para revision. Pendiente de aprobacion.
     - 0.x.x o X.Y.Z-rc
   * - **APROBADO**
     - Revisado y aprobado oficialmente. Version de referencia.
     - >= 1.0.0
   * - **OBSOLETO**
     - Ya no es la version vigente. Reemplazado o superado.
     - (ultima version)
   * - **ARCHIVADO**
     - Retirado del uso activo. Solo consulta historica.
     - (ultima version)

1.2 Representacion Visual
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CICLO DE VIDA DOCUMENTAL
   ========================

                    ┌───────────────┐
                    │   BORRADOR    │◄──────────────────┐
                    │    (0.x.x)    │                   │
                    └───────┬───────┘                   │
                            │                           │
                            │ Enviar a revision         │
                            ▼                           │
                    ┌───────────────┐                   │
                    │  EN_REVISION  │───────────────────┘
                    │ (0.x.x / -rc) │    Devolver
                    └───────┬───────┘    (requiere cambios)
                            │
                            │ Aprobar
                            ▼
                    ┌───────────────┐
          ┌────────│   APROBADO    │────────┐
          │        │   (>= 1.0.0)  │        │
          │        └───────┬───────┘        │
          │                │                │
          │ Modificar      │ Obsoleter      │ Archivar
          │ (nueva version)│                │ (directo)
          │                ▼                │
          │        ┌───────────────┐        │
          │        │   OBSOLETO    │        │
          │        │               │        │
          │        └───────┬───────┘        │
          │                │                │
          │                │ Archivar       │
          │                ▼                ▼
          │        ┌───────────────────────────┐
          │        │        ARCHIVADO          │
          │        │    (Estado Terminal)      │
          │        └───────────────────────────┘
          │
          └──────► Regresa a BORRADOR como nueva version

----

2. Definicion Detallada de Estados
----------------------------------

2.1 BORRADOR
^^^^^^^^^^^^

**Codigo:** ``Borrador``

**Proposito:** Artefacto en proceso de creacion o modificacion.

.. code-block:: text

   CARACTERISTICAS:
   - No ha sido revisado formalmente
   - Puede contener errores o contenido incompleto
   - No debe usarse como referencia oficial
   - Puede modificarse libremente por el autor

   VERSION:
   - Siempre < 1.0.0 (tipicamente 0.1.0, 0.2.0, etc.)
   - Incrementos MINOR para cambios significativos
   - Incrementos PATCH para ajustes menores

   VISIBILIDAD:
   - Visible solo para autor y revisores designados
   - No aparece en indices publicos
   - Marcado claramente como "BORRADOR" en renderizado

**Indicador Visual:**

.. code-block:: rst

   .. warning::

      Este documento esta en estado BORRADOR y no ha sido
      aprobado. No utilizar como referencia oficial.

2.2 EN_REVISION
^^^^^^^^^^^^^^^

**Codigo:** ``En_Revision``

**Proposito:** Artefacto enviado para revision formal.

.. code-block:: text

   CARACTERISTICAS:
   - Autor considera que esta listo para revision
   - Asignado a uno o mas revisores
   - No debe modificarse sin devolucion explicita
   - Puede usar sufijo -rc (release candidate)

   VERSION:
   - Mantiene version de borrador, o
   - Usa sufijo: 1.0.0-rc, 1.0.0-rc.2, etc.

   VISIBILIDAD:
   - Visible para autor, revisores y aprobadores
   - Puede compartirse para consulta
   - Marcado como "EN REVISION"

**Transiciones Posibles:**

- **→ APROBADO:** Si revision es exitosa
- **→ BORRADOR:** Si requiere cambios (devolucion)

2.3 APROBADO
^^^^^^^^^^^^

**Codigo:** ``Aprobado``

**Proposito:** Artefacto oficialmente aprobado y vigente.

.. code-block:: text

   CARACTERISTICAS:
   - Version oficial de referencia
   - Ha pasado revision y aprobacion formal
   - Puede ser referenciado por otros artefactos
   - Cambios requieren proceso de gestion de cambios (GOB_04)

   VERSION:
   - Primera aprobacion siempre es 1.0.0
   - Versiones posteriores: 1.1.0, 1.2.0, 2.0.0, etc.
   - Nunca < 1.0.0

   VISIBILIDAD:
   - Visible para todos los usuarios autorizados
   - Aparece en indices y busquedas
   - Sin marcas de advertencia

.. note::

   La version de un artefacto con estado APROBADO debe ser >= 1.0.0.
   Ver :ref:`gob-05` para reglas completas de versionado.

2.4 OBSOLETO
^^^^^^^^^^^^

**Codigo:** ``Obsoleto``

**Proposito:** Artefacto que ya no es la version vigente.

.. code-block:: text

   CARACTERISTICAS:
   - Reemplazado por una version mas reciente, o
   - Superado por otro artefacto, o
   - Ya no aplica al contexto actual
   - Mantiene valor historico

   VERSION:
   - Mantiene ultima version asignada
   - No se incrementa

   VISIBILIDAD:
   - Visible pero marcado como obsoleto
   - Puede aparecer en busquedas con filtro
   - Enlace a reemplazo si existe

**Indicador Visual:**

.. code-block:: rst

   .. warning::

      Este documento esta OBSOLETO desde [fecha].
      Ha sido reemplazado por: :ref:`nuevo-artefacto`
      Consultar solo para referencia historica.

**Motivos Comunes de Obsolescencia:**

.. code-block:: text

   - Nueva version mayor del mismo artefacto
   - Fusion con otro artefacto
   - Cambio de alcance que lo hace irrelevante
   - Actualizacion de politicas o estandares
   - Fin de ciclo de vida del sistema relacionado

2.5 ARCHIVADO
^^^^^^^^^^^^^

**Codigo:** ``Archivado``

**Proposito:** Artefacto retirado del uso activo.

.. code-block:: text

   CARACTERISTICAS:
   - Estado terminal (no hay transiciones de salida)
   - Solo para consulta historica
   - No aparece en busquedas normales
   - Preservado para auditoria y trazabilidad

   VERSION:
   - Mantiene ultima version
   - Congelada permanentemente

   VISIBILIDAD:
   - Requiere busqueda explicita en archivo
   - Acceso restringido segun clasificacion
   - Marcado como "ARCHIVADO - Solo lectura"

**Politica de Retencion:**

.. code-block:: text

   RETENCION DE ARCHIVADOS:

   - Artefactos de gobernanza (GOB\_): 10 años
   - Requisitos (BR\_, UC\_, FR\_): 7 años post-cierre proyecto
   - Arquitectura (ADR\_): 7 años
   - Documentacion general: 5 años

   Despues del periodo de retencion, el artefacto puede
   eliminarse fisicamente previa aprobacion de PMO.

----

3. Transiciones de Estado
-------------------------

3.1 Matriz de Transiciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 16 16 16 16 16

   * - Desde / Hacia
     - BORRADOR
     - EN_REVISION
     - APROBADO
     - OBSOLETO
     - ARCHIVADO
   * - **BORRADOR**
     - --
     - ✅
     - ❌
     - ❌
     - ❌
   * - **EN_REVISION**
     - ✅
     - --
     - ✅
     - ❌
     - ❌
   * - **APROBADO**
     - ✅ (*)
     - ❌
     - --
     - ✅
     - ✅
   * - **OBSOLETO**
     - ❌
     - ❌
     - ❌
     - --
     - ✅
   * - **ARCHIVADO**
     - ❌
     - ❌
     - ❌
     - ❌
     - --

(*) APROBADO → BORRADOR crea una **nueva version**, no revierte la actual.

3.2 Transiciones Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las siguientes transiciones estan **estrictamente prohibidas**:

.. code-block:: text

   TRANSICIONES PROHIBIDAS:

   ❌ APROBADO → BORRADOR (mismo artefacto, misma version)
      Razon: Romperia la integridad de la version aprobada
      Alternativa: Crear nueva version en borrador

   ❌ OBSOLETO → APROBADO
      Razon: Un artefacto obsoleto no puede "revivir"
      Alternativa: Crear nuevo artefacto si es necesario

   ❌ ARCHIVADO → (cualquier estado)
      Razon: Archivado es estado terminal
      Alternativa: Crear nuevo artefacto referenciando el archivado

   ❌ BORRADOR → APROBADO (sin revision)
      Razon: Viola proceso de revision obligatorio
      Alternativa: Pasar por EN_REVISION

3.3 Detalle de Cada Transicion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**BORRADOR → EN_REVISION**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Autor envia a revision
   * - Validaciones
     - Metadata completa, Sphinx compila, checklist autor cumplido
   * - Autorizacion
     - Autor
   * - Acciones
     - Asignar revisor(es), notificar, registrar timestamp

**EN_REVISION → BORRADOR**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Revisor devuelve con observaciones
   * - Validaciones
     - Observaciones documentadas
   * - Autorizacion
     - Revisor
   * - Acciones
     - Notificar autor, registrar observaciones

**EN_REVISION → APROBADO**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Aprobador acepta el artefacto
   * - Validaciones
     - Revision completada, checklist aprobador cumplido
   * - Autorizacion
     - Owner subdominio/dominio o PMO (segun tipo)
   * - Acciones
     - Cambiar version a >= 1.0.0, notificar, publicar

**APROBADO → BORRADOR (nueva version)**

.. list-table::
   :widths: 25 75

   * - Trigger
     - RFC aprobado para modificar artefacto
   * - Validaciones
     - RFC existente y aprobado
   * - Autorizacion
     - Segun tipo de cambio (ver GOB_04)
   * - Acciones
     - Crear copia como nueva version borrador

**APROBADO → OBSOLETO**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Artefacto reemplazado o ya no aplica
   * - Validaciones
     - Justificacion documentada, reemplazo identificado (si aplica)
   * - Autorizacion
     - Owner dominio o PMO
   * - Acciones
     - Marcar obsoleto, agregar referencia a reemplazo, notificar

**APROBADO → ARCHIVADO**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Artefacto debe retirarse directamente (sin obsolescencia previa)
   * - Validaciones
     - Justificacion documentada, no hay artefactos que dependan de el
   * - Autorizacion
     - PMO
   * - Acciones
     - Mover a repositorio de archivo, notificar

**OBSOLETO → ARCHIVADO**

.. list-table::
   :widths: 25 75

   * - Trigger
     - Periodo de obsolescencia cumplido o decision de archivo
   * - Validaciones
     - Periodo minimo cumplido (tipicamente 6 meses)
   * - Autorizacion
     - Owner dominio o PMO
   * - Acciones
     - Mover a repositorio de archivo

----

4. Autorizaciones por Transicion
--------------------------------

4.1 Matriz de Autorizacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 20 20 25

   * - Transicion
     - Quien Ejecuta
     - Quien Autoriza
     - Notificar A
   * - BORRADOR → EN_REVISION
     - Autor
     - Autor (auto)
     - Revisor(es)
   * - EN_REVISION → BORRADOR
     - Revisor
     - Revisor (auto)
     - Autor
   * - EN_REVISION → APROBADO
     - Aprobador
     - Owner/PMO
     - Autor, Interesados
   * - APROBADO → BORRADOR (*)
     - Autor
     - Segun RFC
     - Owner
   * - APROBADO → OBSOLETO
     - Owner
     - Owner/PMO
     - Usuarios del artefacto
   * - APROBADO → ARCHIVADO
     - PMO
     - PMO
     - Owner, Auditor
   * - OBSOLETO → ARCHIVADO
     - Owner
     - Owner/PMO
     - Auditor

4.2 Escalamiento de Autorizacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA DE ESCALAMIENTO:

   Si el autorizador normal no esta disponible:

   Owner Subdominio → Owner Dominio → PMO

   Plazo para escalamiento: 48 horas sin respuesta

   Documentar escalamiento en registro de transicion.

----

5. Validaciones del Sistema
---------------------------

5.1 Validaciones Automaticas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El sistema debe validar automaticamente:

.. code-block:: text

   VALIDACIONES POR TRANSICION:

   BORRADOR → EN_REVISION:
   ✓ Campo :estado: = Borrador
   ✓ Metadata completa (todos los campos requeridos)
   ✓ Sphinx compila sin errores
   ✓ Al menos 1 revisor asignado

   EN_REVISION → APROBADO:
   ✓ Campo :estado: = En_Revision
   ✓ Version correcta (>= 1.0.0 para primera aprobacion)
   ✓ Historial de cambios actualizado
   ✓ Aprobador tiene rol autorizado

   APROBADO → OBSOLETO:
   ✓ Campo :estado: = Aprobado
   ✓ Justificacion presente (min 20 caracteres)
   ✓ Reemplazo identificado (si aplica)

5.2 Mensajes de Error
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ERROR: Transicion no permitida
   "No se puede cambiar de [estado_actual] a [estado_destino].
    Transiciones validas desde [estado_actual]: [lista]"

   ERROR: Validacion fallida
   "No se puede cambiar a [estado_destino].
    Validacion fallida: [detalle del error]"

   ERROR: Autorizacion insuficiente
   "No tiene permisos para realizar esta transicion.
    Rol requerido: [rol]. Su rol: [rol_actual]"

----

6. Registro de Transiciones
---------------------------

6.1 Formato de Registro
^^^^^^^^^^^^^^^^^^^^^^^

Cada transicion de estado debe registrarse:

.. code-block:: text

   REGISTRO DE TRANSICION DE ESTADO
                                   

   Artefacto: [ID]
   Fecha/Hora: YYYY-MM-DD HH:MM:SS

   Estado Anterior: [estado]
   Estado Nuevo: [estado]

   Ejecutado por: [usuario]
   Autorizado por: [usuario] (si diferente)

   Justificacion: [texto]

   Referencia: [RFC o ticket si aplica]

6.2 Auditoria de Estados
^^^^^^^^^^^^^^^^^^^^^^^^

Mantener historial completo de transiciones:

.. code-block:: text

   HISTORIAL DE ESTADOS - [ID_Artefacto]
   =====================================

.. list-table::
   :header-rows: 1

   * - Fecha
     - De
     - A
     - Usuario
     - Motivo
   * - 2025-12-01
     - (nuevo)
     - Borrador
     - J. Perez
     - Creacion
   * - 2025-12-10
     - Borrador
     - En_Revision
     - J. Perez
     - Envio rev
   * - 2025-12-11
     - En_Revision
     - Borrador
     - M. Garcia
     - Observaciones
   * - 2025-12-12
     - Borrador
     - En_Revision
     - J. Perez
     - Reenvio
   * - 2025-12-13
     - En_Revision
     - Aprobado
     - A. Lopez
     - Aprobacion
   * - 2025-12-22
     - Aprobado
     - Obsoleto
     - A. Lopez
     - Reemplazo

----

7. Indicadores Visuales
-----------------------

7.1 Badges de Estado
^^^^^^^^^^^^^^^^^^^^

Cada estado tiene un indicador visual distintivo:

.. code-block:: text

   BORRADOR     →  [BORRADOR]     (gris)
   EN_REVISION  →  [EN REVISION]  (amarillo)
   APROBADO     →  [APROBADO]     (verde)
   OBSOLETO     →  [OBSOLETO]     (naranja)
   ARCHIVADO    →  [ARCHIVADO]    (rojo)

7.2 Advertencias en Documentos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Para BORRADOR:**

.. code-block:: rst

   .. warning::

      **BORRADOR** - Este documento no ha sido aprobado.
      No utilizar como referencia oficial.

**Para EN_REVISION:**

.. code-block:: rst

   .. note::

      **EN REVISION** - Este documento esta pendiente de aprobacion.
      Contenido sujeto a cambios.

**Para OBSOLETO:**

.. code-block:: rst

   .. danger::

      **OBSOLETO** desde [fecha].
      Reemplazado por: :ref:`nuevo-artefacto`
      Consultar solo para referencia historica.

**Para ARCHIVADO:**

.. code-block:: rst

   .. danger::

      **ARCHIVADO** - Documento retirado del uso activo.
      Solo disponible para consulta historica y auditoria.

----

8. Casos Especiales
-------------------

8.1 Artefacto sin Aprobar por Largo Tiempo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   POLITICA:

   Si un artefacto permanece en BORRADOR > 90 dias:
   - Sistema genera alerta al autor
   - Notifica a Owner del subdominio

   Si permanece en BORRADOR > 180 dias:
   - Se solicita justificacion al autor
   - PMO puede ordenar archivado o finalizacion

8.2 Artefacto en Revision sin Respuesta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   POLITICA:

   Si un artefacto permanece en EN_REVISION > 7 dias:
   - Sistema genera recordatorio a revisor

   Si permanece en EN_REVISION > 14 dias:
   - Escalamiento automatico a Owner
   - Puede reasignarse a otro revisor

8.3 Restauracion desde Archivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO EXCEPCIONAL:

   Si se requiere "revivir" un artefacto archivado:

   1. Crear NUEVO artefacto (nuevo ID)
   2. Copiar contenido del archivado
   3. Referenciar al archivado como fuente
   4. Seguir proceso normal de aprobacion

   El artefacto archivado NO cambia de estado.

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`gob-04` - Gestion de Cambios Documentales
- :ref:`gob-05` - Control de Versiones

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 15489 - Gestion de Documentos
- ISO 9001:2015 - Control de Documentos

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
     - Version inicial. 5 estados definidos (BORRADOR, EN_REVISION, APROBADO, OBSOLETO, ARCHIVADO). Matriz de transiciones. Autorizaciones. Validaciones automaticas. Indicadores visuales.

----

**Trazabilidad:** Este artefacto define el ciclo de vida de estados aplicable
a todos los artefactos del sistema documental IACT. El campo :estado: de cada
artefacto debe contener uno de los valores definidos aqui. Las transiciones
deben seguir las reglas establecidas en este documento.