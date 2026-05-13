```yml
type: Reference
title: Context Engineering
category: Desarrollo — Metodología
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: La disciplina de llenar el context window con la información correcta en el momento correcto
```

# Context Engineering

> La disciplina de llenar el context window con la información correcta en el momento correcto.
> — Andrej Karpathy
>
> **Fuente:** `guide/core/context-engineering.md` (claude-code-ultimate-guide)

## Qué es context engineering

**Prompt engineering** es la habilidad de formular bien una pregunta para una tarea específica.
**Context engineering** es el sistema que asegura que Claude tenga el conocimiento de fondo correcto antes de que comience cualquier tarea.

| Dimensión | Prompt Engineering | Context Engineering |
|-----------|-------------------|---------------------|
| Alcance | Una solicitud | Sesión completa o sistema |
| Duración | Interacción singular | Persistente entre interacciones |
| Esfuerzo | Por solicitud | Diseño de sistema upfront |
| Artefacto | Un string de prompt | Un sistema de configuración |

> **Regla de diagnóstico:** la mayoría de fallas de output de AI son fallas de contexto, no del modelo. Cuando Claude produce una respuesta genérica, ignora una convención o genera código fuera del stack — el modelo casi nunca está roto. El contexto que recibió estaba incompleto, contradictorio o le faltaba la información correcta.

---

## Por qué el context rot es estructural

Los transformers atienden todos los tokens en pares. El número de relaciones de atención crece como **n²**, no n. Duplicar la longitud del contexto cuadruplica el número de relaciones que el modelo debe ponderar.

**Implicación:** no se puede resolver context rot confiando en una ventana más grande. Se resuelve manteniendo el contexto lean y cargando información justo a tiempo.

---

## Presupuesto de tokens

### Regla del 5%

El contexto always-on (CLAUDE.md + módulos siempre activos) debe quedar **por debajo del 5%** del context window. Más allá desplaza contenido de tarea real, que importa más por token que instrucciones permanentes.

Baseline de referencia para un proyecto mid-size:

| Fuente | Tokens típicos |
|--------|----------------|
| CLAUDE.md global | 1,000 – 3,000 |
| CLAUDE.md de proyecto (root) | 2,000 – 8,000 |
| Módulos path-scoped (todos activos) | 1,000 – 5,000 |
| Skills / commands importados | 500 – 3,000 |
| **Total always-on** | **~5,000 – 20,000** |

### El techo de las 150 instrucciones

Más allá de ~150 reglas distintas, los modelos comienzan a ignorar selectivamente algunas. El mecanismo es **difusión de atención**: con cientos de constraints potencialmente relevantes, la atención se divide. Las reglas de alta saliencia (recientes, formuladas con fuerza, al inicio) desplazan a las de baja saliencia.

> **Dato empírico (HumanLayer):** equipos con contexto estructurado — pocas reglas específicas, organizadas jerárquicamente — ven 15-25% mejor adherencia que equipos con listas de reglas largas sin diferenciación.

**Calidad de regla > cantidad de reglas.** 20 reglas específicas y accionables superan a 200 genéricas y aspiracionales.

### Degradación de adherencia por tamaño

```
Líneas en CLAUDE.md    Adherencia (estimado)
─────────────────     ─────────────────────
1 – 100               ~95%
100 – 200             ~88%
200 – 400             ~75%
400 – 600             ~60%
600+                  ~45% y cayendo
```

Path-scoping puede mantener adherencia alta a mayor count total de reglas, porque solo las reglas relevantes están en contexto en cada momento.

### Señales de context overload

- **Rule silencing:** Claude sigue el 80% de convenciones consistentemente pero ignora reglas específicas que deberían aplicar
- **Comportamiento contradictorio:** aplica una regla en algunos archivos pero no en otros
- **Primeras respuestas lentas:** mayor latencia en tareas simples
- **Outputs genéricos:** Claude ignora patrones específicos del proyecto y vuelve a best practices genéricas

Cuando aparecen estos patrones: hacer context audit, **no agregar más instrucciones**.

---

## Jerarquía de configuración

Las tres capas:

```
┌──────────────────────────────────────────────┐
│  Global (~/.claude/CLAUDE.md)                │
│  Identidad, tono, herramientas universales,  │
│  convenciones cross-proyecto                 │
├──────────────────────────────────────────────┤
│  Proyecto (./CLAUDE.md + módulos path-scope) │
│  Decisiones de arquitectura, convenciones    │
│  de stack, reglas de equipo                  │
├──────────────────────────────────────────────┤
│  Sesión (instrucciones inline, flags)        │
│  Overrides ad-hoc, parámetros de tarea,      │
│  experimentos temporales                     │
└──────────────────────────────────────────────┘
```

Las capas posteriores override las anteriores. Sesión > Proyecto > Global.

### Árbol de decisión: ¿dónde va esta regla?

```
¿Esta regla aplica a TODOS mis proyectos?
├── Sí → CLAUDE.md global
└── No ↓

¿Esta regla aplica a archivos/subsistemas específicos?
├── Sí → Módulo path-scoped (src/api/CLAUDE-api.md)
└── No ↓

¿Esta regla aplica a todo el proyecto?
├── Sí → CLAUDE.md del proyecto (root)
└── No ↓

¿Aplica solo a esta tarea o sesión?
├── Sí → Instrucción inline de sesión
└── No → Revisar: ¿es realmente una regla?
```

### Altitud correcta de una regla

