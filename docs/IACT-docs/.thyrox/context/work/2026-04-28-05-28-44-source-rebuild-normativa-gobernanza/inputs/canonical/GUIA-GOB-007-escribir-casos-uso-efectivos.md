---
id: GUIA-GOB-007
tipo: guia
categoria: gobernanza
subcategoria: requisitos
version: 1.0.0
fecha: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
relacionados: ["ADR-GOB-007", "ADR-GOB-005", "ADR-GOB-008", "ADR-GOB-009"]
---

# GUIA-GOB-007: Escribir Casos de Uso Efectivos

## Propósito

Esta guía enseña cómo escribir casos de uso de alta calidad que sean claros, completos, verificables y útiles para todos los stakeholders, aplicando las decisiones del ADR-GOB-007.

## Audiencia

- Analistas de requisitos
- Product Owners
- Arquitectos de software
- Desarrolladores
- Testers / QA

## Problema que Resuelve

Casos de uso mal escritos causan:
- Ambigüedad en responsabilidades (¿quién hace qué?)
- Mezcla de niveles de abstracción (QUÉ vs CÓMO)
- Nomenclatura inconsistente
- Falta de información crítica (precondiciones, postcondiciones)
- Dificultad para derivar requisitos funcionales
- Incomprensión por stakeholders no técnicos

## Recordatorio: Especificar vs Ilustrar

```
ESPECIFICAR casos de uso = ESCRIBIR documentos de texto
ILUSTRAR diagramas UML = DIBUJAR figuras (ver GUIA-GOB-008)
```

Esta guía trata sobre **especificar** (escribir documentos de texto).

## Parte 1: Principio Fundamental - QUÉ vs CÓMO

### La Regla de Oro

**Los casos de uso describen QUÉ debe hacer el sistema, NO CÓMO lo hace.**

### Ejercicio de Contraste

#### Ejemplo 1: Login

**INCORRECTO (CÓMO)**:
```
3. El sistema ejecuta query SQL: SELECT * FROM usuarios WHERE email = ?
4. El sistema compara password usando bcrypt.compare()
5. El sistema genera JWT usando librería jsonwebtoken con algoritmo HS256
6. El sistema escribe registro en tabla audit_logs usando INSERT INTO...
```

**Problema**: Especifica implementación técnica (SQL, bcrypt, JWT, tabla específica).

**CORRECTO (QUÉ)**:
```
3. El sistema valida credenciales contra base de datos de usuarios
4. El sistema genera token de sesión con expiración de 15 minutos
5. El sistema registra el intento de login en log de auditoría
```

**Por qué es mejor**:
- Independiente de tecnología (podría cambiar de SQL a NoSQL)
- Enfocado en comportamiento observable
- Comprensible por stakeholders no técnicos
- Permite flexibilidad en diseño

#### Ejemplo 2: Guardar Datos

**INCORRECTO (CÓMO)**:
```
5. El sistema serializa el objeto a JSON
6. El sistema escribe en archivo /var/data/orders.json
7. El sistema hace chmod 644 al archivo
```

**CORRECTO (QUÉ)**:
```
5. El sistema guarda la orden en almacenamiento persistente
6. El sistema protege los datos con permisos apropiados
```

#### Ejemplo 3: Enviar Notificación

**INCORRECTO (CÓMO)**:
```
8. El sistema usa API de SendGrid para enviar email
9. El sistema configura template ID: d-abc123
10. El sistema usa puerto SMTP 587
```

**CORRECTO (QUÉ)**:
```
8. El sistema envía email de confirmación al usuario
```

### Ejercicio Práctico: Identificar QUÉ vs CÓMO

**Instrucciones**: Marca cada oración como QUÉ o CÓMO

1. "El sistema valida formato de email"
   ```
   Respuesta: _________
   ```

2. "El sistema usa expresión regular /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/ para validar email"
   ```
   Respuesta: _________
   ```

3. "El sistema guarda la venta"
   ```
   Respuesta: _________
   ```

4. "El sistema ejecuta stored procedure sp_guardar_venta con parámetros @monto, @fecha"
   ```
   Respuesta: _________
   ```

5. "El sistema calcula el total con impuestos"
   ```
   Respuesta: _________
   ```

6. "El sistema multiplica subtotal por 1.16 para obtener total con IVA"
   ```
   Respuesta: _________
   ```

