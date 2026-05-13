# ANÁLISIS INTEGRADO: PARTES 0, 1 Y 2 vs PROYECTO IACT

**Documento:** Análisis Consolidado de Desconexión Pedagógica  
**Fecha:** 2025-01-08  
**Alcance:** base_cognitiva/ COMPLETO (PARTES 0, 1, 2)  
**Problema:** Desconexión sistemática entre pedagogía (Químicos) y proyecto real (IVR)

---

## RESUMEN EJECUTIVO 🚨

### El Patrón Sistemático Confirmado

**HALLAZGO CENTRAL:**

Las PARTES 0, 1 y 2 usan **EL MISMO CONJUNTO DE EJEMPLOS PEDAGÓGICOS** de manera repetitiva:
- Mismo dominio: Gestión de Químicos en Laboratorio Universitario
- Mismos Business Rules: BR-028, BR-031, BR-046, BR-060, BR-087
- Mismos Casos de Uso: UC-04, UC-07, UC-09, UC-10
- Mismas entidades: Contenedor, ProductoQuimico, Propietario
- Mismos actores: Solicitante, Coordinador de Seguridad

**ESTO NO ES COINCIDENCIA - ES UN SISTEMA PEDAGÓGICO COMPLETO**

El problema NO es que cada parte use químicos por separado.  
El problema es que **todo el material pedagógico está construido sobre UN SOLO CASO DE ESTUDIO** (químicos) que NO tiene relación con el proyecto real (IVR).

---

## VISTA PANORÁMICA: TRACKING DE EJEMPLOS

### Tabla Maestra de Ejemplos Pedagógicos

| Ejemplo | PARTE 0 | PARTE 1 | PARTE 2 | Total Apariciones | Dominio |
|---------|---------|---------|---------|-------------------|---------|
| **BR-028** "Solicitudes >$500" | ✓ Intro | ⭐ Ejemplo central | ⭐⭐⭐ 15+ refs | 20+ | Químicos ❌ |
| **BR-031** "Notificar vencimiento" | ✓ Intro | ⭐ Desencadenador | ⭐⭐⭐ 20+ refs | 30+ | Químicos ❌ |
| **BR-046** "Marcar caduco" | ✓ Intro | ⭐ Inferencia | ⭐⭐ 10+ refs | 15+ | Químicos ❌ |
| **BR-060** "Descuento volumen" | ✓ Intro | ⭐ Cálculo | ⭐⭐ 8+ refs | 12+ | Químicos ❌ |
| **BR-087** "Certificación OSHA" | ✓ Intro | ⭐ Restricción | ⭐⭐⭐ 12+ refs | 18+ | Químicos ❌ |
| **UC-04** "Solicitar Químico" | ✓ Mención | ⭐ Ejemplo | ⭐⭐⭐ 25+ refs | 35+ | Químicos ❌ |
| **UC-07** "Notificar Vencimiento" | ✓ Mención | ⭐ Generado | ⭐⭐⭐⭐ 30+ refs | 40+ | Químicos ❌ |
| **Contenedor** (entidad) | ✓ Modelo | ⭐ Hecho | ⭐⭐⭐⭐ 40+ refs | 55+ | Químicos ❌ |
| **Propietario** (actor) | ✓ Rol | ⭐ Actor | ⭐⭐⭐ 20+ refs | 30+ | Químicos ❌ |
| **Coordinador Seguridad** | ✓ Rol | ⭐ Actor | ⭐⭐⭐ 15+ refs | 25+ | Químicos ❌ |

**Leyenda:**
- ⭐ = Ejemplo usado
- ⭐⭐ = Ejemplo central de sección
- ⭐⭐⭐ = Ejemplo guía de metodología completa
- ⭐⭐⭐⭐ = Ejemplo más crítico de todo el documento

### Distribución Acumulada de Referencias

```
PARTE 0 (30 páginas):
  Referencias a químicos: ~25 (introducción de conceptos)

PARTE 1 (50 páginas):
  Referencias a químicos: ~60 (ejemplos de 5 tipos de BR)

PARTE 2 (150 páginas):
  Referencias a químicos: ~150+ (transformación completa)

TOTAL: 235+ referencias al dominio de químicos
TOTAL: 0 referencias al dominio IVR/IACT real
```

---

## ANÁLISIS POR PARTE

### PARTE 0: INTRODUCCIÓN Y JERARQUÍA (30 páginas)

**Propósito:** Establecer contexto y presentar jerarquía de documentación

**Ejemplos Pedagógicos Introducidos:**

1. **Primer contacto con el dominio:**
   - Línea ~150: "Ejemplo: Sistema de gestión de químicos en laboratorio universitario"
   - Línea ~200: "BR-028: Solicitudes de compra que excedan $500..."
   - Línea ~250: "UC-04: Solicitar Producto Químico"

2. **Establecimiento del caso de estudio:**
   - Entidades mencionadas: Contenedor, ProductoQuimico, Usuario, Departamento
   - Actores introducidos: Solicitante, Coordinador, Gerente
   - Procesos descritos: Solicitud, Aprobación, Notificación

**Función en PARTE 0:**
- Introducir el sistema pedagógico
- Dar contexto para PARTE 1 y 2
- Establecer la narrativa del caso de estudio

**Problema:**
- ✅ Metodología general correcta
- ❌ Introduce dominio de químicos como "el ejemplo" que se usará
- ❌ No menciona que es SOLO pedagógico, no del proyecto real
- ❌ Desarrollador asume que estos ejemplos son del proyecto IACT

**Desconexión con IACT:**
- 0 menciones de IVR, llamadas, agentes, colas
- 0 referencias a los 49 UC reales del proyecto
- 0 referencias a las 20 BR reales del proyecto

---

### PARTE 1: IDENTIFICAR REGLAS DE NEGOCIO (50 páginas)

**Propósito:** Enseñar a identificar y clasificar Business Rules en 5 tipos

**Ejemplos Pedagógicos CENTRALES:**

| Tipo BR | Ejemplo PARTE 1 | Líneas | Apariciones |
|---------|----------------|--------|-------------|
| **Tipo 1: Hecho** | BR-012 "Código de barras único" | 800-900 | 8+ |
| **Tipo 2: Restricción** | BR-028 "Aprobación >$500" | 1200-1400 | 12+ |
| **Tipo 2: Restricción** | BR-087 "Certificación OSHA" | 1500-1700 | 10+ |
| **Tipo 3: Desencadenador** | BR-031 "Notificar vencimiento" | 1800-2100 | 15+ |
| **Tipo 4: Inferencia** | BR-046 "Marcar caduco" | 2200-2400 | 8+ |
| **Tipo 5: Cálculo** | BR-060 "Descuento volumen" | 2500-2700 | 6+ |

**Desarrollo Completo de BR-031 (ejemplo):**

```
PARTE 1 (Líneas 1800-2100):

BR-031 (DESENCADENADOR):
  "SI un contenedor de químico alcanza su fecha de vencimiento 
   ENTONCES el sistema debe notificar por email al propietario 
   del contenedor y al coordinador de seguridad con 30 días 
   de anticipación"

Clasificación: Tipo 3 - Desencadenador
Justificación: Tiene patrón SI-ENTONCES + comportamiento observable
Fuente: Política de Seguridad de Laboratorio v4.1
```

**Función en PARTE 1:**
- Enseñar los 5 tipos de BR con ejemplos concretos
- Mostrar cómo clasificar cada tipo
- Establecer plantillas de documentación

**Problema:**
- ✅ Metodología de 5 tipos correcta y completa
- ✅ Criterios de clasificación claros
- ❌ TODOS los ejemplos (15+) son del dominio de químicos
- ❌ NO hay ejemplos del dominio IVR real

