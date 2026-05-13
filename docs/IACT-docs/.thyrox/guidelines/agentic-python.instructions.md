# Agentic Python — Guidelines
> Cargado automáticamente via @imports en CLAUDE.md.
> Fuente: AP-01..AP-42 descubiertos en ÉPICA 42 (análisis Cap.9-20) y calibración epistémica.
> 42 reglas / 14 secciones. Última actualización: 2026-04-20

---

## Sección 1: ADK Callbacks (AP-01, AP-02)

**AP-01 (CRÍTICO):** `before_model_callback` debe retornar el objeto modificado, no `None`

El framework usa el valor de retorno para obtener el objeto modificado. Retornar `None`
hace que el framework use el objeto original sin cambios.

```python
# INCORRECTO — framework ignora el objeto modificado
def before_model_callback(self, ctx, llm_request):
    llm_request.contents.append(new_content)
    return None  # framework usa el original, no este objeto

# CORRECTO — retornar el objeto modificado
def before_model_callback(self, ctx, llm_request):
    llm_request.contents.append(new_content)
    return llm_request
```

**AP-02 (ALTO):** `before_tool_callback` requiere `ToolContext`, no `CallbackContext`

El tipo de contexto inyectado en callbacks de herramienta es `ToolContext`. Usar
`CallbackContext` produce un error de tipo en runtime.

```python
# INCORRECTO
def before_tool_callback(self, ctx: CallbackContext, tool_call):
    ...

# CORRECTO
def before_tool_callback(self, ctx: ToolContext, tool_call):
    ...
```

---

## Sección 2: Type Contracts (AP-03..AP-06)

**AP-03 (ALTO):** Función declara `-> list` pero retorna `dict` en rama de excepción

```python
# INCORRECTO
def get_items(self) -> list:
    try:
        return self._items
    except Exception as e:
        return {"error": str(e)}  # rompe el contrato -> list

# CORRECTO
def get_items(self) -> list:
    try:
        return self._items
    except Exception as e:
        return []  # mantiene el contrato -> list
```

**AP-04 (MEDIO):** Función declara `-> str` pero retorna `tuple` en alguna rama.
Asegurar que todas las ramas de retorno cumplan el tipo declarado en la firma.

**AP-05 (ALTO):** `types.Content(role="system")` usa un rol inválido en el protocolo ADK

```python
# INCORRECTO
contents = [types.Content(role="system", parts=[...])]

# CORRECTO — usar system_instruction a nivel de configuración del modelo
model_config = types.GenerateContentConfig(
    system_instruction="...",
)
```

**AP-06 (MEDIO):** `code_executor=[BuiltInCodeExecutor]` pasa la clase en vez de una instancia

```python
# INCORRECTO
agent = Agent(code_executor=[BuiltInCodeExecutor])

# CORRECTO — instanciar antes de pasar
agent = Agent(code_executor=[BuiltInCodeExecutor()])
```

---

## Sección 3: Classifier Temperature (AP-07, AP-08)

**AP-07 (ALTO):** `temperature=1` para clasificadores produce routing no-determinístico

```python
# INCORRECTO — temperature alta en clasificadores
classifier = LlmAgent(
    model="gemini-2.0-flash",
    temperature=1,  # routing varía entre invocaciones idénticas
)

# CORRECTO — temperatura cero para determinismo en clasificación
classifier = LlmAgent(
    model="gemini-2.0-flash",
    temperature=0,
)
```

**AP-08 (ALTO):** `temperature=0.5` para routing introduce variabilidad no intencional

```python
# INCORRECTO
router = LlmAgent(temperature=0.5)

# CORRECTO
router = LlmAgent(temperature=0)
```

Todo agente cuya función sea clasificar, enrutar o tomar decisiones binarias/categóricas
debe usar `temperature=0`. Reservar `temperature > 0` solo para generación creativa.

---

## Sección 4: Error Handling (AP-09..AP-12)

**AP-09 (ALTO):** `json.loads(llm_output)` sin try/except produce crash en output no-JSON

```python
# INCORRECTO
result = json.loads(llm_output)

# CORRECTO
try:
    result = json.loads(llm_output)
except json.JSONDecodeError as e:
    logger.error("LLM returned non-JSON output: %s", e)
    result = {}
```

