# DID_Centro_Transferencia_v0.3.1.xlsx — Datos reales Q1-Q3 2025

**Origen:** Script `v0.3.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql` ejecutado sobre producción
**Cobertura:** Q01_25, Q02_25, Q03_25 — segmentos Nacional y Puebla
**Archivo CSV:** `DID_Centro_Transferencia_v0.3.1.csv`
**Filas:** 841 combinaciones (trimestre, segmento, centro, menu, opcion)
**Total llamadas:** 36,738,171 (Q1+Q2+Q3 2025, ambos segmentos)

---

## Estructura de columnas (confirmadas desde el script v0.3.1)

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR | Q01_25, Q02_25, Q03_25 |
| `segmento` | VARCHAR | Nacional, Puebla |
| `centro_transferencia` | VARCHAR | VDN normalizado o sentinel |
| `menu` | VARCHAR | cMenu normalizado |
| `opcion` | VARCHAR | cOpcion o SIN_OPCION |
| `total_llamadas` | INT | COUNT(*) por combinación |
| `porcentaje` | DECIMAL | % sobre el total del trimestre+segmento |
| `misma_linea` | INT | cTelefono_Origen = cTelefono_Digitado |
| `linea_diferente` | INT | cTelefono_Origen ≠ cTelefono_Digitado |
| `no_digito_telefono` | INT | cTelefono_Digitado IS NULL |

---

## Top 5 centros por trimestre

### Q1 2025 (total: 11,643,679)
| Centro | Llamadas | % |
|---|---|---|
| 19020086 | 3,591,868 | 30.8% |
| CLIENTE_COLGO | 1,408,555 | 12.1% |
| 10828091 | 1,157,261 | 9.9% |
| 10728487 | 1,153,873 | 9.9% |
| 1309004 | 583,384 | 5.0% |

### Q2 2025 (total: 13,612,375)
| Centro | Llamadas | % |
|---|---|---|
| 19020086 | 4,055,378 | 29.8% |
| CLIENTE_COLGO | 1,820,525 | 13.4% |
| 19010000 | 1,297,603 | 9.5% |
| 10828091 | 764,065 | 5.6% |
| 19020088 | 747,175 | 5.5% |

### Q3 2025 (total: 11,482,117)
| Centro | Llamadas | % |
|---|---|---|
| 19020086 | 3,233,933 | 28.2% |
| CLIENTE_COLGO | 1,535,034 | 13.4% |
| 19010000 | 1,376,945 | 12.0% |
| 19020088 | 1,147,353 | 10.0% |
| 10928253 | 886,032 | 7.7% |

---

## Hallazgos críticos

### 1. CLIENTE_COLGO es un VDN normalizado distinto de 19020086

En los datos del Excel aparece `CLIENTE_COLGO` como un centro propio con
1.4-1.8M llamadas por trimestre. No es el mismo que 19020086 (que recibe
`cliente_colgo` como menu). Son dos cosas distintas:

- `centro = CLIENTE_COLGO` → el campo `cDID_Centro_Transferencia` tenía
  el valor literal `'cliente_colgo'` → el ETL lo normaliza a `'CLIENTE_COLGO'`
- `centro = 19020086` → el campo tenía un VDN real; el menu es `cliente_colgo`

Esto confirma que la normalización del CASE en el ETL funciona correctamente
y que hay ~1.5M llamadas/trimestre donde el cliente colgó antes de que el
sistema asignara cualquier centro.

### 2. Centro 19020088 aparece en Q2 y Q3 pero no en Q1

Un VDN nuevo que surge en Q2 2025 con 747K llamadas y crece a 1.1M en Q3.
No documentado en análisis anteriores. Confirmar con el equipo qué servicio
representa.

### 3. El VDN 1309004 (7 dígitos) tiene 583K llamadas en Q1

Confirma que el VDN de 7 dígitos es real y significativo (~5% del quarter),
aunque el caso dominante sigue siendo 8 dígitos.

### 4. 96 VDNs distintos en Hoja2

La Hoja2 del Excel contiene el catálogo completo de 96 VDNs activos en
Q1-Q3 2025. Es la referencia para validar los resultados del ETL.

