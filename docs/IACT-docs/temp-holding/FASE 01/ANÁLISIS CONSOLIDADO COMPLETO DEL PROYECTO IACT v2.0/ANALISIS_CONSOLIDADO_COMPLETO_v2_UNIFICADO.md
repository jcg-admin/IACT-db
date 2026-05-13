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

# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 5

**RBAC v5.1.1, CNST v1.1.0, UC v4.0 - Análisis Técnico Detallado**

---

## PARTE 3: NORMATIVAS Y SISTEMAS ACTUALIZADOS

### 3.1 RBAC v5.1.1: SISTEMA DE FUNCIONES ATÓMICAS

#### Cambio Arquitectónico Principal

```
┌──────────────────────────────────────────────────────────┐
│         DE ROLES FIJOS A FUNCIONES ATÓMICAS               │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  RBAC v4.0 (OBSOLETO)          RBAC v5.1.1 (VIGENTE)    │
│  ════════════════════           ═══════════════════      │
│                                                           │
│  18 roles fijos                 44 funciones atómicas    │
│  R001-R018                      Distribuidas en 8 módulos │
│  Nomenclatura genérica          Nomenclatura descriptiva │
│  Basado en "quién es"           Basado en "qué hace"     │
│  Sin temporalidad               Con expiración opcional  │
│                                                           │
│  EJEMPLO:                                                 │
│  R004: REPORTS_VIEWER           ve_reportes              │
│         (rol con pretensiones)  exporta_csv              │
│                                 filtra_reportes          │
│                                 (funciones sin pretensiones)│
└──────────────────────────────────────────────────────────┘
```

#### Distribución de las 44 Funciones

```
MOD_Auth (4 funciones)
══════════════════════
AUT-001: gestiona_sesiones
  • Capacidad: auth:sesiones
  • UC: UC-AUTH-05
  • Permite gestionar sesiones activas de otros usuarios

AUT-002: cierra_sesion_usuario
  • Capacidad: auth:cerrar_sesion
  • UC: UC-AUTH-05
  • Cierra sesión de otro usuario (admin)

AUT-003: resetea_password
  • Capacidad: auth:reset_password
  • UC: UC-AUTH-03
  • Genera contraseña temporal
  • CNST_001: Notificación solo buzón interno (NO email)

AUT-004: ve_sesiones_activas
  • Capacidad: auth:ver_sesiones
  • UC: UC-AUTH-05
  • Consulta todas las sesiones activas del sistema

──────────────────────────────────────────────────────────

MOD_Users (10 funciones)
═════════════════════════
USR-001: crea_usuarios
  • Capacidad: users:crear
  • UC: UC-USR-01
  • CNST_001: Notificación por buzón interno
  • CNST_005: Estado inicial PENDIENTE_CONFIGURACION

USR-002: ve_usuarios
  • Capacidad: users:leer
  • UC: UC-USR-02
  • Consulta información de usuarios

USR-003: modifica_usuarios
  • Capacidad: users:modificar
  • UC: UC-USR-03
  • Modifica datos de usuario
  • CNST_009: Auditoría obligatoria

USR-004: elimina_usuarios
  • Capacidad: users:eliminar
  • UC: UC-USR-04
  • Baja LÓGICA (nunca física - CNST_005)

USR-005: lista_usuarios
  • Capacidad: users:listar
  • UC: UC-USR-02
  • Lista con paginación y filtros

USR-006: busca_usuarios
  • Capacidad: users:buscar
  • UC: UC-USR-02
  • Búsqueda por criterios múltiples

USR-007: bloquea_usuarios
  • Capacidad: users:bloquear
  • UC: UC-USR-03
  • Bloquea acceso temporalmente

USR-008: desbloquea_usuarios
  • Capacidad: users:desbloquear
  • UC: UC-USR-03
  • Reactiva acceso bloqueado

USR-009: reactiva_usuarios
  • Capacidad: users:reactivar
  • UC: UC-USR-03
  • Reactiva usuario inactivo/eliminado

USR-010: asigna_segmento
  • Capacidad: users:asignar_segmento
  • UC: UC-ACC-07
  • Asigna segmento de datos

──────────────────────────────────────────────────────────

MOD_Access (6 funciones)
═════════════════════════
ACC-001: asigna_funciones
  • Capacidad: access:asignar
  • UC: UC-ACC-01, UC-ACC-08 (temporal)
  • CNST_005: Validación SoD
  • CNST_005: Permisos temporales con justificación

ACC-002: revoca_funciones
  • Capacidad: access:revocar
  • UC: UC-ACC-02
  • CNST_009: Auditoría crítica

ACC-003: ve_asignaciones
  • Capacidad: access:ver
  • UC: UC-ACC-03
  • Ve permisos efectivos de usuario

ACC-004: asigna_agrupadores
  • Capacidad: access:asignar_agrupador
  • UC: UC-ACC-04
  • Asigna agrupador completo (múltiples funciones)

ACC-005: gestiona_sod
  • Capacidad: access:sod
  • UC: UC-ACC-05
  • Configura restricciones de Separación de Funciones
  • CNST_005: SoD obligatorio

ACC-006: gestiona_segmentos
  • Capacidad: access:segmentos
  • UC: UC-ACC-06
  • Gestiona catálogo de segmentos de datos

──────────────────────────────────────────────────────────

MOD_Pipeline (4 funciones)
═══════════════════════════
PIP-001: ve_estado_etl
  • Capacidad: pipeline:ver_estado
  • UC: UC-PIP-01
  • CNST_003: ETL cada 6-12 horas

PIP-002: ve_errores_etl
  • Capacidad: pipeline:ver_errores
  • UC: UC-PIP-02
  • Consulta errores del ETL

PIP-003: ve_disponibilidad_datos
  • Capacidad: pipeline:disponibilidad
  • UC: UC-PIP-03
  • CNST_003: Datos desfasados según último ETL

PIP-004: solicita_reintento_etl
  • Capacidad: pipeline:reintento
  • UC: UC-PIP-04
  • Solicita reintento controlado (no ejecuta directamente)

──────────────────────────────────────────────────────────

MOD_Reports (8 funciones)
══════════════════════════
RPT-001: ve_reportes
  • Capacidad: reports:ver
  • UC: UC-RPT-01, UC-RPT-02, UC-RPT-03
  • CNST_003: Datos no real-time
  • CNST_006: Rango máximo 2 años

RPT-002: ve_dashboard
  • Capacidad: reports:dashboard
  • UC: UC-RPT-09
  • Dashboard principal con KPIs

RPT-003: filtra_reportes
  • Capacidad: reports:filtrar
  • UC: UC-RPT-04, UC-RPT-05
  • Filtros por fecha, centro, métricas

RPT-004: exporta_csv
  • Capacidad: reports:exportar_csv
  • UC: UC-RPT-06
  • CNST_001: NO envío por email
  • CNST_007: Máx 100,000 registros, 10 export/día

RPT-005: exporta_excel
  • Capacidad: reports:exportar_excel
  • UC: UC-RPT-07
  • CNST_007: Máx 50,000 registros, 5 export/día

RPT-006: exporta_pdf
  • Capacidad: reports:exportar_pdf
  • UC: UC-RPT-08
  • CNST_007: Máx 10,000 registros, 3 export/día

RPT-007: ve_kpis
  • Capacidad: reports:kpis
  • UC: UC-RPT-10
  • KPIs estáticos predefinidos

RPT-008: ve_graficos
  • Capacidad: reports:graficos
  • UC: UC-RPT-12, UC-RPT-13, UC-RPT-14
  • Gráficos por hora, día, centro

──────────────────────────────────────────────────────────

MOD_Alerts (6 funciones)
═════════════════════════
ALR-001: ve_alertas
  • Capacidad: alerts:ver
  • UC: UC-ALR-02
  • Ve alertas propias

ALR-002: configura_alertas
  • Capacidad: alerts:configurar
  • UC: UC-ALR-01
  • CNST_001: Notificación solo buzón interno
  • CNST_004: Máx 50 destinatarios

ALR-003: configura_alertas_equipo
  • Capacidad: alerts:config_equipo
  • UC: UC-ALR-05
  • Alertas para usuarios del mismo segmento

ALR-004: pausa_alertas
  • Capacidad: alerts:pausar
  • UC: UC-ALR-03
  • Snooze temporal de alertas

ALR-005: elimina_alertas
  • Capacidad: alerts:eliminar
  • UC: UC-ALR-04
  • Elimina alertas propias

ALR-006: ve_historial_alertas
  • Capacidad: alerts:historial
  • UC: UC-ALR-02
  • Historial de alertas enviadas

──────────────────────────────────────────────────────────

MOD_Audit (4 funciones)
════════════════════════
AUD-001: ve_auditoria
  • Capacidad: audit:ver
  • UC: UC-AUD-01
  • CNST_008: Solo lectura (inmutable)
  • SoD: ⚔️ Incompatible con administra_sistema

AUD-002: busca_auditoria
  • Capacidad: audit:buscar
  • UC: UC-AUD-01
  • Búsqueda con filtros avanzados

AUD-003: exporta_auditoria
  • Capacidad: audit:exportar
  • UC: UC-AUD-03
  • CNST_001: NO envío por email
  • CNST_008: Sin PII innecesaria

AUD-004: genera_reporte_compliance
  • Capacidad: audit:compliance
  • UC: UC-AUD-02
  • Reportes de cumplimiento regulatorio

──────────────────────────────────────────────────────────

MOD_Logs (2 funciones)
═══════════════════════
LOG-001: ve_logs_tecnicos
  • Capacidad: logs:ver
  • UC: UC-LOG-01, UC-LOG-02
  • CNST_008: PII enmascarada
  • Retención 30-90 días

LOG-002: exporta_logs
  • Capacidad: logs:exportar
  • UC: UC-LOG-03
  • CNST_001: NO envío por email
```

