# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 4

**PARTE 2B-2C + Mapeo Químicos→IACT Detallado**

---

## CONTINUACIÓN: PARTE 2B, 2C Y MAPEO COMPLETO

### 1.4 PARTE 2B: CONSTRUCCIÓN DETALLADA - ANÁLISIS

**Archivo:** PARTE_2B_CONSTRUCCION_DETALLADA_CASOS_USO.md  
**Tamaño:** 40,000 palabras (~80 páginas)  
**Líneas:** ~2,300  
**Tamaño archivo:** 156 KB

#### Contenido Técnico: Proceso de 7 Pasos

```
PARTE 2B: CONSTRUCCIÓN DETALLADA DE CASOS DE USO
═══════════════════════════════════════════════════

PROCESO DE 7 PASOS PARA CREAR UN UC

PASO 1: Identificar Actor Principal
────────────────────────────────────
• Técnica: Análisis de stakeholders
• Algoritmo de selección de actor
• Catálogo de actores (15 actores documentados)
• Ejemplo: UC-04 → Actor: Solicitante

PASO 2: Definir Objetivo Observable
────────────────────────────────────
• Test de observabilidad
• Objetivo debe ser medible
• Ejemplo: "Adquirir producto para operación"

PASO 3: Extraer Precondiciones
───────────────────────────────
• De las BR aplicables
• Estados del sistema
• Permisos del usuario
• Ejemplo UC-04:
  • Usuario autenticado
  • Certificación OSHA vigente (BR-087)
  • Presupuesto disponible (BR-033)

PASO 4: Construir Flujo Normal (Técnica de Storytelling)
─────────────────────────────────────────────────────────
• ALGORITMO:
  1. Iniciar: "Usuario inicia..."
  2. Sistema presenta: "Sistema muestra formulario..."
  3. Usuario ingresa: "Usuario completa campos..."
  4. Sistema valida: "Sistema verifica..."
  5. Por cada BR: Insertar validación
  6. Sistema procesa: "Sistema registra..."
  7. Resultado: "Sistema confirma..."

• PLANTILLA de paso:
  [N]. [Actor] [Verbo] [Complemento]
      Detalles: [Información adicional]
      BR aplicada: [BR-NNN]

• Ejemplo completo UC-04:
  1. Usuario inicia solicitud
  2. Sistema presenta formulario
  3. Usuario completa: producto, cantidad, justificación
  4. Sistema valida disponibilidad presupuestal ← BR-033
  5. Sistema verifica umbral aprobación ← BR-028
  6. Sistema valida certificación OSHA ← BR-087
  7. Sistema registra solicitud
  8. Sistema notifica solicitante

PASO 5: Derivar Flujos Alternos
────────────────────────────────
• TÉCNICA: Analizar cada decisión del flujo normal
• Para cada "SI/NO": Crear flujo alterno
• Ejemplo UC-04:
  FA-1: Requiere aprobación (si monto >$500)
  FA-2: Sin certificación OSHA
  FA-3: Sin presupuesto

PASO 6: Definir Excepciones
────────────────────────────
• Situaciones de error
• Validaciones fallidas
• Recursos no disponibles

PASO 7: Derivar FR
───────────────────
• 1 FR por cada acción del sistema
• ALGORITMO:
  FOR cada paso WHERE actor==Sistema:
    IF paso contiene validación:
      Crear FR de tipo VALIDATION
    ELSE IF paso contiene cálculo:
      Crear FR de tipo CALCULATION
    ELSE IF paso contiene persistencia:
      Crear FR de tipo PERSISTENCE
    ELSE IF paso contiene notificación:
      Crear FR de tipo NOTIFICATION
```

**Estimación actualización PARTE 2B:** 8h (revisión y ajuste ejemplos)

---

### 1.5 PARTE 2C: CASOS ESPECIALES Y VALIDACIÓN

