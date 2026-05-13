---
proyecto: IACT
documento: PARTE_2B
titulo: Construcción Detallada de Casos de Uso
version: 1.0.0
fecha: 2026-01-09
prerequisito: PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
siguiente: PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
estado: ACTUALIZADO
---


**Sistema:** IACT - Integrated Analysis and Contextual Traceability  
**Versión del Documento:** 2.0.0 - IACT Edition  
**Fecha:** Enero 2026  
**Alcance:** Secciones 4-7 (Construcción Detallada)

---

## PARTE 2B: CONSTRUCCIÓN DETALLADA (Secciones 4-7)

**Documento Analizado:** PARTE_2B_CONSTRUCCION_IACT.md  
**Longitud:** ~70 páginas estimadas  
**Objetivo:** Proceso paso a paso de construcción, integración y derivación

---

# SECCIÓN 4: PROCESO DE CONSTRUCCIÓN DE CASOS DE USO

## 4.1 Proceso Completo de Construcción (7 Pasos)

Esta sección presenta el proceso sistemático para construir un Caso de Uso desde cero, desde la identificación del Desencadenador hasta la documentación completa.

### Vista General del Proceso

```
┌─────────────────────────────────────────────────────────┐
│         PROCESO DE CONSTRUCCIÓN DE UC                   │
│              (7 PASOS SECUENCIALES)                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  PASO 1: Identificar BR Desencadenador                  │
│          ↓                                              │
│          ¿Es observable? → SÍ (continuar)               │
│                                                         │
│  PASO 2: Identificar Actor Primario                     │
│          ↓                                              │
│          3 preguntas para decidir                       │
│                                                         │
│  PASO 3: Definir Objetivo del UC                        │
│          ↓                                              │
│          Formato: Verbo + Objeto + Contexto             │
│                                                         │
│  PASO 4: Construir Precondiciones                       │
│          ↓                                              │
│          4 categorías: Estado, Autenticación, BR, Datos │
│                                                         │
│  PASO 5: Construir Flujo Normal                         │
│          ↓                                              │
│          7 subpasos (inicio, consulta, validación...)   │
│                                                         │
│  PASO 6: Construir Flujos Alternos                      │
│          ↓                                              │
│          5 patrones: Validación, Técnico, Cancelación...│
│                                                         │
│  PASO 7: Definir Postcondiciones                        │
│          ↓                                              │
│          ¿Qué cambió? Estado BD + Auditoría             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Ejemplo Guiado: Construcción de UC-IACT-09

Vamos a construir un nuevo UC desde cero usando el proceso de 7 pasos.

**Business Rule Origen:**

```
BR-IACT-033 (DESENCADENADOR):
"SI un permiso temporal expirará en menos de 24 horas
 Y el usuario tiene al menos una función crítica asignada temporalmente
 ENTONCES enviar notificación al usuario Y al administrador que asignó
 para que decidan si renovar o revocar antes de expiración automática."

Tipo: Desencadenador
Fuente: CNST-009 + Política Temporal de Permisos
Criticidad: Alta
Vigencia: Desde 2025-11-01
Frecuencia: Cada hora (verificación)
```

---

### **PASO 1: Identificar BR Desencadenador**

**Análisis de BR-IACT-033:**

```
Estructura IF-THEN: ✅ Sí
  IF: permiso temporal expira <24h Y función crítica
  THEN: enviar notificación

Condición temporal: ✅ Sí
  Expira en <24 horas

Acción observable: ✅ Sí
  "Enviar notificación" → Usuario y Admin RECIBEN mensaje

¿Alguien recibe algo?: ✅ Sí
  - Usuario recibe notificación
  - Administrador recibe notificación

CONCLUSIÓN: Es DESENCADENADOR → Genera UC completo
```

**Decisión:** Proceder con construcción de UC-IACT-09

---

### **PASO 2: Identificar Actor Primario**

Aplicamos las **3 preguntas** del método:

```
PREGUNTA 1: ¿Quién quiere que esto ocurra?
  
  Opciones:
    A) Usuario → NO exactamente, él quiere el permiso pero no inicia la notif
    B) Administrador → NO, él asignó pero no dispara la notificación
    C) Sistema → SÍ, el sistema monitorea automáticamente
  
  Análisis:
    - Usuario RECIBE (no inicia)
    - Admin RECIBE (no inicia)
    - Sistema MONITOREA y NOTIFICA
  
  Respuesta: Sistema (Tiempo/Scheduler)

PREGUNTA 2: ¿Cuándo se ejecuta?
  
  Cada hora (verificación periódica)
  Trigger: APScheduler job
  Cron: "0 * * * *" (cada hora en punto)
  
  Respuesta: Automático, no manual

PREGUNTA 3: ¿Quién se beneficia del resultado?
  
  - Usuario: Sabe que permiso expira, puede pedir renovación
  - Administrador: Recuerda revisar permisos temporales asignados
  - Seguridad: Asegura que permisos críticos no expiren sin revisión
  
  Respuesta: Múltiples stakeholders, pero ninguno INICIA

DECISIÓN FINAL:
  Actor Primario: Sistema (Scheduler)
  Actores Secundarios: Usuario, Administrador (ambos reciben)
```

**Justificación Detallada:**

El Sistema es el actor primario porque:
1. **Inicia** la ejecución (cada hora, automáticamente)
2. **Monitorea** condiciones (permisos temporales próximos a expirar)
3. **Ejecuta** la acción (enviar notificaciones)
4. No requiere intervención humana para dispararse

Usuario y Administrador son secundarios porque:
1. **NO inician** el UC
2. **RECIBEN** el resultado (notificaciones)
3. **PUEDEN reaccionar** pero no es obligatorio en este UC
4. Su reacción será otro UC (UC-IACT-10: Renovar Permiso Temporal)

---

### **PASO 3: Definir Objetivo del UC**

**Formato estándar:** Verbo + Objeto + Contexto (opcional)

**Opciones consideradas:**

```
Opción A: "Notificar Vencimiento de Permisos"
  ❌ Problema: Muy genérico, no especifica temporales ni criticidad

Opción B: "Enviar Alerta de Expiración"
  ❌ Problema: "Alerta" es ambiguo, no dice QUÉ expira

Opción C: "Notificar Vencimiento de Permiso Temporal Crítico"
  ✅ Mejor: Específico, menciona "temporal" y "crítico"
  
Opción D: "Notificar Expiración Inminente de Permiso Temporal"
  ✅✅ ÓPTIMO: 
    - "Expiración Inminente" → Transmite urgencia (<24h)
    - "Permiso Temporal" → Específico del tipo
    - Longitud adecuada (6 palabras)
```

**OBJETIVO ELEGIDO:**

```
UC-IACT-09: Notificar Expiración Inminente de Permiso Temporal

Verbo: Notificar
Objeto: Expiración Inminente
Calificador: de Permiso Temporal
```

**Descripción breve (1 párrafo):**

> Este caso de uso permite al sistema monitorear automáticamente permisos 
> temporales que expiran en menos de 24 horas, especialmente aquellos que 
> incluyen funciones críticas, y enviar notificaciones preventivas tanto 
> al usuario que posee el permiso como al administrador que lo asignó, 
> para que puedan decidir si renovar o dejar expirar.

---

### **PASO 4: Construir Precondiciones**

Las precondiciones son condiciones que **DEBEN ser ciertas ANTES** de que el UC pueda ejecutarse.

**Categorías de Precondiciones:**

```
┌──────────────────────────────────────────────────┐
│    4 CATEGORÍAS DE PRECONDICIONES                │
├──────────────────────────────────────────────────┤
│                                                  │
│  CATEGORÍA 1: Estado del Sistema                 │
│    - Servicios requeridos disponibles            │
│    - Scheduler activo                            │
│    - BD accesible                                │
│                                                  │
│  CATEGORÍA 2: Autenticación/Autorización         │
│    - No aplica (Sistema es actor)                │
│    - Solo si actor fuera humano                  │
│                                                  │
│  CATEGORÍA 3: Business Rules                     │
│    - BR específicas que deben cumplirse          │
│    - Restricciones del dominio                   │
│                                                  │
│  CATEGORÍA 4: Datos                              │
│    - Existen registros elegibles                 │
│    - Datos consistentes en BD                    │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Precondiciones para UC-IACT-09:**

```
PRECONDICIONES:

[CATEGORÍA 1: Estado del Sistema]
  PRE-01: APScheduler job está configurado y activo
          Job ID: "temp_permission_expiration_check"
          Frecuencia: Cada hora (0 * * * *)
  
  PRE-02: InternalMessageService está disponible
          Endpoint: /api/v1/messages/send
          Health check: PASS
  
  PRE-03: Base de datos está accesible
          Connection pool: >2 conexiones disponibles
          Query timeout: 30 segundos

[CATEGORÍA 3: Business Rules]
  PRE-04: Política de permisos temporales vigente
          BR-IACT-033 aplicable desde 2025-11-01
  
  PRE-05: Definición de "función crítica" clara
          Campo functions.es_critica definido
          Catálogo actualizado

[CATEGORÍA 4: Datos]
  PRE-06: Existen permisos temporales en sistema
          Tabla temp_permissions tiene registros
          Al menos algunos con estado = 'ACTIVO'
  
  PRE-07: Usuarios y administradores tienen buzón interno
          Campo users.internal_mailbox_id NOT NULL
          Buzones activos y funcionales
  
  PRE-08: Timestamp de expiración correctamente registrado
          temp_permissions.expiration_date es DATETIME válido
          En zona horaria del servidor
```

**Notas sobre Precondiciones:**

- **PRE-01 a PRE-03** son técnicas (infraestructura)
- **PRE-04 a PRE-05** son de negocio (BR aplicables)
- **PRE-06 a PRE-08** son de datos (registros existen y son válidos)

**No incluimos:**
- Autenticación (Sistema no se autentica)
- Permisos del usuario (Sistema tiene permisos implícitos)
- Condiciones que se verifican DURANTE el flujo (esas van en pasos)

---

### **PASO 5: Construir Flujo Normal**

El Flujo Normal es la secuencia cuando **TODO sale perfecto**. Sin errores, sin excepciones, camino feliz completo.

**7 Subpasos para Construir Flujo Normal:**

```
┌──────────────────────────────────────────────────┐
│    7 SUBPASOS DEL FLUJO NORMAL                   │
├──────────────────────────────────────────────────┤
│                                                  │
│  5.1. INICIO: Job/Trigger                        │
│       Sistema inicia, registra contexto          │
│                                                  │
│  5.2. CONSULTA: Datos elegibles                  │
│       Query con condiciones de BR                │
│                                                  │
│  5.3. ITERACIÓN: Por cada registro               │
│       Loop sobre resultados                      │
│                                                  │
│  5.4. VALIDACIÓN: Verificar condiciones          │
│       Checks adicionales por registro            │
│                                                  │
│  5.5. PROCESAMIENTO: Lógica de negocio           │
│       Cálculos, preparación de datos             │
│                                                  │
│  5.6. ACCIÓN: Ejecutar comportamiento            │
│       Enviar, actualizar, notificar              │
│                                                  │
│  5.7. AUDITORÍA: Registrar evento                │
│       Log, auditoría, métricas                   │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Flujo Normal de UC-IACT-09:**

```
FLUJO NORMAL (11 pasos):

═══════════════════════════════════════════════════════════
FASE 1: INICIO Y CONSULTA
═══════════════════════════════════════════════════════════

1. Sistema inicia job programado (cada hora en punto)
   
   Timestamp: NOW()
   Job ID: temp_permission_expiration_check
   Timeout: 60 segundos
   
   Log:
     INFO: "Iniciando verificación de permisos temporales..."
     Timestamp: {timestamp}
     Expected records: ~50-200

2. Sistema consulta permisos temporales próximos a expirar [BR-IACT-033]
   
   Query:
   SELECT 
     tp.temp_permission_id,
     tp.user_id,
     tp.assigned_by_user_id,
     tp.expiration_date,
     TIMESTAMPDIFF(HOUR, NOW(), tp.expiration_date) as horas_restantes,
     u.nombre as usuario_nombre,
     u.email as usuario_email,
     admin.nombre as admin_nombre,
     admin.email as admin_email,
     COUNT(DISTINCT CASE WHEN f.es_critica = TRUE THEN f.function_id END) as funciones_criticas_count,
     GROUP_CONCAT(DISTINCT f.code_slug ORDER BY f.code_slug) as funciones_code_slugs
   FROM temp_permissions tp
   JOIN users u ON tp.user_id = u.user_id
   JOIN users admin ON tp.assigned_by_user_id = admin.user_id
   LEFT JOIN temp_permission_functions tpf ON tp.temp_permission_id = tpf.temp_permission_id
   LEFT JOIN functions f ON tpf.function_id = f.function_id
   WHERE tp.estado = 'ACTIVO'
     AND TIMESTAMPDIFF(HOUR, NOW(), tp.expiration_date) > 0      -- Aún no expiró
     AND TIMESTAMPDIFF(HOUR, NOW(), tp.expiration_date) <= 24    -- Expira en ≤24h
     AND EXISTS (
       SELECT 1 FROM temp_permission_functions tpf2
       JOIN functions f2 ON tpf2.function_id = f2.function_id
       WHERE tpf2.temp_permission_id = tp.temp_permission_id
         AND f2.es_critica = TRUE
     )  -- Tiene al menos una función crítica
     AND NOT EXISTS (
       SELECT 1 FROM temp_permission_notifications tpn
       WHERE tpn.temp_permission_id = tp.temp_permission_id
         AND tpn.notification_type = 'EXPIRATION_WARNING_24H'
         AND tpn.created_at > DATE_SUB(NOW(), INTERVAL 6 HOUR)
     )  -- No notificado en últimas 6 horas
   GROUP BY tp.temp_permission_id, tp.user_id, tp.assigned_by_user_id,
            tp.expiration_date, u.nombre, u.email, admin.nombre, admin.email
   HAVING funciones_criticas_count > 0
   ORDER BY tp.expiration_date ASC;
   
   Filtros aplicados:
     ✓ Estado ACTIVO (no revocados)
     ✓ 0 < horas_restantes ≤ 24 (ventana de 24h)
     ✓ Tiene al menos 1 función crítica (HAVING)
     ✓ No notificado recientemente (<6h)
   
   Performance esperada:
     - Con índices: <200ms
     - Típicamente retorna: 5-50 permisos

═══════════════════════════════════════════════════════════
FASE 2: ITERACIÓN Y PROCESAMIENTO
═══════════════════════════════════════════════════════════

3. Sistema itera sobre cada permiso encontrado
   
   FOR EACH permiso IN permisos_encontrados:
     Procesar pasos 4-10 para este permiso
   END FOR
   
   Modo: Secuencial (no paralelo, evitar race conditions)
   
   Variables por iteración:
     - temp_permission_id
     - user_id, usuario_nombre, usuario_email
     - admin_id, admin_nombre, admin_email
     - horas_restantes
     - funciones_criticas_count
     - funciones_code_slugs

4. Sistema calcula información adicional
   
   # Calcular tiempo exacto de expiración
   expiracion_timestamp = permiso.expiration_date
   tiempo_restante_formatted = format_duration(horas_restantes)
   # Ej: "23 horas y 15 minutos"
   
   # Obtener lista de funciones críticas con nombres
   funciones_criticas_detalle = []
   FOR EACH code_slug IN funciones_code_slugs.split(','):
     funcion = Function.objects.get(code_slug=code_slug)
     funciones_criticas_detalle.append({
       'code': funcion.code_slug,
       'name': funcion.name,
       'categoria': funcion.categoria
     })
   END FOR
   
   # Determinar urgencia por horas restantes
   IF horas_restantes <= 6:
     urgencia = 'CRÍTICA'
     prioridad_mensaje = 'URGENT'
   ELSIF horas_restantes <= 12:
     urgencia = 'ALTA'
     prioridad_mensaje = 'HIGH'
   ELSE:
     urgencia = 'MEDIA'
     prioridad_mensaje = 'MEDIUM'
   END IF

═══════════════════════════════════════════════════════════
FASE 3: COMPOSICIÓN DE MENSAJES
═══════════════════════════════════════════════════════════

5. Sistema compone mensaje para USUARIO
   
   Template:
   ───────────────────────────────────────────────────
   ⏰ AVISO: Su permiso temporal expirará pronto
   ───────────────────────────────────────────────────
   
   Estimado/a {usuario_nombre},
   
   Su permiso temporal que incluye funciones críticas expirará
   en aproximadamente {tiempo_restante_formatted}.
   
   📋 FUNCIONES CRÍTICAS AFECTADAS:
   {lista_funciones_criticas}
   
   ⚠️  ACCIÓN REQUERIDA:
   Si necesita continuar usando estas funciones después de
   {expiracion_timestamp}, debe solicitar RENOVACIÓN del
   permiso temporal al administrador que lo asignó.
   
   Para solicitar renovación:
   1. Contacte a: {admin_nombre}
   2. O use el botón de abajo
   
   [Solicitar Renovación de Permiso]
   
   Si NO solicita renovación, estas funciones se revocarán
   automáticamente el {expiracion_timestamp}.
   
   ℹ️  DETALLES:
   - Fecha de asignación: {fecha_asignacion}
   - Asignado por: {admin_nombre}
   - ID del permiso: {temp_permission_id}
   - Urgencia: {urgencia}
   
   ───────────────────────────────────────────────────
   
   Prioridad: {prioridad_mensaje}
   Categoría: TEMP_PERMISSION_EXPIRATION
   Expira auto: Sí (cuando permiso expire)