| Altitud | Ejemplo | Veredicto |
|---------|---------|-----------|
| Demasiado vaga | "Escribe código limpio" | Cortar — el modelo la ignora |
| Demasiado vaga | "Sigue best practices de seguridad" | Cortar — reemplazar con constraints específicos |
| Correcta | "Nunca exponer IDs raw de DB en respuestas API; usar UUIDs" | Conservar — específica, el modelo haría otra cosa |
| Correcta | "Usar el patrón Result<T, E> para funciones de servicio, no try/catch" | Conservar — override de un default común |
| Demasiado granular | "Usar indentación de 2 espacios" | Cortar — delegar a Prettier |
| Demasiado granular | "Agregar JSDoc a cada función" | Cortar — delegar a lint rule |

**Test:** "¿Claude, sin contexto de proyecto, haría razonablemente algo diferente aquí?" Si sí → la regla pertenece a CLAUDE.md. Si es aspiracional → cortar. Si un linter la enforcea → cortar.

---

## Path-scoping — técnica clave

**Mecanismo:** Claude Code soporta imports `@path/to/file.md` en CLAUDE.md. Las reglas de ese módulo se agregan al contexto solo cuando los archivos bajo ese path están en scope.

**Resultado típico:**

```
Sin path-scoping:
  Always-on: root CLAUDE.md con reglas backend + frontend + database + API = 8,000 tokens

Con path-scoping:
  Always-on: root CLAUDE.md con reglas compartidas = 2,000 tokens
  Activo en src/api/: módulo api = +1,500 tokens
  Activo en src/components/: módulo frontend = +1,200 tokens
  Activo en prisma/: módulo database = +800 tokens
```

**Reducción del 40-50% en contexto always-on, sin pérdida de cobertura.**

Estructura de archivos:
```
project/
├── CLAUDE.md                     # Reglas compartidas + @imports
├── src/
│   ├── api/
│   │   └── CLAUDE-api.md         # Reglas específicas de API
│   ├── components/
│   │   └── CLAUDE-components.md  # Reglas de React/UI
│   └── lib/
│       └── CLAUDE-lib.md
├── prisma/
│   └── CLAUDE-db.md
└── tests/
    └── CLAUDE-tests.md
```

---

## Reglas vs. Skills

| Dimensión | Reglas | Skills |
|-----------|--------|--------|
| Naturaleza | Constraints, estándares, convenciones | Capacidades, procedimientos, workflows |
| Cuándo activas | Siempre enforceadas | Invocadas on-demand |
| Ejemplo | "Nunca usar `any` en TypeScript" | "Cómo agregar un nuevo API endpoint" |
| Ubicación | CLAUDE.md | `.claude/skills/` |
| Costo de tokens | Always-on | Cargadas solo cuando se invocan |

**Regla:** `"Los endpoints de API deben tener validación Zod."`
**Skill:** `"Aquí está el patrón paso a paso para crear un endpoint en este proyecto, incluyendo el schema Zod, el wrapper de error handling, el middleware de auth, y la estructura del archivo de test."`

El procedimiento de creación de endpoint en una regla → 40 líneas de instrucciones procedurales para cada sesión, aunque no estés creando endpoints. En un skill → 40 líneas cargadas solo cuando se crea un endpoint.

---

## Límites del ecosistema MCP

MCP servers inyectan definiciones de herramientas en el system prompt. Recomendación de Anthropic:

- **Menos de 10 MCP servers** activos por proyecto
- **Menos de 80 herramientas totales** entre todos los servers activos

Con 80+ herramientas, se queman 15-20K tokens en tool schemas solos — budget que de otro modo iría a contenido de código, historial de conversación y contenido de archivos.

El principio de progressive disclosure aplica a MCP servers: no activar todos los servers disponibles "por si acaso". Si un server se usa en menos del 20% de las sesiones de un proyecto, no debe estar en la configuración default.

---

## Anti-patrón: el CLAUDE.md monolítico

Un CLAUDE.md de 600 líneas sin estructura es el failure mode más común en producción:

- Las reglas 1-20 reciben ~95% de peso de atención; las reglas 500+ reciben ~30%
- Reglas de frontend y backend se mezclan — cada dev lee reglas que no le aplican
- Agregar una regla nueva requiere escanear todo el archivo por conflictos
- La adherencia se degrada continuamente

**Fix:**
1. Extraer reglas por dominio a módulos path-scoped
2. Conservar el root CLAUDE.md para reglas compartidas + declaraciones de import
3. Mover conocimiento procedimental a skills
4. Target: root CLAUDE.md bajo 150 líneas tras la extracción

---

## Cuándo aplicar cada técnica

| Síntoma | Técnica |
|---------|---------|
| Reglas ignoradas en algunos archivos | Path-scoping — las reglas no deben ser always-on |
| Adherencia del ~60% con 400+ líneas | Refactor a módulos; cortar reglas aspiracionales |
| Primeras respuestas lentas en tareas simples | Context audit — demasiado always-on |
| Claude ignora patrones del proyecto | Las reglas están en la zona de "too vague"; reformular |
| Costos altos sin uso intensivo | MCP tool count — revisar servers activos |

---

## Referencias relacionadas

- [memory-hierarchy](memory-hierarchy.md) — Los 8 niveles de memoria en Claude Code
- [claude-authoring](claude-authoring.md) — Cuándo y cómo crear CLAUDE.md (jerarquía, @imports)
- [skill-authoring](skill-authoring.md) — Crear o mejorar skills
- [long-context-tips](long-context-tips.md) — Tácticas para documentos >5,000 palabras
