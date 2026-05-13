## 4. CLASIFICACIÓN DE FR

### 4.1 Categorías Principales

Los FR se clasifican según su naturaleza funcional:

```
1. VALIDACIÓN          → Verificar datos de entrada
2. CÁLCULO             → Procesar/transformar datos
3. PERSISTENCIA        → Guardar/actualizar/eliminar datos
4. CONSULTA            → Leer/buscar datos
5. UI/PRESENTACIÓN     → Mostrar información al usuario
6. NAVEGACIÓN          → Flujo entre pantallas
7. INTEGRACIÓN         → Comunicación con sistemas externos
8. SEGURIDAD           → Autenticación/autorización
9. AUDITORÍA           → Registro de operaciones
10. NOTIFICACIÓN       → Alertas/emails/mensajes
11. REPORTES           → Generar documentos
12. REGLAS DE NEGOCIO  → Implementar BR específicas
```

### 4.2 Validación

**Propósito:** Verificar que datos cumplan reglas antes de procesar.

**Sub-categorías:**
- Formato (regex, longitud)
- Rango (valores mín/máx)
- Existencia (FK)
- Unicidad
- Integridad referencial
- Lógica de negocio

**Plantilla:**

```
FR-XX.YY: Validar [Aspecto] de [Campo/Entidad]

El sistema DEBE validar que [campo] cumpla [regla específica].

Si validación falla:
  • Mostrar mensaje: "[texto exacto]"
  • Resaltar campo con [estilo]
  • Prevenir [acción]

Criterios de Aceptación:
  AC-1: Valor válido → validación pasa
  AC-2: Valor inválido → validación falla con mensaje específico
```

**Ejemplos:**

```
FR-40.6: Validar Formato CAS Number
  Regla: Regex ^[0-9]{2,7}-[0-9]{2}-[0-9]$
  Mensaje: "CAS inválido. Formato: XXX-XX-X"
  
FR-50.8: Validar Formato Email
  Regla: RFC 5322
  Mensaje: "Email inválido"
  
FR-04.12: Validar Stock Disponible
  Regla: cantidad_solicitada <= disponible
  Mensaje: "Stock insuficiente. Disponible: {disponible}"
```

---

### 4.3 Cálculo/Procesamiento

**Propósito:** Transformar, agregar o derivar datos.

**Sub-categorías:**
- Cálculos matemáticos
- Agregaciones (SUM, AVG, COUNT)
- Transformaciones (formato, unidades)
- Derivaciones (valores calculados)

**Plantilla:**

```
FR-XX.YY: Calcular [Resultado]

El sistema DEBE calcular [resultado] usando [fórmula/algoritmo].

Input:
  • [parámetro 1]: [tipo]
  • [parámetro 2]: [tipo]

Fórmula:
  [expresión matemática]

Output:
  • [resultado]: [tipo]
  • [precisión]: [decimales/redondeo]
```

**Ejemplos:**

```
FR-61.25: Calcular Disponibilidad de Producto
  Fórmula: Disponible = Stock_Actual - Stock_Reservado
  Input: producto_id
  Output: disponible (integer)
  
FR-200.5: Calcular Valor Total de Inventario
  Fórmula: Total = SUM(stock_actual × precio_unitario)
  Agregación sobre todos los productos activos
  
FR-04.20: Calcular Costo Total de Solicitud
  Fórmula: Total = SUM(cantidad × precio_unitario)
  Por cada producto en la solicitud
```

---

### 4.4 Persistencia

**Propósito:** Guardar, actualizar o eliminar datos en BD.

**Sub-categorías:**
- INSERT (crear)
- UPDATE (modificar)
- DELETE (eliminar)
- UPSERT (insertar o actualizar)

**Plantilla:**

```
FR-XX.YY: [Operación] [Entidad] en Base de Datos

El sistema DEBE [INSERT|UPDATE|DELETE] en tabla [nombre_tabla].

Transacción:
  • Nivel aislamiento: [SERIALIZABLE|READ_COMMITTED]
  • Rollback si: [condiciones]
  • Commit si: [condiciones]

SQL:
  [query exacto]

Auditoría:
  • Registrar en AuditoriaLog
  • Incluir: usuario, timestamp, IP, datos
```

**Ejemplos:**

