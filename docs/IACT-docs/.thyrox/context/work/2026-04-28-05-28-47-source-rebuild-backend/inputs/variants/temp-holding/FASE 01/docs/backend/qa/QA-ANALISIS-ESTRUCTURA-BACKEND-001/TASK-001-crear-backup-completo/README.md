---
id: TASK-REORG-BACK-001
tipo: tarea
categoria: preparacion
titulo: Crear Backup Completo
fase: FASE_1
prioridad: CRITICA
duracion_estimada: 5min
estado: pendiente
dependencias: []
---

# TASK-REORG-BACK-001: Crear Backup Completo

**Fase:** FASE 1 - Preparacion
**Prioridad:** CRITICA
**Duracion Estimada:** 5 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear un tag de backup de seguridad en Git antes de realizar cualquier operacion de reorganizacion de documentacion, permitiendo rollback completo en caso de problemas.

---

## Prerequisitos

- [ ] Git configurado y funcionando
- [ ] Rama objetivo checked out: claude/analyze-work-01TYDrCJf4rqZRczvnam67Gv
- [ ] Estado de trabajo limpio (no hay cambios sin commit)
- [ ] Acceso push a repositorio remoto

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

**Resultado Esperado:** Rama correcta, working tree clean

### Paso 2: Crear Tag de Backup
```bash
git tag -a backup-reorganizacion-backend-2025-11-18 \
 -m "Backup pre-reorganizacion docs/backend - estructura 27 carpetas"
```

**Resultado Esperado:** Tag creado localmente

### Paso 3: Push Tag a Remoto
```bash
git push origin backup-reorganizacion-backend-2025-11-18
```

**Resultado Esperado:** Tag pusheado exitosamente

### Paso 4: Verificar Tag Creado
```bash
# Listar tags locales
git tag | grep "backup-reorganizacion-backend"

# Verificar tag en remoto
git ls-remote --tags origin | grep "backup-reorganizacion-backend"

# Ver commit al que apunta el tag
git show backup-reorganizacion-backend-2025-11-18 --oneline -s
```

**Resultado Esperado:** Tag existe local y remotamente, apunta al commit actual

### Paso 5: Documentar Commit Hash de Backup
```bash
# Guardar hash del commit de backup
git rev-parse backup-reorganizacion-backend-2025-11-18 > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/backup-commit-hash.txt

# Mostrar hash
cat docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/backup-commit-hash.txt
```

**Resultado Esperado:** Hash guardado en backup-commit-hash.txt

---

## Criterios de Exito

- [ ] Tag backup-reorganizacion-backend-2025-11-18 creado
- [ ] Tag pusheado al remoto exitosamente
- [ ] Tag apunta al commit actual de la rama
- [ ] Commit hash documentado en QA-ANALISIS-ESTRUCTURA-BACKEND-001/
- [ ] Nombre del tag sigue convencion: backup-reorganizacion-backend-YYYY-MM-DD

---

## Validacion

```bash
# Validar existencia de tag local
git tag | grep "backup-reorganizacion-backend-2025-11-18"

# Validar existencia en remoto
git ls-remote --tags origin | grep "backup-reorganizacion-backend-2025-11-18"

# Ver commit al que apunta el tag
git log backup-reorganizacion-backend-2025-11-18 -1 --pretty=format:"%H %s"

# Comparar con HEAD
diff <(git rev-parse HEAD) <(git rev-parse backup-reorganizacion-backend-2025-11-18)
```

**Salida Esperada:** Tag existe local y remoto, apunta al mismo commit que HEAD

---

## Rollback

Si falla la creacion del tag:
```bash
# Eliminar tag local si existe
git tag -d backup-reorganizacion-backend-2025-11-18

# Reintentar desde Paso 2
```

Si se necesita restaurar desde backup (EMERGENCIA):
```bash
# Ver diferencias
git diff backup-reorganizacion-backend-2025-11-18

# Restaurar completamente (PELIGROSO)
git reset --hard backup-reorganizacion-backend-2025-11-18
git push --force origin claude/analyze-work-01TYDrCJf4rqZRczvnam67Gv
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Tag con nombre duplicado | BAJA | BAJO | Usar sufijo incremental -v2 |
| Fallo en push a remoto | BAJA | MEDIO | Reintentar con exponential backoff |
| Tag apunta a commit incorrecto | MUY BAJA | CRITICO | Validar con git show antes de continuar |

---

## Evidencias a Capturar

1. Output de `git tag`
2. Output de `git push origin backup-...`
3. Archivo `backup-commit-hash.txt` con hash del commit
4. Screenshot (opcional)

---

## Notas

- Este backup es CRITICO para seguridad de rollback
- NO continuar con siguientes tareas si este backup falla
- El tag debe estar en remoto para ser considerado valido
- Conservar tag al menos 90 dias post-reorganizacion
- En caso de necesitar rollback, contactar Tech Lead primero

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Tag backup-reorganizacion-backend-2025-11-18 creado localmente
- [ ] Tag pusheado al remoto
- [ ] Tag verificado con git tag y git ls-remote
- [ ] Commit hash documentado
- [ ] Tag apunta al commit correcto
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
