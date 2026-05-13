---
# PLANTILLA: Checklist de Tareas
# Aplicando tecnicas: Auto-CoT + Self-Consistency (Combinadas)
# Version: 1.0.0
# Fecha: 2025-11-18
#
# INSTRUCCIONES DE USO:
# 1. Copia este archivo a: TASK-REORG-INFRA-XXX/evidencias/CHECKLIST-TAREAS.md
# 2. Reemplaza todos los valores entre [CORCHETES]
# 3. Usa [ ] para items pendientes, [x] para completados, [!] para bloqueados
# 4. Actualiza checklist conforme avanzas en la tarea
# 5. Este checklist combina Auto-CoT (pasos logicos) con Self-Consistency (validaciones multiples)
# 6. NO uses emojis
---

id: CHECKLIST-[TASK-ID]
fecha_creacion: [YYYY-MM-DD]
fecha_actualizacion: [YYYY-MM-DD]
tarea: [TASK-REORG-INFRA-XXX]
tipo: checklist_ejecucion
tecnicas: [Auto-CoT, Self-Consistency]
estado: [en_progreso/completado/bloqueado]

---

# CHECKLIST DE EJECUCION - [TASK-REORG-INFRA-XXX]

**Tarea:** [Nombre descriptivo de la tarea]
**Responsable:** [Nombre del responsable]
**Fecha Inicio:** [YYYY-MM-DD]
**Fecha Estimada Fin:** [YYYY-MM-DD]
**Estado Actual:** [EN_PROGRESO/COMPLETADO/BLOQUEADO]

---

## Leyenda de Estados

- [ ] Pendiente - No iniciado
- [x] Completado - Exitosamente finalizado
- [>] En Progreso - Actualmente trabajando en esto
- [!] Bloqueado - Bloqueado por dependencia o problema
- [?] Opcional - No es obligatorio, evaluar si es necesario

---

## FASE 1: Preparacion (Auto-CoT)

### 1.1. Comprension del Problema

- [ ] Leer README completo de [TASK-REORG-INFRA-XXX]
- [ ] Entender objetivo principal de la tarea
- [ ] Identificar criterios de aceptacion (total: [N criterios])
- [ ] Revisar dependencias previas (total: [N dependencias])
  - [ ] [TASK-XXX: nombre] - Estado: [completada/pendiente]
  - [ ] [TASK-YYY: nombre] - Estado: [completada/pendiente]
- [ ] Identificar restricciones o limitaciones
- [ ] Estimar complejidad real vs estimada ([ALTA/MEDIA/BAJA])

**Auto-CoT - Razonamiento:**
```
Pregunta: Que estoy tratando de resolver?
Respuesta: [Escribe tu razonamiento sobre el problema]

Pregunta: Por que es importante esta tarea?
Respuesta: [Escribe tu razonamiento sobre importancia]

Pregunta: Cuales son los riesgos principales?
Respuesta: [Escribe tu razonamiento sobre riesgos]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

### 1.2. Recoleccion de Informacion

- [ ] Leer documentos de referencia mencionados en README
  - [ ] [Documento 1: nombre]
  - [ ] [Documento 2: nombre]
  - [ ] [Documento N: nombre]
- [ ] Analizar tareas similares completadas anteriormente
  - [ ] [TASK-similar-1: leccion aprendida]
  - [ ] [TASK-similar-2: leccion aprendida]
- [ ] Revisar estructura de carpetas/archivos relevantes
- [ ] Identificar plantillas o ejemplos a seguir
- [ ] Recopilar comandos o scripts necesarios

**Auto-CoT - Razonamiento:**
```
Pregunta: Que informacion necesito antes de empezar?
Respuesta: [Lista y justifica informacion necesaria]

Pregunta: Hay ejemplos previos que puedo seguir?
Respuesta: [Referencias a ejemplos]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

### 1.3. Planificacion de Estrategia

- [ ] Dividir tarea en sub-tareas logicas (total: [N sub-tareas])
  - [ ] [Sub-tarea 1: nombre] - Prioridad: [ALTA/MEDIA/BAJA]
  - [ ] [Sub-tarea 2: nombre] - Prioridad: [ALTA/MEDIA/BAJA]
  - [ ] [Sub-tarea N: nombre] - Prioridad: [ALTA/MEDIA/BAJA]
- [ ] Definir orden de ejecucion optimo
- [ ] Identificar puntos de validacion intermedia
- [ ] Preparar plan de rollback si algo falla
- [ ] Establecer tiempo limite por sub-tarea

