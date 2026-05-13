.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-MOD-NN
   :Titulo: Nombre del Use Case
   :Version: 4.0.0
   :Actor_Principal: Rol del Actor
   :Tipo: Normal|CRUD|Temporal|UI-Driven
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
UC-IACT-MOD-NN: Nombre del Use Case
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Actor Principal:** Rol del Actor Principal  
**Tipo:** Normal|CRUD|Temporal|UI-Driven  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Use Cases siguiendo la estructura estandar de
11 componentes basada en las mejores practicas de Cockburn, Larman
y Jacobson.

**Proposito de los Use Cases:**

Los UC describen interacciones entre actores y el sistema para lograr
un objetivo de valor para el negocio. Un UC bien escrito:

1. Describe QUE hace el sistema, no COMO lo implementa
2. Captura el flujo de eventos desde la perspectiva del actor
3. Define precondiciones y postcondiciones claras
4. Maneja casos alternos y excepciones
5. Deriva Functional Requirements implementables

**Los 11 Componentes Estandar:**

1. Actor Principal: Quien inicia el UC
2. Actores Secundarios: Quienes participan pero no inician
3. Precondiciones: Estado requerido antes de ejecutar
4. Trigger: Evento que inicia el UC
5. Flujo Normal: Camino feliz, paso a paso
6. Flujos Alternos: Variaciones esperadas del flujo normal
7. Flujos de Excepcion: Errores inesperados
8. Postcondiciones: Estado resultante tras ejecucion
9. Requisitos No Funcionales: Performance, usabilidad, seguridad
10. Reglas de Negocio: BR implementadas en el UC
11. Derivacion de FR: Mapeo paso → FR

**Caracteristicas de un UC Bien Escrito:**

- Atomico: Cada paso es una accion simple e indivisible
- Completo: Cubre caso normal, alternos y excepciones
- Consistente: Terminologia uniforme
- Correcto: Sin errores logicos
- Verificable: Puede testearse
- Modificable: Facil de actualizar
- Trazable: Derivacion clara a FR

----------------------------------------------------------------------
1. ACTOR PRINCIPAL
----------------------------------------------------------------------

**Definicion:**

El actor principal es quien INICIA el caso de uso y tiene el OBJETIVO
que este UC busca satisfacer.

**Actor Principal:** Nombre del actor o rol

**Tipo de Actor:**

- Usuario Interno: empleado de la organizacion
- Usuario Externo: cliente, proveedor, partner
- Sistema Externo: API, servicio, aplicacion
- Sistema: Scheduler/Cron Job para UC temporales

**Rol Especifico:**

Titulo o cargo concreto del actor, ejemplo: Analista de Operaciones,
Supervisor de Area, Administrador del Sistema, Cliente Corporativo

**Objetivo del Actor:**

Que busca lograr el actor al ejecutar este UC

**Formato:** "Quiero accion para beneficio"

**EJEMPLO COMPLETO (UC-RPT-01):**

Actor Principal: Analista de Operaciones

Tipo: Usuario Interno

Rol Especifico: Analista de metricas de IVR del area de Call Center

Objetivo:
"Quiero consultar reportes trimestrales de metricas IVR para analizar
tendencias y generar presentaciones ejecutivas"

Contexto:
El Analista necesita datos agregados de llamadas IVR por trimestre,
segmento de cliente y tipo de consulta, para identificar patrones,
calcular KPIs y reportar a gerencia.

----------------------------------------------------------------------
2. ACTORES SECUNDARIOS
----------------------------------------------------------------------

**Definicion:**

Actores secundarios PARTICIPAN en el UC pero NO lo inician. Pueden ser:

- Sistemas externos que proveen datos
- Usuarios que autorizan acciones
- Servicios que el UC consume
- Bases de datos consultadas

**Formato de Documentacion:**

.. list-table::
   :header-rows: 1
   :widths: 25 50 25

   * - Actor Secundario
     - Rol en el UC
     - Momento de Participacion
   * - Nombre Actor
     - Que hace o provee
     - En que paso participa
   * - Nombre Actor 2
     - Que hace o provee
     - En que paso participa

**EJEMPLO COMPLETO (UC-RPT-01):**