```
FR-40.50: Guardar Producto en Base de Datos
  Operación: INSERT
  Tabla: Producto
  Transacción: ACID con auditoría
  Rollback si: error en INSERT o auditoría
  
FR-42.30: Actualizar Stock de Producto
  Operación: UPDATE
  Tabla: Producto
  Campo: stock_actual = stock_actual - cantidad_entregada
  Condición: stock_actual >= cantidad_entregada
  
FR-44.15: Eliminar Producto (Soft Delete)
  Operación: UPDATE (no DELETE físico)
  Campo: activo = FALSE, fecha_eliminacion = NOW()
  Preservar datos para auditoría
```

---

### 4.5 Consulta/Lectura

**Propósito:** Recuperar datos de BD para mostrar o procesar.

**Sub-categorías:**
- Búsqueda simple (por ID)
- Búsqueda con filtros
- Búsqueda con paginación
- Búsqueda con ordenamiento
- Búsqueda full-text

**Plantilla:**

```
FR-XX.YY: Consultar [Entidad] con [Criterios]

El sistema DEBE recuperar [entidad] de BD aplicando [filtros].

Query:
  [SQL exacto con JOINs, WHERE, ORDER BY, LIMIT]

Índices requeridos:
  • [índice 1]
  • [índice 2]

Performance:
  • Tiempo máximo: [X segundos]
  • Registros máximos: [Y]
  • Paginación: [registros por página]
```

**Ejemplos:**

```
FR-41.10: Consultar Productos con Filtros
  Filtros: nombre (LIKE), categoría (=), clase (=)
  Ordenamiento: nombre ASC
  Paginación: 20 por página
  Performance: < 500ms
  
FR-61.15: Consultar Solicitudes de Usuario
  Filtros: usuario_id, estado, fecha_desde, fecha_hasta
  JOINs: Producto, Usuario
  Agregación: COUNT de productos por solicitud
  
FR-63.8: Buscar Productos por CAS o Nombre
  Full-text search en campos: nombre, descripcion
  Ranking por relevancia
  Highlight de términos encontrados
```

---

### 4.6 UI/Presentación

**Propósito:** Renderizar información en interfaz de usuario.

**Sub-categorías:**
- Formularios
- Listas/tablas
- Dashboards
- Modals/diálogos
- Mensajes (success, error, warning)

**Plantilla:**

```
FR-XX.YY: Mostrar [Componente] con [Datos]

El sistema DEBE renderizar [componente UI] mostrando [información].

Elementos:
  • [elemento 1]: [descripción]
  • [elemento 2]: [descripción]

Layout:
  [ASCII mockup o referencia a diseño]

Interactividad:
  • [acción 1] → [comportamiento]
  • [acción 2] → [comportamiento]
```

**Ejemplos:**

```
FR-40.2: Mostrar Formulario de Registro de Producto
  Campos: 11 campos agrupados
  Layout: 2 columnas para desktop, 1 para mobile
  Validación: Inline (onChange) + Submit
  
FR-61.30: Mostrar Dashboard de Solicitudes
  Secciones: KPIs (3), Filtros (5), Lista (paginada)
  KPIs: Total, Pendientes, Aprobadas
  Gráfico: Barras con estados
  
FR-110.20: Mostrar Modal de Error
  Título: "Error"
  Mensaje: [texto descriptivo]
  Botones: [Reintentar] [Cancelar]
  Icono: ⚠️ rojo
```

---

### 4.7 Navegación

**Propósito:** Controlar flujo entre pantallas/vistas.

**Sub-categorías:**
- Redirecciones
- Breadcrumbs
- Menús
- Enlaces
- Back button behavior

**Plantilla:**

```
FR-XX.YY: Navegar a [Destino] desde [Origen]

El sistema DEBE redirigir a [URL] cuando [condición/acción].

Preservar:
  • [parámetros en URL]
  • [estado en session]

Comportamiento:
  • [describir transición]
```

**Ejemplos:**

```
FR-40.63: Redirigir a Detalle Después de Guardar
  Desde: /productos/nuevo
  Hacia: /productos/{id}
  Preservar: mensaje de éxito
  
FR-110.75: Redirigir a Login si No Autenticado
  Desde: Cualquier ruta protegida
  Hacia: /login?return={url_actual}
  Después de login: volver a {url_actual}
  
FR-41.18: Actualizar Breadcrumb
  Ruta: Home > Productos > {nombre_producto}
  Clicable: cada nivel redirige
```

