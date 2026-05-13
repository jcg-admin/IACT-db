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

### 2.7 Diagrama Maestro de la Jerarquía

```
┌──────────────────────────────────────────────────────────────────────────┐
│                   PROYECTO IACT - FLUJO COMPLETO                          │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  STAKEHOLDER: "Necesitamos prevenir que consultas grandes saturen        │
│                el servidor de Analytics"                                  │
│                                    │                                      │
│                                    ↓ IDENTIFICA                           │
│                                                                           │
│  BRQ-RPT-001: Prevenir Sobrecarga Servidor                               │
│  ═══════════════════════════════════════                                 │
│  Objetivo medible: 0 incidentes saturación en Q1-2026                    │
│  KPI: CPU <80%, latencia p95 <3s                                         │
│                                    │                                      │
│                                    ↓ SE IMPLEMENTA CON                    │
│                                                                           │
│  BR-IACT-028: Aprobación Consultas Grandes                               │
│  ═══════════════════════════════════════════                             │
│  "Consultas >10K registros requieren aprobación supervisor"              │
│  Tipo: Restricción | Observable: Sí                                      │
│                                    │                                      │
│                         ┌──────────┴──────────┐                          │
│                         ↓                      ↓                          │
│                                                                           │
│  UC-IACT-RPT-01:                  UC-IACT-RPT-09:                        │
│  Consultar Reporte                Aprobar/Rechazar Consulta              │
│  ══════════════════                ═══════════════════════               │
│  Paso 7: Ejecuta COUNT(*)         Actor: Supervisor                      │
│  Paso 8: Si >10K → FA-1           Precondición: Request pendiente        │
│  FA-1: Solicita aprobación        Paso 3: Supervisor aprueba/rechaza    │
│                                    Paso 5: Notifica analista             │
│         │                                  │                              │
│         ↓ DERIVA EN                        ↓ DERIVA EN                    │
│                                                                           │
│  FR-RPT-01-07:                    FR-RPT-09-03:                          │
│  Calcular COUNT(*)                Actualizar Estado Request              │
│  ══════════════════                ═══════════════════════               │
│  Query: SELECT COUNT(*)...         UPDATE requests                       │
│  Timeout: 5 segundos               SET status = :decision                │
│  Index: (call_date,...)            WHERE request_id = :id                │
│                                                                           │
│         │                                  │                              │
│         ↓ SE IMPLEMENTA EN                 ↓ SE IMPLEMENTA EN             │
│                                                                           │
│  reports/services.py              requests/services.py                   │
│  ════════════════════              ═══════════════════                   │
│  calculate_query_count()           update_request_status()               │
│  ↓ retorna count                   ↓ retorna updated_request             │
│                                                                           │
│         │                                  │                              │
│         ↓ SE VALIDA CON                    ↓ SE VALIDA CON                │
│                                                                           │
│  tests/test_reports.py            tests/test_requests.py                 │
│  ══════════════════════            ══════════════════════                │
│  test_count_under_10k()            test_supervisor_approves()            │
│  test_count_over_10k()             test_supervisor_rejects()             │
│  test_count_timeout()              test_notification_sent()              │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

<a name="3-transformaciones-clave"></a>

## 3. TRANSFORMACIONES CLAVE

### 3.1 BR → UC: La Transformación Principal

**Pregunta fundamental:** ¿Cómo conviertes una regla de negocio en lenguaje natural en un caso de uso estructurado?

**Respuesta:** Depende del **TIPO de BR**.

### 3.2 Los 5 Tipos de BR y Sus Transformaciones

#### Tipo 1: RESTRICCIONES → PRECONDICIONES / FLUJOS ALTERNOS

**Ejemplo: BR-IACT-087**

```yaml
BR-IACT-087: Nivel de Seguridad para Funciones Críticas
Tipo: Restricción
Enunciado:
  "Solo usuarios con nivel de seguridad ≥3 pueden asignar
   funciones marcadas como críticas a otros usuarios."

Observable:
  - Usuario con nivel 2 intenta asignar función crítica
  - Sistema muestra: "Nivel de seguridad insuficiente"
```

**Transformación a UC:**

```
UC-IACT-ACC-01: Asignar Funciones a Usuario
  
  PRECONDICIÓN (derivada de BR-IACT-087):
    1. Usuario admin autenticado
    2. Usuario admin tiene función ACC-001 (asigna_funciones)
    3. Si funciones a asignar incluyen críticas:
       → Usuario admin debe tener nivel_seguridad ≥ 3
  
  PASO 4: Identificar Funciones Críticas
    Sistema verifica cuáles funciones tienen es_critica = TRUE
  
  FLUJO ALTERNO FA-3 (derivado de BR-IACT-087):
    En paso 4, si hay funciones críticas Y nivel_admin < 3:
      4a. Sistema muestra error:
          "Nivel de seguridad insuficiente para asignar funciones críticas.
           Nivel requerido: 3. Nivel actual: X."
      4b. Sistema lista funciones denegadas
      4c. Sistema regresa a selección de funciones (paso 3)
```

**Patrón:**
```
Restricción en BR
  ↓
Precondición en UC (validación antes)
  +
Flujo Alterno en UC (qué pasa si falla validación)
```

#### Tipo 2: CÁLCULOS → REQUISITOS FUNCIONALES

**Ejemplo: BR-IACT-053**

```yaml
BR-IACT-053: Cálculo de Promedio de Duración
Tipo: Cálculo
Enunciado:
  "El promedio de duración de llamadas se calcula como la suma
   de todas las duraciones dividida por el número total de llamadas,
   excluyendo llamadas con duración = 0 (abandonadas sin conexión)."

Fórmula:
  promedio_duracion = SUM(call_duration WHERE call_duration > 0) 
                      / COUNT(*) WHERE call_duration > 0
```

**Transformación a UC:**

```
UC-IACT-RPT-02: Consultar Promedio de Duración

  PASO 8: Calcular Promedio de Duración
    Sistema ejecuta cálculo según BR-IACT-053
    
  [NO genera flujo alterno, solo FR]
```

**Transformación a FR:**

```yaml
FR-RPT-02-08: Calcular Promedio Duración de Llamadas
Derivado de: UC-IACT-RPT-02 paso 8
Implementa: BR-IACT-053

Query SQL:
  SELECT 
    AVG(call_duration) as avg_duration
  FROM analytics_calls
  WHERE call_date BETWEEN :start AND :end
    AND call_duration > 0  -- Excluir abandonadas sin conexión
    AND segment_id = :user_segment

Validación:
  - avg_duration >= 0
  - avg_duration <= 7200 (2 horas, límite físico razonable)
  - Redondeo: 2 decimales
  - Unidad: segundos

Caso Especial:
  Si COUNT(*) WHERE call_duration > 0 = 0:
    → Retornar NULL (no 0, para diferenciar)
```

**Patrón:**
```
Cálculo en BR
  ↓
Paso en UC (menciona que se calcula)
  ↓
FR específico con fórmula SQL/código exacto
```

#### Tipo 3: DESENCADENADORES → CASOS DE USO COMPLETOS

**Ejemplo: BR-IACT-031**

```yaml
BR-IACT-031: Notificación de Sesión por Expirar
Tipo: Desencadenador (Trigger)
Enunciado:
  "El sistema debe notificar al usuario cuando su sesión haya estado
   inactiva durante 12 minutos, advirtiéndole que expirará en 3 minutos
   más si no realiza alguna acción."

Observable:
  Usuario recibe notificación: "Su sesión expirará en 3 minutos por inactividad"
  
Timing:
  T+0:   Usuario autenticado, última actividad registrada
  T+12min: Sistema notifica (BR-IACT-031)
  T+15min: Sistema marca sesión EXPIRED (BR-IACT-046)
```

**Transformación:**

```
BR-IACT-031 → GENERA UN UC COMPLETO

UC-IACT-AUTH-07: Notificar Sesión por Expirar
═══════════════════════════════════════════════

