# PARTE 2: TRANSFORMACIÓN DE BUSINESS RULES A CASOS DE USO Y FUNCTIONAL REQUIREMENTS

**Sistema:** IACT - Integrated Analysis and Contextual Traceability  
**Versión del Documento:** 2.0.0 - IACT Edition  
**Fecha:** Enero 2026  
**Alcance:** Secciones 8-11 (Casos Especiales y Validación)

---

## PARTE 2C: CASOS ESPECIALES Y VALIDACIÓN (Secciones 8-11)

**Documento Analizado:** PARTE_2C_CASOS_ESPECIALES_IACT.md  
**Longitud:** ~60 páginas estimadas  
**Objetivo:** Manejo de casos especiales, validación de calidad y ejercicios prácticos

---

# SECCIÓN 8: CASOS ESPECIALES

## 8.1 UC CRUD Genéricos

Los Casos de Uso CRUD (Create, Read, Update, Delete) son especiales porque:
- Siguen patrón repetitivo
- Raramente derivan de BR específicas (son necesidad técnica)
- Tienen estructura predecible

### Cuándo Documentar UC CRUD

```
┌────────────────────────────────────────────────────┐
│    DECISIÓN: ¿DOCUMENTAR UC CRUD COMPLETO?        │
├────────────────────────────────────────────────────┤
│                                                    │
│  DOCUMENTAR COMPLETO si:                           │
│    ✓ Tiene lógica de negocio compleja             │
│    ✓ Múltiples validaciones de BR                  │
│    ✓ Flujos alternos no triviales                  │
│    ✓ Auditoría detallada requerida                │
│    ✓ Entidad crítica del dominio                   │
│                                                    │
│  DOCUMENTAR SIMPLIFICADO si:                       │
│    ✓ CRUD estándar sin lógica especial            │
│    ✓ Solo validaciones básicas (NOT NULL)          │
│    ✓ Entidad de soporte/catálogo                   │
│                                                    │
│  NO DOCUMENTAR (solo código) si:                   │
│    ✓ Auto-generado por ORM                        │
│    ✓ Sin reglas de negocio                         │
│    ✓ Entidad puramente técnica                     │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: UC CRUD de Function (Completo)

```
═══════════════════════════════════════════════════════════
UC-IACT-15: Registrar Nueva Función en Catálogo
═══════════════════════════════════════════════════════════

JUSTIFICACIÓN DE DOCUMENTACIÓN COMPLETA:
  - Entidad crítica del dominio (44 funciones atómicas)
  - Validaciones de BR: BR-IACT-012 (code_slug único)
  - Impacto en permisos de usuarios
  - Requiere auditoría completa

IDENTIFICACIÓN
──────────────
ID: UC-IACT-15
Nombre: Registrar Nueva Función en Catálogo
Tipo: CRUD - Create
Actor Primario: AGR-002 (agr_admin_funciones)
Módulo: MOD_Functions
Prioridad: Alta (operación frecuente)
Complejidad: Media

ACTORES
───────
Actor Primario:
  AGR-002 (agr_admin_funciones) - Administrador de funciones
  
Stakeholders:
  - Administrador de funciones: Mantener catálogo actualizado
  - Administrador de acceso: Nuevas funciones disponibles para asignar
  - Auditor: Tracking de cambios en catálogo

PRECONDICIONES
──────────────
  - Actor tiene función FUNC-015 (registrar_funcion)
  - Actor autenticado con sesión activa
  - Catálogo de categorías definido (5 categorías)
  - Sistema de auditoría activo

TRIGGER
───────
Administrador selecciona "Registrar Nueva Función" desde dashboard

FLUJO NORMAL (9 pasos)
──────────────────────

1. Admin selecciona "Registrar Nueva Función"

2. Sistema muestra formulario con campos:
   - code_slug: VARCHAR(50) [requerido, único]
   - name: VARCHAR(100) [requerido]
   - description: TEXT [opcional]
   - categoria: ENUM [requerido, dropdown]
   - es_critica: BOOLEAN [checkbox, default FALSE]
   - estado: ENUM [default ACTIVA]
   - orden_visualizacion: INT [opcional]

3. Admin completa campos:
   Ejemplo:
     code_slug: "consultar_auditoria_completa"
     name: "Consultar Auditoría Completa"
     description: "Permite ver todos los eventos de auditoría..."
     categoria: "Auditoría"
     es_critica: TRUE
     orden: 45

4. Admin confirma "Guardar"

5. Sistema valida code_slug único [BR-IACT-012]
   
   Query:
   SELECT COUNT(*) FROM functions 
   WHERE code_slug = ?;
   
   IF count > 0 THEN
     Ir a FA-1: code_slug Duplicado
   END IF

6. Sistema valida campos requeridos
   
   IF code_slug IS NULL OR name IS NULL OR categoria IS NULL THEN
     Ir a FA-2: Campos Requeridos Faltantes
   END IF

7. Sistema valida formato code_slug
   
   Pattern: ^[a-z][a-z0-9_]*$
   (lowercase, underscore, no espacios)
   
   IF NOT MATCH THEN
     Ir a FA-3: Formato Inválido
   END IF

8. Sistema crea registro en tabla functions
   
   INSERT INTO functions (
     function_id,
     code_slug,
     name,
     description,
     categoria,
     es_critica,
     estado,
     orden_visualizacion,
     created_at,
     created_by
   ) VALUES (
     UUID(),
     ?,
     ?,
     ?,
     ?,
     ?,
     'ACTIVA',
     ?,
     NOW(),
     ?
   );

9. Sistema registra en auditoría
   
   INSERT INTO audit_log (
     evento_tipo,
     function_id,
     user_id,
     descripcion,
     metadata_json,
     timestamp
   ) VALUES (
     'FUNCTION_CREATED',
     ?,
     ?,
     'Nueva función registrada en catálogo',
     JSON_OBJECT(
       'code_slug', ?,
       'name', ?,
       'es_critica', ?
     ),
     NOW()
   );

10. Sistema muestra mensaje de éxito con detalles
    "Función '{name}' registrada exitosamente con código {code_slug}"

FLUJOS ALTERNOS
───────────────

FA-1: code_slug Duplicado [BR-IACT-012]
  
  5a. Sistema detecta code_slug ya existe
  
  5b. Sistema busca función existente:
      SELECT name, estado FROM functions
      WHERE code_slug = ?;
  
  5c. Sistema muestra error:
      "El código '{code_slug}' ya existe.
       Función existente: '{name}' (Estado: {estado})
       
       Sugerencias:
       - Use un código diferente
       - O reactive la función existente si está INACTIVA"
  
  5d. Sistema mantiene formulario con datos ingresados
      (excepto code_slug marcado en rojo)
  
  5e. Admin puede:
      [Cambiar código] [Cancelar] [Ver función existente]
  
  5f. Si elige "Cambiar código":
      Volver a paso 3
  
  5g. Si elige "Ver función existente":
      Abrir UC-IACT-16 (Consultar Función)
  
  Postcondición: Sin función creada, formulario abierto

FA-2: Campos Requeridos Faltantes
  
  6a. Sistema detecta campos requeridos vacíos
  
  6b. Sistema marca campos faltantes en rojo
  
  6c. Sistema muestra mensaje:
      "Complete los campos requeridos:
       • code_slug
       • name
       • categoria"
  
  6d. Volver a paso 3
  
  Postcondición: Formulario con errores visibles

FA-3: Formato de code_slug Inválido
  
  7a. Sistema detecta formato no válido
  
  7b. Sistema muestra error:
      "Formato de código inválido.
       
       Reglas:
       • Solo minúsculas y guiones bajos
       • Debe iniciar con letra
       • Sin espacios ni caracteres especiales
       
       Ejemplos válidos:
       • consultar_reporte
       • asignar_funcion_critica
       • revisar_logs
       
       Su código: '{code_slug_ingresado}'
       Sugerencia: '{code_slug_sugerido}'"
  
  7c. Sistema auto-sugiere corrección:
      "Consultar Auditoría" → "consultar_auditoria"
  
  7d. Admin puede:
      [Usar sugerencia] [Corregir manual] [Cancelar]
  
  7e. Volver a paso 3
  
  Postcondición: Formulario con sugerencia

FA-4: Categoría No Válida
  
  6.5a. Sistema detecta categoría no existe en catálogo
  
  6.5b. Sistema muestra error:
       "Categoría '{categoria}' no existe.
        
        Categorías disponibles:
        • Consulta
        • Asignación
        • Auditoría
        • Configuración
        • Administración"
  
  6.5c. Volver a paso 3
  
  Postcondición: Dropdown reseteado

FA-5: Admin Cancela Operación
  
  *a. En cualquier momento, admin selecciona "Cancelar"
  
  *b. Sistema pregunta:
      "¿Descartar cambios?"
      [Sí, descartar] [No, continuar editando]
  
  *c. Si confirma descarte:
      Sistema cierra formulario sin guardar
      UC termina sin postcondiciones
  
  *d. Si continúa editando:
      Volver al paso actual
  
  Postcondición: Sin función creada

POSTCONDICIONES
───────────────

De Éxito:
  - Nueva función creada en tabla functions
  - function_id generado (UUID)
  - Estado inicial: ACTIVA
  - Registro en audit_log
  - Función disponible inmediatamente en catálogo
  - Administradores pueden asignarla desde UC-IACT-04

De Fallo (FA-1 a FA-5):
  - Sin registro en functions
  - Sin auditoría
  - Formulario abierto o cerrado según FA

BUSINESS RULES APLICADAS
─────────────────────────
  BR-IACT-012: code_slug debe ser único
    Ubicación: Paso 5, FA-1
    Implementado como: UNIQUE constraint + validación explícita

FUNCTIONAL REQUIREMENTS DERIVADOS
──────────────────────────────────
  FR-1501: Validar Unicidad de code_slug
  FR-1502: Validar Campos Requeridos
  FR-1503: Validar Formato de code_slug
  FR-1504: Crear Registro de Función
  FR-1505: Registrar Auditoría de Creación
  FR-1506: Auto-sugerir code_slug desde name

MÉTRICAS
────────
  Frecuencia: ~1-2 veces por mes (agregar funciones nuevas)
  Duración estimada: 2-3 minutos
  Complejidad: Media (validaciones múltiples)
  Tasa de error esperada: 15% (principalmente duplicados)

═══════════════════════════════════════════════════════════
```

### Template Simplificado para CRUD

Para entidades simples, usar template reducido:

```markdown
## UC-IACT-XX: [Operación] [Entidad]

**Tipo:** CRUD - [Create/Read/Update/Delete]
**Actor:** [Rol]
**Trigger:** [Acción del usuario]

**Flujo Normal:**
1. Actor inicia operación
2. Sistema [obtiene datos / muestra formulario]
3. Actor [ingresa / modifica / confirma] datos
4. Sistema valida [reglas básicas]
5. Sistema [crea / actualiza / elimina] registro
6. Sistema muestra confirmación

**Validaciones:**
- [Lista de validaciones críticas]

**BR Aplicadas:**
- [Solo si hay BR específicas]

**Notas:**
- [Particularidades si las hay]
```

---

## 8.2 Manejo de Restricciones del Sistema

El sistema IACT tiene restricciones técnicas específicas que afectan múltiples UC.

### Catálogo de Restricciones IACT

```
┌────────────────────────────────────────────────────┐
│      RESTRICCIONES GLOBALES DE IACT                │
├────────────────────────────────────────────────────┤
│                                                    │
│  CNST-001: Sin Emails en Producción                │
│    Impacto: Todos los UC que notifican             │
│    Solución: Buzón interno exclusivo               │
│                                                    │
│  CNST-002: BD IVR en Read-Only                     │
│    Impacto: UC que consultan IVR                   │
│    Solución: Solo SELECT, no UPDATE                │
│                                                    │
│  CNST-003: Sesiones en MySQL (No Redis)            │
│    Impacto: UC de sesión                           │
│    Solución: Tabla user_sessions                   │
│                                                    │
│  CNST-004: Sin Actualizaciones Real-Time           │
│    Impacto: UC de monitoreo                        │
│    Solución: Polling cada 30s                      │
│                                                    │
│  CNST-005: Sin Integración con AD                  │
│    Impacto: UC de autenticación                    │
│    Solución: Usuarios locales solamente            │
│                                                    │
│  CNST-009: Logs en MySQL (No ELK/Splunk)           │
│    Impacto: UC de auditoría                        │
│    Solución: Tabla audit_log                       │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: UC Afectado por CNST-001

