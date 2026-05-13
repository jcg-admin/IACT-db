# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 2

**PARTE 1, PARTE 2A, PARTE 2B, PARTE 2C - Análisis Detallado**

---

## CONTINUACIÓN: INVENTARIO DETALLADO CON ALGORITMOS

### 1.2 PARTE 1: IDENTIFICAR BUSINESS RULES - ANÁLISIS COMPLETO

**Archivo:** PARTE_1_IDENTIFICAR_REGLAS_NEGOCIO.md  
**Estado:** Guía metodológica completa  
**Tamaño:** 15,000 palabras (~60-70 páginas)  
**Líneas:** ~800  
**Fecha:** 2025-12-10

#### Estructura Detallada (12 secciones + 5 ejercicios)

```
PARTE 1: IDENTIFICAR BUSINESS RULES
════════════════════════════════════

1. INTRODUCCIÓN (1,500 palabras)
   ├── ¿Por qué necesitamos BR explícitas?
   ├── El problema de los requisitos implícitos
   └── Beneficios de la formalización

2. FUENTES DE BUSINESS RULES (2,000 palabras)
   │
   ├── FUENTE 1: Entrevistas con Stakeholders
   │   ├── Técnica: Preguntas STAR
   │   ├── Ejemplo: "Cuénteme de una compra rechazada"
   │   └── Extracción: BR-028 descubierta
   │
   ├── FUENTE 2: Documentación Existente
   │   ├── Políticas corporativas
   │   ├── Manuales de procedimientos
   │   └── Regulaciones externas
   │
   ├── FUENTE 3: Análisis de Sistemas Legacy
   │   ├── Técnica: Reverse engineering
   │   ├── Código → Lógica → BR
   │   └── Ejemplo: IF monto > 500 → BR-028
   │
   └── FUENTE 4: Observación Directa
       ├── Shadowing de usuarios
       ├── Análisis de casos reales
       └── Patrones emergentes

3. LOS 5 TIPOS DE BUSINESS RULES (3,500 palabras) ⭐⭐⭐
   │
   ├── TIPO 1: RESTRICCIÓN (Constraint)
   │   │
   │   ├── Definición:
   │   │   Establece límites sobre valores o acciones.
   │   │   Limita el espacio de soluciones válidas.
   │   │
   │   ├── Palabras clave:
   │   │   • "debe", "no debe", "obligatorio"
   │   │   • "solo si", "únicamente cuando"
   │   │   • "prohibido", "permitido solo"
   │   │   • "máximo", "mínimo", "entre"
   │   │
   │   ├── Estructura lógica:
   │   │   CONSTRAINT ::= [SUJETO] [VERBO_MODAL] [PREDICADO]
   │   │   
   │   │   Ejemplos:
   │   │     [Usuario] [debe] [tener certificación OSHA]
   │   │     [Solicitud] [no debe] [exceder presupuesto]
   │   │     [Cantidad] [debe estar] [entre 1 y 1000]
   │   │
   │   ├── Ejemplos del proyecto:
   │   │   │
   │   │   ├── BR-028 ⭐:
   │   │   │   "Solicitudes de compra con monto superior a $500
   │   │   │    DEBEN obtener aprobación del gerente de departamento"
   │   │   │   
   │   │   │   Análisis:
   │   │   │     Sujeto: Solicitudes de compra
   │   │   │     Condición: monto > $500
   │   │   │     Acción obligatoria: obtener aprobación gerente
   │   │   │     
   │   │   │   Formalización SBVR:
   │   │   │     It is obligatory that
   │   │   │       each purchase_request that has amount > 500
   │   │   │         obtains approval from department_manager
   │   │   │
   │   │   ├── BR-087:
   │   │   │   "Solo personal con certificación OSHA vigente
   │   │   │    puede manipular productos químicos peligrosos"
   │   │   │   
   │   │   │   Análisis:
   │   │   │     Sujeto: Personal
   │   │   │     Condición: tiene certificación OSHA vigente
   │   │   │     Acción permitida: manipular químicos peligrosos
   │   │   │     
   │   │   │   Formalización SBVR:
   │   │   │     It is obligatory that
   │   │   │       each person who handles hazardous_chemical
   │   │   │         has valid osha_certification
   │   │   │
   │   │   └── BR-033:
   │   │       "El departamento debe tener presupuesto disponible
   │   │        suficiente para cubrir la solicitud"
   │   │
   │   ├── Implementación típica:
   │   │   • Validaciones en formularios
   │   │   • Constraints en BD
   │   │   • Reglas en capa de negocio
   │   │
   │   └── ¿Genera UC?
   │       SÍ, si la restricción requiere acción del usuario
   │       Ej: BR-028 → UC-04 "Solicitar Producto" (paso aprobación)
   │
   ├── TIPO 2: CÁLCULO (Calculation)
   │   │
   │   ├── Definición:
   │   │   Deriva un valor mediante operación matemática o lógica.
   │   │   Función: Input → Fórmula → Output
   │   │
   │   ├── Palabras clave:
   │   │   • "calcular", "derivar", "obtener"
   │   │   • "sumar", "multiplicar", "promediar"
   │   │   • "resultado de", "producto de"
   │   │   • "equivale a", "se calcula como"
   │   │
   │   ├── Estructura lógica:
   │   │   CALCULATION ::= [OUTPUT] = f([INPUT1], [INPUT2], ...)
   │   │
   │   ├── Ejemplos del proyecto:
   │   │   │
   │   │   ├── BR-042:
   │   │   │   "Costo_Total = Precio_Unitario × Cantidad + 
   │   │   │                  (Precio_Unitario × Cantidad × Tasa_Impuesto)"
   │   │   │   
   │   │   │   Formalización:
   │   │   │     total_cost = (unit_price * quantity) * (1 + tax_rate)
   │   │   │   
   │   │   │   Implementación:
   │   │   │     def calculate_total_cost(unit_price, quantity, tax_rate):
   │   │   │         subtotal = unit_price * quantity
   │   │   │         tax = subtotal * tax_rate
   │   │   │         return subtotal + tax
   │   │   │
   │   │   ├── BR-055:
   │   │   │   "Fecha_Vencimiento = Fecha_Compra + Vida_Útil_Producto"
   │   │   │
   │   │   └── BR-062:
   │   │       "Descuento = Base × Porcentaje_Descuento"
   │   │
   │   └── ¿Genera UC?
   │       NO, solo genera FR (función de cálculo)
   │       Ej: BR-042 → FR-220 calculate_total_cost()
   │
   ├── TIPO 3: INFERENCIA (Inference)
   │   │
   │   ├── Definición:
   │   │   Deriva hechos nuevos a partir de hechos existentes.
   │   │   Si [CONDICIÓN] entonces [CONCLUSIÓN]
   │   │
   │   ├── Palabras clave:
   │   │   • "si...entonces", "implica que"
   │   │   • "cuando...automáticamente"
   │   │   • "al alcanzar...marcar como"
   │   │   • "deriva en", "resulta en"
   │   │
   │   ├── Estructura lógica:
   │   │   INFERENCE ::= IF [CONDICIÓN] THEN [ACCIÓN_AUTOMÁTICA]
   │   │
   │   ├── Ejemplo CLAVE del proyecto:
   │   │   │
   │   │   ├── BR-046 ⭐⭐⭐:
   │   │   │   "Cuando un contenedor químico alcanza su fecha de
   │   │   │    vencimiento, el sistema automáticamente marca su
   │   │   │    estado como VENCIDO"
   │   │   │   
   │   │   │   Análisis:
   │   │   │     Condición: contenedor.fecha_vencimiento == HOY
   │   │   │     Acción: contenedor.estado = 'VENCIDO'
   │   │   │     Ejecutor: SISTEMA (automático, sin usuario)
   │   │   │   
   │   │   │   Formalización SBVR:
   │   │   │     It is obligatory that
   │   │   │       each container that has expiration_date = today
   │   │   │         has status = 'EXPIRED'
   │   │   │   
   │   │   │   Implementación:
   │   │   │     # Job diario
   │   │   │     def update_expired_containers():
   │   │   │         expired = Container.objects.filter(
   │   │   │             expiration_date__lte=date.today(),
   │   │   │             status='ACTIVE'
   │   │   │         )
   │   │   │         expired.update(status='EXPIRED')
   │   │   │   
   │   │   │   CRÍTICO:
   │   │   │     • Usuario NO ve nada
   │   │   │     • Usuario NO actúa
   │   │   │     • Solo cambio en BD
   │   │   │     • NO genera UC, solo FR-305
   │   │   │
   │   │   └── Comparar con BR-031 (Desencadenador):
   │   │       BR-031 NOTIFICA al usuario (observable)
   │   │       BR-046 CAMBIA BD (no observable)
   │   │
   │   └── ¿Genera UC?
   │       NO, nunca genera UC
   │       Solo genera FR (lógica automática)
   │
   ├── TIPO 4: DESENCADENADOR (Action Enabler/Trigger)
   │   │
   │   ├── Definición:
   │   │   Dispara una acción observable cuando se cumple condición.
   │   │   Gatillo: [EVENTO] → [ACCIÓN_OBSERVABLE]
   │   │
   │   ├── Palabras clave:
   │   │   • "notificar cuando", "alertar si"
   │   │   • "enviar mensaje al alcanzar"
   │   │   • "activar proceso cuando"
   │   │   • "disparar acción si"
   │   │
   │   ├── Estructura lógica:
   │   │   TRIGGER ::= ON [EVENTO] DO [ACCIÓN_CON_USUARIO]
   │   │
   │   ├── Ejemplo CLAVE del proyecto:
   │   │   │
   │   │   ├── BR-031 ⭐⭐⭐:
   │   │   │   "El sistema debe notificar al coordinador de seguridad
   │   │   │    con 30 días de anticipación cuando un producto químico
   │   │   │    esté próximo a vencer"
   │   │   │   
   │   │   │   Análisis:
   │   │   │     Evento: días_hasta_vencimiento == 30
   │   │   │     Acción OBSERVABLE: Enviar notificación
   │   │   │     Receptor: Usuario (coordinador)
   │   │   │   
   │   │   │   Formalización SBVR:
   │   │   │     It is obligatory that
   │   │   │       each chemical_product that has 
   │   │   │         days_until_expiration = 30
   │   │   │       triggers notification to safety_coordinator
   │   │   │   
   │   │   │   Implementación (Job):
   │   │   │     def scan_expiring_products():
   │   │   │         threshold = date.today() + timedelta(days=30)
   │   │   │         expiring = Product.objects.filter(
   │   │   │             expiration_date=threshold,
   │   │   │             status='ACTIVE'
   │   │   │         )
   │   │   │         for product in expiring:
   │   │   │             notify_safety_coordinator(product)
   │   │   │   
   │   │   │   GENERA UC-07 COMPLETO:
   │   │   │     • 11 pasos
   │   │   │     • 6 flujos alternos
   │   │   │     • Interfaz de notificaciones
   │   │   │     • Usuario PERCIBE y ACTÚA
   │   │   │
   │   │   └── Diferencia con BR-046:
   │   │       BR-031: Usuario VE notificación → Observable → UC
   │   │       BR-046: Solo cambio BD → No observable → FR
   │   │
   │   └── ¿Genera UC?
   │       SÍ, SIEMPRE genera UC completo
   │       Usuario percibe y puede actuar
   │
   └── TIPO 5: DECISIÓN (Decision)
       │
       ├── Definición:
       │   Define caminos alternativos basados en criterios.
       │   Ruleset: [CRITERIOS] → [OPCIÓN_SELECCIONADA]
       │
       ├── Palabras clave:
       │   • "seleccionar", "elegir", "determinar"
       │   • "según criterios", "basado en"
       │   • "priorizar", "clasificar"
       │
       ├── Estructura lógica:
       │   DECISION ::= SELECT [OPCIÓN] WHERE [CRITERIO]
       │
       ├── Ejemplo del proyecto:
       │   │
       │   ├── BR-038:
       │   │   "La prioridad de envío se determina así:
       │   │     • URGENTE: Si inventario < 10% del stock mínimo
       │   │     • ALTA:    Si inventario < 25% del stock mínimo
       │   │     • NORMAL:  Si inventario >= 25% del stock mínimo"
       │   │   
       │   │   Implementación:
       │   │     def determine_shipping_priority(inventory, min_stock):
       │   │         percentage = (inventory / min_stock) * 100
       │   │         if percentage < 10:
       │   │             return 'URGENT'
       │   │         elif percentage < 25:
       │   │             return 'HIGH'
       │   │         else:
       │   │             return 'NORMAL'
       │   │
       │   └── BR-041:
       │       "Asignar laboratorio según tipo de producto:
       │         • Ácidos → Lab A
       │         • Bases → Lab B
       │         • Orgánicos → Lab C"
       │
       └── ¿Genera UC?
           Depende: Si usuario elige → SÍ
                    Si sistema decide → NO

4. TÉCNICA: Análisis de Lenguaje Natural (2,000 palabras)
   │
   ├── ALGORITMO: Extracción automática de BR
   │   │
   │   ├── Paso 1: Tokenización
   │   │   Entrada: "Solo usuarios certificados pueden aprobar"
   │   │   Tokens: [Solo, usuarios, certificados, pueden, aprobar]
   │   │
   │   ├── Paso 2: POS Tagging (Part-of-Speech)
   │   │   Solo       → ADV (adverbio restrictivo)
   │   │   usuarios   → NOUN
   │   │   certificados → ADJ
   │   │   pueden     → VERB_MODAL
   │   │   aprobar    → VERB
   │   │
   │   ├── Paso 3: Detección de patrones
   │   │   Patrón detectado:
   │   │     [RESTRICTOR] + [NOUN] + [QUALIFIER] + [MODAL] + [ACTION]
   │   │   
   │   │   Coincide con: RESTRICCIÓN
   │   │
   │   └── Paso 4: Extracción de componentes
   │       Sujeto: usuarios certificados
   │       Restricción: Solo
   │       Acción: aprobar
   │       Tipo: RESTRICCION
   │
   ├── Diccionario de palabras clave
   │   │
   │   ├── RESTRICCIÓN:
   │   │   debe, no debe, solo, únicamente, obligatorio,
   │   │   prohibido, permitido, máximo, mínimo
   │   │
   │   ├── CÁLCULO:
   │   │   calcular, derivar, sumar, multiplicar, resultado,
   │   │   producto de, total, promedio
   │   │
   │   ├── INFERENCIA:
   │   │   si, entonces, cuando, automáticamente, implica,
   │   │   deriva, marca como
   │   │
   │   ├── DESENCADENADOR:
   │   │   notificar, alertar, enviar, activar, disparar,
   │   │   gatillar, trigger
   │   │
   │   └── DECISIÓN:
   │       seleccionar, elegir, determinar, priorizar,
   │       clasificar, asignar según
   │
   └── Ejemplo completo de extracción:
       │
       Texto: "Cuando el inventario de un producto cae por debajo
               del 10% del stock mínimo, el sistema debe enviar una
               notificación urgente al gerente de compras"
       
       Paso 1: Identificar palabras clave
         • "Cuando" → Trigger temporal
         • "cae por debajo" → Condición numérica
         • "debe enviar" → Obligación
         • "notificación" → Acción observable
       
       Paso 2: Clasificar tipo
         Tiene "notificación" → Observable
         Tiene "cuando...debe enviar" → DESENCADENADOR
       
       Paso 3: Extraer componentes
         Evento: inventario < 0.10 * stock_minimo
         Acción: enviar_notificacion(gerente_compras)
         Prioridad: URGENTE
       
       Paso 4: Formalizar como BR
         BR-XXX (Desencadenador):
         "El sistema debe notificar al gerente de compras
          cuando el inventario caiga por debajo del 10%
          del stock mínimo"
       
       Paso 5: Verificar observabilidad
         ¿Usuario percibe? SÍ (recibe notificación)
         ¿Usuario actúa? SÍ (puede ordenar reposición)
         → GENERA UC completo

5. TÉCNICA: Entrevistas STAR (1,500 palabras)
   │
   ├── Metodología:
   │   S - Situation (Situación)
   │   T - Task (Tarea)
   │   A - Action (Acción)
   │   R - Result (Resultado)
   │
   ├── Ejemplo de entrevista:
   │   │
   │   Entrevistador: "Cuénteme de una vez que rechazaron
   │                   una solicitud de compra"
   │   
   │   Stakeholder (gerente):
   │     S: "El mes pasado, un solicitante pidió reactivos
   │         por $650"
   │     T: "Como gerente, debía revisar porque superaba
   │         los $500"
   │     A: "Revisé la justificación y el presupuesto.
   │         El presupuesto estaba OK, pero la justificación
   │         era vaga, así que la rechacé"
   │     R: "El solicitante reelaboró la justificación y
   │         la aprobé en segunda instancia"
   │   
   │   → EXTRACCIÓN:
   │       BR-028: Solicitudes >$500 requieren aprobación gerente
   │       BR-033: Debe haber presupuesto disponible
   │       BR-052: Justificación debe ser específica
   │
   └── Preguntas clave:
       • "¿Qué decisiones toma regularmente?"
       • "¿Qué validaciones realiza?"
       • "¿Qué políticas debe cumplir?"
       • "¿Cuándo rechaza una solicitud?"

6. TAXONOMÍA DE BR (1,000 palabras)
   [Clasificación jerárquica de BR]

7. PLANTILLA DE DOCUMENTACIÓN (1,500 palabras)
   │
   ├── Template de BR:
   │   │
   │   BR-NNN: [Título Descriptivo]
   │   ═══════════════════════════════
   │   
   │   Tipo: [Restricción|Cálculo|Inferencia|Desencadenador|Decisión]
   │   Prioridad: [Crítica|Alta|Media|Baja]
   │   Origen: [Stakeholder|Regulación|Legacy]
   │   
   │   Descripción:
   │     [Texto en lenguaje natural]
   │   
   │   Formalización SBVR:
   │     It is [obligatory|necessary|possible] that
   │       [regla formalizada]
   │   
   │   Ejemplo:
   │     [Caso concreto de aplicación]
   │   
   │   Excepciones:
   │     [Casos donde no aplica]
   │   
   │   Relaciones:
   │     Relacionada con: BR-XXX, BR-YYY
   │     Parte de: BRQ-NNN
   │     Aplica en: UC-MMM
   │   
   │   Trazabilidad:
   │     → BReq: BRQ-NNN
   │     → UC: UC-MMM (paso N)
   │     → FR: FR-PPP
   │     → Código: archivo.py::funcion()
   │   
   │   Historial:
   │     2024-01-15: Creación inicial
   │     2024-03-20: Actualización umbral $500 → $1000
   │
   └── Ejemplo completo: BR-028
       [Ver arriba en sección de Restricciones]

8. VALIDACIÓN DE BR (1,000 palabras)
   │
   ├── Checklist de calidad:
   │   □ BR es atómica (una sola regla)
   │   □ BR es testeable
   │   □ BR está formalizada en SBVR
   │   □ BR tiene trazabilidad
   │   □ BR tiene fuente documentada
   │   □ BR no contradice otras BR
   │   □ BR es comprensible por stakeholders
   │
   └── Técnicas de validación:
       • Revisión con stakeholders
       • Casos de prueba
       • Matriz de trazabilidad

9. PATRONES COMUNES (1,500 palabras)
   [Patrones recurrentes en BR]

10. ANTIPATRONES (1,000 palabras)
    │
    ├── Antipatrón 1: BR demasiado genérica
    │   ❌ MAL: "El sistema debe validar datos"
    │   ✅ BIEN: "El usuario debe ingresar email válido (RFC 5322)"
    │
    ├── Antipatrón 2: BR ambigua
    │   ❌ MAL: "Aprobar si es razonable"
    │   ✅ BIEN: "Aprobar si monto ≤ presupuesto disponible"
    │
    └── Antipatrón 3: Mezclar múltiples reglas
        ❌ MAL: "Validar usuario, presupuesto y stock"
        ✅ BIEN: Separar en BR-001, BR-002, BR-003

11. HERRAMIENTAS (500 palabras)
    │
    ├── Herramientas de documentación:
    │   • SBVR Toolkit
    │   • BR Repository (Excel/DB)
    │   • Diagrams (PlantUML para BR)
    │
    └── Herramientas de extracción:
        • NLP tools (spaCy, NLTK)
        • Text mining
        • Interview transcription tools

12. CONCLUSIÓN (500 palabras)
    │
    ├── Resumen de técnicas aprendidas
    ├── Importancia de BR explícitas
    └── Próximo paso → PARTE 2: Transformar BR → UC
```

