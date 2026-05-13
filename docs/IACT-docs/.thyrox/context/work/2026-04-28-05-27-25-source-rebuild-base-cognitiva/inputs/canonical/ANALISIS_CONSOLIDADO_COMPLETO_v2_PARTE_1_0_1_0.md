# ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0

**Análisis Integral Detallado con Algoritmos, Técnicas y Metodología Completa**

**Fecha de Análisis:** 2026-01-08  
**Versión del Análisis:** 2.0.0 (COMPLETO)  
**Estado:** EN PROGRESO - Parte 1 de 6  
**Alcance:** PARTES 0-2C COMPLETAS + CNST + UC + Algoritmos + Técnicas

---

## 🎯 METODOLOGÍA DE ESTE ANÁLISIS

### Principios
1. **Incremental:** Análisis en 6 partes, validado progresivamente
2. **Exhaustivo:** Incluye TODOS los algoritmos, técnicas, ejercicios
3. **Staging:** Usar /tmp para contenido extenso
4. **Nomenclatura:** Formato _MAJOR_MINOR_PATCH consistente
5. **Ejemplos Reales:** Solo dominio IACT (IVR Analytics)

### Técnica de Generación
```bash
# Generar cada parte en /tmp
cat > /tmp/ANALISIS_v2_PARTE_N.md << 'ENDOFPART'
[contenido completo]
ENDOFPART

# Validar
wc -l /tmp/ANALISIS_v2_PARTE_N.md

# Al final: Concatenar todas las partes
cat /tmp/ANALISIS_v2_PARTE_*.md > /tmp/ANALISIS_CONSOLIDADO_COMPLETO_v2_0_0.md
```

---

## TABLA DE CONTENIDO GENERAL

### PARTE 1: INVENTARIO DETALLADO (esta parte)
- Resumen Ejecutivo
- PARTE 0: Análisis completo con algoritmos
- PARTE 1: Análisis completo con taxonomía
- PARTE 2A: Análisis completo con 5 patrones
- Templates: Estructura completa

### PARTE 2: MAPEO QUÍMICOS → IACT
- Tabla maestra 30 filas
- Todos los BR mapeados (BR-028, BR-031, BR-046, BR-087, etc.)
- Todos los UC mapeados (UC-04, UC-07, etc.)
- Ejercicios adaptados

### PARTE 3: RBAC v5.1.1 COMPLETO
- 44 funciones detalladas
- 10 agrupadores con justificación
- SoD con ejemplos
- Código Python completo

### PARTE 4: CNST v1.0.0 → v1.1.0 DETALLADO
- 10 documentos analizados línea por línea
- Código Python de permisos COMPLETO
- Permisos temporales: implementación completa
- Patrones de diseño: 6 patrones documentados

### PARTE 5: UC v4.0.0 REGENERACIÓN
- 49 UC con plantilla completa (14 secciones)
- Diagramas PlantUML
- Trazabilidad BR→UC→FR
- Código de validación

### PARTE 6: PLAN DE ACTUALIZACIÓN 157H
- 10 fases detalladas
- Cronograma semana por semana
- Riesgos y mitigaciones
- Métricas y validación

---

## RESUMEN EJECUTIVO

### Situación Actual - TRIPLE DESCONEXIÓN

