---
# PLANTILLA: Resumen de Ejecucion de Tarea
# Aplicando tecnica: Auto-CoT (Automatic Chain-of-Thought)
# Version: 1.0.0
# Fecha: 2025-11-18
#
# INSTRUCCIONES DE USO:
# 1. Copia este archivo a: TASK-REORG-INFRA-XXX/evidencias/RESUMEN-EJECUCION.md
# 2. Reemplaza todos los valores entre [CORCHETES] con informacion especifica de tu tarea
# 3. Elimina las secciones marcadas como [OPCIONAL] si no aplican
# 4. Documenta el razonamiento paso a paso en la seccion Auto-CoT
# 5. NO uses emojis en el contenido
---

id: REPORTE-[TASK-ID]
fecha: [YYYY-MM-DD]
tarea: [TASK-REORG-INFRA-XXX]
estado: [COMPLETADO/EN_PROGRESO/BLOQUEADO]
tipo: reporte_ejecucion
responsable: [Nombre del responsable]

---

# RESUMEN DE EJECUCION - [TASK-REORG-INFRA-XXX]

**Tarea:** [Nombre descriptivo de la tarea]
**Estado:** [COMPLETADO/EN_PROGRESO/BLOQUEADO]
**Fecha Inicio:** [YYYY-MM-DD HH:MM]
**Fecha Fin:** [YYYY-MM-DD HH:MM]
**Duracion Real:** [X horas Y minutos]

---

## Resumen Ejecutivo

[Descripcion breve de 2-3 parrafos sobre lo que se logro en la tarea. Incluir:]
- [Objetivo principal alcanzado]
- [Resultados cuantitativos (ej: 13/13 archivos creados, 24 items mapeados)]
- [Estado general (exitoso, parcial, bloqueado)]
- [Impacto en siguientes tareas]

**Resultado:** [EXITOSO/PARCIAL/BLOQUEADO] ([X/Y items completados])

---

## Auto-CoT: Razonamiento Paso a Paso

### Fase 1: Comprension del Problema

**Pregunta Inicial:** [Cual es el problema u objetivo de esta tarea?]

**Analisis:**
```
Paso 1: [Identificacion del problema]
- [Descripcion del estado inicial]
- [Problemas detectados]
- [Necesidades identificadas]

Paso 2: [Analisis de requisitos]
- [Requisito 1 identificado]
- [Requisito 2 identificado]
- [Requisito N identificado]

Paso 3: [Definicion de alcance]
- [Que esta incluido en la tarea]
- [Que esta excluido de la tarea]
- [Limites y restricciones]
```

### Fase 2: Planificacion de Solucion

**Estrategia Elegida:** [Descripcion de la estrategia de solucion]

**Razonamiento:**
```
Paso 4: [Division del problema]
- [Sub-tarea 1: descripcion]
- [Sub-tarea 2: descripcion]
- [Sub-tarea N: descripcion]

Paso 5: [Orden de ejecucion]
- [Prioridad 1: tarea critica]
- [Prioridad 2: tarea dependiente]
- [Prioridad N: tarea final]

Paso 6: [Identificacion de dependencias]
- [Dependencia 1 → Solucion/Mitigacion]
- [Dependencia 2 → Solucion/Mitigacion]
```

### Fase 3: Ejecucion

**Acciones Realizadas:**

#### Paso de Ejecucion 1: [Nombre del paso]
- **Accion:** [Que se hizo]
- **Comando/Herramienta:** [Comando ejecutado o herramienta usada]
- **Resultado:** [Que se obtuvo]
- **Validacion:** [Como se verifico que funciono]
- **Tiempo:** [X minutos]

#### Paso de Ejecucion 2: [Nombre del paso]
- **Accion:** [Que se hizo]
- **Comando/Herramienta:** [Comando ejecutado o herramienta usada]
- **Resultado:** [Que se obtuvo]
- **Validacion:** [Como se verifico que funciono]
- **Tiempo:** [X minutos]

[OPCIONAL: Agregar mas pasos segun necesidad]

#### Paso de Ejecucion N: [Nombre del paso final]
- **Accion:** [Que se hizo]
- **Comando/Herramienta:** [Comando ejecutado o herramienta usada]
- **Resultado:** [Que se obtuvo]
- **Validacion:** [Como se verifico que funciono]
- **Tiempo:** [X minutos]

### Fase 4: Validacion de Resultados