---

### 4.8 Integración

**Propósito:** Comunicar con sistemas externos.

**Sub-categorías:**
- API REST
- SOAP
- GraphQL
- WebSockets
- File upload/download
- Email
- SMS

**Plantilla:**

```
FR-XX.YY: Integrar con [Sistema Externo] para [Propósito]

El sistema DEBE llamar a [API/servicio] para [acción].

Endpoint:
  • URL: [endpoint exacto]
  • Método: [GET|POST|PUT|DELETE]
  • Auth: [tipo de autenticación]

Request:
  [payload JSON]

Response:
  [estructura esperada]

Error Handling:
  • Si timeout (> X seg) → [acción]
  • Si 4xx → [acción]
  • Si 5xx → [acción]
```

**Ejemplos:**

```
FR-210.5: Sincronizar con SAP
  Endpoint: POST /sap/api/materials
  Cada noche a 2:00 AM
  Enviar: lista de productos creados/modificados
  Recibir: confirmación con IDs SAP
  
FR-112.10: Enviar Email de Recuperación
  Servicio: SendGrid API
  Template: password_reset_template
  Variables: {user_name}, {reset_link}, {expiry_time}
  
FR-220.8: Importar Datos desde Excel
  Formato: .xlsx o .csv
  Validar: columnas requeridas
  Procesar: por lotes de 100 registros
```

---

### 4.9 Seguridad

**Propósito:** Proteger sistema y datos.

**Sub-categorías:**
- Autenticación (login, logout)
- Autorización (permisos)
- Encriptación
- Hashing
- Rate limiting
- CSRF protection
- XSS prevention

**Plantilla:**

```
FR-XX.YY: [Mecanismo de Seguridad]

El sistema DEBE implementar [mecanismo] para [proteger contra].

Algoritmo/Protocolo:
  • [especificar algoritmo]
  • [parámetros de seguridad]

Comportamiento:
  • Si pasa → [acción]
  • Si falla → [acción]

Cumplimiento:
  • [estándar: OWASP, NIST, etc.]
```

**Ejemplos:**

```
FR-110.5: Hashear Password con bcrypt
  Algoritmo: bcrypt cost 12
  Previene: rainbow table attacks
  
FR-110.12: Implementar Rate Limiting
  Límite: 5 intentos de login por minuto por IP
  Bloqueo: 15 minutos después de 5 fallos
  
FR-40.81: Validar CSRF Token
  Token: generado por servidor, incluido en form
  Validación: en cada POST/PUT/DELETE
```

---

### 4.10 Auditoría

**Propósito:** Registrar operaciones para cumplimiento y debugging.

**Sub-categorías:**
- Audit log
- Access log
- Change log
- Error log

**Plantilla:**

```
FR-XX.YY: Registrar [Evento] en Log de Auditoría

El sistema DEBE registrar en [tabla_auditoria] cuando [evento].

Datos a registrar:
  • usuario_id: [quien ejecutó]
  • accion: [qué hizo]
  • tabla/entidad: [dónde]
  • registro_id: [ID afectado]
  • datos_antes: [estado previo]
  • datos_despues: [estado nuevo]
  • timestamp: [cuándo - UTC]
  • ip_origen: [desde dónde]

Retención:
  • [período de retención]
```

**Ejemplos:**

```
FR-40.53: Auditar Creación de Producto
  Tabla: AuditoriaLog
  Acción: INSERT
  Datos: JSON completo del producto
  Retención: 7 años (cumplimiento)
  
FR-110.90: Auditar Intentos de Login Fallidos
  Log: security_events
  Incluir: username, IP, razón de fallo, timestamp
  Alertar: si 10 fallos en 5 minutos (posible ataque)
```

---

### 4.11 Notificación

**Propósito:** Alertar usuarios sobre eventos importantes.

**Sub-categorías:**
- Email
- SMS
- Push notifications
- In-app notifications
- Webhooks

**Plantilla:**

```
FR-XX.YY: Notificar [Destinatario] sobre [Evento]

El sistema DEBE enviar [tipo de notificación] a [quien] cuando [evento].

Canal:
  • [Email|SMS|Push|In-app]

Contenido:
  • Asunto/Título: [texto]
  • Cuerpo: [template con variables]
  • Acciones: [links/botones]

Timing:
  • [Inmediato|Diferido|Batch]

Configuración:
  • Usuario puede deshabilitar: [Sí|No]
```

