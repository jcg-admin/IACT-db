```yml
type: Registro de Deuda Técnica
project: IACT-docs
created_at: 2026-04-23 08:30:00
updated_at: 2026-04-23 08:30:00
scope: IACT-docs project only — NOT framework THYROX
```

# Deuda Técnica — IACT-docs

Registro de problemas conocidos específicos del proyecto IACT-docs que no se corrigen inmediatamente pero deben ser atendidos. Cada ítem tiene un ID, descripción, impacto, y criterio de resolución.

**Nota:** Esta lista es SOLO para IACT-docs. La deuda técnica del framework THYROX está separada.

## Convenciones

- `[ ]` = Pendiente
- `[-]` = En progreso
- `[x]` = Resuelto (YYYY-MM-DD)
- Severidad: alta | media | baja
- Origen: security-review, calibration-analysis, Phase X DIAGNOSE, etc.

---

## TD-001: Information Disclosure via Git History — Configuración Sensible en Commits

```
Severidad: ALTA
Origen: security-review (2026-04-23)
Fase afectada: feature/project-setup branch
Estado: [ ] Pendiente
Descubierto por: /security-review skill
```

**Problema:**

Durante revisión de seguridad de la rama `feature/project-setup` se identificó que:

1. Commit `e5c0ff1` (2026-04-23 06:47:43) agregó `PROJECT_CONFIGURATION_REVIEW.md` con información sensible del sistema IACT:
   - Código de proyecto: IACT-2025-001
   - RBAC model v5.1.1 (8 módulos funcionales, 44 funciones atómicas, 3 restricciones SoD)
   - 8 restricciones del sistema (CNST_001 a CNST_008) detallando arquitectura de seguridad
   - Información de compliance: OWASP, NIST RBAC, ISO 27001
   - Detalles de arquitectura operacional y control de acceso

2. Commit `2a21dd0` (2026-04-23 06:53:32) removió el archivo, pero la información permanece **permanentemente en git history**.

**Impacto:**

- Si el repositorio se hace público, expone arquitectura de seguridad interna
- Si credenciales de git se comprometen, cualquiera con acceso al repo puede ver detalles de restricciones
- El histórico de git no puede "revertirse" — la información está para siempre a menos que se reescriba el historial

**Riesgo Real:**

La rama `feature/project-setup` está up-to-date con `origin/feature/project-setup`. Los commits están en el servidor remoto (127.0.0.1:40231).

**Criterio de Resolución:**

Elegir una opción:

**Opción A (Recomendado):** Limpiar el historial completamente
```bash
# 1. Usar bfg-repo-cleaner o git-filter-branch para remover ambos commits
git filter-branch --tree-filter 'rm -f PROJECT_CONFIGURATION_REVIEW.md' -- e5c0ff1^..2a21dd0
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push origin feature/project-setup --force-with-lease
```

**Opción B:** Aceptar el riesgo y documentar
- Agregar `PROJECT_CONFIGURATION_REVIEW.md` a `.gitignore`
- Documentar que información sensible NUNCA debe entrar en git
- Implementar pre-commit hooks para prevenir futuros incidentes

**Recomendación:** Opción A es preferida. Opción B solo si el historial es "local-only".

**Próximos pasos:**
1. Decidir Opción A o B (requiere confirmación de usuario)
2. Si Opción A: ejecutar limpieza de historial
3. Crear TD-002 (ADR sobre política de información sensible)

---

## TD-002: Crear ADR-sensitive-info-policy — Política de Información Sensible en Repositorio

```
Severidad: MEDIA
Origen: TD-001 (como resultado de limpieza)
Fase afectada: Decisiones del proyecto
Estado: [ ] Pendiente
Descripción: ADR formal que defina qué es sensible y dónde almacenarlo
```

**Problema:**

El proyecto no tiene política formal sobre qué información es sensible y dónde almacenarla. Como resultado, información de seguridad (RBAC, restricciones de sistema) se agregó accidentalmente a git en TD-001.

**Trabajo requerido:**

Crear `decisions/adr-sensitive-info-policy.md` que documente:

1. **Qué es información sensible en IACT-docs:**
   - RBAC models y definiciones de funciones
   - Restricciones del sistema (CNST-NNN)
   - Detalles de autenticación/autorización
   - Credenciales, API keys, tokens
   - Información de compliance interna

2. **Dónde almacenarla:**
   - Credenciales: variables de entorno, no-git
   - RBAC/restricciones: documentos no-versionados o encriptados (git-crypt)
   - Detalles técnicos internos: wikis privadas o documentos no-git

3. **Prevención:**
   - Pre-commit hooks para detectar patrones (RBAC, CNST, credenciales)
   - `.gitignore` explícito para archivos de configuración
   - Code review checklist: "¿contiene información sensible?"

4. **Recuperación si ocurre:**
   - Procedimiento de limpieza con git-filter-branch
   - Comunicación a stakeholders
   - Rotación de credenciales si aplica

**Criterio de resolución:**

`decisions/adr-sensitive-info-policy.md` existe, está aprobado, y las convenciones se documentan en `.claude/rules/` o `.thyrox/guidelines/`.

---

## TD-003: Implementar Pre-commit Hooks para Detectar Información Sensible