**AP-10 (MEDIO):** `output.pydantic` accedido sin verificar None produce falla silenciosa

```python
# INCORRECTO
data = response.output.pydantic.field

# CORRECTO
if response.output and response.output.pydantic:
    data = response.output.pydantic.field
else:
    data = default_value
```

**AP-11 (MEDIO):** Llamadas HTTP sin `response.raise_for_status()` en path alternativo

Asegurar que todos los paths de código que realizan llamadas HTTP llaman a
`response.raise_for_status()` para que los errores 4xx/5xx se propaguen explícitamente.

**AP-12 (ALTO):** `json.loads` sin strip de markdown fencing falla en output con bloques de código

```python
# INCORRECTO — falla si LLM envuelve JSON en ```json ... ```
result = json.loads(llm_output)

# CORRECTO — limpiar fencing antes de parsear
import re
clean = re.sub(r"^```(?:json)?\s*|\s*```$", "", llm_output.strip())
result = json.loads(clean)
```

---

## Sección 5: Observability (AP-13..AP-15)

**AP-13 (ALTO):** `level=logging.ERROR` en configuración del logger silencia INFO y WARNING

```python
# INCORRECTO — oculta mensajes operacionales
logging.basicConfig(level=logging.ERROR)

# CORRECTO — nivel apropiado para producción
logging.basicConfig(level=logging.INFO)
```

**AP-14 (MEDIO):** `print("DEBUG: ...")` en código de producción — usar el logger estructurado

```python
# INCORRECTO
print("DEBUG: response =", response)

# CORRECTO
logger.debug("response = %s", response)
```

**AP-15 (MEDIO):** `InMemoryArtifactService` usado en producción sin disclaimer explícito

```python
# CORRECTO — marcar explícitamente como solo para desarrollo
artifact_service = InMemoryArtifactService()  # DEV ONLY — no persiste entre reinicios
```

Todo uso de `InMemoryArtifactService` en código no-test debe incluir el comentario
`# DEV ONLY` para evitar que llegue a producción sin advertencia.

---

## Sección 6: HITL Patterns (AP-16, AP-17)

**AP-16 (CRÍTICO):** `escalate_to_human()` retorna `{"status": "success"}` sin loop de espera real

Una función que declara escalada a humano pero retorna éxito inmediatamente es HITL
decorativo. No hay pausa real ni mecanismo de reanudación.

```python
# INCORRECTO — HITL decorativo: retorna éxito sin esperar al humano
def escalate_to_human(task_id: str) -> dict:
    send_notification(task_id)
    return {"status": "success"}  # humano aún no respondió

# CORRECTO — interrumpir ejecución y registrar estado pendiente
def escalate_to_human(task_id: str) -> dict:
    send_notification(task_id)
    store_pending_review(task_id)
    raise HumanInterruptRequired(task_id=task_id)
    # la reanudación ocurre desde el endpoint de callback externo
```

**AP-17 (CRÍTICO):** `flag_for_review()` sin mecanismo de interrupt/resume — HITL decorativo

Cualquier función que "marca para revisión" pero permite que el agente continúe
ejecutando inmediatamente no implementa HITL real. Requisitos mínimos:

1. Persistir el estado de la tarea como `PENDING_HUMAN_REVIEW`
2. Interrumpir el flujo del agente (no continuar con el siguiente paso)
3. Exponer un endpoint o mecanismo para que el humano reanude con su decisión

```python
# CORRECTO — estructura mínima de HITL real
async def flag_for_review(self, task: Task) -> None:
    await self.state_store.set(task.id, TaskState.PENDING_HUMAN_REVIEW)
    raise HumanReviewRequired(task_id=task.id)

# En el handler de reanudación (endpoint externo)
async def resume_after_review(self, task_id: str, decision: HumanDecision) -> None:
    task = await self.state_store.get(task_id)
    await self.continue_execution(task, decision)
```

---

## Sección 7: Imports (AP-18..AP-22)

**AP-18 (CRÍTICO):** `from langchain_core.tools import Tool` produce ImportError

```python
# INCORRECTO — langchain_core no exporta Tool en este path
from langchain_core.tools import Tool

# CORRECTO
from langchain.tools import Tool
```