```
═══════════════════════════════════════════════════════════
UC-IACT-09: Notificar Expiración de Permiso Temporal
═══════════════════════════════════════════════════════════

RESTRICCIÓN APLICADA: CNST-001 (Sin emails)

IMPACTO EN UC:

Original (sin restricción):
  Paso 7: Sistema envía email a usuario
  Paso 8: Sistema envía email a admin

Con restricción CNST-001:
  Paso 7: Sistema envía mensaje a BUZÓN INTERNO de usuario
  Paso 8: Sistema envía mensaje a BUZÓN INTERNO de admin
  
  Servicio usado: InternalMessageService
  Tabla: internal_messages
  No hay: SMTP, SendGrid, mailgun, etc.

FLUJO ALTERNO ADICIONAL:

FA-6: Usuario Tiene Buzón Deshabilitado
  
  7a. Sistema intenta enviar a buzón interno
  
  7b. Campo users.internal_mailbox_enabled = FALSE
  
  7c. Debido a CNST-001, NO HAY fallback a email
  
  7d. Sistema registra error:
      "Usuario {id} no puede recibir notificaciones (buzón deshabilitado)"
  
  7e. Sistema genera alerta para admin:
      "Permiso temporal de usuario {nombre} expirará pero no pudo notificarse"
  
  7f. Sistema envía notificación SOLO a admin (si su buzón está habilitado)
  
  Postcondición: Usuario NO notificado, admin SÍ (con advertencia)

DOCUMENTACIÓN DE RESTRICCIÓN:

Nota en UC:
  ⚠️  RESTRICCIÓN CNST-001: Este sistema NO envía emails.
      Todas las notificaciones usan buzón interno exclusivamente.
      
      Si el buzón interno del usuario está deshabilitado,
      NO hay mecanismo de fallback. La notificación falla.
      
      Razones de CNST-001:
      - Servidor sin acceso SMTP
      - Política de seguridad: emails no encriptados
      - Arquitectura air-gapped en producción

ALTERNATIVAS CONSIDERADAS:

Alternativa A: Fallback a email en desarrollo
  ❌ Rechazada: Comportamiento diferente dev/prod es riesgoso
  
Alternativa B: Log en tabla + dashboard de notificaciones perdidas
  ✅ Implementada: Sistema mantiene pending_notifications table

Alternativa C: Forzar buzón habilitado en todos los usuarios
  ✅ Implementada: Campo internal_mailbox_enabled NOT NULL DEFAULT TRUE
      Admin puede deshabilitar solo manualmente con justificación

═══════════════════════════════════════════════════════════
```

### Plantilla para Documentar Restricciones en UC

```markdown
## RESTRICCIONES APLICADAS

**CNST-XXX: [Nombre de la Restricción]**

Descripción: [Qué prohíbe/limita]

Impacto en este UC:
  - Paso [N]: [Cómo afecta]
  - Flujo Alterno [X]: [Manejo especial]

Solución implementada:
  [Descripción de workaround/alternativa]

Documentación adicional:
  [Link a doc de arquitectura/política]

Fecha vigencia: [Desde cuándo aplica]

Justificación:
  [Por qué existe esta restricción]
```

---

## 8.3 UC con Múltiples Actores Primarios

Algunos UC pueden tener más de un actor primario si varias personas pueden iniciar el mismo comportamiento con igual resultado.

### Criterios para Múltiples Actores

```
┌────────────────────────────────────────────────────┐
│    DECISIÓN: ¿UN UC CON MÚLTIPLES ACTORES?        │
├────────────────────────────────────────────────────┤
│                                                    │
│  SÍ, un solo UC si:                                │
│    ✓ Flujo Normal idéntico para ambos             │
│    ✓ Precondiciones casi iguales                   │
│    ✓ Postcondiciones idénticas                     │
│    ✓ Solo difieren en permisos/rol                 │
│                                                    │
│  NO, UC separados si:                              │
│    ✓ Flujos Normal muy diferentes                  │
│    ✓ Validaciones distintas por actor              │
│    ✓ Postcondiciones divergen                      │
│    ✓ Lógica de negocio diferenciada                │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: UC-IACT-18 con 2 Actores

```
═══════════════════════════════════════════════════════════
UC-IACT-18: Consultar Historial de Asignaciones de Usuario
═══════════════════════════════════════════════════════════

MÚLTIPLES ACTORES PRIMARIOS:
  
  Actor Primario A: AGR-007 (agr_admin_acceso)
    Razón: Necesita ver historial para auditoría
    Diferencia: Ve todos los usuarios
  
  Actor Primario B: Usuario regular (cualquier user_id)
    Razón: Puede ver su propio historial
    Diferencia: Solo ve sus propias asignaciones

JUSTIFICACIÓN DE UN SOLO UC:
  - Flujo Normal: Idéntico (consulta + filtros + paginación)
  - Postcondiciones: Idénticas (solo consulta, no modifica)
  - Diferencia ÚNICA: Filtro de user_id en query

PRECONDICIONES DIFERENCIADAS:

Si Actor = AGR-007:
  - PRE-01: Actor tiene función FUNC-018 (consultar_historial_todos)
  - PRE-02: Actor puede consultar cualquier user_id

Si Actor = Usuario regular:
  - PRE-01: Actor autenticado
  - PRE-02: Actor solo puede consultar su propio user_id

FLUJO NORMAL (7 pasos)

1. Actor selecciona "Ver Historial de Asignaciones"

2. Sistema determina alcance del actor
   
   IF actor.tiene_funcion('consultar_historial_todos') THEN
     alcance = 'TODOS_LOS_USUARIOS'
     mostrar_selector_usuario = TRUE
   ELSE
     alcance = 'SOLO_PROPIO'
     user_id_filtro = actor.user_id
     mostrar_selector_usuario = FALSE
   END IF

3. Sistema muestra interfaz según alcance
   
   Si alcance = TODOS_LOS_USUARIOS:
     Mostrar: [Selector de Usuario] [Rango de fechas] [Filtros]
   
   Si alcance = SOLO_PROPIO:
     Mostrar: [Rango de fechas] [Filtros]
     (Sin selector de usuario)

4. Actor aplica filtros deseados
   Ejemplo Admin:
     - Usuario: "Juan Pérez" (user_id 123)
     - Fechas: 2025-01-01 a 2025-12-31
     - Tipo: Solo asignaciones (no revocaciones)
   
   Ejemplo Usuario Regular:
     - Fechas: Últimos 30 días
     - Tipo: Asignaciones y revocaciones

5. Actor confirma "Buscar"

6. Sistema ejecuta query con alcance respetado
   
   Query para Admin:
   SELECT 
     ah.assignment_history_id,
     ah.user_id,
     u.nombre as usuario_nombre,
     ah.function_id,
     f.code_slug,
     f.name as function_name,
     ah.action_type,  -- 'ASSIGNED' o 'REVOKED'
     ah.assigned_by_user_id,
     admin.nombre as admin_nombre,
     ah.created_at,
     ah.justificacion
   FROM assignment_history ah
   JOIN users u ON ah.user_id = u.user_id
   JOIN functions f ON ah.function_id = f.function_id
   JOIN users admin ON ah.assigned_by_user_id = admin.user_id
   WHERE ah.user_id = ?  -- Parámetro del selector
     AND ah.created_at BETWEEN ? AND ?
     AND (? IS NULL OR ah.action_type = ?)
   ORDER BY ah.created_at DESC
   LIMIT 50 OFFSET ?;
   
   Query para Usuario Regular:
   SELECT 
     ah.assignment_history_id,
     ah.function_id,
     f.code_slug,
     f.name as function_name,
     ah.action_type,
     admin.nombre as admin_nombre,  -- Quién asignó/revocó
     ah.created_at,
     ah.justificacion
   FROM assignment_history ah
   JOIN functions f ON ah.function_id = f.function_id
   JOIN users admin ON ah.assigned_by_user_id = admin.user_id
   WHERE ah.user_id = ?  -- SIEMPRE = actor.user_id (forzado)
     AND ah.created_at BETWEEN ? AND ?
     AND (? IS NULL OR ah.action_type = ?)
   ORDER BY ah.created_at DESC
   LIMIT 50 OFFSET ?;
   
   Diferencia clave:
     Admin: WHERE ah.user_id = [parámetro_selector]
     Usuario: WHERE ah.user_id = [actor_user_id_FORZADO]

7. Sistema muestra resultados en tabla
   
   Columnas para Admin:
     | Usuario | Función | Acción | Admin | Fecha | Justificación |
   
   Columnas para Usuario Regular:
     | Función | Acción | Asignado por | Fecha | Justificación |
   
   (Usuario regular NO ve columna de "Usuario" porque es obvio)

FLUJOS ALTERNOS

FA-1: Usuario Regular Intenta Modificar user_id en Query (Seguridad)
  
  6a. Usuario regular manipula parámetros HTTP
      Intenta: ?user_id=999 (otro usuario)
  
  6b. Sistema detecta user_id != actor.user_id
  
  6c. Sistema FUERZA user_id = actor.user_id
      (Ignora parámetro manipulado)
  
  6d. Sistema registra intento en security_log:
      "Usuario {actor} intentó acceder historial de user {999}"
  
  6e. Sistema continúa con query usando user_id correcto
  
  6f. Continuar paso 7
  
  Postcondición:
    - Query ejecutado con user_id del actor (seguro)
    - Intento registrado en security_log
    - Usuario NO ve mensaje de error (evitar enumeration attack)

FA-2: Sin Resultados
  
  6a. Query retorna 0 filas
  
  6b. Sistema muestra mensaje:
      "No se encontraron asignaciones con los filtros seleccionados."
  
  6c. Sistema ofrece:
      [Ampliar rango de fechas] [Quitar filtros] [Volver]
  
  Postcondición: Tabla vacía con mensaje

POSTCONDICIONES

De Éxito:
  - Historial consultado respetando alcance del actor
  - Admin: Puede ver cualquier usuario
  - Usuario regular: Solo ve su propio historial
  - Sin modificaciones en BD (solo consulta)
  - Auditoría ligera (query_log, no audit_log)

SEGURIDAD CRÍTICA

Validación de alcance:
  ⚠️  CRÍTICO: El sistema NUNCA confía en parámetros del cliente
                para determinar user_id en consultas de usuarios regulares.
  
  Implementación:
    IF NOT actor.tiene_funcion('consultar_historial_todos') THEN
      user_id_query = actor.user_id  -- FORZADO desde sesión
      // Ignorar completamente request.params['user_id']
    END IF

Tests de Seguridad:
  - test_user_cannot_see_other_user_history()
  - test_user_cannot_manipulate_user_id_param()
  - test_admin_can_see_all_users()
  - test_unauthorized_access_logged()

═══════════════════════════════════════════════════════════
```

### Formato para Documentar Múltiples Actores

```markdown
## MÚLTIPLES ACTORES PRIMARIOS

**Actor A: [Rol/Grouper]**
  - Objetivo: [Por qué usa este UC]
  - Alcance: [Qué puede hacer]
  - Precondición específica: [...]

**Actor B: [Rol/Grouper]**
  - Objetivo: [Por qué usa este UC]
  - Alcance: [Qué puede hacer]
  - Precondición específica: [...]

**Diferencias en Flujo:**
  Paso [N]: 
    - Actor A: [Comportamiento]
    - Actor B: [Comportamiento]

**Consideraciones de Seguridad:**
  - [Validaciones para prevenir escalación]
  - [Logging diferenciado si aplica]
```

---

## 8.4 Variantes de UC

A veces un UC tiene múltiples "caminos" significativamente diferentes que merecen documentarse como **variantes** en lugar de flujos alternos.

### Cuándo Usar Variantes

```
┌────────────────────────────────────────────────────┐
│    VARIANTE vs FLUJO ALTERNO vs UC SEPARADO       │
├────────────────────────────────────────────────────┤
│                                                    │
│  VARIANTE (dentro del mismo UC) si:                │
│    ✓ Objetivo final idéntico                       │
│    ✓ Actor primario igual                          │
│    ✓ Precondiciones similares                      │
│    ✓ Camino alternativo IGUALMENTE válido          │
│    ✓ Diferencia en CÓMO se logra el objetivo       │
│                                                    │
│  FLUJO ALTERNO si:                                 │
│    ✓ Es excepción o error                          │
│    ✓ Camino menos común                            │
│    ✓ Resultado diferente del esperado              │
│                                                    │
│  UC SEPARADO si:                                   │
│    ✓ Objetivo diferente                            │
│    ✓ Actor diferente                               │
│    ✓ Precondiciones muy distintas                  │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: UC-IACT-04 con 3 Variantes

