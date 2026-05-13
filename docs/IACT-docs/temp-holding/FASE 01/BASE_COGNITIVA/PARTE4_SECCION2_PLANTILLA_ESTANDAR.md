## 2. PLANTILLA ESTÁNDAR DE FR

### 2.1 Campos de la Plantilla

#### 2.1.1 Plantilla Completa

```
═══════════════════════════════════════════════════════════════
FR-[UC].[Número]: [Nombre Descriptivo del FR]
═══════════════════════════════════════════════════════════════

IDENTIFICADOR:
  FR-[UC].[Número]
  Ejemplo: FR-40.6

NOMBRE:
  [Nombre descriptivo en español, verbo imperativo]
  Ejemplo: "Validar Formato de CAS Number"

DESCRIPCIÓN:
  [Descripción detallada del comportamiento requerido]
  [Usar lenguaje imperativo: DEBE, NO DEBE]
  [Especificar EXACTAMENTE qué debe hacer el sistema]
  
  El sistema DEBE [acción específica] cuando [condición].
  
  Si [condición], entonces [comportamiento].
  
  [Incluir detalles técnicos necesarios: formato, algoritmo, etc.]

CATEGORÍA:
  [Tipo de FR según clasificación]
  Opciones:
    • Validación
    • Cálculo/Procesamiento
    • Persistencia
    • UI/Presentación
    • Integración
    • Seguridad
    • Auditoría
    • Notificación
    • Reportes
    • Navegación

PRIORIDAD (MoSCoW):
  [Must Have | Should Have | Could Have | Won't Have]
  
  Must Have:    Crítico, sin esto el sistema no funciona
  Should Have:  Importante, pero puede postergarse
  Could Have:   Deseable, pero no esencial
  Won't Have:   Fuera de scope actual

ORIGEN/TRAZABILIDAD:
  Deriva de: UC-[X] Paso [N]
  Relacionado con: BR-[Y]
  Motivación: [Por qué es necesario este FR]

PRECONDICIONES:
  • [Condición 1 que debe cumplirse antes]
  • [Condición 2 que debe cumplirse antes]
  
POSTCONDICIONES:
  • [Estado resultante después de ejecutar]
  • [Efecto observable en el sistema]

REGLAS DE NEGOCIO:
  • BR-[X]: [Descripción de la regla]
  • BR-[Y]: [Descripción de la regla]

ESPECIFICACIÓN TÉCNICA:
  [Detalles técnicos específicos]
  
  Input:
    • Campo/Parámetro 1: [tipo, formato, rango]
    • Campo/Parámetro 2: [tipo, formato, rango]
  
  Proceso:
    • Paso 1: [Qué hace exactamente]
    • Paso 2: [Algoritmo, cálculo, validación]
  
  Output:
    • Resultado: [tipo, formato]
    • Mensaje: [texto exacto]
  
  Algoritmo (si aplica):
    [Pseudocódigo o descripción detallada]
    [Fórmulas matemáticas]
    [Regex específico]

CRITERIOS DE ACEPTACIÓN:
  [Formato Given-When-Then]
  
  AC-1:
    GIVEN [contexto/estado inicial]
    WHEN [acción ejecutada]
    THEN [resultado esperado]
    AND [resultado adicional]
  
  AC-2:
    GIVEN [contexto]
    WHEN [acción]
    THEN [resultado]

MENSAJES:
  Mensaje de error:
    Texto: "[Mensaje exacto mostrar al usuario]"
    Tipo: Error | Warning | Info
    Ubicación: [Dónde se muestra]
  
  Mensaje de éxito:
    Texto: "[Mensaje exacto]"

VALIDACIONES RELACIONADAS:
  • FR-[A]: [Validación dependiente]
  • FR-[B]: [Validación relacionada]

CASOS DE PRUEBA SUGERIDOS:
  TC-[FR].1: [Caso válido - happy path]
  TC-[FR].2: [Caso inválido - error esperado]
  TC-[FR].3: [Caso límite - boundary]

DEPENDENCIAS:
  Depende de:
    • FR-[X]: [Descripción dependencia]
  
  Es requerido por:
    • FR-[Y]: [Descripción]

NOTAS TÉCNICAS:
  [Consideraciones de implementación]
  [Performance considerations]
  [Security considerations]
  [Limitaciones conocidas]

REFERENCIAS:
  • Documentación: [URL o documento]
  • Estándares: [RFC, ISO, etc.]
  • Código existente: [módulo, clase]

HISTORIAL:
  Versión 1.0 - [Fecha] - [Autor] - Creación inicial
  Versión 1.1 - [Fecha] - [Autor] - [Cambio realizado]

═══════════════════════════════════════════════════════════════
```

#### 2.1.2 Campos Obligatorios vs Opcionales

```
OBLIGATORIOS (Siempre deben estar):
  ✓ IDENTIFICADOR (FR-XX.YY)
  ✓ NOMBRE (descriptivo)
  ✓ DESCRIPCIÓN (detallada)
  ✓ CATEGORÍA (tipo de FR)
  ✓ PRIORIDAD (MoSCoW)
  ✓ ORIGEN/TRAZABILIDAD (UC/BR)
  ✓ CRITERIOS DE ACEPTACIÓN (mínimo 2)

OPCIONALES (Según el tipo de FR):
  ○ PRECONDICIONES (si aplica)
  ○ POSTCONDICIONES (si aplica)
  ○ REGLAS DE NEGOCIO (si está ligado a BR)
  ○ ESPECIFICACIÓN TÉCNICA (si es complejo)
  ○ ALGORITMO (si requiere cálculo especial)
  ○ MENSAJES (si hay interacción con usuario)
  ○ VALIDACIONES RELACIONADAS (si forma parte de cadena)
  ○ DEPENDENCIAS (si depende de otros FR)
  ○ NOTAS TÉCNICAS (consideraciones especiales)

NO INCLUIR en FR (va en otros documentos):
  ✗ Código de implementación real
  ✗ Diseño de base de datos (va en diseño)
  ✗ Arquitectura del sistema (va en diseño)
  ✗ Plan de testing detallado (va en plan de QA)
  ✗ Cronograma de implementación (va en plan de proyecto)
```

---

### 2.2 Ejemplo Completo: FR de Validación

