---
id: TASK-REORG-INFRA-035
tipo: tarea_contenido
categoria: adr
fase: FASE_3_CONTENIDO_NUEVO
prioridad: CRÍTICA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-REORG-INFRA-031]
tags: [adr, secretos, security, devcontainer, decision, infraestructura, crítico]
tecnica_prompting: Template-based Prompting + Chain-of-Verification (CoVE) + Self-Consistency
fecha_creacion: 2025-11-18
---

# TASK-REORG-INFRA-035: Crear ADR-INFRA-005 (Gestión de Secretos en DevContainer)

## Auto-CoT: Chain-of-Verification para Decisión Crítica de Seguridad

### 1. Verificación de Problema (CoVE Step 1)

**¿Cuál es exactamente el problema de secretos?**
```
Development environment requiere:
[OK] Credenciales de base de datos (dev, prod)
[OK] API keys (third-party services)
[OK] Tokens de autenticación (JWT, OAuth)
[OK] SSH keys (git, internal services)
[OK] Environment variables sensibles

En DevContainer (contenedor):
[OK] No hardcodear secretos en imagen
[OK] Aislamiento de secretos entre devs
[OK] Auditoría de acceso a secretos
[OK] Rotación de secretos factible
[OK] No exponer en git
```

**Verificación:** Problema bien definido [OK]

### 2. Verificación de Opciones (CoVE Step 2)

**¿Todas las alternativas han sido consideradas?**
```
Opción A: Environment variables en .env
├─ Verificación: Simple, pero difícil de rotación y auditoría
├─ Riesgo: .env puede ser commiteado por error
└─ Verdict: Incompleto para requirements

Opción B: Vault (HashiCorp)
├─ Verificación: Auditoría total, rotación, multi-tenant
├─ Riesgo: Overhead operacional para dev local
└─ Verdict: Overkill para dev, bueno para prod

Opción C: Archivos .env cifrados + decryption en runtime (RECOMENDADA)
├─ Verificación: Seguridad + simplicity + auditabilidad
├─ Riesgo: Gestión de master key
└─ Verdict: Equilibrio óptimo

Opción D: Secretos en memoria (initramfs)
├─ Verificación: Máxima seguridad, pero complejidad
├─ Riesgo: No factible en VM Vagrant estándar
└─ Verdict: Demasiado complejo
```

**Verificación:** Todas las opciones evaluadas [OK]

### 3. Verificación de Criterios (CoVE Step 3)

**¿Se consideraron los criterios de seguridad relevantes?**
```
OWASP Top 10 - Secrets Management:
├─ A01: Broken Access Control
│  ├─ Verificación: Vault/cifrado controla acceso
│  └─ Mitigación: Implementar en ADR [OK]
├─ A02: Cryptographic Failures
│  ├─ Verificación: Cifrado AES-256 para .env
│  └─ Mitigación: Documentar en ADR [OK]
├─ A03: Injection
│  ├─ Verificación: Environment variables no concatenadas
│  └─ Mitigación: Best practices en ADR [OK]
└─ A05: Security Misconfiguration
   ├─ Verificación: Plantillas de .env.example
   └─ Mitigación: Documentar en ADR [OK]

Compliance:
├─ GDPR: Credentials auditable [OK]
├─ SOC2: Encryption required [OK]
└─ ISO27001: Secrets rotation required [OK]
```

**Verificación:** Criterios de seguridad cubiertos [OK]

### 4. Verificación de Consecuencias (CoVE Step 4)

**¿Se evaluaron todas las consecuencias?**
```
Positivas:
- Developerss no need hardcoding [OK]
- Secrets auditable (chain of custody) [OK]
- Easy rotation in DevContainer [OK]
- Multi-environment support [OK]

Negativas:
- Overhead de decryption en startup [OK]
- Gestión de master key complexity [OK]
- Learning curve para developers [OK]

Neutrales:
- Requires documentation [OK]
- Requires automation (script) [OK]
- CI/CD integration necesaria [OK]
```

**Verificación:** Todas las consecuencias documentadas [OK]

### 5. Verificación de Implementabilidad (CoVE Step 5)

**¿Es la opción elegida realista de implementar?**
```
Tecnología requerida:
├─ Git-crypt: Disponible, OpenSource [OK]
├─ SOPS (Secrets Operations): Disponible, OpenSource [OK]
├─ Vault: Disponible, pero overhead [ERROR]

Tooling:
├─ .env.encrypted + script de decryption [OK]
├─ Permisos de archivo 600 [OK]
├─ Gitignore.* patrones [OK]

Timeframe: 3-4 horas implementación [OK]
```

**Verificación:** Opción es implementable [OK]

## Descripción de la Tarea

Esta tarea documenta formalmente la **estrategia crítica de gestión de secretos en DevContainer**, garantizando seguridad, auditoría y compatibilidad con el workflow de development.

Es el **quinto ADR formal de infraestructura**, siendo CRÍTICO para la seguridad del proyecto.

## Objetivo

Crear un Architecture Decision Record (ADR) que:
- Documente requisitos de seguridad para secretos
- Presente opciones evaluadas (env vars, Vault, .env cifrado)
- Justifique la elección de .env cifrado con rotación
- Establezca políticas de secretos (never commit, auditar, rotar)
- Defina criterios de validación y compliance

## Alineación

**Canvases de referencia:**
- `/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`
- `/docs/gobernanza/seguridad/politica-secretos.md`

**Decisión:** ADR-INFRA-005 define la estrategia crítica de secrets management.

## Contenido a Generar

