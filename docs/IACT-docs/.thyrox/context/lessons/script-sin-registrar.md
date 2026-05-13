---
id: L-001
titulo: Script creado sin registrar en settings.json queda huérfano
categoria: Infraestructura
origen_wp: 2026-04-14-09-13-51-context-migration
origen_fase: FASE 35
fecha: 2026-04-14
---

## Contexto

Durante FASE 35 se expandió `validate-session-close.sh` con 3 checks nuevos
(TD-001 timestamps, agentes huérfanos, inconsistencia `current_work`).
El script existía correctamente en `.claude/scripts/`.

## Qué Pasó

Al cerrar sesión, el hook de Stop **no ejecutaba** los nuevos checks.
El script existía pero no tenía efecto. El `Stop` hook en `settings.json`
solo llamaba a `stop-hook-git-check.sh` — `validate-session-close.sh`
nunca fue registrado.

## Causa Raíz

El ciclo de trabajo fue: crear/mejorar script → asumir que estaba wired.
No hubo verificación de que el script estuviera registrado en `settings.json`
como parte del proceso de creación.

## Solución Aplicada

Agregar `validate-session-close.sh` al Stop hook en `settings.json`:

```json
"Stop": [
  {
    "hooks": [
      {"type": "command", "command": "bash .claude/scripts/validate-session-close.sh"},
      {"type": "command", "command": "bash .claude/scripts/stop-hook-git-check.sh"}
    ]
  }
]
```

## Clave del Aprendizaje

**Un script que no está registrado en `settings.json` no existe para el sistema.**
Crear un script y registrarlo son dos pasos — ambos son obligatorios.

## Aplicación Futura

Checklist al crear cualquier script de hook:
1. Crear el script en `.claude/scripts/`
2. Agregar al evento correspondiente en `settings.json`
3. Verificar con `bash script.sh` que corre correctamente
4. Confirmar en `settings.json` que el wiring es correcto

Si el script debe ejecutarse automáticamente (Stop, SessionStart, PostToolUse):
→ Probar que se dispara en el evento correcto antes de commitear.

## Referencias

- WP: `.thyrox/context/work/2026-04-14-09-13-51-context-migration/`
- Commit fix: `fix(hooks): registrar validate-session-close.sh en Stop hook`
- Patrón derivado: [validate-wire-test](../patterns/validate-wire-test.md)
