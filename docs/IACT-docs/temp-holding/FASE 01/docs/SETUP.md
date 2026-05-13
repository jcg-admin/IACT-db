---
title: Setup Guide - IACT Project
date: 2025-11-13
domain: general
status: active
---

# Setup Guide - IACT Project

Guía rápida para configurar el proyecto después de clonar el repositorio.

---

## 1. Requisitos Previos

- Python 3.11+ instalado
- Git instalado
- (Opcional) Ollama para LLMs locales

---

## 2. Clonar el Repositorio

```bash
git clone <URL_DEL_REPO>
cd IACT---project
```

---

## 3. Crear Entorno Virtual

### Linux/Mac:
```bash
python3 -m venv venv
source venv/bin/activate
```

### Windows:
```bash
python -m venv venv
venv\Scripts\activate
```

---

## 4. Instalar Dependencias

```bash
pip install -r requirements.txt
```

Esto instalará:
- `anthropic` - Claude API
- `requests` - Para Ollama y APIs
- `pytest` - Testing
- `flake8`, `black`, `mypy` - Calidad de código
- Otras utilidades

---

## 5. Configurar API Keys

### 5.1 Copiar Template

```bash
cp .env.example .env
```

### 5.2 Editar .env

Abre `.env` y agrega tus API keys:

```bash
# Anthropic Claude (recomendado)
ANTHROPIC_API_KEY=sk-ant-api03-TU_KEY_AQUI

# OpenAI GPT (opcional)
# OPENAI_API_KEY=sk-TU_KEY_AQUI

# Ollama local (opcional)
OLLAMA_BASE_URL=http://localhost:11434

# Presupuesto mensual
LLM_MONTHLY_BUDGET=100

# Optimización de costos
ENABLE_COST_OPTIMIZATION=true

# Proveedor preferido: "auto", "anthropic", "openai", "ollama"
PREFER_LLM_PROVIDER=auto

# Entorno
ENVIRONMENT=development
```

### 5.3 Obtener API Keys

**Anthropic Claude:**
1. Ir a https://console.anthropic.com/
2. Crear cuenta o login
3. Settings → API Keys → Create Key
4. Copiar key y pegar en `.env`
5. **IMPORTANTE:** Agregar créditos/método de pago en Billing

**OpenAI (opcional):**
1. Ir a https://platform.openai.com/
2. API Keys → Create new secret key
3. Copiar key y pegar en `.env`

---

## 6. Verificar Configuración

```bash
# Verificar que .env se carga correctamente
python3 scripts/ai/shared/env_loader.py
```

Deberías ver:

```
======================================================================
VERIFICACION DE CONFIGURACION LLM
======================================================================

[OK] ANTHROPIC_API_KEY: sk-ant-api03-c4...tQAA
...
======================================================================
```

---

## 7. Ejecutar Tests

```bash
# Test simple de viabilidad
python3 test_case1_viabilidad.py

# Test de API de Claude
python3 test_claude_api.py

# Todos los casos de uso
bash run_all_use_cases.sh

# Tests unitarios
pytest tests/ai/
```

---

## 8. Opciones de LLM

### Opción A: Claude (Cloud, Pago)

**Pros:** Mejor calidad, rápido
**Cons:** Requiere créditos ($)

```bash
# En .env
ANTHROPIC_API_KEY=sk-ant-...
PREFER_LLM_PROVIDER=anthropic
```

### Opción B: Ollama (Local, Gratis)

**Pros:** Gratis, privado
**Cons:** Requiere hardware potente

```bash
# Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Iniciar servidor
ollama serve &

# Descargar modelo
ollama pull qwen2.5-coder:7b

# En .env
PREFER_LLM_PROVIDER=ollama
```

### Opción C: Solo Heurísticas (Sin LLM)

**Pros:** Gratis, instantáneo
**Cons:** Análisis más básico

```bash
# En .env
# Comentar o borrar ANTHROPIC_API_KEY
# ANTHROPIC_API_KEY=...

# El sistema detectará automáticamente y usará heurísticas
```

