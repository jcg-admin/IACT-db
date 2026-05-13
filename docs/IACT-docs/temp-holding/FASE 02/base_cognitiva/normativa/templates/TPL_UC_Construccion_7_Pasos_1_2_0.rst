.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre Descriptivo del Caso de Uso]
   :Version: 4.0.0
   :Modulo: [RPT|AUTH|ACC|PIPE|DASH|ADMIN|API|NOTIF]
   :Implementa_BR: BR-IACT-XXX, BR-IACT-YYY
   :Complejidad: [Baja|Media|Alta]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre del Business Analyst]
   :Estado: [DRAFT|REVIEW|APPROVED|IMPLEMENTED]

======================================================================
UC-IACT-XXX-YY: [Nombre Descriptivo del Caso de Uso]
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Modulo:** [RPT|AUTH|ACC|PIPE|DASH|ADMIN|API|NOTIF]  
**Estado:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]  
**Prioridad:** [Alta|Media|Baja]  
**Complejidad:** [Baja|Media|Alta]

----------------------------------------------------------------------
INTRODUCCION: ESTRUCTURA DE 11 PASOS
----------------------------------------------------------------------

Este template implementa la estructura canónica para documentación de
Use Cases siguiendo las mejores prácticas de:

- **Alistair Cockburn:** "Writing Effective Use Cases"
- **Craig Larman:** "Applying UML and Patterns"
- **Ivar Jacobson:** "Object-Oriented Software Engineering"

**Los 11 Componentes Estándar:**

1. **Actor Principal** - Quién inicia el UC
2. **Actor(es) Secundario(s)** - Quién participa sin iniciar
3. **Precondiciones** - Estado previo requerido
4. **Trigger (Disparador)** - Evento que inicia
5. **Flujo Normal** - Camino feliz (happy path)
6. **Flujos Alternos** - Variaciones esperadas
7. **Flujos de Excepción** - Errores inesperados
8. **Postcondiciones** - Estado resultante
9. **Requisitos No Funcionales** - Atributos de calidad
10. **Reglas de Negocio Asociadas** - BR implementadas
11. **Derivación a Functional Requirements** - FR generados

**Características de un UC bien escrito:**

✅ Completo (11 pasos documentados)  
✅ Consistente (terminología uniforme)  
✅ Correcto (sin errores lógicos)  
✅ Verificable (puede testearse)  
✅ Modificable (fácil de actualizar)  
✅ Trazable (derivación clara a FR)

----------------------------------------------------------------------
1. ACTOR PRINCIPAL
----------------------------------------------------------------------

**Definición:**

El actor principal es quien INICIA el caso de uso y tiene el OBJETIVO
que este UC busca satisfacer.

**Actor Principal:** [Nombre del actor]

**Tipo de Actor:**

- [ ] Usuario Interno (empleado de la organización)
- [ ] Usuario Externo (cliente, proveedor, partner)
- [ ] Sistema Externo (API, servicio, aplicación)
- [ ] Sistema (Scheduler/Cron Job) - para UC temporales

**Rol Específico:**

[Rol concreto: Analista de Operaciones, Supervisor de Área, Administrador
del Sistema, Cliente Corporativo, etc.]

**Objetivo del Actor:**

[Qué busca lograr el actor al ejecutar este UC]

**Formato:** "Quiero [acción] para [beneficio]"

**Ejemplo:**

- **Actor:** Analista de Operaciones
- **Tipo:** Usuario Interno
- **Rol:** Analista de métricas de IVR del área de Call Center
- **Objetivo:** "Quiero consultar reportes trimestrales de métricas IVR
  para analizar tendencias y generar presentaciones ejecutivas"

----------------------------------------------------------------------
2. ACTORES SECUNDARIOS
----------------------------------------------------------------------

**Definición:**

Actores secundarios PARTICIPAN en el UC pero NO lo inician. Pueden ser
otros usuarios, sistemas externos, o servicios que proveen información
o reciben notificaciones.

**Actor Secundario 1:** [Nombre]

- **Tipo:** [Usuario|Sistema Externo|Servicio]
- **Rol:** [Descripción del rol]
- **Participación:** [Qué hace: provee datos, recibe notificación,
  valida, aprueba, etc.]

**Actor Secundario 2:** [Nombre]

- **Tipo:** [...]
- **Rol:** [...]
- **Participación:** [...]

**Ejemplo:**

1. **Sistema de Analytics**
   - Tipo: Sistema Externo
   - Rol: Motor SQL de procesamiento de consultas
   - Participación: Ejecuta queries y retorna resultados

2. **Supervisor de Área**
   - Tipo: Usuario Interno
   - Rol: Supervisor que aprueba consultas grandes
   - Participación: Recibe notificación y aprueba/rechaza solicitudes

----------------------------------------------------------------------
3. PRECONDICIONES
----------------------------------------------------------------------

**Definición:**

Condiciones que DEBEN cumplirse ANTES de que el UC pueda iniciar.
Si alguna precondición falla, el UC no puede ejecutarse.

**Formato:** PC-N: [Descripción de la condición]

**Tipos de Precondiciones:**

- **Estado del Sistema:** Sistema en cierto estado
- **Autenticación:** Usuario autenticado
- **Autorización:** Usuario con permisos específicos
- **Datos:** Datos previos existentes
- **Tiempo:** Horario o fecha específica
- **Negocio:** Reglas de negocio cumplidas

**PRECONDICIONES:**

PC-1: [Primera precondición obligatoria]

**Verificación:** [Cómo se verifica]  
**BR Origen:** [BR-IACT-XXX si deriva de BR]

PC-2: [Segunda precondición]

**Verificación:** [...]

PC-3: [Tercera precondición]

**Verificación:** [...]

**Ejemplo:**

PC-1: Usuario autenticado en el sistema

- Verificación: Existe sesión activa con session_id válido
- BR Origen: -

PC-2: Usuario tiene permiso RPT-001 asignado

- Verificación: SELECT 1 FROM user_permissions WHERE user_id=X AND perm='RPT-001'
- BR Origen: BR-IACT-087

PC-3: Usuario pertenece a segmento OP o MG

- Verificación: users.segment IN ('OP', 'MG')
- BR Origen: BR-IACT-012

----------------------------------------------------------------------
4. TRIGGER (Disparador)
----------------------------------------------------------------------

**Definición:**

Evento concreto que INICIA el caso de uso. Es la acción específica
que realiza el Actor Principal para comenzar el flujo.

**Trigger:** [Descripción del evento disparador]

**Tipo de Trigger:**

- [ ] Acción de Usuario en UI (click, submit, selección)
- [ ] Request HTTP (POST, GET, PUT, DELETE)
- [ ] Evento Temporal (cron job, scheduler, timeout)
- [ ] Evento de Sistema (mensaje cola, webhook, callback)
- [ ] Evento de Negocio (cambio estado, umbral alcanzado)

**Detalles Específicos:**

[Qué botón, qué URL, qué horario, etc.]

**Ejemplos:**

Tipo: Acción de Usuario

- Trigger: Usuario hace click en menú "Reportes > Trimestral Consolidado"
- Detalles: Link en menú superior, href='/reports/quarterly'

Tipo: Request HTTP

- Trigger: POST /api/v1/reports/generate
- Detalles: Headers: Authorization: Bearer {token}

Tipo: Evento Temporal

- Trigger: Cron ejecuta cada día a 02:00 AM
- Detalles: Cron: 0 2 * * *, comando: python manage.py run_process

----------------------------------------------------------------------
5. FLUJO NORMAL (Curso Básico de Eventos)
----------------------------------------------------------------------

**Definición:**

Secuencia de pasos que describe el CAMINO FELIZ (happy path), cuando
todo funciona sin errores.

**Reglas para el Flujo Normal:**

✓ Cada paso es ACCIÓN ATOMICA (no divisible)  
✓ Numerar secuencialmente (1, 2, 3, ...)  
✓ Alternar Sistema ↔ Actor cuando posible  
✓ Indicar FR: (FR-XXX-YY-ZZ)  
✓ Indicar BR: [BR-IACT-XXX]  
✓ Verbos activos en presente  
✓ Máximo 15 pasos  
✓ Último paso: "Caso de uso termina exitosamente"

**Patrón Típico:**

- Pasos 1-3: Usuario ingresa datos
- Pasos 4-7: Sistema valida y procesa
- Pasos 8-12: Sistema calcula y prepara resultado
- Paso 13-14: Sistema muestra resultado
- Paso 15: Termina exitosamente

**FLUJO NORMAL:**

1. [Sistema muestra / Actor realiza acción inicial]

2. [Actor ingresa / selecciona información]

3. [Actor confirma / hace click]

4. Sistema valida datos de entrada (FR-XXX-YY-01) [BR-IACT-ZZZ]

5. Sistema procesa / calcula (FR-XXX-YY-02)

6. Sistema consulta base de datos (FR-XXX-YY-03)

7. Sistema evalúa condición [BR-IACT-WWW]

8. Sistema ejecuta operación principal (FR-XXX-YY-04)

9. Sistema genera resultado (FR-XXX-YY-05)

10. Sistema registra en auditoría (FR-XXX-YY-06)

11. Sistema muestra resultado al Actor

12. Caso de uso termina exitosamente

**Ejemplo Completo (UC-IACT-RPT-01):**

1. Sistema muestra formulario de generación de reportes
   - Campos: Trimestre (dropdown), Año (dropdown), Segmento

2. Usuario selecciona parámetros:
   - Trimestre: Q3, Año: 2024, Segmento: OP

3. Usuario hace click en "Generar Reporte"

4. Sistema valida parámetros (FR-RPT-01-01)
   - Trimestre en rango válido, Año 2020-2025

5. Sistema construye query SQL (FR-RPT-01-02)

6. Sistema calcula count de registros (FR-RPT-01-07) [BR-IACT-028]
   - SELECT COUNT(*) → 10,500 registros

7. Sistema evalúa si count > 10,000 [BR-IACT-028]

8. Sistema ejecuta query principal (FR-RPT-01-08)

9. Sistema calcula métricas (FR-RPT-01-09)
   - Tasa abandono = (abandonadas / total) * 100

10. Sistema registra consulta (FR-RPT-01-11)

11. Sistema muestra tabla de resultados con gráficos

12. Caso de uso termina exitosamente

----------------------------------------------------------------------
6. FLUJOS ALTERNOS (FA)
----------------------------------------------------------------------

**Definición:**

Caminos alternativos para condiciones ESPERADAS que difieren del flujo
normal. NO son errores, son variaciones normales.

**Diferencia FA vs FE:**

- **FA:** Situación ESPERADA (validación falla, sin datos, cancelar)
- **FE:** Error INESPERADO (timeout, excepción, servicio caído)

**Formato:**

.. code-block:: text

   FA-N: [Nombre Descriptivo]
   
   En paso X, si [condición]:
     
     Xa. [Acción alternativa 1]
     Xb. [Acción alternativa 2]
     Xc. [Resolución: vuelve a paso Y | termina]

**Tipos Comunes:**

- Validación: Datos no cumplen reglas
- Datos Vacíos: No se encuentran resultados
- Cancelación: Usuario cancela operación
- Permiso: Usuario no autorizado
- Negocio: BR requiere flujo diferente

**FLUJOS ALTERNOS:**

FA-1: [Nombre del Flujo Alterno]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso X, si [condición específica]:

  Xa. [Acción]
  
  Xb. [Acción]
  
  Xc. [Resolución]

**Derivación FR:** [FR-XXX-YY-ZZ si genera FR nuevo]

**Ejemplo:**

FA-1: Validación de Parámetros Falla
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso 4, si validación falla:

  4a. Sistema identifica campos con errores
  
  4b. Sistema muestra mensajes específicos:
      - "Trimestre es obligatorio"
      - "Año debe estar entre 2020 y 2025"
  
  4c. Sistema mantiene valores ingresados
  
  4d. Vuelve a paso 3 (usuario corrige)

