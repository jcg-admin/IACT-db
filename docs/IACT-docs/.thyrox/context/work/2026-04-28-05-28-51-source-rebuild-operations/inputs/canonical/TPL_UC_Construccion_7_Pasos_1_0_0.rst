.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre del Caso de Uso]
   :Version: 4.0.0
   :Modulo: [RPT|AUTH|ACC|PIPE|DASH|ADMIN|API|NOTIF]
   :Implementa_BR: BR-IACT-XXX, BR-IACT-YYY
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre del BA]

======================================================================
UC-IACT-XXX-YY: [Nombre Descriptivo del Caso de Uso]
======================================================================

**Módulo:** [RPT|AUTH|ACC|PIPE|DASH|ADMIN|API|NOTIF]  
**Estado:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]  
**Prioridad:** [Alta|Media|Baja]  
**Complejidad:** [Baja|Media|Alta]

----------------------------------------------------------------------
ESTRUCTURA ESTÁNDAR (11 PASOS)
----------------------------------------------------------------------

1. Actor Principal
~~~~~~~~~~~~~~~~~~

[Nombre del actor que inicia el caso de uso]

**Ejemplos:**
- Analista de Operaciones
- Supervisor de Área
- Administrador del Sistema
- Sistema (Scheduler) [para UC temporales]

