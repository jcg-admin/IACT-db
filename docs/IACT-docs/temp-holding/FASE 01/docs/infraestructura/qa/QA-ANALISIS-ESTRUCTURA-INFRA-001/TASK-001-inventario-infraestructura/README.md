---
id: TASK-QA-INFRA-001
tipo: tarea
categoria: descubrimiento
nombre: Levantar inventario de infraestructura
titulo: Levantar inventario de infraestructura
fase: FASE_1
prioridad: P1
duracion_estimada: 0.4h
estado: pendiente
dependencias: []
---

# TASK-QA-INFRA-001: Levantar inventario de infraestructura

**Objetivo:** Mapear subdirectorios `infrastructure/{box, cpython, vagrant, workspace}` y scripts clave para preparar la documentación espejo en `docs/infraestructura/`.

**Responsable:** @arquitecto-senior  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (referencia interna en `docs/ai/prompting`).

---

## Alcance
- Inventariar archivos y scripts (`bootstrap.sh`, `setup.sh`, `Vagrantfile`, `.env.example`).
- Registrar dependencias externas y restricciones explícitas encontradas en configuraciones.
- Generar tabla preliminar en `docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/`.

## Pasos principales
1. Recorrer `infrastructure/` y listar subdirectorios y scripts de arranque.
2. Identificar dependencias o servicios prohibidos (sin Redis, sin correo) y anotar ubicaciones.
3. Consolidar hallazgos en una tabla (componentes, propósito, archivos clave, restricciones) lista para publicarse.

## Entregables
- Tabla de inventario inicial en el paquete QA (`ANALISIS-ESTRUCTURA-INFRA-2025-11-18.md` o addendum).
- Actualización de checklist del plan con los hallazgos completados.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (capturas de comandos, rutas revisadas, timestamp de ejecución).

## Checklist de salida
- [ ] Subdirectorios inventariados con propósito documentado.
- [ ] Scripts críticos localizados y descritos.
- [ ] Restricciones sin Redis/correo verificadas en los artefactos.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Colocar toda evidencia en `./evidencias/evidencia-ejecucion.md` (logs, tablas, referencias a commits). Sin evidencia no se considera completada.