**Archivo:** PARTE_2C_CASOS_ESPECIALES_Y_VALIDACION.md  
**Tamaño:** 30,000 palabras (~60 páginas)  
**Líneas:** ~1,800  
**Tamaño archivo:** 114 KB

#### Contenido: Checklist de Calidad (26 Puntos)

```
PARTE 2C: CASOS ESPECIALES Y VALIDACIÓN
════════════════════════════════════════

CHECKLIST DE CALIDAD DE UC (26 PUNTOS)

A. COMPLETITUD (8 puntos)
─────────────────────────
□ 1. UC tiene ID único
□ 2. UC tiene nombre descriptivo
□ 3. UC tiene actor principal identificado
□ 4. Precondiciones documentadas (mínimo 2)
□ 5. Flujo normal completo (mínimo 5 pasos)
□ 6. Al menos 1 flujo alterno
□ 7. Postcondiciones documentadas
□ 8. BR aplicadas identificadas

B. CLARIDAD (6 puntos)
──────────────────────
□ 9. Lenguaje claro y sin ambigüedades
□ 10. Pasos numerados consecutivamente
□ 11. Actor especificado en cada paso
□ 12. Verbos en presente
□ 13. Sin jerga técnica innecesaria
□ 14. Formato consistente

C. OBSERVABILIDAD (4 puntos)
─────────────────────────────
□ 15. Objetivo es observable por usuario
□ 16. Postcondiciones son verificables
□ 17. Flujo tiene inicio y fin claros
□ 18. Usuario puede distinguir éxito de falla

D. TRAZABILIDAD (4 puntos)
──────────────────────────
□ 19. Vinculado a BReq
□ 20. BR aplicadas documentadas
□ 21. FR derivados listados
□ 22. Código implementador referenciado

E. ATOMICIDAD (2 puntos)
────────────────────────
□ 23. UC cumple UN solo objetivo
□ 24. No mezcla múltiples procesos

F. TESTABILIDAD (2 puntos)
──────────────────────────
□ 25. Precondiciones son reproducibles
□ 26. Postcondiciones son medibles

CASOS ESPECIALES DOCUMENTADOS:
• UC con múltiples actores
• UC anidados (include/extend)
• UC de sistemas externos
• UC batch/automáticos
```

**Estimación actualización PARTE 2C:** 2h (ajustar ejemplos)

---

## PARTE 2: MAPEO QUÍMICOS → IACT COMPLETO

### 2.1 TABLA MAESTRA DE MAPEO (30 Filas)