Actor Principal: Sistema (Scheduler/Background Job)
Actor Secundario: Usuario (receptor de notificación)
Trigger: Cron job cada 1 minuto
Frecuencia: Continua

PRECONDICIONES
  1. Sistema de notificaciones activo
  2. Tabla user_sessions actualizada
  3. Scheduler ejecutándose

FLUJO NORMAL
  1. Sistema (Scheduler) ejecuta cada 1 minuto
  2. Sistema consulta sesiones con:
     - estado = 'ACTIVA'
     - last_activity BETWEEN (NOW() - 13 min) AND (NOW() - 12 min)
  3. Para cada sesión encontrada:
     3a. Sistema crea notificación:
         Título: "Sesión por Expirar"
         Mensaje: "Su sesión expirará en 3 minutos por inactividad"
         Prioridad: WARNING
         Destinatario: user_id de la sesión
     3b. Sistema envía vía InternalMessage (CNST-001: NO email)
     3c. Sistema actualiza session.notified_expiry = TRUE
     3d. Sistema audita evento (nivel INFO)

POSTCONDICIONES
  - Usuario recibe notificación en buzón interno
  - Sesión marcada como notified_expiry = TRUE
  - Evento auditado

FLUJOS ALTERNOS
  FA-1: Usuario Realiza Acción Después de Notificación
    Si usuario hace click/request antes de 15 min:
      → last_activity se actualiza
      → Sesión NO expira
      → notified_expiry se resetea a FALSE

DERIVADO DE: BR-IACT-031
RELACIONADO CON: 
  - UC-IACT-AUTH-08: Marcar Sesión Expirada (BR-IACT-046)
  - FR-AUTH-07-02: Query sesiones por expirar
  - FR-AUTH-07-03: Crear InternalMessage
```

**Patrón:**
```
Desencadenador en BR
  ↓
UC COMPLETO (11+ pasos)
  ↓
Múltiples FR derivados
  ↓
Scheduler/Background job en código
```

#### Tipo 4: INFERENCIAS → REQUISITOS FUNCIONALES DIRECTOS

**Ejemplo: BR-IACT-046**

```yaml
BR-IACT-046: Marcar Sesión como Expirada
Tipo: Inferencia (Deducción)
Enunciado:
  "Una sesión se considera EXPIRADA si han transcurrido más de
   15 minutos desde la última actividad registrada."

Observable: NO directamente observable por usuario
  (Solo visible en BD: campo session.estado cambia a 'EXPIRED')

Timing:
  T+15min: Sistema marca sesión EXPIRED (BR-IACT-046)
           ↓
           Usuario NO ve nada (sucede en background)
           ↓
           Próximo request: Sistema rechaza con "Sesión expirada"
```

**Transformación:**

```
BR-IACT-046 → NO genera UC completo

UC-IACT-AUTH-08: Marcar Sesiones Expiradas
═══════════════════════════════════════════

Actor: Sistema (Background Job)
Trigger: Cron job cada 1 minuto
Complejidad: BAJA (solo UPDATE)

FLUJO NORMAL
  1. Sistema ejecuta cada 1 minuto
  2. Sistema ejecuta UPDATE:
     
     UPDATE user_sessions
     SET estado = 'EXPIRED',
         expired_at = NOW()
     WHERE estado = 'ACTIVA'
       AND last_activity < NOW() - INTERVAL '15 minutes'
  
  3. Sistema audita cantidad de sesiones marcadas

POSTCONDICIONES
  - Sesiones inactivas >15 min marcadas como EXPIRED
  - Evento auditado

[UC muy simple, casi solo el FR]
```

**O directamente:**

```yaml
FR-AUTH-08-02: Marcar Sesiones Inactivas como Expiradas
Derivado de: BR-IACT-046 (directamente)
Prioridad: ALTA

Query SQL:
  UPDATE user_sessions
  SET estado = 'EXPIRED',
      expired_at = CURRENT_TIMESTAMP
  WHERE estado = 'ACTIVA'
    AND last_activity < (CURRENT_TIMESTAMP - INTERVAL '15 minutes')
  RETURNING session_id;

Ejecución:
  - Scheduler: Cada 1 minuto
  - Timeout: 5 segundos
  - Log: Registrar cantidad de sesiones expiradas

Validación:
  - Solo sesiones ACTIVAS se marcan
  - Campo expired_at se actualiza
  - Auditoría con cantidad afectada
```

**Patrón:**
```
Inferencia en BR
  ↓
UC simple (casi vacío) o directamente FR
  ↓
UPDATE/cálculo automático en BD
  ↓
Background job
```

**DIFERENCIA CRÍTICA: Desencadenadores vs Inferencias**

```
DESENCADENADOR (BR-IACT-031):
  ✅ Observable por usuario → Usuario RECIBE notificación
  ✅ Genera UC completo con 11 pasos
  ✅ Actor secundario: Usuario
  ✅ Acción visible: Notificación aparece
  
INFERENCIA (BR-IACT-046):
  ❌ NO observable por usuario → Solo campo BD cambia
  ❌ NO genera UC completo → Solo FR directo
  ❌ Sin actor secundario → Solo sistema
  ❌ Sin acción visible → UPDATE silencioso
```

#### Tipo 5: DEFINICIONES → GLOSARIO

**Ejemplo: BR-IACT-001**

```yaml
BR-IACT-001: Definición de Cliente Activo
Tipo: Definición
Enunciado:
  "Un cliente se considera 'activo' si ha realizado al menos
   una llamada en los últimos 30 días naturales."

Propósito: Clarificar término de negocio
```

**Transformación:**

```
BR-IACT-001 → NO genera UC ni FR

Se documenta en GLOSARIO DEL PROYECTO:

GLOSARIO.rst
════════════

Cliente Activo
──────────────
Definición: Cliente con al menos 1 llamada en últimos 30 días
Fuente: BR-IACT-001
Uso: Reportes de actividad, segmentación

Query referencia:
  SELECT customer_id
  FROM customers c
  WHERE EXISTS (
    SELECT 1 FROM calls
    WHERE customer_id = c.customer_id
      AND call_date >= CURRENT_DATE - INTERVAL '30 days'
  )
```

**Patrón:**
```
Definición en BR
  ↓
Entrada en Glosario
  ↓
Uso consistente en toda la documentación
```

### 3.3 Desencadenadores vs Inferencias: La Diferencia CRÍTICA

**Esta es la distinción MÁS IMPORTANTE en PARTE 1.**

```
┌──────────────────────────────────────────────────────────────┐
│          DESENCADENADOR vs INFERENCIA                         │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  DESENCADENADOR (Trigger)                                     │
│  ════════════════════════                                     │
│  Inicio de acción OBSERVABLE por actor externo               │
│                                                               │
│  Ejemplo: BR-IACT-031 (Notificar sesión por expirar)         │
│                                                               │
│  Características:                                             │
│    ✅ Usuario VE/RECIBE algo                                  │
│    ✅ Genera UC completo (11+ pasos)                          │
│    ✅ Actor secundario: Usuario                               │
│    ✅ Interacción usuario-sistema                             │
│                                                               │
│  Timeline:                                                    │
│    T+12min: Sistema envía notificación                        │
│             ↓                                                 │
│             Usuario RECIBE mensaje en buzón                   │
│             ↓                                                 │
│             Usuario puede ACTUAR (hacer click, ignorar)       │
│                                                               │
│ ───────────────────────────────────────────────────────────  │
│                                                               │
│  INFERENCIA (Inference)                                       │
│  ═══════════════════                                          │
│  Deducción de estado SIN interacción observable              │
│                                                               │
│  Ejemplo: BR-IACT-046 (Marcar sesión expirada)               │
│                                                               │
│  Características:                                             │
│    ❌ Usuario NO ve nada                                      │
│    ❌ NO genera UC completo → Solo FR                         │
│    ❌ Sin actor secundario                                    │
│    ❌ Solo cambio de estado en BD                             │
│                                                               │
│  Timeline:                                                    │
│    T+15min: Sistema UPDATE estado_sesion = 'EXPIRED'          │
│             ↓                                                 │
│             Campo en BD cambia                                │
│             ↓                                                 │
│             Usuario NO se entera (hasta próximo request)      │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

