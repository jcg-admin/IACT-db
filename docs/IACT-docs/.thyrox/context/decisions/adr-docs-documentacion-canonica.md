```yml
type: Architectural Decision Record
category: Decisión Técnica/Arquitectónica
version: 1.0
usage: Solo para decisiones arquitectonicas permanentes del PROYECTO (stack, patrones, componentes principales).
     NO usar para decisiones de metodologia — esas van en SKILL.md.
```

# ADR-013: docs/ como documentación canónica del proyecto

## Metadatos

**ADR ID:** ADR-013<br>
**Título:** Separación .claude/ (efímero) vs docs/ (permanente) con adr_path configurable<br>
**Fecha:** 2026-04-04<br>
**Status:** Aprobado<br>

---

## Contexto

El framework pm-thyrox mezclaba dos tipos de artefactos bajo `.claude/`:

- **Efímeros** (contexto de Claude): `context/work/`, `focus.md`, `now.md`
- **Permanentes** (documentación del proyecto): `context/decisions/` (ADRs)

Al vivir en `.claude/` (directorio oculto, Claude-only), los ADRs quedaban
invisibles para desarrolladores que no usan Claude Code, para herramientas
de documentación como Sphinx o MkDocs, y para un PM que entrega el proyecto.

**Drivers:**
- ADRs deben ser accesibles para todo el equipo, no solo para Claude
- Herramientas de docs (Sphinx) necesitan indexar archivos en directorios visibles
- SKILL.md debe ser portátil entre proyectos sin referenciar rutas específicas

**Restricciones técnicas:**
- No romper proyectos existentes (THYROX usa `.claude/context/decisions/`)
- El default debe funcionar para el 90% de los casos nuevos

---

## Opciones Consideradas

### Opción 1: Mantener todo en .claude/

**Descripción:** No cambiar nada. ADRs siguen en `.claude/context/decisions/`.

**Ventajas:**<br>
+ Sin cambios, sin riesgo de ruptura

**Desventajas:**<br>
- ADRs invisibles para equipo y herramientas<br>
- SKILL.md no portable (hardcodea ruta)<br>
- PM no puede entregar documentación sin filtrar manualmente

---

### Opción 2: Mover todo a docs/ sin retrocompatibilidad

**Descripción:** Cambiar SKILL.md para siempre escribir en `docs/architecture/decisions/`.

**Ventajas:**<br>
+ Estructura limpia desde el inicio

**Desventajas:**<br>
- Rompe proyectos existentes que usan `.claude/context/decisions/`<br>
- Obliga migración inmediata

---

### Opción 3: Campo adr_path configurable (elegida)

**Descripción:** Campo `adr_path` en CLAUDE.md del proyecto. SKILL.md lee ese
campo; si no existe, usa `docs/architecture/decisions/` como default.

**Ventajas:**<br>
+ Portabilidad total de SKILL.md<br>
+ Retrocompatibilidad — proyectos existentes declaran su path actual<br>
+ Proyectos nuevos arrancan con el default correcto

**Desventajas:**<br>
- Requiere que proyectos existentes añadan el campo a su CLAUDE.md

---

## Decisión

**Se elige:** Opción 3 — campo `adr_path` configurable

**Razón principal:** Portabilidad sin ruptura. Cada proyecto declara su convención;
SKILL.md respeta esa declaración.

---

## Justificación

La separación `.claude/` vs `docs/` es la separación correcta por audiencia:

| Directorio | Audiencia | Durabilidad |
|-----------|-----------|-------------|
| `.claude/context/work/` | Solo Claude | Efímera |
| [focus](.claude/context/focus.md) | Solo Claude | Sesión |
| `docs/` | Todo el equipo | Permanente |

El campo `adr_path` es el mecanismo que permite a proyectos en distintos estados
de madurez adoptar la convención gradualmente.

**Trade-offs aceptados:**
Proyectos existentes deben añadir una línea a su CLAUDE.md para declarar su
`adr_path` actual. Es un cambio trivial con alto valor.

---

## Consecuencias

### Positivas

+ADRs accesibles para el equipo sin depender de Claude Code<br>
+Sphinx y otras herramientas pueden indexar `docs/` directamente<br>
+SKILL.md portátil entre proyectos<br>
+CLAUDE.md de THYROX es retrocompatible con una sola línea

### Negativas

-Proyectos existentes deben actualizar su CLAUDE.md

### Mitigaciones

Proyectos existentes que no actualicen su CLAUDE.md → Claude usará el default
`docs/architecture/decisions/`, lo cual es incorrecto para esos proyectos.
Mitigación: documentar el campo en el template de CLAUDE.md.

---

## Impacto

**Áreas afectadas:**<br>
- [CLAUDE](.claude/CLAUDE.md) — sección nueva Configuración del Proyecto<br>
- [SKILL](.claude/skills/pm-thyrox/SKILL.md) — Phase 1 Step 8<br>
- `docs/architecture/decisions/` — directorio creado en este WP

**Esfuerzo de implementación:** Bajo<br>
**Fecha de implementación:** 2026-04-04

---

## Referencias

- [doc-structure analysis](../work/2026-04-04-08-46-36-doc-structure/analysis/doc-structure-analysis.md)
- [doc-structure solution strategy](../work/2026-04-04-08-46-36-doc-structure/doc-structure-solution-strategy.md)

---

**Última Actualización:** 2026-04-04
