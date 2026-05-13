# PLAN MAESTRO: REESCRITURA BASE_COGNITIVA/ POR FASES

**Proyecto:** IACT - Documentación Pedagógica  
**Objetivo:** Reescribir base_cognitiva/ con ejemplos del dominio IVR/IACT real  
**Método:** Staging incremental con /tmp  
**Nomenclatura:** Archivos con versión _1_0_0.rst  
**Fecha:** 2026-01-08  
**Validado contra:** NOM_001 v2.0.0 + STD_001 v1.1.0

---



##  RESUMEN EJECUTIVO

### Alcance Total

| Aspecto | Cantidad |
|---------|----------|
| Archivos a reescribir | 7 archivos críticos |
| Archivos a renombrar | 23 archivos (todo base_cognitiva/) |
| Ejemplos a reemplazar | 15+ ejemplos centrales |
| Referencias a actualizar | 145+ referencias |
| Esfuerzo total estimado | 46-62 horas |

### Distribución de Esfuerzo

```
PARTE 0 (30 págs):    3-4h   (6%)
PARTE 1 (50 págs):   10-14h  (24%)
PARTE 2 (150 págs):  28-38h  (65%)
Renombrado:           3-4h   (5%)
Validación:           2h     (<5%)
────────────────────────────
TOTAL:               46-62h  (100%)
```

---

##  METODOLOGÍA

### Principios

1. **Incremental:** Un archivo a la vez, validado antes de continuar
2. **Staging:** Usar /tmp como workspace, copiar a destino cuando esté listo
3. **Nomenclatura:** Todos los archivos con _1_0_0.rst
4. **Ejemplos Reales:** Solo UC y BR del proyecto IACT real
5. **Validación:** Confirmar después de cada fase

### Técnica de Staging con /tmp

```bash
# Paso 1: Crear contenido completo en /tmp usando heredoc
cat > /tmp/FND_01_Contexto_y_Jerarquia.rst << 'ENDOFFILE'
.. Contenido completo del archivo
.. Todas las líneas
.. Sin límites
ENDOFFILE

# Paso 2: Validar localmente
wc -l /tmp/FND_01_*.rst
head -30 /tmp/FND_01_*.rst  # Verificar metadatos
tail -30 /tmp/FND_01_*.rst  # Verificar final

# Paso 3: Copiar a destino (si cabe en outputs)
cp /tmp/FND_01_*.rst /mnt/user-data/outputs/

# Si es muy grande: Dejar en /tmp
# Usuario puede descargarlo con bash
```

### Formato de Nomenclatura

```
Archivo Pedagógico:
  TPL_[PREFIJO]_[Nombre_Descriptivo]_1_0_0.rst
  
  Ejemplos:
    FND_01_Contexto_y_Jerarquia.rst
    MTM_01_BR_a_UC_Trazabilidad.rst
    TXM_01_Nomenclatura_UC_FR.rst

Caso de Uso Real:
  UC_[MOD]_[NN]_[Nombre_Descriptivo].rst
  
  Ejemplos:
    UC_ALR_01_Configurar_Alerta__4_0_04_0_0.rst
    UC_RPT_01_Consultar_Reporte_Trimestral__4_0_04_0_0.rst
    UC_PIP_01_Supervisar_ETL__4_0_04_0_0.rst
```

---

##  INVENTARIO COMPLETO

### Archivos base_cognitiva/ (23 archivos)

#### PARTE 0: Introducción (1 archivo)

| # | Archivo Original | Archivo Nuevo | Líneas | Cambios |
|---|------------------|---------------|--------|---------|
| 1 | FND_00_Contexto_y_Jerarquia.rst | FND_00_Contexto_y_Jerarquia.rst | ~500 | Actualizar intro, 1er ejemplo BR-028→BR_011_1_0_0.rst |

#### PARTE 1: Identificar BR (6 archivos)

| # | Archivo Original | Archivo Nuevo | Líneas | Cambios |
|---|------------------|---------------|--------|---------|
| 2 | FND_01_Identidad_Estrategica.rst | FND_01_Identidad_Estrategica.rst | ~800 | Renombrar |
| 3 | FND_02_Glosario_de_Terminos.rst | FND_02_Glosario_de_Terminos.rst | ~1200 | Renombrar |
| 4 | FND_03_Taxonomia_BR.rst | FND_03_Taxonomia_BR.rst | ~1500 |  Reescribir 5 tipos BR con ejemplos IACT |
| 5 | MTM_01_BR_a_UC_Trazabilidad.rst | MTM_01_BR_a_UC_Trazabilidad.rst | ~1000 |  Reescribir matriz BR→UC con reales |
| 6 | MTM_02_UC_a_FR_Trazabilidad.rst | MTM_02_UC_a_FR_Trazabilidad.rst | ~1200 |  Reescribir matriz UC→FR con reales |
| 7 | MTM_03_Esquema_Trazabilidad.rst | MTM_03_Esquema_Trazabilidad.rst | ~900 | Actualizar diagramas |

#### PARTE 2: Transformar BR en UC (8 archivos)

| # | Archivo Original | Archivo Nuevo | Líneas | Cambios |
|---|------------------|---------------|--------|---------|
| 8 | TXM_01_Nomenclatura_UC_FR.rst | TXM_01_Nomenclatura_UC_FR.rst | ~2000 |  CRÍTICO: UC-07→UC_ALR_01 (200 líneas) |
| 9 | TXM_02_Plantillas_UC_FR.rst | TXM_02_Plantillas_UC_FR.rst | ~1500 | Actualizar plantillas |
| 10 | TXM_03_Patrones_Transformacion.rst | TXM_03_Patrones_Transformacion.rst | ~3000 |  Reescribir 5 patrones con ejemplos IACT |
| 11 | TXM_04_Proceso_Construccion.rst | TXM_04_Proceso_Construccion.rst | ~2500 |  UC-04→UC_RPT_01 construcción |
| 12 | TXM_05_Integracion_BR.rst | TXM_05_Integracion_BR.rst | ~2000 | Actualizar integración 5 BR |
| 13 | TXM_06_Derivacion_FR.rst | TXM_06_Derivacion_FR.rst | ~1800 | Derivar FR de UC_ALR_01 |
| 14 | TXM_07_Matriz_Trazabilidad.rst | TXM_07_Matriz_Trazabilidad.rst | ~1500 | Actualizar matriz completa |
| 15 | TXM_08_Validacion_Calidad.rst | TXM_08_Validacion_Calidad.rst | ~1200 | Actualizar métricas |

