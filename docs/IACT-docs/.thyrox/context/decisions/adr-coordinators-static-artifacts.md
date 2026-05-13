```yml
created_at: 2026-04-20 13:46:00
project: THYROX
author: NestorMonroy
status: Aprobado
```

# ADR: Coordinators como Artefactos Estáticos

## Decisión

Los coordinators (dmaic-coordinator, pdca-coordinator, etc.) NO se generan desde `bootstrap.py`.
Son artefactos estáticos creados y mantenidos manualmente, con `installation: manual` en su YML de registry.

## Razón

Los coordinators tienen lógica de metodología específica — qué hacer en cada paso, cómo transicionar entre etapas, cuáles son los tollgates formales — que no se puede parametrizar en templates simples de registry. Un template genérico produciría coordinators sin contenido metodológico: tendrían la estructura de frontmatter correcta pero carecerían de las instrucciones de ejecución que los hacen funcionales.

Diferencia con los tech-experts (generados por bootstrap.py): los experts tienen una estructura de convenciones y herramientas que sí es parametrizable — el template puede capturar el 80% del contenido. Los coordinators tienen un cuerpo de instrucciones de orquestación que es inherentemente específico a cada metodología.

## Consecuencias

- Cada coordinator nuevo requiere trabajo manual de creación
- Los coordinators no aparecen en el pipeline de `bootstrap.py --list` como generables
- Los YMLs de coordinators usan `installation: manual` para que ARCHITECTURE.md y herramientas de auditoría los distingan de los agentes generados

## Cómo crear un nuevo coordinator

1. Usar `dmaic-coordinator.md` como template base (anatomía de frontmatter)
2. Frontmatter requerido:
   ```yaml
   ---
   name: {metodología}-coordinator
   description: "Use when {metodología} methodology is active. Coordinator for {NOMBRE} — {descripción breve}, N phases with formal tollgates, isolated worktree."
   tools: Read, Write, Edit, Glob, Grep, Bash
   skills:
     - {metodología}-{fase1}
     - {metodología}-{fase2}
   background: true
   isolation: worktree
   color: {color}
   updated_at: YYYY-MM-DD HH:MM:SS
   ---
   ```
3. Cuerpo: instrucciones para cada fase, criterios de tollgate, transiciones
4. Crear YML en `.thyrox/registry/agents/{metodología}-coordinator.yml` con:
   ```yaml
   name: {metodología}-coordinator
   description: "..."
   tools: [Read, Write, Edit, Glob, Grep, Bash]
   installation: manual
   ```
5. Registrar en `ARCHITECTURE.md` sección "Agentes instalados"

## Naming y excepciones documentadas

- Patrón estándar: `{metodología}-coordinator.md`
- **Excepción 1:** `pm-coordinator` — la "pm" es por PMI Project Management (PMBOK), no por "pm" genérico o "project manager". El nombre correcto semánticamente sería `pmbok-coordinator` pero se mantuvo `pm-coordinator` por retrocompatibilidad.
- **Excepción 2:** `ba-coordinator` — la "ba" es por BABOK (Business Analysis), no por "business analyst" genérico. El nombre correcto semánticamente sería `babok-coordinator` pero se mantuvo `ba-coordinator` por retrocompatibilidad.
- `thyrox-coordinator` es el coordinator genérico fallback — no es específico de ninguna metodología, lee el YAML dinámicamente.

## Contexto histórico

Esta decisión fue documentada implícitamente en `bootstrap.py` líneas 46-67 como comentario de código. La ausencia de ADR formal significaba que un mantenedor podía no saber por qué los coordinators no estaban en el pipeline de generación, o intentar agregarlos rompiendo la lógica metodológica. ÉPICA 42 formalizó esta decisión como ADR.
