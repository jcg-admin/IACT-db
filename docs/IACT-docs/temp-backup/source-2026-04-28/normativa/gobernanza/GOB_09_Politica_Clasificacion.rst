.. meta::
   :artefacto: GOB_09
   :tipo: Politica
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-09:

=================================
GOB_09: Politica de Clasificacion
=================================


Proposito
---------

Este documento establece la **politica de clasificacion de seguridad** para
todos los artefactos del sistema documental IACT, definiendo los niveles de
clasificacion, controles asociados, proceso de asignacion y cambio, y las
responsabilidades correspondientes.

.. important::

   **Pregunta Clave que Responde:**

   "¿Quien puede ver este documento y como debo manejarlo?"

.. note::

   Esta politica complementa y expande :ref:`meta_02_clasificacion_documental`,
   que define los niveles basicos. GOB_09 establece los procesos de gobernanza
   para la gestion de clasificacion.

----

1. Niveles de Clasificacion
---------------------------

1.1 Catalogo de Niveles
^^^^^^^^^^^^^^^^^^^^^^^

El sistema IACT reconoce **cuatro niveles** de clasificacion de seguridad:

.. list-table::
   :header-rows: 1
   :widths: 15 45 40

   * - Nivel
     - Definicion
     - Ejemplos Tipicos
   * - **Publico**
     - Informacion que puede divulgarse sin restricciones fuera de la organizacion.
     - Documentacion de API publica, guias de usuario final, material de marketing tecnico.
   * - **Interno**
     - Informacion de uso general dentro de la organizacion. No debe divulgarse externamente sin autorizacion.
     - Documentacion tecnica, requisitos, casos de uso, arquitectura general.
   * - **Confidencial**
     - Informacion sensible cuya divulgacion no autorizada podria causar daño a la organizacion o clientes.
     - Configuraciones de seguridad, datos anonimizados, contratos, credenciales de prueba.
   * - **Restringido**
     - Informacion altamente sensible con acceso limitado a personal especificamente autorizado.
     - Claves de produccion, datos personales, informacion financiera detallada, auditorias de seguridad.

1.2 Jerarquia de Niveles
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   JERARQUIA (de menor a mayor restriccion):

   Publico < Interno < Confidencial < Restringido

   REGLA: Un nivel superior puede acceder a niveles inferiores.

   Ejemplo:
   - Usuario con acceso "Confidencial" puede ver Publico e Interno
   - Usuario con acceso "Interno" NO puede ver Confidencial

1.3 Valores en Metadatos
^^^^^^^^^^^^^^^^^^^^^^^^

El campo ``:clasificacion:`` en el bloque ``.. meta::`` acepta:

.. code-block:: text

   Valores permitidos:
   - Publico
   - Interno
   - Confidencial
   - Restringido

   Formato: Primera letra mayuscula, sin tildes

----

2. Clasificacion por Defecto
----------------------------

2.1 Clasificacion por Dominio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cada dominio tiene una clasificacion por defecto que heredan sus artefactos:

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Dominio
     - Clasificacion
     - Justificacion
   * - base_cognitiva/
     - Interno
     - Fundamentos metodologicos, sin datos sensibles
   * - normativa/
     - Interno
     - Estandares y politicas de aplicacion interna
   * - requisitos/
     - Interno
     - Reglas de negocio y casos de uso, logica propietaria
   * - arquitectura_tecnica/
     - Confidencial
     - Decisiones de arquitectura, propiedad intelectual
   * - usuario_gestion/
     - Interno
     - Manuales y documentacion de proyecto

2.2 Clasificacion por Subdominio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algunos subdominios tienen clasificacion diferente a su dominio:

.. list-table::
   :header-rows: 1
   :widths: 35 20 45

   * - Subdominio
     - Clasificacion
     - Justificacion
   * - arquitectura_tecnica/decisiones/
     - Confidencial
     - ADRs contienen decisiones estrategicas
   * - normativa/restricciones/
     - Interno
     - Restricciones tecnicas y de negocio
   * - normativa/gobernanza/
     - Interno
     - Politicas de gobernanza documental
   * - usuario_gestion/evidencia/
     - Confidencial
     - Puede contener datos de pruebas reales