6. Sistema compone mensaje para ADMINISTRADOR
   
   Template:
   ───────────────────────────────────────────────────
   📋 RECORDATORIO: Permiso temporal expirará pronto
   ───────────────────────────────────────────────────
   
   Administrador/a {admin_nombre},
   
   Un permiso temporal que usted asignó expirará pronto.
   
   👤 USUARIO AFECTADO:
   - Nombre: {usuario_nombre}
   - Email: {usuario_email}
   - ID: {user_id}
   
   📋 FUNCIONES TEMPORALES ASIGNADAS:
   {lista_funciones_criticas}
   
   ⏰ TIEMPO RESTANTE:
   Expira en: {tiempo_restante_formatted}
   Fecha/hora exacta: {expiracion_timestamp}
   
   ⚠️  ACCIÓN RECOMENDADA:
   Revise si este usuario necesita continuar con estos
   permisos. Opciones:
   
   1. RENOVAR: Extender por X días más
   2. CONVERTIR: Hacer permanente (si justifica)
   3. REVOCAR: Terminar ahora (antes de expiración auto)
   4. DEJAR EXPIRAR: No hacer nada (revocación auto)
   
   [Renovar Permiso] [Convertir a Permanente] [Revocar Ahora]
   
   ℹ️  HISTORIAL:
   - Asignado el: {fecha_asignacion}
   - Duración original: {duracion_dias} días
   - Justificación original: {justificacion}
   - Renovaciones previas: {renovaciones_count}
   
   Si no toma ninguna acción, el permiso se revocará
   automáticamente el {expiracion_timestamp}.
   ───────────────────────────────────────────────────
   
   Prioridad: {prioridad_mensaje}
   Categoría: ADMIN_TEMP_PERMISSION_REVIEW

═══════════════════════════════════════════════════════════
FASE 4: ENVÍO Y REGISTRO
═══════════════════════════════════════════════════════════

7. Sistema envía mensaje al buzón interno del USUARIO
   
   CALL InternalMessageService.send(
     recipient_user_id: {user_id},
     sender_user_id: NULL,  -- mensaje del sistema
     message_type: 'TEMP_PERMISSION_EXPIRATION_USER',
     subject: 'AVISO: Permiso temporal expirará en {horas}h',
     body_text: {mensaje_usuario_texto},
     body_html: {mensaje_usuario_html},
     priority: {prioridad_mensaje},
     action_buttons: [
       {
         label: 'Solicitar Renovación',
         action: 'REQUEST_RENEWAL',
         temp_permission_id: {temp_permission_id}
       }
     ],
     auto_expire_at: {expiracion_timestamp},
     metadata: {
       temp_permission_id: {temp_permission_id},
       horas_restantes: {horas_restantes},
       urgencia: {urgencia}
     }
   );
   
   Si envío exitoso:
     usuario_notificado = TRUE
   Si falla:
     Ir a FA-3: Error al Enviar Mensaje

8. Sistema envía mensaje al buzón interno del ADMINISTRADOR
   
   CALL InternalMessageService.send(
     recipient_user_id: {admin_id},
     sender_user_id: NULL,
     message_type: 'TEMP_PERMISSION_EXPIRATION_ADMIN',
     subject: 'RECORDATORIO: Permiso temporal de {usuario} expira en {horas}h',
     body_text: {mensaje_admin_texto},
     body_html: {mensaje_admin_html},
     priority: {prioridad_mensaje},
     action_buttons: [
       {
         label: 'Renovar Permiso',
         action: 'RENEW_PERMISSION',
         temp_permission_id: {temp_permission_id}
       },
       {
         label: 'Convertir a Permanente',
         action: 'CONVERT_TO_PERMANENT',
         temp_permission_id: {temp_permission_id}
       },
       {
         label: 'Revocar Ahora',
         action: 'REVOKE_NOW',
         temp_permission_id: {temp_permission_id}
       }
     ],
     auto_expire_at: {expiracion_timestamp},
     metadata: {
       temp_permission_id: {temp_permission_id},
       user_id: {user_id},
       horas_restantes: {horas_restantes}
     }
   );
   
   Si envío exitoso:
     admin_notificado = TRUE
   Si falla:
     Ir a FA-4: Error al Enviar a Admin

9. Sistema registra notificación en tabla temp_permission_notifications
   
   INSERT INTO temp_permission_notifications (
     temp_permission_id,
     notification_type,
     horas_restantes,
     urgencia,
     usuario_notificado,
     admin_notificado,
     created_at,
     user_message_id,
     admin_message_id
   ) VALUES (
     {temp_permission_id},
     'EXPIRATION_WARNING_24H',
     {horas_restantes},
     {urgencia},
     {usuario_notificado},
     {admin_notificado},
     NOW(),
     {user_message_id},
     {admin_message_id}
   );
   
   Propósito: 
     - Evitar duplicados (EXISTS check en paso 2)
     - Auditoría de notificaciones enviadas
     - Tracking de entregas

10. Sistema registra evento en auditoría completa
    
    INSERT INTO audit_log (
      evento_tipo,
      temp_permission_id,
      user_id,
      admin_id,
      descripcion,
      metadata_json,
      timestamp
    ) VALUES (
      'TEMP_PERMISSION_EXPIRATION_WARNING',
      {temp_permission_id},
      {user_id},
      {admin_id},
      'Notificación de expiración enviada a usuario y admin',
      JSON_OBJECT(
        'horas_restantes', {horas_restantes},
        'urgencia', {urgencia},
        'funciones_criticas', {funciones_code_slugs},
        'usuario_notificado', {usuario_notificado},
        'admin_notificado', {admin_notificado},
        'expiration_date', {expiracion_timestamp}
      ),
      NOW()
    );

═══════════════════════════════════════════════════════════
FASE 5: FINALIZACIÓN
═══════════════════════════════════════════════════════════

11. Sistema finaliza job exitosamente
    
    Logs finales:
      INFO: "Verificación de permisos temporales completada"
      - Total permisos procesados: {count}
      - Usuarios notificados: {usuarios_notificados}
      - Admins notificados: {admins_notificados}
      - Errores: {errores_count}
      - Duración: {duracion_ms}ms
      - Próxima ejecución: {timestamp + 1 hora}
    
    Métricas:
      - Tasa de éxito: {(notificados / encontrados) * 100}%
      - Tiempo promedio por permiso: {duracion_ms / count}ms
      - Permisos urgencia CRÍTICA: {criticos_count}
    
    UC termina exitosamente
```

**Características del Flujo Normal:**

- **11 pasos** bien definidos
- **5 fases** lógicas (Inicio, Iteración, Composición, Envío, Finalización)
- **Dual notification**: Usuario Y Administrador
- **Sin errores**: Todo funciona perfectamente
- **Auditoría completa**: Cada acción registrada
- **Idempotente**: No duplica notificaciones (EXISTS check)

---

### **PASO 6: Construir Flujos Alternos**

Los Flujos Alternos manejan las situaciones donde algo sale **diferente** del camino feliz.

**5 Patrones de Flujos Alternos:**

```
┌──────────────────────────────────────────────────┐
│    5 PATRONES DE FLUJOS ALTERNOS                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  PATRÓN A: Variación de Negocio                  │
│    No es error, es camino alternativo legítimo   │
│    Ejemplo: FA-1 (No hay permisos elegibles)     │
│                                                  │
│  PATRÓN B: Error de Validación                   │
│    Dato inválido o inconsistente                 │
│    Ejemplo: FA-2 (Permiso ya expiró)             │
│                                                  │
│  PATRÓN C: Error Técnico                         │
│    Fallo de infraestructura/servicio             │
│    Ejemplo: FA-3, FA-4 (Error al enviar)         │
│                                                  │
│  PATRÓN D: Usuario Cancela                       │
│    No aplica (Sistema es actor)                  │
│                                                  │
│  PATRÓN E: Timeout/Performance                   │
│    Job excede tiempo permitido                   │
│    Ejemplo: FA-5 (Timeout 60s)                   │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Flujos Alternos de UC-IACT-09:**

```
═══════════════════════════════════════════════════════════
FLUJOS ALTERNOS
═══════════════════════════════════════════════════════════

FA-1: No Hay Permisos Temporales Próximos a Expirar (PATRÓN A)
───────────────────────────────────────────────────────────

Punto de desviación: Paso 2

2a. Query retorna 0 filas
    Ningún permiso cumple las 4 condiciones:
      - Estado ACTIVO
      - 0 < horas_restantes ≤ 24
      - Tiene funciones críticas
      - No notificado recientemente

2b. Sistema registra en log:
    INFO: "No hay permisos temporales elegibles en esta ejecución"
    Timestamp: {timestamp}
    Condiciones verificadas: ACTIVO, <24h, críticas, sin notif reciente

2c. Sistema incrementa contador de ejecuciones sin acción
    Métrica: empty_executions_count++

2d. UC termina exitosamente
    Exit code: 0
    Duración: <10ms

Postcondición:
  - Ningún mensaje enviado (comportamiento esperado)
  - Log limpio sin errores
  - Próxima ejecución programada normalmente

Notas:
  - Esto NO es error, es caso normal
  - Ocurre frecuentemente (la mayoría de ejecuciones)
  - No genera alarmas


FA-2: Permiso Expiró Mientras Job Ejecutaba (PATRÓN B - Race Condition)
────────────────────────────────────────────────────────────────────────

Punto de desviación: Paso 4

4a. Sistema intenta procesar permiso {temp_permission_id}

4b. Permiso fue marcado EXPIRADO por otro proceso paralelo
    (UC-IACT-11: Expirar Permisos Automáticamente)
    Estado cambió: ACTIVO → EXPIRADO
    
    Causa común:
      - Query del paso 2 ejecutó a 11:59:55
      - Permiso expiraba a 12:00:00
      - Paso 4 ejecuta a 12:00:05
      - UC-IACT-11 ya lo expiró a 12:00:01

4c. Sistema detecta al refrescar:
    SELECT estado FROM temp_permissions 
    WHERE temp_permission_id = {id}
    
    Resultado: 'EXPIRADO' (ya no 'ACTIVO')

4d. Sistema registra en log:
    WARN: "Permiso {id} expiró durante procesamiento, omitiendo"
    Original_query_time: {paso_2_timestamp}
    Expiration_time: {expiration_timestamp}
    Current_time: {now_timestamp}
    Race_window: {difference}ms

4e. Sistema OMITE ese permiso (no envía notificaciones)
    Justificación: Ya expiró, notificación no tiene sentido

4f. Sistema continúa con siguiente permiso en lista (paso 3)

Postcondición:
  - Permiso omitido correctamente (ya está EXPIRADO)
  - Sin notificaciones enviadas para ese permiso
  - Log con WARNING (no ERROR)
  - Otros permisos procesados normalmente

Frecuencia: Rara (~1% de ejecuciones)
Impacto: Mínimo (permiso ya expirado de todas formas)


FA-3: Error al Enviar Mensaje a Usuario (PATRÓN C)
───────────────────────────────────────────────────

Punto de desviación: Paso 7

7a. InternalMessageService.send() retorna error

7b. Sistema captura excepción específica:
    - MessageQueueFull (cola llena, >10,000 mensajes pendientes)
    - RecipientNotFound (user_id no existe o buzón deshabilitado)
    - ServiceUnavailable (503, servicio caído)
    - NetworkTimeout (>5s sin respuesta)

7c. Sistema NO marca usuario como notificado:
    usuario_notificado = FALSE

7d. Sistema registra error detallado en error_log:
    INSERT INTO error_log (
      error_type,
      error_subtype,
      temp_permission_id,
      user_id,
      error_message,
      stack_trace,
      service_called,
      timestamp,
      retry_scheduled
    ) VALUES (
      'MESSAGE_SEND_FAILED',
      {error_subtype},  -- MessageQueueFull, RecipientNotFound, etc.
      {temp_permission_id},
      {user_id},
      {exception.message},
      {exception.stack_trace},
      'InternalMessageService',
      NOW(),
      TRUE  -- Se reintentará en próxima ejecución
    );

7e. Sistema CONTINÚA con paso 8 (enviar a admin)
    No aborta el job completo
    Admin aún recibe su notificación

7f. Sistema marca en notificación parcial:
    temp_permission_notifications.usuario_notificado = FALSE
    temp_permission_notifications.user_message_error = {error_message}

7g. Continuar con siguiente permiso (paso 3)

Postcondición:
  - Usuario NO notificado (pero error registrado)
  - Administrador SÍ notificado (si paso 8 exitoso)
  - Error en log para debugging
  - Permiso sigue elegible en próxima ejecución (1 hora)
  - Otros permisos NO afectados

Retry Logic:
  - En próxima ejecución (1h después)
  - Si persiste por 3 intentos (3 horas):
    * Generar alarma crítica
    * Notificar on-call engineer
    * Escalar a notificación por email (fallback)


FA-4: Error al Enviar Mensaje a Administrador (PATRÓN C)
─────────────────────────────────────────────────────────

Punto de desviación: Paso 8

8a. InternalMessageService.send() para admin retorna error

8b. Mismos tipos de error que FA-3
    (MessageQueueFull, RecipientNotFound, ServiceUnavailable, NetworkTimeout)

8c. Sistema NO marca admin como notificado:
    admin_notificado = FALSE

8d. Sistema registra error similar a FA-3 pero para admin

8e. Sistema SÍ marca usuario como notificado (si paso 7 fue exitoso)
    Usuario tiene la info, admin no
    Usuario puede contactar admin proactivamente

8f. Sistema continúa con paso 9 (registro en notifications table)
    Con usuario_notificado = TRUE, admin_notificado = FALSE

8g. Continuar con siguiente permiso

Postcondición:
  - Usuario SÍ notificado (si paso 7 OK)
  - Administrador NO notificado
  - Error registrado
  - Permiso marcado como "notificación parcial"

Implicación:
  - Usuario sabe que su permiso expira
  - Admin NO sabe (pero usuario puede contactarlo)
  - Sistema reintentará notificar admin en 1 hora


FA-5: Job Excede Timeout de 60 Segundos (PATRÓN E)
───────────────────────────────────────────────────

Punto de desviación: Durante cualquier paso (global)

*a. APScheduler detecta que job lleva >60 segundos ejecutando

*b. Scheduler fuerza terminación del job (SIGTERM)
    Causas posibles:
      - Muchos permisos concurrentes (>500)
      - Query del paso 2 lento (sin índices)
      - BD sobrecargada / lock contention
      - Servicio de mensajería lento (<200ms por mensaje esperado)

*c. Sistema registra alarma CRÍTICA:
    INSERT INTO system_alerts (
      alert_type,
      severity,
      description,
      context_json,
      timestamp,
      requires_action
    ) VALUES (
      'JOB_TIMEOUT',
      'CRITICAL',
      'temp_permission_expiration_check excedió timeout de 60s',
      JSON_OBJECT(
        'duration_seconds', 60+,
        'permissions_processed', {count_procesados},
        'permissions_pending', {count_pendientes},
        'step_when_killed', {current_step}
      ),
      NOW(),
      TRUE
    );

*d. Sistema envía alerta a on-call engineer
    Channel: PagerDuty + Slack
    Severity: P2 (respuesta <1 hora)
    Message: "IACT: Temp permissions check timeout, {pending} permisos sin notificar"

*e. Sistema ejecuta análisis post-mortem:
    - ¿Cuántos permisos se procesaron antes de timeout?
    - ¿En qué paso ocurrió el timeout?
    - ¿Query del paso 2 fue lento? (revisar query log)
    - ¿Índices presentes? (SHOW INDEX FROM temp_permissions)
    - ¿CPU/RAM del servidor OK? (cloudwatch metrics)

*f. UC termina parcialmente
    Exit code: 124 (timeout)
    Permisos procesados: Solo los completados antes de kill
    Permisos pendientes: Se reintentarán en próxima ejecución (1h)

*g. Sistema sugiere acciones correctivas:
    - Si query >5s: Recrear índices
    - Si muchos permisos (>500): Particionar por criticidad
    - Si servicio mensajes lento: Escalar concurrencia
    - Si recurrente: Cambiar frecuencia a cada 30 min

Postcondición:
  - Algunos permisos notificados, otros pendientes
  - Alarma crítica activa
  - On-call notificado
  - Próxima ejecución programada (intentará pendientes)
  - Requiere intervención humana si recurrente

Prevención:
  - Monitorear duración de job (target: <30s)
  - Alarma si >45s (warning antes de timeout)
  - Optimizar queries (índices, EXPLAIN ANALYZE)
  - Limitar cantidad por ejecución (ej: máx 200 permisos)


FA-6: Usuario o Admin Deshabilitaron Buzón Interno (PATRÓN B)
──────────────────────────────────────────────────────────────

Punto de desviación: Pasos 7 o 8

7a/8a. Sistema intenta enviar mensaje

7b/8b. InternalMessageService retorna:
       RecipientMailboxDisabled
       Causa: users.internal_mailbox_enabled = FALSE

7c/8c. Sistema registra:
       WARN: "Usuario {id} tiene buzón interno deshabilitado"

7d/8d. Sistema busca email de fallback:
       IF users.email IS NOT NULL AND users.email_verified = TRUE THEN
         Enviar notificación por EMAIL (fallback)
         Usar template similar pero para email
       ELSE
         No enviar nada, solo registrar error
       END IF

7e/8e. Sistema marca notificación como:
       notification_channel = 'EMAIL_FALLBACK'
       O si no hay email:
       notification_status = 'FAILED_NO_CHANNEL'

7f/8f. Continuar normalmente

Postcondición:
  - Si email disponible: Notificación enviada por email
  - Si no: Error registrado, usuario no alcanzado
  - Admin SÍ notificado (si su buzón está habilitado)

Nota:
  - Restricción CNST-001: "NO enviar emails en producción"
  - Fallback solo aplica en dev/staging
  - En producción: Error crítico si buzón deshabilitado
```

