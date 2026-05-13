---
name: Loop THYROX
description: Ejecución continua de Phase 10 EXECUTE — continúa automáticamente el work package activo sin intervención. Usar con /loop para auto-avanzar tareas T-NNN. STOP automático ante gates humanos.
---

# /thyrox:loop — Ejecución continua THYROX

Ejecuta la siguiente tarea pendiente del work package activo. Diseñado para usarse con `/loop`:

```
/loop 10m /thyrox:loop
```

---

## Instrucciones de ejecución

### 1. Verificar contexto

Leer `.thyrox/context/now.md`:
- Si `phase` ≠ `Phase 10` → STOP: reportar "Loop detenido: fase activa es `{phase}`, no Phase 10. Usar `/thyrox:execute` para avanzar manualmente."
- Si `current_work` es vacío o `null` → STOP: reportar "Loop detenido: sin WP activo. Usar `/thyrox:discover` para iniciar."

### 2. Encontrar la siguiente tarea

Leer `{current_work}/*-task-plan.md` (o `plan-execution/*-task-plan.md` si existe):
- Encontrar la primera línea con `- [ ] [T-`
- Si no hay tareas pendientes (`- [ ]`) → STOP: reportar "Phase 10 completa — todas las tareas `[x]`. Usar `/thyrox:track` para Phase 11."
- Si la próxima tarea tiene `[GATE]` en su descripción → STOP: reportar "Gate humano detectado en `{T-NNN}`. Revisar y aprobar manualmente antes de continuar el loop."

### 3. Ejecutar la tarea

1. Leer la descripción de la tarea y el SPEC referenciado
2. Verificar que las dependencias anteriores estén `[x]`
3. Implementar el cambio (respetar tech skills activos)
4. Si falla → crear `context/errors/ERR-descripcion.md` y STOP: reportar el error

### 4. Commit y actualizar

1. Commit: `type(scope): T-NNN — descripción`
2. Actualizar checkbox en `*-task-plan.md`: `- [ ]` → `- [x]`
3. Actualizar `now.md::updated_at` al timestamp actual

### 5. Reportar

Reportar en una línea: `[T-NNN] ✓ {descripción} — {N} tareas restantes`

Si quedan tareas → el loop continuará en el próximo ciclo.
Si no quedan tareas → reportar compleción y proponer `/thyrox:track`.

---

## Reglas de STOP

El loop se detiene automáticamente cuando:

| Condición | Mensaje |
|-----------|---------|
| `phase` ≠ `Phase 10` | "Fase `{phase}` no es ejecutable con loop" |
| Sin WP activo | "Sin WP activo" |
| Tarea con `[GATE]` | "Gate humano en `{T-NNN}`" |
| Error en implementación | "ERR: `{descripción del error}`" |
| Todas las tareas `[x]` | "Phase 10 completa" |
| Tarea `irreversible` | "Tarea irreversible requiere aprobación manual" |

> Ausencia de respuesta ≠ aprobación. Si el usuario no responde, esperar — no auto-continuar.

---

## Uso recomendado

```bash
# Auto-continuar Phase 10 cada 10 minutos
/loop 10m /thyrox:loop

# Para WPs grandes con muchas tareas
/loop 5m /thyrox:loop

# Para sesiones nocturnas (ejecutar cada 30 min)
/loop 30m /thyrox:loop
```

> Requiere que el task-plan no tenga gates humanos en las tareas pendientes.
> Para WPs con gates obligatorios, usar solo para el batch de tareas entre gates.

Ver [scheduling](../skills/workflow-implement/references/scheduling.md) para patrones avanzados.
