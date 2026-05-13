```yml
type: Reference
title: Known Issues — Bugs Conocidos y Workarounds
category: Claude Code Platform — Reliability
version: 1.0
created_at: 2026-04-15
owner: thyrox (cross-phase)
purpose: Bugs conocidos y activos de Claude Code con workarounds verificados
```

# Known Issues

Bugs verificados y activos en Claude Code, con causas, workarounds y estado actual.
Para errores de streaming (timeouts, StopFailure, context limits), ver
[streaming-errors.md](streaming-errors.md).

Fuente principal: `known-issues.md` del claude-code-ultimate-guide (actualizado Apr 1, 2026).
GitHub Issues tracker: https://github.com/anthropics/claude-code/issues

---

## Tabla de estado — bugs activos

| Bug | Versiones afectadas | Tiene fix oficial | Workaround disponible | Impacto |
|-----|--------------------|--------------------|----------------------|---------|
| Bug 2 — Cache rebuild en --resume | v2.1.69+ | No (activo en v2.1.88) | Si — evitar --resume | ALTO: 10-20x costo por turno |
| Bug 3 — Attribution header | v2.1.69+ | No (activo en v2.1.88) | Si — env var inmediata | MEDIO: cold miss en system prompt |
| Bug 1 — Sentinel string `cch=00000` | standalone binary v2.1.36+ | No | Si — no pegar string literal | BAJO: edge case puntual |
| GitHub issue en repo incorrecto | v2.0.65+ | No (activo en v2.1.88) | Si — especificar --repo siempre | CRITICO: fuga de datos privados |
| Consumo excesivo de tokens | v2.1.1+ (reportado) | No confirmado como bug | Parcial — sesiones cortas | ALTO: rate limits prematuros |

---

## Bug 0 — Prompt Cache: tres bugs de inflacion silenciosa de costos

