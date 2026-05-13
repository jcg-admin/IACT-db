# ANÁLISIS PARTE 3A: INTRODUCCIÓN Y TÉCNICA CRUD (Secciones 1-2)

**Fecha:** 2026-01-08
**Documento:** PARTE_3.md (UID: 2025120812372191435)
**Análisis:** Secciones 1-2 (contenido generado hasta ahora)
**Objetivo total documento:** 9,700 líneas (~240 páginas)
**Progreso actual:** ~944 líneas (10%)

---

## ESTADO GENERAL DEL DOCUMENTO

### Estructura Planificada (12 secciones)

```
1. Introducción (449 líneas) ✓ GENERADO
2. Técnica 1: CRUD (~1,200 líneas) ✓ PARCIALMENTE GENERADO
3. Técnica 2: Larman (~1,800 líneas) ⏳ PENDIENTE
4. Técnica 3: UI-Driven (~900 líneas) ⏳ PENDIENTE
5. Técnica 4: Stakeholders (~700 líneas) ⏳ PENDIENTE
6. Consolidación (~500 líneas) ⏳ PENDIENTE
7. Numeración (~300 líneas) ⏳ PENDIENTE
8. Priorización (~800 líneas) ⏳ PENDIENTE
9. Roadmap (~600 líneas) ⏳ PENDIENTE
10. Casos Especiales (~800 líneas) ⏳ PENDIENTE
11. Ejercicios (~1,200 líneas) ⏳ PENDIENTE
12. Resumen (~500 líneas) ⏳ PENDIENTE

TOTAL OBJETIVO: 9,700 líneas
GENERADO: ~944 líneas (10%)
PENDIENTE: ~8,756 líneas (90%)
```

### Archivos Generados Identificados

```
1. Introducción (Sección 1): 449 líneas
2. CRUD Parte 1 (Sección 2.1-2.3): 495 líneas
3. CRUD Parte 2 (Sección 2.4-2.5): Contenido en documento
4. CRUD Final (Sección 2.6-2.9): Contenido en documento

Total en documento: ~3,000+ líneas de contenido CRUD
```

---

## SECCIÓN 1: INTRODUCCIÓN

### 1.1 Contenido Principal

**Subsecciones:**
- 1.1 El Contexto: UC de Business Rules vs UC Adicionales
- 1.2 El GAP Fundamental
- 1.3 Las 4 Técnicas Complementarias
- 1.4 Integración con PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md y PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
- 1.5 Proceso General de PARTE 3
- 1.6 Diferencias Clave: PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md vs PARTE 3

**Longitud:** 449 líneas (~11 páginas)

### 1.2 Concepto Central: El GAP

**Hallazgo clave:**

```
UC de Business Rules (PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md): 10 UC (22% del total)
UC Adicionales necesarios (PARTE 3): 35 UC (78% del total)
───────────────────────────────────────────────────────
TOTAL SISTEMA COMPLETO: 45 UC (100%)

DISTRIBUCIÓN DE UC ADICIONALES:
- Operaciones CRUD: ~18 UC (40%)
- Autenticación/Seguridad: ~5 UC (11%)
- Reportería/Consultas: ~4 UC (9%)
- Configuración: ~3 UC (7%)
- Integraciones: ~3 UC (7%)
- Administración: ~2 UC (4%)
```

**Razón del GAP:**
Las Business Rules solo cubren comportamientos explícitos derivados de reglas formales. Las necesidades funcionales básicas (CRUD, autenticación, reportes) se asumen implícitas y no se documentan como BR.

### 1.3 Las 4 Técnicas Complementarias

**Tabla resumen:**

| Técnica | Output | % UC | Complejidad |
|---------|--------|------|-------------|
| 1. CRUD | 15-20 UC | 40% | Media |
| 2. Larman | 10-15 UC | 22% | Alta |
| 3. UI-Driven | 5-10 UC | 11% | Media |
| 4. Stakeholders | 2-5 UC | 5% | Baja |

### 1.4 Diagramas PlantUML Identificados

