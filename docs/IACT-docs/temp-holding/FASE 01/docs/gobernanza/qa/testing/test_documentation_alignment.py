"""Tests de consistencia documental para proteger los ajustes de la revisión 2025-11-12."""

from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
PROJECT_ROOT = REPO_ROOT.parent


def _read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def test_readme_acknowledges_absence_of_root_makefile():
    readme = _read(REPO_ROOT / "README.md")
    assert "No existe un Makefile en la raíz" in readme
    assert "docs/operaciones/verificar_servicios.md" in readme
    assert "./scripts/verificar_servicios.sh" in readme
    assert "[IMPLEMENTADO]" in readme
    assert "make docs-serve" not in readme


def test_docs_index_and_stubs_are_canonical():
    index = _read(REPO_ROOT / "docs/index.md")
    assert "## [DOCS] Documentación activa" in index
    assert "## [LEGADO] Contenido legado" in index

    index_stub = _read(REPO_ROOT / "docs/INDEX.md")
    indice_stub = _read(REPO_ROOT / "docs/INDICE.md")
    expected = "Consulta el índice consolidado en [index.md](index.md)."
    assert expected in index_stub
    assert expected in indice_stub


def test_scripts_documentation_reflects_current_inventory():
    scripts_readme = _read(REPO_ROOT / "scripts/README.md")
    assert "Cualquier referencia anterior a `scripts/requisitos/`" in scripts_readme
    assert "validation/" in scripts_readme
    assert "validacion/" in scripts_readme

    docs_scripts = _read(REPO_ROOT / "docs/scripts/README.md")
    assert "No existen scripts como `scripts/sdlc_agent.py`" in docs_scripts
    assert "scripts/ci" in docs_scripts


def test_logs_and_analysis_documentation_are_updated():
    schema = _read(REPO_ROOT / "logs_data/SCHEMA.md")
    assert "Automatización parcial" in schema
    assert "scripts/dora_metrics.py" in schema

    analyzer = _read(REPO_ROOT / "scripts/analyze_backend.py")
    assert "logs_data/analysis/backend_analysis_results.json" in analyzer


def test_run_all_tests_targets_ui_directory():
    script = _read(REPO_ROOT / "scripts/run_all_tests.sh")
    assert "UI_DIR" in script
    assert "FRONTEND_DIR" not in script


def test_architecture_design_patterns_catalog_is_referenced():
    guide_path = REPO_ROOT / "docs/arquitectura/patrones/DESIGN_PATTERNS_GUIDE.md"
    assert guide_path.exists()

    guide_contents = _read(guide_path)
    assert "#" in guide_contents

    index_contents = _read(REPO_ROOT / "docs/index.md")
    assert "arquitectura/patrones/DESIGN_PATTERNS_GUIDE.md" in index_contents

    architecture_readme = _read(REPO_ROOT / "docs/arquitectura/README.md")
    assert "patrones/DESIGN_PATTERNS_GUIDE.md" in architecture_readme


def test_cpython_install_script_renamed():
    renamed_path = REPO_ROOT / "infraestructura/cpython/scripts/install_prebuilt_cpython.sh"
    assert renamed_path.exists()


def test_revision_20251112_lives_in_docs_analisis():
    revision_path = REPO_ROOT / "docs/analisis/revision_20251112_consolidada.md"
    assert revision_path.exists()

    index_contents = _read(REPO_ROOT / "docs/index.md")
    assert "analisis/revision_20251112_consolidada.md" in index_contents

    legacy_path = REPO_ROOT / "rev/revision_20251112_consolidada.md"
    assert not legacy_path.exists()


def test_docs_analisis_agent_guides_revision_location():
    agent_path = REPO_ROOT / "docs/analisis/AGENTS.md"
    assert agent_path.exists()

    agent_contents = _read(agent_path)
    assert "ETA-AGENTE CODEX" in agent_contents
    assert "colocar las revisiones consolidadas" in agent_contents


def test_eta_codex_agent_is_implemented_in_agents_tree():
    agent_module = REPO_ROOT / "scripts/coding/ai/agents/documentation/eta_codex_agent.py"
    assert agent_module.exists()

    tests_path = REPO_ROOT / "scripts/coding/tests/ai/agents/documentation/test_eta_codex_agent.py"
    assert tests_path.exists()