.. list-table::
   :header-rows: 1
   :widths: 25 50 25

   * - Actor Secundario
     - Rol en el UC
     - Momento de Participacion
   * - Sistema Analytics
     - Provee datos agregados de BD
     - Paso 7: Ejecuta query principal
   * - Supervisor de Area
     - Aprueba consultas grandes
     - FA-2: Cuando count mayor 10,000
   * - Servicio de Email
     - Envia reporte por email
     - Paso 11: Si usuario solicita envio

----------------------------------------------------------------------
3. PRECONDICIONES
----------------------------------------------------------------------

**Definicion:**

Precondiciones son condiciones que DEBEN cumplirse ANTES de que el UC
pueda ejecutarse. Si una precondicion falla, el UC no puede iniciarse.

**Caracteristicas:**

- Verificables: Se puede comprobar si se cumple
- Necesarias: Sin ellas, UC no puede ejecutarse
- Fuera de control del UC: UC no las crea, ya deben existir

**Formato:**

PC-N: Titulo de la precondicion

Descripcion: Detalle de que debe existir o cumplirse

Verificacion: Como se comprueba

**PRECONDICIONES:**

PC-1: Titulo de precondicion 1

Descripcion: Detalle de la condicion

Verificacion: Query SQL o metodo de verificacion

PC-2: Titulo de precondicion 2

Descripcion: ...

Verificacion: ...

**EJEMPLO COMPLETO (UC-RPT-01):**

PC-1: Usuario Autenticado en el Sistema

Descripcion:
El usuario debe haber iniciado sesion exitosamente y tener una sesion
activa valida.

Verificacion:

.. code-block:: sql

   SELECT * FROM ivr_sessions
   WHERE user_id = :user_id
     AND status = 'ACTIVE'
     AND last_activity_at > NOW() - INTERVAL '15 minutes'
   -- Debe retornar 1 fila

PC-2: Usuario tiene Permiso RPT-001

Descripcion:
El usuario debe tener asignado el permiso RPT-001 que autoriza consultar
reportes operacionales.

Verificacion:

.. code-block:: sql

   SELECT COUNT(*) FROM user_permissions
   WHERE user_id = :user_id
     AND permission_code = 'RPT-001'
     AND revoked_at IS NULL
   -- Debe retornar 1

PC-3: Segmento Valido Existe en Catalogo

Descripcion:
El segmento que el usuario va a consultar debe existir en el catalogo
de segmentos activos: OP (Operaciones) o MG (Management).

Verificacion:

.. code-block:: sql

   SELECT segment_code FROM segments
   WHERE segment_code IN ('OP', 'MG')
     AND is_active = TRUE
   -- Debe retornar 2 filas

----------------------------------------------------------------------
4. TRIGGER (Evento Desencadenante)
----------------------------------------------------------------------

**Definicion:**

El trigger es el evento especifico que inicia la ejecucion del UC.
Puede ser:

- Accion del usuario: Click en boton, submit de form
- Evento temporal: Llega cierta hora, pasa X tiempo
- Evento de sistema: Llegada de mensaje, cambio de estado
- Evento externo: Webhook, callback, notificacion

**Especificidad:**

El trigger debe ser MUY especifico, no generico.

Malo: "Usuario quiere consultar reporte"
Bueno: "Usuario hace click en menu Reportes > Trimestral"

**TRIGGER:**

Tipo: Accion Usuario | Temporal | Sistema | Externo

Detalle: Descripcion exacta del evento

**EJEMPLO COMPLETO (UC-RPT-01):**

Tipo: Accion de Usuario

Detalle:
Usuario autenticado hace click en la opcion de menu:
"Reportes > Metricas Trimestrales"

Elemento UI: Menu item con ID=menu-reports-quarterly
Ubicacion: Barra de navegacion principal, seccion Reportes
Icono: Grafico de barras, color azul

----------------------------------------------------------------------
5. FLUJO NORMAL
----------------------------------------------------------------------

**Definicion:**

El flujo normal describe el camino feliz, paso a paso, cuando TODO
sale bien y no hay errores ni condiciones especiales.

**Reglas del Flujo Normal:**

1. Maximo 15 pasos (ideal: 7-12 pasos)
2. Cada paso es ATOMICO, una accion simple
3. Alternar actor-sistema: usuario hace, sistema responde
4. Numerar pasos: 1, 2, 3, ...
5. Verbo presente indicativo: "Sistema valida", no "validara"
6. Cada paso puede derivar FR, anotar entre parentesis

**Formato de Paso:**

N. Actor/Sistema hace accion especifica (FR-XXX-NN-ZZ si deriva FR)

**Anotaciones de BR:**