```
┌─────────────────────────────────────────────────────────────┐
│              PROBLEMA 1: DOMINIO INCORRECTO                  │
├─────────────────────────────────────────────────────────────┤
│ Documentación actual: Sistema de Gestión de Químicos        │
│ Proyecto real:       Sistema de Análisis de Llamadas IVR    │
│                                                              │
│ Impacto medido:                                              │
│   • PARTE 0: 150+ ocurrencias "químico/contenedor/labor"    │
│   • PARTE 1: 100+ ocurrencias                                │
│   • PARTE 2: 50+ ocurrencias                                 │
│   • Ejercicios: 100% dominio químicos                        │
│                                                              │
│ Ejemplos problemáticos:                                      │
│   BR-028: "Compras >$500 requieren aprobación gerente"      │
│   UC-04:  "Solicitar Producto Químico" (8 pasos)            │
│   BR-087: "Solo personal certificado OSHA maneja químicos"  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              PROBLEMA 2: RBAC OBSOLETO                       │
├─────────────────────────────────────────────────────────────┤
│ CNST v1.0.0:  Sistema de roles fijos (R001-R018)            │
│ Sistema real: RBAC v5.1.1 con 44 funciones atómicas         │
│                                                              │
│ Impacto arquitectónico:                                      │
│   • 10 documentos CNST: 9,621 líneas → 10,543 líneas        │
│   • CNST_005: Sistema de permisos COMPLETO a reescribir     │
│   • CNST_006: Antipatrones con referencias a roles          │
│   • CNST_010: Matriz ACCESS_MATRIX obsoleta                 │
│                                                              │
│ Cambio crítico:                                              │
│   ANTES: HasRole(['R004', 'R005'])                           │
│   AHORA: HasFunction('ve_reportes')                          │
│                                                              │
│ Distribución v5.1.1:                                         │
│   MOD_Auth:     4 funciones (gestiona_sesiones, etc.)       │
│   MOD_Users:   10 funciones (crea_usuarios, etc.)           │
│   MOD_Access:   6 funciones (asigna_funciones, etc.)        │
│   MOD_Pipeline: 4 funciones (supervisa_etl, etc.)           │
│   MOD_Reports:  8 funciones (ve_reportes, exporta_csv)      │
│   MOD_Alerts:   6 funciones (configura_alertas, etc.)       │
│   MOD_Audit:    4 funciones (consulta_auditoria, etc.)      │
│   MOD_Logs:     2 funciones (consulta_logs, etc.)           │
│   TOTAL:       44 funciones                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│         PROBLEMA 3: VERSIONADO SEMÁNTICO FALTANTE            │
├─────────────────────────────────────────────────────────────┤
│ Estado actual: Archivos SIN sufijo _X_Y_Z                   │
│ NOM_001 v2.0.0: Versionado OBLIGATORIO                       │
│                                                              │
│ Impacto:                                                     │
│   • ~60-80 archivos en base_cognitiva/ sin versión          │
│   • Imposible rastrear cambios                              │
│   • No compatible con Sphinx :version:                       │
│                                                              │
│ Formato requerido:                                           │
│   [PREFIX]_[NUM]_[Nombre]_MAJOR_MINOR_PATCH.rst             │
│                                                              │
│ Ejemplos correctos:                                          │
│   UC_AUTH_01_Iniciar_Sesion_4_0_0.rst                       │
│   BR_001_Cliente_Debe_Autenticarse_1_0_0.rst                │
│   FND_01_Contexto_y_Jerarquia_1_0_0.rst                     │
│   CNST_005_Seguridad_DRF_1_1_0.rst                          │
└─────────────────────────────────────────────────────────────┘
```

### Magnitud del Trabajo

```
┌──────────────────┬────────┬──────────┬──────┬───────────┐
│ Componente       │ Docs   │ Palabras │ Hrs  │ Prioridad │
├──────────────────┼────────┼──────────┼──────┼───────────┤
│ PARTE 0          │ 1      │ 18,000   │ 23h  │ 🔴 CRÍTICA│
│ PARTE 1          │ 1      │ 15,000   │ 16h  │ 🟠 ALTA   │
│ PARTE 2 (A+B+C)  │ 3      │ 95,000   │ 15h  │ 🟡 MEDIA  │
│ base_cognitiva/  │ 24     │ 60,000   │ 70h  │ 🟡 MEDIA  │
│ CNST v1.1.0      │ 11     │ 25,000   │ 5h   │ 🟠 ALTA   │
│ UC v4.0.0        │ 49     │ 25,000   │ 5h   │ 🟠 ALTA   │
│ Nomenclatura     │ ~80    │ -        │ 20h  │ 🟢 BAJA   │
│ Templates        │ 7      │ 8,000    │ 15h  │ 🟢 BAJA   │
│ Validación       │ -      │ -        │ 10h  │ 🟢 BAJA   │
├──────────────────┼────────┼──────────┼──────┼───────────┤
│ TOTAL            │ ~170   │ ~246,000 │ 179h │           │
└──────────────────┴────────┴──────────┴──────┴───────────┘

Distribución temporal:
  Semana 1: 39h  (PARTE 0 + PARTE 1)
  Semana 2: 47h  (base_cognitiva/ Grupo 1 + PARTE 2)
  Semana 3: 30h  (CNST + UC + Nomenclatura)
  Semana 4: 63h  (base_cognitiva/ Grupo 2 + Templates + Validación)
  
Equipo requerido:
  - Analista de Requisitos (49h)
  - Redactor Técnico (70h)
  - Arquitecto de Software (20h)
  - Developer Senior (10h)
  - Tech Lead (30h)
  TOTAL: ~180h (~23 días laborables)
```

---

## PARTE 1: INVENTARIO DETALLADO CON ALGORITMOS Y TÉCNICAS

