# Datos reales Q1 2025 — Clasificación de cDID_Centro_Transferencia

**Fuente:** Resultado de script de análisis sobre `tbl_historico_t1_2025`
**Trimestre:** Q01_25 (2025-01-01 a 2025-03-31)
**Total registros confirmado:** 11,643,679

---

## clasificacion_cDID_Centro_Transferencia.csv

Clasificación completa del campo `cDID_Centro_Transferencia` por longitud
de caracteres. Este es el campo más crítico del ETL — su normalización
determina qué se almacena como `centro_transferencia` en `base_ivr_detalle`.

### Distribución real Q1 2025

| Clasificación | Long. | Registros | % | Comportamiento en el ETL |
|---|---|---|---|---|
| `CASO_VACIO` | 0 | 1,514 | 0.01% | → `'CASO_NULL'` (NULL o vacío) |
| `CONFIGURACION_FIJA_6_DIG` | 6 | 6 | 0.00% | → pasa tal cual (VDN de 6 dígitos) |
| `CONFIGURACION_FIJA_8_DIG` | 8 | 9,568,639 | **82.18%** | → pasa tal cual (VDN de 8 dígitos) |
| `CASO_CLIENTE_COLGO` | 13 | 1,408,555 | **12.10%** | → `'CLIENTE_COLGO'` (string literal de 13 chars) |
| `POSIBLE_EMBEBIDO_16_DIG` | 16 | 39,951 | 0.34% | → NK90: `LEFT(campo, 6)` — VDN de 6 dígitos |
| `POSIBLE_EMBEBIDO_17_DIG` | 17 | 620,730 | **5.33%** | → NK90: `LEFT(campo, 7)` — VDN de 7 dígitos |
| `POSIBLE_EMBEBIDO_24_DIG` | 24 | 1 | 0.00% | → NK90: `LEFT(campo, 14)` — VDN de 14 dígitos |
| `POSIBLE_EMBEBIDO_25_DIG` | 25 | 4,283 | 0.04% | → NK90: `LEFT(campo, 15)` — VDN de 15 dígitos |

---

## Hallazgos críticos que impactan el diseño del ETL

### 1. El VDN dominante es de 8 dígitos, no 7

El análisis previo usaba `'1309004'` (7 dígitos) como VDN de ejemplo.
Los datos reales muestran que el 82.18% de los registros tiene VDN de
**8 dígitos** (CONFIGURACION_FIJA_8_DIG). El ejemplo `'15070013'`
documentado en los WPs (8 dígitos) es el caso representativo real,
no `'1309004'` (7 dígitos).

### 2. El caso NK90 más frecuente es 17 dígitos (7 VDN + 10 teléfono)

Los 620,730 registros de 17 dígitos representan el formato NK90 principal:
`VDN de 7 dígitos + cTelefono_Digitado de 10 dígitos`.
El segundo caso NK90 (16 dígitos = 6 VDN + 10 teléfono) es mucho menor
(39,951 registros).

La regla `LENGTH > 10 → LEFT(campo, LENGTH - 10)` cubre correctamente
todos los casos NK90 sin importar la longitud del VDN.

### 3. CASO_CLIENTE_COLGO: el campo contiene el string literal 'cliente_colgo'

'cliente_colgo' tiene 13 caracteres. El CASE de normalización lo detecta
antes de la regla NK90 porque coincide con el string exacto:

```sql
WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
```

Si esta condición no estuviera, la regla NK90 (`LENGTH > 10`) intentaría
extraer `LEFT('cliente_colgo', 3)` = `'cli'` — un VDN inválido.
El orden de las condiciones en el CASE es crítico.

### 4. Casos extremos: 24 y 25 dígitos

Solo 4,284 registros combinados (0.04%). Probablemente son errores del
sistema IVR donde concatenó más información de la esperada. La regla
`LEFT(campo, LENGTH - 10)` los normaliza pero produce VDNs de 14-15
dígitos que no corresponden a ningún centro conocido. Candidatos a
`'FORMATO_ESPECIAL'` o a análisis adicional.

### 5. Volumen total confirmado: 11,643,679 registros en Q1 2025

Consistente con la estimación de "~11-14M filas por quarter" documentada
en los WPs. El ETL procesa este volumen en un full table scan nocturno.

---

## Resumen de grupos para el CASE de normalización

```
Cobertura por grupo:
  Formato directo (len <= 10):   9,568,645 registros  →  82.18%
  CASO_CLIENTE_COLGO (len = 13): 1,408,555 registros  →  12.10%
  Formato NK90 (len > 10):         664,965 registros  →   5.71%
  CASO_VACIO (len = 0 / NULL):       1,514 registros  →   0.01%
  TOTAL:                        11,643,679 registros  → 100.00%
```

El CASE en el ETL debe mantener este orden para evitar colisiones:

```sql
CASE
    WHEN TRIM(cDID_Centro_Transferencia) IS NULL
      OR TRIM(cDID_Centro_Transferencia) = ''     THEN 'CASO_NULL'
    WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
    WHEN cDID_Centro_Transferencia REGEXP '^0+$'  THEN 'CASO_ERROR_CEROS'
    WHEN LENGTH(cDID_Centro_Transferencia) > 10
        THEN LEFT(cDID_Centro_Transferencia,
                  LENGTH(cDID_Centro_Transferencia) - 10)
    ELSE cDID_Centro_Transferencia
END
```

