---
id: TASK-REORG-INFRA-001
tipo: tarea_preparacion
categoria: backup
fase: FASE_1_PREPARACION
prioridad: CRITICA
duracion_estimada: 30min
estado: pendiente
dependencias: []
tags: [backup, git, preparacion]
tecnica_prompting: Execution Pattern
---

# TASK-REORG-INFRA-001: Crear Backup Completo

**Fase:** FASE 1 - Preparacion
**Prioridad:** CRITICA
**Duracion Estimada:** 30 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear un tag de backup de seguridad en Git antes de realizar cualquier operacion de reorganizacion de documentacion de infraestructura, permitiendo rollback completo en caso de problemas. Este backup preserva el estado completo de docs/infraestructura antes de cambios estructurales.

---

## Auto-CoT: Razonamiento sobre la Tarea

Esta tarea es CRITICA porque:
1. Establece un punto de recuperacion seguro antes de reorganizar documentacion de infraestructura
2. Permite rollback sin perdida de datos en caso de error
3. Debe completarse ANTES de cualquier cambio estructural en docs/infraestructura
4. La rama actual contiene el estado base que se debe preservar

El backup se implementa mediante:
- Tag anotado en Git (preserva metadata y mensaje)
- Push del tag al repositorio remoto (seguridad redundante)
- Documentacion del commit hash para referencia rapida

---

## Prerequisitos

- [ ] Git configurado y funcionando
- [ ] Rama objetivo checked out: claude/reorganize-infra-docs-01UpZE8vxSuoLPPeqnXCubRT
- [ ] Estado de trabajo limpio (no hay cambios sin commit)
- [ ] Acceso push a repositorio remoto
- [ ] Capacidad para crear y pushear tags

---

## Pasos de Ejecucion

### Paso 1: Verificar Estado Actual

```bash
# Ver commit actual
git log -1 --oneline

# Ver nombre de rama actual
git branch --show-current

# Verificar estado limpio
git status
```

**Resultado Esperado:** Rama correcta (claude/reorganize-infra-docs-01UpZE8vxSuoLPPeqnXCubRT), working tree clean, sin cambios sin commit

**Acciones si falla:**
- Si no estoy en la rama correcta: `git checkout claude/reorganize-infra-docs-01UpZE8vxSuoLPPeqnXCubRT`
- Si hay cambios sin commit: `git status` para revisar, luego commit o stash

---

### Paso 2: Crear Tag de Backup

```bash
git tag -a QA-INFRA-REORG-BACKUP-2025-11-18 \
 -m "Backup pre-reorganizacion docs/infraestructura - estructura completa infraestructura antes de cambios"
```

**Resultado Esperado:** Tag creado localmente sin errores

**Nota:** El nombre sigue la convencion: QA-INFRA-REORG-BACKUP-YYYY-MM-DD

---

### Paso 3: Push Tag a Remoto

```bash
git push origin QA-INFRA-REORG-BACKUP-2025-11-18
```

**Resultado Esperado:** Tag pusheado exitosamente al repositorio remoto

**Acciones si falla:**
- Verificar acceso a remoto: `git remote -v`
- Reintentar con verbose: `git push -v origin QA-INFRA-REORG-BACKUP-2025-11-18`

---

### Paso 4: Verificar Tag Creado

```bash
# Listar tags locales que contengan "QA-INFRA-REORG-BACKUP"
git tag | grep "QA-INFRA-REORG-BACKUP"

# Verificar tag en remoto
git ls-remote --tags origin | grep "QA-INFRA-REORG-BACKUP"

# Ver commit al que apunta el tag (formato corto)
git show QA-INFRA-REORG-BACKUP-2025-11-18 --oneline -s

# Ver informacion completa del tag
git show QA-INFRA-REORG-BACKUP-2025-11-18
```

**Resultado Esperado:**
- Tag existe en listado local
- Tag existe en remoto
- Tag apunta al commit actual de la rama

---

### Paso 5: Documentar Commit Hash de Backup

```bash
# Guardar hash del commit de backup en archivo
git rev-parse QA-INFRA-REORG-BACKUP-2025-11-18 > \
 /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt

# Mostrar hash guardado para verificacion
cat /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt

# Mostrar tambien el contenido del tag
echo "===== TAG DETAILS =====" && \
git show QA-INFRA-REORG-BACKUP-2025-11-18 --oneline -s
```

