# PARTE 0: CONTEXTO Y FUNDAMENTOS
## Del Caos de Requisitos a un Sistema Ordenado

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Documento:** Material Pedagógico - Puente Metodológico  
**Versión:** 1.0.0  
**Fecha:** 2026-01-08  
**Autor:** Equipo IACT  
**Audiencia:** Desarrolladores, Analistas, Product Owners  
**Clasificación:** C2 - INTERNAL

---

## TABLA DE CONTENIDO

1. [El Problema](#1-el-problema)
2. [La Solución](#2-la-solucion)
3. [Transformaciones Clave](#3-transformaciones-clave)
4. [Alcance del Material](#4-alcance-del-material)
5. [Roadmap Detallado](#5-roadmap-detallado)
6. [Metodología de Estudio](#6-metodologia-estudio)
7. [Convenciones y Referencias](#7-convenciones-referencias)

---

## PREFACIO

### ¿Por qué existe este documento?

Este documento es un **puente pedagógico** entre la teoría de ingeniería de requisitos y la práctica específica del proyecto IACT. No es parte de la documentación técnica formal del sistema, sino un **material de apoyo** diseñado para:

1. **Contextualizar** la metodología completa antes de profundizar en cada parte
2. **Motivar** el uso de técnicas rigurosas de requisitos
3. **Ilustrar** conceptos abstractos con ejemplos concretos del dominio IACT
4. **Prevenir** errores comunes en proyectos de software

### Estructura del Material Completo

Este material pedagógico consta de **6 PARTES**:

```
PARTE 0: Contexto y Fundamentos (este documento)
  ↓ Establece el "por qué" y "para qué"
  
PARTE 1: Identificar Reglas de Negocio
  ↓ Técnicas de elicitación y clasificación de BR
  
PARTE 2: Transformar BR en UC
  ↓ Metodología de transformación sistemática
  
PARTE 3: Técnicas de Elicitación de UC
  ↓ CRUD, Larman, UI-Driven, Stakeholder-Driven
  
PARTE 4: Requisitos Funcionales
  ↓ Derivación de FR desde UC
  
PARTE 5: Trazabilidad y Gestión
  ↓ Matrices RTM, gestión de cambios
  
PARTE 6: Casos Prácticos Completos
  ↓ Ejercicios end-to-end del proyecto IACT
```

### Cómo usar este documento

- **Lectura secuencial:** Secciones 1-7 en orden
- **Tiempo estimado:** 2-3 horas primera lectura
- **Nivel:** Intermedio (requiere conocimientos básicos de ingeniería de software)
- **Prerequisitos:** Familiaridad con conceptos de UC, requisitos, testing

---

<a name="1-el-problema"></a>

## 1. EL PROBLEMA

### 1.1 El Síntoma: Proyectos que Fracasan

Imagina este escenario común en desarrollo de software:

```
MES 1 (Kickoff):
  PO: "Necesitamos un sistema de análisis de llamadas IVR"
  Dev Team: "¡Perfecto! Empezamos el sprint 1"
  
MES 3 (Primera demo):
  PO: "Esto no es lo que pedí. Falta validación de permisos"
  Dev Team: "No lo mencionaste en las historias de usuario"
  
MES 6 (Crisis):
  PO: "El sistema acepta consultas de 10 años. ¡Tarda 5 minutos!"
  Dev Team: "¿Cuál era el límite? No está documentado"
  
MES 9 (Disaster):
  QA: "El sistema envía emails automáticos. ¿Esto es correcto?"
  PO: "¡NO! Tenemos prohibido enviar emails externos"
  Dev Team: "¿Dónde dice eso? No hay ninguna especificación"
  
MES 12 (Fracaso):
  Proyecto cancelado. $500K perdidos. Equipo desmotivado.
```

**Pregunta clave:** ¿Qué salió mal?

### 1.2 La Causa Raíz: Requisitos Implícitos y Ambiguos

El problema NO es técnico. El código funciona. Los tests pasan. La arquitectura es sólida.

**El problema es de REQUISITOS:**

```
Requisitos Implícitos (no escritos):
  ✗ "Los usuarios deben tener nivel de seguridad ≥3 para funciones críticas"
  ✗ "Las consultas de reportes están limitadas a 2 años máximo"
  ✗ "El sistema NO puede enviar emails externos bajo ninguna circunstancia"
  ✗ "Las sesiones expiran después de 15 minutos de inactividad"
  ✗ "Solo se pueden asignar funciones RBAC, no roles tradicionales"

Requisitos Ambiguos (mal escritos):
  ✗ "El sistema debe ser rápido" → ¿Cuánto es "rápido"? ¿2 seg? ¿200ms?
  ✗ "Los usuarios pueden exportar datos" → ¿Todos? ¿En qué formatos? ¿Con límites?
  ✗ "Debe haber control de acceso" → ¿Roles? ¿Funciones? ¿Grupos? ¿SoD?

Requisitos Contradictorios:
  ✗ "Cualquier usuario puede ver reportes" vs "Solo supervisores ven datos sensibles"
  ✗ "Sistema en tiempo real" vs "BD IVR se actualiza cada 6 horas"
```

**Resultado:** Equipo construye lo que entiende, NO lo que el negocio necesita.

### 1.3 Las Consecuencias

Cuando los requisitos son implícitos o ambiguos:

**Costo Económico:**
- Retrabajo: 40-60% del esfuerzo de desarrollo
- Defectos en producción: 10x más caros de arreglar que en diseño
- Features no usadas: 45% del código nunca se usa (CHAOS Report 2020)

**Costo Humano:**
- Frustración del equipo: "¿Por qué cambian todo el tiempo?"
- Burnout de PO: Revisiones interminables
- Pérdida de confianza: Stakeholders dejan de creer en TI

**Costo de Oportunidad:**
- Time-to-market duplicado
- Ventaja competitiva perdida
- Clientes que se van a la competencia

### 1.4 Caso Ilustrativo: Sistema de Reportes IACT

**Contexto:**

El proyecto IACT necesita un módulo de reportes consolidados de llamadas IVR. Los analistas de negocio deben poder:
- Consultar métricas trimestrales
- Filtrar por fecha y centro de contacto
- Exportar datos a CSV/Excel/PDF

**Historia de Usuario Original (deficiente):**

```
Como Analista de Negocio
Quiero consultar reportes de llamadas
Para analizar el desempeño del IVR
```

**¿Qué falta?**

Esta historia parece clara, pero esconde DOCENAS de decisiones no tomadas:

1. **Permisos:** ¿Quién puede consultar? ¿Todos los analistas? ¿Solo los de cierto nivel?
2. **Límites:** ¿Cuántos registros? ¿Qué rango de fechas? ¿Hay throttling?
3. **Formato:** ¿Qué campos incluye el reporte? ¿Son configurables?
4. **Performance:** ¿Qué pasa si la consulta toma >30 segundos?
5. **Exportación:** ¿Cuántas veces al día? ¿Con qué límites?
6. **Notificaciones:** ¿Se notifica al usuario cuando termina? ¿Cómo?

**La Regla de Negocio Oculta:**

Enterrado en un email del PO de hace 3 meses:

> "Ah, y solo aprueben consultas de más de 10,000 registros si el usuario es supervisor o superior. Es una política corporativa para evitar sobrecarga del servidor."

**Esta es BR-IACT-028:** Una **Restricción** que dice:

```
BR-IACT-028: Aprobación de Consultas Grandes
Tipo: Restricción
Enunciado: 
  "Las consultas de reportes que retornen más de 10,000 registros
   requieren aprobación del supervisor del área."
   
Observable: 
  Usuario ve modal: "Consulta requiere aprobación. Notificando supervisor..."
  
Impacto:
  - Precondición en UC-IACT-RPT-01 (Consultar Reporte)
  - Flujo alterno si count > 10,000
  - Notificación automática al supervisor
  - Estado "PENDIENTE_APROBACION" en tabla requests
```

**¿Qué pasa si esto no se documenta?**

```
Sprint 2: Desarrollan consulta de reportes SIN validación
Sprint 5: QA descubre que retorna 50,000 registros sin restricción
Sprint 6: PO dice "Esto está mal, necesita aprobación"
Sprint 7: Retrabajo completo del módulo
  - Agregar tabla approvals
  - Crear flujo de notificación
  - Modificar UI
  - Nuevos tests
  Costo: 40 horas de trabajo perdidas
```

**Si BR-IACT-028 se hubiera documentado desde el principio:**

```
Sprint 2: Diseñan UC-IACT-RPT-01 CON flujo de aprobación
Sprint 3: Implementan tabla approvals desde el inicio
Sprint 4: Tests incluyen caso >10,000 registros
Sprint 5: QA valida flujo completo
  Costo: 0 horas de retrabajo
```

**La lección:** Una BR bien documentada ahorra semanas de retrabajo.

---

<a name="2-la-solucion"></a>

## 2. LA SOLUCIÓN: JERARQUÍA DE 4 NIVELES

### 2.1 Visión General

La solución es un **sistema de requisitos estructurado en 4 niveles** que transforma reglas de negocio implícitas en código ejecutable y testeable.

```
┌─────────────────────────────────────────────────────────────┐
│                    JERARQUÍA DE 4 NIVELES                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  NIVEL 0: Business Rules (BR)                                │
│  ═══════════════════════════                                 │
│  "Reglas del negocio en lenguaje natural"                    │
│  Ejemplo: BR-IACT-028                                        │
│  "Consultas >10K registros requieren aprobación supervisor"  │
│                                                              │
│                      ↓ TRANSFORMA EN                          │
│                                                              │
│  NIVEL 1: Business Requirements (BReq)                       │
│  ═══════════════════════════════════                         │
│  "Objetivos del negocio medibles"                            │
│  Ejemplo: BRQ-RPT-001                                        │
│  "Sistema debe prevenir sobrecarga con consultas grandes"    │
│                                                              │
│                      ↓ SE CUMPLE CON                          │
│                                                              │
│  NIVEL 2: User Requirements / Use Cases (UC)                 │
│  ════════════════════════════════════════                    │
│  "Interacciones usuario-sistema observables"                 │
│  Ejemplo: UC-IACT-RPT-01                                     │
│  Paso 7: "Sistema valida count. Si >10K, solicita aprobación"│
│                                                              │
│                      ↓ DERIVA EN                              │
│                                                              │
│  NIVEL 3: Functional Requirements (FR)                       │
│  ══════════════════════════════════════                      │
│  "Especificaciones técnicas implementables"                  │
│  Ejemplo: FR-RPT-01-07                                       │
│  "Sistema debe calcular COUNT(*) antes de ejecutar query"    │
│                                                              │
│                      ↓ SE IMPLEMENTA EN                       │
│                                                              │
│  CÓDIGO + TESTS                                              │
│  ═══════════════                                             │
│  reports/views.py::generate_report()                         │
│  tests/test_reports.py::test_large_query_approval()          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Nivel 0: Business Rules (BR)

**Definición:** Políticas, restricciones y decisiones del negocio expresadas en lenguaje natural.

**Características:**
- Escritas en lenguaje de dominio (no técnico)
- Observable por stakeholders
- Validable sin código

**Ejemplo Real - BR-IACT-028:**

```yaml
ID: BR-IACT-028
Nombre: Aprobación de Consultas Grandes
Tipo: Restricción
Categoría: Operational

Enunciado:
  "Las consultas de reportes que retornen más de 10,000 registros
   deben ser aprobadas por el supervisor del área antes de ejecutarse."

Contexto:
  - Aplica a: MOD_Reports (todos los reportes consolidados)
  - Razón de negocio: Prevenir sobrecarga del servidor de Analytics
  - Política corporativa: IT-SEC-2024-015

Casos:
  CASO A: Consulta retorna 5,000 registros
    → Ejecuta inmediatamente (sin aprobación)
  
  CASO B: Consulta retorna 15,000 registros
    → Notifica supervisor
    → Estado PENDIENTE_APROBACION
    → Supervisor aprueba/rechaza
    → Ejecuta si aprobada

Observable:
  - Usuario ve modal: "Su consulta requiere aprobación..."
  - Supervisor recibe notificación en buzón interno
  - Usuario recibe respuesta cuando supervisor decide

Derivado de:
  - BRQ-RPT-001: "Prevenir sobrecarga servidor"
  
Genera:
  - UC-IACT-RPT-01 (flujo alterno "Requiere Aprobación")
  - UC-IACT-RPT-09 (Aprobar/Rechazar Consulta)
  
Relacionado con:
  - CNST-006: Rango máximo 2 años
  - CNST-007: Límites de exportación
  - BR-IACT-087: Nivel seguridad para funciones críticas
```

**Los 5 Tipos de BR** (se detallan en PARTE 1):

1. **Restricciones** (Constraints): Limitan comportamiento
   - Ejemplo: BR-IACT-028 (aprobación >10K)
   - Ejemplo: BR-IACT-087 (nivel seguridad ≥3)

2. **Cálculos** (Calculations): Derivan valores
   - Ejemplo: BR-IACT-053 (promedio duración llamadas)
   - Ejemplo: BR-IACT-112 (tasa abandono %)

3. **Desencadenadores** (Triggers): Inician acciones
   - Ejemplo: BR-IACT-031 (notificar si sesión >12 min inactiva)
   - Ejemplo: BR-IACT-104 (alerta si llamadas abandonadas >20%)

4. **Inferencias** (Inferences): Deducen estados
   - Ejemplo: BR-IACT-046 (marcar sesión EXPIRED si >15 min)
   - Ejemplo: BR-IACT-091 (clasificar horario como PEAK/OFF-PEAK)

5. **Definiciones** (Definitions): Clarif ican términos
   - Ejemplo: BR-IACT-001 ("Cliente activo" = llamada últimos 30 días)
   - Ejemplo: BR-IACT-015 ("Función crítica" = es_critica=TRUE)

### 2.3 Nivel 1: Business Requirements (BReq)

**Definición:** Objetivos del negocio que justifican las reglas.

**Características:**
- Medibles (con KPIs)
- Priorizables
- Independientes de implementación

**Ejemplo Real - BRQ-RPT-001:**

```yaml
ID: BRQ-RPT-001
Nombre: Prevenir Sobrecarga del Servidor Analytics
Prioridad: ALTA
Stakeholder: CTO + Gerente Operaciones

Objetivo:
  "El sistema debe prevenir que consultas grandes degraden
   el rendimiento del servidor de Analytics para otros usuarios."

Motivación de Negocio:
  - Incidentes históricos: 3 veces en Q3-2025 el servidor se saturó
  - Impacto: Dashboards ejecutivos inaccesibles durante 2+ horas
  - Costo: ~$15K por incidente (SLA violation)

Métrica de Éxito:
  - 0 incidentes de saturación de servidor en Q1-2026
  - Tiempo de respuesta promedio <3 segundos (p95)
  - Máximo uso CPU servidor <80% en horarios peak

Reglas de Negocio que lo implementan:
  - BR-IACT-028: Aprobación consultas >10K registros
  - BR-IACT-053: Cálculo anticipado de count antes de ejecutar
  - BR-IACT-112: Timeout 60 segundos para consultas

Casos de Uso que lo cumplen:
  - UC-IACT-RPT-01: Consultar Reporte (con validación count)
  - UC-IACT-RPT-09: Aprobar/Rechazar Consulta Grande
  
Validable con:
  - Test de carga: 50 usuarios concurrentes consultan 10K registros c/u
  - Monitoreo Grafana: CPU, memoria, tiempo respuesta
  - Alertas automáticas si CPU >80% o latencia >5s
```

### 2.4 Nivel 2: User Requirements (UC)

**Definición:** Interacciones observables entre usuario y sistema.

**Características:**
- Describen FLUJO de acciones
- Incluyen precondiciones y postcondiciones
- Identifican flujos alternos y excepciones

**Ejemplo Real - UC-IACT-RPT-01:**

```
═══════════════════════════════════════════════════════════════
UC-IACT-RPT-01: Consultar Reporte Trimestral Consolidado
═══════════════════════════════════════════════════════════════

RESUMEN
───────
ID: UC-IACT-RPT-01
Nombre: Consultar Reporte Trimestral Consolidado
Actor Principal: Analista de Negocio [AGR-003: agr_supervisor]
Actor Secundario: Supervisor de Área [AGR-003]
Módulo: MOD_Reports
Función RBAC: RPT-001 (ve_reportes)
Prioridad: ALTA
Complejidad: MEDIA

DESCRIPCIÓN
───────────
Permite al analista de negocio consultar métricas consolidadas 
de llamadas IVR para un trimestre específico, con la posibilidad 
de filtrar por centro de contacto y tipo de métrica.

RESTRICCIONES APLICABLES
─────────────────────────
- CNST-003: Datos provienen de BD Analytics (desfase 6-12h según ETL)
- CNST-006: Rango máximo de consulta: 2 años
- CNST-007: Límite de registros según formato export (CSV:100K, Excel:50K, PDF:10K)
- BR-IACT-028: Aprobación requerida si consulta >10,000 registros

PRECONDICIONES
──────────────
1. Usuario autenticado en el sistema
2. Usuario tiene función RPT-001 (ve_reportes) asignada
3. Usuario pertenece a un segmento de datos válido
4. ETL ha ejecutado al menos una vez (datos disponibles)

TRIGGER
───────
Usuario selecciona "Reportes > Trimestral Consolidado" en el menú

POSTCONDICIONES ÉXITO
─────────────────────
1. Reporte generado y visible en pantalla
2. Datos filtrados según segmento del usuario
3. Evento auditado en log (CNST-009)
4. Contadores de uso actualizados

FLUJO NORMAL (Camino Feliz)
────────────────────────────
┌────┬─────────────────┬────────────────────────────────────────┐
│ # │ Actor           │ Acción                                  │
├────┼─────────────────┼────────────────────────────────────────┤
│ 1  │ Analista        │ Selecciona "Reportes > Trimestral"     │
│ 2  │ Sistema         │ Valida función RPT-001                  │
│ 3  │ Sistema         │ Muestra formulario con filtros          │
│ 4  │ Analista        │ Selecciona:                             │
│    │                 │   - Trimestre: Q4-2025                  │
│    │                 │   - Centro: Todos                       │
│    │                 │   - Métrica: Llamadas totales           │
│ 5  │ Analista        │ Click en "Generar Reporte"              │
│ 6  │ Sistema         │ Valida rango fecha ≤ 2 años (CNST-006)  │
│ 7  │ Sistema         │ Ejecuta COUNT(*) en query               │
│ 8  │ Sistema         │ Valida count ≤ 10,000 (BR-IACT-028)     │
│ 9  │ Sistema         │ Aplica filtro de segmento del usuario   │
│ 10 │ Sistema         │ Ejecuta query en BD Analytics           │
│ 11 │ Sistema         │ Renderiza tabla con resultados          │
│ 12 │ Sistema         │ Audita acción (CNST-009)                │
└────┴─────────────────┴────────────────────────────────────────┘

FLUJOS ALTERNOS
───────────────

FA-1: Consulta Requiere Aprobación (count > 10,000)
  En paso 8, si count > 10,000:
    8a. Sistema muestra modal: "Su consulta retorna X registros.
        Requiere aprobación del supervisor. ¿Desea continuar?"
    8b. Si Analista confirma:
      8b.1. Sistema crea request en estado PENDIENTE_APROBACION
      8b.2. Sistema notifica supervisor vía buzón interno (CNST-001)
      8b.3. Sistema muestra: "Solicitud enviada. Será notificado"
      8b.4. → Fin de UC (continúa en UC-IACT-RPT-09)
    8c. Si Analista cancela:
      8c.1. Sistema regresa a formulario (paso 3)

FA-2: Usuario sin Permisos
  En paso 2, si usuario NO tiene RPT-001:
    2a. Sistema muestra error: "No tiene permisos para este módulo"
    2b. Sistema sugiere contactar administrador
    2c. Sistema audita intento denegado
    2d. → Fin de UC (fallo)

FA-3: Rango de Fecha Inválido (>2 años)
  En paso 6, si rango > 2 años:
    6a. Sistema muestra error: "Rango máximo: 2 años (CNST-006)"
    6b. Sistema marca campos fecha en rojo
    6c. Sistema regresa a formulario (paso 3)

FA-4: Sin Datos Disponibles
  En paso 10, si query retorna 0 registros:
    10a. Sistema muestra: "No hay datos para los filtros seleccionados"
    10b. Sistema sugiere ampliar rango o cambiar filtros
    10c. Sistema regresa a formulario (paso 3)

EXCEPCIONES
───────────

EX-1: Timeout de Query (>60 segundos)
  En paso 10, si query excede 60 segundos:
    10x.1. Sistema cancela query
    10x.2. Sistema muestra: "Consulta muy compleja. Contacte soporte"
    10x.3. Sistema audita evento (nivel WARNING)
    10x.4. → Fin de UC (fallo técnico)

EX-2: Error de BD
  En paso 10, si error de conexión/query:
    10x.1. Sistema captura excepción
    10x.2. Sistema muestra: "Error técnico. Intente más tarde"
    10x.3. Sistema log completo en logs técnicos
    10x.4. Sistema audita evento (nivel ERROR)
    10x.5. → Fin de UC (fallo técnico)

REGLAS DE NEGOCIO APLICADAS
────────────────────────────
- BR-IACT-028: Aprobación si count >10K (paso 8, FA-1)
- BR-IACT-087: Validación nivel seguridad (implícito en paso 2)
- BR-IACT-053: Cálculo de count anticipado (paso 7)

REQUISITOS FUNCIONALES DERIVADOS
─────────────────────────────────
- FR-RPT-01-01: Validar función RBAC RPT-001
- FR-RPT-01-02: Renderizar formulario con filtros
- FR-RPT-01-03: Validar rango fecha ≤ 2 años
- FR-RPT-01-04: Ejecutar COUNT(*) antes de query principal
- FR-RPT-01-05: Aplicar filtro segmento automático
- FR-RPT-01-06: Ejecutar query con timeout 60s
- FR-RPT-01-07: Renderizar tabla paginada (50 filas/página)
- FR-RPT-01-08: Auditar evento en tabla auditoria
- FR-RPT-01-09: Crear request si count >10K
- FR-RPT-01-10: Notificar supervisor vía InternalMessage

TRAZABILIDAD
────────────
BReq: BRQ-RPT-001 (Prevenir sobrecarga servidor)
BR: BR-IACT-028, BR-IACT-053, BR-IACT-087
UC: Este UC
FR: FR-RPT-01-01 a FR-RPT-01-10
Actor: AGR-003 (agr_supervisor)
Función: RPT-001 (ve_reportes)

═══════════════════════════════════════════════════════════════
```

**Características clave de este UC:**

1. **Actor RBAC:** Usa agrupador (AGR-003) y función atómica (RPT-001)
2. **CNST explícitos:** Menciona CNST-003, 006, 007, 009
3. **BR aplicadas:** BR-IACT-028 integrada en paso 8
4. **Flujos alternos:** FA-1 implementa la aprobación
5. **FR derivados:** 10 requisitos funcionales específicos
6. **Trazabilidad:** Conecta BReq → BR → UC → FR

### 2.5 Nivel 3: Functional Requirements (FR)

**Definición:** Especificaciones técnicas que el sistema DEBE implementar.

**Características:**
- Implementables en código
- Testeables automáticamente
- Sin ambigüedad técnica

**Ejemplo Real - FR-RPT-01-07:**

```yaml
ID: FR-RPT-01-07
Nombre: Calcular COUNT(*) Antes de Ejecutar Query Principal
Módulo: MOD_Reports
Prioridad: ALTA
Derivado de: UC-IACT-RPT-01 (paso 7)
Implementa: BR-IACT-028, BR-IACT-053

DESCRIPCIÓN
───────────
El sistema debe ejecutar una query COUNT(*) con los mismos filtros
que la query principal ANTES de ejecutar el SELECT completo, para
determinar si se requiere aprobación del supervisor.

ESPECIFICACIÓN TÉCNICA
──────────────────────

Query Count:
  SELECT COUNT(*) as total_records
  FROM analytics_calls ac
  INNER JOIN analytics_centers ctr ON ac.center_id = ctr.center_id
  WHERE ac.call_date BETWEEN :start_date AND :end_date
    AND ac.metric_type = :metric_type
    AND ctr.segment_id = :user_segment_id
    [AND ac.center_id = :center_id]  -- Si filtro centro activo

Variables:
  :start_date → Del formulario (Q4-2025 inicio)
  :end_date → Del formulario (Q4-2025 fin)
  :metric_type → Del formulario ('TOTAL_CALLS')
  :user_segment_id → Del usuario autenticado (ej: 'OP')
  :center_id → Opcional, del formulario

Resultado Esperado:
  total_records: INTEGER (ej: 8,542 o 15,327)

Decisión:
  IF total_records <= 10000 THEN
    → Continuar con query principal (paso 10)
  ELSE
    → Solicitar aprobación (FA-1)
  END IF

Performance:
  - Timeout: 5 segundos máximo
  - Index requerido: (call_date, center_id, metric_type)
  - Caching: NO (datos cambian con cada ETL)

IMPLEMENTACIÓN PYTHON
─────────────────────

File: apps/reports/services.py

def calculate_query_count(filters: ReportFilters, user: User) -> int:
    """
    Calcula el count de registros que retornaría una consulta.
    
    Args:
        filters: Filtros del reporte (fecha, centro, métrica)
        user: Usuario autenticado (para segmento)
    
    Returns:
        int: Número de registros que retornaría la consulta
    
    Raises:
        DatabaseError: Si falla la query
        TimeoutError: Si excede 5 segundos
    
    Implements: FR-RPT-01-07
    References: BR-IACT-028, BR-IACT-053
    """
    from django.db import connection
    from datetime import timedelta
    
    # Validar rango fecha
    if (filters.end_date - filters.start_date) > timedelta(days=730):
        raise ValidationError("Rango máximo: 2 años")
    
    # Construir query count
    query = """
        SELECT COUNT(*) as total_records
        FROM analytics_calls ac
        INNER JOIN analytics_centers ctr 
          ON ac.center_id = ctr.center_id
        WHERE ac.call_date BETWEEN %s AND %s
          AND ac.metric_type = %s
          AND ctr.segment_id = %s
    """
    
    params = [
        filters.start_date,
        filters.end_date,
        filters.metric_type,
        user.segment_id
    ]
    
    # Agregar filtro centro si aplica
    if filters.center_id:
        query += " AND ac.center_id = %s"
        params.append(filters.center_id)
    
    # Ejecutar con timeout
    with connection.cursor() as cursor:
        cursor.execute("SET statement_timeout = 5000")  # 5 seg
        cursor.execute(query, params)
        result = cursor.fetchone()
    
    count = result[0] if result else 0
    
    # Auditar
    UserActionLog.record(
        user=user,
        action='REPORT_COUNT_CALCULATED',
        resource='analytics_calls',
        result='SUCCESS',
        details={'count': count, 'filters': filters.to_dict()}
    )
    
    return count

CASOS DE PRUEBA
───────────────

Test 1: Count ≤ 10,000 (No requiere aprobación)
  Input:
    filters = {start: '2025-10-01', end: '2025-12-31', type: 'TOTAL_CALLS'}
    user.segment_id = 'OP'
  Expected Output:
    count = 8,542
    decision = 'EXECUTE_IMMEDIATELY'

Test 2: Count > 10,000 (Requiere aprobación)
  Input:
    filters = {start: '2024-01-01', end: '2025-12-31', type: 'TOTAL_CALLS'}
    user.segment_id = 'OP'
  Expected Output:
    count = 15,327
    decision = 'REQUIRES_APPROVAL'

Test 3: Timeout (> 5 segundos)
  Input:
    filters = {start: '2020-01-01', end: '2025-12-31', type: 'ALL'}
  Expected Output:
    TimeoutError raised
    Mensaje: "Query count excedió timeout de 5 segundos"

Test 4: Filtro de segmento aplicado
  Input:
    user_A.segment_id = 'OP' (Operativo)
    user_B.segment_id = 'FI' (Financiero)
  Expected:
    count_A ≠ count_B (diferentes segmentos ven diferentes datos)

VALIDACIÓN
──────────
□ Query ejecuta en <5 segundos con 1M registros
□ Index (call_date, center_id, metric_type) existe
□ Segmento del usuario filtra automáticamente
□ Count exacto (no aproximado)
□ Timeout configurado en 5 segundos
□ Evento auditado en UserActionLog
```

**Características clave de este FR:**

1. **Derivación clara:** Viene de UC-IACT-RPT-01 paso 7
2. **Especificación SQL:** Query exacta, no ambigua
3. **Implementación Python:** Código completo con docstring
4. **Casos de prueba:** 4 escenarios específicos
5. **Performance:** Timeout y índices definidos
6. **Trazabilidad:** Referencia a BR-IACT-028 y BR-IACT-053

### 2.6 Flujo de Influencia Bidireccional

**CRÍTICO:** El flujo NO es solo de arriba hacia abajo.

```
      BR ←→ BReq
       ↕      ↕
      UC  ←→ FR
       ↕      ↕
    CÓDIGO ←→ TESTS
```

**Ejemplo de influencia de abajo hacia arriba:**

```
PASO 1 (Implementación):
  Dev implementa FR-RPT-01-07 y descubre:
  "El COUNT(*) en BD con 10M registros tarda 12 segundos, no 5"

PASO 2 (Impacto en UC):
  → UC-IACT-RPT-01 necesita ajuste:
     Timeout de count debe ser 15 segundos, no 5
     O agregar índice compuesto
     O usar EXPLAIN para optimizar

PASO 3 (Impacto en BR):
  → BR-IACT-053 necesita refinamiento:
     "Count debe ejecutarse con índice optimizado"
     "Timeout: 15 segundos para queries count"

PASO 4 (Impacto en BReq):
  → BRQ-RPT-001 mantiene objetivo pero ajusta implementación
     Métrica: p95 <15 segundos (en lugar de <3 segundos)
```

**Este es el ciclo de refinamiento continuo.**

---