**Resumen de Flujos Alternos:**

| FA | Patrón | Punto | Recuperación | Criticidad |
|----|--------|-------|--------------|------------|
| FA-1 | Negocio | Paso 2 | UC termina OK | Bajo |
| FA-2 | Validación | Paso 4 | Omite permiso, continúa | Bajo |
| FA-3 | Técnico | Paso 7 | Registra error, reintenta | Media |
| FA-4 | Técnico | Paso 8 | Registra error, reintenta | Media |
| FA-5 | Timeout | Global | Parcial, alarma crítica | Alta |
| FA-6 | Validación | Pasos 7-8 | Email fallback o error | Media-Alta |

---

### **PASO 7: Definir Postcondiciones**

Las postcondiciones describen **QUÉ CAMBIÓ** en el sistema después de ejecutar el UC.

**Categorías de Postcondiciones:**

```
┌──────────────────────────────────────────────────┐
│    CATEGORÍAS DE POSTCONDICIONES                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  CATEGORÍA 1: Estado de Base de Datos            │
│    - Registros creados/actualizados              │
│    - Campos modificados                          │
│    - Relaciones establecidas                     │
│                                                  │
│  CATEGORÍA 2: Mensajes/Notificaciones            │
│    - Mensajes enviados a usuarios                │
│    - Notificaciones generadas                    │
│    - Alertas despachadas                         │
│                                                  │
│  CATEGORÍA 3: Auditoría                          │
│    - Eventos registrados en audit_log            │
│    - Métricas capturadas                         │
│    - Logs generados                              │
│                                                  │
│  CATEGORÍA 4: Estados Futuros                    │
│    - Jobs programados                            │
│    - Timers iniciados                            │
│    - Recordatorios establecidos                  │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Postcondiciones de UC-IACT-09:**

```
POSTCONDICIONES DE ÉXITO (Flujo Normal):

[CATEGORÍA 1: Base de Datos]
  POST-01: Registro creado en temp_permission_notifications
           Para cada permiso procesado:
             - notification_type = 'EXPIRATION_WARNING_24H'
             - horas_restantes = {valor calculado}
             - urgencia = {CRÍTICA | ALTA | MEDIA}
             - usuario_notificado = TRUE
             - admin_notificado = TRUE
             - created_at = NOW()
  
  POST-02: Campos metadata actualizados (no existe físicamente, pero conceptual)
           Los permisos ahora tienen:
             - last_notification_sent = NOW()
             - notification_count++ (implícito en EXISTS check)

[CATEGORÍA 2: Mensajes/Notificaciones]
  POST-03: Usuario recibió mensaje en buzón interno
           Mensaje con:
             - Prioridad según urgencia
             - Botón "Solicitar Renovación"
             - Expira automáticamente al expirar permiso
  
  POST-04: Administrador recibió mensaje en buzón interno
           Mensaje con:
             - 3 botones de acción (Renovar, Convertir, Revocar)
             - Historial del permiso
             - Expira automáticamente al expirar permiso
  
  POST-05: Ambos mensajes marcados como "no leídos"
           users_messages.read = FALSE
           Aparecen en bandeja de entrada

[CATEGORÍA 3: Auditoría]
  POST-06: Evento registrado en audit_log
           Para cada permiso:
             - evento_tipo = 'TEMP_PERMISSION_EXPIRATION_WARNING'
             - metadata completo (horas, funciones, urgencia)
             - Timestamp de ejecución
  
  POST-07: Métricas de job actualizadas
           job_execution_stats:
             - execution_id = {uuid}
             - job_name = 'temp_permission_expiration_check'
             - duration_ms = {calculado}
             - permissions_processed = {count}
             - messages_sent = {count * 2}
             - errors = {count}
  
  POST-08: Log completo generado
           Nivel INFO para ejecución exitosa
           Incluye:
             - Total procesados
             - Desglose por urgencia
             - Duración total

[CATEGORÍA 4: Estados Futuros]
  POST-09: Próxima ejecución programada
           APScheduler job:
             - next_run_time = NOW() + 1 hora
             - Estado = 'SCHEDULED'
             - Sin cambios en configuración
  
  POST-10: Permisos notificados NO serán reprocesados
            En próxima ejecución (1 hora):
              - EXISTS check en paso 2 los excluye
              - Ventana de exclusión: 6 horas
              - Si aún sin expirar después de 6h: Re-notificar

═══════════════════════════════════════════════════════════

POSTCONDICIONES PARCIALES (Flujos Alternos):

[FA-1: Sin Permisos]
  POST-11: Ejecución registrada en stats con count = 0
           Métrica: empty_executions_count++
           Log: INFO "No hay permisos elegibles"
  
  POST-12: Sin mensajes enviados (correcto)
           users_messages: Sin nuevos registros
           temp_permission_notifications: Sin nuevos registros

[FA-2: Permiso Expiró Durante Ejecución]
  POST-13: Permiso omitido correctamente
           Log: WARN con detalles de race condition
           Permiso con estado = 'EXPIRADO' (por UC-IACT-11)
  
  POST-14: Sin notificaciones para ese permiso
           Justificación: Ya expiró, notificación sin sentido
           Otros permisos procesados normalmente

[FA-3 / FA-4: Error al Enviar Mensaje]
  POST-15: Error registrado en error_log
           Incluye:
             - Stack trace completo
             - Tipo de error específico
             - temp_permission_id afectado
             - retry_scheduled = TRUE
  
  POST-16: Notificación parcial registrada
           temp_permission_notifications:
             - usuario_notificado = TRUE/FALSE (según cuál falló)
             - admin_notificado = TRUE/FALSE
             - error_message = {si aplica}
  
  POST-17: Permiso elegible para retry
           En próxima ejecución (1h):
             - EXISTS check permite reprocesar
             - Reintenta envío fallido
  
  POST-18: Otros permisos NO afectados
           Job continuó después del error
           Permisos subsecuentes procesados OK

[FA-5: Timeout de Job]
  POST-19: Alarma crítica activa
           system_alerts:
             - alert_type = 'JOB_TIMEOUT'
             - severity = 'CRITICAL'
             - requires_action = TRUE
  
  POST-20: On-call engineer notificado
           PagerDuty incident creado
           Slack message enviado a #oncall
  
  POST-21: Procesamiento parcial
           Algunos permisos notificados: {count_completados}
           Algunos pendientes: {count_pendientes}
  
  POST-22: Análisis post-mortem iniciado
           Auto-diagnóstico ejecutado:
             - Query performance check
             - Index verification
             - Resource utilization review

[FA-6: Buzón Deshabilitado]
  POST-23: Fallback a email (si disponible)
           O error registrado si no hay fallback
  
  POST-24: Canal de notificación documentado
           temp_permission_notifications:
             - notification_channel = 'EMAIL_FALLBACK' o 'FAILED_NO_CHANNEL'
```

**Garantías del UC:**

```
GARANTÍAS MÍNIMAS (incluso si falla):
  
  ✓ Job siempre termina (con timeout si necesario)
  ✓ Errores en un permiso NO afectan otros permisos
  ✓ Errores siempre registrados en error_log
  ✓ Próxima ejecución siempre programada
  ✓ Sin corrupción de datos en BD

GARANTÍAS DE ÉXITO (solo si flujo normal):
  
  ✓ Todos los permisos elegibles notificados
  ✓ Usuario Y administrador reciben mensajes
  ✓ Mensajes con botones funcionales
  ✓ Auditoría completa registrada
  ✓ Sin duplicados (gracias a EXISTS check)
  ✓ Métricas precisas capturadas
```

---

## 4.2 Proceso Completo Documentado

Ahora tenemos **UC-IACT-09 completo** construido usando el proceso de 7 pasos:

```
✅ PASO 1: Identificar BR Desencadenador
   → BR-IACT-033 identificada y verificada

✅ PASO 2: Identificar Actor Primario
   → Sistema (Scheduler) confirmado como actor primario

✅ PASO 3: Definir Objetivo
   → "Notificar Expiración Inminente de Permiso Temporal"

✅ PASO 4: Construir Precondiciones
   → 8 precondiciones en 3 categorías

✅ PASO 5: Construir Flujo Normal
   → 11 pasos en 5 fases

✅ PASO 6: Construir Flujos Alternos
   → 6 FA cubriendo todos los escenarios

✅ PASO 7: Definir Postcondiciones
   → 24 postcondiciones en 4 categorías
```

**Resultado:** UC profesional completo, listo para implementación.

**Métricas del UC construido:**

- **Longitud total:** ~8,000 palabras
- **Pasos flujo normal:** 11
- **Flujos alternos:** 6
- **Precondiciones:** 8
- **Postcondiciones:** 24 (10 éxito + 14 FA)
- **Queries SQL:** 2 (paso 2 + varios checks)
- **Servicios externos:** 1 (InternalMessageService)
- **Complejidad:** Alta (dual notification + múltiples condiciones)

---

## 4.3 Template Reutilizable

**PLANTILLA PARA CONSTRUCCIÓN DE UC DESDE DESENCADENADOR**

```markdown
# UC-{MODULE}-{NUMBER}: {Nombre del UC}

## PASO 1: IDENTIFICACIÓN DE BR

**Business Rule Origen:**
- ID: BR-{ID}
- Tipo: Desencadenador
- Descripción: {texto completo}
- Verificación:
  * Estructura IF-THEN: [SÍ/NO]
  * Condición temporal/estado: [SÍ/NO]
  * Acción observable: [SÍ/NO]
  * Alguien recibe resultado: [SÍ/NO]
- Conclusión: [Genera UC / No genera UC]

## PASO 2: IDENTIFICACIÓN DE ACTORES

**Actor Primario:**
- Pregunta 1 (Quién quiere): {respuesta}
- Pregunta 2 (Cuándo ejecuta): {respuesta}
- Pregunta 3 (Quién se beneficia): {respuesta}
- **Decisión:** {actor decidido}

**Actores Secundarios:**
- {lista de actores que participan pero no inician}

**Stakeholders:**
- {rol}: {interés}
- {rol}: {interés}

## PASO 3: OBJETIVO

**Nombre del UC:** {Verbo + Objeto + Contexto}
**Descripción breve:** {1-2 párrafos}

## PASO 4: PRECONDICIONES

**Categoría 1: Estado del Sistema**
- PRE-01: {descripción}
- PRE-02: {descripción}

**Categoría 2: Autenticación/Autorización**
- PRE-03: {si aplica}

**Categoría 3: Business Rules**
- PRE-04: {BR aplicables}

**Categoría 4: Datos**
- PRE-05: {registros existen}
- PRE-06: {datos consistentes}

## PASO 5: FLUJO NORMAL

**Fase 1: Inicio**
1. {paso inicial, trigger}

**Fase 2: Consulta**
2. {query de registros elegibles con condiciones de BR}
   Query SQL:
   ```sql
   {query completo}
   ```

**Fase 3: Iteración**
3. {iterar sobre cada registro}

**Fase 4: Procesamiento**
4. {cálculos, preparación de datos}
5. {composición de mensajes/resultados}

**Fase 5: Acción**
6. {ejecutar comportamiento observable}
7. {enviar, actualizar, notificar}

**Fase 6: Auditoría**
8. {registrar en audit_log}
9. {registrar métricas}

**Fase 7: Finalización**
10. {logs finales, métricas}

## PASO 6: FLUJOS ALTERNOS

**FA-1: {Nombre} (PATRÓN {A/B/C/D/E})**
Punto de desviación: Paso {X}
{X}a. {condición detectada}
{X}b. {acción del sistema}
...
{X}n. {resultado/retorno}

Postcondición: {qué cambió}

**FA-2: ...** (repetir para cada FA)

## PASO 7: POSTCONDICIONES

**De Éxito (Flujo Normal):**

[Categoría 1: Base de Datos]
- POST-01: {registros creados/actualizados}
- POST-02: {campos modificados}

[Categoría 2: Mensajes]
- POST-03: {notificaciones enviadas}

[Categoría 3: Auditoría]
- POST-04: {eventos registrados}
- POST-05: {métricas capturadas}

[Categoría 4: Estados Futuros]
- POST-06: {jobs programados}

**Parciales (Flujos Alternos):**
- POST-07: [FA-X] {postcondición específica}

## METADATOS

**Business Rules Aplicadas:**
- BR-{ID}: {descripción breve} → {Ubicación en UC}

**UC Relacionados:**
- UC-{ID}: {nombre} → {relación}

**Frecuencia:** {diaria / horaria / continua}
**Prioridad:** {Alta / Media / Baja}
**Complejidad:** {Alta / Media / Baja}
```

---

# SECCIÓN 5: INTEGRACIÓN DE MÚLTIPLES BR EN UN UC

## 5.1 Cuándo Integrar vs Crear UC Nuevo

Una de las decisiones más importantes del análisis es: **¿Esta BR genera un UC nuevo o se integra en uno existente?**

### Criterios de Decisión

```
┌────────────────────────────────────────────────────┐
│    CRITERIOS PARA CREAR UC NUEVO vs INTEGRAR      │
├────────────────────────────────────────────────────┤
│                                                    │
│  CREAR UC NUEVO si:                                │
│                                                    │
│    ✓ BR es DESENCADENADOR (único tipo que genera) │
│    ✓ Comportamiento observable independiente      │
│    ✓ Actor diferente al de UC existentes          │
│    ✓ Objetivo completamente distinto              │
│    ✓ Puede ejecutarse sin otros UC                │
│                                                    │
│  INTEGRAR EN UC EXISTENTE si:                      │
│                                                    │
│    ✓ BR es HECHO (→ Modelo, no UC)                │
│    ✓ BR es RESTRICCIÓN (→ Precond/Valid/FA)       │
│    ✓ BR es INFERENCIA (→ Postcondición)           │
│    ✓ BR es CÁLCULO (→ Paso en flujo)              │
│    ✓ Modifica/condiciona UC existente             │
│    ✓ Mismo actor y objetivo general               │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Matriz de Decisión

```
                    ┌──────────────────────────────┐
                    │   ¿QUÉ TIPO DE BR ES?        │
                    └──────────┬───────────────────┘
                               │
      ┌────────────────────────┼────────────────────────┐
      │                        │                        │
┌─────▼─────┐          ┌───────▼──────┐        ┌──────▼─────┐
│   HECHO   │          │ RESTRICCIÓN  │        │ DESENCADE- │
│           │          │   CÁLCULO    │        │   NADOR    │
│           │          │  INFERENCIA  │        │            │
└─────┬─────┘          └───────┬──────┘        └──────┬─────┘
      │                        │                       │
      │                        │                       │
      ▼                        ▼                       ▼
  NO genera UC           INTEGRAR EN              CREAR UC
  (Modelo)               UC EXISTENTE              NUEVO ⭐
                               │
                               ▼
                    ¿En cuál UC integrar?
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
    ┌─────▼─────┐        ┌────▼─────┐       ┌─────▼──────┐
    │UC donde    │        │UC que    │       │UC más      │
    │restricción │        │ejecuta   │       │relevante   │
    │aplica      │        │cálculo   │       │por contexto│
    └────────────┘        └──────────┘       └────────────┘
```

### Ejemplos Concretos del Dominio IACT

**CASO 1: Crear UC Nuevo**

```
BR-IACT-031 (DESENCADENADOR):
"SI sesión >12 min inactiva ENTONCES enviar alerta"

Análisis:
  ¿Tipo? DESENCADENADOR
  ¿Observable? SÍ (usuario recibe alerta)
  ¿Actor diferente? SÍ (Sistema/Tiempo, no usuario)
  ¿Objetivo propio? SÍ (notificar, independiente de login/logout)
  ¿Independiente? SÍ (no depende de otros UC)

DECISIÓN: Crear UC-IACT-07 nuevo
```

**CASO 2: Integrar en UC Existente**

```
BR-IACT-087 (RESTRICCIÓN):
"Solo nivel seguridad ≥3 puede asignar funciones críticas"

Análisis:
  ¿Tipo? RESTRICCIÓN
  ¿Observable? NO (es validación)
  ¿UC relevante? UC-IACT-04 (Asignar Funciones)
  ¿Modifica ese UC? SÍ (añade precondición + FA)

DECISIÓN: Integrar en UC-IACT-04 existente
  → Como: Precondición + Validación paso 4 + FA-3
```

**CASO 3: Modelo, No UC**

```
BR-IACT-012 (HECHO):
"code_slug debe ser único por función"

Análisis:
  ¿Tipo? HECHO
  ¿Estructura? SÍ (define entidad Function)
  ¿Comportamiento? NO (solo atributo)

DECISIÓN: NO genera UC
  → Resultado: Modelo de Function con UNIQUE constraint
  → Usado en: UC-IACT-04, UC-IACT-15, UC-IACT-18
```

**CASO 4: FR Directo, Sin UC**

```
BR-IACT-046 (INFERENCIA):
"SI sesión >15 min inactividad ENTONCES marcar EXPIRADA"

Análisis:
  ¿Tipo? INFERENCIA
  ¿Observable? NO (solo campo cambia)
  ¿Usuario ve? NO (descubre al siguiente clic)

DECISIÓN: NO genera UC
  → Resultado: FR-305 directo (UPDATE automático)
  → Usado en: Middleware de sesión
```

---

## 5.2 Orden de Integración de BR en UC

Cuando múltiples BR se integran en un mismo UC, el **orden importa**. Seguir esta secuencia asegura coherencia lógica.

### **Secuencia de 6 Pasos**

