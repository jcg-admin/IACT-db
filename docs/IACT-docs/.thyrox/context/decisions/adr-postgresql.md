```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: PostgreSQL como Base de Datos
goal: Seleccionar motor de base de datos
updated_at: 2026-03-25
```

# ADR-007: PostgreSQL como Base de Datos

**ADR ID:** ADR-007 | **Status:** Aprobado | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar PostgreSQL como principal base de datos.**

---

## Justificación

- Open source
- Robusto y confiable
- Soporta JSON
- Herramientas maduras
- Escalable
- Excelente documentación
- Comunidad activa

---

## Características Utilizadas

- JSONB para datos flexibles
- Full-text search
- Transacciones ACID
- Índices avanzados
- Window functions

---

## Consecuencias

### Positivas

+Datos seguros y confiables<br>
+Buen performance<br>
+Amplio soporte<br>
+Open source

### Negativas

-Setup inicial más complejo<br>
-Requiere administración<br>
-No es serverless

---

**Estado:** Activo en producción
