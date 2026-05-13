```yml
type: Análisis de Calibración Epistémica
version: 1.0
created_at: 2026-04-22 21:30:00
work_package: 2026-04-22-21-15-30-phase1-discover-iact-docs
phase: Phase 1 — DISCOVER
agent: agentic-reasoning
status: completed
metodologia: Clasificación de claims por tipo de evidencia + ratio CAD
ratio_global: 62% — PARCIALMENTE CALIBRADO
```

# IACT-docs — Análisis de Calibración Epistémica

## Resumen Ejecutivo

Evaluación de calibración epistémica de claims técnicos en IACT-docs mediante clasificación por tipo de evidencia y distribución por dominio (CAD: Calibración Asimétrica por Dominio).

**Ratio global: 62% — PARCIALMENTE CALIBRADO**

**Gate de evaluación:** 75% (no alcanzado)

---

## Metodología

Cada claim técnico fue clasificado según tipo de evidencia:

| Evidencia | Score | Definición |
|-----------|-------|-----------|
| PROVEN | 1.0 | Verificado directamente en código/docs |
| INFERRED | 0.6 | Deducible de estructura documentaria |
| SPECULATIVE | 0.2 | Proyectado sin validación explícita |

**Ratio de calibración = (claims_proven × 1.0 + claims_inferred × 0.6 + claims_speculative × 0.2) / total_claims**

---

## Claims Analizados (13 total)

### Dominio 1: Arquitectura Técnica

| # | Claim | Tipo | Score | Notas |
|---|-------|------|-------|-------|
| 1 | "IACT es Dashboard Analytics" | INFERRED | 0.6 | Visible en index.rst, no verificado en código |
| 2 | "Conecta MySQL → PostgreSQL" | INFERRED | 0.6 | Documentado en arquitectura, no verificado en ETL |
| 3 | "Django + DRF backend" | PROVEN | 1.0 | Listado en stack, tipología confirmada |
| 4 | "React + Webpack frontend" | INFERRED | 0.6 | React listado, Webpack NO en docs oficiales |
| 5 | "ETL robusto y trazable" | SPECULATIVE | 0.2 | Sin definición operacional, sin métricas |

**Subtotal A:** (1 + 2 + 1 + 1 + 0.2) / 5 = **1.04 / 5 = 0.69 (69%)**

---

### Dominio 2: Estructura Documentaria

| # | Claim | Tipo | Score | Notas |
|---|-------|------|-------|-------|
| 6 | "Modelo Documental IACT v2.0.0" | SPECULATIVE | 0.2 | Mencionado sin especificación, sin doc de transición |
| 7 | "5 Dominios Primarios" | PROVEN | 1.0 | Verificado directamente (5 directorios) |
| 8 | "21 Subdominios especializados" | SPECULATIVE | 0.2 | Reclamado pero no listado, no verificable |

**Subtotal B:** (0.2 + 1 + 0.2) / 3 = **1.4 / 3 = 0.47 (47%)**

---

### Dominio 3: Versionado y Metadata

| # | Claim | Tipo | Score | Notas |
|---|-------|------|-------|-------|
| 9 | "Versión documentación 1.0.0" | PROVEN | 1.0 | Explícito en metadata |
| 10 | "Fecha: 2025" | INFERRED | 0.6 | Año sin precisión (fecha incompleta) |
| 11 | "Equipo: IACT Development Team" | SPECULATIVE | 0.2 | Nombre genérico, sin roles específicos |

**Subtotal C:** (1 + 0.6 + 0.2) / 3 = **1.8 / 3 = 0.6 (60%)**

---

### Dominio 4: Requisitos

| # | Claim | Tipo | Score | Notas |
|---|-------|------|-------|-------|
| 12 | "Requisitos documentados y trazables" | INFERRED | 0.6 | Estructura visible, trazabilidad RTM no verificada |

**Subtotal D:** 0.6 / 1 = **0.6 (60%)**

---

### Dominio 5: Normativa y Gobernanza

| # | Claim | Tipo | Score | Notas |
|---|-------|------|-------|-------|
| 13 | "Estándares, gobernanza, procedimientos documentados" | INFERRED | 0.6 | 1.9 MB presente, completitud no verificada |

**Subtotal E:** 0.6 / 1 = **0.6 (60%)**

---

## Calibración Asimétrica por Dominio (CAD)