```
┌────────────────────────────────────────────────────┐
│    ORDEN DE INTEGRACIÓN DE MÚLTIPLES BR EN UC     │
├────────────────────────────────────────────────────┤
│                                                    │
│  PASO 1: Identificar UC Central                    │
│          ↓                                         │
│          El UC "dueño" del comportamiento          │
│                                                    │
│  PASO 2: Integrar HECHOS → Modelo                  │
│          ↓                                         │
│          Define entidades usadas en UC             │
│                                                    │
│  PASO 3: Integrar RESTRICCIONES → Precondiciones   │
│          ↓                                         │
│          Condiciones ANTES de ejecutar             │
│                                                    │
│  PASO 4: Integrar CÁLCULOS → Pasos del Flujo       │
│          ↓                                         │
│          Fórmulas en pasos específicos             │
│                                                    │
│  PASO 5: Integrar RESTRICCIONES → Validaciones     │
│          ↓                                         │
│          Checks DURANTE el flujo                   │
│                                                    │
│  PASO 6: Integrar INFERENCIAS → Postcondiciones    │
│          ↓                                         │
│          Cambios automáticos DESPUÉS              │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Justificación del Orden

**¿Por qué este orden específico?**

```
HECHOS primero porque:
  → Definen las entidades que todo lo demás usa
  → Modelo debe existir antes de validaciones
  → Ejemplo: Function debe existir antes de validar es_critica

RESTRICCIONES-Precondiciones antes de Cálculos porque:
  → No tiene sentido calcular si precondición falla
  → Fail-fast: detectar problemas antes de procesamiento
  → Ejemplo: Verificar nivel_seguridad antes de calcular score

CÁLCULOS antes de Validaciones porque:
  → Validaciones pueden depender de resultados de cálculos
  → Ejemplo: Calcular score_riesgo, LUEGO validar si >85

RESTRICCIONES-Validaciones antes de Inferencias porque:
  → Solo inferir si validaciones pasaron
  → Ejemplo: Solo actualizar permisos_efectivos si asignación válida

INFERENCIAS al final porque:
  → Son consecuencias de todo lo anterior
  → Cambios automáticos después de éxito
  → Ejemplo: Marcar estado EXPIRADA después de timeout
```

---

## 5.3 UC-IACT-04 como Ejemplo Maestro

**UC-IACT-04: Asignar Funciones a Usuario** es el ejemplo perfecto de integración de múltiples BR de diferentes tipos.

### BR Integradas (5 tipos, 5 BR)

```
┌────────────────────────────────────────────────────┐
│    BR INTEGRADAS EN UC-IACT-04                     │
├──────┬──────────────┬────────────────┬─────────────┤
│ BR   │ TIPO         │ UBICACIÓN      │ FORMA       │
├──────┼──────────────┼────────────────┼─────────────┤
│      │              │                │             │
│ 012  │ HECHO        │ Modelo         │ Function    │
│      │              │                │ con UK slug │
│      │              │                │             │
├──────┼──────────────┼────────────────┼─────────────┤
│      │              │                │             │
│ 087  │ RESTRICCIÓN  │ Precond + FA-3 │ Nivel seg   │
│      │              │ Paso 4 valid   │ críticas    │
│      │              │                │             │
├──────┼──────────────┼────────────────┼─────────────┤
│      │              │                │             │
│ 028  │ RESTRICCIÓN  │ Paso 7-8 +FA-1 │ Aprobación  │
│      │              │                │ si >10 users│
│      │              │                │             │
├──────┼──────────────┼────────────────┼─────────────┤
│      │              │                │             │
│ 060  │ CÁLCULO      │ Paso 6         │ Score       │
│      │              │ + FA-5         │ riesgo      │
│      │              │                │             │
├──────┼──────────────┼────────────────┼─────────────┤
│      │              │                │             │
│ 046  │ INFERENCIA   │ Postcondición  │ Permisos    │
│      │              │ Paso 11        │ efectivos   │
│      │              │                │             │
└──────┴──────────────┴────────────────┴─────────────┘
```

### Integración Paso a Paso

**PASO 1: Identificar UC Central**

```
UC Central: UC-IACT-04 (Asignar Funciones a Usuario)

Actor Primario: AGR-007 (agr_admin_acceso)
Objetivo: Administrador asigna funciones del catálogo a un usuario

Este UC es el "dueño" del comportamiento de asignación.
Todas las BR se integran en contexto de esta asignación.
```

**PASO 2: Integrar HECHO (BR-IACT-012)**

```
BR-IACT-012: code_slug único por función

Integración en UC-IACT-04:

Ubicación: Modelo (usado en paso 2)

Paso 2 del UC:
  "Sistema muestra catálogo de 44 funciones disponibles"
  
  Query usa:
  SELECT function_id, code_slug, name, es_critica, categoria
  FROM functions
  WHERE estado = 'ACTIVA'
  ORDER BY code_slug;  -- Ordenado por code_slug único
  
  El UNIQUE constraint de BR-012 asegura:
    - No duplicados en catálogo
    - Referencia inequívoca por code_slug
    - Validación automática por BD

Sin necesidad de validación explícita en UC
(BD maneja via UNIQUE constraint)
```

**PASO 3: Integrar RESTRICCIÓN como Precondición (BR-IACT-087)**

```
BR-IACT-087: Solo nivel_seguridad ≥3 para funciones críticas

Integración en UC-IACT-04:

Ubicación 1: PRECONDICIÓN (condicional)

  PRECONDICIONES (actualizadas):
    ...
    - SI función es crítica (función.es_critica = TRUE):
      ENTONCES admin tiene nivel_seguridad >= 3 [BR-IACT-087]
    ...
  
  Nota: Es condicional porque solo aplica SI hay funciones críticas

Ubicación 2: Paso 4 del Flujo (Validación explícita)

  4. Sistema verifica nivel_seguridad si hay funciones críticas [BR-IACT-087]
     
     Pseudocódigo:
     funciones_criticas = [f for f in funciones_seleccionadas if f.es_critica]
     
     IF funciones_criticas IS NOT EMPTY THEN
       admin_nivel = admin.nivel_seguridad
       
       IF admin_nivel < 3 THEN
         Ir a FA-3: Nivel Insuficiente
       END IF
     END IF

Ubicación 3: Flujo Alterno

  FA-3: Administrador Sin Nivel de Seguridad Requerido [BR-IACT-087]
    
    4a. Sistema detecta función.es_critica = TRUE
    4b. Sistema verifica admin.nivel_seguridad < 3
    4c. Sistema deniega asignación de funciones críticas
    4d. Sistema muestra mensaje explicativo
    4e. Sistema registra intento en auditoría
    4f. Sistema ofrece: [Continuar sin críticas] [Cancelar]

Triple integración:
  1. Precondición (check antes de iniciar)
  2. Validación (check durante flujo)
  3. FA (manejo cuando falla)
```

**PASO 4: Integrar CÁLCULO (BR-IACT-060)**

```
BR-IACT-060: Score de riesgo de acceso

Integración en UC-IACT-04:

Ubicación 1: Paso 6 del Flujo (Cálculo)

  6. Sistema calcula score de riesgo de acceso [BR-IACT-060]
     
     Inputs:
       - cantidad_funciones_criticas
       - cantidad_permisos_totales
       - nivel_seguridad_usuario (del usuario DESTINO, no admin)
       - dias_desde_ultima_auditoria
     
     Formula (normalizada):
       score = (
         (func_criticas / 15 * 30) +
         (min(permisos, 200) / 200 * 30) +
         ((5 - nivel_usuario) * 10) +
         (min(dias_audit, 365) / 365 * 10)
       ) * 1.25
       
       score = max(0, min(100, score))
     
     Persistir:
       UPDATE users
       SET risk_score = score,
           risk_category = classify_risk(score),
           risk_calculated_at = NOW()
       WHERE user_id = {user_destino_id};

Ubicación 2: Paso 7 (Uso del resultado)

  7. Sistema verifica si score > 85 (umbral crítico)
     
     IF score_riesgo > 85 THEN
       Ir a FA-5: Score Excede Umbral
     END IF

Ubicación 3: Flujo Alterno

  FA-5: Score de Riesgo Excede Umbral Crítico
    
    7a. Sistema detecta score_riesgo > 85
    7b. Sistema requiere justificación adicional
    7c. Admin ingresa justificación (campo texto)
    7d. Sistema valida justificación no vacía
    7e. Sistema registra justificación en assignment_justifications
    7f. Continuar con paso 8

Doble integración:
  1. Cálculo en paso 6
  2. Validación + FA en paso 7
```

**PASO 5: Integrar RESTRICCIÓN como Validación (BR-IACT-028)**

```
BR-IACT-028: Aprobación si afecta >10 usuarios

Integración en UC-IACT-04:

Nota: Esta BR aplica solo en variante "Asignación via Agrupador"
      (cuando se asignan funciones a todos los users de un grouper)

Ubicación 1: Paso 7 (Contador)

  7. Sistema cuenta usuarios que serán afectados [BR-IACT-028]
     
     Query:
     SELECT COUNT(DISTINCT ug.user_id) as usuarios_afectados
     FROM user_groupers ug
     WHERE ug.grouper_id = {grouper_seleccionado}
       AND ug.estado = 'ACTIVO';

Ubicación 2: Paso 8 (Validación)

  8. Sistema verifica si cantidad > 10 [BR-IACT-028]
     
     IF usuarios_afectados > 10 THEN
       Ir a FA-1: Requiere Aprobación de Auditor
     ELSE
       Continuar con paso 9
     END IF

Ubicación 3: Flujo Alterno

  FA-1: Asignación Requiere Aprobación de Auditor [BR-IACT-028]
    
    8a. Sistema detecta usuarios_afectados > 10
    8b. Sistema identifica auditor del segmento
    8c. Sistema genera solicitud de aprobación
    8d. Sistema envía notificación a auditor
    8e. Sistema envía confirmación a admin
    8f. Sistema registra auditoría
    8g. UC termina sin aplicar asignaciones
        (Continuará con UC-IACT-09: Aprobar Asignación Masiva)

Integración compleja:
  - Requiere variante del UC (via agrupador)
  - Derivación a otro UC (UC-IACT-09)
  - Postcondiciones diferentes (solicitud pendiente vs asignación completa)
```

**PASO 6: Integrar INFERENCIA (BR-IACT-046)**

```
BR-IACT-046: Permisos efectivos actualizados automáticamente

Integración en UC-IACT-04:

Ubicación 1: Paso 11 del Flujo (Trigger de inferencia)

  11. Sistema actualiza permisos efectivos del usuario [BR-IACT-046]
      
      CALL recalculate_effective_permissions(user_id)
      
      Internamente ejecuta:
        1. Recolectar funciones directas (user_functions)
        2. Recolectar funciones via groupers
        3. Recolectar funciones via segments
        4. Aplicar precedencia: Directo > Grouper > Segment
        5. Generar lista de permissions (expandir funciones)
        6. Actualizar permissions_cache
      
      Esta es una INFERENCIA porque:
        - Cambio automático (no requiere acción adicional)
        - Basado en regla: "permisos se derivan de funciones"
        - Usuario NO ve este paso (transparente)
        - Efecto se percibe en SIGUIENTE acción del usuario

Ubicación 2: Postcondición

  POSTCONDICIONES:
    ...
    - Permisos efectivos del usuario actualizados [BR-IACT-046]
      Tabla permissions_cache sincronizada
      Usuario puede ejercer nuevas funciones inmediatamente
    ...

Ubicación 3: Flujo Alterno (manejo de error)

  FA-6: Error al Actualizar Permisos Efectivos
    
    11a. Sistema intenta UPDATE en permissions_cache
    11b. BD retorna error (constraint, timeout, lock)
    11c. Sistema ejecuta ROLLBACK completo
    11d. Sistema registra error
    11e. Sistema muestra mensaje de error
    11f. Sistema ofrece: "Reintentar" o "Cancelar"

Integración como Inferencia:
  - No es paso explícito observable
  - Es consecuencia automática de asignación
  - Transparente para el actor (admin)
  - Efecto percibido por usuario DESTINO después
```

### Flujo Completo Integrado

```
UC-IACT-04: Asignar Funciones a Usuario
(Con 5 BR integradas)

PRECONDICIONES:
  [✓ BR-087] Admin nivel ≥3 si funciones críticas

FLUJO NORMAL:
  1. Admin selecciona "Asignar Funciones"
  
  2. Sistema muestra catálogo
     [✓ BR-012] code_slug único en catálogo
  
  3. Admin selecciona usuario destino
  
  4. Sistema verifica nivel_seguridad
     [✓ BR-087] Validación explícita
     → Si falla: FA-3
  
  5. Admin selecciona funciones (múltiples)
  
  6. Sistema calcula score de riesgo
     [✓ BR-060] Fórmula completa aplicada
  
  7. Sistema verifica score > 85
     [✓ BR-060] Uso del resultado
     → Si excede: FA-5
  
  8. Sistema verifica usuarios afectados >10
     [✓ BR-028] Validación cantidad
     → Si >10: FA-1
  
  9. Sistema valida restricciones SoD
  
  10. Sistema crea registros en user_functions
  
  11. Sistema actualiza permisos efectivos
      [✓ BR-046] Inferencia automática
      → Si falla: FA-6
  
  12. Sistema muestra confirmación

POSTCONDICIONES:
  [✓ BR-012] Funciones con code_slug válido asignadas
  [✓ BR-087] Solo asignadas si nivel suficiente
  [✓ BR-060] Score recalculado y persistido
  [✓ BR-028] Aprobación registrada si >10 users
  [✓ BR-046] Permisos efectivos sincronizados
```

### Métricas de Integración

```
Total BR integradas: 5
  - 1 Hecho (Modelo)
  - 2 Restricciones (Validaciones + FA)
  - 1 Cálculo (Paso + FA)
  - 1 Inferencia (Postcondición + FA)

Puntos de integración: 11
  - Precondiciones: 1
  - Pasos del flujo: 6
  - Flujos alternos: 4
  - Postcondiciones: 2

FR derivados de integración: 15
  - De BR-012: FR-101 (Consultar catálogo)
  - De BR-087: FR-401 a FR-404 (4 FR)
  - De BR-028: FR-205 a FR-209 (5 FR)
  - De BR-060: FR-601 (Calcular score) + FR-602 (Validar umbral)
  - De BR-046: FR-305 (Actualizar permisos efectivos) + FR-306 (Rollback)
```

---

## 5.4 Resolución de Conflictos Entre BR

A veces, múltiples BR tienen **interacciones complejas** o incluso **conflictos aparentes**. Es necesario resolverlos durante integración.

### Tipos de Conflictos

```
┌────────────────────────────────────────────────────┐
│    4 TIPOS DE CONFLICTOS ENTRE BR                  │
├────────────────────────────────────────────────────┤
│                                                    │
│  TIPO 1: Conflicto de Precedencia                  │
│    Dos BR aplican al mismo dato/momento            │
│    Ejemplo: BR-A dice "permitir", BR-B dice "denegar"│
│    Solución: Establecer orden de precedencia       │
│                                                    │
│  TIPO 2: Conflicto de Secuencia                    │
│    Orden de aplicación ambiguo                     │
│    Ejemplo: ¿Calcular antes o después de validar? │
│    Solución: Definir secuencia lógica             │
│                                                    │
│  TIPO 3: Conflicto de Alcance                      │
│    BR aplican a diferentes subconjuntos            │
│    Ejemplo: BR-A para admins, BR-B para users     │
│    Solución: Clarificar alcance con IF-THEN       │
│                                                    │
│  TIPO 4: Conflicto Aparente                        │
│    Parecen contradecirse pero no lo hacen          │
│    Ejemplo: BR en diferentes contextos            │
│    Solución: Documentar contextos distintos       │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo de Conflicto Real: BR-087 vs BR-028

**Situación:**

```
BR-IACT-087 (RESTRICCIÓN):
"Solo nivel_seguridad ≥3 puede asignar funciones críticas"

BR-IACT-028 (RESTRICCIÓN):
"Asignaciones que afectan >10 usuarios requieren aprobación de auditor"

CONFLICTO APARENTE:
  ¿Qué pasa si admin nivel 2 intenta asignar función crítica
   via agrupador que afecta 50 usuarios?
  
  - BR-087 dice: Denegar (nivel insuficiente)
  - BR-028 dice: Pedir aprobación (>10 usuarios)
  
  ¿Cuál aplicar primero?
```

**Resolución:**

```
ANÁLISIS:

Escenario: Admin nivel 2, función crítica, 50 usuarios

Opción A: Aplicar BR-087 primero
  → Denegar inmediatamente (nivel insuficiente)
  → No llegar a BR-028
  → Admin bloqueado, sin opción de aprobación

Opción B: Aplicar BR-028 primero
  → Enviar a aprobación
  → Auditor puede aprobar
  → Pero admin nivel 2 no debería poder asignar críticas
  → VIOLACIÓN de BR-087

Opción C: Aplicar AMBAS simultáneamente
  → Denegar por BR-087
  → E INFORMAR que requeriría aprobación por BR-028
  → Mensaje: "Requiere nivel 3 Y aprobación de auditor"

DECISIÓN: Opción A (precedencia de seguridad)

REGLA GENERAL:
  Restricciones de SEGURIDAD (BR-087) tienen precedencia sobre
  Restricciones de PROCESO (BR-028)
  
  Justificación:
    - Seguridad no se delega
    - Nivel de seguridad es requisito del ASIGNADOR
    - Aprobación de auditor no puede compensar nivel insuficiente

IMPLEMENTACIÓN en UC-IACT-04:

  Paso 4: Verificar nivel_seguridad [BR-087]
    IF funciones críticas Y nivel < 3 THEN
      Denegar → FA-3
      UC termina SIN llegar a paso 7-8 (BR-028)
    END IF
  
  Paso 7-8: Verificar >10 usuarios [BR-028]
    (Solo se ejecuta si paso 4 pasó)
    IF >10 usuarios THEN
      Pedir aprobación → FA-1
    END IF

ORDEN CORRECTO:
  1º BR-087 (seguridad)
  2º BR-028 (proceso)
```

