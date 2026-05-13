---
title: Reorganizacion de Documentacion IACT usando Modelo TFG-Server
date: 2025-11-13
proyecto: IACT---project
modelo_referencia: TFG-server
status: planning
---

# Reorganizacion de Documentacion IACT - Modelo TFG-Server

**Objetivo**: Adoptar la estructura de documentacion de TFG-Server en IACT---project para mejor organizacion y escalabilidad.

**Fecha**: 2025-11-13

---

## 1. Estructura Objetivo (Basada en TFG-Server)

```
IACT---project/docs/
├── README.md                    # Indice principal (NUEVO - crear)
│
├── analisis/                    # Requisitos y analisis de negocio
│   ├── README.md
│   ├── brs/                    # Business Requirements
│   ├── strs/                   # Stakeholder Requirements
│   ├── syrs/                   # System Requirements
│   └── srs/                    # Software Requirements
│
├── diseno_solucion/            # Arquitectura y diseno
│   ├── README.md
│   ├── arquitectura_empresarial/
│   ├── arquitectura_sistemas/
│   │   └── adr/               # Architecture Decision Records (MOVER AQUI)
│   └── diseno_detallado/
│       ├── backend/
│       └── frontend/
│
├── devops/                     # Automatizacion y CI/CD (NUEVO)
│   ├── README.md
│   ├── git/                    # Guias Git (YA CREADAS)
│   │   ├── README.md
│   │   ├── nivel_1_basico/
│   │   ├── nivel_2_intermedio/
│   │   └── nivel_3_avanzado/
│   └── operaciones/            # Otras operaciones (MOVER DESDE docs/operaciones/)
│
└── anexos/                     # Material complementario (NUEVO)
    ├── README.md
    ├── glosario.md
    └── referencias/
```

---

## 2. Mapeo de Contenido Existente

### 2.1 Que Existe Actualmente en IACT

```bash
# Ejecutar en IACT---project para ver estructura actual
find docs -type d -maxdepth 3 | head -30
```

**Estructura Actual Conocida**:
- docs/gobernanza/ - ADRs y governance
- docs/ai/agent/ - Documentacion de agentes AI
- docs/backend/ - Docs de backend
- docs/frontend/ - Docs de frontend
- docs/infraestructura/ - Docs de infra
- docs/operaciones/ - Operaciones (incluye git/)
- docs/sesiones/ - Sesiones de trabajo

### 2.2 Mapeo Propuesto

