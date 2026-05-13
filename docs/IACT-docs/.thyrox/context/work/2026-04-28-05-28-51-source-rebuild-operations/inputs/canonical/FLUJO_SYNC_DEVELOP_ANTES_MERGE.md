---
title: Flujo de Sincronizacion con Develop Antes de Merge
date: 2025-11-13
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
branch_target: develop
type: procedimiento
status: active
---

# Flujo: Sincronizar con Develop Antes de Merge

**Objetivo**: Verificar cambios en `develop` y sincronizar antes de hacer merge de nuestros cambios

**Branch Actual**: `claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R`
**Branch Target**: `develop`
**Fecha**: 2025-11-13

---

## Problema que Resuelve

Cuando trabajas en una feature branch por tiempo prolongado, `develop` puede haber avanzado con:
- Nuevos commits de otros desarrolladores
- Cambios en archivos que tu tambien modificaste
- Nuevas features que pueden conflictuar

**Sin sincronizar primero**:
- Alto riesgo de conflictos en merge
- Pueden perderse cambios de develop
- Dificil resolver conflictos complejos

**Sincronizando primero**:
- Detectas conflictos temprano
- Resuelves en tu branch (controlado)
- Merge final es limpio y rapido

---

## PASO 1: Verificar Estado de Develop

### 1.1 Hacer Fetch de Cambios Remotos

```bash
# Traer TODOS los cambios del remoto (sin merge)
git fetch origin develop

# Verificar que fetch fue exitoso
git log origin/develop --oneline -5
```

**Output esperado**:
```
21d2860 feat: add agents github
bebbc9e bug: problem with actions
6821397 Merge pull request #176 from ...
...
```

### 1.2 Comparar tu Branch con Develop

```bash
# Ver cuantos commits tiene develop que tu no tienes
git log HEAD..origin/develop --oneline | wc -l

# Ver commits nuevos en develop
git log HEAD..origin/develop --oneline

# Ver estadisticas de cambios
git diff --stat HEAD origin/develop
```

**Ejemplo output**:
```
# 150 commits nuevos en develop
# 316 archivos cambiados
# +65,546 lineas agregadas
```

### 1.3 Identificar si tu Branch Ya Fue Mergeada

```bash
# Buscar referencias a tu branch en develop
git log origin/develop --grep="$(git rev-parse --abbrev-ref HEAD)" --oneline

# Buscar merges de tu branch
git log origin/develop --all --grep="analyze-scripts-output" --oneline
```

**Si encuentra commits**: Parte o todo de tu trabajo ya esta en develop
**Si no encuentra nada**: Tu branch es completamente nueva para develop

---

## PASO 2: Analizar Cambios en Develop

### 2.1 Ver Cambios Recientes (Ultimos 10 Commits)

```bash
# Ver ultimos 10 commits con estadisticas
git log origin/develop --oneline --stat -10 > develop_recent_changes.txt

# Ver resumen
cat develop_recent_changes.txt | head -50
```

### 2.2 Detectar Archivos que Cambiaron en Develop Y en tu Branch

```bash
# Script de deteccion de conflictos potenciales
cat > check_overlap.sh << 'EOF'
#!/bin/bash

echo "=== Detectando archivos modificados en ambos lados ==="

# Archivos modificados en TU branch vs develop
echo "[1] Tus cambios vs develop:"
git diff --name-only origin/develop...HEAD | sort > my_files.txt
echo "Total: $(wc -l < my_files.txt) archivos"

# Archivos modificados en DEVELOP (ultimos 20 commits)
echo -e "\n[2] Cambios en develop (ultimos 20 commits):"
git diff --name-only origin/develop~20 origin/develop | sort > develop_files.txt
echo "Total: $(wc -l < develop_files.txt) archivos"

# Archivos COMUNES (riesgo de conflicto)
echo -e "\n[3] Archivos modificados en AMBOS (RIESGO ALTO):"
comm -12 my_files.txt develop_files.txt | tee conflict_risk.txt
echo "Total: $(wc -l < conflict_risk.txt) archivos"

# Limpiar archivos temporales
rm -f my_files.txt develop_files.txt

if [ -s conflict_risk.txt ]; then
    echo -e "\n[ADVERTENCIA] Conflictos potenciales detectados!"
    echo "Revisar estos archivos durante merge/rebase"
else
    echo -e "\n[OK] Sin conflictos obvios detectados"
fi
EOF

chmod +x check_overlap.sh
./check_overlap.sh
```

**Output ejemplo**:
```
=== Detectando archivos modificados en ambos lados ===
[1] Tus cambios vs develop:
Total: 99 archivos

[2] Cambios en develop (ultimos 20 commits):
Total: 316 archivos

[3] Archivos modificados en AMBOS (RIESGO ALTO):
docs/adr/adr_2025_003_dora_sdlc_integration.md
docs/gobernanza/README.md
.github/CODEOWNERS
Total: 3 archivos

[ADVERTENCIA] Conflictos potenciales detectados!
```

---

## PASO 3: Decidir Estrategia de Sincronizacion

Tienes 3 opciones segun la situacion:

### Opcion A: MERGE (Develop -> Tu Branch)

**Cuando usar**:
- Tu branch es publica (compartida con otros)
- Quieres preservar historial exacto
- No te importa tener commit de merge

**Ventaja**: Mas seguro, no reescribe historia
**Desventaja**: Crea commit de merge adicional

```bash
# En tu branch actual
git merge origin/develop

# Si hay conflictos, resolver:
git status
# Editar archivos en conflicto
git add <archivo_resuelto>
git commit  # Completa el merge

# Push
git push
```

---

### Opcion B: REBASE (Tu Branch sobre Develop)

**Cuando usar**:
- Tu branch es privada (solo tuya)
- Quieres historial lineal y limpio
- Estas dispuesto a reescribir historia local

**Ventaja**: Historial limpio sin merge commits
**Desventaja**: Reescribe historia (cambia SHAs)

```bash
# En tu branch actual
git rebase origin/develop

# Si hay conflictos, resolver uno por uno:
git status
# Editar archivo
git add <archivo>
git rebase --continue

# Repetir hasta completar rebase

# Force push (CUIDADO: solo si branch es privada)
git push --force-with-lease
```

---

### Opcion C: VERIFICAR SOLO (Sin Sincronizar)

**Cuando usar**:
- Solo quieres ver QUE cambio en develop
- No estas listo para sincronizar aun
- Quieres analizar impacto primero

**No hace cambios**, solo analisis

---

## PASO 4: Sincronizar (Merge o Rebase)

### RECOMENDADO: Merge (Mas Seguro)

```bash
# PASO 4.1: Asegurate estar en tu branch
git checkout claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R

# PASO 4.2: Hacer merge de develop
git merge origin/develop

# PASO 4.3: Si NO hay conflictos
# (merge se completa automaticamente)
git log --oneline -1
# Veras: Merge remote-tracking branch 'origin/develop' into ...

# PASO 4.4: Si HAY conflictos
# Ver archivos en conflicto
git status | grep "both modified"

# Resolver cada archivo
# Buscar markers: <<<<<<<, =======, >>>>>>>
# Editar manualmente para combinar cambios

# Agregar archivos resueltos
git add <archivo1> <archivo2> ...

# Completar merge
git commit

# PASO 4.5: Verificar merge
git log --oneline --graph -10

# PASO 4.6: Push
git push
```

---

## PASO 5: Verificar Sincronizacion

### 5.1 Confirmar que Estas Actualizado

```bash
# Tu branch debe estar "adelante" de develop ahora
git log origin/develop..HEAD --oneline | wc -l
# Numero positivo = tienes commits que develop no

git log HEAD..origin/develop --oneline | wc -l
# Debe ser 0 (estas actualizado con develop)
```

### 5.2 Ver Diferencias Finales

```bash
# Ver QUE vas a aportar a develop cuando hagas PR
git diff --stat origin/develop..HEAD | tail -20

# Ejemplo output:
# 99 files changed, 6869 insertions(+), 297 deletions(-)
```

---

## FLUJO COMPLETO (Resumen)

```
[INICIO]
   |
   v
[PASO 1] git fetch origin develop
   |
   v
[PASO 2] Analizar cambios en develop
   |     git log HEAD..origin/develop
   |     git diff --stat HEAD origin/develop
   |     ./check_overlap.sh
   |
   v
[PASO 3] Decidir estrategia
   |
   +---> [Opcion A] Merge (mas seguro)
   |        |
   |        v
   |     git merge origin/develop
   |        |
   |        v
   |     Resolver conflictos (si hay)
   |        |
   |        v
   |     git commit (completar merge)
   |
   +---> [Opcion B] Rebase (historial limpio)
   |        |
   |        v
   |     git rebase origin/develop
   |        |
   |        v
   |     Resolver conflictos uno por uno
   |        |
   |        v
   |     git push --force-with-lease
   |
   v
[PASO 4] Verificar sincronizacion
   |     git log HEAD..origin/develop (debe ser 0)
   |
   v
[PASO 5] Push de tu branch actualizada
   |     git push
   |
   v
[PASO 6] Crear PR a develop
   |     (ahora con develop actualizado)
   |
   v
[FIN]
```

---

## Caso Especifico: Tu Situacion Actual

### Descubrimiento

```bash
$ git log origin/develop --grep="analyze-scripts-output" --oneline
71ff463 Merge changes from claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R into develop
```

**Significa**: ¡Parte de tu branch YA FUE MERGEADA a develop!

### Analisis Requerido

```bash
# Ver QUE fue mergeado
git show 71ff463 --stat

# Comparar commits
git log 71ff463..HEAD --oneline

# Ver diferencias restantes
git diff 71ff463 HEAD --stat
```

**Preguntas a responder**:
1. ¿TODO tu trabajo esta en ese merge?
2. ¿O solo una parte?
3. ¿Hay commits nuevos despues de ese merge?

### Estrategia Segun Respuesta

**Si TODO ya fue mergeado**:
- No necesitas hacer PR adicional
- Puedes cerrar tu branch
- Trabajo completo ✅