def test_phi3_prompt_engineering_playbook_is_published_and_linked():
    guide_path = REPO_ROOT / "docs/ai_capabilities/prompting/PHI3_PROMPT_ENGINEERING_PLAYBOOK.md"
    assert guide_path.exists()

    readme = _read(REPO_ROOT / "README.md")
    assert "PHI3_PROMPT_ENGINEERING_PLAYBOOK.md" in readme

    prompting_index = _read(REPO_ROOT / "docs/ai_capabilities/prompting/README.md")
    assert "Phi-3" in prompting_index


def test_codex_mcp_multi_agent_guide_is_linked():
    guide_path = REPO_ROOT / "docs/ai_capabilities/orchestration/CODEX_MCP_MULTI_AGENT_GUIDE.md"
    assert guide_path.exists()

    readme = _read(REPO_ROOT / "README.md")
    assert "CODEX_MCP_MULTI_AGENT_GUIDE.md" in readme

    prompting_index = _read(REPO_ROOT / "docs/ai_capabilities/prompting/README.md")
    assert "Codex MCP Multi-Agent Guide" in prompting_index

    agent_catalog = _read(REPO_ROOT / ".agent" / "agents" / "README.md")
    assert "CodexMCPWorkflow Orchestrator" in agent_catalog


def test_hamilton_framework_integration_doc_is_published():
    guide_path = PROJECT_ROOT / "docs" / "gobernanza" / "ai" / "HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md"
    assert guide_path.exists(), "Debe existir la guía de integración Hamilton alineada a las 6 fases SDLC"

    index_contents = _read(REPO_ROOT / "index.md")
    assert "gobernanza/ai/HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md" in index_contents


def test_issue_templates_connect_execplans_and_agents():
    templates_dir = REPO_ROOT / ".github" / "ISSUE_TEMPLATE"
    assert templates_dir.exists(), "La carpeta .github/ISSUE_TEMPLATE debe existir"

    feature_template = _read(templates_dir / "feature_request.md")
    assert "ExecPlan" in feature_template
    assert ".agent/PLANS.md" in feature_template

    custom_template = _read(templates_dir / "custom.md")
    assert ".agent/agents" in custom_template
    assert "Agente" in custom_template

    bug_template = _read(templates_dir / "bug_report.md")
    assert "SecurityAgent" in bug_template or "DependencyAgent" in bug_template


def test_ci_workflows_cover_quality_security_and_dependencies():
    workflows_dir = REPO_ROOT / ".github" / "workflows"
    quality = workflows_dir / "code-quality.yml"
    codeql = workflows_dir / "codeql.yml"
    dependency = workflows_dir / "dependency-review.yml"

    assert quality.exists()
    assert codeql.exists()
    assert dependency.exists()

    quality_yaml = _read(quality)
    assert "./scripts/run_all_tests.sh" in quality_yaml
    assert "pytest" in quality_yaml

    codeql_yaml = _read(codeql)
    assert "github/codeql-action/init" in codeql_yaml

    dependency_yaml = _read(dependency)
    assert "dependency-review-action" in dependency_yaml


def test_readme_links_issue_templates_and_agents():
    readme = _read(REPO_ROOT / "README.md")
    assert "ISSUE_TEMPLATE" in readme
    assert ".agent/agents" in readme


def test_agent_catalog_links_to_docs_and_scripts():
    agent_readme = _read(REPO_ROOT / ".agent" / "README.md")
    assert "docs/ai/SDLC_AGENTS_GUIDE.md" in agent_readme
    assert "scripts/coding/ai/agents" in agent_readme


def test_llm_provider_agents_are_documented():
    agents_dir = REPO_ROOT / ".agent" / "agents"
    providers = {
        "claude_agent.md": "ClaudeAgent",
        "chatgpt_agent.md": "ChatGPTAgent",
        "huggingface_agent.md": "HuggingFaceAgent",
    }

    catalog_contents = _read(agents_dir / "README.md")

    for filename, label in providers.items():
        agent_path = agents_dir / filename
        assert agent_path.exists(), f"Falta el archivo {filename} en el catálogo de agentes"

        agent_contents = _read(agent_path)
        assert "scripts/coding/ai/generators/llm_generator.py" in agent_contents
        assert "docs/ai/CONFIGURACION_API_KEYS.md" in agent_contents
        assert "docs/plans/EXECPLAN_codex_mcp_multi_llm.md" in agent_contents

        assert label in catalog_contents

    sdlc_guide = _read(REPO_ROOT / "docs" / "ai" / "SDLC_AGENTS_GUIDE.md")
    for label in providers.values():
        assert label in sdlc_guide


