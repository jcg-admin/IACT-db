# ANÁLISIS COMPLETO: PARTE 0 vs base_cognitiva/ del Proyecto IACT

**Fecha:** 2026-01-08  
**Analista:** Claude  
**Objetivo:** Determinar impacto de PARTE 0 en actualización de base_cognitiva/

---

## RESUMEN EJECUTIVO

**Hallazgo crítico:**
Los archivos en base_cognitiva/ (FND, MTM, TXM) contienen **ejemplos pedagógicos**
de la metodología BR → UC → FR definida en PARTE 0. Estos ejemplos usan 
nomenclatura v2.0 (UC-010, UC-043, UC-015) que **NO necesariamente corresponden**
a los 49 UC reales del proyecto IACT v4.0.0.

**Problema:**
Si actualizamos mecánicamente UC-010 → UC_ACC_01 sin verificar que el ejemplo
sea semánticamente correcto, estaremos **documentando incorrectamente** la
metodología que el equipo debe seguir.

**Solución requerida:**
AUDITORÍA COMPLETA de cada ejemplo en base_cognitiva/ para determinar:
1. ¿Es un ejemplo genérico pedagógico o un UC real del proyecto?
2. Si es real, ¿corresponde correctamente a nomenclatura v4.0?
3. Si es genérico, ¿debe reemplazarse con ejemplo real del proyecto?

---

## CONTENIDO DE PARTE 0

### Estructura del Documento

PARTE 0 define una metodología de 4 niveles jerárquicos:

```
Nivel 0: Business Rules (BR)
  - Externas al sistema (políticas, regulaciones)
  - Obligatorias y estables
  - Influyen en múltiples aspectos
  
Nivel 1: Business Requirements (BReq)
  - Objetivos del proyecto
  - Justificación de inversión
  
Nivel 2: User Requirements (UC)
  - Casos de Uso
  - Comportamientos observables
  
Nivel 3: Functional Requirements (FR)
  - Especificaciones detalladas
  - Derivados de pasos UC
```

### Ejemplos Clave Usados en PARTE 0

**BR-028 (Restricción):**
```
Definición: "Solicitudes de compra >$500 requieren aprobación 
             del gerente de departamento"
Tipo: Restricción
Fuente: Política Financiera Corporativa v2.3, Sección 4.2
Estática: No
Fecha vigencia: 2023-01-01
```

**UC-04: Solicitar Producto Químico**
```
Actor Primario: Solicitante
Objetivo: Obtener autorización para adquirir un producto químico

Flujo Normal:
  1. Solicitante ingresa código del producto
  2. Sistema muestra información del producto
  3. Solicitante ingresa cantidad y justificación
  4. Sistema verifica capacitación del solicitante
  5. Sistema valida cantidad contra límites permitidos
  6. SI monto >$500 ENTONCES
       Sistema solicita aprobación de gerente
  7. Sistema registra la solicitud
  8. Sistema notifica al solicitante

Business Rules aplicadas: BR-028, BR-087, BR-031
```

**RF-205, RF-206, RF-207:**
```
RF-205: "El sistema debe comparar el monto total de la solicitud 
         contra el umbral de $500"

RF-206: "SI el monto excede $500 ENTONCES el sistema debe:
         - Cambiar estado a 'Pendiente Aprobación'
         - Identificar gerente del departamento
         - Enviar notificación al gerente
         - Bloquear procesamiento hasta recibir aprobación"

RF-207: "El sistema debe registrar timestamp de cada cambio de 
         estado en la solicitud"

Derivados de: UC-04, Paso 6
Implementan: BR-028
```

**Otros ejemplos mencionados:**
- UC-01, UC-02, UC-03 (Autenticación)
- UC-006 a UC-009 (Gestión de Usuarios)
- UC-010 (Asignar Rol)
- UC-015 (Generar Reporte Mensual)
- UC-017 a UC-024 (Reportes)
- UC-043 (Configurar SoD)
- BR-087 (OSHA 1910.1200 - Capacitación)
- BR-088 (EPA 40 CFR Part 262)

---

