```yml
created_at: 2026-04-22 21:20:00
updated_at: 2026-04-22 21:20:00
status: Aprobado
project: IACT-docs
author: claude
version: 1.0.0
```

# Calibration Invariant: Verified Numbers Only

> Cargado automáticamente en cada sesión.
> Regla NO NEGOCIABLE sobre uso de números en comunicación.

## Regla Principal

**NUNCA dar un número sin verificar.**

Si dices una cifra (cantidad, porcentaje, líneas, archivos, tiempo, etc.), DEBE ser:
- VERIFICADO en el repo/sistema actual
- EXPLÍCITO en su origen (cómo se obtuvo)
- EXACTO, no aproximación (a menos que indiques explícitamente "aproximado")

## Protocolo

Antes de mencionar CUALQUIER número:

```
1. ¿Es verificable? → Ejecutar comando de verificación (find, wc, git log, etc.)
2. ¿Puedo explicar cómo lo sé? → Incluir método en respuesta
3. ¿Hay margen de error? → Indicarlo explícitamente si existe
```

## Ejemplos

| ❌ INCORRECTO | ✅ CORRECTO |
|---|---|
| "~100 archivos" (asumido) | "93 archivos (verificado con find \| wc -l)" |
| "Aproximadamente 15 minutos" | "Máximo 15 minutos (basado en 10 tool_uses límite claro)" |
| "Hay unos 5-10 commits" | "He encontrado 3 commits relacionados (git log --grep, listados)" |

## Severidad

**CRÍTICA** — Un número sin verificar corrompe:
- Decisiones de scope/tiempo del usuario
- Confianza en cifras posteriores (incluso correctas)
- Estimaciones en cascada
- Reproducibilidad

## Aplicación

Aplica a:
- Cantidad de archivos/directorios
- Líneas de código
- Commits/git history
- Estimaciones de tiempo basadas en conteos
- Porcentajes, ratios, proporciones
- Cualquier métrica dada como "número real"

## Excepción

OK dar número sin verificación SOLO si:
1. Es explícitamente conjetura: "Si hubiera 100 archivos (hipotético)..."
2. Es basado en info del usuario: "Dijiste que son 5 archivos"
3. Es rango documentado: "GitHub Actions free tier = 2000 minutos/mes (según docs oficiales)"

