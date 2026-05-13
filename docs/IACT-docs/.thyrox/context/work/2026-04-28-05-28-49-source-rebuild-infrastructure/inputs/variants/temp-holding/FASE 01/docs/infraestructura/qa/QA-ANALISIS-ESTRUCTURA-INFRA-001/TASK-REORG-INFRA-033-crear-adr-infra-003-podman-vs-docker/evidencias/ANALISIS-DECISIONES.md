# ANALISIS-DECISIONES: ADR-INFRA-003 - Podman vs Docker

**Fecha:** 2025-11-18 | **Decision:** Podman rootless en VM

---

## Razonamiento Profundo

### Contexto

Container runtime es critico para:
- Ejecutar DevContainers
- Ejecutar pipeline CI/CD
- Isolation y seguridad
- Performance

### Analisis de Trade-offs

| Factor | Docker | Podman | Peso |
|--------|--------|--------|------|
| Seguridad (rootless) | 2/5 (daemon root) | 5/5 (rootless) | CRITICO |
| Performance | 4/5 | 4/5 (similar) | Alto |
| Compatibilidad CLI | 5/5 | 5/5 (docker alias) | Alto |
| Documentacion | 5/5 | 3/5 | Medio |
| Learning Curve | 5/5 | 4/5 | Bajo |

**Score Ponderado:**
- Docker: 3.8/5
- Podman: 4.6/5

### PROS de Podman

1. **Seguridad Rootless:** Contenedores ejecutan sin root privileges
2. **Sin Daemon:** No requiere proceso daemon corriendo
3. **Menos Recursos:** Sin overhead de daemon
4. **Docker Compatible:** Alias docker=podman funciona para 95% de casos
5. **Open Source Philosophy:** Alineado con valores del proyecto

### CONTRAS de Podman

1. **Menos Documentacion:** Menos tutoriales que Docker
2. **Learning Curve Minima:** Algunas diferencias sutiles en flags
3. **Mitigacion:** Documentacion interna, troubleshooting guide

### Trade-off Aceptable

**Menos documentacion < Seguridad mejorada**

---

**Conclusion:** Podman es superior para use case de development + CI/CD