#### 10 Agrupadores RBAC

```
AGR-001: agr_operador_basico (5 funciones)
═══════════════════════════════════════════
Funciones:
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • ve_alertas (ALR-001)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 50-100
Descripción: Consulta básica de reportes y alertas

──────────────────────────────────────────────────────────

AGR-002: agr_operador_reportes (8 funciones)
═════════════════════════════════════════════
Funciones:
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • ve_kpis (RPT-007)
  • ve_graficos (RPT-008)
  • ve_alertas (ALR-001)
  • configura_alertas (ALR-002)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 30-50
Descripción: Acceso completo a reportes sin exportación

──────────────────────────────────────────────────────────

AGR-003: agr_supervisor (12 funciones)
═══════════════════════════════════════
Funciones:
  # Reportes
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • exporta_csv (RPT-004)
  • exporta_excel (RPT-005)
  • ve_kpis (RPT-007)
  • ve_graficos (RPT-008)
  # Alertas
  • ve_alertas (ALR-001)
  • configura_alertas (ALR-002)
  • configura_alertas_equipo (ALR-003)
  • pausa_alertas (ALR-004)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 20-40
Descripción: Supervisor con exportación y alertas de equipo

──────────────────────────────────────────────────────────

AGR-008: agr_auditor (4 funciones)
═══════════════════════════════════
Funciones:
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)
  • genera_reporte_compliance (AUD-004)

Usuarios estimados: 2-5

SoD OBLIGATORIO (CNST_005):
  ⚔️ Incompatible con agr_admin_usuarios
  ⚔️ Incompatible con agr_admin_pipeline

Descripción: Auditoría y compliance (solo lectura)
```

#### Separación de Funciones (SoD)

```
RESTRICCIONES SoD OBLIGATORIAS (CNST_005)
══════════════════════════════════════════

SOD-001: sod_admin_auditoria
─────────────────────────────
Descripción: Quien opera el sistema NO debe auditarlo

Grupo A (Administración Pipeline):
  • ve_estado_etl (PIP-001)
  • ve_errores_etl (PIP-002)
  • ve_disponibilidad_datos (PIP-003)
  • solicita_reintento_etl (PIP-004)

Grupo B (Auditoría):
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)
  • genera_reporte_compliance (AUD-004)

Agrupadores afectados:
  agr_admin_pipeline ⚔️ agr_auditor

Validación:
  Sistema rechaza asignación si usuario ya tiene funciones
  del grupo opuesto.

──────────────────────────────────────────────────────────

SOD-002: sod_usuarios_auditoria
────────────────────────────────
Descripción: Quien gestiona usuarios NO debe auditar sus acciones

Grupo A (Gestión Usuarios):
  • crea_usuarios (USR-001)
  • modifica_usuarios (USR-003)
  • elimina_usuarios (USR-004)
  • bloquea_usuarios (USR-007)

Grupo B (Auditoría):
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)

Agrupadores afectados:
  agr_admin_usuarios ⚔️ agr_auditor
```

