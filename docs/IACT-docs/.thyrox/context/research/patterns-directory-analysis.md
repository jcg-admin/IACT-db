```yml
type: Análisis Comparativo
project: IACT-docs
created_at: 2026-04-23 09:20:00
category: Arquitectura de Conocimiento
subject: Diferencia entre .thyrox/discover/patterns/ y .thyrox/context/patterns/
```

# Análisis: `.thyrox/discover/patterns/` vs `.thyrox/context/patterns/`

## Ubicaciones

| Directorio | Ubicación | Propósito |
|------------|-----------|----------|
| **discover** | `.thyrox/discover/patterns/` | Historial de patrones legacy/legacy del framework |
| **context** | `.thyrox/context/patterns/` | Base de conocimiento activa del proyecto actual |

---

## Comparación Estructural

### 1. Cantidad y Contenido

**`.thyrox/discover/patterns/`** (6 patrones — Legacy)
```
adk-model-callback-contract.md        (4.0 KB)
adk-tool-callback-contract.md         (4.4 KB)
hitl-blocking-loop.md                 (7.5 KB)
hitl-interrupt-resume.md              (8.7 KB)
langchain-imports-correct.md          (5.6 KB)
named-mechanism-vs-implementation.md  (8.7 KB)
```

**Temas:** ADK callbacks, HITL loops, LangChain, arquitectura de agentes
**Índice:** SIN README — sin estructura de catalogación
**Denominación:** SIN numeración P-NNN, solo nombres descriptivos

---

**`.thyrox/context/patterns/`** (3 patrones activos + README — Activo)
```
README.md                    (1.9 KB) ← Índice catalógico
bound-explicito-agente.md    (3.3 KB) ← P-002
git-mv-migracion.md          (3.0 KB) ← P-003
validate-wire-test.md        (2.3 KB) ← P-001
```

**Temas:** Bounds en agentes, migraciones git, validación de scripts
**Índice:** CON README — estructura de catalogación formal
**Denominación:** CON numeración P-NNN, referencias documentadas

---

### 2. Estructura Interna

#### `.thyrox/discover/patterns/` — Patrón Legacy

Ejemplo: `adk-model-callback-contract.md`

```markdown
# ADK Model Callback Contract — AP-01

## Anti-patrón
[Código incorrecto]

## Patrón correcto
[Código correcto]

## Ejemplo mínimo ejecutable
[Código de prueba]
```

**Características:**
- Encabezado: Título + ID arbitrario (AP-01, no P-NNN)
- Estructurado: Anti-patrón → Correcto → Ejemplo
- Enfoque técnico profundo (callbacks, mutaciones, retornos)
- SIN metadatos YAML
- Destinado a usuarios (desarrolladores de ADK)
- No vinculado al sistema de conocimiento del proyecto

---

#### `.thyrox/context/patterns/` — Patrón Activo

Ejemplo: `bound-explicito-agente.md`

```yaml
---
id: P-002
nombre: Bound Explícito en Instrucciones de Agente
problema: Instrucciones con alcance ilimitado causan timeouts
categoria: Agentes
origen: FASE 35
fecha: 2026-04-14
---

## Problema
[Descripción del problema]

## Solución (el Patrón)
[Solución general]

## Implementación
[Tabla de bounds por tipo]
[Tipos de bounds]

## Cuándo Aplicar
[Escenarios de uso]

## Alternativas Consideradas
[Por qué no otras opciones]
```

**Características:**
- Metadatos YAML: id (P-NNN), nombre, problema, categoría, origen, fecha
- Estructurado: Problema → Solución → Implementación → Cuándo aplicar
- Enfoque orientado a síntomas (¿cuándo aplicar? ¿por qué?)
- Vinculado al sistema de conocimiento (P-NNN, origen FASE-NNN)
- Destinado a desarrollo interno del proyecto
- Rastreable en el conocimiento del proyecto

---

### 3. Gestión y Ciclo de Vida

#### `.thyrox/discover/patterns/` — Estática

| Aspecto | Estado |
|--------|--------|
| **Creación** | Ad-hoc, cuando se descubre | 
| **Validación** | No formal |
| **Integración** | No vinculada a WPs |
| **Actualización** | Ninguna visible (frozen) |
| **Referencias** | No catalogadas |
| **Reuso** | Manual, búsqueda por nombre |

**Comportamiento:** "Descubrimiento pasivo" — se graba cuando se detecta pero no se gestiona.

---

#### `.thyrox/context/patterns/` — Activa