def test_domain_agents_are_documented_and_linked():
    agents_dir = REPO_ROOT / ".agent" / "agents"
    domain_agents = {
        "api_agent.md": "ApiAgent",
        "ui_agent.md": "UiAgent",
        "infrastructure_agent.md": "InfrastructureAgent",
        "docs_agent.md": "DocsAgent",
        "scripts_agent.md": "ScriptsAgent",
    }

    catalog_contents = _read(agents_dir / "README.md")
    root_readme = _read(REPO_ROOT / ".agent" / "README.md")
    sdlc_guide = _read(REPO_ROOT / "docs" / "ai" / "SDLC_AGENTS_GUIDE.md")

    execplan_path = REPO_ROOT / "docs" / "plans" / "EXECPLAN_agents_domain_alignment.md"
    assert execplan_path.exists(), "Debe existir el ExecPlan de alineación por dominios"

    for filename, label in domain_agents.items():
        agent_path = agents_dir / filename
        assert agent_path.exists(), f"Falta el archivo {filename}"

        contents = _read(agent_path)
        assert "docs/plans/EXECPLAN_agents_domain_alignment.md" in contents
        assert label in catalog_contents
        assert label in root_readme
        assert label in sdlc_guide


def test_prompt_techniques_catalog_is_linked_across_agents():
    catalog_path = REPO_ROOT / "docs" / "ai_capabilities" / "prompting" / "PROMPT_TECHNIQUES_CATALOG.md"
    assert catalog_path.exists(), "Falta el catálogo de técnicas de prompting"

    catalog_contents = _read(catalog_path)
    assert "Catálogo Completo de Técnicas de Prompts" in catalog_contents

    prompting_index = _read(REPO_ROOT / "docs" / "ai_capabilities" / "prompting" / "README.md")
    assert "PROMPT_TECHNIQUES_CATALOG.md" in prompting_index

    root_readme = _read(REPO_ROOT / "README.md")
    assert "PROMPT_TECHNIQUES_CATALOG.md" in root_readme

    agent_catalog = _read(REPO_ROOT / ".agent" / "agents" / "README.md")
    assert "PROMPT_TECHNIQUES_CATALOG.md" in agent_catalog

    provider_agents = [
        "claude_agent.md",
        "chatgpt_agent.md",
        "huggingface_agent.md",
    ]

    domain_agents = [
        "api_agent.md",
        "ui_agent.md",
        "infrastructure_agent.md",
        "docs_agent.md",
        "scripts_agent.md",
    ]

    agents_dir = REPO_ROOT / ".agent" / "agents"

    for filename in provider_agents + domain_agents:
        contents = _read(agents_dir / filename)
        assert "PROMPT_TECHNIQUES_CATALOG.md" in contents

    sdlc_guide = _read(REPO_ROOT / "docs" / "ai" / "SDLC_AGENTS_GUIDE.md")
    assert "PROMPT_TECHNIQUES_CATALOG.md" in sdlc_guide


def test_context_management_playbook_is_linked_across_guides():
    playbook_path = REPO_ROOT / "docs" / "ai_capabilities" / "orchestration" / "CONTEXT_MANAGEMENT_PLAYBOOK.md"
    assert playbook_path.exists(), "Debe existir el playbook de gestión de contexto"

    playbook_contents = _read(playbook_path)
    assert "Context Management Playbook" in playbook_contents
    assert "TrimmingSession" in playbook_contents
    assert "SummarizingSession" in playbook_contents

    context_module = REPO_ROOT / "scripts" / "coding" / "ai" / "shared" / "context_sessions.py"
    assert context_module.exists(), "Falta el módulo reutilizable de sesiones de contexto"

    readme_root = _read(REPO_ROOT / "README.md")
    assert "CONTEXT_MANAGEMENT_PLAYBOOK" in readme_root

    docs_index = _read(REPO_ROOT / "docs" / "index.md")
    assert "CONTEXT_MANAGEMENT_PLAYBOOK" in docs_index

    prompting_index = _read(REPO_ROOT / "docs" / "ai_capabilities" / "prompting" / "README.md")
    assert "Context Management Playbook" in prompting_index

    agent_catalog = _read(REPO_ROOT / ".agent" / "agents" / "README.md")
    assert "CONTEXT_MANAGEMENT_PLAYBOOK" in agent_catalog

    agents_dir = REPO_ROOT / ".agent" / "agents"
    provider_agents = ["claude_agent.md", "chatgpt_agent.md", "huggingface_agent.md"]
    domain_agents = ["api_agent.md", "ui_agent.md", "infrastructure_agent.md", "docs_agent.md", "scripts_agent.md"]

    for filename in provider_agents + domain_agents:
        contents = _read(agents_dir / filename)
        assert "CONTEXT_MANAGEMENT_PLAYBOOK" in contents
        assert "context_sessions.py" in contents

    sdlc_guide = _read(REPO_ROOT / "docs" / "ai" / "SDLC_AGENTS_GUIDE.md")
    assert "CONTEXT_MANAGEMENT_PLAYBOOK" in sdlc_guide
    assert "context_sessions.py" in sdlc_guide


