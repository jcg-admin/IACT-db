# Evidence Classification — Vocabulario Epistémico THYROX

> Referencia de clasificación para la sección "Evidencia de respaldo" de artefactos WP.
> Fuente: ÉPICA 42 methodology-calibration.

## Esquema de 3 niveles

### PROVEN (Observable)
Producido por herramienta ejecutada (Bash, Read, Grep, Glob) en este WP, con output citado textualmente.
No requiere interpretación del agente.

**Ejemplo:**
```
Claim: "El archivo validate-session-close.sh existe"
Fuente: Bash `ls .claude/scripts/` → output incluye el archivo
Tipo: PROVEN
```

**Criterio:** ¿Hay un tool_use con output que directamente sustenta el claim? → PROVEN

### INFERRED (Inferido)
Derivado de uno o más observables mediante razonamiento explícito del agente.
Requiere que los observables de origen estén documentados.

**Ejemplo:**
```
Claim: "El mecanismo @imports funciona con rutas fuera de .claude/"
Fuente: PROVEN (archivo memory-hierarchy.md L47-63) + razonamiento explícito sobre restricciones
Tipo: INFERRED
```

**Criterio:** ¿Hay observables documentados + razonamiento explícito que conecta los observables al claim? → INFERRED

### SPECULATIVE (Especulativo)
Sin observable de origen. Afirmación del agente sin respaldo en tool output o referencia citada.

**Ejemplo:**
```
Claim: "El sistema probablemente tiene bugs en los hooks"
Fuente: ninguna
Tipo: SPECULATIVE
```

**Criterio de gate:** SPECULATIVE no puede avanzar gate Stage→Stage. Debe convertirse en INFERRED u OBSERVABLE antes del gate.

## Reglas de uso en artefactos WP

| Columna "Tipo" | Valor correcto | Gate-bloqueante si ausente |
|----------------|---------------|---------------------------|
| PROVEN | Solo si hay tool output citado | No (permite avanzar) |
| INFERRED | Solo si hay observables + razonamiento | No (permite avanzar) |
| SPECULATIVE | Por defecto si no hay fuente | Sí (bloquea gate) |

## Cherry-Pick Consciente — Algoritmo de iteración calibrada

Cuando se emite una versión N+1 de un artefacto:

1. **Score por claim/dominio de versión N** — calcular ratio PROVEN+INFERRED / total
2. **Break-even ratio** — score esperado de claims nuevos ≥ ratio_vN (no degradar)
3. **Claims ≥ 0.80 de confianza:** preservar exactamente
4. **Claims nuevos sin fuente identificable:** posponer o eliminar
5. **Anti-patrón Cherry-Pick:** seleccionar solo casos que confirman hipótesis → requiere declarar denominador

Ver también: `discover/patterns/named-mechanism-vs-implementation.md`