| Ubicacion Actual | Ubicacion Nueva (Modelo TFG) | Accion |
|------------------|------------------------------|--------|
| docs/gobernanza/ADR_* | docs/diseno_solucion/arquitectura_sistemas/adr/ | MOVER |
| docs/gobernanza/INDICE_ADRs.md | docs/diseno_solucion/arquitectura_sistemas/adr/README.md | MOVER/RENOMBRAR |
| docs/ai/agent/ | docs/diseno_solucion/diseno_detallado/ai/ | MOVER |
| docs/backend/ | docs/diseno_solucion/diseno_detallado/backend/ | MOVER |
| docs/frontend/ | docs/diseno_solucion/diseno_detallado/frontend/ | MOVER |
| docs/infraestructura/ | docs/diseno_solucion/arquitectura_sistemas/infraestructura/ | MOVER |
| docs/devops/git/ | docs/devops/git/ | MOVER |
| docs/operaciones/* (otros) | docs/devops/operaciones/ | MOVER |
| docs/sesiones/ | docs/anexos/sesiones/ | MOVER |

**Documentos de Gobernanza/Reportes**:
- REPORTE_VALIDACION_COMPLETA.md → docs/anexos/reportes/
- VALIDACION_CONFORMIDAD_GOBERNANZA.md → docs/anexos/reportes/

---

## 3. Plan de Ejecucion

### OPCION A: Reorganizacion Completa (GRANDE - 1 semana)

**Alcance**: Reorganizar toda la estructura docs/ siguiendo modelo TFG-Server

**Pasos**:
1. Crear nueva estructura de carpetas (analisis, diseno_solucion, devops, anexos)
2. Mover todos los documentos segun mapeo
3. Actualizar todas las referencias internas (links)
4. Crear README.md principal estilo TFG-Server
5. Crear README.md en cada seccion
6. Validar todos los links
7. Commit y push

**Esfuerzo**: 20-30 horas
**Riesgo**: Alto (muchos links rotos potenciales)
**Beneficio**: Estructura completamente profesional

---

### OPCION B: Reorganizacion Incremental (RECOMENDADA - 2-3 dias)

**Alcance**: Reorganizar en fases, empezando con lo mas critico

**FASE 1** (2 horas):
1. Crear estructura base de carpetas (analisis/, diseno_solucion/, devops/, anexos/)
2. Crear README.md principal simple
3. Crear README.md en devops/
4. Mover docs/devops/git/ → docs/devops/git/
5. Validar links en guias Git
6. Commit Fase 1

**FASE 2** (3 horas):
1. Mover ADRs: docs/gobernanza/ADR_* → docs/diseno_solucion/arquitectura_sistemas/adr/
2. Actualizar referencias a ADRs en otros documentos
3. Crear docs/diseno_solucion/README.md
4. Commit Fase 2

**FASE 3** (2 horas):
1. Mover docs de ai/backend/frontend a diseno_solucion/diseno_detallado/
2. Actualizar referencias
3. Commit Fase 3

**FASE 4** (1 hora):
1. Mover docs/sesiones/ a docs/anexos/sesiones/
2. Mover reportes a docs/anexos/reportes/
3. Crear docs/anexos/README.md
4. Commit Fase 4

**FASE 5** (1 hora):
1. Actualizar README.md principal con estructura completa
2. Validacion final de todos los links
3. Commit final

**Esfuerzo Total**: 9 horas (distribuidas en 2-3 dias)
**Riesgo**: Medio (controlado por fases)
**Beneficio**: Estructura profesional con menor riesgo

---

### OPCION C: Hibrida - Solo DevOps (MINIMA - 2 horas)

**Alcance**: Crear solo docs/devops/ y mover contenido relacionado

**Pasos**:
1. Crear docs/devops/
2. Crear docs/devops/README.md
3. Mover docs/devops/git/ → docs/devops/git/
4. Mover docs/operaciones/* (otros) → docs/devops/operaciones/
5. Actualizar referencias
6. Crear docs/README.md basico mencionando devops/
7. Commit

**Esfuerzo**: 2 horas
**Riesgo**: Bajo
**Beneficio**: Parcial (solo organiza devops, resto queda igual)

---

## 4. Recomendacion

**OPCION B - Reorganizacion Incremental** es la RECOMENDADA:

**Razones**:
1. Balance entre beneficio y riesgo
2. Permite validacion en cada fase
3. Si algo falla, facil rollback de una fase
4. Distribuible en varios dias (no requiere bloque continuo)
5. Estructura final identica a OPCION A pero con menos riesgo

**Inicio Recomendado**: FASE 1 (mover git/ a devops/)
- Ya tenemos docs/devops/git/ completo y validado
- Es contenido nuevo, minimo riesgo de romper referencias existentes
- Crea la base para el resto de reorganizacion

---

## 5. Actualizacion de Referencias

### 5.1 Referencias a ADRs

**Patron Actual**:
```markdown
Ver: docs/backend/ADR_2025_001_arquitectura.md
```

**Patron Nuevo**:
```markdown
Ver: docs/diseno_solucion/arquitectura_sistemas/adr/ADR_2025_001_arquitectura.md
```

**Herramienta para actualizar**:
```bash
# Buscar todas las referencias a ADR_ en docs/
grep -r "docs/backend/ADR_" docs/ --include="*.md"
grep -r "docs/frontend/ADR_" docs/ --include="*.md"
grep -r "docs/gobernanza/ADR_" docs/ --include="*.md"

# Para cada resultado, actualizar path con Edit tool
```

### 5.2 Referencias a Guias Git

**Patron Actual** (despues de reorganizacion inicial):
```markdown
Ver: docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
```

**Patron Nuevo**:
```markdown
Ver: docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
```

**Script de Actualizacion**:
```bash
find docs/ -name "*.md" -exec sed -i 's|docs/devops/git/|docs/devops/git/|g' {} \;
```

---

## 6. Beneficios de Adoptar Estructura TFG-Server

**Organizacion**:
- Separacion clara: Analisis / Diseno / DevOps / Anexos
- Escalable: Facil agregar nuevo contenido
- Profesional: Sigue estandares de industria

**Navegacion**:
- README.md principal como indice
- README.md en cada seccion para navegacion local
- Estructura predecible

**Mantenimiento**:
- Claro donde va cada tipo de documento
- Facil para nuevos contribuidores
- Consistente con TFG-Server (conocimiento transferible)

**Integracion**:
- Guias Git encajan naturalmente en devops/
- ADRs agrupados logicamente en arquitectura_sistemas/
- Docs de agentes AI en diseno_detallado/ai/

---

## 7. Riesgos y Mitigaciones

### Riesgo 1: Links Rotos

**Probabilidad**: Alta
**Impacto**: Medio

**Mitigacion**:
- Usar git mv (preserva historia)
- Actualizar referencias sistematicamente (grep + sed)
- Validar en cada fase
- Herramienta: markdown-link-check (si disponible)

### Riesgo 2: Confusion Durante Transicion

**Probabilidad**: Media
**Impacto**: Bajo

**Mitigacion**:
- Comunicar reorganizacion al equipo
- Dejar README.md con links en ubicaciones antiguas (temporalmente)
- Hacer en branch separado, merge solo cuando completo

### Riesgo 3: Git History Confusion

**Probabilidad**: Baja
**Impacto**: Bajo

**Mitigacion**:
- Usar git mv en lugar de rm + add
- Commits descriptivos por fase
- Mantener estructura dentro de subdirectorios (historia preserved)

---

## 8. Proximos Pasos

### Inmediato (Esta Sesion):

1. Decidir opcion (A, B, o C)
2. Si OPCION B: Ejecutar FASE 1
   - Crear docs/devops/
   - Mover git/ a devops/git/
   - Crear README.md principal simple
   - Commit

### Corto Plazo (Proxima Sesion):

1. Si se ejecuto FASE 1: Continuar con FASE 2-5
2. Validacion completa
3. Actualizacion de PR_DESCRIPTION.md con reorganizacion

### Largo Plazo:

1. Mantener estructura consistente
2. Agregar contenido a docs/analisis/ cuando se haga analisis de requisitos
3. Documentar decisiones en ADRs en ubicacion estandarizada

---

**Status**: PLAN COMPLETO - ESPERANDO DECISION
**Opciones**: A (Completa), B (Incremental - RECOMENDADA), C (Minima)
**Proximo Paso**: Decidir opcion y ejecutar
**Esfuerzo Estimado OPCION B**: 9 horas distribuidas en 2-3 dias
