```yml
id: ERR-023
created_at: 2026-03-28
type: Confusión estructural
severity: Crítica
status: Detectado
```

# ERR-023: Confusión sobre estructura del flujo de trabajo

## Qué pasó

Múltiples confusiones acumuladas:

1. **Work-logs:** Definimos que son "por sesión" pero nunca definimos qué es una sesión. ¿Es toda la conversación? ¿Cada ciclo de 7 fases? ¿Cada día?

2. **Epics no usados:** Definimos context/epics/ para trabajo planificado pero pusimos TODO en context/analysis/ (18+ archivos sueltos mezclando análisis con planes, strategies, structures, y tasks).

3. **El SKILL es el producto:** Nuestro SKILL.md es lo que estamos construyendo. Estamos en paso 6 (Iterate) del Skill Creation Process de Anthropic. Pero usamos nuestro propio SKILL (el producto) para gestionar el proceso de mejorarlo. Es circular.

4. **Analysis/ se convirtió en cajón de sastre:** covariance-analysis.md, covariance-solution-strategy.md, covariance-tasks.md, spec-kit-comparison.md, spec-kit-adoption-strategy.md, spec-kit-adoption-tasks.md... estos no son "análisis" — son fases de trabajo que deberían estar en epics/.

## La confusión de fondo

Estamos usando el SKILL (paso 6: iterate) para mejorar el SKILL. Cada "mejora" genera un ciclo de 7 fases que produce archivos en analysis/ en vez de epics/. Los work-logs no se actualizan porque no hay clarity sobre cuándo hacerlo.

## Preguntas sin resolver

1. ¿Un work-log cubre toda una conversación con Claude, o cada epic tiene su propio work-log?
2. ¿Los ciclos de correcciones (covariancia, spec-kit, etc.) son epics o analysis?
3. ¿Cómo se organiza el trabajo cuando el producto Y el proceso son el mismo SKILL?
4. ¿El flujo de sesión (CLAUDE.md) y el flujo de fases (SKILL.md) son lo mismo o diferentes?

## Lo que debería pasar antes de seguir

PARAR de agregar features. Definir claramente:
- Qué es una sesión vs un ciclo vs un epic
- Cuándo se crea/actualiza cada artefacto
- Cómo se organiza analysis/ vs epics/
- Resolver la circularidad del SKILL mejorándose a sí mismo