### Archivo Principal
- **Ubicación:** `/docs/infraestructura/adr/ADR-INFRA-005-gestion-secretos-devcontainer.md`
- **Formato:** Markdown con frontmatter YAML
- **Secciones:** 8 secciones completas

### Estructura del ADR

1. **Contexto y Problema**
   - Requisitos de secretos en DevContainer
   - Riesgos de seguridad (hardcoding, exposición)
   - Requisitos de compliance (OWASP, GDPR, SOC2)
   - Casos de uso (DB credentials, API keys, tokens)

2. **Factores de Decisión**
   - Security (encryption, access control) (CRÍTICO)
   - Auditability (chain of custody) (CRÍTICO)
   - Rotación de secretos (CRÍTICO)
   - Developer Experience (Medio)
   - Operational Overhead (Medio)
   - Compliance (GDPR, SOC2) (Alto)

3. **Opciones Consideradas**
   - Environment variables planas (.env)
   - Vault (HashiCorp)
   - .env cifrado + decryption
   - Alternativas rechazadas

4. **Decisión**
   - Archivos .env cifrados con decryption en runtime + Vault para producción

5. **Justificación**
   - Seguridad: Cifrado AES-256
   - Auditoría: Chain of custody via git
   - Developer-friendly: Transparencia en devcontainer
   - Compliance: OWASP, GDPR, SOC2 aligned

6. **Consecuencias**
   - Positivas: Seguridad, auditoría, compliance
   - Negativas: Complejidad de master key
   - Neutrales: Documentación y training necesarios

7. **Plan de Implementación**
   - Fase 1: Setup de git-crypt / SOPS (1 día)
   - Fase 2: .env.encrypted template (1 día)
   - Fase 3: Decryption automation en provision.sh (1 día)
   - Fase 4: Developer guide + compliance validation (1 día)

8. **Validación y Métricas**
   - Criterios: Zero secrets in git, auditable access
   - Medición: Secrets scanning en CI (git-secrets)
   - Compliance: SOC2 audit trail requerido

## Self-Consistency: Validación de Coherencia (CoVE Verificado)

### Checklist de Completitud - CRÍTICO

- [ ] 8 secciones presentes en el ADR
- [ ] Frontmatter YAML completo
- [ ] CoVE (Chain-of-Verification) en análisis
- [ ] OWASP Top 10 Secrets Management documentado
- [ ] Compliance (GDPR, SOC2) referenciado
- [ ] 4 opciones consideradas con riesgos
- [ ] Mitigación de riesgos explícita
- [ ] Plan de rotación de secretos
- [ ] Audit trail requerido
- [ ] Procedimientos de emergencia (leaked secret)

### Alineación Verificada - Crítica

| Aspecto | Requerimiento | ADR | Status |
|---------|-----------|-----|--------|
| No secrets en git | CRÍTICO | [ ] | Pendiente |
| Encrypto AES-256 | CRÍTICO | [ ] | Pendiente |
| Auditable access | CRÍTICO | [ ] | Pendiente |
| OWASP compliant | CRÍTICO | [ ] | Pendiente |
| Rotación viable | CRÍTICO | [ ] | Pendiente |
| Emergency procedure | CRÍTICO | [ ] | Pendiente |

### Coherencia de CoVE

**Verificación completada:**
```
[OK] Problema bien definido
[OK] Opciones exhaustivas
[OK] Criterios de seguridad evaluados
[OK] Consecuencias verificadas
[OK] Implementabilidad confirmada

Conclusión: Decisión CoVE-verificada y lista para implementación
```

## Decisión Capturada (Preliminary)

**Opción elegida:** .env cifrado (git-crypt/SOPS) + Vault para producción

**Justificación CRÍTICA:**
- Seguridad: Cifrado AES-256, zero secrets en git
- Auditoría: Chain of custody completa
- Compliance: OWASP, GDPR, SOC2 aligned
- Developer-friendly: Transparencia pero seguro
- Emergency-ready: Procedimientos para leaked secrets

## Estructura de Secretos (Propuesta)

```
DevContainer Secrets:
├─ .env.encrypted (versionado, cifrado)
├─ .env.example (template, no secrets)
├─ .gitattributes (git-crypt filter)
├─ secrets/
│  ├─ db.key (development credentials)
│  ├─ api.key (third-party services)
│  └─ jwt.key (authentication)
└─ scripts/decrypt.sh (executed en provision)

CI/CD Secrets:
├─ GitHub Secrets (Actions)
└─ Vault (future production)
```

## Próximos Pasos

1. Desarrollar ADR-INFRA-005 con 8 secciones
2. CoVE completamente documentado
3. OWASP/Compliance matrix
4. Emergency procedures (leaked secrets)
5. Developer onboarding guide
6. Revisión de Security team

## Referencias

- **OWASP Secrets Management:** https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- **git-crypt:** https://github.com/AGWA/git-crypt
- **SOPS:** https://github.com/mozilla/sops
- **Vault:** https://www.vaultproject.io/
- **Plantilla ADR:** `/docs/gobernanza/adr/plantilla_adr.md`

## Criterios de Aceptación

- [ ] ADR-INFRA-005 creado con 8 secciones
- [ ] CoVE completamente documentado
- [ ] OWASP Top 10 Secrets Management cubierto
- [ ] Compliance matrix (GDPR, SOC2) presente
- [ ] Emergency procedures documentados
- [ ] Developer guide creado
- [ ] Revisión de Security team completada

---

**Estado:** PENDIENTE
**Fecha Creación:** 2025-11-18
**Fase:** FASE_3_CONTENIDO_NUEVO
**Prioridad:** CRÍTICA
**Responsable:** Equipo de Arquitectura + Security