**Resultado Esperado:** Hash guardado en archivo backup-commit-hash.txt y mostrado en consola

---

## Criterios de Exito

- [ ] Tag QA-INFRA-REORG-BACKUP-2025-11-18 creado localmente
- [ ] Tag pusheado al remoto exitosamente
- [ ] Tag apunta al commit actual de la rama claude/reorganize-infra-docs-01UpZE8vxSuoLPPeqnXCubRT
- [ ] Commit hash documentado en QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt
- [ ] Nombre del tag sigue convencion: QA-INFRA-REORG-BACKUP-YYYY-MM-DD
- [ ] Archivo backup-commit-hash.txt contiene hash valido

---

## Validacion

```bash
# Validar existencia de tag local
git tag | grep "QA-INFRA-REORG-BACKUP-2025-11-18"
if [ $? -eq 0 ]; then echo "PASS: Tag existe localmente"; else echo "FAIL: Tag no existe localmente"; fi

# Validar existencia en remoto
git ls-remote --tags origin | grep "QA-INFRA-REORG-BACKUP-2025-11-18"
if [ $? -eq 0 ]; then echo "PASS: Tag existe en remoto"; else echo "FAIL: Tag no existe en remoto"; fi

# Ver commit al que apunta el tag
git log QA-INFRA-REORG-BACKUP-2025-11-18 -1 --pretty=format:"%H %s"

# Comparar con HEAD (deben ser identicos)
BACKUP_HASH=$(git rev-parse QA-INFRA-REORG-BACKUP-2025-11-18)
HEAD_HASH=$(git rev-parse HEAD)
if [ "$BACKUP_HASH" = "$HEAD_HASH" ]; then echo "PASS: Tag apunta a HEAD"; else echo "FAIL: Tag no apunta a HEAD"; fi

# Verificar archivo de documentacion
if [ -f "/home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt" ]; then
  echo "PASS: Archivo backup-commit-hash.txt existe"
  echo "Contenido:"
  cat /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt
else
  echo "FAIL: Archivo backup-commit-hash.txt no existe"
fi
```

**Salida Esperada:**
- Todos los checks muestran PASS
- Tag existe local y remoto
- Hash en archivo coincide con HEAD

---

## Self-Consistency: Validacion Multiple

Responde estas preguntas para confirmar completitud:

1. **Existe el tag localmente?**
   ```bash
   git tag | grep "QA-INFRA-REORG-BACKUP-2025-11-18" && echo "SI" || echo "NO"
   ```

2. **Existe el tag en remoto?**
   ```bash
   git ls-remote --tags origin | grep "QA-INFRA-REORG-BACKUP-2025-11-18" && echo "SI" || echo "NO"
   ```

3. **Apunta el tag al commit correcto?**
   ```bash
   [ "$(git rev-parse QA-INFRA-REORG-BACKUP-2025-11-18)" = "$(git rev-parse HEAD)" ] && echo "SI" || echo "NO"
   ```

4. **Fue documentado el hash?**
   ```bash
   [ -f "/home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt" ] && echo "SI" || echo "NO"
   ```

5. **El hash documentado es valido?**
   ```bash
   STORED=$(cat /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/backup-commit-hash.txt)
   CURRENT=$(git rev-parse HEAD)
   [ "$STORED" = "$CURRENT" ] && echo "SI" || echo "NO"
   ```

**Resultado esperado para todos:** SI

---

## Rollback

### Si falla la creacion del tag:

```bash
# Eliminar tag local si existe
git tag -d QA-INFRA-REORG-BACKUP-2025-11-18

# Eliminar tag remoto si fue pusheado
git push origin --delete QA-INFRA-REORG-BACKUP-2025-11-18

# Reintentar desde Paso 2
```

### Si se necesita restaurar desde backup (EMERGENCIA):