**Ejemplos:**

```
FR-204.25: Notificar Aprobación de Solicitud
  Canal: Email + In-app
  Destinatario: Usuario solicitante
  Asunto: "Tu solicitud #{id} fue aprobada"
  Link: Ver solicitud
  
FR-40.64: Notificar Producto Clase 5
  Canal: Email
  Destinatario: Admin
  Asunto: "Nuevo producto clase 5: {nombre}"
  Inmediato
```

---

### 4.12 Reportes

**Propósito:** Generar documentos con datos del sistema.

**Sub-categorías:**
- PDF
- Excel
- CSV
- JSON export
- Print view

**Plantilla:**

```
FR-XX.YY: Generar Reporte [Nombre]

El sistema DEBE generar reporte en formato [PDF|Excel|CSV].

Contenido:
  • Sección 1: [descripción]
  • Sección 2: [descripción]
  • ...

Datos:
  • [query o cálculos]

Formato:
  • Template: [referencia]
  • Logo: [sí/no]
  • Paginación: [reglas]

Parámetros:
  • Filtros: [opcionales]
  • Fecha: [rango]
```

**Ejemplos:**

```
FR-200.1: Generar Reporte OSHA
  Formato: PDF oficial OSHA
  Secciones: 5 (productos clase 4-5, movimientos, etc.)
  Firma digital: Sí
  Frecuencia: Trimestral
  
FR-61.40: Exportar Solicitudes a Excel
  Formato: .xlsx
  Hojas: Resumen, Detalle por Producto
  Estilos: Tablas con filtros automáticos
```

---

### 4.13 Reglas de Negocio (FR específicos)

**Propósito:** Implementar BR que afectan comportamiento del sistema.

**Plantilla:**

```
FR-XX.YY: Implementar [Business Rule]

El sistema DEBE aplicar BR-[XX]: "[texto de la BR]"

Si [condición de la BR]:
  • Entonces [comportamiento A]
Si no:
  • Entonces [comportamiento B]

Validación:
  • [cómo verificar cumplimiento]
```

**Ejemplos:**

```
FR-40.60: Requiere Aprobación para Clase 5
  BR-015: "Productos clase 5 requieren aprobación"
  Si clase = 5:
    • estado inicial = 'Pendiente_Aprobacion'
    • notificar a Admin
  Si clase <= 4:
    • estado inicial = 'Activo'
  
FR-204.8: Validar Stock Antes de Aprobar
  BR-030: "Stock no puede ser negativo"
  Si disponible >= cantidad_solicitada:
    • aprobar
  Si no:
    • rechazar con mensaje
```

---

## 5. CRITERIOS DE ACEPTACIÓN

### 5.1 ¿Qué son los Criterios de Aceptación?

**Definición:**

> Criterios de Aceptación (AC - Acceptance Criteria) son condiciones
> específicas y medibles que un FR debe cumplir para considerarse
> completo y correcto.

**Propósito:**
- Definir QUÉ significa "done" para un FR
- Base para escribir test cases
- Contrato entre analista y desarrollador
- Verificación objetiva de cumplimiento

---

### 5.2 Formato Given-When-Then (Gherkin)

**Sintaxis:**

```
GIVEN [contexto/estado inicial]
WHEN [acción ejecutada]
THEN [resultado esperado]
AND [resultado adicional - opcional]
```

**Ventajas:**
- Lenguaje natural comprensible por todos
- Estructura clara: Setup → Action → Verification
- Compatible con BDD (Behavior Driven Development)
- Traducible a tests automáticos (Cucumber, Behave)

**Ejemplo:**

```
FR-40.6: Validar Formato CAS Number

AC-1: CAS válido con formato corto
  GIVEN usuario ingresa "50-00-0" en campo CAS
  WHEN sistema valida formato
  THEN validación pasa (retorna true)
  AND NO se muestra mensaje de error
  AND campo se resalta con borde verde

AC-2: CAS inválido con segundo bloque de 3 dígitos
  GIVEN usuario ingresa "12-345-6"
  WHEN sistema valida formato
  THEN validación falla (retorna false)
  AND se muestra "CAS inválido. Formato: XXX-XX-X"
  AND campo se resalta con borde rojo
  AND botón Guardar queda deshabilitado
```

---

### 5.3 Principios de Buenos AC

