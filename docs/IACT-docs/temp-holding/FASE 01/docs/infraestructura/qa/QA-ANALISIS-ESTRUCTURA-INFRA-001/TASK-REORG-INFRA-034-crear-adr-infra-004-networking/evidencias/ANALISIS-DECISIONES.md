# ANALISIS-DECISIONES: ADR-INFRA-004 - Networking

**Decision:** Private Network con IP fija

---

## Trade-offs

| Opcion | PROS | CONTRAS | Score |
|--------|------|---------|-------|
| NAT | Simple | No acceso directo | 2/5 |
| Private Network | IP fija, acceso bidireccional | Config adicional | 5/5 |
| Bridged | LAN access | Depende de red fisica | 3/5 |
| Host-only | Secure | Restrictivo | 3/5 |

## Decision Rationale
Private Network balances:
- Accessibility (SSH, VS Code Remote)
- Portability (no depende de red fisica)
- Simplicity (IP fija, facil configurar)

**Trade-off Aceptable:** Config adicional < Beneficios de IP fija

---

**Conclusion:** Private Network optimo para dev VM