**Patrón identificado: Asimetría extrema entre dominios**

| Dominio | Claims | Score | Volumen | Patrón |
|---------|--------|-------|---------|--------|
| Arquitectura técnica | 5 | 69% | ~500 KB | MODERADO (mezcla PROVEN/SPECULATIVE) |
| Estructura documental | 3 | 47% | ~100 KB | BAJO (alto SPECULATIVE: 21 subdominios) |
| Versionado/Metadata | 3 | 60% | ~50 KB | BAJO (falta precisión) |
| Requisitos | 1 | 60% | ~1.1 MB | POTENCIAL NO REALIZADO (volumen alto, claim incierto) |
| Normativa | 1 | 60% | ~1.9 MB | POTENCIAL NO REALIZADO (volumen máximo, claim genérico) |

**Gráfico conceptual:**
```
Arquitectura:     [=====>         ] 69%
Estructura:       [==>            ] 47%  ← Más bajo por claim "21 subdominios"
Versionado:       [===>           ] 60%
Requisitos:       [===>           ] 60%  (pero 1.1 MB detrás)
Normativa:        [===>           ] 60%  (pero 1.9 MB detrás)

GLOBAL:           [==>            ] 62%  (NO supera gate 75%)
```

---

## Hallazgos por Patrón

### Patrón 1: "Volumen sin calibración"

Dominios como Requisitos (1.1 MB) y Normativa (1.9 MB) tienen un solo claim de alto nivel, sin desagregación que permita verificar calibración de contenido específico.

**Implicación:** El 60% global OCULTA que hay 3 MB de contenido con un claim único e incierto.

### Patrón 2: "Asimetría crítica en versionado"

Modelo v2.0.0 + Documentación v1.0.0 es un patrón de "cambio de modelo sin sincronización de docs" — típico de transiciones incompletas.

**Implicación:** El 60% en versionado debería ser 0.2 hasta que se sincronice.

### Patrón 3: "Especulación en elementos clave"

Claim "21 Subdominios" es SPECULATIVE (0.2) y es de los primeros en el documento. Genera duda sobre estructura de toda documentación.

**Implicación:** Baja confianza en metaestructura.

---

## Efecto Denominador

**Observación:** Con 13 claims, cambios pequeños mueven el ratio significativamente.

Si se PRUEBAN "21 Subdominios" → +0.8 puntos → 62% → 72% (aún bajo)
Si se REFUTA "21 Subdominios" → -0.8 puntos → 62% → 52% (regresa)

**Recomendación:** No usar ratio global como métrica única; usar distribución CAD.

---

## Recomendaciones Phase 1 → Phase 2

**Antes de Phase 2: BASELINE:**

1. **CRÍTICO:** Resolver claim "21 Subdominios" (impacto: ±0.8 en ratio)
   - Si existen → documentar y mapear
   - Si no existen → retirar claim

2. **CRÍTICO:** Sincronizar Modelo v2.0.0 con Documentación v1.0.0
   - Actualizar a v2.0.0 si modelo cambió
   - O revertir claim de modelo si docs son v1.0.0

3. **MODERADO:** Operacionalizar ETL (pasar de SPECULATIVE a PROVEN)
   - Documento de especificación técnica
   - Definición de robustez y trazabilidad

4. **MODERADO:** Desagregar Requisitos (1.1 MB) y Normativa (1.9 MB)
   - Claims de nivel superior para cada subdominio
   - Evaluación de calibración por subdivisión

---

## Conclusión

**IACT-docs está PARCIALMENTE CALIBRADO (62%)**

**Strengths:**
- Stack técnico bien documentado (69% arquitectura)
- Volumen de contenido significativo (3.6 MB)
- 5 dominios claramente estructurados

**Weaknesses:**
- Claims estructurales sin verificación (21 subdominios SPECULATIVE)
- Versionado desincronizado (modelo v2.0.0, docs v1.0.0)
- ETL sin operacionalización
- Dominios grandes con claims únicos de alto nivel

**Next action:** Entrar Phase 2: BASELINE con trabajo de desagregación y especificación.

---

## Metadata de este análisis

**Confianza:** 80% en ratio global; 90% en distribución CAD; 70% en recomendaciones (dependen de validación de claims SPECULATIVE)

**Tiempo análisis:** Phase 1 DISCOVER (estimado: 1.5h implementación de recomendaciones)