### 1.1 PARTE 0: CONTEXTO Y FUNDAMENTOS - ANÁLISIS COMPLETO

**Archivo:** PARTE_0_CONTEXTO_FUNDAMENTOS.md  
**Estado:** Puente pedagógico - Dominio químicos  
**Tamaño:** 18,000 palabras (~40-50 páginas)  
**Líneas:** ~900  
**Fecha:** 2025-12-08

#### Estructura Detallada (7 secciones)

```
PARTE 0: EL PUENTE HACIA LA METODOLOGÍA
═══════════════════════════════════════

1. EL PROBLEMA (2,500 palabras)
   ├── 1.1 El Síntoma
   │   └── "Los programadores reciben requisitos ambiguos"
   │
   ├── 1.2 La Causa Raíz
   │   ├── Ausencia de jerarquía clara
   │   ├── BR → BReq → UC → FR no documentados
   │   └── Sin trazabilidad bidireccional
   │
   ├── 1.3 Las Consecuencias
   │   ├── Código que no refleja el negocio
   │   ├── Cambios propagados incorrectamente
   │   └── Deuda técnica acumulada
   │
   └── 1.4 Caso Ilustrativo ⭐⭐⭐
       └── UC-04: Solicitar Producto Químico (26 menciones)
           ├── Actor: Solicitante
           ├── Objetivo: Adquirir producto
           ├── 8 pasos detallados
           ├── Validaciones: BR-028, BR-087
           └── [PROBLEMA: Dominio químicos]

2. LA SOLUCIÓN (4,000 palabras) ⭐⭐⭐
   ├── 2.1 Jerarquía de 4 Niveles
   │   │
   │   ├── NIVEL 0: Business Rules (BR)
   │   │   ├── Origen: Negocio, regulaciones
   │   │   ├── Naturaleza: Atómica, inmutable
   │   │   ├── Formato: BR-NNN
   │   │   └── 5 tipos: Restricción, Cálculo, Inferencia, 
   │   │                Desencadenador, Decisión
   │   │
   │   ├── NIVEL 1: Business Requirements (BReq)
   │   │   ├── Agrupan múltiples BR
   │   │   ├── Objetivo de negocio
   │   │   └── Formato: BRQ-NNN
   │   │
   │   ├── NIVEL 2: User Requirements (UC)
   │   │   ├── Casos de uso observables
   │   │   ├── Interacción usuario-sistema
   │   │   ├── Formato: UC-NNN
   │   │   └── Estructura: 14 secciones
   │   │
   │   └── NIVEL 3: Functional Requirements (FR)
   │       ├── Requisitos implementables
   │       ├── 1 UC → N FR
   │       ├── Formato: RF-NNN
   │       └── Mapeo directo a código
   │
   ├── 2.2 Nivel 0: Business Rules
   │   ├── BR-028 ⭐ (Restricción - 23 menciones)
   │   │   └── "Compras >$500 requieren aprobación gerente"
   │   │
   │   └── BR-087 (Restricción - 10 menciones)
   │       └── "Solo personal certificado OSHA maneja químicos"
   │
   ├── 2.3 Nivel 1: Business Requirements
   │   └── BRQ-007: "Gestión de Adquisiciones"
   │       ├── Agrega: BR-028, BR-087, BR-033
   │       └── Objetivo: Control presupuestal
   │
   ├── 2.4 Nivel 2: User Requirements ⭐⭐⭐
   │   └── UC-04: Solicitar Producto Químico (26 menciones)
   │       ├── Actor: Solicitante [Agrupador AGR-001]
   │       ├── Objetivo: Adquirir producto para operación
   │       │
   │       ├── FLUJO NORMAL (8 pasos):
   │       │   1. Usuario inicia solicitud
   │       │   2. Sistema presenta formulario
   │       │   3. Usuario ingresa: producto, cantidad, justificación
   │       │   4. Sistema valida disponibilidad presupuestal
   │       │   5. [APLICACIÓN BR-028] ¿Monto >$500?
   │       │       SÍ → Requiere aprobación gerente
   │       │       NO → Continúa flujo
   │       │   6. [APLICACIÓN BR-087] Sistema valida certificación OSHA
   │       │   7. Sistema registra solicitud
   │       │   8. Sistema notifica al solicitante
   │       │
   │       ├── PRECONDICIONES:
   │       │   • Usuario autenticado
   │       │   • Usuario con certificación OSHA vigente (BR-087)
   │       │   • Presupuesto disponible en departamento
   │       │
   │       ├── POSTCONDICIONES:
   │       │   • Solicitud registrada con estado PENDIENTE
   │       │   • Notificación enviada a solicitante
   │       │   • Si >$500: Notificación a gerente
   │       │
   │       └── REGLAS APLICADAS:
   │           • BR-028: Umbral aprobación ($500)
   │           • BR-087: Certificación obligatoria
   │           • BR-033: Presupuesto disponible
   │
   ├── 2.5 Nivel 3: Functional Requirements
   │   │
   │   ├── FR-205: Validar Disponibilidad Presupuestal
   │   │   ├── Origen: UC-04 paso 4
   │   │   ├── Query SQL: 
   │   │   │   SELECT saldo_disponible 
   │   │   │   FROM presupuestos 
   │   │   │   WHERE departamento_id = :dept_id
   │   │   │     AND periodo = :periodo_actual
   │   │   └── Validación: saldo >= monto_solicitado
   │   │
   │   ├── FR-206: Validar Umbral Aprobación (BR-028)
   │   │   ├── Origen: UC-04 paso 5
   │   │   ├── Algoritmo:
   │   │   │   if monto_total > 500:
   │   │   │       solicitud.requiere_aprobacion = True
   │   │   │       solicitud.nivel_aprobador = 'GERENTE'
   │   │   │   else:
   │   │   │       solicitud.requiere_aprobacion = False
   │   │   └── Constante: UMBRAL_APROBACION = 500
   │   │
   │   └── FR-207: Validar Certificación OSHA (BR-087)
   │       ├── Origen: UC-04 paso 6
   │       ├── Query SQL:
   │       │   SELECT certificacion_osha_vigente
   │       │   FROM usuarios
   │       │   WHERE usuario_id = :usuario_id
   │       │     AND certificacion_fecha_vencimiento > CURDATE()
   │       └── Error: "Usuario sin certificación OSHA vigente"
   │
   ├── 2.6 Flujo de Influencia (Bidireccional)
   │   │
   │   ├── TOP-DOWN (Descomposición):
   │   │   BR-028 → BRQ-007 → UC-04 → FR-206
   │   │   "Una regla influye en múltiples niveles"
   │   │
   │   └── BOTTOM-UP (Trazabilidad):
   │       FR-206 → UC-04 → BRQ-007 → BR-028
   │       "Un cambio en código debe rastrearse al negocio"
   │
   └── 2.7 Diagrama Maestro de Jerarquía
       [Diagrama completo en la sección]

3. TRANSFORMACIONES CLAVE (3,500 palabras) ⭐⭐⭐
   │
   ├── 3.1 BR → UC: La Transformación Principal
   │   ├── Pregunta clave: ¿Esta BR es OBSERVABLE?
   │   ├── Prueba de Observabilidad:
   │   │   • ¿Un usuario PUEDE ejecutar una acción?
   │   │   • ¿El sistema RESPONDE de forma visible?
   │   │   • ¿Hay un ANTES y un DESPUÉS distinguibles?
   │   └── Resultado:
   │       OBSERVABLE → Genera UC completo
   │       NO OBSERVABLE → Solo FR directo
   │
   ├── 3.2 Los 5 Tipos de Business Rules
   │   │
   │   ├── TIPO 1: Restricción (Constraint)
   │   │   ├── Definición: Limita valores/acciones permitidas
   │   │   ├── Palabras clave: "debe", "no debe", "solo si"
   │   │   ├── Ejemplo BR-028 ⭐:
   │   │   │   "Solicitudes >$500 DEBEN obtener aprobación gerente"
   │   │   └── Genera UC: SÍ (solicitud de aprobación observable)
   │   │
   │   ├── TIPO 2: Cálculo (Calculation)
   │   │   ├── Definición: Deriva valores mediante fórmula
   │   │   ├── Palabras clave: "calcular", "sumar", "derivar"
   │   │   ├── Ejemplo BR-042:
   │   │   │   "Costo_Total = Precio_Unitario * Cantidad + Impuestos"
   │   │   └── Genera UC: NO (solo FR de cálculo)
   │   │
   │   ├── TIPO 3: Inferencia (Inference)
   │   │   ├── Definición: Deriva hechos de otros hechos
   │   │   ├── Palabras clave: "si...entonces", "implica"
   │   │   ├── Ejemplo BR-046:
   │   │   │   "Si contenedor alcanza fecha_vencimiento, 
   │   │   │    ENTONCES marcar estado=VENCIDO"
   │   │   └── Genera UC: NO (cambio interno, no observable)
   │   │
   │   ├── TIPO 4: Desencadenador (Action Enabler)
   │   │   ├── Definición: Dispara acción cuando condición se cumple
   │   │   ├── Palabras clave: "cuando", "al alcanzar", "trigger"
   │   │   ├── Ejemplo BR-031 ⭐:
   │   │   │   "Notificar vencimiento de químico 30 días antes"
   │   │   └── Genera UC: SÍ (notificación observable por usuario)
   │   │
   │   └── TIPO 5: Decisión (Decision)
   │       ├── Definición: Define caminos alternativos
   │       ├── Palabras clave: "seleccionar", "elegir"
   │       ├── Ejemplo BR-038:
   │       │   "Prioridad envío: URGENTE si inventario <10%, 
   │       │                       NORMAL si >=10%"
   │       └── Genera UC: Depende del contexto
   │
   ├── 3.3 Desencadenadores vs Inferencias ⭐⭐⭐ CRÍTICO
   │   │
   │   │   Este es el concepto MÁS IMPORTANTE y CONFUSO
   │   │   de toda la metodología. Se explica con un ejemplo
   │   │   cronológico de un contenedor químico que vence.
   │   │
   │   ├── ESCENARIO: Contenedor químico ID=C-1234
   │   │   ├── Fecha de compra: 2024-01-01
   │   │   ├── Fecha de vencimiento: 2024-12-31
   │   │   └── Estado inicial: ACTIVO
   │   │
   │   ├── LÍNEA DE TIEMPO:
   │   │
   │   │   T = 2024-12-01 (30 días antes de vencimiento)
   │   │   ┌────────────────────────────────────────────┐
   │   │   │ BR-031: DESENCADENADOR                     │
   │   │   │ "Notificar vencimiento 30 días antes"      │
   │   │   ├────────────────────────────────────────────┤
   │   │   │ • Job ejecuta: scan_expiring_containers()  │
   │   │   │ • Encuentra: C-1234 vence en 30 días       │
   │   │   │ • ACCIÓN OBSERVABLE:                       │
   │   │   │   - Envía notificación a Coordinador       │
   │   │   │   - Usuario VE el mensaje                  │
   │   │   │   - Puede ACTUAR (solicitar reposición)    │
   │   │   ├────────────────────────────────────────────┤
   │   │   │ GENERA UC-07: "Notificar Vencimiento"      │
   │   │   │ 11 pasos completos                         │
   │   │   │ 6 flujos alternos                          │
   │   │   └────────────────────────────────────────────┘
   │   │
   │   │   T = 2024-12-31 (fecha de vencimiento)
   │   │   ┌────────────────────────────────────────────┐
   │   │   │ BR-046: INFERENCIA                         │
   │   │   │ "Marcar VENCIDO al alcanzar fecha"         │
   │   │   ├────────────────────────────────────────────┤
   │   │   │ • Job ejecuta: update_expired_containers() │
   │   │   │ • Encuentra: C-1234.fecha = HOY            │
   │   │   │ • CAMBIO NO OBSERVABLE:                    │
   │   │   │   - UPDATE contenedores                    │
   │   │   │     SET estado = 'VENCIDO'                 │
   │   │   │     WHERE id = 'C-1234'                    │
   │   │   │   - Solo BD cambia                         │
   │   │   │   - Usuario NO recibe notificación         │
   │   │   │   - Usuario NO actúa                       │
   │   │   ├────────────────────────────────────────────┤
   │   │   │ NO GENERA UC                               │
   │   │   │ Solo genera FR-305: UPDATE directo         │
   │   │   └────────────────────────────────────────────┘
   │   │
   │   └── DIFERENCIA CRÍTICA:
   │       │
   │       ├── BR-031 (Desencadenador):
   │       │   • Usuario PERCIBE el evento (notificación)
   │       │   • Usuario PUEDE actuar (solicitar reposición)
   │       │   • Hay INTERFAZ de usuario
   │       │   • GENERA UC-07 completo
   │       │
   │       └── BR-046 (Inferencia):
   │           • Solo cambio en BD
   │           • Usuario NO percibe nada
   │           • Sin interfaz, sin notificación
   │           • GENERA solo FR-305 (query directo)
   │
   ├── 3.4 Trazabilidad Bidireccional
   │   │
   │   ├── Forward Tracing (BR → FR):
   │   │   BR-028 
   │   │     → BRQ-007
   │   │       → UC-04 (paso 5)
   │   │         → FR-206 (validación umbral)
   │   │           → approval_required.py (función)
   │   │             → test_approval_threshold.py
   │   │
   │   └── Backward Tracing (Código → BR):
   │       approval_required.py
   │         → test_approval_threshold.py
   │           → FR-206
   │             → UC-04
   │               → BRQ-007
   │                 → BR-028
   │
   └── 3.5 Propagación de Cambios
       │
       ├── CASO: BR-028 cambia de $500 a $1000
       │   │
       │   └── Impacto en cascada:
       │       1. BR-028: Actualizar texto
       │       2. BRQ-007: Revisar justificación
       │       3. UC-04 paso 5: Actualizar descripción
       │       4. FR-206: Cambiar constante UMBRAL = 1000
       │       5. approval_required.py: UMBRAL_APROBACION = 1000
       │       6. test_approval_threshold.py: Actualizar casos
       │       7. Documentación de usuario: Nueva política
       │
       └── SIN TRAZABILIDAD:
           • Solo cambiaría el código (paso 5)
           • Documentación desactualizada
           • Tests incorrectos
           • Usuarios confundidos

4. ALCANCE DEL MATERIAL (1,500 palabras)
   │
   ├── Las 6 Partes Documentadas:
   │   │
   │   ├── PARTE 0 (esta): Contexto y Fundamentos
   │   │   • Objetivo: Entender el PORQUÉ
   │   │   • 18,000 palabras
   │   │   • Caso ilustrativo: UC-04
   │   │
   │   ├── PARTE 1: Identificar Business Rules
   │   │   • Objetivo: Técnicas de extracción
   │   │   • 15,000 palabras
   │   │   • 5 ejercicios prácticos
   │   │
   │   ├── PARTE 2A: Fundamentos de Transformación
   │   │   • Objetivo: BR → UC paso a paso
   │   │   • 37,000 palabras
   │   │   • 5 patrones de transformación
   │   │
   │   ├── PARTE 2B: Construcción Detallada
   │   │   • Objetivo: Proceso de 7 pasos
   │   │   • 40,000 palabras
   │   │   • Plantilla completa de UC
   │   │
   │   ├── PARTE 2C: Casos Especiales
   │   │   • Objetivo: Situaciones complejas
   │   │   • 30,000 palabras
   │   │   • Checklist de calidad (26 puntos)
   │   │
   │   └── base_cognitiva/: Documentos fundacionales
   │       • 24 archivos RST
   │       • Ontologías, metamodelos, taxonomías
   │       • Estándares SBVR
   │
   └── Progreso actual:
       • PARTE 0: ✅ COMPLETO
       • PARTE 1: ✅ COMPLETO
       • PARTE 2A: ✅ COMPLETO
       • PARTE 2B: ✅ COMPLETO
       • PARTE 2C: ✅ COMPLETO
       • Templates: 5/12 generados

5. ROADMAP DETALLADO (5,000 palabras) ⭐⭐⭐
   │
   ├── 5.1 Ruta de Aprendizaje (Semanas 1-4)
   │
   ├── 5.2 Aplicación al Proyecto Real (Semanas 5-8)
   │
   ├── 5.3 Consolidación (Semanas 9-12)
   │
   └── 5.4 Mejora Continua (Semanas 13+)

6. CASOS DE USO REALES (3,000 palabras)
   │
   ├── UC-04: Solicitar Producto Químico ⭐⭐⭐
   │   [Ya documentado arriba en detalle]
   │
   ├── UC-07: Notificar Vencimiento Inminente
   │   [Detallado en sección 3.3]
   │
   └── Otros UC mencionados:
       • UC-12: Aprobar Solicitud de Compra
       • UC-18: Consultar Inventario
       • UC-25: Generar Reporte de Cumplimiento

7. CONCLUSIONES (1,500 palabras)
   │
   ├── 7.1 Beneficios de la Metodología
   │   • Trazabilidad completa
   │   • Propagación de cambios controlada
   │   • Código alineado con negocio
   │
   ├── 7.2 Desafíos Comunes
   │   • Confundir Desencadenadores con Inferencias
   │   • Omitir niveles de jerarquía
   │   • No documentar BR atómicas
   │
   └── 7.3 Próximos Pasos
       → Leer PARTE 1: "Identificar Business Rules"
```

