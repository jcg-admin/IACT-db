# PLAN MAESTRO: REESCRITURA BASE_COGNITIVA/

**Proyecto:** IACT - Documentación Pedagógica base_cognitiva/  
**Versión Plan:** 3.0.0 FINAL  
**Fecha:** 2026-01-08  
**Método:** Staging incremental con /tmp  
**Validado contra:** Casos de Uso v4 generados (49 UC, 23,401 líneas)

---

## CONTEXTO Y JUSTIFICACIÓN

### Problema Actual

La carpeta `base_cognitiva/` contiene documentación pedagógica sobre la metodología BR→UC→FR, pero usa ejemplos de un dominio **INCORRECTO**:

- **Dominio actual:** Gestión de productos químicos en laboratorio universitario
- **Dominio correcto:** Sistema IVR Analytics (IACT) - Análisis de llamadas telefónicas

### Ejemplos del Problema

| Elemento Pedagógico | Dominio Incorrecto (Químicos) | Dominio Correcto (IACT) |
|---------------------|-------------------------------|-------------------------|
| Ejemplo UC principal | UC-07 "Notificar Vencimiento" | UC_ALR_01 "Configurar Umbrales" |
| Ejemplo BR principal | BR-031 "Notificar 30 días antes" | BR_014 "Alerta por Umbral" |
| Entidad central | Contenedor de químico | Llamada telefónica |
| Actor genérico | "Coordinador de Seguridad" | AGR_007 "supervisor" |
| Restricción ejemplo | BR-028 "Aprobación >$500" | BR_011 "Límites Exportación" |

### Objetivo

Reescribir base_cognitiva/ usando **ÚNICAMENTE ejemplos del proyecto IACT real**:
- 49 UC generados (23,401 líneas)
- 20 BR del sistema
- 10 CNST arquitectónicas
- Modelo RBAC v5.1.1 (44 funciones, 10 agrupadores)

---

## ALCANCE DEL PLAN

### Archivos en base_cognitiva/ (23 archivos)

| Tipo | Cantidad | Acción |
|------|----------|--------|
| Archivos a reescribir completamente | 7 | Reemplazar contenido con ejemplos IACT |
| Archivos a actualizar referencias | 16 | Cambiar nombres de UC/BR/actores |
| Total archivos afectados | 23 | |

### Esfuerzo Estimado

| Fase | Descripción | Archivos | Horas Min | Horas Max |
|------|-------------|----------|-----------|-----------|
| 0 | Preparación e inventario | - | 1h | 2h |
| 1 | PARTE 0 (Introducción) | 1 | 3h | 4h |
| 2 | PARTE 1 (Identificar BR) | 4 | 10h | 14h |
| 3 | PARTE 2 - UC_ALR_01 (Ejemplo crítico) | 1 | 6h | 8h |
| 4 | PARTE 2 - UC_RPT_01 (Ejemplo secundario) | 1 | 5h | 6h |
| 5 | PARTE 2 - Otros ejemplos | 3 | 8h | 12h |
| 6 | Actualización referencias | 16 | 3h | 4h |
| 7 | Validación final | - | 2h | 2h |
| **TOTAL** | **8 Fases** | **27** | **38h** | **52h** |

---

## NOMENCLATURA OFICIAL DEL PROYECTO

### Casos de Uso (Públicos, Generados)

**Formato actual en el proyecto:**
```
UC_[MOD]_[NN]_[Nombre_Descriptivo].rst
```

**Ejemplos reales del proyecto:**
```
UC_ALR_01_Configurar_Umbrales.rst
UC_RPT_01_Ver_Dashboard.rst
UC_PIP_01_Supervisar_ETL.rst
UC_ACC_01_Asignar_Funciones.rst
```

**Uso en base_cognitiva/:**
- Referencias en texto: `UC_ALR_01`
- Links a archivos: `UC_ALR_01_Configurar_Umbrales.rst`

---

### Business Rules (20 BR del proyecto)

**Formato:**
```
BR_[NNN] (identificador en texto)
```

**Las 20 BR reales del proyecto:**

| BR | Nombre | Tipo | CNST |
|----|--------|------|------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 |
| BR_003 | Usuario Inactivo 90d | Inferencia | — |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 |
| BR_005 | Sesión Única | Restricción | CNST_002 |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 |
| BR_011 | Límites Exportación | Restricción | CNST_007 |
| BR_012 | Usuario-Segmento Único | Hecho | — |
| BR_013 | Username Único | Hecho | — |
| BR_014 | Alerta por Umbral | Desencadenador | — |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 |
| BR_016 | Tasa Abandono | Cálculo | — |
| BR_017 | Tiempo Promedio Espera | Cálculo | — |
| BR_018 | Índice Eficiencia | Cálculo | — |
| BR_019 | Retención 2 Años | Restricción | CNST_006 |
| BR_020 | Clasificación Datos | Restricción | CNST_010 |

**Clasificación por Tipo:**

| Tipo | Cantidad | BR |
|------|----------|-----|
| Restricción | 10 | BR_001, 004, 005, 007, 008, 009, 010, 011, 019, 020 |
| Desencadenador | 3 | BR_002, 014, 015 |
| Hecho | 3 | BR_006, 012, 013 |
| Inferencia | 1 | BR_003 |
| Cálculo | 3 | BR_016, 017, 018 |

---

### Restricciones Arquitectónicas (10 CNST)

**Formato:**
```
CNST_[NNN] (con guión bajo)
```

**Las 10 CNST del proyecto:**

| CNST | Nombre |
|------|--------|
| CNST_001 | InternalMessage (Solo notificaciones internas) |
| CNST_002 | 2FA Obligatorio |
| CNST_003 | BD Dual (IVR readonly / Analytics transaccional) |
| CNST_004 | Segmentos de Datos |
| CNST_005 | Bloqueo tras 5 intentos |
| CNST_006 | Retención 2 años |
| CNST_007 | Límite 100k exportaciones |
| CNST_008 | Logs JSON estructurado |
| CNST_009 | Auditoría Inmutable |
| CNST_010 | Segregación de Funciones (SoD) |

---

### Agrupadores RBAC (10 AGR)

**Formato:**
```
AGR_[NNN] (con guión bajo)
```

**Los 10 Agrupadores reales del proyecto (RBAC v5.1.1):**

| ID | Código | Descripción | Usado en UC |
|----|--------|-------------|-------------|
| AGR_001 | agr_superadmin | Acceso total | Todos los módulos |
| AGR_002 | agr_admin_usuarios | Gestión usuarios | MOD_Users |
| AGR_003 | agr_admin_roles | Gestión roles | MOD_Access |
| AGR_004 | agr_operador_etl | Supervisión ETL | MOD_Pipeline |
| AGR_005 | agr_analista | Reportes y análisis | MOD_Reports |
| AGR_006 | agr_auditor | Auditoría compliance | MOD_Audit |
| AGR_007 | agr_supervisor | Alertas y monitoreo | MOD_Alerts |
| AGR_008 | agr_exportador | Exportación datos | MOD_Reports (Export) |
| AGR_009 | agr_viewer | Solo lectura | Todos los módulos |
| AGR_010 | agr_soporte | Soporte técnico | MOD_Logs |

**Reglas SoD (Segregación de Funciones):**

