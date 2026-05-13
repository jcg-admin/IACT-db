# Plan de Reorganización: Documentación AI/Agentes

**Fecha creación**: 2025-11-17 08:00:00
**Autor**: Claude Code (Sonnet 4.5)
**Tipo**: Plan de reorganización documental
**Relacionado**: ADR-AI-018-ai-services-standalone-architecture

---

## Contexto

Según **ADR-AI-018**, el proyecto `iact_agents/` es STANDALONE y separado de callcentersite:

> `iact_agents/` = Proyecto Python STANDALONE (separado de callcentersite)
> DORA + Agentes = Proyecto aparte del entregable principal
> NO integrar con Django REST Framework

Sin embargo, actualmente la documentación de AI/agentes está dispersa en ubicaciones incorrectas dentro de `docs/gobernanza/`, cuando debería estar centralizada según la arquitectura standalone.

---

## Análisis Actual

### Distribución de Documentación

| Ubicación | Archivos | Estado | Acción Requerida |
|-----------|----------|--------|------------------|
| `docs/gobernanza/ai/` | 12 | ❌ Incorrecta | Mover a `docs/ai/` |
| `docs/gobernanza/agentes/` | 4 | ❌ Incorrecta | Mover a `docs/agents/` |
| `docs/agents/` | 8 | ✅ Correcta | Mantener |
| `docs/ai/` | 173 | ✅ Correcta | Mantener + agregar |

### Archivos en docs/gobernanza/ai/ (12 archivos)

1. `AI_CAPABILITIES.md`
2. `ANALISIS_GAPS_POST_DORA_2025.md`
3. `COLLABORATION_PROTOCOLS.md`
4. `DORA_CASSANDRA_INTEGRATION.md`
5. `DORA_SDLC_INTEGRATION_GUIDE.md`
6. `ESTRATEGIA_IA.md`
7. `FASES_IMPLEMENTACION_IA.md`
8. `GAPS_SUMMARY_QUICK_REF.md`
9. `HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md`
10. `TASK-009-comunicacion_ai_stance.md`
11. `TASK-012-ai_guidelines_onboarding.md`
12. `TASK-024-ai_telemetry_system.md`

**Categorización**:
- **Estrategia/Planeación** (docs/ai/estrategia/): 2, 6, 7
- **Análisis/Gaps** (docs/ai/analisis/): 2, 8
- **Integraciones** (docs/ai/integraciones/): 4, 5, 9
- **Protocolos** (docs/ai/protocolos/): 3
- **Capabilities** (docs/ai/ai_capabilities/): 1
- **Tasks** (docs/ai/tasks/): 10, 11, 12

### Archivos en docs/gobernanza/agentes/ (4 archivos)

1. `AGENTS.md`
2. `README.md`
3. `constitution.md`
4. `tdd_feature_agent.md`

**Categorización**:
- Todos van a `docs/agents/` (documentación del framework)

---

## Plan de Acción

### FASE 1: Preparación

#### 1.1 Crear estructura de subcarpetas en docs/ai/

```bash
mkdir -p docs/ai/estrategia
mkdir -p docs/ai/integraciones
mkdir -p docs/ai/protocolos
mkdir -p docs/ai/tasks
```

**Nota**: `docs/ai/analisis/` ya existe (verificado)

---

### FASE 2: Migración de docs/gobernanza/ai/ → docs/ai/

#### 2.1 Mover archivos de estrategia

```bash
git mv docs/gobernanza/ai/ESTRATEGIA_IA.md docs/ai/estrategia/
git mv docs/gobernanza/ai/FASES_IMPLEMENTACION_IA.md docs/ai/estrategia/
```

#### 2.2 Mover archivos de análisis

```bash
git mv docs/gobernanza/ai/ANALISIS_GAPS_POST_DORA_2025.md docs/ai/analisis/
git mv docs/gobernanza/ai/GAPS_SUMMARY_QUICK_REF.md docs/ai/analisis/
```

#### 2.3 Mover archivos de integraciones

```bash
git mv docs/gobernanza/ai/DORA_CASSANDRA_INTEGRATION.md docs/ai/integraciones/
git mv docs/gobernanza/ai/DORA_SDLC_INTEGRATION_GUIDE.md docs/ai/integraciones/
git mv docs/gobernanza/ai/HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md docs/ai/integraciones/
```

#### 2.4 Mover archivos de protocolos

```bash
git mv docs/gobernanza/ai/COLLABORATION_PROTOCOLS.md docs/ai/protocolos/
```

#### 2.5 Mover archivos de capabilities

```bash
git mv docs/gobernanza/ai/AI_CAPABILITIES.md docs/ai/ai_capabilities/
```

#### 2.6 Mover archivos de tasks

```bash
git mv docs/gobernanza/ai/TASK-009-comunicacion_ai_stance.md docs/ai/tasks/
git mv docs/gobernanza/ai/TASK-012-ai_guidelines_onboarding.md docs/ai/tasks/
git mv docs/gobernanza/ai/TASK-024-ai_telemetry_system.md docs/ai/tasks/
```

---

### FASE 3: Migración de docs/gobernanza/agentes/ → docs/agents/

```bash
git mv docs/gobernanza/agentes/AGENTS.md docs/agents/
git mv docs/gobernanza/agentes/README.md docs/agents/README_AGENTS.md  # Evitar conflicto
git mv docs/gobernanza/agentes/constitution.md docs/agents/
git mv docs/gobernanza/agentes/tdd_feature_agent.md docs/agents/
```