**Test de Observabilidad:**

```
Pregunta: "¿El usuario VE o RECIBE algo como resultado de esta BR?"

SI → Desencadenador → UC completo
  Ejemplos:
    - Notificación aparece
    - Email llega (si no fuera CNST-001)
    - Popup se muestra
    - Dashboard se actualiza en tiempo real

NO → Inferencia → FR directo
  Ejemplos:
    - Campo BD cambia
    - Flag se actualiza
    - Timestamp se registra
    - Estado se calcula
```

**Ejemplo Completo de la Diferencia:**

```
TIMELINE COMPLETO: Expiración de Sesión

T+0 min:
  Usuario autenticado
  Session {estado: 'ACTIVA', last_activity: 14:00:00}

T+12 min (14:12:00):
  ┌─────────────────────────────────────────────┐
  │ BR-IACT-031 (DESENCADENADOR)               │
  │ ═══════════════════════════                 │
  │ → UC-IACT-AUTH-07 ejecuta                   │
  │ → Sistema crea InternalMessage              │
  │ → Usuario RECIBE notificación               │
  │   "Su sesión expirará en 3 minutos"         │
  │                                              │
  │ ✅ OBSERVABLE: Usuario ve notificación      │
  └─────────────────────────────────────────────┘

T+13 min (14:13:00):
  Usuario hace click en la app
  → last_activity actualizado a 14:13:00
  → Sesión se mantiene ACTIVA

T+28 min (14:28:00):
  Usuario NO ha hecho nada en 15 minutos
  
  ┌─────────────────────────────────────────────┐
  │ BR-IACT-046 (INFERENCIA)                    │
  │ ═══════════════════                         │
  │ → FR-AUTH-08-02 ejecuta                     │
  │ → UPDATE estado = 'EXPIRED'                 │
  │ → Campo BD cambia                           │
  │                                              │
  │ ❌ NO OBSERVABLE: Usuario no ve nada        │
  │    (solo se entera en próximo request)      │
  └─────────────────────────────────────────────┘

T+30 min (14:30:00):
  Usuario intenta hacer request
  → Sistema consulta session.estado
  → Encuentra 'EXPIRED'
  → Rechaza request con "Sesión expirada. Inicie sesión"
  
  ✅ AHORA SÍ es observable (error de sesión expirada)
  Pero NO fue observable en T+28 cuando cambió el estado
```

### 3.4 Trazabilidad Bidireccional

**Hacia Adelante (Forward Tracing):**

```
BR-IACT-028
  ↓ genera
UC-IACT-RPT-01 (Consultar Reporte)
  ↓ paso 8 deriva
FR-RPT-01-07 (Calcular COUNT(*))
  ↓ implementado en
reports/services.py::calculate_query_count()
  ↓ validado con
tests/test_reports.py::test_count_over_10k()
```

**Hacia Atrás (Backward Tracing):**

```
test_count_over_10k() FALLA
  ↑ valida
FR-RPT-01-07 (especificación incorrecta?)
  ↑ derivado de
UC-IACT-RPT-01 paso 8 (flujo incorrecto?)
  ↑ implementa
BR-IACT-028 (regla mal entendida?)
```

**Matriz de Trazabilidad (RTM):**

```
| BR          | BReq       | UC              | FR             | Código                  | Test                    |
|-------------|------------|-----------------|----------------|-------------------------|-------------------------|
| BR-IACT-028 | BRQ-RPT-001| UC-IACT-RPT-01  | FR-RPT-01-07   | calculate_query_count() | test_count_over_10k()   |
|             |            | UC-IACT-RPT-09  | FR-RPT-01-09   | create_approval_request | test_approval_created() |
|             |            |                 | FR-RPT-09-03   | update_request_status() | test_supervisor_approves|
| BR-IACT-031 | BRQ-SEC-005| UC-IACT-AUTH-07 | FR-AUTH-07-02  | get_expiring_sessions() | test_notification_sent()|
|             |            |                 | FR-AUTH-07-03  | create_internal_message | test_message_created()  |
| BR-IACT-046 | BRQ-SEC-005| UC-IACT-AUTH-08 | FR-AUTH-08-02  | mark_sessions_expired() | test_session_marked()   |
| BR-IACT-087 | BRQ-SEC-008| UC-IACT-ACC-01  | FR-ACC-01-04   | validate_security_level | test_level_insufficient |
```

### 3.5 Propagación de Cambios

**Escenario:** PO dice "Cambió la regla. Ahora son 5,000 registros en lugar de 10,000"

```
IMPACTO CASCADE:

BR-IACT-028
  Cambio: "consultas >10,000" → "consultas >5,000"
  ↓
UC-IACT-RPT-01
  Paso 8: "count > 10000" → "count > 5000"
  ↓
FR-RPT-01-07
  Decisión: "IF count > 10000" → "IF count > 5000"
  ↓
reports/services.py
  Línea 47: if count > 10000: → if count > 5000:
  ↓
tests/test_reports.py
  Test: count = 8000 (antes pasaba, ahora falla)
  Ajustar: count = 4000 (pasa) y count = 6000 (falla)
  ↓
UC-IACT-RPT-09 (Aprobar/Rechazar)
  Sin cambios (solo afecta si se dispara)
```

**Sin trazabilidad:** Cambias BR, olvidas actualizar tests → Bug en producción

**Con trazabilidad:** Cambias BR, RTM te muestra exactamente qué afecta → Cambio controlado

---

<a name="4-alcance-del-material"></a>

## 4. ALCANCE DEL MATERIAL

### 4.1 Qué Cubre Este Material

Este material pedagógico (PARTES 0-6) cubre:

```
✅ INCLUIDO EN EL MATERIAL
════════════════════════════

1. Metodología BR → UC → FR
   - Identificación de reglas de negocio
   - Transformación sistemática a casos de uso
   - Derivación de requisitos funcionales

2. Técnicas de Elicitación
   - CRUD básico
   - Técnica de Larman
   - UI-Driven Use Cases
   - Stakeholder-Driven Use Cases

3. Proyecto IACT Real
   - Ejemplos de MOD_Reports
   - Ejemplos de MOD_Auth
   - Ejemplos de MOD_Access
   - Ejemplos de MOD_Alerts

4. Trazabilidad Completa
   - Matrices RTM
   - Forward/Backward tracing
   - Gestión de cambios

5. Plantillas y Herramientas
   - Templates de UC (14 secciones)
   - Templates de FR (10 componentes)
   - Checklists de validación
   - Scripts de auditoría
```

```
❌ NO INCLUIDO (Fuera del Alcance)
═══════════════════════════════════

1. Requisitos No Funcionales (NFR)
   - Performance
   - Seguridad
   - Escalabilidad
   → Ver: RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md

2. Arquitectura Técnica
   - Diagramas de componentes
   - Deployment
   - Stack tecnológico
   → Ver: docs/arquitectura/

3. Diseño de Datos
   - Modelo ER
   - Normalización
   - Índices
   → Ver: docs/database/

4. Testing Detallado
   - Estrategia de testing
   - Test plans
   - Coverage
   → Ver: docs/testing/

5. Gestión de Proyecto
   - Estimaciones
   - Cronogramas
   - Asignación de recursos
   → Ver: docs/management/
```

### 4.2 Dominio del Proyecto IACT

**IACT:** IVR Analytics & Customer Tracking

**Contexto:**
- Sistema de análisis de llamadas IVR (Interactive Voice Response)
- Tracking de clientes que interactúan con sistema telefónico automatizado
- Reportes consolidados de métricas operacionales
- Control de acceso basado en funciones atómicas (RBAC v5.1.1)

**Módulos Principales:**

