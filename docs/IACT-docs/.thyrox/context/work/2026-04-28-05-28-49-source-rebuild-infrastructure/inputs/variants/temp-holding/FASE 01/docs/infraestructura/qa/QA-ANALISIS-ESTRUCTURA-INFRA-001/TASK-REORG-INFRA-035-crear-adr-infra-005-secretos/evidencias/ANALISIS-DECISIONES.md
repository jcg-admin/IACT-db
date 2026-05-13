# ANALISIS-DECISIONES: ADR-INFRA-005 - Secretos

**Decision:** Environment Variables + .env.local

---

## Trade-offs

| Opcion | Security | Simplicity | Overhead | Score |
|--------|----------|------------|----------|-------|
| Hardcoded | 0/5 | 5/5 | 0/5 | 1/5 |
| Env Vars | 4/5 | 5/5 | 5/5 | 4.7/5 |
| Vault | 5/5 | 2/5 | 2/5 | 3/5 |
| Cloud Secret Manager | 5/5 | 2/5 | 2/5 | 3/5 |

## PROS de Env Vars

1. **Simplicity:** Export VAR=value, done
2. **Security:** Si .env.local git-ignored, seguro
3. **Standard:** 12-factor app methodology
4. **No Overhead:** No infrastructure adicional
5. **Developer Friendly:** Facil onboarding

## CONTRAS

1. **Manual Rotation:** Requiere actualizar manualmente
2. **Mitigacion:** Documentar rotation process

## Trade-off

**Simplicidad > Infrastructure overhead** (para proyecto tamano IACT)

---

**Conclusion:** Env vars suficiente y seguro para IACT