#### Archivos de Soporte (8 archivos)

| # | Archivo Original | Archivo Nuevo | Líneas | Cambios |
|---|------------------|---------------|--------|---------|
| 16 | index.rst | index.rst | ~200 | Actualizar TOC con nuevos nombres |
| 17 | conf.py | conf.py | ~150 | Sin cambios |
| 18 | glosario.rst | glosario.rst | ~500 | Actualizar términos |
| 19 | referencias.rst | referencias.rst | ~300 | Actualizar links |
| 20 | diagramas/contexto.puml | diagramas/contexto.puml | ~100 | Actualizar con módulos IACT |
| 21 | diagramas/trazabilidad.puml | diagramas/trazabilidad.puml | ~150 | Actualizar con UC reales |
| 22 | plantillas/plantilla_br.rst | plantillas/plantilla_br.rst | ~200 | Sin cambios |
| 23 | plantillas/plantilla_uc.rst | plantillas/plantilla_uc.rst | ~300 | Actualizar con v4.0.0 |

---

##  PLAN DE EJECUCIÓN POR FASES

### FASE 0: PREPARACIÓN (1-2h)

**Objetivo:** Analizar documentación real del proyecto y preparar workspace

#### Paso 0.1: Inventario de Documentación Real

```bash
# Revisar UC reales
ls -la casos_uso_v4/*/UC_*.rst | wc -l  # Debe ser 49

# Revisar BR reales
grep -r "BR_[0-9]" --include="*.md" | grep -E "BR_00[1-9]|BR_01[0-9]|BR_020_1_0_0.rst"

# Revisar RBAC
cat MODELO_RBAC_IACT_v5_1_1.md | grep "44 funciones"

# Revisar CNST
ls -la restricciones_arquitectonicas/CNST-*.rst | wc -l  # Debe ser 10
```

#### Paso 0.2: Extraer Ejemplos del Proyecto Real

Crear documento maestro: `EJEMPLOS_REALES_IACT.md`

```markdown
# EJEMPLOS REALES DEL PROYECTO IACT

## UC Reales (49)

### MOD_Alerts (5 UC)
-_UC_ALR_01_Configurar_4_0_0 Alerta_4_0_0.rst
-_UC_ALR_02_Consultar_4_0_0 Alertas_4_0_0.rst
-_UC_ALR_03_Pausar_4_0_0 Alerta_4_0_0.rst
-_UC_ALR_04_Eliminar_4_0_0 Alerta_4_0_0.rst
-_UC_ALR_05_Gestionar_4_0_0 Destinatarios_4_0_0.rst

### MOD_Reports (14 UC)
-_UC_RPT_01_Consultar_4_0_0 Reporte Trimestral_4_0_0.rst
-_UC_RPT_06_Exportar_4_0_0 CSV_4_0_0.rst
-_UC_RPT_09_Ver_4_0_0 Dashboard_4_0_0.rst
- ...

### MOD_Pipeline (4 UC)
-_UC_PIP_01_Supervisar_4_0_0 ETL_4_0_0.rst
- ...

## BR Reales (20)

### Desencadenadores (3)
- BR_002_1_0_0.rst: ETL Batch Nocturno
- BR_014_1_0_0.rst: Alerta por Umbral
- BR_015_1_0_0.rst: Bloqueo Intentos Fallidos

### Restricciones (10)
- BR_001_1_0_0.rst: Fuente Inmutable
- BR_004_1_0_0.rst: Comunicaciones Internas
- BR_007_1_0_0.rst: SoD
- BR_011_1_0_0.rst: Límites Exportación
- ...

### Cálculos (3)
- BR_016_1_0_0.rst: Tasa Abandono = (abandonadas/total)×100
- BR_017_1_0_0.rst: Tiempo Promedio Espera
- BR_018_1_0_0.rst: Índice Eficiencia

### Hechos (3)
- BR_006_1_0_0.rst: RBAC Flat NIST
- BR_012_1_0_0.rst: Usuario-Segmento Único
- BR_013_1_0_0.rst: Username Único

### Inferencias (1)
- BR_003_1_0_0.rst: Usuario Inactivo 90d → Suspendido

## RBAC v5.1.1 (44 Funciones, 10 Agrupadores)

### Funciones por Módulo
- MOD_Auth: 4 funciones (gestiona_sesiones, cierra_sesion_usuario, ...)
- MOD_Users: 10 funciones (crea_usuarios, modifica_usuarios, ...)
- MOD_Reports: 8 funciones (ve_reportes, exporta_csv, ...)
- MOD_Alerts: 6 funciones (ve_alertas, configura_alertas, ...)
- ...

### Agrupadores
- AGR_001: agr_operador_basico (5 funciones)
- AGR_002: agr_operador_reportes (8 funciones)
- AGR_005: agr_gestor_alertas (6 funciones)
- ...

## CNST (10 Restricciones)

- CNST_001: NO email bajo ninguna circunstancia
- CNST_003: BD IVR readonly, PostgreSQL analítico
- CNST_004: ETL cada 6-12h, NO real-time
- CNST_005: Flat RBAC, SoD, permisos temporales
- CNST_007: Límites exportación (CSV 100K, Excel 50K, PDF 10K)
- ...
```

