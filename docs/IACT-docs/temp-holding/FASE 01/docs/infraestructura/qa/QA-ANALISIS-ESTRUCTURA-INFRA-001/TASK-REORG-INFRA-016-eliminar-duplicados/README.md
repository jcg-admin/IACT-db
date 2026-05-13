---
id: TASK-REORG-INFRA-016
tipo: eliminacion_duplicados
categoria: reorganizacion_infra
fase: FASE_2_REORGANIZACION_CRITICA
fecha_creacion: 2025-11-18
version: 1.0.0
prioridad: CRITICA
duracion_estimada: 30min
estado: pendiente
dependencias:
  - TASK-REORG-INFRA-004
tecnica: Chain-of-Thought + Self-Consistency
---

# TASK-REORG-INFRA-016: Eliminar archivos duplicados

## Descripción Ejecutiva

Esta tarea coordina la eliminación de archivos duplicados de la raíz de `docs/infraestructura/` donde existen versiones autorizadas en ubicaciones apropiadas. La prioridad es CRÍTICA debido a que los duplicados generan confusión y riesgo de inconsistencias.

## Objetivos

1. Eliminar `spec_infra_001_cpython_precompilado.md` de raíz (duplicado)
2. Eliminar `index.md` de raíz (duplicado minúscula)
3. Mantener versiones autorizadas en ubicaciones correctas
4. Documentar decisiones de eliminación exhaustivamente

## Archivos a Eliminar

| Archivo a Eliminar | Archivo Autorizado | Razón | Estado |
|---|---|---|---|
| `/docs/infraestructura/spec_infra_001_cpython_precompilado.md` | `/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md` | Duplicado - mantener versión en specs/ | Pendiente |
| `/docs/infraestructura/index.md` | `/docs/infraestructura/INDEX.md` | Duplicado minúscula - mantener INDEX.md | Pendiente |

## Justificación del Movimiento

### Duplicado 1: spec_infra_001_cpython_precompilado.md
- **Ubicación de Raíz:** `/docs/infraestructura/spec_infra_001_cpython_precompilado.md`
- **Ubicación Autorizada:** `/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md`
- **Prioridad:** MEDIA en MAPEO-MIGRACION-DOCS.md (fila 9)
- **Razón de Eliminación:** Existe versión autorizada en ubicación correcta (`specs/`)
- **Nomenclatura:** Versión en specs/ usa nomenclatura estandarizada (MAYÚSCULA)
- **Acción:** DELETE archivo de raíz

### Duplicado 2: index.md
- **Ubicación de Raíz (minúscula):** `/docs/infraestructura/index.md`
- **Ubicación Autorizada (mayúscula):** `/docs/infraestructura/INDEX.md`
- **Prioridad:** BAJA en MAPEO-MIGRACION-DOCS.md (fila 13)
- **Razón de Eliminación:** Convención de nomenclatura = MAYÚSCULA para índices principales
- **Estándar:** INDEX.md es la nomenclatura correcta para índices de directorios
- **Acción:** DELETE archivo minúscula, consolidar en INDEX.md

## Criterios de Validación

### Pre-Eliminación
- [ ] Ambos archivos de raíz existen
- [ ] Versiones autorizadas existen en ubicaciones destinadas
- [ ] Contenido de duplicados es idéntico o compatible
- [ ] Se realiza backup de archivos antes de eliminación
- [ ] Se verifica no haya referencias exclusivas a archivo de raíz

### Post-Eliminación
- [ ] Archivos han sido eliminados de raíz
- [ ] Versiones autorizadas permanecen intactas
- [ ] No hay referencias rotas apuntando a archivos eliminados
- [ ] Índices de navegación actualizados
- [ ] Backups de archivos eliminados guardados en evidencias/

## Análisis de Duplicados

### Comparación spec_infra_001_cpython_precompilado.md

```bash
# Verificación de contenido
diff /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md \
     /home/user/IACT/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md

# Verificación de checksums
md5sum /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md
md5sum /home/user/IACT/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md
```

### Comparación index.md vs INDEX.md

```bash
# Verificación de contenido
diff /home/user/IACT/docs/infraestructura/index.md \
     /home/user/IACT/docs/infraestructura/INDEX.md

# Verificación de checksums
md5sum /home/user/IACT/docs/infraestructura/index.md
md5sum /home/user/IACT/docs/infraestructura/INDEX.md
```

## Impacto en Referencias

Se deben verificar referencias a:
- `spec_infra_001_cpython_precompilado.md` (verificar que apunten a specs/)
- `index.md` (verificar que apunten a INDEX.md)

Buscar referencias con:
```bash
grep -r "spec_infra_001_cpython_precompilado" /home/user/IACT/docs/infraestructura/
grep -r "index.md" /home/user/IACT/docs/infraestructura/ --include="*.md"
```

## Comando de Ejecución

