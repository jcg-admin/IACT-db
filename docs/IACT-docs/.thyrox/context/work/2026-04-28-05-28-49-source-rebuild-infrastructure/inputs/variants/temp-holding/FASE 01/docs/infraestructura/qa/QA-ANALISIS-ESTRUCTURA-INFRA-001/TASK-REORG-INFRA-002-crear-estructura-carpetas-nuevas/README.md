---
id: TASK-REORG-INFRA-002
tipo: tarea
categoria: preparacion
titulo: Crear Estructura de Carpetas Nuevas
fase: FASE_1
prioridad: CRITICA
duracion_estimada: 2h
estado: pendiente
dependencias: ["TASK-REORG-INFRA-001"]
tecnica_prompting: Decomposed Prompting
---

# TASK-REORG-INFRA-002: Crear Estructura de Carpetas Nuevas

**Fase:** FASE 1 - Preparacion
**Prioridad:** CRITICA
**Duracion Estimada:** 2 horas
**Responsable:** Equipo Infraestructura
**Estado:** PENDIENTE

---

## Objetivo

Crear las 13 carpetas nuevas identificadas en el analisis que deben existir en docs/infraestructura/ para alinear con la estructura de docs/gobernanza/.

---

## Prerequisitos

- [ ] TASK-REORG-INFRA-001 completada exitosamente (backup creado con git tag)
- [ ] Working directory limpio (git status clean)
- [ ] Permisos de escritura en docs/infraestructura/
- [ ] Acceso al archivo LISTADO-COMPLETO-TAREAS.md para validacion

---

## Alcance

**INCLUYE:**
- Creacion de 13 carpetas nuevas en docs/infraestructura/
- Validacion de nombres segun especificacion
- Documentacion de carpetas creadas
- Verificacion de estructura
- Captura de evidencias

**NO INCLUYE:**
- Creacion de README.md en carpetas (TASK-REORG-INFRA-003)
- Movimiento de archivos existentes (fases posteriores)
- Cambios en estructura de otras carpetas

---

## Pasos de Ejecucion

### Paso 1: Verificar Backup y Estado Base

```bash
# Confirmar que backup existe
git tag | grep "backup-reorganizacion-infra"

# Confirmar working directory limpio
git status

# Registrar estado base
ls -la docs/infraestructura/ | grep "^d" | wc -l
```

**Resultado Esperado:**
- Tag de backup visible
- Working directory clean
- Conteo de carpetas existentes

---

### Paso 2: Crear Carpetas Nuevas (Auto-CoT)

Crear todas las 13 carpetas usando comando mkdir con estructura batch:

```bash
# Crear todas las carpetas en un solo comando
mkdir -p docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance}
```

**Resultado Esperado:** 13 carpetas creadas sin errores

---

### Paso 3: Verificar Creacion Individual

Ejecutar script de validacion para confirmar cada carpeta:

```bash
# Script de validacion
for dir in catalogos ci_cd ejemplos estilos glosarios gobernanza guias metodologias planificacion plans seguridad testing vision_y_alcance; do
  if [ -d "docs/infraestructura/$dir" ]; then
    echo "OK: $dir"
  else
    echo "FALTA: $dir"
  fi
done

# Contar total de carpetas creadas
ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} 2>/dev/null | wc -l
```

**Resultado Esperado:** Todas las carpetas muestran "OK" y conteo = 13

---

### Paso 4: Verificar Estructura Objetivo (Self-Consistency)

Validar que las carpetas creadas coinciden con el documento de reorganizacion:

```bash
# Leer lista de carpetas esperadas del README-REORGANIZACION-ESTRUCTURA.md
# Verificar cada una existe
echo "Validando contra README-REORGANIZACION-ESTRUCTURA.md..."

# Listar carpetas creadas en orden alfabetico
echo "Carpetas creadas:"
ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} | sort
```

**Resultado Esperado:**
- 13 carpetas listadas en orden alfabetico
- Coincidencia con lista en README-REORGANIZACION-ESTRUCTURA.md

---

### Paso 5: Documentar Evidencias

Crear archivo de evidencias con detalles de ejecucion:

```bash
# Crear log de ejecucion
cat > docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-002-crear-estructura-carpetas-nuevas/evidencias/TASK-002-LOG.md << 'EOF'
# TASK-REORG-INFRA-002 - Log de Ejecucion

**Fecha:** $(date)
**Ejecutado por:** [Tu Nombre]

## Ejecucion

### Paso 1: Backup Verificado
- Git tag: $(git describe --tags --match "backup-reorganizacion-infra*" | head -1)
- Working directory: CLEAN

### Paso 2: Carpetas Creadas
$(ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} 2>/dev/null)

### Paso 3: Validacion Individual
$(for dir in catalogos ci_cd ejemplos estilos glosarios gobernanza guias metodologias planificacion plans seguridad testing vision_y_alcance; do
  if [ -d "docs/infraestructura/$dir" ]; then
    echo "- OK: $dir"
  else
    echo "- FALTA: $dir"
  fi
done)

### Paso 4: Estadisticas
- Total carpetas creadas: 13
- Todos directorios vacios: YES
- Estructura validada: YES

## Criterios de Exito Cumplidos
- [x] 13 carpetas nuevas creadas en docs/infraestructura/
- [x] Carpetas tienen nombres correctos segun especificacion
- [x] No hay errores de permisos
- [x] Listado documentado

EOF

# Listar carpetas creadas en archivo separado
ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} > docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-002-crear-estructura-carpetas-nuevas/evidencias/carpetas-nuevas.txt
```