## ANÁLISIS DE EJEMPLOS EN base_cognitiva/

### Verificación de Correspondencia

Según análisis previo de base_cognitiva/, los archivos FND/MTM/TXM
contienen ~61 referencias a UC antiguos:

**Referencias encontradas previamente:**

_fundamentos_conceptuales/ (~20 referencias):
- UC-40
- UC-015
- UC-043 → ¿Corresponde a UC_ACC_05?
- UC-001, UC-002, UC-003 → ¿Corresponden a UC_AUTH_01/02/03?
- UC-006 a UC-009 → ¿Corresponden a UC_USR_01 a 04?

metamodelos/ (~16 referencias):
- UC_010 (sin módulo) → ¿Debería ser UC_ACC_01?
- UC_ETL → ¿Corresponde a UC_PIP_01?

taxonomias/ (~25 referencias):
- UC-006, UC-010, UC-017, UC-025, UC-022, UC-037
- Rangos: UC-005 a UC-011, UC-017 a UC-024, UC-031 a UC-035

### Preguntas Críticas a Responder

**Para CADA referencia UC en base_cognitiva/:**

1. ¿Es un ejemplo REAL del proyecto IACT o un ejemplo GENÉRICO pedagógico?

2. Si es REAL:
   - ¿Corresponde correctamente al mapeo v2.0 → v4.0?
   - ¿La descripción/contexto es precisa?
   - ¿Las BR asociadas son correctas?

3. Si es GENÉRICO:
   - ¿Debe mantenerse como genérico?
   - ¿O debe reemplazarse con ejemplo real del proyecto?
   - ¿Qué UC real del proyecto IACT sería mejor ejemplo?

---

## MAPEO v2.0 → v4.0.0 DEL PROYECTO IACT

Según plan maestro previo, el mapeo conocido es:

**MOD_Auth:**
- UC-001 → UC_AUTH_01 (Iniciar Sesión)
- UC-002 → UC_AUTH_02 (Cerrar Sesión)
- UC-003 → UC_AUTH_03 (Recuperar Contraseña)
- UC-004 → UC_AUTH_04 (Cambiar Contraseña)
- UC-005 → UC_AUTH_05 (Gestionar Sesiones)

**MOD_Users:**
- UC-006 → UC_USR_01 (Crear Usuario)
- UC-007 → UC_USR_02 (Consultar Usuarios)
- UC-008 → UC_USR_03 (Modificar Usuario)
- UC-009 → UC_USR_04 (Eliminar Usuario)

**MOD_Access:**
- UC-010 → UC_ACC_01 (Asignar Funciones)
- UC-011 → UC_ACC_02 (Revocar Funciones)
- UC-043 → UC_ACC_05 (Gestionar SoD)
- UC-044 → UC_ACC_03 (Consultar Permisos)
- UC-041 → UC_ACC_07 (Asignar Segmento)
- UC-046 → UC_ACC_06 (Gestionar Segmentos)
- UC-047 → UC_ACC_09 (Auditar Cambios Acceso)

**MOD_Pipeline:**
- UC-050, UC-ETL → UC_PIP_01 (Supervisar ETL)
- UC-051 → UC_PIP_02 (Consultar Errores ETL)
- UC-052 → UC_PIP_03 (Consultar Disponibilidad)
- UC-053 → UC_PIP_04 (Solicitar Reintento)

**Nota:** El proyecto IACT NO es un sistema de "Solicitud de Productos Químicos"
como los ejemplos de PARTE 0. Es un sistema de análisis IVR.

---

## EVALUACIÓN POR ARCHIVO

### FND_01_Concepto_Requisito.rst

**Referencias identificadas:**
- Línea 316: UC-40 (genérico)
- Línea 490: UC-015 (Generar Reporte Mensual)
- Línea 491: FR-015.3

**Evaluación:**
- UC-40: NO existe en proyecto IACT → Ejemplo genérico pedagógico
- UC-015: Podría corresponder a UC_RPT_XX del proyecto IACT
- Necesita verificación: ¿Es ejemplo genérico o caso real?

