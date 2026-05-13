---
id: TASK-QA-INFRA-003
tipo: tarea
categoria: diseno
nombre: Definir árbol y navegación documental
titulo: Definir árbol y navegación documental
fase: FASE_2
prioridad: P1
duracion_estimada: 1h
estado: pendiente
dependencias: [TASK-QA-INFRA-001, TASK-QA-INFRA-002]
---

# TASK-QA-INFRA-003: Definir árbol y navegación documental

**Objetivo:** Diseñar la estructura espejo de `infrastructure/` dentro de `docs/infraestructura/`, con páginas padre/hijas y frontmatter consistentes con el modelo de Gobernanza.

**Responsable:** @tech-writer  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Proponer árbol `docs/infraestructura/{box, cpython, vagrant, workspace}/` con `README.md` e `INDEX.md`.
- Definir secciones de navegación: Página padre, Páginas hijas, Validaciones obligatorias.
- Establecer campos de frontmatter (id, tipo, fecha, version, responsable) y enlaces relativos válidos.

## Pasos principales
1. Mapear el árbol final basándose en el inventario y el plan QA.
2. Redactar plantilla de navegación por componente con anchors y rutas relativas verificadas.
3. Validar coherencia con el formato de `docs/gobernanza/qa/QA-ANALISIS-RAMAS-001` y registrar decisiones.

## Entregables
- Estructura propuesta documentada y lista para ejecución en la fase siguiente.
- Lista de frontmatter y secciones obligatorias a usar por componente.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (diagramas/textos, validación de rutas).

## Checklist de salida
- [ ] Árbol propuesto cubre todos los submódulos (`box`, `cpython`, `vagrant`, `workspace`).
- [ ] Navegación padre/hijas documentada con enlaces relativos probados.
- [ ] Frontmatter estándar definido y aprobado.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Documentar bosquejos y validaciones en `./evidencias/evidencia-ejecucion.md`. Adjuntar capturas o hashes de comandos si se usaron validadores de enlaces.
