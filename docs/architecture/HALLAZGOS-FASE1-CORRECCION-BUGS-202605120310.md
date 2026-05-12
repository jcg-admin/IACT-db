# Hallazgos — Ejecución FASE 1 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 1  
**Commit:** `155fcce`  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-1.1 | `utils/core.sh` L75 — separar `local` de asignación (BUG-007) | COMPLETO | H-F1-001 |
| T-1.2 | `utils/core.sh` L326 — `break` → `return 1` (BUG-001) | COMPLETO | — |
| T-1.3 | `utils/provisioning.sh` L28 — separar `export` de asignación (BUG-008) | COMPLETO | — |
| T-1.4 | `verify.sh` 27 OK sin regresión | PASA | — |

---

## H-F1-001 — `set -e` no se propaga en funciones llamadas en contexto de comando compuesto

**Detectado en:** T-1.1 durante la verificación funcional de BUG-007  
**Severidad:** INFORMATIVO — hallazgo de comportamiento de bash, no un bug nuevo  
**Estado:** DOCUMENTADO

### Descripción

Durante la verificación de la corrección de BUG-007 (`local backup=$(date ...)`),
se confirmó empíricamente un comportamiento de bash que afecta el impacto real
de SC2155 en este proyecto:

**bash no propaga `set -e` dentro de funciones cuando estas son llamadas
en el contexto de un comando compuesto** (`&&`, `||`, `if cmd`, `while cmd`,
`until cmd`).

```bash
# Verificación empírica:
set -e
f() {
    local val="$(false)"       # local enmascara — val=''
    echo "sigue: val=[$val]"   # SÍ llega aquí
}
f && echo "OK"   # f está en contexto de &&  → set -e NO actúa dentro de f

# Sin contexto compuesto:
g() {
    local val
    val="$(false)"             # set -e debería actuar aquí...
    echo "sigue: val=[$val]"
}
g && echo "OK"   # g también está en contexto de && → set -e tampoco actúa
```

### Impacto en BUG-007

`backup_file()` siempre se llama en contexto compuesto:

```bash
# En config.sh — uso real:
if ! backup_file "$config_file"; then
    log_warn "No se pudo crear backup"
fi
```

En este patrón, la diferencia de comportamiento entre la versión vieja
(`local backup=$(date ...)`) y la nueva (`local backup; backup=$(date ...)`)
es **idéntica en tiempo de ejecución** para el caso de fallo de `date`.

### Por qué la corrección sigue siendo válida

1. **SC2155 es un error de intención**, no solo de ejecución. La declaración
   `local backup="$(date ...)"` expresa que se quiere abortar si `date` falla,
   pero bash no lo garantiza. La separación expresa la intención correctamente.

2. **A nivel de script (fuera de funciones)**, `var=$(cmd_fallida)` con
   `set -e` sí termina el script. La corrección previene el bug en ese contexto.

3. **Consistencia con el proyecto.** Los demás archivos del proyecto que usan
   este patrón ya lo hacen correctamente (ej: `provisioning.sh` L20-21).

4. **shellcheck SC2155** es un error de nivel `warning` que herramientas de CI
   pueden configurar como bloqueante. La corrección lo elimina.

---

## Cambios implementados

### `utils/core.sh` — T-1.1 (BUG-007) y T-1.2 (BUG-001)

**T-1.1 L75 — separar `local` de asignación en `backup_file()`:**

```bash
# Antes:
local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"

# Después:
local backup
backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
```

**T-1.2 L326 — `break` sin loop → `return 1` en `_service_action()`:**

```bash
# Antes:
log_debug "service_action: mariadbd/mysqld no disponibles"
break

# Después:
log_debug "service_action: mariadbd/mysqld no disponibles"
return 1
```

Comportamiento de `break` confirmado empíricamente:

```
$ bash -c 'f() { case x in x) break; echo "continúa"; ;; esac; }; f'
bash: break: only meaningful in a 'for', 'while', or 'until' loop
continúa
```

El `break` emite el warning a stderr y la ejecución **continúa**.
Con `daemon=""`, el `nohup su -s /bin/bash mysql -c " --datadir=..."` lanza
un proceso en background con espacio en blanco como nombre de binario,
que falla silenciosamente.

Con `return 1`, la función `_service_action` sale limpiamente.
`start_service()` recibe el exit 1 y lo propaga correctamente al llamador.

### `utils/provisioning.sh` — T-1.3 (BUG-008)

**L28 — separar `export` de asignación en `init_env()`:**

```bash
# Antes:
export PROJECT_ROOT="$(pwd)"

# Después:
PROJECT_ROOT="$(pwd)"
export PROJECT_ROOT
```

La función `init_env()` ya usaba el patrón correcto en L20-21 para `git_root`:

```bash
local git_root
git_root=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
```

El cambio alinea el bloque `last resort` con el patrón ya establecido
en la misma función.

---

## Estado de los bugs del plan tras FASE 1

| Bug | Descripción | Estado |
|---|---|---|
| BUG-007 | `local backup=$(...)` — SC2155 en `utils/core.sh` L75 | RESUELTO — T-1.1 |
| BUG-001 | `break` sin loop en `utils/core.sh` L326 | RESUELTO — T-1.2 |
| BUG-008 | `export PROJECT_ROOT=$(pwd)` — SC2155 en `utils/provisioning.sh` L28 | RESUELTO — T-1.3 |
