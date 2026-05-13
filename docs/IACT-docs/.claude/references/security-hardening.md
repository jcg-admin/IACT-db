```yml
type: Reference
title: Security Hardening — Amenazas, CVEs y Configuración Defensiva
category: Claude Code Platform — Seguridad
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Amenazas activas, CVEs, patrones de ataque MCP, configuración defensiva y privacidad de datos
```

# Security Hardening

Guia de seguridad para Claude Code: amenazas activas, CVEs, patrones de ataque MCP, configuracion defensiva y privacidad de datos.

Fuente principal: `security-hardening.md`, `data-privacy.md`, `sandbox-isolation.md` del claude-code-ultimate-guide.

---

## 1. CVE Tracker — 2025-2026

| CVE | Severity | Impacto | Mitigacion | Patch |
|-----|----------|---------|------------|-------|
| **CVE-2025-53109/53110** | High | Filesystem MCP sandbox escape via prefix bypass + symlinks | Actualizar a >= 0.6.3 / 2025.7.1 | Si |
| **CVE-2025-54135** | High (8.6) | RCE en Cursor via prompt injection reescribiendo mcp.json | File integrity monitoring hook | Si |
| **CVE-2025-54136** | High | Backdoor de equipo persistente via config tampering post-aprobacion | Git hooks + hash verification | Si |
| **CVE-2025-49596** | Critical (9.4) | RCE en MCP Inspector tool | Actualizar a version parchada | Si |
| **CVE-2026-24052** | High | SSRF via bypass de validacion de dominio en WebFetch | Actualizar a v1.0.111+ | Si |
| **CVE-2025-66032** | High | 8 bypasses de ejecucion de comandos via fallas en blocklist | Actualizar a v1.0.93+ | Si |
| **ADVISORY-CC-2026-001** | High | Sandbox bypass — comandos excluidos del sandboxing bypasean permisos Bash | **Actualizar a v2.1.34+** | Si |
| **CVE-2026-25725** | High | Sandbox escape — codigo malicioso crea `.claude/settings.json` con SessionStart hooks que ejecutan con privilegios del host en restart | Actualizar a >= v2.1.2 (cubierto por v2.1.34+) | Si |
| **CVE-2026-0755** | **Critical (9.8)** | RCE en gemini-mcp-tool — args generados por LLM pasados a shell sin validacion; sin auth, accesible por red | **Sin fix** — no usar en produccion ni redes expuestas | No |
| **SNYK-PYTHON-MCPRUNPYTHON-15250607** | High | SSRF en mcp-run-python — sandbox Deno permite acceso a localhost, habilitando pivoting a red interna | Restringir permisos de red del sandbox; bloquear rango localhost | Parcial |
| **CVE-2026-25253** | High (8.8) | OpenClaw 1-click RCE — link malicioso abre WebSocket a servidor atacante, exfiltrando auth token; 17,500+ instancias expuestas | Actualizar OpenClaw a >= 2026.1.29; bloquear exposicion a internet | Si |
| **CVE-2026-0757** | High | MCP Manager sandbox escape via command injection en execute-command con objetos MCP config sin sanitizar | Restringir a configs confiables | Pendiente |
| **CVE-2025-35028** | **Critical (9.1)** | HexStrike AI MCP Server — arg prefijado con `;` ejecuta OS commands; tipicamente como root; sin auth | **Sin fix** — no exponer a inputs/redes no confiables | No |
| **CVE-2025-15061** | **Critical (9.8)** | Framelink Figma MCP Server — fetchWithRetry ejecuta metacaracteres shell controlados por atacante; RCE sin autenticacion | Actualizar a latest | Si |
| **CVE-2026-3484** | Medium (6.5) | nmap-mcp-server — command injection en handler Nmap CLI via `child_process.exec`; explotable remotamente | Aplicar patch commit `30a6b9e` | Si |

**CVEs sin patch activos (evitar en produccion):** CVE-2026-0755, CVE-2025-35028.

**Version minima segura de Claude Code:** v2.1.34+ (cubre ADVISORY-CC-2026-001 + CVE-2026-25725).

Fuente: `security-hardening.md:57-85`

---

## 2. Patrones de Ataque MCP

### 2.1 Rug Pull

```
1. Atacante publica MCP benigno "code-formatter"
               |
2. Usuario agrega a ~/.claude.json, aprueba una vez
               |
3. MCP funciona normalmente 2 semanas (construye confianza)
               |
4. Atacante empuja update malicioso (sin re-aprobacion)
               |
5. MCP exfiltra ~/.ssh/*, .env, credentials
```

**Por que funciona:** El modelo de aprobacion es one-time. Una vez aprobado, los updates del MCP se ejecutan automaticamente sin re-consentimiento.

