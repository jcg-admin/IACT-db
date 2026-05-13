## 3. PROCESO DE DERIVACIÓN UC → FR

### 3.1 Introducción al Proceso

#### 3.1.1 ¿Por qué derivar FR desde UC?

**Los UC son la fuente primaria de FR porque:**

```
1. UC capturan la visión completa del sistema
   → Cada paso del UC esconde múltiples FR

2. UC están validados por stakeholders
   → FR derivados tienen trazabilidad clara

3. UC cubren flujos normales y excepcionales
   → FR cubren happy path y edge cases

4. UC organizan funcionalidad por actor
   → FR se agrupan naturalmente por módulo
```

**Relación numérica típica:**

```
1 UC completo (20-30 pasos) → 40-70 FR

Ejemplo:
  UC-40: Registrar Nuevo Producto
    • Flujo normal: 9 pasos
    • Flujos alternos: 8 FAs
    • Total pasos: ~25
    ↓
    • FR derivados: ~60 FR

Ratio: ~2.5 FR por paso de UC (incluyendo alternos)
```

---

### 3.2 Metodología: 7 Pasos para Derivar FR

#### PASO 1: Leer y Comprender el UC Completo

**Actividades:**

```
1. Leer UC completo de inicio a fin
   • Flujo normal
   • Todos los flujos alternos
   • Precondiciones y postcondiciones
   • Business Rules asociadas

2. Identificar actores involucrados
   • Actor principal
   • Actores secundarios
   • Sistemas externos

3. Identificar datos involucrados
   • Inputs del usuario
   • Outputs del sistema
   • Datos persistidos

4. Identificar operaciones del sistema
   • Validaciones
   • Cálculos
   • Almacenamiento
   • Notificaciones
```

**Ejemplo: UC-40**

```
UC-40: Registrar Nuevo Producto

Actor: Coordinador de Laboratorio

Flujo Normal (9 pasos):
  1. Usuario selecciona "Agregar Producto"
  2. Sistema muestra formulario vacío
  3. Usuario ingresa datos: nombre, CAS, categoría, etc.
  4. Usuario hace clic en "Guardar"
  5. Sistema valida datos ingresados
  6. Sistema verifica unicidad de CAS Number
  7. Sistema guarda producto en BD
  8. Sistema muestra mensaje de éxito
  9. Sistema actualiza lista de productos

Flujos Alternos (8 FAs):
  FA-1: Datos inválidos
  FA-2: CAS Number duplicado
  FA-3: Error de BD
  FA-4: Usuario cancela
  ... (continúa)

COMPRENSIÓN:
  ✓ Este UC maneja el registro de productos químicos
  ✓ Involucra formulario con ~10 campos
  ✓ Requiere validaciones estrictas (formato CAS)
  ✓ Debe garantizar unicidad de CAS
  ✓ Incluye auditoría
  ✓ 60+ FR esperados
```

#### PASO 2: Descomponer Cada Paso del Flujo Normal

**Técnica: Pregunta "¿Qué debe hacer el sistema EXACTAMENTE?"**

```
PASO UC (alto nivel):
  "5. Sistema valida datos ingresados"

DESCOMPOSICIÓN (bajo nivel - FR):
  ↓
  FR-40.6:  Validar formato de CAS Number
  FR-40.7:  Validar checksum de CAS Number
  FR-40.8:  Validar nombre no vacío
  FR-40.9:  Validar longitud de nombre (≤ 200 caracteres)
  FR-40.10: Validar categoría existe en catálogo
  FR-40.11: Validar clase peligrosidad en rango [1-5]
  FR-40.12: Validar precio > 0
  FR-40.13: Validar stock_minimo ≥ 0
  FR-40.14: Validar unidad_medida en lista válida
  FR-40.15: Validar proveedor existe (si se ingresó)

Resultado: 1 paso UC → 10 FR específicos
```

**Matriz de Descomposición:**

```
┌────────────────────┬─────────────────────────┬───────────────┐
│ Paso UC            │ Pregunta Clave          │ FR Resultantes│
├────────────────────┼─────────────────────────┼───────────────┤
│ "Sistema muestra   │ ¿Qué campos mostrar?    │ FR-40.1       │
│  formulario"       │ ¿Qué valores default?   │ FR-40.2       │
│                    │ ¿Qué validaciones UI?   │ FR-40.3       │
│                    │ ¿Labels/placeholders?   │ FR-40.4       │
│                    │                         │ 4 FR          │
├────────────────────┼─────────────────────────┼───────────────┤
│ "Sistema valida    │ ¿Qué validar?           │ FR-40.6-40.15 │
│  datos"            │ ¿Cómo validar?          │               │
│                    │ ¿Qué mensaje si falla?  │ 10 FR         │
├────────────────────┼─────────────────────────┼───────────────┤
│ "Sistema guarda    │ ¿En qué tabla?          │ FR-40.50      │
│  en BD"            │ ¿Qué campos?            │ FR-40.51      │
│                    │ ¿Transacción ACID?      │ FR-40.52      │
│                    │ ¿Auditoría?             │ FR-40.53      │
│                    │                         │ 4 FR          │
└────────────────────┴─────────────────────────┴───────────────┘

Total: 3 pasos UC → 18 FR (ratio 1:6)
```

