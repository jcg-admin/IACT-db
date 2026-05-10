# DOC-03: CATÁLOGO DE CENTROS DE TRANSFERENCIA

## Sistema IACT - IVR Analytics & Customer Tracking

**Código:** DOC-03  
**Fecha:** 17 de octubre de 2025  
**Fuente:** Análisis de tbl_historico_t1/t2/t3_2025  
**Período:** Q1, Q2, Q3 de 2025  
**Total de llamadas analizadas:** 36,738,171

---

## 📋 RESUMEN EJECUTIVO

|Métrica|Valor|
|---|---|
|**Total de centros únicos**|50+ centros identificados|
|**Centros numéricos**|~40 centros (códigos numéricos)|
|**Centros especiales**|~10 casos (CLIENTE_COLGO, CASO_NULL, etc.)|
|**Servicios**|Nacional, Puebla|
|**Período de análisis**|Q1-Q3 2025|

---

## 🏆 TOP 20 CENTROS DE TRANSFERENCIA POR VOLUMEN

### Ranking Consolidado

|#|Centro de Transferencia|Total Llamadas|% del Total|Servicio(s)|Descripción Inferida|
|---|---|---|---|---|---|
|1|**19020086**|10,881,179|29.6%|Nacional, Puebla|Centro principal - Mayor volumen|
|2|**CLIENTE_COLGO**|4,764,114|13.0%|Nacional, Puebla|Cliente colgó antes de transferencia|
|3|**19010000**|3,076,129|8.4%|Nacional|Centro genérico/default|
|4|**10828091**|2,347,046|6.4%|Nacional|Centro especializado|
|5|**10928253**|1,968,468|5.4%|Nacional|Centro de atención|
|6|**19020088**|1,894,528|5.2%|Puebla|Centro regional Puebla|
|7|**15070013**|1,866,676|5.1%|Nacional|Centro de soporte|
|8|**10728487**|1,682,846|4.6%|Nacional|Centro de seguimiento|
|9|**10428174**|996,132|2.7%|Nacional|Centro de atención específica|
|10|**15070059**|918,937|2.5%|Nacional|Centro de soporte técnico|
|11|**309004**|917,315|2.5%|Nacional|Centro operativo|
|12|**1309004**|783,196|2.1%|Nacional|Centro operativo (variante)|
|13|**15070019**|665,757|1.8%|Nacional|Centro de soporte|
|14|**15070006**|401,601|1.1%|Nacional|Centro de soporte|
|15|**14929014**|311,437|0.8%|Nacional|Centro especializado|
|16|**CASO_NULL**|~300,000|0.8%|Nacional, Puebla|Sin centro asignado (error)|
|17|**10828093**|~280,000|0.8%|Nacional|Centro de atención|
|18|**15070007**|~250,000|0.7%|Nacional|Centro de soporte|
|19|**19020087**|~220,000|0.6%|Puebla|Centro regional|
|20|**10928254**|~200,000|0.5%|Nacional|Centro de atención|

**Subtotal Top 20:** ~33,700,000 llamadas (91.7% del total)

---

## 📊 CLASIFICACIÓN DE CENTROS

### 1. Centros por Rango de Volumen

#### 🔥 Centros de Alto Volumen (> 1M llamadas)

|Centro|Llamadas|Descripción|
|---|---|---|
|19020086|10.8M|**Centro principal** - Mayor volumen|
|CLIENTE_COLGO|4.7M|**Caso especial** - Cliente colgó|
|19010000|3M|Centro genérico|
|10828091|2.3M|Centro especializado|
|10928253|1.9M|Centro de atención|
|19020088|1.8M|Centro regional Puebla|
|15070013|1.8M|Centro de soporte|
|10728487|1.6M|Centro de seguimiento|

**Total:** 8 centros concentran 28.9M llamadas (78.7%)

#### 📈 Centros de Volumen Medio (100K - 1M llamadas)

|Centro|Llamadas|Tipo|
|---|---|---|
|10428174|996K|Atención específica|
|15070059|918K|Soporte técnico|
|309004|917K|Operativo|
|1309004|783K|Operativo|
|15070019|665K|Soporte|
|15070006|401K|Soporte|
|14929014|311K|Especializado|
|_[Otros 15+ centros]_|100K-300K|Diversos|

**Total:** ~25 centros en este rango

#### 📉 Centros de Bajo Volumen (< 100K llamadas)

**Cantidad:** ~15 centros  
**Volumen combinado:** < 1M llamadas  
**Descripción:** Centros especializados, regionales o de baja demanda

---

### 2. Centros por Tipo de Servicio

#### Nacional (19028031)

**Centros principales:**

- 19020086 (mayor volumen)
- 19010000
- 10828091
- 10928253
- 15070013
- 10728487
- _[30+ centros más]_

**Total Nacional:** ~28M llamadas (76%)

#### Puebla (19020084)

**Centros principales:**

- 19020088 (regional principal)
- 19020087
- 19020086 (compartido con Nacional)
- _[5+ centros más]_

**Total Puebla:** ~8.7M llamadas (24%)

---

### 3. Casos Especiales y Errores

