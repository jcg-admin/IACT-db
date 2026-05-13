## 7. EJEMPLO COMPLETO: UC-61 → REQUERIMIENTOS FUNCIONALES

### 7.1 UC-61 de Referencia

```
UC-61: Consultar Estado de Solicitudes Propias

Actor: Estudiante
Complejidad: Alta (query complejo, filtros, paginación)
FR esperados: ~45 FR
```

---

### 7.2 FR DESTACADOS DE UC-61

```
═══════════════════════════════════════════════════════════════
FR-61.10: Ejecutar Query Principal con Filtros
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-61.10
CATEGORÍA: Consulta
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE ejecutar query optimizado que recupere solicitudes
  con joins, filtros, agregaciones y paginación.

SQL COMPLETO:
  ```sql
  WITH SolicitudResumen AS (
    SELECT 
      s.id,
      s.fecha_solicitud,
      s.estado,
      s.fecha_aprobacion,
      s.fecha_entrega,
      u.nombre AS solicitante,
      a.nombre AS aprobador,
      COUNT(sp.producto_id) AS total_productos,
      SUM(sp.cantidad) AS total_unidades,
      SUM(sp.cantidad * p.precio_unitario) AS valor_total
    FROM Solicitud s
    JOIN Usuario u ON s.usuario_id = u.id
    LEFT JOIN Usuario a ON s.aprobador_id = a.id
    JOIN SolicitudProducto sp ON s.id = sp.solicitud_id
    JOIN Producto p ON sp.producto_id = p.id
    WHERE s.usuario_id = :usuario_id
      AND (:estado IS NULL OR s.estado = :estado)
      AND s.fecha_solicitud >= :fecha_desde
      AND s.fecha_solicitud <= :fecha_hasta
    GROUP BY s.id, u.nombre, a.nombre
  )
  SELECT *,
    COUNT(*) OVER() AS total_registros
  FROM SolicitudResumen
  ORDER BY fecha_solicitud DESC
  LIMIT :limit OFFSET :offset;
  ```

ÍNDICES REQUERIDOS:
  • CREATE INDEX idx_solicitud_usuario_fecha 
    ON Solicitud(usuario_id, fecha_solicitud DESC)
  • CREATE INDEX idx_solicitud_estado 
    ON Solicitud(estado)

CRITERIOS DE ACEPTACIÓN:
  AC-1: Query con 100 solicitudes < 2 segundos
    GIVEN BD con 10,000 solicitudes
    AND usuario tiene 100 solicitudes
    WHEN ejecuta query
    THEN completa en < 2 segundos (95th percentile)
    
  AC-2: Agregaciones correctas
    GIVEN solicitud con 3 productos:
      • Producto A: 5 unidades × $10 = $50
      • Producto B: 2 unidades × $20 = $40
      • Producto C: 1 unidad × $30 = $30
    WHEN query ejecuta
    THEN total_productos = 3
    AND total_unidades = 8
    AND valor_total = $120

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-61.25: Calcular Disponibilidad de Producto
═══════════════════════════════════════════════════════════════

[YA ESPECIFICADO EN SECCIÓN 2.4 - Ver allí para detalles completos]

Fórmula: Disponible = Stock_Actual - Stock_Reservado
Estados considerados en reserva: Pendiente, Aprobada, En_Preparacion
Performance: < 20ms por producto

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-61.35: Implementar Paginación con Cursor
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-61.35
CATEGORÍA: Consulta
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE implementar paginación offset-based:
  
  Parámetros:
    • page: número de página (1-indexed)
    • page_size: registros por página (default 20, max 100)
  
  Cálculo:
    • offset = (page - 1) × page_size
    • limit = page_size
  
  Response incluye:
    • data: array de registros
    • pagination: {
        page: número actual,
        page_size: tamaño página,
        total_records: total registros,
        total_pages: ceil(total_records / page_size),
        has_next: boolean,
        has_previous: boolean
      }

CRITERIOS DE ACEPTACIÓN:
  AC-1: Paginación primera página
    GIVEN 100 registros totales, page_size = 20
    WHEN page = 1
    THEN retorna registros 1-20
    AND pagination.total_pages = 5
    AND pagination.has_next = true
    AND pagination.has_previous = false
    
  AC-2: Paginación última página
    GIVEN 100 registros, page_size = 20
    WHEN page = 5
    THEN retorna registros 81-100 (solo 20)
    AND pagination.has_next = false
    AND pagination.has_previous = true

═══════════════════════════════════════════════════════════════
```