#### PASO 3: Descomponer Flujos Alternos

**Los flujos alternos son fuente rica de FR porque manejan errores.**

**Ejemplo: FA-1 del UC-40**

```
FA-1: Datos Inválidos
  Condición: En paso 5, si algún dato es inválido
  Flujo:
    5a. Sistema muestra mensaje de error específico
    5b. Sistema resalta campos con error
    5c. Sistema mantiene datos ingresados (no borra)
    5d. Usuario corrige errores
    5e. Retorna a paso 4

DESCOMPOSICIÓN:
  ↓
  FR-40.20: Mostrar mensaje de error específico por campo
  FR-40.21: Resaltar campos inválidos con borde rojo
  FR-40.22: Preservar datos ingresados en formulario
  FR-40.23: Prevenir submit mientras haya errores
  FR-40.24: Re-validar al corregir cada campo
  FR-40.25: Limpiar error cuando campo se corrige

Resultado: 1 FA → 6 FR de manejo de errores
```

**Categorías comunes de FA → FR:**

```
CATEGORÍA FA                    FR RESULTANTES
─────────────────────────────   ────────────────────────────
Validación fallida          →   Mensajes de error
                                UI feedback (colores, íconos)
                                Preservación de datos

Unicidad violada            →   Query de verificación
                                Mensaje específico
                                Sugerencias (si aplica)

Error de BD                 →   Manejo de excepciones
                                Rollback de transacción
                                Logging de error
                                Mensaje genérico al usuario

Usuario cancela             →   Confirmación de cancelación
                                Limpieza de datos temporales
                                Navegación al origen

Timeout                     →   Detección de timeout
                                Retry lógico
                                Mensaje informativo
```

#### PASO 4: Extraer FR de Precondiciones

**Las precondiciones implican validaciones pre-ejecución.**

**Ejemplo: Precondiciones de UC-40**

```
Precondiciones:
  • Usuario está autenticado
  • Usuario tiene rol Coordinador o Admin
  • Sesión de usuario es válida

DESCOMPOSICIÓN:
  ↓
  FR-40.70: Verificar usuario autenticado antes de mostrar formulario
  FR-40.71: Verificar usuario tiene permiso "productos.crear"
  FR-40.72: Verificar sesión no ha expirado
  FR-40.73: Redirigir a login si no autenticado

Categoría: Seguridad / Autorización
```

#### PASO 5: Extraer FR de Postcondiciones

**Las postcondiciones implican efectos observables.**

**Ejemplo: Postcondiciones de UC-40**

```
Postcondiciones (éxito):
  • Producto creado en BD con ID único
  • Stock inicial = 0
  • Estado = Activo
  • Auditoría registrada
  • Lista de productos actualizada

DESCOMPOSICIÓN:
  ↓
  FR-40.54: Generar ID auto-incremental para producto
  FR-40.55: Inicializar stock_actual en 0
  FR-40.56: Establecer estado "Activo" por default
  FR-40.57: Registrar en AuditoriaLog: INSERT producto
  FR-40.58: Invalidar cache de lista productos
  FR-40.59: Publicar evento "ProductoCreado"

Categoría: Persistencia / Auditoría / Events
```

#### PASO 6: Extraer FR de Business Rules

**Las BR a menudo derivan FR específicos.**

**Ejemplo: BR asociadas a UC-40**

```
BR-012: CAS Number debe ser único y válido
  ↓
  FR-40.6: Validar formato CAS (XXX-XX-X)
  FR-40.7: Validar checksum CAS
  FR-40.8: Verificar unicidad CAS en BD

BR-015: Productos clase 5 requieren aprobación especial
  ↓
  FR-40.60: Si clase_peligrosidad = 5, requerir aprobación
  FR-40.61: Establecer estado "Pendiente_Aprobacion" si clase 5
  FR-40.62: Notificar a Admin cuando se registra clase 5

BR-030: Stock no puede ser negativo
  ↓
  FR-40.13: Validar stock_minimo ≥ 0
  FR-42.10: Verificar stock suficiente antes de descuento
```

#### PASO 7: Identificar FR Cross-Cutting

**Algunos FR aplican a múltiples pasos/UC.**

**Categorías cross-cutting:**

