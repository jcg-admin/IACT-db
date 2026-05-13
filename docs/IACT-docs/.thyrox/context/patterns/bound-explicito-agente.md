---
id: P-002
nombre: Bound Explícito en Instrucciones de Agente
problema: Instrucciones con alcance ilimitado ("todos", "cada uno") causan timeouts y resultados impredecibles
categoria: Agentes
origen: FASE 35
fecha: 2026-04-14
---

## Problema

Cuando se lanza un subagente con una instrucción que contiene términos de
alcance ilimitado ("todos los archivos", "cada sección", "cualquier referencia"),
el agente aplica la instrucción literalmente. Sin un punto de parada determinista:

- El agente lee más archivos de los necesarios
- El contexto crece hasta saturar la ventana
- La generación del output final causa períodos de idle en el stream
- Resultado: stream idle timeout o respuesta de baja calidad

## Solución (el Patrón)

**Toda instrucción de agente con alcance potencialmente ilimitado debe incluir
un bound explícito: número máximo, lista concreta o criterio de parada.**

```
Sin bound (❌):  "leer todos los scripts del directorio"
Con bound (✓):  "leer máximo 5 scripts: [pre-tool-check.sh, log-bash.sh, ...]"

Sin bound (❌):  "analiza todas las referencias"
Con bound (✓):  "analiza estas 3 referencias: X, Y, Z"

Sin bound (❌):  "complementa todos los documentos"
Con bound (✓):  "complementa máximo 4 documentos por sesión, priorizando los de hooks"
```

## Implementación

### Tabla de bounds por tipo de instrucción

| Instrucción sin bound | Bound recomendado |
|-----------------------|-------------------|
| "todos los archivos" | "máximo N archivos" o "solo estos: [lista]" |
| "cada sección del doc" | "las secciones X, Y, Z" |
| "cualquier referencia" | "hasta 5 referencias relevantes" |
| "leer todo el directorio" | "leer README.md + máximo 3 ejemplos" |
| "analiza todos los casos" | "analiza los 5 casos más representativos" |

### Tipos de bounds

```
A) Número máximo:       "máximo N elementos"
B) Lista explícita:     "solo estos: [item1, item2, item3]"
C) Criterio de parada:  "hasta encontrar N instancias de X"
D) Representatividad:   "los 3-5 más representativos del dominio"
E) Profundidad:         "máximo N tool_uses en total"
```

### Estimación de bound apropiado

| Complejidad de tarea | Bound recomendado | Riesgo de timeout |
|---------------------|-------------------|-------------------|
| Doc simple + 1-3 fuentes | Sin bound o N≤5 | Bajo |
| Doc complejo + 4-8 fuentes | N≤5 archivos fuente | Medio |
| Doc muy maduro + corpus grande | N≤3 archivos + lista explícita | Alto |

### Enforcement automático

`bound-detector.py` en `PreToolUse` bloquea automáticamente instrucciones
sin bound y presenta las 5 opciones al usuario.

## Cuándo Aplicar

- Al lanzar cualquier agente con acceso a un directorio con >5 archivos
- Cuando la instrucción contiene: "todos", "todas", "cada", "cualquier", "sin límite"
- En tareas de deep-review donde el corpus fuente es grande
- En parallel batch de agentes (el más lento determina el tiempo total)

## Cuándo NO Aplicar

- Cuando el scope es naturalmente pequeño (3-4 archivos conocidos)
- Cuando la lista explícita hace el bound redundante

## Referencias

- Lección origen: [bound-agente-timeout](../lessons/bound-agente-timeout.md)
- Análisis Ishikawa: sesión FASE 35
- Script de enforcement: `.claude/scripts/bound-detector.py`