**Mitigacion:** Version pinning + hash verification + monitoring de cambios.

### 2.2 Tool Poisoning

Instrucciones maliciosas embebidas en el metadata del tool (descriptions, schemas) influyen al LLM antes de la ejecucion. El atacante no necesita comprometer el servidor — solo el contenido que Claude lee.

**Deteccion:** Schema diff monitoring entre versiones.

### 2.3 Confused Deputy

El atacante registra un tool con nombre de confianza en un servidor no confiable. Claude asocia el nombre con el servidor confiable previo y ejecuta sin verificar el origen real.

**Mitigacion:** Namespace verification — verificar que el servidor que expone el tool es el mismo que fue auditado.

Fuente: `security-hardening.md:87-93`

---

## 3. Checklist de Auditoria MCP (5 minutos)

Antes de agregar cualquier MCP server, completar estos pasos:

| Paso | Comando / Accion | Criterio de Aprobacion |
|------|-----------------|----------------------|
| **1. Fuente** | `gh repo view <mcp-repo>` | Stars >50, commits <30 dias |
| **2. Permisos** | Revisar config `mcp.json` | Sin flags `--dangerous-*` |
| **3. Version** | Verificar string de version | Pinned exacto (no "latest" o "main") |
| **4. Hash** | `sha256sum <mcp-binary>` | Coincide con checksum del release |
| **5. Commits** | Revisar commits recientes | Sin cambios sospechosos |

**Lista de MCPs evaluados por la comunidad:**

| MCP Server | Estado | Notas |
|------------|--------|-------|
| `@anthropic/mcp-server-*` | Seguro | Servidores oficiales Anthropic |
| `context7` | Seguro | Solo lectura, lookup de documentacion |
| `sequential-thinking` | Seguro | Sin acceso externo, razonamiento local |
| `memory` | Seguro | Persistencia en archivo local |
| `filesystem` (sin restricciones) | Riesgo | CVE-2025-53109/53110 — usar con cuidado |
| `database` (credenciales prod) | Inseguro | Riesgo de exfiltracion — usar read-only |
| `browser` (acceso completo) | Riesgo | Puede navegar a sitios maliciosos |
| `mcp-scan` (Snyk) | Herramienta | Escaneo de supply chain para skills/MCPs |

Fuente: `security-hardening.md:96-120`

---

## 4. Supply Chain de Skills

### Datos Snyk ToxicSkills (Feb 2026)

Escaneo de **3,984 skills** en ClawHub y skills.sh:

| Hallazgo | Estadistica | Impacto |
|---------|-------------|---------|
| Skills con fallas de seguridad | **36.82%** (1,467/3,984) | Mas de 1 de cada 3 |
| Skills de riesgo critico | **534** (13.4%) | Malware, prompt injection, secrets expuestos |
| Payloads maliciosos identificados | **76** | Robo de credenciales, backdoors, exfiltracion |
| Secrets hardcodeados (ClawHub) | **10.9%** | API keys y tokens en el codigo del skill |
| Ejecucion remota de prompts | **2.9%** | Skills que fetchean y ejecutan contenido remoto dinamicamente |

Fuente: Snyk ToxicSkills — `security-hardening.md:153-165`

### Como escanear

```bash
# Escanear un directorio de skill con mcp-scan (Snyk)
npx mcp-scan ./skill-directory

# Validar cumplimiento de spec con skills-ref
skills-ref validate ./skill-directory
```

### Mitigaciones antes de instalar un skill

1. Ejecutar `mcp-scan` — 90-100% recall en skills maliciosos confirmados, 0% falsos positivos en top-100 legitimos
2. Revisar `SKILL.md` — verificar `allowed-tools` (especialmente permisos de `Bash`)
3. Auditar `scripts/` — los scripts ejecutables son el componente de mayor riesgo
4. Pinear version — usar commit hashes especificos al instalar desde GitHub

Fuente: `security-hardening.md:166-180`

---

## 5. permissions.deny — Que bloquea y que no

### Que bloquea

| Operacion | Bloqueado | Notas |
|-----------|-----------|-------|
| Llamadas `Read()` | Si | Mecanismo primario de bloqueo |
| Llamadas `Edit()` | Si | Con regla deny explicita |
| Llamadas `Write()` | Si | Con regla deny explicita |
| `Bash(cat .env)` | Si | Con regla deny explicita |
| Patrones `Glob()` | Si | Manejados por reglas Read |
| `ls .env*` (nombres) | Parcial | Expone existencia del archivo, no contenido |

### Gaps documentados (lo que NO bloquea)