Derivación: FR-RPT-01-01

FA-2: Consulta Requiere Aprobación [BR-IACT-028]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso 7, si count > 10,000:

  7a. Sistema crea registro en tabla approvals (FR-RPT-01-10)
  
  7b. Sistema identifica supervisor
  
  7c. Sistema notifica supervisor
  
  7d. Sistema muestra modal: "Requiere aprobación (10,500 regs)"
  
  7e. Usuario hace click "OK"
  
  7f. Caso de uso termina

Derivación: FR-RPT-01-10

----------------------------------------------------------------------
7. FLUJOS DE EXCEPCION (FE)
----------------------------------------------------------------------

**Definición:**

Errores INESPERADOS del sistema que impiden completar el UC.

**Formato:**

.. code-block:: text

   FE-N: [Nombre de la Excepción]
   
   En paso X (o "cualquier paso"), si [error]:
     
     Xa. Sistema registra error en log
     Xb. Sistema muestra mensaje al usuario
     Xc. Sistema envía alerta a equipo
     Xd. Caso de uso termina sin éxito

**Tipos Comunes:**

- Timeout: Operación excede tiempo
- BD Error: Error al ejecutar query
- Servicio Externo: API no responde
- Sistema: Excepción no controlada

**FLUJOS DE EXCEPCION:**

FE-1: [Nombre]
^^^^^^^^^^^^^^

En paso X, si [error crítico]:

  Xa. Sistema registra error
  
  Xb. Sistema muestra mensaje
  
  Xc. Sistema envía alerta
  
  Xd. Termina sin éxito

**Ejemplo:**

FE-1: Timeout de Base de Datos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso 6 o 8, si query excede 5 segundos:

  6a. Sistema cancela query
  
  6b. Sistema registra: logger.error("Query timeout")
  
  6c. Sistema muestra: "La consulta tardó demasiado.
      Intente con rango menor. Ref: ERR-TIMEOUT-001"
  
  6d. Sistema envía alerta Slack a #tech-alerts
  
  6e. Caso de uso termina sin éxito

----------------------------------------------------------------------
8. POSTCONDICIONES
----------------------------------------------------------------------

**Postcondiciones de Éxito:**

PC-E1: [Estado si UC termina exitosamente]

**Verificación:** [Cómo verificar]

PC-E2: [Otro estado de éxito]

**Postcondiciones de Fallo:**

PC-F1: [Estado si UC falla]

**Invariantes:**

INV-1: [Condiciones que SIEMPRE deben cumplirse]

**Ejemplo:**

Éxito:

- PC-E1: Reporte generado y visible
- PC-E2: Consulta en audit_log con status='SUCCESS'

Fallo:

- PC-F1: Consulta en audit_log con status='FAILED'
- PC-F2: Recursos liberados (conexiones, memoria)

Invariante:

- INV-1: Integridad de datos no comprometida

----------------------------------------------------------------------
9. REQUISITOS NO FUNCIONALES (RNF)
----------------------------------------------------------------------

RNF-1: Performance
^^^^^^^^^^^^^^^^^^

**Tiempo de Respuesta:**

- Operación normal: < [X] segundos (p95)
- Operación compleja: < [Y] segundos (p95)

**Ejemplo:**
- Consultas < 1,000 registros: < 1 seg (p95)
- Consultas 1,000-10,000: < 3 seg (p95)

RNF-2: Usabilidad
^^^^^^^^^^^^^^^^^

- Facilidad de uso: [Criterio]
- Accesibilidad: WCAG 2.1 nivel AA
- Internacionalización: [Idiomas]

RNF-3: Seguridad
^^^^^^^^^^^^^^^^

- Autenticación: [Método]
- Autorización: [RBAC, permisos]
- Encriptación: HTTPS/TLS 1.3
- Auditoría: Todos logs inmutables

RNF-4: Disponibilidad
^^^^^^^^^^^^^^^^^^^^^

- Uptime: [X]% (ej: 99.9%)
- Ventana mantenimiento: [Horario]

