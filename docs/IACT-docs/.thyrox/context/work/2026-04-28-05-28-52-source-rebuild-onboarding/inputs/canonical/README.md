---
title: Documentación IACT (estado consolidado)
date: 2025-11-13
domain: general
status: active
---

# Documentación IACT (estado consolidado)

> Actualización: 2025-11-12

La reorganización anunciada como “estructura v4.0” no se completó. Este README describe la estructura **real** del repositorio para evitar confusiones.

## Cómo está organizada la documentación

```
IACT---project/
├── docs/
│   ├── index.md               ← Índice consolidado
│   ├── README.md              ← Este archivo
│   ├── agents/                ← AI Agents Framework (v1.0.0) - NUEVO
│   ├── gobernanza/            ← Políticas, procesos y guías de estilo
│   ├── infrastructure/        ← Manuales y cambios de infraestructura (ej. CPython)
│   ├── operaciones/           ← Runbooks vigentes
│   ├── qa/                    ← Guías de aseguramiento de calidad
│   ├── specs/                 ← Especificaciones activas
│   ├── plans/                 ← Planes de trabajo y seguimiento
│   ├── analisis/              ← Informes y reportes recientes
│   ├── backend_analisis/      ← Resultados detallados de evaluaciones backend
│   └── scripts/               ← Documentación de scripts existentes
├── scripts/                   ← Scripts reales (CI, validaciones, infraestructura)
├── infrastructure/            ← Herramientas de soporte (incluye CPython builder)
├── logs_data/                 ← Artefactos JSON generados manualmente
└── respaldo/docs_legacy/      ← Documentación histórica archivada
```

## Puntos de entrada recomendados
- [Índice consolidado](index.md)
- **[AI Agents Framework v1.0.0](agents/README.md)** ← Framework de agentes IA (NUEVO)
  - [Ejemplos](agents/EXAMPLES.md) - 17 ejemplos ejecutables
  - [Referencia API](agents/API_REFERENCE.md) - API completa
  - [Guía de integración](agents/INTEGRATION.md) - Django, FastAPI, CLI, LLM
  - [Arquitectura](agents/ARCHITECTURE.md) - Diagramas y patrones
  - [Índice completo](agents/DOCUMENTATION_INDEX.md) - Navegación completa
- [Plan de remediación actual](plans/REV_20251112_remediation_plan.md)
- [Manual de infraestructura](infrastructure/README.md)
- [Runbooks operativos](operaciones/)
- [Documentación de scripts](scripts/README.md)

## Qué hacer con la documentación antigua
- Todo lo anterior a noviembre de 2025 vive en [`../respaldo/docs_legacy/`](../respaldo/docs_legacy/README.md).
- Si necesitas reactivar un documento, muévelo a la ubicación activa adecuada y actualiza este README.

## Reglas de contribución
- Mantén actualizados los índices mínimos: `docs/index.md`, `docs/scripts/README.md` y cualquier plan activo.
- Añade notas explícitas cuando un documento describa una funcionalidad todavía no implementada.
- Para cambios estructurales mayores, acompaña la modificación con un ADR o con una actualización del plan de remediación.
