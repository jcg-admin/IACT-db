---
id: TASK-REORG-INFRA-013
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

# TASK-REORG-INFRA-013: Mover archivos de arquitectura desde raíz

## Descripción Ejecutiva

Esta tarea coordina el movimiento de archivos de diseño arquitectónico desde la raíz de `docs/infraestructura/` a su ubicación apropiada en `docs/infraestructura/diseno/arquitectura/` según el mapeo definido en MAPEO-MIGRACION-DOCS.md.

## Objetivos

1. Mover `ambientes_virtualizados.md` a `diseno/arquitectura/`
2. Mover `storage_architecture.md` a `diseno/arquitectura/`
3. Consolidar documentación arquitectónica en ubicación centralizada
4. Validar integridad de referencias cruzadas post-movimiento

## Archivos a Mover

| Archivo Origen | Ubicación Destino | Tipo | Estado |
|---|---|---|---|
| `/docs/infraestructura/ambientes_virtualizados.md` | `/docs/infraestructura/diseno/arquitectura/ambientes_virtualizados.md` | Documento Arquitectura | Pendiente |
| `/docs/infraestructura/storage_architecture.md` | `/docs/infraestructura/diseno/arquitectura/storage_architecture.md` | Documento Arquitectura | Pendiente |

## Justificación del Movimiento

### ambientes_virtualizados.md
- **Categoría:** Documento de diseño arquitectónico
- **Razón:** Describe arquitectura de ambientes virtualizados (infra arquitectónica)
- **Consolidación:** Los documentos de arquitectura deben centralizarse en `diseno/arquitectura/`
- **Relación:** Acompaña a `devcontainer-host-vagrant.md` que ya existe en destino

### storage_architecture.md
- **Categoría:** Documento de diseño arquitectónico
- **Razón:** Especifica decisiones de arquitectura de almacenamiento
- **Consolidación:** Parte de la consolidación "Arquitectura y Diseño"
- **Relación:** Complementa documentación de infraestructura de almacenamiento

## Criterios de Validación

### Pre-Movimiento
- [ ] Archivos origen existen en raíz
- [ ] Directorio destino `diseno/arquitectura/` existe
- [ ] Archivos no tienen contenido duplicado en destino
- [ ] Se realiza backup de archivos origen

### Post-Movimiento
- [ ] Archivos existen en nueva ubicación
- [ ] Contenido íntegro y sin corrupción
- [ ] Referencias cruzadas en otros documentos actualizadas
- [ ] Índices de navegación actualizados

## Impacto en Referencias

Se deben validar y actualizar referencias en:
- `docs/infraestructura/diseno/arquitectura/README.md` (índice)
- `docs/infraestructura/INDEX.md` (índice principal)
- `MAPEO-MIGRACION-DOCS.md` (marcar como completado)

## Metadatos YAML en Archivos

Después del movimiento, validar que cada archivo contenga:
```yaml
---
id: [nombre_archivo]_[fecha]
tipo: arquitectura
categoria: diseno
fecha_migracion: 2025-11-18
ubicacion_anterior: /docs/infraestructura/[nombre]
---
```

## Comando de Ejecución

```bash
# Movimiento seguro con validación
mv /home/user/IACT/docs/infraestructura/ambientes_virtualizados.md /home/user/IACT/docs/infraestructura/diseno/arquitectura/
mv /home/user/IACT/docs/infraestructura/storage_architecture.md /home/user/IACT/docs/infraestructura/diseno/arquitectura/

# Validación
ls -la /home/user/IACT/docs/infraestructura/diseno/arquitectura/
```

## Documentación de Evidencias

Guardar en `evidencias/`:
1. `LISTA-ARCHIVOS-ORIGEN.txt` - Listado con timestamps pre-movimiento
2. `VALIDACION-INTEGRIDAD.md` - Checksums y verificaciones
3. `REFERENCIAS-ACTUALIZADAS.md` - Documentación de cambios en referencias
4. `MOVIMIENTO-COMPLETADO.log` - Log de ejecución

## Seguimiento de Dependencias

- **Depende de:** TASK-REORG-INFRA-004 (Mapeo y análisis completo)
- **Precursor de:** TASK-REORG-INFRA-017 (Validación integral post-migración)

## Técnica: Chain-of-Thought

### Razonamiento Paso a Paso

1. **Identificación:** Documentos en raíz describen arquitectura
   - `ambientes_virtualizados.md` = arquitectura de VMs
   - `storage_architecture.md` = arquitectura de almacenamiento

2. **Categorización:** Ambos son decisiones/diseños arquitectónicos
   - Prioridad ALTA en MAPEO-MIGRACION-DOCS.md
   - Parte de Consolidación 1: Arquitectura y Diseño

3. **Destino:** `diseno/arquitectura/` es la ubicación canónica
   - Coherencia con estructura existente
   - `devcontainer-host-vagrant.md` ya allí
   - `cpython_arquitectura.md` será movido allí

4. **Validación:** Post-movimiento verificar referencias
   - README.md en destino
   - INDEX.md principal
   - MAPEO-MIGRACION-DOCS.md

## Cumplimiento de Auto-CoT

- [x] ¿Se entiende el problema? = Sí, movimiento simple de archivos arquitectónicos
- [x] ¿Hay información incompleta? = No, mapeo detallado disponible
- [x] ¿Hay conflictos entre pasos? = No, movimientos independientes
- [x] ¿Se pueden ejecutar en paralelo? = Sí, con TASK-014, TASK-015, TASK-016
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

- Coordinar con TASK-014 y TASK-015 para ejecución paralela
- Validar que no haya referencias hardcodeadas en scripts
- Documentar cualquier anomalía encontrada en evidencias/

---

**Creado:** 2025-11-18
**Última actualización:** 2025-11-18
**Estado:** LISTO PARA EJECUCIÓN
