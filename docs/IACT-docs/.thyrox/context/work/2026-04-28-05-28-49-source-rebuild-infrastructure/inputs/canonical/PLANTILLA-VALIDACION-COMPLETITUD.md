---
# PLANTILLA: Validacion de Completitud
# Aplicando tecnica: Self-Consistency (Validacion Multiple)
# Version: 1.0.0
# Fecha: 2025-11-18
#
# INSTRUCCIONES DE USO:
# 1. Copia este archivo a: TASK-REORG-INFRA-XXX/evidencias/VALIDACION-COMPLETITUD.md
# 2. Reemplaza todos los valores entre [CORCHETES] con informacion especifica
# 3. Ejecuta cada validacion y registra resultados
# 4. La tecnica Self-Consistency requiere validar desde MULTIPLES perspectivas
# 5. NO uses emojis en el contenido
---

id: VALIDACION-[TASK-ID]
fecha: [YYYY-MM-DD]
tarea: [TASK-REORG-INFRA-XXX]
tipo: validacion_completitud
tecnica: Self-Consistency
estado: [completado/en_progreso]

---

# VALIDACION DE COMPLETITUD - [TASK-REORG-INFRA-XXX]

## Objetivo de Validacion

Verificar mediante multiple perspectivas y validaciones cruzadas que [TASK-REORG-INFRA-XXX: descripcion] fue completada exitosamente con todos los criterios de aceptacion cumplidos.

**Tecnica Aplicada:** Self-Consistency (Validacion Multiple)

**Principio:** Un resultado es valido si se confirma desde multiples perspectivas independientes.

---

## PERSPECTIVA 1: Validacion de Existencia

### Objetivo
Verificar que TODOS los artifacts esperados existen fisicamente.

### Validacion 1.1: Listado de Artifacts Esperados

| # | Artifact Esperado | Ruta Completa | Existe? | Tamano | Validado |
|---|-------------------|---------------|---------|--------|----------|
| 1 | [Nombre artifact 1] | `[/ruta/completa/artifact1]` | [SI/NO] | [X KB] | [PASS/FAIL] |
| 2 | [Nombre artifact 2] | `[/ruta/completa/artifact2]` | [SI/NO] | [X KB] | [PASS/FAIL] |
| 3 | [Nombre artifact 3] | `[/ruta/completa/artifact3]` | [SI/NO] | [X KB] | [PASS/FAIL] |
| N | [Nombre artifact N] | `[/ruta/completa/artifactN]` | [SI/NO] | [X KB] | [PASS/FAIL] |

**Total Esperado:** [N artifacts]
**Total Encontrado:** [M artifacts]
**Porcentaje Completitud:** [M/N * 100]%

**Resultado Perspectiva 1:** [PASS/FAIL] - [Todos los artifacts existen: SI/NO]

### Comandos de Validacion

```bash
# Validar existencia de artifacts
[COMANDO 1 - ej: ls -la /ruta/artifact1]
[COMANDO 2 - ej: find /ruta -name "pattern"]
[COMANDO N - validacion final]
```

**Output Esperado:**
```
[Copia aqui el output esperado de los comandos]
```

**Output Real:**
```
[Copia aqui el output real obtenido]
```

---

## PERSPECTIVA 2: Validacion de Estructura

### Objetivo
Verificar que cada artifact tiene la estructura interna correcta.

### Validacion 2.1: Estructura de Archivos Markdown

[APLICAR SI LA TAREA CREO ARCHIVOS .md]

| Archivo | Frontmatter YAML | Titulo H1 | Secciones Requeridas | Formato | Validado |
|---------|------------------|-----------|---------------------|---------|----------|
| [archivo1.md] | [SI/NO] | [SI/NO] | [X/Y secciones] | [OK/FAIL] | [PASS/FAIL] |
| [archivo2.md] | [SI/NO] | [SI/NO] | [X/Y secciones] | [OK/FAIL] | [PASS/FAIL] |
| [archivoN.md] | [SI/NO] | [SI/NO] | [X/Y secciones] | [OK/FAIL] | [PASS/FAIL] |

**Secciones Requeridas en cada archivo:**
- [[x]/[ ]] [Seccion 1: ej. "Proposito"]
- [[x]/[ ]] [Seccion 2: ej. "Contenido Esperado"]
- [[x]/[ ]] [Seccion 3: ej. "Estructura"]
- [[x]/[ ]] [Seccion N: ej. "Estado"]

**Resultado Perspectiva 2:** [PASS/FAIL] - [Estructura correcta: SI/NO]

