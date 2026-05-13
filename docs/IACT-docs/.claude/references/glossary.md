```yml
type: Reference
title: Glossary — Términos Claude Code
category: Claude Code Platform — Referencia
version: 1.0
created_at: 2026-04-15
owner: thyrox (cross-phase)
purpose: Glosario alfabético de términos Claude Code — sintaxis, conceptos, patrones, modelos
```

# Glossary — Términos Claude Code

Referencia alfabética de términos que aparecen en la documentación de Claude Code: conceptos propios de la plataforma, patrones de la comunidad y vocabulario de AI engineering. Los términos estándar de CS/DevOps (JWT, CI/CD, REST) no están incluidos — buscarlos en otros recursos.

**Fuente:** `guide/core/glossary.md` (claude-code-ultimate-guide, ~130 términos)

---

## Tabla principal

| Término | Definición | Categoría |
|---------|-----------|-----------|
| `!` (shell prefix) | Prefijo para ejecutar comandos shell directamente sin intervención de Claude, e.g. `! git status`. El output aparece en la conversación. | Sintaxis |
| `@` (file reference) | Sintaxis para referenciar archivos específicos en prompts, e.g. `@src/auth.tsx`. Claude carga ese archivo al contexto inmediatamente. | Sintaxis |
| `.claude/` folder | Directorio a nivel de proyecto que contiene agents, skills, commands, hooks, rules y settings. `settings.local.json` se gitignora por convención. | Configuración |
| `.mcp.json` | Archivo a nivel de proyecto para configuración de servidores MCP, commiteado al repo para que todo el equipo comparta la misma configuración. | Configuración |
| `/clear` | Slash command que resetea la sesión completamente, descartando todo el historial de conversación. El contexto cae a 0%. | Comandos |
| `/compact` | Slash command que comprime el contexto de conversación resumiendo intercambios anteriores, liberando espacio sin perder estado. | Comandos |
| 150K ceiling | Límite efectivo práctico de contexto donde la calidad de output se degrada, incluso si la ventana nominal es mayor. Ver `./context-engineering.md`. | Arquitectura |
| ACE pipeline | Assemble, Check, Execute — el ciclo de tres fases para gestión intencional de contexto. Ver `./context-engineering.md`. | AI Engineering |
| Act Mode | Modo de ejecución normal donde Claude puede leer, escribir y ejecutar comandos. Opuesto a Plan Mode. | Modos |
| Adaptive thinking | Feature de Opus 4.6: ajusta dinámicamente la profundidad de razonamiento según la complejidad detectada de la tarea, sin configuración manual. | Modelos |
| Agent | Persona de AI especializada definida en un archivo markdown con rol, lista de herramientas e instrucciones de comportamiento. Se almacena en `.claude/agents/`. | Herramientas |
| Agent teams | Feature experimental (v2.1.32+) que habilita coordinación y mensajería multi-agente dentro de una sola sesión de Claude Code. | Multi-Agent |
| Agentic coding | Estilo de desarrollo donde agentes de AI realizan tareas multi-paso de forma autónoma con mínima intervención humana por paso. | Patrones |
| AI traceability | Prácticas para documentar y declarar la participación de AI en código, commits y contenido — git trailers, PR labels, audit logs. | Seguridad |
| allowedTools | Clave de settings para control granular de permisos de herramientas — permite o niega herramientas individuales o por patrón de argumento. | Configuración |
| Annotation cycle | Patrón de Boris Tane: anotar un plan markdown personalizado con notas de implementación antes de que Claude lo ejecute, creando una spec viva. | Patrones |
| Anti-hallucination protocol | Instrucciones explícitas que requieren que Claude verifique afirmaciones contra código o documentación real antes de declararlas como hecho. | Seguridad |
| Artifact Paradox | Hallazgo de investigación de Anthropic (AI Fluency Index, 2026): los usuarios que producen artefactos de AI tienen menos probabilidad de cuestionar el razonamiento detrás de ellos. | Investigación |
| Auto-accept Mode | Modo de permisos (`acceptEdits`) que auto-aprueba ediciones de archivos mientras sigue solicitando confirmación para comandos shell. Buen balance para sesiones de confianza. | Permisos |
| Auto-compaction | Mecanismo integrado que comprime automáticamente el contexto de conversación (~75% de umbral en extensiones VS Code, ~95% en CLI). Se activa silenciosamente a menos que se use `/compact` primero. | Arquitectura |
| Auto-memories | Feature (v2.1.32+) donde Claude almacena automáticamente el contexto aprendido del proyecto en un archivo de memoria persistente entre sesiones. | Herramientas |
| autoApproveTools | Array de settings que lista herramientas auto-aprobadas sin prompts interactivos. Más granular que los modos de permisos. | Configuración |
| awesome-claude-code | Lista curada por la comunidad de recursos, herramientas y ejemplos de Claude Code con 20K+ estrellas en GitHub. | Ecosistema |
| BMAD | Business-driven, Methodical AI Development — framework de planificación estructurada para proyectos de AI agentic (metodología de la comunidad). | Patrones |
| Boris Cherny pattern | Enfoque de escalado horizontal: ejecutar múltiples instancias de Claude Code en paralelo, cada una en un git worktree, luego hacer merge. Nombrado por Boris Cherny, creador de Claude Code y Head of Claude Code en Anthropic. | Patrones |
| Bypass Permissions Mode | Modo de máxima autonomía via `--dangerously-skip-permissions` — auto-aprueba todas las herramientas. Usar solo en entornos aislados/sandboxed. | Permisos |
| Capability Uplift | Tipo de skill que enseña a Claude una capacidad nueva que no tiene de forma nativa, a diferencia de reforzar una preferencia de estilo. | Herramientas |
| ccusage | CLI tool de la comunidad para rastrear consumo de tokens de Claude Code, costo por sesión y desglose por modelo. | Ecosistema |
| Chain of Verification (CoVe) | Patrón de verificador independiente: un segundo agente re-verifica el output del primero para prevenir sesgo de confirmación. arXiv:2309.11495. | Patrones |
| Checkpoint | Estado de sesión guardado que puede restaurarse via Esc×2 → /rewind. Se crea automáticamente antes de operaciones riesgosas. | Herramientas |
| Claude Haiku 4.5 | El modelo más rápido y económico de Anthropic. Ideal para tareas de alto volumen, búsquedas simples y workflows CI sensibles al costo. | Modelos |
| Claude Opus 4.6 | El modelo más capaz de Anthropic. Ideal para razonamiento profundo, decisiones de arquitectura y análisis multi-paso complejos. | Modelos |
| Claude Sonnet 4.6 | El modelo predeterminado y balanceado de Anthropic. Mejor mezcla de velocidad y capacidad para trabajo de desarrollo diario. | Modelos |
| CLAUDE.md | Archivo de memoria persistente cargado automáticamente al inicio de sesión. Contiene reglas del proyecto, convenciones y contexto. La base de la configuración de Claude Code. | Configuración |
| Co-Authored-By | Convención de git trailer (`Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>`) para atribuir commits con asistencia de AI. | Patrones |
| Comprehension debt | La brecha creciente entre el código que produce una AI y la comprensión real del desarrollador sobre qué hace y por qué. | Investigación |
| Config hierarchy | Precedencia de tres niveles para CLAUDE.md: Local (`.claude/`, gitignored) > Project (commiteado) > Global (`~/.claude/CLAUDE.md`). Lo más específico siempre gana. | Configuración |
| Constitutional AI | Framework de valores de Anthropic (según system prompt publicado) que define el orden de prioridad de Claude: seguridad > ética > principios Anthropic > utilidad del usuario. | AI Engineering |
| Context budget | La asignación finita de tokens que debe distribuirse entre instrucciones, código, historial de conversación y resultados de herramientas en una sesión. | AI Engineering |
| Context engineering | La disciplina de diseñar intencionalmente qué va en el context window de un modelo de AI para maximizar la calidad del output. Ver `./context-engineering.md`. | AI Engineering |
| Context maturity model | Framework que mide qué tan bien han evolucionado las prácticas de context engineering de un equipo, desde prompts ad-hoc hasta pipelines medidos. | AI Engineering |
| Context packing | Técnica de codificar información densamente (markdown estructurado, símbolos, tablas) para maximizar la señal útil por token. | AI Engineering |
| Context rot | La degradación gradual de la conciencia situacional de Claude en sesiones largas a medida que el contexto relevante queda fuera o enterrado. | AI Engineering |
| Context triage | La decisión deliberada sobre qué información vale la pena poner en contexto por adelantado vs. cargar bajo demanda via herramientas. | AI Engineering |
| Context window | Cantidad total de texto (en tokens) que Claude puede procesar en una sesión. Claude Sonnet 4.6: 200K; API extendida: 1M. | Modelos |
| Ctrl+B | Atajo de teclado para poner en segundo plano una tarea en ejecución, manteniéndola viva mientras se continúa otro trabajo en la sesión. | Herramientas |
| dangerouslyDisableSandbox | Flag que omite el sandboxing nativo de Claude Code a nivel OS. Solo debe usarse en entornos ya aislados. | Seguridad |
| Default Mode | Modo de permisos base que requiere aprobación explícita del usuario para todas las ediciones de archivos, comandos shell y commits. | Permisos |
| Desloppify | Tool de la comunidad (@peteromallet, Feb 2026) que instala un workflow skill en Claude Code y ejecuta un ciclo scan→fix→score para elevar la calidad del código. | Ecosistema |
| Diff review | La práctica de leer los cambios de archivo propuestos por Claude antes de aceptarlos o rechazarlos. Una de las Five Golden Rules. | Patrones |
| disallowedTools | Clave de settings que bloquea herramientas específicas de ser invocadas en una sesión o globalmente. | Configuración |
| Docker sandbox | Aislamiento basado en contenedores para ejecutar Claude Code con límites estrictos de recursos y filesystem. | Seguridad |
| Don't Ask Mode | Modo de permisos (`dontAsk`) que niega silenciosamente las herramientas que no están en la lista pre-aprobada, sin preguntar. | Permisos |
| Dual-instance planning | Patrón de Jon Williams: una instancia de Claude crea un plan detallado, una instancia separada lo ejecuta — evitando contaminación de contexto. | Patrones |
| Encoded Preference | Tipo de skill que refuerza convenciones, elecciones de estilo o restricciones específicas que Claude no aplicaría por defecto. | Herramientas |
| Enterprise AI governance | Políticas a nivel org para uso de herramientas de AI: usage charter, registro de servidores MCP, niveles de guardrail y audit trail. | Seguridad |
| Eval harness | Framework de testing para medir sistemáticamente el comportamiento de agentes, calidad de output y efectividad de skills contra criterios definidos. | Herramientas |
| Event-driven agents | Patrón donde eventos externos (tickets de Linear, PRs de GitHub, webhooks de Jira) disparan automáticamente workflows de agentes de Claude Code. | Patrones |
| Extended thinking | Feature del modelo que habilita razonamiento más profundo via "thinking tokens" procesados antes de la respuesta visible. Se activa con `--thinking`. | Modelos |
| Fast Mode | Modo (v2.1.36+) que corre 2.5x más rápido a 6x el costo de tokens, sobre el mismo modelo subyacente. Toggle con `/fast`. | Modos |
| FIRE framework | Find, Isolate, Remediate, Evaluate — metodología de troubleshooting DevOps/SRE para respuesta a incidentes con Claude Code. | Patrones |
| Fresh context pattern | Iniciar deliberadamente una nueva sesión cuando la actual ha acumulado contexto irrelevante o su calidad de output ha degradado. | Patrones |
| Gas Town | Workspace manager multi-agente de Steve Yegge para ejecutar múltiples instancias coordinadas de Claude Code con una cola de tareas compartida. | Ecosistema |
| Git worktree | Feature de git que crea directorios de trabajo paralelos desde el mismo repo. Usado en workflows multi-instancia de Claude Code sin cambiar de rama. | Herramientas |
| GSD (Get Shit Done) | Metodología de desarrollo pragmática y orientada a resultados: shipear rápido, validar con uso real, iterar basado en feedback. | Patrones |
| gstack | Suite de 6 skills de Garry Tan: strategic gate + architecture review + code review + release notes + browser QA + retrospectiva. | Ecosistema |
| Guardrail tiers | Cuatro niveles de cumplimiento de seguridad enterprise: Starter (awareness), Standard (review gates), Strict (approval flows), Regulated (full audit). | Seguridad |
| Hallucination | Cuando un modelo de AI genera información que suena plausible pero es incorrecta, a menudo con alta confianza aparente. | AI Engineering |
| Hook | Script de automatización disparado por eventos del ciclo de vida de Claude Code. Definido en `settings.json`. Corre sincrónicamente antes o después de la ejecución de herramientas. | Herramientas |
| Hook types | Cuatro tipos de ejecución: `command` (script shell), `http` (POST webhook), `prompt` (llamada LLM de un solo turno), `agent` (sub-agente multi-turno completo). | Herramientas |
| Infisical | Gestor de secrets open-source usado para inyectar credenciales en sesiones de Claude Code sin almacenarlas en CLAUDE.md o archivos de entorno. | Ecosistema |
| JSONL transcript | Historial de sesión almacenado como archivos JSON Lines en `~/.claude/projects/`. Se puede buscar, reproducir y analizar programáticamente. | Arquitectura |
| llms.txt | Formato de archivo estándar (colocado en la raíz del sitio) para documentación optimizada para AI. Claude Code lee archivos `llms.txt` desde las raíces de proyecto. | AI Engineering |
| Master loop | Ciclo de ejecución central de Claude Code: recibir input → seleccionar herramientas → ejecutar → observar resultados → responder. Se repite hasta completar la tarea. | Arquitectura |
| MCP (Model Context Protocol) | Protocolo abierto desarrollado por Anthropic para conectar modelos de AI a herramientas externas, bases de datos y APIs de forma estandarizada. | Arquitectura |
| Mechanic Stacking | Patrón de capas múltiples de mecanismos de Claude Code (Plan Mode + extended thinking + MCP) para máximo razonamiento en decisiones críticas. | Patrones |
| Memory hierarchy | Precedencia de tres niveles de CLAUDE.md: Local > Project > Global. Cada nivel extiende el inferior y puede sobreescribirlo para su propio scope. | Configuración |
| Model aliases | Nombres cortos que resuelven a versiones actuales de modelos: `default`, `sonnet`, `opus`, `haiku`, `sonnet[1m]`, `opusplan`. | Modelos |
| Modular context architecture | Patrón de dividir CLAUDE.md en módulos enfocados cargados dinámicamente via rules con scope de path, reduciendo el overhead de tokens por sesión. | AI Engineering |
| multiclaude | Spawner multi-agente self-hosted de la comunidad usando tmux + git worktrees. Ejecuta N instancias de Claude Code en paralelo. | Ecosistema |
| Native sandbox | Sandboxing integrado de Claude Code a nivel OS: Seatbelt en macOS, bubblewrap en Linux. Limita acceso a filesystem y red. | Seguridad |
| OpusPlan | Modo híbrido: Opus 4.6 maneja la planificación (con thinking), Sonnet ejecuta. Se activa con `/model opusplan`. | Modelos |
| Packmind | Tool que distribuye estándares de código como archivos `CLAUDE.md`, slash commands y skills a través de repositorios y herramientas de AI (Claude Code, Cursor, Copilot). | Ecosistema |
| Permission modes | Cinco niveles de autonomía: Default, Auto-accept, Plan, Don't Ask, Bypass Permissions. Se configuran por sesión o en `settings.json`. | Permisos |
| Plan Mode | Modo de solo lectura donde Claude puede analizar, buscar y proponer pero no puede modificar archivos. Se activa con Shift+Tab o `/plan`. | Modos |
| Plugin | Paquete distribuible que agrupa agents, skills, commands y hooks bajo un manifiesto `plugin.json`. Instalable desde el marketplace. | Herramientas |
| PostToolUse | Evento de hook disparado después de que una herramienta completa su ejecución. Usado para post-procesamiento, formateo, validación y logging. | Herramientas |
| PreToolUse | Evento de hook disparado antes de que Claude ejecute una herramienta. Puede bloquear, permitir o modificar la llamada a la herramienta según sus argumentos. | Herramientas |
| Prompt injection | Ataque donde texto malicioso en archivos o inputs externos intenta sobreescribir las instrucciones de Claude o exfiltrar información. | Seguridad |
| Ralph Loop | También "Ralph Wiggum Loop" (Geoffrey Huntley). Ciclo de refinamiento iterativo: generar → revisar → corregir → repetir, hasta que el output cumple el criterio de calidad. | Patrones |
| Recovery ladder | Tres niveles de deshacer: rechazar cambio inline, /rewind a checkpoint de sesión, `git restore` como reset nuclear. | Herramientas |
| Rev the Engine | Patrón de ejecutar múltiples rondas de análisis profundo y planificación antes de ejecutar, para detectar casos borde y modos de falla temprano. | Patrones |
| Rewind | Mecanismo de deshacer de Claude Code. Revierte cambios de archivos y/o estado de conversación a un checkpoint anterior. Trigger: Esc×2. | Herramientas |
| RTK (Rust Token Killer) | Proxy CLI que reduce el consumo de tokens 60-90% filtrando y comprimiendo el output de comandos antes de que llegue a Claude. | Ecosistema |
| Rules (`.claude/rules/`) | Archivos markdown cargados automáticamente que proveen instrucciones siempre activas. Cargados en cada inicio de sesión, independiente de qué skills estén activos. | Configuración |
| SE-CoVe | Software Engineering Chain-of-Verification — plugin de la comunidad que implementa CoVe con agentes de revisión independientes para validación automática de output. Basado en investigación de Meta (arXiv:2309.11495). | Ecosistema |
| Semantic anchors | Patrones de referencia nombrados en CLAUDE.md (e.g., `## Architecture`) que Claude encuentra y sigue confiablemente entre sesiones. | AI Engineering |
| Session | Una sola conversación de Claude Code con su propio context window, historial, checkpoints y estado de herramientas. | Herramientas |
| Session handoff | Iniciar manualmente una nueva sesión y pasar un documento de contexto resumido desde una sesión anterior agotada o degradada. | Patrones |
| SessionStart / SessionEnd | Eventos de hook disparados cuando una sesión comienza o se cierra. Usados para scripts de setup, logging y automatización de cleanup. | Herramientas |
| Shift+Tab | Atajo de teclado para alternar entre Plan Mode y Act Mode. | Herramientas |
| Skeleton project | Template de proyecto mínimo pero completamente funcional generado por Claude para establecer patrones de arquitectura antes de comenzar la implementación completa. | Patrones |
| Skill | Módulo de conocimiento reutilizable (carpeta + punto de entrada SKILL.md) que provee expertise de dominio o instrucciones de comportamiento bajo demanda. | Herramientas |
| Skill evals | Criterios de evaluación automatizados que miden la calidad de skills, confiabilidad de invocación y consistencia de output. Parte de Skills 2.0. | Herramientas |
| Skills 2.0 | Evolución del sistema de skills que introduce tipos Capability Uplift, tipos Encoded Preference, evals y gestión de ciclo de vida. | Herramientas |
| Slash command | Comandos personalizados definidos como archivos markdown en `.claude/commands/`, invocados con `/nombre-comando`. Soportan sustitución de `$ARGUMENTS`. | Herramientas |
| Slop | Contenido generado por AI no deseado y no revisado — el equivalente AI del spam. Término acuñado por Simon Willison en mayo 2024. | AI Engineering |
| SonnetPlan | Remapeo comunitario de OpusPlan: Sonnet maneja la planificación, Haiku maneja la ejecución. Más económico que OpusPlan para tareas más ligeras. | Modelos |
| Spec-first development | Patrón de Addy Osmani: escribir un documento de especificación detallado antes de que comience cualquier implementación. Reduce el scope creep y clarifica casos borde. | Patrones |
| Stop | Evento de hook disparado cuando Claude está a punto de dejar de responder. Usado para quality gates, tareas de cleanup y notificaciones de completado. | Herramientas |
| Strategic gate | Paso de revisión de producto pre-implementación en el workflow gstack. Asegura que la feature vale la pena construir antes de escribir cualquier código. | Patrones |
| Sub-agent | Una instancia hija de Claude generada por la sesión principal para manejar una tarea delegada en aislamiento, con su propio contexto. | Multi-Agent |
| Supply chain attack | Explotar dependencias de confianza (servidores MCP, plugins, skills de la comunidad) para inyectar comportamiento malicioso o exfiltrar datos. | Seguridad |
| Tasks API | Sistema integrado de gestión de tareas (v2.1.16+) con seguimiento de dependencias, gestión de estado y persistencia entre sesiones. Reemplaza a TodoWrite. | Herramientas |
| The 20% Rule | Framework de decisión: patrones en >20% de sesiones → reglas CLAUDE.md; 5-20% → skills; <5% → commands. | Patrones |
| The 56% Reliability Warning | Hallazgo del blog de ingeniería de Vercel (Gao, 2026): los agentes invocan skills bajo demanda solo el 56% del tiempo, recurriendo al conocimiento nativo en su lugar. | Investigación |
| The 80% Problem | Observación de Addy Osmani: la AI maneja confiablemente el 80% de una tarea; el 20% restante es donde la expertise y el juicio humano determinan el éxito. | Investigación |
| The Trinity | Patrón avanzado central que combina Plan Mode + Extended Thinking + MCP Secuencial para máxima profundidad de razonamiento en decisiones críticas. | Patrones |
| Thinking tokens | Tokens de razonamiento interno consumidos durante el extended thinking. No son visibles en la respuesta de Claude pero se cuentan contra el context budget. | Modelos |
| Token | La unidad básica de texto que los modelos de lenguaje procesan. Aproximadamente 3/4 de una palabra en inglés, o ~4 caracteres. 1K tokens ≈ 750 palabras. | Modelos |
| Token efficiency | Minimizar el consumo de tokens mientras se mantiene la calidad del output. Clave para gestión de costos, espacio de contexto y longevidad de sesión. | AI Engineering |
| Tool shadowing | Ataque donde un servidor MCP malicioso registra herramientas con nombres que coinciden con las herramientas integradas de Claude Code para interceptar o secuestrar llamadas. | Seguridad |
| Tool-qualified deny | Patrón de permisos que bloquea una herramienta basado en los valores de argumento, e.g., `Read(file_path:*.env*)` para prevenir lectura de archivos de secrets. | Seguridad |
| Trust calibration | Framework para hacer coincidir el esfuerzo de verificación con el nivel de riesgo real del código generado por AI — evitando tanto la aceptación ciega como la revisión paranoica. | AI Engineering |
| UserPromptSubmit | Evento de hook disparado cuando el usuario envía un prompt, antes de que Claude comience a procesar. Usado para enriquecimiento de prompts, logging y validación. | Herramientas |
| Verification debt | El riesgo acumulado de código generado por AI que no fue revisado en el momento de su creación, componiéndose a lo largo de sesiones sucesivas. | Investigación |
| Verification paradox | La tensión entre necesitar verificación rigurosa del código de AI mientras se depende cada vez más de herramientas de AI para realizar la verificación. | Investigación |
| Vertical slice | Tarea con scope en un comportamiento de usuario, cruzando todas las capas de arquitectura (UI → API → DB). Unidad preferida para implementación asistida por AI. | Patrones |
| Vibe coding | Estilo de desarrollo donde se describe la intención de alto nivel y se itera rápidamente sobre el output de AI, priorizando la velocidad de ship sobre la precisión. | Patrones |
| Vibe Review | Capa de verificación intermedia entre la aceptación ciega y la revisión línea por línea. Más rápida para cambios de bajo riesgo, igual detecta problemas obvios. | Patrones |
| Vitals | Plugin de la comunidad para detección de hotspots del codebase via un score combinado de git churn × complexity × centralidad de acoplamiento de módulo. | Ecosistema |
| WHAT/WHERE/HOW/VERIFY | Formato de prompt estructurado: qué hacer, dónde en el codebase, cómo abordarlo, cómo verificar el éxito. Reduce la ambigüedad en tareas agentic. | AI Engineering |

