# ANALISIS-DECISIONES: ADR-INFRA-007 - Dual Database

**Decision:** SQLite (dev) + PostgreSQL (prod)

---

## Trade-offs

| Strategy | Dev Simplicity | Prod Parity | Features | Score |
|----------|----------------|-------------|----------|-------|
| Solo SQLite | 5/5 | 2/5 | 3/5 | 3.3/5 |
| Solo PostgreSQL | 2/5 | 5/5 | 5/5 | 4/5 |
| Dual (ELEGIDA) | 5/5 | 4/5 | 4/5 | 4.5/5 |

## PROS de Dual Database

1. **Dev Simplicity:** SQLite = zero config, archivo local
2. **Prod Robustness:** PostgreSQL = features avanzadas, escalable
3. **Migration Compatibility:** ORM abstraction mantiene compatibility
4. **Fast Onboarding:** Nuevos devs: git clone → runserver (sin DB setup)

## CONTRAS

1. **Potential Divergence:** SQLite vs PostgreSQL pueden tener sutiles diferencias
2. **Mitigacion:** Testing regular en PostgreSQL antes de deploy

## Trade-off

**Dev Speed > Perfect Prod Parity** (diferencias minimas con ORM)

---

**Conclusion:** Dual database balances dev speed + prod robustness