```
1. AUDITORÍA:
   FR-40.90: Registrar en AuditoriaLog toda operación CUD
   FR-40.91: Incluir usuario, timestamp, IP, datos antes/después
   
   Aplica a: UC-40, UC-42, UC-44, UC-204, UC-208

2. VALIDACIÓN DE SESIÓN:
   FR-40.95: Verificar token JWT válido en cada request
   FR-40.96: Renovar token si está próximo a expirar
   
   Aplica a: Todos los UC autenticados

3. LOGGING:
   FR-40.97: Loggear errores con stack trace completo
   FR-40.98: Loggear performance (tiempo de ejecución)
   
   Aplica a: Todos los UC

4. CACHE:
   FR-40.99: Invalidar cache de productos al crear/editar/eliminar
   
   Aplica a: UC-40, UC-42, UC-44

5. NOTIFICACIONES:
   FR-40.100: Enviar notificación a Admin cuando se crea producto clase 5
   
   Aplica a: UC-40
```

---

### 3.3 Técnicas de Descomposición

#### 3.3.1 Técnica 1: Matriz de Descomposición

**Template:**

```
┌─────────────────────┬──────────────┬──────────────┬───────────┐
│ Paso UC             │ Actor        │ Sistema      │ Datos     │
├─────────────────────┼──────────────┼──────────────┼───────────┤
│ [Descripción paso]  │ [Qué hace    │ [Qué debe    │ [Inputs   │
│                     │  el usuario] │  hacer el    │  /Outputs]│
│                     │              │  sistema]    │           │
├─────────────────────┼──────────────┼──────────────┼───────────┤
│                     │              │              │           │
└─────────────────────┴──────────────┴──────────────┴───────────┘
```

**Ejemplo aplicado a UC-40:**

```
┌─────────────────────┬──────────────┬──────────────┬───────────┐
│ Paso 3: Usuario     │ Usuario      │ Sistema      │ Datos     │
│ ingresa datos       │ ingresa:     │ debe:        │           │
├─────────────────────┼──────────────┼──────────────┼───────────┤
│                     │ • Nombre     │ • Capturar   │ Input:    │
│                     │ • CAS        │   cada campo │ - nombre  │
│                     │ • Categoría  │ • Validar    │ - cas     │
│                     │ • Clase      │   en tiempo  │ - categ   │
│                     │ • Precio     │   real       │ - clase   │
│                     │ • Stock min  │ • Mostrar    │ - precio  │
│                     │ • Unidad     │   feedback   │ - stock   │
│                     │              │   visual     │ - unidad  │
└─────────────────────┴──────────────┴──────────────┴───────────┘

FR derivados de columna "Sistema debe":
  FR-40.1: Capturar nombre (max 200 chars)
  FR-40.2: Capturar CAS (formato XXX-XX-X)
  FR-40.3: Capturar categoría (dropdown)
  FR-40.4: Capturar clase (1-5)
  FR-40.5: Capturar precio (decimal positivo)
  FR-40.31: Validar nombre en tiempo real (onChange)
  FR-40.32: Mostrar ✓ verde si campo válido
  FR-40.33: Mostrar ✗ rojo si campo inválido
```

#### 3.3.2 Técnica 2: Árbol de Decisión

**Para flujos con múltiples ramas condicionales.**

```
PASO UC:
  "6. Sistema verifica unicidad de CAS Number"

ÁRBOL DE DECISIÓN:

                  [Verificar CAS en BD]
                          │
            ┌─────────────┴─────────────┐
            │                           │
        [Existe]                    [No Existe]
            │                           │
   ┌────────┴────────┐                  │
   │                 │                  │
[Mismo ID]    [Diferente ID]       [Continuar]
   │                 │
[OK, update]    [Error: duplicado]

FR por cada nodo:
  FR-40.40: Ejecutar query: SELECT id FROM Producto WHERE cas = ?
  FR-40.41: Si result.count = 0 → CAS único → Continuar
  FR-40.42: Si result.count = 1 AND result.id = producto_actual → OK (update)
  FR-40.43: Si result.count ≥ 1 AND result.id != producto_actual → Error
  FR-40.44: Mostrar "CAS ya existe en producto: {nombre}"
```

#### 3.3.3 Técnica 3: Tabla CRUD

**Para operaciones de base de datos.**

