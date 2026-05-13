---
id: DOC-SOL-SC02-ENTREGABLES
estado: en_progreso
propietario: equipo-backend
ultima_actualizacion: 2025-11-04
relacionados: ["DOC-SOL-SC02"]
---
# SC02 - Entregables

Esta carpeta contiene los borradores y versiones de trabajo de la documentación de la API antes de su publicación final en `docs/implementacion/backend/`.

## Estructura

```
entregables/
├── readme.md                    (este archivo)
├── fase1_apps_criticas/
│   ├── api_etl_borrador.md
│   ├── api_analytics_borrador.md
│   └── api_reports_borrador.md
├── fase2_apps_soporte/
│   ├── api_dashboard_borrador.md
│   ├── api_authentication_borrador.md
│   ├── api_users_borrador.md
│   └── api_audit_borrador.md
├── fase3_apps_integracion/
│   ├── api_ivr_legacy_borrador.md
│   ├── api_notifications_borrador.md
│   └── api_common_borrador.md
└── transversal/
    ├── arquitectura_apps_borrador.md
    ├── modelos_datos_borrador.md
    ├── guia_desarrollo_borrador.md
    └── guia_testing_borrador.md
```

## Proceso de trabajo

1. **Borrador inicial**: Se crea en esta carpeta usando las plantillas
2. **Revisión técnica**: El equipo revisa y comenta
3. **Iteración**: Se incorporan cambios y mejoras
4. **Revisión editorial**: QA documental verifica formato y estándares
5. **Publicación**: Se copia a `docs/implementacion/backend/` y se actualiza índice
6. **Archivo**: El borrador se mantiene aquí para referencia histórica

## Estado de entregables

| Entregable | Fase | Estado | Responsable | Última actualización |
| --- | --- | --- | --- | --- |
| api_etl_borrador.md | 1 | ⏸️ Pendiente | - | - |
| api_analytics_borrador.md | 1 | ⏸️ Pendiente | - | - |
| api_reports_borrador.md | 1 | ⏸️ Pendiente | - | - |
| api_dashboard_borrador.md | 2 | ⏸️ Pendiente | - | - |
| api_authentication_borrador.md | 2 | ⏸️ Pendiente | - | - |
| api_users_borrador.md | 2 | ⏸️ Pendiente | - | - |
| api_audit_borrador.md | 2 | ⏸️ Pendiente | - | - |
| api_ivr_legacy_borrador.md | 3 | ⏸️ Pendiente | - | - |
| api_notifications_borrador.md | 3 | ⏸️ Pendiente | - | - |
| api_common_borrador.md | 3 | ⏸️ Pendiente | - | - |
| arquitectura_apps_borrador.md | Trans | ⏸️ Pendiente | - | - |
| modelos_datos_borrador.md | Trans | ⏸️ Pendiente | - | - |
| guia_desarrollo_borrador.md | Trans | ⏸️ Pendiente | - | - |
| guia_testing_borrador.md | Trans | ⏸️ Pendiente | - | - |

## Convenciones

- Todos los borradores usan sufijo `_borrador.md`
- Seguir plantillas de `docs/plantillas/`
- Incluir front matter completo
- Usar enlaces relativos
- Incluir diagramas cuando aplique

## Referencias

- [Solicitud SC02](../readme.md)
- [Alcance](../alcance.md)
- [Checklist](../checklist.md)
- [Plantillas](../../plantillas/)