**Equivalentes IACT que deberían usarse:**

| BR PARTE 1 (Químicos) | BR Real IACT (IVR) |
|----------------------|-------------------|
| BR-031 "Notificar vencimiento" | BR_002 "ETL Batch 2:00 AM" |
| BR-028 "Aprobación >$500" | BR_XXX "Exportación >100K requiere aprobación" |
| BR-087 "Certificación OSHA" | BR_007 "SoD: admin_usuarios ↔ auditor" |
| BR-046 "Marcar caduco" | BR_003 "Usuario inactivo >90d → Suspendido" |
| BR-060 "Descuento volumen" | BR_016 "Tasa_Abandono = (Abandon/Total)×100" |

---

### PARTE 2: TRANSFORMAR BR EN UC (150 páginas) ⭐⭐⭐

**Propósito:** Enseñar a transformar Business Rules en Casos de Uso y Functional Requirements

**Ejemplos Pedagógicos CENTRALES (DESARROLLO COMPLETO):**

#### Ejemplo Guía Central: BR-031 → UC-07

**PARTE 2 (Líneas 2500-3500):**

```
===============================================================================
BR-031 (DESENCADENADOR) - EJEMPLO GUÍA CENTRAL DE TODA PARTE 2
===============================================================================

Definición:
  "SI un contenedor de químico alcanza su fecha de vencimiento ENTONCES 
   el sistema debe notificar por email al propietario del contenedor y al 
   coordinador de seguridad con 30 días de anticipación"

⬇️ TRANSFORMACIÓN COMPLETA (200+ líneas)

UC-07: Notificar Vencimiento de Químico

IDENTIFICACIÓN
--------------
ID: UC-07
Nombre: Notificar Vencimiento de Químico
Actor Primario: Sistema (tiempo)
Trigger: Diario a las 00:00 horas

FLUJO NORMAL (11 pasos):
  1. Sistema verifica fecha actual
  2. Sistema consulta tabla Contenedores
  3. Sistema aplica filtro: DATEDIFF <= 30 días
  4. Para cada contenedor:
     4.1 Sistema obtiene propietario
     4.2 Sistema obtiene email
     4.3 Sistema obtiene coordinador
     4.4 Sistema obtiene email coordinador
     4.5 Sistema obtiene datos contenedor
     4.6 Sistema obtiene datos producto químico
     4.7 Sistema genera contenido email
     4.8 Sistema envía email propietario
     4.9 Sistema envía email coordinador
     4.10 Sistema registra notificación
  5. Sistema cuenta notificaciones
  6. Sistema registra en log
  7. Sistema finaliza

FLUJOS ALTERNOS (5 FA):
  FA-1: Sin Contenedores Próximos a Vencer
  FA-2: Contenedor sin Propietario Asignado
  FA-3: Email del Propietario Inválido
  FA-4: Error al Conectar con Servidor SMTP
  FA-5: Proceso Excede Tiempo Máximo

⬇️ DERIVACIÓN DE FR (9 FR generados)

RF-301: Obtener Fecha Actual del Servidor
RF-302: Consultar Contenedores Activos
RF-303: Filtrar Contenedores Próximos a Vencer (30 días)
RF-304: Obtener Propietario Actual del Contenedor
RF-305: Validar y Extraer Email del Usuario
RF-306: Obtener Coordinador de Seguridad del Laboratorio
RF-307: Generar Contenido de Email con Plantilla
RF-308: Enviar Email vía Protocolo SMTP
RF-309: Registrar Timestamp de Notificación Enviada

⬇️ TRAZABILIDAD COMPLETA

BR-031 → UC-07 → RF-301..309 → ExpirationNotificationService.java
```

**Apariciones de este ejemplo en PARTE 2:**
- Sección 1 (Introducción): 3 referencias
- Sección 3 (Patrón 3 - Desencadenador): 200+ líneas COMPLETAS
- Sección 4 (Construcción): 5 referencias
- Sección 5 (Integración): 4 referencias
- Sección 6 (Derivación FR): 15 referencias
- Sección 7 (Trazabilidad): 8 referencias
- **TOTAL: 30+ referencias, 1 desarrollo completo de 200+ líneas**

#### Otros Ejemplos Frecuentes en PARTE 2

**UC-04: Solicitar Producto Químico (25+ referencias)**

```
PARTE 2 usa UC-04 para ejemplificar:
- Sección 2.1: Componentes de UC
- Sección 3.2: Integración de Restricciones (BR-028, BR-087)
- Sección 4: Proceso de construcción (7 pasos)
- Sección 5: Integración de 5 BR en un solo UC
- Sección 6: Derivación de FR de pasos

Flujo Normal (12 pasos):
  1. Usuario selecciona "Nueva Solicitud"
  2. Sistema muestra catálogo de productos químicos
  3. Usuario selecciona producto
  4. Usuario especifica cantidad
  5. Sistema obtiene precio
  6. Sistema calcula subtotal
  7. Sistema calcula descuento [BR-060]
  8. Sistema muestra desglose
  9. Usuario confirma
  10. Sistema verifica monto >$500 [BR-028]
  11. SI monto <=500: Aprobar / SINO: Enviar a aprobación [BR-028]

BR Integradas:
  - BR-012 (Hecho): Estructura Contenedor
  - BR-087 (Restricción): Certificación OSHA
  - BR-028 (Restricción): Aprobación >$500
  - BR-060 (Cálculo): Descuento volumen
  - BR-046 (Inferencia): Marcar reservado
```

**BR-087: Certificación OSHA (12+ referencias)**

```
PARTE 2 usa BR-087 para ejemplificar:
- Sección 3.2: Patrón de Restricciones → Precondiciones
- Sección 4.4: Establecer precondiciones
- Sección 5: Integración en múltiples UC
- Sección 8.1: Una BR afecta múltiples UC

BR-087 afecta:
  - UC-04 (Solicitar): Precondición condicional
  - UC-12 (Transferir): Precondición
  - UC-15 (Registrar): Validación
  - UC-18 (Modificar): Precondición
  - UC-22 (Eliminar): Precondición
```

**Función en PARTE 2:**
- Enseñar los 5 patrones de transformación BR → UC
- Mostrar construcción completa de UC (7 pasos)
- Derivar FR sistemáticamente
- Establecer trazabilidad bidireccional

**Problema CRÍTICO:**
- ✅ Metodología impecable (5 patrones + 7 pasos construcción)
- ✅ Ejemplos MUY detallados y completos
- ❌ TODOS los ejemplos principales son químicos
- ❌ UC-07 (200+ líneas) es el ejemplo CENTRAL que todo el equipo leerá
- ❌ Aparece 30+ veces en diferentes contextos
- 🔴 **MÁXIMA PRIORIDAD PARA REESCRITURA**

---

## EL CASO DE ESTUDIO PEDAGÓGICO COMPLETO

### Sistema de Gestión de Químicos - Visión Integral

**Las PARTES 0, 1 y 2 construyen JUNTAS un caso de estudio completo:**

#### Modelo de Dominio (de PARTE 1 - Hechos)