Si un paso implementa una BR, anotar: paso N implementa BR-IACT-XXX

**FLUJO NORMAL:**

1. Actor hace primera accion

2. Sistema responde con algo (FR-XXX-NN-01)

3. Actor hace segunda accion

...

N. UC termina exitosamente

**EJEMPLO COMPLETO (UC-RPT-01):**

FLUJO NORMAL - Consultar Reporte Trimestral

1. Usuario selecciona parametros de consulta en formulario:
   
   - Trimestre: Q3 (dropdown)
   - Ano: 2024 (dropdown)
   - Segmento: OP - Operaciones (dropdown)
   - Tipo Consulta: Todas (checkbox)

2. Sistema valida formato de parametros (FR-RPT-01-01)
   
   Verifica:
   - Trimestre en Q1, Q2, Q3, Q4
   - Ano entre 2020 y ano actual
   - Segmento en OP, MG

3. Usuario hace click en boton "Generar Reporte"

4. Sistema muestra mensaje "Calculando volumen de datos..."
   (FR-RPT-01-02)

5. Sistema ejecuta COUNT para estimar volumen de registros
   (FR-RPT-01-03)
   
   Implementa BR-IACT-028: Aprobacion Consultas Grandes

.. code-block:: sql

   SELECT COUNT(*) as record_count
   FROM ivr_calls
   WHERE quarter = 'Q3'
     AND year = 2024
     AND segment = 'OP'

6. Sistema evalua resultado del count (FR-RPT-01-04)
   
   Si count menor o igual 10,000 → Continua paso 7
   Si count mayor 10,000 → FA-2: Requiere Aprobacion

7. Sistema ejecuta query principal de reporte (FR-RPT-01-05)

.. code-block:: sql

   SELECT 
       DATE_TRUNC('day', call_date) as dia,
       COUNT(*) as total_llamadas,
       SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) as completadas,
       SUM(CASE WHEN status='ABANDONED' THEN 1 ELSE 0 END) as abandonadas,
       AVG(duration_seconds) as duracion_promedio
   FROM ivr_calls
   WHERE quarter = 'Q3'
     AND year = 2024
     AND segment = 'OP'
   GROUP BY DATE_TRUNC('day', call_date)
   ORDER BY dia

8. Sistema procesa resultados y calcula metricas derivadas
   (FR-RPT-01-06)
   
   Implementa BR-IACT-053: Calculo Tasa Abandono

.. code-block:: python

   tasa_abandono = (abandonadas / total_llamadas) * 100

9. Sistema genera graficos visuales (FR-RPT-01-07)
   
   - Grafico de lineas: Llamadas por dia
   - Grafico de barras: Completadas vs Abandonadas
   - KPI card: Tasa de abandono con semaforo

10. Sistema muestra tabla de resultados con graficos en pantalla
    (FR-RPT-01-08)

11. Sistema registra consulta ejecutada en audit log (FR-RPT-01-09)

.. code-block:: sql

   INSERT INTO report_audit_log (
       user_id, report_type, parameters,
       record_count, executed_at
   ) VALUES (
       :user_id, 'QUARTERLY',
       '{"quarter":"Q3","year":2024,"segment":"OP"}',
       :count, NOW()
   )

12. Caso de uso termina exitosamente

Usuario ve reporte completo en pantalla, puede exportar a Excel/PDF
si lo desea mediante opciones adicionales.

----------------------------------------------------------------------
6. FLUJOS ALTERNOS (FA)
----------------------------------------------------------------------

**Definicion:**

Caminos alternativos para condiciones ESPERADAS que difieren del flujo
normal. NO son errores, son variaciones normales del negocio.

**Diferencia FA vs FE:**

- FA: Situacion ESPERADA (validacion falla, sin datos, cancelar)
- FE: Error INESPERADO (timeout, excepcion, servicio caido)

**Formato:**

FA-N: Titulo Descriptivo

En paso X, si condicion:

  Xa. Sistema/Actor hace accion alternativa 1
  
  Xb. Sistema/Actor hace accion alternativa 2
  
  Xc. Resolucion: vuelve a paso Y | termina UC exitosamente | termina UC con falla

**Tipos Comunes de FA:**

- Validacion: Datos no cumplen reglas
- Datos Vacios: No se encuentran resultados
- Cancelacion: Usuario cancela operacion
- Permiso: Usuario no autorizado para algo especifico
- Negocio: BR requiere flujo diferente