----------------------------------------------------------------------
10. REGLAS DE NEGOCIO ASOCIADAS
----------------------------------------------------------------------

**BR Implementadas:**

BR-IACT-XXX: [Nombre]
^^^^^^^^^^^^^^^^^^^^^

**Tipo:** [Restricción|Cálculo|Desencadenador|Inferencia]

**Donde:** [Precondición | Paso N | FA-N]

**Cómo:** [Descripción de implementación]

**Ejemplo:**

BR-IACT-028: Aprobación de Consultas Grandes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tipo: Restricción

Donde:
- Precondición PC-2 (permiso)
- Paso 6 (calcular count)
- Paso 7 (evaluar umbral)
- FA-2 (flujo completo de aprobación)

Cómo:
1. Paso 6: ejecuta COUNT(*)
2. Paso 7: compara con 10,000
3. Si > 10,000: activa FA-2

----------------------------------------------------------------------
11. DERIVACION A FUNCTIONAL REQUIREMENTS
----------------------------------------------------------------------

**Regla:** Cada paso con lógica de sistema → 1 FR

**FR Derivados:**

Paso 4 → FR-XXX-YY-01: [Nombre]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Descripción:** [Qué hace]  
**Tipo:** [Query|Validación|Cálculo|UI|Integración]  
**Archivo:** FR_XXX_YY_01_[Nombre]_1_0_0.rst

Paso 5 → FR-XXX-YY-02: [Nombre]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[...]

FA-2 → FR-XXX-YY-10: [Nombre]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[...]

**Total FR Derivados:** [N FR]

**Ejemplo:**

Paso 4 → FR-RPT-01-01: Validar Parámetros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Descripción: Valida trimestre, año, segmento
- Tipo: Validación
- Archivo: FR_RPT_01_01_Validar_Parametros_1_0_0.rst

Paso 6 → FR-RPT-01-07: Calcular Count
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Descripción: SELECT COUNT(*) con parámetros
- Tipo: Query
- Implementa: BR-IACT-028

Total: 7 FR

----------------------------------------------------------------------
TRAZABILIDAD
----------------------------------------------------------------------

**Backward (UC ← BR):**

- BR-IACT-028
- BR-IACT-053

**Forward (UC → FR):**

- FR-RPT-01-01 a FR-RPT-01-11 (7 FR)

**Horizontal (UC ↔ UC):**

- UC-RPT-09 (continuación de FA-2)

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
- PARTE_3B_Tecnica_Larman_IACT_1_0_0.md

**Bibliografía:**

- Cockburn. "Writing Effective Use Cases"
- Larman. "Applying UML and Patterns"

----------------------------------------------------------------------
CHECKLIST DE CALIDAD (26 PUNTOS)
----------------------------------------------------------------------

Estructura Básica:
- [ ] Los 11 pasos completos
- [ ] Actor principal identificado
- [ ] Actores secundarios documentados
- [ ] Precondiciones incluyen BR
- [ ] Trigger específico

Flujo Normal:
- [ ] Entre 5 y 15 pasos
- [ ] Cada paso atómico
- [ ] FR derivados indicados (FR-XXX-YY-ZZ)
- [ ] BR implementadas [BR-IACT-XXX]
- [ ] Último paso: termina exitosamente

Flujos Alt y Exc:
- [ ] FA bien formados (En paso X, si...)
- [ ] Diferencia clara FA vs FE
- [ ] FA terminan con resolución
- [ ] FE incluyen logging

Postcondiciones y RNF:
- [ ] Postcondiciones de éxito/fallo
- [ ] RNF especificados
- [ ] Performance cuantificado

Trazabilidad:
- [ ] Backward (BR → UC) completa
- [ ] Forward (UC → FR) completa
- [ ] Cada paso deriva ≥1 FR

Documentación:
- [ ] Metadata correcta
- [ ] Versión NOM_001
- [ ] Referencias actualizadas
- [ ] Historial de versiones

----------------------------------------------------------------------

**Archivo:** TPL_UC_Construccion_7_Pasos_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha:** 2026-01-09  
**Líneas:** ~700