**Resultado Esperado:**
- Archivo TASK-002-LOG.md creado con detalles de ejecucion
- Archivo carpetas-nuevas.txt con listado de carpetas

---

### Paso 6: Validacion Final de Estructura (Self-Consistency Check)

```bash
# Verificar que NO existen archivos sueltos en las carpetas nuevas
echo "Validando que carpetas estan vacias..."
find docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} -type f 2>/dev/null | wc -l
# Esperado: 0 archivos

# Verificar tree o ls
echo "Estructura de directorios:"
tree docs/infraestructura/ -L 1 -d --dirsfirst 2>/dev/null || ls -lhd docs/infraestructura/*/
```

**Resultado Esperado:**
- 0 archivos encontrados en carpetas nuevas
- Estructura clara y limpia

---

## Criterios de Exito

- [ ] 13 carpetas nuevas creadas en docs/infraestructura/
- [ ] Carpetas tienen nombres EXACTOS segun listado:
  - catalogos/ (Catalogos de servicios y componentes)
  - ci_cd/ (CI/CD especifico de infraestructura)
  - ejemplos/ (Ejemplos de configuracion)
  - estilos/ (Guias de estilo IaC)
  - glosarios/ (Glosario tecnico)
  - gobernanza/ (Gobernanza especifica)
  - guias/ (Guias tecnicas)
  - metodologias/ (Metodologias IaC, GitOps)
  - planificacion/ (Planificacion consolidada)
  - plans/ (Planes de implementacion)
  - seguridad/ (Seguridad de infra)
  - testing/ (Testing de infra)
  - vision_y_alcance/ (Vision y roadmap)
- [ ] Todas las carpetas estan vacias (sin archivos)
- [ ] No hay errores de permisos
- [ ] Listado documentado en evidencias/carpetas-nuevas.txt
- [ ] Log de ejecucion en evidencias/TASK-002-LOG.md

---

## Validacion

### Conteo Automatico

```bash
# Contar carpetas creadas
TOTAL=$(ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} 2>/dev/null | wc -l)
if [ "$TOTAL" -eq 13 ]; then
  echo "EXITO: 13 carpetas creadas"
else
  echo "ERROR: Se esperaban 13 carpetas, se encontraron $TOTAL"
fi
```

### Verificacion Individual

```bash
# Verificar existencia individual (script completo)
CARPETAS=(catalogos ci_cd ejemplos estilos glosarios gobernanza guias metodologias planificacion plans seguridad testing vision_y_alcance)
CONTADOR=0
for dir in "${CARPETAS[@]}"; do
  if [ -d "docs/infraestructura/$dir" ]; then
    echo "[OK] $dir"
    ((CONTADOR++))
  else
    echo "[ERROR] FALTA: $dir"
  fi
done
echo ""
echo "Resultado: $CONTADOR/13 carpetas creadas"
```

**Salida Esperada:**
- EXITO: 13 carpetas creadas
- Todas las carpetas muestran check ([OK])
- Resultado: 13/13 carpetas creadas

---

## Rollback (Si es Necesario)

Si se necesita deshacer completamente la creacion:

```bash
# ADVERTENCIA: Esto eliminara todas las carpetas creadas
# SOLO ejecutar si hay errores criticos

# Eliminar carpetas (SI ESTAN VACIAS)
rm -rf docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance}

# Verificar eliminacion
ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} 2>&1
# Esperado: "No such file or directory" para cada carpeta

# Revertir a backup anterior si es necesario
git reset --hard <backup-commit-hash>
```

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Carpeta ya existe | BAJA | BAJO | mkdir -p no falla si existe |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos antes con `touch test.txt` |
| Nombre incorrecto de carpeta | BAJA | MEDIO | Seguir listado exacto, usar script de validacion |
| Estructura existente se sobrescribe | MUY BAJA | CRITICO | Backup previo ya hecho en TASK-001 |
| Caracteres especiales en nombres | MUY BAJA | BAJO | Usar nombres ASCII simples |
| Conflicto con branch actual | BAJA | MEDIO | Verificar git status antes |

---

## Evidencias a Capturar

1. **TASK-002-LOG.md** - Log de ejecucion con detalles paso a paso
2. **carpetas-nuevas.txt** - Listado de carpetas creadas (output de ls)
3. **validacion-estructura.txt** (opcional) - Output de script de validacion completo
4. **tree-output.txt** (opcional) - Arbol de directorios con `tree`

---

## Listado de Carpetas a Crear (13 Total)

