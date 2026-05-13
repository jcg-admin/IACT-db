# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 3

**PARTE 2A, PARTE 2B, PARTE 2C - Transformación BR→UC Completa**

---

## CONTINUACIÓN: PARTE 2A-2C ANÁLISIS DETALLADO

### 1.3 PARTE 2A: FUNDAMENTOS DE TRANSFORMACIÓN - ANÁLISIS COMPLETO

**Archivo:** PARTE_2A_FUNDAMENTOS_TRANSFORMACION_BR_UC.md  
**Estado:** Documento técnico central  
**Tamaño:** 37,000 palabras (~75 páginas)  
**Líneas:** ~2,100  
**Tamaño archivo:** 142 KB  
**Fecha:** 2025-12-12

#### Estructura y Contenido Técnico Detallado

```
PARTE 2A: FUNDAMENTOS DE TRANSFORMACIÓN BR → UC
═════════════════════════════════════════════════

1. INTRODUCCIÓN A LA TRANSFORMACIÓN (3,000 palabras)
   │
   ├── El Problema Central:
   │   "¿Cómo convertir una regla de negocio atómica
   │    en un caso de uso observable completo?"
   │
   ├── Ejemplo Motivador:
   │   BR-028 → UC-04 (paso a paso completo)
   │
   └── Los 5 Patrones de Transformación
       (Adelanto de lo que viene)

2. PATRÓN 1: RESTRICCIÓN → PRECONDICIÓN (7,500 palabras) ⭐⭐⭐
   │
   ├── CONCEPTO:
   │   Una BR de tipo RESTRICCIÓN se mapea típicamente
   │   a una PRECONDICIÓN de un UC existente.
   │
   ├── EJEMPLO MAESTRO: BR-087 → UC-04
   │   │
   │   ├── BR-087 original (Restricción):
   │   │   "Solo personal con certificación OSHA vigente
   │   │    puede manipular productos químicos peligrosos"
   │   │
   │   ├── Análisis de componentes:
   │   │   Sujeto: personal
   │   │   Calificador: con certificación OSHA vigente
   │   │   Acción permitida: manipular químicos peligrosos
   │   │   Tipo: RESTRICCIÓN (limita quién puede hacer qué)
   │   │
   │   ├── Decisión de transformación:
   │   │   ¿Es observable? NO DIRECTAMENTE
   │   │   ¿Genera UC propio? NO
   │   │   ¿Se incorpora en UC existente? SÍ
   │   │   UC objetivo: UC-04 "Solicitar Producto Químico"
   │   │   Ubicación: PRECONDICIÓN
   │   │
   │   ├── Transformación aplicada:
   │   │   │
   │   │   UC-04 ANTES:
   │   │   ──────────
   │   │   Precondiciones:
   │   │     • Usuario autenticado
   │   │     • Presupuesto disponible
   │   │   
   │   │   UC-04 DESPUÉS (con BR-087):
   │   │   ────────────────────────────
   │   │   Precondiciones:
   │   │     • Usuario autenticado
   │   │     • Usuario con certificación OSHA vigente ← BR-087
   │   │     • Presupuesto disponible
   │   │   
   │   │   Paso 6 (nuevo):
   │   │     Sistema valida certificación OSHA del usuario
   │   │     
   │   │   Excepción EX-02 (nueva):
   │   │     Si usuario no tiene certificación OSHA vigente:
   │   │       1. Sistema muestra mensaje de error
   │   │       2. Sistema no permite continuar
   │   │       3. UC termina en falla
   │   │
   │   ├── FR derivado:
   │   │   │
   │   │   FR-207: Validar Certificación OSHA
   │   │   ═════════════════════════════════════
   │   │   
   │   │   Origen: UC-04 paso 6 (BR-087)
   │   │   
   │   │   Descripción:
   │   │     Verificar que el usuario tenga certificación
   │   │     OSHA vigente antes de permitir solicitud de
   │   │     productos químicos peligrosos.
   │   │   
   │   │   Query SQL:
   │   │     SELECT osha_certified, osha_expiration_date
   │   │     FROM users
   │   │     WHERE user_id = :user_id
   │   │       AND osha_expiration_date > CURRENT_DATE
   │   │   
   │   │   Validación:
   │   │     if not osha_certified:
   │   │         raise ValidationError("Usuario sin certificación OSHA")
   │   │     if osha_expiration_date <= today:
   │   │         raise ValidationError("Certificación OSHA vencida")
   │   │   
   │   │   Código Python:
   │   │     # api/apps/requests/validators.py
   │   │     
   │   │     class OSHACertificationValidator:
   │   │         def validate(self, user):
   │   │             if not user.osha_certified:
   │   │                 raise ValidationError(
   │   │                     "Usuario no tiene certificación OSHA"
   │   │                 )
   │   │             if user.osha_expiration_date <= date.today():
   │   │                 raise ValidationError(
   │   │                     "Certificación OSHA vencida. "
   │   │                     "Contacte a RH para renovación."
   │   │                 )
   │   │
   │   └── Trazabilidad completa:
   │       BR-087
   │         → UC-04 (Precondición + Paso 6 + Excepción EX-02)
   │           → FR-207 (Validar Certificación)
   │             → validators.py::OSHACertificationValidator
   │               → test_osha_validation.py
   │
   ├── ALGORITMO FORMAL:
   │   │
   │   │   PATRÓN 1: Restricción → Precondición
   │   │   ═══════════════════════════════════════
   │   │   
   │   │   INPUT:
   │   │     • BR de tipo RESTRICCIÓN
   │   │     • UC objetivo identificado
   │   │   
   │   │   PASOS:
   │   │     1. Analizar restricción:
   │   │        ¿Quién? → Actor
   │   │        ¿Qué condición? → Predicado
   │   │        ¿Qué acción? → Verbo
   │   │     
   │   │     2. Buscar UC que contenga la ACCIÓN
   │   │        Ej: "manipular químicos" → UC-04 "Solicitar Producto"
   │   │     
   │   │     3. Agregar a PRECONDICIONES del UC:
   │   │        "Actor debe cumplir CONDICIÓN"
   │   │     
   │   │     4. Agregar PASO de validación:
   │   │        "Sistema verifica CONDICIÓN"
   │   │     
   │   │     5. Agregar EXCEPCIÓN:
   │   │        "Si no cumple CONDICIÓN → Error"
   │   │     
   │   │     6. Derivar FR de validación
   │   │   
   │   │   OUTPUT:
   │   │     • UC modificado con precondición
   │   │     • FR de validación
   │   │     • Excepción documentada
   │
   ├── Ejercicio Práctico:
   │   │
   │   │   Transformar esta BR:
   │   │   
   │   │   BR-099: "Solo usuarios con rol SUPERVISOR pueden
   │   │            aprobar solicitudes de compra"
   │   │   
   │   │   ¿A qué UC se incorpora? UC-12 "Aprobar Solicitud"
   │   │   ¿Cómo precondición? Sí
   │   │   ¿Qué FR genera? FR-250 "Validar Rol Supervisor"
   │
   └── Otros ejemplos:
       • BR-033 → UC-04 (Presupuesto disponible)
       • BR-101 → UC-18 (Stock mínimo)
       • BR-115 → UC-25 (Permiso de acceso)

3. PATRÓN 2: DESENCADENADOR → UC COMPLETO (8,000 palabras) ⭐⭐⭐
   │
   ├── CONCEPTO:
   │   Una BR de tipo DESENCADENADOR SIEMPRE genera
   │   un UC completo nuevo de 11+ pasos.
   │
   ├── EJEMPLO MAESTRO: BR-031 → UC-07
   │   │
   │   ├── BR-031 original (Desencadenador):
   │   │   "El sistema debe notificar al coordinador de seguridad
   │   │    con 30 días de anticipación cuando un producto químico
   │   │    esté próximo a vencer"
   │   │
   │   ├── Análisis de componentes:
   │   │   Gatillo: días_hasta_vencimiento == 30
   │   │   Acción: notificar
   │   │   Receptor: coordinador de seguridad
   │   │   Observable: SÍ (usuario VE notificación)
   │   │
   │   ├── Decisión de transformación:
   │   │   ¿Es observable? SÍ (notificación visible)
   │   │   ¿Usuario puede actuar? SÍ (solicitar reposición)
   │   │   ¿Genera UC propio? SÍ ✓
   │   │   UC generado: UC-07 "Notificar Vencimiento Inminente"
   │   │
   │   └── UC-07 GENERADO COMPLETO:
   │       │
   │       UC-07: Notificar Vencimiento Inminente de Producto Químico
   │       ═══════════════════════════════════════════════════════════
   │       
   │       1. RESUMEN
   │       ──────────
   │       ID: UC-07
   │       Nombre: Notificar Vencimiento Inminente
   │       Actor Principal: Sistema (Scheduler)
   │       Actor Secundario: Coordinador de Seguridad
   │       Objetivo: Alertar sobre químicos próximos a vencer
   │       Prioridad: Alta
   │       Complejidad: Media
   │       BReq Origen: BRQ-003 "Gestión de Inventario"
   │       BR Aplicada: BR-031
   │       
   │       2. DESCRIPCIÓN
   │       ───────────────
   │       Job automatizado que se ejecuta diariamente para
   │       identificar productos químicos que vencerán en
   │       exactamente 30 días y notificar al coordinador
   │       de seguridad para que tome acciones preventivas
   │       (solicitar reposición, planificar uso acelerado, etc.)
   │       
   │       3. PRECONDICIONES
   │       ──────────────────
   │       • Sistema de notificaciones operativo
   │       • BD de productos actualizada
   │       • Coordinador de seguridad designado
   │       • Job scheduler configurado (ejecución diaria)
   │       
   │       4. TRIGGER
   │       ──────────
   │       • Automático: Job ejecuta diariamente a las 08:00
   │       
   │       5. FLUJO NORMAL (11 pasos)
   │       ───────────────────────────
   │       
   │       Paso 1: Sistema (Job) inicia escaneo diario
   │         Actor: Sistema
   │         Acción: Ejecuta job scan_expiring_products()
   │       
   │       Paso 2: Sistema calcula fecha límite
   │         Actor: Sistema
   │         Acción: threshold_date = TODAY + 30 días
   │       
   │       Paso 3: Sistema consulta BD de productos
   │         Actor: Sistema
   │         Acción: Query productos con expiration_date == threshold_date
   │         SQL:
   │           SELECT id, name, expiration_date, location
   │           FROM chemical_products
   │           WHERE expiration_date = :threshold_date
   │             AND status = 'ACTIVE'
   │       
   │       Paso 4: Sistema verifica si hay productos encontrados
   │         Actor: Sistema
   │         Decisión: 
   │           SÍ encontró productos → Continuar paso 5
   │           NO encontró productos → Terminar (sin notificar)
   │       
   │       Paso 5: Sistema itera sobre productos encontrados
   │         Actor: Sistema
   │         Acción: FOR EACH product IN expiring_products
   │       
   │       Paso 6: Sistema obtiene coordinador asignado
   │         Actor: Sistema
   │         Acción: coordinator = get_safety_coordinator()
   │       
   │       Paso 7: Sistema construye mensaje de notificación
   │         Actor: Sistema
   │         Acción: 
   │           subject = "Alerta: Producto próximo a vencer"
   │           body = f"El producto {product.name} vencerá en 30 días..."
   │           priority = "HIGH"
   │       
   │       Paso 8: Sistema envía notificación
   │         Actor: Sistema
   │         Acción: 
   │           send_internal_notification(
   │               to=coordinator,
   │               subject=subject,
   │               body=body,
   │               priority="HIGH"
   │           )
   │       
   │       Paso 9: Sistema registra notificación enviada
   │         Actor: Sistema
   │         Acción: 
   │           CREATE notification_log (
   │               product_id, coordinator_id, sent_at, status='SENT'
   │           )
   │       
   │       Paso 10: Sistema actualiza estado del producto
   │         Actor: Sistema
   │         Acción:
   │           UPDATE products
   │           SET notified_30days = TRUE
   │           WHERE id = product.id
   │       
   │       Paso 11: Coordinador recibe y visualiza notificación
   │         Actor: Coordinador de Seguridad
   │         Acción:
   │           • Ve notificación en bandeja
   │           • Puede marcar como leída
   │           • Puede tomar acción (solicitar reposición)
   │       
   │       6. FLUJOS ALTERNOS
   │       ───────────────────
   │       
   │       FA-1: Múltiples productos vencen mismo día
   │         • Sistema consolida en UNA notificación
   │         • Lista todos los productos en cuerpo del mensaje
   │         • No envía 10 notificaciones separadas
   │       
   │       FA-2: Coordinador no disponible
   │         • Sistema busca coordinador sustituto
   │         • Si no hay sustituto → Notifica a gerente de planta
   │       
   │       FA-3: Producto ya fue notificado previamente
   │         • Sistema verifica notified_30days flag
   │         • Si TRUE → Skip notificación (evitar duplicados)
   │       
   │       FA-4: Sistema de notificaciones caído
   │         • Intentar reenvío 3 veces con delay de 5 min
   │         • Si falla → Registrar en error_log
   │         • Enviar alerta a equipo técnico
   │       
   │       FA-5: Producto vendido antes de vencer
   │         • Estado cambió a SOLD o DISPOSED
   │         • Sistema NO notifica
   │       
   │       FA-6: Usuario marca notificación como "Acción tomada"
   │         • Sistema registra acknowledgment
   │         • Notificación pasa a estado ACKNOWLEDGED
   │       
   │       7. EXCEPCIONES
   │       ───────────────
   │       
   │       EX-01: Error en query a BD
   │         Causa: BD no disponible
   │         Acción: Registrar error, reintentar en 1 hora
   │       
   │       EX-02: No hay coordinador designado
   │         Causa: Puesto vacante
   │         Acción: Escalar a gerente de planta
   │       
   │       EX-03: Error al enviar notificación
   │         Causa: Servicio de mensajería caído
   │         Acción: Queue para reintento, alertar a Ops
   │       
   │       8. POSTCONDICIONES
   │       ───────────────────
   │       • Notificación enviada y registrada
   │       • Producto marcado como notified_30days = TRUE
   │       • Coordinador puede visualizar alerta
   │       • Log de auditoría generado
   │       
   │       9. REGLAS DE NEGOCIO
   │       ─────────────────────
   │       • BR-031: Notificar 30 días antes (regla principal)
   │       • BR-104: Consolidar notificaciones múltiples
   │       • BR-112: Escalar si coordinador no disponible
   │       
   │       10. FR DERIVADOS
   │       ────────────────
   │       
   │       FR-301: Consultar Productos Próximos a Vencer
   │         Query: SELECT ... WHERE expiration_date = TODAY + 30
   │       
   │       FR-302: Obtener Coordinador de Seguridad
   │         Query: SELECT user WHERE role = 'SAFETY_COORDINATOR'
   │       
   │       FR-303: Enviar Notificación Interna
   │         Función: send_internal_notification(to, subject, body)
   │       
   │       FR-304: Registrar Notificación Enviada
   │         INSERT INTO notification_logs (...)
   │       
   │       FR-305: Actualizar Flag de Producto
   │         UPDATE products SET notified_30days = TRUE
   │       
   │       FR-306: Consolidar Notificaciones Múltiples
   │         Lógica: Agrupar productos en un solo mensaje
   │       
   │       11. TRAZABILIDAD
   │       ─────────────────
   │       BReq: BRQ-003 "Gestión de Inventario"
   │       BR: BR-031 "Notificar 30 días antes"
   │       UC: UC-07 (este documento)
   │       FR: FR-301 a FR-306
   │       Código: jobs/scan_expiring_products.py
   │       Tests: test_expiring_notifications.py
   │
   ├── ALGORITMO FORMAL:
   │   │
   │   │   PATRÓN 2: Desencadenador → UC Completo
   │   │   ═══════════════════════════════════════
   │   │   
   │   │   INPUT:
   │   │     • BR de tipo DESENCADENADOR
   │   │   
   │   │   PASOS:
   │   │     1. Identificar componentes:
   │   │        Gatillo/Evento: ¿Qué dispara la acción?
   │   │        Acción: ¿Qué hacer?
   │   │        Receptor: ¿Quién recibe?
   │   │     
   │   │     2. Verificar observabilidad:
   │   │        Pregunta: "¿El usuario VE algo?"
   │   │        Si SÍ → Continuar
   │   │     
   │   │     3. Crear UC nuevo con estructura completa:
   │   │        • Resumen (9 campos)
   │   │        • Descripción
   │   │        • Precondiciones
   │   │        • Trigger (automático o manual)
   │   │        • Flujo Normal (11+ pasos típicos):
   │   │            1. Inicio del job/trigger
   │   │            2. Cálculo de condición
   │   │            3. Query a BD
   │   │            4. Verificación de resultados
   │   │            5. Iteración (si múltiples)
   │   │            6. Obtener receptor
   │   │            7. Construir mensaje
   │   │            8. Enviar notificación
   │   │            9. Registrar envío
   │   │            10. Actualizar estado
   │   │            11. Usuario visualiza
   │   │        • Flujos Alternos (4-6 típicos)
   │   │        • Excepciones (2-3 típicas)
   │   │        • Postcondiciones
   │   │        • BR aplicadas
   │   │        • FR derivados (5-8 típicos)
   │   │        • Trazabilidad
   │   │     
   │   │     4. Derivar FR para cada paso del flujo
   │   │     
   │   │     5. Crear job/scheduler si es automático
   │   │   
   │   │   OUTPUT:
   │   │     • UC completo (11+ pasos)
   │   │     • 5-8 FR derivados
   │   │     • Job scheduler configurado
   │
   └── Comparación con BR-046 (Inferencia):
       │
       │   BR-046: "Marcar VENCIDO al alcanzar fecha"
       │   ═══════════════════════════════════════════
       │   
       │   ¿Es observable? NO
       │   ¿Usuario ve algo? NO
       │   ¿Usuario actúa? NO
       │   
       │   NO genera UC, solo genera:
       │     FR-305: Update status = 'EXPIRED'
       │   
       │   DIFERENCIA CLAVE:
       │     BR-031: Usuario PERCIBE (notificación)
       │     BR-046: Solo cambio BD (invisible)

4. PATRÓN 3: CÁLCULO → FR DIRECTO (5,000 palabras)
   │
   ├── CONCEPTO:
   │   Una BR de tipo CÁLCULO típicamente NO genera UC,
   │   sino que se mapea directamente a un FR (función).
   │
   ├── EJEMPLO: BR-042 → FR-220
   │   │
   │   ├── BR-042 original (Cálculo):
   │   │   "Costo_Total = Precio_Unitario × Cantidad + 
   │   │                (Precio_Unitario × Cantidad × Tasa_Impuesto)"
   │   │
   │   ├── Análisis:
   │   │   Tipo: CÁLCULO
   │   │   Observable: NO (cálculo interno)
   │   │   Genera UC: NO
   │   │   Genera FR: SÍ (función de cálculo)
   │   │
   │   └── FR-220 GENERADO:
   │       │
   │       FR-220: Calcular Costo Total con Impuesto
   │       ══════════════════════════════════════════
   │       
   │       Origen: BR-042
   │       
   │       Descripción:
   │         Calcula el costo total de una solicitud incluyendo
   │         el subtotal y el impuesto aplicable.
   │       
   │       Fórmula:
   │         total_cost = (unit_price * quantity) * (1 + tax_rate)
   │       
   │       Firma de función:
   │         def calculate_total_cost(
   │             unit_price: Decimal,
   │             quantity: int,
   │             tax_rate: Decimal = 0.16
   │         ) -> Decimal
   │       
   │       Implementación Python:
   │         # api/apps/requests/calculators.py
   │         
   │         from decimal import Decimal
   │         
   │         class CostCalculator:
   │             """Cálculos de costos según BR-042."""
   │             
   │             TAX_RATE = Decimal('0.16')  # 16% IVA
   │             
   │             @staticmethod
   │             def calculate_total_cost(
   │                 unit_price: Decimal,
   │                 quantity: int,
   │                 tax_rate: Decimal = None
   │             ) -> Decimal:
   │                 """
   │                 Calcula costo total con impuesto.
   │                 
   │                 Args:
   │                     unit_price: Precio por unidad
   │                     quantity: Cantidad solicitada
   │                     tax_rate: Tasa de impuesto (default 0.16)
   │                 
   │                 Returns:
   │                     Decimal: Costo total
   │                 
   │                 Raises:
   │                     ValueError: Si params son negativos
   │                 
   │                 Example:
   │                     >>> calc = CostCalculator()
   │                     >>> calc.calculate_total_cost(
   │                     ...     Decimal('100'), 5
   │                     ... )
   │                     Decimal('580.00')
   │                 """
   │                 if unit_price < 0 or quantity < 0:
   │                     raise ValueError("Precio y cantidad deben ser ≥ 0")
   │                 
   │                 if tax_rate is None:
   │                     tax_rate = self.TAX_RATE
   │                 
   │                 subtotal = unit_price * quantity
   │                 total = subtotal * (1 + tax_rate)
   │                 
   │                 return total.quantize(Decimal('0.01'))
   │       
   │       Tests:
   │         # tests/test_calculators.py
   │         
   │         def test_calculate_total_cost_basic():
   │             calc = CostCalculator()
   │             result = calc.calculate_total_cost(
   │                 Decimal('100'), 5
   │             )
   │             assert result == Decimal('580.00')
   │         
   │         def test_calculate_total_cost_custom_tax():
   │             calc = CostCalculator()
   │             result = calc.calculate_total_cost(
   │                 Decimal('100'), 5, Decimal('0.08')
   │             )
   │             assert result == Decimal('540.00')
   │       
   │       Trazabilidad:
   │         BR-042 → FR-220 → calculators.py → test_calculators.py
   │
   └── ALGORITMO FORMAL:
       │
       │   PATRÓN 3: Cálculo → FR Directo
       │   ═══════════════════════════════
       │   
       │   INPUT:
       │     • BR de tipo CÁLCULO
       │   
       │   PASOS:
       │     1. Extraer fórmula matemática
       │     2. Identificar inputs (parámetros)
       │     3. Identificar output (resultado)
       │     4. Crear FR con firma de función
       │     5. Implementar como método estático o función pura
       │     6. Escribir tests unitarios
       │   
       │   OUTPUT:
       │     • FR (función)
       │     • Código implementado
       │     • Tests

5. PATRÓN 4: INFERENCIA → FR AUTOMÁTICO (5,500 palabras)
   │
   ├── EJEMPLO: BR-046 → FR-305
   │   [Ya documentado arriba en comparación]
   │
   └── Diferencia con Desencadenador:
       Sin interfaz de usuario, solo lógica de BD

6. PATRÓN 5: DECISIÓN → FLUJO ALTERNO (6,000 palabras)
   │
   ├── CONCEPTO:
   │   Una BR de tipo DECISIÓN se mapea típicamente
   │   a un FLUJO ALTERNO en un UC existente.
   │
   └── EJEMPLO: BR-038 → UC-13 (Flujo Alterno)
       [Documentación completa]

7. MATRIZ DE TRANSFORMACIÓN (1,000 palabras)
   │
   │   TABLA RESUMEN
   │   ═════════════
   │   
   │   ┌───────────────┬─────────────┬──────────────┬───────────┐
   │   │ Tipo de BR    │ Observable? │ Genera UC?   │ Genera FR?│
   │   ├───────────────┼─────────────┼──────────────┼───────────┤
   │   │ RESTRICCIÓN   │ Parcial     │ Como precond │ Sí        │
   │   │ DESENCADENADOR│ SÍ          │ SÍ (11 pasos)│ 5-8 FR    │
   │   │ CÁLCULO       │ NO          │ NO           │ Sí (1 FR) │
   │   │ INFERENCIA    │ NO          │ NO           │ Sí (1 FR) │
   │   │ DECISIÓN      │ Depende     │ Flujo alterno│ Sí        │
   │   └───────────────┴─────────────┴──────────────┴───────────┘

8-11. [Otras secciones con casos especiales, validaciones, etc.]
```

#### Problemas Identificados en PARTE 2A

```
PROBLEMA: Dominio Químicos - 50+ ocurrencias

Ejemplos a mapear:
  BR-028 → Químicos: $500 aprobación
  BR-031 → Químicos: Vencimiento 30 días
  BR-042 → Químicos: Costo con impuesto
  BR-046 → Químicos: Marcar VENCIDO
  BR-087 → Químicos: Certificación OSHA
  
  UC-04 → Químicos: Solicitar Producto
  UC-07 → Químicos: Notificar Vencimiento
  
  FR-207 → Químicos: Validar OSHA
  FR-220 → Químicos: Calcular costo
  FR-305 → Químicos: Update VENCIDO

Esfuerzo estimación: 15h para adaptar a IACT
```

---

[FIN DE PARTE 3 - CONTINÚA CON MAPEO QUÍMICOS→IACT]