```
OPERACIÓN: Registrar Producto (CREATE)

┌──────────────┬────────────┬──────────┬──────────────┬──────────┐
│ Campo        │ Tipo       │ Null?    │ Default      │ Validar  │
├──────────────┼────────────┼──────────┼──────────────┼──────────┤
│ id           │ INTEGER    │ NO       │ AUTO_INC     │ -        │
│ nombre       │ VARCHAR    │ NO       │ -            │ SÍ       │
│ cas_number   │ VARCHAR    │ NO       │ -            │ SÍ       │
│ categoria_id │ INTEGER    │ NO       │ -            │ SÍ (FK)  │
│ clase_pelig  │ INTEGER    │ NO       │ 1            │ SÍ (1-5) │
│ precio       │ DECIMAL    │ NO       │ 0.00         │ SÍ (≥0)  │
│ stock_min    │ INTEGER    │ NO       │ 10           │ SÍ (≥0)  │
│ stock_actual │ INTEGER    │ NO       │ 0            │ -        │
│ activo       │ BOOLEAN    │ NO       │ TRUE         │ -        │
│ creado_en    │ TIMESTAMP  │ NO       │ NOW()        │ -        │
└──────────────┴────────────┴──────────┴──────────────┴──────────┘

FR por fila:
  FR-40.54: Generar id auto-incremental
  FR-40.8:  Validar nombre no NULL
  FR-40.9:  Validar nombre <= 200 caracteres
  FR-40.6:  Validar cas_number formato XXX-XX-X
  FR-40.15: Validar categoria_id existe en tabla Categoria
  FR-40.11: Validar clase_peligrosidad entre 1 y 5
  FR-40.12: Validar precio >= 0
  FR-40.13: Validar stock_minimo >= 0
  FR-40.55: Inicializar stock_actual en 0
  FR-40.56: Establecer activo = TRUE
  FR-40.58: Establecer creado_en = CURRENT_TIMESTAMP
```

#### 3.3.4 Técnica 4: Mapeo de Mensajes

**Para cada mensaje al usuario, un FR.**

```
MENSAJES DEL UC-40:

1. "Producto registrado exitosamente"
   → FR-40.80: Mostrar toast verde con mensaje de éxito

2. "CAS Number inválido. Formato: XXX-XX-X"
   → FR-40.20: Mostrar error debajo del campo CAS

3. "Ya existe un producto con ese CAS Number"
   → FR-40.21: Mostrar error de duplicado con link al producto existente

4. "Error al guardar. Intente nuevamente."
   → FR-40.22: Mostrar modal de error con botón Reintentar

5. "Campo obligatorio"
   → FR-40.23: Mostrar error inline para campos vacíos

Cada mensaje → 1 FR de UI/UX
```

---

### 3.4 Ejercicio Guiado: UC-40 Completo

**Vamos a derivar TODOS los FR de UC-40 paso a paso.**

#### UC-40 Completo (Referencia)

```
UC-40: Registrar Nuevo Producto Químico

Actor Principal: Coordinador de Laboratorio

Precondiciones:
  • Usuario autenticado con rol Coordinador o Admin
  • Sesión válida
  • Catálogos (Categoría, Unidad) cargados

Flujo Normal:
  1. Usuario selecciona "Agregar Producto" del menú
  2. Sistema muestra formulario vacío con campos:
     - Nombre (obligatorio)
     - CAS Number (obligatorio)
     - Categoría (obligatorio, dropdown)
     - Clase de Peligrosidad (obligatorio, 1-5)
     - Precio Unitario (obligatorio, decimal)
     - Stock Mínimo (obligatorio, entero)
     - Unidad de Medida (obligatorio, dropdown)
     - Proveedor (opcional, autocomplete)
     - Descripción (opcional, textarea)
     - Ubicación Almacén (opcional, texto)
     - Fecha Vencimiento (opcional, date)
  3. Usuario ingresa datos
  4. Usuario hace clic en "Guardar"
  5. Sistema valida datos ingresados:
     - Formato de CAS Number
     - Checksum de CAS
     - Longitudes de campos
     - Rangos de valores
     - Existencia de FK
  6. Sistema verifica unicidad de CAS Number
  7. Sistema guarda producto en BD (transacción ACID)
  8. Sistema muestra mensaje "Producto registrado exitosamente"
  9. Sistema actualiza lista de productos en pantalla
  Fin UC

Flujos Alternos:
  FA-1: Datos Inválidos (en paso 5)
  FA-2: CAS Number Duplicado (en paso 6)
  FA-3: Error de BD (en paso 7)
  FA-4: Usuario Cancela (en paso 3 o 4)
  FA-5: Sesión Expirada (cualquier paso)
  FA-6: Sin Permisos (en paso 1)
  FA-7: Catálogos No Disponibles (en paso 2)
  FA-8: Timeout (en paso 7)

Postcondiciones (éxito):
  • Producto creado en BD con ID único
  • Stock inicial = 0
  • Estado = Activo
  • Auditoría registrada
  • Lista actualizada

Business Rules:
  • BR-012: CAS Number único y válido
  • BR-015: Clase 5 requiere aprobación
  • BR-030: Stock no negativo
```

#### Derivación Completa (60 FR)

**GRUPO 1: UI / Presentación (FR-40.1 a FR-40.5)**