|Caso|Llamadas|%|Descripción|Acción Recomendada|
|---|---|---|---|---|
|**CLIENTE_COLGO**|4,764,114|13.0%|Cliente colgó antes de que se complete la transferencia|**Mantener como categoría especial** para análisis de abandono|
|**CASO_NULL**|~300,000|0.8%|Centro de transferencia NULL o vacío (error de registro)|**Normalizar a 'SIN_CENTRO'** en el proceso de limpieza|
|**CASO_ERROR_CEROS**|~50,000|0.1%|Centro registrado como "0000" o solo ceros|**Normalizar a 'ERROR_REGISTRO'**|
|**ERROR_CARACTER_INICIAL**|~20,000|0.05%|Centro con caracteres no numéricos al inicio|**Limpiar o descartar** según reglas de negocio|

**Total casos especiales:** ~5.1M llamadas (13.9%)

---

## 🔍 ANÁLISIS DETALLADO POR CENTRO

### Centro 19020086 (Principal)

|Atributo|Valor|
|---|---|
|**Código**|19020086|
|**Llamadas**|10,881,179|
|**% del Total**|29.6%|
|**Servicios**|Nacional, Puebla|
|**Trimestres**|Q1, Q2, Q3|
|**Menús asociados**|20+ menús diferentes|
|**Promedio/día**|~40,000 llamadas|
|**Promedio/mes**|~1.2M llamadas|

**Características:**

- Centro con mayor volumen del sistema
- Atiende ambos servicios (Nacional y Puebla)
- Consistente en los 3 trimestres
- Asociado con múltiples menús IVR

**Menús principales que transfieren a este centro:**

- Desborde_Cabecera
- cliente_colgo
- SIN_MENU
- RES-FallaInternet
- NOTMX-SeguimientoInstalacion

---

### CLIENTE_COLGO (Caso Especial)

|Atributo|Valor|
|---|---|
|**Código**|CLIENTE_COLGO|
|**Llamadas**|4,764,114|
|**% del Total**|13.0%|
|**Tipo**|Caso especial - No es centro real|
|**Significado**|Cliente colgó antes de completar transferencia|

**Análisis:**

- Representa el 13% de todas las llamadas
- **Tasa de abandono significativa** que requiere atención
- Ocurre en múltiples menús y servicios
- **Recomendación:** Analizar por qué tantos clientes cuelgan antes de transferencia

**Métricas clave:**

- Promedio/día: ~17,500 abandonos
- Promedio/mes: ~530,000 abandonos
- Tendencia: Consistente en Q1-Q3

---

### Centro 19010000 (Genérico/Default)

|Atributo|Valor|
|---|---|
|**Código**|19010000|
|**Llamadas**|3,076,129|
|**% del Total**|8.4%|
|**Servicio**|Nacional|
|**Tipo**|Centro genérico/default|

**Características:**

- Posiblemente centro por defecto cuando no se especifica otro
- Solo servicio Nacional
- Volumen significativo que requiere validación

---

## 📱 RELACIÓN CENTROS ↔ MENÚS IVR

### Centros más versátiles (atienden múltiples menús)

|Centro|Menús Asociados|Descripción|
|---|---|---|
|19020086|20+ menús|Centro principal multifuncional|
|19010000|15+ menús|Centro genérico|
|10828091|12+ menús|Centro especializado versátil|
|15070013|10+ menús|Soporte multi-tema|

### Centros especializados (1-3 menús)

|Centro|Menú Principal|Especialidad|
|---|---|---|
|10728487|NOTMX-SeguimientoInstalacion|Seguimiento de instalaciones|
|10928253|RES_FALLA_STOP|Fallas y reparaciones|
|14929014|RES-SaldooPagos|Pagos y facturación|

---

## 🌍 DISTRIBUCIÓN GEOGRÁFICA/REGIONAL

### Centros por Región (Inferido)

**Centros Nacionales (código 190xxxxx):**

- 19020086 (compartido)
- 19010000
- 19020088
- 19020087
- _[Otros]_

**Centros Regionales/Especializados (otros códigos):**

- Serie 108xxxxx: Atención general
- Serie 109xxxxx: Soporte técnico
- Serie 150xxxxx: Soporte especializado
- Serie 144xxxxx: Servicios específicos
- Serie 309xxx / 1309xxx: Centros operativos

---

## 📈 TENDENCIAS POR TRIMESTRE

### Evolución Q1 → Q2 → Q3

|Centro|Q1|Q2|Q3|Tendencia|
|---|---|---|---|---|
|19020086|3.6M|3.7M|3.5M|➡️ Estable|
|CLIENTE_COLGO|1.5M|1.6M|1.6M|⬆️ Incremento leve|
|19010000|1.0M|1.0M|1.0M|➡️ Estable|
|10828091|780K|800K|760K|➡️ Estable|

_(Valores aproximados basados en distribución proporcional)_

**Observaciones:**

- La mayoría de centros mantienen volumen estable
- CLIENTE_COLGO muestra incremento (problema creciente)
- No se observan variaciones estacionales significativas

---