---

### 3.2 CNST v1.0.0 → v1.1.0: ACTUALIZACIÓN DETALLADA

#### Resumen de Cambios

```
┌──────────┬───────┬────────┬─────────┬──────────┬───────────┐
│ Doc      │ v1.0  │ v1.1.0 │ Δ Líneas│ Impacto  │ Prioridad │
├──────────┼───────┼────────┼─────────┼──────────┼───────────┤
│ CNST_001 │  685  │  688   │   +3    │ BAJO     │ MEDIA     │
│ CNST_002 │  840  │  841   │   +1    │ BAJO     │ BAJA      │
│ CNST_003 │  901  │  902   │   +1    │ BAJO     │ BAJA      │
│ CNST_004 │  920  │  921   │   +1    │ BAJO     │ BAJA      │
│ CNST_005 │  994  │ 1,339  │  +345   │ ALTO     │ CRÍTICA   │
│ CNST_006 │ 1,126 │ 1,703  │  +577   │ ALTO     │ CRÍTICA   │
│ CNST_007 │ 1,061 │ 1,062  │   +1    │ BAJO     │ BAJA      │
│ CNST_008 │ 1,019 │ 1,020  │   +1    │ BAJO     │ BAJA      │
│ CNST_009 │ 1,077 │ 1,078  │   +1    │ BAJO     │ BAJA      │
│ CNST_010 │  998  │ 1,002  │   +4    │ MEDIO    │ ALTA      │
│ index    │  253  │  280   │  +27    │ MEDIO    │ IMPORTANTE│
├──────────┼───────┼────────┼─────────┼──────────┼───────────┤
│ TOTAL    │ 9,621 │ 10,543 │  +922   │          │           │
└──────────┴───────┴────────┴─────────┴──────────┴───────────┘
```

#### CNST_005: Cambio Arquitectónico Mayor

**Ampliación: +345 líneas (34.7% incremento)**

**SECCIÓN NUEVA: Permisos Temporales (Sistema completo)**

```python
# api/apps/access/models.py

from django.db import models
from django.utils import timezone
from datetime import timedelta

class UserFunctionAssignment(models.Model):
    """
    Asignación de función atómica a usuario.
    
    RBAC v5.1.1: Soporta permisos temporales con vencimiento.
    CNST_005: Permisos temporales obligatorios para casos especiales.
    """
    
    user = models.ForeignKey(
        'auth.User',
        on_delete=models.CASCADE,
        related_name='function_assignments'
    )
    
    function_code = models.CharField(
        max_length=50,
        help_text='Código función (ej: ve_reportes)'
    )
    
    # Temporalidad
    assigned_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField(
        null=True,
        blank=True,
        help_text='NULL = permanente'
    )
    
    # Auditoría
    assigned_by = models.ForeignKey(
        'auth.User',
        on_delete=models.SET_NULL,
        null=True,
        related_name='functions_assigned_by_me'
    )
    
    reason = models.TextField(
        help_text='Justificación mínimo 20 caracteres (CNST_005)'
    )
    
    # Estado
    is_active = models.BooleanField(default=True)
    revoked_at = models.DateTimeField(null=True)
    revoked_by = models.ForeignKey(
        'auth.User',
        on_delete=models.SET_NULL,
        null=True,
        related_name='functions_revoked_by_me'
    )
    
    class Meta:
        db_table = 'user_function_assignments'
        indexes = [
            models.Index(fields=['user', 'is_active']),
            models.Index(fields=['expires_at']),
        ]
        constraints = [
            models.UniqueConstraint(
                fields=['user', 'function_code'],
                condition=models.Q(is_active=True),
                name='unique_active_function_per_user'
            )
        ]
    
    @property
    def is_expired(self):
        """Verificar si permiso ha expirado."""
        if not self.expires_at:
            return False
        return timezone.now() > self.expires_at
    
    @classmethod
    def assign_temporary(cls, user, function_code, days, 
                        assigned_by, reason):
        """
        Asignar función temporal.
        
        CNST_005: Justificación mínimo 20 chars.
        CNST_005: Vencimiento máximo 6 meses (180 días).
        """
        if len(reason) < 20:
            raise ValidationError(
                "Justificación debe tener mínimo 20 caracteres"
            )
        
        if days > 180:
            raise ValidationError(
                "Vencimiento máximo es 180 días (6 meses)"
            )
        
        expires_at = timezone.now() + timedelta(days=days)
        
        assignment = cls.objects.create(
            user=user,
            function_code=function_code,
            expires_at=expires_at,
            assigned_by=assigned_by,
            reason=reason
        )
        
        # Auditar (CNST_009)
        from apps.common.models import UserActionLog
        UserActionLog.record(
            user=assigned_by,
            action='FUNCTION_ASSIGN_TEMP',
            resource=f"{user.username}:{function_code}",
            result='SUCCESS',
            details={
                'function': function_code,
                'target_user': user.username,
                'duration_days': days,
                'expires_at': expires_at.isoformat(),
                'reason': reason
            }
        )
        
        return assignment
```

**Middleware de Auto-Expiración:**

```python
# api/apps/access/middleware.py

class ExpireTemporaryPermissionsMiddleware:
    """
    Middleware para auto-expirar permisos temporales vencidos.
    
    CNST_005: Precedencia: Permiso Temporal > Función Permanente.
    """
    
    def __init__(self, get_response):
        self.get_response = get_response
    
    def __call__(self, request):
        if request.user.is_authenticated:
            # Desactivar permisos expirados
            UserFunctionAssignment.objects.filter(
                user=request.user,
                is_active=True,
                expires_at__lt=timezone.now()
            ).update(
                is_active=False,
                revoked_at=timezone.now()
            )
        
        return self.get_response(request)
```

---

