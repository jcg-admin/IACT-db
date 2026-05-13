```yml
type: Reference
title: Tool Patterns — Herramienta Correcta por Tarea
category: Claude Code Platform — Herramientas
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Herramienta correcta por tarea, parallel calls y Edit vs Write
```

# Tool Patterns — Herramienta Correcta por Tarea

Guía de cuándo usar cada herramienta de Claude Code, cómo maximizar eficiencia con llamadas paralelas, y anti-patrones frecuentes.

Para el modelo de permisos y flujos de aprobación, ver [tool-execution-model.md](tool-execution-model.md).

---

## La herramienta correcta por tarea

| Tarea | Herramienta correcta | Herramienta incorrecta | Por qué |
|-------|---------------------|----------------------|---------|
| Leer un archivo | `Read` | `Bash(cat)` / `Bash(head)` / `Bash(tail)` | Read tiene paginación, limit, offset y soporte multimodal |
| Buscar contenido en archivos | `Grep` | `Bash(grep)` / `Bash(rg)` | Grep tiene output_mode, context lines, regex completo |
| Buscar archivos por nombre | `Glob` | `Bash(find)` / `Bash(ls)` | Glob retorna paths ordenados por mtime |
| Editar un archivo existente | `Edit` | `Bash(sed)` / `Bash(awk)` | Edit es atómico, muestra diff al usuario |
| Crear un archivo nuevo | `Write` | `Bash(echo > file)` / heredoc | Write es explícito, auditable, soporta revisión |
| Operaciones de sistema | `Bash` | N/A — Bash es la herramienta para esto | No hay alternativa dedicada para git, npm, etc. |

**Regla:** Usar herramientas dedicadas siempre que existan. `Bash` es para operaciones del sistema que no tienen herramienta dedicada.

---

## Edit vs Write — cuándo usar cada uno

### Edit — modificar archivo existente

```
Edit(
  file_path="/path/to/file.md",
  old_string="texto a reemplazar",
  new_string="texto nuevo"
)
```

**Cuándo:**
- El archivo ya existe y se quiere cambiar una parte específica
- Cambios quirúrgicos (una función, un bloque, un valor)
- Requiere leer el archivo primero (obligatorio)

**`replace_all: true`** — renombrar/reemplazar en todo el archivo:
```
Edit(file_path="...", old_string="oldName", new_string="newName", replace_all=true)
```

### Write — crear o reescribir completamente

```
Write(
  file_path="/path/to/new-file.md",
  content="contenido completo..."
)
```

**Cuándo:**
- Crear un archivo que no existe
- Reescritura completa del archivo (cuando cambiar es mayor que mantener)
- Si el archivo existe: leer primero (obligatorio), luego Write solo para reescritura total

**Preferir Edit sobre Write** para archivos existentes — Edit solo manda el diff, Write manda el archivo completo.

---

## Parallel tool calls — independientes vs dependientes

### Independientes → paralelo (en un mismo mensaje)

Cuando las herramientas no dependen unas de otras, lanzarlas en paralelo:

```
# Bien — leer 3 archivos en paralelo
Read("file-a.md") + Read("file-b.md") + Grep("pattern", "src/")

# Bien — buscar mientras se lee
Glob("*.ts") + Grep("useState", "src/")
```

**Casos comunes de paralelismo:**
- Leer múltiples archivos de referencia al inicio de una tarea
- Buscar patrones en diferentes directorios
- `git status` + `git log` + `git diff` (todos independientes)

### Dependientes → secuencial

Cuando el output de A es input de B:

```
# Correcto — secuencial
1. Read("config.json")          → obtiene contenido actual
2. Edit("config.json", old, new) → usa contenido del paso 1

# Incorrecto — paralelo daría resultado incorrecto
Read("config.json") + Edit("config.json", old, new)  # ❌ Edit no sabe qué hay en el archivo
```

**Regla:** Si B necesita el resultado de A, deben ser secuenciales.

---

## Bash tool — cuándo es necesario

`Bash` es para operaciones del sistema que no tienen herramienta dedicada:

```bash
# Bien — operaciones git
Bash("git add . && git commit -m 'feat: ...'")
Bash("git status")
Bash("git log --oneline -5")

# Bien — comandos de sistema
Bash("npm install")
Bash("python script.py")
Bash("date '+%Y-%m-%d %H:%M:%S'")
Bash("mkdir -p context/work/nuevo-wp/")

# MAL — hay herramienta dedicada
Bash("cat file.md")        # → Read("file.md")
Bash("grep -r 'pattern'")  # → Grep("pattern")
Bash("find . -name '*.ts'") # → Glob("**/*.ts")
```

**Comandos paralelos en Bash:**
```bash
# Para comandos independientes — usar llamadas Bash separadas en paralelo
Bash("git status") + Bash("git log --oneline -3")  # ✅ paralelo

# Para comandos secuenciales dependientes — usar && en una llamada
Bash("git add -A && git commit -m '...'")  # secuencial forzado
```

---

## Tool restrictions en agentes

### `tools:` en frontmatter — restricción física

El campo `tools:` restringe qué herramientas puede usar el agente. Cualquier herramienta no listada es invisible para el agente:

```yaml
---
name: read-only-agent
tools: Read, Grep, Glob
# No puede Write, Edit, Bash, Agent
---
```

**Cuándo usar restricción física:**
- Agentes de análisis/auditoría que solo deben leer
- Agentes de reportes
- Principio de mínimo privilegio

### `disallowedTools` CLI — restricción dinámica

```bash
claude -p "Analiza el código" --disallowedTools Write,Edit,Bash
```

**Diferencia:** `tools:` en frontmatter es permanente en el agente. `--disallowedTools` en CLI es por invocación.

---

## Error handling

### Cuando Read falla (archivo no existe)

```
Read → "No such file or directory"
```
**Patrón:** Verificar con Glob primero si el archivo puede no existir:
```
Glob("*.config.json") → si resultado vacío → crear con Write
                       → si hay archivos → Read el primero
```

### Cuando Edit falla (old_string no único)

```
Edit → "Error: old_string is not unique in the file"
```
**Patrón:** Ampliar `old_string` con más contexto circundante para hacerlo único.

### Cuando Bash falla

```
Bash → exit code ≠ 0
```
**Patrón:** Investigar la causa antes de reintentar. No reintentar el mismo comando sin cambios.

---

## Anti-patrones

### ❌ Bash para leer archivos

```bash
Bash("cat .claude/CLAUDE.md")   # MAL
Read(".claude/CLAUDE.md")       # BIEN
```

### ❌ Bash para buscar

```bash
Bash("grep -r 'useState' src/")    # MAL
Grep("useState", path="src/")      # BIEN
```

### ❌ Sleep loops para esperar

```bash
# MAL
Bash("sleep 5 && check_status.sh")
```
**Correcto:** Usar `run_in_background` y esperar notificación de completado.

### ❌ Múltiples Edits al mismo archivo

```
Edit(archivo, cambio_1) → Edit(archivo, cambio_2)  # MAL
```
**Correcto:** Un solo Edit con todos los cambios, o leer + Write completo.

### ❌ Write sin leer antes (en archivo existente)

```
Write("existing-file.md", nuevo_contenido)  # MAL — sobreescribe sin saber qué había
```
**Correcto:** `Read` primero, luego decidir si `Edit` o `Write`.
