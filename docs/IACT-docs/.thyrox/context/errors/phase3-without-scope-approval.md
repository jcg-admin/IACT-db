```yml
id: ERR-030
created_at: 2026-04-03-00-00-00
phase: Phase 3 (PLAN)
severity: media
recurrence: primera
```

# ERR-030: Phase 3 declarada completa sin obtener aprobación del scope

## Qué pasó

Al actualizar ROADMAP.md con el scope del MVP del meta-framework generativo, declaré
"Phase 3 completada" inmediatamente después de la actualización. Sin embargo, el exit
criteria de Phase 3 es: **"ROADMAP actualizado Y scope aprobado"**.

El scope fue presentado como propuesta al final del mensaje, pero se declaró la fase
completa antes de recibir respuesta del usuario.

## Por qué

Confusión entre "artefacto creado" y "fase completada". Actualizar ROADMAP.md es
condición necesaria pero no suficiente para cerrar Phase 3 — la aprobación del usuario
es el gate real que cierra la fase.

## Prevención

No declarar ninguna fase como "completada" hasta que el usuario confirme explícitamente.
El patrón correcto:

1. Crear/actualizar artefactos de la fase
2. Presentar al usuario: "Artefactos listos. [Resumen]. Apruebas para continuar a Phase N?"
3. Esperar confirmación
4. Solo entonces: declarar fase completa y proponer siguiente

Agregar en validate-phase-readiness.sh Phase 3: verificar que ROADMAP.md contiene
el WP linkeado (condición técnica). La aprobación humana sigue siendo responsabilidad
del flujo conversacional.

## Insight

Cuando el exit criteria de una fase incluye una acción humana (aprobación, revisión,
confirmación), ningún script puede reemplazarla. Separar "artefacto listo" de "fase
aprobada" es fundamental para el control de calidad del framework.