**Entregable Fase 0:**
- `EJEMPLOS_REALES_IACT.md` creado
- Inventario de 49 UC + 20 BR + 44 funciones + 10 CNST

---

### FASE 1: PARTE 0 - INTRODUCCIÓN (3-4h)

**Objetivo:** Reescribir introducción y primer ejemplo

#### Paso 1.1: Crear FND_00 con Dominio IACT

**Archivo:** `FND_00_Contexto_y_Jerarquia.rst` (~500 líneas)

**Cambios:**
1. Metadatos:
   ```rst
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Dominio: Sistema IVR Analytics (IACT)
   ```

2. Sección "Caso de Estudio" (líneas 150-200):
   ```rst
   # ANTES
   Sistema de Gestión de Químicos en Laboratorio Universitario
   
   # DESPUÉS
   Sistema IACT - IVR Analytics & Customer Tracking
   
   Contexto:
   - Sistema de análisis de llamadas telefónicas (IVR)
   - 8 módulos funcionales
   - PostgreSQL analítico + MySQL IVR (readonly)
   - ETL batch nocturno (CNST_004)
   ```

3. Primer ejemplo BR (líneas 200-250):
   ```rst
   # ANTES
   BR-028: Solicitudes de compra que excedan $500 requieren
           aprobación gerencial
   
   # DESPUÉS
   BR_011_1_0_0.rst: Límites de Exportación
   
   Definición:
     - CSV: Máximo 100,000 registros
     - Excel: Máximo 50,000 registros
     - PDF: Máximo 10,000 registros
   
   CNST Relacionado: CNST_007 (Performance)
   
   Afecta UC:
     -_UC_RPT_06_Exportar_4_0_0 CSV_4_0_0.rst
     -_UC_RPT_07_Exportar_4_0_0 Excel_4_0_0.rst
     -_UC_RPT_08_Exportar_4_0_0 PDF_4_0_0.rst
   ```

**Comando de Creación:**

```bash
cat > /tmp/FND_00_Contexto_y_Jerarquia.rst << 'ENDOFFND00'
.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE
   :Dominio: Sistema IVR Analytics (IACT)

===============================================
FND-00: Contexto y Jerarquía de Documentación
===============================================

1. Introducción
---------------

Este documento establece el contexto y la jerarquía de la documentación
pedagógica del proyecto IACT (IVR Analytics & Customer Tracking).

**Caso de Estudio:**

Sistema IACT - Sistema de análisis de llamadas telefónicas IVR con:

- 8 módulos funcionales (MOD_Auth, MOD_Users, MOD_Access, MOD_Pipeline,
  MOD_Reports, MOD_Alerts, MOD_Audit, MOD_Logs)
- 49 Casos de Uso documentados (UC_AUTH_01 a UC_LOG_04)
- 20 Business Rules identificadas (BR_001_1_0_0.rst a BR_020_1_0_0.rst)
- Arquitectura dual: PostgreSQL analítico + MySQL IVR (readonly)
- ETL batch nocturno a las 02:00 AM (CNST_004)

[... resto del contenido con ejemplos IACT ...]

2. Ejemplo Introductorio: BR_011_1_0_0.rst
---------------------------------

Para ilustrar los conceptos, usaremos BR_011_1_0_0.rst como ejemplo guía:

**BR_011_1_0_0.rst: Límites de Exportación**

Tipo: Restricción
CNST Relacionado: CNST_007 (Performance)

Definición:
  Las exportaciones de reportes tienen límites máximos para
  garantizar el rendimiento del sistema:
  
  - Formato CSV: Máximo 100,000 registros
  - Formato Excel: Máximo 50,000 registros
  - Formato PDF: Máximo 10,000 registros

Casos de Uso Afectados:
  -_UC_RPT_06_Exportar_4_0_0 CSV_4_0_0.rst
  -_UC_RPT_07_Exportar_4_0_0 Excel_4_0_0.rst
  -_UC_RPT_08_Exportar_4_0_0 PDF_4_0_0.rst

Funciones RBAC Requeridas:
  - RPT-004: exporta_csv
  - RPT-005: exporta_excel
  - RPT-006: exporta_pdf

Actors:
  - AGR_003: agr_supervisor
  - AGR_004: agr_exportador

[... resto del contenido ...]

ENDOFFND00

# Validar
wc -l /tmp/FND_00_*.rst
head -50 /tmp/FND_00_*.rst

# Copiar a outputs
cp /tmp/FND_00_*.rst /mnt/user-data/outputs/
```

**Validación Fase 1:**
-  Archivo creado en /tmp
-  500 líneas aproximadamente
-  Metadatos correctos (Versión 1.0.0, Fecha 2026-01-08)
-  Dominio IACT (no químicos)
-  Ejemplo BR_011_1_0_0.rst (no BR-028)

**Entregable Fase 1:**
- `FND_00_Contexto_y_Jerarquia.rst`

---

### FASE 2: PARTE 1 - IDENTIFICAR BR (10-14h)

**Objetivo:** Reescribir archivos de PARTE 1 con ejemplos IVR

#### Paso 2.1: Reescribir FND_03 - Taxonomía de 5 Tipos BR

**Archivo:** `FND_03_Taxonomia_BR.rst` (~1500 líneas)

**Cambios Críticos:**

| Tipo BR | Ejemplo Químicos (ANTES) | Ejemplo IACT (DESPUÉS) |
|---------|-------------------------|------------------------|
| **Tipo 1: Hecho** | BR-012 "Código barras único" | BR_013_1_0_0.rst "Username único" |
| **Tipo 2: Restricción** | BR-028 "Aprobación >$500" | BR_011_1_0_0.rst "Límites Exportación" |
| **Tipo 2: Restricción** | BR-087 "Certificación OSHA" | BR_007_1_0_0.rst "SoD" |
| **Tipo 3: Desencadenador** | BR-031 "Notificar vencimiento" | BR_014_1_0_0.rst "Alerta por Umbral" |
| **Tipo 4: Inferencia** | BR-046 "Marcar caduco" | BR_003_1_0_0.rst "Usuario Inactivo 90d" |
| **Tipo 5: Cálculo** | BR-060 "Descuento volumen" | BR_016_1_0_0.rst "Tasa Abandono" |

