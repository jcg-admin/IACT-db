# Referencias de producción

Artefactos reales del sistema IVR en producción que sirven como fuente
de verdad para el diseño e implementación de los Stored Procedures.

## Contenido

| Directorio | Descripción |
|---|---|
| `scripts-sql/` | Scripts SQL de análisis ad-hoc usados actualmente |

## Propósito

Los scripts de referencia documentan el comportamiento exacto que los
SPs de producción deben replicar. Se organizan por reporte destino y
se versionan tal como fueron recibidos del equipo.

Cada script tiene un `README.md` que documenta:
- Qué hace el script
- Columnas del resultado
- Problemas identificados que el SP debe corregir
- Diferencias entre el script ad-hoc y el SP de producción