#### Problemas Críticos Identificados en PARTE 0

```
┌────────────────────────────────────────────────────────────┐
│ PROBLEMA 1: Dominio Químicos (150+ ocurrencias)           │
├────────────────────────────────────────────────────────────┤
│ Ocurrencias identificadas:                                 │
│   • "producto químico": 45 veces                           │
│   • "contenedor": 28 veces                                 │
│   • "laboratorio": 18 veces                                │
│   • "certificación OSHA": 12 veces                         │
│   • "solicitud de compra": 22 veces                        │
│   • "fecha de vencimiento": 15 veces                       │
│   • "gerente de departamento": 10 veces                    │
│                                                            │
│ Ejemplos más usados:                                       │
│   • BR-028 (Restricción): 23 menciones                     │
│   • UC-04 (Solicitar Producto): 26 menciones               │
│   • BR-087 (Certificación): 10 menciones                   │
│   • BR-031 vs BR-046: 7+4 = 11 menciones (ejemplo clave)  │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ PROBLEMA 2: Mapeo IACT Requerido                          │
├────────────────────────────────────────────────────────────┤
│ Entidades a mapear:                                        │
│   Producto Químico → Llamada IVR                           │
│   Contenedor → Sesión IVR                                  │
│   Solicitud de Compra → Consulta de Reporte               │
│   Fecha de Vencimiento → Timeout/Expiración                │
│   Laboratorio → Cola IVR                                   │
│   Gerente → Supervisor de Centro                           │
│   Certificación OSHA → Rol/Permiso RBAC                    │
│                                                            │
│ BR a mapear:                                               │
│   BR-028: $500 → 10,000 registros                          │
│   BR-087: OSHA → Nivel de seguridad ≥3                     │
│   BR-031: 30 días → 12 minutos inactividad                 │
│   BR-046: Vencido → Estado EXPIRED                         │
└────────────────────────────────────────────────────────────┘
```

