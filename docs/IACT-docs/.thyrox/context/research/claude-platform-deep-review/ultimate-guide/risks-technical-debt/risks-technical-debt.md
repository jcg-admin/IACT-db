---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: risks-technical-debt
repo: claude-code-ultimate-guide
---

# Riesgos y Deuda Técnica: Hallazgos de claude-code-ultimate-guide

## Bugs activos conocidos

### Bug crítico 1 — Prompt Cache Bugs: inflación de costos silenciosa
**Descripción:** Tres bugs independientes rompen el prefix-based prompt caching de Anthropic. Bug 2 (ALTO IMPACTO): full cache rebuild en --resume/--continue (v2.1.69+). Bug 3: attribution header único por sesión causa cold miss en system prompt (~12K tokens). Bug 1: sentinel string replacement (solo standalone binary v2.1.36+). Impacto medido: 4.3-34.6% cache read ratio vs 95-99% en sesiones sanas. Parcialmente fixeado en v2.1.88.
**Fuente:** core/known-issues.md:18-136
**Relevancia:** Alta

**Workaround inmediato (Bug 3):**
```json
{ "env": { "CLAUDE_CODE_ATTRIBUTION_HEADER": "false" } }
```
**Workaround Bug 2:** Evitar `--resume` y `--continue` hasta fix. O downgrade a v2.1.68.

### Bug crítico 2 — GitHub Issue Auto-Creation en repositorio incorrecto
**Descripción:** Claude Code crea issues en el repositorio público `anthropics/claude-code` en lugar del repositorio del usuario. 17+ casos confirmados de exposición accidental de información sensible (database schemas, API credentials, arquitectura de infraestructura). Afecta v2.0.65+.
**Fuente:** core/known-issues.md:142-205
**Relevancia:** Alta

**Workaround:** Siempre especificar el repositorio explícitamente: `gh issue create --repo owner/my-repo`.

## CVEs y vulnerabilidades de seguridad

### CVE 1 — CVE-2025-53109/53110 (Alto): MCP filesystem sandbox escape
**Descripción:** Escape del sandbox del filesystem MCP via prefix bypass + symlinks. Afecta versiones anteriores a 0.6.3 / 2025.7.1. Actualizar inmediatamente.
**Fuente:** guide/security/security-hardening.md:56
**Relevancia:** Alta

### CVE 2 — CVE-2026-0755 (Crítico 9.8): RCE en gemini-mcp-tool
**Descripción:** Sin patch disponible. Args generados por LLM pasados a shell sin validación. Red-reachable sin autenticación. No usar en producción o redes expuestas.
**Fuente:** guide/security/security-hardening.md:66
**Relevancia:** Alta

### CVE 3 — CVE-2025-15061 (Crítico 9.8): RCE en Framelink Figma MCP
**Descripción:** El método `fetchWithRetry` pasa input sin sanitizar a shell. RCE no autenticado. Actualizar a la versión parcheada inmediatamente.
**Fuente:** guide/security/security-hardening.md:74
**Relevancia:** Alta

### CVE 4 — CVE-2026-25725 (Alto): Claude Code sandbox escape
**Descripción:** Código malicioso dentro del sandbox bubblewrap crea `.claude/settings.json` faltante con SessionStart hooks que ejecutan con privilegios del host al reiniciar. Fixeado en v2.1.34+.
**Fuente:** guide/security/security-hardening.md:68
**Relevancia:** Alta

### CVE 5 — ADVISORY-CC-2026-001 (Alto): Sandbox bypass por comandos excluidos
**Descripción:** Comandos excluidos del sandboxing bypassean el enforcement de permisos de Bash. Actualizar a v2.1.34+ inmediatamente.
**Fuente:** guide/security/security-hardening.md:65
**Relevancia:** Alta

## Patrones de ataque documentados

