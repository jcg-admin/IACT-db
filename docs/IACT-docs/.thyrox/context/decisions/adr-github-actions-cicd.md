```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: GitHub Actions para CI/CD
goal: Automatización de tests y deployment
updated_at: 2026-03-25
```

# ADR-009: GitHub Actions para CI/CD

**ADR ID:** ADR-009 | **Status:** Aprobado (Fase 2) | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar GitHub Actions para automatización de CI/CD.**

---

## Pipeline

1. **Lint** - Verificar código
2. **Test** - Ejecutar tests
3. **Build** - Compilar artifacts
4. **Deploy** - Desplegar a producción

---

## Ventajas

- Nativo en GitHub
- Gratis para repos públicos
- YAML simple
- Buena integración
- Comunidad activa

---

## Justificación

- Integración perfecta con GitHub
- Sin configuración externa
- Bajo costo
- Fácil de mantener

---

## Consecuencias

### Positivas

+Automatización completamente integrada<br>
+Bajo costo<br>
+Fácil configuración<br>
+Monitoreo en GitHub

### Negativas

-Limitado a GitHub<br>
-Menos potente que soluciones dedicadas<br>
-Curva de aprendizaje para YAML

---

**Estado:** Planeado para Fase 2