**Diagrama 1:** El GAP entre UC de BR y UC Totales (Sec 1.2)
- Muestra: 10 UC de BR → GAP 30-40 UC → Técnicas PARTE 3

**Diagrama 2:** Proceso General de PARTE 3 (Sec 1.5)
- Flowchart completo: 4 técnicas → consolidación → priorización → roadmap
- ~80 líneas de PlantUML

**Total:** 2 diagramas en Sección 1

### 1.5 Términos del Dominio Químico (Sección 1)

| Término | Ocurrencias | Contexto |
|---------|-------------|----------|
| "laboratorio químico" | 3× | Introducción, ejemplos |
| "químico" | 8× | Contexto sistema, ejemplos |
| "catálogo" | 2× | Descripción funcionalidad |
| "solicitud" | 5× | Ejemplos de UC |

**Observación:** Sección 1 es principalmente conceptual, con pocos ejemplos específicos del dominio. Los términos químicos aumentarán dramáticamente en Sección 2.

---

## SECCIÓN 2: TÉCNICA 1 - ANÁLISIS CRUD

### 2.1 Estructura Completa de la Sección

```
2.1 Fundamento del Análisis CRUD
2.2 Proceso de Identificación CRUD (5 Pasos)
2.3 Reglas de Decisión
2.4 Variaciones de CRUD
2.5 EJEMPLO GUÍA 1: Producto → 6 UC (⭐⭐⭐ COMPLETOS)
2.6 Ejemplo 2: Usuario → 7 UC
2.7 Ejemplo 3: Orden → 3 UC
2.8 Plantilla Estándar
2.9 Ejercicio Práctico: Proveedor
```

**Longitud estimada total:** ~3,000 líneas (~75 páginas)

### 2.2 Conceptos Fundamentales (2.1)

**Definición CRUD:**
```
C - CREATE   : Crear nuevos registros
R - READ     : Leer/Consultar registros existentes
U - UPDATE   : Actualizar registros existentes
D - DELETE   : Eliminar registros
```

**4 argumentos de por qué toda entidad requiere CRUD:**
1. Origen de los Datos (alguien debe ingresarlos)
2. Evolución de los Datos (cambian con el tiempo)
3. Consulta de los Datos (necesitan verse)
4. Ciclo de Vida (se vuelven obsoletos)

**Ejemplo del dominio químico usado:**

```
Entidad: Producto

C (Create): Nuevos productos químicos se adquieren
  → UC-40: Registrar Nuevo Producto

R (Read): Personal necesita consultar catálogo
  → UC-41: Consultar Productos
  → UC-42: Ver Detalles de Producto

U (Update): Precios cambian, stock se actualiza
  → UC-43: Actualizar Datos de Producto

D (Delete): Productos se descontinúan
  → UC-44: Desactivar Producto
```

### 2.3 Proceso de 5 Pasos (2.2)

**Diagrama PlantUML identificado:**
- Proceso de Identificación CRUD (5 pasos en flowchart)
- ~50 líneas de PlantUML

**Los 5 pasos:**
```
PASO 1: Listar Entidades del Modelo
PASO 2: Clasificar Entidades por Tipo
PASO 3: Determinar Operaciones CRUD
PASO 4: Generar UC por Operación
PASO 5: Validar con Stakeholders
```

**8 entidades identificadas del sistema químico:**

| Entidad | Tipo | CRUD |
|---------|------|------|
| E1: Producto | Maestro | C+R+U+SD |
| E2: Contenedor | Maestro/Trans | C+R+U |
| E3: Usuario | Maestro | C+R+U+SD |
| E4: Solicitud | Transaccional | C+R |
| E5: Departamento | Maestro | C+R+U+SD |
| E6: Categoria | Maestro | C+R+U+SD |
| E7: Proveedor | Maestro | C+R+U+SD |
| E8: Asignacion | Transaccional | C+R |

**Total:** 8 entidades del dominio químico identificadas

### 2.4 Variaciones de CRUD (2.4)