#### Algoritmos y Técnicas en PARTE 0

**ALGORITMO 1: Prueba de Observabilidad**

```python
def es_observable(business_rule):
    """
    Determina si una BR genera UC completo o solo FR.
    
    Args:
        business_rule: Regla de negocio a evaluar
    
    Returns:
        bool: True si genera UC, False si solo genera FR
    """
    # Paso 1: Identificar tipo de BR
    tipo = business_rule.tipo
    
    # Paso 2: Aplicar criterios de observabilidad
    if tipo == 'DESENCADENADOR':
        # Desencadenadores SIEMPRE son observables
        # Ej: BR-031 "Notificar vencimiento"
        return True
    
    elif tipo == 'INFERENCIA':
        # Inferencias NUNCA son observables
        # Ej: BR-046 "Marcar VENCIDO"
        return False
    
    elif tipo == 'RESTRICCION':
        # Restricciones: Verificar si hay acción de usuario
        # Ej: BR-028 "Requiere aprobación" → SÍ observable
        # Ej: BR-052 "Cantidad ≤ Stock" → NO observable (validación)
        return business_rule.requiere_interaccion_usuario
    
    elif tipo == 'CALCULO':
        # Cálculos: Solo si resultado se MUESTRA al usuario
        # Ej: "Costo Total" mostrado → SÍ observable
        # Ej: "Peso Total" interno → NO observable
        return business_rule.resultado_visible
    
    elif tipo == 'DECISION':
        # Decisiones: Verificar si usuario elige
        # Ej: "Usuario selecciona prioridad" → SÍ observable
        # Ej: "Sistema elige prioridad" → NO observable
        return business_rule.usuario_elige
    
    return False


# EJEMPLO DE USO:
br_028 = BusinessRule(
    id='BR-028',
    tipo='RESTRICCION',
    texto='Solicitudes >$500 requieren aprobación gerente',
    requiere_interaccion_usuario=True  # Usuario solicita aprobación
)

br_046 = BusinessRule(
    id='BR-046',
    tipo='INFERENCIA',
    texto='Marcar contenedor VENCIDO al alcanzar fecha'
)

print(es_observable(br_028))  # True → Genera UC-04
print(es_observable(br_046))  # False → Solo genera FR-305
```