**Auto-CoT - Razonamiento:**
```
Pregunta: Cual es la mejor manera de abordar esta tarea?
Respuesta: [Escribe tu estrategia paso a paso]

Pregunta: Que pasa si algo falla en el paso X?
Respuesta: [Plan de contingencia]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

### 1.4. Preparacion de Entorno

- [ ] Crear estructura de carpetas necesarias
  - [ ] `[ruta/carpeta1]`
  - [ ] `[ruta/carpeta2]`
  - [ ] `[ruta/evidencias]`
- [ ] Verificar permisos de escritura/lectura
- [ ] Preparar herramientas o scripts necesarios
- [ ] Crear backup si se van a modificar archivos existentes
- [ ] Configurar entorno de trabajo (variables, etc)

**Comandos de Preparacion:**
```bash
# [Comando 1: descripcion]
[comando aqui]

# [Comando 2: descripcion]
[comando aqui]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

## FASE 2: Ejecucion (Auto-CoT Paso a Paso)

### 2.1. [Nombre de Sub-tarea 1]

**Objetivo:** [Que se busca lograr en esta sub-tarea]

**Pasos:**
- [ ] [Paso 1.1: accion especifica]
- [ ] [Paso 1.2: accion especifica]
- [ ] [Paso 1.N: accion especifica]

**Comandos Ejecutados:**
```bash
# [Descripcion del comando]
[comando aqui]
```

**Validacion Inmediata:**
- [ ] [Criterio de validacion 1]
- [ ] [Criterio de validacion 2]
- [ ] [Resultado esperado vs resultado real coinciden]

