---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: glossary
repo: claude-code-ultimate-guide
---

# Glosario: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Glosario completo de ~130 términos en core/glossary.md
**Descripción:** El repositorio mantiene un glosario alfabético comprehensivo con 4 columnas: Term, Definition, Category, Subcategory. Cubre términos específicos de Claude Code, patrones de comunidad y vocabulario de AI engineering. Excluye deliberadamente términos estándar de CS/DevOps.
**Fuente:** core/glossary.md:1-153
**Relevancia:** Alta

## Términos clave no cubiertos en referencias existentes del proyecto

### Términos de contexto y memoria
| Término | Definición |
|---------|-----------|
| **Context rot** | Degradación gradual de la situational awareness de Claude en sesiones largas a medida que el contexto relevante es desplazado o enterrado |
| **Context budget** | Asignación finita de tokens distribuida entre instrucciones, código, historial de conversación y tool results en una sesión |
| **Context triage** | Decisión deliberada sobre qué información vale la pena poner en contexto upfront vs. cargar on-demand via tools |
| **Context packing** | Codificación densa de información (markdown estructurado, símbolos, tablas) para maximizar señal útil por token |
| **ACE pipeline** | Assemble, Check, Execute — tres fases del lifecycle para gestión intencional de contexto |
| **Session handoff** | Iniciar nueva sesión pasando un documento de contexto resumido de una sesión agotada/degradada |
| **Fresh context pattern** | Iniciar una nueva sesión deliberadamente cuando el contexto acumulado es irrelevante o la calidad de output ha degradado |
| **150K ceiling** | Límite práctico de contexto efectivo donde la calidad de output degrada, aunque la ventana nominal sea mayor |

### Términos de workflow y patrones
| Término | Definición |
|---------|-----------|
| **Boris Cherny pattern** | Escalado horizontal: múltiples instancias Claude en paralelo, cada una en un git worktree, luego merge |
| **Dual-instance planning** | Jon Williams: una instancia crea plan detallado, otra instancia separada ejecuta — previene contaminación de contexto |
| **Ralph Loop** | Geoffrey Huntley: ciclo iterativo de refinamiento generate → review → correct → repeat hasta alcanzar la barra de calidad |
| **Gas Town** | Steve Yegge: workspace manager multi-agente con task queue compartido para múltiples instancias de Claude Code |
| **gstack** | Suite de 6 skills de Garry Tan: strategic gate + architecture review + code review + release notes + browser QA + retrospective |
| **Mechanic Stacking** | Patrón de capas múltiples: Plan Mode + Extended Thinking + MCP para máximo razonamiento en decisiones críticas |
| **Rev the Engine** | Múltiples rondas de análisis y planeamiento profundo antes de ejecutar para detectar edge cases y failure modes |
| **Annotation cycle** | Boris Tane: anotar un plan markdown personalizado con notas de implementación antes de que Claude ejecute |
| **Vibe coding** | Estilo de desarrollo donde se describe intent de alto nivel e itera rápidamente en el output de AI, priorizando velocidad |
| **Vibe Review** | Capa de verificación intermedia entre aceptación ciega y review línea por línea |

### Términos de seguridad
| Término | Definición |
|---------|-----------|
| **MCP Rug Pull** | MCP benigno que se vuelve malicioso después de ganar confianza; no requiere re-aprobación para actualizaciones |
| **Tool shadowing** | MCP malicioso registra tools con nombres que coinciden con built-ins para interceptar calls |
| **Supply chain attack** | Explotar dependencias confiables (MCP servers, plugins, community skills) para inyectar comportamiento malicioso |
| **Tool-qualified deny** | Patrón de permission que bloquea una herramienta basado en valores de argumentos, ej: `Read(file_path:*.env*)` |
| **Bypass Permissions Mode** | Máxima autonomía via `--dangerously-skip-permissions` — solo para entornos aislados/sandboxed |

### Términos de modelos y modos
| Término | Definición |
|---------|-----------|
| **OpusPlan** | Modo híbrido: Opus 4.6 maneja planning (con thinking), Sonnet ejecuta. Activa con `/model opusplan` |
| **SonnetPlan** | Remapping comunitario: Sonnet para planning, Haiku para ejecución. Más económico que OpusPlan |
| **Fast Mode** | Modo (v2.1.36+) 2.5x más rápido a 6x el costo de tokens. Toggle con `/fast` |
| **Adaptive thinking** | Feature de Opus 4.6: ajusta dinámicamente la profundidad de razonamiento según la complejidad detectada |
| **Extended thinking** | Feature que habilita reasoning más profundo via "thinking tokens" procesados antes de la respuesta visible |

### Términos de métricas y calidad
| Término | Definición |
|---------|-----------|
| **The 56% Reliability Warning** | Vercel engineering (Gao, 2026): agentes invocan skills on-demand solo el 56% del tiempo |
| **The 80% Problem** | Addy Osmani: AI maneja el 80% de una tarea; el 20% restante determina el éxito |
| **The 20% Rule** | Framework: patrones en >20% de sesiones → CLAUDE.md rules; 5-20% → skills; <5% → commands |
| **Comprehension debt** | Brecha entre código que produce AI y comprensión real del desarrollador |
| **Verification debt** | Riesgo acumulado de código AI-generado no revisado en el momento de creación |
| **Verification paradox** | Tensión entre necesitar verificación rigurosa y depender cada vez más de AI para verificar |
| **Artifact Paradox** | Anthropic 2026: usuarios que producen artefactos AI son menos propensos a cuestionar el razonamiento |

### Términos de ecosistema y herramientas
| Término | Definición |
|---------|-----------|
| **ccusage** | CLI comunitario para tracking de consumo de tokens y costos de Claude Code |
| **RTK (Rust Token Killer)** | CLI proxy que reduce consumo de tokens 60-90% filtrando outputs de comandos antes de que lleguen a Claude |
| **Desloppify** | Herramienta comunitaria que instala un skill de workflow y ejecuta scan→fix→score loop para elevar calidad |
| **multiclaude** | Self-hosted multi-agent spawner usando tmux + git worktrees |
| **Infisical** | Secrets manager open-source para inyectar credentials en sesiones de Claude Code sin almacenarlos en CLAUDE.md |
| **Packmind** | Herramienta que distribuye coding standards como CLAUDE.md files, slash commands y skills across repos |

## Conceptos clave

El glosario de ~130 términos en core/glossary.md es el vocabulario oficial de la comunidad Claude Code. Cubre desde conceptos técnicos del runtime hasta patrones nombrados por sus creadores (Boris Cherny pattern, Ralph Loop, Gas Town, gstack).

## Notas adicionales

El glosario distingue categorías: Architecture, AI Engineering, Claude Code, Models, Operations, Security, Methodology, Workflow, Ecosystem. Cada término tiene subcategoría (ej: AI Engineering/Context, Claude Code/Permissions, Security/Attack).

Términos con nombre de personas: Boris Cherny (creador de Claude Code, Head of Claude Code en Anthropic), Geoffrey Huntley (Ralph Loop), Steve Yegge (Gas Town), Garry Tan (gstack), Jon Williams (dual-instance planning), Damian Galarza (Linear-driven agent loop).
