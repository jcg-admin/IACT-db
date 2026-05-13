---
description: Analiza el transcript de la sesión actual y propone entradas para `permissions.allow` en `.claude/settings.json`, reduciendo los prompts de confirmación de herramientas de solo lectura.
allowed-tools: Bash Read Edit
---

# /permisos-sugeridos

Escanea el transcript de la sesión para identificar llamadas a herramientas frecuentes
que no requieren supervisión y propone agregarlas al listado de permisos automáticos
en `.claude/settings.json`.

Equivalente al skill nativo `/less-permission-prompts` de Claude Code.

---

## Instrucciones

### 1. Obtener la ruta del transcript

```bash
# El transcript_path llega via stdin en hooks, pero en sesión interactiva:
ls ~/.claude/projects/ | head -5
```

Identificar el proyecto activo por directorio de trabajo.

### 2. Escanear el transcript en busca de comandos de solo lectura

Leer el archivo JSONL del transcript y extraer todas las llamadas a herramienta `Bash`:

```bash
# Extraer todos los comandos Bash ejecutados en la sesión
grep '"tool_name":"Bash"' "$TRANSCRIPT_PATH" | \
  jq -r '.tool_input.command // empty' | \
  sort | uniq -c | sort -rn
```

### 3. Clasificar por tipo de herramienta

**Comandos Bash de solo lectura — candidatos a `allow` automático:**

| Patrón | Entrada sugerida en settings.json |
|--------|----------------------------------|
| `git status` | `"Bash(git status)"` |
| `git log *` | `"Bash(git log *)"` |
| `git diff *` | `"Bash(git diff *)"` |
| `git branch *` | `"Bash(git branch *)"` |
| `git fetch *` | `"Bash(git fetch *)"` |
| `ls *` | Ya no requiere permiso desde v2.1.111 |
| `echo *` | Ya no requiere permiso desde v2.1.111 |
| `date *` | `"Bash(date *)"` |
| `cat *.md` | `"Bash(cat *.md)"` |
| `wc -l *` | `"Bash(wc *)"` |
| `find . -name *` | Ya no requiere permiso desde v2.1.111 |
| `grep * *` | `"Bash(grep *)"` |
| `python3 --version` | `"Bash(python3 *)"` si solo para consultas |
| `node --version` | `"Bash(node *)"` si solo para consultas |

**Herramientas MCP frecuentes — candidatos a `allow` automático:**

Si se detectan llamadas repetidas a herramientas MCP de solo lectura
(ej: `mcp__github__list_issues`), agregar: `"mcp__github__list_issues(*)"`

### 4. Generar la propuesta

Leer el `.claude/settings.json` actual:

```bash
cat .claude/settings.json | python3 -c "
import sys, json
d = json.load(sys.stdin)
current = d.get('permissions', {}).get('allow', [])
print('Entradas actuales en allow:')
for e in current:
    print(f'  {e}')
"
```

Presentar al usuario:
1. Las entradas actualmente en `permissions.allow`
2. Los comandos detectados en el transcript que aún no tienen permiso automático
3. Las entradas sugeridas agrupadas por prioridad (alta = muy frecuente, media = ocasional)
4. Las entradas que ya son redundantes desde v2.1.111 (candidatas a eliminar)

### 5. Aplicar los cambios aprobados

Solo agregar las entradas que el usuario aprueba explícitamente.
Actualizar `permissions.allow` en `.claude/settings.json` con las entradas nuevas.

Verificar que no hay duplicados antes de agregar.

---

## Nota sobre la versión 2.1.111

Desde la versión 2.1.111 de Claude Code, los siguientes comandos ya **no generan
prompt de confirmación** y por lo tanto no necesitan entrada en `permissions.allow`:

- Comandos Bash de solo lectura con patrones glob: `ls *.ts`, `find . -name "*.md"`
- Comandos que empiezan con `cd <directorio-del-proyecto> &&`

Si el proyecto tiene estas entradas en `permissions.allow`, se pueden eliminar
para limpiar la configuración sin perder funcionalidad.
