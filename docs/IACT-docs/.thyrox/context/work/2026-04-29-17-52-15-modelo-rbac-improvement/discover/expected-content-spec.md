```yml
created_at: 2026-04-29 18:10:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Expected Content Spec

## Marco normativo aplicable

El modelo RBAC IACT debe cumplir y reflejar los siguientes
artefactos normativos del proyecto:

### CNSTs (restricciones obligatorias)

| ID | Título | v | Implicación para el modelo |
|----|--------|---|----------------------------|
| **CNST-029** | RBAC Modelo Plano | 2.0.0 | Modelo plano (sin jerarquía ni herencia ABAC); 42 funciones atómicas + 10 grupos predefinidos AGR-001..010 + system vs custom |
| **CNST-030** | Reglas SoD | 2.0.0 | 3 reglas SOD-001/002/003 declaradas + aplicabilidad a custom groups |
| **CNST-031** | Permisos Temporales Máximo 6 Meses | 2.0.0 | Permisos excepcionales con duración máxima 6 meses |
| **CNST-032** | Menú Dinámico Obligatorio | 1.0.0 | Función SQL `obtener_menu_usuario` + flujo dinámico server-side |
| **CNST-033** | Vocabulario Unificado RBAC | 1.0.0 | Término canónico "Función" (docs) / "Function" (código). Prohibida coexistencia con "Capacidad/Capacity" |

### ADRs (decisiones arquitectónicas)

| ID | Título | Decisión | Implicación |
|----|--------|----------|-------------|
| **ADR-GOB-008** | RBAC Coexistencia Vista Funcional ↔ Vista Técnica | Aceptada 2026-04-29 | Coexisten 2 vistas: MOD_Access (modelo conceptual v5.2.1) + MOD_Permissions (sistema PERM granular). Vocabulario unificado "Function" en código. |

### STDs (estándares aplicables)

| ID | Aplicación |
|----|-----------|
| **STD-001** v2.1.0 | Sin emojis, ASCII only, sin tildes en código |
| **STD-006** v1.0.0 | Versión SemVer en metadata YAML, NO en filename |
| **STD-007** v2.0.2 | Schema canónico de metadata YAML §6 |

## Decisiones D-RBAC explicitadas (8)

Del ADR-GOB-008 § "Decisiones Relacionadas":

1. **D-RBAC-1:** Vocabulario único "Función" / "Function".
2. **D-RBAC-2:** UsuarioGrupo unificación (rename ALTER TABLE).
3. **D-RBAC-3:** AuditoriaPermiso vs AuditLog — tablas separadas.
4. **D-RBAC-4:** Grupos system inmutables (AGR-001..010) + custom creables.
5. **D-RBAC-5:** Crear CNST_032 Menu Dinamico Obligatorio.
6. **D-RBAC-6:** Crear CNST_033 Vocabulario Unificado RBAC.
7. **D-RBAC-7:** SoD aplica también a custom groups.
8. **D-RBAC-8:** Migración Capacidad → Function: reemplazo total.

## Contenido esperado del modelo (síntesis)

### A. Identificación + metadata

- Frontmatter `.. meta::` Schema A canonical (STD-007 v2.0.2 §6).
- `:artefacto: ARQ_MOD_RBAC` o `MODELO_RBAC_IACT` (preservar por
  refs entrantes).
- `:tipo: Documento de Arquitectura` o `Modelo Arquitectonico`
  (clarificar canonicalmente).
- `:dominio: arquitectura-tecnica` (kebab — ya está en correcto en
  ADR-GOB-008).
- `:estado: Aprobado` (no "Vigente" — ver gap analysis).
- `:clasificacion: Confidencial` (no "Critico").
- Anchor `:ref: modelo-rbac-iact` (preservar).

### B. Filosofía y arquitectura

- Principio central: modelo plano (refleja CNST-029).
- Distinción de las 2 vistas (per ADR-GOB-008): funcional
  (MOD_Access) y técnica (MOD_Permissions).
- 8 módulos: Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs.

### C. Catálogo declarativo (autoritativo)

- 42 funciones distribuidas en los 8 módulos (con código canónico
  inglés).
- 10 grupos AGR-001..AGR-010 con membership.
- 3 reglas SoD SOD-001/002/003.
- Distinción system vs custom groups (per D-RBAC-4).

### D. Vocabulario canónico (per CNST-033)

- "Función" (docs español) / "Function" (código inglés).
- "Grupo predefinido" / "FunctionGroup".
- "Agrupador" (admin no-tech UI label).
- 8 términos canónicos del § H del glosario.

### E. Modelo de datos abstracto

- Esquema lógico de tablas (sin DDL detallado — ese va en
  artefactos separados de implementación).
- Relaciones entre entities (Function, FunctionGroup, User,
  AssignmentTemporary, etc.).

### F. Casos de Uso asociados

- Mapeo del catálogo a UCs (UC_ACC_01..09 + UC_PERM_01..10 + UC_AUD_*).
- Cross-refs bidireccionales con UCs.

### G. NO esperado en el modelo (debe vivir en otros artefactos)

- **DDL SQL completo** → debe vivir en `arq-mod-003-rbac-core.rst`
  o módulo de implementación.
- **Código Python Django** → debe vivir en código fuente del
  backend, NO en doc.
- **Script de migración** entre versiones del modelo → debe vivir
  en `proc-doc-*` o `proced-gob-*` según corresponda.

## Tipo de artefacto

Según STD-007 v2.0.2 §4, este archivo está en el directorio
`arquitectura-tecnica/rbac/` SIN prefijo numerado canónico
(`mod-NNN-*`, `arq-mod-*`, etc.). Eso es **excepción documentable**
porque:

- Es el modelo conceptual maestro del subdominio RBAC.
- Es referenciado por nombre canónico (`MODELO_RBAC_IACT`).
- Renombrarlo rompería las 12 refs entrantes.

Posibles patrones canónicos retroactivos:

| Opción | Patrón | Implicación |
|--------|--------|-------------|
| A (recomendada) | Mantener `modelo-rbac-iact.rst` + documentar como excepción en STD-007 §5.4 (guías sin prefijo en directorios temáticos) | 0 renames, 0 refs rotas |
| B | Renombrar a `arq-rbac-001-modelo-rbac-iact.rst` | 12 refs cascading |
| C | Renombrar a `mod-001-rbac-modelo.rst` (junto con arq-mod-* renames) | 12 refs cascading + nuevo prefijo |

## Próximo paso

T-004: producir gap analysis comparando estado actual (T-001) vs
contenido esperado (T-003).
