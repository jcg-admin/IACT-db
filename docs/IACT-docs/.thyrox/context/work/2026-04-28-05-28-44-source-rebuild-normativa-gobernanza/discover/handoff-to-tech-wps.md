```yml
created_at: 2026-04-28 16:45:00
project: IACT-docs
work_package: 2026-04-28-05-28-44-source-rebuild-normativa-gobernanza
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Handoff a WPs tecnicos — ADRs no-GOB

## Premisa (Decision 10 del padre)

Los ADRs especificos de tier tecnico (backend, frontend, infrastructure,
quality) NO entran al cajon `source/normativa/gobernanza/`. Per
Decision 10 (re-autoria con v1.0.0 fresh, no migracion), cada cajon
tecnico re-autorea sus propios ADRs en su WP correspondiente.

## ADRs encontrados en `inputs/canonical/` no rutados a este WP

19 ADRs totales en inputs, 7 son GOB (rutados aqui), 12 corresponden
a otros WPs tecnicos.

### A WP #9 backend (`source-rebuild-backend`) — 4 ADRs

| ADR | Titulo |
|-----|--------|
| ADR-BACK-001-grupos-funcionales-sin-jerarquia | Modelo RBAC: grupos funcionales sin jerarquia (relacionado con CNST_029) |
| ADR-BACK-002-configuracion-dinamica-sistema | Configuracion dinamica via tabla settings |
| ADR-BACK-003-orm-sql-hybrid-permissions | ORM + SQL hybrid para permission queries |
| ADR-BACK-004-sistema-permisos-sin-roles-jerarquicos | Sistema de permisos sin roles jerarquicos (relacionado con CNST_029) |

### A WP #10 frontend (`source-rebuild-frontend`) — 5 ADRs

| ADR | Titulo |
|-----|--------|
| ADR-FRONT-001-frontend-modular-monolith | Frontend como monolito modular |
| ADR-FRONT-002-redux-toolkit-state-management | Redux Toolkit para state management |
| ADR-FRONT-003-webpack-bundler | Webpack como bundler |
| ADR-FRONT-004-arquitectura-microfrontends | Arquitectura de microfrontends (decision diferida) |
| ADR-FRONT-010-typescript-adopcion-gradual | TypeScript adopcion gradual |

### A WP #11 infrastructure (`source-rebuild-infrastructure`) — 2 ADRs

| ADR | Titulo |
|-----|--------|
| ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC | Vagrant + mod_wsgi (relacionado con CNST_021 Stack Apache) |
| ADR-DEVOPS-003-wasi-style-virtualization--IMPORTANTE-DB | WASI-style virtualization para DB |

### A WP #15 quality (`source-rebuild-quality`) — 1 ADR

| ADR | Titulo |
|-----|--------|
| ADR-QA-002-testing-strategy-jest-testing-library | Estrategia de testing con Jest + Testing Library |

## Procedimiento sugerido para los WPs receptores

Cada WP tecnico debe:

1. Leer su lista de ADRs candidatos en `inputs/canonical/` (ya
   pre-staged por la convencion de inputs).
2. Aplicar criterio editorial (Idea 5): incorporar / fusionar /
   reescribir / descartar caso por caso.
3. Re-autorizar con v1.0.0 fresh per Decision 10:
   - Si el ADR sigue vigente y aplica → incorporar con metadata 1.0.0.
   - Si se contradice con CNSTs del rebuild → reescribir resolviendo
     la contradiccion.
   - Si esta deprecado → descartar con nota en handoff propio.
4. Aplicar STD_007 §4.2 naming: `ADR-<MOD>-<NNN>-<desc-kebab>.rst`.
5. Renumerar consecutivamente desde 001 en su cajon (no preservar
   gaps).

## Refs cruzadas con CNSTs del rebuild

Algunos ADRs tienen relacion explicita con CNSTs del rebuild SRP:

| ADR | CNST relacionado |
|-----|------------------|
| ADR-BACK-001 (grupos sin jerarquia) | :doc:`/normativa/restricciones/CNST_029_RBAC_Modelo_Plano` |
| ADR-BACK-004 (permisos sin roles) | :doc:`/normativa/restricciones/CNST_029_RBAC_Modelo_Plano` |
| ADR-DEVOPS-001 (Vagrant + mod_wsgi) | :doc:`/normativa/restricciones/CNST_021_Stack_Obligatorio_Ubuntu_Apache_mod_wsgi` |
| ADR-FRONT-003 (webpack bundler) | (sin CNST directo, decision tier) |

Cuando los WPs tecnicos abran, deben asegurar consistencia con los
CNSTs del rebuild — si hay contradiccion, prevalece el CNST como
fuente canonica (ver :doc:`/normativa/restricciones/index`).

## Notas adicionales

- En `inputs/canonical/` tambien hay `plantilla_adr.md` (formato
  legacy markdown) — NO se usa, esta deprecada en favor de
  :doc:`/normativa/estandares/plantillas/TPL_ADR_Decisiones_Arquitectonicas`
  que es el formato RST canonico.
- Hay 9 archivos de analisis (`ANALISIS_*.md`,
  `REPORTE_CLASIFICACION_ADRS_*.md`, etc.) que son insumos
  metodologicos, no ADRs. No se incorporan al rebuild — quedan
  disponibles en `inputs/` para consulta historica.
- Hay 6 entradas de bitacora ejecutiva (`2025_NN_NN_*.md`) que
  son notas operativas, no ADRs. Tampoco se incorporan.