**Soluciones**:
1. QUÉ (describe comportamiento, no implementación)
2. CÓMO (especifica expresión regular exacta)
3. QUÉ (describe acción, no mecanismo)
4. CÓMO (especifica stored procedure y parámetros)
5. QUÉ (describe resultado esperado)
6. LÍMITE (técnicamente QUÉ pero demasiado específico; mejor "calcula impuestos")

### Checklist: ¿Es QUÉ o CÓMO?

**Es CÓMO (evitar) si menciona**:
- [ ] Tecnología específica (SQL, NoSQL, REST, GraphQL)
- [ ] Nombres de tablas o campos de base de datos
- [ ] Nombres de librerías o frameworks
- [ ] Algoritmos específicos (merge sort, bcrypt, SHA-256)
- [ ] Rutas de archivos o URLs específicas
- [ ] Código o pseudocódigo

**Es QUÉ (correcto) si describe**:
- [ ] Comportamiento observable del sistema
- [ ] Validaciones (sin especificar algoritmo)
- [ ] Transformaciones de datos (sin especificar fórmula exacta)
- [ ] Almacenamiento (sin especificar mecanismo)
- [ ] Comunicación (sin especificar protocolo)

## Parte 2: Nomenclatura VERBO+OBJETO

### Patrón Obligatorio

```
VERBO + OBJETO
```

**NO**: Sustantivos puros, frases largas, sujetos incluidos

### 10 Ejemplos Buenos

1. **Registrar Vuelo**
   - Verbo: Registrar
   - Objeto: Vuelo
   - ✓ Claro, conciso, acción + cosa

2. **Imprimir Pases de Abordar**
   - Verbo: Imprimir
   - Objeto: Pases de Abordar
   - ✓ Plural permitido cuando apropiado

3. **Cambiar Asientos**
   - Verbo: Cambiar
   - Objeto: Asientos
   - ✓ Simple y directo

4. **Solicitar Producto Químico**
   - Verbo: Solicitar
   - Objeto: Producto Químico
   - ✓ Objeto compuesto apropiado

5. **Generar Reporte de Auditoría**
   - Verbo: Generar
   - Objeto: Reporte de Auditoría
   - ✓ Objeto con calificador

6. **Procesar Pago**
   - Verbo: Procesar
   - Objeto: Pago
   - ✓ Clásico verbo de negocio

7. **Consultar Inventario**
   - Verbo: Consultar
   - Objeto: Inventario
   - ✓ Acción de lectura

8. **Actualizar Perfil de Usuario**
   - Verbo: Actualizar
   - Objeto: Perfil de Usuario
   - ✓ Acción de modificación

9. **Eliminar Producto Obsoleto**
   - Verbo: Eliminar
   - Objeto: Producto Obsoleto
   - ✓ Objeto con adjetivo descriptivo

10. **Aprobar Solicitud de Compra**
    - Verbo: Aprobar
    - Objeto: Solicitud de Compra
    - ✓ Acción de workflow

### 10 Ejemplos Malos (y Cómo Corregirlos)

1. **Login** ✗
   - Problema: Sustantivo, no verbo+objeto
   - Corrección: **Iniciar Sesión** ✓

2. **El usuario inicia sesión** ✗
   - Problema: Incluye sujeto
   - Corrección: **Iniciar Sesión** ✓

3. **Sistema de autenticación** ✗
   - Problema: Describe sistema, no acción
   - Corrección: **Autenticar Usuario** ✓

4. **Autenticarse** ✗
   - Problema: Solo verbo, falta objeto
   - Corrección: **Iniciar Sesión** ✓

5. **Gestión de inventario** ✗
   - Problema: Sustantivo (gestión), demasiado amplio
   - Corrección: **Consultar Inventario**, **Actualizar Inventario** ✓

6. **El cajero procesa una venta al cliente** ✗
   - Problema: Oración completa con sujetos
   - Corrección: **Procesar Venta** ✓

7. **Hacer login con credenciales válidas** ✗
   - Problema: Demasiado detallado
   - Corrección: **Iniciar Sesión** ✓

8. **CRUD de productos** ✗
   - Problema: Acrónimo técnico
   - Corrección: **Gestionar Productos** o separar en 4 UC ✓

9. **Búsqueda avanzada con filtros** ✗
   - Problema: Demasiado detallado
   - Corrección: **Buscar Productos** ✓