**FLUJOS ALTERNOS:**

FA-1: Titulo del Flujo Alterno 1

En paso X, si condicion:

  Xa. Accion
  
  Xb. Accion
  
  Xc. Resolucion

FA-2: Titulo del Flujo Alterno 2

...

**EJEMPLO COMPLETO (UC-RPT-01):**

FA-1: Validacion de Parametros Falla

En paso 2, si alguno de los parametros es invalido:

  2a. Sistema identifica parametros invalidos
  
  2b. Sistema muestra mensaje de error especifico:
      
      "Error: Parametros invalidos detectados:
      - Trimestre debe ser Q1, Q2, Q3 o Q4
      - Ano debe estar entre 2020 y 2024"
      
      Mensaje en color rojo, icono de advertencia
  
  2c. Sistema mantiene formulario abierto con valores ingresados
  
  2d. Usuario corrige parametros
  
  2e. Vuelve a paso 3 (usuario hace click en Generar)

FA-2: Consulta Requiere Aprobacion del Supervisor

En paso 6, si count mayor 10,000 registros:

  6a. Sistema NO ejecuta query principal
  
  6b. Sistema crea registro de solicitud de aprobacion
      (FR-RPT-01-10)

.. code-block:: sql

   INSERT INTO approvals (
       user_id, report_type, parameters,
       record_count, status, created_at
   ) VALUES (
       :user_id, 'QUARTERLY', :params_json,
       :count, 'PENDING', NOW()
   )

  6c. Sistema identifica supervisor del usuario
      
.. code-block:: sql

   SELECT supervisor_id FROM user_hierarchy
   WHERE user_id = :user_id

  6d. Sistema crea notificacion para supervisor
      (FR-RPT-01-11)
      
      Titulo: "Aprobacion requerida: Consulta de nombre_usuario"
      Descripcion: "Consulta retornaria count registros"

  6e. Sistema muestra modal al usuario:
      
      "Su consulta requiere aprobacion del supervisor debido al
      volumen de datos (count registros).
      
      Le notificaremos cuando sea aprobada o rechazada.
      
      Tiempo estimado de respuesta: 2-4 horas."
      
      Boton: OK

  6f. Usuario hace click en OK

  6g. UC termina, usuario debe esperar aprobacion
      
      Nota: La ejecucion del reporte ocurrira en UC separado
      UC-RPT-02: Ejecutar Reporte Aprobado

----------------------------------------------------------------------
7. FLUJOS DE EXCEPCION (FE)
----------------------------------------------------------------------

**Definicion:**

Flujos de excepcion manejan errores INESPERADOS, situaciones
anormales que NO deberian ocurrir en operacion normal.

**Diferencia FA vs FE:**

- FA: Esperado, parte del negocio normal
- FE: Inesperado, error tecnico o situacion anomala

**Ejemplos de FE:**

- Timeout de base de datos
- Servicio externo no disponible
- Excepcion no capturada
- Datos corruptos
- Falta de recursos (memoria, disco)

**Formato:**

FE-N: Titulo de la Excepcion

En paso X, si ocurre error Y:

  Xa. Sistema registra error en log
  
  Xb. Sistema muestra mensaje generico al usuario
  
  Xc. Sistema notifica a soporte tecnico
  
  Xd. UC termina con falla

**FLUJOS DE EXCEPCION:**

FE-1: Titulo de Excepcion 1

En paso X, si error Y:

  Xa. Accion
  
  Xb. Accion
  
  Xc. UC termina con falla

**EJEMPLO COMPLETO (UC-RPT-01):**

FE-1: Timeout de Base de Datos

En paso 7, si query principal no responde en 30 segundos:

  7a. Sistema cancela ejecucion de query
      
.. code-block:: sql

   -- PostgreSQL statement timeout
   SET statement_timeout = '30s'

  7b. Sistema registra error en log de aplicacion
      
.. code-block:: python

   logger.error(
       f"Query timeout for user {user_id}, "
       f"params: {params}, query: {query_hash}"
   )

  7c. Sistema envia alerta a equipo de soporte via Slack
      
      Canal: alerts-database
      Mensaje: "DB timeout en UC-RPT-01, user_id usuario"

  7d. Sistema muestra mensaje al usuario:
      
      "Lo sentimos, la consulta tardo demasiado en ejecutarse.
      
      Esto puede deberse a alto volumen de datos o carga en
      el sistema.
      
      Por favor intente:
      - Reducir el rango de fechas
      - Consultar en horario de menor carga (6am-8am)
      - Contactar a soporte si persiste
      
      Codigo de error: ERR-RPT-TIMEOUT-timestamp"
      
      Boton: Volver al Formulario

  7e. Usuario hace click en Volver

  7f. Sistema vuelve a mostrar formulario con parametros previos

  7g. UC termina con falla, usuario puede reintentar con otros parametros