**Nota**: Renombrar README.md a README_AGENTS.md para evitar conflicto con README.md existente.

---

### FASE 4: Limpieza

#### 4.1 Eliminar directorios vacíos

```bash
# Verificar que estén vacíos
ls -la docs/gobernanza/ai/
ls -la docs/gobernanza/agentes/

# Si están vacíos, eliminar
rmdir docs/gobernanza/ai/
rmdir docs/gobernanza/agentes/
```

#### 4.2 Actualizar .gitignore (si es necesario)

No se esperan cambios en `.gitignore` para esta reorganización.

---

### FASE 5: Actualización de Referencias Cruzadas

#### 5.1 Buscar referencias a archivos movidos

```bash
# Buscar referencias a docs/gobernanza/ai/
grep -r "docs/gobernanza/ai" docs/ --include="*.md"

# Buscar referencias a docs/gobernanza/agentes/
grep -r "docs/gobernanza/agentes" docs/ --include="*.md"
```

#### 5.2 Actualizar referencias encontradas

Actualizar manualmente cada referencia para que apunte a la nueva ubicación.

**Ejemplo**:
```markdown
# Antes
[Estrategia IA](docs/gobernanza/ai/ESTRATEGIA_IA.md)

# Después
[Estrategia IA](docs/ai/estrategia/ESTRATEGIA_IA.md)
```

---

### FASE 6: Verificación

#### 6.1 Verificar estructura final

```bash
# Verificar que docs/gobernanza NO contenga ai/ ni agentes/
ls -la docs/gobernanza/ | grep -E "ai|agentes"
# Esperado: Sin resultados

# Verificar nuevas ubicaciones
ls -la docs/ai/estrategia/
ls -la docs/ai/integraciones/
ls -la docs/ai/protocolos/
ls -la docs/ai/tasks/
ls -la docs/agents/
```

#### 6.2 Verificar que no hay links rotos

```bash
# Opcional: Usar herramienta de verificación de links
npx markdown-link-check docs/**/*.md
```

---

### FASE 7: Commit y Push

#### 7.1 Review de cambios

```bash
git status
git diff --name-status
```

#### 7.2 Commit

```bash
git add docs/

git commit -m "$(cat <<'EOF'
refactor(docs): reorganizar documentacion AI/agentes segun ADR-AI-018

CONTEXTO:
Según ADR-AI-018, iact_agents/ es un proyecto STANDALONE separado
de callcentersite. La documentación debe reflejar esta arquitectura.

CAMBIOS:

1. Migración docs/gobernanza/ai/ → docs/ai/ (12 archivos)
   - estrategia/ (2 archivos): ESTRATEGIA_IA, FASES_IMPLEMENTACION_IA
   - analisis/ (2 archivos): ANALISIS_GAPS_POST_DORA_2025, GAPS_SUMMARY
   - integraciones/ (3 archivos): DORA_CASSANDRA, DORA_SDLC, HAMILTON
   - protocolos/ (1 archivo): COLLABORATION_PROTOCOLS
   - ai_capabilities/ (1 archivo): AI_CAPABILITIES
   - tasks/ (3 archivos): TASK-009, TASK-012, TASK-024

2. Migración docs/gobernanza/agentes/ → docs/agents/ (4 archivos)
   - AGENTS.md
   - README_AGENTS.md (renombrado de README.md)
   - constitution.md
   - tdd_feature_agent.md

3. Eliminación de directorios vacíos:
   - docs/gobernanza/ai/
   - docs/gobernanza/agentes/

4. Actualización de referencias cruzadas

BENEFICIOS:
- Documentación centralizada según arquitectura standalone
- Mejor separación de concerns
- Facilita mantenimiento del proyecto iact_agents/
- Cumple con decisión arquitectónica de ADR-AI-018

Relacionado: ADR-AI-018-ai-services-standalone-architecture
EOF
)"
```

#### 7.3 Push

```bash
git push -u origin claude/analyze-project-agents-01CW4YLfCp3taEJjTCNbwpfq
```

---

## Criterios de Éxito

- ✅ `docs/gobernanza/ai/` eliminado
- ✅ `docs/gobernanza/agentes/` eliminado
- ✅ Todos los 12 archivos de AI movidos a `docs/ai/` subcarpetas correctas
- ✅ Todos los 4 archivos de agentes movidos a `docs/agents/`
- ✅ Referencias cruzadas actualizadas
- ✅ No hay links rotos
- ✅ Commit exitoso con mensaje descriptivo
- ✅ Push exitoso a branch remoto

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Links rotos | Media | Medio | Buscar y actualizar todas las referencias |
| Conflicto con README.md | Baja | Bajo | Renombrar a README_AGENTS.md |
| Pérdida de historial git | Muy baja | Alto | Usar `git mv` en lugar de `mv` + `git add` |

---

## Próximos Pasos (Post-Reorganización)

1. Crear índice unificado en `docs/ai/README.md` con links a todas las subcarpetas
2. Actualizar `docs/agents/DOCUMENTATION_INDEX.md` con nuevos archivos
3. Notificar al equipo del cambio en estructura documental
4. Actualizar ADR-AI-018 con sección de "Ubicación de Documentación"

---

## Aprobación

- **Autor**: Claude Code (Sonnet 4.5)
- **Basado en**: ADR-AI-018-ai-services-standalone-architecture
- **Fecha de ejecución**: 2025-11-17