10. **Usuarios administrando sus perfiles** ✗
    - Problema: Gerundio y sujeto
    - Corrección: **Actualizar Perfil** ✓

### Verbos Comunes por Categoría

#### Verbos de Creación
- Registrar (Registrar Cliente)
- Crear (Crear Orden de Compra)
- Agregar (Agregar Producto al Carrito)
- Solicitar (Solicitar Producto Químico)

#### Verbos de Lectura/Consulta
- Consultar (Consultar Inventario)
- Buscar (Buscar Vuelos)
- Ver (Ver Historial de Transacciones)
- Listar (Listar Productos Disponibles)

#### Verbos de Actualización
- Actualizar (Actualizar Perfil)
- Modificar (Modificar Orden)
- Cambiar (Cambiar Contraseña)
- Editar (Editar Producto)

#### Verbos de Eliminación
- Eliminar (Eliminar Usuario)
- Cancelar (Cancelar Orden)
- Dar de Baja (Dar de Baja Empleado)
- Revocar (Revocar Permiso)

#### Verbos de Proceso/Acción
- Procesar (Procesar Pago)
- Generar (Generar Factura)
- Enviar (Enviar Email de Confirmación)
- Aprobar (Aprobar Solicitud)
- Rechazar (Rechazar Devolución)
- Validar (Validar Certificación)

### Ejercicio: Corregir Nomenclatura

**Instrucciones**: Corrige estos nombres de casos de uso

1. "El usuario puede ver su historial de compras"
   ```
   Corrección: _________________________
   ```

2. "Dashboard de métricas"
   ```
   Corrección: _________________________
   ```

3. "Registro de nuevos empleados en el sistema"
   ```
   Corrección: _________________________
   ```

4. "Password recovery"
   ```
   Corrección: _________________________
   ```

5. "Gestión completa de usuarios del sistema"
   ```
   Corrección: _________________________
   ```

**Soluciones**:
1. **Consultar Historial de Compras**
2. **Consultar Métricas** o **Ver Dashboard de Métricas**
3. **Registrar Empleado**
4. **Recuperar Contraseña**
5. Separar en: **Crear Usuario**, **Editar Usuario**, **Eliminar Usuario**, **Consultar Usuarios**

## Parte 3: Formato de Dos Columnas

### Estructura Visual

```
┌──────────────────────────┬─────────────────────────────┐
│  ACCIONES DEL ACTOR      │  RESPONSABILIDADES SISTEMA  │
├──────────────────────────┼─────────────────────────────┤
│ 1. Actor hace X          │                             │
├──────────────────────────┼─────────────────────────────┤
│                          │ 2. Sistema hace Y           │
│                          │ 3. Sistema hace Z           │
├──────────────────────────┼─────────────────────────────┤
│ 4. Actor hace W          │                             │
└──────────────────────────┴─────────────────────────────┘
```

### Ventajas del Formato

1. **Claridad visual**: Obvio quién hace qué
2. **Separación de responsabilidades**: Actor vs Sistema
3. **Facilita extracción de RF**: Columna derecha = requisitos funcionales
4. **Reduce ambigüedad**: No se mezclan acciones
5. **Mejor para validación**: Stakeholders revisan su columna

### Ejemplo Completo: UC-BACK-001 Iniciar Sesión

```markdown
## UC-BACK-001: Iniciar Sesión

**Actores Primarios**: Usuario Registrado
**Actores Secundarios**: Sistema de Auditoría

### Precondiciones
- El usuario debe tener cuenta registrada en el sistema
- El usuario no debe estar bloqueado

### Flujo Normal (Happy Path)

| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| 1. El usuario accede a pantalla de login | |
| 2. El usuario introduce email y contraseña | |
| | 3. El sistema valida formato de email |
| | 4. El sistema valida credenciales contra base de datos |
| | 5. El sistema verifica que cuenta esté activa (no bloqueada) |
| | 6. El sistema genera token de sesión con expiración de 15 minutos |
| | 7. El sistema actualiza campo "ultimo_acceso" del usuario |
| | 8. El sistema registra intento exitoso en log de auditoría |
| | 9. El sistema muestra pantalla principal con menú de navegación |

### Postcondiciones
- Usuario autenticado con sesión activa
- Token de sesión almacenado en cliente
- Evento de login registrado en auditoría
```

### Reglas de Numeración

