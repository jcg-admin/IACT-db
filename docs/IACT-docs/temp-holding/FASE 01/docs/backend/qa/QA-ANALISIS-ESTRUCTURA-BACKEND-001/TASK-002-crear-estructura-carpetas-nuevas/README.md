---
id: TASK-REORG-BACK-002
tipo: tarea
categoria: preparacion
titulo: Crear Estructura de Carpetas Nuevas
fase: FASE_1
prioridad: ALTA
duracion_estimada: 10min
estado: pendiente
dependencias: ["TASK-REORG-BACK-001"]
---

# TASK-REORG-BACK-002: Crear Estructura de Carpetas Nuevas

**Fase:** FASE 1 - Preparacion
**Prioridad:** ALTA
**Duracion Estimada:** 10 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear las 13 carpetas nuevas identificadas en el analisis que deben existir en docs/backend/ para alinear con la estructura de docs/gobernanza/.

---

## Prerequisitos

- [ ] TASK-001 completada exitosamente (backup creado)
- [ ] Working directory limpio
- [ ] Permisos de escritura en docs/backend/

---

## Pasos de Ejecucion

### Paso 1: Verificar Backup
```bash
# Confirmar que backup existe
git tag | grep "backup-reorganizacion-backend-2025-11-18"
```

**Resultado Esperado:** Tag existe

### Paso 2: Crear Carpetas Nuevas
```bash
mkdir -p docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance}
```

**Resultado Esperado:** 13 carpetas creadas

### Paso 3: Verificar Creacion
```bash
# Listar carpetas creadas
ls -d docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance}
```

**Resultado Esperado:** 13 carpetas listadas sin error

### Paso 4: Documentar Carpetas Creadas
```bash
# Crear listado de carpetas nuevas
ls -d docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance} > \
 docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/carpetas-nuevas.txt
```

**Resultado Esperado:** Archivo carpetas-nuevas.txt creado

---

## Criterios de Exito

- [ ] 13 carpetas nuevas creadas en docs/backend/
- [ ] Carpetas tienen nombres correctos segun especificacion
- [ ] No hay errores de permisos
- [ ] Listado documentado en carpetas-nuevas.txt

---

## Validacion

```bash
# Contar carpetas creadas
ls -d docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance} | wc -l
# Esperado: 13

# Verificar existencia individual
for dir in adr catalogos ci_cd ejemplos estilos glosarios metodologias plantillas procesos referencias templates trazabilidad vision_y_alcance; do
 if [ -d "docs/backend/$dir" ]; then
 echo "OK: $dir"
 else
 echo "FALTA: $dir"
 fi
done
```

**Salida Esperada:** Todas las carpetas muestran "OK"

---

## Rollback

Si se necesita deshacer:
```bash
# Eliminar carpetas creadas (SI ESTAN VACIAS)
rm -rf docs/backend/{adr,catalogos,ci_cd,ejemplos,estilos,glosarios,metodologias,plantillas,procesos,referencias,templates,trazabilidad,vision_y_alcance}

# Verificar eliminacion
ls docs/backend/ | grep -E "(adr|catalogos|ci_cd)"
# Esperado: sin output
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Carpeta ya existe | BAJA | BAJO | mkdir -p no falla si existe |
| Permisos insuficientes | MUY BAJA | MEDIO | Verificar permisos antes |
| Nombre incorrecto de carpeta | BAJA | BAJO | Seguir listado exacto |

---

## Evidencias a Capturar

1. Output de `ls -d docs/backend/{carpetas}`
2. Archivo `carpetas-nuevas.txt`
3. Screenshot de arbol de directorios (opcional)

---

## Listado de Carpetas a Crear

1. adr/ - Architecture Decision Records
2. catalogos/ - Catalogos de componentes
3. ci_cd/ - Documentacion CI/CD
4. ejemplos/ - Ejemplos de codigo
5. estilos/ - Guias de estilo
6. glosarios/ - Glosario tecnico
7. metodologias/ - Metodologias aplicadas
8. plantillas/ - Plantillas de documentos
9. procesos/ - Procesos high-level
10. referencias/ - Referencias tecnicas
11. templates/ - Templates adicionales
12. trazabilidad/ - Matrices de trazabilidad
13. vision_y_alcance/ - Vision estrategica

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] 13 carpetas creadas
- [ ] Verificacion OK con script
- [ ] Listado documentado en carpetas-nuevas.txt
- [ ] No hay errores de permisos
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