2. Actor(es) Secundario(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

[Actores que participan pero no inician]

**Ejemplos:**
- Sistema de Analytics (recibe datos)
- Sistema de Notificaciones (envía emails)
- Base de Datos (almacena)

3. Precondiciones
~~~~~~~~~~~~~~~~~

PC-1: [Condición que debe cumplirse ANTES de iniciar]

PC-2: [Otra precondición]

PC-3: [...]

**Ejemplos:**
PC-1: Usuario autenticado en el sistema
PC-2: Usuario tiene permiso RPT-001 asignado
PC-3: Usuario pertenece a segmento OP o MG

**Nota:** Las precondiciones derivadas de BR deben indicarlo:

``PC-2: Usuario tiene nivel_seguridad >= 3 [BR-IACT-087]``

4. Trigger (Disparador)
~~~~~~~~~~~~~~~~~~~~~~~

[Evento que inicia el caso de uso]

**Ejemplos:**
- Usuario hace click en "Reportes > Trimestral Consolidado"
- Sistema detecta sesión inactiva por 12 minutos
- Cron job ejecuta cada día a las 02:00 AM
- API recibe POST request a /api/v1/reports

5. Flujo Normal (Curso Básico de Eventos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. [Sistema/Actor realiza acción]
2. [Sistema/Actor realiza acción]
3. [Sistema valida/procesa]
4. [Sistema/Actor realiza acción con referencia a FR]

   **Ejemplo paso 4:**
   ``4. Sistema calcula count de registros (FR-RPT-01-07) [BR-IACT-028]``

5. [Sistema/Actor realiza acción]
6. [...]
...
N. Caso de uso termina exitosamente

**Reglas para el flujo normal:**

- Cada paso es una acción atómica
- Indicar FR cuando corresponda: ``(FR-XXX-YY-ZZ)``
- Indicar BR cuando corresponda: ``[BR-IACT-XXX]``
- Usar verbos activos
- Máximo 15 pasos (si son más, dividir UC)

**Estándar de pasos comunes:**

- Paso 1: Siempre es mostrar/recibir input
- Paso 2-N/2: Usuario ingresa datos, sistema valida
- Paso N/2+1 a N-2: Sistema procesa, calcula
- Paso N-1: Sistema muestra resultado/confirma
- Paso N: "Caso de uso termina exitosamente"

6. Flujos Alternos
~~~~~~~~~~~~~~~~~~

FA-1: [Nombre del Flujo Alterno]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso X, si [condición]:

  Xa. [Acción alternativa]
  Xb. [Otra acción]
  Xc. [Resultado: vuelve a paso Y, termina con éxito, o termina sin éxito]

**Ejemplo completo:**

FA-2: Consulta Requiere Aprobación [BR-IACT-028]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso 6, si count > 10,000:

  6a. Sistema crea registro en tabla approvals (FR-RPT-01-10)
  6b. Sistema identifica supervisor del usuario
  6c. Sistema crea notificación para supervisor
  6d. Sistema muestra modal: "Su consulta requiere aprobación. Le notificaremos."
  6e. Usuario hace click en "OK"
  6f. Sistema redirige a página principal
  6g. Caso de uso termina (continúa en UC-IACT-RPT-09)

FA-3: [Otro Flujo Alterno]
^^^^^^^^^^^^^^^^^^^^^^^^^^^

[...]

**Tipos comunes de FA:**

- FA-X: Validación falla
- FA-X: Sin datos encontrados
- FA-X: Timeout o error de BD
- FA-X: Usuario cancela operación
- FA-X: Permiso denegado

7. Flujos de Excepción
~~~~~~~~~~~~~~~~~~~~~~~

FE-1: [Nombre del Flujo de Excepción]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso X, si [error crítico]:

  Xa. Sistema registra error en log con nivel ERROR
  Xb. Sistema muestra mensaje: "Error interno. Contacte soporte. Ref: ERR-XXX"
  Xc. Sistema envía alerta a equipo técnico
  Xd. Caso de uso termina sin éxito

**Diferencia FA vs FE:**

- **FA:** Situación esperada (validación, datos vacíos, cancelación)
- **FE:** Error inesperado del sistema (timeout BD, excepción, servicio caído)

8. Postcondiciones
~~~~~~~~~~~~~~~~~~

**Postcondición de Éxito:**

PC-1: [Estado del sistema tras ejecución exitosa]

PC-2: [Otro estado]

**Ejemplo:**
PC-1: Reporte generado y mostrado al usuario
PC-2: Consulta registrada en audit_log con resultado SUCCESS

**Postcondición de Fallo:**

PC-F1: [Estado si UC termina sin éxito]

**Ejemplo:**
PC-F1: Consulta registrada en audit_log con resultado FAILED

9. Requisitos No Funcionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

RNF-1: Performance
^^^^^^^^^^^^^^^^^^

- Tiempo máximo de respuesta: [X segundos]
- Throughput mínimo: [Y transacciones/segundo]

RNF-2: Usabilidad
^^^^^^^^^^^^^^^^^

- Interfaz debe cumplir WCAG 2.1 nivel AA
- Formulario debe auto-guardarse cada 30 segundos

RNF-3: Seguridad
^^^^^^^^^^^^^^^^

- Datos sensibles deben encriptarse en tránsito (TLS 1.3)
- Logs deben enmascarar PII

RNF-4: Disponibilidad
^^^^^^^^^^^^^^^^^^^^^

- Sistema debe estar disponible 99.9% del tiempo
- Mantenimiento programado solo fines de semana

10. Reglas de Negocio Asociadas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BR Implementadas en este UC:**

- BR-IACT-028: [Nombre] → [Paso 5-6 + FA-2]
- BR-IACT-053: [Nombre] → [Paso 8]

**Patrón de Implementación:**

.. list-table::
   :header-rows: 1
   :widths: 20 20 60

   * - BR
     - Tipo
     - Dónde se Implementa
   * - BR-IACT-028
     - Restricción
     - Precondición PC-2 + FA-2
   * - BR-IACT-053
     - Cálculo
     - Paso 8 (sin UC propio)
   * - BR-IACT-031
     - Desencadenador
     - UC completo generado

11. Derivación a Functional Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**FR Derivados de este UC:**

Paso 4 → FR-XXX-YY-01: [Nombre]

Paso 5 → FR-XXX-YY-02: [Nombre]

Paso 6 → FR-XXX-YY-03: [Nombre]

FA-2 → FR-XXX-YY-04: [Nombre]

**Total FR:** [N FR derivados]

----------------------------------------------------------------------
TRAZABILIDAD
----------------------------------------------------------------------

Backward (UC ← BR)
~~~~~~~~~~~~~~~~~~

Este UC implementa:

- BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
- BR_IACT_053_Calculo_Promedio_1_0_0.rst

Forward (UC → FR)
~~~~~~~~~~~~~~~~~

Este UC deriva:

- FR_RPT_01_07_Calcular_Count_1_0_0.rst
- FR_RPT_01_08_Ejecutar_Query_1_0_0.rst
- FR_RPT_01_09_Calcular_Metricas_1_0_0.rst

----------------------------------------------------------------------
DIAGRAMA DE ACTIVIDAD (Opcional)
----------------------------------------------------------------------

.. code-block:: text

   [Usuario]                [Sistema]              [BD]
       |                        |                    |
       |--Click "Generar"------>|                    |
       |                        |--Query Count------>|
       |                        |<---10,500 rows-----|
       |                        |                    |
       |<--"Requiere Aprobación"|                    |
       |                        |                    |

----------------------------------------------------------------------
NOTAS DE IMPLEMENTACIÓN
----------------------------------------------------------------------

**Consideraciones técnicas:**

- [Nota técnica importante]
- [Otra consideración]

**Dependencias:**

- Servicio externo: [Nombre y versión]
- Librería: [Nombre y versión]

**Decisiones de diseño:**

- [Por qué se eligió cierta implementación]

----------------------------------------------------------------------
HISTORIAL DE VERSIONES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 4.0.0
     - YYYY-MM-DD
     - Versión actualizada con nomenclatura v2.0
     - [Nombre]
   * - 3.0.0
     - YYYY-MM-DD
     - [Cambio mayor]
     - [Nombre]

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_2B_Construccion_Detallada_IACT_1_0_0.md (Construcción de UC)
- PARTE_3B_Tecnica_Larman_IACT_1_0_0.md (Técnica de Larman)

**Documentos Relacionados:**

- BR_IACT_XXX_[Nombre]_1_0_0.rst
- FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst

----------------------------------------------------------------------

.. note::
   **CHECKLIST DE CALIDAD:**
   
   - [ ] Los 11 pasos están completos
   - [ ] Precondiciones incluyen BR donde aplica
   - [ ] Flujo normal tiene 5-15 pasos
   - [ ] Cada paso tiene FR cuando corresponde
   - [ ] FA están bien formados (paso X si condición)
   - [ ] Postcondiciones cubren éxito y fallo
   - [ ] Trazabilidad backward y forward completa
   - [ ] RNF especificados si aplican
   - [ ] Metadata correcta al inicio

**Archivo:** TPL_UC_Construccion_7_Pasos_1_0_0.rst  
**Versión:** 1.0.0  
**Última actualización:** 2026-01-09