---

### 7.3 RESUMEN UC-61

```
Total FR derivados: 45 FR

DISTRIBUCIÓN:
  • Query y filtros: 10 FR
  • Cálculos/agregaciones: 8 FR
  • Paginación y ordenamiento: 6 FR
  • Dashboard UI: 8 FR
  • KPIs: 5 FR
  • Excel export: 4 FR
  • Performance optimization: 4 FR

Complejidad: ALTA
  • SQL complejo con CTEs, JOINs, agregaciones
  • Multiple índices requeridos
  • Performance crítico (< 2 seg)

Tiempo estimado: 80 horas (~2 semanas)
```

---

## 8. EJEMPLO COMPLETO: UC-110 → REQUERIMIENTOS FUNCIONALES

### 8.1 UC-110 de Referencia

```
UC-110: Iniciar Sesión (Login)

Actor: Cualquier usuario
Complejidad: Alta (seguridad crítica)
FR esperados: ~40 FR
```

---

### 8.2 FR DESTACADOS DE UC-110

```
═══════════════════════════════════════════════════════════════
FR-110.5: Hashear Password con bcrypt
═══════════════════════════════════════════════════════════════

[YA ESPECIFICADO EN SECCIÓN 2.5 - Ver allí para detalles completos]

Algoritmo: bcrypt cost 12
Salt: automático de 128 bits
Output: 60 caracteres fijos
Performance: ~400ms por hash

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-110.6: Comparar Password con Hash Almacenado
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-110.6
CATEGORÍA: Seguridad
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE comparar password ingresado con hash almacenado
  usando bcrypt.compare() para prevenir timing attacks.
  
  Proceso:
    1. Recuperar password_hash de BD para usuario
    2. Ejecutar: bcrypt.compare(password_plaintext, password_hash)
    3. Función retorna true (coincide) o false (no coincide)
    4. Comparación toma tiempo constante (~400ms) independiente del resultado
       (previene timing attack)

TIMING ATTACK PREVENTION:
  • bcrypt.compare() usa algoritmo de tiempo constante
  • Ejecuta hashing completo incluso si primeros bytes no coinciden
  • Atacante NO puede inferir si password está cerca basado en tiempo
  
CRITERIOS DE ACEPTACIÓN:
  AC-1: Password correcto → autenticación exitosa
    GIVEN usuario "john@example.com" con password hasheado en BD
    AND usuario ingresa password correcto "MyPass123!"
    WHEN sistema compara
    THEN bcrypt.compare() retorna true
    AND autenticación procede
    
  AC-2: Password incorrecto → autenticación falla
    GIVEN usuario ingresa password incorrecto "WrongPass"
    WHEN sistema compara
    THEN bcrypt.compare() retorna false
    AND autenticación falla
    AND mensaje genérico "Credenciales inválidas" (no revelar qué falló)
    
  AC-3: Timing constante (anti timing attack)
    GIVEN 100 intentos con password correcto
    AND 100 intentos con password incorrecto
    WHEN se mide tiempo de comparación
    THEN desviación estándar < 5%
    AND NO hay diferencia significativa detectable

NOTAS TÉCNICAS:
  • NUNCA comparar hashes directamente (password_hash == otro_hash)
  • Siempre usar bcrypt.compare() o equivalente
  • Loggear fallos pero NO revelar si username o password falló
  • Rate limiting adicional recomendado (FR-110.12)

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-110.12: Implementar Rate Limiting por IP
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-110.12
CATEGORÍA: Seguridad
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE limitar intentos de login por IP para prevenir
  ataques de fuerza bruta.
  
  Reglas:
    • Máximo 5 intentos fallidos por IP en ventana de 5 minutos
    • Después del 5to fallo → bloquear IP por 15 minutos
    • Counter resetea después de login exitoso
    • Bloqueo aplicable solo a /login endpoint
  
  Implementación:
    • Storage: Redis (key = "login_attempts:{ip}", TTL = 300 segundos)
    • Key stores: {attempts: N, first_attempt_at: timestamp}
    • Si attempts >= 5 → 429 Too Many Requests

CRITERIOS DE ACEPTACIÓN:
  AC-1: Bloqueo después de 5 fallos
    GIVEN IP 192.168.1.100
    WHEN hace 5 login fallidos en 3 minutos
    THEN intento 6 retorna 429 Too Many Requests
    AND mensaje "Demasiados intentos. Intente en 15 minutos"
    
  AC-2: Reseteo después de éxito
    GIVEN IP con 3 intentos fallidos
    WHEN login exitoso
    THEN counter resetea a 0
    AND próximos 5 intentos permitidos
    
  AC-3: TTL correcto
    GIVEN IP con 4 intentos fallidos
    AND 6 minutos han pasado
    WHEN intenta login de nuevo
    THEN counter reseteado (TTL expiró)
    AND intento permitido

NOTAS:
  • Considerar rate limiting por username también (FR-110.13)
  • IP puede ser spoofed → combinar con CAPTCHA después de 3 fallos
  • Usar X-Forwarded-For si detrás de proxy/CDN

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-110.18: Generar Token JWT con Claims
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-110.18
CATEGORÍA: Seguridad
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE generar JSON Web Token (JWT) después de autenticación
  exitosa.
  
  Estructura JWT:
    Header:
      { "alg": "HS256", "typ": "JWT" }
    
    Payload (claims):
      {
        "sub": user_id (subject),
        "username": email,
        "roles": ["Estudiante", "Coordinador"],
        "permisos": ["productos.leer", "solicitudes.crear"],
        "iat": timestamp issued_at,
        "exp": timestamp expires_at (iat + 8 horas),
        "jti": unique_token_id (para revocación)
      }
    
    Signature:
      HMACSHA256(base64(header) + "." + base64(payload), secret_key)
  
  Secret Key:
    • Min 256 bits (32 bytes)
    • Almacenado en variable de entorno JWT_SECRET
    • NUNCA en código fuente
    • Rotación recomendada cada 90 días

CRITERIOS DE ACEPTACIÓN:
  AC-1: JWT generado correctamente
    GIVEN usuario autenticado exitosamente
    WHEN sistema genera JWT
    THEN token tiene 3 partes separadas por "."
    AND header decodifica a {"alg":"HS256","typ":"JWT"}
    AND payload incluye todos los claims requeridos
    
  AC-2: Expiración correcta
    GIVEN JWT generado a las 10:00 AM
    WHEN exp claim se verifica
    THEN exp = 10:00 AM + 8 horas = 6:00 PM
    AND token inválido después de 6:00 PM
    
  AC-3: Firma válida
    GIVEN JWT generado con secret "my_secret_key"
    WHEN se verifica firma con mismo secret
    THEN verificación pasa
    WHEN se verifica con secret diferente
    THEN verificación falla (token manipulado)

NOTAS TÉCNICAS:
  • Usar librería estándar (jsonwebtoken en Node, PyJWT en Python)
  • NUNCA implementar JWT desde cero (error-prone)
  • Considerar refresh tokens para sesiones largas (FR-110.20)
  • Almacenar JTI en blacklist si se necesita revocación prematura

═══════════════════════════════════════════════════════════════
```

