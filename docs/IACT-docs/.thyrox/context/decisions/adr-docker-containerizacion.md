```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: Docker para Containerización
goal: Reproducibilidad y deployment
updated_at: 2026-03-25
```

# ADR-008: Docker para Containerización

**ADR ID:** ADR-008 | **Status:** Aprobado (Fase 2) | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar Docker para reproducibilidad y deployment.**

---

## Enfoque

- `Dockerfile` por sub-proyecto
- `docker-compose.yml` para desarrollo
- Minimal images basadas en alpine

---

## Justificación

- Reproducibilidad garantizada
- Fácil deployment
- Aislamiento de dependencias
- Escalabilidad con orquestación

---

## Consecuencias

### Positivas

+Reproducibilidad<br>
+Fácil onboarding<br>
+Deployment consistente<br>
+CI/CD simplificado

### Negativas

-Overhead de Docker<br>
-Curva de aprendizaje<br>
-Debugging más complejo

---

**Estado:** Planeado para Fase 2