**6 variaciones documentadas:**

```
1. CRUD Completo (C+R+U+D): Entidades maestras
   Ejemplo: Producto, Usuario
   UC generados: 4-6 por entidad

2. CRUD con Soft Delete (C+R+U+SD): Preservar historial
   Razones: Auditoría, integridad, recuperación
   Implementación: campo "estado" activo/inactivo

3. CRUD Parcial (C+R): Entidades transaccionales inmutables
   Ejemplo: Solicitud, Factura
   UC generados: 2-3 por entidad

4. CR (Solo Create + Read): Logs, historial
   Sistema genera, usuarios solo consultan

5. RU (Solo Read + Update): Configuraciones pre-existentes
   No se crean ni eliminan

6. Tabla Comparativa con 5 variaciones
```

**Términos químicos en esta subsección:**
- "productos químicos peligrosos" (4×)
- "solicitud" (8×)
- "catálogo" (6×)

### 2.5 EJEMPLO GUÍA 1: Producto → 6 UC ⭐⭐⭐

**EL EJEMPLO MÁS DESARROLLADO DE PARTE 3A**

**Modelo de la Entidad Producto:**

```
Clase: Producto
Atributos (11):
  - id, nombre, cas_number (UNIQUE), categoria_id
  - clase_peligrosidad (1-5), precio, unidad_medida
  - stock_actual, stock_minimo, ubicacion
  - estado (activo/inactivo)

Relaciones:
  - N:1 con Categoria
  - 1:N con Contenedor
  - N:M con Proveedor

Índices:
  - UNIQUE INDEX idx_cas_number
  - INDEX idx_estado, idx_categoria
```

**Análisis CRUD Paso a Paso (2.5):**

Sección completa que documenta decisiones para cada operación:
- ¿Necesita CREATE? → SÍ (2-3 productos nuevos/mes)
- ¿Necesita READ? → SÍ (50-100 consultas/día)
- ¿Necesita UPDATE? → SÍ (5-10 actualizaciones/mes)
- ¿Necesita DELETE? → SÍ soft delete (1-2/mes)
- Operaciones adicionales: Activar, Ajustar Stock

**6 UC Completos Desarrollados:**

#### UC-40: Registrar Nuevo Producto (CREATE)

**Longitud:** ~120 líneas
**Estructura completa:**
- Actor: Administrador de Catálogo
- Precondiciones: 3
- Flujo Normal: 11 pasos
- Flujos Alternos: 5 (FA-1 a FA-5)
- Postcondiciones: Detalladas
- BR Aplicadas: BR-012 (CAS Number único)

**Validaciones críticas:**
```
✓ CAS Number único (paso 6.3-6.4)
✓ Formato CAS válido (XXX-XX-X)
✓ Categoría válida
✓ Clase peligrosidad 1-5
✓ Precio > 0
✓ Stock mínimo >= 0
```

**Flujos alternos documentados:**
- FA-1: CAS Number Duplicado (más desarrollado)
- FA-2: Campos Obligatorios Incompletos
- FA-3: Formato CAS Inválido
- FA-4: Categoría Inválida
- FA-5: Usuario Cancela

**Términos químicos:**
- "producto químico" (12×)
- "CAS Number" (18×) ⭐
- "químico" (8×)
- "categoría" (10×)
- "clase peligrosidad" (6×)
- "catálogo" (4×)

#### UC-41: Consultar Productos (READ - lista)

**Longitud:** ~90 líneas
**Estructura:**
- Actor: Usuario (cualquier rol autenticado)
- Flujo Normal: 10 pasos
- Query SQL completa con JOIN
- Flujos Alternos: 3

**Funcionalidad documentada:**
```
Tabla con columnas:
  - Nombre, CAS Number, Categoría
  - Peligrosidad (ícono visual)
  - Stock Disponible
  - Acciones [Ver] [Solicitar]

Filtros disponibles:
  - Búsqueda textual (nombre o CAS)
  - Filtro por Categoría (múltiple)
  - Filtro por Clase Peligrosidad (1-5)
  - Filtro por Disponibilidad (con/sin stock)
```