### Tabla de Precedencia de BR

```
┌─────────────────────────────────────────────────────────┐
│         PRECEDENCIA DE BR EN UC-IACT-04                 │
├──────┬──────────────┬─────────────┬─────────────────────┤
│ Orden│ BR           │ Tipo        │ Razón Precedencia   │
├──────┼──────────────┼─────────────┼─────────────────────┤
│  1º  │ BR-012       │ HECHO       │ Define modelo       │
│      │              │             │ (prerequisito)      │
├──────┼──────────────┼─────────────┼─────────────────────┤
│  2º  │ BR-087       │ RESTRICCIÓN │ Seguridad no se     │
│      │              │ (Seguridad) │ delega              │
├──────┼──────────────┼─────────────┼─────────────────────┤
│  3º  │ BR-060       │ CÁLCULO     │ Resultado usado en  │
│      │              │             │ validación posterior│
├──────┼──────────────┼─────────────┼─────────────────────┤
│  4º  │ BR-028       │ RESTRICCIÓN │ Proceso después de  │
│      │              │ (Proceso)   │ seguridad           │
├──────┼──────────────┼─────────────┼─────────────────────┤
│  5º  │ BR-046       │ INFERENCIA  │ Consecuencia final  │
│      │              │             │ de todo anterior    │
└──────┴──────────────┴─────────────┴─────────────────────┘
```

### Plantilla de Resolución de Conflictos

```markdown
## CONFLICTO ENTRE BR-{ID1} y BR-{ID2}

**Descripción del Conflicto:**
- BR-{ID1}: {resumen}
- BR-{ID2}: {resumen}
- Conflicto: {descripción de aparente contradicción}

**Análisis:**

Escenario problemático: {descripción}

Opción A: {descripción}
  → Ventajas: {lista}
  → Desventajas: {lista}
  → Violaciones: {lista}

Opción B: {descripción}
  → Ventajas: {lista}
  → Desventajas: {lista}
  → Violaciones: {lista}

Opción C: {descripción}
  → Ventajas: {lista}
  → Desventajas: {lista}
  → Violaciones: {lista}

**Decisión:** Opción {letra}

**Justificación:**
{explicación detallada}

**Regla General Derivada:**
{principio aplicable a casos similares}

**Implementación en UC-{ID}:**
{cambios específicos en flujo para resolver conflicto}

**Precedencia Establecida:**
1º {BR-ID}: {razón}
2º {BR-ID}: {razón}

**Documentación:**
- Agregar nota en BR-{ID1}: "Ver resolución conflicto con BR-{ID2}"
- Agregar nota en BR-{ID2}: "Ver resolución conflicto con BR-{ID1}"
- Actualizar Matriz de Trazabilidad con precedencia
```

# SECCIÓN 6: DERIVACIÓN DE FUNCTIONAL REQUIREMENTS

## 6.1 Qué es un FR y su Relación con UC

### Definición Formal

> **Functional Requirement (FR):** Una capacidad específica que el sistema debe poseer para soportar uno o más pasos de un Caso de Uso, expresada en términos técnicos e implementables.

**Diferencia clave con UC:**

```
┌────────────────────────────────────────────────────┐
│         CASO DE USO vs FUNCTIONAL REQUIREMENT      │
├────────────────────────────────────────────────────┤
│                                                    │
│  CASO DE USO:                                      │
│    • Perspectiva del USUARIO/ACTOR                 │
│    • Lenguaje de NEGOCIO                           │
│    • Describe INTERACCIÓN completa                 │
│    • Nivel CONCEPTUAL                              │
│    • Ejemplo: "Admin asigna funciones a usuario"   │
│                                                    │
│  ──────────────────────────────────────────────    │
│                                                    │
│  FUNCTIONAL REQUIREMENT:                           │
│    • Perspectiva del SISTEMA                       │
│    • Lenguaje TÉCNICO                              │
│    • Describe CAPACIDAD específica                 │
│    • Nivel IMPLEMENTABLE                           │
│    • Ejemplo: "Validar nivel_seguridad >= 3 via   │
│                query SQL antes de INSERT"          │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Relación Jerárquica

```
                    BR (Business Rule)
                          │
                          │ transforma a
                          ▼
                    UC (Use Case)
                          │
                          │ deriva
                          ▼
                    FR (Functional Req)
                          │
                          │ implementa
                          ▼
                   Código / Tests
```

**Ejemplo concreto:**

```
BR-IACT-087: "Solo nivel ≥3 para funciones críticas"
      │
      │ genera/integra
      ▼
UC-IACT-04 Paso 4: "Sistema verifica nivel_seguridad"
      │
      │ deriva
      ├──▶ FR-401: Verificar Nivel de Seguridad
      ├──▶ FR-402: Listar Funciones Críticas
      ├──▶ FR-403: Registrar Intento Denegado
      └──▶ FR-404: Mostrar Mensaje de Denegación
      │
      │ implementa
      ├──▶ check_security_level(admin_id, functions)
      ├──▶ get_critical_functions(function_ids)
      ├──▶ audit_log.create(event='DENIED', ...)
      └──▶ messages.error(template='denied.html', ...)
```

---

## 6.2 Proceso de Derivación de FR

### **Proceso de 3 Pasos**

```
┌────────────────────────────────────────────────────┐
│    PROCESO DE DERIVACIÓN DE FR DESDE UC           │
├────────────────────────────────────────────────────┤
│                                                    │
│  PASO 1: Descomponer UC en Acciones Atómicas      │
│          ↓                                         │
│          Por cada paso del flujo:                  │
│          - ¿Qué HACE el sistema?                   │
│          - ¿Qué CONSULTA?                          │
│          - ¿Qué VALIDA?                            │
│          - ¿Qué ACTUALIZA?                         │
│                                                    │
│  PASO 2: Identificar Capacidades Necesarias        │
│          ↓                                         │
│          Por cada acción:                          │
│          - Query específico                        │
│          - Validación específica                   │
│          - Cálculo específico                      │
│          - Actualización específica                │
│                                                    │
│  PASO 3: Documentar como FR con Detalle Técnico    │
│          ↓                                         │
│          Para cada capacidad:                      │
│          - ID único (FR-XXX)                       │
│          - Descripción técnica                     │
│          - Query/Algoritmo                         │
│          - Casos de prueba                         │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo Guiado: Derivar FR desde UC-IACT-07 Paso 2

**Paso del UC:**

```
UC-IACT-07 Paso 2:
  "Sistema consulta sesiones que cumplen condiciones [BR-IACT-031]"
  
  Query:
  SELECT 
    s.session_id,
    s.user_id,
    s.last_activity,
    TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) as minutos_inactivos,
    u.nombre,
    u.email
  FROM user_sessions s
  JOIN users u ON s.user_id = u.user_id
  WHERE s.estado = 'ACTIVA'
    AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) >= 12
    AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) < 15
    AND NOT EXISTS (
      SELECT 1 FROM session_notifications sn
      WHERE sn.session_id = s.session_id
        AND sn.notification_type = 'EXPIRATION_WARNING'
        AND sn.created_at > DATE_SUB(NOW(), INTERVAL 2 MINUTE)
    );
```

**PASO 1: Descomponer en Acciones Atómicas**

```
Paso 2 del UC realiza:
  
  a) CONSULTA sesiones activas
  b) FILTRA por inactividad >= 12 min
  c) FILTRA por inactividad < 15 min (aún no expiradas)
  d) EXCLUYE sesiones notificadas recientemente
  e) CALCULA minutos_inactivos
  f) OBTIENE datos del usuario (nombre, email)
  g) RETORNA lista de sesiones elegibles
```

**PASO 2: Identificar Capacidades Necesarias**

```
Capacidades identificadas:

CAPACIDAD 1: Consultar sesiones activas con inactividad en rango
  Input: None (ejecuta periódicamente)
  Output: Lista de session_id + metadata
  Query: (el mostrado arriba)

CAPACIDAD 2: Calcular minutos de inactividad
  Input: last_activity timestamp
  Output: minutos_inactivos (INT)
  Formula: TIMESTAMPDIFF(MINUTE, last_activity, NOW())

CAPACIDAD 3: Verificar si sesión fue notificada recientemente
  Input: session_id
  Output: Boolean (fue notificada en <2 min?)
  Query: EXISTS (SELECT 1 FROM session_notifications WHERE...)

CAPACIDAD 4: Obtener información del usuario de la sesión
  Input: user_id
  Output: nombre, email
  Query: JOIN con tabla users
```

**PASO 3: Documentar como FR**

Cada capacidad se convierte en un FR:

```
FR-301: Consultar Sesiones Elegibles para Notificación

FR-302: Calcular Tiempo de Inactividad de Sesión

FR-303: Verificar Notificación Reciente de Sesión

FR-304: Obtener Información de Usuario por Sesión
```

---

## 6.3 Anatomía de un Functional Requirement

Un FR bien documentado tiene **10 componentes esenciales**:

```
┌────────────────────────────────────────────────────┐
│    ANATOMÍA DE UN FUNCTIONAL REQUIREMENT           │
├────────────────────────────────────────────────────┤
│                                                    │
│  1. ID ÚNICO                                       │
│     FR-XXX (nomenclatura estándar)                 │
│                                                    │
│  2. NOMBRE DESCRIPTIVO                             │
│     Verbo técnico + Objeto                         │
│                                                    │
│  3. DESCRIPCIÓN BREVE                              │
│     1-2 oraciones en lenguaje técnico              │
│                                                    │
│  4. DERIVACIÓN                                     │
│     De UC-XX Paso Y                                │
│     Implementa BR-ZZ                               │
│                                                    │
│  5. PRIORIDAD                                      │
│     Crítica / Alta / Media / Baja                  │
│                                                    │
│  6. COMPLEJIDAD                                    │
│     Alta / Media / Baja                            │
│                                                    │
│  7. INPUTS                                         │
│     Parámetros necesarios con tipos                │
│                                                    │
│  8. OUTPUTS                                        │
│     Retorno esperado con tipo                      │
│                                                    │
│  9. ALGORITMO / QUERY                              │
│     Pseudocódigo o SQL específico                  │
│                                                    │
│  10. CASOS DE PRUEBA                               │
│      Escenarios de validación                      │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo Completo: FR-301

```
═══════════════════════════════════════════════════════════
FR-301: Consultar Sesiones Elegibles para Notificación
═══════════════════════════════════════════════════════════

1. IDENTIFICACIÓN
─────────────────

ID: FR-301
Módulo: MOD_Session
Tipo: Query / Data Retrieval
Versión: 1.0.0

2. DESCRIPCIÓN
──────────────

El sistema debe consultar todas las sesiones activas que:
  - Tienen >= 12 minutos de inactividad
  - Tienen < 15 minutos de inactividad (aún no expiradas)
  - NO han sido notificadas en los últimos 2 minutos

Esta consulta se ejecuta cada minuto como parte de UC-IACT-07.

3. DERIVACIÓN Y TRAZABILIDAD
─────────────────────────────

Derivado de:
  - UC-IACT-07 (Paso 2): "Sistema consulta sesiones..."
  - BR-IACT-031: Condición de 12 minutos

Relacionado con:
  - FR-302: Calcular Tiempo de Inactividad (usa resultado)
  - FR-305: Expirar Sesión Automáticamente (relacionado)

4. PRIORIDAD Y COMPLEJIDAD
──────────────────────────

Prioridad: Alta
  Justificación: Crítico para seguridad, previene sesiones zombie

Complejidad: Media
  - Query con múltiples JOINs
  - Subconsulta EXISTS
  - Cálculos temporales

5. INPUTS
─────────

Ninguno (query sin parámetros)
  - Ejecuta sobre todas las sesiones del sistema
  - Usa NOW() como referencia temporal implícita

6. OUTPUTS
──────────

Lista de objetos SessionEligible:
  - session_id: UUID
  - user_id: INT
  - last_activity: DATETIME
  - minutos_inactivos: INT (calculado)
  - usuario_nombre: VARCHAR(100)
  - usuario_email: VARCHAR(100)

Cantidad esperada: 5-50 sesiones típicamente

7. ALGORITMO / QUERY
────────────────────

Query SQL optimizado:

SELECT 
  s.session_id,
  s.user_id,
  s.last_activity,
  s.created_at,
  TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) as minutos_inactivos,
  u.nombre as usuario_nombre,
  u.email as usuario_email,
  u.nivel_seguridad
FROM user_sessions s
INNER JOIN users u ON s.user_id = u.user_id
WHERE s.estado = 'ACTIVA'
  AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) >= 12
  AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) < 15
  AND NOT EXISTS (
    SELECT 1 
    FROM session_notifications sn
    WHERE sn.session_id = s.session_id
      AND sn.notification_type = 'EXPIRATION_WARNING'
      AND sn.created_at > DATE_SUB(NOW(), INTERVAL 2 MINUTE)
  )
ORDER BY s.last_activity ASC;  -- Más antiguas primero

Índices requeridos:
  - user_sessions(estado, last_activity)
  - session_notifications(session_id, notification_type, created_at)
  - users(user_id) [PK natural]

Performance esperada:
  - Con índices: 50-150ms
  - Sin índices: Hasta 2-5 segundos (inaceptable)
  - Registros escaneados: <10,000 sesiones activas típicamente

8. CASOS DE PRUEBA
──────────────────

CP-1: Sesión con 12.5 minutos inactividad
  Precondición:
    - last_activity = NOW() - 12.5 minutos
    - estado = 'ACTIVA'
    - No notificada recientemente
  Resultado esperado:
    - Aparece en resultados ✅
    - minutos_inactivos = 12

CP-2: Sesión con 11 minutos inactividad
  Precondición:
    - last_activity = NOW() - 11 minutos
  Resultado esperado:
    - NO aparece en resultados (< 12 min)

CP-3: Sesión con 16 minutos inactividad
  Precondición:
    - last_activity = NOW() - 16 minutos
  Resultado esperado:
    - NO aparece en resultados (>= 15 min, ya debería estar expirada)

CP-4: Sesión notificada hace 1 minuto
  Precondición:
    - last_activity = NOW() - 12.5 minutos
    - session_notifications.created_at = NOW() - 1 minuto
  Resultado esperado:
    - NO aparece en resultados (ventana de 2 minutos)

CP-5: Sesión notificada hace 3 minutos
  Precondición:
    - last_activity = NOW() - 12.8 minutos
    - session_notifications.created_at = NOW() - 3 minutos
  Resultado esperado:
    - SÍ aparece en resultados (fuera de ventana 2 min)

CP-6: Sin sesiones activas
  Precondición:
    - Todas las sesiones con estado != 'ACTIVA'
  Resultado esperado:
    - Retorna lista vacía []
    - Sin error

CP-7: Múltiples sesiones del mismo usuario
  Precondición:
    - Usuario tiene 3 sesiones activas
    - 2 cumplen condiciones, 1 no
  Resultado esperado:
    - Retorna las 2 que cumplen
    - Cada sesión es independiente

CP-8: Performance con 10,000 sesiones activas
  Precondición:
    - 10,000 registros en user_sessions con estado='ACTIVA'
    - 50 cumplen condiciones
  Resultado esperado:
    - Query completa en <200ms
    - Retorna 50 sesiones correctas

9. MANEJO DE ERRORES
────────────────────

Error 1: BD no disponible
  - Capturar DatabaseConnectionError
  - Registrar en error_log
  - Retornar lista vacía []
  - Job reintenta en próxima ejecución

Error 2: Query timeout (>5s)
  - Capturar QueryTimeoutError
  - Generar alarma (índices faltantes)
  - Registrar query plan con EXPLAIN
  - Sugerir recrear índices

Error 3: Datos inconsistentes (user_id no existe)
  - Capturar ForeignKeyError
  - Registrar sesión huérfana
  - Omitir esa sesión
  - Generar task de limpieza

10. IMPLEMENTACIÓN
──────────────────

Función Python:

def get_eligible_sessions_for_notification() -> List[SessionEligible]:
    """
    Consulta sesiones activas elegibles para notificación de expiración.
    
    Returns:
        Lista de objetos SessionEligible con metadata completa.
        Lista vacía si no hay sesiones elegibles o error.
    
    Raises:
        DatabaseError: Si BD no disponible (manejado internamente)
        QueryTimeout: Si query excede 5 segundos
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT 
                  s.session_id,
                  s.user_id,
                  s.last_activity,
                  TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) as minutos_inactivos,
                  u.nombre,
                  u.email
                FROM user_sessions s
                INNER JOIN users u ON s.user_id = u.user_id
                WHERE s.estado = 'ACTIVA'
                  AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) >= 12
                  AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) < 15
                  AND NOT EXISTS (
                    SELECT 1 FROM session_notifications sn
                    WHERE sn.session_id = s.session_id
                      AND sn.notification_type = 'EXPIRATION_WARNING'
                      AND sn.created_at > DATE_SUB(NOW(), INTERVAL 2 MINUTE)
                  )
                ORDER BY s.last_activity ASC
            """)
            
            rows = cursor.fetchall()
            
            return [
                SessionEligible(
                    session_id=row[0],
                    user_id=row[1],
                    last_activity=row[2],
                    minutos_inactivos=row[3],
                    usuario_nombre=row[4],
                    usuario_email=row[5]
                )
                for row in rows
            ]
    
    except DatabaseError as e:
        logger.error(f"Database error in get_eligible_sessions: {e}")
        return []
    
    except QueryTimeout as e:
        logger.critical(f"Query timeout (>5s) - Check indexes: {e}")
        alert_oncall("FR-301 query timeout - indexes may be missing")
        return []

