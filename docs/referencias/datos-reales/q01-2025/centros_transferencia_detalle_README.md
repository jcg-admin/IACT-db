# Detalle de centros de transferencia — Q1 2025

**Fuente:** Resultado de script de análisis (origen: mariadb_analisis_transferencias_menu.sql o similar)
**Trimestre:** Q01_25 (2025-01-01 a 2025-03-31)
**Centros registrados:** 63 VDNs distintos
**Llamadas cubiertas:** 9,570,159 (82.19% del total — solo centros con VDN asignado)
**Registros sin centro asignado:** ~2,073,520 (CASO_NULL + CASO_CLIENTE_COLGO + NK90)

---

## Estructura de columnas

| Columna | Descripción |
|---|---|
| `trimestre` | Quarter del dato |
| `longitud_vdn` | Número de dígitos del VDN normalizado |
| `numero_enrutamiento` | VDN real (post-normalización NK90) |
| `total_llamadas` | Llamadas recibidas por ese centro en Q1 |
| `porcentaje_q1` | % sobre el total del quarter |
| `menus_distintos` | COUNT DISTINCT de menús que llegan a ese centro |
| `etiquetas_distintas` | COUNT DISTINCT de etiquetas de cliente |
| `col8` | Pendiente confirmar: posiblemente `combinaciones_distintas` o `zonas_geograficas` |
| `menus_lista` | Lista de menús (puede estar truncada) |
| `etiquetas_lista` | Lista de etiquetas/opciones (puede estar truncada) |
| `fecha_primera` | Primera llamada registrada en Q1 |
| `fecha_ultima` | Última llamada registrada en Q1 |

---

## Top 10 centros por volumen — Q1 2025

| VDN | Llamadas | % Q1 | Tipo |
|---|---|---|---|
| **19020086** | 3,591,868 | **37.54%** | Bucket de abandono — sin etiqueta |
| **10828091** | 1,157,261 | **12.09%** | Fallas de internet (principal) |
| **10728487** | 1,153,873 | **12.06%** | Seguimiento instalación |
| **15070013** | 547,016 | 5.72% | Multiservicio (6 menús distintos) |
| **10428174** | 440,285 | 4.60% | Desborde TELVICOBRA (cobranza) |
| **10928253** | 410,706 | 4.29% | Quejas + fallas (8 etiquetas) |
| **19010000** | 401,581 | 4.20% | Fallas de internet (secundario) |
| **15070059** | 298,542 | 3.12% | Contratación |
| **15070019** | 278,512 | 2.91% | Fallas + variantes 2024 |
| **10728000** | 129,568 | 1.35% | Fallas (5 etiquetas diagnóstico) |

---

## Hallazgos críticos

### 1. Centro 19020086 — el "bucket de abandono" (37.54%)

El centro más grande recibe llamadas con solo cuatro menús:
`cliente_colgo`, `Desborde_Promocional`, `Marque3`, `SinOpcion_Cabecera`.

La columna de etiquetas está vacía — no hay etiqueta de cliente. Esto
confirma que este VDN no corresponde a un agente o cola de atención real:
es el destino de llamadas que terminaron antes de ser transferidas.

**Implicación para el ETL:** las llamadas con `centro_transferencia = '19020086'`
son candidatas a clasificarse como abandono junto con CASO_NULL y CLIENTE_COLGO,
aunque técnicamente tienen un centro asignado. Confirmar con el equipo si
este VDN debe incluirse en la definición de abandono de `sp_rpt_llamadas_abandonadas`.

### 2. Los dos centros de ~12% son fallas e instalaciones

`10828091` (RES-FallaInternet) y `10728487` (NOTMX-SeguimientoInstalacion)
concentran juntos el 24.15% del volumen. Son los centros de atención de
servicio más demandados de la operación.

### 3. Centro 15070013 — el más documentado en los WPs (5.72%)

Este VDN aparece explícitamente en los WPs como ejemplo canónico. Con
547,016 llamadas y 6 menús distintos es el centro de mayor complejidad
funcional (multiservicio: aparatos, contratación, fallas, MADT, cambios).

### 4. Etiquetas de cobranza identificadas

Cinco centros tienen etiquetas de cobranza explícitas. Juntos concentran
1,167,354 llamadas (12.2% del total de centros asignados):

| VDN | Llamadas | Etiqueta |
|---|---|---|
| 15070013 | 547,016 | ADEUDO22222 |
| 10428174 | 440,285 | TELVICOBRA |
| 14928994 | 98,985 | TELECOBRA |
| 10428163 | 59,257 | ADEUDO_1Y2, MES_1, MES_2 |
| 15070007 | 21,077 | ADEUDO22222 |

### 5. Catálogo de 35 menús reales identificados

```
Abandono (3):
  cliente_colgo, SinOpcion_Cabecera, Marque3

Desborde (2):
  Desborde_Cabecera, Desborde_Promocional

Fallas (8):
  RES-FallaInternet, RES-FallaInternet_2024, RES-FallasLinea, RES-Fallas_2024,
  RES-FallaEntretiene, RES-Falla-MVSHUB, RES-FallaSegQja, RES-Falla-AntivirusMcAfee

Contratación (4):
  RES-ContratacionInfinitum, RES-ContratacionInfinitum_2024,
  NOTMX-CONT-Contratacion, NOTMX-CONT-Portabilidad

Instalación (2):
  NOTMX-SeguimientoInstalacion, RES-SegInst_2024

Cambios y administración (4):
  RES_CambioDom, RES_CambioTit, RES_Cambios, RES-AsistenciaTelmexcom

Servicios adicionales (9):
  RES-Aparatos, RES-DISH, RES-SegurosInbursa, RES-ClaroDrive,
  RES-StartGo, RES-Entr, RES_Otros, RES-SaldosPagos_2024, RES-MADT-MVSHUB

MADT (2):
  RES-MADT-Detalle, RES-Falla-MVSHUB

Truncados en el CSV (aparecen como 'RE' o 'RES-MADT'):
  Posiblemente RES-... con nombre completo mayor a 150 caracteres
```

### 6. Centros geográficos de Ecatepec

Cuatro VDNs tienen etiquetas relacionadas con Ecatepec:
`ECATEPEC_FM`, `ECATEPEC_QJA`, `ECATEPEC_PORTA`, `ECATEPEC`. Juntos
suman ~130,000 llamadas. Sugiere una oficina regional con múltiples
colas diferenciadas por tipo de gestión.

---

## Notas sobre los datos

Los menús y etiquetas en `menus_lista` y `etiquetas_lista` pueden estar
truncados (los scripts usan `SUBSTRING(..., 1, 150)`). Centros con muchas
combinaciones pueden mostrar listas incompletas.

Los 63 centros del CSV representan los VDNs directos (CONFIGURACION_FIJA_8_DIG
en su mayoría). Los registros NK90 (5.71%) no están desglosados aquí por
lo que el total de llamadas en este archivo (9.57M) no incluye esas llamadas.

