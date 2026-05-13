---
name: dmaic-control
description: "Use when sustaining improvements in a DMAIC project. dmaic:control — create Control Plan, update SOPs, configure ongoing monitoring, and transfer process ownership."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 01:00:00
---

# /dmaic-control — DMAIC: Control

> *"An improvement that isn't sustained isn't an improvement — it's a temporary fix. Control is what separates DMAIC projects from firefighting."*

Ejecuta la fase **Control** de DMAIC. Sostiene las mejoras en el tiempo, transfiere la propiedad del proceso y cierra el proyecto formalmente.

**THYROX Stage:** Stage 11 TRACK/EVALUATE / Stage 12 STANDARDIZE.

**Tollgate:** Control Plan activo y proceso transferido al dueño del proceso antes de cerrar el proyecto.

---

## Pre-condición

Requiere: `{wp}/dmaic-improve.md` con:
- Mejora validada estadísticamente (nuevo Sigma Level documentado)
- Piloto completado con datos post-implementación
- Solución estable en el scope del piloto

---

## Cuándo usar este paso

- Cuando la mejora de Improve está validada estadísticamente
- Para asegurar que la mejora no se pierda con el tiempo
- Para transferir la responsabilidad del proceso del equipo del proyecto al dueño del proceso

## Cuándo NO usar este paso

- Sin validación de Improve — Control de una mejora no validada no tiene base
- Si el proceso está actualmente inestable (causas especiales activas) — estabilizar primero
- Sin dueño del proceso identificado — alguien específico debe hacerse responsable post-proyecto

---

## Actividades

### 1. Control Plan — el documento central de Control

El Control Plan define *exactamente* cómo se va a monitorear y mantener el proceso mejorado:

| Característica | Método de medición | Frecuencia | Quién | Límites de control | Acción ante desvío |
|---------------|-------------------|-----------|-------|-------------------|-------------------|
| [CTQ principal] | [Instrumento/sistema] | [Diaria/semanal] | [Rol/nombre] | [UCL / LCL] | [Procedimiento de respuesta] |
| [CTQs secundarios] | | | | | |
| [Variables críticas del proceso] | | | | | |

**Cada fila del Control Plan es un compromiso operacional — no un documento de referencia.**

### 2. SPC — Statistical Process Control

Para CTQs continuos críticos, implementar gráficas de control:

**Selección del tipo de gráfica:**

| Tipo de dato | Tamaño de subgrupo | Gráfica recomendada |
|-------------|-------------------|-------------------|
| Continuo | n = 1 (medición individual) | I-MR (Individuales y Rango Móvil) |
| Continuo | n = 2-9 (subgrupos pequeños) | X-bar / R |
| Continuo | n ≥ 10 (subgrupos grandes) | X-bar / S |
| Atributo — proporción defectuosa | Variable | p-chart |
| Atributo — defectos por unidad | Variable | u-chart |
| Conteo — defectos totales | n fijo | c-chart |

**Límites de control (UCL / LCL):**
- Calcular desde los datos de Improve (proceso mejorado), no del baseline
- UCL = Media + 3σ, LCL = Media − 3σ (para gráficas de Shewhart)

**Señales de alarma — Reglas de Western Electric (las 8 reglas):**

| Regla | Señal de causa especial |
|-------|------------------------|
| 1 | 1 punto fuera de los límites de control (±3σ) |
| 2 | 2 de 3 puntos consecutivos más allá de ±2σ (mismo lado) |
| 3 | 4 de 5 puntos consecutivos más allá de ±1σ (mismo lado) |
| 4 | 8 puntos consecutivos del mismo lado de la línea central |
| 5 | 6 puntos consecutivos en tendencia ascendente o descendente |
| 6 | 15 puntos consecutivos dentro de ±1σ (estratificación/hugging) |
| 7 | 14 puntos consecutivos alternando arriba-abajo |
| 8 | 8 puntos consecutivos a ambos lados de la media, ninguno dentro de ±1σ |

> En la práctica, usar las reglas 1 y 4 como mínimo. Agregar las demás si el proceso tiene alta criticidad o si se quiere sensibilidad para detectar causas especiales sutiles.