```
Severidad: MEDIA
Origen: TD-001 + TD-002 (prevención)
Fase afectada: Development workflow
Estado: [ ] Pendiente
Depende de: TD-002 (necesita ADR primero)
```

**Problema:**

Sin pre-commit hooks, desarrolladores pueden accidentalmente commitar información sensible. El error solo se detecta después de push.

**Trabajo requerido:**

Crear `.git/hooks/pre-commit` que:
1. Detecte patrones sensibles:
   - `RBAC_` o `CNST_` en archivos `.md`
   - Credenciales típicas (API_KEY, PASSWORD, SECRET, TOKEN)
   - Patrones de IPs privadas o rutas internas
2. Bloquee el commit si detecta patrones
3. Proporcione mensaje útil: "Información sensible detectada — usar env vars o .gitignore"

**Alternativa:** Usar herramientas existentes:
- `git-secrets` de AWS
- `detect-secrets` de Python
- `gitleaks`

**Criterio de resolución:**

Pre-commit hook existe, funciona localmente, previene commit de información sensible, y está documentado en CONTRIBUTING.md.

---

## TD-004: Documentar Estructura de Directorios para Desarrolladores

```
Severidad: BAJA
Origen: calibration-analysis (2026-04-23)
Fase afectada: Project documentation
Estado: [ ] Pendiente
```

**Problema:**

La estructura del proyecto es clara (`source/`, `build/`, `.venv/`, etc.) pero no está documentada en README o CONTRIBUTING. Nuevos desarrolladores deben inferir el propósito de cada directorio.

**Trabajo requerido:**

Actualizar `README.rst` o crear `STRUCTURE.md` con:
- Propósito de cada directorio principal
- Dónde agregar documentación (source/arquitectura_tecnica/, etc.)
- Cómo construir (Makefile targets)
- Cómo contribuir

**Criterio de resolución:**

`STRUCTURE.md` o sección en `README.rst` documenta la estructura, y es comprensible para alguien nuevo en el proyecto.

---

## TD-005: Validar que Todas las Extensiones Sphinx se Cargan Correctamente

```
Severidad: MEDIA
Origen: security-review / config-review (2026-04-23)
Fase afectada: Phase 3 DIAGNOSE
Estado: [ ] Pendiente
```

**Problema:**

El proyecto declara 16 extensiones Sphinx activas en `source/conf.py`, pero:
- `sphinxcontrib.spelling` — requiere `spelling_wordlist.txt` (no existe)
- `sphinx.ext.autodoc` — comentado (backend no integrado)
- `sphinxcontrib.openapi` — comentado (OpenAPI no integrado)

No hay verificación de que todas las extensiones funcionan.

**Trabajo requerido:**

1. Ejecutar `make clean && make html` y revisar warnings
2. Resolver cada warning:
   - Crear `spelling_wordlist.txt` para español
   - Descomentar autodoc si hay backend Python
   - Comentar extensiones no-usadas si no se necesitan
3. Documentar qué extensión hace qué en conf.py

**Criterio de resolución:**

`make html` ejecuta sin warnings de extensiones. La documentación contiene metadatos sobre qué extensión agregó qué característica.

---

## TD-006: Crear CI/CD Pipeline para Validación Automática de Builds

```
Severidad: ALTA
Origen: config-review (2026-04-23)
Fase afectada: Phase 3 DIAGNOSE / Phase 6 SCOPE
Estado: [ ] Pendiente
```

**Problema:**

No hay CI/CD documentado. Los cambios a documentación no se validan automáticamente antes de merge. Es posible mergear cambios que rompen la build.

**Trabajo requerido:**

Crear `.github/workflows/sphinx-build.yml` (o equivalente) que:
1. En cada push: `make clean && make html`
2. En cada PR: validar links con `make linkcheck`
3. Artifact: guardar build output para preview
4. Gate: bloquear merge si build falla

**Criterio de resolución:**

CI/CD workflow existe, ejecuta en cada PR, y has visto al menos 1 PR pasar las validaciones.

---

## TD-007: Crear Plan de Remediación para Phase 3 DIAGNOSE

```
Severidad: ALTA
Origen: Phase 1 DISCOVER completado (2026-04-23)
Fase afectada: Phase 3 DIAGNOSE (próxima)
Estado: [ ] Pendiente
Depende de: TD-001, TD-002, TD-003, TD-005, TD-006
```

**Problema:**

Phase 1 DISCOVER identificó hallazgos (calibración global 0.71, dominios críticos con 0.37-0.41). Phase 3 DIAGNOSE requiere root cause analysis y plan de remediación.

**Trabajo requerido:**

Crear `analyze/` directorio dentro del WP con:
- `analyze/security-analysis.md` — profundizar en TD-001
- `analyze/dependencies-analysis.md` — validar vulnerabilidades
- `analyze/configuration-analysis.md` — revisar completud de conf.py
- Task-plan de remediación para Phase 5 STRATEGY

**Criterio de resolución:**

`analyze/` tiene 3+ análisis completados, identifican causa raíz, y hay plan de remediación escrito.

---

**Total TDs:** 7 (IACT-docs specific)
**Pendientes:** 7 · **En progreso:** 0 · **Resueltos:** 0
**Ubicación:** `.thyrox/context/technical-debt.md`
**Alcance:** Solo IACT-docs project (feature/project-setup branch)
