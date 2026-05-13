# TEMPLATE T02: Construcción de Caso de Uso Completo (7 Pasos)

**Versión:** 1.0.0  
**Categoría:** Construcción de UC  
**Fuente:** PARTE 2B, Sección 4.1  
**Uso:** Construir UC paso a paso desde BR Desencadenador

---

## ¿CUÁNDO USAR ESTE TEMPLATE?

Usa este template cuando:
- Identificaste una BR de tipo DESENCADENADOR
- Necesitas documentar un UC completo desde cero
- Quieres asegurar que no falte ningún componente crítico

---

## PROCESO DE 7 PASOS

```
PASO 1: Identificar BR Desencadenador → 10 min
PASO 2: Identificar Actor Primario → 5 min
PASO 3: Definir Objetivo del UC → 5 min
PASO 4: Construir Precondiciones → 15 min
PASO 5: Construir Flujo Normal → 45 min
PASO 6: Construir Flujos Alternos → 30 min
PASO 7: Definir Postcondiciones → 15 min

TOTAL ESTIMADO: 2 horas para UC completo
```

---

## TEMPLATE COMPLETO

```markdown
# UC-[MODULE]-[NN]: [Nombre del UC]

---

## PASO 1: IDENTIFICACIÓN DE BR DESENCADENADOR

**Business Rule Origen:**

ID: BR-[ID]
Tipo: Desencadenador
Texto completo:
  "[Copiar aquí el enunciado completo de la BR]"

**Verificación de Desencadenador:**

☐ Estructura IF-THEN: [SÍ / NO]
☐ Condición temporal/estado: [SÍ / NO]
☐ Acción observable: [SÍ / NO]
☐ Alguien recibe resultado: [SÍ / NO]

✅ Conclusión: [Genera UC / No genera UC]

---

## PASO 2: IDENTIFICACIÓN DE ACTORES

### Actor Primario

**3 Preguntas de Decisión:**

1. ¿Quién QUIERE que esto ocurra?
   Respuesta: [descripción]

2. ¿CUÁNDO se ejecuta?
   Respuesta: [manual / automático / programado]

3. ¿Quién se BENEFICIA del resultado?
   Respuesta: [descripción]

**Actor Primario Decidido:** [Rol / Sistema / Tiempo]

Justificación:
  [Explicar por qué este es el actor primario]

### Actores Secundarios

- [Actor 1]: [Rol en el UC]
- [Actor 2]: [Rol en el UC]

### Stakeholders e Intereses

- [Stakeholder 1]: [Interés específico]
- [Stakeholder 2]: [Interés específico]

---

## PASO 3: OBJETIVO DEL UC

**Formato:** Verbo + Objeto + Contexto (opcional)

**Opciones Consideradas:**

A) [Opción 1]
   Evaluación: [Pros / Contras]

B) [Opción 2]
   Evaluación: [Pros / Contras]

**Objetivo Elegido:** [Nombre final del UC]

**Descripción Breve (1-2 párrafos):**
[Explicar qué hace el UC, por qué es importante, cuándo se ejecuta]

---

## PASO 4: PRECONDICIONES

### Categoría 1: Estado del Sistema

- PRE-01: [Descripción]
- PRE-02: [Descripción]

### Categoría 2: Autenticación/Autorización

- PRE-03: [Si aplica]

### Categoría 3: Business Rules

- PRE-04: [BR que deben cumplirse ANTES]
- PRE-05: [BR que deben cumplirse ANTES]

### Categoría 4: Datos

- PRE-06: [Registros que deben existir]
- PRE-07: [Datos que deben estar disponibles]

---

## PASO 5: FLUJO NORMAL

### Fase 1: Inicio

1. [Descripción del trigger inicial]

### Fase 2: Consulta

2. [Query o consulta de datos]
   
   ```sql
   [Si aplica, incluir query SQL]
   ```

### Fase 3: Iteración (si aplica)

3. [Descripción de loop sobre registros]

### Fase 4: Validación

4. [Validaciones específicas con BR aplicadas]

### Fase 5: Procesamiento

5. [Cálculos, transformaciones, preparación]

### Fase 6: Acción Observable

6. [Comportamiento observable: enviar, notificar, actualizar visible]

### Fase 7: Auditoría

7. [Registro en audit_log u otro mecanismo]

8. [Paso final de confirmación/cierre]

---

## PASO 6: FLUJOS ALTERNOS

### FA-1: [Nombre del Flujo Alterno] (PATRÓN [A/B/C/D/E])

**Punto de desviación:** Paso [N]

[N]a. [Condición detectada]

[N]b. [Acción del sistema]

[N]c. [Acción del sistema]

[N]d. [Resultado o retorno]

**Postcondición:** [Qué cambió o no cambió]

---

### FA-2: [Otro Flujo Alterno]

[Repetir estructura]

---

### FA-3: [Otro Flujo Alterno]

[Mínimo 2-3 FA por UC, idealmente 4-6]

---

## PASO 7: POSTCONDICIONES

### De Éxito (Flujo Normal)

**Categoría 1: Base de Datos**
- POST-01: [Registros creados/actualizados]
- POST-02: [Campos modificados]

**Categoría 2: Mensajes/Notificaciones**
- POST-03: [Notificaciones enviadas]

**Categoría 3: Auditoría**
- POST-04: [Eventos registrados]
- POST-05: [Métricas capturadas]

**Categoría 4: Estados Futuros**
- POST-06: [Jobs programados, timers iniciados]

### Parciales (Flujos Alternos)

- POST-07: [FA-1] [Postcondición específica]
- POST-08: [FA-2] [Postcondición específica]

---

## METADATOS Y TRAZABILIDAD

**Business Rules Aplicadas:**

- BR-[ID]: [Descripción breve] → [Ubicación en UC: Paso N / FA-M]

**Casos de Uso Relacionados:**

- UC-[ID]: [Nombre] → [Relación: Precede / Sigue / Alternativa]

**Functional Requirements Derivados:**

- FR-[ID1]: [Nombre breve]
- FR-[ID2]: [Nombre breve]
- [Listar 5-10 FR típicamente]

**Frecuencia:** [Diaria / Horaria / Continua / Semanal]

**Prioridad:** [Alta / Media / Baja]

**Complejidad:** [Alta / Media / Baja]

**Métricas de Performance:**

- Duración esperada: [X segundos/minutos]
- Throughput: [N registros por ejecución]
- Recursos: [RAM, CPU estimados]

---

## VALIDACIÓN FINAL

**Checklist de Completitud (Mínimo):**

☐ ID único asignado
☐ Nombre en formato Verbo + Objeto
☐ Actor Primario identificado
☐ Trigger específico documentado
☐ Mínimo 5 pasos en Flujo Normal
☐ Mínimo 2 Flujos Alternos
☐ Postcondiciones definidas
☐ BR origen identificada
☐ FR derivados listados

**Aprobado por:** [Nombre]  
**Fecha:** [YYYY-MM-DD]

---
```

