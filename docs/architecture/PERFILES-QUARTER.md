# Perfiles de quarter — Arquitectura de poblar_historico.py

**Fecha:** 2026-05-06

---

## Propósito

Los datos del sistema IVR no son estáticos entre trimestres. El catálogo de
menús crece cada quarter y los VDNs de destino cambian cuando el cliente
reconfigura su infraestructura de enrutamiento. Un solo conjunto de
parámetros no puede representar fielmente los seis quarters que cubren
las tablas `tbl_historico_*`.

Los perfiles de quarter resuelven esto: cada perfil define la distribución
de menús y los VDNs de destino que corresponden a ese trimestre específico,
acumulando los cambios de los quarters anteriores.

---

## Estructura de archivos

```
provisioners/mariadb/
    poblar_historico.py          motor de generación (lógica pura)
    perfiles/
        __init__.py              PERFILES dict — punto de entrada
        q01_2025.py              BASE: Q01 2025
        q02_2025.py              ACUMULADO: Q01 + cambios Q02
        q03_2025.py              ACUMULADO: Q01 + Q02 + cambios Q03
        q04_2025.py              PROXY → q03_2025
        q01_2026.py              PROXY → q01_2025
        q02_2026.py              PROXY → q02_2025 (escala parcial)
```

---

## Modelo de acumulación

Cada perfil hereda del anterior e incorpora lo nuevo. Nunca duplica
lógica — si Q02 no cambia un VDN, no lo redeclara.

```
q01_2025 ──→ q02_2025 ──→ q03_2025
                │                └──→ q04_2025  (proxy — sin datos reales)
                └──→ q02_2026    (proxy — escala parcial 36/91 días)
q01_2025 ──→ q01_2026            (proxy — sin datos reales)
```

### Herencia en Python

```python
# q02_2025.py
from perfiles.q01_2025 import VDN_POR_MENU as VDN_Q01

VDN_POR_MENU = {
    **VDN_Q01,                          # hereda todo de Q01
    'NOTMX-CONT-Portabilidad': [...],   # sobreescribe solo lo que cambia
    'RES_FALLA_STOP':          [...],   # añade VDNs de menús nuevos
}
```

```python
# q04_2025.py (proxy — sin cambios propios)
from perfiles.q03_2025 import MENUS, VDN_POR_MENU  # referencia directa

CONFIG = { 'escala': 0.993, ... }  # solo CONFIG es propio
```

---

## Qué define cada perfil

Cada `q*.py` expone tres objetos:

| Objeto | Tipo | Descripción |
|---|---|---|
| `CONFIG` | dict | tabla, fechas, escala, error_ceros |
| `MENUS` | list | distribución de menús con probabilidades acumuladas |
| `VDN_POR_MENU` | dict | VDN dominante por menú (acumulado de quarters anteriores) |

### CONFIG

```python
CONFIG = {
    'tabla':       'tbl_historico_t2_2025',
    'quarter':     'Q02_25',
    'fecha_ini':   date(2025, 4, 1),
    'fecha_fin':   date(2025, 6, 30),
    'escala':      1.169,    # factor vs Q01 (base). Q02 es el pico del año.
    'error_ceros': True,     # CASO_ERROR_CEROS activo desde Q02 en Puebla
}
```

### MENUS

Lista de tuplas `(nombre_raw, cum, opciones)`. El campo `nombre_raw`
contiene el valor tal como está en `tbl_historico_*` — mixed case, sin
`UPPER()`. Los SPs de reporte aplican su propia normalización.

### VDN_POR_MENU

Mapeo `cMenu → VDN de destino dominante`. El motor usa este mapeo para
asignar `cDID_Centro_Transferencia`. Si un menú no está en el mapa,
el motor usa un pool de VDNs frecuentes como fallback.

---

## Factores de escala por quarter

El parámetro `--rows N` del motor es siempre relativo a Q01_2025 (base).
Cada quarter se escala automáticamente:

| Quarter | Escala | Fuente | Con --rows 50000 |
|---|---|---|---|
| Q01_25 | 1.000 | Real: 11,643,679 | 50,000 |
| Q02_25 | 1.169 | Real: 13,612,375 | 58,450 |
| Q03_25 | 0.986 | Real: 11,482,117 | 49,300 |
| Q04_25 | 0.993 | Estimado: prom(Q01,Q03) | 49,650 |
| Q01_26 | 1.000 | Proxy Q01_25 | 50,000 |
| Q02_26 | 0.462 | Q02_25 × 36/91 días | 23,100 |

---

## Menús que aparecen en cada quarter

### Solo Q01_2025 (ausentes en Q01, añadidos en Q02+)