```
═══════════════════════════════════════════════════════════
UC-IACT-04: Asignar Funciones a Usuario
═══════════════════════════════════════════════════════════

OBJETIVO COMÚN:
  Asignar una o más funciones a usuario(s) para que puedan
  ejercer esos permisos.

TRES VARIANTES:

┌──────────────────────────────────────────────────────┐
│  VARIANTE A: Asignación Individual (1 función → 1 user)│
│    Más común: 60% de casos                            │
│    Complejidad: Baja                                  │
│    Validaciones: Estándar                             │
│                                                       │
│  VARIANTE B: Asignación Múltiple (N funciones → 1 user)│
│    Común: 30% de casos                                │
│    Complejidad: Media                                 │
│    Validaciones: Score de riesgo [BR-IACT-060]        │
│                                                       │
│  VARIANTE C: Asignación Masiva (N funciones → M users) │
│    Rara: 10% de casos                                 │
│    Complejidad: Alta                                  │
│    Validaciones: Aprobación si >10 users [BR-IACT-028]│
│                                                       │
└──────────────────────────────────────────────────────┘

DOCUMENTACIÓN DE VARIANTES:

═════════════════════════════════════════════════════
VARIANTE A: Asignación Individual
═════════════════════════════════════════════════════

FLUJO NORMAL:

1. Admin selecciona "Asignar Funciones"

2. Sistema muestra catálogo (44 funciones)

3. Admin selecciona usuario destino

4. Admin selecciona UNA función del catálogo

5. Sistema valida BR-IACT-087 (nivel seguridad si crítica)

6. Sistema calcula score de riesgo [BR-IACT-060]
   (Simple: una función añadida)

7. Admin confirma asignación

8. Sistema crea registro en user_functions

9. Sistema actualiza permisos efectivos [BR-IACT-046]

10. Sistema muestra confirmación

CARACTERÍSTICAS:
  - Sin iteración (una sola función)
  - Sin score de riesgo crítico típicamente
  - Sin aprobación de auditor (solo 1 usuario)
  - Rápido: 30 segundos promedio

═════════════════════════════════════════════════════
VARIANTE B: Asignación Múltiple
═════════════════════════════════════════════════════

FLUJO NORMAL:

1-3. [Igual que Variante A]

4. Admin selecciona MÚLTIPLES funciones (checkboxes)
   Ejemplo: 5 funciones

5. Sistema valida BR-IACT-087 para CADA función crítica
   IF any(f.es_critica for f in seleccionadas) THEN
     Validar nivel >= 3
   END IF

6. Sistema calcula score de riesgo ANTES y DESPUÉS
   
   score_actual = calcular_score(user)
   score_proyectado = calcular_score(user + funciones_nuevas)
   
   delta_score = score_proyectado - score_actual
   
   Sistema muestra:
     "Score actual: 45 (MEDIO)
      Score proyectado: 78 (ALTO)
      Delta: +33 puntos"

7. Sistema verifica umbral crítico [BR-IACT-060]
   IF score_proyectado > 85 THEN
     Ir a FA-5: Requiere Justificación Adicional
   END IF

8. Admin confirma asignación de todas las funciones

9. Sistema crea MÚLTIPLES registros (loop):
   FOR EACH funcion IN funciones_seleccionadas:
     INSERT INTO user_functions (...)
   END FOR

10. Sistema actualiza permisos efectivos (UNA VEZ al final)

11. Sistema muestra confirmación con resumen:
    "5 funciones asignadas a {usuario}
     Score de riesgo actualizado: 78 (ALTO)"

CARACTERÍSTICAS:
  - Iteración sobre funciones
  - Score de riesgo más complejo
  - Puede requerir justificación (FA-5)
  - Duración: 1-2 minutos

═════════════════════════════════════════════════════
VARIANTE C: Asignación Masiva (via Agrupador)
═════════════════════════════════════════════════════

TRIGGER DIFERENTE:
  Admin selecciona "Asignar Funciones a Agrupador"
  (En lugar de seleccionar usuario individual)

FLUJO NORMAL:

1. Admin selecciona "Asignar a Agrupador"

2. Sistema muestra catálogo de funciones

3. Admin selecciona AGRUPADOR destino
   (No usuario individual)
   
   Ejemplo: "Gerentes de Área" (20 usuarios)

4. Admin selecciona funciones (una o múltiples)

5. Sistema valida BR-IACT-087 para funciones críticas
   (Aplica a admin que asigna, no a usuarios destino)

6. Sistema calcula usuarios afectados [BR-IACT-028]
   
   Query:
   SELECT COUNT(DISTINCT ug.user_id)
   FROM user_groupers ug
   WHERE ug.grouper_id = ?
     AND ug.estado = 'ACTIVO';
   
   Ejemplo: 20 usuarios activos en agrupador

7. Sistema verifica umbral >10 usuarios [BR-IACT-028]
   
   IF usuarios_afectados > 10 THEN
     Ir a FA-1: Requiere Aprobación de Auditor
   ELSE
     Continuar con paso 8
   END IF

8. Admin confirma asignación masiva

9. Sistema crea registros para CADA usuario del agrupador
   
   BEGIN TRANSACTION;
   
   usuarios = SELECT user_id FROM user_groupers
              WHERE grouper_id = ? AND estado = 'ACTIVO';
   
   FOR EACH user_id IN usuarios:
     FOR EACH function_id IN funciones_seleccionadas:
       INSERT INTO user_functions (
         user_id,
         function_id,
         assigned_via,  -- 'GROUPER'
         grouper_id,
         assigned_by_user_id,
         created_at
       ) VALUES (?, ?, 'GROUPER', ?, ?, NOW());
     END FOR
     
     -- Actualizar permisos efectivos por usuario
     recalculate_effective_permissions(user_id);
   END FOR
   
   COMMIT;

10. Sistema muestra resumen:
    "{count_funciones} funciones asignadas a {count_usuarios} usuarios
     del agrupador '{grouper_name}'"

CARACTERÍSTICAS:
  - Doble iteración (usuarios × funciones)
  - Requiere aprobación si >10 usuarios
  - Transacción atómica (todo o nada)
  - Duración: 3-10 minutos (depende de cantidad)
  - Auditoría por lote (no individual)

FLUJO ALTERNO ESPECÍFICO DE VARIANTE C:

FA-1: Requiere Aprobación de Auditor [BR-IACT-028]
  
  7a. Sistema detecta usuarios_afectados = 20 (>10)
  
  7b. Sistema identifica auditor del segmento
  
  7c. Sistema genera solicitud de aprobación:
      INSERT INTO approval_requests (
        request_id,
        request_type,
        grouper_id,
        function_ids,
        users_affected_count,
        requested_by_user_id,
        auditor_user_id,
        estado,
        expires_at,
        created_at
      ) VALUES (
        UUID(),
        'MASS_FUNCTION_ASSIGNMENT',
        ?,
        ?,
        20,
        ?,
        ?,
        'PENDING',
        NOW() + INTERVAL 48 HOUR,
        NOW()
      );
  
  7d. Sistema envía notificación a auditor:
      "Solicitud de aprobación: Asignar {count} funciones
       a {count_usuarios} usuarios del agrupador {nombre}
       
       Solicitante: {admin_nombre}
       Expira: {fecha + 48h}
       
       [Revisar y Aprobar] [Rechazar]"
  
  7e. Sistema envía confirmación a admin:
      "Su solicitud ha sido enviada al auditor {nombre}.
       Recibirá notificación cuando sea revisada.
       
       Solicitud expira en 48 horas."
  
  7f. Sistema registra auditoría
  
  7g. UC termina SIN ejecutar asignaciones
      (Continuará con UC-IACT-19: Aprobar Solicitud Masiva)
  
  Postcondición:
    - Solicitud PENDING creada
    - Auditor notificado
    - Admin notificado
    - Sin funciones asignadas aún

═════════════════════════════════════════════════════

TABLA COMPARATIVA DE VARIANTES:

┌─────────┬──────────┬──────────┬──────────────┬──────────┐
│Variante │Funciones │Usuarios  │BR Específicas│Duración  │
├─────────┼──────────┼──────────┼──────────────┼──────────┤
│ A       │ 1        │ 1        │ BR-087       │ 30s      │
│         │          │          │              │          │
│ B       │ N        │ 1        │ BR-087       │ 1-2 min  │
│         │          │          │ BR-060 (FA-5)│          │
│         │          │          │              │          │
│ C       │ N        │ M        │ BR-087       │ 3-10 min │
│         │          │          │ BR-028 (FA-1)│          │
│         │          │          │ BR-060       │          │
└─────────┴──────────┴──────────┴──────────────┴──────────┘

DECISIÓN DE DISEÑO:

¿Por qué 1 UC con 3 variantes en lugar de 3 UC separados?

Razones:
  ✓ Objetivo final idéntico (asignar funciones)
  ✓ Actor primario idéntico (AGR-007)
  ✓ Precondiciones casi iguales
  ✓ Pasos centrales compartidos (2-5, validaciones)
  ✓ Postcondiciones idénticas (funciones asignadas)
  ✓ Reutilización de código (misma lógica base)

Diferencias:
  - Entrada: Cantidad de funciones/usuarios
  - Pasos: Iteraciones añadidas
  - Validaciones: Algunas adicionales (BR-028)
  - Duración: Variable

Conclusión: Variantes dentro de un UC es mejor diseño

═══════════════════════════════════════════════════════════
```

---

## 8.5 Manejo de Concurrencia y Race Conditions

Algunos UC requieren manejo especial de concurrencia.

### Tipos de Problemas de Concurrencia

```
┌────────────────────────────────────────────────────┐
│    3 TIPOS DE PROBLEMAS DE CONCURRENCIA           │
├────────────────────────────────────────────────────┤
│                                                    │
│  TIPO 1: Lecturas Sucias (Dirty Read)              │
│    • UC lee dato mientras otro UC lo modifica      │
│    • Solución: Isolation level READ COMMITTED      │
│                                                    │
│  TIPO 2: Escrituras Perdidas (Lost Update)         │
│    • Dos UC modifican mismo registro concurrente   │
│    • Solución: Optimistic locking / versioning     │
│                                                    │
│  TIPO 3: Condiciones de Carrera (Race Condition)   │
│    • Resultado depende del timing entre UC         │
│    • Solución: Locks, semáforos, transacciones     │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: UC con Optimistic Locking

```
═══════════════════════════════════════════════════════════
UC-IACT-21: Modificar Datos de Usuario
═══════════════════════════════════════════════════════════

PROBLEMA DE CONCURRENCIA:

Escenario:
  T0: Admin A lee usuario (version=5)
  T1: Admin B lee usuario (version=5)
  T2: Admin A modifica nombre (version=6)
  T3: Admin B modifica email (¿version=6 o 7?)
  
  Sin control: Admin B sobrescribe cambio de Admin A (Lost Update)

SOLUCIÓN: Optimistic Locking con version field

ESQUEMA DE TABLA:

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  ...
  version INT NOT NULL DEFAULT 1,  -- ⭐ Campo de versión
  updated_at DATETIME,
  updated_by INT
);

FLUJO NORMAL CON VERSION:

1. Admin selecciona "Editar Usuario"

2. Sistema lee usuario CON version
   
   Query:
   SELECT user_id, nombre, email, ..., version
   FROM users
   WHERE user_id = ?;
   
   Resultado:
     user_id: 123
     nombre: "Juan Pérez"
     version: 5  ⭐ Almacenar en sesión

3. Sistema muestra formulario pre-poblado
   (Incluye <input type="hidden" name="version" value="5">)

4. Admin modifica campos (ej: email)

5. Admin confirma "Guardar"

6. Sistema intenta UPDATE con versión esperada
   
   Query:
   UPDATE users
   SET 
     nombre = ?,
     email = ?,
     version = version + 1,  -- Incrementar
     updated_at = NOW(),
     updated_by = ?
   WHERE user_id = ?
     AND version = ?;  -- ⭐ Validar versión esperada
   
   Parámetros:
     [nombre_nuevo], [email_nuevo], [admin_id], [user_id], [5]

7. Sistema verifica filas afectadas
   
   affected_rows = cursor.rowcount
   
   IF affected_rows == 0 THEN
     -- Version mismatch!
     Ir a FA-1: Conflicto de Concurrencia
   ELSIF affected_rows == 1 THEN
     -- Éxito
     Continuar paso 8
   END IF

8. Sistema muestra confirmación
   "Usuario actualizado exitosamente (versión 6)"

FLUJO ALTERNO CRÍTICO:

FA-1: Conflicto de Concurrencia (Version Mismatch)
  
  7a. Sistema detecta affected_rows = 0
      Significa: version en BD != version esperada
  
  7b. Sistema lee versión actual:
      SELECT version, nombre, email, updated_by, updated_at
      FROM users
      WHERE user_id = ?;
      
      Resultado:
        version: 6 (era 5 cuando Admin leyó)
        nombre: "Juan P. Martínez" (cambió!)
        updated_by: 456 (otro admin)
        updated_at: hace 2 minutos
  
  7c. Sistema identifica quién modificó:
      SELECT nombre FROM users WHERE user_id = 456;
      → "Admin B"
  
  7d. Sistema muestra mensaje detallado:
      ┌────────────────────────────────────────────┐
      │ ⚠️  CONFLICTO DE CONCURRENCIA               │
      ├────────────────────────────────────────────┤
      │ El usuario fue modificado por otro admin   │
      │ mientras usted editaba.                    │
      │                                            │
      │ Modificado por: Admin B                    │
      │ Hace: 2 minutos                            │
      │                                            │
      │ VALORES ACTUALES (Admin B):                │
      │   Nombre: "Juan P. Martínez"               │
      │   Email: juan@example.com                  │
      │                                            │
      │ SUS CAMBIOS (no guardados):                │
      │   Nombre: "Juan Pérez"                     │
      │   Email: juan.perez@newdomain.com          │
      │                                            │
      │ Opciones:                                  │
      │ [Recargar y Editar] - Descartar sus cambios│
      │ [Forzar Guardar] - Sobrescribir cambios de │
      │                    Admin B (requiere justif)│
      │ [Cancelar] - No guardar nada               │
      └────────────────────────────────────────────┘
  
  7e. Admin selecciona opción:
  
      Opción 1: Recargar y Editar
        → Recargar datos actuales (version=6)
        → Volver a paso 2 con datos frescos
        → Admin reaplica sus cambios manualmente
      
      Opción 2: Forzar Guardar
        7e.1: Sistema solicita justificación
        7e.2: Admin ingresa: "Corrección de email es crítica"
        7e.3: Sistema ejecuta UPDATE sin validar version:
              UPDATE users SET ... WHERE user_id = ?;
              (Sin cláusula AND version = ?)
        7e.4: Sistema registra override en audit_log:
              "Admin A sobrescribió cambios de Admin B por: {justif}"
        7e.5: Sistema notifica a Admin B:
              "Sus cambios en usuario {nombre} fueron sobrescritos
               por Admin A. Justificación: {justif}"
      
      Opción 3: Cancelar
        → UC termina sin guardar
        → Sin cambios en BD