**Si SOLO PARTE fue mergeada**:
- Sincronizar con: `git merge origin/develop`
- Crear PR solo con commits nuevos
- Especificar en PR que es continuacion

**Si NADA fue mergeado** (merge fue revertido):
- Investigar por que se revirtio
- Corregir problemas
- Volver a intentar merge

---

## Comandos de Diagnostico

```bash
# 1. Ver si tu branch esta contenida en develop
git merge-base --is-ancestor HEAD origin/develop
# Exit code 0 = SI (ya mergeado completo)
# Exit code 1 = NO (no mergeado o solo parcial)

# 2. Ver commits unicos en tu branch
git log origin/develop..HEAD --oneline

# 3. Ver commits de develop que no tienes
git log HEAD..origin/develop --oneline

# 4. Ver archivos que aun difieren
git diff --name-only origin/develop HEAD

# 5. Ver si hay merge commit de tu branch
git log --merges origin/develop --grep="$(git rev-parse --abbrev-ref HEAD)"
```

---

## Checklist: Antes de Hacer Merge a Develop

- [ ] Fetch de origin/develop hecho
- [ ] Cambios en develop analizados (commits, archivos)
- [ ] Script de deteccion de conflictos ejecutado
- [ ] Verificado si ya existe merge parcial
- [ ] Estrategia elegida (merge o rebase)
- [ ] Branch sincronizada con develop
- [ ] Conflictos resueltos (si hubo)
- [ ] Tests pasando localmente
- [ ] Push de branch actualizada
- [ ] Listo para crear PR

---

## Ejemplo Practico: Tu Caso

```bash
# PASO 1: Fetch
git fetch origin develop
# Output: Already up to date. (si no hay cambios nuevos)

# PASO 2: Ver si hay cambios nuevos en develop
git log HEAD..origin/develop --oneline
# Si output esta vacio: develop no tiene cambios nuevos vs tu branch
# Si output tiene commits: develop avanzo, necesitas sincronizar

# PASO 3: Ver merge previo
git show 71ff463 --stat | head -30
# Esto muestra QUE archivos fueron mergeados en ese commit

# PASO 4: Ver diferencias actuales
git diff origin/develop..HEAD --stat
# Muestra archivos que TU tienes pero develop no

# PASO 5: Decidir accion
# Si diferencias son significativas: Hacer PR
# Si diferencias son minimas: Quiza no hacer nada
# Si no hay diferencias: Todo ya esta en develop
```

---

## Resolucion de Conflictos Comunes

### Conflicto en ADRs

```markdown
<<<<<<< HEAD (develop)
# ADR_2025_003: DORA SDLC Integration
Contenido version develop...
=======
# ADR_2025_003: DORA SDLC Integration
Contenido tu version...
>>>>>>> tu-commit-sha
```

**Resolucion**:
- Revisar ambas versiones
- Combinar cambios si son compatibles
- O elegir version mas reciente/completa
- Eliminar markers

### Conflicto en CODEOWNERS

```
<<<<<<< HEAD (develop)
docs/backend/**  @equipo-backend
=======
docs/backend/**  @equipo-backend @arquitecto-senior
>>>>>>> tu-commit-sha
```

**Resolucion**:
- Combinar owners: usar version mas completa
- Mantener ambos equipos si tiene sentido

---

## Monitoring Post-Sincronizacion

### Verificar que Merge Fue Limpio

```bash
# No debe haber archivos unmerged
git status
# Output esperado: "working tree clean"

# Historial debe verse limpio
git log --oneline --graph -20
# Debe mostrar commit de merge claramente

# Verificar que no se perdieron commits
git log --all --oneline | grep "feat(ai): complete SDLC"
# Debe aparecer tu commit importante
```

---

## Troubleshooting

### Problema: "CONFLICT (content): Merge conflict in X"

**Solucion**:
```bash
# Ver archivo en conflicto
cat X | grep -A 5 -B 5 "<<<<<<<<"

# Editar manualmente
# Eliminar markers y combinar contenido

# Agregar
git add X

# Continuar merge
git commit
```

### Problema: "fatal: refusing to merge unrelated histories"

**Causa**: Branches sin ancestro comun (tu caso?)

**Solucion**:
```bash
# Permitir merge de historias no relacionadas
git merge origin/develop --allow-unrelated-histories

# Resolver conflictos masivos que apareceran
# Considerar cherry-pick en su lugar (ver MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
```

---

## Conclusion

**Antes de cualquier merge a develop**:
1. ✅ Fetch para ver cambios
2. ✅ Analizar impacto (archivos, commits)
3. ✅ Detectar conflictos potenciales
4. ✅ Sincronizar tu branch (merge o rebase)
5. ✅ Resolver conflictos en tu branch
6. ✅ Verificar que todo funciona
7. ✅ Entonces SI hacer PR a develop

**Beneficios**:
- Merge final es limpio
- Conflictos resueltos antes, no durante PR
- Develop se mantiene estable
- Menos friccion con equipo

---

**Documento creado**: 2025-11-13
**Estrategia**: Sincronizar antes de merge
**Branch**: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
**Target**: develop
**Estado**: Merge parcial ya existe (commit 71ff463)