**AP-19 (ALTO):** `from langchain.memory import ConversationBufferMemory` — deprecado en LangChain ≥0.3

```python
# INCORRECTO — deprecado
from langchain.memory import ConversationBufferMemory

# CORRECTO — usar LangChain Expression Language (LCEL) con RunnableWithMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory
```

**AP-20 (ALTO):** `from langchain_community.embeddings import OpenAIEmbeddings` — deprecado

```python
# INCORRECTO — deprecado en langchain_community
from langchain_community.embeddings import OpenAIEmbeddings

# CORRECTO — paquete dedicado
from langchain_openai import OpenAIEmbeddings
```

**AP-21 (ALTO):** `from langchain_community.vectorstores import Weaviate` — deprecado

```python
# INCORRECTO — deprecado en langchain_community
from langchain_community.vectorstores import Weaviate

# CORRECTO — paquete dedicado
from langchain_weaviate import WeaviateVectorStore
```

**AP-22 (MEDIO):** `datetime.now()` en f-string dentro del constructor del agente se evalúa
una sola vez al instanciar, no en cada invocación. Las instrucciones del sistema con
fecha/hora dinámica deben generarse en el método de invocación, no en `__init__`.

```python
# INCORRECTO — fecha fijada al momento de instanciar
class MyAgent:
    def __init__(self):
        self.instruction = f"Current date: {datetime.now()}"  # nunca se actualiza

# CORRECTO — fecha evaluada en cada invocación
class MyAgent:
    def get_instruction(self) -> str:
        return f"Current date: {datetime.now()}"
```

---

## Sección 8: Agentic Design (AP-23..AP-30)

**AP-23 (ALTO):** `ConversationBufferMemory` compartido entre sesiones produce contaminación cross-invocation

```python
# INCORRECTO — memoria compartida a nivel de clase/módulo
shared_memory = ConversationBufferMemory()

class MyAgent:
    def run(self, input: str):
        return self.chain.run(input, memory=shared_memory)

# CORRECTO — memoria con scope de sesión
class MyAgent:
    def run(self, session_id: str, input: str):
        memory = get_or_create_session_memory(session_id)
        return self.chain.run(input, memory=memory)
```

**AP-24 (MEDIO):** A2A naming inconsistency — usar solo la forma del protocolo A2A

Mezclar `sendTask` (camelCase RPC) con `tasks/send` (path HTTP) en el mismo codebase
crea ambigüedad. Adoptar una sola convención y aplicarla consistentemente en toda
la capa de comunicación A2A.

**AP-25 (SISTÉMICO):** Named Mechanism — el nombre del mecanismo no debe sustituir a su implementación

Un patrón nombrado (e.g., "adaptive memory", "dynamic re-prioritization") debe tener
una implementación verificable que corresponda al nombre. Señales de alerta:

- El nombre aparece en docstrings pero no en el código
- La "implementación" es una variable o log sin lógica real
- El mecanismo no tiene tests que verifiquen el comportamiento descrito

**AP-26 (ALTO):** Counter sin lock en sistema concurrente produce race condition

```python
# INCORRECTO — race condition en asyncio concurrente
class TaskManager:
    def __init__(self):
        self.next_task_id = 0

    async def create_task(self) -> str:
        self.next_task_id += 1  # no es atómico
        return f"task-{self.next_task_id}"

# CORRECTO — proteger con asyncio.Lock()
class TaskManager:
    def __init__(self):
        self.next_task_id = 0
        self._lock = asyncio.Lock()

    async def create_task(self) -> str:
        async with self._lock:
            self.next_task_id += 1
            return f"task-{self.next_task_id}"
```

**AP-27 (ALTO):** "Dynamic re-prioritization" declarado sin campo `deadline` ni algoritmo de re-ranking

Si un agente anuncia re-priorización dinámica de tareas, debe existir:
1. Un campo `deadline` (o equivalente) en el modelo de tarea
2. Un algoritmo explícito de re-ranking (e.g., EDF, weighted scoring)
3. Un trigger que lo invoque cuando cambien las condiciones

Sin estos tres elementos, la re-priorización es declarativa, no real.

**AP-28 (ALTO):** `http://` URL en AgentCard con claim de mTLS — usar `https://`

