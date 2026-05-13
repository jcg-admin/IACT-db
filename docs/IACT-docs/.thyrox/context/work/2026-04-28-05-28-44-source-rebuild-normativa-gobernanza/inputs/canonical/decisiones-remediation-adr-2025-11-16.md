---
title: Decisiones Arquitectónicas - Remediación ADRs
date: 2025-11-16
tipo: decisiones
estado: aprobado
relacionado: analisis-errores-adr-2025-11-16.md
---

# Decisiones para Remediación de ADRs

**Fecha**: 2025-11-16
**Contexto**: Remediación de 59 ADRs con problemas críticos de organización
**Referencia**: analisis-errores-adr-2025-11-16.md

---

## Decisiones Tomadas

### 1. Convención de Numeración
**Decisión**: `ADR-XXX-descripcion.md` (sin año)

**Razón**:
- Más simple y mantenible
- Evita redundancia (año ya está en metadatos)
- Facilita referencias cortas (ADR-056 vs ADR_2025_056)
- Estándar más común en industria

**Acción**: Renombrar todos los ADR_2025_XXX a ADR-XXX

---

### 2. Ubicación de ADRs
**Decisión**: TODOS centralizados en `docs/gobernanza/adr/`

**Razón**:
- Single source of truth
- Más fácil mantener índice único
- Coherente con principio de gobernanza transversal
- ADRs son decisiones arquitectónicas, no código de dominio
- Facilita auditorías y búsquedas

**Acción**: Mover 22 ADRs dispersos a ubicación canónica

---

### 3. Manejo de Duplicados
**Decisión**: Mantener versión más completa/reciente

**Proceso**:
1. Comparar contenido de duplicados
2. Identificar versión con más información
3. Verificar fecha más reciente en metadatos
4. Mantener versión óptima
5. Eliminar duplicados

**Acción**: Consolidar duplicados caso por caso

---

### 4. Estrategia de Renumeración
**Decisión**: Mantener números existentes, solo resolver conflictos

**Razón**:
- Preserva referencias existentes en documentos externos
- Minimiza impacto en git history
- Menos cambios = menos riesgo
- Solo renumerar donde hay conflictos reales

**Casos específicos**:
- ADR-056 duplicado → Renumerar nuevo a ADR-058
- ADR_2025_XXX → Convertir a ADR-XXX manteniendo número base
- Verificar no hay colisiones ADR-012 (dos versiones diferentes)

**Acción**: Renumeración selectiva, no masiva

---

### 5. Formato de Descripción
**Decisión**: `kebab-case` (con-guiones)

**Razón**:
- Más estándar en web y documentación
- Mejor legibilidad en URLs
- Consistente con convenciones modernas
- Facilita parsing automático

**Ejemplo**: `ADR-058-ai-agents-standalone-architecture.md`

**Acción**: Estandarizar todos los nombres de archivo

---

## Implementación

### Orden de Ejecución
1. Resolver ADR-056 duplicado (inmediato)
2. Mover ADRs a ubicación canónica
3. Renombrar a convención estándar
4. Consolidar duplicados
5. Reconstruir índice
6. Validar referencias

### Scripts a Utilizar
- `git mv` para preservar historial
- Script automatizado para renombres masivos
- Validación automática post-cambios

### Validación
- ✅ No references rotas
- ✅ Todos los ADRs en docs/gobernanza/adr/
- ✅ Formato consistente ADR-XXX-kebab-case.md
- ✅ Índice refleja realidad (59 ADRs)
- ✅ Sin duplicados

---

## Próximos Pasos

1. Ejecutar Fase 1 (CRÍTICO) - 8-12 horas
2. Ejecutar Fase 2 (ALTO) - 16-24 horas
3. Validación completa
4. Commit y push

---

**Responsable**: AI Agent (con aprobación implícita de continuar)
**Inicio ejecución**: 2025-11-16
**Estado**: En progreso