### Validacion 2.2: Frontmatter YAML

[APLICAR SI SE REQUIERE YAML]

Cada archivo debe tener frontmatter valido:

```yaml
---
[campo1]: [valor esperado]
[campo2]: [valor esperado]
[campoN]: [valor esperado]
---
```

**Validacion de campos:**
- [[x]/[ ]] [Campo 1: presente y valido]
- [[x]/[ ]] [Campo 2: presente y valido]
- [[x]/[ ]] [Campo N: presente y valido]

**Comando de validacion:**
```bash
# Validar frontmatter YAML
[COMANDO - ej: grep -A5 "^---$" archivo.md | head -10]
```

---

## PERSPECTIVA 3: Validacion de Contenido

### Objetivo
Verificar que el contenido de cada artifact es correcto, completo y coherente.

### Validacion 3.1: Propositos Documentados

[Aplicar si la tarea requirio documentar propositos]

| Artifact | Tiene Proposito? | Proposito Claro? | Coherente? | Validado |
|----------|-----------------|-----------------|-----------|----------|
| [artifact1] | [SI/NO] | [SI/NO] | [SI/NO] | [PASS/FAIL] |
| [artifact2] | [SI/NO] | [SI/NO] | [SI/NO] | [PASS/FAIL] |
| [artifactN] | [SI/NO] | [SI/NO] | [SI/NO] | [PASS/FAIL] |

**Criterios de "Proposito Claro":**
- Responde "Para que existe este artifact?"
- Es especifico, no generico
- Explica valor agregado

**Resultado Perspectiva 3.1:** [PASS/FAIL] - [Propositos claros: X/Y]

### Validacion 3.2: Contenido Completo

[Definir que significa "completo" para esta tarea especifica]

**Criterios de Completitud:**
- [[x]/[ ]] [Criterio 1: ej. "Todos los items del mapeo estan cubiertos"]
- [[x]/[ ]] [Criterio 2: ej. "Todas las categorias tienen descripcion"]
- [[x]/[ ]] [Criterio 3: ej. "Todos los enlaces funcionan"]
- [[x]/[ ]] [Criterio N: ej. "No hay secciones vacias"]

**Resultado Perspectiva 3.2:** [PASS/FAIL] - [Contenido completo: X/Y criterios]

### Validacion 3.3: Coherencia y Consistencia

**Verificaciones de Coherencia:**

1. **Nomenclatura Consistente:**
   - [[x]/[ ]] [Todos los archivos usan [formato esperado]]
   - [[x]/[ ]] [No hay inconsistencias de nombres]
   - [[x]/[ ]] [Convenciones respetadas]

2. **Formato Consistente:**
   - [[x]/[ ]] [Mismo estilo de frontmatter en todos]
   - [[x]/[ ]] [Mismo formato de secciones]
   - [[x]/[ ]] [Sin emojis en ningun archivo]

3. **Referencias Cruzadas:**
   - [[x]/[ ]] [Enlaces internos funcionan]
   - [[x]/[ ]] [Referencias a otras tareas son correctas]
   - [[x]/[ ]] [No hay enlaces rotos]

**Resultado Perspectiva 3.3:** [PASS/FAIL] - [Coherente: SI/NO]

---

## PERSPECTIVA 4: Validacion de Calidad

### Objetivo
Verificar que los artifacts cumplen estandares de calidad.

### Validacion 4.1: Calidad de Documentacion

| Criterio de Calidad | Esperado | Real | Estado |
|-------------------|----------|------|--------|
| Sin errores de ortografia | 0 errores | [N errores] | [PASS/FAIL] |
| Formato Markdown valido | 100% valido | [X%] | [PASS/FAIL] |
| Sin emojis | 0 emojis | [N emojis] | [PASS/FAIL] |
| Indentacion correcta | Uniforme | [Uniforme/Inconsistente] | [PASS/FAIL] |
| Enlaces validos | 100% | [X%] | [PASS/FAIL] |
| Frontmatter YAML valido | 100% | [X%] | [PASS/FAIL] |

**Resultado Perspectiva 4.1:** [PASS/FAIL] - [Calidad aceptable: SI/NO]

### Validacion 4.2: Estandares de Proyecto

- [[x]/[ ]] [Sigue convenciones del proyecto IACT]
- [[x]/[ ]] [Formato compatible con estructura docs/]
- [[x]/[ ]] [Metadata completo y correcto]
- [[x]/[ ]] [Versionado incluido donde corresponde]
- [[x]/[ ]] [Fecha de actualizacion presente]