```
MOD_Auth: Autenticación y Sesiones
  - Login/Logout
  - Gestión de sesiones
  - Notificaciones de expiración
  - Reseteo de passwords

MOD_Users: Gestión de Usuarios
  - CRUD de usuarios
  - Perfiles
  - Preferencias
  - Estados (activo/bloqueado/baja)

MOD_Access: Control de Acceso RBAC
  - Asignación de funciones atómicas
  - Validación de permisos
  - Segregation of Duties (SoD)
  - Permisos temporales

MOD_Pipeline: ETL y Procesamiento
  - Extracción de BD IVR
  - Transformación de datos
  - Carga a BD Analytics
  - Ejecución cada 6-12 horas

MOD_Reports: Reportes y Analytics
  - Consultas consolidadas
  - Exportación (CSV/Excel/PDF)
  - Filtros avanzados
  - Aprobación de consultas grandes

MOD_Alerts: Alertas y Notificaciones
  - Configuración de alertas
  - Umbrales dinámicos
  - Notificaciones internas (CNST-001)
  - Logs de alertas

MOD_Audit: Auditoría
  - Registro de acciones
  - Búsqueda de eventos
  - Reportes de auditoría
  - Retención 7 años

MOD_Logs: Logs Técnicos
  - Logs de aplicación
  - Monitoreo de errores
  - Dashboards técnicos
  - Alertas de sistema
```

**Restricciones del Sistema (CNST):**

```
CNST-001: NO envío de emails externos
  → Solo notificaciones en buzón interno

CNST-002: Sesión única por usuario
  → Cierre automático de sesión anterior

CNST-003: BD IVR solo lectura
  → Datos con desfase 6-12h (según ETL)

CNST-004: ETL cada 6-12 horas
  → Datos NO en tiempo real

CNST-005: Flat RBAC + SoD
  → 44 funciones atómicas, sin jerarquía
  → Permisos temporales con justificación

CNST-006: Rango máximo 2 años
  → Reportes limitados a 730 días

CNST-007: Límites de exportación
  → CSV: 100K registros
  → Excel: 50K registros
  → PDF: 10K registros

CNST-008: Sesión expira 15 minutos
  → Inactividad = logout automático

CNST-009: Auditoría obligatoria
  → Todas las acciones se registran

CNST-010: Retención logs 7 años
  → Cumplimiento normativo
```

### 4.3 Actores del Sistema

**Agrupadores RBAC (AGR-00x):**

```
AGR-001: agr_operador
  - Usuarios operativos básicos
  - Consulta datos de su segmento
  - Sin permisos de administración
  - Funciones: 5-10 funciones básicas

AGR-002: agr_analista
  - Analistas de negocio
  - Reportes avanzados
  - Exportación de datos
  - Funciones: 15-20 funciones

AGR-003: agr_supervisor
  - Supervisores de área
  - Aprobación de consultas grandes
  - Gestión de equipo
  - Funciones: 25-30 funciones

AGR-004: agr_admin_sistema
  - Administradores técnicos
  - Gestión de usuarios
  - Asignación de funciones
  - Configuración del sistema
  - Funciones: 35-40 funciones

AGR-005: agr_auditor
  - Auditores internos
  - Solo lectura de logs
  - Reportes de auditoría
  - Sin permisos de modificación
  - Funciones: 5-8 funciones específicas
```

**Segmentos de Datos:**

```
Operativo (OP):
  - Centros de contacto operativos
  - Métricas de llamadas
  - Datos de clientes activos

Financiero (FI):
  - Centros financieros
  - Transacciones telefónicas
  - Datos sensibles

Ventas (VT):
  - Centros de ventas
  - Métricas de conversión
  - Campañas telefónicas

Soporte (SP):
  - Centros de soporte técnico
  - Tiempos de resolución
  - Satisfacción del cliente
```

### 4.4 Ejemplos Usados en el Material

**BR Principales:**

```
BR-IACT-028: Aprobación consultas >10K registros
  → Usado extensivamente en PARTE 2

BR-IACT-031: Notificación sesión por expirar (12 min)
  → Ejemplo de Desencadenador en PARTE 1

BR-IACT-046: Marcar sesión expirada (15 min)
  → Ejemplo de Inferencia en PARTE 1

BR-IACT-087: Nivel seguridad ≥3 para funciones críticas
  → Usado en PARTE 2 y 3

BR-IACT-053: Cálculo promedio duración llamadas
  → Ejemplo de Cálculo en PARTE 1

BR-IACT-001: Definición "Cliente activo"
  → Ejemplo de Definición en PARTE 1
```

**UC Principales:**

```
UC-IACT-RPT-01: Consultar Reporte Trimestral
  → Caso maestro en PARTE 0, 2 y 4
  → 11 pasos, 4 flujos alternos, 3 excepciones
  → Integra BR-IACT-028, CNST-006, CNST-007

UC-IACT-AUTH-01: Iniciar Sesión
  → Ejemplo básico en PARTE 3

UC-IACT-AUTH-07: Notificar Sesión por Expirar
  → Ejemplo de UC generado por Desencadenador

UC-IACT-ACC-01: Asignar Funciones a Usuario
  → Ejemplo de RBAC en PARTE 3
  → Implementa BR-IACT-087

UC-IACT-RPT-09: Aprobar/Rechazar Consulta Grande
  → Complemento de UC-IACT-RPT-01
  → Actor: Supervisor
```

**FR Principales:**

```
FR-RPT-01-07: Calcular COUNT(*) antes de query principal
  → Derivado de UC-IACT-RPT-01 paso 7
  → Implementa BR-IACT-028

FR-AUTH-07-02: Query sesiones por expirar
  → Derivado de UC-IACT-AUTH-07
  → Implementa BR-IACT-031

FR-ACC-01-04: Validar nivel seguridad para funciones críticas
  → Derivado de UC-IACT-ACC-01
  → Implementa BR-IACT-087
```

---

<a name="5-roadmap-detallado"></a>

## 5. ROADMAP DETALLADO

### 5.1 Mapa Conceptual de las 6 Partes