```
FR-40.1: Mostrar Formulario de Registro
  Sistema DEBE mostrar formulario con 11 campos agrupados:
    • Grupo "Identificación": Nombre, CAS Number
    • Grupo "Clasificación": Categoría, Clase Peligrosidad
    • Grupo "Inventario": Precio, Stock Min, Unidad
    • Grupo "Opcional": Proveedor, Descripción, Ubicación, Vencimiento
  Categoría: UI/Presentación
  Prioridad: Must Have
  
FR-40.2: Renderizar Campo Nombre
  Campo tipo text, max 200 caracteres, obligatorio.
  Placeholder: "Ej: Acetona"
  
FR-40.3: Renderizar Campo CAS Number
  Campo tipo text, max 12 caracteres, obligatorio.
  Placeholder: "XXX-XX-X"
  Hint: "Formato: 50-00-0"
  
FR-40.4: Renderizar Dropdown Categoría
  Cargar categorías desde tabla Categoria (activas).
  Ordenar alfabéticamente.
  Opción default: "-- Seleccione --"
  
FR-40.5: Renderizar Campo Clase Peligrosidad
  Radio buttons: 1, 2, 3, 4, 5
  Default: 1
  Mostrar descripción por clase
```

**GRUPO 2: Validaciones de Formato (FR-40.6 a FR-40.14)**

```
FR-40.6: Validar Formato CAS Number
  [YA ESPECIFICADO EN SECCIÓN 2.2]
  Regex: ^[0-9]{2,7}-[0-9]{2}-[0-9]$
  
FR-40.7: Validar Checksum CAS Number
  Algoritmo CAS checksum:
    1. Remover guiones: "50-00-0" → "50000"
    2. Último dígito es check digit (0)
    3. Invertir resto: "5000" → "0005"
    4. Multiplicar cada dígito por posición (1-indexed):
       0×1 + 0×2 + 0×3 + 5×4 = 20
    5. Checksum = 20 % 10 = 0 ✓ (coincide con check digit)
  
FR-40.8: Validar Nombre No Vacío
  nombre.trim() != ""
  Mensaje: "Nombre es obligatorio"
  
FR-40.9: Validar Longitud Nombre
  nombre.length <= 200
  Mensaje: "Nombre máximo 200 caracteres (actual: {length})"
  
FR-40.10: Validar Nombre Solo Caracteres Permitidos
  Permite: letras, números, espacios, guiones, paréntesis
  Regex: ^[a-zA-Z0-9\s\-\(\)]+$
  
FR-40.11: Validar Clase Peligrosidad en Rango
  clase >= 1 AND clase <= 5
  
FR-40.12: Validar Precio Positivo
  precio > 0
  Mensaje: "Precio debe ser mayor a 0"
  
FR-40.13: Validar Stock Mínimo No Negativo
  stock_minimo >= 0
  
FR-40.14: Validar Unidad Medida Seleccionada
  unidad_id != null AND unidad_id existe en tabla UnidadMedida
```

**GRUPO 3: Validaciones de Negocio (FR-40.15 a FR-40.19)**

```
FR-40.15: Validar Categoría Existe
  Query: SELECT id FROM Categoria WHERE id = ? AND activa = 1
  Si no existe: "Categoría inválida"
  
FR-40.16: Validar Proveedor Existe (si se ingresó)
  Si proveedor_id != null:
    Query: SELECT id FROM Proveedor WHERE id = ?
    Si no existe: "Proveedor no encontrado"
  
FR-40.17: Validar Fecha Vencimiento en Futuro (si se ingresó)
  Si fecha_vencimiento != null:
    fecha_vencimiento >= hoy
    Mensaje: "Fecha de vencimiento debe ser futura"
  
FR-40.18: Validar Precio con 2 Decimales
  precio con máximo 2 decimales
  Ejemplo: 123.45 ✓, 123.456 ✗
  
FR-40.19: Normalizar CAS Number Antes de Validar
  1. Trim espacios
  2. Convertir a uppercase (si aplica)
  3. Verificar solo dígitos y guiones
```

**GRUPO 4: Mensajes de Error (FR-40.20 a FR-40.25)**

```
FR-40.20: Mostrar Error de Formato CAS
  [ESPECIFICADO en FR-40.6]
  Mensaje: "CAS inválido. Formato: XXX-XX-X"
  Ubicación: Debajo del campo
  
FR-40.21: Mostrar Error CAS Duplicado
  Mensaje: "Ya existe un producto con CAS {cas}: {nombre_existente}"
  Link: "Ver producto existente"
  Color: Amarillo (warning, no error)
  
FR-40.22: Resaltar Campos con Error
  Borde rojo (#dc3545)
  Ícono ⚠️ al lado derecho
  
FR-40.23: Preservar Datos en Formulario al Fallar
  NO limpiar campos cuando hay error.
  Usuario puede corregir sin reescribir todo.
  
FR-40.24: Deshabilitar Submit con Errores
  Botón "Guardar" disabled mientras haya algún error.
  Tooltip: "Corrija los errores antes de guardar"
  
FR-40.25: Limpiar Error al Corregir
  onChange de campo → re-validar → quitar error si ahora es válido
```

**GRUPO 5: Verificación de Unicidad (FR-40.40 a FR-40.44)**