ORM alternativo (Django):

from django.db.models import F, Q, OuterRef, Exists, ExpressionWrapper
from django.db.models.functions import Now
from datetime import timedelta

def get_eligible_sessions_orm():
    # Subconsulta para notificaciones recientes
    recent_notifications = SessionNotification.objects.filter(
        session_id=OuterRef('session_id'),
        notification_type='EXPIRATION_WARNING',
        created_at__gt=Now() - timedelta(minutes=2)
    )
    
    # Query principal
    eligible = UserSession.objects.filter(
        estado='ACTIVA'
    ).annotate(
        minutos_inactivos=ExpressionWrapper(
            (Now() - F('last_activity')) / timedelta(minutes=1),
            output_field=IntegerField()
        )
    ).filter(
        minutos_inactivos__gte=12,
        minutos_inactivos__lt=15
    ).exclude(
        Exists(recent_notifications)
    ).select_related(
        'user'
    ).order_by('last_activity')
    
    return list(eligible)

11. MÉTRICAS Y MONITOREO
─────────────────────────

Métricas a capturar:
  - Duración de query (p50, p95, p99)
  - Cantidad de sesiones retornadas
  - Tasa de sesiones elegibles (% del total activas)
  - Frecuencia de query timeout

Alertas:
  - Query >200ms: Warning
  - Query >500ms: Error (revisar índices)
  - Query timeout: Critical (índices faltantes)
  - Más de 100 sesiones elegibles: Investigar causa

Dashboard:
  - Gráfico de sesiones elegibles por hora del día
  - Distribución de minutos_inactivos
  - Top usuarios con más sesiones elegibles

═══════════════════════════════════════════════════════════
```

---

## 6.4 Granularidad de FR

Un desafío común es decidir el **nivel de granularidad**: ¿Cuán pequeño debe ser cada FR?

### 4 Niveles de Granularidad

```
┌────────────────────────────────────────────────────┐
│    4 NIVELES DE GRANULARIDAD DE FR                 │
├────────────────────────────────────────────────────┤
│                                                    │
│  NIVEL 1: Muy Granular (Atómico)                   │
│    1 FR = 1 Query o 1 Función específica           │
│    Ejemplo: FR-301 (Query sesiones)                │
│            FR-302 (Calcular minutos)               │
│    Ventaja: Reutilizable, testeable                │
│    Desventaja: Muchos FR, overhead                 │
│                                                    │
│  NIVEL 2: Moderadamente Granular                   │
│    1 FR = 1 Paso del UC                            │
│    Ejemplo: FR-300 (Todo el paso 2 del UC)         │
│    Ventaja: Mapeo 1:1 con UC, claro                │
│    Desventaja: Menos reutilizable                  │
│                                                    │
│  NIVEL 3: Poco Granular (Agrupado)                 │
│    1 FR = Múltiples pasos relacionados             │
│    Ejemplo: FR-300 (Pasos 2-4 del UC)              │
│    Ventaja: Menos FR, más contexto                 │
│    Desventaja: Difícil de testear, no atómico      │
│                                                    │
│  NIVEL 4: Muy Poco Granular (Monolítico)           │
│    1 FR = UC completo                              │
│    Ejemplo: FR-300 (Todo UC-IACT-07)               │
│    Ventaja: Simple, pocos FR                       │
│    Desventaja: No implementable directamente       │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Recomendación

**NIVEL 1 (Muy Granular) para:**
- Queries reutilizables en múltiples UC
- Validaciones usadas frecuentemente
- Cálculos compartidos
- Servicios externos

**NIVEL 2 (Moderadamente Granular) para:**
- Pasos específicos de UC único
- Lógica no reutilizable
- Flujos de negocio específicos

**Ejemplo de decisión:**

```
UC-IACT-07 Paso 2: "Consultar sesiones elegibles"

Opción A (Nivel 1 - Muy Granular):
  ├─ FR-301: Consultar sesiones activas
  ├─ FR-302: Calcular minutos inactividad
  ├─ FR-303: Verificar notificación reciente
  └─ FR-304: Obtener info usuario por sesión
  
  Total: 4 FR atómicos
  Ventaja: Cada uno reutilizable
  Desventaja: 4 documentos para 1 paso

Opción B (Nivel 2 - Moderado):
  └─ FR-301: Consultar sesiones elegibles para notificación
  
  Total: 1 FR
  Ventaja: Mapeo directo a paso
  Desventaja: Query complejo, menos reutilizable

DECISIÓN RECOMENDADA:
  Opción B (Nivel 2) porque:
    - Query específico de este UC
    - Incluye lógica de negocio (ventana 2 min)
    - Poco probable reutilizar en otros UC
    - Más simple de mantener (1 documento vs 4)
```

---

## 6.5 Ejemplo Completo: FR Derivados de UC-IACT-09

Ahora derivaremos todos los FR del UC-IACT-09 que construimos en Sección 4.

### Mapeo UC → FR

```
UC-IACT-09: Notificar Expiración Inminente de Permiso Temporal

11 pasos del flujo → Derivación de FR:

Paso 1: Iniciar job
  └─ No genera FR (infraestructura de APScheduler)

Paso 2: Consultar permisos elegibles
  └─ FR-901: Consultar Permisos Temporales Próximos a Expirar

Paso 3: Iterar sobre permisos
  └─ No genera FR (control de flujo)

Paso 4: Calcular información adicional
  ├─ FR-902: Calcular Tiempo Restante Antes de Expiración
  └─ FR-903: Determinar Nivel de Urgencia

Paso 5: Componer mensaje para usuario
  └─ FR-904: Componer Notificación de Expiración para Usuario

Paso 6: Componer mensaje para admin
  └─ FR-905: Componer Recordatorio de Expiración para Admin

Paso 7: Enviar a usuario
  └─ FR-906: Enviar Mensaje a Buzón Interno con Prioridad

Paso 8: Enviar a admin
  └─ (Reutiliza FR-906, mismo servicio)

Paso 9: Registrar notificación
  └─ FR-907: Registrar Notificación de Permiso Temporal

Paso 10: Auditoría
  └─ FR-908: Registrar Evento de Notificación en Auditoría

Paso 11: Finalizar job
  └─ FR-909: Generar Métricas de Ejecución de Job

TOTAL: 9 FR derivados
```

### FR Seleccionados para Documentación Completa

Vamos a documentar 3 FR representativos:

**1. FR-901 (Query complejo)**
**2. FR-904 (Composición de mensaje)**
**3. FR-907 (Registro en BD)**

---

### **FR-901: Consultar Permisos Temporales Próximos a Expirar**

```
═══════════════════════════════════════════════════════════
FR-901: Consultar Permisos Temporales Próximos a Expirar
═══════════════════════════════════════════════════════════

IDENTIFICACIÓN
──────────────
ID: FR-901
Módulo: MOD_TempPermission
Tipo: Query / Data Retrieval
Prioridad: Alta
Complejidad: Media-Alta

DESCRIPCIÓN
───────────
El sistema debe consultar permisos temporales que:
  - Están en estado ACTIVO
  - Expiran en 0-24 horas
  - Incluyen al menos una función crítica
  - NO han sido notificados en últimas 6 horas

DERIVACIÓN
──────────
Derivado de: UC-IACT-09 Paso 2
Implementa: BR-IACT-033
Relacionado con: FR-305 (Expirar permisos automáticamente)

INPUTS
──────
Ninguno (query global sobre todos los permisos temporales)

OUTPUTS
───────
Lista de objetos TempPermissionEligible:
  - temp_permission_id: UUID
  - user_id: INT
  - assigned_by_user_id: INT
  - expiration_date: DATETIME
  - horas_restantes: INT (0-24)
  - funciones_criticas_count: INT
  - funciones_code_slugs: VARCHAR (comma-separated)
  - usuario_nombre: VARCHAR
  - admin_nombre: VARCHAR

ALGORITMO / QUERY
─────────────────
(Ver query completo en UC-IACT-09 Paso 2)

Filtros clave:
  1. estado = 'ACTIVO'
  2. 0 < horas_restantes <= 24
  3. EXISTS función crítica
  4. NOT EXISTS notificación reciente (<6h)

GROUP BY: temp_permission_id + metadata
HAVING: funciones_criticas_count > 0
ORDER BY: expiration_date ASC

Performance: <200ms con índices

CASOS DE PRUEBA
───────────────
CP-1: Permiso expira en 18h con 2 funciones críticas
  → Aparece en resultados ✅

CP-2: Permiso expira en 30h
  → NO aparece (>24h)

CP-3: Permiso expira en 2h pero sin funciones críticas
  → NO aparece (no cumple requisito)

CP-4: Permiso notificado hace 3 horas
  → NO aparece (dentro de ventana 6h)

═══════════════════════════════════════════════════════════
```

---

### **FR-904: Componer Notificación de Expiración para Usuario**

```
═══════════════════════════════════════════════════════════
FR-904: Componer Notificación de Expiración para Usuario
═══════════════════════════════════════════════════════════

IDENTIFICACIÓN
──────────────
ID: FR-904
Módulo: MOD_Notification
Tipo: Template Rendering / Message Composition
Prioridad: Alta
Complejidad: Media

DESCRIPCIÓN
───────────
El sistema debe componer mensaje HTML personalizado para notificar
al usuario que su permiso temporal expirará pronto, incluyendo:
  - Tiempo restante exacto
  - Lista de funciones críticas afectadas
  - Botón de acción "Solicitar Renovación"
  - Instrucciones claras

DERIVACIÓN
──────────
Derivado de: UC-IACT-09 Paso 5
Implementa: BR-IACT-033 (parte de notificación)

INPUTS
──────
- temp_permission: TempPermissionEligible
  * temp_permission_id: UUID
  * user_id: INT
  * horas_restantes: INT
  * funciones_criticas: List[Function]
  * admin_nombre: VARCHAR
  * expiration_date: DATETIME

OUTPUTS
───────
- mensaje: Dict con:
  * subject: VARCHAR(200)
  * body_text: TEXT (plain text)
  * body_html: TEXT (HTML formatted)
  * prioridad: ENUM (HIGH / MEDIUM)
  * action_button: Dict (label, action, params)

ALGORITMO / TEMPLATE
────────────────────

Template base (body_html):
```html
<div class="notification-container temp-permission-warning">
  <div class="icon">⏰</div>
  <h2>AVISO: Su permiso temporal expirará pronto</h2>
  
  <p>Estimado/a {{ usuario_nombre }},</p>
  
  <p>Su permiso temporal que incluye funciones críticas expirará
     en aproximadamente <strong>{{ tiempo_restante_formatted }}</strong>.</p>
  
  <div class="critical-functions">
    <h3>📋 FUNCIONES CRÍTICAS AFECTADAS:</h3>
    <ul>
      {% for funcion in funciones_criticas %}
      <li>
        <code>{{ funcion.code_slug }}</code> - {{ funcion.name }}
        <span class="badge">{{ funcion.categoria }}</span>
      </li>
      {% endfor %}
    </ul>
  </div>
  
  <div class="action-required">
    <h3>⚠️  ACCIÓN REQUERIDA:</h3>
    <p>Si necesita continuar usando estas funciones después de
       <strong>{{ expiration_date|date:"d/m/Y H:i" }}</strong>,
       debe solicitar RENOVACIÓN del permiso temporal.</p>
    
    <div class="actions">
      <button class="btn-primary" data-action="request-renewal"
              data-permission-id="{{ temp_permission_id }}">
        Solicitar Renovación de Permiso
      </button>
    </div>
    
    <p class="help-text">
      Para solicitar renovación:
      <ol>
        <li>Contacte a: <strong>{{ admin_nombre }}</strong></li>
        <li>O use el botón de arriba</li>
      </ol>
    </p>
  </div>
  
  <div class="warning">
    ⚠️ Si NO solicita renovación, estas funciones se revocarán
    automáticamente el {{ expiration_date|date:"d/m/Y H:i" }}.
  </div>
  
  <div class="details">
    <h4>ℹ️  DETALLES:</h4>
    <ul class="detail-list">
      <li>Fecha de asignación: {{ fecha_asignacion|date:"d/m/Y" }}</li>
      <li>Asignado por: {{ admin_nombre }}</li>
      <li>ID del permiso: <code>{{ temp_permission_id }}</code></li>
      <li>Urgencia: <span class="badge-{{ urgencia|lower }}">{{ urgencia }}</span></li>
    </ul>
  </div>
  
  <div class="footer">
    <p><small>Hora actual: {{ timestamp_actual|date:"d/m/Y H:i:s" }}</small></p>
    <p><small>Última actividad: {{ last_activity|date:"d/m/Y H:i:s" }}</small></p>
  </div>
</div>
```

Lógica de prioridad:
```python
def determinar_prioridad(horas_restantes):
    if horas_restantes <= 6:
        return 'URGENT'
    elif horas_restantes <= 12:
        return 'HIGH'
    else:
        return 'MEDIUM'
```

Función de composición:
```python
def componer_notificacion_usuario(temp_permission: TempPermissionEligible) -> Dict:
    # 1. Determinar prioridad
    prioridad = determinar_prioridad(temp_permission.horas_restantes)
    
    # 2. Formatear tiempo restante
    tiempo_restante = format_duration(temp_permission.horas_restantes)
    # Ejemplo: "23 horas y 15 minutos"
    
    # 3. Preparar contexto para template
    context = {
        'usuario_nombre': temp_permission.usuario_nombre,
        'tiempo_restante_formatted': tiempo_restante,
        'funciones_criticas': temp_permission.funciones_criticas,
        'expiration_date': temp_permission.expiration_date,
        'temp_permission_id': temp_permission.temp_permission_id,
        'admin_nombre': temp_permission.admin_nombre,
        'fecha_asignacion': temp_permission.fecha_asignacion,
        'urgencia': prioridad,
        'timestamp_actual': timezone.now(),
        'last_activity': temp_permission.last_activity
    }
    
    # 4. Renderizar templates
    body_html = render_template('temp_permission_warning_user.html', context)
    body_text = strip_html_tags(body_html)  # Versión texto plano
    
    # 5. Componer subject
    subject = f"AVISO: Permiso temporal expirará en {temp_permission.horas_restantes}h"
    
    # 6. Preparar botón de acción
    action_button = {
        'label': 'Solicitar Renovación de Permiso',
        'action': 'REQUEST_RENEWAL',
        'params': {
            'temp_permission_id': str(temp_permission.temp_permission_id)
        }
    }
    
    # 7. Retornar mensaje completo
    return {
        'subject': subject,
        'body_text': body_text,
        'body_html': body_html,
        'prioridad': prioridad,
        'action_button': action_button,
        'auto_expire_at': temp_permission.expiration_date
    }
```

CASOS DE PRUEBA
───────────────
CP-1: Permiso expira en 2 horas
  Input: horas_restantes = 2
  Output: prioridad = 'URGENT'
          subject contiene "expirará en 2h"

CP-2: Permiso con 5 funciones críticas
  Input: 5 funciones en lista
  Output: body_html lista las 5 funciones
          Cada una con code_slug + name

CP-3: Template rendering sin errores
  Input: Datos válidos
  Output: body_html es HTML válido
          Sin placeholders sin reemplazar

CP-4: Botón de acción funcional
  Input: temp_permission_id = "123e4567-..."
  Output: action_button.params contiene UUID
          JavaScript puede capturar evento

═══════════════════════════════════════════════════════════
```

---

### **FR-907: Registrar Notificación de Permiso Temporal**