Postcondición de FA-1:
  - Opción 1: Admin re-edita con datos frescos
  - Opción 2: Cambios forzados (con auditoría)
  - Opción 3: Sin cambios

PREVENCIÓN DE CONFLICTOS:

Estrategia 1: Mostrar "quién está editando"
  - Al abrir editor, marcar registro:
    UPDATE users SET locked_by = ?, locked_at = NOW()
    WHERE user_id = ?;
  
  - Al guardar o cancelar, liberar:
    UPDATE users SET locked_by = NULL, locked_at = NULL
    WHERE user_id = ?;
  
  - Si otro admin intenta editar:
    Sistema muestra: "Usuario siendo editado por {admin_nombre}"
    [Ver de todas formas] [Esperar] [Cancelar]

Estrategia 2: Locks con timeout
  - Lock automático expira después de 10 minutos
  - Sistema libera locks huérfanos cada minuto (job)

TESTING DE CONCURRENCIA:

Test 1: Modificación concurrente (version conflict)
  Thread 1: Lee usuario (version=5), espera 2s, guarda
  Thread 2: Lee usuario (version=5), guarda inmediato
  
  Esperado:
    - Thread 2 guarda exitoso (version→6)
    - Thread 1 detecta conflict (FA-1)

Test 2: Forzar guardado con justificación
  Simular conflict, elegir "Forzar Guardar"
  
  Esperado:
    - UPDATE sin version check ejecuta
    - Auditoría registra override
    - Admin B notificado

Test 3: Lock timeout
  Admin A abre editor, no guarda por 15 minutos
  Admin B intenta editar después de 11 minutos
  
  Esperado:
    - Lock expiró (timeout 10 min)
    - Admin B puede editar

═══════════════════════════════════════════════════════════
```

---

# SECCIÓN 9: VALIDACIÓN DE CASOS DE USO

## 9.1 Checklist de Calidad de UC (26 Puntos)

Un UC de calidad debe cumplir estos 26 criterios:

```
═══════════════════════════════════════════════════════════
CHECKLIST DE CALIDAD DE UC
═══════════════════════════════════════════════════════════

COMPLETITUD (8 puntos)
───────────────────────

☐ 1. ID único asignado (UC-MODULE-NN)
☐ 2. Nombre claro en formato Verbo + Objeto
☐ 3. Actor Primario identificado
☐ 4. Trigger específico documentado
☐ 5. Precondiciones completas (mínimo 2)
☐ 6. Flujo Normal con 5+ pasos
☐ 7. Al menos 2 Flujos Alternos
☐ 8. Postcondiciones definidas (éxito y fallo)

CLARIDAD (6 puntos)
───────────────────

☐ 9. Pasos numerados secuencialmente
☐ 10. Un paso = Una acción atómica
☐ 11. Sin ambigüedad en verbos ("Sistema valida" vs "Sistema verifica si")
☐ 12. Sin jerga técnica no explicada
☐ 13. Ejemplos concretos en pasos complejos
☐ 14. Puntos de desviación explícitos en FA

TRAZABILIDAD (4 puntos)
───────────────────────

☐ 15. BR origen identificadas (al menos 1)
☐ 16. Ubicación de BR en UC documentada (Paso N)
☐ 17. FR derivados listados (mínimo 3)
☐ 18. UC relacionados referenciados si existen

COMPLETITUD TÉCNICA (4 puntos)
──────────────────────────────

☐ 19. Queries SQL incluidos para pasos críticos
☐ 20. Validaciones con lógica explícita (IF-THEN)
☐ 21. Manejo de errores documentado (FA)
☐ 22. Consideraciones de performance si aplican

REVISIÓN DE NEGOCIO (4 puntos)
──────────────────────────────

☐ 23. Stakeholders identificados con intereses
☐ 24. Valor de negocio claro
☐ 25. Frecuencia de uso estimada
☐ 26. Prioridad asignada (Alta/Media/Baja)

═══════════════════════════════════════════════════════════

PUNTUACIÓN:
  26/26: Excelente ⭐⭐⭐⭐⭐
  22-25: Muy Bueno ⭐⭐⭐⭐
  18-21: Bueno ⭐⭐⭐
  14-17: Aceptable ⭐⭐
  <14: Requiere mejora ⭐

BLOQUEOS (UC no aprobado si falta):
  ❌ Punto 1 (Sin ID)
  ❌ Punto 3 (Sin Actor)
  ❌ Punto 6 (Sin Flujo Normal)
  ❌ Punto 15 (Sin BR origen)
```

### Aplicación del Checklist

```
EJEMPLO: Evaluación de UC-IACT-07

☑ 1. ID único: UC-IACT-07 ✅
☑ 2. Nombre: "Notificar Expiración Inminente de Sesión" ✅
☑ 3. Actor: Sistema (Scheduler) ✅
☑ 4. Trigger: Cada minuto (cron) ✅
☑ 5. Precondiciones: 8 listadas ✅
☑ 6. Flujo Normal: 11 pasos ✅
☑ 7. Flujos Alternos: 6 (FA-1 a FA-6) ✅
☑ 8. Postcondiciones: 24 (éxito + FA) ✅
───────────────────────────────────────
☑ 9. Pasos numerados: 1-11 consecutivos ✅
☑ 10. Acción atómica: Cada paso es claro ✅
☑ 11. Sin ambigüedad: "Sistema consulta" ✅
☑ 12. Sin jerga: Términos explicados ✅
☑ 13. Ejemplos: Query completo incluido ✅
☑ 14. Puntos desviación: "Paso 2a", "4b" ✅
───────────────────────────────────────
☑ 15. BR origen: BR-IACT-031 ✅
☑ 16. Ubicación BR: Paso 2 (query) ✅
☑ 17. FR derivados: FR-301 a FR-309 (9 FR) ✅
☑ 18. UC relacionados: UC-IACT-08 (expirar) ✅
───────────────────────────────────────
☑ 19. Queries: Paso 2 completo con índices ✅
☑ 20. Validaciones: EXISTS check en query ✅
☑ 21. Manejo errores: 6 FA documentados ✅
☑ 22. Performance: <100ms con índices ✅
───────────────────────────────────────
☑ 23. Stakeholders: 3 identificados ✅
☑ 24. Valor: Seguridad (sesiones zombie) ✅
☑ 25. Frecuencia: Continua (cada min) ✅
☑ 26. Prioridad: Alta ✅

RESULTADO: 26/26 ⭐⭐⭐⭐⭐ EXCELENTE

Sin bloqueos, aprobado para implementación.
```

---

## 9.2 Peer Review de UC

### Proceso de Revisión por Pares

```
┌────────────────────────────────────────────────────┐
│         PROCESO DE PEER REVIEW (5 FASES)          │
├────────────────────────────────────────────────────┤
│                                                    │
│  FASE 1: Auto-revisión del Autor                   │
│    • Completar checklist 26 puntos                 │
│    • Corregir fallos evidentes                     │
│    • Preparar documentación completa               │
│                                                    │
│  FASE 2: Revisión Técnica                          │
│    • Revisor: Ingeniero Senior/Arquitecto          │
│    • Enfoque: Completitud, trazabilidad, queries   │
│    • Duración: 30-45 minutos                       │
│                                                    │
│  FASE 3: Revisión de Negocio                       │
│    • Revisor: Analista de Negocio/Product Owner    │
│    • Enfoque: Flujos, validaciones, valor          │
│    • Duración: 20-30 minutos                       │
│                                                    │
│  FASE 4: Consolidación de Feedback                 │
│    • Autor consolida comentarios                   │
│    • Prioriza cambios (críticos primero)           │
│    • Actualiza UC                                  │
│                                                    │
│  FASE 5: Aprobación                                │
│    • Re-revisión si cambios mayores                │
│    • Aprobación final de ambos revisores           │
│    • UC marcado como "Aprobado"                    │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Template de Revisión

```markdown
# PEER REVIEW: UC-IACT-XX

**Revisor:** [Nombre]
**Rol:** [Técnico / Negocio]
**Fecha:** [YYYY-MM-DD]
**Versión UC:** [X.Y.Z]

## PUNTUACIÓN INICIAL

Checklist: [X/26] puntos

Bloqueos detectados:
- [ ] Ninguno
- [ ] Punto N: [Descripción]

## COMENTARIOS POR SECCIÓN

### Identificación
- [✓/✗/⚠] [Comentario]

### Actores
- [✓/✗/⚠] [Comentario]

### Precondiciones
- [✓/✗/⚠] [Comentario]

### Flujo Normal
Paso [N]: [Comentario específico]

### Flujos Alternos
FA-[N]: [Comentario específico]

### Postcondiciones
- [✓/✗/⚠] [Comentario]

### Trazabilidad
- [✓/✗/⚠] [Comentario]

## ISSUES IDENTIFICADOS

### Críticos (Bloquean aprobación)
1. [Descripción del issue]
   Sugerencia: [Cómo corregir]

### Mayores (Deben corregirse)
1. [Descripción]

### Menores (Mejoras sugeridas)
1. [Descripción]

## DECISIÓN

- [ ] APROBADO sin cambios
- [ ] APROBADO con cambios menores
- [ ] REQUIERE CAMBIOS MAYORES (re-revisión)
- [ ] RECHAZADO (reescritura completa)

## COMENTARIOS GENERALES

[Feedback adicional, fortalezas del UC, áreas de mejora]

---

**Firma:** [Revisor]
```

### Ejemplo de Review Real

```
═══════════════════════════════════════════════════════════
PEER REVIEW: UC-IACT-09
═══════════════════════════════════════════════════════════

Revisor: María González
Rol: Arquitecta de Software (Revisión Técnica)
Fecha: 2025-12-15
Versión UC: 1.0.0

PUNTUACIÓN INICIAL: 23/26

Bloqueos detectados:
- [✗] Ninguno

COMENTARIOS POR SECCIÓN
───────────────────────

Identificación: ✓
  ID, nombre, actores bien definidos

Precondiciones: ⚠
  Issue menor: Falta especificar timeout del job (30s o 60s?)

Flujo Normal: ✓
  Pasos claros y secuenciales. Query bien documentado.

Flujos Alternos: ⚠
  FA-3: Falta especificar qué pasa si MessageQueueFull persiste
        por 3+ horas. ¿Escalar a email? ¿Alarma crítica?

Postcondiciones: ✓
  Completas para éxito y fallos

Trazabilidad: ✓
  BR-IACT-033 bien documentada en Paso 2

ISSUES IDENTIFICADOS
────────────────────

CRÍTICOS: Ninguno

MAYORES:
1. FA-3: Agregar manejo de persistencia de error
   Sugerencia: "Si falla por 3 intentos consecutivos (3h):
                 - Generar alarma P1
                 - Notificar on-call
                 - Considerar fallback a email en dev"

2. Paso 2: Query podría ser lento sin índices correctos
   Sugerencia: Documentar índices requeridos:
               - user_sessions(estado, last_activity)
               - session_notifications(session_id, type, created_at)

MENORES:
1. Paso 4: "Determinar urgencia" es vago
   Sugerencia: Especificar fórmula:
               IF horas <= 6 THEN 'CRÍTICA'
               ELSIF horas <= 12 THEN 'ALTA'
               ELSE 'MEDIA'

2. FA-5: Timeout de 60s podría ser insuficiente si >500 permisos
   Sugerencia: Mencionar estrategia de escalamiento
               (particionar job o aumentar timeout)

DECISIÓN
────────

☑ APROBADO CON CAMBIOS MAYORES

Razón: UC bien estructurado pero requiere:
  - Completar FA-3 con estrategia de retry exhaustivo
  - Documentar índices en Paso 2

Una vez corregidos estos 2 puntos, aprobar sin re-revisión.

COMENTARIOS GENERALES
─────────────────────

Fortalezas:
  + Query muy bien documentado con todos los filtros
  + FA-2 (race condition) está muy bien pensado
  + Postcondiciones exhaustivas

Sugerencias adicionales:
  - Considerar agregar diagrama de flujo para Variante C
  - Tests de concurrencia deberían estar en sección de Testing

Excelente trabajo en general. Con las correcciones, será un
UC de referencia para el equipo.

Firma: María González, 2025-12-15

═══════════════════════════════════════════════════════════
```

---

## 9.3 Validación con Stakeholders

### Sesión de Walkthrough