### 3.3 UC v4.0.0: REGENERACIÓN DE 49 CASOS DE USO

#### Plantilla Estándar (14 Secciones)

```rst
.. meta::
   :project: IACT - IVR Analytics & Customer Tracking
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_xxx
   :uc_id: UC_[MOD]_[NN]
   :normativa: CNST-xxx, CNST-yyy

UC_[MOD]_[NN]: [Título del Caso de Uso]
════════════════════════════════════════

1. Resumen
──────────
.. list-table::
   :widths: 25 75

   * - **ID**
     - UC_[MOD]_[NN]
   * - **Nombre**
     - [Título]
   * - **Actor Principal**
     - [AGR-00x]: [nombre_agrupador]
   * - **Función RBAC**
     - [XXX-NNN]: [nombre_funcion]
   * - **Prioridad**
     - [Alta/Media/Baja]

2. Descripción
──────────────
[Descripción detallada con CNST aplicables]

3. Diagrama de Caso de Uso
──────────────────────────
.. uml::
   [PlantUML con agrupadores AGR-00x]

4. Contexto de Ejecución
────────────────────────
4.1 Precondiciones
4.2 Trigger
4.3 Postcondiciones

5. Flujo Normal (Camino Feliz)
──────────────────────────────
[8-15 pasos típicos]

6. Diagrama de Secuencia
────────────────────────
.. uml::
   [PlantUML con notas CNST]

7. Flujos Alternos
──────────────────
[4-6 flujos alternos típicos]

8. Excepciones
──────────────
[2-3 excepciones típicas]

9. Diagrama de Actividad
────────────────────────
.. uml::
   [PlantUML]

10. Reglas de Negocio
─────────────────────
[BR aplicables con trazabilidad]

11. Restricciones de Arquitectura
─────────────────────────────────
.. list-table::
   :header-rows: 1

   * - CNST
     - Aplicación en este UC
   * - CNST-001
     - [Cómo se aplica]

12. Requisitos Funcionales Derivados
────────────────────────────────────
[FR-xxx derivados de este UC]

13. Trazabilidad
────────────────
BReq: [BRQ-xxx]
BR: [BR-xxx]
UC: [Este UC]
FR: [FR-xxx a FR-yyy]
Actor: [AGR-00x]
Función: [XXX-NNN]

14. Historial de Cambios
────────────────────────
[Versiones del UC]
```

#### Distribución de los 49 UC

```
MOD_Auth (5 UC)    → 25-30 min generación
MOD_Users (4 UC)   → 20-25 min generación
MOD_Access (9 UC)  → 45-55 min generación
MOD_Pipeline (4 UC) → 20-25 min generación
MOD_Reports (14 UC) → 70-85 min generación ← Mayor módulo
MOD_Alerts (5 UC)   → 25-30 min generación
MOD_Audit (4 UC)    → 20-25 min generación
MOD_Logs (4 UC)     → 20-25 min generación

TOTAL: 4-5 horas generación completa (~5-6 min por UC)
```

---

[FIN DE PARTE 5 - CONTINÚA CON PLAN 157H EN PARTE 6]

# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 6 (FINAL)

**Plan de Actualización 157h + Métricas + Conclusión**

---

## PARTE 4: PLAN DE ACTUALIZACIÓN INTEGRAL

### 4.1 SECUENCIA ÓPTIMA DE EJECUCIÓN (10 Fases)