**Resultado Perspectiva 4.2:** [PASS/FAIL] - [Cumple estandares: X/Y]

---

## PERSPECTIVA 5: Validacion Self-Consistency

### Objetivo
Verificar consistencia mediante validacion cruzada de multiples fuentes.

### Validacion 5.1: Preguntas de Consistencia

Responde estas preguntas desde DIFERENTES perspectivas:

#### Pregunta 1: [Pregunta especifica de la tarea]

**Respuesta desde Perspectiva A (Existencia):**
[Respuesta basada en validacion de existencia]

**Respuesta desde Perspectiva B (Estructura):**
[Respuesta basada en validacion de estructura]

**Respuesta desde Perspectiva C (Contenido):**
[Respuesta basada en validacion de contenido]

**Consistencia:** [CONSISTENTE/INCONSISTENTE]
**Conclusion:** [Descripcion de la conclusion]

#### Pregunta 2: [Pregunta especifica de la tarea]

**Respuesta desde Perspectiva A:**
[Respuesta]

**Respuesta desde Perspectiva B:**
[Respuesta]

**Respuesta desde Perspectiva C:**
[Respuesta]

**Consistencia:** [CONSISTENTE/INCONSISTENTE]
**Conclusion:** [Descripcion]

[OPCIONAL: Agregar mas preguntas segun complejidad de la tarea]

### Validacion 5.2: Verificacion de No-Contradiccion

**Objetivo:** Detectar inconsistencias o contradicciones.

| Tipo de Contradiccion | Busqueda | Resultado | Estado |
|---------------------|----------|-----------|--------|
| [Duplicados] | [Como se busco] | [Encontrados: SI/NO - N items] | [PASS/FAIL] |
| [Inconsistencias de nombre] | [Como se busco] | [Encontrados: SI/NO - N items] | [PASS/FAIL] |
| [Referencias rotas] | [Como se busco] | [Encontrados: SI/NO - N items] | [PASS/FAIL] |
| [Conflictos de contenido] | [Como se busco] | [Encontrados: SI/NO - N items] | [PASS/FAIL] |

**Resultado Perspectiva 5:** [PASS/FAIL] - [Sin contradicciones: SI/NO]

---

## PERSPECTIVA 6: Validacion de Criterios de Aceptacion

### Objetivo
Verificar que TODOS los criterios de aceptacion de la tarea estan cumplidos.

### Criterios de Aceptacion Original

[Copiar criterios de aceptacion del README de la tarea]

- [[x]/[ ]] [Criterio 1: descripcion exacta del README]
- [[x]/[ ]] [Criterio 2: descripcion exacta del README]
- [[x]/[ ]] [Criterio 3: descripcion exacta del README]
- [[x]/[ ]] [Criterio N: descripcion exacta del README]

**Total Criterios:** [N]
**Criterios Cumplidos:** [M]
**Porcentaje Cumplimiento:** [M/N * 100]%

**Resultado Perspectiva 6:** [PASS/FAIL] - [Criterios cumplidos: M/N]

---

## Matriz de Validacion Cruzada

### Tabla de Consistencia Multiple

| Aspecto a Validar | P1: Existencia | P2: Estructura | P3: Contenido | P4: Calidad | P5: Self-Consistency | P6: Criterios | Consistente? |
|------------------|---------------|----------------|---------------|-------------|---------------------|---------------|--------------|
| [Aspecto 1] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [SI/NO] |
| [Aspecto 2] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [SI/NO] |
| [Aspecto N] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] | [SI/NO] |

**Aspectos Consistentes:** [X/Y]
**Nivel de Consistencia:** [X/Y * 100]%

---

## Score de Completitud

### Calculo de Score Final

| Perspectiva | Peso | Score Obtenido | Score Ponderado |
|-------------|------|----------------|-----------------|
| P1: Existencia | [20%] | [X/100] | [X * 0.20] |
| P2: Estructura | [15%] | [X/100] | [X * 0.15] |
| P3: Contenido | [25%] | [X/100] | [X * 0.25] |
| P4: Calidad | [15%] | [X/100] | [X * 0.15] |
| P5: Self-Consistency | [15%] | [X/100] | [X * 0.15] |
| P6: Criterios | [10%] | [X/100] | [X * 0.10] |
| **TOTAL** | **100%** | **---** | **[X/100]** |

**Score Final de Completitud:** [X/100]

**Interpretacion:**
- 90-100: Excelente - Tarea completamente exitosa
- 75-89: Bueno - Tarea exitosa con excepciones menores
- 60-74: Aceptable - Tarea completada pero requiere mejoras
- < 60: Insuficiente - Tarea requiere retrabajos