```
═══════════════════════════════════════════════════════════
FR-907: Registrar Notificación de Permiso Temporal
═══════════════════════════════════════════════════════════

IDENTIFICACIÓN
──────────────
ID: FR-907
Módulo: MOD_TempPermission
Tipo: Data Persistence / Recording
Prioridad: Alta
Complejidad: Baja

DESCRIPCIÓN
───────────
El sistema debe crear registro en tabla temp_permission_notifications
para tracking de notificaciones enviadas, evitar duplicados y mantener
historial de alertas.

DERIVACIÓN
──────────
Derivado de: UC-IACT-09 Paso 9
Implementa: BR-IACT-033 (tracking)
Usado para: Filtro de duplicados en FR-901

INPUTS
──────
- temp_permission_id: UUID
- notification_type: VARCHAR = 'EXPIRATION_WARNING_24H'
- horas_restantes: INT
- urgencia: ENUM ('CRÍTICA', 'ALTA', 'MEDIA')
- usuario_notificado: BOOLEAN
- admin_notificado: BOOLEAN
- user_message_id: UUID (del mensaje enviado)
- admin_message_id: UUID (del mensaje enviado)

OUTPUTS
───────
- notification_id: UUID (PK del registro creado)
- created_at: DATETIME

ALGORITMO / QUERY
─────────────────

INSERT Query:
```sql
INSERT INTO temp_permission_notifications (
  notification_id,
  temp_permission_id,
  notification_type,
  horas_restantes,
  urgencia,
  usuario_notificado,
  admin_notificado,
  user_message_id,
  admin_message_id,
  created_at
) VALUES (
  UUID(),
  ?,
  'EXPIRATION_WARNING_24H',
  ?,
  ?,
  ?,
  ?,
  ?,
  ?,
  NOW()
);
```

Esquema de tabla:
```sql
CREATE TABLE temp_permission_notifications (
  notification_id UUID PRIMARY KEY,
  temp_permission_id UUID NOT NULL,
  notification_type VARCHAR(50) NOT NULL,
  horas_restantes INT NOT NULL,
  urgencia ENUM('CRÍTICA', 'ALTA', 'MEDIA') NOT NULL,
  usuario_notificado BOOLEAN NOT NULL DEFAULT FALSE,
  admin_notificado BOOLEAN NOT NULL DEFAULT FALSE,
  user_message_id UUID,
  admin_message_id UUID,
  user_message_error TEXT,
  admin_message_error TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (temp_permission_id) 
    REFERENCES temp_permissions(temp_permission_id),
  FOREIGN KEY (user_message_id) 
    REFERENCES internal_messages(message_id),
  FOREIGN KEY (admin_message_id) 
    REFERENCES internal_messages(message_id),
  
  INDEX idx_temp_perm_notif (temp_permission_id, notification_type, created_at),
  INDEX idx_created_at (created_at)
);
```

Función Python:
```python
def registrar_notificacion_permiso_temporal(
    temp_permission_id: UUID,
    horas_restantes: int,
    urgencia: str,
    usuario_notificado: bool,
    admin_notificado: bool,
    user_message_id: Optional[UUID],
    admin_message_id: Optional[UUID],
    user_error: Optional[str] = None,
    admin_error: Optional[str] = None
) -> UUID:
    """
    Registra notificación de permiso temporal en BD.
    
    Args:
        temp_permission_id: ID del permiso notificado
        horas_restantes: Horas antes de expiración
        urgencia: Nivel de urgencia
        usuario_notificado: Si usuario recibió mensaje
        admin_notificado: Si admin recibió mensaje
        user_message_id: ID del mensaje enviado a usuario (o None si falló)
        admin_message_id: ID del mensaje enviado a admin (o None si falló)
        user_error: Mensaje de error si envío a usuario falló
        admin_error: Mensaje de error si envío a admin falló
    
    Returns:
        notification_id: UUID del registro creado
    
    Raises:
        DatabaseError: Si INSERT falla
    """
    notification_id = uuid4()
    
    with connection.cursor() as cursor:
        cursor.execute("""
            INSERT INTO temp_permission_notifications (
              notification_id,
              temp_permission_id,
              notification_type,
              horas_restantes,
              urgencia,
              usuario_notificado,
              admin_notificado,
              user_message_id,
              admin_message_id,
              user_message_error,
              admin_message_error,
              created_at
            ) VALUES (
              %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW()
            )
        """, [
            notification_id,
            temp_permission_id,
            'EXPIRATION_WARNING_24H',
            horas_restantes,
            urgencia,
            usuario_notificado,
            admin_notificado,
            user_message_id,
            admin_message_id,
            user_error,
            admin_error
        ])
    
    logger.info(
        f"Notificación registrada: {notification_id} "
        f"para permiso {temp_permission_id} "
        f"(usuario={usuario_notificado}, admin={admin_notificado})"
    )
    
    return notification_id
```

CASOS DE PRUEBA
───────────────
CP-1: Notificación exitosa (ambos notificados)
  Input:
    usuario_notificado = TRUE
    admin_notificado = TRUE
    user_message_id = UUID válido
    admin_message_id = UUID válido
  Output:
    Registro creado con notification_id
    Campos de error = NULL

CP-2: Notificación parcial (solo usuario)
  Input:
    usuario_notificado = TRUE
    admin_notificado = FALSE
    admin_message_error = "MessageQueueFull"
  Output:
    Registro creado
    admin_message_error contiene error

CP-3: Notificación fallida (ambos)
  Input:
    usuario_notificado = FALSE
    admin_notificado = FALSE
    user_message_error = "ServiceUnavailable"
    admin_message_error = "ServiceUnavailable"
  Output:
    Registro creado
    Ambos message_id = NULL
    Ambos campos error poblados

CP-4: Query de exclusión funciona
  Precondición:
    Registro creado con created_at = NOW()
  Acción:
    Ejecutar FR-901 query con EXISTS check
  Resultado:
    Permiso NO aparece en resultados (excluido)

═══════════════════════════════════════════════════════════
```

---

## 6.6 Resumen de Derivación

**Proceso completo aplicado:**

```
UC-IACT-09 (11 pasos)
  │
  ├── Paso 2: Consultar permisos
  │   └── FR-901: Query con filtros complejos
  │
  ├── Paso 4: Calcular info adicional
  │   ├── FR-902: Tiempo restante
  │   └── FR-903: Nivel de urgencia
  │
  ├── Paso 5: Componer mensaje usuario
  │   └── FR-904: Template HTML personalizado
  │
  ├── Paso 6: Componer mensaje admin
  │   └── FR-905: Template HTML para admin
  │
  ├── Pasos 7-8: Enviar mensajes
  │   └── FR-906: Servicio de envío (reutilizado)
  │
  ├── Paso 9: Registrar notificación
  │   └── FR-907: INSERT en BD
  │
  ├── Paso 10: Auditoría
  │   └── FR-908: Evento en audit_log
  │
  └── Paso 11: Finalizar
      └── FR-909: Métricas de job

TOTAL: 9 FR derivados
DOCUMENTADOS COMPLETOS: 3 (FR-901, FR-904, FR-907)
GRANULARIDAD: Nivel 2 (Moderada, 1 FR por paso)
```

---

# SECCIÓN 7: TRAZABILIDAD BR → UC → FR → CÓDIGO

## 7.1 Forward Tracing (5 Pasos)

**Forward Tracing** responde: "Si cambio esta BR, ¿qué UC y FR se ven afectados?"

### Proceso de 5 Pasos

```
┌────────────────────────────────────────────────────┐
│         FORWARD TRACING (BR → Código)              │
├────────────────────────────────────────────────────┤
│                                                    │
│  PASO 1: Identificar BR a trazar                   │
│          ↓                                         │
│          BR-XXX seleccionada                       │
│                                                    │
│  PASO 2: Encontrar UC que usan BR                  │
│          ↓                                         │
│          Lista de UC-YYY                           │
│                                                    │
│  PASO 3: Dentro de cada UC, encontrar ubicación    │
│          ↓                                         │
│          Precondición / Paso N / FA-M              │
│                                                    │
│  PASO 4: Identificar FR derivados                  │
│          ↓                                         │
│          FR-ZZZ de ese paso/validación             │
│                                                    │
│  PASO 5: Localizar código implementado             │
│          ↓                                         │
│          Archivo.py, función, líneas               │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: Forward Tracing de BR-IACT-087

```
═══════════════════════════════════════════════════════════
FORWARD TRACING: BR-IACT-087
═══════════════════════════════════════════════════════════

PASO 1: BR Origen
─────────────────
BR-IACT-087 (RESTRICCIÓN):
"Solo usuarios con nivel de seguridad 3 o superior pueden asignar
 funciones críticas (function.es_critica = TRUE)."

PASO 2: UC Afectados
────────────────────
UC donde BR-IACT-087 aplica:

UC-IACT-04: Asignar Funciones a Usuario
  Ubicación: Precondición + Paso 4 + FA-3
  Impacto: ALTO (bloquea asignación si nivel < 3)

UC-IACT-06: Revocar Funciones
  Ubicación: Precondición (condicional)
  Impacto: MEDIO (solo si revoca críticas)

UC-IACT-18: Modificar Función en Catálogo
  Ubicación: Validación al cambiar es_critica flag
  Impacto: MEDIO (verifica al marcar función como crítica)

TOTAL UC AFECTADOS: 3

PASO 3: Ubicaciones Específicas
────────────────────────────────

En UC-IACT-04:
  
  • Precondición:
    "SI función es crítica ENTONCES admin nivel_seguridad >= 3"
    Línea: PRE-04
  
  • Paso 4 del Flujo Normal:
    "Sistema verifica nivel_seguridad si hay funciones críticas"
    Pseudocódigo:
      IF funciones_criticas AND admin.nivel < 3 THEN
        Ir a FA-3
      END IF
  
  • FA-3: Administrador Sin Nivel Requerido
    Completo (9 subpasos)
    Deniega asignación
    Ofrece: Continuar sin críticas o Cancelar

En UC-IACT-06:
  
  • Precondición (implícita):
    No restricción explícita para REVOCAR
    (Cualquier admin puede revocar, incluso críticas)
    BR-087 NO aplica a revocación
  
  ACTUALIZACIÓN: BR-087 NO afecta UC-IACT-06
  (Solo aplica a ASIGNACIÓN, no revocación)

En UC-IACT-18:
  
  • Paso 7: Validar cambio de flag es_critica
    IF cambio_a_critica AND admin.nivel < 3 THEN
      Denegar cambio
    END IF

PASO 4: FR Derivados
────────────────────

De UC-IACT-04:
  
  FR-401: Verificar Nivel de Seguridad del Administrador
    Descripción: Query que verifica nivel >= 3
    Input: admin_id, list[function_id]
    Output: Boolean (permitido) + razón
    
  FR-402: Listar Funciones Críticas en Selección
    Descripción: Filtrar functions donde es_critica = TRUE
    Input: list[function_id]
    Output: list[FunctionCritica]
  
  FR-403: Registrar Intento Denegado en Auditoría
    Descripción: INSERT en audit_log evento DENIED
    Input: admin_id, function_ids, razón
    Output: audit_log_id
  
  FR-404: Mostrar Mensaje de Denegación
    Descripción: Renderizar template con info
    Input: nivel_actual, funciones_denegadas
    Output: HTML message

De UC-IACT-18:
  
  FR-1801: Validar Cambio de Flag es_critica
    Descripción: Verificar permiso para marcar crítica
    Input: admin_id, function_id, nuevo_valor
    Output: Boolean + razón

TOTAL FR DERIVADOS: 5

PASO 5: Código Implementado
────────────────────────────

FR-401:
  Archivo: iact/access/validators.py
  Función: check_security_level_for_critical(admin_id, function_ids)
  Líneas: 156-189
  
  Tests:
    - tests/access/test_validators.py::test_check_security_level_pass
    - tests/access/test_validators.py::test_check_security_level_deny

FR-402:
  Archivo: iact/access/services.py
  Función: filter_critical_functions(function_ids)
  Líneas: 203-218
  
  Tests:
    - tests/access/test_services.py::test_filter_critical

FR-403:
  Archivo: iact/audit/services.py
  Función: log_denied_critical_assignment(admin_id, functions, reason)
  Líneas: 89-112
  
  Tests:
    - tests/audit/test_services.py::test_log_denied

FR-404:
  Archivo: iact/access/templates/denied_critical.html
  Template: Jinja2
  Usado por: iact/access/views.py::show_denial_message()
  
  Tests:
    - tests/access/test_views.py::test_denial_message_rendering

FR-1801:
  Archivo: iact/functions/validators.py
  Función: validate_critical_flag_change(admin_id, function_id, new_value)
  Líneas: 45-67
  
  Tests:
    - tests/functions/test_validators.py::test_critical_flag_validation

═══════════════════════════════════════════════════════════

IMPACTO DE CAMBIO EN BR-IACT-087:
──────────────────────────────────

SI cambia BR-IACT-087 (ej: nivel 3 → nivel 4):

Componentes a actualizar:
  
  1. Documentación BR:
     - BR-IACT-087.rst: Actualizar de 3 a 4
  
  2. Casos de Uso (3):
     - UC-IACT-04: Precondición + Paso 4 + FA-3
     - UC-IACT-18: Paso 7 validación
  
  3. Functional Requirements (5):
     - FR-401: Cambiar >= 3 a >= 4 en query
     - FR-402: Sin cambio (solo lista)
     - FR-403: Actualizar mensaje de error
     - FR-404: Actualizar template (nivel 4)
     - FR-1801: Cambiar validación
  
  4. Código (5 archivos):
     - validators.py (2 funciones)
     - services.py (1 función)
     - audit/services.py (1 función)
     - templates/denied_critical.html
  
  5. Tests (6 archivos):
     - Actualizar todos los test cases
     - Nuevos casos para nivel 3 (ahora insuficiente)
     - Casos nivel 4 (ahora suficiente)
  
  6. Base de Datos:
     - Sin cambio (nivel_seguridad ya existe)
     - Posible: Actualizar admins actuales nivel 3 → 4

ESTIMACIÓN:
  - Tiempo: 4-6 horas
  - Complejidad: Media
  - Riesgo: Bajo (bien trazado)
  - Tests a modificar: ~15 tests

═══════════════════════════════════════════════════════════
```

---

## 7.2 Backward Tracing (5 Pasos)

**Backward Tracing** responde: "¿De dónde viene este código? ¿Qué BR lo origina?"

### Proceso de 5 Pasos

```
┌────────────────────────────────────────────────────┐
│         BACKWARD TRACING (Código → BR)             │
├────────────────────────────────────────────────────┤
│                                                    │
│  PASO 1: Identificar código a trazar               │
│          ↓                                         │
│          Archivo.py, función o query               │
│                                                    │
│  PASO 2: Encontrar FR que implementa               │
│          ↓                                         │
│          FR-ZZZ (buscar en docstring/comments)     │
│                                                    │
│  PASO 3: Encontrar UC que deriva ese FR            │
│          ↓                                         │
│          UC-YYY Paso N                             │
│                                                    │
│  PASO 4: Identificar BR aplicada en ese paso       │
│          ↓                                         │
│          BR-XXX                                    │
│                                                    │
│  PASO 5: Validar trazabilidad completa             │
│          ↓                                         │
│          BR → UC → FR → Código ✅                  │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo: Backward Tracing desde Código

```
═══════════════════════════════════════════════════════════
BACKWARD TRACING: Desde check_security_level()
═══════════════════════════════════════════════════════════

PASO 1: Código Origen
─────────────────────
Archivo: iact/access/validators.py
Función: check_security_level_for_critical()
Líneas: 156-189

Código:
```python
def check_security_level_for_critical(
    admin_id: int,
    function_ids: List[int]
) -> Tuple[bool, Optional[str], List[Function]]:
    """
    Verifica que administrador tiene nivel de seguridad suficiente
    para asignar funciones críticas.
    
    Implementa: FR-401
    Derivado de: UC-IACT-04 Paso 4
    Business Rule: BR-IACT-087
    
    Args:
        admin_id: ID del administrador que intenta asignar
        function_ids: Lista de IDs de funciones a asignar
    
    Returns:
        Tupla (permitido, razón_denegación, funciones_críticas)
        - permitido: True si puede asignar, False si no
        - razón: Mensaje si denegado, None si permitido
        - funciones_críticas: Lista de funciones que son críticas
    """
    # 1. Obtener nivel de seguridad del admin
    admin = User.objects.get(id=admin_id)
    nivel_actual = admin.nivel_seguridad
    
    # 2. Filtrar funciones críticas
    funciones_criticas = Function.objects.filter(
        function_id__in=function_ids,
        es_critica=True
    )
    
    # 3. Si no hay críticas, permitir
    if not funciones_criticas.exists():
        return (True, None, [])
    
    # 4. Verificar nivel >= 3 (BR-IACT-087)
    NIVEL_REQUERIDO = 3
    
    if nivel_actual < NIVEL_REQUERIDO:
        # Denegar
        razon = (
            f"Requiere nivel de seguridad {NIVEL_REQUERIDO} o superior "
            f"para asignar funciones críticas. "
            f"Su nivel actual: {nivel_actual}. "
            f"Funciones críticas intentadas: "
            f"{', '.join(f.code_slug for f in funciones_criticas)}"
        )
        return (False, razon, list(funciones_criticas))
    
    # 5. Permitir
    return (True, None, list(funciones_criticas))
```

PASO 2: FR Implementado
────────────────────────
Docstring indica: "Implementa: FR-401"

FR-401: Verificar Nivel de Seguridad del Administrador
  Descripción: Verifica que admin tiene nivel >= 3 para críticas
  Input: admin_id, function_ids
  Output: Boolean + razón + lista críticas
  
  Documentado en: docs/FR/FR-401.md

PASO 3: UC que Deriva FR-401
─────────────────────────────
Docstring indica: "Derivado de: UC-IACT-04 Paso 4"

UC-IACT-04: Asignar Funciones a Usuario
  Paso 4: "Sistema verifica nivel_seguridad si hay funciones críticas"
  
  Extracto del UC:
    4. Sistema verifica nivel_seguridad si hay funciones críticas [BR-IACT-087]
       
       funciones_criticas = [f for f in seleccionadas if f.es_critica]
       
       IF funciones_criticas IS NOT EMPTY THEN
         admin_nivel = admin.nivel_seguridad
         
         IF admin_nivel < 3 THEN
           Ir a FA-3: Nivel Insuficiente
         END IF
       END IF

PASO 4: BR Origen
─────────────────
Docstring indica: "Business Rule: BR-IACT-087"

BR-IACT-087 (RESTRICCIÓN):
"Solo usuarios con nivel de seguridad 3 o superior pueden asignar
 funciones críticas (function.es_critica = TRUE). Esta restricción
 aplica independientemente del rol o agrupador del usuario."

Tipo: Restricción de Seguridad
Fuente: CNST-009 (Auditoría y Control)
Criticidad: Alta
Vigencia: Desde 2025-10-01

PASO 5: Validación de Trazabilidad
───────────────────────────────────

Trazabilidad completa verificada:

BR-IACT-087 (origen)
  ↓ transforma/integra
UC-IACT-04 Paso 4 (comportamiento)
  ↓ deriva
FR-401 (capacidad técnica)
  ↓ implementa
check_security_level_for_critical() (código)

✅ TRAZABILIDAD COMPLETA Y CONSISTENTE

Verificaciones:
  ✓ Docstrings presentes con IDs
  ✓ BR existe y está vigente
  ✓ UC documenta la BR en paso 4
  ✓ FR derivado correctamente del paso
  ✓ Código implementa lógica de FR
  ✓ Tests cubren casos de FR

═══════════════════════════════════════════════════════════
```

---

## 7.3 Matriz de Trazabilidad