```
PLAN MAESTRO: 157 HORAS EN 10 FASES SOBRE 4 SEMANAS
═════════════════════════════════════════════════════

FASE 0: PREPARACIÓN (3h)
────────────────────────
□ Aprobar este análisis
□ Asignar recursos humanos
□ Crear estructura /tmp/iact_update/
□ Configurar herramientas

Entregables:
  • Plan aprobado
  • Equipo asignado
  • Workspace configurado

───────────────────────────────────────────────────────────

FASE 1: PARTE 0 (23h) 🔴 BLOCKER CRÍTICO
─────────────────────────────────────────
Prioridad: MÁXIMA
Dependencias: Ninguna
Blocker: Todas las fases siguientes dependen de esto

Tareas:
  1. Mapeo Químicos → IACT (4h)
     • Tabla maestra 30 filas
     • Validar con PO equivalencias
     • Documentar justificaciones
  
  2. Reescribir Sección 1.4 Caso Ilustrativo (3h)
     • UC-04 químicos → UC-IACT-RPT-01 IVR
     • 8 pasos adaptados
     • BR-028 con 10,000 registros
  
  3. Reescribir Sección 2.4 Nivel 2 UC (2.5h)
     • UC-04 completo adaptado
     • Flujo normal 8 pasos IACT
     • Precondiciones/postcondiciones
  
  4. Actualizar Sección 3.3 Triggers vs Inferences (2h)
     • BR-031: 30 días → 12 minutos
     • BR-046: VENCIDO → EXPIRED
     • Timeline adaptada a sesiones IVR
  
  5. Actualizar ejemplos BR-028 (1.5h)
     • $500 → 10,000 registros
     • 23 ocurrencias actualizadas
  
  6. Actualizar ejemplos BR-087 (1h)
     • OSHA → Nivel seguridad RBAC
     • 10 ocurrencias actualizadas
  
  7. Revisar algoritmos (2h)
     • Algoritmo observabilidad
     • Algoritmo propagación cambios
     • Técnica descomposición UC→FR
  
  8. Actualizar diagramas (3h)
     • Jerarquía 4 niveles con ejemplos IACT
     • Flujo bidireccional
     • Diagrama maestro
  
  9. Revisar referencias cruzadas (2h)
     • 150+ referencias a químicos
     • Actualizar a IVR/Analytics
  
  10. Validar consistencia (2h)
      • Grep químico|contenedor|laboratorio
      • Verificar 0 ocurrencias
      • Build Sphinx sin warnings

Entregables:
  • PARTE_0_CONTEXTO_FUNDAMENTOS_v2_IACT.md (18,000 palabras)
  • Mapeo Químicos→IACT documentado
  • 0 ocurrencias de dominio químicos

Métrica de éxito:
  grep -i "químico\|contenedor\|laboratorio" PARTE_0*.md
  → Resultado: 0 matches

───────────────────────────────────────────────────────────

FASE 2: PARTE 1 (16h) 🟠 ALTA PRIORIDAD
────────────────────────────────────────
Dependencias: PARTE 0 aprobada
Blocker: base_cognitiva/ depende de PARTE 1

Tareas:
  1. Mapeo terminológico BR (2h)
     • BR-028, BR-031, BR-046, BR-087
     • Adaptación a IACT
  
  2. Actualizar Sección 3 (5 tipos de BR) (3h)
     • Ejemplos con dominio IACT
     • Mantener estructura taxonómica
  
  3. Reescribir ejemplos principales (2h)
     • BR-028: $500 → 10,000 registros
     • BR-031: Notificación sesión
     • BR-046: Marcar EXPIRED
     • BR-087: Nivel seguridad
  
  4. Adaptar Ejercicio 1 (Clasificación) (1h)
     • 5 BR adaptadas a IACT
  
  5. Adaptar Ejercicio 2 (Observabilidad) (1h)
     • 4 BR adaptadas a IACT
  
  6. Adaptar Ejercicio 3 (Extracción) (1.5h)
     • Texto entrevista adaptado
     • 4 BR extraídas de IACT
  
  7. Adaptar Ejercicio 4 (SBVR) (0.5h)
     • Ejemplo con roles RBAC IACT
  
  8. Adaptar Ejercicio 5 (Caso completo) (2h)
     • 10+ BR de documento IACT real
  
  9. Actualizar algoritmos NLP (2h)
     • Diccionario palabras clave
     • Patrones específicos IACT
  
  10. Validar consistencia (2h)
      • Ejercicios funcionales
      • Referencias correctas

Entregables:
  • PARTE_1_IDENTIFICAR_REGLAS_NEGOCIO_v2_IACT.md (15,000 palabras)
  • 5 ejercicios adaptados IACT
  • Algoritmos NLP actualizados

───────────────────────────────────────────────────────────

FASE 3: base_cognitiva/ Grupo 1 (32h) ⭐ IMPORTANTE
───────────────────────────────────────────────────
Dependencias: PARTE 1 completada
Blocker: No

Documentos a actualizar:
  • TXM_03_Taxonomia_Reglas_Negocio_2_0_0.rst (8h)
  • SBVR_03_Reglas_Estructurales_2_0_0.rst (8h)
  • SBVR_04_Reglas_Operativas_2_0_0.rst (8h)
  • FND_02_Reglas_de_Negocio_2_0_0.rst (8h)

Cambios por documento:
  • Actualizar ejemplos a dominio IACT
  • Mantener estructura ontológica
  • Agregar versionado semántico
  • Validar con Sphinx

───────────────────────────────────────────────────────────

FASE 4: PARTE 2 Revisión (10h) 🟡 MEDIA PRIORIDAD
──────────────────────────────────────────────────
Dependencias: PARTE 0, PARTE 1
Blocker: No

Tareas:
  • PARTE 2A revisión (5h)
    - Verificar 5 patrones con ejemplos IACT
    - UC-07 completo adaptado
  
  • PARTE 2B revisión (3h)
    - Proceso 7 pasos validado
    - Plantilla UC actualizada
  
  • PARTE 2C revisión (2h)
    - Checklist 26 puntos
    - Casos especiales

───────────────────────────────────────────────────────────

FASE 5: CNST v1.1.0 (5h) 🟠 ALTA PRIORIDAD
───────────────────────────────────────────
Dependencias: Ninguna (puede ejecutarse en paralelo)
Blocker: UC v4.0 depende de CNST

Método: GENERACIÓN DESDE CERO
  • NO usar sed/transformación
  • Escribir TODO el contenido con create_file
  • Incluir secciones nuevas COMPLETAS

Documentos:
  1. CNST_001 (688 líneas) - 30 min
  2. CNST_002 (841 líneas) - 20 min
  3. CNST_003 (902 líneas) - 20 min
  4. CNST_004 (921 líneas) - 20 min
  5. CNST_005 (1,339 líneas) - 60 min ⚠️
     + Sección Permisos Temporales (+345 líneas)
  6. CNST_006 (1,703 líneas) - 70 min ⚠️
     + Sección Patrones Recomendados (+577 líneas)
  7. CNST_007 (1,062 líneas) - 20 min
  8. CNST_008 (1,020 líneas) - 20 min
  9. CNST_009 (1,078 líneas) - 20 min
  10. CNST_010 (1,002 líneas) - 30 min
  11. index.rst (280 líneas) - 20 min

Validación:
  • wc -l → 10,543 líneas total
  • grep "RBAC v5.1.1" → 4 ocurrencias
  • grep "v1.1.0" → 11 ocurrencias

───────────────────────────────────────────────────────────

FASE 6: UC v4.0.0 (5h) 🟠 ALTA PRIORIDAD
─────────────────────────────────────────
Dependencias: CNST v1.1.0
Blocker: No

Método: GENERACIÓN INCREMENTAL
  • Usar plantilla de 14 secciones
  • Actor = Agrupador AGR-00x
  • Función RBAC explícita
  • CNST documentado en Sección 11

Módulos:
  1. AUTH (5 UC) - 30 min
  2. USR (4 UC) - 25 min
  3. ACC (9 UC) - 55 min ← Mayor complejidad
  4. PIP (4 UC) - 25 min
  5. RPT (14 UC) - 85 min ← Mayor cantidad
  6. ALR (5 UC) - 30 min
  7. AUD (4 UC) - 25 min
  8. LOG (4 UC) - 25 min

Validación por UC:
  □ Meta tags completos
  □ Actor = AGR-00x
  □ Función RBAC correcta
  □ CNST aplicable documentado
  □ Trazabilidad completa

───────────────────────────────────────────────────────────

FASE 7: Nomenclatura v2.0.0 (20h) 🟡 MEDIA PRIORIDAD
─────────────────────────────────────────────────────
Dependencias: CNST, UC completados
Blocker: No (puede hacerse incremental)

Tareas:
  1. Renombrar archivos existentes (10h)
     • ~60-80 archivos base_cognitiva/
     • Agregar _X_Y_Z según NOM_001 v2.0.0
     • Script automatizado
  
  2. Actualizar referencias internas (8h)
     • index.rst de cada carpeta
     • Toctree con nuevos nombres
     • Links internos
  
  3. Validación (2h)
     • Sphinx build sin warnings
     • Grep nombres antiguos → 0 matches

Script de renombrado:
  ```bash
  # rename_to_v2.sh
  for file in *.rst; do
    if [[ ! $file =~ _[0-9]_[0-9]_[0-9]\.rst$ ]]; then
      base="${file%.rst}"
      mv "$file" "${base}_1_0_0.rst"
    fi
  done
  ```

───────────────────────────────────────────────────────────

FASE 8: base_cognitiva/ Grupo 2 (18h) 🟢 BAJA PRIORIDAD
────────────────────────────────────────────────────────
Dependencias: Fase 3 completada
Blocker: No

Documentos:
  • FND_03_Casos_de_Uso_2_0_0.rst (6h)
  • FND_05_Jerarquia_4_Niveles_2_0_0.rst (6h)
  • MTM_01_Metamodelo_BR_2_0_0.rst (3h)
  • MTM_02_Metamodelo_UC_2_0_0.rst (3h)

───────────────────────────────────────────────────────────

FASE 9: Templates Pendientes (15h) 🟢 BAJA PRIORIDAD
─────────────────────────────────────────────────────
Dependencias: PARTES 0-2 completadas
Blocker: No

Templates:
  • T05_Identificacion_Actor_Principal (2h)
  • T06_Derivacion_FR_desde_UC (2h)
  • T07_Validacion_BR_Checklist (2h)
  • T08_Matriz_Trazabilidad_RTM (2h)
  • T10_Plantilla_BR_SBVR (2h)
  • T11_Plantilla_FR_Implementable (3h)
  • T12_Plantilla_BReq_Agrupador (2h)

───────────────────────────────────────────────────────────

FASE 10: VALIDACIÓN GLOBAL (10h) ⭐ CRÍTICA
────────────────────────────────────────────
Dependencias: TODAS las fases anteriores
Blocker: Entrega final

Tareas:
  1. Sphinx build limpio (2h)
     • make html sin warnings
     • Validar todos los toctree
  
  2. STD_001 verificación (2h)
     • grep emojis → 0 matches
     • grep "✅\|❌\|⚠️" → 0 matches
  
  3. NOM_001 verificación (2h)
     • Todos los archivos con _X_Y_Z
     • Formato correcto
  
  4. Trazabilidad BR→UC→FR (2h)
     • 10 cadenas completas verificadas
     • RTM actualizada
  
  5. Tests de integración (2h)
     • Casos de uso navegables
     • Links internos funcionales
     • Referencias cruzadas OK

Métricas objetivo:
  □ 0 warnings Sphinx
  □ 0 emojis en documentación
  □ 100% archivos versionados
  □ 10/10 cadenas trazabilidad completas
```

