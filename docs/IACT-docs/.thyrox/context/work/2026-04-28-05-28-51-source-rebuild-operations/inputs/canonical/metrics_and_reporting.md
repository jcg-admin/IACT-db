---
title: Métricas y reporting
date: 2025-11-13
domain: general
status: active
---

# Métricas y reporting

Actualmente no existe un script automatizado para generar métricas DORA o reportes de despliegue. Los JSON en `logs_data/` se mantienen de forma manual.

## Procedimiento manual recomendado
1. Recopila la información necesaria (deployments, incidentes, métricas de ciclo) y actualiza los archivos JSON ubicados en `logs_data/`.
2. Documenta la fecha y el origen de los datos dentro del propio JSON o en un README de acompañamiento.
3. Si necesitas un reporte estructurado, genera un documento en `docs/analisis/` o `docs/backend_analisis/` describiendo la metodología aplicada.

## Próximos pasos sugeridos
- Definir requerimientos para un script `metrics` real antes de implementarlo.
- Crear pruebas unitarias que validen cualquier automatización futura.
- Documentar en este archivo la ubicación final de los reportes una vez que la automatización exista.
