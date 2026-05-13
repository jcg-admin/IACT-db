# Template 5 Whys — PS8 Step 4

> Template para el análisis de causa raíz mediante la técnica 5 Whys.
> Usar en pps:analyze para cada causa candidata significativa del Fishbone.

---

## Información general

| Campo | Valor |
|-------|-------|
| **Problema / Síntoma** | [Problem Statement de pps:clarify] |
| **Facilitador** | [nombre] |
| **Participantes** | [nombres — incluir a quienes conocen el proceso] |
| **Fecha** | [YYYY-MM-DD] |
| **Hilo #** | [1, 2, 3... — si hay múltiples cadenas causales] |

---

## Cadena causal

| Nivel | Pregunta | Respuesta | Evidencia / Datos que lo soportan |
|-------|----------|-----------|----------------------------------|
| **Síntoma** | ¿Qué está pasando? | [Problem Statement exacto] | [datos del Gemba] |
| **Why 1** | ¿Por qué ocurre el síntoma? | [causa inmediata] | [observación / dato / log] |
| **Why 2** | ¿Por qué ocurre [causa 1]? | [causa intermedia] | [observación / dato / log] |
| **Why 3** | ¿Por qué ocurre [causa 2]? | [causa más profunda] | [observación / dato / log] |
| **Why 4** | ¿Por qué ocurre [causa 3]? | [causa sistémica] | [observación / dato / log] |
| **Why 5** | ¿Por qué ocurre [causa 4]? | **[CAUSA RAÍZ]** | [observación / dato / log] |

> El número de "porqués" puede ser 3, 4, 5 o más. Detenerse cuando se llega a un factor sistémico accionable.

---

## Verificación de causa raíz alcanzada

**Checklist de causa raíz:**

- [ ] La respuesta es un factor sistémico (proceso, estándar, diseño, capacitación) — no una persona específica
- [ ] Si se corrige este factor, el problema no vuelve a ocurrir
- [ ] El equipo no puede preguntar otro "¿por qué?" sin salir del alcance del proyecto
- [ ] Hay evidencia que confirma que este factor existe y está activo

**¿Se llegó a la causa raíz?**
- [ ] Sí — la causa raíz está confirmada con evidencia
- [ ] No — continuar el análisis [describir qué falta]
- [ ] Parcialmente — hay múltiples causas raíz [listar y abrir hilo separado]

---

## Causas descartadas durante el análisis

| Hipótesis descartada | Por qué se descartó | Evidencia que la refuta |
|---------------------|---------------------|------------------------|
| [hipótesis 1] | [razón] | [dato o experimento] |
| [hipótesis 2] | [razón] | [dato o experimento] |

---

## Resumen

**Causa raíz identificada:**

[Descripción clara del factor sistémico identificado]

**Cadena causal completa (resumen):**

```
[Síntoma]
  → [Causa 1]
    → [Causa 2]
      → [Causa 3]
        → [Causa raíz]
```

**Confirmación con datos:**

[Qué evidencia específica confirma que esta es la causa raíz y no otra hipótesis]

**¿Requiere hilos adicionales de análisis?**

- [ ] No — esta cadena causal es suficiente
- [ ] Sí — abrir Hilo #[N] para [otra causa candidata del Fishbone]

---

## Señales de análisis incompleto — checklist de calidad

Antes de declarar la causa raíz confirmada, verificar:

- [ ] Cada "por qué" fue respondido con evidencia, no con supuesición
- [ ] La causa raíz NO menciona a una persona como culpable (busca causas sistémicas)
- [ ] Se consideraron causas de múltiples categorías (Fishbone), no solo la más obvia
- [ ] La causa raíz fue observada o verificada directamente (Gemba / datos)
- [ ] El equipo consultó a quienes conocen el proceso, no solo a managers
