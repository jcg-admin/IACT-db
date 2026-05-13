---
id: TASK-QA-INFRA-005
tipo: tarea
categoria: ejecucion
nombre: Crear o actualizar documentación base por componente
titulo: Crear/actualizar documentación base por componente
fase: FASE_3
prioridad: P1
duracion_estimada: 1.25h
estado: pendiente
dependencias: [TASK-QA-INFRA-004]
---

# TASK-QA-INFRA-005: Crear/actualizar documentación base por componente

**Objetivo:** Generar `README.md` e `INDEX.md` para cada módulo de `infrastructure/` con navegación consistente, restricciones operativas y ejemplos de comandos.

**Responsable:** @tech-writer  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Crear/actualizar documentación en `docs/infraestructura/{box, cpython, vagrant, workspace}`.
- Incluir secciones de "Restricciones operativas" y "Validaciones obligatorias" (TDD, cobertura ≥80 %, sin Redis/correo).
- Agregar ejemplos de comandos (Vagrant up, bootstrap cpython, setup workspace) y ubicación de `.env.example`.

## Pasos principales
1. Copiar y ajustar plantillas aprobadas en TASK-QA-INFRA-004 a cada subcarpeta.
2. Verificar enlaces relativos a la página padre e hijas de cada componente.
3. Documentar comandos y referencias a archivos de configuración, manteniendo consistencia con la taxonomía QA.

## Entregables
- READMEs e índices actualizados para cada módulo.
- Navegación validada con rutas relativas correctas.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (diffs, capturas de validadores de enlaces, timestamps).

## Checklist de salida
- [ ] READMEs e INDEX creados/actualizados en los cuatro módulos.
- [ ] Sección de restricciones operativas completa y visible en cada documento.
- [ ] Enlaces relativos verificados.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Registrar validaciones y diffs en `./evidencias/evidencia-ejecucion.md`, con enlaces a commits o build de docs si aplica.