---

## 9. Estructura del Proyecto

```
IACT---project/
├── .env                    # TUS API keys (NO commitear)
├── .env.example            # Template de configuración
├── requirements.txt        # Dependencias Python
├── scripts/
│   └── ai/
│       ├── sdlc/          # Agentes SDLC
│       │   ├── feasibility_agent.py
│       │   ├── design_agent.py
│       │   ├── testing_agent.py
│       │   ├── deployment_agent.py
│       │   └── orchestrator.py
│       ├── generators/
│       │   └── llm_generator.py
│       └── shared/
│           ├── env_loader.py
│           └── llm_cost_optimizer.py
├── docs/
│   └── ai/
│       ├── SDLC_AGENTS_GUIDE.md
│       ├── CASOS_DE_USO_SDLC.md
│       ├── ESTRATEGIA_CREDITOS_LLM.md
│       └── CONFIGURACION_API_KEYS.md
├── examples/
│   ├── sdlc_pipeline_complete.py
│   ├── sdlc_feasibility_only.py
│   └── sdlc_compare_providers.py
└── tests/
    └── ai/
        └── sdlc/
```

---

## 10. Uso Rápido

### Análisis de Viabilidad

```python
from scripts.ai.shared.env_loader import get_llm_config_from_env
from scripts.ai.sdlc.feasibility_agent import SDLCFeasibilityAgent

# Config automática desde .env
config = get_llm_config_from_env()

agent = SDLCFeasibilityAgent(config=config)
result = agent.run({
    "issue": {
        "title": "Add dark mode",
        "description": "Toggle between light/dark themes",
        "requirements": ["Toggle button", "localStorage"],
        "estimated_story_points": 2
    }
})

print(f"Decision: {result['phase_result'].decision}")
print(f"Confidence: {result['phase_result'].confidence:.0%}")
```

### Pipeline Completo

```python
from scripts.ai.sdlc.orchestrator import SDLCOrchestratorAgent

orchestrator = SDLCOrchestratorAgent(config=config)
result = orchestrator.run({
    "feature_request": {
        "title": "Two-Factor Authentication",
        "requirements": ["TOTP", "QR codes", "Backup codes"],
        "estimated_story_points": 8
    }
})
```

---

## 11. Troubleshooting

### Error: "ANTHROPIC_API_KEY not found"

```bash
# Verificar que .env existe
ls -la .env

# Verificar contenido
cat .env | grep ANTHROPIC_API_KEY

# Recargar variables
python3 scripts/ai/shared/env_loader.py
```

### Error: "Model not found (404)"

Tu cuenta de Anthropic necesita créditos:
1. Ir a https://console.anthropic.com/settings/billing
2. Agregar método de pago
3. Agregar al menos $5 USD

### Error: "ModuleNotFoundError"

```bash
# Verificar que venv está activado
which python3

# Reinstalar dependencias
pip install -r requirements.txt
```

### LLM muy lento

Considera usar:
- Ollama local: más rápido que cloud para modelos pequeños
- Heurísticas: instantáneo para features simples

---

## 12. Documentación Completa

- **Guía de Agentes:** `docs/ai/SDLC_AGENTS_GUIDE.md`
- **Casos de Uso:** `docs/ai/CASOS_DE_USO_SDLC.md`
- **Estrategia de Costos:** `docs/ai/ESTRATEGIA_CREDITOS_LLM.md`
- **Configuración API Keys:** `docs/ai/CONFIGURACION_API_KEYS.md`

---

## 13. Próximos Pasos

1. Verificar que tests pasan: `pytest tests/ai/`
2. Ejecutar caso de uso 1: `python3 test_case1_viabilidad.py`
3. Revisar documentación en `docs/ai/`
4. Explorar ejemplos en `examples/`
5. Configurar optimización de costos (ver ESTRATEGIA_CREDITOS_LLM.md)

---

**Última actualización:** 2025-11-12
**Autor:** Sistema SDLC IACT