2.3 Reglas de Herencia
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA 1: Herencia por defecto
   Un artefacto hereda la clasificacion de su dominio/subdominio.

   REGLA 2: Elevacion permitida
   Un artefacto PUEDE tener clasificacion SUPERIOR a su dominio.

   REGLA 3: Reduccion prohibida
   Un artefacto NO PUEDE tener clasificacion INFERIOR a su dominio.

   REGLA 4: Propagacion hacia arriba
   Si un artefacto tiene clasificacion superior, eleva la clasificacion
   EFECTIVA del contenedor para propositos de acceso.

**Ejemplo de Elevacion:**

.. code-block:: text

   Dominio: requisitos/ (Interno)
   Artefacto: BR_SECRET_001.rst (Confidencial)

   Resultado:
   - BR_SECRET_001 requiere acceso Confidencial
   - El resto de requisitos/ sigue siendo Interno
   - Al listar requisitos/, se indica que contiene material Confidencial

----

3. Matriz de Controles
----------------------

3.1 Controles por Nivel
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 28 18 18 18 18

   * - Control
     - Publico
     - Interno
     - Confidencial
     - Restringido
   * - Almacenamiento en Git
     - Si
     - Si
     - Con cifrado
     - No permitido
   * - Envio por email corporativo
     - Si
     - Si
     - Solo cifrado
     - Prohibido
   * - Compartir con externos
     - Si
     - Con NDA
     - Prohibido
     - Prohibido
   * - Impresion fisica
     - Libre
     - Controlada
     - Con registro
     - Prohibida
   * - Copia a USB
     - Si
     - Autorizacion
     - Prohibido
     - Prohibido
   * - Discusion en areas comunes
     - Si
     - Precaucion
     - Prohibido
     - Prohibido
   * - Acceso remoto
     - Si
     - VPN
     - VPN + MFA
     - Solo on-premise

3.2 Controles de Acceso Digital
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PUBLICO:
   - Sin restriccion de acceso
   - Puede publicarse en sitios publicos
   - No requiere autenticacion

   INTERNO:
   - Requiere autenticacion corporativa
   - Acceso via VPN o red interna
   - Puede compartirse internamente sin restriccion

   CONFIDENCIAL:
   - Requiere autenticacion + rol autorizado
   - Acceso registrado en logs
   - Cifrado en reposo y en transito
   - Prohibido en dispositivos personales

   RESTRINGIDO:
   - Requiere autenticacion + autorizacion explicita
   - Acceso con justificacion documentada
   - Cifrado de extremo a extremo
   - Solo en equipos corporativos controlados
   - Monitoreo activo de acceso

----

4. Matriz de Acceso por Rol
---------------------------

4.1 Permisos por Nivel de Clasificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 28 18 18 18 18

   * - Rol
     - Publico
     - Interno
     - Confidencial
     - Restringido
   * - PMO / Gobernanza
     - L/E
     - L/E
     - L/E
     - L/E
   * - Arquitecto
     - L/E
     - L/E
     - L/E
     - L
   * - Business Analyst
     - L/E
     - L/E
     - L
     - --
   * - Tech Lead
     - L/E
     - L/E
     - L/E
     - L
   * - Developer
     - L/E
     - L/E
     - L
     - --
   * - QA
     - L
     - L
     - L
     - --
   * - Tech Writer
     - L/E
     - L/E
     - L
     - --
   * - Auditor
     - L
     - L
     - L
     - L
   * - Stakeholder Externo
     - L
     - --
     - --
     - --

**Leyenda:** L = Lectura, E = Escritura, L/E = Ambos, -- = Sin acceso

4.2 Acceso Excepcional
^^^^^^^^^^^^^^^^^^^^^^

Para acceso excepcional a niveles superiores al rol:

.. code-block:: text

   PROCESO DE ACCESO EXCEPCIONAL:

   1. Solicitante envia justificacion a Owner del dominio

   2. Owner evalua:
      - Necesidad real de acceso
      - Duracion requerida
      - Riesgos asociados

   3. Si es Confidencial o superior:
      - Requiere aprobacion adicional de PMO
      - Requiere aceptacion de terminos de confidencialidad

   4. Acceso otorgado:
      - Temporal (maximo 30 dias, renovable)
      - Registrado en log de accesos excepcionales
      - Revocable en cualquier momento

   5. Al finalizar:
      - Acceso revocado automaticamente
      - Registro de uso durante el periodo

----

5. Proceso de Asignacion de Clasificacion
-----------------------------------------

5.1 Asignacion Inicial
^^^^^^^^^^^^^^^^^^^^^^