Ver tabla de selección de tipo de gráfica SPC, causas típicas por regla y Plan de Reacción completo: [control-chart-guide.md](./references/control-chart-guide.md)

### 3. Respuesta ante señales de alarma — Plan de reacción

El valor de las gráficas de control está en el Plan de Reacción: qué hace *exactamente* alguien cuando aparece una señal. Sin plan de reacción, las gráficas son decoración.

| Señal | ¿Quién actúa? | ¿Qué hace primero? | ¿Cuándo escalar? |
|-------|--------------|-------------------|-----------------|
| Regla 1: punto fuera de UCL/LCL | Operador | Verificar si es error de medición → si real, iniciar análisis de causa | Si no se identifica causa en 24h |
| Regla 4: 8 puntos del mismo lado | Supervisor | Revisar si hubo cambio en el proceso o insumos | Inmediatamente si no hay causa obvia |
| Tendencia (Regla 5) | Supervisor | Revisar variables de proceso | Si continúa después de corrección |
| Patrón cíclico (Regla 7) | Ingeniero | Analizar factores temporales (turnos, días, semana) | Inmediatamente |

> Documentar el Plan de Reacción junto con el Control Plan — son inseparables.

### 4. Gestión Visual — hacer visible el estado del proceso

Las gráficas de control son más efectivas cuando están visibles en el punto de trabajo:

| Elemento de gestión visual | Propósito |
|---------------------------|-----------|
| **Dashboard del proceso** | Estado actual del CTQ vs límites de control — visible para el equipo en tiempo real |
| **Semáforo de estado** | Verde/Amarillo/Rojo según posición del último punto vs límites | 
| **Andon** (para manufactura) | Señal visual o auditiva automática cuando aparece una señal de alarma |
| **Tablero de métricas en el lugar de trabajo** | CTQ principal actualizado diariamente; todos pueden ver si el proceso está en control |

> La gestión visual reduce el tiempo de detección de problemas — no se espera al reporte semanal para saber si algo está fuera de control.

### 5. Actualizar SOPs y documentación

Los procedimientos del proceso deben reflejar el nuevo método de trabajo:

| Documento | Qué actualizar |
|-----------|---------------|
| **SOP / procedimiento operativo** | Pasos nuevos del proceso, parámetros actualizados |
| **Especificaciones técnicas** | Límites de especificación si cambiaron |
| **Runbooks / playbooks** | Procedimientos de operación y mantenimiento |
| **Documentación de sistema** | Si hubo cambios en software, configuración, infraestructura |

> No incluir referencias a herramientas de trabajo específicas del equipo de mejora en los SOPs estándar del proceso — los SOPs deben ser independientes de cómo se ejecutó el proyecto.

### 6. Training — transferir conocimiento

| Contenido del training | Audiencia |
|----------------------|-----------|
| El problema que se resolvió y por qué importa | Todos los operadores del proceso |
| El nuevo método de trabajo (SOP actualizado) | Operadores que ejecutan el proceso |
| Cómo leer y reaccionar a las gráficas de control | Supervisores y dueño del proceso |
| Plan de reacción ante desvíos | Supervisores |

### 7. Lecciones aprendidas del proyecto

Antes de cerrar, capturar las lecciones del ciclo DMAIC completo:

| Dimensión | Pregunta |
|-----------|----------|
| **Define** | ¿El VOC fue suficiente? ¿El scope fue el correcto? |
| **Measure** | ¿El sistema de medición fue adecuado? ¿Los datos fueron representativos? |
| **Analyze** | ¿Las causas raíz identificadas eran las correctas? ¿Algo sorprendente? |
| **Improve** | ¿La solución funcionó como se esperaba? ¿Qué se haría diferente? |
| **Control** | ¿El Control Plan es sostenible? ¿El dueño del proceso está comprometido? |
| **Proceso DMAIC** | ¿Alguna fase tomó más tiempo del esperado? ¿Qué herramientas fueron más valiosas? |

> Las lecciones aprendidas son el principal activo para proyectos DMAIC futuros — no saltarlas por presión de cierre.

### 8. Cierre formal del proyecto

