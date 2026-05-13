# dmaic-control — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: dmaic:control
author: [nombre]
status: Borrador
```

---

## Control Plan

> Cada fila es un compromiso operacional activo, no un documento de referencia.

| Característica | Método de medición | Frecuencia | Responsable | UCL | LCL | Acción ante desvío |
|---------------|-------------------|-----------|-------------|-----|-----|-------------------|
| [CTQ principal] | [instrumento/sistema] | [diaria/semanal] | [nombre/rol] | [valor] | [valor] | [procedimiento específico] |
| [CTQ secundario] | | | | | | |
| [Variable crítica del proceso] | | | | | | |

**Dueño del Control Plan:** [Nombre y rol]
**Fecha de vigencia:** [YYYY-MM-DD]

---

## Gráficas de control configuradas (SPC)

| CTQ | Tipo de dato | Tamaño de subgrupo n | Tipo de gráfica | Límites de control (UCL/LCL) | Sistema / herramienta |
|-----|-------------|---------------------|----------------|-----------------------------|-----------------------|
| [CTQ] | [Continuo / Atributo] | [n] | [I-MR / X-bar R / p-chart / u-chart] | UCL=[valor] · LCL=[valor] | [Minitab/R/Excel/dashboard] |

**Base de datos para límites:** Datos del piloto de Improve (proceso mejorado — no del baseline)
**Período de cálculo:** [inicio → fin, n observaciones]

*Ver tabla de selección de tipo de gráfica y 8 Reglas Western Electric: [control-chart-guide.md](./references/control-chart-guide.md)*

---

## Plan de reacción ante señales de alarma

> Sin Plan de Reacción, las gráficas de control son decoración.

| Señal (Regla Western Electric) | ¿Quién actúa primero? | ¿Qué hace en las primeras 2 horas? | ¿Cuándo escalar? | Escalar a: |
|-------------------------------|---------------------|-----------------------------------|-----------------|-----------|
| Regla 1: punto fuera de UCL/LCL | [Operador] | Verificar si es error de medición → si real, documentar y buscar causa | Si no se identifica causa en [X] horas | [Supervisor] |
| Regla 4: 8 puntos mismo lado | [Supervisor] | Revisar cambios recientes en el proceso o insumos | Inmediatamente si no hay causa obvia | [Dueño del proceso] |
| Regla 5: tendencia de 6 puntos | [Supervisor] | Revisar variables de proceso y materiales | Si continúa tras corrección | [Dueño del proceso] |
| Otro patrón | [Ingeniero] | Analizar datos históricos | [criterio] | [escalamiento] |

*Ver descripción completa de las 8 reglas: [control-chart-guide.md](./references/control-chart-guide.md)*

---

## Gestión visual implementada

| Elemento | Descripción | Ubicación / acceso | Responsable de actualización |
|----------|-------------|-------------------|-----------------------------| 
| Dashboard del proceso | Estado actual del CTQ vs límites de control | [URL / ubicación física] | [nombre/sistema] |
| Frecuencia de actualización | [en tiempo real / diaria / semanal] | — | — |
| Semáforo de estado | Verde = dentro de control · Amarillo = señal de tendencia · Rojo = fuera de control | [dónde se ve] | [automático / manual] |

---

## SOPs actualizados

| Documento | Cambio aplicado | Versión anterior | Nueva versión | Responsable | Fecha |
|-----------|----------------|-----------------|--------------|-------------|-------|
| [SOP / Runbook] | [qué cambió] | [v1.0] | [v2.0] | [nombre] | [YYYY-MM-DD] |

---

## Training realizado

| Audiencia | Contenido | Fecha | Modalidad | N° participantes |
|-----------|-----------|-------|-----------|-----------------|
| Operadores del proceso | Nuevo método de trabajo (SOP actualizado) | [YYYY-MM-DD] | [presencial/virtual] | [n] |
| Supervisores | Cómo leer y reaccionar a gráficas de control | [YYYY-MM-DD] | | [n] |
| Dueño del proceso | Control Plan completo + Plan de reacción | [YYYY-MM-DD] | | [n] |

---

## Lecciones aprendidas del proyecto DMAIC

| Fase | Lección aprendida |
|------|------------------|
| **Define** | [¿El VOC fue suficiente? ¿El scope fue el correcto?] |
| **Measure** | [¿El sistema de medición fue adecuado? ¿Los datos fueron representativos?] |
| **Analyze** | [¿Las causas raíz identificadas eran las correctas? ¿Algo sorprendente?] |
| **Improve** | [¿La solución funcionó como se esperaba? ¿Qué se haría diferente?] |
| **Control** | [¿El Control Plan es sostenible? ¿El dueño del proceso está comprometido?] |
| **Proceso DMAIC** | [¿Qué fases tomaron más tiempo? ¿Qué herramientas fueron más valiosas?] |

---

## Transferencia al dueño del proceso

| Campo | Valor |
|-------|-------|
| Dueño del proceso | [Nombre y cargo] |
| Fecha de aceptación formal | [YYYY-MM-DD] |
| Elementos transferidos | Control Plan · SOPs actualizados · Acceso a gráficas de control · Plan de reacción |
| Compromiso del dueño | [Firma / confirmación escrita / email de aceptación] |

---

## Resultados finales del proyecto

| Métrica | Baseline (Measure) | Post-Improve (piloto) | Resultado Control (estabilizado) | % Mejora |
|---------|-------------------|----------------------|----------------------------------|---------|
| Sigma Level | [valor] | [valor] | [valor] | [%] |
| DPMO / Cpk | [valor] | [valor] | [valor] | [%] |
| Beneficio financiero | $[valor]/mes | $[estimado] | $[realizado] | — |

---

## Cierre formal del proyecto

| Campo | Valor |
|-------|-------|
| Fecha de cierre | [YYYY-MM-DD] |
| Aprobación del sponsor | [Nombre] — [YYYY-MM-DD] |
| Criterios de cierre cumplidos | [ ] Control Plan activo · [ ] Dueño aceptó responsabilidad · [ ] Beneficios documentados |
| Work package cerrado | [YYYY-MM-DD] |