Al crear un artefacto:

.. code-block:: text

   PASO 1: Determinar clasificacion por defecto
   - Identificar dominio/subdominio
   - Aplicar clasificacion heredada

   PASO 2: Evaluar contenido
   - ¿Contiene datos personales? → Minimo Confidencial
   - ¿Contiene credenciales? → Minimo Confidencial
   - ¿Contiene datos financieros? → Minimo Confidencial
   - ¿Contiene propiedad intelectual critica? → Evaluar Confidencial

   PASO 3: Asignar clasificacion
   - Usar la MAS ALTA entre herencia y contenido
   - Documentar en campo :clasificacion:

   PASO 4: Verificar
   - Revisor valida clasificacion apropiada

5.2 Indicadores de Contenido Sensible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Tipo de Contenido
     - Clasificacion Minima
     - Ejemplo
   * - Datos personales identificables
     - Restringido
     - Nombres, emails, telefonos de clientes
   * - Credenciales de produccion
     - Restringido
     - API keys, passwords, tokens
   * - Datos financieros detallados
     - Restringido
     - Transacciones, cuentas, balances
   * - Credenciales de prueba
     - Confidencial
     - Usuarios de test, endpoints de staging
   * - Configuraciones de seguridad
     - Confidencial
     - Firewalls, ACLs, politicas
   * - Arquitectura detallada
     - Confidencial
     - Diagramas internos, decisiones tecnicas
   * - Datos anonimizados
     - Confidencial
     - Estadisticas agregadas de clientes
   * - Logica de negocio propietaria
     - Interno
     - Reglas de negocio, algoritmos
   * - Documentacion tecnica general
     - Interno
     - APIs, guias de desarrollo

----

6. Proceso de Cambio de Clasificacion
-------------------------------------

6.1 Solicitud de Cambio
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   SOLICITUD DE CAMBIO DE CLASIFICACION
   ====================================

   Fecha: YYYY-MM-DD
   Solicitante: [nombre]

   ARTEFACTO:
   - ID: [identificador]
   - Clasificacion actual: [nivel]
   - Clasificacion solicitada: [nivel]

   JUSTIFICACION:
   [Explicar por que se requiere el cambio]

   TIPO DE CAMBIO:
   [ ] Elevacion (a nivel mas restrictivo)
   [ ] Reduccion (a nivel menos restrictivo)

   IMPACTO:
   - Usuarios afectados: [lista o cantidad]
   - Otros artefactos afectados: [lista]

6.2 Proceso de Aprobacion
^^^^^^^^^^^^^^^^^^^^^^^^^

**Elevacion de Clasificacion:**

.. code-block:: text

   Publico → Interno:      Owner Subdominio
   Interno → Confidencial: Owner Dominio
   Confidencial → Restringido: PMO + Seguridad

**Reduccion de Clasificacion:**

.. code-block:: text

   ADVERTENCIA: La reduccion de clasificacion es una operacion
   sensible que requiere mayor escrutinio.

   Restringido → Confidencial: PMO + Seguridad + Justificacion detallada
   Confidencial → Interno:     Owner Dominio + PMO
   Interno → Publico:          PMO + Legal (si aplica)

6.3 Ejecucion del Cambio
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CHECKLIST DE CAMBIO DE CLASIFICACION:

   [ ] Aprobacion obtenida y documentada
   [ ] Campo :clasificacion: actualizado en metadata
   [ ] Campo :ultimo_cambio: actualizado
   [ ] Entrada agregada en Historial de Cambios
   [ ] Permisos de acceso actualizados (si aplica)
   [ ] Notificacion a usuarios afectados
   [ ] Registro en log de cambios de clasificacion

6.4 Registro del Cambio
^^^^^^^^^^^^^^^^^^^^^^^

En el historial del artefacto:

.. code-block:: rst

   Historial de Cambios
   --------------------

   * - 1.1.0
     - 2025-12-22
     - J. Perez
     - Clasificacion cambiada de Interno a Confidencial.
       Justificacion: Artefacto ahora contiene configuraciones
       de seguridad del sistema. Aprobado por: M. Garcia (PMO).

----

7. Incidentes de Clasificacion
------------------------------

7.1 Definicion de Incidente
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Un incidente de clasificacion ocurre cuando:

.. code-block:: text

   TIPOS DE INCIDENTE:

   - Divulgacion no autorizada de informacion clasificada
   - Acceso no autorizado a material restringido
   - Almacenamiento en ubicacion no permitida
   - Transmision por canal no seguro
   - Clasificacion incorrecta descubierta (sub-clasificado)
   - Perdida de material clasificado

7.2 Proceso de Respuesta
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESPUESTA A INCIDENTE DE CLASIFICACION
   ======================================

   PASO 1: CONTENER (inmediato)
   - Detener divulgacion adicional
   - Revocar accesos comprometidos
   - Preservar evidencia

   PASO 2: REPORTAR (< 1 hora)
   - Notificar a Seguridad de la Informacion
   - Notificar a PMO
   - Documentar hechos conocidos

   PASO 3: EVALUAR (< 24 horas)
   - Determinar alcance de la divulgacion
   - Identificar informacion comprometida
   - Evaluar impacto potencial

   PASO 4: REMEDIAR (segun impacto)
   - Ejecutar plan de contencion
   - Notificar a afectados (si aplica)
   - Implementar controles adicionales

   PASO 5: DOCUMENTAR (< 72 horas)
   - Informe completo del incidente
   - Lecciones aprendidas
   - Acciones preventivas

7.3 Severidad de Incidentes
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Severidad
     - Criterio
     - Respuesta
   * - **Critica**
     - Divulgacion de Restringido a externos
     - Escalamiento inmediato a direccion
   * - **Alta**
     - Divulgacion de Confidencial a no autorizados
     - Respuesta en < 4 horas
   * - **Media**
     - Acceso indebido sin divulgacion
     - Respuesta en < 24 horas
   * - **Baja**
     - Error de clasificacion sin consecuencias
     - Correccion en < 72 horas

----

8. Auditoria de Clasificacion
-----------------------------

8.1 Revisiones Periodicas
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FRECUENCIA DE REVISION:

   - Restringido: Trimestral
   - Confidencial: Semestral
   - Interno: Anual
   - Publico: Cada 2 años

   VERIFICACIONES:
   [ ] Clasificacion sigue siendo apropiada
   [ ] Controles de acceso correctos
   [ ] No hay material sub-clasificado
   [ ] Accesos excepcionales justificados

8.2 Reporte de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REPORTE DE AUDITORIA DE CLASIFICACION
   =====================================

   Periodo: [fecha inicio] a [fecha fin]
   Auditor: [nombre]

   1. ESTADISTICAS:
      - Artefactos Publico: N
      - Artefactos Interno: N
      - Artefactos Confidencial: N
      - Artefactos Restringido: N

   2. HALLAZGOS:
      - Posibles sub-clasificaciones: [lista]
      - Accesos excepcionales activos: N
      - Incidentes en el periodo: N

   3. RECOMENDACIONES:
      [Lista de acciones sugeridas]

   4. ESTADO GENERAL:
      [ ] Conforme
      [ ] Requiere atencion
      [ ] Critico

----

9. Responsabilidades
--------------------

9.1 Matriz RACI
^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 14 14 14 14 14

   * - Actividad
     - Autor
     - Owner
     - PMO
     - Seguridad
     - Auditor
   * - Asignar clasificacion inicial
     - R
     - A
     - I
     - C
     - I
   * - Solicitar cambio de clasificacion
     - R
     - C
     - A
     - C
     - I
   * - Aprobar elevacion
     - I
     - R
     - A
     - C
     - I
   * - Aprobar reduccion
     - I
     - C
     - R
     - A
     - I
   * - Reportar incidente
     - R
     - I
     - I
     - A
     - I
   * - Responder a incidente
     - C
     - C
     - R
     - R
     - I
   * - Auditar clasificacion
     - I
     - C
     - I
     - C
     - R

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`meta_02_clasificacion_documental` - Definicion base de niveles
- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`gob-10` - Auditoria Documental

Fuentes Externas
^^^^^^^^^^^^^^^^

- ISO 27001 - Seguridad de la Informacion
- ISO 27002 - Controles de Seguridad

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
     - Version inicial. 4 niveles de clasificacion. Matriz de controles y acceso. Procesos de asignacion y cambio. Gestion de incidentes. Auditoria.

----

**Trazabilidad:** Este artefacto establece la politica de clasificacion de
seguridad aplicable a todos los artefactos IACT. Complementa META_02 con los
procesos de gobernanza. Es verificado por GOB_10 (Auditoria Documental).