**ALGORITMO 2: Propagación de Cambios**

```python
def propagar_cambio(elemento_origen, nuevo_valor):
    """
    Propaga cambio en jerarquía BR → BReq → UC → FR → Código.
    
    Args:
        elemento_origen: Elemento que cambió (BR, BReq, UC, FR)
        nuevo_valor: Nuevo valor del elemento
    
    Returns:
        list: Lista de elementos afectados
    """
    afectados = []
    
    # Paso 1: Identificar nivel del cambio
    nivel = elemento_origen.nivel
    
    if nivel == 'BR':
        # Cambio en BR: Afecta TODO hacia abajo
        breqs = buscar_breqs_con_br(elemento_origen)
        afectados.extend(breqs)
        
        for breq in breqs:
            ucs = buscar_ucs_con_breq(breq)
            afectados.extend(ucs)
            
            for uc in ucs:
                frs = buscar_frs_de_uc(uc)
                afectados.extend(frs)
                
                for fr in frs:
                    codigo = buscar_codigo_de_fr(fr)
                    afectados.extend(codigo)
    
    elif nivel == 'UC':
        # Cambio en UC: Afecta FR y código
        frs = buscar_frs_de_uc(elemento_origen)
        afectados.extend(frs)
        
        for fr in frs:
            codigo = buscar_codigo_de_fr(fr)
            afectados.extend(codigo)
    
    # Paso 2: Generar reporte de impacto
    reporte = {
        'origen': elemento_origen,
        'afectados': afectados,
        'acciones': generar_acciones_correctivas(afectados)
    }
    
    return reporte


# EJEMPLO: Cambio en BR-028
br_028_nuevo = BusinessRule(
    id='BR-028',
    texto='Solicitudes >$1000 requieren aprobación gerente',  # Cambió de $500 a $1000
    umbral=1000  # Nuevo valor
)

impacto = propagar_cambio(br_028_nuevo, 1000)
# Resultado:
# {
#   'origen': 'BR-028',
#   'afectados': [
#       'BRQ-007: Gestión de Adquisiciones',
#       'UC-04: Solicitar Producto (paso 5)',
#       'FR-206: Validar Umbral',
#       'approval_required.py',
#       'test_approval_threshold.py'
#   ],
#   'acciones': [
#       'Actualizar constante UMBRAL = 1000',
#       'Actualizar tests con nuevo umbral',
#       'Actualizar documentación de usuario'
#   ]
# }
```