```
┌────────────────────────┬──────────────────────────┬──────────┐
│ Concepto Químicos      │ Equivalente IACT         │ Razón    │
├────────────────────────┼──────────────────────────┼──────────┤
│ ENTIDADES                                                     │
├────────────────────────┼──────────────────────────┼──────────┤
│ Producto Químico       │ Llamada IVR              │ Entidad  │
│                        │                          │ principal│
├────────────────────────┼──────────────────────────┼──────────┤
│ Contenedor Químico     │ Sesión IVR               │ Contenedor│
│                        │                          │ temporal │
├────────────────────────┼──────────────────────────┼──────────┤
│ Solicitud de Compra    │ Consulta de Reporte      │ Acción   │
│                        │                          │ usuario  │
├────────────────────────┼──────────────────────────┼──────────┤
│ Laboratorio            │ Cola IVR / Centro        │ Ubicación│
├────────────────────────┼──────────────────────────┼──────────┤
│ Inventario Químicos    │ Disponibilidad Datos     │ Estado   │
│                        │ Analytics                │ sistema  │
├────────────────────────┼──────────────────────────┼──────────┤
│ Fecha de Vencimiento   │ Timeout / Expiración     │ Temporal │
│                        │ Sesión                   │          │
├────────────────────────┼──────────────────────────┼──────────┤
│ ACTORES                                                       │
├────────────────────────┼──────────────────────────┼──────────┤
│ Solicitante            │ Analista de Negocio      │ Usuario  │
│                        │                          │ operativo│
├────────────────────────┼──────────────────────────┼──────────┤
│ Coordinador Seguridad  │ Coordinador Técnico      │ Rol      │
│                        │                          │ supervisor│
├────────────────────────┼──────────────────────────┼──────────┤
│ Gerente de Departamento│ Gerente de Área          │ Aprobador│
├────────────────────────┼──────────────────────────┼──────────┤
│ Personal de Almacén    │ Operador de Reportes     │ Ejecutor │
├────────────────────────┼──────────────────────────┼──────────┤
│ ATRIBUTOS                                                     │
├────────────────────────┼──────────────────────────┼──────────┤
│ Monto ($500)           │ Cantidad Registros       │ Umbral   │
│                        │ (10,000)                 │ numérico │
├────────────────────────┼──────────────────────────┼──────────┤
│ Certificación OSHA     │ Nivel de Seguridad ≥3    │ Permiso  │
│                        │ (RBAC)                   │          │
├────────────────────────┼──────────────────────────┼──────────┤
│ Clase de Peligro       │ Nivel de Prioridad       │ Clasificac│
│ (I, II, III)           │ (ALTA, MEDIA, BAJA)      │          │
├────────────────────────┼──────────────────────────┼──────────┤
│ Stock Mínimo           │ Umbral de Datos          │ Límite   │
│                        │ Requeridos               │          │
├────────────────────────┼──────────────────────────┼──────────┤
│ Vida Útil (días)       │ Retención de Sesión (min)│ Duración │
├────────────────────────┼──────────────────────────┼──────────┤
│ PROCESOS                                                      │
├────────────────────────┼──────────────────────────┼──────────┤
│ Aprobar Compra         │ Aprobar Consulta Masiva  │ Workflow │
├────────────────────────┼──────────────────────────┼──────────┤
│ Notificar Vencimiento  │ Notificar Sesión         │ Alert    │
│                        │ Inactiva                 │          │
├────────────────────────┼──────────────────────────┼──────────┤
│ Validar Certificación  │ Validar Permiso RBAC     │ Seguridad│
├────────────────────────┼──────────────────────────┼──────────┤
│ Calcular Costo Total   │ Calcular Total Llamadas  │ Agregación│
├────────────────────────┼──────────────────────────┼──────────┤
│ Marcar VENCIDO         │ Marcar EXPIRED           │ Estado   │
├────────────────────────┼──────────────────────────┼──────────┤
│ TEMPORALIDAD                                                  │
├────────────────────────┼──────────────────────────┼──────────┤
│ 30 días antes          │ 12 minutos antes         │ Ventana  │
│                        │                          │ alerta   │
├────────────────────────┼──────────────────────────┼──────────┤
│ Fecha actual           │ T+15 min inactividad     │ Umbral   │
│                        │                          │ crítico  │
├────────────────────────┼──────────────────────────┼──────────┤
│ Frecuencia compra      │ Frecuencia consulta      │ Métrica  │
│ (mensual)              │ (diaria)                 │          │
└────────────────────────┴──────────────────────────┴──────────┘
```

### 2.2 MAPEO DE BUSINESS RULES DETALLADO

#### BR-028: Restricción de Umbral Monetario

