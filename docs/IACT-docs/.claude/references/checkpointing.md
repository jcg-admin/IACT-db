```yml
type: Reference
title: Checkpointing — Rewind y gestion de estado de sesion
category: Cross-phase
version: 1.0
created_at: 2026-04-09 19:30:00
updated_at: 2026-04-09 19:30:00
owner: thyrox (cross-phase)
purpose: Entender el mecanismo de checkpointing de Claude Code y sus limitaciones criticas. Especialmente relevante al disenar hooks que modifican archivos via bash, ya que esos cambios NO son revertibles via /rewind.
source: https://code.claude.com/docs/checkpointing
```

# Checkpointing — Rewind y gestion de estado de sesion

Claude Code captura automaticamente el estado de los archivos antes de cada edicion.
Esto permite deshacer cambios y volver a estados anteriores sin usar git.

---

## Como funciona

- Cada prompt del usuario crea un nuevo checkpoint
- Los checkpoints persisten entre sesiones (accesibles en sesiones reanudadas)
- Se limpian automaticamente junto con las sesiones despues de 30 dias

### Acceso al rewind

Presionar `Esc` dos veces o usar el comando `/rewind`. Se abre un menu con la lista
de prompts de la sesion. Seleccionar el punto de retorno y elegir una accion:

| Accion | Efecto en codigo | Efecto en conversacion |
|--------|-----------------|----------------------|
| Restore code and conversation | Revertido al punto | Revertida al punto |
| Restore conversation | Sin cambio | Revertida al punto |
| Restore code | Revertido al punto | Sin cambio |
| Summarize from here | Sin cambio | Comprimida desde ese punto |

Despues de restore, el prompt original del mensaje seleccionado vuelve al input
para poder reenviarlo o editarlo.

---

## Diferencia entre restore y summarize

**Restore** revierte estado (codigo, conversacion, o ambos).

**Summarize from here** es diferente:
- Los mensajes anteriores al seleccionado quedan intactos
- El mensaje seleccionado y todos los siguientes se reemplazan con un resumen compacto
- Los archivos en disco NO cambian
- Los mensajes originales se preservan en el transcript, Claude puede referenciarlos
- Similar a `/compact` pero localizado: comprime desde el medio hacia adelante

---

## Limitacion critica — Lo que NO captura checkpointing

### Bash commands no son tracked

Los archivos modificados por comandos bash NO son revertibles via /rewind:

```bash
# Estos cambios NO se pueden deshacer con /rewind:
rm file.txt
mv old.txt new.txt
cp source.txt dest.txt
sed -i "s/foo/bar/" file.txt
echo "content" >> file.txt
```

Solo las ediciones hechas con las herramientas de archivos de Claude (Edit, Write) son
capturadas por checkpointing.

### Implicacion para hooks que usan bash scripts

Los hooks `PostToolUse`, `SessionStart`, etc. que ejecutan scripts bash y modifican
archivos NO seran revertibles.

Ejemplo del impacto en thyrox:
- `sync-wp-state.sh` modifica `now.md` via `sed -i` → no revertible via /rewind
- `mkdir` para crear directorios WP → no revertible via /rewind
- Si el usuario hace /rewind a "antes de crear el WP", los archivos WP escritos con
  Write tool si se revierten, pero `now.md::current_work` no → inconsistencia

**Como manejar la inconsistencia:**

La inconsistencia es auto-corregida: el PostToolUse hook re-sincroniza `now.md` en
la siguiente Write operation al WP. Si el usuario hace /rewind y luego continua
trabajando, el primer Write al WP correcto actualiza `now.md`.

Si el usuario hace /rewind completo (antes de crear el WP) y el WP ya no existe:
- Verificar `now.md::current_work` vs `ls context/work/`
- Si no coinciden, actualizar `now.md` manualmente o reiniciar desde Phase 1

### Cambios externos no son tracked

Cambios manuales a archivos fuera de Claude Code y ediciones de otras sesiones
concurrentes normalmente no se capturan.

---

## Checkpointing vs Git

| Aspecto | Checkpointing | Git |
|---------|--------------|-----|
| Alcance | Sesion actual | Historia permanente |
| Granularidad | Por prompt | Por commit |
| Colaboracion | Local | Compartido |
| Reversion | Quick undo | Branches, cherry-pick |
| Bash changes | No captura | Si captura (si se commitea) |
| Uso en thyrox | Quick recovery en sesion | Persistencia real del proyecto |

El sistema THYROX usa Git como mecanismo de persistencia (Locked Decision #3).
El checkpointing complementa pero no reemplaza los commits convencionales.

---

## Impacto en el diseno de hooks reactivos (PostToolUse)

Al disenar hooks que sincronizan estado:

| Operacion | Revertible via /rewind |
|-----------|------------------------|
| Claude usa Edit/Write tool directamente | Si |
| Hook bash script usa sed/echo/cp | No |
| Hook bash script usa mkdir | No |
| Hook bash script llama git | No (pero git history preserva) |

**Recomendacion de diseno:**

Para archivos de estado criticos (`now.md`, `focus.md`) que deben ser coherentes
despues de un /rewind, considerar si la inconsistencia post-rewind es acceptable:

- Si el archivo es "session state" (now.md, focus.md): la inconsistencia es temporal
  y auto-corregible. Aceptable usar bash hooks.
- Si el archivo es codigo o configuracion critica: preferir que Claude lo edite con
  Edit tool (checkpointable) en lugar de un bash script de hook.

---

## Summarize vs /compact

| | /compact | Summarize from here |
|-|---------|-------------------|
| Scope | Toda la conversacion | Desde el punto seleccionado hacia adelante |
| Contexto inicial | Se comprime | Se preserva intacto |
| Codigo en disco | Sin cambio | Sin cambio |
| Uso | Liberar contexto total | Comprimir solo la parte verbose |

`Summarize from here` es util en sesiones largas donde los primeros intercambios
(instrucciones, analisis inicial) deben preservarse en detalle pero la parte de
depuracion o iteracion puede comprimirse.

---

## Ver tambien

- [hooks](hooks.md) — Hooks de Claude Code y su interaccion con checkpointing
- [state-management](state-management.md) — Cuando actualizar now.md, focus.md
- [permission-model](permission-model.md) — Plano A y B de permisos