**TÉCNICA 1: Descomposición de UC en FR**

```
ENTRADA: UC-04 "Solicitar Producto Químico"
  8 pasos en flujo normal
  3 flujos alternos
  2 excepciones

PROCESO:
  1. Por cada PASO del UC:
     → Identificar ACCIÓN del sistema
     → Si acción es VALIDACIÓN → Generar FR de validación
     → Si acción es CÁLCULO → Generar FR de cálculo
     → Si acción es PERSISTENCIA → Generar FR de BD
     → Si acción es NOTIFICACIÓN → Generar FR de mensaje
  
  2. Por cada REGLA aplicada:
     → BR-028 → FR-206 (Validar umbral)
     → BR-087 → FR-207 (Validar certificación)
     → BR-033 → FR-205 (Validar presupuesto)
  
  3. Por cada FLUJO ALTERNO:
     → Flujo aprobación → FR-208, FR-209
  
  4. Por cada EXCEPCIÓN:
     → Manejo de error → FR-210

SALIDA: 10 FR derivados
  FR-205: Validar Disponibilidad Presupuestal
  FR-206: Validar Umbral Aprobación
  FR-207: Validar Certificación OSHA
  FR-208: Registrar Solicitud
  FR-209: Notificar Solicitante
  FR-210: Notificar Gerente (si >$500)
  FR-211: Crear Registro Auditoría
  FR-212: Actualizar Presupuesto
  FR-213: Manejo Error Sin Presupuesto
  FR-214: Manejo Error Sin Certificación
```