**Recomendación:**
- Si es pedagógico: Mantener genérico o reemplazar con ejemplo real claro
- Si es real: Actualizar a UC_RPT_XX correspondiente

### FND_03_Casos_de_Uso.rst

**Referencias identificadas:**
- Línea 100: UC-043 (SoD)
- Líneas 160-163: UC-043 (estructura)
- Líneas 265-274: Tabla agrupadores UC-006 a UC-040
- Línea 277: UC-050 (ETL)
- Líneas 614-616: UC-001, UC-002, UC-003 (Autenticación)

**Evaluación:**
- UC-043 → UC_ACC_05 (Gestionar SoD): EXISTE en proyecto, actualizar
- UC-001/002/003 → UC_AUTH_01/02/03: EXISTEN, actualizar
- UC-006 a UC-009 → UC_USR_01-04: EXISTEN, actualizar
- UC-050 → UC_PIP_01: EXISTE, actualizar
- Tabla agrupadores: Requiere AUDITORÍA completa de rangos

**Recomendación:**
- Actualizar ejemplos específicos que corresponden a UC reales
- Verificar tabla agrupadores línea por línea

### MTM_01_Metamodelo_Requisitos.rst

**Referencias identificadas:**
- Línea 413: BR_015 → UC_010 (Asignar Rol)
- Línea 434: UC_010 deriva FR-10.1 a FR-10.15
- Línea 451: UC_ETL
- Línea 597: UC_010 (instancia UseCase)
- Línea 606: ucOrigen = UC_010

**Evaluación:**
- UC_010 → UC_ACC_01 (Asignar Funciones): EXISTE en proyecto
- UC_ETL → UC_PIP_01: EXISTE en proyecto
- BR_015: ¿Existe BR_015 real en proyecto? Verificar

**Recomendación:**
- Si BR_015 existe: Actualizar UC_010 → UC_ACC_01
- Si BR_015 es pedagógico: Considerar ejemplo real del proyecto

### MTM_02_Metamodelo_Trazabilidad.rst

**Referencias identificadas:**
- 9 referencias a UC_010 en ejemplos de trazabilidad
- Tablas RTM con UC-010

**Evaluación:**
- Todos los ejemplos usan UC_010 como caso ilustrativo
- Claramente es ejemplo pedagógico de trazabilidad BR → UC → FR

**Recomendación:**
- Actualizar UC_010 → UC_ACC_01 si se mantiene este ejemplo
- O reemplazar con OTRO UC real del proyecto más representativo

### TXM_01_Taxonomia_Requisitos.rst

**Referencias identificadas:**
- 6 ejemplos por tipo (UC-006, UC-010, UC-017, UC-025, UC-022, UC-037)
- 6 rangos por dominio (UC-005 a UC-011, UC-017 a UC-024, etc.)
- Nomenclatura FR (FR-10.1 → FR_ACC_01_01)

**Evaluación:**
- CRÍTICO: Esta es TAXONOMÍA del proyecto
- Los rangos deben corresponder EXACTAMENTE a módulos v4.0
- UC-005 a UC-011: Mezcla MOD_Auth (UC-005) y MOD_Users (UC-006-009) 
  y MOD_Access (UC-010-011) → INCORRECTO en v4.0

**Recomendación:**
- REESCRIBIR rangos completamente según módulos v4.0
- Cada módulo tiene sus propios rangos:
  - MOD_Auth: UC_AUTH_01 a UC_AUTH_05
  - MOD_Users: UC_USR_01 a UC_USR_04
  - MOD_Access: UC_ACC_01 a UC_ACC_09
  - etc.

---

## ESTRATEGIA DE ACTUALIZACIÓN PROPUESTA

### Opción A: Actualización Conservadora

**Enfoque:**
- Actualizar SOLO ejemplos que corresponden a UC reales del proyecto
- Mantener ejemplos pedagógicos genéricos como genéricos
- Agregar nota aclaratoria: "Este es un ejemplo ilustrativo"

**Pasos:**
1. Verificar cada UC mencionado contra listado real de 49 UC
2. Si existe en proyecto: Actualizar a nomenclatura v4.0
3. Si NO existe: Marcar claramente como "ejemplo pedagógico"

