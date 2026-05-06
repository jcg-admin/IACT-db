# Scripts de investigación / exploración

Scripts que documentan el proceso de descubrimiento — no son reportes
de producción sino análisis ad-hoc que generaron el conocimiento
técnico que hoy sustenta el diseño del ETL y los SPs.

---

## Directorios

| Directorio | Script | Qué documenta |
|---|---|---|
| `nk90-descubrimiento/` | `qCentros_de_transferencia_ID.sql` | Proceso de descubrimiento del formato NK90 en `cDID_Centro_Transferencia` |
| `catalogo-menus-trimestral/` | `REPTRIM001-A1.sql` | Análisis de qué menús existen en cada trimestre (matriz presencia/ausencia) |
| `tabla-temporal-analisis/` | `REPTRIM001-WS.sql` | Script de workbench — crea tabla temporal para análisis combinado de quarters |

---

## Por qué se conservan estos scripts

No mapean a los 7 SPs de producción pero son valiosos como referencia:
- Documentan el razonamiento detrás de las decisiones de diseño
- Evidencian los bugs y edge cases descubiertos en el proceso
- Proveen contexto cuando surjan preguntas sobre el comportamiento del sistema