```
ENTIDADES PRINCIPALES:

ProductoQuimico
  - id: INTEGER PK
  - nombre: STRING
  - nombre_cientifico: STRING
  - numero_cas: STRING UNIQUE
  - clase_peligrosidad: INTEGER (1-9)
  - precio_actual: DECIMAL

Contenedor
  - id: INTEGER PK
  - codigo_barras: STRING UNIQUE IMMUTABLE [BR-012]
  - producto_quimico_id: INTEGER FK
  - fecha_vencimiento: DATE
  - cantidad_actual: DECIMAL
  - estado: ENUM (ACTIVO, CADUCO, ELIMINADO)

Usuario
  - id: INTEGER PK
  - nombre: STRING
  - email: STRING
  - rol: ENUM (Solicitante, Gerente, Coordinador, Admin)
  - departamento_id: INTEGER FK

Certificacion
  - id: INTEGER PK
  - usuario_id: INTEGER FK
  - tipo: STRING ('OSHA')
  - vigencia_hasta: DATE [BR-087]

Solicitud
  - id: INTEGER PK
  - solicitante_id: INTEGER FK
  - producto_id: INTEGER FK
  - cantidad: DECIMAL
  - monto_total: DECIMAL
  - estado: ENUM (Aprobada, Pendiente, Rechazada)
```

#### Business Rules (de PARTE 1)

```
20 Business Rules identificadas:

HECHOS (5):
  BR-012: Código de barras único e inmutable
  BR-015: Relación 1:N Producto-Contenedores
  BR-018: Relación M:N Producto-Proveedores
  BR-022: Orden tiene mínimo 1 item
  ...

RESTRICCIONES (6):
  BR-028: Solicitudes >$500 requieren aprobación gerencial
  BR-087: Solo certificados OSHA solicitan peligrosos clase 1-4
  BR-101: Matriz de Roles y Permisos (5 roles × 10 operaciones)
  BR-102: SLA 24 horas para procesamiento
  ...

DESENCADENADORES (3):
  BR-031: Notificar 30 días antes de vencimiento
  BR-043: Alertar stock <20% capacidad
  BR-055: Generar reporte mensual automático
  ...

INFERENCIAS (3):
  BR-046: Marcar contenedor como caduco al vencer
  BR-098: Marcar producto con requiere_reorden si stock bajo
  BR-115: Clasificar cliente como moroso si +3 facturas vencidas
  ...

CÁLCULOS (3):
  BR-060: Descuento por volumen (tabla decisión)
  BR-077: Costo envío (base + peso + distancia - descuento)
  BR-088: Prioridad solicitud (urgencia + clase peligrosidad)
  ...
```

#### Casos de Uso (de PARTE 2)

```
15 Casos de Uso derivados:

GESTIÓN DE SOLICITUDES:
  UC-04: Solicitar Producto Químico [BR-012,028,060,087]
  UC-09: Aprobar/Rechazar Solicitud [BR-028]
  UC-11: Cancelar Solicitud

GESTIÓN DE INVENTARIO:
  UC-12: Transferir Contenedor Entre Ubicaciones [BR-087]
  UC-15: Registrar Nuevo Contenedor [BR-012,087]
  UC-18: Modificar Datos de Contenedor [BR-087]
  UC-22: Eliminar Contenedor [BR-087]

NOTIFICACIONES AUTOMÁTICAS:
  UC-07: Notificar Vencimiento de Químico [BR-031]
  UC-28: Alertar Inventario Crítico Bajo [BR-043]

REPORTES:
  UC-10: Procesar Orden de Compra [BR-060,077]
  UC-20: Procesar Pago con Tarjeta
  UC-30: Generar Reporte Mensual [BR-055]

CONTROL DE ACCESO:
  UC-25: Gestionar Usuarios [BR-101]
  UC-26: Configurar Sistema

BIBLIOTECA (Ejercicio 4):
  UC-31: Solicitar Préstamo de Libro [BR-402]
  UC-32: Notificar Devolución Pendiente [BR-403]
  UC-33: Procesar Devolución [BR-404]
```

#### Actores del Sistema

```
5 Actores Principales:

1. Solicitante
   - Solicita productos químicos
   - Consulta disponibilidad
   - Cancela solicitudes propias

2. Gerente de Departamento
   - Aprueba solicitudes >$500
   - Supervisa inventario
   - Gestiona personal

3. Coordinador de Seguridad
   - Supervisa químicos peligrosos
   - Valida certificaciones OSHA
   - Recibe notificaciones críticas
   - Gestiona eliminación de químicos caducos

4. Administrador
   - Gestiona usuarios y roles
   - Configura sistema
   - Acceso completo

5. Sistema (tiempo)
   - Ejecuta notificaciones periódicas
   - Genera reportes automáticos
   - Sincroniza con sistemas externos
```

### Procesos Principales del Sistema

```
PROCESO 1: Solicitud de Producto Químico
  1. Solicitante busca producto → UC-04 inicio
  2. Sistema verifica certificación OSHA → BR-087
  3. Sistema calcula costo con descuento → BR-060
  4. Sistema verifica umbral $500 → BR-028
  5a. SI <=500: Aprueba automáticamente
  5b. SI >500: Envía a gerente → UC-09
  6. Sistema marca contenedor reservado → BR-046
  7. Sistema actualiza inventario

PROCESO 2: Gestión de Vencimientos
  1. Sistema diario 00:00 → UC-07 inicio
  2. Sistema filtra vencimientos 30 días → BR-031
  3. Sistema envía emails a propietarios
  4. Sistema envía emails a coordinador
  5. Al vencer: Sistema marca caduco → BR-046

PROCESO 3: Control de Inventario
  1. Sistema monitorea stock → UC-28
  2. SI stock <20%: Genera alerta → BR-043
  3. Sistema notifica a compras
  4. Cuando llega mercancía: UC-15 (Registrar)
```

---

## IMPACTO ACUMULADO DE LA DESCONEXIÓN

### Distribución de Contenido por Dominio

```
TOTAL base_cognitiva/ (PARTES 0+1+2):
  - Páginas totales: 230
  - Líneas totales: ~8,000
  
CONTENIDO POR TIPO:

Metodología Pura (sin ejemplos específicos): ~2,000 líneas (25%)
  ✓ Teoría, definiciones, principios
  ✓ NO depende de dominio específico
  ✓ Reutilizable as-is

Ejemplos del Dominio Químicos: ~5,300 líneas (66%)
  ❌ Business Rules de químicos
  ❌ Casos de Uso de químicos
  ❌ Entidades químicas
  ❌ Procesos de laboratorio
  ❌ Actores de laboratorio

Ejemplos Genéricos: ~700 líneas (9%)
  ⚠️ Ejemplos abstractos aplicables a múltiples dominios
  ⚠️ Pero sin conexión explícita con IACT

CONTENIDO DEL PROYECTO IACT: 0 líneas (0%)
  ❌ NO hay ejemplos de llamadas IVR
  ❌ NO hay ejemplos de colas telefónicas
  ❌ NO hay ejemplos de agentes
  ❌ NO hay ejemplos de métricas IVR
  ❌ NO hay ejemplos de pipelines ETL
```

### Frecuencia Acumulada de Ejemplos

| Ejemplo | PARTE 0 | PARTE 1 | PARTE 2 | TOTAL | Criticidad |
|---------|---------|---------|---------|-------|-----------|
| **BR-031** Notificar vencimiento | 1 | 15 | 20 | **36** | ⭐⭐⭐⭐ |
| **UC-07** Notificar Vencimiento | 1 | 5 | 30 | **36** | ⭐⭐⭐⭐ |
| **UC-04** Solicitar Químico | 1 | 8 | 25 | **34** | ⭐⭐⭐⭐ |
| **Contenedor** (entidad) | 3 | 15 | 40 | **58** | ⭐⭐⭐⭐ |
| **BR-028** Aprobación >$500 | 1 | 12 | 15 | **28** | ⭐⭐⭐ |
| **BR-087** Certificación OSHA | 1 | 10 | 12 | **23** | ⭐⭐⭐ |
| **BR-060** Descuento volumen | 0 | 6 | 8 | **14** | ⭐⭐ |
| **BR-046** Marcar caduco | 0 | 8 | 10 | **18** | ⭐⭐ |
| **Propietario** (actor) | 2 | 10 | 20 | **32** | ⭐⭐⭐ |
| **Coordinador Seguridad** | 2 | 8 | 15 | **25** | ⭐⭐⭐ |