**1. ESPECÍFICOS:**
   Evitar vaguedad, ser concreto.
   
   ❌ Mal: "Sistema valida correctamente"
   ✅ Bien: "Sistema retorna {válido: true, error: null}"

**2. MEDIBLES:**
   Resultado debe ser verificable objetivamente.
   
   ❌ Mal: "Sistema responde rápido"
   ✅ Bien: "Sistema responde en < 2 segundos"

**3. COMPLETOS:**
   Cubrir casos válidos, inválidos y límite.
   
   Para validación numérica (rango 1-5):
     • AC-1: Valor válido dentro de rango (3)
     • AC-2: Valor válido límite inferior (1)
     • AC-3: Valor válido límite superior (5)
     • AC-4: Valor inválido bajo (0)
     • AC-5: Valor inválido alto (6)
     • AC-6: Valor no numérico ("abc")

**4. INDEPENDIENTES:**
   Cada AC verificable por separado.
   
   ❌ Mal: AC que depende del resultado de otro AC
   ✅ Bien: Cada AC con su propio GIVEN-WHEN-THEN completo

**5. ATÓMICOS:**
   Un AC, un comportamiento.
   
   ❌ Mal: "Sistema valida formato Y unicidad Y guarda"
   ✅ Bien: 
     - AC-1: Validar formato
     - AC-2: Validar unicidad
     - AC-3: Guardar en BD

---

### 5.4 Plantillas por Tipo de FR

#### 5.4.1 Validación

```
AC-1: Valor válido → pasa
  GIVEN [valor que cumple regla]
  WHEN sistema valida
  THEN validación pasa
  AND NO muestra error

AC-2: Valor inválido → falla
  GIVEN [valor que NO cumple regla]
  WHEN sistema valida
  THEN validación falla
  AND muestra mensaje "[texto exacto]"

AC-3: Valor vacío → error específico
  GIVEN campo vacío
  WHEN sistema valida
  THEN error "Campo obligatorio"

AC-4: Valor límite inferior → comportamiento
AC-5: Valor límite superior → comportamiento
```

#### 5.4.2 Cálculo

```
AC-1: Cálculo con valores positivos
  GIVEN [inputs específicos]
  WHEN sistema calcula [fórmula]
  THEN resultado = [valor esperado exacto]
  AND precisión = [decimales]

AC-2: Cálculo con valores cero
  GIVEN input = 0
  WHEN calcula
  THEN resultado = 0

AC-3: Cálculo con valores negativos (si aplica)
AC-4: División por cero → error
AC-5: Overflow → manejo
```

#### 5.4.3 Persistencia

```
AC-1: Guardado exitoso
  GIVEN datos válidos
  WHEN sistema guarda
  THEN registro insertado en BD con ID = [X]
  AND auditoría registrada
  AND transacción committed

AC-2: Error de BD → rollback
  GIVEN BD no disponible
  WHEN sistema intenta guardar
  THEN rollback ejecutado
  AND BD en estado consistente (sin cambios)
  AND error loggeado

AC-3: Constraint violado → error específico
  GIVEN dato duplica UNIQUE key
  WHEN intenta guardar
  THEN error "Ya existe"
  AND rollback
```

#### 5.4.4 Consulta

```
AC-1: Consulta con resultados
  GIVEN filtros [especificar]
  WHEN sistema ejecuta query
  THEN retorna [N] registros
  AND registros cumplen filtros
  AND ordenados por [campo]

AC-2: Consulta sin resultados
  GIVEN filtros que no coinciden
  WHEN ejecuta query
  THEN retorna lista vacía []
  AND mensaje "No se encontraron resultados"

AC-3: Paginación correcta
  GIVEN 100 registros disponibles
  AND página_tamaño = 20
  WHEN solicita página 1
  THEN retorna registros 1-20
  AND total_páginas = 5
```

---

### 5.5 Cobertura de AC

**Regla: Mínimo 3 AC por FR, idealmente 5-7.**

**Categorías de cobertura:**

```
1. HAPPY PATH (caso normal)
   • Input válido típico
   • Sistema funciona correctamente
   • Usuario exitoso

2. EDGE CASES (límites)
   • Valores mínimos/máximos
   • Listas vacías
   • Primera/última ejecución
   • Valores límite de algoritmo

3. ERROR CASES (errores)
   • Input inválido
   • Errores de sistema (BD, red)
   • Timeouts
   • Permisos denegados

4. ALTERNATES (caminos alternos)
   • Usuarios cancela
   • Segunda opción disponible
   • Fallback behavior

5. SECURITY (seguridad)
   • Input malicioso (XSS, SQL injection)
   • Sin autenticación
   • Sin autorización
   • Rate limiting excedido
```