| Regla | Conflicto | Descripción |
|-------|-----------|-------------|
| SoD-001 | AGR_002 ↔ AGR_006 | Admin usuarios no audita sus cambios |
| SoD-002 | AGR_003 ↔ AGR_006 | Admin roles no audita asignaciones |
| SoD-003 | AGR_004 ↔ AGR_005 | Operador ETL no analiza datos cargados |

---

### Archivos base_cognitiva/ (SIN versionado)

**Formato:**
```
FND_[NN]_[Nombre_Descriptivo].rst
MTM_[NN]_[Nombre_Descriptivo].rst
TXM_[NN]_[Nombre_Descriptivo].rst
```

**Ejemplos:**
```
FND_00_Contexto_y_Jerarquia.rst
FND_03_Taxonomia_BR.rst
MTM_01_BR_a_UC_Trazabilidad.rst
TXM_01_Nomenclatura_UC_FR.rst
```

**IMPORTANTE:** Los archivos de base_cognitiva/ son artefactos **PRIVADOS** (pedagógicos) y NO llevan versionado en el nombre del archivo.

---

## INVENTARIO DE ARCHIVOS

### PARTE 0: Introducción (1 archivo)

| # | Archivo | Líneas | Acción |
|---|---------|--------|--------|
| 1 | FND_00_Contexto_y_Jerarquia.rst | ~500 | Reescribir 1er ejemplo BR_011 |

**Cambios:**
- Líneas 150-200: Cambiar "Sistema de Químicos" → "Sistema IACT IVR Analytics"
- Líneas 200-250: Cambiar ejemplo BR-028 → BR_011 "Límites Exportación"

---

### PARTE 1: Identificar BR (6 archivos)

| # | Archivo | Líneas | Acción |
|---|---------|--------|--------|
| 2 | FND_01_Identidad_Estrategica.rst | ~800 | Actualizar referencias |
| 3 | FND_02_Glosario_de_Terminos.rst | ~1200 | Actualizar términos |
| 4 | FND_03_Taxonomia_BR.rst | ~1500 | **CRÍTICO:** Reescribir 5 tipos BR |
| 5 | MTM_01_BR_a_UC_Trazabilidad.rst | ~1000 | **CRÍTICO:** Reescribir matriz BR→UC |
| 6 | MTM_02_UC_a_FR_Trazabilidad.rst | ~1200 | **CRÍTICO:** Reescribir matriz UC→FR |
| 7 | MTM_03_Esquema_Trazabilidad.rst | ~900 | Actualizar diagramas |

**Prioridad 1: FND_03_Taxonomia_BR.rst**

Reescribir COMPLETAMENTE sección de 5 tipos de BR con ejemplos IACT:

| Tipo BR | Ejemplo Químicos (ELIMINAR) | Ejemplo IACT (USAR) |
|---------|---------------------------|---------------------|
| Tipo 1: Hecho | BR-012 "Código barras único" | BR_013 "Username Único" |
| Tipo 2: Restricción | BR-028 "Aprobación >$500" | BR_011 "Límites Exportación" |
| Tipo 2: Restricción | BR-087 "Certificación OSHA" | BR_007 "Separación Funciones SoD" |
| Tipo 3: Desencadenador | BR-031 "Notificar vencimiento" | BR_014 "Alerta por Umbral" |
| Tipo 4: Inferencia | BR-046 "Marcar caduco" | BR_003 "Usuario Inactivo 90d" |
| Tipo 5: Cálculo | BR-060 "Descuento volumen" | BR_016 "Tasa Abandono" |

---

### PARTE 2: Transformar BR en UC (8 archivos)

| # | Archivo | Líneas | Acción |
|---|---------|--------|--------|
| 8 | TXM_01_Nomenclatura_UC_FR.rst | ~2000 | **CRÍTICO×3:** Reescribir UC_ALR_01 completo |
| 9 | TXM_02_Plantillas_UC_FR.rst | ~1500 | Actualizar plantillas |
| 10 | TXM_03_Patrones_Transformacion.rst | ~3000 | **CRÍTICO×2:** Reescribir 5 patrones |
| 11 | TXM_04_Proceso_Construccion.rst | ~2500 | **CRÍTICO×2:** Reescribir UC_RPT_01 |
| 12 | TXM_05_Integracion_BR.rst | ~2000 | Actualizar integración BR |
| 13 | TXM_06_Derivacion_FR.rst | ~1800 | Derivar FR de UC_ALR_01 |
| 14 | TXM_07_Matriz_Trazabilidad.rst | ~1500 | Actualizar matriz completa |
| 15 | TXM_08_Validacion_Calidad.rst | ~1200 | Actualizar métricas |

**Prioridad 1: TXM_01 con UC_ALR_01 (200+ líneas a reescribir)**

Este es el ejemplo MÁS CRÍTICO de toda la documentación pedagógica.

---

### Archivos de Soporte (8 archivos)

| # | Archivo | Líneas | Acción |
|---|---------|--------|--------|
| 16 | index.rst | ~200 | Actualizar TOC |
| 17 | conf.py | ~150 | Sin cambios |
| 18 | glosario.rst | ~500 | Actualizar términos |
| 19 | referencias.rst | ~300 | Actualizar links |
| 20 | diagramas/contexto.puml | ~100 | Actualizar módulos |
| 21 | diagramas/trazabilidad.puml | ~150 | Actualizar con UC reales |
| 22 | plantillas/plantilla_br.rst | ~200 | Sin cambios |
| 23 | plantillas/plantilla_uc.rst | ~300 | Actualizar formato |

---

## TABLA MAESTRA DE SUSTITUCIÓN

### Ejemplos Centrales (Más frecuentes)

| # | Elemento PARTE 2 (Químicos) | Tipo | Apariciones | UC/BR Real IACT | Justificación |
|---|---------------------------|------|-------------|-----------------|---------------|
| 1 | UC-07 "Notificar Vencimiento" | UC | 30+ | UC_ALR_01 "Configurar Umbrales" | Proceso automático con desencadenador |
| 2 | BR-031 "Notificar 30d antes" | BR | 20+ | BR_014 "Alerta por Umbral" | Ambos Desencadenadores (Tipo 3) |
| 3 | UC-04 "Solicitar Químico" | UC | 25+ | UC_RPT_01 "Ver Dashboard" | Acción principal con múltiples pasos |
| 4 | BR-028 "Aprobación >$500" | BR | 15+ | BR_011 "Límites Exportación" | Restricción con umbral numérico |
| 5 | BR-087 "Certificación OSHA" | BR | 12+ | BR_007 "Separación Funciones SoD" | Restricción de autorización |
| 6 | BR-060 "Descuento volumen" | BR | 8+ | BR_016 "Tasa Abandono" | Cálculo con fórmula |

### Actores y Entidades

| # | Elemento Químicos | Apariciones | Elemento IACT | Justificación |
|---|------------------|-------------|---------------|---------------|
| 7 | "Propietario" | 20+ | AGR_005 "analista" | Usuario que consulta datos |
| 8 | "Coordinador Seguridad" | 15+ | AGR_007 "supervisor" | Supervisor de alertas |
| 9 | "Gerente" | 8+ | AGR_001 "superadmin" | Administrador |
| 10 | "Contenedor" | 40+ | "Llamada" | Entidad principal |
| 11 | "ProductoQuimico" | 25+ | "Cola/Centro" | Clasificador |

### Ejemplos Adicionales

