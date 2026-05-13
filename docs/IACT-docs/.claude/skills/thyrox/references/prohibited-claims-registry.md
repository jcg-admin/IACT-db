# Prohibited Claims Registry — THYROX

> Claims y valores con contradicción interna demostrada. No usar como fundamento en artefactos.
> Fuente: ÉPICA 42 (análisis adversarial Cap.1-20, Part A/B/C).

## Valores numéricos prohibidos

| Valor | Contexto de origen | Por qué prohibido | Alternativa válida |
|-------|-------------------|-------------------|-------------------|
| ᾱ ≈ 0.83 | Basin-Hallucination framework Sec 2.5.5 | Derivado de tabla con contradicción interna; parámetro de ajuste circular | No usar — sin derivación empírica verificable |
| db_t/dt ≈ 0.02 | Basin framework | Sin unidades definidas, sin protocolo de medición | No usar |
| t_conv ≈ 45 | Basin framework | Sin protocolo de medición citado | No usar |
| P(u_0) ≈ 0.95 | Basin framework | Derivado circular | No usar |
| Thm 2.5.1 como "teorema" | Basin framework | Proposición sin demostración formal | Citar como "proposición" con condiciones explícitas |

## Fórmulas prohibidas

| Fórmula | Por qué prohibida | Alternativa |
|---------|------------------|-------------|
| `P₀ × e^(-r×d)` | Decay sin calibración empírica propia del dominio | Estimación explícita marcada como hipótesis |
| `P(correct) = P₀ × e^(-Σλᵢxᵢ)` (5+ params) | Ratio de calibración 8%, calibración circular | Idem |

## Claims cualitativos prohibidos como absolutos

| Claim | Forma prohibida | Condición requerida para ser válido |
|-------|----------------|-------------------------------------|
| "hallucination is inevitable" | Sin condición explícita | "hallucination ocurre bajo condición X cuando Y" |
| "deterministic given architecture" | Sin evidencia experimental | Demostración empírica con condiciones |
| "independent of training weights" | Para claims sobre hallucination | No establecido sin estudio controlado |

## Patrón: Evasión de definición

**Señal de detección:** una variable tiene valor numérico en sección de resultados pero no tiene definición operacional (protocolo de medición) en la sección de definiciones del mismo documento.

**Evaluación:** el valor es UNDEFINED, no INFERRED. No puede usarse como evidencia.

**Corrección requerida:** definir el protocolo de medición, o eliminar el valor.

**Checklist de Capa 2 para agente deep-dive:** para el elemento con valor numérico: verificar que existe definición operacional en la sección de definiciones del documento.