| Gap | Descripcion | Fuente |
|-----|-------------|--------|
| **System reminders** | El indexing en background puede exponer contenido via mecanismo interno "system reminder" antes de los checks de permisos de herramienta | GitHub #4160 |
| **Bash wildcards** | Comandos bash genericos sin regla deny explicita pueden acceder archivos | Security research |
| **Indexing timing** | El file watching opera en una capa por debajo de los permisos de herramienta | GitHub #4160 |

### Configuracion recomendada

Bloquear **todos** los vectores de acceso, no solo `Read`:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env*)",
      "Edit(./.env*)",
      "Write(./.env*)",
      "Bash(cat .env*)",
      "Bash(head .env*)",
      "Bash(tail .env*)",
      "Bash(grep .env*)",
      "Read(./secrets/**)",
      "Read(./**/credentials*)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Read(./**/service-account*.json)"
    ]
  }
}
```

### Protecciones integradas (sin configuracion)

| Proteccion | Comportamiento |
|------------|---------------|
| **Command blocklist** | `curl` y `wget` bloqueados por defecto en sandbox para prevenir fetch de contenido web arbitrario |
| **Fail-closed matching** | Cualquier regla que no matchea requiere aprobacion manual por defecto |
| **Command injection detection** | Comandos bash sospechosos requieren aprobacion manual aunque esten en allowlist |

### Estrategia de defensa en profundidad

`permissions.deny` es necesario pero no suficiente. Combinarlo con:

1. Guardar secrets fuera del directorio del proyecto — usar `~/.secrets/` o vault externo
2. Usar gestion externa de secrets — AWS Secrets Manager, 1Password, HashiCorp Vault
3. Agregar hooks `PreToolUse` como capa secundaria de bloqueo
4. Nunca commitear secrets — incluso archivos "bloqueados" pueden filtrarse por otros vectores

Fuente: `security-hardening.md:183-250`

---

## 6. Auditoria de Repos con .claude/ Embebido

Repositorios de terceros pueden incluir una carpeta `.claude/` con agentes, comandos y hooks pre-configurados. Al abrir el repo en Claude Code, esta configuracion se carga automaticamente — un vector de supply chain que bypasea los marketplaces de skills.

### Vectores de ataque

| Vector | Mecanismo | Riesgo |
|--------|-----------|--------|
| **Agentes maliciosos** | `allowed-tools: ["Bash"]` + instrucciones de exfiltracion en system prompt | Ejecuta comandos arbitrarios con permisos amplios |
| **Comandos maliciosos** | Instrucciones ocultas en template de prompt, argumentos inyectados | Corren con todos los permisos Claude Code del usuario |
| **Hooks maliciosos** | Scripts bash en `.claude/hooks/` disparados en cada tool call | Exfiltracion de datos en cada evento `PreToolUse`/`PostToolUse` |
| **CLAUDE.md envenenado** | Instrucciones que anulan settings de seguridad o deshabilitan validacion | El LLM sigue instrucciones del repo como contexto de proyecto |
| **settings.json troyanizado** | Reglas `permissions.allow` muy permisivas, hooks deshabilitados | Debilita postura de seguridad silenciosamente |

### Checklist de auditoria (antes de abrir un repo desconocido)

| Paso | Que verificar | Red Flags |
|------|--------------|-----------|
| **1. Existencia** | `ls -la .claude/` | `.claude/` inesperado en un proyecto no-Claude |
| **2. Hooks** | `cat .claude/hooks/*.sh` | `curl`, `wget`, llamadas de red, encoding base64 |
| **3. Agents** | `cat .claude/agents/*.md` | `allowed-tools: ["Bash"]` con descripciones vagas |
| **4. Commands** | `cat .claude/commands/*.md` | Instrucciones ocultas despues del contenido visible |
| **5. Settings** | `cat .claude/settings.json` | Reglas `permissions.allow` excesivamente permisivas |
| **6. CLAUDE.md** | `cat .claude/CLAUDE.md` | Instrucciones para deshabilitar seguridad, saltear reviews |

```bash
# Scan rapido de patrones sospechosos en .claude/
grep -r "curl\|wget\|nc \|base64\|eval\|exec" .claude/ 2>/dev/null
grep -r "allowed-tools.*Bash" .claude/agents/ 2>/dev/null
grep -r "permissions.allow" .claude/ 2>/dev/null
```

**Regla:** Revisar `.claude/` en un repo desconocido con el mismo escrutinio que `package.json` scripts o `.github/workflows/`.

Fuente: `security-hardening.md:253-323`

---

## 7. Retencion de Datos

> Todo lo que se comparte con Claude Code se envia a servidores de Anthropic. Los datos viajan via HTTPS/TLS pero **no estan cifrados en reposo** en servidores de Anthropic.

### Tiers de retencion

| Configuracion | Periodo de Retencion | Usado para training | Como activar |
|--------------|---------------------|---------------------|-------------|
| **Consumer (default)** | 5 anos | Si | Estado por defecto |
| **Consumer (opt-out)** | 30 dias | No | Deshabilitar en claude.ai/settings/data-privacy-controls |
| **Team / Enterprise / API** | 30 dias | No (por defecto) | Usar plan Team, Enterprise, o API keys |
| **ZDR (Zero Data Retention)** | 0 dias server-side | No | API keys con configuracion ZDR apropiada |

**Nota:** El comando `/bug` envia el historial completo de conversacion (incluyendo codigo, archivos y posibles secrets) retenido por **5 anos independientemente del tier** de privacidad configurado.

### Que datos salen de tu maquina

| Escenario | Datos enviados a Anthropic |
|-----------|---------------------------|
| Claude lee `src/app.ts` | Contenido completo del archivo |
| Corres `git status` via Claude | Output del comando |
| MCP ejecuta `SELECT * FROM users` | Resultados con datos de usuarios |
| Claude lee `.env` | API keys, passwords, secrets |
| Error en tu codigo | Stack trace completo con paths |

Adicionalmente, Claude Code conecta a servicios de terceros:

- **Statsig** — metricas operacionales (latencia, confiabilidad). Sin codigo ni file paths. Opt-out: `DISABLE_TELEMETRY=1`
- **Sentry** — error logging. Sin codigo ni file paths. Opt-out: `DISABLE_ERROR_REPORTING=1`

### Variables de entorno para privacidad

```bash
# En ~/.zshrc o ~/.bashrc
export DISABLE_TELEMETRY=1
export DISABLE_ERROR_REPORTING=1
export DISABLE_BUG_COMMAND=1
# O deshabilitar todo el trafico no esencial de una vez:
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
```

**Nota:** Con providers Bedrock, Vertex o Foundry, todo el trafico no esencial se deshabilita por defecto.

### ZDR — cuando usarlo

ZDR requiere API keys especialmente configuradas. Casos de uso:
- Datos PII (nombres, emails, direcciones)
- Industrias reguladas: HIPAA (requiere BAA separado), GDPR, PCI-DSS
- Contratos gubernamentales
- Procesamiento de datos de clientes

Fuente: `data-privacy.md:11-99`

---

## 8. Configuracion Segura de MCP — Ejemplo JSON

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server@1.2.3"],
      "env": {}
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@company/db-mcp@2.0.1"],
      "env": {
        "DB_HOST": "readonly-replica.internal",
        "DB_USER": "readonly_user"
      }
    }
  }
}
```

**Practicas clave:**

| Practica | Razon |
|----------|-------|
| Pinear versiones exactas (`@1.2.3`, nunca `@latest`) | Previene Rug Pull — updates no ejecutan sin revision |
| Usar credenciales de DB read-only | Previene DROP/DELETE/UPDATE accidentales |
| Minimizar variables de entorno expuestas | Reduce superficie de exfiltracion |
| Nunca conectar DBs de produccion | Todos los resultados de queries se envian a Anthropic |
| Usar datos de desarrollo anonimizados | Reduce exposicion de PII |

Fuente: `security-hardening.md:124-148`, `data-privacy.md:250-257`

---

## 9. Sandboxing — Referencia rapida

Para ejecucion autonoma (`--dangerously-skip-permissions`), el sandbox es la frontera de seguridad real, no el sistema de permisos.

| Solucion | Aislamiento | Local/Cloud | Mejor para |
|----------|-------------|-------------|-----------|
| **Docker Sandboxes** | microVM (hypervisor) | Local | Maxima seguridad, Docker-in-Docker necesario |
| **Native CC sandbox** | Proceso (Seatbelt/bubblewrap) | Local | Dev diario ligero, codigo confiable |
| **Fly.io Sprites** | Firecracker microVM | Cloud | Workflows de agentes via API |
| **E2B** | Firecracker microVM | Cloud | Apps multi-framework AI |
| **Vercel Sandboxes** | Firecracker microVM | Cloud | Ecosistema Next.js / Vercel |

```bash
# Docker sandbox local — patron recomendado para dev autonomo
docker sandbox run claude ~/my-project -- --dangerously-skip-permissions

# Native sandbox (macOS built-in, Linux requiere bubblewrap + socat)
/sandbox
```

**Limitaciones del native sandbox:** kernel compartido con el host (vulnerable a kernel exploits), domain fronting bypass posible via CDN.

Fuente: `sandbox-isolation.md:16-25`, `sandbox-isolation.md:368-377`

---

## Ver tambien

- [permission-model.md](permission-model.md) — Configuracion vigente de settings.json, sintaxis de reglas, modos disponibles
- CVE sources: Cymulate EscapeRoute, Checkpoint MCPoison, Cato CurXecute, SentinelOne, Flatt Security, Penligent AI