#### Ejercicios Prácticos en PARTE 1

```
EJERCICIO 1: Clasificación de BR
════════════════════════════════

Clasifica las siguientes reglas de negocio por tipo:

1. "El descuento se calcula como: Base × 0.15"
   Tipo: ___________
   
2. "Si el cliente es VIP, aplicar descuento del 20%"
   Tipo: ___________
   
3. "Solo usuarios con rol ADMIN pueden eliminar registros"
   Tipo: ___________
   
4. "Notificar al supervisor cuando horas_extra > 10 en semana"
   Tipo: ___________
   
5. "Marcar pedido como RETRASADO si fecha_entrega < HOY"
   Tipo: ___________

SOLUCIONES:
  1. CÁLCULO
  2. DECISIÓN (o RESTRICCIÓN, según interpretación)
  3. RESTRICCIÓN
  4. DESENCADENADOR
  5. INFERENCIA


EJERCICIO 2: Prueba de Observabilidad
══════════════════════════════════════

Para cada BR, determina si genera UC completo o solo FR:

1. BR-046: "Marcar contenedor VENCIDO al alcanzar fecha"
   ¿Observable? ___
   Genera: UC / FR
   
2. BR-031: "Notificar vencimiento 30 días antes"
   ¿Observable? ___
   Genera: UC / FR
   
3. BR-042: "Costo = Precio × Cantidad × (1 + Impuesto)"
   ¿Observable? ___
   Genera: UC / FR
   
4. BR-028: "Compras >$500 requieren aprobación"
   ¿Observable? ___
   Genera: UC / FR

SOLUCIONES:
  1. NO observable → Solo FR-305
  2. SÍ observable → UC-07 completo
  3. NO observable → Solo FR-220
  4. SÍ observable → UC-04 (paso aprobación)


EJERCICIO 3: Extracción de BR de Texto
═══════════════════════════════════════

Extrae BR del siguiente texto de entrevista:

"En nuestra empresa, cualquier compra que supere los $500 debe
ser aprobada por el gerente del departamento. Además, solo el
personal con certificación vigente puede manipular químicos.
Cuando un químico está por vencer en 30 días, enviamos un email
al coordinador de seguridad. El costo total se calcula sumando
el subtotal más el 16% de IVA."

BRs extraídas:
  BR-001 (Restricción): _______________________
  BR-002 (Restricción): _______________________
  BR-003 (Desencadenador): ____________________
  BR-004 (Cálculo): ___________________________

SOLUCIONES:
  BR-001: Compras >$500 requieren aprobación gerente
  BR-002: Solo personal certificado maneja químicos
  BR-003: Notificar coordinador 30 días antes vencimiento
  BR-004: Costo = Subtotal × 1.16


EJERCICIO 4: Formalización SBVR
════════════════════════════════

Formaliza en SBVR la siguiente BR:

"Los usuarios del rol SUPERVISOR pueden aprobar solicitudes
de hasta $5,000. Para montos superiores, se requiere aprobación
del DIRECTOR"

SBVR:
  It is obligatory that
    ____________________________________
    ____________________________________

SOLUCIÓN:
  It is obligatory that
    each user who has role = 'SUPERVISOR'
      can approve purchase_request where amount <= 5000
  It is obligatory that
    each purchase_request where amount > 5000
      requires approval from user who has role = 'DIRECTOR'


EJERCICIO 5: Caso Completo de Extracción
═════════════════════════════════════════

[Caso extenso con 10+ BR para extraer de documento real]
```