| # | Nombre Carpeta | Proposito |
|---|---|---|
| 1 | catalogos/ | Catalogos de servicios y componentes de infraestructura |
| 2 | ci_cd/ | Documentacion CI/CD especifica de infraestructura |
| 3 | ejemplos/ | Ejemplos de configuracion, scripts, manifests |
| 4 | estilos/ | Guias de estilo para IaC (Terraform, Ansible, etc) |
| 5 | glosarios/ | Glosario tecnico y terminologia de infraestructura |
| 6 | gobernanza/ | Gobernanza especifica de infraestructura |
| 7 | guias/ | Guias tecnicas operativas y procedimientos |
| 8 | metodologias/ | Metodologias aplicadas (IaC, GitOps, Infrastructure as Code) |
| 9 | planificacion/ | Planificacion consolidada (roadmaps, sprints, releases) |
| 10 | plans/ | Planes de implementacion especificos |
| 11 | seguridad/ | Documentacion de seguridad de infraestructura |
| 12 | testing/ | Testing y pruebas de infraestructura |
| 13 | vision_y_alcance/ | Vision estrategica y roadmap de infraestructura |

---

## Comando Unico (Recomendado)

Para ejecutar toda la tarea en un paso:

```bash
# 1. Verificar backup
echo "Verificando backup..."
git tag | grep "backup-reorganizacion-infra" && echo "Backup OK" || echo "ERROR: Backup no encontrado"

# 2. Crear carpetas
echo "Creando 13 carpetas nuevas..."
mkdir -p docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance}

# 3. Verificar creacion
echo "Verificando creacion..."
TOTAL=$(ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} 2>/dev/null | wc -l)
if [ "$TOTAL" -eq 13 ]; then
  echo "EXITO: 13 carpetas creadas"

  # 4. Documentar
  echo "Documentando evidencias..."
  ls -d docs/infraestructura/{catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance} > \
    docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-002-crear-estructura-carpetas-nuevas/evidencias/carpetas-nuevas.txt

  echo "TAREA COMPLETADA: 13 carpetas creadas exitosamente"
else
  echo "ERROR: Se esperaban 13 carpetas, se encontraron $TOTAL"
  exit 1
fi
```

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

Nota: La tarea deberia completar en 10-20 minutos maximos

---

## Checklist de Finalizacion

- [ ] TASK-REORG-INFRA-001 backup verificado
- [ ] Comando mkdir ejecutado exitosamente
- [ ] Todas las 13 carpetas creadas
- [ ] Verificacion OK con script de validacion
- [ ] Listado documentado en evidencias/carpetas-nuevas.txt
- [ ] Log de ejecucion documentado en evidencias/TASK-002-LOG.md
- [ ] No hay errores de permisos
- [ ] Working directory limpio (listo para git add/commit)
- [ ] Tarea marcada como COMPLETADA en INDICE.md
- [ ] Dependencia documentada para TASK-REORG-INFRA-003

---

## Notas Importantes

### Auto-CoT (Chain of Thought)
Esta tarea aplica Auto-CoT dividiendo la creacion en pasos logicos:
1. Verificacion de prerequisitos (backup)
2. Creacion de estructura
3. Validacion individual
4. Validacion cruzada (Self-Consistency)
5. Documentacion de evidencias

### Self-Consistency
Las carpetas creadas se validan contra:
- LISTADO-COMPLETO-TAREAS.md (seccion 3.2)
- README-REORGANIZACION-ESTRUCTURA.md (seccion 3.2)
- PLAN-REORGANIZACION-ESTRUCTURA-INFRA-2025-11-18.md

Todas las fuentes deben listar las mismas 13 carpetas.

### Decomposed Prompting
La tarea se descompone en sub-tareas atomicas:
- T1: Verificacion
- T2: Creacion
- T3: Validacion
- T4: Documentacion

---

## Proximas Tareas Dependientes

Una vez COMPLETADA esta tarea:

1. **TASK-REORG-INFRA-003** - Crear README.md en cada carpeta nueva
2. **TASK-REORG-INFRA-004** - Crear mapeo de migracion de archivos
3. **TASK-REORG-INFRA-005** - Herramientas de validacion

---

## Referencias

- **README-REORGANIZACION-ESTRUCTURA.md** - Seccion 3.2 (Carpetas Nuevas a Crear)
- **LISTADO-COMPLETO-TAREAS.md** - TASK-REORG-INFRA-002
- **PLAN-REORGANIZACION-ESTRUCTURA-INFRA-2025-11-18.md** - Detalles de ejecucion
- **docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-002-crear-estructura-carpetas-nuevas/** - Modelo de referencia

---

## Control de Versiones

**Version:** 1.0.0
**Fecha de Creacion:** 2025-11-18
**Ultima Actualizacion:** 2025-11-18
**Estado:** PENDIENTE
**Cambios Recientes:** Creacion inicial del documento TASK-REORG-INFRA-002

---

**Documento creado siguiendo tecnicas de prompting: Auto-CoT, Self-Consistency, Decomposed Prompting**