**Ejemplo de cobertura completa:**

```
FR-40.6: Validar Formato CAS Number

HAPPY PATH:
  AC-1: CAS válido formato corto "50-00-0"
  AC-2: CAS válido formato largo "1333-74-0"

EDGE CASES:
  AC-3: CAS mínimo "10-00-0" (2 dígitos parte 1)
  AC-4: CAS máximo "1234567-89-0" (7 dígitos parte 1)
  AC-5: CAS con espacios " 50-00-0 " → normalizar y validar

ERROR CASES:
  AC-6: CAS inválido "12-345-6" (parte 2 tiene 3 dígitos)
  AC-7: CAS inválido "1-23-4" (parte 1 tiene 1 dígito)
  AC-8: CAS con letras "abc-de-f"
  AC-9: CAS sin guiones "123456"
  AC-10: CAS vacío ""

SECURITY:
  AC-11: CAS con HTML tags "<script>50-00-0</script>" → sanitizar

Total: 11 AC → cobertura excelente
```

---

### 5.6 De AC a Test Cases

**Los AC se mapean directamente a test cases:**

```
AC-1: CAS válido "50-00-0" → pasa
  ↓
TC-40.6.1: test_validar_cas_valido_corto()
  // Given
  cas_input = "50-00-0"
  // When
  result = validarFormatoCAS(cas_input)
  // Then
  assert result.valido == true
  assert result.error == null
```

**Frameworks BDD permiten escribir AC ejecutables:**

```gherkin
Feature: Validación de CAS Number
  
  Scenario: CAS válido formato corto
    Given el usuario ingresa "50-00-0" en campo CAS
    When el sistema valida formato
    Then la validación pasa
    And no se muestra mensaje de error
    And el campo se resalta con borde verde
```

**Herramientas:**
- Cucumber (Java, Ruby)
- Behave (Python)
- SpecFlow (.NET)
- Jasmine/Mocha (JavaScript)

---

### 5.7 Checklist de AC

**Al escribir AC para un FR, verificar:**

```
□ Mínimo 3 AC, idealmente 5-7

□ Formato Given-When-Then consistente

□ Cobertura de:
  □ Happy path (al menos 1)
  □ Edge cases (al menos 2)
  □ Error cases (al menos 2)
  □ Security (si aplica)

□ Cada AC es específico y medible

□ Cada AC es independiente (verificable solo)

□ AC cubren todos los mensajes mencionados en el FR

□ AC verifican tanto comportamiento visible (UI) como interno (BD, logs)

□ AC incluyen valores de ejemplo concretos (no "valor válido" genérico)

□ AC están numerados secuencialmente (AC-1, AC-2, ...)

□ AC son traducibles a test cases directamente
```

---

### 5.8 Resumen de Secciones 4-5

**Sección 4: Clasificación de FR**

```
✅ 12 categorías de FR identificadas
✅ Plantilla específica por categoría
✅ Ejemplos por cada tipo
✅ Sub-categorías detalladas

Categorías más comunes:
  1. Validación (30-40% de FR)
  2. Persistencia (15-20% de FR)
  3. Consulta (15-20% de FR)
  4. UI (10-15% de FR)
  5. Otras (20-25% de FR)
```

**Sección 5: Criterios de Aceptación**

```
✅ Formato Given-When-Then (Gherkin)
✅ 5 principios de buenos AC
✅ Plantillas por tipo de FR
✅ Cobertura: Happy Path + Edge + Error + Security
✅ Mapeo directo a test cases
✅ Checklist de verificación

Mínimo: 3 AC por FR
Ideal: 5-7 AC por FR
Completo: 10+ AC para FR críticos
```

**Próximas Secciones (las MÁS VALIOSAS):**

Sección 6: UC-40 → 60 FR completos (~1,200 líneas)
Sección 7: UC-61 → 45 FR completos (~1,000 líneas)
Sección 8: UC-110 → 40 FR completos (~900 líneas)

**Fin de Secciones 4-5**

P4S4S5EOF