----------------------------------------------------------------------
8. POSTCONDICIONES
----------------------------------------------------------------------

**Definicion:**

Postcondiciones son condiciones que DEBEN cumplirse DESPUES de que el
UC se ejecuta, dependiendo del resultado (exito o falla).

**Tipos de Postcondiciones:**

1. Postcondicion de Exito: Si UC termina exitosamente
2. Postcondicion de Falla: Si UC termina con error
3. Invariante: Condicion que SIEMPRE se cumple, exito o falla

**Caracteristicas:**

- Verificables: Se puede comprobar si se cumple
- Estado observable: Cambio en BD, archivo, UI
- Consistentes: Sistema queda en estado valido

**Formato:**

**Exito:**

- Condicion 1 que se cumple si UC termina bien
- Condicion 2

**Falla:**

- Condicion 1 que se cumple si UC termina con error
- Condicion 2

**Invariante:**

- Condicion que SIEMPRE se cumple

**POSTCONDICIONES:**

**Exito:**

- Descripcion de estado resultante

**Falla:**

- Descripcion de estado resultante

**Invariante:**

- Descripcion de condicion siempre cierta

**EJEMPLO COMPLETO (UC-RPT-01):**

**Exito:**

- Reporte generado y mostrado en pantalla del usuario
- Tabla report_audit_log contiene nuevo registro de la consulta
- Graficos visuales renderizados correctamente
- Usuario puede exportar reporte a Excel o PDF
- Metricas calculadas (tasa abandono) son correctas

Verificacion:

.. code-block:: sql

   SELECT * FROM report_audit_log
   WHERE user_id = :user_id
     AND executed_at > NOW() - INTERVAL '1 minute'
   ORDER BY executed_at DESC
   LIMIT 1
   -- Debe retornar 1 fila con status='SUCCESS'

**Falla:**

- Reporte NO generado
- Log de error registrado en application_logs
- Usuario ve mensaje de error descriptivo
- Equipo de soporte notificado si es error critico
- Parametros de consulta preservados para reintento

Verificacion:

.. code-block:: sql

   SELECT * FROM application_logs
   WHERE severity = 'ERROR'
     AND module = 'reports'
     AND created_at > NOW() - INTERVAL '1 minute'
   -- Debe retornar al menos 1 fila

**Invariante:**

- Integridad de datos NO comprometida
- Session del usuario permanece activa
- Permisos del usuario sin cambios
- Catalogo de segmentos permanece consistente

----------------------------------------------------------------------
9. REQUISITOS NO FUNCIONALES (RNF)
----------------------------------------------------------------------

**Definicion:**

RNF son atributos de calidad del UC, no funcionalidad directa.
Describen COMO el sistema debe comportarse.

**Categorias Principales:**

1. Performance: Tiempo de respuesta, throughput
2. Usabilidad: Facilidad de uso, accesibilidad
3. Seguridad: Autenticacion, autorizacion, encriptacion
4. Disponibilidad: Uptime, tolerancia a fallos
5. Escalabilidad: Manejo de carga creciente
6. Mantenibilidad: Facilidad de cambiar/extender

**Formato:**

**RNF-Categoria-N: Titulo**

Descripcion del requisito

Metrica: Valor medible

**REQUISITOS NO FUNCIONALES:**

**RNF-Performance-1: Titulo**

Descripcion

Metrica: Valor

**EJEMPLO COMPLETO (UC-RPT-01):**

**RNF-Performance-1: Tiempo de Respuesta Aceptable**

La consulta debe completarse en menos de 5 segundos para el 95%
de los casos (percentil 95).

Metrica:
- p95 de tiempo respuesta menor 5 segundos
- p50 de tiempo respuesta menor 2 segundos

Verificacion:

.. code-block:: python

   # Prometheus query
   histogram_quantile(0.95,
       report_query_duration_seconds{type="quarterly"}
   ) < 5

**RNF-Performance-2: Limite de Registros Sin Degradacion**