---

## PATRONES DE FLUJOS ALTERNOS

**PATRÓN A: Variación de Negocio**
- No es error, es camino alternativo legítimo
- Ejemplo: "No hay registros que procesar"

**PATRÓN B: Error de Validación**
- Dato inválido o inconsistente
- Ejemplo: "Campo requerido vacío"

**PATRÓN C: Error Técnico**
- Fallo de infraestructura
- Ejemplo: "BD no disponible"

**PATRÓN D: Usuario Cancela**
- Actor decide no continuar
- Ejemplo: "Admin cancela operación"

**PATRÓN E: Timeout/Performance**
- Excede tiempo permitido
- Ejemplo: "Job excede 60 segundos"

---

## EJEMPLO MÍNIMO (VERSIÓN CORTA)

Para UC simples, puedes usar versión reducida:

```markdown
## UC-[ID]: [Nombre]

**Actor:** [Rol]  
**Trigger:** [Qué inicia]

**Precondiciones:**
- [Lista de 2-3 precondiciones]

**Flujo Normal:**
1. [Paso 1]
2. [Paso 2]
...

**FA-1: [Nombre]**
- [Descripción breve de desviación]

**Postcondiciones:**
- [Qué cambió en el sistema]

**BR:** BR-[ID]  
**FR:** FR-[ID1], FR-[ID2]
```

---

## CONSEJOS PRÁCTICOS

**✅ HACER:**

- Un paso = Una acción atómica
- Usar verbos precisos ("Sistema valida", no "Sistema checa")
- Incluir queries SQL en pasos críticos
- Numerar pasos consecutivamente (1, 2, 3...)
- Documentar punto de desviación explícito en FA (Paso 4a, 4b...)
- Incluir ejemplos concretos en pasos complejos

**❌ EVITAR:**

- Pasos ambiguos ("Sistema procesa datos")
- Saltar números en flujo
- Más de 15 pasos en Flujo Normal (dividir el UC)
- FA genéricos sin detalle
- Olvidar auditoría en UC críticos
- Sobre-detallar código (guardar para FR)

---

## TIEMPO ESTIMADO POR PASO

| Paso | Tiempo | Complejidad |
|------|--------|-------------|
| 1. Identificar BR | 10 min | Baja |
| 2. Actor | 5 min | Baja |
| 3. Objetivo | 5 min | Baja |
| 4. Precondiciones | 15 min | Media |
| 5. Flujo Normal | 45 min | Alta |
| 6. Flujos Alternos | 30 min | Alta |
| 7. Postcondiciones | 15 min | Media |
| **TOTAL** | **2 horas** | |

Para UC complejos (>10 pasos, >5 FA): hasta 4 horas

---

## REFERENCIAS

- **Documento fuente:** PARTE_2B_CONSTRUCCION_IACT.md, Sección 4
- **Ejemplo completo:** UC-IACT-09 (11 pasos, 6 FA)
- **Templates relacionados:**
  - T01: Decisión de Tipo de BR
  - T03: Identificación de Actor Primario
  - T05: Construcción de Flujos Alternos

---

**Versión:** 1.0.0  
**Última actualización:** 2026-01-08  
**Mantenido por:** Equipo IACT