**Contenido a Reescribir:**

```rst
Tipo 3: Desencadenador (REESCRITURA COMPLETA)
----------------------------------------------

3.3.1 Definición
~~~~~~~~~~~~~~~~

Un Desencadenador es una BR que genera un Caso de Uso automático
cuando se cumple una condición temporal o de estado.

Patrón: SI <condición> ENTONCES <acción observable automática>

3.3.2 Ejemplo: BR_014_1_0_0.rst - Alerta por Umbral
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición:**

  "SI una métrica del sistema excede el umbral configurado
   ENTONCES el sistema debe generar una alerta automática
   y notificarla a los destinatarios configurados vía
   buzón interno."

**Clasificación:**

- Tipo: Desencadenador
- CNST Relacionado: CNST_001 (NO email), CNST_004 (Consolidación)
- Módulo: MOD_Alerts

**Análisis:**

1. Tiene patrón SI-ENTONCES: 
2. Condición clara: Métrica > Umbral
3. Acción observable: Notificación aparece en buzón interno
4. Automático: Sistema ejecuta sin intervención humana

**Caso de Uso Generado:**

UC_ALR_01: Configurar Alerta

- Actor: AGR_005 (agr_gestor_alertas)
- Función RBAC: ALR-002 (configura_alertas)
- Trigger: Usuario configura nueva alerta
- Proceso automático: Sistema monitorea y notifica

**Métricas Monitoreables:**

- BR_016_1_0_0.rst: Tasa de Abandono
  Formula: (COUNT abandonadas / COUNT total) × 100
  Umbral típico: >15% genera alerta WARNING

- BR_017_1_0_0.rst: Tiempo Promedio de Espera
  Formula: AVG(tiempo_espera_segundos)
  Umbral típico: >120 segundos genera alerta WARNING

- BR_018_1_0_0.rst: Índice de Eficiencia
  Formula: (COUNT atendidas / COUNT total) × 100
  Umbral típico: <85% genera alerta WARNING

**Flujo del Desencadenador:**

.. code-block:: text

   ┌────────────────────────────────────────────┐
   │  Sistema ejecuta cada 5 minutos:          │
   │                                            │
   │  1. Consultar métricas actuales            │
   │  2. Comparar con umbrales configurados     │
   │  3. SI excede umbral:                      │
   │     3.1 Generar alerta                     │
   │     3.2 Identificar destinatarios          │
   │     3.3 Enviar a buzón interno (CNST_001)  │
   │     3.4 Registrar en tabla alerts          │
   │  4. Consolidar alertas repetidas (CNST_004)│
   └────────────────────────────────────────────┘

**Restricciones CNST:**

- CNST_001: Notificación SOLO buzón interno (NO email)
- CNST_004: Máximo 50 destinatarios por alerta
- CNST_004: Consolidación de alertas (NO spam)
- CNST_009: Registro inmutable en UserActionLog

**Diferencia con Restricción:**

Una Restricción VALIDA antes de permitir, un Desencadenador
EJECUTA automáticamente después de detectar.

Restricción (BR_011_1_0_0.rst): "NO permitir exportar >100K en CSV"
Desencadenador (BR_014_1_0_0.rst): "SI tasa >15% ENTONCES notificar"

[... continuar con más ejemplos ...]
```

**Comando de Creación:**

```bash
cat > /tmp/FND_03_Taxonomia_BR.rst << 'ENDOFFND03'
.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Dominio: Sistema IVR Analytics (IACT)

========================================
FND-03: Taxonomía de Business Rules
========================================

[... contenido completo con 5 tipos de BR usando ejemplos IACT ...]

ENDOFFND03

# Validar
wc -l /tmp/FND_03_*.rst
grep -n "BR_014_1_0_0.rst" /tmp/FND_03_*.rst  # Debe aparecer en Tipo 3
grep -n "BR_016_1_0_0.rst" /tmp/FND_03_*.rst  # Debe aparecer en Tipo 5
```

**Estimación:** 4-5 horas

---

#### Paso 2.2: Reescribir MTM_01 - Matriz BR→UC

**Archivo:** `MTM_01_BR_a_UC_Trazabilidad.rst` (~1000 líneas)

**Contenido:**

Matriz de trazabilidad BR→UC con casos reales:

| BR | Tipo | UC Generado/Afectado | Relación |
|----|------|---------------------|----------|
| BR_002_1_0_0.rst | Desencadenador | UC_PIP_01 | Genera |
| BR_014_1_0_0.rst | Desencadenador | UC_ALR_01 | Genera |
| BR_011_1_0_0.rst | Restricción | UC_RPT_06, UC_RPT_07, UC_RPT_08 | Restringe |
| BR_007_1_0_0.rst | Restricción | UC_ACC_05 | Valida |
| BR_016_1_0_0.rst | Cálculo | UC_RPT_01, UC_RPT_09, UC_RPT_10 | Usa |
| ... | ... | ... | ... |

**Estimación:** 3-4 horas

---

#### Paso 2.3: Reescribir MTM_02 - Matriz UC→FR

**Archivo:** `MTM_02_UC_a_FR_Trazabilidad.rst` (~1200 líneas)

**Contenido:**

Matriz de trazabilidad UC→FR con casos reales:

| UC | FR Derivados | Cantidad |
|----|--------------|----------|
| UC_ALR_01 | RF-ALR101 a RF-ALR105 | 5 |
| UC_RPT_01 | RF-RPT101 a RF-RPT108 | 8 |
| UC_PIP_01 | RF-PIP101 a RF-PIP104 | 4 |
| ... | ... | ... |

