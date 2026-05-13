# Standardization Patterns — PDCA:Act

Guías para consolidar mejoras: Yokoten, A3 Report, ciclo SDCA y estructura de SOPs.

---

## Yokoten — despliegue horizontal

Yokoten (横展開) es el principio Lean/Toyota de propagar aprendizajes a procesos análogos sin reinventar la rueda.

### Proceso de Yokoten en 4 pasos

**1. Identificar — ¿hay procesos análogos?**

| Criterio de similitud | Preguntas |
|----------------------|-----------|
| Mismo tipo de problema | ¿Hay otras áreas con el mismo síntoma (latencia, error, demora)? |
| Mismo tipo de proceso | ¿Es un proceso de tipo similar (batch, stream, manual, automatizado)? |
| Misma causa raíz potencial | ¿La hipótesis que funcionó aquí podría aplicar allá? |

**2. Adaptar — la mejora rara vez es copia exacta**

| Elemento a adaptar | Por qué |
|-------------------|---------|
| Escala / volumen | El proceso análogo puede tener diferente carga |
| Tecnología / stack | La implementación técnica puede diferir |
| Restricciones locales | Regulatorias, de SLA, de equipo |
| Métricas de referencia | El baseline y objetivo pueden ser distintos |

**3. Transferir — comunicar el aprendizaje**

| Audiencia | Contenido | Formato |
|-----------|-----------|---------|
| Líderes técnicos del área análoga | Hipótesis + resultados + cómo replicar | Demo + doc técnica |
| Equipos operativos | Qué cambia en su trabajo + por qué | Reunión breve + SOP actualizado |
| Repositorio de mejoras del área | Patrón generalizado + condiciones de aplicación | Wiki / CHANGELOG de mejoras |

**4. Verificar — confirmar que la transferencia funcionó**

- Definir un seguimiento a 2-4 semanas con el área que recibió el aprendizaje
- No asumir que "notificamos" es igual a "se implementó"

### Señales de que Yokoten NO aplica

- El problema es único a ese sistema/proceso
- Las diferencias de contexto son tan grandes que el aprendizaje no es transferible
- El área análoga ya resolvió el problema de otra manera
- No hay capacidad en el área análoga para implementar en el corto plazo

---

## A3 Report — template de una página

El A3 Report es el artefacto de comunicación estándar del ciclo PDCA completo. Permite presentar todo el ciclo en una sola página (originalmente papel A3 = 297×420mm).

### Template A3

```
╔══════════════════════════════╦══════════════════════════════╗
║  CONTEXTO                    ║  CONTRAMEDIDAS               ║
║  ─────────────────────────── ║  ─────────────────────────── ║
║  ¿Por qué este problema       ║  Plan de acción (Do):        ║
║  importa al negocio?          ║  • Acción 1 (resp, fecha)    ║
║  [2-3 líneas]                 ║  • Acción 2 (resp, fecha)    ║
║                              ║  • Acción 3 (resp, fecha)    ║
╠══════════════════════════════╣                              ║
║  SITUACIÓN ACTUAL            ║                              ║
║  ─────────────────────────── ║                              ║
║  Baseline: [métrica = valor] ╠══════════════════════════════╣
║  Problem Statement (IS/IS    ║  RESULTADO (Check)           ║
║  NOT resumido):              ║  ─────────────────────────── ║
║  [2-3 líneas]                ║  Antes → Después:            ║
║                              ║  [métrica]: X → Y (+Z%)      ║
╠══════════════════════════════║  ¿Objetivo alcanzado? Sí/No  ║
║  OBJETIVO (Plan)             ║                              ║
║  ─────────────────────────── ╠══════════════════════════════╣
║  SMART goal:                 ║  PRÓXIMOS PASOS (Act)        ║
║  [métrica de X a Y para Z]   ║  ─────────────────────────── ║
║                              ║  □ Estandarizar (rollout)    ║
╠══════════════════════════════║  □ Nuevo ciclo: [ajuste]     ║
║  ANÁLISIS DE CAUSA RAÍZ      ║  □ Yokoten a: [área]         ║
║  ─────────────────────────── ║  □ Nuevo baseline: [valor]   ║
║  Hipótesis:                  ║                              ║
║  Si [X] entonces [Y]         ║                              ║
║  porque [Z]                  ║                              ║
╚══════════════════════════════╩══════════════════════════════╝
```

### Cuándo usar A3