```
┌────────────────────────────────────────────────────┐
│      SESIÓN DE WALKTHROUGH CON STAKEHOLDER        │
├────────────────────────────────────────────────────┤
│                                                    │
│  PREPARACIÓN (1 día antes):                        │
│    • Enviar UC completo a stakeholders             │
│    • Identificar secciones críticas a discutir     │
│    • Preparar preguntas específicas                │
│                                                    │
│  DURANTE SESIÓN (60-90 min):                       │
│    1. Introducción (5 min)                         │
│       - Objetivo del UC                            │
│       - Alcance de la revisión                     │
│                                                    │
│    2. Walkthrough Flujo Normal (30 min)            │
│       - Leer paso por paso                         │
│       - Stakeholder confirma/corrige               │
│       - Capturar dudas                             │
│                                                    │
│    3. Revisión Flujos Alternos (20 min)            │
│       - ¿Escenarios faltantes?                     │
│       - ¿Manejo de errores correcto?               │
│                                                    │
│    4. Validación de BR (15 min)                    │
│       - ¿BR aplicadas correctamente?               │
│       - ¿Falta alguna regla?                       │
│                                                    │
│    5. Cierre y Acciones (10 min)                   │
│       - Resumen de cambios acordados               │
│       - Asignación de responsables                 │
│       - Fecha próxima revisión                     │
│                                                    │
│  DESPUÉS (2 días):                                 │
│    • Actualizar UC con feedback                    │
│    • Enviar versión revisada                       │
│    • Obtener aprobación formal                     │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Script de Walkthrough

```
═══════════════════════════════════════════════════════════
SCRIPT DE WALKTHROUGH: UC-IACT-04
═══════════════════════════════════════════════════════════

Participantes:
  - Analista: Responsable del UC
  - Stakeholder 1: Admin de Acceso (usuario del sistema)
  - Stakeholder 2: Auditor (revisor de seguridad)

INTRODUCCIÓN (Analista):
─────────────────────────

"Buenos días. Hoy vamos a revisar el UC-IACT-04: Asignar 
Funciones a Usuario. Este UC describe cómo ustedes, como 
administradores de acceso, asignan funciones del catálogo 
a los usuarios finales.

El objetivo de esta sesión es:
  1. Validar que el flujo refleja su proceso actual
  2. Identificar escenarios faltantes
  3. Confirmar que las validaciones son correctas

¿Alguna pregunta antes de empezar?"

WALKTHROUGH FLUJO NORMAL (Analista lee, Stakeholder valida):
─────────────────────────────────────────────────────────────

Analista: "Paso 1: Admin selecciona 'Asignar Funciones'"

Stakeholder 1 (Admin): "Correcto. Desde el dashboard principal,
hay un botón 'Administrar Accesos' que abre el módulo."

Analista: [Anota: Paso 1 validado ✓]

───

Analista: "Paso 2: Sistema muestra catálogo de 44 funciones"

Stakeholder 1: "Sí, pero ¿el catálogo se muestra completo o
solo las funciones que yo tengo permiso de asignar?"

Analista: [Issue anotado] "Buena pregunta. En el UC actual,
mostramos todas las 44. ¿Debería filtrarse?"

Stakeholder 2 (Auditor): "Recomiendo filtrar. Un admin sin
nivel 3 no debería ni VER funciones críticas en el catálogo.
Evita confusión."

Analista: [Acción: Agregar filtro en Paso 2]
  "Actualizado: Sistema muestra solo funciones que admin
   puede asignar (excluye críticas si nivel < 3)"

───

Analista: "Paso 3: Admin selecciona usuario destino"

Stakeholder 1: "Correcto. Usamos un autocomplete por nombre
o email. ¿Está documentado?"

Analista: [Anota] "Agregaré detalle técnico: autocomplete
con búsqueda por nombre/email, mínimo 3 caracteres."

───

Analista: "Paso 4: Sistema verifica nivel_seguridad [BR-087]"

Stakeholder 2 (Auditor): "Esta validación es crítica. Confirmo
que es correcto: Solo nivel 3+ para funciones críticas."

Analista: [Validado ✓]

Stakeholder 1: "¿Qué pasa si intento asignar 5 funciones y
solo 2 son críticas? ¿Se deniegan todas o solo las 2?"

Analista: [Issue importante] "En el UC actual, se deniegan
todas. ¿Es correcto o deberíamos permitir las no críticas?"

Stakeholder 2: "Hmm, permitir parcialmente es más usable.
Pero debe ser MUY claro en el mensaje."

Analista: [Acción: Nuevo FA para asignación parcial]

───

[Continuar con pasos 5-12...]

REVISIÓN FLUJOS ALTERNOS:
──────────────────────────

Analista: "Tenemos 6 flujos alternos. ¿Falta algún escenario?"

Stakeholder 1: "¿Qué pasa si el usuario destino está INACTIVO?
¿Se puede asignar o se bloquea?"

Analista: [Escenario faltante ❗]

Stakeholder 2: "Recomiendo bloquear. No tiene sentido asignar
funciones a usuario inactivo."

Analista: [Acción: Agregar FA-7: Usuario Destino Inactivo]

───

Stakeholder 1: "Otro escenario: ¿Puedo asignar la misma función
que el usuario ya tiene? ¿Es error o idempotente?"

Analista: [Anota] "Actualmente es idempotente (ignora duplicado).
¿Es correcto?"

Stakeholder 1: "Sí, está bien. Pero mostrar mensaje:
'Usuario ya tiene esta función'"

Analista: [Acción: Agregar FA-8: Función Ya Asignada]

VALIDACIÓN DE BR:
─────────────────

Analista: "Tenemos 5 BR integradas. ¿Falta alguna regla?"

Stakeholder 2: "Hay una política nueva desde noviembre:
Si se asigna función de 'Auditoría', debe notificarse
al gerente de seguridad. ¿Está contemplado?"

Analista: [BR faltante ❗] "No está. ¿Es obligatorio?"

Stakeholder 2: "Sí, desde BR-IACT-095 (nueva)."

Analista: [Acción: Integrar BR-095 en UC]
  "Agregaré paso 9b: Si función es de categoría 'Auditoría',
   notificar a gerente de seguridad"

CIERRE:
───────

Analista: "Resumen de acciones:
  1. Filtrar catálogo por permisos de admin (Paso 2)
  2. Agregar autocomplete con 3+ chars (Paso 3)
  3. Permitir asignación parcial (nuevo FA-6b)
  4. Agregar FA-7: Usuario Inactivo
  5. Agregar FA-8: Función Ya Asignada
  6. Integrar BR-095: Notificar gerente si Auditoría

Plazo: Actualizaré UC en 2 días. Enviaré versión 1.1 para
       aprobación final.

¿Algo más?"

Stakeholder 1: "Perfecto, esperamos la actualización."

Stakeholder 2: "Una última cosa: ¿Los tests incluirán todos
estos FA nuevos?"

Analista: "Sí, cada FA tendrá al menos 1 test automatizado."

[Sesión concluida - 85 minutos]

═══════════════════════════════════════════════════════════
```

---

## 9.4 Consistencia Entre UC

### Tipos de Inconsistencias

```
┌────────────────────────────────────────────────────┐
│      5 TIPOS DE INCONSISTENCIAS ENTRE UC          │
├────────────────────────────────────────────────────┤
│                                                    │
│  TIPO 1: Nombres de Entidades Diferentes           │
│    UC-04: "usuario destino"                        │
│    UC-06: "usuario afectado"                       │
│    UC-18: "usuario objetivo"                       │
│    → SOLUCIÓN: Estandarizar a "usuario destino"    │
│                                                    │
│  TIPO 2: Validaciones Divergentes                  │
│    UC-04: Valida nivel_seguridad >= 3              │
│    UC-18: No valida nivel_seguridad                │
│    → SOLUCIÓN: Ambos deben validar (misma BR)      │
│                                                    │
│  TIPO 3: Precondiciones Contradictorias            │
│    UC-04: Requiere sesión activa                   │
│    UC-05: No menciona sesión                       │
│    → SOLUCIÓN: Todos los UC deben requerir sesión  │
│                                                    │
│  TIPO 4: Formato de Mensajes Diferente             │
│    UC-07: "Su sesión expirará en X minutos"        │
│    UC-09: "Permiso temporal vence en X horas"      │
│    → SOLUCIÓN: Template estándar de notificaciones │
│                                                    │
│  TIPO 5: Auditoría Incompleta                      │
│    UC-04: Registra en audit_log                    │
│    UC-06: No registra auditoría                    │
│    → SOLUCIÓN: Todos los UC críticos auditan       │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Matriz de Consistencia

```
═══════════════════════════════════════════════════════════
MATRIZ DE CONSISTENCIA: Módulo MOD_Access
═══════════════════════════════════════════════════════════

Verificación de 4 aspectos consistentes entre 3 UC:

┌──────┬─────────┬─────────┬──────────────┬─────────────┐
│ UC   │ Entidad │ BR-087  │ Auditoría    │ Sesión      │
│      │ Destino │ Validada│ Registrada   │ Requerida   │
├──────┼─────────┼─────────┼──────────────┼─────────────┤
│ 04   │ usuario │ ✓ Paso 4│ ✓ Paso 10    │ ✓ PRE-02    │
│      │ destino │         │              │             │
│      │         │         │              │             │
│ 06   │ usuario │ ✗ Falta │ ✓ Paso 8     │ ✓ PRE-01    │
│      │ destino │         │              │             │
│      │         │         │              │             │
│ 18   │ usuario │ ✗ Falta │ ✗ Falta      │ ✓ PRE-01    │
│      │ objetivo│  ⚠      │  ❌          │             │
│      │  ⚠      │         │              │             │
└──────┴─────────┴─────────┴──────────────┴─────────────┘

ISSUES DETECTADOS:

Issue 1: Terminología inconsistente
  UC-18 usa "usuario objetivo" vs "usuario destino"
  
  Impacto: Confusión en documentación
  Acción: Actualizar UC-18 a "usuario destino"
  Responsable: Analista B
  Plazo: 2 días

Issue 2: BR-087 no validada en UC-06 y UC-18
  UC-06 revoca funciones (¿validar nivel también?)
  UC-18 consulta historial (no aplica, solo lectura)
  
  Análisis:
    UC-06: NO requiere validación (revocar es menos restrictivo)
    UC-18: NO requiere validación (solo consulta)
  
  Acción: Documentar excepción en UC-06 y UC-18
          "BR-087 no aplica a revocación/consulta"
  Responsable: Analista A
  Plazo: 1 día

Issue 3: UC-18 sin auditoría ❌
  Consultas también deben auditarse (análisis forense)
  
  Impacto: Gap de seguridad
  Acción: Agregar Paso 8 en UC-18: Registrar auditoría
  Responsable: Analista B
  Plazo: 3 días (requiere pruebas)

RESUMEN:
  Issues detectados: 3
  Críticos (bloquean): 1 (Issue 3)
  Mayores: 1 (Issue 1)
  Menores: 1 (Issue 2)

═══════════════════════════════════════════════════════════
```

### Checklist de Consistencia

```markdown
## CHECKLIST DE CONSISTENCIA ENTRE UC

Proyecto: IACT
Módulo: [Nombre del módulo]
UC Revisados: [Lista de IDs]

### TERMINOLOGÍA
- [ ] Nombres de entidades consistentes
- [ ] Verbos estándar (consultar, crear, actualizar, eliminar)
- [ ] Términos técnicos usados uniformemente

### PRECONDICIONES ESTÁNDAR
- [ ] Todos requieren autenticación (salvo públicos)
- [ ] Todos requieren sesión activa
- [ ] Permisos documentados consistentemente

### VALIDACIONES DE BR
- [ ] Misma BR validada igual en todos los UC
- [ ] Punto de validación consistente (mismo paso relativo)
- [ ] Mensaje de error similar

### AUDITORÍA
- [ ] UC críticos registran en audit_log
- [ ] Formato de auditoría consistente
- [ ] Metadata JSON con campos estándar

### MANEJO DE ERRORES
- [ ] Flujos Alternos numerados consistentemente
- [ ] Mensajes de error siguen template
- [ ] Estrategias de recovery similares

### FORMATO DE DOCUMENTACIÓN
- [ ] Estructura de secciones igual
- [ ] Nivel de detalle similar
- [ ] Queries SQL formateados igual

**Revisado por:** [Nombre]
**Fecha:** [YYYY-MM-DD]
**Issues encontrados:** [Cantidad]
```

---

# SECCIÓN 10: MÉTRICAS Y COMPLETITUD

## 10.1 Métricas de Calidad de Documentación

### 7 Métricas Clave

```
┌────────────────────────────────────────────────────┐
│         7 MÉTRICAS DE CALIDAD DE UC                │
├────────────────────────────────────────────────────┤
│                                                    │
│  M1: Cobertura de BR                               │
│      = (BR cubiertas / Total BR) × 100%            │
│      Target: >90%                                  │
│                                                    │
│  M2: Profundidad de Documentación                  │
│      = Promedio(Pasos por UC, FA por UC)          │
│      Target: >8 pasos, >3 FA                       │
│                                                    │
│  M3: Trazabilidad Completa                         │
│      = (UC con BR→FR / Total UC) × 100%            │
│      Target: 100%                                  │
│                                                    │
│  M4: Consistencia Terminológica                    │
│      = 1 - (Términos duplicados / Total términos)  │
│      Target: >95%                                  │
│                                                    │
│  M5: Cobertura de Escenarios                       │
│      = (FA documentados / FA identificados) × 100% │
│      Target: 100%                                  │
│                                                    │
│  M6: Claridad (Legibilidad)                        │
│      = Flesch Reading Score                        │
│      Target: 60-70 (Standard)                      │
│                                                    │
│  M7: Actualización                                 │
│      = Días desde última revisión                  │
│      Target: <90 días                              │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Cálculo de Métricas

```
═══════════════════════════════════════════════════════════
MÉTRICAS DEL PROYECTO IACT (Módulo MOD_Access)
═══════════════════════════════════════════════════════════