### Patrón 1 — MCP Rug Pull
**Descripción:** MCP benigno publicado → usuario lo añade y aprueba → funciona normalmente 2 semanas → atacante sube actualización maliciosa (no requiere re-aprobación) → exfiltra ~/.ssh/*, .env, credentials. Mitigation: version pinning + hash verification + monitoring.
**Fuente:** guide/security/security-hardening.md:36-50
**Relevancia:** Alta

### Patrón 2 — Prompt injection vía contenido de archivos
**Descripción:** Texto malicioso en archivos o inputs externos intenta ovveridear instrucciones de Claude o exfiltrar información. Difícil de detectar. Usar hooks PreToolUse que escaneen contenido antes de procesarlo.
**Fuente:** core/glossary.md:105 ("Prompt injection")
**Relevancia:** Alta

### Patrón 3 — Tool shadowing
**Descripción:** Un MCP server malicioso registra tools con nombres que coinciden con las built-in tools de Claude Code para interceptar o hijackear calls. Verificar namespaces de tools.
**Fuente:** core/glossary.md:138 ("Tool shadowing")
**Relevancia:** Alta

### Patrón 4 — Supply chain de skills
**Descripción:** Snyk ToxicSkills (Feb 2026): 36.82% de 3,984 skills escaneados tienen flaws de seguridad. 13.4% son critical risk. 10.9% en ClawHub tienen secrets hardcodeados. Usar `mcp-scan` y `skills-ref validate` antes de instalar.
**Fuente:** guide/security/security-hardening.md:152-168
**Relevancia:** Alta

## Riesgos de privacidad de datos

### Patrón 5 — Todo lo que lee Claude sale a servidores de Anthropic
**Descripción:** Prompts, archivos leídos (incluyendo .env si no está excluido), resultados de MCP (SQL queries, API responses), outputs de comandos bash, mensajes de error y stack traces — todo se envía a Anthropic via HTTPS/TLS. No está encriptado at-rest en servidores de Anthropic.
**Fuente:** guide/security/data-privacy.md:25-50
**Relevancia:** Alta

### Patrón 6 — Tiers de retención de datos
**Descripción:** Consumer (default): 5 años, usado para training. Consumer (opt-out): 30 días, no training. Team/Enterprise/API: 30 días, no training por defecto. ZDR (Zero Data Retention): 0 días server-side (requiere API keys configurados; necesario para HIPAA + BAA separado, GDPR, PCI-DSS).
**Fuente:** guide/security/data-privacy.md:68-99
**Relevancia:** Alta

### Patrón 7 — El comando /bug envía todo con retención de 5 años
**Descripción:** `/bug` envía el historial completo de conversación (incluyendo código, contenidos de archivos, potencialmente secrets) a Anthropic con retención de 5 años, independientemente de tus preferencias de training opt-out. Deshabilitar el comando en codebases sensibles.
**Fuente:** guide/security/data-privacy.md:144-150
**Relevancia:** Alta

## Riesgos conceptuales (deuda cognitiva)

### Patrón 8 — Comprehension debt
**Descripción:** La brecha creciente entre el código que produce AI y la comprensión real del desarrollador sobre qué hace y por qué. Se acumula silenciosamente. Solucionado parcialmente por práctica de "vibe review" y documentación de las decisiones.
**Fuente:** core/glossary.md:52 ("Comprehension debt")
**Relevancia:** Alta

### Patrón 9 — Verification paradox
**Descripción:** La tensión entre necesitar verificación rigurosa del código AI mientras se depende cada vez más de herramientas AI para realizar esa verificación. No hay solución completa; requiere disciplina procedimental.
**Fuente:** core/glossary.md:143 ("Verification paradox")
**Relevancia:** Media

## Conceptos clave

- Bugs de caché (conocidos, parcialmente fixeados): verificar versión y aplicar workarounds
- GitHub issue en repo incorrecto: always specify --repo explícitamente
- CVEs en MCPs de terceros: auditar antes de instalar, pinear versiones
- ZDR requerido para compliance real (HIPAA, GDPR, PCI-DSS)
- /bug command = 5 años de retención sin importar la configuración
- Comprehension debt es riesgo a largo plazo de adopción masiva de AI coding

## Notas adicionales

Herramientas de monitoreo de caché: `cc-diag` (mitmproxy-based), `claude-code-router` (transparent proxy con logging). Community patch: `cc-cache-fix`.

La limitación documentada de `permissions.deny`: bloquea Read/Edit/Write/Bash explícitos, pero `ls` puede exponer existencia de archivos. Los archivos .env pueden ser leídos via Bash si no se configura una deny rule explícita para eso también.

Los guardrail tiers empresariales documentados en enterprise-governance.md: Starter (awareness), Standard (review gates), Strict (approval flows), Regulated (full audit trail).