**Opción 1: Numeración global secuencial**
```
| ACTOR | SISTEMA |
|---|---|
| 1. Actor hace X | |
| | 2. Sistema hace Y |
| | 3. Sistema hace Z |
| 4. Actor hace W | |
```

**Opción 2: Numeración por columna** (menos común)
```
| ACTOR | SISTEMA |
|---|---|
| 1. Actor hace X | |
| | 1. Sistema hace Y |
| | 2. Sistema hace Z |
| 2. Actor hace W | |
```

**Recomendación**: Usar numeración global (Opción 1) para secuencia clara.

### Cuándo Usar Formato de Dos Columnas

**USAR cuando**:
- [ ] UC interactivo (múltiples intercambios actor-sistema)
- [ ] Responsabilidades del sistema complejas
- [ ] Necesidad de claridad para stakeholders
- [ ] Se derivarán requisitos funcionales

**NO USAR (formato simple) cuando**:
- [ ] UC extremadamente simple (3 pasos o menos)
- [ ] Solo una acción del sistema sin interacción
- [ ] Caso trivial sin valor de documentación extensa

## Parte 4: Flujos Alternos vs Excepciones

### Diferencia Fundamental

| Aspecto | Flujos Alternos | Excepciones |
|---------|-----------------|-------------|
| **Propósito** | Camino alternativo VÁLIDO hacia éxito | Situación de ERROR que previene éxito |
| **Resultado** | Postcondición lograda (posiblemente diferente) | Caso de uso termina sin éxito completo |
| **Ejemplo** | Pagar con tarjeta vs. pagar con transferencia | Tarjeta rechazada por fondos insuficientes |
| **Frecuencia** | Común, esperado | Menos frecuente, indeseable |

### Ejemplos de Flujos Alternos

#### Flujo Alterno 1: Método de Pago Alternativo

**Contexto**: UC-BACK-020 Procesar Pago

```markdown
### Flujo Alterno 2.1: Pago con Transferencia Bancaria

**Punto de entrada**: Después del paso 2 (Cliente elige método de pago)

**Condición**: Cliente selecciona "Transferencia Bancaria" en lugar de tarjeta

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| 2.1.1 Cliente selecciona transferencia bancaria | |
| | 2.1.2 Sistema genera CLABE interbancaria |
| | 2.1.3 Sistema muestra instrucciones de transferencia |
| | 2.1.4 Sistema envía instrucciones por email |
| 2.1.5 Cliente realiza transferencia desde su banco | |
| 2.1.6 Cliente notifica que completó transferencia | |
| | 2.1.7 Sistema registra pago como "pendiente de confirmación" |
| | 2.1.8 Sistema genera número de seguimiento |

**Punto de retorno**: Sistema continúa con paso 5 del flujo normal (confirmar orden)

**Postcondición alternativa**: Orden registrada con pago pendiente (no confirmado inmediatamente)
```

#### Flujo Alterno 2: Producto No Disponible

**Contexto**: UC-BACK-030 Solicitar Producto Químico

```markdown
### Flujo Alterno 4.1: Producto No Disponible en Inventario

**Punto de entrada**: Después del paso 4 (Sistema verifica disponibilidad)

**Condición**: Producto solicitado tiene stock = 0

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 4.1.1 Sistema detecta stock = 0 |
| | 4.1.2 Sistema muestra mensaje "Producto no disponible" |
| | 4.1.3 Sistema sugiere 3 productos alternativos similares |
| 4.1.4 Solicitante puede seleccionar producto alternativo | |
| | 4.1.5 Sistema actualiza solicitud con producto seleccionado |

**Punto de retorno**: Regresa a paso 5 del flujo normal (confirmar solicitud)

**Postcondición**: Solicitud registrada con producto alternativo (si fue seleccionado)
```

### Ejemplos de Excepciones

#### Excepción 1: Credenciales Incorrectas

**Contexto**: UC-BACK-001 Iniciar Sesión

```markdown
### Excepción 4.1: Credenciales Incorrectas

**Punto de entrada**: Durante paso 4 (Sistema valida credenciales)

**Condición**: Email o contraseña incorrectos

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 4.1.1 Sistema incrementa contador de intentos fallidos |
| | 4.1.2 Sistema registra intento fallido en log de auditoría |
| | 4.1.3 Sistema muestra mensaje "Email o contraseña incorrectos" |
| | 4.1.4 Sistema limpia campo de contraseña |
| 4.1.5 Usuario puede reintentar ingreso de credenciales | |

**Resultado**: Regresa a paso 2 (usuario introduce credenciales nuevamente)

**Nota**: Si intentos fallidos >= 5, activar Excepción 4.2 (Cuenta Bloqueada)
```