**Total de referencias a dominio químicos:** 304+

### Impacto en Desarrollador

**Escenario típico de uso:**

```
DÍA 1: Desarrollador nuevo lee PARTE 0
  - Aprende jerarquía documental
  - Se introduce al "sistema de ejemplo": Químicos
  - Asume que estos son los UC/BR del proyecto

DÍA 2-3: Desarrollador lee PARTE 1
  - Aprende a identificar Business Rules
  - Practica con BR-028, BR-031, BR-046, BR-060, BR-087
  - TODOS los ejercicios usan químicos
  - Domina la taxonomía de 5 tipos... con ejemplos de químicos

DÍA 4-7: Desarrollador lee PARTE 2 (la más extensa)
  - Aprende transformación BR → UC → FR
  - Estudia UC-07 en detalle (200 líneas, ejemplo central)
  - Practica derivación de FR con ejemplos de químicos
  - Completa ejercicios... todos de químicos o biblioteca

DÍA 8: Desarrollador abre el código del proyecto IACT
  - Ve: call_id, agente_id, duracion_segundos, tasa_abandono
  - Pregunta: "¿Dónde está UC-04? ¿Dónde está BR-028?"
  - Confusión: "¿Por qué no hay contenedores ni productos químicos?"
  - Descubre: "Ah... todo lo que leí era pedagógico, no del proyecto real"

DÍA 9-10: Desarrollador hace "traducción mental"
  - Contenedor → Llamada
  - Propietario → Agente
  - Vencimiento → Timeout/Fallo
  - Certificación OSHA → Rol RBAC
  - $500 → 10,000 registros
  - UC-07 Notificar Vencimiento → ??? (UC_PIP_01 o UC_ALR_01)

SEMANAS 2-3: Desarrollador sigue traduciendo mentalmente
  - Cada vez que consulta documentación: Traducir químicos → IVR
  - Doble esfuerzo cognitivo
  - Riesgo de malinterpretación
  - Frustración creciente

RESULTADO:
  - Onboarding 30-40% más lento
  - Errores de interpretación
  - Documentación percibida como "no útil"
```

---

## MAPEO CONCEPTUAL MAESTRO: QUÍMICOS ↔ IVR

### Tabla de Equivalencias Completa

| Categoría | Concepto Químicos | Concepto IVR/IACT | Justificación del Mapeo |
|-----------|-------------------|-------------------|------------------------|
| **ENTIDADES CENTRALES** |
| Principal | Contenedor de químico | Llamada telefónica | Unidad básica de gestión, tiene ID único, estado, timestamp |
| Clasificador | ProductoQuimico | Cola / Tipo de llamada | Categoriza la unidad principal, múltiples instancias |
| Secundaria | Ubicación | Agente / Extension | Dónde se encuentra/procesa |
| **PERSONAS/ROLES** |
| Usuario normal | Propietario / Solicitante | Analista / Usuario | Persona que usa el sistema, permisos limitados |
| Supervisor | Coordinador de Seguridad | Coordinador Técnico / Supervisor | Supervisión, permisos elevados, recibe alertas |
| Aprobador | Gerente de Departamento | Supervisor / Jefe de Área | Aprueba operaciones críticas, decisión final |
| Admin | Administrador | Administrador | Control total del sistema |
| **CREDENCIALES** |
| Autorización | Certificación OSHA | Rol RBAC / Permiso | Qué puede hacer el usuario, restricciones de acceso |
| Badge | Badge activo | Token de sesión activo | Validación de acceso vigente |
| **ATRIBUTOS TEMPORALES** |
| Límite temporal | fecha_vencimiento | timestamp_fin / timeout | Cuándo expira/termina |
| Anticipación | 30 días antes de vencer | 24 horas / Tiempo real | Ventana de alerta |
| Periodicidad | Diario 00:00 | Cada hora / Batch 02:00 AM | Frecuencia de proceso automático |
| **ATRIBUTOS CUANTITATIVOS** |
| Identificador | codigo_barras | call_id / session_id | ID único e inmutable |
| Medida principal | cantidad_actual | duracion_segundos | Métrica cuantitativa principal |
| Clasificación | clase_peligrosidad (1-9) | prioridad / severidad | Niveles de importancia/urgencia |
| **ESTADOS** |
| Activo | ACTIVO | ACTIVA / EN_PROCESO | En uso normal |
| Finalizado | CADUCO / VENCIDO | FINALIZADA / COMPLETADA | Ya no se usa |
| Crítico | PELIGROSO (clase 1-4) | CRITICA / ALTA_PRIORIDAD | Requiere atención especial |
| **UMBRALES** |
| Umbral monetario | $500 | 10,000 registros / CPU >80% | Límite que dispara acción especial |
| Umbral porcentual | Stock <20% capacidad | Disponibilidad <80% / Eficiencia <85% | Métrica de capacidad/rendimiento |
| Umbral temporal | 30 días | 120 segundos / 24 horas | Límite de tiempo |
| **ACCIONES/PROCESOS** |
| Solicitud básica | Solicitar producto químico | Consultar reporte / Ver dashboard | Acción principal del usuario |
| Notificación | Notificar vencimiento | Generar alerta / Notificar umbral | Aviso automático del sistema |
| Transferencia | Transferir contenedor | Reasignar llamada / Cambiar estado | Operación de cambio |
| Aprobación | Aprobar solicitud | Aprobar configuración / Validar cambio | Flujo de autorización |
| Registro | Registrar contenedor | Ingestar llamada (ETL) / Registrar evento | Creación de nueva entidad |
| **MÉTRICAS/CÁLCULOS** |
| Fórmula simple | Descuento = cantidad × % | Tasa_Abandono = (Abandon/Total)×100 | Cálculo matemático directo |
| Fórmula compleja | Costo = base + peso + distancia - desc | Índice_Eficiencia = (Atendidas/Total)×100 | Cálculo con múltiples variables |
| Tabla decisión | Descuento por volumen (4 rangos) | Prioridad por duración (3 niveles) | Decisión basada en rangos |
| **CONDICIONES LÓGICAS** |
| Umbral simple | SI monto >$500 | SI registros >10,000 | Comparación directa |
| Umbral temporal | SI días_restantes <=30 | SI cpu_alto >5_minutos | Condición con tiempo |
| Condición compuesta | SI (clase<=4 AND sin_cert) | SI (tasa>15% AND periodo>24h) | Múltiples condiciones con AND/OR |
| **INFERENCIAS** |
| Cambio de estado | Marcar como caduco | Marcar como procesada / suspendida | Actualización automática de estado |
| Cálculo derivado | Calcular requiere_reorden | Calcular estado_salud_sistema | Valor derivado de otros datos |
| Clasificación | Clasificar como moroso | Clasificar como llamada_critica | Categorización automática |
| **NOTIFICACIONES** |
| Destinatario primario | Propietario | Analista / Agente | Quien recibe la notificación principal |
| Destinatario supervisor | Coordinador Seguridad | Coordinador Técnico | Quien supervisa y recibe copia |
| Canal | Email | In-app notification (NO email per CNST-001) | Medio de comunicación |
| **INTEGRACIONES** |
| Sistema externo | Servicio de Pago | API MySQL readonly | Servicio externo con que se integra |
| Protocolo | SMTP | SQL query / REST API | Tecnología de integración |
| **AUDITORÍA** |
| Log de evento | HistorialNotificaciones | user_action_log | Registro de auditoría |
| Timestamp | fecha_envio | created_at / timestamp | Cuándo ocurrió el evento |
| Inmutabilidad | Código barras no cambia | call_id inmutable / log sin UPDATE | Dato que nunca se modifica |