| # | Elemento Químicos | Elemento IACT | Tipo |
|---|------------------|---------------|------|
| 12 | BR-046 "Marcar caduco" | BR_003 "Usuario Inactivo 90d" | Inferencia |
| 13 | BR-012 "Código barras único" | BR_013 "Username Único" | Hecho |
| 14 | UC-09 "Aprobar Solicitud" | UC_ACC_01 "Asignar Funciones" | UC autorización |
| 15 | UC-10 "Procesar Orden" | UC_RPT_04 "Exportar CSV" | UC con límites |

---

## METODOLOGÍA DE TRABAJO

### Técnica de Staging con /tmp

```bash
# PASO 1: Crear contenido completo en /tmp
cat > /tmp/FND_03_Taxonomia_BR.rst << 'ENDOFFILE'
.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Dominio: Sistema IVR Analytics (IACT)

========================================
FND-03: Taxonomía de Business Rules
========================================

[... CONTENIDO COMPLETO DEL ARCHIVO ...]
[... TODAS LAS LÍNEAS ...]
[... SIN LÍMITES DE TAMAÑO ...]

ENDOFFILE

# PASO 2: Validar localmente
wc -l /tmp/FND_03_*.rst
head -50 /tmp/FND_03_*.rst  # Ver inicio
tail -50 /tmp/FND_03_*.rst  # Ver final
grep -n "BR_014" /tmp/FND_03_*.rst  # Buscar referencias

# PASO 3: Copiar a destino
cp /tmp/FND_03_*.rst /mnt/user-data/outputs/base_cognitiva/
```

### Principios

1. **Un archivo a la vez:** Completar y validar antes de continuar
2. **Validación incremental:** Confirmar después de cada fase
3. **Sin límites:** Usar heredoc para archivos grandes
4. **Ejemplos reales:** Solo del proyecto IACT generado
5. **Coherencia:** Referencias correctas a UC/BR/AGR/CNST

---

## PLAN DE EJECUCIÓN POR FASES

### FASE 0: PREPARACIÓN (1-2h)

**Objetivo:** Inventariar documentación real del proyecto

#### Paso 0.1: Validar Casos de Uso Generados

```bash
# Verificar 49 UC generados
echo "=== INVENTARIO UC GENERADOS ==="
ls -1 /mnt/user-data/outputs/casos_uso_v4/*/UC_*.rst | wc -l

# Listar por módulo
for mod in auth users access pipeline reports alerts audit logs; do
  count=$(ls /mnt/user-data/outputs/casos_uso_v4/$mod/UC_*.rst 2>/dev/null | wc -l)
  echo "MOD_${mod^^}: $count UC"
done

# Verificar líneas totales
total=$(cat /mnt/user-data/outputs/casos_uso_v4/*/UC_*.rst | wc -l)
echo "TOTAL: $total líneas (esperado: ~23,401)"
```

#### Paso 0.2: Extraer Ejemplos Reales

Crear documento maestro: `EJEMPLOS_REALES_IACT_COMPLETO.md`

```markdown
# EJEMPLOS REALES DEL PROYECTO IACT

## Estadísticas Globales

- 49 UC generados (23,401 líneas)
- 8 módulos funcionales
- 20 BR identificadas
- 10 CNST arquitectónicas
- 10 AGR RBAC v5.1.1

## UC por Módulo

### MOD_Auth (5 UC - 3,251 líneas)

1. UC_AUTH_01_Iniciar_Sesion.rst
2. UC_AUTH_02_Cerrar_Sesion.rst
3. UC_AUTH_03_Recuperar_Contrasena.rst
4. UC_AUTH_04_Cambiar_Contrasena.rst
5. UC_AUTH_05_Gestionar_Sesiones.rst

### MOD_Alerts (5 UC - 2,565 líneas)

1. UC_ALR_01_Configurar_Umbrales.rst (544 líneas) ← **EJEMPLO PRINCIPAL**
2. UC_ALR_02_Ver_Alertas_Activas.rst (496 líneas)
3. UC_ALR_03_Reconocer_Alerta.rst (480 líneas)
4. UC_ALR_04_Ver_Historial_Alertas.rst (469 líneas)
5. UC_ALR_05_Gestionar_Suscripciones.rst (576 líneas)

### MOD_Reports (14 UC - 5,288 líneas)

1. UC_RPT_01_Ver_Dashboard.rst (434 líneas) ← **EJEMPLO SECUNDARIO**
2. UC_RPT_02_Ver_Metricas_Tiempo_Real.rst (456 líneas)
3. UC_RPT_03_Ver_Reportes_Historicos.rst (439 líneas)
4. UC_RPT_04_Exportar_CSV.rst (489 líneas)
5-14. [... otros 10 UC ...]

### MOD_Pipeline (4 UC - 1,778 líneas)

1. UC_PIP_01_Supervisar_ETL.rst (474 líneas)
2. UC_PIP_02_Consultar_Errores_ETL.rst (391 líneas)
3. UC_PIP_03_Consultar_Disponibilidad.rst (379 líneas)
4. UC_PIP_04_Solicitar_Reintento.rst (534 líneas)

## Las 20 BR del Sistema

[Tabla completa mostrada arriba]

## Los 10 AGR (RBAC v5.1.1)

[Tabla completa mostrada arriba]

## Las 10 CNST

[Tabla completa mostrada arriba]
```

**Comando de creación:**

```bash
cat > /tmp/EJEMPLOS_REALES_IACT_COMPLETO.md << 'ENDOFDOC'
[... contenido completo ...]
ENDOFDOC

cp /tmp/EJEMPLOS_REALES_IACT_COMPLETO.md /mnt/user-data/outputs/
```

**Entregable Fase 0:**
- `EJEMPLOS_REALES_IACT_COMPLETO.md` creado
- Inventario verificado: 49 UC, 20 BR, 10 AGR, 10 CNST

---

### FASE 1: PARTE 0 - INTRODUCCIÓN (3-4h)

**Objetivo:** Reescribir introducción con primer ejemplo del dominio IACT

#### Paso 1.1: Reescribir FND_00

**Archivo:** `FND_00_Contexto_y_Jerarquia.rst` (~500 líneas)

**Sección 1: Metadatos (líneas 1-10)**

```rst
.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE
   :Dominio: Sistema IVR Analytics (IACT)
   :Autor: Equipo IACT

===============================================
FND-00: Contexto y Jerarquía de Documentación
===============================================
```

**Sección 2: Caso de Estudio (líneas 150-200)**

```rst
1.3 Caso de Estudio
-------------------

Esta documentación pedagógica utiliza como caso de estudio el
**Sistema IACT** (IVR Analytics & Customer Tracking):

**Contexto:**

Sistema de análisis de llamadas telefónicas IVR para call center
con 8 módulos funcionales:

- **MOD_Auth:** Autenticación y sesiones (5 UC, 3,251 líneas)
- **MOD_Users:** Gestión de usuarios (4 UC, 2,584 líneas)
- **MOD_Access:** Control de acceso RBAC (9 UC, 4,180 líneas)
- **MOD_Pipeline:** Supervisión ETL (4 UC, 1,778 líneas)
- **MOD_Reports:** Reportería analítica (14 UC, 5,288 líneas)
- **MOD_Alerts:** Sistema de alertas (5 UC, 2,565 líneas)
- **MOD_Audit:** Auditoría y compliance (4 UC, 1,900 líneas)
- **MOD_Logs:** Bitácoras del sistema (4 UC, 1,855 líneas)

**Arquitectura:**

- Base de datos dual: MySQL IVR (readonly) + PostgreSQL Analytics
- ETL batch nocturno a las 02:00 AM (CNST_004)
- RBAC Flat con 44 funciones atómicas y 10 agrupadores
- 10 restricciones arquitectónicas (CNST_001 a CNST_010)

**Artefactos Documentados:**

- 49 Casos de Uso (23,401 líneas RST)
- 20 Business Rules (5 tipos)
- 147 Diagramas PlantUML
- Modelo RBAC v5.1.1
```