def test_meta_agente_codex_is_published_and_linked():
    meta_doc = REPO_ROOT / "docs" / "analisis" / "META_CODEX_PARTE_1.md"
    assert meta_doc.exists(), "Falta la Parte 1 del META-AGENTE CODEX en docs/analisis"

    meta_contents = _read(meta_doc)
    assert "META-AGENTE CODEX" in meta_contents
    assert "Parte 1 de 3" in meta_contents

    meta_doc_part2 = REPO_ROOT / "docs" / "analisis" / "META_AGENTE_CODEX_PARTE_2.md"
    assert meta_doc_part2.exists(), "Falta la Parte 2 del META-AGENTE CODEX en docs/analisis"

    meta_part2_contents = _read(meta_doc_part2)
    assert "META-AGENTE CODEX" in meta_part2_contents
    assert "Parte 2 de 3" in meta_part2_contents

    meta_doc_part3 = REPO_ROOT / "docs" / "analisis" / "META_AGENTE_CODEX_PARTE_3.md"
    assert meta_doc_part3.exists(), "Falta la Parte 3 del META-AGENTE CODEX en docs/analisis"

    meta_part3_contents = _read(meta_doc_part3)
    assert "META-AGENTE CODEX" in meta_part3_contents
    assert "PARTE 3 DE 3" in meta_part3_contents.upper()

    execplan_path = REPO_ROOT / "docs" / "plans" / "EXECPLAN_meta_agente_codex.md"
    assert execplan_path.exists(), "Debe existir el ExecPlan que gobierna el META-AGENTE CODEX"

    docs_index = _read(REPO_ROOT / "docs" / "index.md")
    assert "META_CODEX_PARTE_1" in docs_index
    assert "META_AGENTE_CODEX_PARTE_2" in docs_index
    assert "META_AGENTE_CODEX_PARTE_3" in docs_index

    root_readme = _read(REPO_ROOT / "README.md")
    assert "META-AGENTE CODEX" in root_readme

    agent_catalog = _read(REPO_ROOT / ".agent" / "agents" / "README.md")
    assert "META_CODEX_PARTE_1" in agent_catalog
    assert "META_AGENTE_CODEX_PARTE_2" in agent_catalog
    assert "META_AGENTE_CODEX_PARTE_3" in agent_catalog

    docs_agent = _read(REPO_ROOT / ".agent" / "agents" / "docs_agent.md")
    assert "META_CODEX_PARTE_1" in docs_agent
    assert "META_AGENTE_CODEX_PARTE_2" in docs_agent
    assert "EXECPLAN_meta_agente_codex.md" in docs_agent
    assert "META_AGENTE_CODEX_PARTE_3" in docs_agent

    providers = ["claude_agent.md", "chatgpt_agent.md", "huggingface_agent.md"]
    domains = ["api_agent.md", "ui_agent.md", "infrastructure_agent.md", "docs_agent.md", "scripts_agent.md"]
    agents_dir = REPO_ROOT / ".agent" / "agents"

    for filename in providers + domains:
        contents = _read(agents_dir / filename)
        assert "META_CODEX_PARTE_1" in contents
        assert "META_AGENTE_CODEX_PARTE_2" in contents
        assert "META_AGENTE_CODEX_PARTE_3" in contents

    execplan_contents = _read(execplan_path)
    assert "Parte 2 de 3" in execplan_contents
    assert "Parte 3 de 3" in execplan_contents