```
═══════════════════════════════════════════════════════════════
FR-40.6: Validar Formato de CAS Number
═══════════════════════════════════════════════════════════════

IDENTIFICADOR:
  FR-40.6

NOMBRE:
  Validar Formato de CAS Number

DESCRIPCIÓN:
  El sistema DEBE validar que el CAS Number ingresado en el 
  campo 'cas_number' del formulario de registro de producto 
  químico cumpla con el formato estándar XXX-XX-X establecido 
  por Chemical Abstracts Service.
  
  Formato válido:
    - Primer bloque: 2 a 7 dígitos (parte 1)
    - Segundo bloque: exactamente 2 dígitos (parte 2)
    - Tercer bloque: exactamente 1 dígito (check digit)
    - Separadores: guiones (-) entre bloques
  
  Ejemplos válidos:
    • 50-00-0      (formaldehído)
    • 67-64-1      (acetona)
    • 7732-18-5    (agua)
    • 1333-74-0    (hidrógeno)
  
  Ejemplos inválidos:
    • 12-345-6     (segundo bloque 3 dígitos)
    • 1-23-4       (primer bloque 1 dígito)
    • abc-de-f     (letras no permitidas)
    • 123456       (sin separadores)
    • 123-45-      (tercer bloque vacío)

CATEGORÍA:
  Validación

PRIORIDAD (MoSCoW):
  Must Have
  
  Justificación: CAS Number es identificador único internacional
  de productos químicos. Formato incorrecto causa problemas en:
    - Búsquedas de productos
    - Cumplimiento regulatorio (OSHA, EPA)
    - Integración con sistemas externos
    - Reportes legales

ORIGEN/TRAZABILIDAD:
  Deriva de: UC-40 (Registrar Nuevo Producto) - Paso 6
  Relacionado con: BR-012 (CAS Number único y válido)
  Motivación: Garantizar integridad del catálogo de productos

PRECONDICIONES:
  • Usuario ha ingresado texto en el campo cas_number
  • Campo cas_number está habilitado para edición
  • Formulario no está en modo solo-lectura

POSTCONDICIONES:
  • Si válido: Campo marcado como válido (borde verde)
  • Si inválido: Campo marcado como inválido (borde rojo)
  • Mensaje de error visible si formato incorrecto
  • Submit del formulario bloqueado si hay errores

REGLAS DE NEGOCIO:
  • BR-012: CAS Number debe ser único en el sistema
  • BR-013: CAS Number debe cumplir formato oficial
  • BR-014: CAS Number debe pasar validación de checksum

ESPECIFICACIÓN TÉCNICA:
  Input:
    • cas_number: string
    • max_length: 12 caracteres (7+2+1+2 guiones)
    • permite: dígitos 0-9 y guiones (-)
  
  Proceso:
    1. Remover espacios en blanco (trim)
    2. Verificar que no esté vacío
    3. Aplicar regex de validación
    4. Si regex pasa, extraer partes
    5. Verificar longitudes de cada parte
  
  Output:
    • válido: boolean (true/false)
    • mensaje_error: string (si inválido)
  
  Regex:
    Pattern: ^[0-9]{2,7}-[0-9]{2}-[0-9]$
    
    Explicación:
      ^              → inicio de string
      [0-9]{2,7}     → 2 a 7 dígitos (primer bloque)
      -              → guion literal
      [0-9]{2}       → exactamente 2 dígitos (segundo bloque)
      -              → guion literal
      [0-9]          → exactamente 1 dígito (check digit)
      $              → fin de string
  
  Pseudocódigo:
    ```
    function validarFormatoCAS(cas_input):
        // Normalizar
        cas = trim(cas_input)
        
        // Verificar no vacío
        if cas es vacío:
            return {válido: false, error: "CAS Number obligatorio"}
        
        // Aplicar regex
        regex = /^[0-9]{2,7}-[0-9]{2}-[0-9]$/
        
        if NOT regex.test(cas):
            return {válido: false, error: "Formato inválido. Use: XXX-XX-X"}
        
        // Extraer partes
        partes = cas.split("-")
        parte1 = partes[0]  // 2-7 dígitos
        parte2 = partes[1]  // 2 dígitos
        checkDigit = partes[2]  // 1 dígito
        
        // Validar longitudes
        if parte1.length < 2 OR parte1.length > 7:
            return {válido: false, error: "Primera parte: 2-7 dígitos"}
        
        if parte2.length != 2:
            return {válido: false, error: "Segunda parte: exactamente 2 dígitos"}
        
        if checkDigit.length != 1:
            return {válido: false, error: "Check digit: exactamente 1 dígito"}
        
        return {válido: true, error: null}
    ```

CRITERIOS DE ACEPTACIÓN:
  AC-1: CAS válido con 3 dígitos en parte 1
    GIVEN usuario ingresa "50-00-0"
    WHEN sistema valida formato
    THEN validación pasa (válido = true)
    AND NO muestra mensaje de error
    AND campo se marca con borde verde
  
  AC-2: CAS válido con 7 dígitos en parte 1
    GIVEN usuario ingresa "1333-74-0"
    WHEN sistema valida formato
    THEN validación pasa (válido = true)
  
  AC-3: CAS inválido - segundo bloque 3 dígitos
    GIVEN usuario ingresa "12-345-6"
    WHEN sistema valida formato
    THEN validación falla (válido = false)
    AND muestra "Formato inválido. Use: XXX-XX-X"
    AND campo se marca con borde rojo
    AND submit está deshabilitado
  
  AC-4: CAS inválido - primer bloque 1 dígito
    GIVEN usuario ingresa "1-23-4"
    WHEN sistema valida formato
    THEN validación falla (válido = false)
    AND muestra "Formato inválido. Use: XXX-XX-X"
  
  AC-5: CAS inválido - contiene letras
    GIVEN usuario ingresa "abc-de-f"
    WHEN sistema valida formato
    THEN validación falla (válido = false)
    AND muestra "Formato inválido. Use: XXX-XX-X"
  
  AC-6: CAS inválido - sin separadores
    GIVEN usuario ingresa "123456"
    WHEN sistema valida formato
    THEN validación falla (válido = false)
  
  AC-7: CAS vacío
    GIVEN usuario deja campo vacío
    WHEN sistema valida formato
    THEN validación falla (válido = false)
    AND muestra "CAS Number es obligatorio"

MENSAJES:
  Mensaje de error (formato inválido):
    Texto: "CAS Number inválido. Formato correcto: XXX-XX-X 
            (ej: 50-00-0, 7732-18-5)"
    Tipo: Error
    Ubicación: Debajo del campo cas_number
    Color: Rojo (#dc3545)
    Icono: ⚠️
  
  Mensaje de error (vacío):
    Texto: "CAS Number es obligatorio"
    Tipo: Error
    Ubicación: Debajo del campo
  
  Mensaje de éxito:
    NO mostrar mensaje (solo borde verde es suficiente)

VALIDACIONES RELACIONADAS:
  • FR-40.7: Validar Checksum de CAS (se ejecuta después de esta)
  • FR-40.8: Verificar Unicidad de CAS (requiere formato válido)
  • FR-40.9: Normalizar CAS Number (se ejecuta antes de esta)

CASOS DE PRUEBA SUGERIDOS:
  TC-40.6.1: CAS válido formato corto (50-00-0)
  TC-40.6.2: CAS válido formato largo (1333-74-0)
  TC-40.6.3: CAS inválido 2do bloque (12-345-6)
  TC-40.6.4: CAS inválido 1er bloque (1-23-4)
  TC-40.6.5: CAS inválido con letras (abc-de-f)
  TC-40.6.6: CAS inválido sin guiones (123456)
  TC-40.6.7: CAS vacío
  TC-40.6.8: CAS con espacios " 50-00-0 " (debe normalizar)
  TC-40.6.9: CAS solo guiones "---"
  TC-40.6.10: CAS parcialmente completo "50-00-" (incompleto)

DEPENDENCIAS:
  Depende de:
    • FR-40.9: Normalizar CAS (debe ejecutarse primero)
  
  Es requerido por:
    • FR-40.7: Validar Checksum (necesita formato válido)
    • FR-40.8: Verificar Unicidad (necesita formato válido)
    • FR-40.10: Guardar Producto (necesita todas validaciones)

NOTAS TÉCNICAS:
  Performance:
    - Regex es O(n) donde n es longitud del string (~10 chars)
    - Validación completa < 1ms
    - NO requiere llamada a BD (validación local)
  
  UX Considerations:
    - Ejecutar validación en evento "onBlur" (al salir del campo)
    - NO validar en cada keystroke (molesto para el usuario)
    - Opcional: Debounce de 500ms en evento "onChange"
    - Mantener mensaje de error visible hasta que se corrija
  
  Client-side vs Server-side:
    - Client-side: Recomendado para UX inmediata
    - Server-side: OBLIGATORIO (nunca confiar solo en cliente)
    - Validación server debe ser idéntica a client
  
  Internacionalización:
    - Mensaje de error en idioma según configuración usuario
    - Formato CAS es internacional (no cambia por región)
  
  Limitaciones:
    - Esta validación solo verifica FORMATO
    - NO verifica que el CAS exista realmente (eso requiere BD externa)
    - NO verifica el checksum (eso es FR-40.7)

REFERENCIAS:
  • CAS Registry: https://www.cas.org/support/documentation/chemical-substances
  • NIST Chemistry WebBook: https://webbook.nist.gov/chemistry/
  • EPA Chemical Substances: https://www.epa.gov/chemicals-under-tsca

HISTORIAL:
  Versión 1.0 - 2025-12-08 - Analista SR - Creación inicial
  
═══════════════════════════════════════════════════════════════
```