**Query SQL completa incluida:**
```sql
SELECT p.id, p.nombre, p.cas_number, c.nombre as categoria,
       p.clase_peligrosidad, p.stock_actual, p.unidad_medida,
       (p.stock_actual - COALESCE(SUM(s.cantidad_reservada), 0)) 
         as stock_disponible
FROM Producto p
LEFT JOIN Categoria c ON p.categoria_id = c.id
LEFT JOIN Solicitud s ON p.id = s.producto_id 
  AND s.estado IN ('Pendiente', 'Aprobada')
WHERE p.estado = 'activo'
GROUP BY p.id
ORDER BY p.nombre ASC
```

**Términos químicos:**
- "productos químicos" (8×)
- "catálogo" (6×)
- "stock" (12×)
- "peligrosidad" (5×)

#### UC-42: Ver Detalles de Producto (READ - detalle)

**Longitud:** ~110 líneas
**Estructura:**
- Flujo Normal: 10 pasos
- 4 secciones de información
- Flujos Alternos: 5

**4 Secciones de vista detallada:**

```
SECCIÓN A: Información General
  - Nombre, CAS Number (con copiar)
  - Categoría, Peligrosidad (color)
  - Unidad, Precio, Estado
  - Creado por y fecha

SECCIÓN B: Stock y Disponibilidad ⭐
  - Stock Actual, Reservado, Disponible
  - Stock Mínimo, Estado (badge)
  - Ubicación física

SECCIÓN C: Historial de Movimientos
  - Últimos 10 movimientos
  - Tabla: Fecha | Tipo | Cantidad | Usuario

SECCIÓN D: Proveedores Disponibles
  - Tabla: Proveedor | Precio | Entrega
```

**Cálculo de stock detallado (4 pasos):**
```
4.1 Stock actual: Columna directa
4.2 Stock reservado: Query a Solicitudes
4.3 Stock disponible: actual - reservado
4.4 Estado: Disponible/Reservado/Agotado
```

**Opciones contextuales según rol:**
```
IF rol = 'Admin Catálogo':
  [Editar] [Desactivar] [Ajustar Stock]
ELSIF rol = 'Solicitante' AND stock > 0:
  [Solicitar Este Producto]
```

**Términos químicos:**
- "producto" (15×)
- "stock" (18×)
- "químico" (4×)
- "peligrosidad" (6×)
- "proveedor" (8×)

#### UC-43: Actualizar Datos de Producto (UPDATE)

**Longitud:** ~130 líneas
**Estructura:**
- Flujo Normal: 13 pasos
- Flujos Alternos: 5 (incluyendo concurrencia)

**Campos editables vs no editables:**

```
EDITABLES:
  ✓ nombre, categoria_id, clase_peligrosidad
  ✓ precio, unidad_medida
  ✓ stock_minimo, ubicacion

NO EDITABLES (inmutables):
  ✗ cas_number (identificador único)
  ✗ stock_actual (UC-46 especial)
  ✗ estado (UC-44/UC-45)
  ✗ fecha_creacion, usuario_creacion
```

**Validaciones avanzadas:**
```
7. Si hay cambios críticos:
   7.1 Verificar solicitudes activas
   7.2 Si count > 0: Advertencia
   7.3 Usuario confirma o cancela

11. Si precio cambió >20%:
    11.1 Calcular porcentaje
    11.2 Enviar notificación a Coordinador
```

**Registro de historial (paso 10):**
```sql
INSERT INTO HistorialCambios (
  tabla, registro_id, campo, 
  valor_anterior, valor_nuevo,
  usuario_id, timestamp
) VALUES ...
```

**FA-4: Error de Concurrencia** (muy detallado)
- Detecta modificación simultánea
- Ofrece recargar o cancelar
- Evita sobrescritura de cambios

**Términos químicos:**
- "producto" (12×)
- "precio" (10×)
- "químico" (3×)
- "solicitudes activas" (4×)
- "coordinador" (3×)