---

## EJEMPLOS DE REESCRITURA DIRECTA

### Ejemplo 1: BR-031 → BR_002

**ACTUAL (Químicos - PARTE 1 y 2):**

```
BR-031 (DESENCADENADOR)
Nombre: Notificación de Vencimiento de Químico

Definición:
  "SI un contenedor de producto químico alcanza su fecha de vencimiento 
   ENTONCES el sistema debe notificar por email al propietario del contenedor 
   y al coordinador de seguridad con 30 días de anticipación"

Tipo: Desencadenador

Justificación:
  - Patrón SI-ENTONCES claro
  - Comportamiento OBSERVABLE: propietario recibe email
  - Acción automática del sistema

Fuente: Política de Seguridad de Laboratorio v4.1, Artículo 8

Fecha Vigencia: 2024-01-01

Prioridad: Alta (seguridad)

⬇️ TRANSFORMACIÓN EN PARTE 2

UC-07: Notificar Vencimiento de Químico
  Actor: Sistema (tiempo)
  Trigger: Diario a las 00:00
  11 pasos en flujo normal
  5 flujos alternos
  9 FR derivados (RF-301 a RF-309)
```

**PROPUESTO (IVR - Reescritura):**

```
BR_002 (DESENCADENADOR)
Nombre: Proceso ETL Batch Nocturno

Definición:
  "SI el sistema alcanza las 02:00 AM en días laborables ENTONCES debe 
   ejecutar proceso ETL automático: extraer datos de MySQL operacional 
   (readonly), transformar según reglas de negocio, y cargar en PostgreSQL 
   analítico para reportes"

Tipo: Desencadenador

Justificación:
  - Patrón SI-ENTONCES claro
  - Comportamiento OBSERVABLE: datos aparecen en PostgreSQL, reportes se actualizan
  - Acción automática del sistema

Fuente: CNST-004 "Actualización ETL solo batch nocturno 2:00 AM"

Fecha Vigencia: 2024-06-01

Prioridad: Crítica (integridad de datos)

⬇️ TRANSFORMACIÓN EN PARTE 2

UC_PIP_01: Monitorear y Ejecutar ETL Batch

Actor Primario: Sistema (tiempo)

Trigger: Diario a las 02:00 AM (lunes a viernes)

Flujo Normal:
  1. Sistema verifica timestamp actual = 02:00 AM
  2. Sistema consulta tabla etl_config para obtener parámetros
  3. Sistema verifica que estado_ultima_ejecucion = 'COMPLETADA'
  4. Sistema extrae datos de MySQL (db_operacional_readonly):
     4.1 Sistema conecta a MySQL con usuario readonly
     4.2 Sistema ejecuta queries de extracción configuradas
     4.3 Sistema obtiene llamadas con fecha >= ultima_extraccion
     4.4 Sistema extrae: call_id, agente_id, cola_id, timestamps, duracion, resultado
  5. Sistema transforma datos según reglas de negocio:
     5.1 Sistema calcula duracion_segundos = timestamp_fin - timestamp_inicio
     5.2 Sistema clasifica resultado según códigos (COMPLETADA, ABANDONADA, TRANSFERIDA)
     5.3 Sistema valida integridad (call_id NOT NULL, duracion >= 0)
  6. Sistema carga datos transformados a PostgreSQL (db_analitico):
     6.1 Sistema conecta a PostgreSQL con usuario etl_writer
     6.2 Sistema inserta registros en tabla llamadas_historico
     6.3 Sistema actualiza tablas agregadas (métricas por día, hora, agente)
  7. Sistema registra resultado en etl_execution_log:
     - timestamp_inicio, timestamp_fin
     - registros_extraidos, registros_cargados
     - estado = 'COMPLETADA'
  8. Sistema actualiza estado_ultima_ejecucion = 'COMPLETADA'
  9. Sistema envía notificación in-app a Coordinador Técnico (éxito)
  10. Sistema finaliza

Flujos Alternos:
  FA-1: Error en Extracción de MySQL
    4a. MySQL no responde o conexión rechazada
    4b. Sistema registra error en log con detalle
    4c. Sistema espera 60 segundos
    4d. Sistema reintenta extracción (máximo 3 intentos)
    4e. Si todos fallan:
        - Sistema actualiza estado = 'FALLIDA_EXTRACCION'
        - Sistema envía alerta CRÍTICA a Coordinador Técnico
        - Sistema NO continúa con transformación ni carga
        - UC termina con error
  
  FA-2: Error en Transformación
    5a. Datos extraídos contienen inconsistencias (ej: duracion negativa)
    5b. Sistema registra registros problemáticos en tabla errores_etl
    5c. Sistema OMITE registros con error (no detiene proceso)
    5d. Sistema continúa con registros válidos
    5e. Si >10% son erróneos:
        - Sistema marca proceso como 'COMPLETADA_CON_ADVERTENCIAS'
        - Sistema envía alerta MEDIA a Coordinador
  
  FA-3: Error en Carga a PostgreSQL
    6a. PostgreSQL rechaza INSERT (constraint violation, timeout)
    6b. Sistema hace ROLLBACK de transacción
    6c. Sistema registra error detallado
    6d. Sistema reintenta carga (máximo 2 intentos)
    6e. Si todos fallan:
        - Sistema actualiza estado = 'FALLIDA_CARGA'
        - Sistema envía alerta CRÍTICA
        - UC termina con error (datos NO cargados)
  
  FA-4: Proceso Anterior Aún Ejecutándose
    3a. Sistema detecta estado_ultima_ejecucion = 'EN_PROCESO'
    3b. Sistema verifica timestamp_inicio de ejecución anterior
    3c. SI diferencia >2 horas (probablemente colgado):
        - Sistema marca anterior como 'FALLIDA_TIMEOUT'
        - Sistema continúa con nueva ejecución
    3d. SI diferencia <2 horas (aún en proceso):
        - Sistema registra en log: "Ejecución omitida - proceso previo activo"
        - UC termina sin ejecutar (esperará siguiente trigger)

Postcondiciones (éxito):
  - Datos de últimas 24h extraídos de MySQL
  - Datos transformados y validados
  - Datos cargados en PostgreSQL.llamadas_historico
  - Tablas agregadas actualizadas
  - Log de ejecución registrado con COMPLETADA
  - Coordinador notificado de éxito

Business Rules Aplicadas:
  - BR_002: Desencadenador ETL batch 02:00 AM
  - BR_001: call_id inmutable (validación en transformación)
  - CNST-003: MySQL readonly, PostgreSQL transaccional
  - CNST-004: Solo batch nocturno (no actualizaciones en vivo)

Frecuencia: Diaria (1 vez al día)

Volumen Esperado: 50,000-100,000 llamadas por día

⬇️ DERIVACIÓN DE FR

RF-PIPXXX: Extraer Datos de MySQL Operacional
  Query:
    SELECT call_id, agente_id, cola_id, timestamp_inicio, 
           timestamp_fin, resultado, metadata
    FROM llamadas
    WHERE DATE(timestamp_inicio) = CURDATE() - INTERVAL 1 DAY
      AND procesado_etl = FALSE
  
  Implementa: BR_002 (extracción)

RF-PIPYYY: Transformar y Validar Registros
  Algoritmo:
    FOR EACH record IN extracted_data:
      duracion = timestamp_fin - timestamp_inicio
      IF duracion < 0 THEN
        registrar_error(record, "Duración negativa")
        CONTINUE
      END IF
      resultado_normalizado = mapear_resultado(record.resultado)
      validar_call_id_unico(record.call_id)  # BR_001
      YIELD transformed_record
  
  Implementa: BR_002 (transformación) + BR_001 (validación)

RF-PIPZZZ: Cargar Datos a PostgreSQL Analítico
  Insert:
    BEGIN TRANSACTION;
    INSERT INTO llamadas_historico 
      (call_id, agente_id, cola_id, ...)
    VALUES (...);
    UPDATE metricas_diarias SET ...;
    COMMIT;
  
  Implementa: BR_002 (carga) + CNST-003 (PostgreSQL transaccional)

...
```