**Verificaciones Realizadas:**
```
Paso Validacion 1: [Tipo de validacion]
- [Criterio 1: PASS/FAIL]
- [Criterio 2: PASS/FAIL]
- [Resultado: descripcion]

Paso Validacion 2: [Tipo de validacion]
- [Criterio 1: PASS/FAIL]
- [Criterio 2: PASS/FAIL]
- [Resultado: descripcion]
```

---

## Tecnicas de Prompting Aplicadas

### 1. Auto-CoT (Chain of Thought)

**Aplicacion:**
- [Paso 1: descripcion de como se aplico Auto-CoT]
- [Paso 2: razonamiento documentado]
- [Paso 3: validacion progresiva]
- [Paso N: resultado verificable]

**Beneficios Observados:**
- [Beneficio 1: ej. "Identificacion clara de sub-tareas"]
- [Beneficio 2: ej. "Orden logico de ejecucion"]
- [Beneficio 3: ej. "Validacion incremental"]

### 2. Self-Consistency [OPCIONAL]

**Aplicacion:**
[Si se uso Self-Consistency, describir aqui. Si no, eliminar esta seccion]
- [Validacion multiple de resultados]
- [Verificacion cruzada de criterios]
- [Consistencia entre diferentes perspectivas]

---

## Artifacts Creados

### 1. [Categoria de Artifact 1]

**Ubicacion:** `[ruta/completa/del/artifact]`

**Contenido:**
- [Item 1 creado/modificado]
- [Item 2 creado/modificado]
- [Item N creado/modificado]

**Proposito:** [Para que sirve este artifact]

**Validacion:** [Como se verifico su completitud]

### 2. [Categoria de Artifact 2]

**Ubicacion:** `[ruta/completa/del/artifact]`

**Contenido:**
- [Item 1 creado/modificado]
- [Item 2 creado/modificado]

**Proposito:** [Para que sirve este artifact]

**Validacion:** [Como se verifico su completitud]

[OPCIONAL: Agregar mas categorias segun necesidad]

---

## Metricas de Ejecucion

| Metrica | Valor Esperado | Valor Real | Estado |
|---------|----------------|------------|--------|
| [Items procesados] | [N items] | [M items] | [OK/PARCIAL/FAIL] |
| [Tiempo de ejecucion] | [X horas] | [Y horas] | [OK/EXCEDIDO] |
| [Criterios cumplidos] | [100%] | [Z%] | [OK/PARCIAL] |
| [Archivos creados] | [N archivos] | [M archivos] | [OK/PARCIAL/FAIL] |
| [Validaciones exitosas] | [100%] | [Z%] | [OK/PARCIAL] |

**Score Total:** [X/Y] ([Z%])

---

## Problemas Encontrados y Soluciones

### Problema 1: [Descripcion del problema]

**Sintomas:**
- [Sintoma observado 1]
- [Sintoma observado 2]

**Causa Raiz:**
- [Analisis de la causa]

**Solucion Aplicada:**
- [Paso 1 de solucion]
- [Paso 2 de solucion]
- [Resultado de la solucion]

**Tiempo Perdido:** [X minutos/horas]

[OPCIONAL: Agregar mas problemas si hubo]

### Problema 2: [Descripcion del problema]
[Misma estructura que Problema 1]

---

## Criterios de Aceptacion - Estado

- [[x]/[ ]] [Criterio 1: descripcion]
- [[x]/[ ]] [Criterio 2: descripcion]
- [[x]/[ ]] [Criterio 3: descripcion]
- [[x]/[ ]] [Criterio 4: descripcion]
- [[x]/[ ]] [Criterio N: descripcion]

**Total Completado:** [X/Y] ([Z%])

---

## Archivos de Evidencia Generados

1. **[nombre-archivo-evidencia-1.ext]**
   - Ubicacion: `[ruta/completa]`
   - Proposito: [Para que sirve]
   - Tamano: [X KB/MB]
   - Validacion: [Como se verifico]

2. **[nombre-archivo-evidencia-2.ext]**
   - Ubicacion: `[ruta/completa]`
   - Proposito: [Para que sirve]
   - Tamano: [X KB/MB]
   - Validacion: [Como se verifico]

[OPCIONAL: Agregar mas archivos de evidencia]

---

## Comparacion: Estimado vs Real