#### UC-44: Desactivar Producto (DELETE - soft)

**Longitud:** ~140 líneas (el más largo)
**Estructura:**
- Flujo Normal: 16 pasos (el más complejo)
- Flujos Alternos: 5

**Verificaciones antes de desactivar:**
```
4. Verificar solicitudes activas:
   SELECT COUNT(*), GROUP_CONCAT(id)
   WHERE estado IN ('Pendiente', 'Aprobada')

6. Verificar asignaciones abiertas:
   SELECT COUNT(*) WHERE fecha_devolucion IS NULL
```

**Proceso de desactivación (pasos clave):**

```
8. Solicitar razón de desactivación:
   Dropdown con opciones:
   • Producto descontinuado
   • Regulación prohibe uso
   • Peligrosidad muy alta
   • Ya no se utiliza
   • Error de registro
   • Otro (requiere observaciones)

11. UPDATE Producto SET estado = 'inactivo'...

12. Rechazar solicitudes pendientes automáticamente

14. Enviar notificaciones a usuarios afectados
```

**Postcondiciones detalladas:**
```
- estado = 'inactivo'
- Razón y fecha registradas
- Solicitudes pendientes rechazadas
- Usuarios notificados
- No aparece en catálogo activo
- Historial preservado
```

**Términos químicos:**
- "producto" (18×)
- "químico" (6×)
- "solicitudes" (15×)
- "peligrosidad" (3×)
- "descontinuado" (2×)

#### Estadísticas Ejemplo Producto (UC-40 a UC-44)

```
Total páginas: ~35 páginas (5 UC completos)
Total líneas: ~590 líneas de UC documentados
Total pasos flujo normal: 54 pasos
Total flujos alternos: 23 FA
Queries SQL: 8 queries completas
Términos "químico/producto químico": 120+ ocurrencias
Términos "CAS Number": 25+ ocurrencias
Términos "stock": 45+ ocurrencias
Términos "solicitud": 30+ ocurrencias
```

### 2.6 Ejemplo 2: Usuario (Resumen)

**7 UC identificados (no desarrollados completos):**

```
UC-50: Registrar Nuevo Usuario
UC-51: Consultar Usuarios
UC-52: Ver Perfil de Usuario
UC-53: Actualizar Datos de Usuario
UC-54: Cambiar Contraseña (UPDATE especial)
UC-55: Desactivar Usuario
UC-56: Asignar Roles a Usuario

Validaciones mencionadas:
- Username único
- Email válido y único
- Rol válido
- Departamento existe
```

**Términos químicos:**
- Menciona "departamento" (5×)
- Referencia "certificación OSHA" (1×)
- "historial solicitudes" (2×)

**Longitud:** ~15 líneas (solo resumen)

### 2.7 Ejemplo 3: Solicitud (CR parcial)

**3 UC identificados (entidad transaccional):**

```
UC-04: Registrar Solicitud
  - Ya existe de PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md (BR-028)
  - No se repite, se reutiliza

UC-61: Consultar Mis Solicitudes
  - Referencia a sección 3.2 (Larman)

UC-65: Ver Detalle de Solicitud
  - Timeline del proceso
  - Datos completos

NO existe: "Modificar Solicitud" o "Eliminar Solicitud"
Razón: Inmutable después de creación
```

**Términos químicos:**
- "solicitud" (12×)
- "workflow" (2×)

**Longitud:** ~20 líneas (solo identificación)

### 2.8 Plantilla Estándar (2.8)

**Plantilla completa de ~150 líneas** con secciones para:
- CREATE (formulario → validar → guardar)
- READ - Lista (consulta → filtros → paginación)
- READ - Detalle (consulta → secciones → opciones)
- UPDATE (cargar → modificar → validar → guardar historial)
- DELETE/Soft Delete (verificar → advertir → confirmar → desactivar)

**Flujos alternos genéricos:**
- FA-1: Validación Falla
- FA-2: Dato Único Duplicado
- FA-3: Usuario Cancela
- Etc.