**Severidad:** ALTA — impacto directo en costo
**Estado:** PARCIALMENTE FIXED — Bug 1 parcialmente mitigado en v2.1.88; Bugs 2 y 3 sin fix
**Versiones afectadas:** v2.1.69+ (Bugs 2 y 3), standalone binary v2.1.36+ (Bug 1)
**GitHub Issue:** [#40524](https://github.com/anthropics/claude-code/issues/40524) (abierto desde marzo 2026)
**Issues relacionados:** [#40652](https://github.com/anthropics/claude-code/issues/40652) · [#41663](https://github.com/anthropics/claude-code/issues/41663) · [#41607](https://github.com/anthropics/claude-code/issues/41607) · [#41767](https://github.com/anthropics/claude-code/issues/41767) · [#41750](https://github.com/anthropics/claude-code/issues/41750)

Fuente: `known-issues.md:18-138`

### Problema general

Tres bugs independientes rompen el prefix-based prompt caching de Anthropic, causando
cargos `cache_creation` (costo completo de tokens) donde deberian ocurrir `cache_read`
(costo descontado). El impacto combinado medido: 48% → 99.98% de mejora en cache hit ratio
al aplicar los workarounds.

> Base: reverse-engineering comunitario (CC#40524), analisis de sourcemap npm, analisis
> de session JSONL independiente (ArkNill, abril 2026).

### Bug 2 — Full cache rebuild en --resume / --continue (HIGH IMPACT)

**Causa raiz:** El JSONL writer de sesion elimina los registros `deferred_tools_delta`
antes de escribir a disco. Al hacer `--resume`, esos registros no existen — la capa de
deferred tools no tiene historial de anuncios previos y re-anuncia todos los tools desde
cero. Esto desplaza cada posicion de mensaje en la conversacion restaurada, rompiendo el
cache prefix de nivel messages completamente.

**Evidencia concreta** (sesiones con 14 skills, analisis de JSONL comunitario):

| Entry | cache_read | cache_creation | Evento |
|-------|-----------|----------------|--------|
| 102 | 84,164 | 174 | Turno normal |
| 103 | 0 | 87,176 | **Resume — rebuild completo** |
| 105 | 87,176 | 561 | Recuperado |
| 166 | 115,989 | 221 | Turno normal |
| 167 | 0 | 118,523 | **Resume — rebuild completo** |

Cada resume = 87-118K tokens reconstruidos como `cache_creation` en lugar de `cache_read`.
3-4 resumes por sesion = 300-400K tokens de costo evitable. El impacto escala con el numero
de skills/deferred tools: usuarios con 10+ skills (comun en setups con frameworks) ven 0%
de cache ratio en cada resume.

**Workaround:**
- Evitar `--resume` y `--continue` hasta que llegue un fix
- Iniciar sesiones frescas en lugar de retomar
- Downgrade si es critico: `npm install -g @anthropic-ai/claude-code@2.1.68` (ultima version antes de la regresion)

**Fix de ingenieria necesario:** preservar registros `deferred_tools_delta` y
`mcp_instructions_delta` al escribir session JSONL, para que resume pueda calcular el delta
correctamente en lugar de re-anunciar todo.

Tracking interno de Anthropic referenciado en telemetria de source como `inc-4747`.

### Bug 3 — Attribution header (MEDIUM IMPACT)

**Causa raiz:** Claude Code inyecta un billing header como el **primer bloque** del system
prompt en cada request a la API. Este header contiene un hash de 3 caracteres derivado de
los primeros caracteres del primer mensaje de usuario, haciendolo unico por sesion, por
subagente y por side query. Como el cache de Anthropic es prefix-based, este primer bloque
unico causa un cold miss en el system prompt de ~12K tokens en cada inicio de sesion y
llamada a subagente.

**Nuance:** el cold miss por sesion tiene "impacto marginal" en practica porque el system
prompt es pequeno relativo al contexto total. El Bug 2 (resume) tiene mayor impacto
medible para usuarios intensivos.

**Workaround (aplicar de inmediato — bajo riesgo):**

```json
// ~/.claude/settings.json
{
  "env": {
    "CLAUDE_CODE_ATTRIBUTION_HEADER": "false"
  }
}
```

Valores aceptados: `"false"`, `"0"`, `"no"`, `"off"`. No requiere reinicio.

### Bug 1 — Sentinel string replacement (LOW IMPACT — edge case)

**Causa raiz:** El stack HTTP nativo de Bun reemplaza el placeholder `cch=00000` en el
request body despues de la serializacion. Si este string exacto aparece en el contenido
de tu mensaje (ej: en un CLAUDE.md que discuta este bug), puede ser reemplazado en el
lugar incorrecto.

**Versiones afectadas:** solo el standalone binary (v2.1.36+). No afecta instalaciones
npm/npx.

**Workaround:** No pegar `cch=00000` literalmente en CLAUDE.md ni en archivos de config.

### Monitorear la salud del cache

**Metodo 1 — Proxy local transparente:**

```json
// ~/.claude/settings.json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:8080"
  }
}
```

Correr un proxy pass-through en puerto 8080 que lea (sin modificar) requests/responses,
parseando el objeto `usage` de cada response. Ratios de referencia:

- Sesion sana: cache read ratio > 80%
- Sesion afectada: cache read ratio < 40%

**Metodo 2 — Inspeccion directa de JSONL:**

Inspeccionar archivos de sesion en `~/.claude/projects/` — buscar
`cache_creation_input_tokens` y `cache_read_input_tokens` por turno.

**Herramientas comunitarias:**
- [`cc-diag`](https://github.com/nicobailey/cc-diag) — analisis de trafico via mitmproxy
- [`claude-code-router`](https://github.com/pathintegral-institute/claude-code-router) — proxy transparente con logging
- [`cc-cache-fix`](https://github.com/Rangizingo/cc-cache-fix) — patch comunitario + test toolkit (aplica fixes de Bug 1 y Bug 2)

**Comando de auditoria rapida:** `/check-cache-bugs` — auditoria de los 3 bugs en ~20 segundos.
Ejecutar al inicio de una sesion fresca o como one-shot:

```bash
claude -p "$(cat .claude/commands/check-cache-bugs.md)"
```

> Usar one-shot evita contaminar el contexto de la sesion actual con strings `cch=`
> (potencial trigger del Bug 1).

---

## Bug 1-GitHub — Issue creado en repositorio incorrecto

**Severidad:** CRITICA — riesgo de privacidad y seguridad
**Estado:** ACTIVO (sin fix al 28 ene 2026)
**Versiones afectadas:** v2.0.65+
**GitHub Issue:** [#13797](https://github.com/anthropics/claude-code/issues/13797) (abierto desde dic 12, 2025)

Fuente: `known-issues.md:142-226`

### Problema

Claude Code crea GitHub issues en el repositorio publico `anthropics/claude-code` en lugar
del repositorio privado del usuario, incluso cuando se trabaja dentro de un directorio git
local.

### Impacto

Al menos **17+ casos confirmados** de usuarios exponiendo informacion sensible en el
repositorio publico:

- Schemas de base de datos
- Credenciales de API y detalles de configuracion
- Arquitectura de infraestructura
- Roadmaps privados de proyectos
- Configuraciones de seguridad

### Sintomas

- Issue creado con flag inesperado `--repo anthropics/claude-code`
- Detalles del proyecto privado aparecen en issues publicos de anthropics/claude-code
- Sin prompt de confirmacion antes de crear el issue en el repositorio publico
- Ocurre al pedir a Claude "crear un issue" mientras se esta en un repo git local

### Causa raiz (hipotesis)

Claude Code puede confundir:
- Feedback legitimo sobre Claude Code mismo → `anthropics/claude-code` (correcto)
- Issues del proyecto del usuario → repositorio actual (deberia ser el default)

El tool parece hardcodear o priorizar excesivamente `anthropics/claude-code` como target.

### Workarounds — APLICAR SIEMPRE

**Antes de crear cualquier GitHub issue via Claude Code:**

1. Verificar el repositorio objetivo:
   ```bash
   git remote -v
   ```

2. Especificar el repositorio explicitamente:
   ```bash
   gh issue create --repo TU_USUARIO/TU_REPO --title "..." --body "..."
   ```

3. Revisar el comando antes de ejecutarlo — abortar si aparece `--repo anthropics/claude-code`
   y no era la intencion.

4. Usar aprobacion manual para todos los comandos `gh` en los settings de Claude.

5. No incluir informacion sensible en prompts de creacion de issues hasta que el bug sea corregido.

### Si ya fuiste afectado

1. Contactar GitHub Support de inmediato para solicitar eliminacion del issue (no solo cerrarlo)
2. Rotar todas las credenciales expuestas (API keys, passwords, tokens)
3. Reportar a Anthropic en [security@anthropic.com](mailto:security@anthropic.com) si hay informacion de seguridad
4. Monitorear el uso de la informacion expuesta

---

## Bug 2-Tokens — Consumo excesivo de tokens

**Severidad:** ALTA — impacto en costo y rate limits
**Estado:** REPORTADO — Anthropic investigando; no confirmado oficialmente como bug
**Versiones afectadas:** v2.1.1+ (reportado; puede afectar versiones anteriores)
**GitHub Issue:** [#16856](https://github.com/anthropics/claude-code/issues/16856) (reportado ene 8, 2026)

Fuente: `known-issues.md:229-316`

### Problema

Multiples usuarios reportan consumo de tokens **4x o mas rapido** que en versiones anteriores:
- Rate limits alcanzados mucho antes de lo normal
- Los mismos workflows consumen significativamente mas tokens
- Aumentos inesperados de costos

Reportes tipicos:
- Limites semanales agotados en 1-2 dias (vs 5-7 dias normal)
- Sesiones alcanzando 90% de contexto tras 2-3 mensajes
- Consumo 4x-20x para operaciones identicas

### Contexto importante

En diciembre 25-31, 2025, Anthropic duplico los limites de uso como regalo de navidad.
Al volver a normal el 1 de enero de 2026, algunos usuarios percibieron "capacidad reducida".
Sin embargo, los reportes persisten mas alla de esa fecha, sugiriendo un posible problema subyacente.

Respuesta oficial de Anthropic (The Register, ene 5, 2026):
> "Anthropic stated it 'takes all such reports seriously but hasn't identified any flaw
> related to token usage' and indicated it had ruled out bugs in its inference stack."

### Workarounds mientras se investiga

1. **Monitorear uso activamente:**
   ```
   /context
   ```
   Revisar tokens usados vs capacidad regularmente.

2. **Sesiones mas cortas:** reiniciar al alcanzar 50-60% de contexto; dividir tareas complejas.

3. **Deshabilitar auto-compact** (puede ayudar):
   ```bash
   claude config set autoCompaction false
   ```

4. **Reducir MCP tools no necesarios:** revisar `~/.claude.json` (campo `"mcpServers"`) y
   deshabilitar servidores no usados.

5. **Usar subagentes para tareas aisladas:** cada subagente tiene su propia context window.

6. **Documentar patrones:** comparar consumo antes/despues de upgrades; registrar picos inusuales.

### Si experimentas consumo excesivo

Para contribuir a la investigacion:
1. Anotar la version: `claude --version`
2. Comparar con version anterior estable si esta disponible
3. Documentar: que operaciones disparan el alto consumo
4. Reportar con datos: version, tipo de operacion, conteos de tokens

---

## Historico resuelto — Model Quality Degradation (ago-sep 2025)

**Severidad:** CRITICA
**Estado:** RESUELTO (mid-septiembre 2025)
**Timeline:** agosto 25 - principios de septiembre 2025

Fuente: `known-issues.md:320-358`

### Que ocurrio

Usuarios reportaron Claude Code produciendo outputs peores que versiones anteriores, errores
de sintaxis inesperados, inserciones de caracteres inesperados (texto Thai/Chino en respuestas
en ingles), fallos en tareas basicas, y ediciones de codigo incorrectas.

### Causa raiz real (tres bugs de infraestructura)

1. **Traffic Misrouting:** ~30% de requests de Claude Code enrutados al tipo de servidor incorrecto
2. **Output Corruption:** misconfiguracion deployada el 25 ago causo errores en generacion de tokens
3. **XLA:TPU Miscompilation:** optimizacion de performance disparo un bug latente del compilador
   afectando la seleccion de tokens

### Resolucion

Postmortem oficial de Anthropic: [A postmortem of three recent issues](https://www.anthropic.com/engineering/a-postmortem-of-three-recent-issues) (17 sep 2025)

> "We never reduce model quality due to demand, time of day, or server load. The problems
> our users reported were due to infrastructure bugs alone."

Todos los bugs resueltos a mid-septiembre 2025.

---

## Nota — Varianza de performance dia a dia (comportamiento esperado, no bug)

Fuente: `known-issues.md:362-413`

La calidad del output de Claude puede variar de sesion en sesion incluso con prompts identicos
y contexto limpio. Esto es **comportamiento esperado** por inferencia probabilistica, routing
MoE, y varianza de infraestructura — no un bug a reportar.

Senales observables: respuestas mas cortas, rehusas en edge cases que normalmente funcionan,
estilo de codigo mas o menos verboso. Ninguna de estas es una degradacion permanente.

El incidente de ago-sep 2025 fue la excepcion: degradacion sistematica confirmada por Anthropic
con bugs de infraestructura reales. La varianza normal entre sesiones es algo distinto.

---

## Como rastrear issues activos

```bash
# Issues con mas reacciones (prioridad comunitaria)
gh issue list --repo anthropics/claude-code --state open --sort reactions-+1 --limit 20

# Bugs criticos recientes
gh search issues --repo anthropics/claude-code "bug" "critical" --sort created --order desc --limit 10
```

Busquedas rapidas por tema:
- Token consumption: https://github.com/anthropics/claude-code/issues?q=is%3Aissue+excessive+token
- Wrong repo: https://github.com/anthropics/claude-code/issues?q=is%3Aissue+%22wrong+repo%22
- Model quality: https://github.com/anthropics/claude-code/issues?q=is%3Aissue+quality+degradation

Canales oficiales:
- GitHub Issues: https://github.com/anthropics/claude-code/issues
- Anthropic Status: https://status.anthropic.com/
- Engineering Blog: https://www.anthropic.com/engineering