| Aspecto | Estado |
|--------|--------|
| **Creación** | Formalizado en Phase 6 EXECUTE o Phase 11 TRACK |
| **Validación** | Requiere ≥2 aplicaciones o impacto estratégico |
| **Integración** | Vinculado a WPs, origen FASE-NNN |
| **Actualización** | Versionado implícito (YAML fecha) |
| **Referencias** | Catalogadas en README.md |
| **Reuso** | Sistemático, referencia P-NNN |

**Comportamiento:** "Conocimiento capturado y formalizado" — se documenta cuando es estratégico.

---

## Propósitos Distintos

### `.thyrox/discover/patterns/` — Biblioteca de Referencias Técnicas

**Propósito:**
- Documentar patrones técnicos descubiertos (ADK, HITL, LangChain)
- Servir como referencia para desarrolladores que usan esas tecnologías
- Preservar aprendizajes sobre librerías/frameworks específicos

**Usuario:**
- Desarrollador de la plataforma
- Persona que escribe agentes con ADK

**Esperanza de vida:**
- Permanente (historial)
- Actualizar cuando la librería cambia
- Pero hoy: frozen, no vinculado a WPs

---

### `.thyrox/context/patterns/` — Base de Conocimiento del Proyecto

**Propósito:**
- Capturar soluciones que se repiten en el proyecto
- Educar a la próxima sesión sobre qué funcionó
- Facilitar decisiones rápidas ("¿hemos resuelto esto antes?")

**Usuario:**
- Siguiente fase del WP actual
- Próximos WPs del proyecto
- Sesiones futuras

**Esperanza de vida:**
- Viva durante la ejecución del proyecto
- Crece con cada WP
- Depuración/consolidación en Phase 11 TRACK

---

## Relación Arquitectónica

```
.thyrox/
├── discover/patterns/          ← LEGACY / Historial técnico
│   ├── adk-*.md               (del framework ADK)
│   ├── hitl-*.md              (del framework HITL)
│   └── langchain-*.md         (referencias técnicas)
│
└── context/
    ├── patterns/              ← ACTIVA / Base de conocimiento del proyecto
    │   ├── README.md          (catálogo formal)
    │   ├── P-001-*.md         (validación)
    │   ├── P-002-*.md         (bounds en agentes)
    │   └── P-003-*.md         (migraciones)
    │
    └── work/
        └── {WP}/
            └── lessons-learned.md  (fuente primaria de patrones)
```

**Flujo:**
```
Lección descubierta en un WP
         ↓
lessons-learned.md (Phase 11 TRACK)
         ↓
¿Se repitió ≥2 veces o tiene impacto estratégico?
         ↓
SÍ → Promover a context/patterns/ como P-NNN
NO  → Mantener en lessons-learned.md del WP
```

---

## Recomendación de Uso

### Para IACT-docs ÉPICA 1

**`.thyrox/discover/patterns/` — Consultar pero NO modificar**
- Usar como referencia técnica si necesitas patrones ADK o HITL
- Pero estos patrones no son específicos del proyecto IACT-docs
- Son legacy del framework original

**`.thyrox/context/patterns/` — Mantener activo**
- Crear P-004, P-005, etc. cuando se detecten patrones en IACT-docs
- Después de Phase 3 DIAGNOSE: ¿hay patrones en cómo se resuelven los hallazgos?
- Después de Phase 5 STRATEGY: ¿hay patrones en cómo se diseña la remediación?
- Al cerrar el WP (Phase 11 TRACK): formalizar lecciones como patrones

---

## Decisión Necesaria

**¿Qué hacer con `.thyrox/discover/patterns/`?**

| Opción | Acción | Impacto |
|--------|--------|--------|
| A | Mantener "as-is" (historial) | Legacy congelado, no confunde proyecto actual |
| B | Mover a `context/research/legacy-patterns/` | Clarifica que son referencias, no activos |
| C | Revisar y promover relevantes a `context/patterns/` | Integra ADK/HITL patterns si se usan en IACT-docs |

**Recomendación:** Opción B (mover a research/) — deja claro que es historial técnico, no parte de la base de conocimiento activa del proyecto.

---

**Conclusión:**

Ambos directorios coexisten con propósitos distintos:
- **discover/** = Biblioteca técnica histórica (congelada)
- **context/** = Base de conocimiento viva del proyecto (crece con WPs)

No hay conflicto; son capas distintas. Pero requiere comunicación clara en la documentación.

---

**Ubicación de este análisis:** `.thyrox/context/research/patterns-directory-analysis.md`  
**Fecha:** 2026-04-23  
**Impacto:** Aclaración arquitectónica, sin cambios urgentes