```python
# INCORRECTO — mTLS requiere TLS; http:// no usa TLS
agent_card = AgentCard(
    url="http://agent.internal:8080",  # claim de mTLS es falso sin https
)

# CORRECTO
agent_card = AgentCard(
    url="https://agent.internal:8080",
)
```

**AP-29 (MEDIO):** Token vacío en Authorization header — validar antes de enviar

```python
# INCORRECTO — envía "Bearer " con token vacío
headers = {"Authorization": f"Bearer {self.token}"}

# CORRECTO — validar token antes de construir el header
if not self.token:
    raise AuthenticationError("Token is required but not configured")
headers = {"Authorization": f"Bearer {self.token}"}
```

**AP-30 (SISTÉMICO):** Referencias sin inline citations no elevan calibración epistémica

Una lista de referencias al final de un documento o respuesta no es suficiente para
verificar claims individuales. Cada afirmación técnica verificable debe ir acompañada
de su citation inline. Sin citation inline:

- No es posible verificar si la referencia realmente respalda el claim
- El lector no sabe qué parte de la referencia aplica
- La calibración epistémica del documento es baja, independientemente de la calidad de las fuentes

---

## Sección 9: Contrato de Herramienta (AP-31, AP-32)

**AP-31 (ALTO):** Tool Description Mismatch — descripción no corresponde al comportamiento real

```python
# INCORRECTO — descripción no corresponde al comportamiento real
@tool(description="Analyzes sentiment and returns positive/negative/neutral")
def analyze_text(text: str) -> dict:
    return {"word_count": len(text.split())}  # retorna word count, no sentiment

# CORRECTO — descripción coincide con implementación
@tool(description="Counts words in text and returns count as integer")
def analyze_text(text: str) -> dict:
    return {"word_count": len(text.split())}
```

**AP-32 (ALTO):** Architectural Shell Without Behavioral Core — clase nombrada como sistema complejo sin lógica real

```python
# INCORRECTO — clase nombrada como sistema complejo pero sin lógica real
class MultiAgentOrchestrator:
    def route(self, task): return "agent_a"  # routing siempre igual, no es "multi"

# CORRECTO — nombre refleja la implementación real, o implementar el comportamiento
class SimpleRouter:
    def route(self, task): return "agent_a"
```

---

## Sección 10: Guardrails (AP-33, AP-34)

**AP-33 (CRÍTICO):** LLM-as-guardrail Prompt Injection — usar LLM para verificar outputs de otro LLM con mismo sistema de instrucciones

```python
# INCORRECTO — usar LLM para verificar outputs de otro LLM con mismo sistema de instrucciones
safety_check = llm.invoke(f"Is this safe? {user_output}")  # injectable

# CORRECTO — usar reglas determinísticas o modelo separado con sistema aislado
def is_safe(text: str) -> bool:
    return not any(pattern in text.lower() for pattern in BLOCKED_PATTERNS)
```

**AP-34 (MEDIO):** Regulated Domain Caveat — agente en dominio regulado (médico, legal) sin disclaimer ni escalada obligatoria

```python
# INCORRECTO — agente médico/legal sin disclaimer, sin escalada obligatoria
def medical_advice(symptom: str) -> str:
    return llm.invoke(f"What should I do for {symptom}?")

# CORRECTO — disclaimer explícito + escalada a profesional
def medical_guidance(symptom: str) -> str:
    response = llm.invoke(f"General health info about {symptom}")
    return f"NOTA: Esto es información general, no consejo médico. Consulta un profesional. {response}"
```

---

## Sección 11: Flujo de Ejecución (AP-35, AP-36)

**AP-35 (ALTO):** Silent Loop Termination — loop termina sin señal observable

```python
# INCORRECTO — loop termina sin señal observable
for step in steps:
    result = agent.run(step)
    if result.done: break  # sin log, sin callback

# CORRECTO — loop con señal observable en terminación
for step in steps:
    result = agent.run(step)
    if result.done:
        logger.info(f"Loop terminado en step {step}: {result.reason}")
        break
```

**AP-36 (MEDIO):** Borrowed Nomenclature — usar término técnico del dominio sin implementar la semántica