```
┌──────────────────────────────────────────────────────────────────┐
│                    MATERIAL PEDAGÓGICO COMPLETO                   │
│                           6 PARTES                                │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  PARTE 0: Contexto y Fundamentos (ESTE DOCUMENTO)                │
│  ═══════════════════════════════════════════════                 │
│  • El Problema                                                    │
│  • La Solución (Jerarquía 4 niveles)                              │
│  • Transformaciones Clave                                         │
│  • Alcance y Roadmap                                              │
│                                                                   │
│                           ↓ FUNDAMENTA                            │
│                                                                   │
│  PARTE 1: Identificar Reglas de Negocio                          │
│  ═══════════════════════════════════════                         │
│  • Taxonomía: 5 tipos de BR                                      │
│  • Técnicas de elicitación de BR                                 │
│  • Desencadenadores vs Inferencias ⭐                             │
│  • Documentación de BR                                            │
│  • Ejercicios prácticos                                           │
│                                                                   │
│  Duración: 8-10 horas estudio                                     │
│  Ejemplos: 15+ BR del proyecto IACT                               │
│                                                                   │
│                           ↓ TRANSFORMA EN                         │
│                                                                   │
│  PARTE 2: Transformar BR en UC                                    │
│  ══════════════════════════════════                               │
│  • PARTE 2A: Fundamentos (5 patrones transformación)              │
│  • PARTE 2B: Construcción Detallada (7 pasos)                     │
│  • PARTE 2C: Casos Especiales y Validación                        │
│                                                                   │
│  Duración: 12-15 horas estudio                                    │
│  Ejemplos: UC-IACT-RPT-01, UC-IACT-ACC-01, UC-IACT-AUTH-07        │
│  Incluye: Checklist 26 puntos, RTM, trazabilidad                  │
│                                                                   │
│                           ↓ COMPLEMENTA CON                       │
│                                                                   │
│  PARTE 3: Técnicas de Elicitación UC                             │
│  ═══════════════════════════════════                             │
│  • PARTE 3A: Introducción y CRUD                                  │
│  • PARTE 3B: Técnica de Larman (20+ UC)                           │
│  • PARTE 3C: UI-Driven + Stakeholder-Driven                       │
│  • PARTE 3D: Consolidación y Resumen                              │
│                                                                   │
│  Duración: 10-12 horas estudio                                    │
│  Ejemplos: 40+ UC desarrollados completos                         │
│                                                                   │
│                           ↓ DERIVA EN                             │
│                                                                   │
│  PARTE 4: Requisitos Funcionales                                 │
│  ════════════════════════════════                                │
│  • Definición y estándares (IEEE 830, ISO 25010)                  │
│  • Plantilla FR (10 componentes)                                  │
│  • Proceso de derivación UC → FR                                  │
│  • Clasificación y priorización                                   │
│  • FR completos con casos de prueba                               │
│                                                                   │
│  Duración: 8-10 horas estudio                                     │
│  Ejemplos: 30+ FR derivados con código Python/SQL                 │
│                                                                   │
│                           ↓ GESTIONA CON                          │
│                                                                   │
│  PARTE 5: Trazabilidad y Gestión                                 │
│  ════════════════════════════════════                            │
│  • Matrices RTM (Requirements Traceability Matrix)                │
│  • Forward/Backward tracing                                       │
│  • Gestión de cambios                                             │
│  • Versionado de requisitos                                       │
│  • Herramientas de trazabilidad                                   │
│                                                                   │
│  Duración: 6-8 horas estudio                                      │
│  Incluye: Scripts automatización, dashboards                      │
│                                                                   │
│                           ↓ PRACTICA CON                          │
│                                                                   │
│  PARTE 6: Casos Prácticos Completos                              │
│  ═══════════════════════════════════                             │
│  • Ejercicio 1: Módulo Reportes (end-to-end)                      │
│  • Ejercicio 2: Módulo Alertas (end-to-end)                       │
│  • Ejercicio 3: Módulo RBAC (end-to-end)                          │
│  • Soluciones completas con código                                │
│                                                                   │
│  Duración: 12-15 horas práctica                                   │
│  Entregables: 3 módulos documentados + implementados              │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘

TOTAL ESTIMADO: 60-80 horas de estudio + práctica
```

### 5.2 PARTE 1: Identificar Reglas de Negocio

**Objetivo:** Aprender a identificar y clasificar reglas de negocio.

**Contenido:**

```
Sección 1: Introducción
  - ¿Qué es una BR?
  - ¿Por qué documentar BR?
  - BR vs BReq vs UC vs FR

Sección 2: Taxonomía de BR (5 Tipos)
  - Tipo 1: Restricciones
  - Tipo 2: Cálculos
  - Tipo 3: Desencadenadores ⭐
  - Tipo 4: Inferencias ⭐
  - Tipo 5: Definiciones

Sección 3: Desencadenadores vs Inferencias
  ⭐ SECCIÓN MÁS IMPORTANTE DE PARTE 1
  - Test de observabilidad
  - Timeline comparativo
  - Impacto en UC
  - Ejemplos: BR-IACT-031 vs BR-IACT-046

Sección 4: Técnicas de Elicitación de BR
  - Entrevistas con stakeholders
  - Análisis de documentos
  - Observación de procesos
  - Workshops

Sección 5: Documentación de BR
  - Template estándar
  - Campos obligatorios
  - Nomenclatura

Secciones 6-12: Ejemplos y Ejercicios
  - 15+ BR del proyecto IACT
  - 5 ejercicios prácticos
  - Soluciones detalladas
```

**Duración:** 8-10 horas  
**Prerequisitos:** PARTE 0  
**Entregables:** 10 BR documentadas del proyecto IACT

### 5.3 PARTE 2: Transformar BR en UC

**Objetivo:** Dominar la transformación sistemática BR → UC.

**PARTE 2A: Fundamentos (3,735 líneas)**

```
Sección 1: Los 5 Patrones de Transformación
  Patrón 1: Restricciones → Precondiciones/Flujos Alternos
    Ejemplo: BR-IACT-087 → UC-IACT-ACC-01 (FA-3)
  
  Patrón 2: Cálculos → FR Derivados
    Ejemplo: BR-IACT-053 → FR-RPT-02-08
  
  Patrón 3: Desencadenadores → UC Completos ⭐
    Ejemplo: BR-IACT-031 → UC-IACT-AUTH-07 (11 pasos)
  
  Patrón 4: Inferencias → FR Directos
    Ejemplo: BR-IACT-046 → FR-AUTH-08-02
  
  Patrón 5: Definiciones → Glosario
    Ejemplo: BR-IACT-001 → GLOSARIO.rst

Sección 2: Fórmulas Matemáticas
  - AVG, SUM, COUNT en SQL
  - Redondeo y precisión
  - Casos especiales (división por cero)

Sección 3: Algoritmos de Decisión
  - Pseudocódigo
  - Estructuras IF-THEN-ELSE
  - Bucles y validaciones
  - Ejemplo completo: BR-IACT-087 (nivel seguridad)
```

**PARTE 2B: Construcción Detallada (4,359 líneas)**

```
Sección 4: Construcción UC Paso a Paso (7 Pasos)
  Paso 1: Identificar actor principal
  Paso 2: Definir trigger
  Paso 3: Enumerar pasos del flujo normal
  Paso 4: Identificar flujos alternos
  Paso 5: Identificar excepciones
  Paso 6: Definir precondiciones/postcondiciones
  Paso 7: Agregar trazabilidad

Sección 5: Integración Multi-BR
  - UC que implementa 3-5 BR diferentes
  - Ejemplo: UC-IACT-RPT-01 integra:
    • BR-IACT-028 (aprobación)
    • BR-IACT-053 (count)
    • BR-IACT-087 (nivel seguridad)

Sección 6: Derivación FR desde UC
  - 1 paso UC → 1-3 FR
  - Nomenclatura FR
  - FR con código implementable

Sección 7: Trazabilidad Bidireccional
  - Matrices RTM
  - Forward tracing
  - Backward tracing
  - Propagación de cambios
```

**PARTE 2C: Casos Especiales (3,332 líneas)**

```
Sección 8: Casos Especiales
  - UC CRUD (casos simples)
  - UC con CNST (restricciones arquitectónicas)
  - UC múltiples actores
  - UC con variantes
  - UC concurrencia

Sección 9: Validación UC
  - Checklist 26 puntos ⭐
  - Peer review
  - Stakeholder walkthrough
  - Validación de trazabilidad

Sección 10: Métricas de Calidad
  - Completitud
  - Consistencia
  - Claridad
  - Trazabilidad

Sección 11: Ejercicios Prácticos
  - 4 ejercicios con soluciones completas
```

**Total PARTE 2:** 11,426 líneas (~215 páginas)  
**Duración:** 12-15 horas  
**Entregables:** 5 UC completos documentados

### 5.4 PARTE 3: Técnicas de Elicitación UC

**Objetivo:** Dominar técnicas avanzadas para descubrir casos de uso.

**Contenido:**

```
PARTE 3A: Introducción y CRUD (936 líneas)
  - Técnicas de elicitación
  - CRUD básico
  - Casos de uso elementales

PARTE 3B: Técnica de Larman (3,277 líneas)
  - Eventos del sistema
  - Operaciones del sistema
  - 20+ UC desarrollados con Larman

PARTE 3C: UI-Driven + Stakeholder-Driven (1,801 líneas)
  - UI-Driven: partir de mockups/wireframes
  - Stakeholder-Driven: workshops
  - 8 UC completos

PARTE 3D: Consolidación (1,280 líneas)
  - Numeración de UC
  - Priorización MoSCoW
  - Roadmap de releases
  - Ejercicio Library System completo
```

**Total PARTE 3:** 7,294 líneas  
**Duración:** 10-12 horas

### 5.5 PARTE 4: Requisitos Funcionales

**Objetivo:** Derivar FR implementables desde UC.

**Contenido:**