| Situación | A3 útil | Alternativa |
|-----------|---------|-------------|
| Múltiples stakeholders que no participaron en el ciclo | ✅ Sí | — |
| Presentación formal a management | ✅ Sí | — |
| Ciclo rápido (1-2 personas, scope pequeño) | ❌ No | Lecciones aprendidas en pdca-act.md |
| Primera vez que se usa PDCA en el equipo | ✅ Sí — como ejercicio de aprendizaje | — |

---

## Ciclo SDCA — Standardize-Do-Check-Act

Después de estandarizar un PDCA exitoso, el proceso entra en el ciclo SDCA de mantenimiento:

```
          ┌─────────────────────────────────────┐
          │           CICLO SDCA                │
          │                                     │
          │  S ─────── D ─────── C ─────── A   │
          │  Ejecutar  Seguir    Verificar  Act  │
          │  el nuevo  el nuevo  que se    si   │
          │  estándar  estándar  mantiene  hay  │
          │                     la mejora  desv │
          └─────────────────────────────────────┘
                                    │
                                    ▼ (desviación detectada)
                            ┌──────────────┐
                            │ Nuevo PDCA   │
                            │ (mejora)     │
                            └──────────────┘
```

### Diferencia PDCA vs SDCA

| Aspecto | PDCA | SDCA |
|---------|------|------|
| **Propósito** | Mejorar — subir el nivel | Mantener — sostener el nivel |
| **Punto de partida** | Problema o gap vs objetivo | Estándar establecido |
| **Señal de activación** | Problema identificado / objetivo de mejora | Desviación del estándar |
| **Output** | Nuevo estándar | Proceso funcionando según estándar |
| **Cuándo pasa a PDCA** | Cuando se identifica nueva oportunidad | Cuando la desviación es sistemática → investigar |

**Principio:** Todo proceso debería tener un SDCA activo. El PDCA es temporal — busca el nuevo estándar. El SDCA es permanente — mantiene el estándar alcanzado.

---

## Estructura de SOP (Standard Operating Procedure)

Un SOP es el documento que captura el nuevo estándar. Sin SOP escrito, la mejora no sobrevive la rotación del equipo.

### Campos mínimos de un SOP

| Campo | Contenido | Propósito |
|-------|-----------|-----------|
| **Nombre** | Nombre del proceso | Identificación |
| **Versión** | v1.0, v1.1, v2.0 | Control de cambios |
| **Fecha** | Fecha de vigencia | Referencia temporal |
| **Dueño** | Rol responsable de mantener el SOP actualizado | Accountability |
| **Alcance** | Qué cubre y qué no cubre | Evitar ambigüedad |
| **Prerequisitos** | Qué debe estar disponible/hecho antes de ejecutar | Prevenir errores de setup |
| **Pasos** | Instrucciones numeradas, con verbo activo | Ejecución reproducible |
| **Criterio de éxito** | Cómo saber que el proceso se ejecutó correctamente | Verificabilidad |
| **Señales de alerta** | Qué indica que algo está fallando | Detección temprana |
| **Escalamiento** | A quién contactar si hay problema | Gestión de incidentes |

### Template mínimo de SOP

```markdown
# SOP: [Nombre del proceso]

**Versión:** 1.0 | **Fecha:** YYYY-MM-DD | **Dueño:** [Rol]

## Alcance
[Qué cubre este SOP — y qué no cubre]

## Prerequisitos
- [Recurso / acceso / condición previa]

## Pasos
1. [Verbo + objeto + contexto — "Ejecutar el script X con parámetro Y"]
2. [Verificar que resultado Z esté presente antes de continuar]
3. ...

## Criterio de éxito
[Observable binario: qué debería verse cuando el proceso se ejecuta correctamente]

## Señales de alerta
| Señal | Significado probable | Acción |
|-------|---------------------|--------|
| [X] | [Y] | [Z] |

## Escalamiento
Si [condición]: contactar [rol] en [canal].
```

### Antipatrones de SOPs que no sirven

| Antipatrón | Problema | Corrección |
|------------|----------|------------|
| Pasos vagos ("verificar que todo esté bien") | No reproducible | Verbo + objeto + criterio medible |
| SOP sin dueño | Nadie lo actualiza cuando cambia el proceso | Asignar rol responsable |
| SOP en el área personal de alguien | Inaccesible para el equipo | Wiki / repositorio compartido |
| Versión obsoleta sin fecha | No se sabe si está vigente | Control de versiones + fecha de última revisión |
| Excesivamente detallado para tareas simples | Nadie lo lee | Calibrar al nivel del ejecutor: experto vs nuevo |
