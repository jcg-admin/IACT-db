```yml
id: ERR-002
created_at: 2026-03-28
type: Violación de proceso
severity: Alta
Phase donde ocurrió: Phase 2 (SOLUTION_STRATEGY)
status: Detectado
```

# ERR-002: Clasificación incorrecta de tamaño del proyecto

## Qué pasó

Al iniciar la corrección de violaciones de covariancia, se clasificó como "proyecto pequeño (<2h)" y se propuso saltar fases (1, 2, 6, 7). Pero el proyecto de covariancia es parte de un esfuerzo más grande que lleva 30+ commits, 93 archivos tocados, y múltiples horas de trabajo.

## Por qué es un error

El SKILL define escalabilidad por complejidad:
- **Pequeño (<2h):** Fases 1, 2, 6, 7
- **Mediano (2-8h):** Las 7 fases completas
- **Grande (8h+):** Full structure con EXIT_CONDITIONS

Clasificar mal el tamaño lleva a saltar fases necesarias, producir trabajo sin estructura, y perder trazabilidad.

## Causa raíz

Se evaluó la tarea aislada (corregir violaciones de covariancia) en vez del contexto completo (la sesión entera de consolidación del framework). La tarea individual es pequeña, pero pertenece a un proyecto grande.

## Lección

Evaluar el tamaño considerando el proyecto completo, no la tarea individual. Una tarea de 30 minutos dentro de un proyecto de 8 horas sigue necesitando las 7 fases del proyecto padre.

---

**Detectado:** 2026-03-28