---

### 2.3 Ejemplo Completo: FR de Persistencia

```
═══════════════════════════════════════════════════════════════
FR-40.50: Guardar Producto en Base de Datos
═══════════════════════════════════════════════════════════════

IDENTIFICADOR:
  FR-40.50

NOMBRE:
  Guardar Producto en Base de Datos

DESCRIPCIÓN:
  El sistema DEBE almacenar el nuevo producto químico en la 
  tabla 'Producto' de la base de datos después de que todas 
  las validaciones han sido exitosas.
  
  El sistema DEBE ejecutar una transacción ACID que:
    1. Inserta el registro en tabla Producto
    2. Registra la auditoría en tabla AuditoriaLog
    3. Actualiza contadores/estadísticas si aplica
    4. Commit solo si todo es exitoso
    5. Rollback si hay cualquier error
  
  El sistema NO DEBE permitir commits parciales.

CATEGORÍA:
  Persistencia

PRIORIDAD (MoSCoW):
  Must Have

ORIGEN/TRAZABILIDAD:
  Deriva de: UC-40 (Registrar Nuevo Producto) - Paso 7
  Relacionado con: BR-001 (Todos los cambios deben auditarse)
  Motivación: Persistir datos validados en almacenamiento permanente

PRECONDICIONES:
  • Todas las validaciones (FR-40.6 a FR-40.45) han pasado
  • Usuario tiene permisos para crear productos
  • Sesión de usuario es válida
  • Conexión a base de datos está activa
  • Transacción no está en curso (no hay transacción pendiente)

POSTCONDICIONES:
  Éxito:
    • Producto insertado en tabla con ID auto-generado
    • Auditoría registrada con timestamp UTC
    • Cache invalidado (si existe)
    • Evento "ProductoCreado" publicado (si hay event bus)
    • Usuario recibe mensaje de éxito
  
  Fallo:
    • Rollback completo ejecutado
    • Base de datos en estado consistente (sin cambios)
    • Usuario recibe mensaje de error descriptivo
    • Error loggeado en sistema de logs

REGLAS DE NEGOCIO:
  • BR-001: Toda operación CUD debe auditarse
  • BR-012: CAS Number debe ser único (constraint DB)
  • BR-050: Transacciones deben ser ACID

ESPECIFICACIÓN TÉCNICA:
  Input (Objeto Producto):
    • nombre: string(200)
    • cas_number: string(12)
    • categoria_id: integer
    • clase_peligrosidad: integer(1-5)
    • precio_unitario: decimal(10,2)
    • stock_minimo: integer
    • unidad_medida_id: integer
    • proveedor_id: integer (opcional)
    • descripcion: text (opcional)
    • ubicacion_almacen: string(50) (opcional)
    • fecha_vencimiento: date (opcional)
    • usuario_creador_id: integer (del contexto)
  
  Proceso:
    1. BEGIN TRANSACTION (nivel SERIALIZABLE)
    
    2. Generar timestamp actual (UTC):
         now_utc = getCurrentTimestampUTC()
    
    3. INSERT en tabla Producto:
         INSERT INTO Producto (
           nombre, cas_number, categoria_id, clase_peligrosidad,
           precio_unitario, stock_minimo, unidad_medida_id,
           proveedor_id, descripcion, ubicacion_almacen,
           fecha_vencimiento, stock_actual,
           fecha_creacion, fecha_modificacion,
           usuario_creador_id, usuario_modificador_id,
           activo
         ) VALUES (
           [datos del input],
           0,  -- stock_actual inicial
           now_utc,
           now_utc,
           usuario_creador_id,
           usuario_creador_id,
           1  -- activo = true
         )
         RETURNING id INTO nuevo_producto_id
    
    4. INSERT en tabla AuditoriaLog:
         INSERT INTO AuditoriaLog (
           tabla, operacion, registro_id,
           usuario_id, fecha_hora, ip_origen,
           datos_json
         ) VALUES (
           'Producto',
           'INSERT',
           nuevo_producto_id,
           usuario_creador_id,
           now_utc,
           obtenerIPUsuario(),
           toJSON(producto)
         )
    
    5. UPDATE contadores (opcional):
         UPDATE Estadistica
         SET total_productos = total_productos + 1
         WHERE tipo = 'INVENTARIO'
    
    6. COMMIT TRANSACTION
    
    7. Invalidar cache (si aplica):
         cache.invalidate("productos:lista")
    
    8. Publicar evento (si hay event bus):
         eventBus.publish("ProductoCreado", {
           producto_id: nuevo_producto_id,
           usuario_id: usuario_creador_id,
           timestamp: now_utc
         })
    
    Si hay error en CUALQUIER paso:
      9. ROLLBACK TRANSACTION
      10. LOG error con contexto completo
      11. Retornar error descriptivo
  
  Output:
    Éxito:
      • producto_id: integer (nuevo ID generado)
      • mensaje: "Producto registrado exitosamente"
      • timestamp: datetime (cuándo se guardó)
    
    Error:
      • error_code: string (código de error)
      • error_mensaje: string (descripción del error)
      • detalles: object (info adicional para debugging)
  
  SQL Exacto:
    ```sql
    BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    INSERT INTO Producto (
      nombre,
      cas_number,
      categoria_id,
      clase_peligrosidad,
      precio_unitario,
      stock_minimo,
      unidad_medida_id,
      proveedor_id,
      descripcion,
      ubicacion_almacen,
      fecha_vencimiento,
      stock_actual,
      fecha_creacion,
      fecha_modificacion,
      usuario_creador_id,
      usuario_modificador_id,
      activo
    ) VALUES (
      :nombre,
      :cas_number,
      :categoria_id,
      :clase_peligrosidad,
      :precio_unitario,
      :stock_minimo,
      :unidad_medida_id,
      :proveedor_id,
      :descripcion,
      :ubicacion_almacen,
      :fecha_vencimiento,
      0,
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP,
      :usuario_id,
      :usuario_id,
      1
    )
    RETURNING id;
    
    INSERT INTO AuditoriaLog (
      tabla,
      operacion,
      registro_id,
      usuario_id,
      fecha_hora,
      ip_origen,
      datos_json
    ) VALUES (
      'Producto',
      'INSERT',
      :producto_id,
      :usuario_id,
      CURRENT_TIMESTAMP,
      :ip_usuario,
      :producto_json
    );
    
    COMMIT;
    ```

CRITERIOS DE ACEPTACIÓN:
  AC-1: Guardado exitoso de producto completo
    GIVEN todos los datos de producto son válidos
    AND todas las validaciones pasaron
    WHEN sistema ejecuta guardado
    THEN producto se inserta en BD con ID auto-generado
    AND auditoría se registra correctamente
    AND transacción hace COMMIT exitoso
    AND función retorna producto_id y mensaje de éxito
  
  AC-2: Violación de constraint UNIQUE en CAS
    GIVEN producto con CAS "50-00-0" ya existe en BD
    AND usuario intenta guardar nuevo producto con mismo CAS
    WHEN sistema ejecuta guardado
    THEN INSERT falla con error de unicidad
    AND sistema ejecuta ROLLBACK
    AND auditoría NO se registra
    AND función retorna error "CAS Number ya existe"
  
  AC-3: Error de conexión a BD durante INSERT
    GIVEN conexión a BD se pierde durante operación
    WHEN sistema intenta hacer INSERT
    THEN sistema detecta error de conexión
    AND ejecuta ROLLBACK (si transacción estaba abierta)
    AND función retorna error "Error de conexión a base de datos"
    AND error se loggea con stack trace completo
  
  AC-4: Error durante registro de auditoría
    GIVEN INSERT de producto fue exitoso
    AND INSERT de auditoría falla (ej: tabla AuditoriaLog corrupta)
    WHEN sistema detecta el error
    THEN sistema ejecuta ROLLBACK completo
    AND producto NO queda guardado (rollback exitoso)
    AND función retorna error descriptivo
  
  AC-5: Timeout de transacción
    GIVEN transacción toma más de 30 segundos
    WHEN timeout ocurre
    THEN BD automáticamente hace ROLLBACK
    AND función retorna error "Timeout de transacción"
  
  AC-6: Verificar atomicidad (todos o ninguno)
    GIVEN se ejecuta guardado con error intencional en paso 4
    WHEN sistema llega al error
    THEN hace ROLLBACK
    AND verificar que producto NO existe en BD
    AND verificar que auditoría NO existe en BD
    AND verificar que contadores NO cambiaron

MENSAJES:
  Mensaje de éxito:
    Texto: "Producto '{nombre}' registrado exitosamente con ID {id}"
    Ejemplo: "Producto 'Acetona' registrado exitosamente con ID 1523"
    Tipo: Success
    Ubicación: Toast notification (esquina superior derecha)
    Duración: 5 segundos
    Color: Verde (#28a745)
  
  Mensaje de error - CAS duplicado:
    Texto: "No se pudo guardar: Ya existe un producto con CAS Number {cas}"
    Ejemplo: "No se pudo guardar: Ya existe un producto con CAS Number 50-00-0"
    Tipo: Error
    Ubicación: Alert banner (parte superior del formulario)
    Color: Rojo (#dc3545)
  
  Mensaje de error - Conexión BD:
    Texto: "Error de conexión con base de datos. Intente nuevamente."
    Tipo: Error
    Ubicación: Modal de error
    Acciones: [Reintentar] [Cancelar]
  
  Mensaje de error - Error inesperado:
    Texto: "Error inesperado al guardar producto. Contacte al administrador."
    Detalles: [Código de error para soporte]
    Tipo: Error

VALIDACIONES RELACIONADAS:
  Todas las validaciones deben pasar antes:
    • FR-40.6: Validar formato CAS
    • FR-40.7: Validar checksum CAS
    • FR-40.8: Verificar unicidad CAS (puede duplicarse con constraint DB)
    • FR-40.15: Validar categoría existe
    • FR-40.20: Validar precio > 0
    • ... (todas las validaciones)

CASOS DE PRUEBA SUGERIDOS:
  TC-40.50.1: Guardado exitoso con todos los campos
  TC-40.50.2: Guardado exitoso con campos opcionales vacíos
  TC-40.50.3: Error por CAS duplicado (constraint violation)
  TC-40.50.4: Error por conexión BD perdida
  TC-40.50.5: Error por timeout de transacción
  TC-40.50.6: Rollback exitoso cuando auditoría falla
  TC-40.50.7: Verificar ID auto-generado es secuencial
  TC-40.50.8: Verificar timestamp UTC es correcto
  TC-40.50.9: Verificar auditoría contiene datos completos
  TC-40.50.10: Performance test: 100 inserts simultáneos

DEPENDENCIAS:
  Depende de:
    • TODAS las validaciones FR-40.X (deben pasar primero)
    • FR-110.X: Usuario autenticado y con permisos
    • Base de datos accesible y operacional
  
  Es requerido por:
    • UC-40: No puede completarse sin este FR
    • FR-40.55: Enviar notificación (se ejecuta después)
    • FR-40.60: Actualizar cache (se ejecuta después)

NOTAS TÉCNICAS:
  Performance:
    - INSERT típico: 10-50ms
    - Con auditoría: 15-70ms
    - Índices afectan performance:
      • UNIQUE en cas_number: +5ms
      • Índice en categoria_id: +2ms
    - Para inserts masivos, considerar batch inserts
  
  Concurrency:
    - Nivel de aislamiento SERIALIZABLE previene dirty reads
    - Posible deadlock si múltiples usuarios crean productos
      con mismo CAS simultáneamente
    - Retry lógico con exponential backoff recomendado
  
  Security:
    - Usar prepared statements (previene SQL injection)
    - NO concatenar strings para formar SQL
    - Validar permisos antes de ejecutar (authz)
    - Sanitizar datos antes de guardar (ya validados)
  
  Rollback Behavior:
    - PostgreSQL: Rollback automático si conexión se pierde
    - MySQL: Depende de motor (InnoDB sí, MyISAM no)
    - SQLite: Rollback automático
  
  Auditoría:
    - datos_json debe incluir TODOS los campos
    - ip_origen útil para análisis forense
    - Considerar GDPR: no guardar datos sensibles en log
  
  Cache:
    - Invalidar cache DESPUÉS de commit exitoso
    - Si invalidación falla, no es crítico (cache expirará)
    - Considerar cache distribuido (Redis) para multi-servidor
  
  Event Bus (Opcional):
    - Publicar evento DESPUÉS de commit
    - Si falla publicación, loggear pero NO rollback
    - Considerar message queue (RabbitMQ, Kafka) para reliability

REFERENCIAS:
  • ACID Properties: https://en.wikipedia.org/wiki/ACID
  • PostgreSQL Transactions: https://www.postgresql.org/docs/current/tutorial-transactions.html
  • SQL Injection Prevention: https://owasp.org/www-community/attacks/SQL_Injection

HISTORIAL:
  Versión 1.0 - 2025-12-08 - Analista SR - Creación inicial

═══════════════════════════════════════════════════════════════
```