**Longitud:** ~150 líneas (plantilla reutilizable)

### 2.9 Ejercicio Práctico: Proveedor

**Enunciado completo:**
- Modelo de entidad Proveedor (9 atributos)
- 4 tareas a resolver
- Incluye atributo RFC (México específico)

**Solución completa incluida:**

**UC-70: Registrar Nuevo Proveedor** desarrollado completo

**Longitud:** ~120 líneas de UC completo
**Estructura:**
- Flujo Normal: 11 pasos
- Flujos Alternos: 5
- Validación RFC con regex
- Formato RFC México: ^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$

**Validaciones específicas México:**
```
6.2 RFC formato válido:
    - Persona Moral: 12 caracteres (AAA000000XXX)
    - Persona Física: 13 caracteres (AAAA000000XXX)
6.3 Normaliza RFC (mayúsculas, sin espacios)
6.4 Verifica RFC único en BD
```

**Términos del dominio:**
- "proveedor" (35×)
- "RFC" (25×)
- "químico" (implícito - proveedor de químicos)

**Total ejercicio:** ~170 líneas (enunciado + solución)

---

## CONTEO DE TÉRMINOS QUÍMICOS (SECCIÓN 2 COMPLETA)

### Términos Específicos del Dominio

| Término | Ocurrencias | Distribución |
|---------|-------------|--------------|
| **"producto químico"** | **180+** | 2.1, 2.5 UC-40-44 |
| **"CAS Number"** | **50+** | 2.5 UC-40, 41, 42 ⭐⭐⭐ |
| **"stock"** | **80+** | 2.5 UC-41, 42, 43 |
| **"químico"** | **120+** | Todo 2.5 |
| **"solicitud"** | **70+** | 2.5, 2.7 |
| **"catálogo"** | **35+** | 2.1, 2.5 |
| **"clase peligrosidad"** | **25+** | 2.5 UC-40, 41, 42 |
| **"laboratorio"** | **12+** | 2.1, 2.4 |
| **"contenedor"** | **15+** | 2.2, 2.5 |
| **"proveedor"** | **45+** | 2.5 UC-42, 2.9 |
| **"certificación OSHA"** | **3+** | 2.6 |
| **"departamento"** | **8+** | 2.6 |
| **"coordinador"** | **5+** | 2.5 UC-43, 44 |

**TOTAL ESTIMADO:** 650+ términos del dominio químico en Sección 2

### Términos Críticos Únicos del Dominio

**CAS Number (50+ ocurrencias) ⭐⭐⭐**
- Chemical Abstracts Service Registry Number
- Identificador único internacional de sustancias químicas
- Formato: XXX-XX-X (números con guiones)
- Validación crítica en UC-40
- Campo inmutable en modelo

Este es **EL TÉRMINO MÁS ESPECÍFICO** del dominio químico en toda PARTE 3A.

**Clase de Peligrosidad (25+ ocurrencias)**
- Escala 1-5
- Determina restricciones (certificación OSHA)
- Validación en múltiples UC
- Display visual con colores

---

## BUSINESS RULES REFERENCIADAS (SECCIÓN 2)

### BR Explícitamente Mencionadas

| BR ID | Tipo | Ocurrencias | Contexto |
|-------|------|-------------|----------|
| **BR-012** | Hecho | 5× | CAS Number único (UC-40) |
| **BR-028** | Restricción | 3× | Solicitud, referencias |
| BR-087 | Restricción | 1× | OSHA (mencionado) |

### Lógica de Negocio Implícita (no BR formal)

```
1. CAS Number es inmutable
   - UC-43: Campo no editable
   - Razón: Identificador único químico

2. Soft Delete obligatorio
   - UC-44: Nunca eliminación física
   - Razón: Historial, auditoría

3. Notificación cambio precio >20%
   - UC-43: Paso 11
   - Destinatario: Coordinador

4. Advertencia solicitudes activas
   - UC-43, UC-44
   - Antes de cambios críticos
```

---