**Sección 3: Primer Ejemplo BR_011 (líneas 200-300)**

```rst
2. Ejemplo Introductorio: BR_011
---------------------------------

Para ilustrar los conceptos de esta documentación, usaremos
**BR_011: Límites de Exportación** como ejemplo guía.

2.1 Definición
~~~~~~~~~~~~~~

**BR_011 - Límites de Exportación**

:Tipo: Restricción
:CNST Relacionado: CNST_007 (Performance)
:Módulo: MOD_Reports

**Descripción:**

  Las exportaciones de reportes tienen límites máximos para
  garantizar el rendimiento del sistema y evitar timeouts:
  
  - Formato CSV: Máximo 100,000 registros
  - Formato Excel: Máximo 50,000 registros
  - Formato PDF: Máximo 10,000 registros
  
  Si el usuario intenta exportar más registros que el límite,
  el sistema rechaza la operación y muestra un mensaje de error
  indicando el límite aplicable.

2.2 Casos de Uso Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Esta regla de negocio impacta directamente a 3 UC:

- **UC_RPT_04_Exportar_CSV.rst** (489 líneas)
  
  Actor: AGR_008 (agr_exportador)
  Función RBAC: RPT-004 (exporta_csv)
  Precondición: Verificar COUNT(registros) <= 100,000

- **UC_RPT_05_Exportar_Excel.rst** (450 líneas)
  
  Actor: AGR_008 (agr_exportador)
  Función RBAC: RPT-005 (exporta_excel)
  Precondición: Verificar COUNT(registros) <= 50,000

- **UC_RPT_06_Exportar_PDF.rst** (427 líneas)
  
  Actor: AGR_008 (agr_exportador)
  Función RBAC: RPT-006 (exporta_pdf)
  Precondición: Verificar COUNT(registros) <= 10,000

2.3 Implementación Técnica
~~~~~~~~~~~~~~~~~~~~~~~~~~~

La BR_011 se implementa mediante validación en el servicio de
exportación:

.. code-block:: python

   # services/reports/export_service.py
   
   class ExportService:
       LIMITS = {
           'csv': 100_000,    # BR_011 + CNST_007
           'excel': 50_000,
           'pdf': 10_000
       }
       
       def validate_export(self, format: str, record_count: int):
           limit = self.LIMITS[format]
           
           if record_count > limit:
               raise ValidationError(
                   f"Límite excedido para formato {format.upper()}. "
                   f"Máximo permitido: {limit:,} registros. "
                   f"Solicitados: {record_count:,} registros. "
                   f"(BR_011 - CNST_007)"
               )

2.4 Relación con Otras BR
~~~~~~~~~~~~~~~~~~~~~~~~~~

BR_011 trabaja en conjunto con:

- **BR_012:** Usuario-Segmento Único
  
  El conteo de registros considera solo el segmento del usuario

- **BR_019:** Retención 2 Años
  
  Los registros exportables están limitados a los últimos 2 años

**Ejemplo combinado:**

Un usuario AGR_008 del segmento "Centro Lima" intenta exportar
150,000 llamadas del año 2024 en formato CSV.

- BR_012: Filtra solo registros del Centro Lima → 80,000 registros
- BR_019: Filtra solo 2024-2025 → 80,000 registros (dentro del rango)
- BR_011: Valida 80,000 < 100,000 → APROBADO

[... resto del contenido ...]
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

[... CONTENIDO COMPLETO ~500 LÍNEAS ...]

ENDOFFND00

# Validar
wc -l /tmp/FND_00_*.rst
head -50 /tmp/FND_00_*.rst
grep -n "BR_011" /tmp/FND_00_*.rst
grep -n "IACT" /tmp/FND_00_*.rst

# Copiar
cp /tmp/FND_00_*.rst /mnt/user-data/outputs/base_cognitiva/
```

**Checklist Validación Fase 1:**

```
[ ] Archivo ~500 líneas
[ ] Metadatos correctos (Versión 1.0.0, Fecha 2026-01-08)
[ ] Dominio IACT (NO químicos)
[ ] Ejemplo BR_011 (NO BR-028)
[ ] Referencias a UC_RPT_04, 05, 06
[ ] Actor AGR_008 (NO "Coordinador")
[ ] CNST_007 referenciado
[ ] 0 referencias a "químico", "contenedor", "OSHA"
```

**Entregable Fase 1:**
- `FND_00_Contexto_y_Jerarquia.rst`

---

### FASE 2: PARTE 1 - IDENTIFICAR BR (10-14h)

**Objetivo:** Reescribir taxonomía de 5 tipos de BR con ejemplos IACT

#### Paso 2.1: Reescribir FND_03_Taxonomia_BR.rst (CRÍTICO)

**Archivo:** `FND_03_Taxonomia_BR.rst` (~1500 líneas)

**Estimación:** 4-5 horas

**Estructura del archivo:**

```
1. Introducción (50 líneas)
2. Los 5 Tipos de Business Rules (1200 líneas)
   2.1 Tipo 1: Hecho (200 líneas)
   2.2 Tipo 2: Restricción (300 líneas)
   2.3 Tipo 3: Desencadenador (350 líneas) ← MÁS IMPORTANTE
   2.4 Tipo 4: Inferencia (200 líneas)
   2.5 Tipo 5: Cálculo (250 líneas)
3. Matriz de Clasificación (150 líneas)
4. Ejercicios Prácticos (100 líneas)
```

**Sección Crítica: Tipo 3 Desencadenador con BR_014**