#### Excepción 2: Tarjeta Rechazada

**Contexto**: UC-BACK-020 Procesar Pago

```markdown
### Excepción 3.1: Tarjeta Rechazada por Banco

**Punto de entrada**: Durante paso 3 (Sistema procesa pago con tarjeta)

**Condición**: Gateway de pago devuelve error (fondos insuficientes, tarjeta bloqueada, etc.)

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 3.1.1 Sistema recibe código de error del gateway |
| | 3.1.2 Sistema registra transacción con estado "fallida" |
| | 3.1.3 Sistema traduce código de error a mensaje comprensible |
| | 3.1.4 Sistema muestra mensaje al cliente: "Tarjeta rechazada: [razón]" |
| 3.1.5 Cliente puede seleccionar otra tarjeta o método de pago | |

**Resultado**: Regresa a paso 2 (seleccionar método de pago) o caso de uso termina sin éxito

**Postcondición**: NO se completó el pago, orden permanece pendiente
```

### Cómo Decidir: ¿Alterno o Excepción?

**Preguntas clave**:

1. **¿El resultado es exitoso?**
   - SÍ → Flujo Alterno
   - NO → Excepción

2. **¿Es un camino válido esperado?**
   - SÍ → Flujo Alterno
   - NO → Excepción

3. **¿Se logra la postcondición (aunque sea diferente)?**
   - SÍ → Flujo Alterno
   - NO → Excepción

4. **¿Es deseable que ocurra?**
   - SÍ o NEUTRAL → Flujo Alterno
   - NO → Excepción

### Ejercicio: Clasificar Flujos

**Instrucciones**: Clasifica cada escenario como Flujo Alterno o Excepción

**Contexto**: UC Procesar Venta

1. "Cliente paga en efectivo en lugar de tarjeta"
   ```
   Respuesta: _____________
   ```

2. "Sistema de impresión no responde al intentar imprimir recibo"
   ```
   Respuesta: _____________
   ```

3. "Cliente solicita factura electrónica además de ticket"
   ```
   Respuesta: _____________
   ```

4. "Producto escaneado no existe en catálogo"
   ```
   Respuesta: _____________
   ```

5. "Cliente paga con combinación de efectivo y tarjeta"
   ```
   Respuesta: _____________
   ```

**Soluciones**:
1. **Flujo Alterno** (método de pago válido alternativo)
2. **Excepción** (error que previene completar el proceso)
3. **Flujo Alterno** (opción adicional válida)
4. **Excepción** (error de datos que previene venta)
5. **Flujo Alterno** (forma válida de pago)

## Parte 5: Precondiciones y Postcondiciones

### Precondiciones

**Definición**: Condiciones que DEBEN ser verdaderas ANTES de iniciar el caso de uso.

#### Características
- Establecen contexto necesario
- NO son parte del flujo (ocurren antes)
- Sistema puede/debe validarlas
- Si no se cumplen, UC no puede iniciarse

#### Tipos de Precondiciones

1. **Estado del Sistema**
   - "El sistema debe estar operativo"
   - "El catálogo de productos debe estar cargado"

2. **Estado del Actor**
   - "El usuario debe estar autenticado"
   - "El usuario debe tener rol de 'Gerente'"

3. **Existencia de Datos**
   - "Debe existir al menos un producto en el carrito"
   - "El cliente debe tener dirección de envío registrada"

4. **Condiciones de Negocio**
   - "La cuenta del usuario no debe estar bloqueada"
   - "El usuario debe tener certificación de seguridad vigente"

#### Ejemplos Buenos de Precondiciones

**UC-BACK-010: Cambiar Contraseña**
```markdown
## Precondiciones
- El usuario debe estar autenticado en el sistema
- El usuario debe tener una sesión activa válida
- El usuario no debe estar en proceso de recuperación de contraseña
```

**UC-BACK-040: Solicitar Producto Químico Peligroso**
```markdown
## Precondiciones
- El usuario debe estar autenticado
- El usuario debe tener certificación de seguridad vigente (menos de 12 meses)
- El catálogo de productos debe estar disponible
- El usuario no debe tener solicitudes pendientes sin aprobar
```