**Auto-CoT - Razonamiento:**
```
Pregunta: Por que ejecuto este paso ahora?
Respuesta: [Justificacion del orden]

Pregunta: Como valido que funciono?
Respuesta: [Metodo de validacion]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]
**Estado:** [COMPLETADO/EN_PROGRESO/BLOQUEADO]

**Notas:**
[Observaciones, problemas encontrados, soluciones aplicadas]

---

### 2.2. [Nombre de Sub-tarea 2]

[Repetir estructura de 2.1 para cada sub-tarea]

**Objetivo:** [Descripcion]

**Pasos:**
- [ ] [Paso 2.1]
- [ ] [Paso 2.2]

**Comandos Ejecutados:**
```bash
[comandos]
```

**Validacion Inmediata:**
- [ ] [Validacion 1]
- [ ] [Validacion 2]

**Auto-CoT - Razonamiento:**
```
[Razonamiento paso a paso]
```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]
**Estado:** [estado]

---

### 2.N. [Nombre de Sub-tarea N]

[Continuar para todas las sub-tareas...]

---

## FASE 3: Validacion (Self-Consistency)

### 3.1. Validacion de Existencia

**Objetivo:** Verificar que TODO lo que debia crearse existe.

- [ ] [Artifact 1] existe en `[ruta]`
- [ ] [Artifact 2] existe en `[ruta]`
- [ ] [Artifact N] existe en `[ruta]`

**Comando de Validacion:**
```bash
# Verificar existencia
[comando de validacion - ej: ls, find]
```

**Resultado:** [X/Y artifacts existen] - [PASS/FAIL]

---

### 3.2. Validacion de Estructura

**Objetivo:** Verificar estructura interna de artifacts.

- [ ] [Artifact 1] tiene estructura correcta (frontmatter, secciones)
- [ ] [Artifact 2] tiene estructura correcta
- [ ] [Artifact N] tiene estructura correcta

**Comando de Validacion:**
```bash
# Verificar estructura
[comando de validacion - ej: grep, head]
```

**Resultado:** [X/Y artifacts con estructura correcta] - [PASS/FAIL]

---

### 3.3. Validacion de Contenido

**Objetivo:** Verificar que contenido es completo y correcto.

- [ ] Todos los artifacts tienen contenido (no estan vacios)
- [ ] Contenido es relevante y especifico (no generico)
- [ ] Propositos/objetivos estan claramente documentados
- [ ] No hay secciones incompletas o placeholder
- [ ] Referencias cruzadas funcionan correctamente

**Resultado:** [Contenido completo: SI/NO] - [PASS/FAIL]

---

### 3.4. Validacion de Calidad

**Objetivo:** Verificar que artifacts cumplen estandares de calidad.

- [ ] Sin errores de ortografia evidentes
- [ ] Formato Markdown valido (sin errores de sintaxis)
- [ ] Sin emojis en contenido
- [ ] Indentacion y espaciado consistente
- [ ] Frontmatter YAML valido (si aplica)
- [ ] Enlaces no rotos
- [ ] Nomenclatura sigue convenciones del proyecto

**Comando de Validacion:**
```bash
# Validar calidad
[comandos de validacion]
```

**Resultado:** [Calidad aceptable: SI/NO] - [PASS/FAIL]

---

### 3.5. Validacion de Criterios de Aceptacion

**Objetivo:** Verificar que TODOS los criterios del README se cumplen.

[Copiar criterios de aceptacion del README de la tarea]

- [ ] [Criterio 1: descripcion exacta]
- [ ] [Criterio 2: descripcion exacta]
- [ ] [Criterio 3: descripcion exacta]
- [ ] [Criterio N: descripcion exacta]

**Total Criterios:** [N]
**Criterios Cumplidos:** [M]
**Porcentaje:** [M/N * 100]%

**Resultado:** [Criterios cumplidos: M/N] - [PASS/FAIL]

---

### 3.6. Validacion Self-Consistency

**Objetivo:** Validacion cruzada desde multiples perspectivas.

**Pregunta 1:** [Pregunta especifica que se puede responder de multiples formas]

- Respuesta desde perspectiva A (existencia): [respuesta]
- Respuesta desde perspectiva B (estructura): [respuesta]
- Respuesta desde perspectiva C (contenido): [respuesta]
- **Consistencia:** [CONSISTENTE/INCONSISTENTE]

**Pregunta 2:** [Otra pregunta especifica]

- Respuesta desde perspectiva A: [respuesta]
- Respuesta desde perspectiva B: [respuesta]
- Respuesta desde perspectiva C: [respuesta]
- **Consistencia:** [CONSISTENTE/INCONSISTENTE]

**Resultado:** [Todas las respuestas consistentes: SI/NO] - [PASS/FAIL]

---

## FASE 4: Documentacion de Evidencias

### 4.1. Crear Archivos de Evidencia

- [ ] Crear `RESUMEN-EJECUCION.md` (usando plantilla)
  - [ ] Seccion Auto-CoT completada
  - [ ] Metricas documentadas
  - [ ] Problemas y soluciones registrados
- [ ] Crear `VALIDACION-COMPLETITUD.md` (usando plantilla)
  - [ ] 6 perspectivas de validacion completadas
  - [ ] Score de completitud calculado
- [ ] Crear archivos de evidencia especificos:
  - [ ] [evidencia-1.txt: descripcion]
  - [ ] [evidencia-2.log: descripcion]
  - [ ] [evidencia-N: descripcion]

**Ubicacion Evidencias:** `[ruta/completa/evidencias/]`

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

### 4.2. Actualizar Documentacion de Tarea

- [ ] Marcar tarea como COMPLETADA en README
- [ ] Actualizar estado en LISTADO-COMPLETO-TAREAS.md (si aplica)
- [ ] Actualizar fecha de finalizacion
- [ ] Documentar lecciones aprendidas
- [ ] Listar proximos pasos o tareas desbloqueadas

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

## FASE 5: Finalizacion

### 5.1. Revision Final

- [ ] Revisar TODOS los items de este checklist
- [ ] Confirmar que todas las validaciones pasaron (PASS)
- [ ] Verificar que evidencias estan completas
- [ ] Confirmar que criterios de aceptacion se cumplen 100%
- [ ] Revisar que no hay trabajo pendiente

**Auto-Evaluacion:**
- Completitud: [X]%
- Calidad: [EXCELENTE/BUENA/ACEPTABLE/INSUFICIENTE]
- Criterios: [M/N cumplidos]
- Recomendacion: [APROBAR/REVISAR/RECHAZAR]

---

### 5.2. Commit y Push (si aplica)

- [ ] Agregar archivos al staging area
  ```bash
  git add [archivos]
  ```
- [ ] Crear commit con mensaje descriptivo
  ```bash
  git commit -m "[TASK-XXX] descripcion clara de cambios"
  ```
- [ ] Verificar estado post-commit
  ```bash
  git status
  ```
- [ ] Push a rama (si corresponde)
  ```bash
  git push origin [branch]
  ```

**Tiempo Estimado:** [X minutos]
**Tiempo Real:** [Y minutos]

---

### 5.3. Notificacion y Handoff

- [ ] Notificar a stakeholders de finalizacion
- [ ] Documentar siguiente tarea a ejecutar
- [ ] Transferir conocimiento si es necesario
- [ ] Archivar/organizar artefactos creados
- [ ] Actualizar tableros de tracking (si aplica)

---

## Resumen de Metricas

### Tiempo

| Fase | Estimado | Real | Diferencia |
|------|----------|------|------------|
| Fase 1: Preparacion | [X min] | [Y min] | [+/- Z min] |
| Fase 2: Ejecucion | [X min] | [Y min] | [+/- Z min] |
| Fase 3: Validacion | [X min] | [Y min] | [+/- Z min] |
| Fase 4: Documentacion | [X min] | [Y min] | [+/- Z min] |
| Fase 5: Finalizacion | [X min] | [Y min] | [+/- Z min] |
| **TOTAL** | **[X min]** | **[Y min]** | **[+/- Z min]** |

**Precision de Estimacion:** [BUENA/REGULAR/POBRE]

---

### Completitud

| Aspecto | Total Items | Completados | Porcentaje |
|---------|------------|-------------|------------|
| Sub-tareas | [N] | [M] | [M/N * 100]% |
| Validaciones | [N] | [M] | [M/N * 100]% |
| Criterios Aceptacion | [N] | [M] | [M/N * 100]% |
| Evidencias | [N] | [M] | [M/N * 100]% |
| **TOTAL** | **[N]** | **[M]** | **[M/N * 100]%** |

---

### Calidad

| Metrica | Resultado |
|---------|-----------|
| Validacion de Existencia | [PASS/FAIL] |
| Validacion de Estructura | [PASS/FAIL] |
| Validacion de Contenido | [PASS/FAIL] |
| Validacion de Calidad | [PASS/FAIL] |
| Validacion Self-Consistency | [PASS/FAIL] |
| Criterios de Aceptacion | [M/N cumplidos] |

**Score General:** [X/100]

---

## Problemas Encontrados

### Problema 1: [Descripcion]

- **Fase:** [En que fase ocurrio]
- **Impacto:** [ALTO/MEDIO/BAJO]
- **Tiempo Perdido:** [X minutos]
- **Solucion:** [Como se resolvio]
- **Prevencion Futura:** [Como evitar en futuras tareas]

[Agregar mas problemas si hubo]

---

## Lecciones Aprendidas

1. [Leccion 1: que aprendimos]
2. [Leccion 2: que se puede mejorar]
3. [Leccion N: best practice identificada]

---

## Estado Final

**Tarea:** [COMPLETADA/PARCIAL/BLOQUEADA]
**Fecha Finalizacion:** [YYYY-MM-DD HH:MM]
**Criterios Cumplidos:** [M/N] ([X]%)
**Calidad:** [EXCELENTE/BUENA/ACEPTABLE/INSUFICIENTE]
**Evidencias:** [COMPLETAS/PARCIALES]

**Recomendacion:**
- [x] APROBAR - Tarea completada exitosamente
- [ ] APROBAR CON RESERVAS - Requiere seguimiento menor
- [ ] RECHAZAR - Requiere retrabajo

**Aprobador:** [Nombre]
**Fecha Aprobacion:** [YYYY-MM-DD]

---

**Checklist Completado:** [YYYY-MM-DD HH:MM]
**Tecnicas Aplicadas:** Auto-CoT (pasos logicos) + Self-Consistency (validacion multiple)
**Version:** 1.0.0

---

## NOTAS DE USO DE LA PLANTILLA

### Como usar este checklist:

1. **Antes de Empezar:**
   - Copia este archivo a la carpeta evidencias/ de tu tarea
   - Reemplaza TODOS los [CORCHETES] con info real
   - Lee FASE 1 completa antes de empezar ejecucion

2. **Durante Ejecucion:**
   - Marca [x] items conforme los completas
   - Usa [>] para item actual en progreso
   - Usa [!] si algo se bloquea
   - Actualiza tiempos reales conforme avanzas
   - Documenta problemas en seccion correspondiente

3. **Durante Validacion:**
   - NO saltes validaciones - ejecuta TODAS
   - Registra resultados PASS/FAIL objetivamente
   - Si algo falla, documenta y corrige antes de continuar

4. **Al Finalizar:**
   - Completa seccion de Metricas
   - Calcula porcentajes y scores
   - Escribe lecciones aprendidas
   - Emite recomendacion final

### Beneficios de combinar Auto-CoT + Self-Consistency:

- **Auto-CoT** te guia en el razonamiento paso a paso (Fases 1 y 2)
- **Self-Consistency** te valida desde multiples perspectivas (Fase 3)
- Juntos aseguran completitud Y calidad

### Personalizacion:

- Agrega sub-tareas segun tu tarea especifica (seccion 2.X)
- Ajusta fases si tu tarea requiere flujo diferente
- Agrega validaciones especificas de tu dominio
- Modifica pesos en scoring si ciertos aspectos son mas criticos

### Consejos:

- Actualiza el checklist conforme avanzas (no al final)
- Se honesto en auto-evaluaciones
- Documenta razonamiento en secciones Auto-CoT
- NO uses emojis
- Mantiene formato markdown limpio