```rst
2.3 Tipo 3: Desencadenador
---------------------------

2.3.1 Definición
~~~~~~~~~~~~~~~~

Un **Desencadenador** (Trigger) es una Business Rule que:

1. Detecta automáticamente una condición
2. Ejecuta una acción observable sin intervención humana
3. Genera un Caso de Uso o proceso automático

**Patrón lingüístico:**

  SI <condición temporal o de estado>
  ENTONCES <acción automática observable>

**Características distintivas:**

- Tiene componente temporal o threshold
- Sistema actúa automáticamente
- Resultado es observable por usuarios
- Genera UC con actor "Sistema"

2.3.2 Ejemplo Central: BR_014
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BR_014: Alerta por Umbral**

:Tipo: Desencadenador
:CNST Relacionado: CNST_001 (Solo InternalMessage)
:Módulo: MOD_Alerts
:UC Generado: UC_ALR_01_Configurar_Umbrales.rst

**Definición:**

  "SI una métrica del sistema excede el umbral configurado
   ENTONCES el sistema debe generar una alerta automática
   y notificarla a los suscriptores vía InternalMessage
   (buzón interno)."

**Análisis Estructural:**

Componente 1: Condición (SI)
  "métrica del sistema excede el umbral configurado"
  
  - Temporal: Sistema monitorea cada 5 minutos
  - Threshold: Valor definido por AGR_007 (supervisor)
  - Métricas monitoreables:
    * BR_016: Tasa de Abandono > 15%
    * BR_017: Tiempo Promedio Espera > 120 segundos
    * BR_018: Índice de Eficiencia < 85%

Componente 2: Acción (ENTONCES)
  "generar alerta y notificarla vía InternalMessage"
  
  - Automática: Sin intervención humana
  - Observable: Aparece en buzón interno del usuario
  - Registrada: Se guarda en tabla alerts
  - Auditable: Registro en UserActionLog (CNST_009)

**Flujo del Desencadenador:**

.. code-block:: text

   ┌──────────────────────────────────────────────┐
   │  Job: Monitor Umbrales (cada 5 minutos)     │
   ├──────────────────────────────────────────────┤
   │  1. Consultar alertas activas                │
   │  2. Para cada alerta:                        │
   │     2.1 Calcular métrica actual (BR_016-018) │
   │     2.2 Comparar con umbral configurado      │
   │     2.3 SI excede:                           │
   │         2.3.1 Crear registro en tabla alerts │
   │         2.3.2 Obtener suscriptores           │
   │         2.3.3 Enviar InternalMessage (CNST_001) │
   │         2.3.4 Registrar en UserActionLog     │
   │     2.4 SI NO excede: continuar             │
   │  3. Consolidar alertas repetidas (CNST_004)  │
   └──────────────────────────────────────────────┘

**Caso de Uso Generado: UC_ALR_01**

Este desencadenador genera el Caso de Uso:

  **UC_ALR_01: Configurar Umbrales** (544 líneas)
  
  :Actor: AGR_007 (agr_supervisor)
  :Función RBAC: ALR-002 (configura_alertas)
  :Trigger: Usuario selecciona "Nueva Alerta"
  :BR Origen: BR_014 (Desencadenador)

Flujo Normal (10 pasos):

1. Usuario accede a módulo Alertas
2. Usuario selecciona "Configurar Umbral"
3. Sistema muestra formulario con métricas disponibles
4. Usuario completa configuración:
   - Nombre descriptivo
   - Métrica (BR_016, BR_017 o BR_018)
   - Operador (>, <, >=, <=)
   - Valor umbral
   - Severidad (INFO, WARNING, CRITICAL)
   - Suscriptores (máx 50, CNST_004)
5. Sistema valida configuración
6. Sistema crea registro en tabla alerts con is_active=TRUE
7. Sistema registra en UserActionLog (CNST_009)
8. Sistema muestra confirmación
9. **A partir de aquí, BR_014 actúa automáticamente**
10. Finalizar

**Implementación Técnica:**

.. code-block:: python

   # jobs/monitor_alerts.py
   
   class AlertMonitorJob:
       """
       Job ejecutado cada 5 minutos para monitorear umbrales.
       Implementa BR_014: Alerta por Umbral
       """
       
       def execute(self):
           # 1. Obtener alertas activas
           alerts = Alert.objects.filter(is_active=True)
           
           for alert in alerts:
               # 2. Calcular métrica actual
               metric_value = self.calculate_metric(
                   alert.metric_id,
                   alert.time_window
               )
               
               # 3. Comparar con umbral (BR_014)
               if self.threshold_exceeded(
                   metric_value,
                   alert.operator,
                   alert.threshold
               ):
                   # 4. Generar alerta
                   self.trigger_alert(alert, metric_value)
       
       def trigger_alert(self, alert, current_value):
           # Crear registro de alerta
           alert_log = AlertLog.objects.create(
               alert=alert,
               triggered_at=now(),
               metric_value=current_value,
               severity=alert.severity
           )
           
           # Enviar a suscriptores vía InternalMessage (CNST_001)
           for subscriber in alert.subscribers.all():
               InternalMessage.send(
                   to_user=subscriber,
                   subject=f"Alerta {alert.severity}: {alert.name}",
                   body=f"Umbral excedido: {current_value}",
                   alert_log=alert_log
               )
           
           # Auditar (CNST_009)
           UserActionLog.record(
               action='ALERT_TRIGGERED',
               resource=f'alert:{alert.id}',
               details={'value': current_value}
           )

**Métricas Monitoreables:**

BR_014 puede aplicarse a las 3 métricas de cálculo:

1. **BR_016: Tasa de Abandono**
   
   Fórmula: (COUNT abandonadas / COUNT total) × 100
   Umbral típico: > 15% genera alerta WARNING
   Ejemplo: 18.5% → ALERTA ACTIVADA

2. **BR_017: Tiempo Promedio de Espera**
   
   Fórmula: AVG(tiempo_espera_segundos)
   Umbral típico: > 120 segundos genera alerta WARNING
   Ejemplo: 145 segundos → ALERTA ACTIVADA

3. **BR_018: Índice de Eficiencia**
   
   Fórmula: (COUNT atendidas / COUNT total) × 100
   Umbral típico: < 85% genera alerta CRITICAL
   Ejemplo: 78% → ALERTA ACTIVADA

**Restricciones Aplicables:**

- **CNST_001:** Notificaciones SOLO vía InternalMessage
  
  PROHIBIDO: Email, SMS, Webhook, Push notification
  PERMITIDO: Buzón interno en la aplicación

- **CNST_004:** Máximo 50 suscriptores por alerta
  
  Evita sobrecarga del sistema de notificaciones

- **CNST_009:** Auditoría inmutable
  
  Cada trigger de alerta se registra en UserActionLog
  sin posibilidad de UPDATE o DELETE

**Diferencia con Restricción:**

Es importante NO confundir Desencadenador con Restricción:

- **Restricción (Tipo 2):** VALIDA antes de permitir una acción
  
  Ejemplo: BR_011 rechaza exportación > 100k registros
  Momento: ANTES de la acción
  Resultado: Bloqueo o permiso

- **Desencadenador (Tipo 3):** EJECUTA después de detectar condición
  
  Ejemplo: BR_014 envía alerta cuando umbral excedido
  Momento: DESPUÉS de detectar condición
  Resultado: Acción automática

**Diagrama Comparativo:**

.. code-block:: text

   RESTRICCIÓN (BR_011):
   
   Usuario → [Intenta exportar 150k CSV]
        ↓
   Sistema → [Valida BR_011: 150k > 100k?] → SÍ
        ↓
   Sistema → [RECHAZA - Muestra error]
        ↓
   Usuario → [Ve mensaje de error]
   
   
   DESENCADENADOR (BR_014):
   
   Job Monitor → [Consulta métricas cada 5 min]
        ↓
   Job Monitor → [Tasa Abandono = 18.5%]
        ↓
   Job Monitor → [Compara: 18.5% > 15%?] → SÍ
        ↓
   Job Monitor → [ENVÍA InternalMessage automático]
        ↓
   Usuario AGR_007 → [Ve notificación en buzón]

[... continuar con más ejemplos y casos ...]
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

[... CONTENIDO COMPLETO ~1500 LÍNEAS ...]
[... LOS 5 TIPOS CON EJEMPLOS IACT ...]

ENDOFFND03

# Validar
wc -l /tmp/FND_03_*.rst
grep -c "BR_014" /tmp/FND_03_*.rst  # Debe aparecer 20+ veces
grep -c "BR_016" /tmp/FND_03_*.rst  # Debe aparecer en Tipo 5
grep -c "BR_011" /tmp/FND_03_*.rst  # Debe aparecer en Tipo 2
grep -c "UC_ALR_01" /tmp/FND_03_*.rst
grep -c "químico" /tmp/FND_03_*.rst  # Debe ser 0

# Copiar
cp /tmp/FND_03_*.rst /mnt/user-data/outputs/base_cognitiva/
```