#### Ejemplos Malos de Precondiciones

**INCORRECTO**:
```markdown
## Precondiciones
- El usuario debe hacer clic en botón "Solicitar"
```
**Problema**: Es parte del flujo, no una precondición.

**INCORRECTO**:
```markdown
## Precondiciones
- El sistema debe usar base de datos PostgreSQL
```
**Problema**: Es decisión de diseño, no precondición de negocio.

#### Precondiciones Opcionales: ¿0 o más?

**Sí, puede haber 0 precondiciones** si el UC no requiere contexto previo.

**Ejemplo**:
```markdown
UC-FRONT-001: Ver Página de Inicio

## Precondiciones
Ninguna (página pública accesible sin autenticación)
```

### Postcondiciones

**Definición**: Estado del sistema DESPUÉS de completar EXITOSAMENTE el caso de uso.

#### Características
- Describen resultado logrado
- Son verificables
- Establecen garantías del sistema
- Base para tests de aceptación

#### Tipos de Postcondiciones

1. **Datos Creados/Modificados**
   - "La orden ha sido registrada en el sistema"
   - "El perfil del usuario ha sido actualizado"

2. **Estado Cambiado**
   - "El usuario tiene sesión activa"
   - "El producto está marcado como 'agotado'"

3. **Notificaciones Enviadas**
   - "Se ha enviado email de confirmación al cliente"
   - "El gerente ha sido notificado de la solicitud"

4. **Eventos Registrados**
   - "El intento de login ha sido registrado en auditoría"
   - "La transacción ha sido registrada con timestamp"

#### Ejemplos Buenos de Postcondiciones

**UC-BACK-001: Iniciar Sesión**
```markdown
## Postcondiciones
- El usuario tiene sesión activa con token válido
- El campo "ultimo_acceso" del usuario ha sido actualizado
- El intento exitoso de login ha sido registrado en log de auditoría
- El usuario puede acceder a funcionalidades protegidas del sistema
```

**UC-BACK-050: Procesar Pago**
```markdown
## Postcondiciones
- La transacción ha sido registrada con estado "exitosa"
- El saldo de la orden ha sido actualizado a $0.00 (pagado)
- Se ha enviado email de confirmación con número de transacción
- El inventario ha sido actualizado (productos reservados)
- Se ha generado comprobante de pago con folio fiscal
```

#### Postcondiciones de Flujos Alternos

Los flujos alternos pueden tener postcondiciones ligeramente diferentes:

**Flujo Normal**:
```markdown
Postcondición: Pago procesado inmediatamente, orden confirmada
```

**Flujo Alterno (Transferencia Bancaria)**:
```markdown
Postcondición: Pago registrado como "pendiente", orden en espera de confirmación
```

### Checklist de Validación

**Precondiciones**:
- [ ] Son condiciones ANTES del UC, no durante
- [ ] Son verificables por el sistema
- [ ] Establecen contexto necesario
- [ ] No describen pasos del flujo
- [ ] Redactadas en tiempo presente o futuro ("debe estar", "debe tener")

**Postcondiciones**:
- [ ] Describen estado DESPUÉS del UC exitoso
- [ ] Son verificables
- [ ] Incluyen cambios de datos relevantes
- [ ] Incluyen notificaciones/eventos importantes
- [ ] Redactadas en tiempo pasado ("ha sido registrada", "se ha enviado")

## Parte 6: Checklist de Calidad de Casos de Uso

### Antes de Documentar

- [ ] ¿He identificado el requerimiento de negocio (RNEG) que justifica este UC?
- [ ] ¿He identificado las reglas de negocio (RN) que aplican?
- [ ] ¿Conozco el actor primario (quién ejecuta el UC)?
- [ ] ¿El UC tiene valor observable para el actor?

### Nomenclatura