**Comparación:**

| Aspecto | BR-031 (Químicos) | BR_002 (IVR) |
|---------|-------------------|--------------|
| Trigger | Diario 00:00 | Diario 02:00 AM |
| Actor | Sistema (tiempo) | Sistema (tiempo) |
| Condición | 30 días antes vencimiento | Hora = 02:00 AM |
| Acción | Notificar por email | Ejecutar ETL (extraer, transformar, cargar) |
| Observable | Propietario recibe email | Datos aparecen en PostgreSQL |
| Complejidad | Media (11 pasos) | Alta (6 pasos principales, subpasos) |
| FR generados | 9 FR | 10+ FR |
| Líneas UC | ~200 | ~250 |

---

### Ejemplo 2: UC-04 → UC_RPT_01

**ACTUAL (Químicos - PARTE 2):**

```
UC-04: Solicitar Producto Químico

Actor Primario: Solicitante

Flujo Normal (12 pasos):
  1. Usuario selecciona "Nueva Solicitud"
  2. Sistema muestra catálogo de productos químicos
  3. Usuario selecciona producto
  4. Usuario especifica cantidad
  5. Sistema obtiene precio
  6. Sistema calcula subtotal
  7. Sistema calcula descuento [BR-060]
  8. Sistema muestra desglose
  9. Usuario confirma
  10. Sistema verifica monto >$500 [BR-028]
  11. SI <=500: Aprobar / SI >500: Enviar a aprobación

Business Rules:
  - BR-012: Código barras único
  - BR-087: Certificación OSHA
  - BR-028: Aprobación >$500
  - BR-060: Descuento volumen
  - BR-046: Marcar reservado

Aparece en PARTE 2: 25+ veces
```

**PROPUESTO (IVR - Reescritura):**

```
UC_RPT_01: Ver Dashboard Principal

Actor Primario: Analista

Precondiciones:
  - Usuario autenticado en sistema
  - Usuario tiene rol agr_analista o superior
  - Existen datos de llamadas en tabla llamadas_historico
  - ETL ha ejecutado al menos una vez (hay datos que mostrar)

Trigger: Usuario selecciona opción "Dashboard" del menú principal

Flujo Normal:
  1. Usuario accede a página de Dashboard
  
  2. Sistema verifica permisos del usuario:
     Sistema consulta roles del usuario
     Sistema valida que usuario.rol IN (agr_analista, agr_supervisor, agr_admin)
  
  3. Sistema obtiene parámetros de consulta:
     rango_temporal = últimas_24_horas (default)
     filtros = ninguno (default, mostrar todo)
  
  4. Sistema consulta métricas principales de llamadas:
     4.1 Sistema ejecuta query para total de llamadas:
         SELECT COUNT(*) FROM llamadas_historico 
         WHERE timestamp_inicio >= NOW() - INTERVAL 24 HOUR
     
     4.2 Sistema ejecuta query para llamadas atendidas:
         SELECT COUNT(*) FROM llamadas_historico 
         WHERE timestamp_inicio >= NOW() - INTERVAL 24 HOUR
           AND resultado = 'COMPLETADA'
     
     4.3 Sistema ejecuta query para llamadas abandonadas:
         SELECT COUNT(*) FROM llamadas_historico 
         WHERE timestamp_inicio >= NOW() - INTERVAL 24 HOUR
           AND resultado = 'ABANDONADA'
  
  5. Sistema calcula métricas derivadas según Business Rules:
     5.1 Sistema calcula Tasa de Abandono [BR_016]:
         tasa_abandono = (abandonadas / total) × 100
         Ejemplo: (150 / 1000) × 100 = 15.0%
     
     5.2 Sistema calcula Tiempo Promedio de Espera [BR_017]:
         SELECT AVG(tiempo_espera_segundos) FROM llamadas_historico
         WHERE timestamp_inicio >= NOW() - INTERVAL 24 HOUR
           AND tiempo_espera_segundos IS NOT NULL
     
     5.3 Sistema calcula Índice de Eficiencia [BR_018]:
         eficiencia = (atendidas / total) × 100
         Ejemplo: (850 / 1000) × 100 = 85.0%
  
  6. Sistema verifica umbrales críticos [BR_016, BR_017, BR_018]:
     6.1 SI tasa_abandono >15%:
         marcar_metrica_como_critica("Tasa Abandono", tasa_abandono)
     6.2 SI tiempo_espera_promedio >120 segundos:
         marcar_metrica_como_critica("Tiempo Espera", tiempo_promedio)
     6.3 SI eficiencia <85%:
         marcar_metrica_como_critica("Eficiencia", eficiencia)
  
  7. Sistema obtiene datos de gráfica de tendencia:
     SELECT DATE_FORMAT(timestamp_inicio, '%H:00') as hora,
            COUNT(*) as total,
            COUNT(*) FILTER (WHERE resultado='COMPLETADA') as atendidas,
            COUNT(*) FILTER (WHERE resultado='ABANDONADA') as abandonadas
     FROM llamadas_historico
     WHERE timestamp_inicio >= NOW() - INTERVAL 24 HOUR
     GROUP BY hora
     ORDER BY hora
  
  8. Sistema renderiza Dashboard con:
     - KPIs principales (Total, Atendidas, Abandonadas, Tasa %, Tiempo Espera, Eficiencia)
     - Indicadores visuales (verde/amarillo/rojo según umbrales)
     - Gráfica de tendencia últimas 24h
     - Top 5 Agentes por volumen
     - Top 5 Colas con más abandono
  
  9. Sistema muestra Dashboard al usuario
  
  10. Usuario visualiza métricas actualizadas

Flujos Alternos:
  FA-1: Sin Datos Disponibles
    4a. Sistema ejecuta queries pero todas retornan 0 registros
    4b. Sistema detecta que no hay datos en rango seleccionado
    4c. Sistema muestra mensaje: 
        "No hay datos disponibles para el período seleccionado.
         Verifique que ETL haya ejecutado correctamente."
    4d. Sistema muestra Dashboard con métricas en 0
    4e. UC termina (éxito sin datos)
  
  FA-2: Tasa de Abandono Crítica (>15%)
    6.1a. Sistema detecta tasa_abandono = 18.5% (>15%)
    6.1b. Sistema marca KPI con indicador ROJO
    6.1c. Sistema muestra tooltip: 
          "Tasa de Abandono CRÍTICA: 18.5% (umbral: 15%)"
    6.1d. SI usuario tiene permiso crear_alertas:
          Sistema muestra botón "Crear Alerta Automática"
    6.1e. Continuar flujo normal
  
  FA-3: Tiempo de Espera Crítico (>120s)
    6.2a. Sistema detecta tiempo_promedio = 145 segundos (>120)
    6.2b. Sistema marca KPI con indicador ROJO
    6.2c. Continuar flujo normal
  
  FA-4: Error al Consultar Base de Datos
    4a. PostgreSQL no responde o query falla (timeout, error de conexión)
    4b. Sistema registra error en log con stack trace
    4c. Sistema muestra mensaje al usuario:
        "Error al cargar datos. Intente nuevamente en unos momentos.
         Si el problema persiste, contacte soporte técnico."
    4d. Sistema muestra Dashboard con mensaje de error
    4e. UC termina con error (usuario NO puede ver métricas)
  
  FA-5: Usuario Cambia Rango Temporal
    *a. En cualquier momento, usuario selecciona diferente rango:
        - Últimas 1 hora
        - Últimas 24 horas (default)
        - Últimos 7 días
        - Mes actual
        - Personalizado (fecha inicio/fin)
    *b. Sistema actualiza parámetro rango_temporal
    *c. Retornar a paso 4 (recalcular con nuevo rango)

Postcondiciones:
  - Dashboard mostrado con métricas actualizadas
  - Métricas calculadas según BR_016, BR_017, BR_018
  - Umbrales críticos evaluados y marcados visualmente
  - Usuario puede visualizar estado actual del sistema
  - Log de acceso registrado (user_id, timestamp, dashboard_viewed)

Business Rules Aplicadas:
  - BR_016: Tasa de Abandono = (Abandonadas / Total) × 100 [Paso 5.1]
  - BR_017: Tiempo Promedio Espera [Paso 5.2]
  - BR_018: Índice de Eficiencia = (Atendidas / Total) × 100 [Paso 5.3]
  - CNST-003: Solo lectura de PostgreSQL analítico [Paso 4]

Requerimientos Especiales:
  - RNF-12: Tiempo de respuesta <2 segundos para queries
  - RNF-15: Caché de 30 segundos para evitar sobrecarga
  - RNF-18: Cifrado HTTPS para transmisión de datos

Frecuencia de Uso: Muy frecuente (200-300 accesos/día)

Prioridad: Alta (funcionalidad core del sistema)

⬇️ DERIVACIÓN DE FR

RF-RPT101: Consultar Total de Llamadas por Período
  Query:
    SELECT COUNT(*) as total_llamadas
    FROM llamadas_historico
    WHERE timestamp_inicio >= :fecha_inicio
      AND timestamp_inicio < :fecha_fin
  
  Optimización:
    - Índice en timestamp_inicio
    - Particionado de tabla por fecha

RF-RPT102: Calcular Tasa de Abandono
  Implementa: BR_016
  
  Query:
    SELECT 
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE resultado='ABANDONADA') as abandonadas,
      (COUNT(*) FILTER (WHERE resultado='ABANDONADA') * 100.0 / 
       NULLIF(COUNT(*), 0)) as tasa_abandono_pct
    FROM llamadas_historico
    WHERE timestamp_inicio >= :fecha_inicio
      AND timestamp_inicio < :fecha_fin
  
  Validación:
    - IF tasa_abandono_pct >15% THEN marcar_critico

RF-RPT103: Calcular Tiempo Promedio de Espera
  Implementa: BR_017
  
  Query:
    SELECT AVG(tiempo_espera_segundos) as tiempo_promedio_espera
    FROM llamadas_historico
    WHERE timestamp_inicio >= :fecha_inicio
      AND timestamp_inicio < :fecha_fin
      AND tiempo_espera_segundos IS NOT NULL
  
  Validación:
    - IF tiempo_promedio_espera >120 THEN marcar_critico

RF-RPT104: Calcular Índice de Eficiencia
  Implementa: BR_018
  
  Query:
    SELECT 
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE resultado='COMPLETADA') as atendidas,
      (COUNT(*) FILTER (WHERE resultado='COMPLETADA') * 100.0 / 
       NULLIF(COUNT(*), 0)) as indice_eficiencia_pct
    FROM llamadas_historico
    WHERE timestamp_inicio >= :fecha_inicio
      AND timestamp_inicio < :fecha_fin
  
  Validación:
    - IF indice_eficiencia_pct <85% THEN marcar_critico

RF-RPT105: Renderizar Dashboard con Datos
  Input:
    - metricas: objeto con total, atendidas, abandonadas, tasas
    - tendencia: array de datos por hora
    - top_agentes: array de agentes ordenados
  
  Output:
    - HTML renderizado con KPIs
    - Gráficas (Chart.js o similar)
    - Indicadores visuales (colores según umbrales)
  
  Framework: Django Templates o React
```

