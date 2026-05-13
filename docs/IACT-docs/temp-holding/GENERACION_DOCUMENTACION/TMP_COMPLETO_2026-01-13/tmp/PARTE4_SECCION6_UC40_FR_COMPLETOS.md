## 6. EJEMPLO COMPLETO: UC-40 → REQUERIMIENTOS FUNCIONALES

### 6.1 UC-40 de Referencia (Resumen)

```
UC-40: Registrar Nuevo Producto Químico

Flujo Normal: 9 pasos
Flujos Alternos: 8 FAs
Precondiciones: Usuario autenticado, rol Coordinador
Postcondiciones: Producto guardado, auditoría registrada

Complejidad: Media-Alta
FR esperados: ~60 FR Must Have
Tiempo derivación: 4-6 horas
```

---

### 6.2 LISTA COMPLETA DE FR DERIVADOS

```
GRUPO 1: UI/Presentación (5 FR)
  FR-40.1 a FR-40.5

GRUPO 2: Validaciones Formato (10 FR)
  FR-40.6 a FR-40.15

GRUPO 3: Validaciones Negocio (10 FR)
  FR-40.16 a FR-40.25

GRUPO 4: Unicidad CAS (5 FR)
  FR-40.26 a FR-40.30

GRUPO 5: Persistencia (10 FR)
  FR-40.31 a FR-40.40

GRUPO 6: Post-Guardado (10 FR)
  FR-40.41 a FR-40.50

GRUPO 7: Seguridad (5 FR)
  FR-40.51 a FR-40.55

GRUPO 8: Auditoría (3 FR)
  FR-40.56 a FR-40.58

GRUPO 9: Performance (2 FR)
  FR-40.59 a FR-40.60

TOTAL: 60 FR Must Have
```

---

### 6.3 FR COMPLETOS - GRUPO 1: UI/PRESENTACIÓN

```
═══════════════════════════════════════════════════════════════
FR-40.1: Mostrar Formulario de Registro de Producto
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-40.1
CATEGORÍA: UI/Presentación
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE mostrar formulario con 11 campos organizados en 3 grupos:
  
  GRUPO "Datos Básicos":
    • Nombre (text, obligatorio, max 200 chars)
    • CAS Number (text, obligatorio, formato XXX-XX-X)
    • Categoría (dropdown, obligatorio, desde BD)
    • Clase Peligrosidad (radio 1-5, obligatorio, default 1)
  
  GRUPO "Inventario":
    • Precio Unitario (number, obligatorio, min 0.01, 2 decimales)
    • Stock Mínimo (integer, obligatorio, min 0)
    • Unidad Medida (dropdown, obligatorio, desde BD)
  
  GRUPO "Opcionales":
    • Proveedor (autocomplete, opcional)
    • Descripción (textarea, opcional, max 2000 chars)
    • Ubicación Almacén (text, opcional, max 100 chars)
    • Fecha Vencimiento (date picker, opcional, min hoy)

ORIGEN: UC-40 Paso 2
RELACIONADO: BR-012, BR-015

CRITERIOS DE ACEPTACIÓN:
  AC-1: Form muestra 11 campos correctamente agrupados
    GIVEN usuario con permisos accede a /productos/nuevo
    WHEN página carga
    THEN formulario renderiza con 3 secciones
    AND cada campo tiene label, placeholder, hint apropiados
    
  AC-2: Campos obligatorios marcados visualmente
    GIVEN formulario visible
    THEN campos obligatorios muestran asterisco (*) rojo
    AND hover en asterisco muestra tooltip "Obligatorio"
    
  AC-3: Valores default establecidos
    GIVEN formulario nuevo (no edición)
    THEN Clase Peligrosidad = 1 (seleccionado)
    AND Stock Mínimo = 10
    AND Precio Unitario = 0.00

CASOS DE PRUEBA:
  TC-40.1.1: Renderizar form en desktop (>= 768px)
  TC-40.1.2: Renderizar form en mobile (< 768px, layout 1 columna)
  TC-40.1.3: Campos obligatorios con asterisco
  TC-40.1.4: Tooltips en hover

DEPENDENCIAS:
  Requiere: FR-110.X (usuario autenticado)
  Es requerido por: Todos los FR-40.X

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-40.2: Cargar Catálogos en Dropdowns
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-40.2
CATEGORÍA: UI/Presentación
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE cargar datos en dropdowns desde BD:
  
  Dropdown "Categoría":
    Query: SELECT id, nombre FROM Categoria WHERE activa = 1 ORDER BY nombre
    Primera opción: "-- Seleccione Categoría --" (valor null)
    
  Dropdown "Unidad Medida":
    Query: SELECT id, nombre, abreviacion FROM UnidadMedida WHERE activa = 1 ORDER BY nombre
    Display: "{nombre} ({abreviacion})" ej: "Litros (L)"
    Primera opción: "-- Seleccione Unidad --"

CRITERIOS DE ACEPTACIÓN:
  AC-1: Categorías cargadas correctamente
    GIVEN BD tiene 10 categorías activas
    WHEN dropdown Categoría se abre
    THEN muestra 11 opciones (1 default + 10 categorías)
    AND ordenadas alfabéticamente
    
  AC-2: Si error al cargar catálogos
    GIVEN servicio de catálogos no responde
    WHEN form intenta cargar
    THEN dropdown muestra "Error al cargar. [Reintentar]"
    AND submit button deshabilitado

═══════════════════════════════════════════════════════════════
```