```
FR-40.40: Query de Verificación CAS
  SELECT id, nombre FROM Producto WHERE cas_number = ?
  
FR-40.41: Lógica de Unicidad para CREATE
  Si result.count = 0 → CAS único → OK
  Si result.count > 0 → CAS duplicado → Error
  
FR-40.42: Lógica de Unicidad para UPDATE
  Si result.count = 1 AND result.id = producto_actual_id → OK
  Si result.count > 0 AND result.id != producto_actual_id → Error
  
FR-40.43: Mensaje de CAS Duplicado con Detalles
  "CAS {cas} ya registrado en producto ID {id}: {nombre}"
  "Última actualización: {fecha}"
  Link: "Ver detalles del producto"
  
FR-40.44: Sugerir CAS Similar (Opcional - Could Have)
  Si CAS inválido por 1 dígito, sugerir CAS válidos similares.
  Ejemplo: Usuario ingresó "50-00-1" (checksum incorrecto)
           Sugerir: "¿Quiso decir 50-00-0?"
```

**GRUPO 6: Persistencia (FR-40.50 a FR-40.59)**

```
FR-40.50: Guardar Producto en BD
  [YA ESPECIFICADO EN SECCIÓN 2.3]
  Transacción ACID con INSERT + Auditoría
  
FR-40.51: Generar ID Auto-incremental
  Campo id con AUTO_INCREMENT (MySQL/PostgreSQL sequence)
  
FR-40.52: Establecer Valores Default
  • stock_actual = 0
  • activo = TRUE
  • fecha_creacion = NOW()
  • usuario_creador_id = current_user.id
  
FR-40.53: Registrar Auditoría
  INSERT INTO AuditoriaLog:
    tabla = 'Producto'
    operacion = 'INSERT'
    registro_id = nuevo_id
    usuario_id = current_user.id
    fecha_hora = NOW()
    ip_origen = request.ip
    datos_json = JSON(producto)
  
FR-40.54: Rollback en Caso de Error
  Si INSERT o auditoría fallan → ROLLBACK completo
  Base de datos queda en estado consistente
  
FR-40.55: Commit Solo si Todo Exitoso
  COMMIT solo después de:
    • INSERT exitoso
    • Auditoría exitosa
    • Validaciones post-insert OK
  
FR-40.56: Retornar ID del Nuevo Producto
  Function debe retornar: {id: 1234, mensaje: "OK"}
  
FR-40.57: Manejo de Excepciones SQL
  Catch: ConstraintViolationException (CAS duplicado)
  Catch: ConnectionException (BD caída)
  Catch: TimeoutException (operación lenta)
  
FR-40.58: Logging de Operación
  Log INFO: "Producto {id} creado por usuario {user_id}"
  Log ERROR: "Error al crear producto: {error_message}"
  
FR-40.59: Invalidar Cache (si existe)
  cache.delete("productos:lista")
  cache.delete("productos:count")
```

**GRUPO 7: Post-Guardado (FR-40.60 a FR-40.69)**

```
FR-40.60: Mostrar Mensaje de Éxito
  Toast notification verde en esquina superior derecha
  Mensaje: "Producto '{nombre}' registrado exitosamente"
  Duración: 5 segundos
  Auto-dismiss
  
FR-40.61: Actualizar Lista de Productos
  Si usuario está en pantalla de lista:
    • Re-fetch datos
    • O agregar nuevo producto al final de la lista
    • Highlight el nuevo producto (fondo amarillo suave)
  
FR-40.62: Limpiar Formulario (Opcional)
  Después de guardado exitoso:
    Opción A: Limpiar form para permitir agregar otro
    Opción B: Mantener form y deshabilitar (solo ver)
    Usuario decide: "¿Agregar otro producto?" [Sí] [No]
  
FR-40.63: Redireccionar a Detalle (Opcional)
  Después de guardar:
    Redirigir a /productos/{id} (vista de detalle)
    Con mensaje de éxito persistente
  
FR-40.64: Notificar si Producto es Clase 5
  Si clase_peligrosidad = 5:
    • Enviar email a admin@lab.com
    • Asunto: "Nuevo producto clase 5 registrado: {nombre}"
    • Cuerpo: Detalles del producto + link
  
FR-40.65: Establecer Estado Inicial Según Clase
  Si clase_peligrosidad <= 4:
    estado = 'Activo'
  Si clase_peligrosidad = 5:
    estado = 'Pendiente_Aprobacion' (por BR-015)
  
FR-40.66: Publicar Evento "ProductoCreado"
  Event bus: publish({
    event: "ProductoCreado",
    producto_id: nuevo_id,
    timestamp: NOW()
  })
  Otros módulos pueden subscribirse (ej: notificaciones)
  
FR-40.67: Generar QR Code del Producto (Opcional - Could Have)
  Generar QR con URL: https://lab.com/productos/{id}
  Guardar imagen QR en storage
  Link para imprimir etiqueta
  
FR-40.68: Inicializar Historial de Movimientos
  Crear primer registro en tabla MovimientoStock:
    tipo = 'INVENTARIO_INICIAL'
    cantidad = 0
    fecha = NOW()
  
FR-40.69: Actualizar Contadores/Estadísticas
  UPDATE Estadistica SET total_productos = total_productos + 1
```

