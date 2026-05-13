```yml
type: Mejores Prácticas Anthropic
category: Prompting
version: 1.0
purpose: Compilación de mejores prácticas de Anthropic para escribir prompts efectivos con Claude 4.5.
goal: Maximizar calidad de respuestas de Claude con prompts bien estructurados.
updated_at: 2026-03-25
owner: thyrox (cross-phase)
```

# Prompting Tips - Mejores Prácticas para Claude 4.5

## Propósito

Compilación de mejores prácticas de Anthropic para escribir prompts efectivos con Claude 4.5.

> Objetivo: Maximizar calidad de respuestas de Claude con prompts bien estructurados.

---

Basado en: Anthropic Prompting Best Practices
Adaptado para: THYROX
Fecha: 2026-02-01

---

## Tabla de Contenidos

- [Principios Generales](#principios-generales)
- [Long-Horizon Reasoning](#long-horizon-reasoning)
- [Context Awareness](#context-awareness)
- [State Management](#state-management)
- [Communication Style](#communication-style)
- [Tool Usage Patterns](#tool-usage-patterns)
- [Trabajar con Documentos Largos](#trabajar-con-documentos-largos)
- [Iteración y Refinamiento](#iteracion-y-refinamiento)
- [Casos de Uso Específicos ADT](#casos-de-uso-especificos-adt)
- [Resumen de Principios](#resumen-de-principios)

---


## Principios Generales

### 1. Ser Explícito con Instrucciones

Claude responde mejor a instrucciones claras y específicas.

**Vago (EVITAR)**:
```
Ayúdame con este archivo RST.
```

**Explícito (MEJOR)**:
```
Revisar source/architecture/section-10.rst y:
1. Corregir referencias rotas
2. Validar sintaxis RST
3. Verificar que todos los labels están definidos
```

**Por qué funciona mejor**: Claude sabe exactamente qué hacer, en qué archivo, y qué validar.

---

### 2. Agregar Contexto Relevante

Proveer contexto que Claude no tiene acceso de otra forma.

**Sin contexto (EVITAR)**:
```
Traducir este documento.
```

**Con contexto (MEJOR)**:
```
Traducir este documento de architecture docs section 9 (Architecture Decisions) de inglés a español.

Contexto:
- Es documentación técnica de arquitectura de software
- Audiencia: desarrolladores y arquitectos
- Debe preservar terminología técnica en inglés cuando apropiado
- Seguir modo Alta Fidelidad del translation-workflow skill

Documento:
[contenido...]
```

**Qué contexto incluir**:
- Tipo de documento y propósito
- Audiencia objetivo
- Convenciones o restricciones específicas
- Relación con otros documentos/partes del proyecto

---

### 3. Usar Lenguaje Fuerte para Requisitos Críticos

Para requisitos no negociables, usar lenguaje imperativo.

**Débil**:
```
Sería bueno si pudieras evitar modificar los labels existentes.
```

**Fuerte**:
```
NO modificar labels existentes bajo ninguna circunstancia.
Crear nuevos labels si es necesario, pero NUNCA cambiar los existentes.
```

**Palabras efectivas**:
- SIEMPRE, NUNCA
- DEBE, NO DEBE
- REQUERIDO, PROHIBIDO
- CRÍTICO, OBLIGATORIO

Usar solo para requisitos genuinamente críticos. Uso excesivo diluye efectividad.

---

## Long-Horizon Reasoning

Claude 4.5 puede razonar a través de tareas largas y complejas cuando se le da espacio.

### Permitir Tiempo de Pensamiento

No forzar respuestas inmediatas para problemas complejos.

**Efectivo**:
```
Analizar este build output de Sphinx (230 warnings).

Primero, categorizar todos los warnings por tipo.
Luego, identificar patterns recurrentes.
Finalmente, proponer estrategia de corrección en lotes.

Tómate el tiempo necesario para hacer análisis exhaustivo.
```

Claude trabará paso a paso, pensando a través del problema antes de proponer solución.

---

### Pedir Razonamiento Paso a Paso

Solicitar que Claude muestre su trabajo.

**Sin razonamiento**:
```
¿Cuál es la mejor estrategia para corregir estos 230 warnings?
```

**Con razonamiento**:
```
Analizar estos 230 warnings y proponer estrategia de corrección.

Razonar paso a paso:
1. ¿Qué tipos de warnings hay?
2. ¿Cuáles son más frecuentes?
3. ¿Hay patterns que sugieren corrección en batch?
4. ¿Cuál es el orden lógico de corrección?
5. Basado en 1-4, ¿cuál es la mejor estrategia?

Mostrar razonamiento antes de proponer estrategia final.
```

Ver el razonamiento de Claude ayuda a validar la propuesta y aprender de su approach.

---

## Context Awareness

Claude 4.5 tiene mayor awareness del contexto disponible.

### Token Budget Awareness

Claude sabe cuánto contexto tiene disponible y puede auto-gestionar.

**Ejemplo - ADT**:
```
Analizar este documento largo de architecture docs (15,000 palabras).

Nota: Este documento es grande. Si necesitas, puedes:
- Pedir que te comparta secciones específicas
- Procesar en chunks si eso ayuda
- Decirme si necesitas el documento estructurado diferente

Prioridad: Análisis exhaustivo y preciso sobre rapidez.
```

Claude puede sugerir estrategias para manejar el documento efectivamente.

---

### Multi-Window Context Management

Claude puede trabajar con múltiples "ventanas" de contexto en conversaciones largas.

**Patrón efectivo - Ejemplo práctico**:
```
Tengo 3 documentos relacionados para revisar:

1. source/architecture/section-05.rst (Building Block View)
2. source/architecture/section-06.rst (Runtime View)
3. source/architecture/section-07.rst (Deployment View)

Plan de trabajo:
- Primero, revisaremos section-05 en detalle
- Luego, section-06 con cross-references a section-05
- Finalmente, section-07 asegurando consistencia con ambos previos

¿Listo para empezar con section-05?
```

Este approach reconoce que Claude puede mantener contexto a través de múltiples pasos.

---

## State Management

### JSON para Estructura, Texto para Progreso

Usar JSON para tracking de estado estructurado, texto para updates de progreso.

**Ejemplo - Corrección Incremental ADT**:

```markdown
Trabajaremos en corrección de 230 warnings en 5 lotes.

Estado inicial (NO modificar este JSON):
```json
{
  "total_warnings": 230,
  "lotes": [
    {"id": 1, "tipo": "referencias_rotas", "count": 80, "status": "pendiente"},
    {"id": 2, "tipo": "duplicate_labels", "count": 60, "status": "pendiente"},
    {"id": 3, "tipo": "toctree_issues", "count": 40, "status": "pendiente"},
    {"id": 4, "tipo": "syntax_rst", "count": 30, "status": "pendiente"},
    {"id": 5, "tipo": "otros", "count": 20, "status": "pendiente"}
  ]
}
```

Cuando completemos cada lote, actualizaré el JSON y daré update en texto.

Comenzar con Lote 1.
```

**Durante progreso**:
```
Lote 1 completado. Aquí está el update:

```json
{
  "total_warnings": 230,
  "lotes": [
    {"id": 1, "tipo": "referencias_rotas", "count": 80, "status": "completado", "resueltos": 78},
    {"id": 2, "tipo": "duplicate_labels", "count": 60, "status": "en_progreso"},
    ...
  ]
}
```

Progreso textual:
- Lote 1: Resueltos 78 de 80 warnings (2 requieren investigación adicional)
- Archivos modificados: 15 archivos .rst
- Build status: PASS+
- Commit: feat(docs): fix broken references in sections 1-5

Continuando con Lote 2...
```

JSON mantiene estado preciso, texto comunica progreso y contexto.

---

### Checkpoints en Tareas Largas

Establecer puntos de verificación naturales.

**Ejemplo - Traducción ADT**:
```
Vamos a traducir architecture docs section 10 (Quality Requirements).
Este documento tiene ~5000 palabras.

Checkpoints:
- Después de traducir "Quality Tree" (subsección 1)
- Después de traducir "Quality Scenarios" (subsección 2)
- Al final, revisión completa

En cada checkpoint:
1. Validaré calidad de traducción
2. Confirmaré preservación de terminología
3. Verificaré consistency con glossary
4. Darás OK para continuar o ajustes necesarios

¿Listo para empezar con Quality Tree?
```

Checkpoints dan oportunidad de corregir curso antes de invertir mucho trabajo.

---

## Communication Style

### Adaptar Tono al Contexto

Claude puede ajustar formalidad según la audiencia.

**Técnico/Formal - Documentación ADT**:
```
Generar documentación para la sección de Arquitectura.

Tono: Formal, técnico
Audiencia: Arquitectos de software senior
Estilo: Preciso, conciso, con terminología técnica apropiada
Formato: architecture documentation standard
```

**Conversacional - Explicaciones**:
```
Explicar cómo funciona la metodología de corrección incremental.

Tono: Conversacional pero profesional
Audiencia: Desarrolladores que la usarán por primera vez
Estilo: Claro, con ejemplos, paso a paso
Formato: Tutorial guiado
```

Especificar tono ayuda a Claude calibrar el estilo de respuesta.

---

### Feedback sobre Estilo

Si el estilo no es el esperado, dar feedback específico.

**Feedback genérico (menos útil)**:
```
Este texto no está bien. Hazlo mejor.
```

**Feedback específico (más útil)**:
```
Este texto es demasiado formal para nuestro glossary.

Ajustes necesarios:
- Usar segunda persona ("puedes") en lugar de tercera persona
- Acortar oraciones (promedio actual: 30 palabras, objetivo: 15)
- Agregar un ejemplo concreto por término
- Reducir uso de terminología académica

Re-escribir con estos ajustes.
```

---

## Tool Usage Patterns

### Cuándo Usar Computer Tools

Claude puede decidir cuándo usar computer tools para completar tareas.

**Guía efectiva - ADT**:
```
Revisar y corregir warnings en source/architecture/section-08.rst

Puedes usar cualquier herramienta que necesites:
- Ver el archivo para entender estructura
- Ejecutar build para verificar changes
- Editar el archivo directamente
- Buscar en otros archivos si necesitas referencias

Workflow sugerido:
1. Ver archivo actual
2. Identificar warnings
3. Hacer correcciones
4. Validar con build
5. Reportar resultados

Proceder con el approach que consideres mejor.
```

Dar libertad a Claude para elegir herramientas apropiadas.

---

### Proveer Contexto de Archivo/Directorio

Cuando trabajas con archivos, especificar ubicación exacta.

**Sin contexto**:
```
Editar el archivo de configuración.
```

**Con contexto**:
```
Editar /tmp/ADT/source/conf.py (archivo de configuración de Sphinx).

Cambios necesarios:
- Actualizar version = '2.0.0' 
- Agregar 'sphinx.ext.todo' a extensions

Archivo está en la raíz del proyecto ADT.
```

Ubicación exacta y contexto del archivo ayudan a Claude trabajar con confianza.

---

## Trabajar con Documentos Largos

### Data at Top, Query at End

Para documentos largos, estructura importa.

**Estructura óptima**:
```
Aquí está el documento completo de architecture docs section 10 para traducir:

<documento>
[contenido completo del documento - 5000 palabras]
</documento>

Instrucciones:
Traducir el documento de inglés a español usando modo Alta Fidelidad.
Preservar toda la estructura, labels y referencias.
Mantener terminología técnica en inglés donde apropiado.
```

**Por qué funciona**: Claude procesa el documento primero, luego ve las instrucciones con todo el contexto ya cargado.

---

### Usar XML Tags para Estructura

XML tags ayudan a Claude encontrar secciones específicas en documentos grandes.

**Ejemplo - ADT**:
```
Aquí está el documento de architecture docs dividido en secciones:

<section id="introduction">
[Contenido de Introduction and Goals]
</section>

<section id="constraints">
[Contenido de Architecture Constraints]
</section>

<section id="context">
[Contenido de Context and Scope]
</section>

Instrucciones:
Revisar la sección <section id="constraints"> y:
1. Verificar que todas las constraints están documentadas
2. Validar referencias cruzadas
3. Sugerir mejoras a claridad
```

Claude puede navegar fácilmente a la sección relevante.

---

### Ground Responses in Quotes

Para análisis de documentos largos, pedir que Claude cite el texto original.

**Ejemplo - ADT**:
```
Analizar este documento de architecture docs section 9 (Architecture Decisions).

Para cada decisión identificada:
1. Citar el texto exacto del documento
2. Explicar la decisión en tus palabras
3. Evaluar si está bien documentada

Formato:
**Decisión X**:
> [cita textual del documento]

Análisis: [tu evaluación]
Calidad de documentación: [Alta/Media/Baja]
```

Citas aseguran que análisis está basado en contenido real del documento.

---

## Iteración y Refinamiento

### Refinar Outputs Incrementalmente

No esperar perfección en primer intento.

**Workflow iterativo - ADT**:
```
# Iteración 1: Draft inicial
Crear primer draft de traducción de architecture docs section 10.

# Iteración 2: Revisión técnica
Revisar traducción y validar:
- Terminología técnica correcta
- Consistency con glossary existente
- Preservación de estructura

# Iteración 3: Pulido final
Afinar:
- Fluidez de lectura
- Transitions entre secciones
- Coherencia de estilo
```

Cada iteración refina un aspecto diferente.

---

### Dar Feedback Específico

Cuando el output no es el esperado, identificar exactamente qué ajustar.

**Feedback específico**:
```
La traducción está bien excepto por 3 issues:

1. Línea 45: "Design decisions" → debería ser "Decisiones de diseño" 
   (no "Decisiones de arquitectura")

2. Sección 2.3: Falta preservar el label original `.. _quality-tree:`

3. Tabla en línea 120: Headers de tabla no están traducidos

Corregir estos 3 issues específicos, mantener todo lo demás igual.
```

---

## Casos de Uso Específicos ADT

### Análisis de Build Sphinx

```
Ejecutar análisis de build de Sphinx:

```bash
make clean && make html 2>&1 | tee build-output.txt
```

Una vez ejecutado:
1. Categorizar todos los warnings por tipo
2. Identificar los 10 archivos con más warnings
3. Proponer estrategia de corrección en lotes
4. Estimar tiempo por lote

Mostrar razonamiento paso a paso antes de la propuesta final.
```

---

### Traducción de Documentación Técnica

```
Traducir architecture docs section 5 (Building Block View) de inglés a español.

Contexto del proyecto:
- Documentación de arquitectura de software
- Audiencia: Desarrolladores y arquitectos hispanohablantes
- Debe integrarse con otras secciones ya traducidas

Modo: Alta Fidelidad
- Preservar 100% de estructura
- Mantener todos los labels y referencias
- Preservar terminología técnica en inglés cuando es estándar de industria
- Consultar glossary.md para términos ya establecidos

Workflow:
1. Procesar sección por sección
2. Checkpoint después de cada subsección mayor
3. Validación final de consistency

¿Listo para comenzar con la primera subsección?
```

---

### Corrección Incremental de Issues

```
Vamos a corregir 230 warnings de Sphinx en lotes incrementales.

Contexto:
- Build actualmente tiene 230 warnings
- Ya hice análisis completo (ver analysis-phase.md adjunto)
- Estrategia: 5 lotes por tipo de warning

Estado de trabajo:
```json
{
  "total": 230,
  "completados": 0,
  "en_progreso": 0,
  "pendientes": 230
}
```

Workflow por lote:
1. Corregir issues del lote
2. Validar con make html
3. Si build pasa → commit y continuar
4. Si build falla → revertir y ajustar
5. Actualizar estado JSON

Comenzar con Lote 1: Referencias rotas (80 warnings).
```

---

## Resumen de Principios

### General
1. **Ser explícito** - Instrucciones claras y específicas
2. **Agregar contexto** - Info que Claude no tiene
3. **Lenguaje fuerte** - Para requisitos críticos

### Reasoning
4. **Permitir tiempo** - No forzar respuestas inmediatas
5. **Pedir razonamiento** - Mostrar trabajo paso a paso

### Context
6. **Token awareness** - Claude puede auto-gestionar
7. **Multi-window** - Mantener contexto a través de pasos

### State
8. **JSON + texto** - Estructura en JSON, progreso en texto
9. **Checkpoints** - Puntos de verificación naturales

### Communication
10. **Adaptar tono** - Según audiencia y contexto
11. **Feedback específico** - Qué ajustar exactamente

### Tools
12. **Libertad de herramientas** - Claude elige apropiadas
13. **Contexto de archivos** - Ubicación exacta y propósito

### Documentos Largos
14. **Data at top** - Documento primero, query después
15. **XML tags** - Estructura con tags semánticos
16. **Ground en quotes** - Citar texto original

### Iteración
17. **Refinar incrementalmente** - Perfección en múltiples pases
18. **Feedback específico** - Issues concretos a corregir

---

**Documento basado en**: Anthropic Prompting Best Practices
**Adaptado para**: THYROX con ejemplos Sphinx, architecture docs, RST
**Fecha**: 2026-02-01
**Ver también**: skill-authoring.md, long-context-tips.md