---

### 6.4 FR COMPLETOS - GRUPO 2: VALIDACIONES

```
[FR-40.6 ya especificado en Sección 2.2 - no duplicar]

═══════════════════════════════════════════════════════════════
FR-40.7: Validar Checksum de CAS Number
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-40.7
CATEGORÍA: Validación
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE validar checksum del CAS Number según algoritmo oficial.
  
  Algoritmo:
    1. Remover guiones: "50-00-0" → "50000"
    2. Separar check digit (último): "5000" y "0"
    3. Invertir secuencia principal: "5000" → "0005"
    4. Multiplicar cada dígito por posición (1-indexed):
       0×1 + 0×2 + 0×3 + 5×4 = 20
    5. Calcular módulo 10: 20 % 10 = 0
    6. Comparar con check digit: 0 == 0 → VÁLIDO
  
  Ejemplo inválido:
    Input: "50-00-1" (check digit incorrecto)
    Cálculo: 20 % 10 = 0
    Comparación: 0 != 1 → INVÁLIDO

CRITERIOS DE ACEPTACIÓN:
  AC-1: CAS con checksum válido
    GIVEN CAS "50-00-0"
    WHEN valida checksum
    THEN validación pasa
    
  AC-2: CAS con checksum inválido
    GIVEN CAS "50-00-1"
    WHEN valida checksum
    THEN validación falla
    AND mensaje "CAS Number inválido (checksum incorrecto)"
    
  AC-3: Varios CAS reales válidos
    GIVEN CAS "67-64-1" (acetona)
    OR "7732-18-5" (agua)
    OR "1333-74-0" (hidrógeno)
    WHEN valida
    THEN todos pasan

NOTAS TÉCNICAS:
  • Validar checksum DESPUÉS de validar formato (FR-40.6)
  • Si formato inválido, skip checksum validation
  • Logging: loggear CAS con checksum inválido (posible typo usuario)

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-40.8 a FR-40.15: Validaciones de Campos
═══════════════════════════════════════════════════════════════

[Por brevedad, listo los 8 FR restantes de validación]

FR-40.8: Validar Nombre No Vacío
  Regla: trim(nombre) != ""
  Mensaje: "Nombre es obligatorio"

FR-40.9: Validar Longitud Nombre
  Regla: length(nombre) <= 200
  Mensaje: "Nombre máximo 200 caracteres"

FR-40.10: Validar Categoría Seleccionada
  Regla: categoria_id != null AND existe en BD
  Query: SELECT 1 FROM Categoria WHERE id = ? AND activa = 1

FR-40.11: Validar Clase Peligrosidad Rango
  Regla: clase >= 1 AND clase <= 5
  Mensaje: "Clase debe ser entre 1 y 5"

FR-40.12: Validar Precio Positivo
  Regla: precio > 0
  Mensaje: "Precio debe ser mayor a 0"

FR-40.13: Validar Stock Mínimo No Negativo
  Regla: stock_minimo >= 0
  Mensaje: "Stock mínimo no puede ser negativo"

FR-40.14: Validar Precio con 2 Decimales
  Regla: precio.decimales <= 2
  Ejemplo válido: 123.45
  Ejemplo inválido: 123.456

FR-40.15: Validar Fecha Vencimiento Futura (si ingresada)
  Regla: SI fecha_vencimiento != null ENTONCES fecha_vencimiento >= hoy
  Mensaje: "Fecha de vencimiento debe ser futura"

═══════════════════════════════════════════════════════════════
```

---

### 6.5 FR COMPLETOS - GRUPO 5: PERSISTENCIA