---

### 2.4 Ejemplo Completo: FR de Cálculo

```
═══════════════════════════════════════════════════════════════
FR-61.25: Calcular Cantidad Disponible de Producto
═══════════════════════════════════════════════════════════════

IDENTIFICADOR:
  FR-61.25

NOMBRE:
  Calcular Cantidad Disponible de Producto

DESCRIPCIÓN:
  El sistema DEBE calcular la cantidad disponible de un producto
  restando las cantidades reservadas (en solicitudes pendientes
  y aprobadas no entregadas) del stock actual.
  
  Fórmula:
    Disponible = Stock_Actual - Stock_Reservado
  
  Donde:
    Stock_Actual = Cantidad física en inventario
    Stock_Reservado = SUM(cantidad) de Solicitudes en estados:
                      'Pendiente', 'Aprobada', 'En_Preparacion'
  
  El sistema DEBE ejecutar este cálculo en tiempo real cada vez
  que se consulte la disponibilidad de un producto.

CATEGORÍA:
  Cálculo/Procesamiento

PRIORIDAD (MoSCoW):
  Must Have
  
  Justificación: Disponibilidad incorrecta puede resultar en:
    - Sobre-asignación de productos (promesas no cumplibles)
    - Conflictos de inventario
    - Frustración de usuarios

ORIGEN/TRAZABILIDAD:
  Deriva de: UC-61 (Consultar Solicitudes) - KPI de disponibilidad
  Deriva de: UC-63 (Consultar Disponibilidad de Producto)
  Relacionado con: BR-030 (Stock no puede ser negativo)
  Motivación: Prevenir solicitudes que no se pueden cumplir

PRECONDICIONES:
  • Producto existe en sistema
  • Stock_actual está actualizado en BD
  • Solicitudes están en estados correctos

POSTCONDICIONES:
  • Valor de disponible calculado y retornado
  • NO se modifica nada en BD (es solo cálculo)
  • Resultado puede ser negativo (indica sobre-asignación)

REGLAS DE NEGOCIO:
  • BR-030: Stock actual no puede ser negativo
  • BR-031: Stock reservado debe reflejarse en tiempo real
  • BR-032: Solicitudes canceladas NO cuentan en reserva

ESPECIFICACIÓN TÉCNICA:
  Input:
    • producto_id: integer
  
  Proceso:
    1. Obtener stock_actual del producto:
         SELECT stock_actual 
         FROM Producto 
         WHERE id = :producto_id
    
    2. Calcular stock_reservado:
         SELECT COALESCE(SUM(cantidad), 0) AS stock_reservado
         FROM SolicitudProducto sp
         JOIN Solicitud s ON sp.solicitud_id = s.id
         WHERE sp.producto_id = :producto_id
           AND s.estado IN ('Pendiente', 'Aprobada', 'En_Preparacion')
    
    3. Calcular disponible:
         disponible = stock_actual - stock_reservado
    
    4. Determinar estado de disponibilidad:
         IF disponible > stock_minimo:
           estado = 'Disponible'
         ELSE IF disponible > 0 AND disponible <= stock_minimo:
           estado = 'Stock_Bajo'
         ELSE IF disponible = 0:
           estado = 'Agotado'
         ELSE:  -- disponible < 0
           estado = 'Sobre_Asignado'  -- ¡Problema!
  
  Output:
    • disponible: integer (puede ser negativo)
    • stock_actual: integer
    • stock_reservado: integer
    • stock_minimo: integer
    • estado: enum ('Disponible', 'Stock_Bajo', 'Agotado', 'Sobre_Asignado')
  
  SQL Optimizado (query única):
    ```sql
    SELECT 
      p.id AS producto_id,
      p.nombre,
      p.stock_actual,
      p.stock_minimo,
      COALESCE(r.stock_reservado, 0) AS stock_reservado,
      (p.stock_actual - COALESCE(r.stock_reservado, 0)) AS disponible,
      CASE
        WHEN (p.stock_actual - COALESCE(r.stock_reservado, 0)) > p.stock_minimo 
          THEN 'Disponible'
        WHEN (p.stock_actual - COALESCE(r.stock_reservado, 0)) > 0 
          THEN 'Stock_Bajo'
        WHEN (p.stock_actual - COALESCE(r.stock_reservado, 0)) = 0 
          THEN 'Agotado'
        ELSE 'Sobre_Asignado'
      END AS estado
    FROM Producto p
    LEFT JOIN (
      SELECT 
        sp.producto_id,
        SUM(sp.cantidad) AS stock_reservado
      FROM SolicitudProducto sp
      JOIN Solicitud s ON sp.solicitud_id = s.id
      WHERE s.estado IN ('Pendiente', 'Aprobada', 'En_Preparacion')
      GROUP BY sp.producto_id
    ) r ON p.id = r.producto_id
    WHERE p.id = :producto_id;
    ```
  
  Pseudocódigo Completo:
    ```
    function calcularDisponibilidad(producto_id):
      // Query combinado para eficiencia
      resultado = ejecutarSQL(queryDisponibilidad, {producto_id})
      
      if resultado es vacío:
        throw ProductoNoExisteError
      
      // Extraer valores
      stock_actual = resultado.stock_actual
      stock_reservado = resultado.stock_reservado
      disponible = resultado.disponible
      estado = resultado.estado
      
      // Log si hay sobre-asignación (no debería pasar)
      if disponible < 0:
        logger.error({
          mensaje: "Sobre-asignación detectada",
          producto_id: producto_id,
          stock_actual: stock_actual,
          stock_reservado: stock_reservado,
          disponible: disponible
        })
      
      return {
        producto_id: producto_id,
        stock_actual: stock_actual,
        stock_reservado: stock_reservado,
        disponible: disponible,
        estado: estado,
        timestamp: ahora()
      }
    ```

CRITERIOS DE ACEPTACIÓN:
  AC-1: Producto con stock suficiente y sin reservas
    GIVEN Producto con ID 100 tiene stock_actual = 50
    AND NO tiene solicitudes pendientes/aprobadas
    WHEN sistema calcula disponibilidad
    THEN disponible = 50
    AND stock_reservado = 0
    AND estado = 'Disponible' (asumiendo stock_minimo < 50)
  
  AC-2: Producto con reservas
    GIVEN Producto con ID 100 tiene stock_actual = 50
    AND tiene 2 solicitudes aprobadas:
      • Solicitud A: 10 unidades
      • Solicitud B: 15 unidades
    WHEN sistema calcula disponibilidad
    THEN stock_reservado = 25
    AND disponible = 25 (50 - 25)
    AND estado = 'Disponible' o 'Stock_Bajo' (según stock_minimo)
  
  AC-3: Producto agotado
    GIVEN Producto con ID 100 tiene stock_actual = 20
    AND tiene solicitudes reservando 20 unidades
    WHEN sistema calcula disponibilidad
    THEN disponible = 0
    AND estado = 'Agotado'
  
  AC-4: Producto sobre-asignado (error)
    GIVEN Producto con ID 100 tiene stock_actual = 20
    AND tiene solicitudes reservando 30 unidades (más del stock)
    WHEN sistema calcula disponibilidad
    THEN disponible = -10 (negativo)
    AND estado = 'Sobre_Asignado'
    AND sistema loggea error crítico
  
  AC-5: Solicitudes canceladas no cuentan
    GIVEN Producto con ID 100 tiene stock_actual = 50
    AND tiene solicitudes:
      • Solicitud A (Aprobada): 10 unidades
      • Solicitud B (Cancelada): 20 unidades
    WHEN sistema calcula disponibilidad
    THEN stock_reservado = 10 (solo Aprobada)
    AND disponible = 40
    AND solicitud cancelada es ignorada
  
  AC-6: Solicitudes entregadas no cuentan
    GIVEN Producto con ID 100 tiene stock_actual = 50
    AND tiene solicitudes:
      • Solicitud A (Aprobada): 10 unidades
      • Solicitud B (Entregada): 15 unidades
    WHEN sistema calcula disponibilidad
    THEN stock_reservado = 10 (solo Aprobada)
    AND disponible = 40
    AND solicitud entregada es ignorada
  
  AC-7: Estado Stock_Bajo
    GIVEN Producto con ID 100:
      • stock_actual = 30
      • stock_minimo = 20
      • stock_reservado = 15
    WHEN sistema calcula disponibilidad
    THEN disponible = 15 (30 - 15)
    AND disponible <= stock_minimo
    AND estado = 'Stock_Bajo'

MENSAJES:
  No hay mensajes de usuario (es cálculo interno).
  
  Solo logging interno:
    Log Info (cálculo normal):
      "Disponibilidad calculada para Producto {id}: {disponible} unidades"
    
    Log Warning (stock bajo):
      "Producto {id} con stock bajo: {disponible} unidades (mínimo: {stock_minimo})"
    
    Log Error (sobre-asignación):
      "CRÍTICO: Producto {id} sobre-asignado: disponible={disponible}, 
       actual={stock_actual}, reservado={stock_reservado}"

VALIDACIONES RELACIONADAS:
  • FR-04.15: Validar disponibilidad antes de crear solicitud
  • FR-204.8: Verificar stock antes de aprobar solicitud
  • FR-42.10: Actualizar stock_actual después de entrega

CASOS DE PRUEBA SUGERIDOS:
  TC-61.25.1: Producto sin reservas (disponible = stock_actual)
  TC-61.25.2: Producto con 1 reserva
  TC-61.25.3: Producto con múltiples reservas
  TC-61.25.4: Producto agotado (disponible = 0)
  TC-61.25.5: Producto sobre-asignado (disponible < 0)
  TC-61.25.6: Solicitudes canceladas no cuentan
  TC-61.25.7: Solicitudes entregadas no cuentan
  TC-61.25.8: Estados de disponibilidad correctos
  TC-61.25.9: Performance: calcular 1000 productos simultáneos
  TC-61.25.10: Concurrencia: múltiples cálculos del mismo producto

DEPENDENCIAS:
  Depende de:
    • Tabla Producto con stock_actual actualizado
    • Tabla Solicitud con estados correctos
    • Tabla SolicitudProducto con cantidades correctas
  
  Es usado por:
    • FR-04.15: Validar disponibilidad al crear solicitud
    • FR-41.20: Mostrar disponibilidad en listado de productos
    • FR-63.10: Consultar disponibilidad específica
    • FR-90.15: Dashboard de inventario

NOTAS TÉCNICAS:
  Performance:
    - Query optimizado con LEFT JOIN: 5-20ms típico
    - Índice requerido en: 
      • SolicitudProducto(producto_id, solicitud_id)
      • Solicitud(estado)
    - Sin índices: puede tardar 500ms+ con 10,000 solicitudes
    - Considerar cache con TTL corto (30 segundos)
  
  Concurrency:
    - Cálculo es read-only, no hay race conditions
    - Usar READ COMMITTED isolation level (suficiente)
    - NO usar locks (innecesario)
  
  Edge Cases:
    - Producto nuevo sin solicitudes: stock_reservado = 0
    - Producto desactivado: debe calcularse igual
    - Stock_actual NULL: considerar como 0 (COALESCE)
  
  Alternativas de Implementación:
    Opción A (actual): Calcular on-demand
      • Pro: Siempre actualizado
      • Con: Requiere query cada vez
    
    Opción B: Campo calculado en tabla Producto
      • Pro: Más rápido (solo SELECT)
      • Con: Debe actualizarse con triggers
      • Con: Puede desincronizarse
    
    Opción C: Cache con TTL
      • Pro: Balance entre velocidad y actualización
      • Con: Puede estar ligeramente desactualizado
    
    Recomendación: Opción A para MVP, migrar a C si performance es issue
  
  Estados de Solicitud Considerados:
    ✓ Pendiente: Sí reserva (esperando aprobación)
    ✓ Aprobada: Sí reserva (esperando entrega)
    ✓ En_Preparacion: Sí reserva (preparando para entregar)
    ✗ Entregada: NO reserva (ya se descontó del stock)
    ✗ Rechazada: NO reserva (nunca se entregará)
    ✗ Cancelada: NO reserva (se liberó el stock)

REFERENCIAS:
  • Inventory Management Best Practices
  • SQL Optimization Techniques
  • Database Indexing Strategies

HISTORIAL:
  Versión 1.0 - 2025-12-08 - Analista SR - Creación inicial
  
═══════════════════════════════════════════════════════════════
```