```bash
# PASO 1: Crear backups ANTES de eliminar
mkdir -p /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/backups
cp /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md \
   /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/backups/
cp /home/user/IACT/docs/infraestructura/index.md \
   /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/backups/

# PASO 2: Verificar contenido antes de eliminar
md5sum /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md > \
       /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/checksums-pre.txt
md5sum /home/user/IACT/docs/infraestructura/index.md >> \
       /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/checksums-pre.txt

# PASO 3: Buscar referencias
grep -r "spec_infra_001_cpython_precompilado" /home/user/IACT/docs/infraestructura/ \
    --include="*.md" > /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/referencias-spec.txt 2>&1 || true
grep -r "index.md" /home/user/IACT/docs/infraestructura/ \
    --include="*.md" > /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/referencias-index.txt 2>&1 || true

# PASO 4: Eliminar archivos duplicados
rm /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md
rm /home/user/IACT/docs/infraestructura/index.md

# PASO 5: Validación post-eliminación
echo "Archivos después de eliminación:" > /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
ls -la /home/user/IACT/docs/infraestructura/*.md >> /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
echo "---" >> /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
echo "Versiones autorizadas intactas:" >> /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
ls -la /home/user/IACT/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md >> /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
ls -la /home/user/IACT/docs/infraestructura/INDEX.md >> /home/user/IACT/TASK-REORG-INFRA-016-eliminar-duplicados/evidencias/validacion-post.txt
```

## Documentación de Evidencias

Guardar en `evidencias/`:
1. `backups/` - Directorio con copias de archivos eliminados
2. `checksums-pre.txt` - Checksums antes de eliminación
3. `referencias-spec.txt` - Búsqueda de referencias a spec_infra_001
4. `referencias-index.txt` - Búsqueda de referencias a index.md
5. `validacion-post.txt` - Validación post-eliminación
6. `ANALISIS-DUPLICADOS.md` - Análisis detallado
7. `ELIMINACION-COMPLETADA.log` - Log de ejecución

## Seguimiento de Dependencias

- **Depende de:** TASK-REORG-INFRA-004 (Mapeo y análisis completo)
- **Coordina con:** TASK-013, TASK-014, TASK-015 (ejecución paralela)
- **Precursor de:** TASK-REORG-INFRA-017 (Validación integral post-migración)

## Técnica: Chain-of-Thought

### Razonamiento Paso a Paso

1. **Identificación:** Duplicados detectados en análisis
   - `spec_infra_001_cpython_precompilado.md` existe en raíz Y en specs/
   - `index.md` (minúscula) existe Y INDEX.md (mayúscula) existe

2. **Análisis de Versiones Autorizadas:**
   - specs/SPEC_INFRA_001_cpython_precompilado.md = ubicación correcta
   - INDEX.md = nomenclatura correcta (mayúscula)

3. **Decisión de Eliminación:** Eliminar versiones de raíz
   - Raíz duplica contenido de ubicaciones autorizadas
   - Genera confusión y riesgo de inconsistencias
   - Prioridad CRÍTICA para evitar conflictos

4. **Validación:** Pre y post-eliminación
   - Backup completo antes de eliminar
   - Verificar no haya referencias exclusivas
   - Validar integridad de versiones autorizadas

## Cumplimiento de Auto-CoT

- [x] ¿Se entiende el problema? = Sí, eliminación de duplicados bien documentada
- [x] ¿Hay información incompleta? = No, análisis de duplicados en MAPEO-MIGRACION-DOCS.md
- [x] ¿Hay conflictos entre pasos? = No, eliminaciones independientes
- [x] ¿Se pueden ejecutar en paralelo? = Sí, con TASK-013, TASK-014, TASK-015
- [x] ¿Es la solución óptima? = Sí, elimina redundancia y confusión

## Métricas de Éxito

| Métrica | Valor Esperado | Umbral Aceptable |
|---------|---|---|
| Archivos eliminados | 2/2 | 100% |
| Backups realizados | 2/2 | 100% |
| Referencias verificadas | 2 búsquedas | Sin fallos |
| Versiones autorizadas intactas | 100% | 100% |
| Tiempo de ejecución | < 30min | <= 30min |
| Documentación de evidencias | Completa | 100% |

## Timeline

- **Inicio estimado:** Post-aprobación TASK-004
- **Duración:** 30 minutos
- **Fin estimado:** 2025-11-19 (estimado)

## Críticidad de Ejecución

PRIORIDAD CRÍTICA porque:
1. Duplicados pueden causar inconsistencias durante migraciones posteriores
2. Nomenclatura inconsistente (minúscula vs mayúscula) genera confusión
3. Reducción de duplicados mejora claridad y mantenibilidad
4. Debe ejecutarse ANTES de validación final integral

## Notas

- **IMPORTANTE:** Ejecutar PASO 1 (backups) antes de cualquier eliminación
- Coordinar con TASK-013 y TASK-014 para ejecución paralela
- Revisar cuidadosamente referencias antes de eliminar
- En caso de encontrar referencias exclusivas, contactar coordinador
- Documentar exhaustivamente cualquier anomalía encontrada

---

**Creado:** 2025-11-18
**Última actualización:** 2025-11-18
**Estado:** LISTO PARA EJECUCIÓN