- [ ] ¿Usa formato VERBO+OBJETO?
- [ ] ¿No incluye sujeto ("El usuario...", "El sistema...")?
- [ ] ¿Es claro y conciso (máximo 4 palabras)?
- [ ] ¿Sigue convención de archivos (UC-DOMINIO-###-verbo-objeto.md)?

### Principio QUÉ vs CÓMO

- [ ] ¿Describe QUÉ debe hacer el sistema (no CÓMO)?
- [ ] ¿No menciona tecnologías específicas (SQL, API, etc.)?
- [ ] ¿No menciona algoritmos de implementación?
- [ ] ¿No especifica nombres de tablas, campos o rutas de archivo?
- [ ] ¿Es comprensible para stakeholders no técnicos?

### Estructura y Formato

- [ ] ¿Usa formato de dos columnas (Actor | Sistema)?
- [ ] ¿Separa claramente acciones de actor vs sistema?
- [ ] ¿Numera pasos secuencialmente?
- [ ] ¿Identifica actores primarios y secundarios?

### Completitud

- [ ] ¿Tiene precondiciones documentadas (o explícitamente "ninguna")?
- [ ] ¿Tiene postcondiciones documentadas?
- [ ] ¿Tiene flujo normal completo?
- [ ] ¿Identifica flujos alternos principales (si existen)?
- [ ] ¿Identifica excepciones críticas (si existen)?

### Trazabilidad

- [ ] ¿Lista reglas de negocio (RN) relacionadas?
- [ ] ¿Lista requerimientos de negocio (RNEG) que justifican este UC?
- [ ] ¿Lista requisitos funcionales (RF) derivados?
- [ ] ¿Lista atributos de calidad (RNF) específicos?

### Claridad

- [ ] ¿Cada paso es una acción concreta y atómica?
- [ ] ¿No hay ambigüedad en responsabilidades?
- [ ] ¿Los flujos alternos tienen puntos de entrada y retorno claros?
- [ ] ¿Las excepciones tienen resultados claros?

### Verificabilidad

- [ ] ¿Las precondiciones son verificables?
- [ ] ¿Las postcondiciones son verificables?
- [ ] ¿Se pueden derivar casos de prueba directamente del UC?
- [ ] ¿QA podría validar el UC sin preguntas?

## Parte 7: Ejemplos Completos Anotados

### Ejemplo 1: UC-BACK-010 Cambiar Contraseña

```markdown
---
id: UC-BACK-010
tipo: caso_uso
categoria: backend
version: 1.0.0
fecha_creacion: 2025-11-17
autor: Equipo de Análisis
estado: aprobado
---

# UC-BACK-010: Cambiar Contraseña

## Información General

**ID**: UC-BACK-010
**Nombre**: Cambiar Contraseña
**Estado**: Aprobado

## Actores

**Actores Primarios**: Usuario Autenticado

**Actores Secundarios**: Sistema de Auditoría

## Descripción

Permite a un usuario autenticado cambiar su contraseña actual por una nueva,
validando la contraseña anterior y aplicando políticas de seguridad.

## Desencadenador

El usuario selecciona opción "Cambiar Contraseña" desde su perfil.

## Precondiciones

- El usuario debe estar autenticado en el sistema
- El usuario debe tener una sesión activa válida
- El usuario no debe estar en proceso de recuperación de contraseña

## Postcondiciones

- La contraseña del usuario ha sido actualizada en el sistema
- La contraseña antigua ha sido invalidada
- Todas las sesiones activas excepto la actual han sido cerradas
- Se ha enviado email de confirmación al usuario
- El cambio ha sido registrado en log de auditoría

## Flujo Normal (Happy Path)

| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| 1. El usuario accede a pantalla de cambio de contraseña | |
| 2. El usuario introduce contraseña actual | |
| 3. El usuario introduce nueva contraseña (2 veces) | |
| | 4. El sistema valida que contraseña actual es correcta |
| | 5. El sistema valida que nueva contraseña cumple política de seguridad (mín 8 caracteres, mayúscula, minúscula, número, símbolo) |
| | 6. El sistema valida que ambas entradas de nueva contraseña coinciden |
| | 7. El sistema valida que nueva contraseña es diferente de contraseña actual |
| | 8. El sistema hashea nueva contraseña |
| | 9. El sistema actualiza contraseña en base de datos |
| | 10. El sistema cierra todas las sesiones activas excepto la actual |
| | 11. El sistema registra cambio en log de auditoría |
| | 12. El sistema envía email de confirmación |
| | 13. El sistema muestra mensaje de éxito |

## Flujos Alternos

### Flujo Alterno 7.1: Nueva Contraseña Igual a Actual

**Punto de entrada**: Después del paso 7 (validar contraseña diferente)

**Condición**: Nueva contraseña es idéntica a contraseña actual

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 7.1.1 Sistema muestra mensaje "La nueva contraseña debe ser diferente de la actual" |
| 7.1.2 Usuario puede ingresar contraseña diferente | |

**Punto de retorno**: Regresa a paso 3

## Excepciones

### Excepción 4.1: Contraseña Actual Incorrecta

**Punto de entrada**: Durante paso 4 (validar contraseña actual)

**Condición**: Contraseña actual ingresada no coincide con la almacenada

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 4.1.1 Sistema incrementa contador de intentos fallidos |
| | 4.1.2 Sistema muestra mensaje "Contraseña actual incorrecta" |
| 4.1.3 Usuario puede reintentar | |

**Resultado**: Regresa a paso 2. Si intentos >= 3, bloquear operación temporalmente.

### Excepción 5.1: Nueva Contraseña No Cumple Política

**Punto de entrada**: Durante paso 5 (validar política de seguridad)

**Condición**: Nueva contraseña no cumple con requisitos mínimos

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 5.1.1 Sistema identifica qué requisitos no se cumplen |
| | 5.1.2 Sistema muestra mensaje específico: "La contraseña debe tener..." |
| 5.1.3 Usuario puede ingresar contraseña válida | |

**Resultado**: Regresa a paso 3

### Excepción 6.1: Contraseñas No Coinciden

**Punto de entrada**: Durante paso 6 (validar coincidencia)

**Condición**: Las dos entradas de nueva contraseña no coinciden

**Pasos**:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| | 6.1.1 Sistema muestra mensaje "Las contraseñas no coinciden" |
| | 6.1.2 Sistema limpia ambos campos de nueva contraseña |
| 6.1.3 Usuario puede reingresar contraseña | |

**Resultado**: Regresa a paso 3

## Requisitos Especiales

**Requerimientos No Funcionales Relacionados**:
- RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres con complejidad
- RNF-BACK-008: Contraseñas deben ser hasheadas con bcrypt factor 12
- RNF-BACK-020: El sistema debe responder en menos de 3 segundos

**Restricciones**:
- No se permite cambiar contraseña más de 3 veces en 24 horas

## Reglas de Negocio Relacionadas

- RN-BACK-001: Usuario debe estar autenticado
- RN-BACK-025: Contraseñas deben cumplir política de seguridad
- RN-BACK-026: Cambios de contraseña deben ser auditados

## Requisitos Funcionales Derivados

- RF-BACK-050: Validar contraseña actual contra hash almacenado
- RF-BACK-051: Validar política de contraseña (8+ caracteres, complejidad)
- RF-BACK-052: Validar que nueva contraseña sea diferente de actual
- RF-BACK-053: Hashear contraseña usando bcrypt
- RF-BACK-054: Cerrar sesiones activas del usuario
- RF-BACK-055: Enviar email de confirmación de cambio

## Información Adicional

**Prioridad**: Alta

**Frecuencia de uso**: Semanal

**Suposiciones**:
- Usuario recuerda su contraseña actual
- Usuario tiene acceso a su email para recibir confirmación
```

### Anotaciones del Ejemplo

**✓ Nomenclatura**: "Cambiar Contraseña" (VERBO+OBJETO)
**✓ QUÉ vs CÓMO**: "hashea nueva contraseña" (no especifica bcrypt aquí)
**✓ Formato dos columnas**: Clara separación de responsabilidades
**✓ Precondiciones**: 3 condiciones necesarias claramente identificadas
**✓ Postcondiciones**: 5 resultados verificables
**✓ Flujos alternos**: Situación válida (contraseña igual)
**✓ Excepciones**: 3 situaciones de error bien documentadas
**✓ Trazabilidad**: Referencias a RN, RNF, RF

## Referencias

- [ADR-GOB-007: Especificación de Casos de Uso](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-007-especificacion-casos-uso.md)
- [ADR-GOB-005: Jerarquía de Requerimientos en 5 Niveles](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md)
- [GUIA-GOB-005: Derivar Requisitos entre Niveles](GUIA-GOB-005-derivar-requisitos-entre-niveles.md)
- [GUIA-GOB-008: Crear Diagramas PlantUML](GUIA-GOB-008-crear-diagramas-plantuml.md)

## Próximos Pasos

1. Practicar escribiendo 3-5 casos de uso del proyecto IACT
2. Revisar casos de uso existentes y mejorarlos según esta guía
3. Crear diagramas UML complementarios (ver GUIA-GOB-008)
4. Derivar requisitos funcionales de casos de uso documentados

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-17 | Claude Code | Versión inicial |