| Aspecto | Estimado | Real | Diferencia | Razon |
|---------|----------|------|------------|-------|
| Duracion total | [X horas] | [Y horas] | [+/- Z horas] | [Explicacion] |
| Complejidad | [ALTA/MEDIA/BAJA] | [ALTA/MEDIA/BAJA] | [IGUAL/MAYOR/MENOR] | [Explicacion] |
| Blockers | [0-N blockers] | [0-M blockers] | [+/- Z] | [Explicacion] |
| Items procesados | [N items] | [M items] | [+/- Z items] | [Explicacion] |

**Precision de Estimacion:** [BUENA/ACEPTABLE/POBRE]

**Lecciones Aprendidas:**
- [Leccion 1: que aprendimos para mejorar estimaciones futuras]
- [Leccion 2: que factores no se consideraron]
- [Leccion 3: que se puede optimizar]

---

## Proximos Pasos

### Tareas Desbloqueadas
- [TASK-REORG-INFRA-XXX: descripcion]
- [TASK-REORG-INFRA-YYY: descripcion]

### Seguimiento Requerido
- [[x]/[ ]] [Accion de seguimiento 1]
- [[x]/[ ]] [Accion de seguimiento 2]
- [[x]/[ ]] [Accion de seguimiento N]

### Recomendaciones
1. [Recomendacion 1 para siguientes tareas]
2. [Recomendacion 2 para mejora de proceso]
3. [Recomendacion N para optimizacion]

---

## Notas Finales

[OPCIONAL: Agregar notas adicionales relevantes]
- [Nota 1: observacion importante]
- [Nota 2: contexto adicional]
- [Nota 3: consideracion futura]

---

## Validacion Final

**Status General:** [COMPLETADO CON EXITO/COMPLETADO CON EXCEPCIONES/BLOQUEADO]

**Criterios Principales:**
- [[x]/[ ]] Objetivo principal alcanzado
- [[x]/[ ]] Criterios de aceptacion cumplidos ([X/Y])
- [[x]/[ ]] Evidencias documentadas
- [[x]/[ ]] Auto-CoT aplicado correctamente
- [[x]/[ ]] Validaciones ejecutadas
- [[x]/[ ]] Artefactos creados y verificados
- [[x]/[ ]] Metricas dentro de umbral aceptable

**Aprobacion:** [SI/NO/CONDICIONAL]

**Observaciones:** [Comentarios del revisor o auto-evaluacion]

---

**Documento Completado:** [YYYY-MM-DD HH:MM]
**Tecnica de Prompting:** Auto-CoT (Chain-of-Thought)
**Version del Reporte:** 1.0.0
**Estado Final:** [EXITOSO/PARCIAL/BLOQUEADO]

---

## NOTAS DE USO DE LA PLANTILLA

### Como personalizar esta plantilla:

1. **Frontmatter YAML:**
   - Reemplaza [TASK-ID] con el ID real (ej: TASK-REORG-INFRA-003)
   - Actualiza fecha, estado, responsable

2. **Resumen Ejecutivo:**
   - Escribe 2-3 parrafos sobre que se logro
   - Se especifico con numeros (ej: 13/13 archivos creados)

3. **Auto-CoT:**
   - Documenta el razonamiento paso a paso REAL que seguiste
   - Cada fase debe reflejar como pensaste el problema
   - Incluye validaciones en cada paso

4. **Artifacts:**
   - Lista TODO lo que creaste/modificaste
   - Incluye rutas absolutas
   - Describe proposito de cada artifact

5. **Metricas:**
   - Llena la tabla con metricas reales de tu tarea
   - Compara esperado vs real
   - Calcula porcentajes de completitud

6. **Problemas:**
   - Documenta TODOS los problemas encontrados
   - Incluye soluciones aplicadas
   - Estima tiempo perdido

7. **Criterios de Aceptacion:**
   - Copia los criterios del README de la tarea
   - Marca [x] los completados, [ ] los pendientes

8. **Evidencias:**
   - Lista TODOS los archivos de evidencia
   - Incluye rutas, tamanos, propositos

9. **Validacion Final:**
   - Revisa que TODO este completo
   - Marca checklist final
   - Auto-evalua calidad

### Secciones Opcionales:

- **Self-Consistency:** Elimina si solo usaste Auto-CoT
- **Problema 2, 3, N:** Elimina si solo hubo 1 problema
- **Notas Finales:** Elimina si no hay notas adicionales

### Consejos:

- Se especifico y detallado
- Usa numeros y metricas cuando sea posible
- Documenta razonamiento, no solo acciones
- Incluye validaciones en cada paso
- NO uses emojis
- Mantiene formato markdown limpio
