# Inventario detallado de reglas y restricciones

## Objetivo
Consolidar en un único archivo todas las líneas del repositorio que mencionan **reglas** o **restricciones**, para facilitar su consulta y trazabilidad sin depender de búsquedas manuales.

## Metodología
- Búsqueda automatizada con `rg -n "(regla|restric)" --hidden` en la raíz del repositorio.
- Exclusión explícita de los artefactos de gobernanza previamente generados para evitar auto-referencias en este consolidado.
- Agrupación de resultados por archivo, preservando números de línea y texto original para permitir verificación rápida.

## Resumen
- Total de líneas encontradas: 2020.
- Total de archivos con coincidencias: 534.

## Detalle por archivo
Cada subsección incluye las líneas exactas que contienen las palabras clave, con su número de línea para referencia directa.

### .agent/agents/README.md
- L175: - Validación de restricciones del proyecto

### .agent/agents/automation_business_rules_validator_agent.md
- L3: description: Agente especializado en validacion de reglas de negocio, verificando consistencia logica, integridad de constraints, cumplimiento de invariantes y validacion de flujos de negocio.
- L8: El BusinessRulesValidatorAgent valida reglas de negocio en codigo, verificando consistencia logica, integridad de constraints, cumplimiento de invariantes y correctitud de flujos de negocio.
- L48: - **Refactoring**: Verificar preservacion de reglas
- L49: - **Feature Development**: Validar nuevas reglas de negocio
- L50: - **Bug Investigation**: Identificar violaciones de reglas
- L51: - **Documentation**: Generar documentacion de reglas
- L96: # Verificar coverage de reglas
- L228: 1. **Documentar reglas**: Mantener business_rules.yaml actualizado
- L229: 2. **Test coverage**: Cada regla debe tener tests
- L233: 6. **Revision periodica**: Validar reglas regularmente
- L234: 7. **Domain experts**: Involucrar en validacion de reglas

### .agent/agents/automation_constitution_validator_agent.md
- L88: # Validar regla especifica
- L94: # Validar todas las reglas

### .agent/agents/claude_agent.md
- L17: - **Normativa CODEX**: `docs/analisis/META_CODEX_PARTE_1.md` fija los supuestos y restricciones que deben respetar los artefactos generados con Claude.

### .agent/agents/dependency_agent.md
- L32: - Detección de licencias restrictivas
- L160: Reporta licencias restrictivas.

### .agent/agents/docs_agent.md
- L14: - **Referencia normativa**: `docs/analisis/META_CODEX_PARTE_1.md` (Parte 1 de 3) establece los supuestos y restricciones del meta-agente que gobierna todas las redacciones CODEX.
- L18: 1. **Planificación**: antes de modificar documentación, produce un ExecPlan y verifica las reglas del ETA-AGENTE CODEX.

### .agent/agents/gitops_agent.md
- L228: - scripts/validate_critical_restrictions.sh
- L340: 3. Verifica restricciones en docs/gobernanza/

### .agent/agents/sdlc_feasibility_agent.md
- L189: - Especificar restricciones conocidas (SLA, presupuesto)

### .agent/agents/sdlc_planner_agent.md
- L184: - Especificar restricciones técnicas conocidas

### .agent/agents/security_agent.md
- L8: SecurityAgent es un agente delegado especializado en seguridad del proyecto. Realiza auditorías de seguridad, escanea vulnerabilidades en código y dependencias, detecta secrets expuestos, y aplica análisis de amenazas STRIDE. Automatiza el cumplimiento de restricciones de seguridad del proyecto IACT.
- L38: - Validación de restricciones del proyecto
- L46: - Verificación de cumplimiento de restricciones
- L81: SecurityAgent: Valida cumplimiento de restricciones del proyecto.
- L115: scripts/validate_critical_restrictions.sh
- L124: - **docs/qa/checklist_auditoria_restricciones.md**: Checklist de auditoría
- L224: Este agente automatiza la seguridad del proyecto siguiendo metodología STRIDE y restricciones específicas de IACT.

### .agent/execplans/EXECPLAN_integrate_implementation_planner.md
- L1: # Integrar el agente Implementation Planner y sus restricciones obligatorias
- L3: Este plan detalla cómo propagar las instrucciones personalizadas "implementation-planner" en los artefactos maestros del catálogo de agentes y documentación, garantizando que cualquier ficha o guía que lo consuma conozca las reglas de TDD, cobertura ≥80 %, commits convencionales y definición operativa de alucinaciones.
- L8: - Actualizar los índices (`AGENTS_IMPLEMENTATION_MAP.md`, `.github/agents/README.md`) para reflejar la existencia del agente y las restricciones que arrastra.
- L9: - Conectar los playbooks temáticos (p. ej., `docs/mobile/ejemplos-mobile.md`) con las mismas reglas para que al solicitar prompts quede claro cómo prevenir alucinaciones.
- L26: 5. **Playbook móvil**: insertar recordatorio para que los prompts usen Implementation Planner como orquestador de restricciones.
- L33: - Toda guía relevante subraya las mismas restricciones obligatorias.

### .ci-local.yaml
- L307:       # Validacion restricciones criticas
- L308:       - name: validate_critical_restrictions
- L309:         description: "Validar restricciones criticas proyecto"
- L311:         command: "./scripts/validate_critical_restrictions.sh"

### .claude/workflow_template_mapping.json
- L68:         "docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md"

### .devcontainer/PROCEDIMIENTO.md
- L10:    - Dado que los hosts locales tienen **restricción de Docker**, usa GitHub Codespaces (Dev Containers en la nube). No es necesario instalar Docker Engine en tu máquina.

### .github/CODEOWNERS
- L40: docs/ai/requisitos/reglas_negocio/ @equipo-ba @arquitecto-ai
- L41: docs/backend/requisitos/reglas_negocio/ @equipo-ba @equipo-backend
- L42: docs/frontend/requisitos/reglas_negocio/ @equipo-ba @equipo-frontend
- L43: docs/infraestructura/requisitos/reglas_negocio/ @equipo-ba @equipo-devops

### .github/agents/AGENTS_IMPLEMENTATION_MAP.md
- L56: | DocumentationEditorAgent | Manual | Pendiente | Definir reglas de estilo automáticas. |

### .github/agents/META_PROMPTS_LIBRARY.md
- L325: [Versión con validaciones y restricciones más estrictas]
- L404: - Falta de restricciones: [qué falta]
- L459: - Mejor adherencia a restricciones éticas

### .github/agents/automation-business-rules-validator-agent.agent.md
- L3: description: Verificar que los procesos automatizados respeten las reglas de negocio declaradas por el dominio y que los cambios no rompan los contratos establecidos.
- L10: - Verificar que los procesos automatizados respeten las reglas de negocio declaradas por el dominio y que los cambios no rompan los contratos establecidos.
- L21: - Contrastar implementaciones con los catálogos vigentes de reglas de negocio.
- L23: - Emitir recomendaciones cuando una regla requiera actualización o nueva cobertura de pruebas.
- L28: - Paso 3: Valida que cada regla tenga pruebas unitarias y escenarios de regresión documentados.
- L40: 3. Valida que cada regla tenga pruebas unitarias y escenarios de regresión documentados.
- L45: - Matriz de reglas revisada y aprobada por el dominio responsable.
- L46: - Ejecución de pruebas automatizadas enfocadas en reglas de negocio.

### .github/agents/automation-constitution-validator-agent.agent.md
- L26: - Paso 1: Revisa los principios éticos y reglas de moderación vigentes.
- L38: 1. Revisa los principios éticos y reglas de moderación vigentes.

### .github/agents/automation/README.md
- L43: - Contrasta automatizaciones con reglas de negocio vigentes.
- L45: - Recomienda pruebas adicionales o ajustes de reglas.

### .github/agents/claude-agent.agent.md
- L26: - Paso 1: Verifica accesos y restricciones antes de iniciar cualquier flujo con Claude.
- L38: 1. Verifica accesos y restricciones antes de iniciar cualquier flujo con Claude.

### .github/agents/generators-llm-generator-agent.agent.md
- L21: - Seleccionar el modelo más adecuado según restricciones de costo, privacidad o latencia.

### .github/agents/huggingface-agent.agent.md
- L22: - Seleccionar checkpoints adecuados según el caso de uso y las restricciones de privacidad.
- L26: - Paso 1: Define el objetivo y las restricciones antes de elegir el modelo.
- L38: 1. Define el objetivo y las restricciones antes de elegir el modelo.

### .github/agents/implementation-planner-agent.agent.md
- L24: - Resumen del contexto (dominio, modelos LLM, restricciones legales) y métricas objetivo.

### .github/agents/llm-providers/README.md
- L17: - Ajusta parámetros según restricciones de privacidad y recursos.

### .github/agents/meta-design-patterns-agent.agent.md
- L26: - Paso 1: Recopila casos de uso y restricciones técnicas del contexto actual.
- L38: 1. Recopila casos de uso y restricciones técnicas del contexto actual.

### .github/agents/quality-syntax-validator-agent.agent.md
- L3: description: Verificar que archivos y scripts cumplan reglas sintácticas antes de integrarse al repositorio.
- L10: - Verificar que archivos y scripts cumplan reglas sintácticas antes de integrarse al repositorio.
- L22: - Configurar reglas y convenciones acordes a cada lenguaje.
- L26: - Paso 1: Selecciona las reglas aplicables al artefacto a revisar.
- L38: 1. Selecciona las reglas aplicables al artefacto a revisar.

### .github/agents/sdlc-feasibility-agent.agent.md
- L21: - Analizar requerimientos y restricciones tempranas.

### .github/agents/sdlc-planner-agent.agent.md
- L26: - Paso 1: Recopila requerimientos priorizados y restricciones del periodo.
- L38: 1. Recopila requerimientos priorizados y restricciones del periodo.

### .github/claude_code_conventions.md
- L11: Este documento establece las reglas específicas que Claude Code debe seguir al trabajar en este repositorio.
- L499: Esta regla aplica a:
- L532: - En code reviews, verificar cumplimiento de esta regla

### .github/copilot/README.md
- L90: - `business_rules_validator_agent.py` - Validación de reglas de negocio
- L240: - Usa `.github/copilot-instructions.md` para lineamientos globales (build/test/convenciones) y `.github/instructions/**/*.instructions.md` para reglas específicas por patrón de archivo.
- L336: ### Compatibilidad con reglas del repo
- L337: - Algunas reglas (ej. "Require signed commits") bloquean su ejecución; configúralo como bypass actor cuando sea necesario.

### .github/copilot/agents.json
- L11:       "description": "Comprueba reglas de negocio y consistencia lógica en automatizaciones y entregables generados.",
- L56:       "description": "Genera análisis de negocio integral con procesos, reglas, UC y requisitos trazables.",

### .github/hooks/README.md
- L317: - Fix de hook roto (debe seguirse con PR para arreglar hook)

### .github/pr_body.md
- L26: - Validación de compatibilidad con restricciones del proyecto
- L32: - Validación de restricciones críticas del proyecto IACT
- L66: - Sin emojis (cumple restricciones del proyecto)
- L73: - 0 emojis (cumple restricciones)

### .github/workflows/PLAN_CORRECCION.md
- L6: - **Triggers consistentes**: cada workflow debe soportar `push`, `pull_request` y `workflow_dispatch` salvo que exista una restricción explícita.

### .github/workflows/REVIEW.md
- L9: | backend-ci.yml | push, pull_request | lint, test-mysql, test-postgresql, validate-restrictions, integration-tests, summary |

### .github/workflows/backend-ci.yml
- L200:   validate-restrictions:
- L259:     needs: [lint, test-mysql, test-postgresql, validate-restrictions, integration-tests]
- L269:           echo "  IACT Restrictions: ${{ needs.validate-restrictions.result }}"
- L275:              [ "${{ needs.validate-restrictions.result }}" != "success" ] || \

### .github/workflows/deploy.yml
- L57:       - name: Check for IACT restrictions
- L59:           echo "Validating IACT critical restrictions..."
- L73:           echo "[PASS] IACT restrictions validated"
- L78:           if [ -f scripts/validate_critical_restrictions.sh ]; then
- L79:             bash scripts/validate_critical_restrictions.sh

### .github/workflows/incident-response.yml
- L413:           echo "Note: NO EMAIL per IACT restrictions"

### .github/workflows/infrastructure-ci.yml
- L84:       - name: Test validate_critical_restrictions.sh
- L86:           if [ -f scripts/validate_critical_restrictions.sh ]; then
- L87:             echo "Testing validate_critical_restrictions.sh..."
- L88:             bash scripts/validate_critical_restrictions.sh
- L90:             echo "[WARNING]  WARNING: validate_critical_restrictions.sh not found"

### api/callcentersite/src/callcentersite/apps/authentication/validators.py
- L12:     """Valida reglas básicas de complejidad de contraseñas."""

### api/callcentersite/src/callcentersite/apps/permissions/tests/test_models.py
- L230:         # (esto es conceptual, no hay restriccion en DB, pero documentamos el patron)

### api/callcentersite/src/dora_metrics/data_ecosystem.py
- L225:                     "description": "Technology restrictions compliance",

### api/callcentersite/tests/authentication/test_login.py
- L6: las reglas de negocio RN-C01-01 y RN-C01-02.

### api/callcentersite/tests/authentication/test_tokens.py
- L6: reglas de negocio RN-C01-03, RN-C01-04 y RN-C01-11.

### api/callcentersite/tests/politicas/test_casos_uso_politicas.py
- L105:             'Contenido actualizado con nuevas reglas',
- L111:         assert politica_v2.contenido == 'Contenido actualizado con nuevas reglas'

### docs/ONBOARDING.md
- L137: 5. Cambios en restricciones criticas (RNF-002 - human only)
- L156: - Respeta restricciones del proyecto (RNF-002)
- L236: A: SI, pero debes revisar CADA linea generada, ejecutar tests, y validar contra restricciones del proyecto.
- L240: A: RECHAZAR la sugerencia. RNF-002 prohibe Redis. IA no conoce restricciones especificas del proyecto.

### docs/agents/constitution.md
- L48: # Error: "No se encontró especificación de reglas de descuento.

### docs/agents/tdd_feature_agent.md
- L304: Cada regla valida evidencias específicas:
- L384: - **CRITICAL**: 40 puntos (4 reglas × 10 pts)
- L385: - **HIGH**: 30 puntos (2 reglas × 15 pts)
- L386: - **MEDIUM**: 30 puntos (4 reglas × 7.5 pts)
- L410: - Cualquier regla CRITICAL es violada

### docs/ai/AGENTES_Y_TECNICAS_APLICADAS.md
- L119: - **Uso**: Razonamiento automático en validaciones de restricciones
- L120: - **Justificación**: Necesario para TASK-002 (validar restricciones)
- L170: **Propósito**: Ejecutar TASK-001 a TASK-004 (tareas P0 críticas) y validar restricciones
- L175:    - **Aplicación**: Validar restricciones RNF-002 paso a paso
- L190:    - **Aplicación**: Múltiples validaciones para misma restricción
- L196:    - **Evidencia**: Análisis automático de por qué email viola restricciones
- L200:    - **Aplicación**: Ejecutar scripts shell (validate_critical_restrictions.sh)
- L210:    - **Aplicación**: Validación con nivel de conocimiento experto de restricciones
- L251: ### TASK-002-validar-restricciones-críticas.md
- L352: 1. **Generated Knowledge**: Podría generar contexto adicional sobre restricciones

### docs/ai/ANALISIS_REORGANIZACION_SCRIPTS.md
- L208: │   │   ├── constitution.py             # 8 reglas TDD

### docs/ai/CHANGELOG.md
- L463: - Documentacion ahora cumple con restriccion critica RNF-NO-EMOJIS
- L682: - NO usar IA para: Decisiones arquitectonicas criticas, security final, merge sin review, credenciales, cambios en restricciones
- L821: - `docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md`
- L838:   - Agregado `checklist_auditoria_restricciones.md`
- L967: - `scripts/validate_critical_restrictions.sh`

### docs/ai/ESTRUCTURA_SCRIPTS_COMPARATIVA.md
- L116:     │   ├── constitution.py            # [OK] 8 reglas TDD

### docs/ai/PLAN_EJECUCION_COMPLETO.md
- L39: - 0 violaciones de restricciones criticas (RNF-002)
- L105: Ejecutar validacion completa de restricciones criticas RNF-002.
- L110: ./scripts/validate_critical_restrictions.sh
- L123: git add scripts/validate_critical_restrictions.sh
- L124: git commit -m "validate: ejecutar restricciones criticas - RNF-002 compliant"
- L1323: - scripts/validate_critical_restrictions.sh

### docs/ai/PREVENCION_EMOJIS_EN_TAREAS.md
- L62: Cuando generes archivos TASK-*.md, aplica estas reglas:
- L129: 1. **Agentes deben tener guardrails explícitos** sobre restricciones del proyecto
- L132: 4. **Constitutional AI** debe incluir reglas de formato de documentación

### docs/ai/PR_DESCRIPTION.md
- L34: - TASK-002: Validar restricciones criticas (1 SP)

### docs/ai/SDLC_AGENTS_GUIDE.md
- L27: - **Modo Heurístico**: Análisis basado en reglas (rápido, determinista, sin costo)
- L441: # Decision será "no-go" por restricción IACT

### docs/ai/agent/arquitectura/adrs_shell_script_analysis_agent.md
- L179: - 8 reglas bien definidas
- L220: - Majority voting para cada regla/metric
- L224: - Constitutional: voting sobre cada regla
- L338: - ConstitutionalAnalyzer → solo reglas constitucionales
- L359: Escenario: Agregar nueva regla constitutional

### docs/ai/agent/arquitectura/adrs_shell_script_remediation_agent.md
- L39: **Path 1**: Hybrid permite mejor ROI - reglas rápidas para 60% cases, LLM para 40% complejos → **APPROVE** (Confidence: 90%)

### docs/ai/agent/planificacion_y_releases/issue_shell_script_analysis_agent.md
- L35: - `validate_shell_constitution.sh` - Valida 8 reglas constitucionales
- L58: - [ ] AC-002-01: Valida las 8 reglas de `SHELL_SCRIPTS_CONSTITUTION.md`
- L249: - Permitir configuración de reglas a ignorar
- L257: - Fallback a análisis basado en reglas estáticas

### docs/ai/agent/planificacion_y_releases/issue_shell_script_remediation_agent.md
- L44: - **Limitación de agentes rule-based**: Solo arreglan patterns conocidos

### docs/ai/agent/requisitos/feasibility_shell_script_analysis_agent.md
- L65: - Usar análisis basado en reglas Python (AST parsing de bash)
- L89: - Valida 8 reglas constitucionales
- L217: - ✓ Configuración de reglas a ignorar por script
- L274: - Nuevos patterns de scripts requieren nuevas reglas
- L278: - ✓ Configuración externa (JSON/YAML) para reglas
- L370: - No customizable para reglas específicas
- L404: - Análisis constitucional (8 reglas)

### docs/ai/agent/testing/testing_strategy_shell_script_analysis_agent.md
- L70:     """Verifica reglas constitucionales personalizadas"""

### docs/ai/ai_capabilities/AI_CAPABILITIES.md
- L54:   - Valide contra restricciones (RNF-002: NO Redis, NO Email)
- L59:   - `./scripts/validate_critical_restrictions.sh`
- L178:   - `./scripts/validate_critical_restrictions.sh`
- L260: # Validate restrictions
- L261: ./scripts/validate_critical_restrictions.sh

### docs/ai/ai_capabilities/TASK-026-dora_ai_capability_7.md
- L201:  - RNF-002: Technology restrictions compliance
- L234:  "description": "Technology restrictions compliance",

### docs/ai/ai_capabilities/orchestration/CODEX_MCP_MULTI_AGENT_GUIDE.md
- L123: `workflow["task"]` contiene un backlog textual que los agentes pueden usar como referencia (objetivo “Bug Busters”, endpoints del backend, restricciones de simplicidad, etc.).

### docs/ai/ai_capabilities/orchestration/CONTEXT_MANAGEMENT_PLAYBOOK.md
- L51: - Olvida de forma abrupta cualquier restricción o identificador anterior a *N* turnos.
- L80: - Conserva decisiones, identificadores y restricciones más allá de *N* turnos.
- L115: 3. **Replay de transcripciones**: reproduce threads largos y valida si el agente recuerda IDs, acuerdos o restricciones.