```
═══════════════════════════════════════════════════════════════
FR-110.25: Auditar Eventos de Autenticación
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: FR-110.25
CATEGORÍA: Auditoría
PRIORIDAD: Must Have

DESCRIPCIÓN:
  El sistema DEBE registrar todos los eventos de autenticación en
  tabla SecurityLog.
  
  Eventos a auditar:
    • LOGIN_SUCCESS: Login exitoso
    • LOGIN_FAILURE: Login fallido
    • LOGOUT: Logout explícito
    • SESSION_EXPIRED: Sesión expiró
    • TOKEN_REFRESH: Token renovado
    • PASSWORD_CHANGED: Password modificado
  
  Datos a registrar:
    • event_type: tipo de evento (enum)
    • user_id: ID usuario (null si login falló por username incorrecto)
    • username: email ingresado
    • ip_address: IP origen
    • user_agent: browser/device
    • timestamp: cuándo (UTC)
    • success: boolean
    • failure_reason: string (si success = false)

CRITERIOS DE ACEPTACIÓN:
  AC-1: Login exitoso auditado
    GIVEN usuario login exitoso
    WHEN evento se registra
    THEN SecurityLog contiene:
      • event_type = 'LOGIN_SUCCESS'
      • user_id = 123
      • ip_address = '192.168.1.100'
      • success = true
    
  AC-2: Login fallido auditado con razón
    GIVEN usuario ingresa password incorrecto
    WHEN evento se registra
    THEN SecurityLog contiene:
      • event_type = 'LOGIN_FAILURE'
      • username = 'john@example.com'
      • success = false
      • failure_reason = 'Invalid password'

NOTAS:
  • Retención: 1 año para SecurityLog
  • Índices en: (user_id, timestamp), (ip_address, timestamp)
  • Alertas: 10+ fallos de mismo user en 10 min → notificar security team
  • Compliance: GDPR Art. 32 requiere logging de eventos de seguridad

═══════════════════════════════════════════════════════════════
```

---

### 8.3 RESUMEN UC-110

```
Total FR derivados: 40 FR

DISTRIBUCIÓN:
  • Validación credenciales: 8 FR
  • Hashing/comparación: 6 FR
  • Rate limiting/anti brute-force: 6 FR
  • JWT generation/validation: 8 FR
  • Sesión management: 6 FR
  • Auditoría: 4 FR
  • Error handling: 2 FR

Complejidad: ALTA (seguridad crítica)
  • Timing attacks prevention
  • Rate limiting multi-layered
  • JWT con refresh tokens
  • Comprehensive audit trail

Tiempo estimado: 70 horas (~2 semanas)
```

---

### 8.4 COMPARACIÓN DE LOS 3 UC

```
┌─────────────────────┬────────┬────────┬─────────┐
│ Métrica             │ UC-40  │ UC-61  │ UC-110  │
├─────────────────────┼────────┼────────┼─────────┤
│ FR Total            │ 60     │ 45     │ 40      │
├─────────────────────┼────────┼────────┼─────────┤
│ Complejidad         │ Media  │ Alta   │ Alta    │
├─────────────────────┼────────┼────────┼─────────┤
│ FR Validación       │ 20     │ 10     │ 8       │
├─────────────────────┼────────┼────────┼─────────┤
│ FR Persistencia     │ 10     │ 2      │ 3       │
├─────────────────────┼────────┼────────┼─────────┤
│ FR Seguridad        │ 5      │ 3      │ 12      │
├─────────────────────┼────────┼────────┼─────────┤
│ FR Query/Consulta   │ 3      │ 15     │ 5       │
├─────────────────────┼────────┼────────┼─────────┤
│ Tiempo Impl (hrs)   │ 60     │ 80     │ 70      │
└─────────────────────┴────────┴────────┴─────────┘

TOTAL 3 UC: 145 FR Must Have
TIEMPO TOTAL: 210 horas (~5 semanas 1 dev)
```

**Fin de Secciones 7-8**

P4S7S8EOF