#### Problemas Identificados en PARTE 1

```
┌────────────────────────────────────────────────────────┐
│ PROBLEMA: Dominio Químicos (100+ ocurrencias)         │
├────────────────────────────────────────────────────────┤
│ Términos a mapear:                                     │
│   • "producto químico" → "llamada IVR"                 │
│   • "certificación OSHA" → "rol RBAC"                  │
│   • "gerente" → "supervisor"                           │
│   • "solicitud de compra" → "consulta de reporte"     │
│   • "$500" → "10,000 registros"                        │
│   • "vencimiento" → "timeout/expiración"               │
│   • "inventario" → "disponibilidad de datos"           │
│                                                        │
│ Ejercicios afectados:                                  │
│   • Ejercicio 1-5: Todos usan químicos                 │
│   • Necesitan adaptación completa a IACT               │
└────────────────────────────────────────────────────────┘
```

#### Estimación de Actualización PARTE 1

```
┌────────────────────────────────────┬──────┬──────────┐
│ Tarea                              │ Hrs  │ Fase     │
├────────────────────────────────────┼──────┼──────────┤
│ 1. Mapeo terminológico             │ 2h   │ Prep     │
│ 2. Actualizar Sección 3 (5 tipos)  │ 3h   │ Fase 2   │
│ 3. Reescribir ejemplos BR-028,     │ 2h   │ Fase 2   │
│    BR-031, BR-046, BR-087          │      │          │
│ 4. Adaptar Ejercicio 1             │ 1h   │ Fase 2   │
│ 5. Adaptar Ejercicio 2             │ 1h   │ Fase 2   │
│ 6. Adaptar Ejercicio 3             │ 1.5h │ Fase 2   │
│ 7. Adaptar Ejercicio 4             │ 0.5h │ Fase 2   │
│ 8. Adaptar Ejercicio 5             │ 2h   │ Fase 2   │
│ 9. Actualizar algoritmos NLP       │ 2h   │ Fase 2   │
│ 10. Validar consistencia           │ 2h   │ Validación│
├────────────────────────────────────┼──────┼──────────┤
│ TOTAL PARTE 1                      │ 16h  │          │
└────────────────────────────────────┴──────┴──────────┘
```

---

[CONTINÚA EN SIGUIENTE SECCIÓN: PARTE 2A-2C]

