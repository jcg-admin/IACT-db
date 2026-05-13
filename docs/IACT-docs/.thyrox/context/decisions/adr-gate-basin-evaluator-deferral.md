```yml
created_at: 2026-04-20 14:00:28
project: THYROX
author: NestorMonroy
status: Aprobado
```

# ADR: Deferral del Evaluador-Basin en el Gate Calibrado

## Decisión

El gate calibrado de THYROX usa 3 evaluadores (completitud, consistencia, separabilidad).
El Evaluador-Basin (evaluación semántica mediante embeddings FAISS) fue propuesto en
`discover/clustering-basin-integration-analysis.md` como 4to evaluador pero se difiere.

## Razón del deferral

1. **Dependencia de infraestructura no disponible:** Basin requiere `faiss-cpu` y `sentence_transformers` — paquetes no instalados en el entorno base (verificado por T-066, bootstrap.py ahora los detecta).
2. **Gate de 3 evaluadores aún no estabilizado:** Los 3 evaluadores actuales se definieron en ÉPICA 42. Agregar un 4to antes de que el gate base sea estable en producción introduce riesgo de regresión.
3. **Criterio de activación no derivado:** No hay evidencia empírica de cuántos WPs se necesitan para calibrar los umbrales del Basin evaluator.

## Cuándo activar (criterio de activación)

Agregar Basin evaluator cuando se cumplan TODOS:
- [ ] `faiss-cpu` y `sentence_transformers` instalados en el entorno base
- [ ] Gate de 3 evaluadores estable en ≥3 ÉPICAs consecutivas sin falsos positivos
- [ ] ≥40 WPs completados disponibles para calibrar embeddings del Basin
- [ ] ADR de activación aprobado con métricas de calibración observadas

## Consecuencia

El gate calibrado con 3 evaluadores es el diseño oficial hasta que se cumplan los 4 criterios anteriores. Referencia de implementación del Basin: `discover/clustering-basin-integration-analysis.md`.