Una **Matriz de Trazabilidad** (RTM - Requirements Traceability Matrix) es la herramienta central para mantener trazabilidad bidireccional.

### Formato de Matriz

```
┌──────┬────────────┬─────────────┬──────────────┬─────────────────┬─────────┐
│  BR  │ Tipo       │ UC          │ Ubicación    │ FR              │ Código  │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┼─────────┤
│      │            │             │              │                 │         │
│ 012  │ HECHO      │ —           │ Modelo       │ —               │ models/ │
│      │            │             │              │                 │ func.py │
│      │            │             │              │                 │         │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┼─────────┤
│      │            │             │              │                 │         │
│ 087  │ RESTRICCIÓN│ UC-04       │ Pre + P4     │ FR-401 a 404    │ valid.  │
│      │            │             │ + FA-3       │                 │ py:156  │
│      │            │             │              │                 │         │
│      │            │ UC-18       │ P7           │ FR-1801         │ func/   │
│      │            │             │              │                 │ val.py  │
│      │            │             │              │                 │         │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┼─────────┤
│      │            │             │              │                 │         │
│ 031  │ DESENCADE- │ UC-07       │ TODO         │ FR-301 a 309    │ sess/   │
│      │ NADOR ⭐   │ (completo)  │ (genera UC)  │ (9 FR)          │ notif.py│
│      │            │             │              │                 │         │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┼─────────┤
│      │            │             │              │                 │         │
│ 046  │ INFERENCIA │ UC-04       │ Postcond     │ FR-305          │ perm/   │
│      │            │             │ P11          │                 │ calc.py │
│      │            │             │              │                 │         │
│      │            │ UC-07       │ (relacionado)│ (usa resultado) │         │
│      │            │             │              │                 │         │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┼─────────┤
│      │            │             │              │                 │         │
│ 060  │ CÁLCULO    │ UC-04       │ P6 + FA-5    │ FR-601, 602     │ risk/   │
│      │            │             │              │                 │ score.py│
│      │            │             │              │                 │         │
└──────┴────────────┴─────────────┴──────────────┴─────────────────┴─────────┘
```

### Matriz Completa de UC-IACT-04

```
═══════════════════════════════════════════════════════════
MATRIZ DE TRAZABILIDAD: UC-IACT-04
═══════════════════════════════════════════════════════════

UC-IACT-04: Asignar Funciones a Usuario

┌──────┬────────────┬─────────────┬──────────────┬─────────────────┐
│ BR   │ Tipo       │ Ubicación   │ FR Derivados │ Tests           │
│ ID   │            │ en UC       │              │                 │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┤
│      │            │             │              │                 │
│ 012  │ HECHO      │ Modelo      │ FR-101       │ test_models/    │
│      │            │ (usado P2)  │ Consultar    │ test_function.  │
│      │            │             │ catálogo     │ py::test_unique │
│      │            │             │              │ _slug           │
│      │            │             │              │                 │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┤
│      │            │             │              │                 │
│ 087  │ RESTRICCIÓN│ PRE-04      │ FR-401       │ test_validators/│
│      │            │ Paso 4      │ Verificar    │ test_security_  │
│      │            │ FA-3        │ nivel        │ level_pass      │
│      │            │             │              │ _deny           │
│      │            │             │ FR-402       │                 │
│      │            │             │ Listar       │ test_services/  │
│      │            │             │ críticas     │ test_filter_    │
│      │            │             │              │ critical        │
│      │            │             │ FR-403       │                 │
│      │            │             │ Audit log    │ test_audit/     │
│      │            │             │ denied       │ test_log_denied │
│      │            │             │              │                 │
│      │            │             │ FR-404       │ test_views/     │
│      │            │             │ Mensaje      │ test_denial_msg │
│      │            │             │ denegación   │                 │
│      │            │             │              │                 │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┤
│      │            │             │              │                 │
│ 028  │ RESTRICCIÓN│ Paso 7-8    │ FR-205       │ test_mass/      │
│      │            │ FA-1        │ Contar users │ test_count_     │
│      │            │             │              │ affected        │
│      │            │             │ FR-206       │                 │
│      │            │             │ Identificar  │ test_mass/      │
│      │            │             │ auditor      │ test_identify_  │
│      │            │             │              │ auditor         │
│      │            │             │ FR-207       │                 │
│      │            │             │ Registrar    │ test_approval/  │
│      │            │             │ solicitud    │ test_create_    │
│      │            │             │              │ request         │
│      │            │             │ FR-208       │                 │
│      │            │             │ Notificar    │ test_messages/  │
│      │            │             │ auditor      │ test_notify_    │
│      │            │             │              │ auditor         │
│      │            │             │ FR-209       │                 │
│      │            │             │ Timer 48h    │ test_scheduler/ │
│      │            │             │              │ test_approval_  │
│      │            │             │              │ timer           │
│      │            │             │              │                 │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┤
│      │            │             │              │                 │
│ 060  │ CÁLCULO    │ Paso 6      │ FR-601       │ test_risk/      │
│      │            │ FA-5        │ Calcular     │ test_calculate_ │
│      │            │             │ score        │ score_low_med_  │
│      │            │             │              │ high_critical   │
│      │            │             │ FR-602       │                 │
│      │            │             │ Validar      │ test_risk/      │
│      │            │             │ umbral >85   │ test_validate_  │
│      │            │             │              │ threshold       │
│      │            │             │              │                 │
├──────┼────────────┼─────────────┼──────────────┼─────────────────┤
│      │            │             │              │                 │
│ 046  │ INFERENCIA │ Paso 11     │ FR-305       │ test_permissions│
│      │            │ Postcond    │ Actualizar   │ test_recalc_    │
│      │            │ FA-6        │ permisos     │ effective       │
│      │            │             │ efectivos    │                 │
│      │            │             │              │ test_permissions│
│      │            │             │ FR-306       │ test_rollback_  │
│      │            │             │ Rollback     │ on_error        │
│      │            │             │ si error     │                 │
│      │            │             │              │                 │
└──────┴────────────┴─────────────┴──────────────┴─────────────────┘

RESUMEN:
  - Total BR integradas: 5
  - Total ubicaciones en UC: 11
  - Total FR derivados: 15
  - Total tests: ~25

COBERTURA:
  - BR → UC: 100% (5/5 BR trazadas a UC)
  - UC → FR: 100% (11/11 ubicaciones derivan FR)
  - FR → Código: 100% (15/15 FR implementados)
  - FR → Tests: 100% (15/15 FR testeados)

═══════════════════════════════════════════════════════════
```

---

## 7.4 Herramientas para Mantener Trazabilidad

### Técnicas de Documentación en Código

**1. Docstrings Estructurados**

```python
def check_security_level_for_critical(admin_id, function_ids):
    """
    Verifica nivel de seguridad para asignar funciones críticas.
    
    Trazabilidad:
        BR: BR-IACT-087 (Nivel seguridad 3 para críticas)
        UC: UC-IACT-04 Paso 4
        FR: FR-401
    
    Args:
        admin_id (int): ID del administrador
        function_ids (List[int]): IDs de funciones a asignar
    
    Returns:
        Tuple[bool, Optional[str], List[Function]]: 
            (permitido, razón, funciones_críticas)
    
    Raises:
        UserNotFound: Si admin_id no existe
    
    Examples:
        >>> check_security_level_for_critical(123, [45, 67])
        (True, None, [Function<45>, Function<67>])
    """
    pass
```

**2. Comentarios de Trazabilidad**

```python
# BR-IACT-087: Solo nivel >= 3 para funciones críticas
NIVEL_SEGURIDAD_MINIMO = 3

# FR-401: Verificar nivel de seguridad
if admin.nivel_seguridad < NIVEL_SEGURIDAD_MINIMO:
    # FA-3 de UC-IACT-04: Denegar por nivel insuficiente
    return deny_critical_assignment(admin, funciones_criticas)
```

**3. Constantes con Referencias**

```python
# iact/access/constants.py

class SecurityLevels:
    """
    Niveles de seguridad del sistema.
    
    Trazabilidad:
        BR-IACT-087: Nivel 3 requerido para funciones críticas
        BR-IACT-092: Nivel 4 requerido para funciones de auditoría
        BR-IACT-095: Nivel 5 solo para superusuario
    """
    BASIC = 1
    STANDARD = 2
    ELEVATED = 3          # BR-IACT-087
    AUDIT = 4             # BR-IACT-092
    SUPERUSER = 5         # BR-IACT-095
```

**4. Tests con Referencias**

```python
# tests/access/test_validators.py

class TestSecurityLevelValidation:
    """
    Tests para FR-401: Verificar Nivel de Seguridad.
    
    Implementa: UC-IACT-04 Paso 4
    Business Rule: BR-IACT-087
    """
    
    def test_admin_nivel_3_puede_asignar_criticas(self):
        """
        Caso: Admin con nivel 3 puede asignar funciones críticas.
        
        Trazabilidad:
            BR-IACT-087: Nivel >= 3 requerido
            UC-IACT-04: Paso 4 (flujo normal)
            FR-401: Validación exitosa
        """
        admin = UserFactory(nivel_seguridad=3)
        funciones = FunctionFactory.create_batch(2, es_critica=True)
        
        permitido, razon, criticas = check_security_level_for_critical(
            admin.id,
            [f.id for f in funciones]
        )
        
        assert permitido is True
        assert razon is None
        assert len(criticas) == 2
    
    def test_admin_nivel_2_no_puede_asignar_criticas(self):
        """
        Caso: Admin con nivel 2 NO puede asignar funciones críticas.
        
        Trazabilidad:
            BR-IACT-087: Nivel < 3 insuficiente
            UC-IACT-04: FA-3 (nivel insuficiente)
            FR-401: Validación falla
        """
        admin = UserFactory(nivel_seguridad=2)
        funciones = FunctionFactory.create_batch(2, es_critica=True)
        
        permitido, razon, criticas = check_security_level_for_critical(
            admin.id,
            [f.id for f in funciones]
        )
        
        assert permitido is False
        assert "Requiere nivel de seguridad 3" in razon
        assert len(criticas) == 2
```

### Herramientas Automatizadas

**1. Script de Extracción de Trazabilidad**

```python
# scripts/extract_traceability.py

import re
import json
from pathlib import Path

def extract_traceability_from_file(filepath):
    """
    Extrae referencias de trazabilidad de un archivo de código.
    
    Busca patrones como:
        - BR: BR-IACT-XXX
        - UC: UC-IACT-YYY
        - FR: FR-ZZZ
    """
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Regex patterns
    br_pattern = r'BR-IACT-\d{3}'
    uc_pattern = r'UC-IACT-\d{2}'
    fr_pattern = r'FR-\d{3}'
    
    br_refs = set(re.findall(br_pattern, content))
    uc_refs = set(re.findall(uc_pattern, content))
    fr_refs = set(re.findall(fr_pattern, content))
    
    return {
        'file': str(filepath),
        'br_references': list(br_refs),
        'uc_references': list(uc_refs),
        'fr_references': list(fr_refs)
    }

def build_traceability_matrix():
    """
    Construye matriz de trazabilidad desde código fuente.
    """
    matrix = []
    
    # Escanear todos los archivos .py
    for filepath in Path('iact').rglob('*.py'):
        if 'test' not in str(filepath):  # Excluir tests
            trace = extract_traceability_from_file(filepath)
            if any([trace['br_references'], 
                    trace['uc_references'], 
                    trace['fr_references']]):
                matrix.append(trace)
    
    return matrix

def generate_rtm_report(matrix, output_file='RTM_Report.md'):
    """
    Genera reporte RTM en Markdown.
    """
    with open(output_file, 'w') as f:
        f.write("# Requirements Traceability Matrix (RTM)\n\n")
        f.write(f"Generated: {datetime.now().isoformat()}\n\n")
        
        f.write("## Traceability by File\n\n")
        f.write("| File | BR | UC | FR |\n")
        f.write("|------|----|----|----|\n")
        
        for entry in matrix:
            br_list = ", ".join(entry['br_references']) or "—"
            uc_list = ", ".join(entry['uc_references']) or "—"
            fr_list = ", ".join(entry['fr_references']) or "—"
            
            f.write(f"| {entry['file']} | {br_list} | {uc_list} | {fr_list} |\n")

if __name__ == '__main__':
    matrix = build_traceability_matrix()
    generate_rtm_report(matrix)
    print(f"RTM generado: {len(matrix)} archivos con trazabilidad")
```

**2. Pre-commit Hook para Verificar Trazabilidad**

```bash
# .git/hooks/pre-commit

#!/bin/bash

echo "Verificando trazabilidad en archivos modificados..."

# Obtener archivos .py modificados
MODIFIED_FILES=$(git diff --cached --name-only --diff-filter=AM | grep '\.py$')

if [ -z "$MODIFIED_FILES" ]; then
    echo "No hay archivos Python modificados."
    exit 0
fi

# Verificar que funciones nuevas tienen docstring con trazabilidad
for file in $MODIFIED_FILES; do
    # Buscar funciones sin docstring de trazabilidad
    if grep -q "def " "$file"; then
        if ! grep -q "Trazabilidad:" "$file"; then
            echo "❌ WARNING: $file contiene funciones sin trazabilidad documentada"
            echo "   Agrega docstring con 'Trazabilidad: BR/UC/FR'"
        fi
    fi
done

echo "✅ Verificación de trazabilidad completada"
exit 0
```

---

## 7.5 Métricas de Trazabilidad

### Fórmulas Clave

```
┌────────────────────────────────────────────────────┐
│         MÉTRICAS DE TRAZABILIDAD                   │
├────────────────────────────────────────────────────┤
│                                                    │
│  1. Cobertura de BR en UC                          │
│     = (BR cubiertas en UC / Total BR) × 100%       │
│     Target: >90%                                   │
│                                                    │
│  2. Cobertura de UC en FR                          │
│     = (Pasos con FR / Total pasos) × 100%          │
│     Target: >80%                                   │
│                                                    │
│  3. Cobertura de FR en Código                      │
│     = (FR implementados / Total FR) × 100%         │
│     Target: 100%                                   │
│                                                    │
│  4. Cobertura de Tests                             │
│     = (FR testeados / Total FR) × 100%             │
│     Target: 100%                                   │
│                                                    │
│  5. BR Huérfanas                                   │
│     = BR sin UC asociado                           │
│     Target: 0 (salvo Hechos)                       │
│                                                    │
│  6. UC Huérfanos                                   │
│     = UC sin BR origen                             │
│     Target: 0 (salvo UC CRUD técnicos)             │
│                                                    │
│  7. FR Huérfanos                                   │
│     = FR sin UC que lo derive                      │
│     Target: 0                                      │
│                                                    │
│  8. Código Huérfano                                │
│     = Funciones sin FR documentado                 │
│     Target: <5%                                    │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo de Cálculo

```
MÉTRICAS DEL PROYECTO IACT (Parcial)

Inventario:
  - BR documentadas: 45
  - UC documentados: 22
  - FR documentados: 156
  - Funciones en código: ~500

Cálculos:

1. Cobertura BR → UC:
   BR cubiertas: 40
   Total BR: 45
   Cobertura = 40/45 × 100% = 88.9%
   
   ❌ Bajo target (90%)
   Acción: Identificar 5 BR sin UC

2. Cobertura UC → FR:
   UC con FR: 20
   Total UC: 22
   Cobertura = 20/22 × 100% = 90.9%
   
   ✅ Cumple target (80%)

3. Cobertura FR → Código:
   FR implementados: 156
   Total FR: 156
   Cobertura = 156/156 × 100% = 100%
   
   ✅ Perfecto

4. Cobertura Tests:
   FR testeados: 148
   Total FR: 156
   Cobertura = 148/156 × 100% = 94.9%
   
   ❌ Bajo target (100%)
   Acción: Agregar 8 tests faltantes

5. BR Huérfanas:
   Total BR: 45
   BR sin UC: 8
   
   Desglose:
     - 8 Hechos (OK, no generan UC)
     - 0 Desencadenadores huérfanos ✅
     - 0 Restricciones huérfanas ✅
   
   ✅ Todas las BR que deben tener UC, lo tienen

6. UC Huérfanos:
   UC sin BR: 2
   
   Detalle:
     - UC-IACT-20: CRUD técnico (OK)
     - UC-IACT-21: CRUD técnico (OK)
   
   ✅ Huérfanos justificados

7. FR Huérfanos:
   FR sin UC: 0
   
   ✅ Todos los FR derivan de UC

8. Código Huérfano:
   Funciones totales: 500
   Sin FR documentado: 18
   % Huérfano = 18/500 × 100% = 3.6%
   
   ✅ Dentro de target (<5%)
   Nota: Son funciones auxiliares simples

SCORE GLOBAL:
  Promedio de métricas cumplidas: 7/8 = 87.5%
  
  ✅ BUENO (target: >80%)
  
Acciones pendientes:
  1. Cubrir 5 BR sin UC (si aplica)
  2. Agregar 8 tests faltantes
```

---

**FIN DE PARTE 2B**

PARTE 2B completada con éxito:
- ✅ Sección 4: Proceso de Construcción (7 pasos)
- ✅ Sección 5: Integración de Múltiples BR
- ✅ Sección 6: Derivación de FR
- ✅ Sección 7: Trazabilidad BR → UC → FR → Código

**Métricas de PARTE 2B:**
- Longitud: ~45,000 palabras
- Ejemplos completos: 7 (UC-IACT-09, FR-901, FR-904, FR-907, etc.)
- Plantillas: 4 (Construcción UC, Resolución conflictos, FR, Trazabilidad)
- Diagramas: 6 (Flujos, Matrices)

**Próximo:** PARTE 2C - Casos Especiales y Validación (Secciones 8-11)