---

## Índice por categoría

### Sintaxis
`!` (shell prefix) · `@` (file reference)

### Comandos
`/clear` · `/compact` · `/fast` · `/plan` · `/model opusplan` · Shift+Tab · Ctrl+B

### Modos
Act Mode · Fast Mode · Plan Mode · OpusPlan · SonnetPlan

### Modelos
Adaptive thinking · Claude Haiku 4.5 · Claude Opus 4.6 · Claude Sonnet 4.6 · Context window · Extended thinking · Model aliases · Thinking tokens · Token

### Configuración
`.claude/` folder · `.mcp.json` · allowedTools · autoApproveTools · CLAUDE.md · Config hierarchy · disallowedTools · Memory hierarchy · Rules (`.claude/rules/`)

### Permisos
Auto-accept Mode · Bypass Permissions Mode · Default Mode · Don't Ask Mode · Permission modes · Tool-qualified deny

### Herramientas (extensibilidad)
Agent · Auto-memories · Capability Uplift · Checkpoint · Encoded Preference · Eval harness · Git worktree · Hook · Hook types · Plugin · PostToolUse · PreToolUse · Recovery ladder · Rewind · SessionStart/SessionEnd · Shift+Tab · Skill · Skill evals · Skills 2.0 · Slash command · Stop · Sub-agent · Tasks API · UserPromptSubmit