```
Sección 1: Definición y Estándares
  - IEEE 830
  - ISO 25010
  - INCOSE

Sección 2: Plantilla FR (10 Componentes)
  - ID, Nombre, Módulo
  - Descripción
  - Derivado de (UC)
  - Especificación técnica
  - Implementación (código)
  - Casos de prueba
  - Validación
  - Prioridad
  - Trazabilidad

Secciones 3-9: Proceso y Ejemplos
  - Derivación UC → FR
  - Clasificación (funcional, datos, interfaz)
  - Priorización
  - 30+ FR con código Python/SQL completo
```

**Duración:** 8-10 horas

### 5.6 PARTE 5: Trazabilidad

**Objetivo:** Gestionar cambios y mantener trazabilidad.

**Contenido:**

```
- Matrices RTM automatizadas
- Scripts de validación
- Dashboards de cobertura
- Versionado semántico de requisitos
- Gestión de cambios
```

**Duración:** 6-8 horas

### 5.7 PARTE 6: Casos Prácticos

**Objetivo:** Aplicar TODO en ejercicios end-to-end.

**Contenido:**

```
Ejercicio 1: Módulo Reportes Completo
  - 5 BR → 3 UC → 15 FR → Código → Tests
  
Ejercicio 2: Módulo Alertas Completo
  - 4 BR → 2 UC → 10 FR → Código → Tests

Ejercicio 3: Módulo RBAC Completo
  - 6 BR → 4 UC → 20 FR → Código → Tests
```

**Duración:** 12-15 horas

### 5.8 Ruta de Aprendizaje Recomendada

```
SEMANA 1: Fundamentos
  Día 1-2: PARTE 0 (contexto)
  Día 3-5: PARTE 1 (identificar BR)

SEMANA 2: Transformación
  Día 1-3: PARTE 2A (patrones transformación)
  Día 4-5: PARTE 2B (construcción detallada)

SEMANA 3: Casos Especiales y Técnicas
  Día 1-2: PARTE 2C (casos especiales)
  Día 3-5: PARTE 3 (técnicas elicitación)

SEMANA 4: FR y Trazabilidad
  Día 1-3: PARTE 4 (requisitos funcionales)
  Día 4-5: PARTE 5 (trazabilidad)

SEMANA 5: Práctica
  Día 1-5: PARTE 6 (casos prácticos)

TOTAL: 5 semanas (60-80 horas)
```

---

<a name="6-metodologia-estudio"></a>

## 6. METODOLOGÍA DE ESTUDIO

### 6.1 Cómo Estudiar Este Material

**Principios de Aprendizaje Efectivo:**

```
1. APRENDER HACIENDO (70%)
   ❌ NO: Leer pasivamente las 6 partes
   ✅ SÍ: Documentar 3 BR reales de tu proyecto mientras lees PARTE 1

2. ITERACIÓN INCREMENTAL
   ❌ NO: Intentar dominar todo antes de empezar
   ✅ SÍ: Documentar 1 UC simple, obtener feedback, mejorar

3. VALIDACIÓN CONTINUA
   ❌ NO: Esperar al final para validar
   ✅ SÍ: Validar cada BR/UC con stakeholder antes de continuar

4. TRAZABILIDAD DESDE EL INICIO
   ❌ NO: "Agregaremos trazabilidad después"
   ✅ SÍ: Cada BR enlaza a BReq, cada UC enlaza a BR desde el día 1
```

### 6.2 Ejercicios Prácticos por Parte

**PARTE 1: Ejercicios de BR**

```
Ejercicio 1.1: Identificar Tipo de BR
  Dado: 10 enunciados de reglas de negocio
  Clasificar: ¿Restricción? ¿Cálculo? ¿Desencadenador? ¿Inferencia? ¿Definición?
  
  Ejemplo:
    "El sistema debe cerrar automáticamente sesiones inactivas por más de 15 minutos"
    → Respuesta: Inferencia (BR-IACT-046)

Ejercicio 1.2: Desencadenador vs Inferencia
  Dado: 5 pares de BR similares
  Identificar: ¿Cuál es desencadenador y cuál inferencia?
  
  Ejemplo:
    A) "El sistema notifica al usuario cuando su sesión lleva 12 minutos inactiva"
    B) "El sistema marca la sesión como expirada a los 15 minutos de inactividad"
    → Respuesta: A = Desencadenador (observable), B = Inferencia (no observable)

Ejercicio 1.3: Documentar BR de Tu Proyecto
  Tarea: Documentar 5 BR reales de tu proyecto actual
  Template: Usar formato de BR-IACT-XXX
  Validar: Con Product Owner o stakeholder
```

**PARTE 2: Ejercicios de Transformación**

```
Ejercicio 2.1: Restricción → Precondición
  Dado: BR-IACT-087 (nivel seguridad ≥3)
  Transformar: A precondición de UC-IACT-ACC-01
  
Ejercicio 2.2: Desencadenador → UC Completo
  Dado: BR-IACT-031 (notificar sesión por expirar)
  Generar: UC-IACT-AUTH-07 completo con 11 pasos
  
Ejercicio 2.3: Cálculo → FR
  Dado: BR-IACT-053 (promedio duración)
  Derivar: FR-RPT-02-08 con query SQL
  
Ejercicio 2.4: UC Completo End-to-End
  Tarea: Tomar 1 BR de tu proyecto
  Generar: UC completo (14 secciones)
  Derivar: 5 FR implementables
  Validar: Con equipo
```

**PARTE 3: Ejercicios de Elicitación**

```
Ejercicio 3.1: CRUD de una entidad
  Elegir: Entidad de tu proyecto (ej: Cliente, Producto)
  Generar: 4 UC (Crear, Leer, Actualizar, Eliminar)
  
Ejercicio 3.2: Técnica de Larman
  Dado: 5 eventos del sistema de tu proyecto
  Aplicar: Técnica de Larman para generar UC
  
Ejercicio 3.3: UI-Driven
  Dado: Mockup o wireframe
  Identificar: UC implícitos en la interfaz
```

**PARTE 4: Ejercicios de FR**

```
Ejercicio 4.1: Derivar FR desde UC
  Dado: UC con 8 pasos
  Derivar: 10 FR (1-2 FR por paso)
  
Ejercicio 4.2: FR con Código Implementable
  Dado: FR-RPT-01-07 (calcular count)
  Implementar: Código Python completo con tests
```

### 6.3 Checklist de Validación

**Checklist para BR:**

```
□ ID único (BR-IACT-XXX)
□ Tipo identificado (Restricción/Cálculo/Desencadenador/Inferencia/Definición)
□ Enunciado claro en lenguaje natural
□ Observable por stakeholder (si aplica)
□ Casos de ejemplo incluidos
□ Derivado de BReq identificado
□ UC generados listados
□ Validado con PO/Stakeholder
```

**Checklist para UC (26 puntos - versión resumida):**

```
□ 1. ID único (UC-MOD-NN)
□ 2. Nombre descriptivo en infinitivo
□ 3. Actor principal identificado
□ 4. Precondiciones completas
□ 5. Trigger claro
□ 6. Postcondiciones de éxito
□ 7. Flujo normal numerado
□ 8. Al menos 1 flujo alterno
□ 9. Al menos 1 excepción
□ 10. CNST aplicables listadas
□ 11. BR implementadas referenciadas
□ 12. FR derivados listados
□ 13. Trazabilidad completa
□ 14. Sin ambigüedad técnica
... (26 puntos completos en PARTE 2C)
```

**Checklist para FR:**

```
□ ID único (FR-MOD-UC-NN)
□ Derivado de UC específico
□ Implementa BR específica
□ Especificación técnica clara
□ Código/SQL implementable
□ Casos de prueba definidos
□ Criterios de validación
□ Prioridad asignada
```

### 6.4 Recursos y Herramientas

**Herramientas Recomendadas:**