```bash
# Verificar diferencias entre estado actual y backup
git diff QA-INFRA-REORG-BACKUP-2025-11-18

# Mostrar cambios en forma de archivos modificados
git diff QA-INFRA-REORG-BACKUP-2025-11-18 --name-status

# ADVERTENCIA: Los siguientes comandos son DESTRUCTIVOS
# Solo ejecutar si se necesita restaurar completamente

# Restaurar rama al estado del backup (IRREVERSIBLE)
git reset --hard QA-INFRA-REORG-BACKUP-2025-11-18

# Pushear cambios al remoto (CUIDADO: usa --force solo en ramas personales)
git push origin claude/reorganize-infra-docs-01UpZE8vxSuoLPPeqnXCubRT
```

**IMPORTANTE:** Antes de ejecutar reset --hard:
1. Contactar al Tech Lead
2. Crear backup local: `git bundle create /tmp/current-state.bundle HEAD`
3. Confirmar que se necesita rollback completo

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Tag con nombre duplicado | BAJA | BAJO | Verificar con `git tag -l \| grep QA-INFRA-REORG-BACKUP` antes de crear |
| Fallo en push a remoto | BAJA | MEDIO | Reintentar con `git push -v origin <tag>` y verificar conectividad |
| Tag apunta a commit incorrecto | MUY BAJA | CRITICO | Validar con `git show <tag>` antes de continuar a siguiente tarea |
| Cambios sin commit en working tree | MEDIA | ALTO | Ejecutar `git status` en Paso 1, commit o stash antes de continuar |
| Acceso insuficiente para push | BAJA | CRITICO | Verificar permisos de repositorio y credenciales de Git |

---

## Evidencias a Capturar

Guardar en `/home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-001-crear-backup-completo/evidencias/`:

1. Output de `git tag | grep QA-INFRA-REORG-BACKUP` (verificacion local)
2. Output de `git ls-remote --tags origin | grep QA-INFRA-REORG-BACKUP` (verificacion remota)
3. Output de `git show QA-INFRA-REORG-BACKUP-2025-11-18` (detalles completos del tag)
4. Archivo `backup-commit-hash.txt` con hash del commit
5. Output de `git log QA-INFRA-REORG-BACKUP-2025-11-18 -1` (informacion del commit)
6. Screenshot (opcional) del comando de push exitoso

---

## Tiempo de Ejecucion Estimado

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

Pasos individuales (tiempo estimado):
- Paso 1 (Verificar estado): 2 min
- Paso 2 (Crear tag): 1 min
- Paso 3 (Push tag): 2 min
- Paso 4 (Verificar tag): 3 min
- Paso 5 (Documentar hash): 2 min
- Documentar evidencias: 20 min

---

## Checklist de Finalizacion

- [ ] Tag QA-INFRA-REORG-BACKUP-2025-11-18 creado localmente
- [ ] Tag pusheado al remoto exitosamente
- [ ] Tag verificado con `git tag` y `git ls-remote`
- [ ] Commit hash documentado en backup-commit-hash.txt
- [ ] Tag apunta al commit correcto (verificado)
- [ ] Evidencias capturadas en carpeta evidencias/
- [ ] Tarea marcada como COMPLETADA en documentacion
- [ ] Resultado de validacion Self-Consistency: TODAS LAS RESPUESTAS SON SI
- [ ] Tiempo de ejecucion registrado
- [ ] Tarea lista para siguiente fase

---

## Notas Importantes

- Este backup es CRITICO para seguridad de rollback de la reorganizacion de infraestructura
- NO continuar con siguientes tareas si este backup falla
- El tag DEBE estar en remoto para ser considerado valido
- Conservar tag al menos 90 dias post-reorganizacion
- En caso de necesitar rollback, contactar Tech Lead primero
- El nombre del tag debe seguir la convencion: QA-INFRA-REORG-BACKUP-YYYY-MM-DD
- Este es un prerequisito CRITICO para la FASE 1 de reorganizacion

---

## Tecnicas de Prompting Aplicadas

**Auto-CoT (Razonamiento Automatico Paso a Paso):**
- Razonamiento inicial sobre por que es critica esta tarea
- Desglose en pasos ordenados y validables
- Verificacion progresiva del estado con criterios claros

**Self-Consistency (Validacion Multiple):**
- Multiples formas de verificar que el backup existe (local, remoto, hash)
- Preguntas de validacion con comandos verificables
- Comparacion de estados antes y despues

**Execution Pattern:**
- Pasos secuenciales y ordenados
- Comandos exactos y reproducibles
- Criterios de exito verificables en cada paso

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