### Arquitectura
150K ceiling · ACE pipeline · Auto-compaction · JSONL transcript · Master loop · MCP (Model Context Protocol) · Native sandbox

### AI Engineering
Anti-hallucination protocol · Constitutional AI · Context budget · Context engineering · Context maturity model · Context packing · Context rot · Context triage · Hallucination · llms.txt · Modular context architecture · Semantic anchors · Slop · Token efficiency · Trust calibration · WHAT/WHERE/HOW/VERIFY

### Patrones
Annotation cycle · Boris Cherny pattern · BMAD · Co-Authored-By · Diff review · Dual-instance planning · Event-driven agents · FIRE framework · Fresh context pattern · GSD · gstack · Mechanic Stacking · Ralph Loop · Rev the Engine · Session handoff · Skeleton project · Spec-first development · Strategic gate · The 20% Rule · The Trinity · Vertical slice · Vibe coding · Vibe Review

### Seguridad
AI traceability · dangerouslyDisableSandbox · Docker sandbox · Enterprise AI governance · Guardrail tiers · Infisical · Native sandbox · Prompt injection · Supply chain attack · Tool shadowing · Tool-qualified deny

### Investigación
Artifact Paradox · Comprehension debt · The 56% Reliability Warning · The 80% Problem · Verification debt · Verification paradox

### Ecosistema
awesome-claude-code · ccusage · Desloppify · Gas Town · multiclaude · Packmind · RTK (Rust Token Killer) · SE-CoVe · Vitals

### Multi-Agent
Agent teams · Agentic coding · Boris Cherny pattern · Dual-instance planning · Sub-agent

---

*~130 términos. Fuente: `guide/core/glossary.md` (claude-code-ultimate-guide). Para el contexto completo de cada concepto ver los archivos de referencia en `./` — e.g., `./context-engineering.md`, `./permission-model.md`, `./hooks.md`, `./skill-authoring.md`.*