---

### 2.5 Ejemplo Completo: FR de Seguridad

```
═══════════════════════════════════════════════════════════════
FR-110.5: Hashear Password con bcrypt
═══════════════════════════════════════════════════════════════

IDENTIFICADOR:
  FR-110.5

NOMBRE:
  Hashear Password con bcrypt

DESCRIPCIÓN:
  El sistema DEBE hashear el password del usuario usando el
  algoritmo bcrypt con un cost factor de 12 antes de almacenarlo
  en la base de datos.
  
  El sistema NO DEBE NUNCA almacenar passwords en texto plano.
  
  El sistema DEBE generar un salt único por cada password usando
  la funcionalidad incorporada de bcrypt (salt automático de 
  128 bits).
  
  El hash resultante DEBE tener formato:
    $2b$[cost]$[22-char salt][31-char hash]
  
  Ejemplo de hash bcrypt:
    $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NU4g1u.j5yG6

CATEGORÍA:
  Seguridad

PRIORIDAD (MoSCoW):
  Must Have
  
  Justificación: Almacenar passwords sin hashear es violación
  grave de seguridad. Expone a usuarios a:
    - Robo masivo de credenciales
    - Violación de privacidad
    - Posibles demandas legales
    - Incumplimiento de GDPR/CCPA

ORIGEN/TRAZABILIDAD:
  Deriva de: UC-110 (Iniciar Sesión) - Pre-requisito de auth
  Deriva de: UC-50 (Registrar Usuario) - Al crear cuenta
  Deriva de: UC-112 (Recuperar Password) - Al resetear
  Relacionado con: BR-100 (Passwords deben ser seguros)
  Motivación: Proteger credenciales de usuarios

PRECONDICIONES:
  • Password en texto plano disponible (de formulario)
  • Password cumple política de complejidad (FR-50.10)
  • Librería bcrypt instalada y disponible
  • Suficiente CPU para cálculo (bcrypt es intensivo)

POSTCONDICIONES:
  • Hash bcrypt generado
  • Password original descartado de memoria
  • Hash almacenable en BD (campo VARCHAR(60))
  • Salt incluido en el hash (bcrypt lo incluye automáticamente)

REGLAS DE NEGOCIO:
  • BR-100: Passwords deben hashearse con algoritmo fuerte
  • BR-101: Passwords nunca deben almacenarse en texto plano
  • BR-102: Salt debe ser único por usuario

ESPECIFICACIÓN TÉCNICA:
  Input:
    • password_plaintext: string
    • min_length: 60 caracteres (típico de texto plano antes de hash)
    • max_length: 255 caracteres (límite razonable)
  
  Constantes:
    • BCRYPT_COST_FACTOR: 12
      (Recomendación OWASP 2023: 10-12)
      (10 = ~100ms, 11 = ~200ms, 12 = ~400ms)
  
  Proceso:
    1. Validar password no está vacío
    2. Validar longitud del password (validación adicional)
    3. Generar salt automáticamente (bcrypt lo hace)
    4. Hashear password con bcrypt cost 12
    5. Retornar hash (formato $2b$12$...)
    6. Limpiar password_plaintext de memoria
  
  Output:
    • password_hash: string (60 caracteres fijos)
    • formato: $2b$12$[22-char salt][31-char hash]
  
  Algoritmo bcrypt:
    bcrypt trabaja así:
      1. Genera salt random de 128 bits (16 bytes)
      2. Deriva key usando algoritmo Blowfish (Eksblowfish)
      3. Itera 2^cost veces (2^12 = 4,096 iteraciones)
      4. Produce hash de 184 bits (23 bytes)
      5. Codifica en Base64 variant
      6. Retorna string con formato $2b$cost$salt$hash
  
  Pseudocódigo:
    ```
    function hashearPassword(password_plaintext):
      // Validar input
      if password_plaintext es vacío:
        throw "Password no puede estar vacío"
      
      if longitud(password_plaintext) > 72:
        // bcrypt trunca a 72 caracteres
        logger.warning("Password truncado a 72 caracteres")
        password_plaintext = substring(password_plaintext, 0, 72)
      
      // Hashear con bcrypt
      try:
        cost_factor = 12
        password_hash = bcrypt.hash(password_plaintext, cost_factor)
        
        // Verificar formato correcto
        if NOT password_hash.startsWith("$2b$12$"):
          throw "Hash bcrypt inválido"
        
        if longitud(password_hash) != 60:
          throw "Longitud de hash incorrecta"
        
        return password_hash
        
      catch error:
        logger.error("Error al hashear password: " + error)
        throw "Error al procesar password"
      
      finally:
        // Limpiar password de memoria (best effort)
        password_plaintext = null
        // En lenguajes como C, usar memset para sobrescribir
    ```
  
  Ejemplos de Código Real:
    Python:
      ```python
      import bcrypt
      
      def hashear_password(password: str) -> str:
          salt = bcrypt.gensalt(rounds=12)
          hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
          return hashed.decode('utf-8')
      
      # Uso:
      hash_guardado = hashear_password("MiPassword123!")
      # Resultado: $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz...
      ```
    
    JavaScript (Node.js):
      ```javascript
      const bcrypt = require('bcrypt');
      
      async function hashearPassword(password) {
          const saltRounds = 12;
          const hash = await bcrypt.hash(password, saltRounds);
          return hash;
      }
      
      // Uso:
      const hashGuardado = await hashearPassword("MiPassword123!");
      ```
    
    Java:
      ```java
      import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
      
      public String hashearPassword(String password) {
          BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
          return encoder.encode(password);
      }
      ```

CRITERIOS DE ACEPTACIÓN:
  AC-1: Hasheo exitoso de password válido
    GIVEN password "MiPassword123!"
    WHEN sistema hashea con bcrypt cost 12
    THEN hash generado empieza con "$2b$12$"
    AND longitud del hash es exactamente 60 caracteres
    AND hash es diferente cada vez (salt random)
  
  AC-2: Dos passwords iguales producen hashes diferentes
    GIVEN password1 = "MiPassword123!"
    AND password2 = "MiPassword123!" (mismo texto)
    WHEN sistema hashea ambos
    THEN hash1 != hash2 (por salts diferentes)
    BUT bcrypt.compare(password1, hash1) = true
    AND bcrypt.compare(password2, hash2) = true
  
  AC-3: Password vacío genera error
    GIVEN password = ""
    WHEN sistema intenta hashear
    THEN lanza excepción "Password no puede estar vacío"
    AND NO genera hash
  
  AC-4: Password muy largo se trunca
    GIVEN password = "A" * 100 (100 caracteres)
    WHEN sistema hashea
    THEN warning loggeado "Password truncado a 72 caracteres"
    AND hash se genera con primeros 72 caracteres
  
  AC-5: Verificar cost factor correcto
    GIVEN password hasheado
    WHEN extraemos cost del hash (posición 4-5)
    THEN cost = "12"
  
  AC-6: Hash almacenable en BD
    GIVEN hash generado
    WHEN insertamos en campo VARCHAR(60)
    THEN insert exitoso sin truncamiento
  
  AC-7: Performance aceptable
    GIVEN password "Test123!"
    WHEN sistema hashea 100 veces consecutivas
    THEN tiempo promedio 300-500ms por hash
    AND 95th percentile < 700ms

MENSAJES:
  No hay mensajes directos al usuario (proceso interno).
  
  Logs:
    Log Info:
      "Password hasheado exitosamente para usuario {user_id}"
    
    Log Warning:
      "Password truncado a 72 caracteres para usuario {user_id}"
    
    Log Error:
      "Error al hashear password: {error_message}"

VALIDACIONES RELACIONADAS:
  • FR-50.10: Validar política de complejidad de password (antes de hashear)
  • FR-110.6: Comparar password ingresado con hash (al autenticar)
  • FR-112.8: Re-hashear password al resetear

CASOS DE PRUEBA SUGERIDOS:
  TC-110.5.1: Hash password simple "password123"
  TC-110.5.2: Hash password complejo "P@ssw0rd!#2023"
  TC-110.5.3: Hash password con caracteres especiales "ñ@€#"
  TC-110.5.4: Hash password vacío (debe fallar)
  TC-110.5.5: Hash password muy largo (truncar)
  TC-110.5.6: Verificar formato $2b$12$...
  TC-110.5.7: Verificar longitud exacta 60
  TC-110.5.8: Dos hashes del mismo password son diferentes
  TC-110.5.9: Performance: 100 hashes en < 60 segundos
  TC-110.5.10: Verificar bcrypt.compare funciona después

DEPENDENCIAS:
  Depende de:
    • Librería bcrypt instalada
    • FR-50.10: Password cumple política de complejidad
  
  Es usado por:
    • FR-50.25: Crear usuario (al registrar)
    • FR-110.6: Comparar password (al autenticar)
    • FR-112.15: Actualizar password (al resetear)
    • FR-115.10: Cambiar password (al modificar)

NOTAS TÉCNICAS:
  Performance:
    - Cost 10: ~100ms por hash (rápido, menos seguro)
    - Cost 11: ~200ms por hash
    - Cost 12: ~400ms por hash (recomendado OWASP 2023)
    - Cost 13: ~800ms por hash (muy lento, puede molestar UX)
    - Recomendación: 12 es buen balance seguridad/UX
  
  Security:
    - bcrypt es resistente a ataques GPU/ASIC
    - Más lento que SHA-256, pero eso es deseable (contra brute force)
    - Salt automático previene rainbow tables
    - Cost factor ajustable permite aumentar seguridad con el tiempo
  
  Limitaciones de bcrypt:
    - Trunca passwords a 72 bytes (no es problema práctico)
    - Solo procesa 72 primeros bytes (caracteres multi-byte cuentan más)
    - Alternativa moderna: Argon2 (pero bcrypt sigue siendo excelente)
  
  Migración de Hashes:
    Si sistema usa MD5/SHA1 actualmente:
      1. NO re-hashear passwords existentes (no tienes plaintext)
      2. Hacer migración gradual: al próximo login exitoso con 
         password viejo, re-hashear con bcrypt
      3. Mantener ambos campos temporalmente (password_old, password_new)
  
  Storage:
    - Campo en BD: VARCHAR(60) o CHAR(60)
    - 60 caracteres es longitud fija de bcrypt
    - NO usar VARCHAR(255) innecesariamente grande
  
  Compliance:
    - OWASP: Recomienda bcrypt o Argon2
    - NIST SP 800-63B: Permite bcrypt
    - PCI DSS: Requiere hashing fuerte (bcrypt cumple)
    - GDPR: Considera passwords como datos sensibles (bcrypt protege)

REFERENCIAS:
  • OWASP Password Storage: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  • bcrypt Specification: https://en.wikipedia.org/wiki/Bcrypt
  • NIST SP 800-63B: https://pages.nist.gov/800-63-3/sp800-63b.html

HISTORIAL:
  Versión 1.0 - 2025-12-08 - Analista SR - Creación inicial

═══════════════════════════════════════════════════════════════
```

---

### 2.6 Resumen de Plantilla

**Lo aprendido:**

```
✅ Plantilla completa con 15+ campos

✅ Campos obligatorios vs opcionales claramente definidos

✅ 4 ejemplos completos de diferentes categorías:
   • Validación: FR-40.6 (CAS Number)
   • Persistencia: FR-40.50 (Guardar producto)
   • Cálculo: FR-61.25 (Disponibilidad)
   • Seguridad: FR-110.5 (bcrypt)

✅ Cada ejemplo incluye:
   - Descripción detallada
   - Pseudocódigo
   - SQL real (cuando aplica)
   - Criterios de aceptación (Given-When-Then)
   - Casos de prueba sugeridos
   - Consideraciones técnicas

✅ Ejemplos de código en Python, JavaScript, Java
```

**Próxima Sección:**

Sección 3: Proceso de Derivación UC → FR
- Metodología paso a paso
- Técnicas de descomposición
- Mapeo de flujos UC a FR
- Ejercicio guiado

**Fin de Sección 2**

P4S2EOF