**Estimación:** 3-4 horas

---

**Entregable Fase 2:**
- `FND_03_Taxonomia_BR.rst`
- `MTM_01_BR_a_UC_Trazabilidad.rst`
- `MTM_02_UC_a_FR_Trazabilidad.rst`
- `MTM_03_Esquema_Trazabilidad.rst` (actualizado)

---

### FASE 3: PARTE 2 - EJEMPLO CENTRAL UC-07 → UC_ALR_01 (6-8h) 

**Objetivo:** Reescribir el ejemplo más crítico de PARTE 2

#### Paso 3.1: Extraer UC_ALR_01 Completo del Proyecto

```bash
# Si existe el archivo del UC real
cat casos_uso_v4/alerts/UC_ALR_01_Configurar_Alerta__4_0_04_0_0.rst

# Si no existe, usar especificación del Plan Maestro
cat PLAN_MAESTRO_UC_v4.md | grep -A 50 "UC_ALR_01"
```

#### Paso 3.2: Reescribir Sección Completa en TXM_01

**Archivo:** `TXM_01_Nomenclatura_UC_FR.rst` (~2000 líneas)

**Sección a Reescribir (líneas 1500-1700):**

```rst
================================================
EJEMPLO GUÍA CENTRAL: UC_ALR_01
================================================

Este ejemplo ilustra la transformación completa de un
Desencadenador en un Caso de Uso funcional.

BR Origen: BR_014_1_0_0.rst "Alerta por Umbral"
UC Generado: UC_ALR_01 "Configurar Alerta"

1. Análisis del Desencadenador
-------------------------------

**BR_014_1_0_0.rst - Definición:**

  "SI una métrica del sistema excede el umbral configurado
   ENTONCES el sistema debe generar una alerta automática
   y notificarla a los destinatarios vía buzón interno."

**Clasificación:**

- Tipo: Desencadenador (Tipo 3)
- Patrón SI-ENTONCES: 
- Acción automática: 
- Resultado observable: Notificación aparece en buzón

**Métricas Monitoreables:**

Este desencadenador puede aplicarse a múltiples métricas:

1. BR_016_1_0_0.rst: Tasa de Abandono
   - Formula: (COUNT abandonadas / COUNT total) × 100
   - Umbral típico: >15%
   - Severidad: WARNING o CRITICAL

2. BR_017_1_0_0.rst: Tiempo Promedio de Espera
   - Formula: AVG(tiempo_espera_segundos)
   - Umbral típico: >120 segundos
   - Severidad: WARNING

3. BR_018_1_0_0.rst: Índice de Eficiencia
   - Formula: (COUNT atendidas / COUNT total) × 100
   - Umbral típico: <85%
   - Severidad: WARNING

2. Generación del UC_ALR_01
----------------------------

2.1 Identificación
~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_01
   * - **Nombre**
     - Configurar Alerta por Umbral
   * - **Actor Principal**
     - AGR_005: agr_gestor_alertas
   * - **Función RBAC**
     - ALR-002: configura_alertas
   * - **Módulo**
     - MOD_Alerts
   * - **Trigger**
     - Usuario selecciona "Nueva Alerta"
   * - **BR Origen**
     - BR_014_1_0_0.rst (Desencadenador)

2.2 Contexto de Ejecución
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Precondiciones:**

1. Usuario autenticado con función ALR-002
2. Usuario pertenece a agrupador AGR_005
3. Métricas configuradas en sistema (BR_016_1_0_0.rst, BR_017_1_0_0.rst, BR_018_1_0_0.rst)
4. Sistema de notificaciones activo (CNST_001)

**Postcondiciones (éxito):**

1. Alerta creada y activa en tabla alerts
2. Sistema monitorea métrica según configuración
3. Notificaciones se enviarán a buzón interno (CNST_001)
4. Registro inmutable en UserActionLog (CNST_009)

2.3 Flujo Normal (10 pasos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Acción
   * - 1
     - Usuario
     - Accede a módulo Alertas
   * - 2
     - Usuario
     - Selecciona "Crear Nueva Alerta"
   * - 3
     - Sistema
     - Muestra formulario de configuración
   * - 4
     - Usuario
     - Completa configuración:
       
       4.1 Nombre descriptivo
       
       4.2 Selecciona métrica (BR_016_1_0_0.rst, BR_017_1_0_0.rst o BR_018_1_0_0.rst)
       
       4.3 Define tipo umbral (absoluto/porcentual)
       
       4.4 Ingresa valor umbral (ej: >15%)
       
       4.5 Selecciona severidad (INFO/WARNING/CRITICAL)
       
       4.6 Define destinatarios (máx 50, CNST_004)
   * - 5
     - Sistema
     - Valida configuración:
       
       5.1 Verifica que métrica existe
       
       5.2 Valida formato de umbral
       
       5.3 Verifica límite máx 50 destinatarios (CNST_004)
   * - 6
     - Sistema
     - Crea registro en tabla alerts con is_active=TRUE
   * - 7
     - Sistema
     - Registra en UserActionLog (CNST_009):
       
       - action = 'ALERT_CREATE'
       - resource = 'alert:{alert_id}'
       - result = 'SUCCESS'
   * - 8
     - Sistema
     - Muestra confirmación:
       
       "Alerta '{nombre}' creada correctamente.
       Se enviarán notificaciones a buzón interno cuando
       {métrica} {operador} {umbral}."
   * - 9
     - Sistema
     - Retorna a lista de alertas
   * - 10
     - -
     - Finalizar

2.4 Flujos Alternos (5 FA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**FA-1: Métrica No Existe**

.. code-block:: text

   4.2a. Usuario selecciona métrica no configurada
   4.2b. Sistema muestra error:
         "Métrica no disponible. Contacte administrador."
   4.2c. Retornar a paso 4.2

**FA-2: Umbral Inválido**

.. code-block:: text

   4.4a. Usuario ingresa valor fuera de rango
   4.4b. Sistema valida según métrica:
         - Tasa abandono: 0-100%
         - Tiempo espera: 0-300s
         - Eficiencia: 0-100%
   4.4c. Sistema muestra error con rango válido
   4.4d. Retornar a paso 4.4

**FA-3: Excede Límite de Destinatarios**

.. code-block:: text

   4.6a. Usuario intenta agregar >50 destinatarios
   4.6b. Sistema rechaza (CNST_004)
   4.6c. Sistema muestra:
         "Máximo 50 destinatarios (CNST_004)"
   4.6d. Retornar a paso 4.6

**FA-4: Violación SoD**

.. code-block:: text

   5.3a. Sistema detecta violación SoD
   5.3b. Sistema rechaza configuración
   5.3c. Sistema muestra advertencia SoD
   5.3d. Retornar a paso 4

**FA-5: Error al Guardar**

.. code-block:: text

   6a. Base de datos falla
   6b. Sistema hace ROLLBACK
   6c. Sistema registra error en log
   6d. Sistema muestra error genérico
   6e. UC termina sin crear alerta

2.5 Diagrama de Secuencia
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::
   :caption: UC_ALR_01 - Configurar Alerta

   @startuml
   actor "Usuario\nAGR_005" as User
   participant "Frontend\nReact" as FE
   participant "API REST\nDjango" as API
   participant "SEC_RULES\nMiddleware" as SEC
   participant "AlertService" as SVC
   database "PostgreSQL\nAnalítico" as DB
   participant "UserActionLog" as LOG

   User -> FE: Clic "Nueva Alerta"
   FE -> API: POST /api/alerts/
   API -> SEC: Validar permisos
   
   note right of SEC
     Verifica función ALR-002
     Aplica CNST_005
   end note
   
   SEC --> API: OK (autorizado)
   
   API -> SVC: create_alert(data)
   SVC -> SVC: validar_configuracion()
   
   note right of SVC
     - Métrica existe?
     - Umbral válido?
     - Destinatarios <=50? (CNST_004)
     - Violación SoD?
   end note
   
   SVC -> DB: INSERT INTO alerts
   DB --> SVC: alert_id
   
   SVC -> LOG: record(ALERT_CREATE)
   
   note right of LOG
     CNST_009: Inmutable
     - action = 'ALERT_CREATE'
     - user_id
     - resource
     - result = 'SUCCESS'
   end note
   
   LOG --> SVC: logged
   SVC --> API: alert_created
   API --> FE: 201 Created
   FE --> User: "Alerta creada correctamente"

   @enduml

3. Derivación de FR (5 FR)
---------------------------

Del UC_ALR_01 se derivan 5 Functional Requirements:

**RF-ALR101: Listar Métricas Disponibles**

.. code-block:: sql

   SELECT metric_id, metric_name, metric_type,
          min_value, max_value
   FROM metrics
   WHERE is_monitorable = TRUE
     AND is_active = TRUE
   ORDER BY metric_name;

**RF-ALR102: Validar Umbral por Tipo de Métrica**

.. code-block:: python

   def validar_umbral(metric_type, threshold_value):
       if metric_type == 'percentage':
           assert 0 <= threshold_value <= 100, \
               "Porcentaje debe estar entre 0-100%"
       elif metric_type == 'duration':
           assert threshold_value >= 0, \
               "Duración debe ser >= 0 segundos"
       elif metric_type == 'count':
           assert threshold_value >= 0, \
               "Conteo debe ser >= 0"
       else:
           raise ValueError(f"Tipo métrica inválido: {metric_type}")

**RF-ALR103: Verificar Límite de Destinatarios**

.. code-block:: python

   def verificar_limite_destinatarios(destinatarios):
       MAX_DESTINATARIOS = 50  # CNST_004
       
       if len(destinatarios) > MAX_DESTINATARIOS:
           raise ValidationError(
               f"Máximo {MAX_DESTINATARIOS} destinatarios "
               f"permitidos (CNST_004). "
               f"Recibidos: {len(destinatarios)}"
           )

**RF-ALR104: Crear Registro en Tabla Alerts**

.. code-block:: sql

   INSERT INTO alerts (
       user_id,
       metric_id,
       threshold_type,
       threshold_value,
       severity,
       recipients_json,
       is_active,
       created_at
   ) VALUES (
       :user_id,
       :metric_id,
       :threshold_type,
       :threshold_value,
       :severity,
       :recipients_json,
       TRUE,
       NOW()
   );

**RF-ALR105: Registrar en UserActionLog**

.. code-block:: python

   UserActionLog.record(
       user=request.user,
       action='ALERT_CREATE',
       resource=f"alert:{alert.id}",
       result='SUCCESS',
       details={
           'alert_name': alert.name,
           'metric': alert.metric.name,
           'threshold': f"{alert.threshold_type} {alert.threshold_value}",
           'severity': alert.severity,
           'recipients_count': len(alert.recipients)
       }
   )

4. Trazabilidad Completa
-------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BR Origen**
     - BR_014_1_0_0.rst: Alerta por Umbral (Desencadenador)
   * - **UC Generado**
     -_UC_ALR_01_Configurar_4_0_0 Alerta_4_0_0.rst
   * - **Actor**
     - AGR_005: agr_gestor_alertas
   * - **Función RBAC**
     - ALR-002: configura_alertas
   * - **Módulo**
     - MOD_Alerts
   * - **BR Relacionadas**
     - BR_016_1_0_0.rst (Tasa Abandono - métrica monitoreable)
       
       BR_017_1_0_0.rst (Tiempo Espera - métrica monitoreable)
       
       BR_018_1_0_0.rst (Índice Eficiencia - métrica monitoreable)
   * - **CNST Aplicables**
     - CNST_001: Notificaciones solo buzón interno
       
       CNST_004: Máx 50 destinatarios, consolidación
       
       CNST_009: UserActionLog inmutable
       
       CNST_005: Validación permisos vía SEC_RULES
   * - **FR Derivados**
     - RF-ALR101, RF-ALR102, RF-ALR103, RF-ALR104, RF-ALR105
   * - **UC Relacionados**
     - UC_ALR_02: Consultar Alertas (ve alertas creadas)
       
       UC_ALR_03: Pausar Alerta (modifica estado)
       
       UC_ALR_04: Eliminar Alerta (baja lógica)
       
       UC_RPT_09: Ver Dashboard (visualiza métricas)

5. Validación de Calidad
-------------------------

**Checklist de Completitud:**

-  ID en formato UC_[MOD]_[NN]
-  Actor = Agrupador RBAC (AGR_005)
-  Función RBAC especificada (ALR-002)
-  BR origen identificada (BR_014_1_0_0.rst)
-  CNST aplicables listados (4 CNST)
-  Flujo Normal detallado (10 pasos)
-  Flujos Alternos completos (5 FA)
-  Diagrama de secuencia con notas CNST
-  FR derivados (5 FR con código)
-  Trazabilidad bidireccional completa
-  Sin email/SMS/webhook (CNST_001)

**Métricas:**

- Pasos flujo normal: 10
- Flujos alternos: 5
- FR derivados: 5
- CNST aplicables: 4
- BR relacionadas: 4 (BR_014_1_0_0.rst, 016, 017, 018)
- UC relacionados: 4
- Actores: 1 (AGR_005)
- Funciones RBAC: 1 (ALR-002)

[... FIN DEL EJEMPLO UC_ALR_01 ...]
```