El sistema debe manejar consultas de hasta 10,000 registros sin
degradacion notable de performance.

Metrica:
- Consultas hasta 10K registros: menor 5 seg
- Consultas 10K-50K: menor 30 seg (con aprobacion)

**RNF-Usabilidad-1: Interfaz Intuitiva**

El formulario de parametros debe ser comprensible sin entrenamiento
previo. Usuario promedio completa consulta en menos de 30 segundos.

Metrica:
- Task completion rate mayor 90%
- Tiempo promedio para primera consulta menor 30 seg

**RNF-Usabilidad-2: Mensajes de Error Claros**

Los mensajes de error deben ser especificos y accionables, no
tecnicos.

Metrica:
- 100% de errores tienen mensaje usuario-friendly
- 0% de stack traces visibles al usuario

**RNF-Seguridad-1: Autorizacion Basada en Permisos**

Solo usuarios con permiso RPT-001 pueden ejecutar reportes.
Sistema valida permisos en cada request.

Metrica:
- 100% de requests validados
- 0% de bypass de autorizacion

Verificacion:

.. code-block:: python

   @require_permission('RPT-001')
   def generate_report(request):
       # Implementation

**RNF-Seguridad-2: Auditoria Completa**

Todas las consultas se registran en audit log con user_id,
timestamp, parametros.

Metrica:
- 100% de consultas auditadas
- Logs retenidos por 12 meses

**RNF-Disponibilidad-1: Alta Disponibilidad**

El servicio de reportes debe tener uptime de 99.5% mensual.

Metrica:
- Uptime mayor o igual 99.5%
- Downtime maximo 3.6 horas/mes

**RNF-Disponibilidad-2: Degradacion Graceful**

Si servicio analytics no disponible, mostrar datos en cache hasta
24 horas atras.

Metrica:
- Fallback a cache en menos 2 segundos
- Cache valido hasta 24 horas

----------------------------------------------------------------------
10. REGLAS DE NEGOCIO ASOCIADAS
----------------------------------------------------------------------

**Definicion:**

Lista de Business Rules que este UC implementa, con descripcion de
DONDE y COMO se implementa cada BR.

**Formato:**

**BR-IACT-XXX: Nombre de la BR**

Tipo: Restriccion|Calculo|Desencadenador|Inferencia

Donde se implementa:
- Paso N del flujo normal
- FA-X
- Precondicion PC-Y

Como se implementa:
Descripcion breve de como el UC implementa la BR

**REGLAS DE NEGOCIO ASOCIADAS:**

**BR-IACT-XXX: Nombre**

Tipo: Tipo de BR

Donde: Paso N | FA-X | PC-Y

Como: Descripcion de implementacion

**EJEMPLO COMPLETO (UC-RPT-01):**

**BR-IACT-028: Aprobacion de Consultas Grandes**

Tipo: Restriccion

Donde se implementa:
- Paso 5: Sistema ejecuta COUNT
- Paso 6: Sistema evalua resultado
- FA-2: Si count mayor 10,000, requiere aprobacion

Como se implementa:

1. Sistema calcula COUNT con mismos parametros que query principal
2. Si COUNT mayor 10,000:
   - NO ejecuta query principal
   - Crea registro en tabla approvals
   - Notifica a supervisor
   - Muestra mensaje de espera a usuario
3. Si COUNT menor o igual 10,000:
   - Continua con query principal normalmente

Codigo clave:

.. code-block:: python

   count = execute_count_query(params)
   
   if count > APPROVAL_THRESHOLD:  # 10,000
       create_approval_request(user_id, params, count)
       notify_supervisor(user.supervisor_id)
       return show_approval_pending_modal()
   else:
       return execute_main_query(params)

**BR-IACT-053: Calculo de Tasa de Abandono**

Tipo: Calculo

Donde se implementa:
- Paso 8: Sistema procesa resultados y calcula metricas derivadas

Como se implementa:

Sistema aplica formula:

   tasa_abandono = (llamadas_abandonadas / total_llamadas) * 100

Para cada dia del periodo, calcula:
- Total llamadas
- Llamadas completadas
- Llamadas abandonadas
- Tasa de abandono

Codigo:

.. code-block:: python

   def calculate_abandon_rate(completed, abandoned):
       total = completed + abandoned
       if total == 0:
           return None
       return round((abandoned / total) * 100, 2)

----------------------------------------------------------------------
11. DERIVACION DE FUNCTIONAL REQUIREMENTS
----------------------------------------------------------------------