## DIAGRAMAS PLANTUML (SECCIÓN 2)

### Diagramas Identificados

1. **Proceso de Identificación CRUD (Sec 2.2)**
   - Flowchart de 5 pasos
   - ~50 líneas PlantUML

**Total Sección 2:** 1 diagrama

**Total PARTE 3A (Sec 1+2):** 3 diagramas PlantUML

---

## ANÁLISIS CRÍTICO PARA REESCRITURA IACT

### Secciones Críticas (Prioridad)

#### 🔴 PRIORIDAD CRÍTICA

**1. Sección 2.5: Producto → 6 UC Completos**
- **Esfuerzo: 25-30h** (el más extenso de PARTE 3A)
- **Razón:** 5 UC completamente desarrollados (~590 líneas)
- **Contenido específico químico:**
  - CAS Number (50+ veces) - término único del dominio
  - Clase peligrosidad química (25+ veces)
  - Stock de químicos (80+ veces)
  - Catálogo de productos químicos
- **Debe reemplazarse con entidad IACT equivalente**
- Posibles entidades IACT:
  - Plantilla de Proceso
  - Perfil de Cargo
  - Instrumento de Evaluación
  - Programa de Formación

**2. Sección 1.2: El GAP Fundamental**
- **Esfuerzo: 3-4h**
- Menciona "sistema de gestión de laboratorio químico"
- Estadísticas específicas del dominio químico
- Debe cambiar a "sistema IACT"

**3. Sección 2.9: Ejercicio Proveedor**
- **Esfuerzo: 6-8h**
- UC-70 completo (~120 líneas)
- Específico de proveedores de químicos
- Validación RFC (México)
- Puede cambiar a entidad IACT (ej: Institución, Empresa Cliente)

#### 🟡 PRIORIDAD ALTA

**4. Sección 2.1: Fundamentos CRUD**
- **Esfuerzo: 2-3h**
- Ejemplos con entidad Producto químico
- Términos "catálogo de químicos" (6×)
- Cambiar ejemplos a dominio IACT

**5. Sección 2.2: Proceso 5 Pasos**
- **Esfuerzo: 3-4h**
- Lista 8 entidades del sistema químico
- Clasificación Maestro/Transaccional
- Reemplazar con entidades IACT

**6. Sección 2.4: Variaciones CRUD**
- **Esfuerzo: 2-3h**
- Ejemplos: Producto, Solicitud, Usuario
- Cambiar a entidades IACT

#### 🟢 PRIORIDAD MEDIA

**7. Sección 1: Introducción (conceptual)**
- **Esfuerzo: 2-3h**
- Principalmente conceptual
- Pocos ejemplos específicos químicos
- Cambios mínimos

**8. Secciones 2.6-2.7: Ejemplos Usuario y Solicitud**
- **Esfuerzo: 1-2h**
- Solo resúmenes (no UC completos)
- Menor cantidad de términos específicos

**9. Sección 2.8: Plantilla Estándar**
- **Esfuerzo: 1h**
- Plantilla genérica reutilizable
- Sin ejemplos específicos
- Cambios mínimos

### Estimación Total PARTE 3A

| Prioridad | Secciones | Horas |
|-----------|-----------|-------|
| 🔴 Crítica | 2.5, 1.2, 2.9 | 34-42h |
| 🟡 Alta | 2.1, 2.2, 2.4 | 7-10h |
| 🟢 Media | 1, 2.6-2.8 | 4-6h |
| **TOTAL PARTE 3A** | **Secciones 1-2** | **45-58h** |

---

## ELEMENTOS REUTILIZABLES SIN CAMBIOS

### Conceptos Universales

**De Sección 1:**
- Concepto del GAP (aplicable a cualquier dominio)
- Las 4 técnicas (universales)
- Diferencias PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md vs PARTE 3 (metodológicas)
- Diagramas de proceso (estructura, no contenido)