**ESFUERZO ESTIMADO PARA ACTUALIZAR PARTE 0**

```
┌──────────────────────────────────┬──────┬──────────┐
│ Tarea                            │ Hrs  │ Fase     │
├──────────────────────────────────┼──────┼──────────┤
│ 1. Mapeo Químicos → IACT         │ 4h   │ Prep     │
│ 2. Reescribir Sección 1.4        │ 3h   │ Fase 1   │
│ 3. Reescribir Sección 2.4 (UC-04│ 2.5h │ Fase 1   │
│ 4. Actualizar Sección 3.3 (BR-031│ 2h   │ Fase 1   │
│ 5. Actualizar ejemplos BR-028    │ 1.5h │ Fase 1   │
│ 6. Actualizar ejemplos BR-087    │ 1h   │ Fase 1   │
│ 7. Revisar algoritmos            │ 2h   │ Fase 1   │
│ 8. Actualizar diagramas          │ 3h   │ Fase 1   │
│ 9. Revisar referencias cruzadas  │ 2h   │ Validación│
│ 10. Validar consistencia         │ 2h   │ Validación│
├──────────────────────────────────┼──────┼──────────┤
│ TOTAL PARTE 0                    │ 23h  │          │
└──────────────────────────────────┴──────┴──────────┘

Distribución:
  Preparación: 4h
  Fase 1 (Reescritura): 15h
  Validación: 4h
```

---

[FIN DE PARTE 1 - CONTINÚA EN PARTE 2]