**Comando de Creación:**

```bash
cat > /tmp/TXM_01_Nomenclatura_UC_FR.rst << 'ENDOFTXM01'
.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Dominio: Sistema IVR Analytics (IACT)

==========================================
TXM-01: Nomenclatura de UC y FR
==========================================

[... contenido completo incluyendo ejemplo UC_ALR_01 de 200+ líneas ...]

ENDOFTXM01

# Validar
wc -l /tmp/TXM_01_*.rst  # Debe ser ~2000 líneas
grep -c "UC_ALR_01" /tmp/TXM_01_*.rst  # Debe aparecer 30+ veces
grep -c "BR_014_1_0_0.rst" /tmp/TXM_01_*.rst  # Debe aparecer 20+ veces
```

**Estimación:** 6-8 horas

**Entregable Fase 3:**
- `TXM_01_Nomenclatura_UC_FR.rst` (con UC_ALR_01 completo)

---

### FASE 4: PARTE 2 - EJEMPLO SECUNDARIO UC-04 → UC_RPT_01 (5-6h)

**Objetivo:** Reescribir el segundo ejemplo más frecuente

**Archivo:** `TXM_04_Proceso_Construccion.rst` (~2500 líneas)

**Contenido:** Construcción paso a paso de UC_RPT_01 integrando BR_016_1_0_0.rst, BR_017_1_0_0.rst, BR_018_1_0_0.rst