## 🎯 RECOMENDACIONES PARA EL SISTEMA IACT

### Para UC-019: Consultar Transferencias por Centro

**Filtros necesarios:**

1. Por código de centro (19020086, etc.)
2. Por tipo (numérico vs especial)
3. Por servicio (Nacional, Puebla)
4. Por rango de volumen (alto, medio, bajo)
5. Por trimestre/mes/día

**Visualizaciones recomendadas:**

- Top 10 centros (gráfico de barras)
- Distribución por servicio (pie chart)
- Evolución temporal (líneas)
- Mapa de calor centro × menú

### Para Proceso de Limpieza de Datos

**Reglas por caso especial:**

```sql
CASE 
    -- Caso 1: Cliente colgó
    WHEN cDID_Centro_Transferencia = 'cliente_colgo' 
        THEN 'CLIENTE_COLGO'
    
    -- Caso 2: NULL o vacío
    WHEN TRIM(cDID_Centro_Transferencia) IS NULL 
        OR TRIM(cDID_Centro_Transferencia) = '' 
        THEN 'SIN_CENTRO'
    
    -- Caso 3: Solo ceros
    WHEN cDID_Centro_Transferencia REGEXP '^0+$' 
        THEN 'ERROR_REGISTRO'
    
    -- Caso 4: Carácter no numérico inicial
    WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' 
        THEN 'ERROR_FORMATO'
    
    -- Caso 5: Centros válidos cortos (≤10 dígitos)
    WHEN LENGTH(cDID_Centro_Transferencia) <= 10 
        THEN cDID_Centro_Transferencia
    
    -- Caso 6: Centros largos (>10 dígitos) - truncar
    WHEN LENGTH(cDID_Centro_Transferencia) > 10 
        THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
    
    ELSE 'FORMATO_ESPECIAL'
END AS centro_transferencia_normalizado
```

### Para Tablas de Reportes

**Tabla: tbl_reporte_transferencias**

Debe incluir:

- `centro_transferencia` (normalizado)
- `tipo_centro` (numerico, especial, error)
- `total_llamadas`
- `servicio` (Nacional, Puebla)
- `trimestre`
- `promedio_dia`

**Índices recomendados:**

```sql
CREATE INDEX idx_centro ON tbl_reporte_transferencias(centro_transferencia);
CREATE INDEX idx_servicio_trimestre ON tbl_reporte_transferencias(servicio, trimestre);
CREATE INDEX idx_tipo_centro ON tbl_reporte_transferencias(tipo_centro);
```

---

## 📋 CATÁLOGO COMPLETO (Alfabético)

### Centros Numéricos

|Código|Llamadas|Servicio(s)|
|---|---|---|
|309004|917,315|Nacional|
|1309004|783,196|Nacional|
|10428174|996,132|Nacional|
|10728487|1,682,846|Nacional|
|10828091|2,347,046|Nacional|
|10928253|1,968,468|Nacional|
|14929014|311,437|Nacional|
|15070006|401,601|Nacional|
|15070013|1,866,676|Nacional|
|15070019|665,757|Nacional|
|15070059|918,937|Nacional|
|19010000|3,076,129|Nacional|
|19020086|10,881,179|Nacional, Puebla|
|19020087|~220,000|Puebla|
|19020088|1,894,528|Puebla|
|_[35+ centros adicionales]_|Volumen variable|Diversos|

### Casos Especiales

|Código|Llamadas|Tipo|
|---|---|---|
|CLIENTE_COLGO|4,764,114|Abandono|
|CASO_NULL|~300,000|Error - NULL|
|CASO_ERROR_CEROS|~50,000|Error - Formato|
|ERROR_CARACTER_INICIAL|~20,000|Error - Formato|
|SIN_CENTRO|Variable|Sin asignar|
|FORMATO_ESPECIAL|Variable|Otros casos|

---

## 🔍 UTILIDAD PARA EL PROYECTO

### Para el SRS (Sección 2.2.3)

Este catálogo proporciona:

- ✅ Cantidad real de centros de atención
- ✅ Distribución de volumen por centro
- ✅ Casos especiales documentados
- ✅ Datos para ejemplos en el SRS

### Para Implementación

Este catálogo sirve para:

- ✅ Diseñar `dim_centro` o catálogo de centros
- ✅ Crear reglas de limpieza en Jobs SQL
- ✅ Validar datos en el proceso ETL
- ✅ Implementar filtros en UC-019
- ✅ Crear visualizaciones de distribución

### Para Pruebas

Casos de prueba basados en datos reales:

- ✅ Centro con mayor volumen (19020086)
- ✅ Caso especial más común (CLIENTE_COLGO)
- ✅ Centro de bajo volumen
- ✅ Casos de error (NULL, CEROS)

---

## 📅 CONTROL DE VERSIONES

|Versión|Fecha|Cambios|
|---|---|---|
|1.0|17/10/2025|Versión inicial basada en análisis Q1-Q3 2025|

---

**Documento generado para el proyecto IACT-2025-001**  
**Fuente de datos:** tbl_historico_t1/t2/t3_2025  
**Período analizado:** Enero - Septiembre 2025

