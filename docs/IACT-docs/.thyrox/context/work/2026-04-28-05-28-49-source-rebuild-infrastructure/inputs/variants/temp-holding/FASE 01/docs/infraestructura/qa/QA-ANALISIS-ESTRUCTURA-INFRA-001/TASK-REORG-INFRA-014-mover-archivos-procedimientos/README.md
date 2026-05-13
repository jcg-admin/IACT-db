---
id: TASK-REORG-INFRA-014
tipo: migracion_archivos
categoria: reorganizacion_infra
fase: FASE_2_REORGANIZACION_CRITICA
fecha_creacion: 2025-11-18
version: 1.0.0
prioridad: ALTA
duracion_estimada: 1h
estado: pendiente
dependencias:
  - TASK-REORG-INFRA-004
tecnica: Chain-of-Thought + Self-Consistency
---

# TASK-REORG-INFRA-014: Mover archivos de procedimientos desde raíz

## Descripción Ejecutiva

Esta tarea coordina el movimiento de archivos procedimentales y estratégicos desde la raíz de `docs/infraestructura/` a su ubicación apropiada en `docs/infraestructura/procedimientos/` según el mapeo definido en MAPEO-MIGRACION-DOCS.md.

## Objetivos

1. Mover `shell_scripts_constitution.md` a `procedimientos/`
2. Mover `cpython_builder.md` a `procedimientos/`
3. Consolidar documentación procedural en ubicación centralizada
4. Validar coherencia de referencias entre procedimientos

## Archivos a Mover

| Archivo Origen | Ubicación Destino | Tipo | Estado |
|---|---|---|---|
| `/docs/infraestructura/shell_scripts_constitution.md` | `/docs/infraestructura/procedimientos/shell_scripts_constitution.md` | Procedimiento | Pendiente |
| `/docs/infraestructura/cpython_builder.md` | `/docs/infraestructura/procedimientos/cpython_builder.md` | Procedimiento | Pendiente |

## Justificación del Movimiento

### shell_scripts_constitution.md
- **Categoría:** Especificación/Procedimiento de desarrollo
- **Razón:** Documento que define constitución y procedimientos para scripts shell
- **Prioridad:** MEDIA en MAPEO-MIGRACION-DOCS.md (fila 8)
- **Consolidación:** Parte de "Consolidación 2: Procedimientos"
- **Relación:** Acompaña a `estrategia_migracion_shell_scripts.md` (procedimientos/)

### cpython_builder.md
- **Categoría:** Procedimiento técnico de construcción
- **Razón:** Documento que describe procedimiento de construcción de CPython
- **Prioridad:** ALTA en MAPEO-MIGRACION-DOCS.md (fila 3)
- **Consolidación:** Procedimiento de construcción de herramientas
- **Relación:** Complementa documentación de CPython en `procedimientos/cpython/`

## Criterios de Validación

### Pre-Movimiento
- [ ] Archivos origen existen en raíz
- [ ] Directorio destino `procedimientos/` existe
- [ ] Archivos no tienen contenido duplicado en destino
- [ ] Se realiza backup de archivos origen

### Post-Movimiento
- [ ] Archivos existen en nueva ubicación
- [ ] Contenido íntegro y sin corrupción
- [ ] Referencias cruzadas entre procedimientos verificadas
- [ ] Índices de navegación actualizados
- [ ] Relaciones con documentos en `procedimientos/cpython/` validadas

## Impacto en Referencias

Se deben validar y actualizar referencias en:
- `docs/infraestructura/procedimientos/README.md` (índice)
- `docs/infraestructura/procedimientos/cpython/README.md` (si existe)
- `docs/infraestructura/INDEX.md` (índice principal)
- `MAPEO-MIGRACION-DOCS.md` (marcar como completado)

## Metadatos YAML en Archivos

Después del movimiento, validar que cada archivo contenga:
```yaml
---
id: [nombre_archivo]_[fecha]
tipo: procedimiento
categoria: procedimientos
fecha_migracion: 2025-11-18
ubicacion_anterior: /docs/infraestructura/[nombre]
---
```

## Comando de Ejecución

```bash
# Movimiento seguro con validación
mv /home/user/IACT/docs/infraestructura/shell_scripts_constitution.md /home/user/IACT/docs/infraestructura/procedimientos/
mv /home/user/IACT/docs/infraestructura/cpython_builder.md /home/user/IACT/docs/infraestructura/procedimientos/

# Validación
ls -la /home/user/IACT/docs/infraestructura/procedimientos/ | grep -E "(shell_scripts|cpython_builder)"
```

## Documentación de Evidencias

Guardar en `evidencias/`:
1. `LISTA-ARCHIVOS-ORIGEN.txt` - Listado con timestamps pre-movimiento
2. `VALIDACION-INTEGRIDAD.md` - Checksums y verificaciones
3. `REFERENCIAS-INTERDEPENDENCIAS.md` - Documentación de relaciones entre procedimientos
4. `MOVIMIENTO-COMPLETADO.log` - Log de ejecución

## Seguimiento de Dependencias

- **Depende de:** TASK-REORG-INFRA-004 (Mapeo y análisis completo)
- **Coordina con:** TASK-REORG-INFRA-013 (movimiento arquitectura en paralelo)
- **Precursor de:** TASK-REORG-INFRA-017 (Validación integral post-migración)

## Técnica: Chain-of-Thought

### Razonamiento Paso a Paso

1. **Identificación:** Documentos en raíz describen procedimientos
   - `shell_scripts_constitution.md` = procedimiento para scripts shell
   - `cpython_builder.md` = procedimiento de construcción CPython

2. **Categorización:** Ambos son procedimientos/instrucciones operacionales
   - Prioridad ALTA (cpython_builder) y MEDIA (shell_scripts)
   - Parte de Consolidación 2: Procedimientos
   - Documentación operacional/técnica

3. **Destino:** `procedimientos/` es la ubicación canónica
   - Coherencia con estructura existente
   - Relación con `procedimientos/cpython/` (cuando exista)
   - Agrupación de procedimientos técnicos

4. **Validación:** Post-movimiento verificar referencias
   - README.md en procedimientos/
   - Coherencia con otros procedimientos
   - INDEX.md principal

## Cumplimiento de Auto-CoT

- [x] ¿Se entiende el problema? = Sí, movimiento de archivos procedurales
- [x] ¿Hay información incompleta? = No, mapeo detallado disponible
- [x] ¿Hay conflictos entre pasos? = No, movimientos independientes
- [x] ¿Se pueden ejecutar en paralelo? = Sí, con TASK-013, TASK-015, TASK-016
- [x] ¿Es la solución óptima? = Sí, sigue consolidación planificada

## Métricas de Éxito

| Métrica | Valor Esperado | Umbral Aceptable |
|---------|---|---|
| Archivos movidos exitosamente | 2/2 | 100% |
| Integridad de contenido | 100% | 100% |
| Referencias actualizadas | 3+ ubicaciones | 0% fallos |
| Tiempo de ejecución | < 1h | <= 1h |
| Documentación de evidencias | Completa | 100% |

## Timeline

- **Inicio estimado:** Post-aprobación TASK-004
- **Duración:** 1 hora
- **Fin estimado:** 2025-11-19 (estimado)

## Notas

- Coordinar con TASK-013 y TASK-015 para ejecución paralela
- Validar que `cpython_builder.md` se relacione correctamente con `procedimientos/cpython/`
- Documentar cualquier anomalía encontrada en evidencias/

---

**Creado:** 2025-11-18
**Última actualización:** 2025-11-18
**Estado:** LISTO PARA EJECUCIÓN