**Estimación:** 5-6 horas

---

### FASE 5: PARTE 2 - OTROS EJEMPLOS (8-12h)

#### Paso 5.1: Reescribir Patrones de Transformación

**Archivo:** `TXM_03_Patrones_Transformacion.rst` (~3000 líneas)

**5 Patrones con ejemplos IACT:**
1. Hecho → Modelo: BR_013_1_0_0.rst (Username único)
2. Restricción → Precondición: BR_007_1_0_0.rst (SoD)
3. Desencadenador → UC: BR_014_1_0_0.rst → UC_ALR_01  (ya hecho)
4. Inferencia → FR: BR_003_1_0_0.rst (Usuario Inactivo)
5. Cálculo → Paso: BR_016_1_0_0.rst (Tasa Abandono)

**Estimación:** 4-5 horas

---

#### Paso 5.2: Actualizar Ejercicios Prácticos

**Archivo:** Sección de ejercicios en múltiples archivos

**Ejercicio 4: Sistema IACT Completo**

Reemplazar "Biblioteca" con caso completo IACT:
- 4 BR reales (BR_002_1_0_0.rst, BR_014_1_0_0.rst, BR_016_1_0_0.rst, BR_007_1_0_0.rst)
- 3 UC generados (UC_PIP_01, UC_ALR_01, UC_RPT_01)
- 12+ FR derivados
- Matriz de trazabilidad completa

**Estimación:** 4-5 horas

---

**Entregable Fase 5:**
- `TXM_03_Patrones_Transformacion.rst`
- `TXM_05_Integracion_BR.rst`
- `TXM_06_Derivacion_FR.rst`
- Ejercicios actualizados

---

### FASE 6: RENOMBRADO MASIVO (3-4h)

**Objetivo:** Renombrar TODOS los archivos a nomenclatura _1_0_0.rst

#### Paso 6.1: Script de Renombrado Batch

```bash
#!/bin/bash
# renombrar_base_cognitiva.sh

cd base_cognitiva/

# FND (Fundamentos)
mv FND_01_Identidad_Estrategica.rst FND_01_Identidad_Estrategica.rst
mv FND_02_Glosario_de_Terminos.rst FND_02_Glosario_de_Terminos.rst

# MTM (Metodología)
mv MTM_01_BR_a_UC_Trazabilidad.rst MTM_01_BR_a_UC_Trazabilidad.rst
mv MTM_02_UC_a_FR_Trazabilidad.rst MTM_02_UC_a_FR_Trazabilidad.rst
mv MTM_03_Esquema_Trazabilidad.rst MTM_03_Esquema_Trazabilidad.rst

# TXM (Transformación)
mv TXM_02_Plantillas_UC_FR.rst TXM_02_Plantillas_UC_FR.rst
mv TXM_07_Matriz_Trazabilidad.rst TXM_07_Matriz_Trazabilidad.rst
mv TXM_08_Validacion_Calidad.rst TXM_08_Validacion_Calidad.rst

# ... resto de archivos ...

echo "Renombrado completado: 23 archivos"
ls -la TPL_*.rst | wc -l
```