```
Documentación:
  - Sphinx + RST (generación de docs)
  - PlantUML (diagramas UC)
  - Mermaid (diagramas de flujo)

Trazabilidad:
  - Matrices RTM en Excel/Google Sheets
  - Scripts Python para validación
  - Jira/Confluence para gestión

Código:
  - Git para versionado
  - Django/Python para implementación
  - pytest para tests
```

**Templates Disponibles:**

```
T01: Decisión de Tipo de BR
T02: Construcción UC en 7 Pasos
T03: Identificación de Actor Primario
T04: Documentación FR (10 Componentes)
T05: Construcción de Flujos Alternos
T06: Integración de BR en UC
T09: Checklist de Calidad UC (26 Puntos)
T10: Peer Review de UC
T12: Matriz de Trazabilidad RTM
```

### 6.5 Errores Comunes a Evitar

**Error 1: Confundir Desencadenador con Inferencia**

```
❌ INCORRECTO:
  "El sistema notifica al usuario cuando la sesión expira"
  Clasificado como: Inferencia
  
✅ CORRECTO:
  Pregunta: ¿El usuario VE/RECIBE algo?
  Respuesta: SÍ (notificación)
  → Es DESENCADENADOR, NO inferencia
```

**Error 2: BR Demasiado Técnica**

```
❌ INCORRECTO:
  BR-XXX: "El campo 'estado' de la tabla 'sessions' debe cambiar
           a 'EXPIRED' cuando NOW() - last_activity > 15 minutos"
  
✅ CORRECTO:
  BR-IACT-046: "Una sesión se considera expirada si han transcurrido
                más de 15 minutos desde la última actividad"
```

**Error 3: UC sin Flujos Alternos**

```
❌ INCORRECTO:
  UC solo tiene flujo normal (camino feliz)
  
✅ CORRECTO:
  UC tiene:
    - Flujo normal
    - 2-4 flujos alternos
    - 1-2 excepciones
```

**Error 4: FR sin Trazabilidad**

```
❌ INCORRECTO:
  FR-001: "El sistema debe validar permisos"
  (¿De qué UC viene? ¿Qué BR implementa?)
  
✅ CORRECTO:
  FR-RPT-01-07: "Calcular COUNT(*) antes de query principal"
  Derivado de: UC-IACT-RPT-01 paso 7
  Implementa: BR-IACT-028, BR-IACT-053
```

**Error 5: No Validar con Stakeholders**

```
❌ INCORRECTO:
  Analista documenta 20 BR sin validar
  → En revisión: 15 BR están incorrectas
  
✅ CORRECTO:
  Analista documenta 3 BR
  → Valida con PO inmediatamente
  → Corrige errores
  → Continúa con siguientes 3
```

### 6.6 Métricas de Progreso

**Seguimiento de Avance:**

```
PARTE 1: Identificar BR
  □ 15 BR leídas y comprendidas
  □ 5 BR documentadas de tu proyecto
  □ 3 ejercicios completados
  □ Validación con PO obtenida

PARTE 2: Transformar BR → UC
  □ 5 patrones de transformación dominados
  □ 3 UC completos documentados
  □ 10 FR derivados
  □ Checklist 26 puntos aplicado

PARTE 3: Técnicas de Elicitación
  □ CRUD de 1 entidad completado
  □ Técnica Larman aplicada (5 UC)
  □ UI-Driven aplicado (3 UC)

PARTE 4: FR
  □ 15 FR derivados con código
  □ 15 tests implementados
  □ Trazabilidad completa

PARTE 5: Trazabilidad
  □ RTM creada (30+ entradas)
  □ Script de validación funcionando
  □ Dashboard de cobertura

PARTE 6: Casos Prácticos
  □ Ejercicio 1 completado (Reportes)
  □ Ejercicio 2 completado (Alertas)
  □ Ejercicio 3 completado (RBAC)
```

---

<a name="7-convenciones-referencias"></a>

## 7. CONVENCIONES Y REFERENCIAS

### 7.1 Nomenclatura del Proyecto IACT

**Reglas de Negocio:**

```
Formato: BR-IACT-NNN
Ejemplo: BR-IACT-028

Donde:
  BR = Business Rule
  IACT = Proyecto
  NNN = Número secuencial (001-999)
```

**Business Requirements:**

```
Formato: BRQ-MOD-NNN
Ejemplo: BRQ-RPT-001

Donde:
  BRQ = Business Requirement
  MOD = Módulo (RPT, AUTH, ACC, etc.)
  NNN = Número secuencial
```

**Casos de Uso:**

```
Formato: UC-IACT-MOD-NN_Nombre_Descriptivo_X_Y_Z.rst
Ejemplo: UC-IACT-RPT-01_Consultar_Reporte_4_0_0.rst

Donde:
  UC = Use Case
  IACT = Proyecto
  MOD = Módulo (RPT, AUTH, ACC, etc.)
  NN = Número secuencial (01-99)
  Nombre_Descriptivo = Nombre en CamelCase con guiones bajos
  X_Y_Z = Versión semántica (MAJOR_MINOR_PATCH)
```

**Requisitos Funcionales:**

```
Formato: FR-MOD-UC-NN
Ejemplo: FR-RPT-01-07

Donde:
  FR = Functional Requirement
  MOD = Módulo
  UC = Número del UC del que deriva (01)
  NN = Número secuencial dentro del UC (07)
```

**Restricciones del Sistema:**

```
Formato: CNST-NNN
Ejemplo: CNST-005

Donde:
  CNST = Constraint
  NNN = Número secuencial (001-999)
```

**Agrupadores RBAC:**

```
Formato: AGR-NNN
Ejemplo: AGR-003

Donde:
  AGR = Agrupador
  NNN = Número secuencial (001-999)
```

**Funciones Atómicas RBAC:**

```
Formato: MOD-NNN
Ejemplo: RPT-001

Donde:
  MOD = Módulo (AUTH, RPT, ACC, etc.)
  NNN = Número secuencial (001-999)
  
Nombre: snake_case descriptivo
Ejemplo: ve_reportes, asigna_funciones, gestiona_sesiones
```

### 7.2 Estándares de Documentación

**STD_001 v1.1.0: Sin Emojis**

```
❌ PROHIBIDO:
  - ✅ ❌ ⚠️ (checkmarks, x, warnings)
  - 🚀 📁 💾 (iconos temáticos)
  - Cualquier emoji Unicode

✅ ALTERNATIVAS:
  - [OK], [ERROR], [WARN]
  - [INFO], [SUCCESS], [PENDING]
  - Texto descriptivo
```

**NOM_001 v2.0.0: Nomenclatura**

```
CAMBIOS v1.0 → v2.0:
  - Dígitos secuenciales: 2 → 3
  - Versionado: Opcional → OBLIGATORIO
  - Formato: _MAJOR_MINOR_PATCH
  - Prefijos: 17 → 27 tipos
  
EJEMPLO:
  v1.0: UC_RPT_01_Consultar_Reporte.rst
  v2.0: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
```

### 7.3 Glosario de Términos

```
BR (Business Rule):
  Política o decisión del negocio expresada en lenguaje natural

BReq (Business Requirement):
  Objetivo del negocio medible

UC (Use Case):
  Interacción observable entre actor y sistema

FR (Functional Requirement):
  Especificación técnica implementable

CNST (Constraint):
  Restricción arquitectónica del sistema

RTM (Requirements Traceability Matrix):
  Matriz de trazabilidad de requisitos

SoD (Segregation of Duties):
  Separación de responsabilidades

RBAC (Role-Based Access Control):
  Control de acceso basado en funciones atómicas

ETL (Extract, Transform, Load):
  Proceso de extracción, transformación y carga de datos

IVR (Interactive Voice Response):
  Sistema de respuesta de voz interactiva
```

### 7.4 Referencias Bibliográficas

**Libros:**

