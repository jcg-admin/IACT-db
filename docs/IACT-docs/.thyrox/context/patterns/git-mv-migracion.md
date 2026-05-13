---
id: P-003
nombre: git mv para Migraciones de Archivos
problema: Mover archivos con mv/cp destruye el historial de git — los archivos aparecen como deleted + created
categoria: Git
origen: FASE 35
fecha: 2026-04-14
---

## Problema

Al reorganizar archivos del proyecto (migraciones de directorios, renombrados),
usar `mv` o `cp + rm` hace que git trate el archivo como:
- Eliminado en la ruta antigua
- Nuevo en la ruta nueva

El historial de commits del archivo se pierde visualmente. Para WPs históricos
(`.thyrox/context/work/`) esto significa perder años de historial de decisiones.

## Solución (el Patrón)

**Usar `git mv` en lugar de `mv` para mover archivos dentro del repositorio.**
Git detecta el rename y preserva el historial completo en la nueva ruta.

```bash
# ❌ MAL — historial se pierde
mv .claude/context/work/2026-03-27-* .thyrox/context/work/

# ✓ BIEN — historial se preserva
git mv .claude/context/work/2026-03-27-mi-wp .thyrox/context/work/2026-03-27-mi-wp
```

## Implementación

### Migración de directorio completo (loop)

```bash
# Mover todos los subdirectorios, evitando colisiones
for wp in .claude/context/work/*/; do
  wpname=$(basename "$wp")
  if [ ! -d ".thyrox/context/work/$wpname" ]; then
    git mv ".claude/context/work/$wpname" ".thyrox/context/work/$wpname"
  else
    echo "COLISIÓN — $wpname ya existe en destino, saltar"
  fi
done
```

### Pre-flight: verificar colisiones antes de ejecutar

```bash
# Listar WPs que colisionarían
comm -12 \
  <(ls .claude/context/work/ | sort) \
  <(ls .thyrox/context/work/ | sort)
# Si output vacío → no hay colisiones → seguro ejecutar
```

### Verificar que git detectó rename (no delete+create)

```bash
git status | grep -E "renamed:|R "
# Debe mostrar: renamed: .claude/... -> .thyrox/...
# Si muestra deleted + new file → git mv no funcionó correctamente
```

## Cuándo Aplicar

- Cualquier reorganización de archivos dentro del mismo repositorio
- Migraciones de directorios (como `.claude/context/` → `.thyrox/context/`)
- Renombrado de archivos que tienen historial valioso
- Movimiento de WPs históricos

## Cuándo NO Aplicar

- Archivos nuevos sin historial (usar `mkdir + Write`)
- Movimiento entre repositorios diferentes (el historial no viaja entre repos)
- Archivos temporales o generados (sin valor de historial)

## Nota sobre `git rm -r`

Después de `git mv` en batch, el directorio origen puede quedar vacío.
`git rm -r dir/` fallará si git ya procesó los archivos como renamed.
Usar `rmdir dir/` para limpiar el directorio vacío del filesystem.

```bash
# Verificar que el directorio quedó vacío
find .claude/context -type f | wc -l  # debe ser 0

# Limpiar directorios vacíos (NO git rm — ya está procesado)
find .claude/context -type d -empty -delete
```

## Referencias

- Lección origen: FASE 35 context-migration
- WP: `.thyrox/context/work/2026-04-14-09-13-51-context-migration/`
- Locked Decision #3: "Git as persistence" (CLAUDE.md)