```python
# INCORRECTO — usar término técnico del dominio sin implementar la semántica
class ReinforcementLearningAgent:
    def act(self, state): return random.choice(self.actions)  # no hay RL

# CORRECTO — nombre descriptivo de la implementación real
class RandomActionAgent:
    def act(self, state): return random.choice(self.actions)
```

---

## Sección 12: Protocolo MCP / A2A (AP-37, AP-38, AP-39)

**AP-37 (CRÍTICO):** MCP JSON-RPC Payload Mismatch — payload no sigue esquema JSON-RPC 2.0

```python
# INCORRECTO — payload no sigue esquema JSON-RPC 2.0
{"tool": "search", "query": "python"}  # falta jsonrpc, id, method

# CORRECTO — payload JSON-RPC 2.0 completo
{
    "jsonrpc": "2.0",
    "id": "req-001",
    "method": "tools/call",
    "params": {"name": "search", "arguments": {"query": "python"}}
}
```

**AP-38 (ALTO):** Hardcoded Identifier — ID de sesión, agente o recurso hardcodeado en lugar de obtenido de configuración

```python
# INCORRECTO — ID de sesión, agente o recurso hardcodeado
agent = AgentClient(agent_id="prod-agent-001")  # cambiará en producción

# CORRECTO — ID obtenido de configuración o entorno
agent = AgentClient(agent_id=os.environ["AGENT_ID"])
```

**AP-39 (ALTO):** Advertencia Desconectada — warning emitido pero el código continúa como si no hubiera problema

```python
# INCORRECTO — warning emitido pero el código continúa como si no hubiera problema
logger.warning("API key not found, using fallback")
api_key = "hardcoded-fallback-key"  # el warning no cambia nada

# CORRECTO — warning conectado a comportamiento diferente
if not api_key:
    logger.warning("API key not found — operando en modo read-only")
    return self._read_only_response(request)
```

---

## Sección 13: Calibración Epistémica (AP-40, AP-41)

**AP-40 (ALTO):** Cherry-Pick Consciente — seleccionar solo casos que confirman el resultado esperado

```python
# INCORRECTO — seleccionar solo casos que confirman el resultado esperado
success_cases = [r for r in results if r.success]  # denominador ocultado
accuracy = len(success_cases) / len(success_cases)  # siempre 100%

# CORRECTO — reportar sobre el denominador completo
accuracy = len([r for r in results if r.success]) / len(results)
logger.info(f"Accuracy: {accuracy:.2%} ({len(results)} total cases)")
```

**AP-41 (MEDIO):** Efecto Denominador — reportar métricas de éxito sin declarar el denominador total

```python
# INCORRECTO — fracción sin declarar denominador
logger.info("15 successful executions")  # ¿de cuántos?

# CORRECTO — siempre declarar denominador
logger.info(f"15/{total} executions succeeded ({15/total:.0%})")
```

---

## Sección 14: Scoring Cuantitativo Verificable — CAD (AP-42)

**AP-42 (ALTO):** Scoring cuantitativo verificable (CAD — Calibración Asincrónica por Dominio)

**Problema:** Scores cuantitativos sin aritmética visible son performativos — no verificables.

**Reglas:**
- Mostrar fórmula y valores de entrada para cada score calculado
- No cambiar el criterio de scoring entre dominios del mismo análisis sin declararlo
- Cuando rango(scores por dominio) > 0.35 → reportar CAD, no solo score global
- Claims de dominio con score < 0.50 no pueden fundamentar gates de stage

**Anti-patrón (AP-42A):** `score_global = promedio(dominios)` sin reportar distribución

```python
# INCORRECTO — score global sin distribución (AP-42A)
report = {"score": 0.72}  # oculta que técnico=0.91, casos_uso=0.43

# CORRECTO — distribución explícita con detección CAD
scores = {"tecnico": 0.91, "casos_uso": 0.43}
rango = max(scores.values()) - min(scores.values())  # 0.48
score_global = sum(scores.values()) / len(scores)    # 0.67
cad_detectado = rango > 0.35
report = {
    "score_global": score_global,
    "distribucion": scores,
    "rango": rango,
    "cad": cad_detectado,  # True — reportar por dominio
}
# output: score_global=0.67 [dist: tecnico=0.91, casos_uso=0.43, rango=0.48 → CAD detectado]
```
