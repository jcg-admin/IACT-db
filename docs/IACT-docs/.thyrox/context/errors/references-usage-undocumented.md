```yml
id: ERR-026
created_at: 2026-03-28
type: Gap en documentación
severity: Alta
status: Detectado
```

# ERR-026: No hay análisis de cuándo se usa cada reference

## Qué pasó

Tenemos 20 archivos en references/ pero no hay un documento que mapee CUÁNDO y POR QUÉ se lee cada uno. El SKILL.md agrupa por dominio con "leer cuando..." pero:

1. No se ha verificado si cada reference es realmente útil o es legacy del proyecto ADT
2. No se ha mapeado qué fase del SKILL invoca cada reference
3. No se ha verificado si hay solapamiento entre references
4. Algunos references tienen contenido genérico de Anthropic (prompting-tips, long-context-tips, skill-authoring) que no es específico de PM

## Impacto

Sin este análisis, no sabemos si las 20 references son realmente necesarias o si estamos cargando contexto innecesario. L-0002 de agentic-framework dice que el bloat mata la compliance.

## Qué hacer

Crear un análisis que mapee cada reference a:
- Qué fase la invoca
- Qué problema resuelve
- Si tiene solapamiento con otra reference
- Si es legacy o activa