```
═══════════════════════════════════════════════════════════════

BR-028-QUÍMICOS (Original - 23 ocurrencias en PARTE 0)
───────────────────────────────────────────────────────
"Las solicitudes de compra de productos químicos con un 
 monto superior a $500 dólares DEBEN obtener aprobación 
 del gerente de departamento antes de ser procesadas."

Componentes:
  Entidad: Solicitud de compra de productos químicos
  Atributo: Monto
  Umbral: $500
  Acción requerida: Aprobación gerente
  Actor aprobador: Gerente de departamento

Tipo: RESTRICCIÓN
Observable: SÍ (usuario solicita aprobación)
Genera UC: SÍ (paso en UC-04)

───────────────────────────────────────────────────────────────

BR-IACT-028 (Adaptado - Nueva versión)
───────────────────────────────────────
"Las consultas de reportes de llamadas IVR que excedan 
 10,000 registros DEBEN obtener aprobación del supervisor 
 de área antes de ser ejecutadas."

Componentes:
  Entidad: Consulta de reporte de llamadas IVR
  Atributo: Cantidad de registros
  Umbral: 10,000 registros
  Acción requerida: Aprobación supervisor
  Actor aprobador: Supervisor de área

Tipo: RESTRICCIÓN
Observable: SÍ (usuario solicita aprobación)
Genera UC: SÍ (paso en UC-IACT-RPT-01)

Justificación del mapeo:
  • $500 → 10,000 registros: Ambos son umbrales de "volumen"
  • Compra → Consulta: Ambas son acciones del usuario
  • Gerente → Supervisor: Ambos son roles de aprobación
  • Procesamiento costoso: Alto costo monetario vs alto costo computacional

Impacto:
  • UC-IACT-RPT-01: "Consultar Reporte Consolidado de Llamadas"
    Paso 5: Sistema verifica cantidad de registros
    IF registros > 10,000:
      Flujo Alterno FA-1: Requiere Aprobación Supervisor
    ELSE:
      Continuar flujo normal
  
  • FR-IACT-206: Validar Umbral de Registros
    def validate_record_threshold(record_count, user):
        if record_count > 10000:
            if not user.has_supervisor_approval():
                raise ValidationError(
                    "Consultas >10K registros requieren aprobación supervisor"
                )

Trazabilidad IACT:
  BR-IACT-028
    → BRQ-IACT-007 "Gestión de Consultas Masivas"
      → UC-IACT-RPT-01 "Consultar Reporte Consolidado" (paso 5)
        → FR-IACT-206 "Validar Umbral Registros"
          → validators.py::validate_record_threshold()
            → test_record_threshold.py

═══════════════════════════════════════════════════════════════
```

#### BR-031 vs BR-046: Comparación CRÍTICA Adaptada

