# pdca-act — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pdca:act
author: [nombre]
status: Borrador
```

---

## Decisión

- [ ] **Estandarizar y escalar** — objetivo alcanzado, sin regresiones
- [ ] **Estandarizar con ajuste** — objetivo alcanzado pero con regresión en métrica de control → corregir primero
- [ ] **Nuevo ciclo — hipótesis correcta, implementación incompleta** — [qué quedó pendiente]
- [ ] **Nuevo ciclo — hipótesis parcialmente correcta** — [qué refinar]
- [ ] **Nuevo ciclo — hipótesis incorrecta** — [nueva hipótesis]

**Justificación:** [Por qué se eligió esta decisión — basado en el Check]

---

## Si Estandarizar

### Cambios al estándar

| Artefacto | Cambio aplicado | Responsable | Fecha |
|-----------|----------------|-------------|-------|
| [SOP / Runbook / README] | [qué cambió exactamente] | [nombre] | [YYYY-MM-DD] |
| [Configuración / código] | [qué cambió exactamente] | [nombre] | [YYYY-MM-DD] |

### Poka-yoke aplicado

| Mecanismo | Descripción | Protege contra |
|-----------|------------|----------------|
| [Constraint / Automatización / Monitor / Documentación] | [cómo funciona] | [qué regresión previene] |

*Ver catálogo de técnicas poka-yoke y proceso Yokoten: [standardization-patterns.md](./references/standardization-patterns.md)*

### Yokoten — despliegue horizontal

| Área / proceso análogo | ¿Aplica la misma mejora? | Acción tomada |
|----------------------|--------------------------|--------------|
| [nombre del área] | Sí / No / Evaluar | [notificado / en proceso / N/A] |

*Si no aplica: "No se identificaron procesos análogos con el mismo problema."*

### Plan de rollout

| Fase | Ámbito | Fecha | Responsable | Criterio de éxito |
|------|--------|-------|-------------|------------------|
| 1 | [subconjunto inicial] | [YYYY-MM-DD] | [nombre] | [qué verificar] |
| 2 | [siguiente ámbito] | [YYYY-MM-DD] | [nombre] | [qué verificar] |
| Full | [ámbito completo] | [YYYY-MM-DD] | [nombre] | [qué verificar] |

### Comunicación a stakeholders

| Audiencia | Mensaje clave | Canal | Fecha |
|-----------|--------------|-------|-------|
| [Sponsor] | Resultado vs objetivo + impacto en negocio | [email/reunión] | [YYYY-MM-DD] |
| [Equipo operativo] | Qué cambia en su trabajo día a día | [reunión/doc] | [YYYY-MM-DD] |
| [Áreas análogas] | Aprendizaje clave + cómo replicarlo | [email/demo] | [YYYY-MM-DD] |

### Nuevo baseline

| Métrica | Baseline anterior | Nuevo baseline | Fecha establecida |
|---------|------------------|----------------|-----------------|
| [métrica principal] | [valor] | [valor] | [YYYY-MM-DD] |

---

## Si Nuevo ciclo

### Análisis del ciclo fallido

| Tipo de falla | ¿Aplica? | Evidencia |
|---------------|---------|-----------|
| Hipótesis incorrecta | Sí / No | [qué dato la refuta] |
| Implementación incompleta | Sí / No | [qué no se ejecutó] |
| Objetivo no realista | Sí / No | [qué los datos muestran] |
| Condiciones externas | Sí / No | [qué factor externo afectó] |

### Hipótesis ajustada para el próximo Plan

```
Si [nueva acción concreta], entonces [resultado esperado revisado], porque [mecanismo causal corregido].
```

### Cambios al próximo Plan

- [Qué será diferente en el Problem Statement / análisis de causa raíz / diseño del piloto]

---

## Lecciones aprendidas del ciclo

| Dimensión | Lección |
|-----------|---------|
| **Proceso** | [¿Qué funcionó bien en Plan-Do-Check? ¿Qué fue difícil?] |
| **Técnica** | [¿Las herramientas elegidas fueron las correctas?] |
| **Hipótesis** | [¿La hipótesis fue bien formulada? ¿Cómo mejorar el análisis inicial?] |
| **Datos** | [¿Los datos de Do fueron suficientes para concluir en Check?] |
| **Comunicación** | [¿Los stakeholders estuvieron informados y alineados?] |

*Ver template A3 Report para comunicación formal del ciclo completo: [standardization-patterns.md](./references/standardization-patterns.md)*
