---
id: TASK-REORG-BACK-050
tipo: tarea
categoria: metodologias
titulo: Crear README metodologias/
fase: FASE_3
prioridad: BAJA
duracion_estimada: 10min
estado: pendiente
dependencias: [TASK-048, TASK-049]
---

# TASK-REORG-BACK-050: Crear README metodologias/

**Fase:** FASE 3 - Metodologias y Mejores Practicas
**Prioridad:** BAJA
**Duracion Estimada:** 10 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE
**Dependencias:** TASK-048 (TDD), TASK-049 (Clean Architecture)

---

## Objetivo

Crear README.md en carpeta metodologias/ que sirva como indice y guia de las metodologias documentadas para el backend.

---

## Pasos de Ejecucion

### Paso 1: Crear README.md

```bash
cat > /home/user/IACT/docs/backend/metodologias/README.md << 'EOF'
# Metodologias y Mejores Practicas - Backend

Guias de metodologias de desarrollo y arquitectura para el equipo backend.

---

## Metodologias Disponibles

### Desarrollo
- **[TDD-metodologia.md](./TDD-metodologia.md)** - Test-Driven Development
 - Ciclo Red-Green-Refactor
 - Mejores practicas de testing
 - Patrones comunes de testing backend
 - Cuando usar: Siempre para nuevo codigo, especialmente logica critica

### Arquitectura
- **[clean-architecture.md](./clean-architecture.md)** - Clean Architecture
 - Principios SOLID
 - Separacion en capas
 - Dependency Inversion
 - Cuando usar: Proyectos grandes, alta complejidad

---

## Como Usar Estas Guias

1. **Onboarding:** Nuevos miembros deben leer TDD y Clean Architecture
2. **Referencia:** Consultar durante development cuando surjan dudas
3. **Code Reviews:** Usar como criterio de calidad
4. **Retrospectivas:** Evaluar si estamos siguiendo las metodologias

---

## Contribuir

Para añadir nueva metodologia:
1. Crear archivo `{nombre}-metodologia.md`
2. Seguir estructura: Introduccion, Principios, Ejemplos, Referencias
3. Añadir entrada en este README
4. Someter a PR con label `documentacion`

---

## Contacto

**Maintainer:** Tech Lead
**Slack:** #backend-architecture
**Issues:** GitHub con label `metodologias`

EOF
```

**Resultado Esperado:** README.md creado

---

## Criterios de Exito

- [ ] README.md creado en docs/backend/metodologias/
- [ ] Lista metodologias disponibles (TDD, Clean Architecture)
- [ ] Seccion "Como Usar Estas Guias"
- [ ] Instrucciones para contribuir

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

**Tarea creada:** 2025-11-18
**Estado:** PENDIENTE