**Ventajas:**
- No rompe ejemplos pedagógicos
- Respeta intención educativa de PARTE 0

**Desventajas:**
- Mezcla ejemplos reales y genéricos
- Puede confundir al equipo

### Opción B: Reescritura Completa con Ejemplos Reales

**Enfoque:**
- REEMPLAZAR todos los ejemplos con UC reales del proyecto IACT
- Mantener la metodología (BR → UC → FR) pero con casos del proyecto
- Consistencia total entre base_cognitiva/ y casos_uso/

**Pasos:**
1. Identificar 5-10 UC representativos del proyecto IACT
2. Documentar sus BR asociadas (si existen)
3. Reescribir FND_03 con ejemplos de IACT
4. Reescribir MTM_01, MTM_02 con trazabilidad real
5. Reescribir TXM_01 con rangos correctos v4.0

**Ejemplos representativos sugeridos:**
- UC_AUTH_01 (Iniciar Sesión) - Simple, conocido
- UC_ACC_01 (Asignar Funciones) - Tiene BR asociadas (RBAC)
- UC_ACC_05 (Gestionar SoD) - Complejo, ilustra restricciones
- UC_RPT_01 (Consultar Reporte) - Ilustra reportes
- UC_PIP_01 (Supervisar ETL) - Ilustra procesos automáticos

**Ventajas:**
- Consistencia total con proyecto
- Equipo aprende con casos reales que van a implementar
- base_cognitiva/ es documentación técnica + pedagógica

**Desventajas:**
- Trabajo significativo (~10-15 horas)
- Requiere conocer BR reales del proyecto
- Pierde generalidad pedagógica

### Opción C: Híbrida - Sección Pedagógica + Sección Proyecto

**Enfoque:**
- Dividir cada archivo en DOS secciones:
  1. Sección Pedagógica (ejemplos genéricos de PARTE 0)
  2. Sección Proyecto IACT (ejemplos reales v4.0)

**Estructura ejemplo:**

```rst
FND_03_Casos_de_Uso.rst

1. Fundamentos Conceptuales (Genérico)
   1.1. Definición de Caso de Uso
   1.2. Estructura (Actor, Objetivo, Flujos)
   1.3. EJEMPLO PEDAGÓGICO:
        UC-Genérico: Solicitar Producto
        (mantener nomenclatura genérica, no v2.0 ni v4.0)

2. Aplicación en Proyecto IACT
   2.1. Casos de Uso del Proyecto
   2.2. Nomenclatura v4.0.0
   2.3. EJEMPLO PROYECTO:
        UC_ACC_05: Gestionar SoD
        (usar nomenclatura v4.0 real)
```

**Ventajas:**
- Separa claramente pedagogía de proyecto
- Mantiene valor educativo de PARTE 0
- Documenta proyecto real

**Desventajas:**
- Archivos más largos
- Duplicación parcial de contenido

---

## RECOMENDACIÓN FINAL

**Recomiendo Opción B: Reescritura Completa con Ejemplos Reales**

**Justificación:**

1. **base_cognitiva/ debe servir al PROYECTO, no ser curso genérico**
   - El equipo necesita entender la metodología EN EL CONTEXTO del proyecto IACT
   - Ejemplos genéricos (productos químicos) son confusos para sistema IVR

2. **Consistencia es crítica**
   - Si FND_03 enseña con UC-043 pero los desarrolladores ven UC_ACC_05,
     hay desconexión cognitiva
   - Mejor: FND_03 enseña directamente con UC_ACC_05

3. **Trazabilidad real**
   - Metamodelos y taxonomías DEBEN reflejar proyecto real
   - TXM_01 con rangos v2.0 es INCORRECTO para proyecto v4.0

4. **Valor pedagógico se mantiene**
   - La metodología BR → UC → FR se enseña IGUAL
   - Solo cambian los ejemplos concretos
   - Incluso mejor: ejemplos que el equipo va a implementar