**GRUPO 8: Flujos Alternos (FR-40.70 a FR-40.79)**

```
FR-40.70: Manejar Error de BD
  FA-3: Si BD no responde
  • Mostrar modal: "Error de conexión. Intente nuevamente."
  • Botón [Reintentar] → vuelve a paso 7
  • Botón [Cancelar] → cierra modal, mantiene form
  • Loggear error con stack trace
  
FR-40.71: Confirmar Cancelación
  FA-4: Usuario hace clic en "Cancelar"
  • Si form tiene datos: Modal "¿Descartar cambios?"
  • Si form vacío: Cerrar directamente
  • [Descartar] → limpiar form, redirigir
  • [Continuar Editando] → mantener form
  
FR-40.72: Manejar Sesión Expirada
  FA-5: Token JWT expirado
  • Detectar error 401 Unauthorized
  • Modal: "Su sesión ha expirado"
  • [Ir a Login] → redirigir, preservar URL return
  • Después de re-login → volver a form con datos preservados
  
FR-40.73: Manejar Sin Permisos
  FA-6: Usuario sin rol Coordinador
  • Detectar error 403 Forbidden
  • Modal: "No tiene permisos para crear productos"
  • [Aceptar] → redirigir a home
  • Loggear intento de acceso no autorizado
  
FR-40.74: Manejar Catálogos No Disponibles
  FA-7: Servicio de catálogos caído
  • Dropdown Categoría muestra: "Error al cargar categorías"
  • Botón [Recargar]
  • Deshabilitar submit hasta que catálogos carguen
  
FR-40.75: Manejar Timeout de Transacción
  FA-8: INSERT tarda > 30 segundos
  • Detectar TimeoutException
  • Modal: "La operación tardó demasiado. Verifica en lista si se guardó."
  • Loggear timeout para análisis
  
FR-40.76: Retry Lógico con Exponential Backoff
  Si error de BD es transitorio (timeout, connection):
    • Retry 1: después de 1 segundo
    • Retry 2: después de 2 segundos
    • Retry 3: después de 4 segundos
    • Después de 3 retries → mostrar error final
  
FR-40.77: Preservar Estado en SessionStorage
  Cada onChange → guardar en sessionStorage
  Si usuario recarga página → restaurar datos
  Útil para evitar pérdida de datos
  
FR-40.78: Validar Permisos en Backend
  Aunque UI valida permisos, backend DEBE re-validar:
  • Verificar JWT válido
  • Verificar rol permite 'productos.crear'
  • Si no autorizado → 403 Forbidden
  
FR-40.79: Rate Limiting en Creación de Productos
  Prevenir abuso:
  • Máximo 10 productos por usuario por hora
  • Si excede → error "Demasiadas solicitudes. Intente en {minutes} minutos"
```

**GRUPO 9: Seguridad y Auditoría (FR-40.80 a FR-40.89)**

```
FR-40.80: Sanitizar Inputs Antes de Guardar
  • Escapar HTML tags en campos de texto
  • Prevenir XSS: <script> → &lt;script&gt;
  • Aplicar a: nombre, descripción, ubicación
  
FR-40.81: Validar CSRF Token
  • Cada form submit incluye CSRF token
  • Backend valida token antes de procesar
  • Si inválido → 403 Forbidden
  
FR-40.82: Prevenir SQL Injection
  • Usar prepared statements (nunca concatenar SQL)
  • Validar tipos de datos (precio = int, no string)
  
FR-40.83: Auditar IP de Origen
  Registrar en AuditoriaLog:
    • IP address del request
    • User agent (browser)
    • Timestamp preciso (con microsegundos)
  
FR-40.84: Limitar Tamaño de Inputs
  • nombre: max 200 caracteres
  • descripcion: max 2000 caracteres
  • ubicacion: max 100 caracteres
  • Prevenir buffer overflow o DoS
  
FR-40.85: Validar Content-Type del Request
  • Esperar: application/json o multipart/form-data
  • Si otro → rechazar con 415 Unsupported Media Type
  
FR-40.86: Implementar Rate Limiting por IP
  • Máximo 100 requests por minuto por IP
  • Si excede → 429 Too Many Requests
  
FR-40.87: Loggear Intentos de Crear Productos Duplicados
  Si CAS ya existe:
    • Log WARNING con usuario, CAS, timestamp
    • Análisis post: detectar intentos maliciosos
  
FR-40.88: Encriptar Datos Sensibles (si aplica)
  Si hay campos sensibles (ej: costo real):
    • Encriptar con AES-256 antes de guardar
    • Desencriptar al leer
  
FR-40.89: Verificar Integridad con Hash (Opcional - Could Have)
  Calcular SHA-256 hash del registro completo
  Guardar hash en campo 'integridad'
  Al leer → re-calcular y comparar (detectar manipulación)
```