**Comparación:**

| Aspecto | UC-04 (Químicos) | UC_RPT_01 (IVR) |
|---------|------------------|-----------------|
| Longitud | 12 pasos | 10 pasos principales |
| Complejidad | Media | Alta (queries complejos) |
| BR integradas | 5 BR | 3 BR principales (cálculos) |
| Actor | Solicitante | Analista |
| Propósito | Crear solicitud | Visualizar métricas |
| Resultado | Solicitud registrada | Dashboard mostrado |
| FR generados | ~8 FR | 5 FR principales + subqueries |

---

## ESTRATEGIA DE REESCRITURA CONSOLIDADA

### Enfoque por Fases

**FASE 0: Decisión y Planificación (COMPLETADA ✓)**

Ya decidimos:
- ✓ Opción B: Reescritura completa con ejemplos IACT
- ✓ Nomenclatura: guion bajo `_` (formato v4.0.0)
- ✓ Mantener metodología, reemplazar ejemplos

**FASE 1: PARTE 0 (3-4 horas)**

Archivos a actualizar:
- `FND_00_Contexto_y_Jerarquia.rst`

Cambios:
- Reemplazar introducción del "sistema de químicos" con "sistema IVR"
- Actualizar primer ejemplo de BR-028 con BR de IACT
- Actualizar diagrama de jerarquía con referencias correctas

**FASE 2: PARTE 1 (10-14 horas) ⭐**

Archivos a actualizar:
- `MTM_01_BR_a_UC_Trazabilidad.rst` (6 referencias UC_010)
- `MTM_02_UC_a_FR_Trazabilidad.rst` (9 referencias UC_010)
- `MTM_03_Esquema_Trazabilidad.rst`

Cambios principales:
- Reescribir ejemplos de 5 tipos de BR con casos IACT
- BR-028 → BR_IACT_XXX (Exportación >100K)
- BR-031 → BR_002 (ETL Batch)
- BR-046 → BR_003 (Usuario Inactivo)
- BR-060 → BR_016 (Tasa Abandono)
- BR-087 → BR_007 (SoD)
- Actualizar tablas de ejemplos
- Actualizar diagramas PlantUML

**FASE 3: PARTE 2 (28-38 horas) ⭐⭐⭐**

Archivos a actualizar:
- `TXM_01_Nomenclatura_UC_FR.rst` (CRÍTICO: 4-5h)
- Probablemente otros archivos si tienen ejemplos pedagógicos extensos

Cambios principales (CRÍTICOS):

1. **UC-07 → UC_ALR_01 o UC_PIP_01** (6-8h)
   - Reescribir completamente el ejemplo de 200+ líneas
   - Actualizar las 30+ referencias
   - Reescribir los 9 FR derivados
   - Actualizar trazabilidad completa

2. **UC-04 → UC_RPT_01** (5-6h)
   - Reescribir flujo completo de 12 pasos
   - Actualizar las 25+ referencias
   - Reescribir integración de 5 BR
   - Actualizar ejercicios de construcción

3. **BR-087 → BR_007** (3-4h)
   - Reescribir ejemplo de SoD
   - Actualizar 12+ referencias
   - Reescribir integración en múltiples UC

4. **BR-060 → BR_016** (2-3h)
   - Reescribir cálculo de tabla decisión
   - Cambiar a fórmula de Tasa de Abandono

5. **Ejercicio 4: Biblioteca → Sistema IACT** (4-5h)
   - Reescribir caso completo con 4 BR + 3 UC del proyecto