**Checklist Validación FND_03:**

```
[ ] ~1500 líneas generadas
[ ] Tipo 3 (Desencadenador) tiene BR_014 como ejemplo
[ ] Tipo 5 (Cálculo) tiene BR_016, BR_017, BR_018
[ ] Tipo 2 (Restricción) tiene BR_011 y BR_007
[ ] Tipo 1 (Hecho) tiene BR_013
[ ] Tipo 4 (Inferencia) tiene BR_003
[ ] Referencias a UC_ALR_01 (NO UC-07)
[ ] Actor AGR_007 (NO "Coordinador Seguridad")
[ ] CNST_001, CNST_004, CNST_009 referenciados
[ ] 0 menciones a "químico", "contenedor", "OSHA"
[ ] Diagramas PlantUML con dominio IACT
```

**Entregable Fase 2.1:**
- `FND_03_Taxonomia_BR.rst` (4-5h)

---

#### Paso 2.2: Reescribir Matrices de Trazabilidad

**2.2.1 MTM_01_BR_a_UC_Trazabilidad.rst**

**Contenido:** Matriz completa BR→UC con las 20 BR y 49 UC reales

```rst
========================================
MTM-01: Matriz de Trazabilidad BR → UC
========================================

1. Matriz Completa
------------------

Esta matriz muestra la relación entre las 20 Business Rules
del sistema IACT y los 49 Casos de Uso generados.

**Leyenda:**

- **Genera:** El BR es origen directo del UC (Desencadenadores)
- **Restringe:** El BR valida precondiciones del UC (Restricciones)
- **Usa:** El UC ejecuta el cálculo definido en el BR (Cálculos)
- **Define:** El BR establece modelo de datos (Hechos)
- **Modifica:** El BR cambia estado automáticamente (Inferencias)

.. list-table:: Matriz BR → UC
   :widths: 10 20 15 15 40
   :header-rows: 1

   * - BR
     - Nombre
     - Tipo
     - Relación
     - UC Afectados
   * - BR_001
     - Fuente Inmutable
     - Restricción
     - Restringe
     - UC_PIP_01, UC_PIP_02, UC_PIP_03, UC_PIP_04
   * - BR_002
     - ETL Batch Nocturno
     - Desencadenador
     - Genera
     - UC_PIP_01 (origen directo)
   * - BR_003
     - Usuario Inactivo 90d
     - Inferencia
     - Modifica
     - UC_USR_02 (muestra estado calculado)
   * - BR_004
     - Comunicaciones Internas
     - Restricción
     - Restringe
     - UC_ALR_01, UC_ALR_02, UC_ALR_03, UC_RPT_07, UC_RPT_11
   * - BR_005
     - Sesión Única
     - Restricción
     - Restringe
     - UC_AUTH_01, UC_AUTH_05
   * - BR_006
     - RBAC Flat NIST
     - Hecho
     - Define
     - Todos los UC (modelo de permisos)
   * - BR_007
     - Separación Funciones SoD
     - Restricción
     - Restringe
     - UC_ACC_01, UC_ACC_02, UC_ACC_04, UC_ACC_08
   * - BR_008
     - Permisos con Vencimiento
     - Restricción
     - Restringe
     - UC_ACC_08 (Permiso Temporal)
   * - BR_009
     - Bajas Lógicas
     - Restricción
     - Restringe
     - UC_USR_03, UC_ALR_03
   * - BR_010
     - Auditoría Inmutable
     - Restricción
     - Restringe
     - UC_AUD_01, UC_AUD_02, UC_AUD_03, UC_AUD_04
   * - BR_011
     - Límites Exportación
     - Restricción
     - Restringe
     - UC_RPT_04, UC_RPT_05, UC_RPT_06, UC_AUD_03, UC_LOG_04
   * - BR_012
     - Usuario-Segmento Único
     - Hecho
     - Define
     - Todos UC de reportes (filtro automático)
   * - BR_013
     - Username Único
     - Hecho
     - Define
     - UC_USR_01 (validación en creación)
   * - BR_014
     - Alerta por Umbral
     - Desencadenador
     - Genera
     - UC_ALR_01 (origen directo)
   * - BR_015
     - Bloqueo Intentos Fallidos
     - Desencadenador
     - Genera
     - UC_AUTH_01 (bloqueo automático tras 5 intentos)
   * - BR_016
     - Tasa Abandono
     - Cálculo
     - Usa
     - UC_RPT_01, UC_RPT_02, UC_RPT_09, UC_ALR_01
   * - BR_017
     - Tiempo Promedio Espera
     - Cálculo
     - Usa
     - UC_RPT_01, UC_RPT_02, UC_RPT_09, UC_ALR_01
   * - BR_018
     - Índice Eficiencia
     - Cálculo
     - Usa
     - UC_RPT_01, UC_RPT_02, UC_RPT_09, UC_ALR_01
   * - BR_019
     - Retención 2 Años
     - Restricción
     - Restringe
     - Todos UC de consulta (rango temporal máx)
   * - BR_020
     - Clasificación Datos
     - Restricción
     - Restringe
     - Todos UC (sensibilidad de datos)

2. Análisis Estadístico
------------------------

Distribución de relaciones BR → UC:

- Total BR: 20
- Total UC: 49
- Total relaciones: 127
- Promedio relaciones/BR: 6.35 UC

Por tipo de BR:

- Restricciones (10): Promedio 8.2 UC afectados/BR
- Desencadenadores (3): Generan 1 UC directo + afectan múltiples
- Hechos (3): Afectan todos o casi todos los UC
- Inferencias (1): Modifica 1 UC
- Cálculos (3): Usados por 4-8 UC cada uno

3. BR con Mayor Impacto
-----------------------

BR que afectan 10+ UC:

1. **BR_006 (RBAC Flat):** 49 UC (100%) - Define modelo de permisos
2. **BR_012 (Usuario-Segmento):** 28 UC (57%) - Todos los reportes
3. **BR_020 (Clasificación Datos):** 49 UC (100%) - Sensibilidad
4. **BR_019 (Retención 2 Años):** 35 UC (71%) - Consultas históricas

[... más análisis ...]
```

**Estimación:** 3-4 horas

---

**2.2.2 MTM_02_UC_a_FR_Trazabilidad.rst**

**Contenido:** Matriz UC→FR con los 55 FR generados hasta ahora