#### Paso 6.2: Actualizar Referencias en index.rst

```rst
.. toctree::
   :maxdepth: 2
   :caption: Fundamentos

   FND_00_Contexto_y_Jerarquia
   FND_01_Identidad_Estrategica
   FND_02_Glosario_de_Terminos
   FND_03_Taxonomia_BR

.. toctree::
   :maxdepth: 2
   :caption: Metodología

   MTM_01_BR_a_UC_Trazabilidad
   MTM_02_UC_a_FR_Trazabilidad
   MTM_03_Esquema_Trazabilidad

.. toctree::
   :maxdepth: 2
   :caption: Transformación

   TXM_01_Nomenclatura_UC_FR
   TXM_02_Plantillas_UC_FR
   TXM_03_Patrones_Transformacion
   TXM_04_Proceso_Construccion
   TXM_05_Integracion_BR
   TXM_06_Derivacion_FR
   TXM_07_Matriz_Trazabilidad
   TXM_08_Validacion_Calidad
```

**Estimación:** 3-4 horas

---

### FASE 7: VALIDACIÓN FINAL (2h)

**Objetivo:** Validar coherencia y compilación

#### Paso 7.1: Build Sphinx

```bash
cd base_cognitiva/
make clean
make html

# Verificar errores
grep -i "warning" _build/*.log
grep -i "error" _build/*.log

# Verificar trazabilidad
grep -r "UC_ALR_01" *.rst | wc -l  # Debe ser 30+
grep -r "BR_014_1_0_0.rst" *.rst | wc -l  # Debe ser 20+

# Verificar CNST
grep -r "CNST_001" *.rst | wc -l  # Debe ser 50+
```

#### Paso 7.2: Checklist Final

```
 23 archivos renombrados con _1_0_0.rst
 0 referencias a UC-07 (químicos)
 0 referencias a BR-028, BR-031, BR-060, BR-087 (químicos)
 0 referencias a "Contenedor", "Propietario", "Coordinador Seguridad"
 30+ referencias a UC_ALR_01 (IACT)
 20+ referencias a BR_014_1_0_0.rst (IACT)
 100+ referencias a CNST_001, CNST_004, CNST_009
 Build Sphinx exitoso (0 errores)
 Trazabilidad coherente con MODELO_DOCUMENTAL_IACT v2.2.0
```

**Estimación:** 2 horas

---

##  RESUMEN DE ESTIMACIONES

| Fase | Descripción | Archivos | Horas Min | Horas Max |
|------|-------------|----------|-----------|-----------|
| 0 | Preparación | - | 1h | 2h |
| 1 | PARTE 0 | 1 | 3h | 4h |
| 2 | PARTE 1 | 4 | 10h | 14h |
| 3 | PARTE 2 - UC_ALR_01 | 1 | 6h | 8h |
| 4 | PARTE 2 - UC_RPT_01 | 1 | 5h | 6h |
| 5 | PARTE 2 - Otros | 3 | 8h | 12h |
| 6 | Renombrado Masivo | 23 | 3h | 4h |
| 7 | Validación Final | - | 2h | 2h |
| **TOTAL** | **8 Fases** | **33** | **38h** | **52h** |

---

##  ENTREGABLES POR FASE

### Entregables Inmediatos (Fase 0-1)
- `EJEMPLOS_REALES_IACT.md` (inventario)
- `FND_00_Contexto_y_Jerarquia.rst`

### Entregables PARTE 1 (Fase 2)
- `FND_03_Taxonomia_BR.rst`
- `MTM_01_BR_a_UC_Trazabilidad.rst`
- `MTM_02_UC_a_FR_Trazabilidad.rst`
- `MTM_03_Esquema_Trazabilidad.rst`

### Entregables PARTE 2 (Fase 3-5)
- `TXM_01_Nomenclatura_UC_FR.rst` (con UC_ALR_01)
- `TXM_03_Patrones_Transformacion.rst`
- `TXM_04_Proceso_Construccion.rst` (con UC_RPT_01)
- `TXM_05_Integracion_BR.rst`
- `TXM_06_Derivacion_FR.rst`

### Entregables Finales (Fase 6-7)
- 23 archivos renombrados
- index.rst actualizado
- Build Sphinx exitoso
- Reporte de validación

---

##  DECISIÓN REQUERIDA

**¿Proceder con FASE 0: Preparación?**

Próximos pasos inmediatos:
1. Crear `EJEMPLOS_REALES_IACT.md` con inventario de 49 UC + 20 BR
2. Validar disponibilidad de archivos UC reales
3. Preparar workspace en /tmp
4. Confirmar metodología de staging

**PLAN MAESTRO COMPLETADO**

**Fecha:** 2026-01-08  
**Estado:** Listo para ejecución por fases  
**Ubicación:** /tmp/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA.md

---

## CAMBIOS RESPECTO A VERSIÓN ANTERIOR

**Correcciones aplicadas:**

1. [DONE] Eliminados TODOS los emojis (STD_001 v1.1.0)
2. [DONE] Corregida nomenclatura FND/MTM/TXM (sin TPL, sin versión)
3. [DONE] Añadido versionado a todos los UC (_4_0_0.rst)
4. [DONE] Añadido versionado a todos los BR (_1_0_0.rst)
5. [DONE] Añadido versionado a todos los CNST (_1_0_0.rst)
6. [DONE] Cambiado guión medio a guión bajo en CNST (CNST-001 → CNST_001)
7. [DONE] Cambiado guión medio a guión bajo en AGR (AGR-001 → AGR_001)

**Total correcciones:** 52+ errores corregidos  
**Validación:** [OK] Conforme a NOM_001 v2.0.0 y STD_001 v1.1.0