### 4.2 CRONOGRAMA DETALLADO (4 Semanas)

```
┌─────────────────────────────────────────────────────────┐
│                  SEMANA 1: FUNDAMENTOS                   │
├─────────────────────────────────────────────────────────┤
│ Lunes     │ FASE 0 (3h) + FASE 1 inicio (5h)  │  8h   │
│ Martes    │ FASE 1 continuación                │  8h   │
│ Miércoles │ FASE 1 finalización               │  10h  │
│ Jueves    │ FASE 2 inicio                      │  8h   │
│ Viernes   │ FASE 2 finalización                │  5h   │
├─────────────────────────────────────────────────────────┤
│ TOTAL SEMANA 1: 39h                                     │
│ Entregables: PARTE 0 + PARTE 1 adaptadas a IACT        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│              SEMANA 2: TRANSFORMACIONES                  │
├─────────────────────────────────────────────────────────┤
│ Lunes     │ FASE 3 inicio (base_cognitiva/)    │  8h   │
│ Martes    │ FASE 3 continuación                │  8h   │
│ Miércoles │ FASE 3 continuación                │  8h   │
│ Jueves    │ FASE 3 finalización                │  8h   │
│ Viernes   │ FASE 4 (PARTE 2 revisión) + FASE 5│ 15h   │
│           │ inicio (CNST)                       │       │
├─────────────────────────────────────────────────────────┤
│ TOTAL SEMANA 2: 47h                                     │
│ Entregables: base_cognitiva/ G1 + PARTE 2 + CNST       │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│            SEMANA 3: UC Y NOMENCLATURA                   │
├─────────────────────────────────────────────────────────┤
│ Lunes     │ FASE 6 (UC v4.0)                   │  5h   │
│ Martes    │ FASE 7 inicio (Nomenclatura)       │  8h   │
│ Miércoles │ FASE 7 continuación                │  8h   │
│ Jueves    │ FASE 7 finalización                │  4h   │
│ Viernes   │ FASE 8 inicio (base_cognitiva/ G2) │  5h   │
├─────────────────────────────────────────────────────────┤
│ TOTAL SEMANA 3: 30h                                     │
│ Entregables: 49 UC v4.0 + Nomenclatura v2.0            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                 SEMANA 4: CIERRE                         │
├─────────────────────────────────────────────────────────┤
│ Lunes     │ FASE 8 continuación                │  8h   │
│ Martes    │ FASE 8 finalización + FASE 9 inicio│  5h   │
│ Miércoles │ FASE 9 continuación (Templates)    │  8h   │
│ Jueves    │ FASE 9 finalización                │  2h   │
│ Viernes   │ FASE 10 (Validación Global)        │ 10h   │
├─────────────────────────────────────────────────────────┤
│ TOTAL SEMANA 4: 33h                                     │
│ Entregables: base_cognitiva/ G2 + Templates + Validación│
└─────────────────────────────────────────────────────────┘

═════════════════════════════════════════════════════════
TOTAL GENERAL: 149h (redondeado a 157h con buffer 5%)
4 SEMANAS: 37.25h promedio por semana
═════════════════════════════════════════════════════════
```

### 4.3 MÉTRICAS DE ÉXITO