**Definicion:**

Mapeo de cada paso del flujo normal a los FR que deben implementarse.

**Regla General:**

Cada paso del flujo normal que dice "Sistema hace X" deriva un FR.

Pasos donde "Usuario hace X" tipicamente NO derivan FR propios, son
inputs al sistema.

**Formato:**

.. list-table::
   :header-rows: 1
   :widths: 10 60 30

   * - Paso
     - Descripcion
     - FR Derivado
   * - 1
     - Usuario ingresa datos
     - -
   * - 2
     - Sistema valida datos
     - FR-XXX-NN-01
   * - 3
     - Usuario confirma
     - -
   * - 4
     - Sistema procesa
     - FR-XXX-NN-02

**DERIVACION FR:**

.. list-table::
   :header-rows: 1
   :widths: 10 60 30

   * - Paso
     - Descripcion
     - FR Derivado
   * - N
     - Descripcion del paso
     - FR-XXX-NN-ZZ

**EJEMPLO COMPLETO (UC-RPT-01):**

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - Paso
     - Descripcion
     - FR Derivado
   * - 1
     - Usuario selecciona parametros
     - FR-RPT-01-01
   * - 2
     - Sistema valida formato
     - FR-RPT-01-02
   * - 3
     - Usuario click Generar
     - -
   * - 4
     - Sistema muestra mensaje calculando
     - FR-RPT-01-03
   * - 5
     - Sistema ejecuta COUNT
     - FR-RPT-01-04
   * - 6
     - Sistema evalua resultado count
     - FR-RPT-01-05
   * - 7
     - Sistema ejecuta query principal
     - FR-RPT-01-06
   * - 8
     - Sistema calcula metricas derivadas
     - FR-RPT-01-07
   * - 9
     - Sistema genera graficos
     - FR-RPT-01-08
   * - 10
     - Sistema muestra resultados
     - FR-RPT-01-09
   * - 11
     - Sistema registra en audit log
     - FR-RPT-01-10
   * - 12
     - UC termina exitosamente
     - -

**Detalles de FR Principales:**

**FR-RPT-01-01: Validar Formato de Parametros**
- Input: Trimestre, Ano, Segmento
- Output: Parametros validados o mensaje error
- Tipo: Validacion

**FR-RPT-01-04: Calcular Count de Registros**
- Input: Parametros validados
- Output: Numero de registros que retornaria query
- Tipo: Query SQL

**FR-RPT-01-06: Ejecutar Query Principal de Reporte**
- Input: Parametros validados, count aprobado
- Output: Dataset con metricas diarias
- Tipo: Query SQL compleja

**FR-RPT-01-07: Calcular Metricas Derivadas**
- Input: Dataset de query principal
- Output: Tasa abandono, promedios, totales
- Tipo: Calculo

**FR-RPT-01-08: Generar Graficos Visuales**
- Input: Dataset con metricas
- Output: Objetos grafico (lineas, barras, KPIs)
- Tipo: Visualizacion

**FR-RPT-01-10: Registrar Consulta en Audit Log**
- Input: user_id, parametros, count, timestamp
- Output: Registro en tabla report_audit_log
- Tipo: INSERT

----------------------------------------------------------------------
TRAZABILIDAD
----------------------------------------------------------------------

**Backward Traceability (de donde viene este UC):**

Este UC deriva de:

- BReq: BRQ-XXX - Nombre del Business Requirement
- BR: BR-IACT-YYY - Nombre de la Business Rule
- Stakeholder: Nombre del stakeholder que solicito

**Forward Traceability (hacia donde deriva este UC):**

Este UC genera:

- FR-XXX-NN-01 hasta FR-XXX-NN-ZZ: Lista de FR
- Codigo: Modulos, archivos, funciones implementadas
- Tests: Test cases automatizados

**Horizontal Traceability (relacion con otros UC):**

UC Relacionados:

- UC-IACT-AAA-BB: Relacion, ejemplo: "Utiliza datos de"
- UC-IACT-CCC-DD: Relacion, ejemplo: "Puede invocar a"

**EJEMPLO COMPLETO (UC-RPT-01):**

**Backward:**

- BReq: BRQ-015 - Optimizar Performance de Reportes
- BR: BR-IACT-028 - Aprobacion Consultas Grandes
- Stakeholder: Maria Rodriguez, Gerente de Operaciones

**Forward:**