DATOS:
  BR totales en PARTE 1: 45
  UC documentados: 22
  UC en MOD_Access: 8

M1: COBERTURA DE BR
───────────────────

BR cubiertas: 40
Total BR: 45
BR no cubiertas: 5 (todos son Hechos, OK)

Cobertura = 40/45 × 100% = 88.9%

Status: ⚠ Cerca del target (90%)
Acción: Revisar si las 5 BR Hechos requieren UC

M2: PROFUNDIDAD DE DOCUMENTACIÓN
─────────────────────────────────

UC-IACT-04: 12 pasos, 6 FA
UC-IACT-06: 9 pasos, 4 FA
UC-IACT-07: 11 pasos, 6 FA
UC-IACT-09: 11 pasos, 6 FA
UC-IACT-15: 10 pasos, 5 FA
UC-IACT-18: 7 pasos, 3 FA
UC-IACT-19: 8 pasos, 3 FA
UC-IACT-21: 9 pasos, 4 FA

Promedio pasos: (12+9+11+11+10+7+8+9)/8 = 9.6 pasos
Promedio FA: (6+4+6+6+5+3+3+4)/8 = 4.6 FA

Status: ✅ Ambos > target (8 pasos, 3 FA)
Calidad: Alta

M3: TRAZABILIDAD COMPLETA
─────────────────────────

UC con BR→FR documentado: 8
Total UC: 8

Trazabilidad = 8/8 × 100% = 100%

Status: ✅ Perfecto
Cada UC tiene BR origen y FR derivados

M4: CONSISTENCIA TERMINOLÓGICA
──────────────────────────────

Análisis de términos clave:
  - "usuario destino": 8/8 UC ✅
  - "nivel_seguridad": 8/8 UC ✅
  - "funciones críticas": 6/8 UC (2 no aplican) ✅
  - "audit_log": 8/8 UC ✅

Términos duplicados detectados: 0
Total términos clave: 50

Consistencia = 1 - 0/50 = 100%

Status: ✅ Excelente consistencia

M5: COBERTURA DE ESCENARIOS
────────────────────────────

Total FA identificados en sesiones: 42
Total FA documentados: 38

Cobertura = 38/42 × 100% = 90.5%

Status: ✅ Buena cobertura
Gap: 4 FA faltantes (menores identificados en reviews)

M6: CLARIDAD (Flesch Reading Score)
────────────────────────────────────

Análisis de UC-IACT-04 (muestra):
  - Total palabras: 3,200
  - Total oraciones: 240
  - Palabras por oración: 13.3
  - Sílabas por palabra: 1.8

Flesch Score = 206.835 - 1.015×(13.3) - 84.6×(1.8)
             = 206.835 - 13.5 - 152.3
             = 41.0

Status: ⚠ Bajo (target 60-70)
Razón: Terminología técnica, queries SQL
Acción: No crítico para doc técnica

M7: ACTUALIZACIÓN
─────────────────

UC-IACT-04: Última revisión hace 15 días
UC-IACT-06: Última revisión hace 20 días
UC-IACT-07: Última revisión hace 10 días
UC-IACT-09: Última revisión hace 5 días
UC-IACT-15: Última revisión hace 45 días
UC-IACT-18: Última revisión hace 60 días ⚠
UC-IACT-19: Última revisión hace 30 días
UC-IACT-21: Última revisión hace 25 días

Promedio: 26.3 días

Status: ✅ Todos < 90 días
UC-IACT-18: Programar revisión

RESUMEN DE MÉTRICAS:
────────────────────

M1: 88.9% (Cobertura BR)          ⚠ Cerca
M2: 9.6 pasos, 4.6 FA             ✅ Excelente
M3: 100% (Trazabilidad)           ✅ Perfecto
M4: 100% (Consistencia)           ✅ Perfecto
M5: 90.5% (Escenarios)            ✅ Bueno
M6: 41.0 (Claridad)               ⚠ Técnico
M7: 26.3 días (Actualización)     ✅ Reciente

SCORE GLOBAL: 6/7 métricas cumplidas = 85.7%

Status General: ✅ BUENO (target: >80%)

Acciones:
  1. Revisar 5 BR sin UC (M1)
  2. Simplificar redacción donde posible (M6)
  3. Programar revisión de UC-IACT-18 (M7)

═══════════════════════════════════════════════════════════
```

---

## 10.2 Indicadores de Completitud

### Dashboard de Completitud

```
═══════════════════════════════════════════════════════════
DASHBOARD DE COMPLETITUD - PROYECTO IACT
═══════════════════════════════════════════════════════════

FASE 1: BUSINESS RULES
──────────────────────
┌─────────────────────────────────────┐
│ BR Identificadas:  45/45  [██████] │ 100%
│ BR Clasificadas:   45/45  [██████] │ 100%
│ BR Documentadas:   45/45  [██████] │ 100%
│ BR Aprobadas:      42/45  [█████░] │  93%
└─────────────────────────────────────┘
Status: ✅ COMPLETO (3 BR pendientes aprobación)

FASE 2: CASOS DE USO
────────────────────
┌─────────────────────────────────────┐
│ UC Identificados:  22/24  [█████░] │  92%
│ UC Documentados:   22/22  [██████] │ 100%
│ UC Revisados:      20/22  [█████░] │  91%
│ UC Aprobados:      18/22  [████░░] │  82%
└─────────────────────────────────────┘
Status: ⚠ EN PROGRESO
  Faltantes: 2 UC técnicos (CRUD)
  Pendientes revisión: UC-18, UC-19
  Pendientes aprobación: UC-04, UC-06, UC-18, UC-19

FASE 3: FUNCTIONAL REQUIREMENTS
────────────────────────────────
┌─────────────────────────────────────┐
│ FR Derivados:     156/156 [██████] │ 100%
│ FR Documentados:  120/156 [████░░] │  77%
│ FR Implementados:  85/156 [███░░░] │  54%
│ FR Testeados:      78/156 [███░░░] │  50%
└─────────────────────────────────────┘
Status: ⚠ EN PROGRESO
  Gap: 36 FR sin documentar completa
  Gap: 71 FR sin implementar
  Gap: 78 FR sin tests

TRAZABILIDAD
────────────
┌─────────────────────────────────────┐
│ BR → UC:          40/40   [██████] │ 100%
│ UC → FR:         156/156  [██████] │ 100%
│ FR → Código:      85/156  [███░░░] │  54%
│ Código → Tests:   78/85   [█████░] │  92%
└─────────────────────────────────────┘
Status: ⚠ PARCIAL
  Cadena completa: 50% (78/156 FR)

COBERTURA POR MÓDULO
────────────────────
┌──────────────┬──────┬──────┬───────────────┐
│ Módulo       │  UC  │  FR  │ Implementación│
├──────────────┼──────┼──────┼───────────────┤
│ MOD_Access   │ 8/8  │62/62 │   45/62 (73%) │
│ MOD_Session  │ 4/4  │28/28 │   28/28 (100%)│
│ MOD_Function │ 3/3  │20/20 │   12/20 (60%) │
│ MOD_Audit    │ 2/3  │18/18 │    0/18 (0%)  │
│ MOD_Temp     │ 3/4  │22/22 │    0/22 (0%)  │
│ MOD_Report   │ 2/2  │ 6/6  │    0/6  (0%)  │
└──────────────┴──────┴──────┴───────────────┘
Status: ⚠ Desbalanceado
  MOD_Session: Completo ✅
  MOD_Audit, MOD_Temp, MOD_Report: Sin implementar ❌

VELOCIDAD
─────────
┌─────────────────────────────────────┐
│ UC/semana:        2.5 UC             │
│ FR/semana:       15.6 FR             │
│ Implementación:   8.5 FR/semana      │
│ Tests:            7.8 FR/semana      │
└─────────────────────────────────────┘

PROYECCIÓN
──────────
┌─────────────────────────────────────┐
│ Semanas restantes (UC):      1 sem  │
│ Semanas restantes (FR doc):  3 sem  │
│ Semanas restantes (Impl):    9 sem  │
│ Semanas restantes (Tests):  10 sem  │
└─────────────────────────────────────┘

Fecha estimada de completitud: 2026-03-15 (10 semanas)

ALERTAS
───────
⚠ MOD_Audit sin implementación (100% sin código)
⚠ Velocidad de tests por debajo de implementación
⚠ 4 UC pendientes de aprobación desde hace >2 semanas

ACCIONES RECOMENDADAS
──────────────────────
1. Priorizar aprobación de UC pendientes (UC-04, UC-06, UC-18, UC-19)
2. Iniciar implementación de MOD_Audit (18 FR)
3. Acelerar escritura de tests (contratar QA adicional?)
4. Documentar 36 FR faltantes (1 semana dedicada)

═══════════════════════════════════════════════════════════
```

---

## 10.3 Análisis de Gaps

### Metodología de Identificación de Gaps

```
┌────────────────────────────────────────────────────┐
│          METODOLOGÍA DE ANÁLISIS DE GAPS          │
├────────────────────────────────────────────────────┤
│                                                    │
│  PASO 1: Identificar Expectativa                   │
│    ¿Qué DEBERÍA estar documentado/implementado?    │
│                                                    │
│  PASO 2: Medir Estado Actual                       │
│    ¿Qué ESTÁ documentado/implementado?             │
│                                                    │
│  PASO 3: Calcular Gap                              │
│    Gap = Expectativa - Estado Actual               │
│                                                    │
│  PASO 4: Clasificar Severidad                      │
│    • Crítico: Bloquea release                      │
│    • Alto: Riesgo de calidad                       │
│    • Medio: Mejora recomendada                     │
│    • Bajo: Nice to have                            │
│                                                    │
│  PASO 5: Priorizar y Planificar                    │
│    • Críticos: Inmediato                           │
│    • Altos: Esta iteración                         │
│    • Medios: Próxima iteración                     │
│    • Bajos: Backlog                                │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo de Análisis de Gap

```
═══════════════════════════════════════════════════════════
ANÁLISIS DE GAPS: IACT MOD_Audit
═══════════════════════════════════════════════════════════

EXPECTATIVA (Definida en arquitectura):
───────────────────────────────────────

MOD_Audit debe incluir:
  ✓ UC-IACT-22: Consultar Log de Auditoría
  ✓ UC-IACT-23: Generar Reporte de Auditoría
  ✓ UC-IACT-24: Exportar Logs a CSV
  
  18 FR derivados:
    - FR-2201 a FR-2206 (Consultar log)
    - FR-2301 a FR-2308 (Generar reporte)
    - FR-2401 a FR-2404 (Exportar CSV)

ESTADO ACTUAL:
──────────────

UC documentados:
  ✓ UC-IACT-22: Completo (aprobado)
  ✓ UC-IACT-23: Completo (revisión pendiente)
  ✗ UC-IACT-24: Faltante

FR documentados: 18/18 ✓
FR implementados: 0/18 ✗
FR testeados: 0/18 ✗

GAPS IDENTIFICADOS:
───────────────────

GAP-1: UC-IACT-24 Sin Documentar
  Severidad: ❌ CRÍTICO
  Impacto: Funcionalidad prometida a cliente
  Descripción: Exportar logs a CSV es requisito contractual
  Responsable: Analista B
  Plazo: 3 días
  Bloqueador: Sí (bloquea release 2.0)

GAP-2: MOD_Audit Sin Implementación
  Severidad: ❌ CRÍTICO
  Impacto: Módulo completo faltante
  Descripción: 0 de 18 FR implementados
  Causa raíz: Priorización incorrecta (se priorizó MOD_Session)
  Responsable: Dev Team Lead
  Estimación: 4 semanas (18 FR × 1.5 días/FR)
  Bloqueador: Sí (bloquea release 2.0)

GAP-3: UC-IACT-23 Sin Aprobación
  Severidad: ⚠ ALTO
  Impacto: Puede requerir cambios en implementación
  Descripción: Pendiente revisión de stakeholder
  Responsable: Product Owner
  Plazo: 1 semana
  Bloqueador: No (pero riesgoso)

GAP-4: Sin Tests Automatizados
  Severidad: ⚠ ALTO
  Impacto: Sin cobertura de QA
  Descripción: 0 tests para 18 FR
  Responsable: QA Lead
  Estimación: 3 semanas (paralelo a implementación)
  Bloqueador: Depende de GAP-2

PLAN DE CIERRE:
───────────────

Semana 1:
  [GAP-1] Documentar UC-IACT-24 (3 días)
  [GAP-3] Obtener aprobación UC-IACT-23 (5 días)

Semana 2-5:
  [GAP-2] Implementar 18 FR (4 semanas)
    - Semana 2: FR-2201 a FR-2206 (consultar)
    - Semana 3: FR-2301 a FR-2305 (reporte parte 1)
    - Semana 4: FR-2306 a FR-2308 (reporte parte 2)
    - Semana 5: FR-2401 a FR-2404 (exportar)

Semana 3-6:
  [GAP-4] Escribir 18 tests (3 semanas, paralelo)
    - Semana 3: Tests para FR-2201 a FR-2206
    - Semana 4: Tests para FR-2301 a FR-2305
    - Semana 5: Tests para FR-2306 a FR-2308
    - Semana 6: Tests para FR-2401 a FR-2404

FECHA CIERRE PROYECTADA: 2026-02-10 (6 semanas)

RIESGOS:
────────

Riesgo 1: Desarrolladores no disponibles
  Probabilidad: Media
  Impacto: Alto (retraso 2+ semanas)
  Mitigación: Reasignar dev de MOD_Session (ya completo)

Riesgo 2: Requerimientos cambian durante implementación
  Probabilidad: Baja (UC aprobado)
  Impacto: Alto (reescritura de código)
  Mitigación: Aprobar UC-IACT-23 ANTES de empezar GAP-2

Riesgo 3: Tests descubren bugs mayores
  Probabilidad: Media
  Impacto: Medio (1 semana adicional de fixes)
  Mitigación: Code reviews exhaustivos durante implementación

═══════════════════════════════════════════════════════════
```