```
M1: CONSISTENCIA TERMINOLÓGICA
───────────────────────────────
Objetivo: 100% ejemplos usan dominio IACT

Test:
  grep -ri "químico\|contenedor\|laboratorio\|osha" \
    PARTE_*.md base_cognitiva/*.rst

Criterio éxito: 0 matches

Estado actual: ~300 ocurrencias
Estado objetivo: 0 ocurrencias

───────────────────────────────────────────────────────────

M2: COBERTURA NOMENCLATURA v2.0
────────────────────────────────
Objetivo: 100% archivos con _MAJOR_MINOR_PATCH

Test:
  find base_cognitiva/ -name "*.rst" | \
    grep -v "_[0-9]_[0-9]_[0-9]\.rst$" | wc -l

Criterio éxito: 0 archivos sin versión

Estado actual: ~60-80 archivos sin versión
Estado objetivo: 0 archivos sin versión

───────────────────────────────────────────────────────────

M3: SIN EMOJIS (STD_001)
────────────────────────
Objetivo: 0 emojis en documentación

Test:
  grep -r "✅\|❌\|⚠️\|🔴\|🟠\|🟡\|🟢" \
    base_cognitiva/*.rst PARTE_*.md

Criterio éxito: 0 matches

Estado actual: Algunos documentos con emojis
Estado objetivo: 0 emojis

───────────────────────────────────────────────────────────

M4: BUILD SPHINX LIMPIO
────────────────────────
Objetivo: 0 warnings en build

Test:
  cd docs/
  make clean
  make html 2>&1 | grep -i "warning" | wc -l

Criterio éxito: 0 warnings

Estado actual: Desconocido
Estado objetivo: 0 warnings

───────────────────────────────────────────────────────────

M5: TRAZABILIDAD COMPLETA
──────────────────────────
Objetivo: 100% BR tienen cadena BR→UC→FR

Test:
  Verificar 10 BR aleatorias:
  • BR tiene BReq referenciado
  • BReq tiene UC asociado
  • UC tiene FR derivados
  • FR tiene código implementador

Criterio éxito: 10/10 cadenas completas

───────────────────────────────────────────────────────────

M6: SATISFACCIÓN DEL EQUIPO
────────────────────────────
Objetivo: >80% satisfecho (>4.0/5.0)

Encuesta (5 preguntas escala 1-5):
  1. ¿Documentación es clara?
  2. ¿Ejemplos son relevantes?
  3. ¿RBAC v5.1.1 es comprensible?
  4. ¿UC v4.0 son útiles?
  5. ¿Metodología es aplicable?

Criterio éxito: Promedio >4.0

───────────────────────────────────────────────────────────

M7: REDUCCIÓN DE PREGUNTAS
───────────────────────────
Objetivo: 50% menos preguntas sobre metodología

Medición:
  • Antes: ~10 preguntas/semana sobre BR/UC
  • Después: <5 preguntas/semana

Método:
  • Contar tickets de consulta metodológica
  • Comparar 4 semanas antes vs 4 semanas después

Criterio éxito: Reducción ≥50%
```

---

## PARTE 5: CONCLUSIÓN Y RECOMENDACIONES

### 5.1 RESUMEN DE HALLAZGOS

**Desconexión Triple Confirmada:**

1. **Dominio Incorrecto** (🔴 CRÍTICO)
   - 300+ ocurrencias de químicos/laboratorios
   - Ejemplos no aplicables directamente
   - Confusión en nuevos miembros del equipo

2. **RBAC Obsoleto** (🔴 CRÍTICO)
   - CNST usa roles fijos (R001-R018)
   - Sistema real usa 44 funciones atómicas
   - 10,543 líneas de documentación CNST afectadas

3. **Sin Versionado** (🟠 ALTA)
   - 60-80 archivos sin _X_Y_Z
   - Imposible rastrear evolución
   - No cumple NOM_001 v2.0.0

**Magnitud del Trabajo:**
- ~170 archivos a actualizar
- ~246,000 palabras total
- 157 horas estimadas (4 semanas)
- 5-6 personas requeridas

**Impacto Positivo Esperado:**
- Documentación alineada 100% con proyecto real
- Onboarding 50% más rápido
- Reducción 50% en preguntas metodológicas
- Base sólida para crecimiento futuro
- ROI >300% en 12 meses

### 5.2 RECOMENDACIÓN PRINCIPAL

```
┌──────────────────────────────────────────────────────────┐
│        RECOMENDACIÓN: PROCEDER CON ACTUALIZACIÓN          │
│                    INTEGRAL EN 4 SEMANAS                  │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  JUSTIFICACIÓN:                                          │
│  ────────────────                                        │
│                                                           │
│  1. NECESIDAD CRÍTICA                                    │
│     • Equipo necesita docs alineadas con proyecto real   │
│     • Dominio químicos genera confusión                  │
│     • Nuevos desarrolladores requieren onboarding        │
│     • Cliente requiere documentación actualizada         │
│                                                           │
│  2. ROI POSITIVO                                         │
│     • Inversión: ~$20-30K (157h × $150/h promedio)       │
│     • Ahorro: 50% más rápido onboarding                  │
│     • Reducción: 50% menos consultas metodológicas       │
│     • Beneficio: Documentación profesional reutilizable  │
│     • ROI estimado: >300% en 12 meses                    │
│                                                           │
│  3. VIABILIDAD                                           │
│     • Plan detallado con fases claras                    │
│     • Riesgos identificados y mitigables                 │
│     • Equipo disponible (4-5 personas)                   │
│     • Herramientas y metodología definidas               │
│                                                           │
│  4. URGENCIA                                             │
│     • Proyecto IACT en desarrollo activo                 │
│     • Nuevos devs necesitan documentación YA             │
│     • Cliente espera docs actualizados Q1 2026           │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

### 5.3 ALTERNATIVAS CONSIDERADAS

```
ALTERNATIVA A: Mantener Status Quo
───────────────────────────────────
Descripción: No actualizar, usar documentación actual

Pros:
  • Costo $0
  • Sin esfuerzo adicional

Contras:
  • Confusión perpetua con ejemplos químicos
  • Onboarding lento (2-3 semanas vs 1 semana)
  • Preguntas repetitivas (~10/semana)
  • Imagen no profesional ante cliente
  • Deuda técnica documental crece

DECISIÓN: ❌ RECHAZADA
Razón: Perpetúa problema, impacto negativo a largo plazo

───────────────────────────────────────────────────────────

