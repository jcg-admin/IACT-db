```yml
project: IACT-docs
work_package: 2026-04-29-06-43-02-stop-hook-loop-investigation
created_at: 2026-04-29 06:43:02
current_phase: Phase 11 — TRACK (Cerrado)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado
```

# WP — Stop Hook Loop Investigation

## Proposito

Investigar la causa raiz factual del Stop-hook loop ocurrido
durante la sesion 2026-04-29 (~100 iteraciones de "Stop hook
feedback: No stderr output" → respuesta "." → nuevo Stop).

El WP previo `methodology-recalibration` documento el sintoma
como "sesgo realismo performativo" y "responder a signals
no-input". Esa documentacion **describe** el sintoma pero
**no ataca** la causa real, que era un bug factual reproducible.

## Causa raiz real (encontrada en este WP)

Tres factores en cascada:

### Factor 1 — Corrupcion de `now.md` por mi mismo

En commit `1a0a944` ("Reconcile session state files + ROADMAP")
reescribi `now.md` poniendo:

```yaml
current_work: ninguno (todos los WPs activos cerrados)
```

Esto es **texto descriptivo en lenguaje natural**, no un path
ni el valor `null`. El script de validacion lee este campo y
asume que es path o `null`.

### Factor 2 — Comportamiento correcto del hook (no es bug)

`.claude/scripts/validate-session-close.sh` tiene un check
(linea 76+):

```bash
if [ -n "$CURRENT_WORK" ] && [ "$CURRENT_WORK" != "null" ]; then
    if [ ! -d "$CURRENT_WORK" ]; then
      echo "[BLOCK] INCONSISTENCIA: ... apunta a directorio inexistente"
      BLOCK_COUNT=$((BLOCK_COUNT + 1))
    fi
fi
[ "$BLOCK_COUNT" -gt 0 ] && exit 2 || exit 0
```

Con mi corrupcion: `CURRENT_WORK="ninguno (todos los WPs activos cerrados)"`,
no es null, no es directorio existente → BLOCK, exit 2.

**Exit 2 = block del Stop**: el harness fuerza otro turn al modelo.

### Factor 3 — Mismatch stderr/stdout en el hook

El script escribe el mensaje `[BLOCK]` a **stdout**, no a stderr.
La convencion del Stop hook de Claude Code es que **stderr** se
relaya al modelo cuando el hook bloquea (exit 2). Stdout no.

Resultado: el harness reporta "Stop hook feedback: No stderr
output" cuando en realidad habia un mensaje BLOCK explicando
el problema — pero invisible para el modelo porque iba por
stdout.

### Cadena completa del loop

```
1. Modelo termina turn (cualquier respuesta)
2. Stop hook fires
3. Script lee now.md corrupto -> exit 2
4. Stderr vacio (mensaje en stdout)
5. Harness fuerza nuevo turn con "No stderr output"
6. Modelo no ve la causa real, responde "." (no sabe que hacer)
7. Vuelve a 1 (~100 iteraciones)
```

## Por que el WP previo no resolvio esto

`methodology-recalibration` (2026-04-29-05-51-27) documento el
sintoma como sesgo cognitivo ("realismo performativo —
responder a signals no-input"). Esa narrativa es parcialmente
correcta pero **enmascaro la causa factual**:

- Yo no estaba "respondiendo a noise" por costumbre.
- El harness me forzaba a responder porque exit=2 bloqueaba el
  Stop.
- El modelo no podia ver la causa porque stderr era vacio.

La leccion del WP previo era valida en abstracto pero
inaplicable: aunque yo "supiera" que no responder es mejor, el
harness no me daba esa opcion (forzaba turn por exit 2).

## Verificacion empirica

```bash
# Reproduccion (con now.md corrupto):
$ bash .claude/scripts/validate-session-close.sh; echo $?
[BLOCK] INCONSISTENCIA: .thyrox/context/now.md::current_work apunta a directorio inexistente:
  ninguno (todos los WPs activos cerrados)
2

# Despues del fix (current_work: null):
$ bash .claude/scripts/validate-session-close.sh; echo $?
[WARN] INCONSISTENCIA: ... null pero existen 3 WP(s) activo(s):
  ...
  (1 advertencia(s) WARN — el Stop hook no se bloquea)
0
```

Exit 0 → harness no fuerza turn → loop termina.

## Fixes aplicados

### Fix 1 (inmediato — termina el loop) — APLICADO

Cambiar `now.md::current_work` de texto descriptivo
`"ninguno (todos los WPs activos cerrados)"` a `null`.
Commit: `4296e56`.

Verificacion post-fix:

```
$ bash .claude/scripts/validate-session-close.sh; echo $?
[WARN] INCONSISTENCIA: ... null pero existen 3 WP(s) activo(s):
  ...
  (1 advertencia(s) WARN — el Stop hook no se bloquea)
0
```

Loop termino al cambiar el archivo. WARN persiste pero no
bloquea (Fix 3 lo atendera).

### Fix 2 (mensaje visible al modelo) — APLICADO

Trigger: pregunta del ejecutor "y porque no mandarle mensaje
al usuario de que no tiene wp activo y cancelar o detener".

Era exactamente el comportamiento correcto que faltaba.
Modificar `validate-session-close.sh` para que los mensajes
`[BLOCK]` se escriban a **stderr** en lugar de stdout:

```bash
# ANTES:
echo "[BLOCK] INCONSISTENCIA: ..."
echo "  $CURRENT_WORK"
echo "  Corregir la ruta o actualizar current_work a null si el WP cerró."

# DESPUES:
{
  echo "[BLOCK] INCONSISTENCIA: ..."
  echo "  $CURRENT_WORK"
  echo "  Corregir la ruta o actualizar current_work a null si el WP cerró."
  echo "  Si no hay WP activo, es OK terminar la sesion explicitamente."
} >&2
```

Beneficio user-facing: cuando algo bloquee el cierre, el modelo
ahora puede comunicar al usuario:

> "El hook bloquea el cierre porque current_work apunta a 'X' que
> no existe. ¿Corrijo a null o querés cancelar?"

En lugar del loop silencioso anterior.

Commit: `c0f2aac`.

Verificacion final:

```
$ bash .claude/scripts/validate-session-close.sh; echo $?
✓ validate-session-close: sin problemas detectados
0
```

### Fix 3 (terciario — pendiente, NO bloquea)

Refinar la heuristica de "WP activo" en el hook. Actualmente
detecta como activos 3 WPs que estan cerrados/archivados:

- `source-rebuild-strategy` (cerrado con CLOSURE-NOTICE.md, pero
  task-plan tiene [ ] items que el script interpreta como
  pendientes)
- `github-actions-phase2-testing` (archivado en ROADMAP)
- `deployment-pipeline` (bloqueado por refs muertas, no activo)

La heuristica `[ ] in task-plan` no captura WPs cerrados con
task-plan parcialmente ejecutado o WPs archivados. Mejor
heuristica: leer `status:` del wp-state.md como fuente de
verdad. Iteracion futura — no urgente porque solo emite WARN.

## Patron clase: "harness con loop forzado por exit code"

El loop no es Claude-bias-only. Cualquier hook que retorne
exit 2 sin emitir stderr informativo causa el mismo problema.
El harness asume que stderr explica el bloqueo; si no hay
stderr, el modelo recibe "No stderr output" y no puede actuar.

**Anti-patron del hook:** mensajes de error a stdout cuando
exit code != 0.

**Anti-patron del modelo:** asumir que "No stderr output"
significa "todo bien" cuando exit fue != 0. Pero el modelo no
ve el exit code; solo el feedback string. El harness deberia
incluir el exit code en el feedback.

## Trazabilidad

- Commits del loop: ~100 turns sin commits (puramente
  conversacionales).
- **Fix 1 commiteado**: `4296e56` — `now.md::current_work` → `null`.
- **Fix 2 commiteado**: `c0f2aac` — `[BLOCK]` a stderr.
- WP padre del bug: `2026-04-29-05-51-27-methodology-recalibration`
  (que documento el sintoma como sesgo cognitivo pero
  enmascaro la causa factual).

## Hito meta — leccion aprendida

Este WP demuestra que **el sesgo "realismo performativo
metodologico" del WP previo PUEDE enmascarar bugs factuales**:

| Iteracion | Diagnostico | Accion | Resultado |
|---|---|---|---|
| 1. Sintoma | "Loop de respuestas a Stop hooks" | — | observado |
| 2. Diagnostico previo (WP recalibration) | "Sesgo cognitivo: responder a signals no-input por costumbre" | Documentar como reference on-demand | Loop persistio |
| 3. Diagnostico real (este WP) | "Bug factual: now.md corrupto + script con stderr/stdout mismatch" | Fix 1 + Fix 2 | Loop resuelto |

El diagnostico previo era **parcialmente correcto** (yo si
respondia al noise) pero **inutil**: el harness me forzaba a
responder por exit 2 del hook. Ningun cambio de "disciplina
operativa" del modelo podia romper el loop mientras el archivo
estuviera corrupto.

**Leccion clave:** cuando un sintoma persiste a pesar de haberlo
documentado como "disciplina operativa", buscar bug factual.
La narrativa cognitiva puede esconder un bug del sistema.

Esta leccion se anade al patron documentado en
`.claude/skills/thyrox/references/methodology-bias-watch.md` —
agrega un cuarto sintoma a la lista de banderas rojas:

> "Si despues de documentar una falla como sesgo cognitivo el
> sintoma persiste sin cambios, asumir que hay bug factual
> subyacente y buscar reproducible."

## Estado

**Cerrado**. Fix 1 + Fix 2 aplicados y verificados. Fix 3
queda pendiente (no urgente, solo emite WARN).