---

# SECCIÓN 11: EJERCICIOS PRÁCTICOS

## 11.1 Ejercicio 1: Construir UC desde BR

### Enunciado

**BR-IACT-070 (DESENCADENADOR):**

```
"SI un usuario no ha iniciado sesión en los últimos 60 días
 Y el usuario tiene estado 'ACTIVO'
 ENTONCES el sistema envía notificación al usuario Y al administrador
 para confirmar si el usuario sigue requiriendo acceso.
 Si no hay respuesta en 15 días, marcar usuario como 'INACTIVO'."

Tipo: Desencadenador
Fuente: Política de Accesos + CNST-009
Criticidad: Media
Vigencia: Desde 2025-12-01
Frecuencia: Verificación semanal (domingos 02:00 AM)
```

**TAREA:** Construir UC completo usando proceso de 7 pasos.

### Solución Ejercicio 1

```
═══════════════════════════════════════════════════════════
SOLUCIÓN EJERCICIO 1: UC-IACT-25
═══════════════════════════════════════════════════════════

PASO 1: Identificar BR Desencadenador
──────────────────────────────────────

BR-IACT-070: ✅ Es Desencadenador

Verificación:
  ✓ Estructura IF-THEN: Sí
  ✓ Condición temporal: Sí (60 días sin login)
  ✓ Acción observable: Sí (envía notificaciones)
  ✓ Alguien recibe: Sí (usuario Y admin)

Conclusión: Genera UC completo

PASO 2: Identificar Actor Primario
───────────────────────────────────

Pregunta 1: ¿Quién quiere que esto ocurra?
  → Sistema (mantener usuarios activos actualizados)

Pregunta 2: ¿Cuándo se ejecuta?
  → Automático, domingos 02:00 AM

Pregunta 3: ¿Quién se beneficia?
  → Administrador (base de usuarios limpia)
  → Usuario (no perder acceso injustamente)

Actor Primario: Sistema (Scheduler)
Actores Secundarios: Usuario, Administrador

PASO 3: Definir Objetivo
─────────────────────────

Opciones:
  A) "Notificar Usuarios Inactivos"
  B) "Verificar Usuarios Sin Actividad"
  C) "Confirmar Vigencia de Acceso de Usuarios Inactivos"

Elegido: C (más específico)

UC-IACT-25: Confirmar Vigencia de Acceso de Usuarios Inactivos

PASO 4: Construir Precondiciones
─────────────────────────────────

PRE-01: Scheduler configurado (domingos 02:00 AM)
PRE-02: Tabla users con campo last_login
PRE-03: InternalMessageService disponible
PRE-04: Tabla inactivity_confirmations existe
PRE-05: Política vigente desde 2025-12-01

PASO 5: Construir Flujo Normal
───────────────────────────────

1. Sistema inicia job (domingos 02:00 AM)

2. Sistema consulta usuarios inactivos [BR-IACT-070]
   
   Query:
   SELECT user_id, nombre, email, last_login,
          DATEDIFF(NOW(), last_login) as dias_inactivo
   FROM users
   WHERE estado = 'ACTIVO'
     AND last_login < DATE_SUB(NOW(), INTERVAL 60 DAY)
     AND NOT EXISTS (
       SELECT 1 FROM inactivity_confirmations ic
       WHERE ic.user_id = users.user_id
         AND ic.estado IN ('PENDING', 'CONFIRMED')
         AND ic.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
     );

3. Sistema itera sobre cada usuario

4. Sistema genera solicitud de confirmación
   
   INSERT INTO inactivity_confirmations (
     confirmation_id,
     user_id,
     dias_inactivo,
     estado,
     expires_at,
     created_at
   ) VALUES (
     UUID(),
     ?,
     ?,
     'PENDING',
     NOW() + INTERVAL 15 DAY,
     NOW()
   );

5. Sistema compone mensaje para USUARIO
   
   Template:
   ───────────────────────────────────────
   Confirmación de Acceso Requerida
   ───────────────────────────────────────
   
   Estimado/a {nombre},
   
   No hemos registrado actividad en su cuenta
   en los últimos {dias} días.
   
   Para mantener su acceso activo, por favor
   confirme que aún requiere usar el sistema.
   
   [Confirmar que Sigo Usando el Sistema]
   
   Si no confirma en los próximos 15 días,
   su cuenta será marcada como INACTIVA.
   
   Última sesión: {last_login}
   ───────────────────────────────────────

6. Sistema envía mensaje a buzón interno del usuario

7. Sistema compone mensaje para ADMINISTRADOR
   
   Template:
   ───────────────────────────────────────
   Usuario Inactivo: Confirmación Enviada
   ───────────────────────────────────────
   
   Usuario: {nombre} ({email})
   Días inactivo: {dias}
   
   Se envió solicitud de confirmación.
   Expira: {fecha + 15 días}
   
   [Ver Usuario] [Marcar Inactivo Ahora]
   ───────────────────────────────────────

8. Sistema envía mensaje a admin que asignó permisos

9. Sistema registra auditoría

10. Sistema continúa con siguiente usuario

11. Sistema finaliza job

PASO 6: Construir Flujos Alternos
──────────────────────────────────

FA-1: Sin Usuarios Inactivos
  2a. Query retorna 0 filas
  2b. Log: "No hay usuarios con >60 días inactividad"
  2c. UC termina

FA-2: Usuario Responde Confirmación
  (Ocurre FUERA del UC, via botón)
  → Actualizar inactivity_confirmations.estado = 'CONFIRMED'
  → Notificar admin

FA-3: Confirmación Expira Sin Respuesta (15 días)
  (Manejado por UC-IACT-26: Procesar Confirmaciones Expiradas)
  → Marcar usuario como INACTIVO
  → Revocar todos los permisos
  → Notificar admin

FA-4: Error al Enviar Mensaje
  6a. InternalMessageService falla
  6b. Registrar error en error_log
  6c. Mantener confirmation_id en estado PENDING
  6d. Reintentar en próxima ejecución (7 días)

PASO 7: Definir Postcondiciones
────────────────────────────────

De Éxito:
  - Solicitudes de confirmación creadas (PENDING)
  - Usuarios notificados
  - Administradores notificados
  - Auditoría registrada
  - Timer de 15 días iniciado

De Fallo:
  - Errores registrados
  - Solicitudes pendientes para retry

═══════════════════════════════════════════════════════════
```

---

## 11.2 Ejercicio 2: Integrar Múltiples BR

### Enunciado

Tienes UC-IACT-04 (Asignar Funciones) existente. 

Nuevas BR a integrar:

```
BR-IACT-099 (RESTRICCIÓN):
"No se pueden asignar más de 15 funciones a un usuario regular
 (solo superusuarios pueden tener >15)."

BR-IACT-105 (CÁLCULO):
"El indicador de cobertura funcional se calcula como:
 cobertura = (funciones_asignadas / funciones_en_grouper) × 100
 Mostrar warning si cobertura < 50%"
```

**TAREA:** Integrar ambas BR en UC-IACT-04.

### Solución Ejercicio 2

```
═══════════════════════════════════════════════════════════
SOLUCIÓN EJERCICIO 2
═══════════════════════════════════════════════════════════

ANÁLISIS DE INTEGRACIÓN:
────────────────────────

BR-IACT-099 (RESTRICCIÓN):
  Tipo: Validación de cantidad
  Ubicación en UC: Paso 5.5 (después de selección, antes de guardar)
  Genera FA: FA-7: Límite de Funciones Excedido

BR-IACT-105 (CÁLCULO):
  Tipo: Indicador informativo
  Ubicación en UC: Paso 6.5 (después de score riesgo)
  No genera FA (es warning, no error)

INTEGRACIÓN EN UC-IACT-04:
──────────────────────────

[... Pasos 1-5 sin cambios ...]

5.5. Sistema valida límite de funciones [BR-IACT-099]
     
     funciones_actuales = COUNT(user_functions WHERE user_id = ?)
     funciones_nuevas = COUNT(funciones_seleccionadas)
     total_proyectado = funciones_actuales + funciones_nuevas
     
     es_superusuario = user.groupers.contains('superusuario')
     
     IF total_proyectado > 15 AND NOT es_superusuario THEN
       Ir a FA-7: Límite de Funciones Excedido
     END IF

[... Paso 6 (score riesgo) sin cambios ...]

6.5. Sistema calcula cobertura funcional [BR-IACT-105]
     
     IF usuario tiene grouper THEN
       grouper_funciones = COUNT(functions IN grouper)
       usuario_funciones = funciones_actuales + funciones_nuevas
       
       cobertura = (usuario_funciones / grouper_funciones) × 100
       
       Sistema muestra indicador:
         "Cobertura funcional: {cobertura}%
          ({usuario_funciones}/{grouper_funciones} funciones)"
       
       IF cobertura < 50 THEN
         Sistema muestra warning:
           "⚠ Cobertura baja. Usuario tiene menos del 50%
              de funciones esperadas para su rol."
       END IF
     END IF

[... Pasos 7-12 sin cambios ...]

NUEVO FLUJO ALTERNO:
────────────────────

FA-7: Límite de Funciones Excedido [BR-IACT-099]
  
  5.5a. Sistema detecta total_proyectado = 18 (>15)
  
  5.5b. Usuario NO es superusuario
  
  5.5c. Sistema calcula cuántas puede asignar:
        permitidas = 15 - funciones_actuales
        excedentes = funciones_nuevas - permitidas
  
  5.5d. Sistema muestra mensaje:
        "Límite Alcanzado
         
         El usuario tiene actualmente {funciones_actuales} funciones.
         Intentó asignar {funciones_nuevas} adicionales.
         Total proyectado: {total_proyectado}
         
         ❌ Los usuarios regulares tienen límite de 15 funciones.
         
         Opciones:
         • Asignar solo {permitidas} funciones (hasta el límite)
         • Revocar funciones existentes primero
         • Convertir usuario a superusuario (requiere aprobación)
         
         [Asignar Parcialmente] [Ir a Revocar] [Cancelar]"
  
  5.5e. Admin selecciona opción:
        
        Opción 1: Asignar Parcialmente
          → Admin selecciona cuáles {permitidas} funciones asignar
          → Continuar paso 6 con subset
        
        Opción 2: Ir a Revocar
          → Abrir UC-IACT-06 en ventana modal
          → Al terminar, volver a UC-IACT-04 paso 3
        
        Opción 3: Cancelar
          → UC termina sin asignar

FR DERIVADOS:
─────────────

De BR-IACT-099:
  FR-4991: Contar Funciones Actuales del Usuario
  FR-4992: Validar Límite de 15 Funciones
  FR-4993: Verificar Si Usuario Es Superusuario
  FR-4994: Calcular Funciones Permitidas Restantes

De BR-IACT-105:
  FR-1051: Obtener Funciones del Grouper del Usuario
  FR-1052: Calcular Cobertura Funcional
  FR-1053: Mostrar Indicador de Cobertura
  FR-1054: Generar Warning Si Cobertura <50%

ACTUALIZACIÓN DE MATRIZ DE TRAZABILIDAD:
─────────────────────────────────────────

UC-IACT-04 ahora integra 7 BR:
  - BR-012 (Hecho)
  - BR-087 (Restricción)
  - BR-028 (Restricción)
  - BR-060 (Cálculo)
  - BR-046 (Inferencia)
  - BR-099 (Restricción) ⭐ Nueva
  - BR-105 (Cálculo) ⭐ Nueva

Total FR: 15 + 8 = 23 FR

═══════════════════════════════════════════════════════════
```

---

## 11.3 Ejercicio 3: Derivar FR

### Enunciado

Del UC-IACT-25 (Ejercicio 1), derivar los FR completos para:

**Paso 2:** Sistema consulta usuarios inactivos

**TAREA:** Documentar FR-2501 con los 10 componentes completos.

### Solución Ejercicio 3