```
1. Cockburn, Alistair. "Writing Effective Use Cases" (2001)
   → Técnica de Larman, niveles de UC

2. Wiegers, Karl; Beatty, Joy. "Software Requirements" 3rd Ed. (2013)
   → IEEE 830, requisitos funcionales

3. Robertson, Suzanne; Robertson, James. "Mastering the Requirements Process" (2012)
   → Elicitación de requisitos, trazabilidad

4. Larman, Craig. "Applying UML and Patterns" 3rd Ed. (2004)
   → Técnica de Larman detallada
```

**Estándares:**

```
1. IEEE 830-1998: Recommended Practice for Software Requirements Specifications
   → Estructura de SRS, requisitos funcionales

2. ISO/IEC 25010:2011: Systems and software Quality Requirements and Evaluation (SQuaRE)
   → Características de calidad

3. INCOSE Systems Engineering Handbook v4 (2015)
   → Gestión de requisitos, trazabilidad
```

**Documentación del Proyecto:**

```
1. MODELO_RBAC_IACT_v5_1_1.md
   → 44 funciones atómicas, agrupadores, SoD

2. RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
   → 10 CNST detalladas

3. REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md
   → Estado congelado de CNST

4. NOM_001_Nomenclatura_Proyecto_v2_0_0.rst
   → Nomenclatura completa con versionado

5. STD_001_Estandares_Documentacion_v1_1_0.rst
   → Estándar sin emojis
```

### 7.5 Contacto y Soporte

**Canales de Ayuda:**

```
Dudas sobre el Material:
  - Email: team-iact@empresa.com
  - Slack: #iact-documentation
  - Wiki: confluence.empresa.com/iact

Validación de Requisitos:
  - Product Owner: po-iact@empresa.com
  - Tech Lead: techlead-iact@empresa.com

Revisión de Código:
  - Pull Requests: github.com/empresa/iact
  - Code Reviews: Viernes 10:00 AM
```

### 7.6 Control de Versiones de Este Documento

```
Versión 1.0.0 (2026-01-08):
  - Versión inicial completa
  - 7 secciones principales
  - Ejemplos 100% IACT (no químicos)
  - ~18,000 palabras

Cambios respecto a versión anterior:
  - Reescritura completa del dominio
  - Químicos → IACT (sistema IVR Analytics)
  - BR-028, BR-031, BR-046, BR-087, BR-053 como ejemplos principales
  - UC-IACT-RPT-01 como caso maestro
  - Integración con RBAC v5.1.1 y CNST v1.0
```

---

## CONCLUSIÓN

Este documento es el **puente** entre la teoría de ingeniería de requisitos y la práctica del proyecto IACT.

**Recuerda:**

1. **Los requisitos implícitos causan el 60% de los defectos** en proyectos de software
2. **Documentar BR es invertir en prevención**, no perder tiempo
3. **La jerarquía BR → BReq → UC → FR no es burocracia**, es comunicación estructurada
4. **Desencadenadores vs Inferencias** es la distinción más importante
5. **Trazabilidad desde el día 1** ahorra semanas de retrabajo

**Próximos Pasos:**

1. Lee PARTE 1 (Identificar Reglas de Negocio)
2. Documenta 3 BR reales de tu módulo
3. Valida con tu PO
4. Continúa con PARTE 2 (Transformar BR → UC)

**¡Buena suerte en tu aprendizaje!**

---

## APÉNDICE A: CASO ILUSTRATIVO COMPLETO

### Caso End-to-End: BR-IACT-028

```
┌──────────────────────────────────────────────────────────────┐
│         TRAZABILIDAD COMPLETA: BR-IACT-028                    │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  STAKEHOLDER:                                                 │
│  "El servidor Analytics se saturó 3 veces en Q3-2025.         │
│   Necesitamos prevenir que consultas grandes lo sobrecarguen."│
│                                                               │
│                           ↓ GENERA                            │
│                                                               │
│  BRQ-RPT-001: Prevenir Sobrecarga Servidor                   │
│  ═══════════════════════════════════════                     │
│  Métrica: 0 incidentes en Q1-2026                            │
│  KPI: CPU <80%, latencia p95 <3s                             │
│                                                               │
│                           ↓ SE IMPLEMENTA CON                 │
│                                                               │
│  BR-IACT-028: Aprobación Consultas Grandes                   │
│  ═══════════════════════════════════════════                 │
│  Tipo: Restricción                                            │
│  Enunciado: "Consultas >10K registros requieren aprobación"  │
│  Observable: Usuario ve modal de solicitud aprobación        │
│                                                               │
│                  ↓ TRANSFORMA EN (Patrón 1)                   │
│                                                               │
│  UC-IACT-RPT-01: Consultar Reporte Trimestral                │
│  ══════════════════════════════════════════                  │
│  Paso 7: Ejecuta COUNT(*)                                    │
│  Paso 8: Si count >10K → FA-1 (Requiere Aprobación)          │
│  FA-1: Sistema notifica supervisor, crea request             │
│                                                               │
│         ↓ DERIVA EN                                           │
│                                                               │
│  FR-RPT-01-07: Calcular COUNT(*) Antes de Query              │
│  ═══════════════════════════════════════════════            │
│  Query: SELECT COUNT(*) FROM analytics_calls WHERE...        │
│  Timeout: 5 segundos                                          │
│  Decisión: IF count > 10000 THEN solicitar_aprobacion()      │
│                                                               │
│         ↓ SE IMPLEMENTA EN                                    │
│                                                               │
│  reports/services.py                                          │
│  ════════════════════                                        │
│  def calculate_query_count(filters, user):                   │
│      query = "SELECT COUNT(*) FROM analytics_calls..."       │
│      count = execute(query, timeout=5)                       │
│      if count > 10000:                                       │
│          create_approval_request(user, filters, count)       │
│          return {'requires_approval': True, 'count': count}  │
│      return {'requires_approval': False, 'count': count}     │
│                                                               │
│         ↓ SE VALIDA CON                                       │
│                                                               │
│  tests/test_reports.py                                        │
│  ══════════════════════                                      │
│  def test_count_over_10k_requires_approval():                │
│      filters = create_large_query_filters()                  │
│      result = calculate_query_count(filters, user)          │
│      assert result['requires_approval'] == True              │
│      assert result['count'] > 10000                          │
│      assert ApprovalRequest.objects.filter(                 │
│          user=user, status='PENDING').exists()              │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

**Propagación de Cambios:**

Si PO cambia BR-IACT-028 de 10,000 a 5,000:

```
1. Actualizar BR-IACT-028: "consultas >10,000" → "consultas >5,000"
2. Actualizar UC-IACT-RPT-01 paso 8: "count > 10000" → "count > 5000"
3. Actualizar FR-RPT-01-07: "IF count > 10000" → "IF count > 5000"
4. Actualizar reports/services.py línea 47: "if count > 10000:" → "if count > 5000:"
5. Actualizar tests/test_reports.py: Casos con 8000 ahora fallan, ajustar a 4000/6000
6. Ejecutar tests: Validar que cambio es correcto
7. Commit con mensaje: "BR-IACT-028: Cambiar umbral de 10K a 5K registros"
```

---

## APÉNDICE B: CHECKLIST DE PREPARACIÓN

**Antes de Empezar PARTE 1:**

```
□ He leído PARTE 0 completa
□ Entiendo la jerarquía BR → BReq → UC → FR
□ Entiendo los 5 tipos de BR
□ Entiendo Desencadenadores vs Inferencias
□ Tengo acceso a stakeholders para validar BR
□ Tengo herramientas configuradas (editor, templates)
□ He reservado 8-10 horas para PARTE 1
```

**Antes de Empezar PARTE 2:**

```
□ He completado PARTE 1
□ He documentado al menos 5 BR reales
□ He validado BR con PO
□ Entiendo los 5 patrones de transformación
□ Tengo templates de UC listos
□ He reservado 12-15 horas para PARTE 2
```

---

**FIN DE PARTE 0**

**Ubicación:** /tmp/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md  
**Versión:** 1.0.0  
**Fecha:** 2026-01-08  
**Próximo Paso:** Leer PARTE 1 - Identificar Reglas de Negocio

---