```
═══════════════════════════════════════════════════════════════

ESCENARIO QUÍMICOS (Original)
──────────────────────────────

T = 2024-12-01 (30 días antes)
  BR-031 (DESENCADENADOR):
  "Notificar vencimiento de químico 30 días antes"
  → Genera UC-07 completo
  → Usuario VE notificación ✓ OBSERVABLE

T = 2024-12-31 (día de vencimiento)
  BR-046 (INFERENCIA):
  "Marcar contenedor VENCIDO al alcanzar fecha"
  → Solo genera FR-305 (UPDATE)
  → Usuario NO ve nada ✗ NO OBSERVABLE

───────────────────────────────────────────────────────────────

ESCENARIO IACT (Adaptado)
──────────────────────────

T = 12 minutos de inactividad
  BR-IACT-031 (DESENCADENADOR):
  "Notificar al usuario si la sesión IVR lleva más de 
   12 minutos sin actividad"
  → Genera UC-IACT-07 completo
  → Usuario VE notificación ✓ OBSERVABLE

T = 15 minutos de inactividad
  BR-IACT-046 (INFERENCIA):
  "Marcar la sesión IVR como EXPIRED cuando supera 
   15 minutos sin actividad"
  → Solo genera FR-IACT-305 (UPDATE)
  → Usuario NO ve nada ✗ NO OBSERVABLE

───────────────────────────────────────────────────────────────

UC-IACT-07: Notificar Sesión IVR Inactiva (11 pasos)
═════════════════════════════════════════════════════

1. Sistema (Job) inicia escaneo de sesiones activas
2. Sistema calcula umbral inactividad = 12 minutos
3. Sistema consulta BD de sesiones IVR
   Query:
     SELECT session_id, user_id, last_activity
     FROM ivr_sessions
     WHERE estado = 'ACTIVA'
       AND last_activity < NOW() - INTERVAL 12 MINUTE
4. Sistema verifica si hay sesiones encontradas
5. Sistema itera sobre sesiones inactivas
6. Sistema obtiene usuario de la sesión
7. Sistema construye mensaje de alerta
   subject = "Alerta: Sesión IVR por expirar"
   body = "Su sesión lleva 12 min inactiva. Expirará en 3 min."
8. Sistema envía notificación interna (NO email - CNST_001)
9. Sistema registra notificación enviada
10. Sistema actualiza flag warned_12min = TRUE
11. Usuario recibe y visualiza alerta ← OBSERVABLE

Flujos Alternos:
  FA-1: Usuario reanuda actividad antes de expirar
  FA-2: Usuario ignora alerta y sesión expira
  FA-3: Sistema de notificaciones no disponible
  FA-4: Usuario ya cerró sesión manualmente

FR Derivados:
  FR-IACT-301: Query sesiones inactivas >12 min
  FR-IACT-302: Obtener datos de usuario
  FR-IACT-303: Enviar notificación interna
  FR-IACT-304: Registrar log de notificación
  FR-IACT-305: Update warned_12min flag

───────────────────────────────────────────────────────────────

FR-IACT-305: Marcar Sesión EXPIRED (sin UC)
════════════════════════════════════════════

Origen: BR-IACT-046 (Inferencia)

Descripción:
  Marca sesiones como EXPIRED cuando superan 15 minutos
  de inactividad. Proceso automático sin interacción del usuario.

Implementación:
  # api/apps/ivr/jobs/expire_sessions.py
  
  def expire_inactive_sessions():
      """
      Job automático: marca sesiones inactivas como EXPIRED.
      
      CNST_002: Timeout 15 minutos
      BR-IACT-046: Inferencia automática
      
      NO GENERA UC (no observable)
      """
      threshold = timezone.now() - timedelta(minutes=15)
      
      expired = IVRSession.objects.filter(
          estado='ACTIVA',
          last_activity__lt=threshold
      )
      
      expired.update(
          estado='EXPIRED',
          expired_at=timezone.now()
      )
      
      # Auditoría (CNST_009)
      for session in expired:
          UserActionLog.record(
              user=session.user,
              action='SESSION_EXPIRED',
              resource=f"session:{session.session_id}",
              result='AUTO'
          )

No genera UC porque:
  • Usuario NO percibe el cambio
  • Usuario NO actúa
  • Solo UPDATE en BD
  • Sin interfaz

═══════════════════════════════════════════════════════════════
```

#### BR-087: Restricción de Certificación

```
BR-087-QUÍMICOS (Original - 10 ocurrencias)
────────────────────────────────────────────
"Solo el personal con certificación OSHA vigente puede 
 manipular productos químicos peligrosos"

BR-IACT-087 (Adaptado)
───────────────────────
"Solo los usuarios con nivel de seguridad ≥3 en RBAC 
 pueden asignar funciones críticas del sistema"

Mapeo:
  Certificación OSHA → Nivel de seguridad RBAC
  Manipular químicos → Asignar funciones críticas
  Personal → Usuarios con permisos

Impacto en IACT:
  • UC-IACT-ACC-01: "Asignar Funciones a Usuario"
    Precondición: Usuario tiene función ACC-001 (asigna_funciones)
                  Y nivel_seguridad ≥ 3
    
    Paso 4: Sistema valida nivel de seguridad
    IF user.security_level < 3:
      Excepción EX-02: "Nivel de seguridad insuficiente"

  • FR-IACT-207: Validar Nivel de Seguridad
    def validate_security_level(user, required_level=3):
        if user.security_level < required_level:
            raise PermissionDenied(
                f"Requiere nivel ≥{required_level}. "
                f"Usuario tiene nivel {user.security_level}"
            )
```

---

[CONTINÚA EN PARTE 5 CON RBAC, CNST, UC v4.0]