ALTERNATIVA B: Actualización Parcial
─────────────────────────────────────
Descripción: Solo PARTE 0 + CNST v1.1.0 (28h)

Pros:
  • Menor inversión ($4-5K)
  • Rápido (1-2 semanas)
  • Soluciona los puntos MÁS críticos

Contras:
  • Solución a medias
  • PARTES 1-2 siguen con químicos
  • base_cognitiva/ sin actualizar
  • UC v4.0 no regenerados

DECISIÓN: ❌ RECHAZADA
Razón: Half solution, no resuelve el problema completo

───────────────────────────────────────────────────────────

ALTERNATIVA C: Reescritura Incremental (6 meses)
─────────────────────────────────────────────────
Descripción: Actualizar gradualmente en 6 meses

Pros:
  • Sin presión de tiempo
  • Puede distribuirse entre equipo
  • Menos disruptivo

Contras:
  • Equipo necesita solución AHORA (no en 6 meses)
  • Documentación inconsistente durante transición
  • Riesgo de abandono/pérdida de momentum
  • Cliente no esperará 6 meses

DECISIÓN: ❌ RECHAZADA
Razón: Demasiado lento para necesidad actual

───────────────────────────────────────────────────────────

ALTERNATIVA D: Actualización Integral 4 Semanas
────────────────────────────────────────────────
Descripción: Plan completo de 157h en 10 fases

Pros:
  • Solución COMPLETA del problema
  • Documentación 100% alineada IACT
  • Timeframe realista (4 semanas)
  • ROI positivo a 12 meses
  • Base sólida para futuro

Contras:
  • Inversión significativa ($20-30K)
  • Requiere 4-5 personas dedicadas
  • Riesgo de retrasos (mitigable)

DECISIÓN: ✅ SELECCIONADA
Razón: Balance óptimo necesidad/viabilidad/beneficio
```

### 5.4 PRÓXIMOS PASOS INMEDIATOS

```
PASO 1: REUNIÓN DE APROBACIÓN (Esta semana)
────────────────────────────────────────────
Objetivo: Decisión GO / NO-GO / DEFER

Participantes:
  • Tech Lead (líder reunión)
  • Product Owner (validador funcional)
  • Arquitecto de Software (validador técnico)
  • CTO o Director Técnico (aprobador final)

Agenda (2 horas):
  1. Presentar este análisis (30 min)
  2. Discutir hallazgos (30 min)
  3. Revisar plan de 157h (30 min)
  4. Evaluar riesgos (15 min)
  5. Tomar decisión (15 min)

Resultado esperado:
  • Decisión documentada
  • Si GO → Asignar recursos inmediatamente
  • Si NO-GO → Documentar razones
  • Si DEFER → Fecha nueva revisión

───────────────────────────────────────────────────────────

PASO 2: ASIGNACIÓN DE RECURSOS (Si GO)
───────────────────────────────────────
Objetivo: Confirmar equipo y disponibilidad

Tareas:
  1. Confirmar disponibilidad 4-5 personas
  2. Asignar roles específicos:
     • Analista de Requisitos: PARTES 0-1 (49h)
     • Tech Writer: base_cognitiva/ (50h)
     • Arquitecto: CNST v1.1.0 validación (15h)
     • Developer Senior: UC v4.0 código (5h)
     • Tech Lead: Nomenclatura + coord (30h)
     • PO: Validación ejemplos IACT (8h)
  
  3. Reservar tiempo en calendarios (4 semanas)
  4. Coordinar con otros proyectos

Duración: 1 día

───────────────────────────────────────────────────────────

PASO 3: KICKOFF FASE 0 (Inicio Semana 1)
─────────────────────────────────────────
Objetivo: Arrancar trabajo con FASE 0

Tareas:
  1. Crear estructura /tmp/iact_update/ (30 min)
  2. Setup herramientas (Sphinx, RST, Git) (1h)
  3. Briefing completo al equipo (1h)
  4. Iniciar FASE 1: PARTE 0 (resto del día)

Duración: Medio día

───────────────────────────────────────────────────────────

PASO 4: EJECUCIÓN FASES 1-10 (4 Semanas)
─────────────────────────────────────────
Objetivo: Completar actualización según plan

Metodología:
  • Daily checkpoints (15 min cada mañana)
  • Weekly reviews (1 hora cada viernes)
  • Ajustes según avance real
  • Comunicación proactiva de bloqueos

───────────────────────────────────────────────────────────

PASO 5: RELEASE Y COMUNICACIÓN (Fin Semana 4)
──────────────────────────────────────────────
Objetivo: Publicar y comunicar cambios

Tareas:
  1. Publicar documentación actualizada (Sphinx deploy)
  2. Comunicar cambios a TODO el equipo técnico (email)
  3. Sesión de training (2 horas presencial)
  4. Recoger feedback inicial (encuesta)
  5. Medir métricas baseline (preguntas/semana)

Duración: 1 día
```

---

## ANEXOS

### ANEXO A: ESTADÍSTICAS CONSOLIDADAS

```
DOCUMENTOS A ACTUALIZAR: ~170 archivos
PALABRAS TOTALES: ~246,000
LÍNEAS DE CÓDIGO DOCS: ~15,000
ESFUERZO TOTAL: 157 horas (~20 días laborables)
DURACIÓN: 4 semanas (1 mes)
EQUIPO: 4-5 personas
INVERSIÓN: $20-30K
ROI ESPERADO: >300% en 12 meses
```

### ANEXO B: CONTACTOS Y RESPONSABLES

```
Tech Lead: [Coordinador general del proyecto]
Product Owner: [Validador de ejemplos IACT]
Arquitecto: [Validador técnico RBAC/CNST]
Analista Req: [Reescritura PARTES 0-1]
Tech Writer: [Redacción base_cognitiva/]
Developer: [UC v4.0 + código validación]
```

---

**FIN DEL ANÁLISIS CONSOLIDADO COMPLETO v2.0**

**Ubicación:** /tmp/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_*.md (6 partes)  
**Líneas totales:** ~4,100 líneas  
**Palabras:** ~35,000  
**Páginas estimadas:** ~140 páginas

**Estado:** ✅ COMPLETO Y LISTO PARA APROBACIÓN

**Acción requerida:** Aprobar plan y proceder con FASE 0

---