### docs/ai/ai_capabilities/prompting/ADVANCED_PROMPTING_TECHNIQUES.md
- L175:     'project_restrictions': [
- L196: - Write operation restrictions
- L277:     "project_restrictions": "- NO Redis\n- NO emojis",
- L302:     "project_restrictions": restrictions_list,
- L796:             "project_restrictions": PROJECT_RESTRICTIONS

### docs/ai/ai_capabilities/prompting/CI_CD_INTEGRATION.md
- L63:             'restrictions': [
- L686:             'restrictions': [

### docs/ai/ai_capabilities/prompting/DJANGO_BACKEND_PROMPTING.md
- L82:                 'project_restrictions': [
- L652: {restrictions}
- L674:     variables=['model_code', 'project_context', 'restrictions']
- L711: - Restricciones: {restrictions}
- L720:                'validations', 'drf_version', 'restrictions']
- L800:                 'restrictions': [
- L976: [ ] Validar que database router cumple READ-ONLY restrictions

### docs/ai/ai_capabilities/prompting/PROMPT_TECHNIQUES_CATALOG.md
- L397: **Descripcion**: Aplicar restricciones estrictas al output.
- L402: "Implementa funcion Python con ESTAS restricciones:
- L476: **Descripcion**: Definir "constitucion" proyecto con reglas/principios validados automaticamente.
- L503: - ConstitutionValidatorAgent (6 reglas automaticas)
- L672: - Constitution-Driven (reglas infra)

### docs/ai/ai_capabilities/prompting/README.md
- L186:     context={"restrictions": ["IVR es READ-ONLY"]}

### docs/ai/analisis/AGENTS.md
- L11: - *Técnicos*: Acceso a repositorios académicos, análisis metodológico riguroso, derivación de restricciones formales y validación multi-ruta.
- L27: 4. **Constraint-Driven Prompting** para garantizar que ninguna decisión viole restricciones lógicas o de complejidad.
- L48: │   ├─ Ejecución condicionada según objetivos y restricciones
- L71: - **Contexto técnico** (problema, propiedades deseadas, restricciones, stack base).
- L72: - **Objetivos verificables** y **restricciones adicionales** (técnicas, operacionales, regulatorias, legacy).
- L78: 2. **Derivación de restricciones**: complejidad computacional, propiedades de consistencia/correctitud y seguridad basada en threat models.

### docs/ai/analisis/ANALISIS_GAPS_POST_DORA_2025.md
- L176: - [OK] validate_critical_restrictions.sh
- L435: - **Impacto:** Prevenir violaciones de restricciones en cada commit
- L456: - **Comando:** `./scripts/validate_critical_restrictions.sh`
- L503: 4. [P0] Validar restricciones (0 SP) - 5 min (validation)
- L716: 4. [Quick Win] Validar restricciones criticas
- L868: 4. Validar restricciones (0 SP validation)

### docs/ai/analisis/GAPS_SUMMARY_QUICK_REF.md
- L61: 4. **Validar restricciones** (5 min)
- L63:    ./scripts/validate_critical_restrictions.sh
- L121: 4. Validar restricciones

### docs/ai/analisis/META_CODEX_PARTE_1.md
- L61: - Validadores automáticos derivados de restricciones formales.
- L80: - **Enunciado:** La especialización admite formalización mediante propiedades verificables o restricciones cuantificables.
- L141: - Presencia de restricciones formales derivables.
- L226: - **Q2: Inferencias válidas.** Cada paso usa reglas de inferencia o referencias formales.
- L336: [3] Derivación de restricciones formales
- L373: ### 3.4 Etapa 3: Derivación de restricciones formales
- L375: **Objetivo:** Extraer propiedades formales, anti-patterns y restricciones cuantitativas.
- L380: - Derivar restricciones cuantitativas vinculadas a propiedades deseadas.
- L382: **Criterios de aceptación:** ≥ 3 propiedades formales, ≥ 5 anti-patterns con evidencia, ≥ 2 restricciones cuantitativas.

### docs/ai/analisis/META_AGENTE_CODEX_PARTE_2.md
- L21: - Propiedades formales, anti-patterns y restricciones (Etapa 3).
- L72: De restricciones cuantitativas (Etapa 3):
- L73:   Para cada restricción:
- L176: De restricciones formales (Etapa 3):
- L177:   Para cada restricción R_i:
- L647: restricciones_tecnicas:
- L707: **Campo: restricciones_tecnicas**
- L710: - Incluir restricciones regulatorias si aplican.

### docs/ai/analisis/META_AGENTE_CODEX_PARTE_3.md
- L40: 4. Derivación de restricciones formales (3-5 min).
- L74: 3. Sección N+6: Limitaciones (entender restricciones).
- L87: - ¿Las restricciones son compatibles con mi entorno?
- L386:       "restriccion_formal": "...",
- L541: Naturaleza: Fundamental (restricción de privacidad).
- L553: - Empresas con restricciones regulatorias únicas.
- L785: - Validadores automáticos derivados de restricciones formales.
- L813: - No considera restricciones de budget organizacional.
- L826: - Análisis formal de propiedades y restricciones.
- L898: Si proyecto tiene restricciones muy específicas no cubiertas en literatura (ej.: integración con sistema *legacy* propietario complejo).

### docs/ai/estrategia/ESTRATEGIA_IA.md
- L255: 5. **Cambios en restricciones criticas**: RNF-002, NO Redis, etc - human only
- L259: - **AI suggestions**: Validar contra restricciones del proyecto
- L470: - [x] Validaciones criticas automatizadas (validate_critical_restrictions.sh)
- L599: - Automated validations: validate_critical_restrictions.sh, CI/CD gates
- L770: **IMPORTANTE:** Todas las practicas DORA deben cumplir restricciones IACT:
- L775: - [ ] NO Prometheus/Grafana (violan esta restriccion)
- L812: 2. Validar contra restricciones del proyecto (RNF-002)
- L828: A: RECHAZAR la sugerencia. IA no conoce restricciones especificas del proyecto. Es responsabilidad del developer validar compliance.

### docs/ai/estrategia/FASES_IMPLEMENTACION_IA.md
- L135: | **T2.3** | **Establecer repositorio de configuracion IA** | Mantener YAMLs, scripts y reglas de validacion bajo control de versiones. | DevOps Engineer | Repositorio `infra/ai-governance`. |

### docs/ai/estrategia_creditos_llm.md
- L732: El optimizador decide automáticamente usando estas reglas:

### docs/ai/integraciones/HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md
- L31: | Beneficios clave | Testing, modularidad, reutilización, documentación automática y visualización de DAGs. | Cumple restricciones de gobierno IA: trazabilidad (`FASES_IMPLEMENTACION_IA.md` Fase 2) y small batches (`FASES_IMPLEMENTACION_IA.md` Fase 4). |

### docs/ai/orchestration/CODEX_MCP_MULTI_AGENT_GUIDE.md
- L130: `workflow["task"]` contiene un backlog textual que los agentes pueden usar como referencia (objetivo “Bug Busters”, endpoints del backend, restricciones de simplicidad, etc.).

### docs/ai/orchestration/CONTEXT_MANAGEMENT_PLAYBOOK.md
- L58: - Olvida de forma abrupta cualquier restricción o identificador anterior a *N* turnos.
- L87: - Conserva decisiones, identificadores y restricciones más allá de *N* turnos.
- L122: 3. **Replay de transcripciones**: reproduce threads largos y valida si el agente recuerda IDs, acuerdos o restricciones.

### docs/ai/prompting/ADVANCED_PROMPTING_TECHNIQUES.md
- L182:     'project_restrictions': [
- L203: - Write operation restrictions
- L284:     "project_restrictions": "- NO Redis\n- NO emojis",
- L309:     "project_restrictions": restrictions_list,
- L803:             "project_restrictions": PROJECT_RESTRICTIONS

### docs/ai/prompting/CI_CD_INTEGRATION.md
- L70:             'restrictions': [
- L693:             'restrictions': [

### docs/ai/prompting/DJANGO_BACKEND_PROMPTING.md
- L89:                 'project_restrictions': [
- L659: {restrictions}
- L681:     variables=['model_code', 'project_context', 'restrictions']
- L718: - Restricciones: {restrictions}
- L727:                'validations', 'drf_version', 'restrictions']
- L807:                 'restrictions': [
- L983: [ ] Validar que database router cumple READ-ONLY restrictions

### docs/ai/prompting/PROMPT_TECHNIQUES_CATALOG.md
- L194: - **Answer Extractor**: regla para extraer la respuesta final.
- L206: - **Guardrails**: reglas para guiar la salida.

### docs/ai/prompting/README.md
- L193:     context={"restrictions": ["IVR es READ-ONLY"]}

### docs/ai/registros/2025_11_05_merge_ramas.md
- L135: - Sin emojis (cumple restricciones)

### docs/ai/requisitos/README.md
- L11: Ver marco conceptual en: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L14: Nivel 1: REGLAS DE NEGOCIO → reglas_negocio/
- L23: - `reglas_negocio/` - 5 tipos: Hechos, Restricciones, Desencadenadores, Inferencias, Cálculos

### docs/ai/requisitos/casos_uso/UC-SYS-006_planning_replanning_workflow.md
- L10: - Sigue [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)
- L1021: 2. [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)

### docs/ai/requisitos/casos_uso/UC-SYS-007_multi_protocol_agent_integration.md
- L10: - Sigue [RT-014: Protocol Performance and Security Standards](../reglas_tecnicas/RT-014_protocol_performance_security_standards.md)
- L313: 2. [RT-014: Protocol Performance and Security Standards](../reglas_tecnicas/RT-014_protocol_performance_security_standards.md)

### docs/ai/requisitos/casos_uso/UC-SYS-008_human_centric_agent_interactions.md
- L10: - Sigue [RT-015: UX Standards](../reglas_tecnicas/RT-015_ux_standards_transparency_control_consistency.md)
- L396: 2. [RT-015: UX Standards](../reglas_tecnicas/RT-015_ux_standards_transparency_control_consistency.md)

### docs/ai/requisitos/casos_uso/UC-SYS-009_trustworthy_agent_operations.md
- L10: - Sigue [RT-016: Security Standards](../reglas_tecnicas/RT-016_security_threat_mitigation_standards.md)

### docs/ai/requisitos/funcionales/RF-011_task_decomposition_structured_output.md
- L8: - Sigue [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)
- L1021: 2. [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)

### docs/ai/requisitos/funcionales/RF-012_iterative_planning_feedback.md
- L8: - Sigue [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)
- L1515: 2. [RT-013: Planning Performance and Quality Standards](../reglas_tecnicas/RT-013_planning_performance_quality_standards.md)

### docs/ai/requisitos/funcionales/RF-013_agent_protocols_implementation.md
- L8: - Sigue [RT-014: Protocol Performance and Security Standards](../reglas_tecnicas/RT-014_protocol_performance_security_standards.md)
- L438: 2. [RT-014: Protocol Performance and Security Standards](../reglas_tecnicas/RT-014_protocol_performance_security_standards.md)

### docs/ai/requisitos/funcionales/RF-016_agent_ux_implementation.md
- L8: - Sigue [RT-015: UX Standards](../reglas_tecnicas/RT-015_ux_standards_transparency_control_consistency.md)
- L592: 2. [RT-015: UX Standards](../reglas_tecnicas/RT-015_ux_standards_transparency_control_consistency.md)

### docs/ai/requisitos/funcionales/RF-017_trustworthy_ai_implementation.md
- L8: - Sigue [RT-016: Security Standards](../reglas_tecnicas/RT-016_security_threat_mitigation_standards.md)
- L451: 2. [RT-016: Security Standards](../reglas_tecnicas/RT-016_security_threat_mitigation_standards.md)

### docs/ai/requisitos/reglas_tecnicas/RT-001_tipos_canonicos_soportados.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-002_estructura_directorios_adr010.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-003_clean_code_naming.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-004_memory_performance_constraints.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-005_memory_retention_policies.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-006_memory_storage_limits.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-007_context_window_limits.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-008_context_quality_standards.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-009_metacognition_performance_constraints.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-010_reflection_quality_standards.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/reglas_tecnicas/RT-011_multi_agent_communication_coordination.md
- L3: tipo: regla_tecnica
- L14: Definir reglas técnicas para comunicación y coordinación entre agentes en sistemas multi-agent para garantizar interoperabilidad, performance, y reliability.

### docs/ai/requisitos/reglas_tecnicas/RT-012_multi_agent_observability.md
- L3: tipo: regla_tecnica

### docs/ai/requisitos/requerimientos_funcionales/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/ai/requisitos/requerimientos_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/ai/requisitos/trazabilidad.md
- L32: - Reglas de Negocio: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L47: **Acción requerida**: Documentar reglas de negocio en `reglas_negocio/` usando los 5 tipos definidos en el marco conceptual.
- L129: - ¿Qué regla de negocio justifica este código?
- L156: 1. Documentar en `reglas_negocio/{tipo}.md`
- L180: - **Marco de Reglas de Negocio**: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/ai/roadmap.md
- L27: 3. **Compliance total** con restricciones criticas (RNF-002, NO Redis)
- L42: - [ ] Validacion completa de restricciones
- L81: - [ ] Pre-commit hooks con validacion restricciones
- L139: - 0 incidents por restricciones violadas
- L286: - Validacion restricciones completa

### docs/ai/tareas/TASK-033-predictive_analytics.md
- L624:  # ... mas reglas
- L1252: - Modelo guardado con permisos restrictivos (600)

### docs/ai/tasks/TASK-009-comunicacion_ai_stance.md
- L57: - Cambios en restricciones criticas (RNF-002 - human only)
- L77: 2. Cumplir con restricciones del proyecto (RNF-002)
- L158:    - Verificar cumplimiento de politicas y restricciones organizacionales
- L266: 2. Validar contra restricciones del proyecto (RNF-002)
- L282: A: RECHAZAR la sugerencia. IA no conoce restricciones especificas del proyecto. Es responsabilidad del developer validar compliance.

### docs/ai/tasks/TASK-012-ai_guidelines_onboarding.md
- L30: - **Cuando NO usar IA** (5 restricciones)
- L51:  - Con restricciones de seguridad
- L104:  - Verificar cumplimiento de politicas y restricciones organizacionales

### docs/ai/tasks/TASK-024-ai_telemetry_system.md
- L32:  - Verificar cumplimiento de politicas y restricciones organizacionales

### docs/backend/2025-11-11/analisis_cobertura_requisitos.md
- L355: - [ ] Alcance y restricciones

### docs/backend/ARQUITECTURA-MODULOS-COMPLETA.md
- L274:  regla (FK)

### docs/backend/GUIA_NAVEGACION_BACKEND.md
- L186: - [`TASK-002-validar_restricciones_criticas.md`](TASK-002-validar_restricciones_criticas.md)

### docs/backend/INDEX.md
- L43: - TASK-002-validar_restricciones_criticas.md
- L136: - [TASK-002-validar_restricciones_criticas.md](TASK-002-validar_restricciones_criticas.md)

### docs/backend/REPORTE_EJECUCION_TASK_001_004.md
- L36: **Razón**: 2 violaciones de restricciones detectadas
- L71: 2. **Violaciones de restricciones RNF-002**: Email y pickle en código
- L99: - **Bloqueadores críticos**: 2 (violaciones de restricciones)
- L105: 1. Equipo de desarrollo debe corregir violaciones de restricciones
- L113: - TASK-002: docs/qa/TASK-002-validar-restricciones-críticas.md
- L116: - Script validación: scripts/validate_critical_restrictions.sh
- L117: - Restricciones: docs/requisitos/restricciones_completas.md
- L122: El Task Executor Agent identificó exitosamente problemas críticos en el código que violan las restricciones del proyecto (RNF-002). La ejecución automatizada de tareas permitió detectar:

### docs/backend/TASK-002-validar_restricciones_criticas.md
- L19: Ejecutar validación completa de restricciones críticas RNF-002.
- L52:  - Validar restricciones paso a paso (Redis, Email, pickle, WebSockets)
- L53:  - Generar verificaciones individuales para cada restricción
- L62:  - Razonamiento automático sobre por qué cada restricción es crítica
- L73:  - Conocimiento experto de restricciones Django

### docs/backend/TASK-022-performance_optimization.md
- L77:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/backend/TASK-028-etl_pipeline_automation.md
- L42:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/backend/TASK-030-api_rate_limiting.md
- L43:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/backend/TASK-031-api_versioning.md
- L38:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/backend/TASK-035-performance_benchmarking.md
- L41:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/backend/TODO.md
- L54: - [ ] **Ejecutar validation completa de restricciones cr?ticas**
- L56:  ./scripts/validate_critical_restrictions.sh
- L330:  - validate_critical_restrictions.sh
- L440: - [x] **Corregir restricciones cr?ticas en documentaci?n**
- L448:  - Commit 7a82363: Correcciones restricciones IACT
- L539: - **Restricciones**: `docs/backend/requisitos/restricciones_y_lineamientos.md`
- L564: # 1. Validar restricciones cr?ticas
- L565: ./scripts/validate_critical_restrictions.sh

### docs/backend/adr/README.md
- L58: Los ADRs deben considerar las siguientes restricciones criticas:

### docs/backend/analisis_congruencia_docs_codigo.md
- L395: - [OK] Documentada constitution (8 reglas)

### docs/backend/calidad_codigo_automatizacion.md
- L313: Según restricciones del proyecto:

### docs/backend/catalogos/CATALOGO-MODELOS.md
- L10: Documentar todos los modelos Django ORM del sistema, incluyendo campos, relaciones, indices y reglas de negocio implementadas a nivel de base de datos.

### docs/backend/catalogos/CATALOGO-SERVICIOS.md
- L91: - Aplicar reglas de negocio

### docs/backend/ci_cd/README.md
- L23: - `CI-CD-003-pipeline-validacion-restricciones.md`
- L40: - Validacion de restricciones criticas (no Redis, no SMTP)

### docs/backend/diseno/README.md
- L90: - Análisis de restricciones y mejoras

### docs/backend/diseno/api/ejemplos_rest_apis.md
- L227: 4. Cita la regla REST violada
- L674: Si tu diseño viola alguna regla de seguridad, corrígelo.

### docs/backend/diseno/arquitectura/decisions/plantilla-adr-backend.md
- L33: - ¿Cuáles son las restricciones actuales?

### docs/backend/diseno/arquitectura/patrones_arquitectonicos.md
- L332: - OK Define reglas de precedencia (negocio)
- L490: 4. **Protección**: Encapsula restricciones (read-only)

### docs/backend/diseno/diagramas/estados/STATE-CALL-001-estados-llamada.puml
- L118:   - Aplicar reglas de routing

### docs/backend/diseno/permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md
- L18: De las **5 fases de mejora propuestas**, hay **2 CONFLICTOS** con restricciones del proyecto:
- L34: **Fuente**: `docs/backend/requisitos/restricciones_y_lineamientos.md`
- L95: - [OK] La restricción dice "NO Redis **para sesiones**", no "NO Redis en general"
- L154: - [OK] No modifica restricciones de seguridad
- L198: [OK] Archivos locales rotativos (cumple restricción)
- L200: [OK] Retención configurable (30/90 días según restricción)
- L209: **Veredicto**: **VIOLA** restricción de "NO servicios externos de monitoreo"
- L286: - [OK] Cumple con restricciones del proyecto
- L317: - [OK] Compatible con restricciones de seguridad
- L441:  - Cumple restricciones
- L456: **2 de 5 fases** requieren modificaciones para cumplir con restricciones:

### docs/backend/diseno/permisos/OPTIMIZACIONES_PERFORMANCE.md
- L349: - [OK] Cumple restricciones (JSON estructurado, logging local)
- L364: - [OK] Sin PII en logs (usuario_id es OK según restricciones)
- L673: - Análisis de restricciones: `docs/backend/permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md`
- L677: # DatabaseCache (cumple restricciones)
- L699: - [OK] Logging cumple restricciones (JSON, local, sin PII)
- L754: - **Restricciones:** `docs/backend/requisitos/restricciones_y_lineamientos.md` (Sección 9: Logging)

### docs/backend/diseno/permisos/README.md
- L33: - `ANALISIS_RESTRICCIONES_VS_MEJORAS.md`: Análisis de restricciones y propuestas de mejora

### docs/backend/diseno/permisos/promptops/ADVANCED_PROMPTING_TECHNIQUES.md
- L182:  'project_restrictions': [
- L203: - Write operation restrictions
- L284:  "project_restrictions": "- NO Redis\n- NO emojis",
- L309:  "project_restrictions": restrictions_list,
- L803:  "project_restrictions": PROJECT_RESTRICTIONS

### docs/backend/diseno/permisos/promptops/CONTRIBUTING.md
- L1059: - [ ] Incluye contexto de proyecto IACT y restricciones
- L1106: - [Restricciones del Proyecto](../gobernanza/marco_integrado/restricciones_y_lineamientos.md)
- L1127: R: NO. Por restricciones del proyecto, NO dependencias externas. Los prompts son templates para uso manual o local.

### docs/backend/diseno/permisos/promptops/README.md
- L121:  "restrictions": [

### docs/backend/diseno/permisos/promptops/REORGANIZACION_SCRIPTS_AI.md
- L127: [RAZÓN] Validación crítica de restricciones → Gate pattern
- L133: [ACTUAL] scripts/validate_critical_restrictions.sh
- L134: [DESTINO] scripts/ai/agents/validation/restrictions_gate.py
- L135: [TIPO] Gate (valida restricciones del proyecto)
- L136: [RAZÓN] Validación de reglas de negocio → Gate pattern
- L137: [SHELL] scripts/ci/gate-restrictions.sh (wrapper)
- L145: [RAZÓN] Ya existe como restricción, crear gate formal
- L281:  - `gate-restrictions.sh`
- L347:  restrictions_gate.py
- L364:  gate-restrictions.sh
- L404: 3. **Crear gates faltantes** (docs, db-router, restrictions, emojis)

### docs/backend/diseno/permisos/promptops/ROADMAP_TDD_OPERATIVO.md
- L53: - Formato consistente con restricciones del proyecto
- L197: - Ejecutar localmente (respetando restricción de no servicios externos)
- L290: - [IMPORTANT] Modelo < 10GB por restricciones de almacenamiento
- L494: 1. **Mantener compatibilidad** con restricciones del proyecto

### docs/backend/diseno/permisos/promptops/gates/route_lint.md
- L486: - [Restricciones del Proyecto](../../gobernanza/marco_integrado/restricciones_y_lineamientos.md)

### docs/backend/diseno/permisos/promptops/meta/tdd_operativo.md
- L33: - NO emojis/iconos (restricción del proyecto)

### docs/backend/estilos/README.md
- L92: - Nomenclatura que refleje restricciones (ej: no usar nombres relacionados con Redis/SMTP)

### docs/backend/gobernanza/adr/ADR-BACK-001-grupos-funcionales-sin-jerarquia.md
- L107: Sistema basado en atributos y reglas dinámicas. Permisos se evalúan en runtime basándose en contexto (hora, ubicación, atributos del usuario, etc.).

### docs/backend/gobernanza/adr/ADR-BACK-002-configuracion-dinamica-sistema.md
- L358: - Valores por defecto seguros (timeouts conservadores, max attempts restrictivos)

### docs/backend/gobernanza/adr/ADR-BACK-010-django-5-framework-backend.md
- L39: - Lenguaje: Python 3.12+ (restricción corporativa)

### docs/backend/gobernanza/adr/ADR-BACK-011-postgresql-mariadb-multi-database.md
- L24: El proyecto IACT necesita integrar datos de un sistema IVR legacy existente mientras construye una nueva aplicación de analytics. Se presentan las siguientes restricciones y requerimientos:
- L178: Migrar el IVR legacy viola la restricción crítica de no modificar el sistema existente. Además, otros sistemas dependen del IVR original, no podemos reemplazarlo.
- L447: - Triggers en IVR violan restricción de no modificarlo

### docs/backend/gobernanza/adr/ADR-BACK-012-apscheduler-tareas-programadas.md
- L175: Viola restricción crítica del cliente: NO Redis, NO RabbitMQ. Aunque Celery es más potente, no podemos usarlo por política de infraestructura.
- L222: Aunque cumple restricciones, performance y estabilidad son pobres. Celery docs desaconsejan usar database como broker. APScheduler es mejor opción para scheduling simple.
- L471: - Requiere Redis (prohibido por restricción)
- L510: - RNF-002: NO Redis (restricción crítica)
- L570: - Reevaluar restricción de NO Redis/RabbitMQ con cliente
- L571: - Considerar Celery + Redis si restricción se levanta

### docs/backend/management_commands.md
- L253: 2. **Transforma** datos segun reglas de negocio

### docs/backend/planificacion/analisis_negocio/marco_integrado/00_resumen_ejecutivo_mejores_practicas.md
- L162: Las reglas atraviesan TODOS los niveles:
- L249: 3. Descubrir que necesita bcrypt (regla de seguridad)
- L254: 2. Diseñar API considerando la regla
- L335: 2. Identificar reglas de negocio aplicables (RN-XXX)
- L357:  - Vincular reglas de negocio
- L474: ¿Dónde está documentada la regla de 8 caracteres?

### docs/backend/planificacion/analisis_negocio/marco_integrado/01_marco_conceptual_iact.md
- L108: Las reglas de negocio atraviesan TODOS los niveles:
- L141:  | Establecen hechos, restricciones, desencadenadores
- L200:  Propósito: Calidad, restricción técnica, atributo del sistema
- L268: - RN-C01-01 a RN-C01-14 (14 reglas de autenticación)
- L326: - Vinculación de reglas de negocio
- L331: - Referencias a reglas
- L349: - De restricciones de calidad → RNF-XXX
- L416:  | ¿Respetan las reglas de negocio?
- L688: 2. Componente 1: Autenticación y Sesiones (14 reglas) 

### docs/backend/planificacion/analisis_negocio/marco_integrado/02_relaciones_fundamentales_iact.md
- L61:  +-- Decisión basada en reglas --> UC de validación
- L114: - Requiere decisión basada en reglas del sistema
- L262: **REGLA:** Las reglas de negocio son TRANSVERSALES y afectan todos los niveles del análisis.
- L387: **EVIDENCIA:** Esta regla impacta 6 niveles diferentes del análisis.
- L623:  | [Define restricción en]
- L724: 1. Componente 1: Autenticación y Sesiones (14 reglas) 

### docs/backend/plantilla_etl_job.md
- L55: **Ventana de ejecución permitida**: [Descripción de restricciones de horario]
- L263:  ValidationError: Si los datos no cumplen reglas de negocio
- L273:  # Cálculo: [descripción de regla de negocio]

### docs/backend/plantilla_spec.md
- L111: | BR-001 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |
- L112: | BR-002 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |

### docs/backend/plantillas/README.md
- L147: - **Restricciones críticas:** No usar Redis ni SMTP (ver restricciones del proyecto)

### docs/backend/plantillas/documentacion/plantilla-adr-backend.md
- L33: - ¿Cuáles son las restricciones actuales?

### docs/backend/plantillas/documentacion/plantilla_etl_job.md
- L55: **Ventana de ejecución permitida**: [Descripción de restricciones de horario]
- L263:  ValidationError: Si los datos no cumplen reglas de negocio
- L273:  # Cálculo: [descripción de regla de negocio]

### docs/backend/plantillas/documentacion/plantilla_spec.md
- L111: | BR-001 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |
- L112: | BR-002 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |

### docs/backend/procesos/README.md
- L123: - Validaciones de restricciones criticas (no Redis, no SMTP)

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/MAPEO-MIGRACION-BACKEND-2025-11-18.md
- L255: | TASK-002-validar_restricciones_criticas.md | sesiones/tareas/TASK-002-validar-restricciones-criticas.md | MOVER + RENOMBRAR | Tareas operacionales |
- L422: - Validar que documentacion de configuracion refleje restricciones

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-EJECUCION-TASKS-002-005.md
- L340: Todas las tareas consideraron las restricciones criticas:

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/REPORTE-LIMPIEZA-EMOJIS.md
- L452:   - /home/user/IACT/docs/backend/requisitos/restricciones_y_lineamientos.md
- L538:   - /home/user/IACT/docs/backend/TASK-002-validar_restricciones_criticas.md

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-003-crear-readmes-carpetas-nuevas/evidencias/TASK-003-LOG.md
- L55: - Validaciones automatizadas de restricciones
- L152: - Placeholders y restricciones
- L238: Cada README considera las restricciones criticas:

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-007-crear-adrs-formales/README.md
- L67: [Que restricciones tecnicas/negocio existian?]

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-011-crear-subcarpetas-en-diseno/README.md
- L232:  - Roles, politicas, reglas de acceso

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-016-mover-permisos-a-diseno-permisos/README.md
- L39: - Roles, politicas y reglas de acceso

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-048-crear-tdd-metodologia/README.md
- L435: 6. **Ignorar tests fallidos** (arreglar o eliminar)

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-049-crear-clean-architecture/README.md
- L73: La UI puede cambiar sin afectar reglas de negocio.
- L76: Las reglas de negocio no estan atadas a una DB especifica.

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-058-validar-nomenclatura/README.md
- L17: **Pensamiento**: ¿Qué reglas de nomenclatura debemos seguir?

### docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-065-crear-documento-lecciones-aprendidas/README.md
- L718: Tentación de "arreglar todo" durante reorganización.

### docs/backend/reporte_intermedio_01.md
- L114: - Actualizacion de CODEOWNERS con regla para docs/features/
- L145: - Ejecucion de script validate_critical_restrictions.sh (8/8 checks passed)

### docs/backend/requisitos/INDICE_REQUISITOS.md
- L22:  restricciones_y_lineamientos.md # Restricciones críticas del proyecto
- L294: Documento: [restricciones_y_lineamientos.md](restricciones_y_lineamientos.md)
- L430: | 2025-11-04 | 1.0 | Documentación completa RN-C01 (14 reglas) |

### docs/backend/requisitos/README.md
- L10:  reglas_negocio/ ← RN: Políticas, restricciones, cálculos

### docs/backend/requisitos/atributos_calidad/rnf002_sesiones_en_bd.md
- L24: **El sistema DEBERA** almacenar sesiones de usuarios en base de datos MySQL **usando** django.contrib.sessions.backends.db **y NO usar** Redis u otros sistemas de cache **conforme** restriccion tecnica IACT.
- L42: **Upward:** Deriva de restricciones arquitectonicas IACT

### docs/backend/requisitos/reglas_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L14: 2. **Restricciones** (`restricciones.md`) - Matriz roles/permisos
- L21: Documenta las reglas de negocio específicas del dominio backend.

### docs/backend/requisitos/reglas_negocio/calculos.md
- L5: tipo: reglas_negocio_calculos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio backend.

### docs/backend/requisitos/reglas_negocio/desencadenadores.md
- L5: tipo: reglas_negocio_desencadenadores
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio backend.

### docs/backend/requisitos/reglas_negocio/hechos.md
- L5: tipo: reglas_negocio_hechos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/backend/requisitos/reglas_negocio/inferencias.md
- L5: tipo: reglas_negocio_inferencias
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio backend.

### docs/backend/requisitos/reglas_negocio/restricciones.md
- L5: tipo: reglas_negocio_restricciones
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L17: **Constraints** (restricciones): [Definicion pendiente segun marco conceptual]
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio backend.
- L37: - [ ] Identificar restricciones especificas del dominio backend

### docs/backend/requisitos/requerimientos_funcionales/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/backend/requisitos/requerimientos_funcionales/rf001_login_credenciales.md
- L210: - Restricciones IACT: restricciones_y_lineamientos.md

### docs/backend/requisitos/requerimientos_funcionales/rf005_login_credenciales_locales.md
- L44: Los usuarios necesitan iniciar sesión de forma segura sin depender de sistemas externos (LDAP, OAuth, SAML), cumpliendo con las restricciones críticas del proyecto que prohíben métodos de autenticación externos.
- L410: Del documento `restricciones_y_lineamientos.md`:
- L492: Este requisito deriva de las reglas de negocio:
- L508: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf006_tokens_jwt.md
- L520: Del documento `restricciones_y_lineamientos.md`:
- L572: Este requisito deriva de las reglas de negocio:
- L589: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf007_logout_manual.md
- L332: Del documento `restricciones_y_lineamientos.md`:
- L399: Este requisito deriva de las reglas de negocio:
- L415: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf008_cierre_inactividad.md
- L168:  And el sistema NO envía email (prohibido por restricciones)
- L169:  And el sistema NO incluye IP address (prohibido por restricciones)
- L426: Del documento `restricciones_y_lineamientos.md`:
- L492: Este requisito deriva de las reglas de negocio:
- L508: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf009_gestion_passwords_intentos_fallidos.md
- L54: 1. **Complejidad:** Validar contraseñas nuevas contra reglas de complejidad
- L251: | **Seguridad** | Complejidad mínima | 8 caracteres + reglas | Test |
- L488: Del documento `restricciones_y_lineamientos.md`:
- L554: Este requisito deriva de las reglas de negocio:
- L572: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf010_sesion_unica.md
- L47: - Almacenar sesiones en base de datos (NO Redis) por restricción del proyecto
- L164:  And el mensaje NO contiene IP address (prohibido por restricciones)
- L427: Del documento `restricciones_y_lineamientos.md`:
- L430: - **RESTR-003:** Sesiones en PostgreSQL (NO Redis) - restricción crítica
- L499: Este requisito deriva de las reglas de negocio:
- L516: - Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/requisitos/requerimientos_funcionales/rf025_clasificar_performance_dora.md
- L53: - Aplicar reglas de mayoría
- L377: - Clasificación general debe seguir reglas de mayoría

### docs/backend/requisitos/requerimientos_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/backend/requisitos/requerimientos_negocio/n001_visibilidad_metricas_ivr_tiempo_real.md
- L250:  - Cumple TODAS las restricciones (no email, readonly IVR, sesiones BD)
- L267:  - NO cumple restricciones (requiere real-time, email notifications)
- L293: 1. **Cumplimiento restricciones**: Unica opcion que cumple 100% restricciones tecnicas (no email, BD readonly, sesiones BD, no real-time)

### docs/backend/requisitos/requerimientos_negocio/rn_c01_autenticacion_sesiones.md
- L3: tipo: reglas_negocio
- L18: **Documento:** Reglas de Negocio Detalladas (14 reglas)
- L26: ### Reglas MUST (14 reglas - 100%)
- L1847: **OK COMPONENTE 1 COMPLETO - 14/14 reglas documentadas**
- L1851: 1. **Crear Requisitos Funcionales** (RF-005 a RF-010) basados en estas reglas
- L1854: 4. **Validar** contra estas reglas de negocio

### docs/backend/requisitos/restricciones_y_lineamientos.md
- L3: tipo: restricciones
- L25: |**Propósito**|Consolidar TODAS las restricciones del proyecto|
- L318:  - Semgrep con reglas DRF
- L1117: - OK **100%** restricciones críticas
- L1118: - OK **95%** restricciones obligatorias
- L1119: - OK **80%** restricciones recomendadas

### docs/backend/requisitos/rq_plantilla.md
- L11: La plantilla maestra se mantiene en [`../gobernanza/plantillas/plantilla_regla_negocio.md`](../gobernanza/plantillas/plantilla_regla_negocio.md). Copia ese contenido como base y añade los siguientes campos adicionales cuando apliquen:

### docs/backend/requisitos/stakeholders/rs001_auditoria_requiere_trazabilidad_completa.md
- L71: La organizacion debe demostrar compliance con ISO 27001 clausula A.9.2.4 (Review of user access rights) y A.9.4.1 (Information access restriction). En auditorias trimestrales, el auditor debe poder:

### docs/backend/seguridad/ANALISIS_SEGURIDAD_AMENAZAS.md
- L65: Del documento `restricciones_y_lineamientos.md`:
- L866: - [ ] NO se almacena IP address (restricción)
- L933: - **Restricciones:** `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/backend/seguridad/PENDIENTE_ANALISIS_AMENAZAS_APLICACION.md
- L36: - [x] Revisión de restricciones de seguridad (`restricciones_y_lineamientos.md`)
- L83:  - NO email (restricción crítica)
- L340: 2. **restricciones_y_lineamientos.md**
- L341:  - Ubicación: `docs/backend/requisitos/restricciones_y_lineamientos.md`
- L343:  - **CRÍTICO:** Incorporar restricciones en el análisis:
- L404: - [ ] Incorpora todas las restricciones críticas del sistema

### docs/backend/sesiones/2025-11-11/analisis_cobertura_requisitos.md
- L348: - [ ] Alcance y restricciones

### docs/backend/template_requisito_funcional.md
- L261: | BR-[XX] | [Nombre regla] | [Descripción detallada de la lógica de negocio] | [RN-XXX] |
- L276: - [ ] [Campo X]: [regla de validación]
- L277: - [ ] [Campo Y]: [regla de validación]

### docs/backend/templates/README.md
- L117: # NOTE: Consider project restrictions

### docs/backend/trazabilidad/README.md
- L145: - Validaciones de restricciones (no Redis, no SMTP)

### docs/backend/validaciones/INDICE_VALIDACION.md
- L114: 1. **Cumplimiento 100%** de restricciones arquitectónicas

### docs/backend/validaciones/RESUMEN_VALIDACION.md
- L31:  - Ruff configurado con 40+ reglas de linting
- L210: **El proyecto está en excelente estado para continuar el desarrollo**. La arquitectura es sólida, la seguridad es robusta, y el cumplimiento de restricciones es del 100%.

### docs/backend/validaciones/VALIDACION_API_CALLCENTERSITE.md
- L11: La API Django `api/callcentersite` ha sido validada exhaustivamente. El proyecto presenta una **arquitectura sólida**, **código bien estructurado**, y **cumplimiento de las restricciones arquitectónicas** definidas (especialmente RNF-002: sesiones en base de datos).
- L317:  # ... 40+ reglas más
- L335: **Validación**: [OK] Herramientas modernas configuradas con reglas estrictas.
- L612:  - [OK] Ruff con 40+ reglas configuradas
- L686: - [OK] **Cumplimiento del 100% de restricciones arquitectónicas** (RNF-002)

### docs/backend/validaciones/VALIDACION_RAPIDA.md
- L10: El backend Django `api/callcentersite` está **correctamente estructurado** y **cumple todas las restricciones arquitectónicas críticas**:

### docs/devops/README.md
- L69: ├── gate-restrictions.sh        # Restricciones críticas
- L308: **Constitution**: Principios y reglas que rigen el comportamiento de agentes AI

### docs/devops/analysis_tfg_server_vs_iact_scripts.md
- L36: **Propósito**: Gestión automática de "constitución" de agentes AI (principios y reglas)

### docs/devops/automatizacion/planificacion/AUTOMATION_ARCHITECTURE.md
- L62: | constitucion.sh | 656 | Valida 6 reglas constitucion | COMPLETO |
- L89: # Responsibility: Validacion inteligente reglas constitucion R1-R6
- L489: - .constitucion.yaml (reglas)

### docs/devops/automatizacion/planificacion/DEPLOYMENT_PLAN.md
- L207: # 2c. Implementar evaluacion reglas (R1, R2, etc.)
- L486: # Expected: Todas reglas OK
- L656: 3. **Iteracion**: Agregar nuevas reglas si necesario

### docs/devops/automatizacion/planificacion/HLD_SISTEMA_AUTOMATIZACION.md
- L210: - `validate_critical_restrictions.sh`: Restricciones criticas
- L270: - Sistema de evolucion de reglas (warning → error)
- L385: │  │    - Conformidad constitucion (% reglas cumplidas)                   │  │
- L438:   │   │   ├─ 70+ reglas Python (E, W, F, Django, Security, etc.)
- L518:   │       CONSTITUCION: 4/5 reglas PASS, 1 WARNING
- L602:   │   │   Validar TODAS las reglas (no solo pre-push)
- L610:   │       ./scripts/validate_critical_restrictions.sh
- L714: - Evolucion gradual de reglas (warning → error)
- L965: # Sistema de evolucion de reglas
- L969:     2. Proponer nueva regla en issue/discussion
- L971:     4. Agregar regla con severity: warning
- L974:     7. Si compliance bajo: refinar regla o descartarla
- L979:       change: "Constitucion inicial con 6 reglas"
- L985:     #   change: "Agregar regla R7: Branch debe tener issue asociado"
- L998:       description: "% commits/pushes que cumplen todas las reglas ERROR"
- L1041:   pre-commit:         Valida reglas scope=pre-commit
- L1042:   pre-push:           Valida reglas scope=pre-push
- L1043:   devcontainer-init:  Valida reglas scope=devcontainer-init
- L1044:   validate-all:       Valida TODAS las reglas (CI local)
- L1211:       - name: validate_critical_restrictions
- L1212:         command: "./scripts/validate_critical_restrictions.sh"
- L1358: 6. **CONTRIBUTING.md**: Como agregar nuevas validaciones/reglas
- L1390: **Contexto**: Necesitamos almacenar reglas gobernanza.
- L1401: - Code review (PRs para cambiar reglas)
- L1467:    - Crear .constitucion.yaml inicial (6 reglas)
- L1497: - Target: 95% commits cumplen reglas ERROR
- L1524:   - Empezar con pocas reglas (6), solo criticas
- L1526:   - Involucrar equipo en definicion reglas
- L1539: - Riesgo: .constitucion.yaml no evoluciona, reglas obsoletas
- L1543:   - Review trimestral reglas

### docs/devops/automatizacion/planificacion/LLD_00_OVERVIEW.md
- L58:    - 6 reglas con condiciones, acciones, mensajes
- L59:    - Sistema evolución reglas

### docs/devops/automatizacion/planificacion/LLD_01_CONSTITUCION.md
- L582:     Proceso para agregar/modificar reglas:
- L588:     2. PROPONER nueva regla
- L590:        - Describir: problema, regla propuesta, severity, automation
- L596:     4. AGREGAR regla con severity: warning
- L604:        - Ajustar regla si compliance bajo
- L612:        - Si compliance mantenido: regla permanente
- L613:        - Si compliance <50%: descartarregla
- L618:     - Automation script DEBE existir antes de aprobar regla
- L662:       description: "Porcentaje de commits/pushes que cumplen TODAS las reglas severity=error"
- L796: Validar conformidad con principios y reglas codificadas en .constitucion.yaml
- L802:     pre-commit          Valida reglas scope=pre-commit
- L803:     pre-push            Valida reglas scope=pre-push
- L804:     devcontainer-init   Valida reglas scope=devcontainer-init
- L805:     validate-all        Valida TODAS las reglas (CI local)
- L820:     0   Todas las reglas pasaron (o solo warnings)
- L821:     1   Al menos una regla ERROR violada

### docs/devops/automatizacion/planificacion/LLD_02_CI_LOCAL.md
- L336:       # Validacion restricciones criticas
- L337:       - name: validate_critical_restrictions
- L338:         description: "Validar restricciones criticas proyecto"
- L340:         command: "./scripts/validate_critical_restrictions.sh"

### docs/devops/automatizacion/planificacion/LLD_04_SCRIPTS_HELPERS.md
- L39: **Invocado por**: constitucion.sh (regla R3_ui_api_coherence)
- L156: - constitucion.sh (regla R6_devcontainer_compatibility)
- L729: exit 0  # Todas las reglas pasaron
- L730: exit 1  # Al menos 1 regla severity=error fallo

### docs/devops/automatizacion/planificacion/LLD_05_INSTALACION.md
- L475: # Expected: [OK] Todas las reglas validadas
- L682: # Contar violaciones por regla
- L699: 1. Editar .constitucion.yaml (agregar regla en `rules:`)
- L707:   - id: R7_nueva_regla

### docs/devops/automatizacion/planificacion/MAINTENANCE_PLAN.md
- L174: # Contar violaciones por regla (semanal)
- L288: # 1. Definir nueva regla
- L311: # 4. Agregar regla a .constitucion.yaml
- L336: # Expected: OK (nueva regla funciona)
- L424: - Nueva regla constitucion agregada → Actualizar LLD_01
- L441: - Agregada regla R7_no_todos_in_code
- L479: - [ ] Leer .constitucion.yaml (reglas proyecto)
- L560:    - Ajustar reglas
- L672: # 1. Marcar regla deprecated en .constitucion.yaml
- L685: # 6. Remover regla completamente
- L779: - [ ] Agregar regla R7_no_todos_in_code

### docs/devops/automatizacion/planificacion/TESTING_PLAN.md
- L202: #### 2.1.6 Test: Todas reglas pasan

### docs/devops/infraestructura/mcp_github_quickstart.md
- L270: - El archivo `.bashrc` tenga permisos restrictivos (`chmod 600`)

### docs/devops/infraestructura/runbooks/claude_code.md
- L29: El entorno de ejecución de Claude Code tiene restricciones de red y permisos que impiden la instalación de GitHub CLI (`gh`).
- L61: - [OK] Evita restricciones de red y permisos
- L176: 5. [OK] **Archivo .bashrc** con permisos restrictivos:
- L452: - Proxy/firewall restrictivo
- L558: - **2025-11-02 v2**: Aplicar regla de NO emojis (docs/gobernanza/estandares_codigo.md)

### docs/devops/infraestructura/runbooks/github_copilot_codespaces.md
- L92: > **Tip:** ante restricciones de red persistentes, coordinar con TI la creación de un túnel temporal usando la VPN corporativa oficial antes de iniciar Codespaces.

### docs/devops/infraestructura/runbooks/playbooks_operativos/github_copilot_cli_403_forbidden.md
- L24: - **Entorno**: Redes corporativas con posibles restricciones de proxy/firewall
- L121: | 403 persiste con registry correcto | Firewall/DLP corporativo | [Solución 3](#solución-3-gestionar-restricciones-corporativas) |
- L180: # Si funciona, confirma que es restricción corporativa
- L584: # - Confirma que es restricción corporativa

### docs/dora/template_requisito_negocio.md
- L243: | C-01 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |
- L244: | C-02 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |

### docs/frontend/ANALISIS_REFACTORING_CPYTHON.md
- L640: - Subtarea 0.1.2: Definir 8 reglas (4 CRITICAL, 2 HIGH, 2 MEDIUM)
- L1373: - [ ] 8/8 reglas implementadas
- L1405:    - Definir 8 reglas inmutables

### docs/frontend/analisis_negocio/marco_integrado/03_matrices_trazabilidad_iact.md
- L134: PREGUNTA: ¿Hay requisitos sin regla de negocio?
- L136: ACCION: Investigar si existe RN no documentada o si RF no tiene restricción
- L145: Mostrar el impacto de cada regla de negocio en casos de uso, requisitos y tests.
- L278: - Total reglas componente autenticación: 10 (de 14 documentadas en RN-C01)
- L296: PREGUNTA: ¿Cuántas reglas de negocio tenemos?
- L297: RESPUESTA: 10 reglas documentadas en RN-C01 (Componente Autenticación)
- L299: PREGUNTA: ¿Todas las reglas tienen casos de uso?
- L300: RESPUESTA: SI - Todas las reglas impactan al menos 1 UC
- L302: PREGUNTA: ¿Todas las reglas tienen requisitos?
- L305: PREGUNTA: ¿Todas las reglas tienen tests?
- L308: PREGUNTA: ¿Qué regla tiene más impacto?
- L593: 2. Componente 1: Autenticación (14 reglas completas)  

### docs/frontend/analisis_negocio/marco_integrado/04_metodologia_analisis_iact.md
- L44: Entender el contexto de negocio, identificar reglas obligatorias y modelar procesos actuales y futuros.
- L131: - Fuente de cada regla
- L675: - Referencias a reglas
- L690: Derivar requisitos funcionales y no funcionales detallados a partir de casos de uso y reglas de negocio.
- L724: - Con trazabilidad a regla de negocio
- L874: ├─ Identificar reglas (RN-C01-01 a RN-C01-14)

### docs/frontend/arquitectura/analisis_api_frontend.md
- L13: 2. Para cada dominio se revisaron las docstrings y reglas de negocio descritas en las vistas para extraer operaciones, parámetros y acciones secundarias.

### docs/frontend/arquitectura/ejemplos_ui_design.md
- L28: <contexto>: descripción breve del producto, usuarios y restricciones
- L30: <restricciones>: browser storage, datos reales/mocks, lineamientos de marca
- L108: Metodología: Auto-CoT detallando reglas WCAG relevantes, indicar cómo evitar falsos positivos (alucinaciones de herramientas).

### docs/frontend/arquitectura/microfrontends_canvas.md
- L63: * **Retos**: gestión de reglas y observabilidad; sigue habiendo navegación dura.
- L159: * **Aislamiento selectivo**: módulos de terceros o alta seguridad por iframe con postMessage y Content Security Policy restrictiva.

### docs/frontend/arquitectura/shared_webpack_configs.md
- L171: 2. **Unificar reglas con `mergeWithRules`** cuando se necesite extender loaders

### docs/frontend/requisitos/reglas_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L14: 2. **Restricciones** (`restricciones.md`) - Matriz roles/permisos
- L21: Documenta las reglas de negocio específicas del dominio frontend.

### docs/frontend/requisitos/reglas_negocio/calculos.md
- L5: tipo: reglas_negocio_calculos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio frontend.

### docs/frontend/requisitos/reglas_negocio/desencadenadores.md
- L5: tipo: reglas_negocio_desencadenadores
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio frontend.

### docs/frontend/requisitos/reglas_negocio/hechos.md
- L5: tipo: reglas_negocio_hechos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/frontend/requisitos/reglas_negocio/inferencias.md
- L5: tipo: reglas_negocio_inferencias
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio frontend.

### docs/frontend/requisitos/reglas_negocio/restricciones.md
- L5: tipo: reglas_negocio_restricciones
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L17: **Constraints** (restricciones): [Definicion pendiente segun marco conceptual]
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio frontend.
- L37: - [ ] Identificar restricciones especificas del dominio frontend

### docs/frontend/requisitos/requerimientos_funcionales/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/frontend/requisitos/requerimientos_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/gobernanza/ANALISIS_GUIAS_WORKFLOWS.md
- L63: - Jobs: lint, test-mysql, test-postgresql, validate-restrictions, integration-tests
- L320: 5. scripts/validate_critical_restrictions.sh
- L322:    - Activacion: ./scripts/validate_critical_restrictions.sh
- L516: 3. checklist_auditoria_restricciones.md
- L517:    - Proposito: Validar restricciones criticas
- L733:   - Como validar restricciones criticas
- L792: 4. Como validar restricciones (script: validate_critical_restrictions.sh)

### docs/gobernanza/CHANGELOG.md
- L462: - Documentacion ahora cumple con restriccion critica RNF-NO-EMOJIS
- L681: - NO usar IA para: Decisiones arquitectonicas criticas, security final, merge sin review, credenciales, cambios en restricciones
- L820: - `docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md`
- L837:   - Agregado `checklist_auditoria_restricciones.md`
- L966: - `scripts/validate_critical_restrictions.sh`

### docs/gobernanza/MAPEO_MIGRACION_LEGACY.md
- L105: - plantilla_regla_negocio.md
- L126: - checklist_auditoria_restricciones.md -> gobernanza/procesos/qa/

### docs/gobernanza/RESUMEN_MIGRACION_SHELL_SCRIPTS.md
- L18: - [x] Constitution-compliant (8 reglas)
- L105: ### Constitution Compliance [PASS 8/8 reglas]
- L304: 5. **Constitution ayuda**: Tener reglas claras mejora consistencia
- L312: - Constitution compliance: 100% (8/8 reglas)

### docs/gobernanza/ROADMAP.md
- L26: 3. **Compliance total** con restricciones criticas (RNF-002, NO Redis)
- L41: - [ ] Validacion completa de restricciones
- L80: - [ ] Pre-commit hooks con validacion restricciones
- L138: - 0 incidents por restricciones violadas
- L285: - Validacion restricciones completa

### docs/gobernanza/TAREAS_ACTIVAS.md
- L50: - [ ] **Validar restricciones criticas** `P0` `1SP`
- L51:   - Comando: `./scripts/validate_critical_restrictions.sh`

### docs/gobernanza/TASK-015-actualizacion_documentacion.md
- L102: **Nuevas reglas agregadas:**
- L259:    - `.github/CODEOWNERS` - Agregada regla para `docs/features/`
- L406: 4. Actualizado CODEOWNERS con regla para docs/features/

### docs/gobernanza/TASK-016-compliance_rnf_002_audit.md
- L21: El requisito RNF-002 establece restricciones tecnologicas criticas para el proyecto IACT:
- L46:  - Verificar cumplimiento de politicas y restricciones organizacionales
- L75: - Script `validate_critical_restrictions.sh`
- L248: **Script:** `scripts/validate_critical_restrictions.sh`
- L252: ./scripts/validate_critical_restrictions.sh
- L258: [INFO] Validando restricciones criticas del proyecto IACT...
- L410: ./scripts/validate_critical_restrictions.sh
- L453:  run: ./scripts/validate_critical_restrictions.sh
- L473: ./scripts/validate_critical_restrictions.sh
- L493: - Razon de cada restriccion
- L529:  - `scripts/validate_critical_restrictions.sh`
- L530:  - Validacion automatica de todas las restricciones
- L538: Script: validate_critical_restrictions.sh
- L580: - [TASK-002: Validar Restricciones Criticas](../qa/TASK-002-validar-restricciones-criticas.md)
- L587: - [validate_critical_restrictions.sh](../../scripts/validate_critical_restrictions.sh)

### docs/gobernanza/adr/ADR-AI-018-ai-services-standalone-architecture.md
- L133: - OK Framework de agentes puede evolucionar rapidamente sin restricciones

### docs/gobernanza/adr/ADR-BACK-001-grupos-funcionales-sin-jerarquia.md
- L102: Sistema basado en atributos y reglas dinámicas. Permisos se evalúan en runtime basándose en contexto (hora, ubicación, atributos del usuario, etc.).

### docs/gobernanza/adr/ADR-BACK-002-configuracion-dinamica-sistema.md
- L269: - Valores por defecto seguros (timeouts conservadores, max attempts restrictivos)

### docs/gobernanza/adr/ADR-DEV-002-workflow-validation-shell-migration.md
- L102: Migrar TODA la lógica embebida a scripts shell standalone en scripts/validation/ organizados por categoría, con constitution (SHELL_SCRIPTS_CONSTITUTION.md) que define 8 reglas inmutables para calidad y consistencia.
- L111: **Constitution (8 reglas)**:
- L178: - OK Constitution garantiza calidad (8/8 reglas)
- L230: - Constitution compliance: 100% (8/8 reglas) [OK]
- L334: 4. Constitution ayuda (reglas claras mejoran consistencia)

### docs/gobernanza/adr/ADR-DEVOPS-001-vagrant-mod-wsgi.md
- L151: 4. **Sin restricciones de licencia**: VirtualBox es libre y open source

### docs/gobernanza/adr/ADR-DEVOPS-004-distribucion-artefactos-strategy.md
- L414:    Para equipos enterprise con restricciones de acceso externo

### docs/gobernanza/adr/ADR-GOB-003-relacion-gobernanza-dominios.md
- L153:     ├── reglas_negocio/

### docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md
- L27: - Tratar reglas de negocio como requisitos funcionales
- L95: **Ubicación en proyecto**: `docs/gobernanza/requisitos/reglas_negocio/`
- L202: ├── reglas_negocio/
- L304: - No captura reglas de negocio explícitamente
- L321: - No captura reglas de negocio externas
- L355:    - Cada feature se justifica desde reglas de negocio hasta atributos de calidad
- L366:    - Cambio en regla de negocio se propaga correctamente
- L457: 1. Identificar reglas de negocio actuales
- L493: - [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](ADR-GOB-006-clasificacion-reglas-negocio.md)

### docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md
- L21: Las reglas de negocio son el nivel más alto en la jerarquía de requerimientos (ver ADR-GOB-005) y representan políticas, leyes y estándares bajo los cuales opera la organización. Sin una clasificación clara, se presentan problemas:
- L26: - No se distingue entre un hecho inmutable y una restricción modificable
- L27: - Confusión entre reglas que desencadenan acciones vs. reglas que calculan valores
- L36: - Cambios en reglas requieren buscar en documentación sin estructura
- L37: - No se sabe dónde buscar cierto tipo de regla
- L41: - Desarrolladores interpretan reglas de manera diferente
- L42: - No queda claro si una regla genera conocimiento o ejecuta acción
- L47: El proyecto IACT opera bajo múltiples tipos de reglas:
- L55: - Clasificación clara de cada tipo de regla
- L62: **Adoptar clasificación de reglas de negocio en 5 tipos con herramientas específicas de documentación para cada uno.**
- L125: tipo: regla_negocio
- L196: Para restricciones basadas en roles de usuario, usar matriz:
- L218: tipo: regla_negocio
- L219: subtipo: restriccion
- L231: [Declaración clara de la restricción usando palabras clave: debe, no debe, no puede, solo puede]
- L241: [Por qué existe esta restricción: seguridad, regulación, política]
- L244: [Si existen excepciones a la restricción]
- L305: tipo: regla_negocio
- L319: **SI**: [Condición o evento que dispara la regla]
- L332: [Qué tan frecuente se espera que se active esta regla]
- L401: tipo: regla_negocio
- L448: - Frecuentemente siguen reglas externas (impuestos, estándares)
- L486: Para reglas complejas, usar representación tabular:
- L510: tipo: regla_negocio
- L586: RN-BACK-028-restriccion-acceso-gerentes.md
- L595: docs/gobernanza/requisitos/reglas_negocio/
- L600: ├── restricciones/
- L625: **Descripción**: Todas las reglas en un solo tipo, sin distinción.
- L637: **Razón de rechazo**: Inadecuado para proyectos complejos con múltiples tipos de reglas.
- L649: - No captura diferencia entre hechos y restricciones
- L673: **Descripción**: Estándar OMG para vocabulario y reglas de negocio.
- L693:    - Tipo de regla explícito
- L704:    - Fácil encontrar reglas específicas
- L713:    - Stakeholders entienden mejor las reglas
- L714:    - Matrices visuales para restricciones
- L731:    - Tiempo para decidir tipo de cada regla
- L760: - `templates/RN-restriccion-template.md`
- L767: Revisar documentación actual e identificar reglas de negocio no documentadas:
- L774: Documentar primeras 20-30 reglas de negocio más críticas.
- L780: - 100% de nuevas reglas clasificadas en uno de los 5 tipos
- L787: - Número de reglas por tipo

### docs/gobernanza/adr/ADR-GOB-007-especificacion-casos-uso.md
- L44: - Sin referencias a reglas de negocio
- L62: 3. **Trazabilidad completa**: Desde reglas de negocio hasta requisitos funcionales
- L434: **Nota**: Solo listar RNF y restricciones **específicos** de este caso de uso, no todos los del sistema.
- L441: - RN-DOMINIO-###: [Nombre de la regla]
- L442: - RN-DOMINIO-###: [Nombre de la regla]
- L445: **Propósito**: Trazabilidad. Permite rastrear qué reglas de negocio influyen en este caso de uso.
- L611:    - Referencias a reglas de negocio
- L655:    - Cambios en reglas de negocio requieren actualizar casos de uso
- L706: 3. Agregar secciones faltantes (precondiciones, reglas de negocio, etc.)
- L722: - 100% de casos de uso tienen referencias a reglas de negocio relevantes
- L739: - [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](ADR-GOB-006-clasificacion-reglas-negocio.md)

### docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md
- L26: - Cambio en regla de negocio no actualiza casos de uso afectados
- L33: - ¿Qué reglas de negocio afectan este módulo?
- L38: - Difícil confirmar que reglas de negocio están implementadas
- L48: 1. **Trazabilidad bidireccional**: Desde reglas de negocio hasta código y viceversa
- L116: [Contenido de la regla...]
- L307:     if ! find docs/gobernanza/requisitos/reglas_negocio -name "*$id*" | grep -q .; then
- L521:    - Trazabilidad desde código hasta reglas
- L608: - [ADR-GOB-006: Clasificación de Reglas de Negocio](ADR-GOB-006-clasificacion-reglas-negocio.md)

### docs/gobernanza/adr/ADR-GOB-010-gobernanza-multinivel.md
- L101: │   │   ├── PROCED-GOB-003-documentar-regla-negocio.md

### docs/gobernanza/adr/ADR-QA-001-suite-calidad-codigo.md
- L46: - **Cumplimiento**: Adherencia a restricciones del proyecto
- L73: - OK Cumple restricción: NO servicios externos (sin Sentry)
- L152: - NO **Viola restricción crítica**: NO Sentry permitido
- L156: - NO No cumple con restricciones del proyecto
- L162: Implementar la suite completa de herramientas de calidad de código y automatización, **sin Sentry** para cumplir con restricciones del proyecto.
- L168: 4. **Cumplimiento**: Sin servicios externos, logging local cumple restricciones
- L175: - NO **NO implementar Sentry** por restricción explícita del proyecto
- L193: - OK **Cumplimiento con restricciones**: Sin servicios externos
- L324: - NO **Prohibido por restricciones del proyecto**
- L346: - [Restricciones Completas](../gobernanza/marco_integrado/restricciones_completas.md) - Documento maestro
- L354: El proyecto originalmente consideró Sentry para monitoreo de errores en producción, pero las restricciones del cliente prohiben servicios externos de monitoreo.
- L364: - OK Cumple restricciones del cliente
- L403: | 1.1 | 2025-11-04 | Removido Sentry por restricciones |

### docs/gobernanza/adr/README.md
- L177: **Contexto:** Asegurar que cambios cumplen con principios y restricciones fundamentales del proyecto.

### docs/gobernanza/adr/plantilla_adr.md
- L27: - ¿Cuáles son las restricciones actuales?

### docs/gobernanza/casos_de_uso_guide.md
- L236: - **RN-XXX**: [Nombre de regla] - Aplica en paso Y
- L237: - **RN-YYY**: [Otra regla] - Validación en paso Z

### docs/gobernanza/catalogos/catalogo_reglas_negocio.md
- L9: # Catálogo de reglas de negocio

### docs/gobernanza/checklists/checklist_trazabilidad_requisitos.md
- L4: - [ ] Cada caso de uso enlaza con reglas de negocio correspondientes.

### docs/gobernanza/ci_cd/GUIA_USO.md
- L51: # Validar restricciones IACT
- L258: ./scripts/validate_critical_restrictions.sh
- L486: - [ ] Cumple restricciones IACT (RNF-002)

### docs/gobernanza/ci_cd/INDICE.md
- L83: ./scripts/validate_critical_restrictions.sh
- L144: - [restricciones_y_lineamientos.md](../../backend/requisitos/restricciones_y_lineamientos.md) - RNF-002

### docs/gobernanza/ci_cd/README.md
- L20: 4. [Restricciones IACT](#restricciones-iact)
- L63: 6. Validacion scripts (validate_critical_restrictions.sh)
- L65: **RNF-002**: Script valida restricciones IACT automaticamente.
- L176: - validate-restrictions (RNF-002)
- L376: - backend-ci.yml: Job `validate-restrictions`
- L421: - RNF-002: docs/backend/requisitos/restricciones_y_lineamientos.md

### docs/gobernanza/claude_code.md
- L29: El entorno de ejecución de Claude Code tiene restricciones de red y permisos que impiden la instalación de GitHub CLI (`gh`).
- L61: - [OK] Evita restricciones de red y permisos
- L176: 5. [OK] **Archivo .bashrc** con permisos restrictivos:
- L452: - Proxy/firewall restrictivo
- L558: - **2025-11-02 v2**: Aplicar regla de NO emojis (docs/gobernanza/estandares_codigo.md)

### docs/gobernanza/diseno/arquitectura/TASK-010-logging_estructurado_json.md
- L70:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/gobernanza/diseno/arquitectura/TASK-011-data_centralization_layer.md
- L60:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/gobernanza/diseno/arquitectura/TASK-029-data_quality_framework.md
- L43:    - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/gobernanza/diseno/arquitectura/patrones/DESIGN_PATTERNS_GUIDE.md
- L166: **Cuándo usarlo:** rara vez. Introduce estado global difícil de testear; úsalo solo si la restricción de instancia única es imprescindible.

### docs/gobernanza/documentacion_corporativa.md
- L52: - [ ] Cumple la regla de cinco minutos.
- L157: | Requisitos | Documentar necesidades, reglas | Herramientas de gestión de requisitos |
- L194: - `req_funcional`, `req_no_funcional`, `regla_negocio`, `caso_uso`.
- L388: - Catálogo de reglas de negocio publicado (WKF-SDLC-104).
- L400: 9. Vincular reglas de negocio y requisitos especiales.
- L459: - Garantizar trazabilidad con reglas de negocio.
- L483: - Definiciones, taxonomía (hechos, restricciones, desencadenadores, inferencias, cálculos).
- L484: - Plantilla: `plantillas/plantilla_regla_negocio.md`.
- L485: - Catálogo: `anexos/catalogo_reglas_negocio.md`.
- L494: - Incluye reglas, requisitos, trazabilidad.
- L497: - Mantener tabla que vincule UC, reglas, requisitos, NFR.
- L508: - Diseño de base de datos deriva de TDD y reglas de negocio.
- L605: | Crear reglas de negocio | C | A | R | C | I | C |

### docs/gobernanza/estandares_codigo.md
- L32: 1. [Regla Fundamental: Output Profesional](#regla-fundamental-output-profesional)
- L224: La única excepción a esta regla es:
- L554:   - Agregar regla fundamental sobre emojis

### docs/gobernanza/estilos/estandares_codigo.md
- L33: 1. [Regla Fundamental: Output Profesional](#regla-fundamental-output-profesional)
- L225: La única excepción a esta regla es:
- L555:   - Agregar regla fundamental sobre emojis

### docs/gobernanza/estilos/shell_scripting_guide.md
- L223: **IMPORTANTE**: Esta sección implementa la "Regla Fundamental" definida en [Estándares de Código](estandares_codigo.md#regla-fundamental-output-profesional).
- L376: | S4 | Archivos temporales seguros | ALTO | Usar mktemp con permisos restrictivos |
- L711: # Excluir reglas específicas (documentar por qué en código)
- L805: - [Estándares de Código - Regla Fundamental](estandares_codigo.md#regla-fundamental-output-profesional)

### docs/gobernanza/glosarios/glossary.md
- L13: | RN | Requisito no funcional que describe restricciones de calidad o plataforma. |

### docs/gobernanza/glossary.md
- L14: | RN | Requisito no funcional que describe restricciones de calidad o plataforma. |

### docs/gobernanza/guias/GUIA-GOB-003-ubicaciones_artefactos.md
- L1112:     reglas_contextuales = {
- L1144:     return reglas_contextuales.get(key, "ANALIZAR_MANUAL")

### docs/gobernanza/guias/GUIA-GOB-005-derivar-requisitos-entre-niveles.md
- L88: **Pregunta clave**: ¿Qué objetivo de negocio necesitamos lograr para cumplir esta regla?
- L103: **Razonamiento**: La regla legal (RN) se traduce en objetivos medibles de negocio (RNEG).
- L562: - [ADR-GOB-006: Clasificación de Reglas de Negocio](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)
- L568: 1. Leer [GUIA-GOB-006: Identificar y Clasificar Reglas de Negocio](GUIA-GOB-006-identificar-clasificar-reglas-negocio.md)

### docs/gobernanza/guias/GUIA-GOB-006-identificar-clasificar-reglas-negocio.md
- L17: Esta guía enseña cómo identificar reglas de negocio en documentación, conversaciones y código existente, y cómo clasificarlas correctamente en uno de los 5 tipos establecidos en ADR-GOB-006.
- L29: - Se documentan reglas de negocio como "texto libre" sin estructura
- L30: - No se distingue entre hechos inmutables y restricciones modificables
- L63: **Definición**: Políticas, leyes, estándares y restricciones bajo las cuales opera la organización.
- L114: - ¿Qué restricciones existen?
- L116: - ¿Qué reglas no se pueden romper?
- L190: Una oración contiene una regla de negocio SI:
- L280: tipo: regla_negocio
- L354: Si la restricción es sobre **roles y operaciones**, usar matriz en lugar de texto:
- L378: tipo: regla_negocio
- L379: subtipo: restriccion
- L398: [Si hay excepciones a la restricción]
- L498: tipo: regla_negocio
- L622: tipo: regla_negocio
- L737: tipo: regla_negocio
- L783: Clasifica cada regla en uno de los 5 tipos:
- L860: **Tarea**: Extraer y clasificar todas las reglas de negocio.
- L904: **Solución**: Separar en 2 reglas
- L966: Antes de documentar una regla, verificar:
- L968: - [ ] ¿La regla está redactada claramente en una oración?
- L971: - [ ] ¿La regla contiene fórmula matemática? (entonces es CÁLCULO)
- L972: - [ ] ¿La regla contiene "debe", "no puede"? (probablemente es RESTRICCIÓN)
- L973: - [ ] ¿La regla describe estructura inmutable? (probablemente es HECHO)
- L974: - [ ] ¿He separado reglas mezcladas en reglas atómicas?
- L975: - [ ] ¿La regla tiene ID único asignado?
- L980: - [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)
- L987: 2. Revisar código existente para extraer reglas de negocio
- L989: 4. Documentar primeras 10-20 reglas de negocio del proyecto

### docs/gobernanza/guias/GUIA-GOB-007-escribir-casos-uso-efectivos.md
- L772: - [ ] ¿He identificado las reglas de negocio (RN) que aplican?
- L808: - [ ] ¿Lista reglas de negocio (RN) relacionadas?

### docs/gobernanza/guias/GUIA-GOB-009-documentacion-uml-completa.md
- L631: ' Backend -> Email (según restricción: NO Email en dev)

### docs/gobernanza/guias/README.md
- L128: - Como usar validate_critical_restrictions.sh

### docs/gobernanza/guias/deployment/deployment_002.md
- L17: Aprende a validar que tu código no viola restricciones críticas del proyecto (RNF-002).
- L26: - [ ] Script validate_critical_restrictions.sh disponible
- L35: ### 1. Ejecutar validación de restricciones
- L37: Ejecuta el script que valida restricciones críticas.
- L41: ./scripts/validate_critical_restrictions.sh
- L46: All critical restrictions validated: PASSED
- L49: ### 2. Revisar restricciones validadas
- L70: Si falla, revisa qué restricción violaste.
- L136: - Script validación: `scripts/validate_critical_restrictions.sh`
- L137: - RNF-002: `docs/requisitos/rnf-002-restricciones-criticas.md`

### docs/gobernanza/guias/deployment/deployment_005_tdd_frontend_permisos_granular.md
- L753:   it('renderiza children cuando requiredCapability es null (sin restriccion)', () => {

### docs/gobernanza/guias/scripts/generate_guides.md
- L196: Generada: docs/guias/deployment/validar_restricciones_criticas.md
- L277: │   └── validar_restricciones_criticas.md

### docs/gobernanza/guias/scripts/validate_critical_restrictions.md
- L2: title: Script: validate_critical_restrictions.sh
- L8: # Script: validate_critical_restrictions.sh
- L10: **Ubicacion:** `scripts/validate_critical_restrictions.sh`
- L11: **Proposito:** Validar restricciones criticas del proyecto IACT (RNF-002)
- L17: Script Bash que valida el cumplimiento de restricciones criticas definidas en RNF-002. Se ejecuta en CI/CD para asegurar que el codigo no use tecnologias prohibidas.
- L94: ./scripts/validate_critical_restrictions.sh
- L97: bash /path/to/scripts/validate_critical_restrictions.sh
- L104: | 0 | Todas las restricciones pasan (SUCCESS) |
- L105: | 1 | Una o mas restricciones fallan (FAIL) |
- L109: ### Cuando TODAS las restricciones pasan:
- L112: [INFO] Validando restricciones criticas del proyecto IACT...
- L147: [INFO] Validando restricciones criticas del proyecto IACT...
- L167:    2. Corregir el codigo segun las restricciones
- L169:    4. Consultar: docs/requisitos/restricciones_completas.md
- L188:   validate-restrictions:
- L193:       - name: Validate critical restrictions
- L195:           chmod +x scripts/validate_critical_restrictions.sh
- L196:           ./scripts/validate_critical_restrictions.sh
- L444:    ./scripts/validate_critical_restrictions.sh
- L451:    ./scripts/validate_critical_restrictions.sh
- L462: ## Justificacion: Por que estas restricciones?
- L491: - Codigo fuente: `scripts/validate_critical_restrictions.sh`
- L492: - RNF-002: `docs/requisitos/rnf-002-restricciones-criticas.md`

### docs/gobernanza/marco_integrado/00_resumen_ejecutivo_mejores_practicas.md
- L161: Las reglas atraviesan TODOS los niveles:
- L248: 3. Descubrir que necesita bcrypt (regla de seguridad)
- L253: 2. Diseñar API considerando la regla
- L334: 2. Identificar reglas de negocio aplicables (RN-XXX)
- L356:    - Vincular reglas de negocio
- L473: ¿Dónde está documentada la regla de 8 caracteres?

### docs/gobernanza/marco_integrado/01_marco_conceptual_iact.md
- L108: Las reglas de negocio atraviesan TODOS los niveles:
- L141:     | Establecen hechos, restricciones, desencadenadores
- L200: ├─ Propósito: Calidad, restricción técnica, atributo del sistema
- L268: - RN-C01-01 a RN-C01-14 (14 reglas de autenticación)
- L326: - Vinculación de reglas de negocio
- L331: - Referencias a reglas
- L349: - De restricciones de calidad → RNF-XXX
- L416:     | ¿Respetan las reglas de negocio?
- L688: 2. Componente 1: Autenticación y Sesiones (14 reglas)  

### docs/gobernanza/marco_integrado/02_relaciones_fundamentales_iact.md
- L60:                +-- Decisión basada en reglas --> UC de validación
- L113: - Requiere decisión basada en reglas del sistema
- L261: **REGLA:** Las reglas de negocio son TRANSVERSALES y afectan todos los niveles del análisis.
- L386: **EVIDENCIA:** Esta regla impacta 6 niveles diferentes del análisis.
- L622:     | [Define restricción en]
- L723: 1. Componente 1: Autenticación y Sesiones (14 reglas)  

### docs/gobernanza/marco_integrado/03_matrices_trazabilidad_iact.md
- L133: PREGUNTA: ¿Hay requisitos sin regla de negocio?
- L135: ACCION: Investigar si existe RN no documentada o si RF no tiene restricción
- L144: Mostrar el impacto de cada regla de negocio en casos de uso, requisitos y tests.
- L277: - Total reglas componente autenticación: 10 (de 14 documentadas en RN-C01)
- L295: PREGUNTA: ¿Cuántas reglas de negocio tenemos?
- L296: RESPUESTA: 10 reglas documentadas en RN-C01 (Componente Autenticación)
- L298: PREGUNTA: ¿Todas las reglas tienen casos de uso?
- L299: RESPUESTA: SI - Todas las reglas impactan al menos 1 UC
- L301: PREGUNTA: ¿Todas las reglas tienen requisitos?
- L304: PREGUNTA: ¿Todas las reglas tienen tests?
- L307: PREGUNTA: ¿Qué regla tiene más impacto?
- L592: 2. Componente 1: Autenticación (14 reglas completas)  

### docs/gobernanza/marco_integrado/04_metodologia_analisis_iact.md
- L43: Entender el contexto de negocio, identificar reglas obligatorias y modelar procesos actuales y futuros.
- L130: - Fuente de cada regla
- L674: - Referencias a reglas
- L689: Derivar requisitos funcionales y no funcionales detallados a partir de casos de uso y reglas de negocio.
- L723: - Con trazabilidad a regla de negocio
- L873: ├─ Identificar reglas (RN-C01-01 a RN-C01-14)

### docs/gobernanza/marco_integrado/05a_casos_practicos_iact.md
- L540: | 8 | **NIVEL 3**: Sistema valida restricciones contextuales (ej: solo datos propios) |
- L589: 3. El sistema debe validar restricciones contextuales (ownership, jerarquía)
- L852:   |--Si--> [Evaluar reglas de detección de amenazas]
- L934: | 2 | Sistema aplica reglas de detección de amenazas |
- L1150: | 6b | Si falso positivo | Hacer clic en "Marcar como Falso Positivo" | Sistema actualiza alerta y ajusta regla |

### docs/gobernanza/marco_integrado/05b_caso_didactico_generico.md
- L1036: | **Reglas de Negocio** | 5 reglas (edad, documentos, biometría, riesgo, score) | 14 reglas (RN-C01-01 a RN-C01-14) |

### docs/gobernanza/marco_integrado/06_plantillas_integradas_iact.md
- L142: [Descripción detallada de la regla]
- L150: - [Cómo se valida la regla]
- L161: - [Qué ocurre si se viola la regla]
- L167: [Repetir para cada regla del componente]
- L235: - Reglas: [IDs de reglas aplicadas]
- L449:   [campo1] [tipo] [restricciones],
- L450:   [campo2] [tipo] [restricciones],
- L480: - [ ] Cada regla de negocio está aplicada en al menos 1 requisito
- L755: - [ ] Todas las reglas de negocio identificadas
- L756: - [ ] Cada regla tiene ID único (formato: RN-[ÁREA]-[NN])
- L757: - [ ] Cada regla tiene nombre descriptivo
- L761: Para cada regla:
- L815: - [ ] Trazabilidad a proceso, reglas, requisitos documentada
- L936: - [ ] Cada regla está aplicada en al menos un RF
- L1122: Plantilla simplificada para documentar rápidamente una regla de negocio individual.
- L1147: [Descripción en lenguaje natural de la regla de negocio]
- L1171: **Fuente:** [De dónde proviene la regla]
- L1183: **¿Cómo se valida esta regla?**
- L1185: [Descripción de cómo el sistema valida que la regla se cumple]
- L1197: **¿Existen casos en los que esta regla NO aplica?**
- L1219: **¿Qué ocurre si se viola esta regla?**
- L1224: "[Mensaje que se muestra al usuario cuando se viola la regla]"
- L1231: - TS-RN-[XX]-001: Validar cumplimiento de la regla
- L1271: | **Regla de Negocio Individual** | Cuando se identifica una regla nueva que debe documentarse rápidamente. |
- L1283:    - Para cada regla compleja, crear documento individual con Plantilla 4
- L1340: - **Documentar reglas ANTES de casos de uso:** Las reglas influyen en los UC
- L1385: **Paso 2:** Identificar reglas de negocio
- L1504: - `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` - 14 reglas de autenticación
- L1516: 4. **Regla Individual** - Documentación rápida de reglas de negocio

### docs/gobernanza/marco_integrado/casos_practicos/caso-practico-02-evaluacion-permisos.md
- L110: | 8 | **NIVEL 3**: Sistema valida restricciones contextuales (ej: solo datos propios) |
- L161: 3. El sistema debe validar restricciones contextuales (ownership, jerarquía)

### docs/gobernanza/marco_integrado/casos_practicos/caso-practico-03-auditoria-seguridad.md
- L59:   |--Si--> [Evaluar reglas de detección de amenazas]
- L143: | 2 | Sistema aplica reglas de detección de amenazas |
- L363: | 6b | Si falso positivo | Hacer clic en "Marcar como Falso Positivo" | Sistema actualiza alerta y ajusta regla |

### docs/gobernanza/marco_integrado/casos_practicos/resumen-casos-practicos.md
- L115: - **Reglas de Negocio:** `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (1859 líneas, 14 reglas)
- L163: - Entender la aplicación de reglas de negocio en requisitos

### docs/gobernanza/marco_integrado/marco_casos_uso.md
- L386:    - Relacionar con reglas de negocio (BR-NN)
- L397: - Reglas de negocio: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/gobernanza/marco_integrado/marco_reglas_negocio.md
- L15: > Concepto Clave: Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.
- L17: Cada organización opera de acuerdo con un extenso conjunto de políticas, leyes y estándares de la industria. En pocas palabras, decimos que las **reglas de negocio** son estas políticas, leyes y estándares bajo los que se rigen las organizaciones.
- L29: Estos constituyen estándares, políticas o reglas que se implementan para el manejo adecuado de residuos.
- L60: > Concepto Clave: Las reglas de negocio también se conocen colectivamente como "lógica de negocio" y tienen dos funciones principales:
- L67: Las **reglas de negocio** influyen de manera directa sobre varios tipos de requerimientos:
- L93: > Concepto Clave: Una restricción es una sentencia que restringe las acciones que el sistema o los usuarios pueden realizar, definiendo qué se puede hacer y qué no se puede hacer.
- L123: > Concepto Clave: Un desencadenador de acción es una regla que activa alguna actividad si las condiciones específicas son verdaderas.
- L168: - `do../gobernanza/marco_integrado/reglas_negocio/`
- L169: - `docs/backend/requisitos/reglas_negocio/`
- L170: - `docs/frontend/requisitos/reglas_negocio/`
- L171: - `docs/infraestructura/requisitos/reglas_negocio/`
- L173: Cada dominio debe documentar sus reglas de negocio específicas siguiendo esta clasificación de 5 tipos.
- L177: Este documento establece el estándar de gobernanza para la documentación de reglas de negocio en todo el proyecto IACT.

### docs/gobernanza/marco_integrado/plantillas/guia-uso-plantillas.md
- L18: | **Regla de Negocio Individual** | Cuando se identifica una regla nueva que debe documentarse rápidamente. |
- L30:    - Para cada regla compleja, crear documento individual con Plantilla 4
- L87: - **Documentar reglas ANTES de casos de uso:** Las reglas influyen en los UC
- L132: **Paso 2:** Identificar reglas de negocio
- L251: - `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` - 14 reglas de autenticación
- L263: 4. **Regla Individual** - Documentación rápida de reglas de negocio

### docs/gobernanza/marco_integrado/plantillas/plantilla-01-documento-maestro-analisis.md
- L131: [Descripción detallada de la regla]
- L139: - [Cómo se valida la regla]
- L150: - [Qué ocurre si se viola la regla]
- L156: [Repetir para cada regla del componente]
- L224: - Reglas: [IDs de reglas aplicadas]
- L438:   [campo1] [tipo] [restricciones],
- L439:   [campo2] [tipo] [restricciones],
- L469: - [ ] Cada regla de negocio está aplicada en al menos 1 requisito

### docs/gobernanza/marco_integrado/plantillas/plantilla-03-checklist-completitud.md
- L84: - [ ] Todas las reglas de negocio identificadas
- L85: - [ ] Cada regla tiene ID único (formato: RN-[ÁREA]-[NN])
- L86: - [ ] Cada regla tiene nombre descriptivo
- L90: Para cada regla:
- L144: - [ ] Trazabilidad a proceso, reglas, requisitos documentada
- L265: - [ ] Cada regla está aplicada en al menos un RF

### docs/gobernanza/marco_integrado/plantillas/plantilla-04-regla-negocio.md
- L14: Plantilla simplificada para documentar rápidamente una regla de negocio individual.
- L39: [Descripción en lenguaje natural de la regla de negocio]
- L63: **Fuente:** [De dónde proviene la regla]
- L75: **¿Cómo se valida esta regla?**
- L77: [Descripción de cómo el sistema valida que la regla se cumple]
- L89: **¿Existen casos en los que esta regla NO aplica?**
- L111: **¿Qué ocurre si se viola esta regla?**
- L116: "[Mensaje que se muestra al usuario cuando se viola la regla]"
- L123: - TS-RN-[XX]-001: Validar cumplimiento de la regla

### docs/gobernanza/metodologias/WORKFLOWS_COMPLETOS.md
- L288: #### 1. `validate_critical_restrictions.sh`
- L289: **Ubicación**: `scripts/validate_critical_restrictions.sh`
- L291: **Propósito**: Validar restricciones críticas del proyecto
- L305: ./scripts/validate_critical_restrictions.sh
- L1082: │     ├─ ./scripts/validate_critical_restrictions.sh         │

### docs/gobernanza/metodologias/automatizacion_servicios.md
- L54:     prompt="Revisa el codigo en api/ y valida contra restricciones...",
- L216: Gates de validacion para restricciones del proyecto.
- L220: | RestrictionsGate | scripts/coding/ai/agents/validation/restrictions_gate.py | Valida restricciones criticas del proyecto |
- L310: | BusinessRulesValidator | scripts/coding/ai/automation/business_rules_validator_agent.py | Valida reglas de negocio |
- L596:           python scripts/coding/ai/agents/validation/restrictions_gate.py \
- L648: │  - validate_critical_restrictions.sh (custom)                      │

### docs/gobernanza/metodologias/arquitectura_servicios_especializados.md
- L223: # AGENTE 5: VALIDATOR (Validación de reglas)
- L234:     Responsabilidad: Validar que transformaciones siguen reglas
- L236:     Input: EditResult, reglas del proyecto
- L241:         """Valida transformaciones contra reglas"""
- L1085: | RestrictionsGate | scripts/ai/validators/restrictions_gate.py | NO | Valida restricciones |

### docs/gobernanza/plan_general.md
- L62: | docs/anexos/catalogo_reglas_negocio.md | Catálogo de reglas de negocio del call center. | Vigente |

### docs/gobernanza/planificacion/PLAN_REMEDIACION_DOCS_GOBERNANZA.md
- L84:   "marco_integrado/marco_reglas_negocio.md"
- L455: - [Marco de Reglas de Negocio](../marco_integrado/marco_reglas_negocio.md)
- L601:   * checklist_auditoria_restricciones.md

### docs/gobernanza/plantilla_adr.md
- L26: - ¿Cuáles son las restricciones actuales?

### docs/gobernanza/plantillas/README.md
- L39: - **Requisitos y análisis:** `plantilla_srs.md`, `plantilla_regla_negocio.md`, `plantilla_caso_de_uso.md` (ver [Guía de Casos de Uso](../gobernanza/casos_de_uso_guide.md) para estándares completos).
- L107: 4. Requisitos funcionales (casos de uso, reglas de negocio, criterios de aceptación)

### docs/gobernanza/plantillas/desarrollo/plantilla_spec.md
- L110: | BR-001 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |
- L111: | BR-002 | [Descripción de la regla] | [Alta/Media/Baja] | [Cómo se valida] |

### docs/gobernanza/plantillas/plantilla_etl_job.md
- L54: **Ventana de ejecución permitida**: [Descripción de restricciones de horario]
- L262:         ValidationError: Si los datos no cumplen reglas de negocio
- L272:     # Cálculo: [descripción de regla de negocio]

### docs/gobernanza/plantillas/plantilla_regla_negocio.md
- L1: # Plantilla de regla de negocio

### docs/gobernanza/plantillas/plantilla_setup_qa.md
- L13: Usuarios, roles y restricciones.

### docs/gobernanza/plantillas/plantilla_srs.md
- L11: Clasificar por tipo usando la plantilla de reglas.

### docs/gobernanza/plantillas/template_requisito_funcional.md
- L260: | BR-[XX] | [Nombre regla] | [Descripción detallada de la lógica de negocio] | [RN-XXX] |
- L275: - [ ] [Campo X]: [regla de validación]
- L276: - [ ] [Campo Y]: [regla de validación]

### docs/gobernanza/plantillas/template_requisito_negocio.md
- L242: | C-01 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |
- L243: | C-02 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |

### docs/gobernanza/procedimientos/PROCED-GOB-001-crear_adr.md
- L156: ¿Qué restricciones o requerimientos tenemos?
- L586: **Solución**: Aplica la regla de "si dudas, crea ADR". Es mejor documentar de más que de menos. Un ADR corto es mejor que ninguno.

### docs/gobernanza/procedimientos/PROCED-GOB-003-documentar-regla-negocio.md
- L16: Documentar una regla de negocio siguiendo la clasificación de 5 tipos (Hechos, Restricciones, Desencadenadores, Inferencias, Cálculos) establecida en ADR-GOB-006, asegurando trazabilidad completa con otros niveles de requisitos.
- L25: - Conocer el dominio al que pertenece la regla (BACK, FRONT, DEVOPS, QA, AI, GOB)
- L31: - Un archivo markdown con la regla de negocio documentada
- L42: Identificar la regla de negocio desde su fuente original y capturarla en texto plano.
- L46: 1. Identificar fuente de la regla:
- L53:    - Descripción completa de la regla
- L69: - [ ] La regla está claramente expresada
- L77: Determinar si la regla es un Hecho, Restricción, Desencadenador, Inferencia o Cálculo.
- L83: │ ¿La regla describe una verdad sobre el negocio? │
- L91: │ ¿La regla limita o restringe una acción?        │
- L99: │ ¿La regla sigue formato SI...ENTONCES?          │
- L113:           │ La regla NO es SI...ENTONCES
- L116: │ ¿La regla contiene una fórmula matemática       │
- L190: ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort | tail -1
- L191: # Ejemplo salida: RN-BACK-028-restriccion-acceso.md
- L206: RN-BACK-028-restriccion-acceso-gerentes.md
- L223: Documentar la regla usando el formato específico de su tipo.
- L228: docs/gobernanza/requisitos/reglas_negocio/
- L230: ├── restricciones/
- L243: tipo: regla_negocio
- L278: tipo: regla_negocio
- L279: subtipo: restriccion
- L308: [Por qué existe esta restricción: seguridad, regulación, política]
- L311: [Si existen excepciones a la restricción]
- L327: tipo: regla_negocio
- L341: **SI**: [Condición o evento que dispara la regla]
- L354: [Qué tan frecuente se espera que se active esta regla]
- L372: tipo: regla_negocio
- L414: tipo: regla_negocio
- L496:    - ¿Esta regla contribuye a algún objetivo organizacional?
- L497:    - ¿Qué RNEG se apoya en esta regla?
- L500:    - ¿Qué casos de uso deben cumplir esta regla?
- L501:    - ¿Qué interacciones de usuario están restringidas/habilitadas por esta regla?
- L504:    - ¿Qué funcionalidades del sistema implementan esta regla?
- L508:    - ¿Esta regla impone requisitos de seguridad, rendimiento, usabilidad?
- L509:    - ¿Hay restricciones de calidad derivadas de esta regla?
- L559: - [ ] Tipo correcto (hecho, restriccion, desencadenador, inferencia, calculo)
- L586:   - `reglas_negocio/hechos/`
- L587:   - `reglas_negocio/restricciones/`
- L588:   - `reglas_negocio/desencadenadores/`
- L589:   - `reglas_negocio/inferencias/`
- L590:   - `reglas_negocio/calculos/`
- L609: Versionar la regla de negocio en git.
- L616: # Ejemplo para restricción
- L617: ls -la docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-ejemplo.md
- L623: git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-ejemplo.md
- L636: docs(requisitos): agregar RN-BACK-029 restricción de acceso
- L662: - Fuente: [Origen de la regla]
- L696: RN-BACK-029-restriccion-acceso-configuracion.md
- L704: tipo: regla_negocio
- L705: subtipo: restriccion
- L737: Ninguna. Esta restricción no admite excepciones por razones de seguridad.
- L777: ✓ Tipo: restriccion
- L782: ✓ Ubicación: reglas_negocio/restricciones/
- L788: git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-acceso-configuracion.md
- L791: docs(requisitos): agregar RN-BACK-029 restricción de acceso a configuración
- L809: **Síntoma**: La regla tiene formato SI...ENTONCES pero no sé si es desencadenador o inferencia.
- L830: ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort
- L833: ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort | tail -1
- L844: - RF-BACK-050: [Pendiente] Implementar validación de regla
- L849: ### Problema 4: La regla parece ser de 2 tipos a la vez
- L851: **Solución**: Probablemente deba dividirse en 2 reglas separadas.
- L865: - [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)

### docs/gobernanza/procedimientos/PROCED-GOB-004-crear-caso-uso.md
- L508: 1. ¿Qué reglas de negocio restringen este caso de uso?
- L519: - RN-DOMINIO-###: [Nombre de la regla]
- L520: - RN-DOMINIO-###: [Nombre de la regla]
- L537: Si las reglas de negocio aún no están documentadas, crear placeholder:
- L550: - [ ] Al menos 1 regla de negocio relacionada identificada
- L1174: - [PROCED-GOB-003: Documentar Regla de Negocio](/home/user/IACT---project/docs/gobernanza/procedimientos/PROCED-GOB-003-documentar-regla-negocio.md)

### docs/gobernanza/procedimientos/PROCED-GOB-005-analisis-impacto-cambios.md
- L123: **Archivo**: docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-001-autenticacion-obligatoria.md
- L179: - ¿Qué regla de negocio justifica este UC?
- L424: **Razón**: Esta regla de calidad para contraseñas sigue siendo válida independientemente de agregar 2FA. Ambas medidas de seguridad son complementarias.
- L583: # 4. Actualizar reglas de negocio relacionadas
- L822: # modified:   docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-001-autenticacion-obligatoria.md
- L1027: vim docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-015-restriccion-acceso-auditores.md
- L1042: git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-015-restriccion-acceso-auditores.md
- L1108: - [PROCED-GOB-003: Documentar Regla de Negocio](/home/user/IACT---project/docs/gobernanza/procedimientos/PROCED-GOB-003-documentar-regla-negocio.md)

### docs/gobernanza/procedimientos/PROCED-GOB-006-generar-diagrama-uml-plantuml.md
- L515: Esta es la regla MÁS IMPORTANTE del diagrama.

### docs/gobernanza/procedimientos/PROCED-GOB-008-configurar-permisos-git-push.md
- L44: - Push de branches sin restricciones

### docs/gobernanza/procesos/INDICE_WORKFLOWS.md
- L240: - Validaciones: 4/4 (validate_critical_restrictions.sh, etc)
- L276: - Viola alguna restriccion critica (NO Redis, NO Email)?
- L299: **4.2 Validar restricciones ANTES de codear**:
- L301: ./scripts/validate_critical_restrictions.sh
- L331: **5.3 Validar restricciones**:
- L333: ./scripts/validate_critical_restrictions.sh
- L400: # 1. Validar restricciones
- L401: ./scripts/validate_critical_restrictions.sh
- L439:     │   ├─ Validar restricciones
- L495: - **Restricciones**: `docs/backend/requisitos/restricciones_y_lineamientos.md`
- L515: - validate-restrictions (RNF-002)

### docs/gobernanza/procesos/PROC-001-gobernanza_sdlc.md
- L23: 5. [Restricciones IACT](#restricciones-iact)
- L202: - Validacion restricciones IACT automatica
- L731: Todos los agentes validan restricciones IACT automaticamente:
- L793: - RNF-002: docs/backend/requisitos/restricciones_y_lineamientos.md

### docs/gobernanza/procesos/PROC-DEVOPS-001-devops_automation.md
- L13:   - restricciones_y_lineamientos.md
- L51: # scripts/validate_critical_restrictions.sh
- L55: echo "Validando restricciones cr?ticas IACT..."
- L75: echo "? Todas las restricciones cr?ticas validadas"
- L85: cp scripts/validate_critical_restrictions.sh .git/hooks/pre-commit
- L125: # 5. Critical restrictions
- L127: bash ../../scripts/validate_critical_restrictions.sh
- L152: ./scripts/validate_critical_restrictions.sh || exit 1
- L429: # 2. Todas las referencias a restricciones son correctas
- L526: - [x] validate_critical_restrictions.sh
- L553: [ ] ./scripts/validate_critical_restrictions.sh  # NO Redis, NO email
- L575: - **Restricciones**: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### docs/gobernanza/procesos/PROC-GOB-001-mapeo_procesos_templates.md
- L102: | **Desarrollo (10)** | plantilla_django_app, plantilla_etl_job, plantilla_regla_negocio, plantilla_spec, plantilla_srs, plantilla_tdd, plantilla_troubleshooting, plantilla_plan, plantilla_sad, plantilla_ui_ux | Development | backend-ci, frontend-ci |
- L193:    └─> Usar: plantilla_regla_negocio.md
- L469: │   └─> Reglas de negocio → plantilla_regla_negocio.md

### docs/gobernanza/procesos/PROC-GOB-008-reorganizacion-estructura-documental.md
- L395: - **NO emojis** en documentación (regla estricta)
- L396: - **NO iconos** en documentación (regla estricta)
- L397: - Considerar restricciones técnicas específicas del dominio
- L542: 3. Considerar restricciones: {listar restricciones específicas}

### docs/gobernanza/procesos/PROC-QA-001-actividades_garantia_documental.md
- L14: Plan operativo para asegurar que las reglas de documentación, requisitos y casos de uso se apliquen de forma consistente en todo el repositorio.
- L22: - Mantener trazabilidad completa entre reglas de negocio, requisitos, casos de uso y pruebas.
- L36: - Actualizar [`../requisitos/trazabilidad.md`](../requisitos/trazabilidad.md) con cualquier relación nueva entre reglas, requisitos, casos de uso y pruebas.
- L44: | Durante desarrollo | QA | Corroborar que los casos de uso reflejen reglas de negocio activas y generen requisitos funcionales claros. | Comentarios en pull requests. |

### docs/gobernanza/procesos/agentes/constitution.md
- L49: # Error: "No se encontró especificación de reglas de descuento.

### docs/gobernanza/procesos/checklists/checklist_auditoria_restricciones.md
- L8: relacionados: ["PROC-QA", "restricciones_completas.md"]
- L15: Este checklist permite auditar el cumplimiento de las restricciones críticas del proyecto IACT. Se basa en los hallazgos de la auditoría real del código en `api/`.
- L331: | 5.2.2 | Ruff con reglas de seguridad (S) | `api/callcentersite/pyproject.toml:46` | OK | Activado |
- L431: # scripts/validate_critical_restrictions.sh
- L433: echo "Validando restricciones críticas..."
- L569: - [Restricciones Completas](../requisitos/restricciones_completas.md)

### docs/gobernanza/procesos/checklists/checklist_trazabilidad_requisitos.md
- L11: - [ ] Cada caso de uso enlaza con reglas de negocio correspondientes.

### docs/gobernanza/procesos/procedimientos/guia_completa_desarrollo_features.md
- L995: # Auto-fix issues que se puedan arreglar

### docs/gobernanza/procesos/procedimientos/procedimiento_analisis_seguridad.md
- L229: | RBAC Permissions | Modificación de permisos en DB | Baja | Crítico | **MEDIO** | Audit logs inmutables, validación de integridad, restricciones DB |
- L231: | Audit Logs | Eliminación de evidencia | Baja | Alto | **MEDIO** | Eliminación lógica, permisos restrictivos, backup continuo |

### docs/gobernanza/procesos/procedimientos/procedimiento_diseno_tecnico.md
- L92: - [ ] Restricciones técnicas documentadas (ver `restricciones_y_lineamientos.md`)
- L605: - Transiciones de estado con reglas de negocio

### docs/gobernanza/procesos/procedimientos/procedimiento_trazabilidad_requisitos.md
- L112:     Start -->|Calidad/restricción técnica| RNF[No Funcional RNF-XXX]

### docs/gobernanza/procesos/qa/actividades_garantia_documental.md
- L11: Plan operativo para asegurar que las reglas de documentación, requisitos y casos de uso se apliquen de forma consistente en todo el repositorio.
- L19: - Mantener trazabilidad completa entre reglas de negocio, requisitos, casos de uso y pruebas.
- L33: - Actualizar [`../requisitos/trazabilidad.md`](../requisitos/trazabilidad.md) con cualquier relación nueva entre reglas, requisitos, casos de uso y pruebas.
- L41: | Durante desarrollo | QA | Corroborar que los casos de uso reflejen reglas de negocio activas y generen requisitos funcionales claros. | Comentarios en pull requests. |

### docs/gobernanza/procesos/qa/checklist_auditoria_restricciones.md
- L8: relacionados: ["PROC-QA", "restricciones_completas.md"]
- L15: Este checklist permite auditar el cumplimiento de las restricciones críticas del proyecto IACT. Se basa en los hallazgos de la auditoría real del código en `api/`.
- L331: | 5.2.2 | Ruff con reglas de seguridad (S) | `api/callcentersite/pyproject.toml:46` | OK | Activado |
- L431: # scripts/validate_critical_restrictions.sh
- L433: echo "Validando restricciones críticas..."
- L569: - [Restricciones Completas](../requisitos/restricciones_completas.md)

### docs/gobernanza/qa/ANALISIS-PROYECTO-2025-01-17.md
- L289:    - Clasificación: Cálculo, restricción, inferencia, desencadenador, hecho
- L353: │   ├── reglas_negocio/             ← RN backend

### docs/gobernanza/qa/ANALISIS_COMPLETO_PROYECTO_IACT_2025_11_17.md
- L18: El proyecto IACT (IVR Analytics & Customer Tracking) es un sistema monolítico de análisis de centros de contacto construido con Django 5.1, PostgreSQL y MariaDB. Con 750 archivos de código, 137,510 líneas de Python, 23 aplicaciones Django, 501 funciones de test y una arquitectura modular bien documentada, el proyecto demuestra una madurez considerable en su estructura y gobernanza, aunque se encuentra en fase de consolidación documental y alineación con implementación. El equipo ha establecido prácticas sólidas con 25 workflows de CI/CD, pre-commit hooks configurados, y un sistema comprehensivo de restricciones arquitectónicas (especialmente RNF-002: NO Redis). Sin embargo, existen brechas críticas entre documentación y código, inconsistencias en cobertura de tests, y varios componentes en estado de "PLANIFICADO" que requieren completarse.
- L602:    - Correcto para dev, pero production must restrict
- L877:   - MUST restrict in production

### docs/gobernanza/qa/ANALISIS_DOCS_GOBERNANZA_2025_11_17.md
- L27: 1. **CRITICO - Violacion masiva de restriccion de emojis**: 46 archivos (11.9%) contienen emojis, violando la politica establecida en GUIA_ESTILO.md seccion 1
- L183: - Negocio: plantilla_business_case.md, plantilla_regla_negocio.md
- L261: | 18 | `marco_reglas_negocio.md` | marco_integrado/ |
- L314:    - `checklist_auditoria_restricciones.md` (qa/, procesos/checklists/, procesos/qa/)

### docs/gobernanza/qa/ANALISIS_INCONSISTENCIAS_NOMENCLATURA_2025_11_17.md
- L234: | `checklist_auditoria_restricciones.md` | (mismo) | `qa/` | `procesos/qa/` |
- L474: 3. **Actualizar GUIA_ESTILO.md** con reglas de nomenclatura claras

### docs/gobernanza/qa/QA-ANALISIS-ESTRUCTURA-003/ANALISIS-ESTRUCTURA-GOBERNANZA-2025-11-17.md
- L103:   - requisitos/reglas_negocio/
- L344: - Casos de uso, reglas de negocio, stakeholders
- L396: - requisitos/ejemplos_test/, requisitos/reglas_negocio/, requisitos/requerimientos_funcionales/, requisitos/requerimientos_negocio/, requisitos/requerimientos_usuario/, requisitos/stakeholders/
- L729: │   ├── reglas_negocio/

### docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/evidencias/TASK-001/RESUMEN-FINAL.md
- L99: 1. El proxy local (127.0.0.1:61479) tiene restricciones para pushear tags
- L149: La TASK-001 falló debido a restricciones de permisos en el repositorio remoto. El rollback se aplicó correctamente y el repositorio está en estado limpio. Se requiere intervención manual para resolver el problema de permisos antes de continuar con el plan de consolidación.

### docs/gobernanza/qa/REPORTE_ANALISIS_FINAL_GOBERNANZA_20251117_083000.md
- L169: ├── catalogos/           # Catálogos de reglas, inventarios
- L208: ├── catalogos/              # Catálogos (reglas, inventarios)

### docs/gobernanza/qa/REPORTE_ANALISIS_MARCO_INTEGRADO_20251117_083500.md
- L25: **RN-C01**: Autenticación y Sesiones (14 reglas)
- L35:   - Contenido: Diagrama de flujo, actores, reglas RN-C01
- L196:    - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/plantilla-04-regla-negocio.md`

### docs/gobernanza/qa/REPORTE_EMOJIS_DOCS_GOBERNANZA_2025_11_17.md
- L55:    - Ubicacion: Tablas de reglas de negocio
- L59:    - Ubicacion: Matriz de hechos y restricciones
- L126: 20. **marco_integrado/marco_reglas_negocio.md** - 790 emojis
- L127:     - Ubicacion: Marco de reglas

### docs/gobernanza/qa/VALIDACION-TRAZABILIDAD-2025-01-17.md
- L103: - **Impacto:** No está conectado con ningún requerimiento de negocio, regla de negocio o requisito funcional

### docs/gobernanza/qa/actividades_garantia_documental.md
- L10: Plan operativo para asegurar que las reglas de documentación, requisitos y casos de uso se apliquen de forma consistente en todo el repositorio.
- L18: - Mantener trazabilidad completa entre reglas de negocio, requisitos, casos de uso y pruebas.
- L32: - Actualizar [`../requisitos/trazabilidad.md`](../requisitos/trazabilidad.md) con cualquier relación nueva entre reglas, requisitos, casos de uso y pruebas.
- L40: | Durante desarrollo | QA | Corroborar que los casos de uso reflejen reglas de negocio activas y generen requisitos funcionales claros. | Comentarios en pull requests. |

### docs/gobernanza/qa/checklist_auditoria_restricciones.md
- L8: relacionados: ["PROC-QA", "restricciones_completas.md"]
- L14: Este checklist permite auditar el cumplimiento de las restricciones críticas del proyecto IACT. Se basa en los hallazgos de la auditoría real del código en `api/`.
- L330: | 5.2.2 | Ruff con reglas de seguridad (S) | `api/callcentersite/pyproject.toml:46` | OK | Activado |
- L430: # scripts/validate_critical_restrictions.sh
- L432: echo "Validando restricciones críticas..."
- L568: - [Restricciones Completas](../requisitos/restricciones_completas.md)

### docs/gobernanza/qa/registros/2025_11_05_merge_ramas.md
- L135: - Sin emojis (cumple restricciones)

### docs/gobernanza/requisitos/README.md
- L133: Todos los requisitos IACT respetan las siguientes restricciones tecnicas:
- L169: - [Restricciones y Lineamientos IACT](../../backend/requisitos/restricciones_y_lineamientos.md)

### docs/gobernanza/requisitos/ejemplos_test/RN-BACK-001-autenticacion-requerida.md
- L3: tipo: regla-negocio

### docs/gobernanza/requisitos/matriz_trazabilidad_rtm.md
- L22: | DOC-RESTRICCIONES-MAESTRO | Documento Maestro de Restricciones y Lineamientos | restricciones | global | definitivo | - | - |
- L46: | RN-C01-COMPONENTE-1 | Reglas de Negocio - Componente 1 - Autenticación y Sesiones | reglas_negocio | backend | completo_definitivo | - | - |

### docs/gobernanza/requisitos/reglas_negocio/APLICACION_IACT.md
- L14: 4. [Mapeo Reglas a Código](#mapeo-reglas-a-código)
- L23: > **Concepto Clave:** Este documento traduce las reglas de negocio abstractas en implementaciones concretas dentro de la arquitectura Django + React del proyecto IACT.
- L27: - **Mapear** reglas de negocio a componentes técnicos
- L28: - **Implementar** cada tipo de regla en el stack tecnológico
- L64: └── docs/gobernanza/requisitos/reglas_negocio/  # Este directorio
- L781:   --docs-dir docs/gobernanza/requisitos/reglas_negocio \
- L801:     """Test de reglas de negocio para Agentes"""
- L803:     def test_restriccion_extension_unica(self):
- L1029: 1. **Trazabilidad Completa:** Cada regla de negocio está mapeada a código específico
- L1031: 3. **Testing Exhaustivo:** Tests unitarios validan cada tipo de regla
- L1046: - [Casos de Uso](../CASOS_USO.md) - Integración de reglas en casos de uso

### docs/gobernanza/requisitos/reglas_negocio/ESPECIFICACION_TESTS_COMPLIANCE.md
- L15: Los tests de reglas de negocio deben ser independientes de Django, Flask o cualquier framework web. Las reglas de negocio son el núcleo del sistema.
- L250: - Documentar reglas de negocio

### docs/gobernanza/requisitos/reglas_negocio/HECHOS_RESTRICCIONES.md
- L11: 1. [Clasificación de Reglas de Negocio](#clasificación-de-reglas-de-negocio)
- L13: 3. [Restricciones (Constraints)](#2-restricciones-constraints)
- L21: > **Concepto Clave:** Los cinco tipos de reglas de negocio son: Hechos, Restricciones, Desencadenadores de Acción, Inferencias y Cálculos Computacionales.
- L99: > **Concepto Clave:** Una restricción es una sentencia que restringe las acciones que el sistema o los usuarios pueden realizar, definiendo qué se puede hacer y qué no se puede hacer.
- L103: Cuando encontramos estas frases o palabras en la documentación, prácticamente están describiendo una restricción:
- L123: **Ejemplo práctico:** Cuando realizas un pago en una tienda en línea, solo ves los últimos cuatro dígitos de tu tarjeta de crédito. Esta es una regla de negocio o política organizacional que establece no mostrar el número completo de la tarjeta.
- L181: > **Concepto Clave:** La matriz de roles y permisos es una representación tabular concisa de las restricciones de acceso del sistema.
- L183: Una manera eficiente de documentar restricciones es a través de una **matriz de roles y permisos**, donde simplemente marcamos qué operaciones puede realizar cierto perfil, stakeholder o rol.
- L258: 4. **Comunicación efectiva:** Stakeholders entienden rápidamente las restricciones
- L327: > **Nota Importante:** La correcta identificación y documentación de hechos y restricciones es fundamental para el desarrollo de sistemas que cumplan con las expectativas del negocio y las regulaciones aplicables.

### docs/gobernanza/requisitos/reglas_negocio/INTRODUCCION.md
- L11: 1. [¿Qué es una Regla de Negocio?](#qué-es-una-regla-de-negocio)
- L12: 2. [Funciones de las Reglas de Negocio](#funciones-de-las-reglas-de-negocio)
- L23: > **Concepto Clave:** Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.
- L25: Cada organización opera de acuerdo con un extenso conjunto de políticas, leyes y estándares de la industria. En pocas palabras, las **reglas de negocio** son estas políticas, leyes y estándares bajo los que se rigen las organizaciones.
- L39: Estos constituyen estándares, políticas o reglas que se implementan para el manejo adecuado de residuos.
- L45: > **Concepto Clave:** Las reglas de negocio también se conocen colectivamente como "lógica de negocio" y tienen dos funciones principales:
- L96: Las **reglas de negocio** constituyen el nivel más alto y ejercen influencia directa sobre todos los demás niveles. Esta influencia se manifiesta de manera cascada:
- L98: 1. Las **reglas de negocio** definen restricciones y políticas
- L99: 2. Los **requerimientos de negocio** se derivan de estas reglas
- L193: Las reglas de negocio constituyen el nivel más alto en la jerarquía de requerimientos y ejercen una influencia directa y determinante sobre todos los demás tipos de requerimientos. Comprender esta influencia es fundamental para el análisis efectivo de requerimientos y el diseño de sistemas que cumplan con las normativas y políticas organizacionales.
- L195: En el contexto del proyecto IACT (sistema de call center), las reglas de negocio están particularmente relacionadas con:

### docs/gobernanza/requisitos/reglas_negocio/README.md
- L22: **Definición:** Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.

### docs/gobernanza/requisitos/reglas_negocio/TIPOS_AVANZADOS.md
- L22: > **Concepto Clave:** Los tipos avanzados de reglas de negocio (Desencadenadores, Inferencias y Cálculos) transforman datos y desencadenan acciones automáticas basadas en condiciones del negocio.
- L24: Este documento complementa [HECHOS_RESTRICCIONES.md](HECHOS_RESTRICCIONES.md) cubriendo los tres tipos restantes de reglas de negocio:
- L36: > **Concepto Clave:** Un desencadenador de acción es una regla que activa alguna actividad si condiciones específicas son verdaderas.
- L418: **Escenario:** Gestión de llamada entrante con múltiples tipos de reglas
- L465: - **Estructura:** Incluya las 5 categorías de reglas
- L495: > **Nota Importante:** La correcta implementación de estos tipos avanzados de reglas permite automatización inteligente, clasificación dinámica y métricas en tiempo real que mejoran la operación del call center.

### docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/CASOS_USO.md
- L6: **Relacionado:** [Reglas de Negocio](reglas_negocio/README.md)
- L18: 7. [Relación con Reglas de Negocio](#relación-con-reglas-de-negocio)
- L163: - **Reglas de Negocio:** IDs de reglas relacionadas
- L215: El sistema registra una llamada entrante desde el IVR y la asigna a un agente disponible según reglas de distribución.
- L451: Los casos de uso **implementan** las reglas de negocio en flujos de trabajo específicos:
- L463: Cada caso de uso debe referenciar las reglas de negocio que implementa:
- L477: - Referencias correctas entre casos de uso y reglas de negocio
- L537: 8. **Trazabilidad** con reglas de negocio
- L550: Tests (validación de reglas y casos de uso)

### docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-001_registrar_llamada_entrante.md
- L24: reglas_negocio_aplicadas:
- L28:   - tipo: restriccion
- L31:   - tipo: restriccion

### docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-002_atender_llamada.md
- L23: reglas_negocio_aplicadas:
- L27:   - tipo: restriccion
- L30:   - tipo: restriccion

### docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-003_transferir_llamada.md
- L22: reglas_negocio_aplicadas:
- L23:   - tipo: restriccion
- L26:   - tipo: restriccion

### docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-CALL-004_generar_reporte_rendimiento.md
- L23: reglas_negocio_aplicadas:
- L24:   - tipo: restriccion

### docs/gobernanza/sesiones/CONSOLIDATION_STATUS.md
- L57: All work is completed locally and ready to push, but requires user intervention due to session ID restrictions.
- L115: 5. Encountered session ID security restriction on push
- L182: - [ ] Push to remote (requires user action - session ID restriction)

### docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_DOCS_ESTRUCTURA_20251116.md
- L49: - TASK-002-validar_restricciones_criticas.md
- L318:      2	TASK-002-validar_restricciones_criticas.md

### docs/gobernanza/sesiones/analisis_nov_2025/ANALISIS_UBICACION_ARCHIVOS.md
- L26: - Contiene reglas generales (output profesional, linters, tests)

### docs/gobernanza/sesiones/analisis_nov_2025/ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md
- L286: │   │   └── restricciones_y_lineamientos.md
- L416: │   ├── catalogo_reglas_negocio.md

### docs/gobernanza/sesiones/analisis_nov_2025/ETA_CODEX_ANALISIS.md
- L18: - *Técnicos*: Acceso a repositorios académicos, análisis metodológico riguroso, derivación de restricciones formales y validación multi-ruta.
- L34: 4. **Constraint-Driven Prompting** para garantizar que ninguna decisión viole restricciones lógicas o de complejidad.
- L55: │   ├─ Ejecución condicionada según objetivos y restricciones
- L78: - **Contexto técnico** (problema, propiedades deseadas, restricciones, stack base).
- L79: - **Objetivos verificables** y **restricciones adicionales** (técnicas, operacionales, regulatorias, legacy).
- L85: 2. **Derivación de restricciones**: complejidad computacional, propiedades de consistencia/correctitud y seguridad basada en threat models.

### docs/gobernanza/sesiones/analisis_nov_2025/META_CODEX_PARTE_1.md
- L68: - Validadores automáticos derivados de restricciones formales.
- L87: - **Enunciado:** La especialización admite formalización mediante propiedades verificables o restricciones cuantificables.
- L148: - Presencia de restricciones formales derivables.
- L233: - **Q2: Inferencias válidas.** Cada paso usa reglas de inferencia o referencias formales.
- L343: [3] Derivación de restricciones formales
- L380: ### 3.4 Etapa 3: Derivación de restricciones formales
- L382: **Objetivo:** Extraer propiedades formales, anti-patterns y restricciones cuantitativas.
- L387: - Derivar restricciones cuantitativas vinculadas a propiedades deseadas.
- L389: **Criterios de aceptación:** ≥ 3 propiedades formales, ≥ 5 anti-patterns con evidencia, ≥ 2 restricciones cuantitativas.

### docs/gobernanza/sesiones/analisis_nov_2025/REPORTE_DUPLICADOS.md
- L102: **Análisis**: La versión general (docs/checklists) es mucho más completa con reglas de output profesional y estándares de código. La versión de backend es más simple.

### docs/gobernanza/sesiones/analisis_nov_2025/analisis_completitud_reorganizacion.md
- L42: ├── reglas_negocio/              # Nivel 1: REGLAS DE NEGOCIO
- L45: │   ├── restricciones.md (pendiente)
- L90: | **Reglas de Negocio** | `docs/gobernanza/marco_integrado/marco_reglas_negocio.md` | 578 | ✅ Activo |
- L101: ai/requisitos/reglas_negocio/README.md ✅
- L103: backend/requisitos/reglas_negocio/README.md ✅
- L105: frontend/requisitos/reglas_negocio/README.md ✅
- L108: infraestructura/requisitos/reglas_negocio/README.md ✅
- L113: - `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L131: 2. `requisitos/reglas_negocio/README.md` - 5 tipos de reglas
- L213: - plantilla_regla_negocio.md ⚠️ (debe referenciar marco de gobernanza)
- L222: 2. Actualizar plantillas de casos de uso y reglas de negocio para referenciar los marcos conceptuales
- L364: **Marco de referencia**: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md` ✅
- L511: 7. **Documentar reglas de negocio (Nivel 1)**
- L593: **RECOMENDACIÓN #4**: Priorizar documentación de reglas de negocio.
- L595: Las reglas de negocio (Nivel 1) son la base de toda la jerarquía. Sin ellas:
- L598: - No hay claridad sobre restricciones y políticas del negocio
- L607: 5. Crear trazabilidad bidireccional con reglas de negocio
- L616: - Actualizar `plantilla_regla_negocio.md` con referencia a marco conceptual
- L649: 3. **Contenido Nivel 1** (0%): No existen archivos de reglas de negocio documentadas en ningún dominio.
- L670: - Documentar reglas de negocio (Nivel 1) en cada dominio
- L727: grep -r "marco_reglas_negocio\|marco_casos_uso" \
- L748: 1. `docs/gobernanza/marco_integrado/marco_reglas_negocio.md` (578 líneas)
- L757: 64ed45b - docs(gobernanza): add marco conceptual for reglas de negocio and casos de uso

### docs/gobernanza/sesiones/analisis_nov_2025/analisis_fallas_docs.md
- L214: **Impacto:** MEDIO - Gobernanza deberia ser solo reglas/procesos
- L293: - catalogo_reglas_negocio.md - Deberia estar en gobernanza/

### docs/gobernanza/sesiones/analisis_nov_2025/catalogo_todos_pendientes.md
- L64:   Linea   14 [TODO       ]: Este documento define 8 reglas inmutables que TODOS los shell scripts 
- L390:   Linea  236 [XXX        ]: - **RN-XXX**: [Nombre de regla] - Aplica en paso Y
- L424:   Linea  161 [TODO       ]: Las reglas atraviesan TODOS los niveles:
- L430:   Linea  334 [XXX        ]: 2. Identificar reglas de negocio aplicables (RN-XXX)
- L452:   Linea  108 [TODO       ]: Las reglas de negocio atraviesan TODOS los niveles:
- L470:   Linea  349 [XXX        ]: - De restricciones de calidad → RNF-XXX
- L695:   Linea  111 [XXX        ]: Start -->|Calidad/restricción técnica| RNF[No Funcional RNF-XXX]
- L839:   Linea  260 [XXX        ]: | BR-[XX] | [Nombre regla] | [Descripción detallada de la lógica de ne
- L939:   Linea  161 [TODO       ]: Las reglas atraviesan TODOS los niveles:
- L945:   Linea  334 [XXX        ]: 2. Identificar reglas de negocio aplicables (RN-XXX)
- L967:   Linea  108 [TODO       ]: Las reglas de negocio atraviesan TODOS los niveles:
- L985:   Linea  349 [XXX        ]: - De restricciones de calidad → RNF-XXX

### docs/gobernanza/sesiones/analisis_nov_2025/reporte_final_fases_1_2.md
- L113: - plantilla_regla_negocio.md
- L207: - `../../requisitos/rq_plantilla.md` → `../gobernanza/plantillas/plantilla_regla_negocio.md`
- L307: - checklist_auditoria_restricciones.md
- L497: │   │   ├── reglas_negocio/
- L567:    - [ ] Revisar plantilla_regla_negocio.md → referenciar marco_reglas_negocio.md
- L573:    - [ ] Documentar reglas de negocio (20 archivos - 5 tipos x 4 dominios)
- L647: - Poblar reglas de negocio (Nivel 1)
- L658: - **Marco de Reglas de Negocio**: docs/gobernanza/marco_integrado/marco_reglas_negocio.md

### docs/gobernanza/sesiones/analisis_nov_2025/reporte_reorganizacion.md
- L58: │   ├── reglas_negocio/       # Nivel 1
- L74: 1. **Reglas de Negocio:** `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L84: 4. Documentar reglas de negocio (5 tipos)

### docs/gobernanza/sesiones/analisis_nov_2025/reporte_reorganizacion_final.md
- L60: │   ├── reglas_negocio/               # NIVEL 1: Reglas de Negocio
- L63: │   │   ├── restricciones.md          # Matriz roles/permisos
- L111: │   └── restricciones_y_lineamientos.md
- L157: **Archivo:** `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L161: - 5 tipos de reglas de negocio:
- L195: | `ai/requisitos/reglas_negocio/README.md` | Guía de 5 tipos de reglas |
- L198: | `backend/requisitos/reglas_negocio/README.md` | Guía de 5 tipos de reglas |
- L201: | `frontend/requisitos/reglas_negocio/README.md` | Guía de 5 tipos de reglas |
- L205: | `infraestructura/requisitos/reglas_negocio/README.md` | Guía de 5 tipos de reglas |
- L328: docs/{dominio}/requisitos/reglas_negocio/
- L330: ├── restricciones.md          # Matriz de roles/permisos del dominio

### docs/gobernanza/sesiones/analisis_nov_2025/reporte_validacion_completa.md
- L53: - Business Rules: 5 archivos (hechos, restricciones, desencadenadores, inferencias, calculos)
- L766: - `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/gobernanza/sesiones/analisis_nov_2025/resumen_ejecutivo_fases_1_2_3.md
- L58: - restricciones.md × 4 dominios
- L169: - [ ] Poblar reglas de negocio con contenido especifico de dominio
- L189: 3. **Frameworks de Gobernanza Establecidos**: Marco conceptual de reglas de negocio y casos de uso
- L199: - Poblar reglas de negocio con contenido real
- L215: - **Marco Reglas de Negocio**: docs/gobernanza/marco_integrado/marco_reglas_negocio.md

### docs/gobernanza/sesiones/analisis_nov_2025/scripts_validacion.md
- L10: Este directorio contiene scripts shell para validar el cumplimiento de las restricciones del proyecto y la configuración de seguridad.
- L14: ### 1. `validate_critical_restrictions.sh`
- L15: **Propósito**: Valida que se cumplan las restricciones críticas del proyecto
- L29: ./scripts/validate_critical_restrictions.sh
- L108: # .github/workflows/validate-restrictions.yml
- L130:         run: ./scripts/validate_critical_restrictions.sh
- L161: # Validar restricciones críticas
- L162: ./scripts/validate_critical_restrictions.sh
- L184:       - id: validate-restrictions
- L186:         entry: ./scripts/validate_critical_restrictions.sh
- L261: ### Actualizar restricciones
- L263: 1. Edita `docs/requisitos/restricciones_completas.md`
- L264: 2. Actualiza los scripts según nuevas restricciones
- L265: 3. Actualiza `docs/qa/checklist_auditoria_restricciones.md`
- L272: - [Restricciones Completas](../docs/requisitos/restricciones_completas.md)
- L273: - [Checklist de Auditoría](../docs/qa/checklist_auditoria_restricciones.md)
- L283: # 1. Validar restricciones críticas
- L284: ./scripts/validate_critical_restrictions.sh

### docs/gobernanza/sesiones/analisis_nov_2025/validacion_conformidad_gobernanza.md
- L32: **Documento**: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L102: **Ubicacion**: `docs/ai/requisitos/reglas_negocio/`
- L106: - [x] Referencia al marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L117: **restricciones.md** - CONFORME
- L123: **Ubicacion**: `docs/backend/requisitos/reglas_negocio/`
- L130: **Ubicacion**: `docs/frontend/requisitos/reglas_negocio/`
- L136: **Ubicacion**: `docs/infraestructura/requisitos/reglas_negocio/`
- L383: **Archivos Analizados**: 24 archivos clave (reglas negocio, casos uso, prioridades)
- L453: **Ejemplo**: `docs/ai/requisitos/reglas_negocio/hechos.md`
- L472: **Reglas de Negocio**: `hechos.md`, `restricciones.md`, `desencadenadores.md`, `inferencias.md`, `calculos.md`
- L510:    - Enlaces claros a marcos de reglas de negocio y casos de uso
- L647: - `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L664: - `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L670: - `docs/ai/requisitos/reglas_negocio/*`

### docs/gobernanza/shell_scripting_guide.md
- L222: **IMPORTANTE**: Esta sección implementa la "Regla Fundamental" definida en [Estándares de Código](estandares_codigo.md#regla-fundamental-output-profesional).
- L375: | S4 | Archivos temporales seguros | ALTO | Usar mktemp con permisos restrictivos |
- L710: # Excluir reglas específicas (documentar por qué en código)
- L804: - [Estándares de Código - Regla Fundamental](estandares_codigo.md#regla-fundamental-output-profesional)

### docs/gobernanza/solicitudes/sc00/sc00_documents/README.md
- L25: - [`./guia_documentacion_integrada.md`](./guia_documentacion_integrada.md) · Procedimiento para articular reglas, solicitudes, requisitos y tareas.

### docs/gobernanza/solicitudes/sc00/sc00_documents/checklist_control_flujo.md
- L13: - [ ] Cada regla de negocio activa relacionada con SC00 está registrada en el catálogo oficial con ID RN-XXX y fuente vigente.
- L14: - [ ] Cada regla RN registrada incluye el campo `relacionados` apuntando a la solicitud SC00 correspondiente.
- L15: - [ ] Cada regla cuenta con criterios de verificación documentados y enlazados desde la SRS aplicable.
- L18: - [ ] Toda solicitud en curso en `docs/solicitudes/sc00/` referencia explícitamente las reglas que la originan.
- L23: - [ ] Cada requisito aprobado en `docs/requisitos/` traza hacia la solicitud SC00 y sus reglas madre.
- L30: - [ ] Cada tarea en ejecución registra la validación de la regla de negocio que satisface (pruebas, auditorías o revisiones).
- L37: > **Recordatorio:** Si alguno de los puntos queda sin marcar, no se debe cerrar la solicitud ni dar por cumplida la regla hasta resolver el faltante.

### docs/gobernanza/solicitudes/sc00/sc00_documents/guia_documentacion_integrada.md
- L8: # Guía de documentación integrada: reglas, solicitudes, requisitos y tareas
- L10: Esta guía consolida el análisis previo sobre cómo se relacionan las reglas de negocio, las solicitudes documentales, los requisitos y las tareas
- L28: 1. **Identificar reglas de negocio**
- L29:    - Registrar cada regla con su ID RN-XXX, fuente y nivel de obligatoriedad.
- L30:    - Enlazar la regla a la solicitud que detona (por ejemplo, SC00) usando el campo `relacionados` en el front matter.
- L48: ### 3.1 Alta de nueva regla vinculada a SC00
- L51: - [ ] Solicitud SC00 actualizada con referencia a la regla.
- L74: regla hasta la validación de su cumplimiento a través de solicitudes, requisitos y tareas documentadas.

### docs/gobernanza/solicitudes/sc02/analisis_funcion_real_apps.md
- L612: - Define reglas de precedencia

### docs/gobernanza/solicitudes/sc02/analisis_plantillas.md
- L25: - plantilla_regla_negocio.md

### docs/gobernanza/templates/MATRIZ-trazabilidad-template.md
- L117: - [RN-DOMINIO-###]: [Nombre de la regla]
- L118: - [RN-DOMINIO-###]: [Nombre de la regla]
- L153: | **Regla de Negocio** | [RN-DOMINIO-###] | [Nombre de la regla] | [Influye en este UC] |
- L154: | **Regla de Negocio** | [RN-DOMINIO-###] | [Nombre de la regla] | [Restringe este UC] |
- L209: | [RN-DOMINIO-###]: [Nombre] | N/A (regla interna sin UC) | N/A |
- L217: - [RN-DOMINIO-###]: Crear UC-DOMINIO-XXX para implementar esta regla

### docs/gobernanza/templates/README.md
- L39: #### 2. RN-restriccion-template.md
- L41: - **Propósito**: Plantilla para documentar restricciones (limitaciones de acciones)
- L53:   - Instrucciones sobre palabras clave obligatorias según tipo de restricción
- L495: 1. Identificar tipo de regla (hecho, restricción, desencadenador, inferencia, cálculo)
- L569: - [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](../docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)

### docs/gobernanza/templates/RF-template.md
- L139: ¿Qué pasos o reglas sigue el sistema para cumplir este requisito?
- L141: Si no hay reglas complejas, elimine esta sección.
- L178: - [RN-DOMINIO-###]: [Nombre de la regla]
- L179: - [RN-DOMINIO-###]: [Nombre de la regla]
- L231: OPCIONAL: Liste restricciones técnicas o de negocio específicas.

### docs/gobernanza/templates/RN-calculo-template.md
- L3: tipo: regla_negocio

### docs/gobernanza/templates/RN-desencadenador-template.md
- L3: tipo: regla_negocio
- L51: **SI**: [Describa la condición o evento que dispara la regla]
- L70: - [Parámetro 1]: [Valor o rango que dispara la regla]
- L71: - [Parámetro 2]: [Valor o rango que dispara la regla]
- L100: ¿Qué tan frecuente se espera que se active esta regla?
- L125: ¿Quiénes están involucrados en esta regla?
- L142: OPCIONAL pero RECOMENDADO: Proporcione un ejemplo concreto de cómo funciona esta regla.
- L143: Ayuda a clarificar la regla con un caso real.

### docs/gobernanza/templates/RN-hecho-template.md
- L3: tipo: regla_negocio

### docs/gobernanza/templates/RN-inferencia-template.md
- L3: tipo: regla_negocio
- L92: ¿Qué se SABE después de aplicar esta regla?
- L157: Ayuda a clarificar la regla con un caso real.
- L166: **Aplicación de regla**: [Cómo se aplica la lógica]
- L180: Aplicación de regla:
- L193: ¿Qué otros procesos, reglas o decisiones lo utilizan?

### docs/gobernanza/templates/RN-restriccion-template.md
- L3: tipo: regla_negocio
- L4: subtipo: restriccion
- L18: - El título debe describir claramente la restricción
- L19: - Las restricciones limitan acciones de usuarios y sistemas
- L29: Escriba aquí la declaración clara de la restricción.
- L30: USE las palabras clave obligatorias según el tipo de restricción:
- L44: [Escriba aquí la declaración de la restricción usando palabras clave: debe, no debe, no puede, solo puede]
- L49: Defina claramente a qué o quién aplica esta restricción
- L63: OPCIONAL: Si esta restricción se basa en roles de usuario, incluya una matriz de permisos.
- L89: Explique por qué existe esta restricción.
- L100: **Detalle**: [Explique por qué esta restricción es necesaria]
- L105: OPCIONAL: Liste cualquier excepción a la restricción.
- L112: 1. [Descripción de excepción 1 - bajo qué condiciones no aplica la restricción]
- L116: <!-- No hay excepciones a esta restricción. -->
- L121: Describa cómo se valida el cumplimiento de esta restricción.
- L127: **Descripción**: [Explique cómo se valida que la restricción se cumple]
- L134: OPCIONAL: Describa qué sucede si esta restricción es violada.
- L138: [Describa las consecuencias de no cumplir con esta restricción]
- L143: Liste los requisitos de otros niveles que son influenciados por esta restricción.

### docs/gobernanza/templates/RNF-template.md
- L194: - [RN-DOMINIO-###]: [Nombre de la regla]

### docs/gobernanza/templates/UC-template-completo.md
- L276: Liste aquí Requerimientos No Funcionales (RNF) y restricciones específicos de este caso de uso.
- L309: - [RN-DOMINIO-###]: [Nombre de la regla de negocio]
- L310: - [RN-DOMINIO-###]: [Nombre de la regla de negocio]
- L311: - [RN-DOMINIO-###]: [Nombre de la regla de negocio]

### docs/gobernanza/vision_y_alcance.md
- L40: - Establece restricciones iniciales para [`../../arquitectura/readme.md`](../../arquitectura/readme.md).

### docs/gobernanza/vision_y_alcance/README.md
- L40: - Establece restricciones iniciales para [`../../arquitectura/readme.md`](../../arquitectura/readme.md).

### docs/gobernanza/vision_y_alcance/glossary.md
- L13: | RN | Requisito no funcional que describe restricciones de calidad o plataforma. |

### docs/infraestructura/TASK-017-layer3_infrastructure_logs.md
- L47:  - Validar que el diseno cumpla con restricciones y mejores practicas

### docs/infraestructura/adr/ADR-INFRA-001-vagrant-devcontainer-host.md
- L54: | ¿Cuáles son las restricciones? | Windows/macOS/Linux, sin servicios en host, reproducible |
- L110: - NO: No funciona en todas las máquinas corporativas (restricciones IT)
- L114: **Limitación Crítica:** No es viable para equipos con restricciones de licencia
- L127: - OK: Funciona en Windows, macOS, Linux sin restricciones

### docs/infraestructura/diseno/arquitectura/canvas-pipeline-cicd-devcontainer.md
- L1573: | R4 | **Falsos positivos en seguridad** | Media | Baja | Tuning de reglas bandit; whitelist de issues conocidos; revisión manual de CRITICAL/HIGH | Security |

### docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant-pipeline.md
- L36: Excluye configuraciones específicas de herramientas, reglas de linters o detalles de credenciales/secrets.

### docs/infraestructura/estrategia_migracion_shell_scripts.md
- L92: **Aplicación**: Definir reglas de diseño que NUNCA se violan (similar a TDD Constitution del proyecto).
- L157: │   ├── compliance/          # Compliance con restricciones IACT
- L222: echo "[METACOGNITION] Iniciando validación de restricciones..."
- L228: echo "[METACOGNITION] Método usado: Pattern matching con 8 reglas"
- L858: - [ ] Aplicar constitution principles (8 reglas)
- L935: **Objetivo**: Migrar backend-ci.yml validaciones de restricciones IACT.
- L938: - [ ] Analizar `scripts/validate_critical_restrictions.sh` (YA EXISTE)
- L945: - [ ] Consolidar con `validate_critical_restrictions.sh`

### docs/infraestructura/matriz_trazabilidad_rtm.md
- L23: | DOC-RESTRICCIONES-MAESTRO | Documento Maestro de Restricciones y Lineamientos | restricciones | global | definitivo | - | - |
- L47: | RN-C01-COMPONENTE-1 | Reglas de Negocio - Componente 1 - Autenticación y Sesiones | reglas_negocio | backend | completo_definitivo | - | - |

### docs/infraestructura/procesos/PROC-INFRA-003-hardening-seguridad-infraestructura.md
- L242:    - Configurar reglas de firewall

### docs/infraestructura/procesos/PROC-INFRA-004-backup-recuperacion-infraestructura.md
- L214:    - Implementar regla 3-2-1 (3 copias, 2 medios, 1 offsite)

### docs/infraestructura/procesos/PROC-INFRA-005-monitoreo-observabilidad-infraestructura.md
- L362:    - Crear reglas en Prometheus Alertmanager

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/FASE-4-VALIDACION-LIMPIEZA-README.md
- L584: - **Excepciones**: Documentar y justificar cualquier excepción a las reglas

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/INDICE.md
- L103:   - TASK-002: Validar restricciones en backend y frontend

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/INDICE_REPORTES_EXPLORACION.md
- L96: | ¿Qué debo arreglar esta semana? | Resumen | Hallazgos Críticos |

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/PLAN-DOCUMENTACION-INFRA-2025-11-19.md
- L13: restricciones: ["TDD con cobertura >=80%", "Commits convencionales", "Sin Redis", "Sin envio de correo"]
- L27: **Objetivo principal:** Crear y validar una estructura documental completa para la carpeta `infrastructure/`, alineada con el modelo de QA de Gobernanza y respetando las restricciones de la plataforma.
- L32: - Registro de restricciones “Sin Redis” y “Sin correo” reflejado en guías de despliegue y validaciones automáticas.
- L46: - Identificar dependencias externas y restricciones explícitas (sin Redis, sin correo) en scripts y configuraciones.
- L49: #### Tarea 1.2: Revisar restricciones en backend y frontend
- L116: - **Dependencias:** Acceso a `api/callcentersite` y `ui` para verificar restricciones y rutas de configuración.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/REPORTE-COMPARACION-GOBERNANZA.md
- L264: │   ├── reglas_negocio/
- L326: │   ├── reglas_negocio/

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/REPORTE-LIMPIEZA-EMOJIS.md
- L255: 2. Configurar linter automatizado (markdownlint + regla custom)

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/REPORTE-MODELO-QA-BACKEND-REFERENCIA-2025-11-18.md
- L27: | Cumplimiento restricciones | 100% | 100% | ✅ Cumplido |
- L39: | TASK-002-validar-restricciones-apps | restricciones.json, evidencia-ejecucion.md | ✅ Ejecutada | 24 apps Django, sin Redis, sin correo |
- L154: 2. `TASK-002/evidencias/restricciones.json`
- L214: ✅ **100% de restricciones validadas**
- L227: 2. **Validación exhaustiva** de restricciones y convenciones

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/REPORTE_EXPLORACION_INFRAESTRUCTURA.md
- L108: │       ├── TASK-002-validar-restricciones-apps/
- L148: │   └── reglas_negocio/
- L154: │       └── restricciones.md
- L230:   ├── requisitos/reglas_negocio/*

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/REPORTE_MODELO_GOBERNANZA_COMPLETO.md
- L64: │   ├── ADR-GOB-006-clasificacion-reglas-negocio.md
- L91: │   │   ├── checklist_auditoria_restricciones.md
- L114: │       └── checklist_auditoria_restricciones.md
- L124: │   ├── PROCED-GOB-003-documentar-regla-negocio.md
- L143: │   ├── GUIA-GOB-006-identificar-clasificar-reglas-negocio.md
- L186: │       ├── validate_critical_restrictions.md
- L206: │   ├── plantilla_regla_negocio.md
- L239: │   ├── marco_reglas_negocio.md
- L252: │       └── plantilla-04-regla-negocio.md
- L261: │   ├── checklist_auditoria_restricciones.md
- L303: │   ├── catalogo_reglas_negocio.md
- L367: │   ├── RN-restriccion-template.md
- L466: - PROCED-GOB-001-009: Gobernanza (crear ADRs, documentación, reglas negocio, casos uso, análisis impacto, diagramas, consolidación ramas, permisos git, refactorizaciones)
- L1056: ├── checklist_auditoria_restricciones.md
- L1080: - Auditoría restricciones

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/RESUMEN_HALLAZGOS_INFRAESTRUCTURA.md
- L14: ## 🔴 CRÍTICOS (Arreglar esta semana)
- L26: ## 🟠 ALTOS (Arreglar próximas 2 semanas)

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-001-inventario-infraestructura/README.md
- L26: - Registrar dependencias externas y restricciones explícitas encontradas en configuraciones.
- L32: 3. Consolidar hallazgos en una tabla (componentes, propósito, archivos clave, restricciones) lista para publicarse.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-001-inventario-infraestructura/evidencias/evidencia-ejecucion.md
- L12: Se completó el inventario completo de la estructura `infrastructure/` del proyecto IACT, identificando 5 componentes principales, 57 scripts shell, y verificando cumplimiento de restricciones (sin Redis, sin correo).
- L38: ✅ **Bases de datos**: Solo MariaDB y PostgreSQL (cumple restricción de no SQLite)
- L54: Proceder con TASK-002 para validar restricciones de apps Django.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-001-inventario-infraestructura/evidencias/inventario.json
- L134:   "restricciones_verificadas": {
- L138:     "sin_sqlite": "Cumple restricción de no usar SQLite"

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-002-validar-restricciones-apps/README.md
- L5: nombre: Revisar restricciones en backend y frontend
- L6: titulo: Revisar restricciones en backend y frontend
- L14: # TASK-QA-INFRA-002: Revisar restricciones en backend y frontend
- L35: - Resumen de restricciones verificadas incorporado al plan QA o addendum dedicado.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-002-validar-restricciones-apps/evidencias/evidencia-ejecucion.md
- L12: Se validó que las 24 apps Django del proyecto IACT cumplen con las restricciones establecidas: sin Redis, sin envío de correo real, y configuración modular de settings.
- L44: - `restricciones.json`: Detalle completo de apps, settings y validaciones

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-002-validar-restricciones-apps/evidencias/restricciones.json
- L3:   "tarea": "TASK-002-validar-restricciones-apps",
- L4:   "objetivo": "Validar que apps Django cumplan restricciones del proyecto",
- L41:   "validacion_restricciones": {
- L72:   "restricciones_cumplidas": true,

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-003-diseno-arbol-docs/evidencias/arbol-docs.txt
- L7: │   └── reglas_negocio/

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-004-plantillas-componentes/README.md
- L41: - [ ] Secciones de pruebas y rollback incluidas con referencias a restricciones.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-005-docs-base-componentes/README.md
- L16: **Objetivo:** Generar `README.md` e `INDEX.md` para cada módulo de `infrastructure/` con navegación consistente, restricciones operativas y ejemplos de comandos.
- L41: - [ ] Sección de restricciones operativas completa y visible en cada documento.

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-043-monitoreo-observabilidad/README.md
- L223: **Objetivo**: Establecer umbrales y reglas de alertas
- L814: - **PROCED-INFRA-024-configurar-alertas**: Definición de reglas

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-065-validar-nomenclatura-snake-case/evidencias/nomenclatura-check.json
- L22:       "validar_restricciones_apps"

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/TAREA-COMPLETADA.md
- L103:     - Contenido: Vision, alcance, objetivos, restricciones

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-008-canvas-devcontainer-host/README.md
- L267: - [ ] Revisar restricciones del proyecto (sin Docker en host)

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-008-canvas-devcontainer-host/evidencias/INDEX.md
- L147:    - Modelo arquitectónico, restricción de Docker, VM Vagrant

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-009-canvas-pipeline-cicd-devcontainer/README.md
- L697: | **Falsos positivos en seguridad** | Media | Baja | Tuning de reglas; whitelist de issues conocidos; revisión manual de críticos |
- L748: [OK] Sección 3: Alcance (stages incluidos, exclusiones, supuestos, restricciones)

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-010-consolidar-diseno-database/README.md
- L34: - Referencias inconsistentes a restricciones críticas (RNF-002: NO Redis para sesiones)
- L79: │   │   ├── restricciones_criticas.md      (RNF-002 y otras)
- L124: - **restricciones_criticas.md**: Documentar limitaciones vinculantes
- L159: - [ ] Documentar restricciones críticas en `restricciones_criticas.md`
- L183: - [ ] Validar referencias a restricciones RNF-002
- L189: - [ ] Confirmar restricciones críticas documentadas explícitamente
- L211: # 4. Validar restricciones críticas documentadas

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-010-consolidar-diseno-database/evidencias/DOCUMENTOS-DATABASE-IDENTIFICADOS.md
- L169: **Consolidar en**: `diseno/database/estrategia/restricciones_criticas.md`

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-010-consolidar-diseno-database/evidencias/FASE-1-RESUMEN-EJECUTIVO.md
- L50:   - estrategia/ (dual database, restricciones, migraciones)
- L102: - [x] Matriz de restricciones (2 críticas identificadas):
- L118:   - Checklist 3: Separación de restricciones vs implementación
- L125: **Valor**: Asegura que restricciones críticas sean respetadas durante consolidación
- L183: **Pregunta**: ¿Qué restricciones debo respetar?
- L205: **Síntesis**: TASK-REORG-INFRA-010 tiene una estructura clara a consolidar, con restricciones documentadas y plan detallado para las 6 fases siguientes.
- L229: ### ¿Están las restricciones explícitas?
- L233: grep -c "RNF-002\|restricción\|CRÍTICA\|PROHIBIDO" TASK-REORG-INFRA-010-consolidar-diseno-database/evidencias/*.md
- L306: # 3. Confirmar restricciones documentadas
- L319: | evidencias/RESTRICCIONES-CRITICAS-DATABASE.md | 15 KB | Análisis de restricciones críticas |
- L364: 2. Identificación explícita de restricciones críticas
- L389: 5. ✓ Qué proteger (restricciones críticas documentadas)

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-010-consolidar-diseno-database/evidencias/RESTRICCIONES-CRITICAS-DATABASE.md
- L5: Existen **2 restricciones críticas** que gobiernan el diseño e implementación de base de datos en IACT. Estas deben estar **explícitamente documentadas y referenciables** en `diseno/database/estrategia/restricciones_criticas.md`.
- L42: En `diseno/database/estrategia/restricciones_criticas.md` incluir:
- L152: | RNF-002 | Persistencia | CRÍTICA | Diseño/Código | restricciones_criticas.md |
- L166: [ ] diseno/database/estrategia/restricciones_criticas.md
- L203: [ ] diseno/database/estrategia/restricciones_criticas.md
- L210: # ✗ NO debe haber restricciones en implementacion/
- L220: Crear: diseno/database/estrategia/restricciones_criticas.md
- L238: ├── Link a restricciones_criticas.md
- L250: # Script: validate_database_restrictions.sh
- L253: if grep -q "RNF-002\|NO Redis.*sesiones" diseno/database/estrategia/restricciones_criticas.md; then
- L281: ### Documentos que deben incluir referencias a restricciones:
- L284:    - Destacar restricciones críticas
- L285:    - Link a restricciones_criticas.md
- L296:    - Validar que implementan correctamente las restricciones
- L308: - Existen restricciones críticas que no están explícitamente documentadas
- L318: - Crear documento explícito `restricciones_criticas.md`
- L319: - Hacer restricciones **searchable** y **referenceable**
- L321: - Documentar consecuencias de violar restricciones
- L325: - ¿Está separado de implementación? → `ls diseno/database/estrategia/restricciones_criticas.md`
- L332: **Próxima Acción**: Consolidar en `diseno/database/estrategia/restricciones_criticas.md`

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-020-validar-estructura-post-fase2/README.md
- L318: 5. Estimado: Tiempo para arreglarlo

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-034-crear-adr-infra-004-networking/evidencias/RESUMEN-EJECUCION.md
- L16: - **Host-only:** Similar a private network pero mas restrictivo

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/plantillas-evidencias/PLANTILLA-CHECKLIST-TAREAS.md
- L56: - [ ] Identificar restricciones o limitaciones

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/plantillas-evidencias/PLANTILLA-RESUMEN-EJECUCION.md
- L67: - [Limites y restricciones]

### docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/tareas_activas.md
- L10: | TASK-002 | validar-restricciones-apps | ✅ COMPLETADA | restricciones.json, evidencia-ejecucion.md | 2025-11-18 |

### docs/infraestructura/qa/plantillas/plantilla_observabilidad.md
- L26: - Configuración de alertas y reglas de retención documentadas en `qa/registros/`.

### docs/infraestructura/qa/tareas_activas.md
- L51: - [ ] **Validar restricciones criticas** `P0` `1SP`
- L52:   - Comando: `./scripts/validate_critical_restrictions.sh`

### docs/infraestructura/qa/testing/comandos_validacion.md
- L7: relacionados: ["scripts/run_all_tests.sh", "scripts/validate_critical_restrictions.sh", "scripts/validar_estructura_docs.sh"]
- L17: | `./scripts/validate_critical_restrictions.sh` | Validar restricciones críticas (sin Redis, sin correo) en configuraciones | @backend-lead | Resultado del comando con timestamp y hallazgos documentados |

### docs/infraestructura/requisitos/reglas_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L14: 2. **Restricciones** (`restricciones.md`) - Matriz roles/permisos
- L21: Documenta las reglas de negocio específicas del dominio infraestructura.

### docs/infraestructura/requisitos/reglas_negocio/calculos.md
- L5: tipo: reglas_negocio_calculos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio infraestructura.

### docs/infraestructura/requisitos/reglas_negocio/desencadenadores.md
- L5: tipo: reglas_negocio_desencadenadores
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio infraestructura.

### docs/infraestructura/requisitos/reglas_negocio/hechos.md
- L5: tipo: reglas_negocio_hechos
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/infraestructura/requisitos/reglas_negocio/inferencias.md
- L5: tipo: reglas_negocio_inferencias
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio infraestructura.

### docs/infraestructura/requisitos/reglas_negocio/restricciones.md
- L5: tipo: reglas_negocio_restricciones
- L13: Ver: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
- L17: **Constraints** (restricciones): [Definicion pendiente segun marco conceptual]
- L27: **Descripcion**: Pendiente de documentar reglas especificas del dominio infraestructura.
- L37: - [ ] Identificar restricciones especificas del dominio infraestructura

### docs/infraestructura/requisitos/requerimientos_funcionales/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/infraestructura/requisitos/requerimientos_negocio/README.md
- L9: Marco conceptual: `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`

### docs/infraestructura/shell_scripts_constitution.md
- L15: Este documento define 8 reglas inmutables que TODOS los shell scripts deben seguir, siguiendo el mismo patrón que `TDD_CONSTITUTION.py`.
- L29: **Solución**: Constitution con reglas inmutables.
- L569: ### Cuándo NO aplicar reglas:
- L814: **Paso 2**: Arreglar violaciones CRITICAL primero
- L821: **Paso 3**: Arreglar violaciones HIGH
- L827: **Paso 4**: Arreglar violaciones MEDIUM

### docs/infraestructura/vision_y_alcance/README.md
- L8:   - restricciones_limitaciones.md
- L17: Este directorio contiene la vision estrategica y el alcance de infraestructura. Define objetivos estrategicos, restricciones, limitaciones y vision a largo plazo.
- L36: ├── restricciones/
- L37: │   └── restricciones_limitaciones.md

### docs/mkdocs.yml
- L105:       - Catálogo de Reglas de Negocio: anexos/catalogo_reglas_negocio.md

### docs/operaciones/claude_code.md
- L30: El entorno de ejecución de Claude Code tiene restricciones de red y permisos que impiden la instalación de GitHub CLI (`gh`).
- L62: - [OK] Evita restricciones de red y permisos
- L177: 5. [OK] **Archivo .bashrc** con permisos restrictivos:
- L453: - Proxy/firewall restrictivo
- L559: - **2025-11-02 v2**: Aplicar regla de NO emojis (docs/gobernanza/estandares_codigo.md)

### docs/operaciones/procedimiento_merge_analyze_scripts.md
- L118: ### 7. Manejo de restricciones de permisos
- L191: - `64ed45b` - Add marco conceptual for reglas de negocio
- L233: 2. **Permisos**: Claude Code tiene restricciones para push directo a ramas principales, requiere usar ramas `claude/*` o que el usuario haga push manual.

### docs/scripts/QUICKSTART.md
- L54: # Validar restricciones criticas (RNF-002)
- L55: ./scripts/validate_critical_restrictions.sh
- L289: ./scripts/validate_critical_restrictions.sh
- L302: ./scripts/validate_critical_restrictions.sh

### docs/scripts/README.md
- L41: - `compliance/` - Cumplimiento de restricciones
- L78: | `validate_critical_restrictions.sh` | Valida RNF-002 (NO Redis) | [IMPLEMENTADO] |
- L193: ./scripts/validate_critical_restrictions.sh
- L215: ./scripts/validate_critical_restrictions.sh

### docs/scripts/analisis/DOMAIN_ANALYSIS.json
- L158:         "validate_critical_restrictions.sh",
- L257:         "gate-restrictions.sh",

### docs/scripts/analisis/SUMMARY.json
- L757:         "file": "validate_critical_restrictions.sh",
- L3399:         "file": "validate_critical_restrictions.sh",
- L3407:         "file": "validate_critical_restrictions.sh",
- L3415:         "file": "validate_critical_restrictions.sh",
- L3423:         "file": "validate_critical_restrictions.sh",
- L3431:         "file": "validate_critical_restrictions.sh",
- L3439:         "file": "validate_critical_restrictions.sh",
- L3447:         "file": "validate_critical_restrictions.sh",
- L3455:         "file": "validate_critical_restrictions.sh",

### docs/scripts/analisis/gate-restrictions.sh_analysis.json
- L2:   "script_name": "gate-restrictions.sh",
- L3:   "script_path": "scripts/ci/gate-restrictions.sh",

### docs/scripts/analisis/gate-restrictions.sh_analysis.md
- L2: title: Analysis: gate-restrictions.sh
- L8: # Analysis: gate-restrictions.sh

### docs/scripts/analisis/remediation_plan.md
- L337: 2. `validate_critical_restrictions.sh` (75/100) - 9 issues

### docs/scripts/analisis/validate_critical_restrictions.sh_analysis.json
- L2:   "script_name": "validate_critical_restrictions.sh",
- L3:   "script_path": "scripts/validate_critical_restrictions.sh",

### docs/scripts/analisis/validate_critical_restrictions.sh_analysis.md
- L2: title: Analysis: validate_critical_restrictions.sh
- L8: # Analysis: validate_critical_restrictions.sh

### docs/scripts/ci_cd_scripts.md
- L36: 2. Valida restricciones IACT (RNF-002: NO Redis, NO email)
- L41: 7. Valida restricciones criticas
- L49: [INFO] Step 2/6: Validating IACT restrictions (RNF-002)...
- L518: 5. **Validar restricciones criticas:**
- L520:    ./scripts/validate_critical_restrictions.sh

### docs/scripts/script_development_guide.md
- L425: Los scripts deben respetar restricciones criticas:

### docs/scripts/sdlc_process_guide.md
- L77:                    │ Consulta reglas
- L83: │  - Valida compliance con reglas del proyecto                │
- L84: │  - Asegura restricciones criticas (RNF-002)                │
- L278:   - Viola restriccion critica RNF-002 (NO Redis)
- L653:   - Usar alternativa compatible con restricciones
- L661: ./scripts/validate_critical_restrictions.sh

### docs/scripts/sdlc_automation_reference.md
- L770:    - Asegura compliance con restricciones criticas

### infrastructure/vagrant/config/apt/sources.list
- L8: # TIER 1: Corporate/Local Mirrors (Fast but may be restricted)
- L10: deb http://91.189.91.81/ubuntu/ bionic main restricted
- L11: deb http://91.189.91.81/ubuntu/ bionic-updates main restricted
- L16: deb http://91.189.91.81/ubuntu/ bionic-backports main restricted universe multiverse
- L19: deb http://archive.ubuntu.com/ubuntu/ bionic main restricted
- L20: deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted
- L25: deb http://archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
- L29: deb http://185.125.190.82/ubuntu/ bionic-security main restricted
- L34: deb http://security.ubuntu.com/ubuntu/ bionic-security main restricted

### infrastructure/vagrant/scripts/postgres_install.sh
- L410:     # Agregar reglas de autenticacion si no existen

### monitoring/dashboards/business_rules_compliance.json
- L224:         "description": "Regla BR-R10: Restricción - Detectar intentos de cerrar llamadas sin clasificación (violación de regla)"
- L240:         "description": "Lista de alertas activas relacionadas con violaciones de reglas de negocio"

### scripts/README.md
- L31: - `run_all_tests.sh`: ejecuta validaciones encadenadas (backend, UI, seguridad y restricciones). Revisa el propio script para conocer flags como `--skip-frontend` o `--skip-security`.

### scripts/ci/gate-restrictions.sh
- L2: # gate-restrictions.sh
- L4: # Gate: Validates critical project restrictions
- L7: #   0 - All restrictions followed
- L34: python3 scripts/ai/agents/validation/restrictions_gate.py

### scripts/ci/run-all-gates.sh
- L138: run_gate "restrictions" "$SCRIPT_DIR/gate-restrictions.sh"

### scripts/coding/ai/agents/README_BUSINESS_ANALYSIS.md
- L308:    - Deriva reglas de negocio clasificadas
- L439: - Clasificación de reglas: Hecho, Restricción, Desencadenador, Inferencia, Cálculo
- L494: - `business_rules`: Lista de reglas
- L518: - `business_rules` (optional): Lista de reglas
- L672: - 14 reglas de negocio (RN-C01-01 a RN-C01-14)

### scripts/coding/ai/agents/README_SDLC_AGENTS.md
- L146: 4. **VALIDATION**: Valida 8 reglas de TDD constitution
- L149: **Constitution Checks** (8 reglas):

### scripts/coding/ai/agents/base/chain_of_verification.py
- L429:         """Verifica consistencia con restricciones del proyecto."""
- L430:         if not context or 'project_restrictions' not in context:
- L433:         restrictions = context['project_restrictions']
- L435:         # Verificar contra restricciones conocidas
- L436:         for restriction in restrictions:
- L437:             if restriction.lower() in claim.lower():
- L440:                     'issue': f'Claim conflicts with project restriction: {restriction}'
- L592:         'project_restrictions': [

### scripts/coding/ai/agents/base/prompt_templates.py
- L87: Your role is to analyze code/configuration and identify violations of project restrictions.
- L96: {project_restrictions}
- L137:                     name="project_restrictions",
- L138:                     description="List of project restrictions to enforce",
- L290: Project restrictions to check:
- L291: {project_restrictions}
- L297: - Compliance with project restrictions
- L340: [Project restrictions compliance check with citations]
- L357:                     name="project_restrictions",
- L358:                     description="Project-specific restrictions",
- L635:         "project_restrictions": "- NO Redis for sessions\n- NO emojis\n- IVR database is READ-ONLY",

### scripts/coding/ai/agents/base/tree_of_thoughts.py
- L312:                 "Verify compliance with project restrictions",

### scripts/coding/ai/agents/database/db_router_gate.py
- L5: Validates that database router never writes to IVR database (read-only restriction).
- L143:                 'project_restrictions': [

### scripts/coding/ai/agents/documentation/docs_structure_gate.py
- L92:                 "message": "Emoji found in documentation (project restriction)"

### scripts/coding/ai/agents/meta/uml_generator_agent.py
- L464:             # Skip IACT-restricted components

### scripts/coding/ai/agents/placement/contexto.py
- L26:     reglas_contextuales = {
- L58:     return reglas_contextuales.get(key, "ANALIZAR_MANUAL")

### scripts/coding/ai/agents/requirements/README.md
- L314: - [Estándares de Código - Regla Fundamental](../../docs/gobernanza/estandares_codigo.md#regla-fundamental-output-profesional)

### scripts/coding/ai/agents/tdd/README.md
- L82: # NOTA: Por restricciones del proyecto, usamos shell scripts en lugar de GitHub Actions

### scripts/coding/ai/agents/validation/emoji_lint_gate.py
- L6: Project restriction: NO emojis/icons.
- L93:             print("[OK] No emojis found (project restriction complied)")

### scripts/coding/ai/agents/validation/restrictions_gate.py
- L5: Validates critical project restrictions are followed:
- L21:     """Gate that validates project restrictions."""
- L35:     def validate_restrictions(self) -> bool:
- L36:         """Validate all project restrictions."""
- L136:             print("[OK] All project restrictions are followed")
- L139:         print(f"[ERROR] Found {len(self.violations)} restriction violations")
- L160:     if gate.validate_restrictions():

### scripts/coding/ai/automation/README.md
- L9: - **`business_rules_validator_agent.py`** - Valida documentación de reglas de negocio (5 tipos: Hechos, Restricciones, Desencadenadores, Inferencias, Cálculos)

### scripts/coding/ai/automation/business_rules_validator_agent.py
- L5: Agente de validacion de documentacion de reglas de negocio para garantizar
- L10: - Validar estructura de documentacion de reglas de negocio

### scripts/coding/ai/automation/compliance_validator_agent.py
- L6: cobertura completa de reglas de negocio, nombres siguiendo Clean Code, y
- L10: - Validar cobertura de reglas de negocio (BR-R**, BR-H**, etc.)

### scripts/coding/ai/business_analysis/generator.py
- L131:         # Paso 2: Derivar reglas de negocio
- L132:         self.logger.info("Paso 2/7: Derivando reglas de negocio")
- L322:         Deriva reglas de negocio de los procesos.
- L329:             Lista de reglas de negocio
- L333:         # Si se proporcionaron reglas explícitamente, usarlas
- L337:         # Si no, generar reglas básicas automáticamente
- L341:         # Generar al menos una regla de restricción básica
- L371:             business_rules: Lista de reglas de negocio
- L417:             business_rules: Lista de reglas de negocio
- L541:             business_rules: Lista de reglas

### scripts/coding/ai/generators/template_generator.py
- L216: [COMPLETAR: Descripción detallada de la regla]
- L370: - [ ] Todas las reglas identificadas
- L371: - [ ] Cada regla tiene ID único (RN-[ÁREA]-[NN])
- L457: [COMPLETAR: Descripción en lenguaje natural de la regla de negocio]
- L494: [COMPLETAR: Descripción de cómo el sistema valida que la regla se cumple]

### scripts/coding/ai/generators/traceability_matrix_generator.py
- L443:         Crea matriz de impacto de reglas de negocio.
- L446:             business_rules: Lista de reglas de negocio
- L462:             # Buscar UC impactados (UC que referencian esta regla)
- L468:             # Buscar requisitos impactados (requisitos que referencian esta regla)
- L510:             business_rules: Lista de reglas de negocio

### scripts/coding/ai/quality/completeness_validator.py
- L43:         "reglas_negocio",
- L244:                 "reglas_negocio": "business_rules",
- L423:             # Validar IDs de reglas

### scripts/coding/ai/sdlc/deployment_agent.py
- L275: ./scripts/validate_critical_restrictions.sh
- L686: - [ ] Restrictions validated: ./scripts/validate_critical_restrictions.sh

### scripts/coding/ai/sdlc/design_agent.py
- L517:                     "Positivo: Cumple con restricciones IACT",
- L572: - docs/backend/requisitos/restricciones_y_lineamientos.md
- L1097:         """Define reglas de validacion."""
- L1162: 3. Tecnologías recomendadas que cumplan restricciones IACT
- L1372:         # Validar que HLD menciona restricciones IACT

### scripts/coding/ai/sdlc/feasibility_agent.py
- L214:         # Check restricciones criticas IACT
- L283: 1. Si el feature viola restricciones críticas del proyecto
- L400:                 "description": "Violacion de restricciones criticas",
- L401:                 "mitigation": "Redisenar feature para cumplir restricciones",
- L764:                 "Redisenar feature para cumplir restricciones"

### scripts/coding/ai/shared/constitution_loader.py
- L29:             rules: Lista de reglas del principio
- L87:             # Extraer reglas del principio (listas, puntos importantes)
- L104:         Extrae reglas importantes del texto de un principio.
- L110:             Lista de reglas extraídas
- L118:         # Extraer texto en negrita (reglas importantes)
- L130:         return unique_rules[:10]  # Limitar a 10 reglas más importantes
- L309:             "cambiar_reglas_negocio"

### scripts/coding/ai/tdd/README.md
- L7: - `constitution.py` - 8 reglas inmutables de cumplimiento TDD (4 CRITICAL, 2 HIGH, 2 MEDIUM)
- L17: 4. **VALIDATION**: Valida 8 reglas de constitution

### scripts/coding/ai/tdd/constitution.py
- L5: Este modulo define las reglas que NO PUEDEN ser violadas durante
- L27:     """Representa una regla de la constitution TDD."""
- L67:     Estas reglas garantizan que el proceso TDD se ejecute correctamente:
- L152:                 - compliant: bool (True si cumple todas las reglas CRITICAL)
- L155:                 - evidence: Dict con evidencia de cada regla
- L563:         - CRITICAL: 40 puntos (10 por regla)
- L564:         - HIGH: 30 puntos (15 por regla)
- L565:         - MEDIUM: 30 puntos (7.5 por regla)
- L574:                 score -= 10.0  # 4 reglas CRITICAL x 10 = 40 puntos
- L576:                 score -= 15.0  # 2 reglas HIGH x 15 = 30 puntos
- L578:                 score -= 7.5   # 4 reglas MEDIUM x 7.5 = 30 puntos

### scripts/coding/tests/ai/agents/test_constitution_integration.py
- L156:     def test_validate_authority_restricted_action(self, validator):
- L158:         restricted_actions = [
- L165:         for action in restricted_actions:

### scripts/coding/tests/ai/automation/test_business_rules_validator_agent.py
- L88:     def valid_hechos_restricciones_content(self):
- L230:                                                          valid_hechos_restricciones_content):
- L241:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L255:                                                           valid_hechos_restricciones_content):
- L266:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L302:     def test_categorization_missing_restricciones_section_fails(self, temp_docs_dir,
- L325:                                                   valid_hechos_restricciones_content):
- L335:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L348:                                                          valid_hechos_restricciones_content):
- L358:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L371:                                                        valid_hechos_restricciones_content,
- L382:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L462:                                                 valid_hechos_restricciones_content):
- L472:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L565:                                                 valid_hechos_restricciones_content,
- L576:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L687:                                             valid_hechos_restricciones_content,
- L700:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)
- L751:                               valid_hechos_restricciones_content):
- L761:         (temp_docs_dir / "HECHOS_RESTRICCIONES.md").write_text(valid_hechos_restricciones_content)

### scripts/coding/tests/ai/sdlc/test_deployment_agent.py
- L374:     def test_generate_pre_deployment_checklist_includes_iact_restrictions(
- L377:         """Should include IACT-specific restrictions."""

### scripts/completeness_analysis_agent.py
- L38:             "gobernanza/marco_integrado/marco_reglas_negocio.md",
- L44:             "reglas_negocio": {
- L45:                 "files": ["hechos.md", "restricciones.md", "desencadenadores.md",
- L182:             "requisitos/reglas_negocio/README.md",
- L222:             r"docs/gobernanza/marco_integrado/marco_reglas_negocio\.md",
- L238:                 "requisitos/reglas_negocio/README.md",

### scripts/constitucion.sh
- L77: Validar conformidad con principios y reglas codificadas en .constitucion.yaml
- L83:     pre-commit          Valida reglas scope=pre-commit (R2: emojis)
- L84:     pre-push            Valida reglas scope=pre-push (R1, R3, R4, R5)
- L85:     devcontainer-init   Valida reglas scope=devcontainer-init (R6)
- L86:     ci-local            Valida reglas para CI local
- L88:     validate-all        Valida TODAS las reglas (CI completo)
- L103:     0   Todas las reglas pasaron (o solo warnings)
- L104:     1   Al menos una regla ERROR violada (bloqueante)

### scripts/deploy.sh
- L174: # Validar restricciones criticas
- L175: if [ -f "$SCRIPT_DIR/validate_critical_restrictions.sh" ]; then
- L176:     bash "$SCRIPT_DIR/validate_critical_restrictions.sh"
- L178:         echo "[FAIL] Validacion de restricciones criticas FALLO"

### scripts/generar-matriz-trazabilidad.py
- L204:         output.append("Esta matriz muestra la cadena de trazabilidad vertical desde reglas de negocio hasta atributos de calidad.")

### scripts/guides/generate_guides.py
- L988:             descripcion="Aprende a validar que tu código no viola restricciones críticas del proyecto (RNF-002).",
- L991:                     "titulo": "Ejecutar validación de restricciones",
- L992:                     "descripcion": "Ejecuta el script que valida restricciones críticas.",
- L993:                     "comando": "./scripts/validate_critical_restrictions.sh",
- L994:                     "output": "All critical restrictions validated: PASSED"
- L997:                     "titulo": "Revisar restricciones validadas",
- L1004:                     "descripcion": "Si falla, revisa qué restricción violaste.",
- L1011:                 "Script validate_critical_restrictions.sh disponible"
- L1032:                 "Script validación": "scripts/validate_critical_restrictions.sh",
- L1033:                 "RNF-002": "docs/requisitos/rnf-002-restricciones-criticas.md",

### scripts/infrastructure/ci/backend_test.sh
- L97: log_info "Step 2/6: Validating IACT restrictions (RNF-002)..."
- L199: if [ -f "$PROJECT_ROOT/scripts/validate_critical_restrictions.sh" ]; then
- L200:     bash "$PROJECT_ROOT/scripts/validate_critical_restrictions.sh" || {
- L201:         log_error "Critical restrictions validation failed"
- L205:     log_warning "validate_critical_restrictions.sh not found"

### scripts/infrastructure/ci/security_scan.sh
- L6: # Valida restricciones IACT criticas (RNF-002)

### scripts/run_all_tests.sh
- L168: if [ -f "$SCRIPT_DIR/validate_critical_restrictions.sh" ]; then
- L169:     bash "$SCRIPT_DIR/validate_critical_restrictions.sh"
- L178:     echo "[WARNING] Script validate_critical_restrictions.sh no encontrado"
- L204:     echo "  Validaciones: ./scripts/validate_critical_restrictions.sh"

### scripts/templates/README.md
- L109: - [ ] Verificar que se sigan los [Estándares de Salida](../../docs/gobernanza/estandares_codigo.md#regla-de-oro-output-profesional)

### scripts/trazabilidad/matriz-vertical-BACK.md
- L5: Esta matriz muestra la cadena de trazabilidad vertical desde reglas de negocio hasta atributos de calidad.

### scripts/validate_critical_restrictions.sh
- L2: # scripts/validate_critical_restrictions.sh
- L3: # Valida que se cumplan las restricciones críticas del proyecto IACT
- L11: echo "[INFO] Validando restricciones críticas del proyecto IACT..."
- L175:     echo "   2. Corregir el código según las restricciones"
- L177:     echo "   4. Consultar: docs/requisitos/restricciones_completas.md"

### scripts/validate_security_config.sh
- L215:     echo "   4. Consultar: docs/qa/checklist_auditoria_restricciones.md"

### scripts/validation/README.md
- L11: ├── compliance/       # IACT restrictions compliance (no Redis, no email, etc.)

### ui/README.md
- L397: El UI debe respetar las restricciones del backend:
