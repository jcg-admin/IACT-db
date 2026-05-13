# Guía de Desarrollo de Contramedidas — PS8

> Referencia para el Step 5 de Toyota TBP: generar, evaluar y seleccionar contramedidas efectivas.

---

## Contramedida vs Solución — por qué importa la distinción

Toyota usa deliberadamente el término **contramedida** (countermeasure) en lugar de "solución" o "corrección". Esta distinción no es semántica — refleja una postura epistémica fundamental:

| Contramedida (TBP) | "Solución" convencional |
|--------------------|------------------------|
| Es la mejor respuesta disponible con el conocimiento actual | Implica certeza sobre la efectividad |
| Se evalúa con datos post-implementación | Se asume efectiva una vez implementada |
| Puede ajustarse si los resultados no confirman la hipótesis | Se "cierra" como resuelta |
| Trazable directamente desde una causa raíz confirmada | Puede responder al síntoma o a intuición |
| Refleja humildad — podemos estar equivocados | Cierra la exploración prematuramente |

Usar el término "contramedida" mantiene al equipo en modo aprendizaje: implementamos, observamos, confirmamos o ajustamos.

---

## Tipos de contramedidas

### Por efecto temporal

| Tipo | Cuándo usar | Ejemplo |
|------|-------------|---------|
| **Preventiva** | Elimina la causa para que el problema no ocurra | Agregar validación automática que impide el error antes de que se produzca |
| **Correctiva** | Responde cuando el problema ya ocurrió | Protocolo estandarizado de recuperación con tiempo objetivo |
| **Detectiva** | Identifica el problema más rápido para reducir el impacto | Alerta automática cuando el indicador cruza un umbral crítico |

### Por nivel de intervención (de más a menos robusto)

| Nivel | Descripción | Ejemplo | Robustez |
|-------|-------------|---------|----------|
| **Eliminación** | Remover completamente la fuente del problema | Eliminar el paso manual que genera el error | ★★★★★ |
| **Sustitución** | Reemplazar el elemento problemático por uno más confiable | Cambiar el proceso manual por automatización | ★★★★ |
| **Control de ingeniería (Poka-yoke)** | Diseño que hace imposible o muy difícil el error | Validación que no permite avanzar si el input es inválido | ★★★★ |
| **Control administrativo** | Procedimientos, estándares, capacitación | SOP actualizado + capacitación del equipo | ★★★ |
| **Señalización / recordatorio** | Alertas, indicadores visuales, recordatorios | Checklist manual, email de recordatorio | ★★ |

> **Regla TBP:** Siempre evaluar si existe una contramedida de nivel más alto (eliminación / control de ingeniería) antes de conformarse con una contramedida administrativa. Las contramedidas de nivel bajo dependen de comportamiento humano consistente y son inherentemente frágiles.

---

## Poka-yoke — diseño a prueba de errores

Poka-yoke (del japonés "prevención de errores inadvertidos") es el principio de diseñar sistemas que hacen imposible o inmediatamente visible el error humano.

**Tipos de poka-yoke:**

| Tipo | Principio | Ejemplo digital | Ejemplo físico |
|------|-----------|-----------------|----------------|
| **Prevención** | El error no puede ocurrir | Formulario que deshabilita "Enviar" si faltan campos | Conector que solo entra en la orientación correcta |
| **Detección** | El error ocurre pero se detecta inmediatamente | Test automático que falla antes del deploy si hay regresión | Señal de alarma cuando el operador omite un paso |
| **Mitigación** | El error puede ocurrir pero su impacto se limita | Rollback automático si el health check falla | Doble palanca que requiere dos manos para operar |

En el contexto de software y procesos digitales, las oportunidades de poka-yoke son abundantes: validaciones, automatizaciones, guards en código, alertas automáticas.

---

## Matriz de evaluación — cómo puntuar

**Impacto esperado (1-5):**
- 5: La contramedida elimina completamente la causa raíz — el problema no puede ocurrir
- 4: Reduce significativamente la frecuencia o severidad del problema (>70%)
- 3: Mejora parcial — reduce el problema pero no lo resuelve completamente
- 2: Impacto marginal — el problema continúa en la mayoría de los casos
- 1: Sin impacto measurable o impacto incierto

**Factibilidad (1-5):**
- 5: El equipo tiene todos los recursos, autoridad y capacidad para implementarlo
- 4: Requiere coordinación menor con otra área o aprobación de bajo nivel
- 3: Requiere recursos adicionales o aprobación de nivel medio
- 2: Requiere cambios significativos fuera del control directo del equipo
- 1: Requiere inversión mayor, aprobación ejecutiva o cambios tecnológicos de largo plazo

**Velocidad (1-5):**
- 5: Implementable en días (esta semana)
- 4: 2-4 semanas
- 3: 1-3 meses
- 2: 3-6 meses
- 1: Más de 6 meses

**Costo (1-5):**
- 5: Sin costo adicional (configuración, procedimiento)
- 4: Costo menor (horas de trabajo del equipo)
- 3: Inversión moderada (días de trabajo, herramientas menores)
- 2: Inversión significativa (semanas de trabajo, herramientas costosas)
- 1: Inversión mayor (meses de trabajo, infraestructura nueva)

---

## El Action Plan — estándar de calidad

Un Action Plan de calidad TBP tiene estas características:

- **Trazabilidad**: cada tarea tiene su causa raíz origen documentada
- **Responsable único**: una persona, no "el equipo"
- **Deadline específico**: una fecha, no "pronto" o "siguiente sprint"
- **Métrica de verificación**: cómo saber si la tarea tuvo el efecto esperado
- **Secuencia**: las dependencias entre tareas están documentadas
- **Cobertura**: todas las causas raíz confirmadas tienen al menos una tarea

Un Action Plan sin cualquiera de estos elementos no es un plan — es una lista de intenciones.
