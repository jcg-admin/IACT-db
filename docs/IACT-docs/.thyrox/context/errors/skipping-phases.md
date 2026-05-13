```yml
id: ERR-006
created_at: 2026-03-28
type: Violación de proceso (reincidencia)
severity: Alta
status: Detectado
Relacionado: ERR-002
```

# ERR-006: Saltar fases de nuevo (reincidencia de ERR-002)

## Qué pasó

Después de completar el análisis comparativo spec-kit vs THYROX (Phase 1: ANALYZE), se propuso "¿Quieres que empiece a implementar las correcciones?" — saltando directamente de Phase 1 a Phase 6.

Este es el MISMO error que ERR-002, donde se clasificó mal el tamaño del proyecto y se propuso saltar fases.

## Por qué es grave

1. Es reincidencia — el error ya fue documentado y supuestamente "aprendido"
2. El análisis de spec-kit identificó 8 correcciones, 5 errores nuevos, y cambios en múltiples archivos — esto NO es un proyecto pequeño
3. Acabamos de documentar ERR-005 (fases no ejecutables) y estamos demostrando exactamente ese problema: las fases del SKILL no se siguen porque no son lo suficientemente prescriptivas

## Causa raíz

La inercia de "resolver rápido" prevalece sobre el proceso. Cuando el análisis está fresco y las correcciones son claras, hay una tendencia a saltar al código. Pero eso es exactamente lo que el framework existe para prevenir.

El SKILL dice 7 fases. No dice "7 fases excepto cuando crees que sabes la respuesta."

## Patrón del error

```
ERR-002: Sesión anterior — propuso saltar fases por "proyecto pequeño"
ERR-006: Esta sesión    — propuso saltar fases por "ya sé qué hacer"
```

Mismo error, diferente justificación. La causa real es la misma: no consultar el SKILL antes de actuar.

## Lección

Antes de proponer CUALQUIER acción, la pregunta es: **¿En qué fase estoy y cuál es la siguiente según el SKILL?**

No "¿qué debería hacer ahora?" sino "¿qué dice el SKILL que toca?"

## Lo que debería haber dicho

"Phase 1: ANALYZE completada. Según el SKILL, el siguiente paso es Phase 2: SOLUTION_STRATEGY — definir CÓMO implementar las correcciones que encontramos. ¿Procedemos?"

---

**Detectado:** 2026-03-28
**Reincidencia de:** ERR-002