**Resultado:** [EXCELENTE/BUENO/ACEPTABLE/INSUFICIENTE]

---

## Resumen de Validacion

### Hallazgos Principales

**Fortalezas:**
1. [Fortaleza 1: que salio muy bien]
2. [Fortaleza 2: aspecto positivo destacado]
3. [Fortaleza N: logro importante]

**Debilidades/Gaps:**
1. [Debilidad 1: que falta o esta incompleto]
2. [Debilidad 2: aspecto a mejorar]
3. [Debilidad N: gap identificado]

**Riesgos Identificados:**
1. [Riesgo 1: posible problema futuro]
2. [Riesgo 2: dependencia fragil]
3. [Riesgo N: area de atencion]

### Acciones Correctivas Requeridas

[SI Score < 90, listar acciones correctivas]

- [[x]/[ ]] [Accion 1: descripcion de que corregir]
- [[x]/[ ]] [Accion 2: descripcion de que corregir]
- [[x]/[ ]] [Accion N: descripcion de que corregir]

[SI Score >= 90, escribir "No se requieren acciones correctivas"]

---

## Validacion Final

**Validacion Ejecutada:** [SI/NO]
**Fecha de Validacion:** [YYYY-MM-DD HH:MM]
**Validador:** [Nombre o "Auto-validacion"]

**Resultado General:** [PASS/FAIL]

**Justificacion:**
[Parrafo explicando por que PASS o FAIL basado en los scores y validaciones]

**Recomendacion:**
- [ ] APROBAR - Tarea completada exitosamente
- [ ] APROBAR CON EXCEPCIONES - Tarea completa pero con acciones correctivas menores
- [ ] RECHAZAR - Requiere retrabajo antes de aprobar

**Observaciones Finales:**
[Comentarios adicionales del validador]

---

**Validacion Completada:** [YYYY-MM-DD HH:MM]
**Tecnica Aplicada:** Self-Consistency (Validacion Multiple)
**Version del Reporte:** 1.0.0
**Estado:** [COMPLETADO]

---

## NOTAS DE USO DE LA PLANTILLA

### Como personalizar esta plantilla:

1. **Frontmatter:**
   - Actualiza id, fecha, tarea, estado

2. **Perspectiva 1 (Existencia):**
   - Lista TODOS los artifacts que la tarea debio crear
   - Ejecuta comandos de validacion
   - Registra si existen o no

3. **Perspectiva 2 (Estructura):**
   - Define estructura esperada (frontmatter, secciones, formato)
   - Valida cada artifact contra estructura
   - Marca PASS/FAIL

4. **Perspectiva 3 (Contenido):**
   - Define que significa "contenido completo" para tu tarea
   - Valida propositos, completitud, coherencia
   - Verifica referencias cruzadas

5. **Perspectiva 4 (Calidad):**
   - Valida calidad tecnica (markdown, YAML, enlaces)
   - Verifica estandares del proyecto
   - Busca errores comunes

6. **Perspectiva 5 (Self-Consistency):**
   - Formula preguntas que se puedan responder desde multiples perspectivas
   - Compara respuestas para detectar inconsistencias
   - Busca contradicciones

7. **Perspectiva 6 (Criterios):**
   - Copia EXACTAMENTE los criterios del README de la tarea
   - Marca [x] los cumplidos
   - Calcula porcentaje

8. **Matriz de Validacion Cruzada:**
   - Define aspectos clave a validar
   - Valida cada aspecto desde TODAS las perspectivas
   - Marca consistencia

9. **Score de Completitud:**
   - Asigna pesos a cada perspectiva segun importancia
   - Calcula scores reales
   - Interpreta resultado

10. **Resumen:**
    - Sintetiza hallazgos
    - Lista acciones correctivas si score < 90
    - Emite recomendacion final

### Perspectivas Obligatorias:
- P1: Existencia (siempre requerida)
- P3: Contenido (siempre requerida)
- P6: Criterios (siempre requerida)

### Perspectivas Opcionales:
- P2: Estructura (si la tarea creo archivos con estructura especifica)
- P4: Calidad (si hay estandares de calidad definidos)
- P5: Self-Consistency (recomendada para tareas complejas)

### Consejos:
- Self-Consistency requiere validar desde MULTIPLES perspectivas
- Un aspecto es valido si es consistente en TODAS las perspectivas
- No te saltes perspectivas - cada una aporta valor
- Se objetivo en los scores
- Documenta evidencia de cada validacion
- NO uses emojis