FR Derivados:
- FR-RPT-01-01: Validar Formato Parametros
- FR-RPT-01-04: Calcular Count Registros
- FR-RPT-01-06: Ejecutar Query Principal
- FR-RPT-01-07: Calcular Metricas Derivadas
- FR-RPT-01-08: Generar Graficos
- FR-RPT-01-10: Registrar Audit Log

Codigo:
- reports_1_0_0/views.py::QuarterlyReportView
- reports_1_0_0/services.py::ReportService
- reports_1_0_0/queries.py::build_quarterly_query

Tests:
- tests/test_reports.py::test_quarterly_report_flow
- tests/test_approvals.py::test_large_query_approval

**Horizontal:**

- UC-RPT-02: Ejecutar Reporte Aprobado
  Relacion: Se invoca cuando supervisor aprueba en FA-2

- UC-RPT-03: Exportar Reporte a Excel
  Relacion: Usuario puede exportar reporte generado

- UC-AUTH-07: Notificar Sesion Proxima a Expirar
  Relacion: Puede interrumpir si sesion expira durante consulta

----------------------------------------------------------------------
SECCION 12: HISTORIAL DE VERSIONES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Version
     - Fecha
     - Cambios
     - Autor
   * - 4.0.0
     - YYYY-MM-DD
     - Version inicial - Creacion de UC
     - Nombre del BA
   * - 4.1.0
     - YYYY-MM-DD
     - Agrega nuevo FA-3 para manejo de cache
     - Nombre del BA
   * - 5.0.0
     - YYYY-MM-DD
     - Cambio MAJOR: Rediseno completo de flujo
     - Nombre del BA

**Versionado Semantico para UC:**

- MAJOR X.0.0: Cambios incompatibles en flujo, nuevos actores, objetivos diferentes
- MINOR X.Y.0: Nuevos FA/FE, nuevos pasos opcionales, compatible con version anterior
- PATCH X.Y.Z: Clarificaciones, correcciones de documentacion, sin cambio funcional

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares del Proyecto:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md
  - Seccion 2: 11 Componentes de UC
  - Seccion 3: Flujos Alternos vs Excepciones
  - Seccion 4: Derivacion UC → FR
  - Seccion 5: Trazabilidad

**Fuentes Externas:**

- Alistair Cockburn, "Writing Effective Use Cases" (2001)
- Craig Larman, "Applying UML and Patterns" (2004)
- Ivar Jacobson, "Object-Oriented Software Engineering" (1992)

**Documentos Relacionados:**

- BRQ_015_Optimizar_Performance_1_0_0.rst
- BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
- FR_RPT_01_XX_Nombre_1_0_0.rst

----------------------------------------------------------------------

.. note::
   CHECKLIST DE CALIDAD - 26 PUNTOS:
   
   Antes de marcar este UC como APPROVED, verificar:
   
   Componente 1: Actor Principal
   - Actor claramente identificado
   - Objetivo explicito del actor
   
   Componente 2: Actores Secundarios
   - Todos los actores secundarios listados
   - Rol de cada actor especificado
   
   Componente 3: Precondiciones
   - Minimo 2 precondiciones
   - Todas verificables
   
   Componente 4: Trigger
   - Trigger especifico, no generico
   
   Componente 5: Flujo Normal
   - Pasos atomicos, uno por linea
   - Maximo 15 pasos
   - Alterna actor-sistema
   - FR derivados anotados
   
   Componente 6: Flujos Alternos
   - Minimo 1 FA documentado
   - Diferenciados de FE
   - Resolucion clara (vuelve a paso X | termina)
   
   Componente 7: Flujos Excepcion
   - Minimo 1 FE documentado
   - Manejo de error completo
   - Logging y notificaciones
   
   Componente 8: Postcondiciones
   - Exito y Falla documentados
   - Verificables
   
   Componente 9: RNF
   - Performance definido
   - Seguridad definida
   - Metricas especificadas
   
   Componente 10: BR
   - BR implementadas listadas
   - Donde y como implementadas
   
   Componente 11: FR
   - Tabla derivacion completa
   - Cada paso del flujo mapeado
   
   Documentacion General
   - Metadata correcta al inicio
   - Version semantica aplicada
   - Referencias actualizadas
   - Trazabilidad backward/forward completa
   - Ejemplo consistente en todo el template

----------------------------------------------------------------------

**Archivo:** TPL_UC_Construccion_7_Pasos_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 900