```rst
========================================
MTM-02: Matriz de Trazabilidad UC → FR
========================================

1. Matriz Completa
------------------

.. list-table:: Matriz UC → FR
   :widths: 15 30 10 45
   :header-rows: 1

   * - UC
     - Nombre
     - # FR
     - FR Derivados
   * - UC_AUTH_01
     - Iniciar Sesión
     - 5
     - FR_UCAUTH_01_01 a FR_UCAUTH_01_05
   * - UC_AUTH_02
     - Cerrar Sesión
     - 3
     - FR_UCAUTH_02_01 a FR_UCAUTH_02_03
   * - [...]
     - [...]
     - [...]
     - [...]
   * - UC_ALR_01
     - Configurar Umbrales
     - ~8
     - (Pendiente generación FR)
   * - UC_RPT_01
     - Ver Dashboard
     - ~8
     - (Pendiente generación FR)

2. Estado de Generación FR
---------------------------

.. list-table:: Progreso FR por Módulo
   :widths: 20 10 10 10 10 15
   :header-rows: 1

   * - Módulo
     - UC
     - FR Est.
     - FR Gen.
     - Progreso
     - Estado
   * - MOD_Auth
     - 5
     - 40
     - 21
     - 52%
     - Parcial
   * - MOD_Users
     - 4
     - 32
     - 17
     - 53%
     - Parcial
   * - MOD_Access
     - 9
     - 72
     - 17
     - 24%
     - Parcial
   * - MOD_Pipeline
     - 4
     - 32
     - 0
     - 0%
     - Pendiente
   * - MOD_Reports
     - 14
     - 112
     - 0
     - 0%
     - Pendiente
   * - MOD_Alerts
     - 5
     - 40
     - 0
     - 0%
     - Pendiente
   * - MOD_Audit
     - 4
     - 32
     - 0
     - 0%
     - Pendiente
   * - MOD_Logs
     - 4
     - 32
     - 0
     - 0%
     - Pendiente
   * - **TOTAL**
     - **49**
     - **~392**
     - **55**
     - **14%**
     - En progreso

[... más contenido ...]
```

**Estimación:** 3-4 horas

**Entregable Fase 2:**
- `FND_03_Taxonomia_BR.rst` (1500 líneas)
- `MTM_01_BR_a_UC_Trazabilidad.rst` (1000 líneas)
- `MTM_02_UC_a_FR_Trazabilidad.rst` (1200 líneas)
- `MTM_03_Esquema_Trazabilidad.rst` (actualizado, 900 líneas)

---

### FASE 3: PARTE 2 - EJEMPLO CENTRAL UC_ALR_01 (6-8h)

**Objetivo:** Reescribir el ejemplo MÁS CRÍTICO de toda la documentación

**Archivo:** `TXM_01_Nomenclatura_UC_FR.rst` (~2000 líneas)

**Sección a reescribir:** Líneas 1500-1700 (200+ líneas de UC-07 → UC_ALR_01)

Este es el corazón de la documentación pedagógica. El ejemplo debe ser:
- Completo (10 pasos flujo normal, 5 flujos alternos)
- Técnicamente correcto (código Python real)
- Con diagramas PlantUML
- Derivación de 5 FR completos
- Trazabilidad total (BR, CNST, AGR, UC relacionados)

**Estimación:** 6-8 horas

**Entregable Fase 3:**
- `TXM_01_Nomenclatura_UC_FR.rst` con UC_ALR_01 completo (200+ líneas reescritas)

---

### FASE 4: PARTE 2 - EJEMPLO SECUNDARIO UC_RPT_01 (5-6h)

**Objetivo:** Segundo ejemplo más frecuente

**Archivo:** `TXM_04_Proceso_Construccion.rst` (~2500 líneas)

**Contenido:** Construcción paso a paso de UC_RPT_01 integrando BR_016, BR_017, BR_018

**Estimación:** 5-6 horas

**Entregable Fase 4:**
- `TXM_04_Proceso_Construccion.rst` con UC_RPT_01 completo

---

### FASE 5: PARTE 2 - OTROS EJEMPLOS (8-12h)

#### Paso 5.1: Patrones de Transformación

**Archivo:** `TXM_03_Patrones_Transformacion.rst` (~3000 líneas)

**5 Patrones con ejemplos IACT:**

1. **Patrón 1:** Hecho → Modelo de Datos
   - Ejemplo: BR_013 "Username Único" → Constraint UNIQUE en BD

2. **Patrón 2:** Restricción → Precondición de UC
   - Ejemplo: BR_007 "SoD" → Validación en UC_ACC_01

3. **Patrón 3:** Desencadenador → UC Automático
   - Ejemplo: BR_014 → UC_ALR_01 (ya hecho en Fase 3)

4. **Patrón 4:** Inferencia → FR de Cálculo de Estado
   - Ejemplo: BR_003 "Usuario Inactivo 90d" → FR automático

5. **Patrón 5:** Cálculo → Paso de UC
   - Ejemplo: BR_016 "Tasa Abandono" → Paso 6.2 de UC_RPT_01

**Estimación:** 4-5 horas

---

#### Paso 5.2: Ejercicios Prácticos

Actualizar secciones de ejercicios en múltiples archivos.

**Ejercicio 4: Sistema IACT Completo**

Reemplazar "Biblioteca" con caso IACT:
- 4 BR reales (BR_002, BR_014, BR_016, BR_007)
- 3 UC generados (UC_PIP_01, UC_ALR_01, UC_RPT_01)
- 12+ FR derivados
- Matriz de trazabilidad completa

**Estimación:** 4-5 horas

**Entregable Fase 5:**
- `TXM_03_Patrones_Transformacion.rst`
- `TXM_05_Integracion_BR.rst`
- `TXM_06_Derivacion_FR.rst`
- Ejercicios actualizados

---

### FASE 6: ACTUALIZACIÓN REFERENCIAS (3-4h)

**Objetivo:** Actualizar referencias en 16 archivos restantes

Buscar y reemplazar en todos los archivos:

```bash
# Script de actualización masiva
cd /tmp/base_cognitiva/

# Reemplazar referencias a UC antiguos
sed -i 's/UC-07/UC_ALR_01/g' *.rst
sed -i 's/UC-04/UC_RPT_01/g' *.rst
sed -i 's/UC-09/UC_ACC_01/g' *.rst

# Reemplazar referencias a BR antiguos
sed -i 's/BR-031/BR_014/g' *.rst
sed -i 's/BR-028/BR_011/g' *.rst
sed -i 's/BR-060/BR_016/g' *.rst
sed -i 's/BR-087/BR_007/g' *.rst

# Reemplazar actores
sed -i 's/Coordinador de Seguridad/AGR_007 (supervisor)/g' *.rst
sed -i 's/Propietario/AGR_005 (analista)/g' *.rst
sed -i 's/Gerente/AGR_001 (superadmin)/g' *.rst

# Eliminar referencias a dominio químicos
sed -i 's/producto químico/llamada telefónica/gi' *.rst
sed -i 's/contenedor/registro de llamada/gi' *.rst
sed -i 's/OSHA/CNST_005/g' *.rst

# Validar
grep -r "UC-0" . | wc -l  # Debe ser 0
grep -r "BR-0" . | wc -l  # Debe ser 0
grep -r "químico" . | wc -l  # Debe ser 0
```

**Archivos afectados:**
- FND_01, FND_02 (actualizar términos)
- TXM_02 (plantillas)
- TXM_05, TXM_06, TXM_07, TXM_08 (referencias)
- glosario.rst, referencias.rst
- index.rst (TOC)
- plantilla_uc.rst (formato)

**Estimación:** 3-4 horas

---

### FASE 7: VALIDACIÓN FINAL (2h)

**Objetivo:** Validar coherencia y compilación Sphinx

#### Paso 7.1: Validación Técnica

