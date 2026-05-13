```yml
id: ERR-022
created_at: 2026-03-28
type: Violación de proceso (reincidencia de patrón)
severity: Alta
status: Detectado
Relacionado: ERR-021, ADR-012
```

# ERR-022: Work-log creado pero no actualizado

## Qué pasó

Se creó el work-log de la sesión (corrigiendo ERR-021) y se creó ADR-012 declarando work-logs como obligatorios. Inmediatamente después, se realizaron 3 ciclos más de trabajo (unused directories, ADRs, principles analysis) sin actualizar el work-log.

## Por qué es grave

1. Es reincidencia del patrón de ERR-021 — crear la regla no garantiza seguirla
2. Se violó un ADR que se creó en la misma sesión
3. El SKILL dice "Update work-log with progress" en Phase 6, paso 5

## Causa raíz

Misma que ERR-021: no hay enforcement automático. Crear el work-log fue un acto consciente (corrección de error). Actualizarlo requiere disciplina continua que no hay nada que recuerde.

El flujo actual no tiene checkpoint que diga "¿actualizaste el work-log?" entre ciclos.

## Lección

Crear una regla no es suficiente. Si el enforcement depende de memoria/disciplina, va a fallar. Necesita ser parte del flujo de cierre de cada ciclo, no solo de la sesión.