**GRUPO 10: Performance y Optimización (FR-40.90 a FR-40.99)**

```
FR-40.90: Índice en cas_number
  CREATE UNIQUE INDEX idx_cas_number ON Producto(cas_number)
  Mejora verificación de unicidad de O(n) a O(log n)
  
FR-40.91: Índice en categoria_id
  CREATE INDEX idx_categoria ON Producto(categoria_id)
  Mejora JOINs con tabla Categoria
  
FR-40.92: Batch Insert (No aplica a UC-40, pero bueno saber)
  Si se crean múltiples productos:
    • Usar INSERT con múltiples VALUES
    • Más eficiente que INSERT individual
  
FR-40.93: Lazy Loading de Catálogos
  • Cargar categorías solo cuando dropdown se abre
  • Reduce carga inicial de página
  
FR-40.94: Comprimir Response JSON
  • Server envía con gzip compression
  • Reduce bandwidth
  
FR-40.95: Pagination en Autocomplete de Proveedores
  • Cargar 20 proveedores a la vez
  • Infinite scroll o "Cargar más"
  
FR-40.96: Debounce en Validación de CAS
  • Validar CAS 500ms después de último keystroke
  • Evita validaciones excesivas mientras usuario escribe
  
FR-40.97: Cache de Catálogos
  • Cachear Categorías, Unidades por 1 hora
  • Reduce queries a BD
  
FR-40.98: Async Validation (Opcional - Could Have)
  • Validar unicidad de CAS en background (onChange)
  • Mostrar "Verificando..." mientras valida
  • Usuario puede seguir llenando otros campos
  
FR-40.99: Metrics y Monitoring
  • Medir tiempo de INSERT (performance)
  • Alertar si > 1 segundo (anormal)
  • Dashboard de operaciones CUD
```

---

### 3.5 Resumen del Ejercicio

**Derivación completa de UC-40:**

```
UC-40: Registrar Nuevo Producto
  • Flujo normal: 9 pasos
  • Flujos alternos: 8 FAs
  • Precondiciones: 3
  • Postcondiciones: 5
  • Business Rules: 3

↓ DERIVACIÓN ↓

FR derivados: 99 FR
  • UI/Presentación: 5 FR (FR-40.1 a 40.5)
  • Validaciones Formato: 9 FR (FR-40.6 a 40.14)
  • Validaciones Negocio: 5 FR (FR-40.15 a 40.19)
  • Mensajes Error: 6 FR (FR-40.20 a 40.25)
  • Unicidad CAS: 5 FR (FR-40.40 a 40.44)
  • Persistencia: 10 FR (FR-40.50 a 40.59)
  • Post-Guardado: 10 FR (FR-40.60 a 40.69)
  • Flujos Alternos: 10 FR (FR-40.70 a 40.79)
  • Seguridad/Auditoría: 10 FR (FR-40.80 a 40.89)
  • Performance: 10 FR (FR-40.90 a 40.99)

Ratio final: 1 UC → 99 FR
  (En proyecto real: filtrar por prioridad, ~60 Must Have)
```

**Lecciones del ejercicio:**

```
✅ UC simple puede generar 50-100 FR si se descompone exhaustivamente

✅ Agrupar FR en categorías facilita organización

✅ Priorización es CRÍTICA (Must vs Could Have)

✅ FR de seguridad/performance son transversales (aplican a múltiples UC)

✅ Documentar bien 1 UC facilita derivar los demás (patrón se repite)
```

---

### 3.6 Checklist de Derivación

**Al derivar FR desde un UC, verificar:**

```
□ Cada paso del flujo normal tiene al menos 1 FR

□ Cada flujo alterno tiene FR para manejo de error

□ Precondiciones derivan FR de seguridad/validación

□ Postcondiciones derivan FR de efectos observables

□ Business Rules tienen FR que las implementan

□ Cada validación tiene FR con:
  - Regla específica
  - Mensaje de error
  - Comportamiento UI

□ Cada operación de BD tiene FR con:
  - SQL/query exacto
  - Manejo de transacciones
  - Rollback en error

□ Cada mensaje al usuario tiene FR de UI

□ Aspectos cross-cutting cubiertos:
  - Auditoría
  - Logging
  - Seguridad
  - Performance

□ FR están numerados secuencialmente (FR-40.1, 40.2, ...)

□ Cada FR tiene prioridad asignada (MoSCoW)

□ Cada FR tiene criterios de aceptación

□ FR tienen trazabilidad a UC/BR origen
```

**Próxima Sección:**

Sección 4: Clasificación de FR
- Categorías de FR por naturaleza
- Patrones comunes
- Ejemplos por categoría

**Fin de Sección 3**

P4S3EOF