```bash
cd /mnt/user-data/outputs/base_cognitiva/

# 1. Compilar con Sphinx
make clean
make html

# Verificar errores
grep -i "warning" _build/*.log
grep -i "error" _build/*.log

# 2. Validar trazabilidad
echo "=== VALIDACIÓN TRAZABILIDAD ==="

# Verificar UC reales
grep -r "UC_ALR_01" *.rst | wc -l  # Debe ser 30+
grep -r "UC_RPT_01" *.rst | wc -l  # Debe ser 20+
grep -r "UC_PIP_01" *.rst | wc -l  # Debe ser 10+

# Verificar BR reales
grep -r "BR_014" *.rst | wc -l  # Debe ser 30+
grep -r "BR_011" *.rst | wc -l  # Debe ser 20+
grep -r "BR_016" *.rst | wc -l  # Debe ser 15+

# Verificar CNST con guión bajo
grep -r "CNST_001" *.rst | wc -l  # Debe ser 50+
grep -r "CNST_004" *.rst | wc -l  # Debe ser 30+
grep -r "CNST_009" *.rst | wc -l  # Debe ser 40+

# Verificar AGR con guión bajo
grep -r "AGR_007" *.rst | wc -l  # Debe ser 20+
grep -r "AGR_005" *.rst | wc -l  # Debe ser 15+

# 3. Verificar ELIMINACIÓN de referencias incorrectas
echo "=== VERIFICACIÓN ELIMINACIÓN ==="

# NO debe haber UC antiguos
grep -r "UC-07" *.rst | wc -l  # Debe ser 0
grep -r "UC-04" *.rst | wc -l  # Debe ser 0

# NO debe haber BR antiguos
grep -r "BR-028" *.rst | wc -l  # Debe ser 0
grep -r "BR-031" *.rst | wc -l  # Debe ser 0
grep -r "BR-060" *.rst | wc -l  # Debe ser 0

# NO debe haber dominio químicos
grep -ri "químico" *.rst | wc -l  # Debe ser 0
grep -ri "contenedor" *.rst | wc -l  # Debe ser 0
grep -r "OSHA" *.rst | wc -l  # Debe ser 0

# NO debe haber actores genéricos
grep -r "Coordinador de Seguridad" *.rst | wc -l  # Debe ser 0
grep -r "Propietario" *.rst | wc -l  # Debe ser 0
```

#### Paso 7.2: Checklist Final

```
COHERENCIA CON PROYECTO IACT:
[ ] 30+ referencias a UC_ALR_01 (NO UC-07)
[ ] 20+ referencias a BR_014 (NO BR-031)
[ ] 50+ referencias a CNST_001 con guión bajo
[ ] 20+ referencias a AGR_007 con guión bajo
[ ] 0 referencias a "UC-07", "BR-028", "BR-031"
[ ] 0 menciones a "químico", "contenedor", "OSHA"
[ ] 0 actores genéricos ("Coordinador", "Propietario")

NOMENCLATURA:
[ ] Archivos FND/MTM/TXM SIN versionado
[ ] Referencias a UC con formato UC_ALR_01 (sin _4_0_0)
[ ] Referencias a BR con formato BR_014
[ ] Referencias a CNST con guión bajo (CNST_001)
[ ] Referencias a AGR con guión bajo (AGR_007)

COMPILACIÓN SPHINX:
[ ] make html exitoso (0 errores)
[ ] Warnings solo informativos
[ ] TOC generado correctamente
[ ] Diagramas PlantUML renderizan

EJEMPLOS CRÍTICOS:
[ ] UC_ALR_01 completo en TXM_01 (200+ líneas)
[ ] BR_014 ejemplo principal en FND_03
[ ] UC_RPT_01 construcción en TXM_04
[ ] Matriz BR→UC con 20 BR en MTM_01
[ ] Matriz UC→FR con 49 UC en MTM_02
```

**Estimación:** 2 horas

---

## RESUMEN DE ENTREGABLES

### Por Fase

| Fase | Archivos | Líneas Est. | Horas |
|------|----------|-------------|-------|
| 0 | EJEMPLOS_REALES_IACT_COMPLETO.md | ~2000 | 1-2h |
| 1 | FND_00_Contexto_y_Jerarquia.rst | ~500 | 3-4h |
| 2 | FND_03 + MTM_01 + MTM_02 + MTM_03 | ~4600 | 10-14h |
| 3 | TXM_01 (con UC_ALR_01) | ~2000 | 6-8h |
| 4 | TXM_04 (con UC_RPT_01) | ~2500 | 5-6h |
| 5 | TXM_03 + TXM_05 + TXM_06 + Ejercicios | ~6800 | 8-12h |
| 6 | 16 archivos actualizados | ~8000 | 3-4h |
| 7 | Validación y reporte | - | 2h |
| **TOTAL** | **27 archivos** | **~26,400** | **38-52h** |

### Archivos Críticos (Prioridad 1)

1. `FND_03_Taxonomia_BR.rst` (1500 líneas) - 5 tipos de BR
2. `TXM_01_Nomenclatura_UC_FR.rst` (2000 líneas) - UC_ALR_01 completo
3. `MTM_01_BR_a_UC_Trazabilidad.rst` (1000 líneas) - Matriz 20 BR
4. `TXM_04_Proceso_Construccion.rst` (2500 líneas) - UC_RPT_01 completo
5. `TXM_03_Patrones_Transformacion.rst` (3000 líneas) - 5 patrones

---

## ESTRATEGIA DE EJECUCIÓN

### Orden Recomendado

1. **FASE 0:** Preparar inventario completo
2. **FASE 1:** Introducción con primer ejemplo
3. **FASE 2.1:** FND_03 (CRÍTICO - Taxonomía)
4. **VALIDACIÓN PARCIAL:** Confirmar FND_03 correcto
5. **FASE 2.2:** Matrices MTM_01, MTM_02
6. **FASE 3:** TXM_01 con UC_ALR_01 (CRÍTICO)
7. **VALIDACIÓN PARCIAL:** Confirmar UC_ALR_01 correcto
8. **FASE 4:** TXM_04 con UC_RPT_01
9. **FASE 5:** Otros ejemplos y patrones
10. **FASE 6:** Actualización masiva referencias
11. **FASE 7:** Validación final y Sphinx build

### Puntos de Decisión

Después de cada fase crítica (FND_03, TXM_01), **DETENER** y:
1. Validar calidad del contenido
2. Confirmar ejemplos correctos
3. Verificar coherencia con proyecto
4. Obtener aprobación para continuar

---

## COMANDO PARA INICIAR

```bash
echo "=============================================="
echo "  REESCRITURA BASE_COGNITIVA/ - FASE 0"
echo "=============================================="
echo ""
echo "OBJETIVO: Preparar inventario de ejemplos IACT reales"
echo ""
echo "Iniciando Fase 0: Preparación..."
echo ""
```

---

## DECISIÓN REQUERIDA

¿Proceder con FASE 0: Preparación?

Próximos pasos inmediatos:
1. Crear `EJEMPLOS_REALES_IACT_COMPLETO.md` (inventario)
2. Validar 49 UC generados (23,401 líneas)
3. Listar 20 BR, 10 AGR, 10 CNST
4. Confirmar metodología de staging /tmp

**PLAN MAESTRO COMPLETADO**

Fecha: 2026-01-08  
Versión: 3.0.0 FINAL  
Estado: Listo para ejecución por fases  
Total páginas: 50+  
Total palabras: 25,000+
