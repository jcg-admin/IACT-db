# Diseño del Frontend - IACT

Diseño arquitectónico y diagramas específicos del dominio Frontend.

## Estructura

```
diseno/
├── arquitectura/                ← Decisiones arquitectónicas frontend
│   ├── componentes/            ← Arquitectura componentes React
│   ├── estado/                 ← Gestión estado (Redux)
│   └── routing/                ← Routing y navegación
└── diagramas/                   ← Diagramas UML frontend
    ├── componentes/            ← Jerarquía componentes
    ├── flujos/                 ← Flujos UX (Secuencia, Actividad)
    └── estado/                 ← Diagramas estado Redux
```

## Estado Actual

Según análisis 2025-01-17:

| Tipo Diagrama | Cantidad Actual | Objetivo | Gap |
|---------------|-----------------|----------|-----|
| **Diagramas Componentes** | 0 | ~5 | -5 |
| **Diagramas Flujos UX** | 0 | ~10 | -10 |
| **Diagramas Estado Redux** | 0 | ~5 | -5 |

## Prioridades de Diagramación

### Prioridad ALTA

1. **Diagramas Componentes React**
   - `COMP-FRONT-001-arquitectura-microfrontends.puml`: Vista general microfrontends
   - `COMP-FRONT-010-modulo-home.puml`: Componentes módulo home
   - `COMP-FRONT-020-modulo-llamadas.puml`: Componentes módulo llamadas
   - `COMP-FRONT-030-modulo-reportes.puml`: Componentes módulo reportes

2. **Diagramas Flujos UX**
   - `SEQ-FRONT-010-login-autenticacion.puml`: Flujo login
   - `SEQ-FRONT-020-dashboard-load.puml`: Carga dashboard
   - `ACT-FRONT-030-generar-reporte.puml`: Workflow generar reporte

3. **Diagramas Estado Redux**
   - `STATE-FRONT-001-app-state.puml`: Estado global aplicación
   - `STATE-FRONT-010-session-state.puml`: Estados sesión usuario

## Nomenclatura Diagramas

```
TIPO-FRONT-###-descripcion.puml

Tipos Frontend:
- COMP: Componentes React
- SEQ: Flujos UX (Secuencia)
- ACT: Workflows frontend
- STATE: Estados Redux/componentes

Ejemplos:
- COMP-FRONT-001-arquitectura-microfrontends.puml
- SEQ-FRONT-010-login-autenticacion.puml
```

## Referencias

- [GUIA-GOB-009: Documentación UML Completa](../../gobernanza/guias/GUIA-GOB-009-documentacion-uml-completa.md)
- [ADR-FRONT-002: Redux Toolkit](../gobernanza/adr/ADR-FRONT-002-redux-toolkit.md)