```
[FR-40.50 ya especificado en Sección 2.3 - referencia]

═══════════════════════════════════════════════════════════════
FR-40.35: Ejecutar Transacción ACID para Guardado
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-40.35
CATEGORÍA: Persistencia
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE ejecutar guardado en transacción ACID:
  
  BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  
  1. INSERT en Producto
  2. INSERT en AuditoriaLog
  3. UPDATE Estadistica (total_productos)
  4. Si error en CUALQUIER paso → ROLLBACK
  5. Si todos exitosos → COMMIT
  
  END TRANSACTION;

CRITERIOS DE ACEPTACIÓN:
  AC-1: Transacción completa exitosa
    GIVEN producto válido
    WHEN guarda
    THEN 3 operaciones ejecutadas
    AND COMMIT exitoso
    AND producto_id retornado
    
  AC-2: Error en paso 2 → rollback de paso 1
    GIVEN INSERT producto exitoso
    AND INSERT auditoría falla
    WHEN error ocurre
    THEN ROLLBACK automático
    AND producto NO existe en BD
    AND BD en estado consistente
    
  AC-3: Nivel aislamiento SERIALIZABLE
    GIVEN 2 usuarios guardan producto con mismo CAS simultáneamente
    WHEN ambos ejecutan transacción
    THEN solo uno tiene éxito (COMMIT)
    AND el otro recibe error de unicidad
    AND NO hay race condition

NOTAS TÉCNICAS:
  • PostgreSQL: SERIALIZABLE detecta conflictos de serialización
  • MySQL: Usar InnoDB (no MyISAM, no tiene transacciones)
  • SQLite: SERIALIZABLE por default
  • Retry lógico recomendado si deadlock (max 3 intentos)

═══════════════════════════════════════════════════════════════
```

---

### 6.6 MATRIZ DE TRAZABILIDAD UC-40 → FR

```
┌────────────────────┬───────────────────────┬─────────────────┐
│ Paso UC-40         │ FR Derivados          │ Cantidad        │
├────────────────────┼───────────────────────┼─────────────────┤
│ 1. Usuario         │ FR-40.70 (permisos)   │ 1 FR            │
│    selecciona      │                       │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 2. Sistema muestra │ FR-40.1, 40.2         │ 2 FR            │
│    formulario      │                       │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 3. Usuario ingresa │ (Acción de usuario,   │ 0 FR            │
│    datos           │  no genera FR)        │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 4. Usuario hace    │ (Acción UI,           │ 0 FR            │
│    clic Guardar    │  no genera FR)        │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 5. Sistema valida  │ FR-40.6 a 40.25       │ 20 FR           │
│    datos           │ (validaciones)        │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 6. Sistema verifica│ FR-40.26 a 40.30      │ 5 FR            │
│    unicidad CAS    │                       │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 7. Sistema guarda  │ FR-40.31 a 40.40      │ 10 FR           │
│    en BD           │ (persistencia)        │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 8. Sistema muestra │ FR-40.41, 40.42       │ 2 FR            │
│    mensaje éxito   │                       │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ 9. Sistema         │ FR-40.43, 40.44       │ 2 FR            │
│    actualiza lista │                       │                 │
├────────────────────┼───────────────────────┼─────────────────┤
│ Precondiciones     │ FR-40.70, 40.71       │ 2 FR            │
├────────────────────┼───────────────────────┼─────────────────┤
│ Postcondiciones    │ FR-40.45 a 40.50      │ 6 FR            │
├────────────────────┼───────────────────────┼─────────────────┤
│ Flujos Alternos    │ FR-40.72 a 40.79      │ 8 FR            │
├────────────────────┼───────────────────────┼─────────────────┤
│ Cross-cutting      │ FR-40.51 a 40.60      │ 10 FR           │
│ (seguridad, audit) │                       │                 │
└────────────────────┴───────────────────────┴─────────────────┘

TOTAL: 60 FR Must Have derivados de UC-40
```

---

### 6.7 DISTRIBUCIÓN POR PRIORIDAD

```
Must Have (Críticos): 45 FR
  • Sin estos FR, UC-40 no funciona
  • Validaciones esenciales
  • Persistencia básica
  • Seguridad mínima

Should Have (Importantes): 10 FR
  • Mejoran UX significativamente
  • Validaciones adicionales
  • Auditoría completa
  • Cache optimization

Could Have (Deseables): 5 FR
  • Features "nice to have"
  • QR code generation
  • Advanced autocomplete
  • Export to Excel

Won't Have (Fuera de scope): 0 FR
  • Ninguno en UC-40 clasificado como Won't
```

---

### 6.8 ESTIMACIÓN DE IMPLEMENTACIÓN

```
POR GRUPO DE FR:

UI/Presentación (5 FR): 8 horas
  • Form components
  • Layout responsive
  • Validation UI

Validaciones (20 FR): 16 horas
  • Regex patterns
  • Business logic
  • Error messages
  • Edge cases

Persistencia (10 FR): 12 horas
  • Transacciones ACID
  • Rollback handling
  • Auditoría
  • Error recovery

Post-Guardado (10 FR): 6 horas
  • Mensajes
  • Redirecciones
  • Cache invalidation

Seguridad (5 FR): 6 horas
  • CSRF tokens
  • XSS prevention
  • Rate limiting

Testing (todos): 12 horas
  • Unit tests
  • Integration tests
  • E2E tests

TOTAL UC-40: 60 horas (~2 semanas 1 developer)
```

**Fin de Sección 6**

P4S6EOF
