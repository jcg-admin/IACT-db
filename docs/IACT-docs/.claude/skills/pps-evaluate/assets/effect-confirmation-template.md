# Effect Confirmation & Standardization — PS8 Steps 7-8

> Template de confirmación de efecto y estandarización.
> Completar en pps:evaluate para cerrar el ciclo PS8.

---

## Información general

| Campo | Valor |
|-------|-------|
| **Proyecto / WP** | [nombre del WP] |
| **Fecha de inicio de evaluación** | [YYYY-MM-DD] |
| **Período de medición post-implementación** | [fecha inicio] → [fecha fin] |
| **Evaluador** | [nombre] |
| **Aprobado por** | [dueño del proceso o sponsor] |

---

## Sección 1 — Step 7: Confirmación de efecto

### 1.1 Datos post-implementación vs baseline y target

| Métrica | Baseline (pps:target) | Target (pps:target) | Resultado real | % de mejora lograda | ¿Target alcanzado? |
|---------|----------------------|---------------------|----------------|--------------------|--------------------|
| [métrica principal] | [valor] | [meta] | [valor real] | [%] | ✅ / ❌ / Parcial |
| [métrica secundaria 1] | [umbral] | ≥ [umbral] | [valor real] | — | ✅ / ❌ |
| [métrica secundaria 2] | [umbral] | ≥ [umbral] | [valor real] | — | ✅ / ❌ |

### 1.2 Análisis de sostenibilidad

¿La mejora se mantiene en el tiempo?

| Semana | Valor de la métrica | Dentro del target | Observación |
|--------|---------------------|------------------|-------------|
| Semana 1 post-impl | [valor] | ✅ / ❌ | |
| Semana 2 post-impl | [valor] | ✅ / ❌ | |
| Semana 3 post-impl | [valor] | ✅ / ❌ | |
| Semana 4 post-impl | [valor] | ✅ / ❌ | |

**¿Es sostenida la mejora?**
- [ ] Sí — [N] semanas consecutivas dentro del target
- [ ] No — hay regresión en la semana [N]: [descripción]
- [ ] Parcialmente — alta variabilidad; el proceso aún no está estabilizado

### 1.3 Efectos secundarios

| Efecto observado | Positivo / Negativo | Impacto | Acción requerida |
|-----------------|--------------------|---------|-----------------| 
| [descripción] | + / - | [magnitud] | [si aplica] |

### 1.4 Diagnóstico de resultado

- [ ] **Target alcanzado completamente** — estandarizar y cerrar el ciclo PS8
- [ ] **Mejora parcial ([%] del target)** — documentar brecha residual, evaluar nuevo ciclo
- [ ] **Sin mejora significativa** — regresar a pps:analyze con nueva información
- [ ] **Regresión** — investigar urgente, posible efecto secundario no anticipado

**Justificación del diagnóstico:**

[Por qué se clasificó de esta manera — qué datos lo soportan]

---

## Sección 2 — Step 8: Estandarización

### 2.1 Contramedidas que se estandarizan

| Contramedida | Efecto confirmado | ¿Estandarizar? | Motivo |
|-------------|-------------------|----------------|--------|
| CM-[N] | ✅ / ❌ / Parcial | Sí / No | [razón de la decisión] |
| CM-[N] | ✅ / ❌ / Parcial | Sí / No | [razón de la decisión] |

### 2.2 Plan de estandarización por contramedida

Para cada contramedida que se estandariza:

#### CM-[N]: [descripción]

| Elemento | Detalle |
|----------|---------|
| **Cómo se estandariza** | [SOP actualizado / automatización / poka-yoke / control en código] |
| **Documento/sistema actualizado** | [nombre del documento o sistema] |
| **Capacitación requerida** | [quién necesita conocer el nuevo estándar] |
| **Mecanismo de control** | [qué verifica que el estándar se mantiene] |
| **Indicador de sostenibilidad** | [métrica que monitorea la regresión] |
| **Umbral de alerta** | [valor que dispara revisión] |
| **Frecuencia de revisión** | [semanal / mensual / trimestral] |
| **Responsable de sostenimiento** | [nombre o rol] |

### 2.3 Checklist de estandarización completada

- [ ] Procedimientos/SOPs actualizados o creados
- [ ] Cambios en código / configuración / infraestructura commiteados
- [ ] Capacitación entregada a quienes ejecutan el proceso
- [ ] Indicadores de sostenibilidad activos en dashboard o reporte
- [ ] Responsable de sostenimiento confirmado

---

## Sección 3 — Aprendizajes y Yokoten

### 3.1 Aprendizajes clave del ciclo PS8

| # | Aprendizaje | Categoría |
|---|-------------|-----------|
| 1 | [qué funcionó y por qué] | Qué replicar |
| 2 | [qué no funcionó y qué se aprendió] | Qué evitar |
| 3 | [qué harías diferente en el próximo ciclo] | Mejora del proceso PS8 |

### 3.2 Yokoten — transferencia lateral de aprendizaje

**¿Hay procesos similares donde esta causa raíz o estas contramedidas podrían aplicarse?**

| Proceso/Equipo similar | Por qué es relevante | Acción de transferencia |
|------------------------|---------------------|------------------------|
| [nombre] | [similitud con el problema resuelto] | Presentación / Documento compartido / Taller |

**¿Quién debería conocer estos aprendizajes?**

[Lista de equipos, áreas o personas que se beneficiarían de este A3]

### 3.3 Plan de comunicación de resultados

| Audiencia | Contenido | Formato | Fecha |
|-----------|-----------|---------|-------|
| Equipo del proyecto | Retrospectiva completa | Sesión de aprendizaje | [fecha] |
| Dueño del proceso | Resultados vs target | A3 Report completo | [fecha] |
| Sponsor | ROI, resultados, estado | Presentación ejecutiva | [fecha] |
| Equipos similares (Yokoten) | Causa raíz + contramedidas | Presentación o documento | [fecha] |

---

## Sección 4 — Brecha residual y próximos pasos

**¿Hay brecha residual?**
- [ ] No — target alcanzado completamente
- [ ] Sí — brecha de [valor] ([%] del target)

**Si hay brecha residual:**

| Causa de la brecha | ¿Requiere nuevo ciclo PS8? | Prioridad |
|-------------------|--------------------------|-----------|
| [descripción] | Sí / No / Evaluar en [fecha] | Alta / Media / Baja |

**Próximos pasos formales:**

- [ ] Presentar A3 completo al sponsor ([fecha])
- [ ] Compartir A3 con equipos de Yokoten ([fecha])
- [ ] Programar revisión de sostenibilidad en [fecha]
- [ ] Iniciar nuevo ciclo PS8 para brecha residual (si aplica)
- [ ] Archivar A3 en repositorio de conocimiento del equipo

---

## Sección 5 — Aprobación de cierre

| Campo | Valor |
|-------|-------|
| **Ciclo PS8 declarado como** | Cerrado completamente / Cerrado con brecha documentada / Regresar a pps:analyze |
| **Aprobado por** | [dueño del proceso o sponsor] |
| **Fecha de cierre** | [YYYY-MM-DD] |
| **Comentarios finales** | [observaciones del aprobador] |