6. **Otros ejemplos menores** (8-12h)
   - UC-09, UC-10, UC-12, UC-15, UC-20, UC-28
   - BR-046, BR-012, BR-101, BR-102
   - Actualizar referencias cruzadas

### Estimación Total Consolidada

| Fase | Componente | Archivos | Horas Min | Horas Max |
|------|-----------|----------|-----------|-----------|
| 0 | ✓ Decisión | - | - | - |
| 1 | PARTE 0 | FND_00 | 3h | 4h |
| 2 | PARTE 1 | MTM_01, MTM_02, MTM_03 | 10h | 14h |
| 3 | PARTE 2 | TXM_01 + otros | 28h | 38h |
| **TOTAL** | **PARTES 0+1+2** | **~5-7 archivos** | **41h** | **56h** |

**Distribución del esfuerzo:**
- Reescritura de ejemplos: 30-40h (70%)
- Actualización de referencias: 8-12h (20%)
- Validación Sphinx: 3-4h (10%)

### Priorización por Impacto

| Prioridad | Ejemplo a Reescribir | Razón | Horas | Fase |
|-----------|---------------------|-------|-------|------|
| ⭐⭐⭐⭐ | UC-07 → UC_ALR_01 | Ejemplo CENTRAL de PARTE 2, 30+ refs, 200+ líneas | 6-8h | 3 |
| ⭐⭐⭐⭐ | UC-04 → UC_RPT_01 | Ejemplo más usado, integra 5 BR, 25+ refs | 5-6h | 3 |
| ⭐⭐⭐ | BR-031 → BR_002 | Desencadenador principal, genera UC-07 | 2h | 2 |
| ⭐⭐⭐ | BR-087 → BR_007 | Restricción más usada, 12+ refs | 3-4h | 2 |
| ⭐⭐⭐ | BR-028 → BR_XXX | Segundo ejemplo más usado, 15+ refs | 2-3h | 2 |
| ⭐⭐ | BR-060 → BR_016 | Cálculo principal | 2-3h | 2 |
| ⭐⭐ | BR-046 → BR_003 | Inferencia | 2h | 2 |
| ⭐⭐ | Ejercicio 4 | Caso completo de práctica | 4-5h | 3 |
| ⭐ | Ejemplos menores | UC-09, 10, 12, 15, 20, 28, etc. | 10-15h | 2-3 |

---

## PRÓXIMOS PASOS INMEDIATOS

### Decisión Requerida del Usuario

**¿Confirmamos proceder con Reescritura Completa de PARTES 0, 1 y 2?**

Opciones:

**A) SÍ - Reescritura Completa (RECOMENDADO ✅)**
- Eliminar 100% referencias a químicos
- Reemplazar con ejemplos IACT (IVR) reales
- Mantener toda la metodología
- Inversión: 41-56 horas
- Resultado: Documentación coherente end-to-end

**B) NO - Mantener Químicos**
- Dejar ejemplos pedagógicos como están
- Asumir que equipo hace "traducción mental"
- Inversión: 0 horas
- Riesgo: Confusión continua, onboarding lento

**C) HÍBRIDO - Mantener Químicos + Agregar Paralelo IACT**
- Mantener ejemplos de químicos
- Agregar sección separada con ejemplos IACT paralelos
- Formato: Cada ejemplo tiene versión genérica + versión IACT
- Inversión: 50-70 horas (más complejo)
- Longitud final: +50% (345 páginas)

### Plan de Ejecución (si Opción A)

**Orden recomendado:**

1. **Semana 1: PARTE 0 + Comenzar PARTE 1**
   - Reescribir FND_00 (3-4h)
   - Reescribir ejemplos principales de 5 tipos en MTM_01, MTM_02 (6-8h)

2. **Semana 2: Completar PARTE 1**
   - Finalizar MTM_01, MTM_02, MTM_03 (4-6h)
   - Validación Sphinx (1h)

3. **Semana 3-4: PARTE 2 - Ejemplos Críticos**
   - UC-07 → UC_ALR_01 (6-8h)
   - UC-04 → UC_RPT_01 (5-6h)
   - BR-087, BR-028, BR-060 actualizados (5-8h)

4. **Semana 5: PARTE 2 - Ejemplos Menores**
   - Ejercicio 4 reescrito (4-5h)
   - Otros UC menores (6-8h)

5. **Semana 6: Validación Final**
   - Build Sphinx completo
   - Verificar 0% referencias a químicos
   - Confirmar coherencia con MODELO_DOCUMENTAL_IACT
   - Testing con equipo

**Cronograma:** 6 semanas trabajando 8-10h/semana

### Información Necesaria para Comenzar

Para ejecutar la reescritura, idealmente necesitamos:

**Opción 1: Archivos UC Completos (IDEAL)**
- UC_ALR_01_Crear_Alerta.rst
- UC_RPT_01_Ver_Dashboard_Principal.rst
- UC_PIP_01_Monitorear_ETL.rst
- UC_ACC_05_Configurar_SoD.rst

**Opción 2: Especificaciones Resumidas (MÍNIMO)**
- Flujos principales de estos 4 UC
- BR específicas que se integran
- Actors y triggers

**Opción 3: Inferir del MODELO_DOCUMENTAL (VIABLE)**
- Ya tenemos el MODELO_DOCUMENTAL_IACT v2.2.0
- Podemos inferir detalles de UC a partir de nombres y contexto
- Calidad: Buena pero no perfecta

---

## CONCLUSIÓN

### Estado Actual del Problema

**CONFIRMADO: Desconexión Sistemática Total**

Las PARTES 0, 1 y 2 constituyen un **sistema pedagógico completo** basado en un caso de estudio único (Gestión de Químicos) que NO tiene relación con el proyecto real (Sistema IVR/IACT).

**Estadísticas finales:**
- 230 páginas totales
- 300+ referencias al dominio de químicos
- 0 referencias al dominio IVR real
- 66% del contenido usa ejemplos desconectados
- Ejemplos centrales (UC-07, UC-04) aparecen 30+ y 25+ veces respectivamente

### Impacto en el Equipo

**Sin corrección:**
- Onboarding 30-40% más lento
- Confusión conceptual constante
- Doble esfuerzo cognitivo (aprender químicos + traducir a IVR)
- Alto riesgo de malinterpretación
- Documentación percibida como "no útil" o "solo teórica"

**Con corrección:**
- Documentación directamente aplicable
- Aprendizaje con ejemplos del proyecto real
- Onboarding más rápido y efectivo
- Mayor confianza en la documentación
- Base sólida para desarrollo

### Recomendación Final

**PROCEDER CON REESCRITURA COMPLETA (OPCIÓN A)**

**Justificación:**
1. ✅ No es opcional: Es fundacional para el éxito del equipo
2. ✅ ROI positivo: Inversión de 41-56h, ahorro continuo en onboarding
3. ✅ Coherencia crítica: base_cognitiva/ debe estar alineada con proyecto real
4. ✅ Momento óptimo: Mejor corregir ahora que después de que equipo completo use documentación incorrecta
5. ✅ Precedente: Ya decidimos reescribir en análisis previos

**Próxima Acción:**
Confirmar decisión y definir si:
- Comenzar con información disponible (inferir de MODELO_DOCUMENTAL)
- Solicitar archivos UC específicos antes de comenzar

---

**FIN DEL ANÁLISIS INTEGRADO: PARTES 0, 1 y 2**

**Fecha:** 2025-01-08  
**Estado:** Análisis completo - Esperando decisión de usuario  
**Próximo Paso:** Confirmar Opción A/B/C y comenzar ejecución
