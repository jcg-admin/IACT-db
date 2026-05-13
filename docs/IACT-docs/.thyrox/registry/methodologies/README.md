# Registry de Metodologías — THYROX

Cada archivo YAML define una metodología gestionada por THYROX.
El coordinator genérico (`thyrox-coordinator`) lee estos archivos para resolver
transiciones de `methodology_step` dinámicamente.

## Schema por tipo de flujo

### 1. `cyclic` — Flujo cíclico (ej: PDCA)

```yaml
id: <id>
type: cyclic
display: "<nombre>"
steps:
  - id: <id>:<step>
    display: "<descripción>"
    output: "<artefacto esperado>"
    next: [<id>:<siguiente>]   # last step → first step para cerrar ciclo
```

### 2. `sequential` — Flujo secuencial lineal (ej: DMAIC, PMBOK)

```yaml
id: <id>
type: sequential
display: "<nombre>"
steps:
  - id: <id>:<step>
    display: "<descripción>"
    output: "<artefacto esperado>"
    next: [<id>:<siguiente>]   # último paso: next: []
```

### 3. `iterative` — Flujo iterativo con repetición (ej: RUP)

```yaml
id: <id>
type: iterative
display: "<nombre>"
steps:
  - id: <id>:<fase>
    display: "<descripción>"
    milestone: "<nombre del milestone>"
    milestone_criteria: "<criterios para avanzar>"
    next: [<id>:<siguiente>]   # avanzar a siguiente fase cuando milestone OK
    repeat: <id>:<fase>        # repetir esta fase (nueva iteración)
    repeat_when: "<condición de repetición>"
```

### 4. `non-sequential` — Knowledge areas sin orden fijo (ej: BABOK)

```yaml
id: <id>
type: non-sequential
display: "<nombre>"
note: "<instrucción de routing para el coordinator>"
areas:
  - id: <id>:<area>
    display: "<descripción>"
    tasks: ["<tarea 1>", "<tarea 2>"]
    output: "<artefacto esperado>"
    # Sin next: — el coordinator determina el área según contexto
```

### 5. `conditional` — Flujo con transiciones tipadas (ej: RM, PS8)

```yaml
id: <id>
type: conditional
display: "<nombre>"
note: "<descripción del flujo condicional>"
steps:
  - id: <id>:<step>
    display: "<descripción>"
    output: "<artefacto esperado>"
    next:
      on_<condicion_a>: [<id>:<paso_a>]
      on_<condicion_b>: [<id>:<paso_b>]
      on_<condicion_c>: []   # paso terminal
```

## Contrato `methodology_step`

El campo `now.md::methodology_step` usa el formato `{flow}:{step-id}`:

```
pdca:plan          # PDCA, paso Plan
dmaic:analyze      # DMAIC, paso Analyze
rup:elaboration    # RUP, fase Elaboration
rm:validation      # RM, paso Validation
pm:executing       # PMBOK, grupo Executing
ba:elicitation     # BABOK, área Elicitation & Collaboration
```

## Archivos disponibles

| Archivo | Metodología | Tipo | Pasos |
|---------|-------------|------|-------|
| `pdca.yml` | PDCA — Plan-Do-Check-Act | cyclic | 4 |
| `dmaic.yml` | DMAIC — Six Sigma | sequential | 5 |
| `rup.yml` | RUP — Rational Unified Process | iterative | 4 fases |
| `rm.yml` | RM — Requirements Management | conditional | 5 |
| `pmbok.yml` | PMBOK — Project Management | sequential | 5 grupos |
| `babok.yml` | BABOK — Business Analysis | non-sequential | 6 áreas |
| `ps8.yml` | PS8 — Problem Solving 8D | conditional | 8 pasos |
