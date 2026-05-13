```yml
type: Reference (lazy-load on-demand)
applies_when: Bash tool con run_in_background o pollers manuales
created_at: 2026-04-29 05:51:27
status: Aprobado
version: 1.0.0
```

# Bash Background Tasks — Mecanismos de Espera

Cargar esta reference cuando se va a usar `Bash(run_in_background=true)`
o se considera escribir un loop de polling manual sobre archivos task.

## Regla principal

Un solo mecanismo de espera por task. **NUNCA combinar:**

1. `run_in_background: true` con redireccion que saca el output del
   task file (`> /tmp/file.txt`, `> /dev/null`, etc.). El task `.output`
   queda vacio; los pollers manuales no encuentran datos.

2. `run_in_background: true` + un `Bash` separado con
   `until grep ...; do sleep N; done`. El loop polea sin timeout y queda
   zombie eternamente si la condicion nunca se cumple.

## Patrones correctos

### Notification-driven (preferido)

```python
Bash(command="make html 2>&1", run_in_background=True)
# La infraestructura emite <task-notification> al terminar.
# Leer el .output entonces.
```

### Sincrono con timeout duro

```python
Bash(command="make html 2>&1", timeout=600000)  # 10 min max
```

### Polling con timeout (ultimo recurso)

```python
Bash(command="timeout 600 bash -c 'until grep -q X /tmp/file; do sleep 5; done'")
```

## Patrones prohibidos

```python
# PROHIBIDO: redireccion vacia el task .output
Bash(command="make html 2>&1 > /tmp/build.txt", run_in_background=True)
Bash(command="until grep -q succeeded /tmp/.../tasks/<id>.output; do sleep 10; done")
# task .output vacio -> poller infinito -> proceso zombie

# PROHIBIDO: sleep arbitrario sin garantia
Bash(command="make html", run_in_background=True)
Bash(command="sleep 30 && grep ...")
```

## Auditoria de zombies (cuando se sospecha)

```bash
# Ver subprocesos del shell de Claude (PID variable)
ps --ppid <claude-pid> -o pid,etime,cmd | grep -E "until|sleep"

# Si etime es mayor que la duracion esperada del job real, matar:
kill -9 <pid>
```

## Caso historico

Sesion IACT-docs 2026-04-29 (saneamiento md->rst): 36 procesos zombie
acumulados durante 3-4h por combinar `run_in_background: true` con
redireccion `> /tmp/buildN.txt` y `until grep ...; do sleep N; done` sin
timeout. La combinacion se gatillo porque la guideline "no polls" se mezclo
con "redirigir output a archivo nombrado" sin ver que ambas son
incompatibles.

Detectado tras 3 horas por `ps --ppid` manual; matados via `kill -9`.

Ver: `.thyrox/context/work/2026-04-29-05-35-11-md-to-rst-saneamiento/`.

## Por que vive en references/, no en .claude/rules/

Esta regla aplica solo cuando se usa `Bash(run_in_background=true)`,
patron presente en <5% de las sesiones. `.claude/rules/` carga siempre
(I-009) — costo permanente para problema acotado. La reference se carga
on-demand cuando el contexto lo amerite.

Decision documentada en WP
`2026-04-29-05-51-27-methodology-recalibration/plan/correction-plan.md`
(accion A1).