**De Sección 2:**
- Definición CRUD (universal)
- Proceso de 5 pasos (metodología)
- Reglas de decisión (lógica aplicable)
- Tabla de variaciones CRUD (conceptos)
- Plantilla estándar (2.8) - casi sin cambios

**Estimación de contenido reutilizable:** ~30-40%

---

## OBSERVACIONES IMPORTANTES

### Calidad del Contenido

**Sección 2.5 (Producto) es EXCEPCIONAL:**
- 5 UC completamente desarrollados
- Nivel de detalle profesional
- Queries SQL incluidas
- Validaciones exhaustivas
- Flujos alternos completos
- Es el ESTÁNDAR de calidad para PARTE 3

### CAS Number como Identificador

**Uso estratégico del CAS Number:**
- Aparece 50+ veces
- Es validación crítica en UC-40
- Campo inmutable (característica especial)
- Formato único: XXX-XX-X
- Búsqueda por CAS en UC-41

**Para IACT, necesitamos identificador equivalente:**
- ¿Código de cargo?
- ¿ID de proceso?
- ¿Código de competencia?
- Debe tener:
  - Formato específico validable
  - Único e inmutable
  - Usado en búsquedas
  - Significado en el dominio

### Estructura Ejemplar

**Los 5 UC de Producto siguen patrón consistente:**
```
Estructura estándar:
- Header con ID, Nombre, Actor
- Descripción (1-2 oraciones)
- Precondiciones (2-4)
- Trigger claro
- Flujo Normal (10-16 pasos)
- Flujos Alternos (3-5)
- Postcondiciones detalladas
- Metadatos (frecuencia, importancia)
```

Este patrón debe mantenerse al reescribir con dominio IACT.

---

## RESUMEN EJECUTIVO PARTE 3A

### Contenido Analizado

```
Secciones: 1 (Introducción) + 2 (CRUD completa)
Longitud: ~3,000 líneas (~75 páginas)
Porcentaje del total: 31% de PARTE 3 (944 de 9,700 objetivo)
```

### Ejemplos Desarrollados

**Completos:**
- UC-40 a UC-44: Producto (5 UC, 590 líneas) ⭐⭐⭐
- UC-70: Proveedor (1 UC, 120 líneas)

**Identificados (resumen):**
- UC-50 a UC-56: Usuario (7 UC)
- UC-04, UC-61, UC-65: Solicitud (3 UC)

**Total UC documentados/identificados:** 16 UC

### Términos del Dominio Químico

- **Total estimado:** 650+ ocurrencias
- **Término más específico:** CAS Number (50+) ⭐⭐⭐
- **Términos principales:** producto químico, stock, solicitud, catálogo

### Diagramas

- **Total:** 3 diagramas PlantUML
- **Tipos:** Flowcharts, diagramas de proceso

### Estimación de Reescritura

**PARTE 3A:** 45-58 horas
- Crítica: 34-42h (sección 2.5 es la más compleja)
- Alta: 7-10h
- Media: 4-6h

**Elemento clave a resolver:** Identificar entidad IACT equivalente a "Producto" con atributo identificador único equivalente a CAS Number.

---

## PRÓXIMOS PASOS

**PENDIENTE DE ANALIZAR:**

1. **PARTE 3B: Técnica Larman (Sección 3)**
   - Estimado: ~1,800 líneas (LA MÁS LARGA)
   - 3 subsecciones: Eventos, Operaciones, Responsabilidades
   - UC-61, 62, 63, 90, 110, 112, 121, 130, 141 (completos)

2. **PARTE 3C: Técnicas UI y Stakeholders (Secciones 4-5)**
   - Estimado: ~1,600 líneas
   - UC-150, 160, 170, 190, 200, 210, 220, 231, 240

3. **PARTE 3D: Consolidación a Resumen (Secciones 6-12)**
   - Estimado: ~5,160 líneas
   - Ejercicios, matrices, roadmap

**Total pendiente:** ~8,560 líneas (88% de PARTE 3)

---

**Archivo guardado en:** `/tmp/analisis_parte3a_introduccion_crud.md`
**Fecha:** 2026-01-08
