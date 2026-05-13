```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: LangChain — Integración con LLMs
type: pattern
id: P-008
severity: MEDIO
origin: discover/patterns (legacy framework)
```

# LangChain Imports Correctos

Patrón para importar correctamente desde los módulos de LangChain después de la reorganización arquitectónica en v0.2+.

## Problema

LangChain reorganizó su arquitectura de paquetes en múltiples versiones, especialmente con la división entre `langchain-core` (abstracciones base), `langchain` (implementaciones de alto nivel) y paquetes de integración (`langchain-openai`, `langchain-anthropic`, etc.). Las importaciones incorrectas pueden causar:
- `ImportError`: módulo no exporta la clase
- `DeprecationWarning`: importación funciona pero obsoleta
- Runtime failures: acceso a atributos que no existen en el tipo incorrecto

### Anti-patrón

```python
# INCORRECTO — AP-18: importación desde módulo incorrecto
from langchain_core.tools import Tool  # ← NO existe en core

# AP-19: cadenas de LLM deprecadas (v0.2+)
from langchain.chains import LLMChain  # ← deprecado

# AP-20: callbacks deprecados
from langchain.callbacks import StdOutCallbackHandler  # ← movido en v0.2

# AP-21: memoria deprecada
from langchain.memory import ConversationBufferMemory  # ← API legacy
```

**Por qué falla:**
- `langchain_core.tools` no exporta `Tool` — esa clase vive en `langchain.tools`
- `LLMChain` fue reemplazado por LCEL (LangChain Expression Language)
- StdOutCallbackHandler se movió entre versiones
- ConversationBufferMemory fue reemplazada por RunnableWithMessageHistory

## Solución (el Patrón)

### Patrón correcto

```python
# CORRECTO — AP-18: importar Tool desde el paquete correcto
from langchain.tools import Tool  # ← Tool de alto nivel

# Para abstracciones base (cuando se subclasea):
from langchain_core.tools import BaseTool, StructuredTool

# AP-19: usar LCEL (LangChain Expression Language) en lugar de LLMChain
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_openai import ChatOpenAI

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant."),
    ("user", "{input}"),
])
model = ChatOpenAI(model="gpt-4")
output_parser = StrOutputParser()

# LCEL: encadena componentes con el operador |
chain = prompt | model | output_parser
# En lugar de: chain = LLMChain(prompt=prompt, llm=model)

# AP-20: callbacks actualizados
from langchain_core.callbacks import StdOutCallbackHandler  # ← en core
# O usar callbacks del paquete de integración correspondiente

# AP-21: memoria actualizada (LangChain v0.3+)
from langchain_core.chat_history import BaseChatMessageHistory
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory

# En v0.3+: usar RunnableWithMessageHistory para state management
history = ChatMessageHistory()
runnable_with_history = RunnableWithMessageHistory(
    runnable=chain,
    get_session_history=lambda session_id: history,
    input_messages_key="input",
)
```

**Por qué funciona:**
- `langchain-core` contiene interfaces y abstracciones puras (sin dependencias de terceros)
- `langchain` contiene implementaciones concretas que usan esas abstracciones
- LCEL (Expression Language) es la forma moderna de encadenar componentes
- Los paquetes de integración (`langchain-openai`, etc.) manejan provider-específico

## Implementación

### Tabla de importaciones correctas por versión

| Componente | v0.1.x | v0.2+ | v0.3+ |
|-----------|--------|-------|-------|
| **Tool** | `langchain.tools.Tool` | `langchain.tools.Tool` | `langchain.tools.Tool` |
| **BaseTool** | `langchain.tools.BaseTool` | `langchain_core.tools.BaseTool` | `langchain_core.tools.BaseTool` |
| **LLMChain** | `langchain.chains.LLMChain` | Deprecado → usar LCEL | Removido |
| **Prompts** | `langchain.prompts` | `langchain_core.prompts` | `langchain_core.prompts` |
| **Callbacks** | `langchain.callbacks` | `langchain_core.callbacks` | `langchain_core.callbacks` |
| **Memory** | `langchain.memory` | Parcialmente deprecado | `langchain_core.runnables.history` |

### Regla simple

1. **Abstracciones e interfaces:** siempre de `langchain_core`
2. **Implementaciones concretas:** de `langchain` o paquetes de integración
3. **Moderne (v0.2+):** usar LCEL (`prompt | model | parser`) en lugar de `LLMChain`
4. **Verificar versión:** `pip show langchain | grep Version`

## Cuándo Aplicar

- Al iniciar un proyecto con LangChain
- Al actualizar a v0.2+ o v0.3+
- Cuando recibas `ImportError` o `DeprecationWarning`
- Cuando necesites garantizar compatibilidad forward

## Alternativas Consideradas

- Pinar versión vieja de LangChain: no escalable, pierde features nuevas
- Ignorar deprecation warnings: funciona pero acumula deuda técnica