| Menú | Desde | % en su quarter |
|---|---|---|
| `RES_FALLA_STOP` | Q02 | 6.3% Q02, 9.1% Q03 |
| `MASI_RepiteBoleta` | Q02 | 0.81% |
| `NoTMX_SinOp` | Q02 | 1.40% |
| `RES-ContratacionInfinitum_FM` | Q02 | 0.57% |
| `Tmx_SOMO` | Q02 | 0.17% (solo Puebla) |
| `ANI` | Q02 (Puebla) / Q03 (Nacional) | 0.05% |
| `Numero Telmex` | Q02 (Puebla) / Q03 (Nacional) | 0.40% |
| `RES-SaldosPagos_FM` | Q02 | 0.09% |
| `KIPSOLCOM` | Q03 | 0.34% |
| `SaldoCabecera` | Q03 | Puebla |
| `Saldos1_Pagar` | Q03 | 0.03% |
| `Saldos3_Otra` | Q03 | 0.03% |
| `MenuSaldosCabecera` | Q03 | Puebla |

### VDNs que cambian entre quarters

| Menú | Q01 | Q02 | Q03 | Impacto |
|---|---|---|---|---|
| `NOTMX-SeguimientoInstalacion` | `10728487` | `10728487` | **`19020088`** | 2° menú por volumen |
| `NOTMX-CONT-Portabilidad` | `10728485` | **`14929014`** | `14929014` | - |
| `Desborde_Cabecera` Nacional | `cliente_colgo` | **`10928253`** | `cliente_colgo` | oscila |
| `Desborde_Cabecera` Puebla | `10928253` | **`10428174`** | **`15070013`** | 3 VDNs distintos |
| `RES-ContratacionInfinitum` | `15070013` | **`15070012`** | **`15070006`** | migra progresivamente |
| `RES-FallaEntretiene` | `19020033` | `19020033` | **`10728381`** | - |
| `RES-Aparatos` | `15070007` | **`15070013`** | `15070007` | oscila |
| `RES_Otros` | `15070002` | `15070002` | **`15070012`** | - |

---

## Proxies — cuándo usar q03 como base

Los quarters sin datos reales (Q04_2025, Q01_2026, Q02_2026) usan el
perfil del quarter real más cercano como referencia:

- `q04_2025` → usa `q03_2025` porque es el último quarter con datos
- `q01_2026` → usa `q01_2025` porque el ciclo anual reinicia en Q1
- `q02_2026` → usa `q02_2025` porque es el mismo quarter un año después

Cuando existan datos reales de Q04_2025 o Q01_2026, se crean perfiles
propios que sobreescriban solo las diferencias observadas.

---

## Condiciones de calidad de datos

Las siguientes condiciones son constantes en todos los quarters —
pertenecen al sistema IVR del cliente, no al calendario:

| Condición | Valor | Referencia |
|---|---|---|
| `dHoraInicio > dHoraFin` (G-29) | 38.8% | TBL-HISTORICO-ANOMALIAS.md |
| `cTelefono_Digitado IS NULL` | 21.2% | BR-CLIENT-001 |
| `Digitado = Origen` (misma_linea) | 28.2% | BR-CLIENT-001 |
| NK90 len_17 | 5.3% | BR-ROUTING-001 |
| NK90 len_16 | 0.3% | BR-ROUTING-001 |
| `CASO_NULL` en cDID_Centro | 1.3% | TBL-HISTORICO-ANOMALIAS.md |
| `CLIENTE_COLGO` en cDID_Centro | 27.4% | TBL-HISTORICO-ANOMALIAS.md |

La única condición quarter-dependiente:

| Condición | Q01_25 | Q02_25+ |
|---|---|---|
| `CASO_ERROR_CEROS` (Puebla) | No | 3% de Puebla |

---

## Agregar un nuevo quarter

Cuando haya datos reales de Q04_2025:

```python
# perfiles/q04_2025.py — reemplazar el proxy
from datetime import date
from perfiles.q03_2025 import VDN_POR_MENU as VDN_Q03

CONFIG = {
    'tabla': 'tbl_historico_t4_2025',
    'quarter': 'Q04_25',
    'fecha_ini': date(2025, 10, 1),
    'fecha_fin': date(2025, 12, 31),
    'escala': X.XXX,      # valor real
    'error_ceros': True,
}

MENUS = [...]             # distribución real Q04

VDN_POR_MENU = {
    **VDN_Q03,            # hereda Q03
    'menu_X': [...],      # solo los que cambian en Q04
}
```

Registrar en `__init__.py` y el motor lo usará automáticamente.

---

## Ver también

- `TBL-HISTORICO-ANOMALIAS.md` — condiciones de calidad de datos
- `REPORTE-C-MENU.md` — fuente de los VDNs por menú
- `REPORTE-PROM-LLAMADAS.md` — fuente de las proporciones de menús
- `MAPEO-DID-SEGMENTOS.md` — DIDs de entrada y etiquetas de segmento
- `provisioners/mariadb/poblar_historico.py` — motor de generación
- `provisioners/mariadb/perfiles/` — perfiles de quarter