**Esfuerzo estimado:**
- FND_01: 2h (reescribir 3 ejemplos)
- FND_03: 4-5h (reescribir tabla agrupadores + ejemplos)
- MTM_01: 2h (actualizar diagramas trazabilidad)
- MTM_02: 2-3h (actualizar tablas RTM)
- TXM_01: 3-4h (reescribir taxonomía completa)
- TXM_03: 1-2h (actualizar ejemplos BR)
- **TOTAL: 14-18 horas**

**Pero:**
- Se obtiene base_cognitiva/ CORRECTA y consistente
- Documentación técnica + pedagógica integrada
- Equipo aprende metodología con casos reales

---

## PLAN DE ACCIÓN SUGERIDO

### Fase 1: Auditoría Completa (2-3h)

1. Listar todos los 49 UC reales del proyecto IACT v4.0
2. Para cada UC mencionado en base_cognitiva/:
   - ¿Existe en proyecto? → Marcar para actualizar
   - ¿NO existe? → Marcar para reescribir
3. Documentar BR reales del proyecto (si existen)
4. Seleccionar 5-10 UC representativos para ejemplos

### Fase 2: Reescritura Fundamentos (4-5h)

1. FND_01: Reemplazar UC-40, UC-015 con ejemplos reales
2. FND_03: 
   - Reescribir tabla agrupadores con módulos v4.0
   - Actualizar ejemplos UC-043, UC-001/002/003, UC-050
   - Agregar ejemplos adicionales de proyecto

### Fase 3: Reescritura Metamodelos (4-5h)

1. MTM_01: 
   - Actualizar UC_010 → UC_ACC_01
   - Verificar BR_015 existe o reemplazar
   - Actualizar diagramas de trazabilidad
2. MTM_02:
   - Actualizar todas las tablas RTM con ejemplos reales
   - Mantener UC_ACC_01 como ejemplo principal
3. MTM_03:
   - Actualizar rangos "UC-005 a UC-011"

### Fase 4: Reescritura Taxonomías (4-5h)

1. TXM_01:
   - REESCRIBIR completamente tabla de rangos por módulo
   - Actualizar ejemplos por tipo con UC reales
   - Actualizar nomenclatura FR
2. TXM_03:
   - Actualizar ejemplos BR → UC con casos reales

### Fase 5: Validación (2h)

1. Build Sphinx sin warnings
2. Verificar consistencia interna
3. Validar que ejemplos corresponden a UC reales
4. Testing navegación

**TOTAL ESTIMADO: 16-20 horas**

---

## PRÓXIMOS PASOS INMEDIATOS

1. **DECISIÓN REQUERIDA:** ¿Opción A, B o C?

2. **Si Opción B (recomendada):**
   - Necesito listado COMPLETO de 49 UC reales del proyecto
   - Necesito ver archivos UC individuales para entender contexto
   - Necesito saber si existen BR documentadas en proyecto

3. **Si Opción A:**
   - Proceder con actualización conservadora
   - Marcar ejemplos pedagógicos claramente

4. **Si Opción C:**
   - Diseñar estructura de secciones dual
   - Más tiempo pero más seguro

---

## CONCLUSIÓN

La actualización de base_cognitiva/ NO es simplemente:
- Renombrar archivos (FASE 0B)
- Actualizar referencias UC-XXX (FASE 3-5 original)

Es una **AUDITORÍA y REESCRITURA** para asegurar que:
1. Ejemplos pedagógicos sean consistentes con proyecto
2. Nomenclatura v4.0 se use correctamente
3. Taxonomías reflejen estructura real del sistema
4. Trazabilidad sea verificable contra código real

**Sin esta reescritura, base_cognitiva/ será:**
- Técnicamente incorrecta (rangos v2.0)
- Pedagógicamente confusa (ejemplos no del proyecto)
- Potencialmente engañosa (UC-010 vs UC_ACC_01)

**Con reescritura (Opción B):**
- Documentación técnica precisa
- Pedagogía aplicada al proyecto real
- Base sólida para todo el equipo

**ESPERANDO TU DECISIÓN para continuar.**

---

**ANÁLISIS COMPLETO GUARDADO EN:** /tmp/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA.md

