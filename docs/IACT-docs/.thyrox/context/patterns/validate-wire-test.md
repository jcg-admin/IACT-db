---
id: P-001
nombre: Validate-Wire-Test
problema: Script/componente creado pero no conectado al sistema — existe sin efecto
categoria: Infraestructura
origen: FASE 35
fecha: 2026-04-14
---

## Problema

Se crea un script, hook o componente. Se asume que está operativo.
Pero falta el paso de registrarlo en el sistema (settings.json, CLAUDE.md,
import, etc.). El componente existe en disco pero no tiene efecto.

Ejemplo real: `validate-session-close.sh` creado y mejorado durante múltiples
sesiones, pero nunca registrado en el Stop hook de `settings.json`.

## Solución (el Patrón)

Todo nuevo componente pasa por tres fases antes de considerarse completo:

```
1. VALIDATE  → el componente funciona en aislamiento
2. WIRE      → el componente está registrado en el sistema
3. TEST      → el componente se dispara en el contexto real
```

## Implementación

Para hooks en `.claude/scripts/`:

```bash
# 1. VALIDATE — probar el script directamente
bash .claude/scripts/mi-nuevo-hook.sh
# Verificar que produce el output esperado y exit 0

# 2. WIRE — registrar en settings.json
# Editar settings.json → agregar al evento correspondiente:
# "Stop": [{"hooks": [{"type": "command", "command": "bash .claude/scripts/mi-nuevo-hook.sh"}]}]

# 3. TEST — verificar que el sistema lo dispara
# Para Stop: cerrar sesión y observar output
# Para PreToolUse: invocar la herramienta correspondiente
# Para PostToolUse: ejecutar la acción que dispara el hook
```

Para permisos en `settings.json`:

```bash
# 1. VALIDATE — intentar la operación manualmente
Bash(git mv archivo destino)

# 2. WIRE — agregar la regla en settings.json
"allow": ["Bash(git mv *)"]

# 3. TEST — verificar que la regla permite la operación sin prompt
```

## Cuándo Aplicar

- Al crear cualquier script que debe ejecutarse automáticamente (hooks)
- Al agregar reglas de permisos en `settings.json`
- Al registrar nuevos comandos slash en `.claude/commands/`
- Al crear agentes en `.claude/agents/`

## Cuándo NO Aplicar

- Scripts utilitarios que se invocan manualmente (no necesitan "wire")
- Archivos de documentación o referencia

## Referencias

- Lección origen: [script-sin-registrar](../lessons/script-sin-registrar.md)
- Commit: `fix(hooks): registrar validate-session-close.sh en Stop hook`