```
═══════════════════════════════════════════════════════════
FR-2501: Consultar Usuarios Inactivos para Confirmación
═══════════════════════════════════════════════════════════

1. IDENTIFICACIÓN
─────────────────

ID: FR-2501
Módulo: MOD_User
Tipo: Query / Data Retrieval
Prioridad: Media
Complejidad: Media
Versión: 1.0.0

2. DESCRIPCIÓN BREVE
────────────────────

El sistema debe consultar usuarios que:
  - Están en estado ACTIVO
  - No han iniciado sesión en >60 días
  - No tienen solicitud de confirmación reciente (<7 días)

Esta consulta se ejecuta semanalmente (domingos 02:00 AM)
como parte de UC-IACT-25.

3. DERIVACIÓN Y TRAZABILIDAD
─────────────────────────────

Derivado de:
  - UC-IACT-25 Paso 2
  - BR-IACT-070: Condición de 60 días sin login

Relacionado con:
  - FR-2502: Generar Solicitud de Confirmación
  - FR-305: Marcar Usuario Inactivo (si no confirma)

4. PRIORIDAD Y COMPLEJIDAD
──────────────────────────

Prioridad: Media
  Justificación: No crítico (proceso semanal)
  
Complejidad: Media
  - Query con múltiples condiciones
  - Cálculo de DATEDIFF
  - Subconsulta EXISTS

5. INPUTS
─────────

Ninguno (query global)
  - Parámetro implícito: NOW() como referencia temporal

6. OUTPUTS
──────────

Lista de objetos InactiveUser:
  - user_id: INT
  - nombre: VARCHAR(100)
  - email: VARCHAR(100)
  - last_login: DATETIME
  - dias_inactivo: INT (calculado)

Cantidad esperada: 5-30 usuarios semanalmente

7. ALGORITMO / QUERY
────────────────────

Query SQL:

SELECT 
  u.user_id,
  u.nombre,
  u.email,
  u.last_login,
  DATEDIFF(NOW(), u.last_login) as dias_inactivo
FROM users u
WHERE u.estado = 'ACTIVO'
  AND u.last_login < DATE_SUB(NOW(), INTERVAL 60 DAY)
  AND NOT EXISTS (
    SELECT 1 
    FROM inactivity_confirmations ic
    WHERE ic.user_id = u.user_id
      AND ic.estado IN ('PENDING', 'CONFIRMED')
      AND ic.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
  )
ORDER BY u.last_login ASC;  -- Más antiguos primero

Explicación de filtros:

  1. estado = 'ACTIVO':
     Excluye usuarios ya marcados como INACTIVO
  
  2. last_login < DATE_SUB(NOW(), INTERVAL 60 DAY):
     Implementa BR-IACT-070 (>60 días)
  
  3. NOT EXISTS (confirmación reciente):
     Evita duplicados si job se ejecuta múltiples veces
     Ventana de 7 días (una semana)

Índices requeridos:

  CREATE INDEX idx_users_inactivity 
    ON users(estado, last_login);
  
  CREATE INDEX idx_confirmations_user_recent
    ON inactivity_confirmations(user_id, estado, created_at);

Performance:

  - Con índices: 100-200ms
  - Sin índices: Hasta 5 segundos (inaceptable)
  - Escaneo: <50,000 usuarios típicamente

8. CASOS DE PRUEBA
──────────────────

CP-1: Usuario con 65 días sin login
  Precondición:
    - user_id: 123
    - estado: 'ACTIVO'
    - last_login: NOW() - 65 días
    - Sin confirmación reciente
  Resultado esperado:
    - Aparece en resultados ✅
    - dias_inactivo = 65

CP-2: Usuario con 55 días sin login
  Precondición:
    - last_login: NOW() - 55 días
  Resultado esperado:
    - NO aparece (< 60 días)

CP-3: Usuario con 70 días pero estado INACTIVO
  Precondición:
    - last_login: NOW() - 70 días
    - estado: 'INACTIVO'
  Resultado esperado:
    - NO aparece (ya inactivo)

CP-4: Usuario con confirmación PENDING hace 3 días
  Precondición:
    - last_login: NOW() - 65 días
    - inactivity_confirmations: created_at hace 3 días, estado PENDING
  Resultado esperado:
    - NO aparece (ventana de 7 días)

CP-5: Usuario con confirmación PENDING hace 10 días
  Precondición:
    - last_login: NOW() - 65 días
    - inactivity_confirmations: created_at hace 10 días
  Resultado esperado:
    - SÍ aparece (fuera de ventana 7 días)

CP-6: Usuario con confirmación CONFIRMED hace 2 días
  Precondición:
    - last_login: NOW() - 90 días (!!)
    - Confirmó hace 2 días
  Resultado esperado:
    - NO aparece (confirmó recientemente)
    Nota: Aunque no haya hecho login, ya confirmó

CP-7: Performance con 50,000 usuarios
  Precondición:
    - 50,000 usuarios en tabla
    - 20 cumplen condiciones
  Resultado esperado:
    - Query <200ms
    - Retorna 20 correctos

9. MANEJO DE ERRORES
────────────────────

Error 1: BD no disponible
  - Capturar DatabaseConnectionError
  - Registrar en error_log
  - Retornar lista vacía []
  - Job se reintenta en próxima semana

Error 2: Query timeout (>5s)
  - Capturar QueryTimeoutError
  - Alarma: "FR-2501 query timeout - check indexes"
  - Retornar parcial si posible
  - Investigar plan de ejecución

Error 3: Campo last_login NULL
  - Posible en usuarios recién creados
  - Tratamiento: WHERE last_login IS NOT NULL
  - O: WHERE COALESCE(last_login, created_at) < ...

10. IMPLEMENTACIÓN
──────────────────

Función Python:

def get_inactive_users_for_confirmation() -> List[InactiveUser]:
    """
    Consulta usuarios con >60 días sin login que requieren confirmación.
    
    Implementa: FR-2501
    Derivado de: UC-IACT-25 Paso 2
    Business Rule: BR-IACT-070
    
    Returns:
        Lista de objetos InactiveUser.
        Lista vacía si no hay usuarios elegibles.
    
    Raises:
        DatabaseError: Si BD no disponible
        QueryTimeout: Si query excede 5 segundos
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT 
                  u.user_id,
                  u.nombre,
                  u.email,
                  u.last_login,
                  DATEDIFF(NOW(), u.last_login) as dias_inactivo
                FROM users u
                WHERE u.estado = 'ACTIVO'
                  AND u.last_login < DATE_SUB(NOW(), INTERVAL 60 DAY)
                  AND NOT EXISTS (
                    SELECT 1 FROM inactivity_confirmations ic
                    WHERE ic.user_id = u.user_id
                      AND ic.estado IN ('PENDING', 'CONFIRMED')
                      AND ic.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
                  )
                ORDER BY u.last_login ASC
            """)
            
            rows = cursor.fetchall()
            
            return [
                InactiveUser(
                    user_id=row[0],
                    nombre=row[1],
                    email=row[2],
                    last_login=row[3],
                    dias_inactivo=row[4]
                )
                for row in rows
            ]
    
    except DatabaseError as e:
        logger.error(f"Database error in FR-2501: {e}")
        return []
    
    except QueryTimeout as e:
        logger.critical(f"Query timeout in FR-2501: {e}")
        alert_oncall("FR-2501 query timeout")
        return []

Tests unitarios:

def test_get_inactive_users_65_days():
    """CP-1: Usuario con 65 días debe aparecer"""
    user = UserFactory(
        estado='ACTIVO',
        last_login=now() - timedelta(days=65)
    )
    
    result = get_inactive_users_for_confirmation()
    
    assert len(result) == 1
    assert result[0].user_id == user.user_id
    assert result[0].dias_inactivo == 65

def test_get_inactive_users_55_days():
    """CP-2: Usuario con 55 días NO debe aparecer"""
    UserFactory(
        estado='ACTIVO',
        last_login=now() - timedelta(days=55)
    )
    
    result = get_inactive_users_for_confirmation()
    
    assert len(result) == 0

# ... más tests para CP-3 a CP-7

═══════════════════════════════════════════════════════════
```

---

## 11.4 Ejercicio 4: Trazabilidad Completa

### Enunciado

Dado el siguiente código en producción:

```python
# iact/access/validators.py

def validate_user_is_not_inactive(user_id: int) -> bool:
    """Valida que usuario no esté inactivo antes de asignar permisos."""
    user = User.objects.get(id=user_id)
    if user.estado == 'INACTIVO':
        raise ValidationError(
            f"No se pueden asignar funciones a usuario inactivo: {user.nombre}"
        )
    return True
```

**TAREA:** Realizar backward tracing completo hasta la BR origen.

### Solución Ejercicio 4

```
═══════════════════════════════════════════════════════════
SOLUCIÓN EJERCICIO 4: BACKWARD TRACING
═══════════════════════════════════════════════════════════

PASO 1: Código Origen
─────────────────────

Archivo: iact/access/validators.py
Función: validate_user_is_not_inactive()
Líneas: 234-242

OBSERVACIÓN INICIAL:
  - Sin docstring de trazabilidad 😞
  - Sin comentarios con BR-XXX
  - Necesitamos investigar

PASO 2: Buscar FR Implementado
───────────────────────────────

Estrategia: Buscar nombre de función en docs/FR/

$ grep -r "validate_user_is_not_inactive" docs/FR/

Resultado:
  docs/FR/FR-408.md: "Implementado por: validate_user_is_not_inactive()"

Bingo! FR encontrado: FR-408

PASO 3: Examinar FR-408
───────────────────────

Contenido de docs/FR/FR-408.md:

```
FR-408: Validar Usuario No Está Inactivo

Descripción:
  Antes de asignar funciones, validar que usuario destino
  tiene estado != 'INACTIVO'.

Derivado de:
  - UC-IACT-04 Paso 3.5 (agregado en v1.2)
  - Business Rule: BR-IACT-072

Implementación:
  Archivo: iact/access/validators.py
  Función: validate_user_is_not_inactive()
```

PASO 4: Examinar UC-IACT-04
────────────────────────────

Buscar "Paso 3.5" en docs/UC/UC-IACT-04.md:

```
3.5. Sistema valida usuario destino no está INACTIVO [BR-IACT-072]
     
     IF usuario.estado == 'INACTIVO' THEN
       Ir a FA-9: Usuario Destino Inactivo
     END IF
```

PASO 5: Examinar BR-IACT-072
─────────────────────────────

Buscar en docs/BR/BR-IACT-072.md:

```
BR-IACT-072 (RESTRICCIÓN):

"No se pueden asignar funciones a usuarios con estado INACTIVO.
 Usuarios inactivos deben ser reactivados primero antes de 
 recibir nuevas asignaciones."

Tipo: Restricción de Proceso
Fuente: UC-IACT-25 (Confirmación de vigencia)
Relacionada con: BR-IACT-070
Criticidad: Media
Vigencia: Desde 2025-12-01
```

PASO 6: Validar Trazabilidad Completa
──────────────────────────────────────

Cadena completa:

BR-IACT-072 (Restricción)
  ↓ integra en
UC-IACT-04 Paso 3.5 (Validación)
  ↓ deriva
FR-408 (Validar Usuario No Inactivo)
  ↓ implementa
validate_user_is_not_inactive() (Código)

✅ TRAZABILIDAD COMPLETA Y VERIFICADA

PASO 7: Mejorar Código con Trazabilidad
────────────────────────────────────────

Código actualizado:

```python
def validate_user_is_not_inactive(user_id: int) -> bool:
    """
    Valida que usuario no esté inactivo antes de asignar permisos.
    
    Trazabilidad:
        BR: BR-IACT-072 (No asignar a usuarios INACTIVO)
        UC: UC-IACT-04 Paso 3.5
        FR: FR-408
    
    Args:
        user_id: ID del usuario a validar
    
    Returns:
        True si usuario es ACTIVO
    
    Raises:
        ValidationError: Si usuario está INACTIVO
    
    Examples:
        >>> validate_user_is_not_inactive(123)
        True
        
        >>> validate_user_is_not_inactive(999)  # Usuario inactivo
        ValidationError: "No se pueden asignar funciones..."
    """
    user = User.objects.get(id=user_id)
    
    # BR-IACT-072: Bloquear asignación a usuarios INACTIVO
    if user.estado == 'INACTIVO':
        raise ValidationError(
            f"No se pueden asignar funciones a usuario inactivo: {user.nombre}. "
            f"Reactive el usuario primero (UC-IACT-27)."
        )
    
    return True
```

CAMBIOS REALIZADOS:
  ✓ Docstring con trazabilidad completa
  ✓ Comentario en línea con BR-IACT-072
  ✓ Mensaje de error mejorado (sugiere acción)
  ✓ Type hints completos
  ✓ Examples en docstring

PASO 8: Actualizar Matriz de Trazabilidad
──────────────────────────────────────────

Agregar entrada:

┌──────┬────────┬──────────────┬──────┬─────────────────┐
│  BR  │  UC    │ Ubicación    │  FR  │ Código          │
├──────┼────────┼──────────────┼──────┼─────────────────┤
│ 072  │ UC-04  │ Paso 3.5 +   │ 408  │ validators.     │
│      │        │ FA-9         │      │ py:validate_... │
└──────┴────────┴──────────────┴──────┴─────────────────┘

REFLEXIÓN:
──────────

Problemas encontrados:
  ❌ Código sin docstring de trazabilidad inicialmente
  ❌ Necesitó investigación manual (grep)

Mejoras implementadas:
  ✅ Docstring completo con BR/UC/FR
  ✅ Comentario en línea con BR
  ✅ Mensaje de error más útil

Lección aprendida:
  SIEMPRE incluir trazabilidad en docstrings desde el inicio.
  Facilita mantenimiento futuro.

═══════════════════════════════════════════════════════════
```

---

**FIN DE PARTE 2C**

**PARTE 2 COMPLETA:**
- ✅ PARTE 2A - Fundamentos
- ✅ PARTE 2B - Construcción Detallada
- ✅ PARTE 2C - Casos Especiales y Validación

**Total:** ~220 páginas, ~100,000 palabras

**Próximo:** ¿Extraer templates identificados como archivos separados?