El proyecto DMAIC se cierra cuando:
1. El Control Plan está activo y monitoreado
2. El dueño del proceso ha aceptado formalmente la responsabilidad
3. Los beneficios del proyecto están documentados vs el business case

**Resultados finales:**

| Métrica | Baseline (Measure) | Post-Improve (piloto) | Resultado Control (estabilizado) | % Mejora |
|---------|-------------------|-----------------------|----------------------------------|---------|
| CTQ principal (Sigma Level) | | | | |
| Beneficio financiero realizado | | | | |

---

## Artefacto esperado

`{wp}/dmaic-control.md` — usar template: [dmaic-control-template.md](./assets/dmaic-control-template.md)

---

## Red Flags — señales de Control mal ejecutado

- **Control Plan sin responsable nombrado** — "el equipo" no es un responsable; necesita un nombre
- **Sin límites de control calculados** — gráficas sin UCL/LCL no permiten detectar señales de alarma
- **Plan de reacción ausente** — una gráfica de control sin plan de reacción no genera ningún valor
- **Solo usar la Regla 1 de Western Electric** — detectar solo puntos fuera de ±3σ deja sin detectar señales de tendencia, estratificación y ciclos
- **Sin gestión visual** — si las gráficas de control están en un sistema al que nadie mira, no hay control real
- **SOPs no actualizados** — si los procedimientos siguen describiendo el proceso antiguo, el nuevo método se perderá cuando roten los operadores
- **Training no realizado antes de la transferencia** — el dueño del proceso necesita entender el nuevo método antes de asumir la responsabilidad
- **Proyecto cerrado antes de que los beneficios se estabilicen** — el tollgate requiere datos del proceso *en control* con el nuevo método, no solo el piloto de Improve
- **Sin aceptación formal del dueño del proceso** — si el dueño no firma formalmente, no se hizo la transferencia real
- **Control Plan archivado sin uso** — un Control Plan que existe solo en papel y no se usa operacionalmente es inútil; verificar que el equipo operativo lo conoce y lo usa

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: dmaic:control
flow: dmaic
```

**Al COMPLETAR** (Control Plan activo, proceso transferido, proyecto cerrado):
```yaml
methodology_step: dmaic:control  # completado → DMAIC cerrado
flow: dmaic
```

## Siguiente paso

DMAIC completado. Iniciar Stage 11 TRACK/EVALUATE del WP → lecciones aprendidas y cierre formal del work package.

---

## Limitaciones

- Las gráficas de control SPC requieren herramientas específicas (Minitab, R, Python, Excel avanzado) — este skill guía qué configurar, no la implementación de la herramienta
- El monitoreo post-proyecto debe mantenerse mínimo 3-6 meses para confirmar que la mejora es sostenida; este skill cubre la configuración, no el monitoreo ongoing
- En procesos con alta complejidad regulatoria (FDA, ISO), los cambios a SOPs pueden requerir aprobaciones adicionales fuera del scope del proyecto DMAIC
- Las 8 reglas de Western Electric aplicadas simultáneamente aumentan la tasa de falsas alarmas — calibrar según el nivel de criticidad del proceso

---

## Reference Files

### Assets
- [dmaic-control-template.md](./assets/dmaic-control-template.md) — Template del artefacto Control: Control Plan, configuración SPC, Plan de Reacción, gestión visual, SOPs, training, cierre formal

### References
- [control-chart-guide.md](./references/control-chart-guide.md) — Selección de gráfica SPC (7 tipos), UCL/LCL fórmulas, 8 Reglas de Western Electric, causas típicas por regla, Plan de Reacción completo

### Scripts
- [check-control-limits.py](./scripts/check-control-limits.py) — Detecta violaciones de las 8 Reglas de Western Electric en datos de proceso CSV

```bash
# Uso básico — primera columna numérica
python .claude/skills/dmaic-control/scripts/check-control-limits.py process_data.csv

# Especificando columna
python .claude/skills/dmaic-control/scripts/check-control-limits.py measurements.csv cycle_time
```

**Output:** estadísticas de la gráfica (n, media, sigma, UCL, LCL) + lista de violaciones con regla, puntos afectados (base 1) y guía de reacción.
