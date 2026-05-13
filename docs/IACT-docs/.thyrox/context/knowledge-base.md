```yml
type: Índice de Base de Conocimiento
project: IACT-docs
version: 1.0.0
created_at: 2026-04-23 08:50:00
updated_at: 2026-04-23 08:50:00
```

# Base de Conocimiento — IACT-docs

Índice del sistema de gestión de conocimiento para el proyecto IACT-docs. El conocimiento generado durante ejecución se captura en estructura formal para que persista entre sesiones.

---

## El Problema que Resuelve

Cuando se descubre algo importante durante ejecución:
- ¿Alguien lo documenta?
- ¿La próxima sesión lo sabe?
- ¿En 6 meses, recordaremos el "por qué" de la decisión?

Sin gestión de conocimiento:
- Decisiones técnicas quedan implícitas en commits
- Errores se repiten
- El contexto se pierde en compactación de sesiones

---

## Estructura de la Base de Conocimiento — IACT-docs

```
.thyrox/context/
├── decisions/                     ← ADRs del PROYECTO IACT-docs
│   └── adr-*.md                   → Decisiones específicas del proyecto
│
├── knowledge-base.md              ← Este archivo
├── technical-debt.md              ← TDs específicos del proyecto
├── focus.md                       ← WP y fases actuales
└── work/                          ← WPs completados
    └── YYYY-MM-DD-*/
        ├── */lessons-learned.md   ← Lecciones del WP
        └── *-risk-register.md     ← Riesgos identificados
```

**Capas:**

| Layer | Qué contiene | Propósito | Tiempo de vida |
|-------|-------------|----------|----------------|
| **ADRs** (`decisions/`) | Decisiones arquitectónicas permanentes | ¿Por qué elegimos X sobre Y? | Inmutable |
| **TDs** (`technical-debt.md`) | Problemas conocidos + criterios de resolución | Backlog de trabajo pendiente | Hasta resolución |
| **WP lessons** (`work/*/lessons-learned.md`) | Aprendizajes de cada WP | Captura de contexto por iniciativa | Permanente (archivo) |

---

## IACT-docs Knowledge Base — Métricas Actuales

### Decisiones (ADRs)

Ubicación: `.thyrox/context/decisions/`

**Status:**
- **Totales:** 0 (a crear)
- **Aprobadas:** 0
- **Pendientes:** 1 (`adr-sensitive-info-policy` — TD-002)

**ADRs necesarios para IACT-docs:**
1. `adr-sensitive-info-policy` — Política de información sensible (Pendiente)
2. `adr-sphinx-configuration` — Decisiones sobre configuración Sphinx (A crear)
3. `adr-documentation-structure` — Estructura de documentación en source/ (A crear)

### Lecciones Aprendidas (L-NNN)

Ubicación: `.thyrox/context/work/{WP}/lessons-learned.md` (agregadas de ahí a índice global)

**Status:**
- **Totales:** 0 (esperar Phase 1 cierre)
- **Próximas:** Lecciones de config-review-iact-docs se agregarán al cerrar WP

**Lecciones esperadas de Phase 1 DISCOVER:**
- L-001: No commitear información sensible (RBAC, restricciones de sistema)
- L-002: Validar configuración Sphinx before pushing
- L-003: Documentar decisiones antes de implementación

### Patrones (P-NNN)

Ubicación: `.thyrox/context/work/{WP}/lessons-learned.md` (agregadas si se repiten)

**Status:**
- **Totales:** 0 (requiere 2+ ocurrencias)
- **Candidatos:** Patrones de seguridad en IACT-docs

### Errores Registrados (ERR-NNN)

Ubicación: `.thyrox/context/errors/`

**Status:**
- **Totales:** 0 (recién creado)
- **Esperados:** Errores de TD-001 (information disclosure)

---

## Framework Knowledge Base (referencia heredada)

El framework THYROX mantiene su propia knowledge base con:
- 20 ADRs de framework
- 4+ Lessons sobre desarrollo del framework
- 3+ Patterns detectados
- 16 ERRs registrados
- ~35 WPs con lessons-learned

**Nota:** Esa información está en el framework repo, no aquí. IACT-docs mantiene su propia base de conocimiento separada.

---

## Proceso de Captura — IACT-docs

```
Evento ocurre durante ejecución
        │
        ▼
¿Es decisión arquitectónica del proyecto?
  Sí → ADR en decisions/adr-{tema}.md (requiere aprobación)
  No  ↓
¿Es problema/error identificado?
  Sí → TD en technical-debt.md + ERR en errors/ (si crítico)
  No  ↓
¿Es lección aprendida?
  Sí → work/{WP}/lessons-learned.md (al cerrar WP)
  No  ↓
¿Es patrón recurrente (≥2 veces)?
  Sí → P-NNN cuando se detecta recurrencia
  No  → Probablemente no necesita captura formal
```

---

## Nomenclatura de IACT-docs

| Tipo | Formato | Ejemplo | Ubicación |
|------|---------|---------|-----------|
| ADR | `adr-{tema}.md` | `adr-sensitive-info-policy.md` | `decisions/` |
| Lección | `L-NNN-descripcion.md` | `L-001-no-sensitive-in-git.md` | WP o `work/*/lessons-learned.md` |
| Patrón | `P-NNN-nombre.md` | `P-001-sphinx-extension-pattern.md` | WP o agregado global |
| Error | `ERR-NNN-descripcion.md` | `ERR-001-git-history-leak.md` | `errors/` |
| Deuda Técnica | `TD-NNN` | `TD-001` (en technical-debt.md) | `technical-debt.md` |

Los NNN son secuenciales por tipo, independientes entre sí.

---

## Cuándo Documentar Qué

| Evento | Artefacto | Timing | Owner |
|--------|-----------|--------|-------|
| Decisión arquitectónica permanente | ADR | Inmediato (Phase 1-2) | Project architect |
| Problema identificado | TD en technical-debt.md | Al descobrir | Discoverer |
| Problema resuelto | L-NNN en WP lessons | Al resolver | Resolver |
| Patrón exitoso (≥2 veces) | P-NNN | Al detectar recurrencia | Pattern spotter |
| Lección del WP completo | WP/lessons-learned.md | Phase 11 TRACK | WP executor |

---

## Próximos Pasos

**Immediate (Phase 1 DISCOVER cierre):**
1. Crear `adr-sensitive-info-policy.md` (TD-002)
2. Registrar lecciones de Phase 1 en WP lessons-learned.md
3. Crear primer ADR de IACT-docs

**After Phase 3 DIAGNOSE:**
1. Documentar root causes como L-NNN
2. Crear patrones si se detectan

**After Phase 5 STRATEGY:**
1. Agregar ADRs de decisiones estratégicas

---

**Total conocimiento IACT-docs:** 0 (recién iniciado)  
**ADRs:** 0 · **Lecciones:** 0 · **Patrones:** 0 · **Errores:** 0  
**Ubicación:** `.thyrox/context/knowledge-base.md`  
**Scope:** Conocimiento específico del proyecto IACT-docs
