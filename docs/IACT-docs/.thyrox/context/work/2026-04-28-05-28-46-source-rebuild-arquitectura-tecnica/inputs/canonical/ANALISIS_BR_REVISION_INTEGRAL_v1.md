# ANÁLISIS INTEGRAL DE REGLAS DE NEGOCIO IACT
## Revisión: BR Existentes vs MODELO_RBAC_v5.1.1 + Cobertura CNST

**Versión:** 1.0  
**Fecha:** 2026-01-03  
**Propósito:** Validar las 18 BR definidas en MODELO_DOCUMENTAL_v2.0.3 contra el MODELO_RBAC_IACT_v5.1.1 y los 10 CNST

---

## 1. RESUMEN EJECUTIVO

### 1.1 Fuentes Analizadas

| Documento | Versión | Contenido Relevante |
|-----------|---------|---------------------|
| MODELO_DOCUMENTAL_IACT | v2.0.3-rev1 | 18 BR identificadas |
| MODELO_RBAC_IACT | v5.1.1 | 44 funciones atómicas, 3 SoD, 10 agrupadores |
| CNST_001 a CNST_010 | v1.0.0 | 10 restricciones técnicas del sistema |

### 1.2 Veredicto General

| Aspecto | Estado | Observación |
|---------|--------|-------------|
| Cantidad BR | ⚠️ REVISAR | 18 definidas, pero hay gaps y redundancias |
| Cobertura CNST | ⚠️ INCOMPLETA | 7/10 CNST cubiertos |
| Alineación RBAC v5.1.1 | ⚠️ PARCIAL | BR_006 y BR_007 requieren actualización |
| Tipificación | ✅ CORRECTA | 5 tipos bien aplicados |
| Nomenclatura | ⚠️ INCONSISTENTE | Gaps en numeración (BR_003 vs BR_015) |

---

## 2. ANÁLISIS DE COBERTURA CNST → BR

### 2.1 Matriz de Cobertura

| CNST | Nombre | BR Asignada | Estado | Observación |
|------|--------|-------------|--------|-------------|
| CNST_001 | Comunicaciones Prohibidas | BR_004 | ✅ CORRECTO | NO email, solo buzón interno |
| CNST_002 | Gestión Sesiones BD | BR_005 | ✅ CORRECTO | Sesión única, timeout 15min |
| CNST_003 | BD Dual Inmutable | BR_001 | ✅ CORRECTO | BD IVR solo lectura |
| CNST_004 | Actualización ETL | BR_002 | ✅ CORRECTO | ETL batch cada 6-12h |
| CNST_005 | Seguridad DRF | BR_006, BR_007, BR_008, BR_009, BR_015 | ⚠️ FRAGMENTADO | 5 BR para 1 CNST - revisar granularidad |
| CNST_006 | Antipatrones Arquitectura | ❌ SIN BR | ❌ GAP | NO es BR, es estándar de código |
| CNST_007 | Límites Performance/SLA | BR_011 | ⚠️ PARCIAL | Solo cubre exportación, falta rango 2 años |
| CNST_008 | Infraestructura/Deployment | ❌ SIN BR | ❌ GAP | NO es BR, es restricción técnica |
| CNST_009 | Logging/Auditoría | BR_010 | ✅ CORRECTO | Auditoría inmutable |
| CNST_010 | Clasificación Datos | ❌ SIN BR | ⚠️ PARCIAL | Implícito en segmentos pero sin BR explícita |

### 2.2 Diagnóstico de Cobertura

```
CNST Cubiertos Correctamente:    5/10 (50%)
CNST Cubiertos Parcialmente:     2/10 (20%)
CNST Sin Cobertura (no aplican): 2/10 (20%) → CNST_006, CNST_008
CNST Sin Cobertura (aplican):    1/10 (10%) → CNST_010
```

### 2.3 Análisis por CNST

#### CNST_006 (Antipatrones) - NO REQUIERE BR
**Justificación:** Este CNST define estándares de calidad de código (evitar God Class, N+1 queries, etc.). No es una regla de negocio sino un estándar de desarrollo que debe reflejarse en:
- STD_001_Estandares_Codigo.rst (normativa/)
- ADR-QA-001 (decisiones arquitectónicas)

#### CNST_008 (Infraestructura) - NO REQUIERE BR
**Justificación:** Define restricciones de deployment (Apache/mod_wsgi, NO Docker). No es regla de negocio sino restricción técnica de infraestructura que debe reflejarse en:
- ADR_XXX_Infraestructura_Deployment.rst
- PROC_XXX_Deployment.rst

#### CNST_010 (Clasificación Datos) - REQUIERE BR NUEVA
**Justificación:** Define 4 niveles de clasificación (C1-PÚBLICO a C4-RESTRINGIDO) que afectan el acceso a datos. Esto SÍ es una regla de negocio que debe formalizarse:
- **Propuesta:** Crear BR_019_Clasificacion_Datos

---

## 3. ANÁLISIS DE ALINEACIÓN CON MODELO_RBAC_v5.1.1

### 3.1 BR Relacionadas con RBAC

| BR | Nombre Actual | ¿Alineada con v5.1.1? | Problema |
|----|---------------|----------------------|----------|
| BR_006 | RBAC Flat NIST | ⚠️ PARCIAL | No menciona 44 funciones atómicas ni filosofía "Sin Pretensiones" |
| BR_007 | Separación Funciones SoD | ⚠️ PARCIAL | Solo menciona concepto, no las 3 restricciones específicas (SOD-001, SOD-002, SOD-003) |
| BR_008 | Permisos con Vencimiento | ✅ OK | Alineado con CNST_005 |
| BR_009 | Bajas Lógicas | ✅ OK | Alineado con USR-004 (elimina_usuarios) |
| BR_012 | Usuario-Segmento Único | ✅ OK | Alineado con 5 segmentos del RBAC v5.1.1 |

### 3.2 Problemas Detectados

#### BR_006: Requiere Actualización

**Contenido Actual (implícito):**
```
"El sistema implementa RBAC Flat según NIST"
```

**Contenido Requerido (según RBAC v5.1.1):**
```
El sistema implementa RBAC Flat con las siguientes características:
- 44 funciones atómicas distribuidas en 8 módulos
- Filosofía "Sin Pretensiones": nombres describen QUÉ HACE, no QUIÉN ES
- 10 agrupadores predefinidos (AGR-001 a AGR-010)
- Precedencia: Permiso Directo > Función Asignada > Segmento
- NO existe jerarquía de roles (roles flat)
```

#### BR_007: Requiere Actualización

**Contenido Actual (implícito):**
```
"El sistema implementa separación de funciones"
```

**Contenido Requerido (según RBAC v5.1.1):**
```
El sistema implementa 3 restricciones SoD obligatorias:

SOD-001: sod_admin_auditoria
  - Grupo A: PIP-001, PIP-002, PIP-003, PIP-004 (funciones Pipeline)
  - Grupo B: AUD-001, AUD-002, AUD-003, AUD-004 (funciones Auditoría)
  - Regla: Quien opera pipeline NO puede auditar

SOD-002: sod_usuarios_auditoria
  - Grupo A: USR-001, USR-003, USR-004, USR-007 (gestión usuarios)
  - Grupo B: AUD-001, AUD-002, AUD-003 (auditoría)
  - Regla: Quien gestiona usuarios NO puede auditar

SOD-003: sod_acceso_auditoria
  - Grupo A: ACC-001, ACC-002, ACC-005 (gestión acceso)
  - Grupo B: AUD-001, AUD-002 (auditoría)
  - Regla: Quien gestiona acceso NO puede auditar
```

### 3.3 Mapeo BR → Funciones RBAC v5.1.1

| BR | Funciones Atómicas Afectadas |
|----|------------------------------|
| BR_001 | PIP-001 (ve_estado_etl), RPT-001 (ve_reportes) |
| BR_002 | PIP-001, PIP-002, PIP-003, PIP-004 |
| BR_003 | USR-009 (reactiva_usuarios) |
| BR_004 | AUT-003 (resetea_password), ALR-002 (configura_alertas) |
| BR_005 | AUT-001 (gestiona_sesiones), AUT-002, AUT-004 |
| BR_006 | ACC-001 a ACC-006 (todas las de acceso) |
| BR_007 | ACC-005 (gestiona_sod) |
| BR_008 | ACC-001 (asigna_funciones) |
| BR_009 | USR-004 (elimina_usuarios) |
| BR_010 | AUD-001 a AUD-004 (todas las de auditoría) |
| BR_011 | RPT-004, RPT-005, RPT-006 (exportaciones) |
| BR_012 | USR-010 (asigna_segmento), ACC-006 (gestiona_segmentos) |
| BR_013 | USR-001 (crea_usuarios) |
| BR_014 | ALR-002 (configura_alertas) |
| BR_015 | AUT-001 (gestiona_sesiones) |
| BR_016-018 | RPT-007 (ve_kpis) |

---

## 4. ANÁLISIS POR TIPO DE BR

### 4.1 Distribución por Tipo

| Tipo | Cantidad | BR |
|------|----------|-----|
| Restricción | 8 | BR_001, BR_004, BR_005, BR_007, BR_008, BR_009, BR_010, BR_011 |
| Hecho | 3 | BR_006, BR_012, BR_013 |
| Desencadenador | 3 | BR_002, BR_014, BR_015 |
| Inferencia | 1 | BR_003 |
| Cálculo | 3 | BR_016, BR_017, BR_018 |
| **TOTAL** | **18** | |

### 4.2 Validación de Tipificación

| BR | Tipo Asignado | ¿Correcto? | Análisis |
|----|---------------|------------|----------|
| BR_001 | Restricción | ✅ SÍ | "BD IVR NO DEBE ser modificada" → Deóntica |
| BR_002 | Desencadenador | ✅ SÍ | "SI hora=batch ENTONCES ejecutar ETL" → Visible |
| BR_003 | Inferencia | ✅ SÍ | "SI inactivo 90d ENTONCES estado=INACTIVO" → Interno |
| BR_004 | Restricción | ✅ SÍ | "Sistema NO DEBE enviar emails" → Deóntica |
| BR_005 | Restricción | ✅ SÍ | "Usuario DEBE tener sesión única" → Deóntica |
| BR_006 | Hecho | ✅ SÍ | "Sistema ES RBAC Flat" → Aléctica |
| BR_007 | Restricción | ✅ SÍ | "Funciones conflictivas NO DEBEN asignarse juntas" → Deóntica |
| BR_008 | Restricción | ✅ SÍ | "Permisos directos DEBEN tener vencimiento" → Deóntica |
| BR_009 | Restricción | ✅ SÍ | "Usuarios NO DEBEN eliminarse físicamente" → Deóntica |
| BR_010 | Restricción | ✅ SÍ | "Auditoría NO DEBE ser modificable" → Deóntica |
| BR_011 | Restricción | ✅ SÍ | "Exportaciones NO DEBEN exceder límites" → Deóntica |
| BR_012 | Hecho | ✅ SÍ | "Usuario PERTENECE a un segmento" → Aléctica |
| BR_013 | Hecho | ✅ SÍ | "Username ES único" → Aléctica |
| BR_014 | Desencadenador | ✅ SÍ | "SI métrica > umbral ENTONCES crear alerta" → Visible |
| BR_015 | Desencadenador | ✅ SÍ | "SI intentos > 5 ENTONCES bloquear" → Visible |
| BR_016 | Cálculo | ✅ SÍ | "Tasa = abandonos / total * 100" → Fórmula |
| BR_017 | Cálculo | ✅ SÍ | "TPE = suma(tiempos) / count" → Fórmula |
| BR_018 | Cálculo | ✅ SÍ | "IE = atendidas / recibidas * 100" → Fórmula |

**Resultado:** 18/18 BR correctamente tipificadas ✅

---

## 5. PROBLEMAS IDENTIFICADOS

### 5.1 Problemas Estructurales

| # | Problema | Severidad | Impacto |
|---|----------|-----------|---------|
| P1 | Gap en numeración (no hay BR_003 "RBAC") | 🟡 Media | Confusión, BR_003 es "Usuario Inactivo" |
| P2 | BR_006 y BR_007 no alineadas con RBAC v5.1.1 | 🔴 Alta | Documentación desactualizada |
| P3 | CNST_007 parcialmente cubierto | 🟡 Media | Falta BR para rango máximo 2 años |
| P4 | CNST_010 sin BR explícita | 🟡 Media | Clasificación de datos implícita |
| P5 | 5 BR derivan de CNST_005 | 🟢 Baja | Fragmentación pero justificada |

### 5.2 Detalle de Problemas

#### P1: Gap en Numeración
El MODELO_DOCUMENTAL anterior tenía:
- BR_001: Fuente Inmutable
- BR_002: ETL Batch
- BR_003: Control de Acceso RBAC ← **ESTA ERA LA VIEJA**

El nuevo MODELO_DOCUMENTAL tiene:
- BR_003: Usuario Inactivo 90d ← **DIFERENTE**
- BR_006: RBAC Flat NIST ← **Nueva ubicación**

**Recomendación:** Documentar explícitamente el cambio de numeración o renumerar.

#### P2: Desalineación RBAC v5.1.1
Las BR relacionadas con RBAC no reflejan:
- 44 funciones atómicas (solo mencionan "RBAC Flat")
- 3 reglas SoD específicas con IDs (SOD-001, SOD-002, SOD-003)
- 10 agrupadores (AGR-001 a AGR-010)
- Filosofía "Sin Pretensiones"

#### P3: CNST_007 Parcial
BR_011 cubre límites de exportación pero no:
- Rango máximo de reportes: 730 días (2 años)
- Tiempos de respuesta API (200ms target, 500ms máx)

**Recomendación:** Crear BR_020_Rango_Temporal_Reportes

---

## 6. PROPUESTA DE BR CORREGIDAS

### 6.1 Catálogo Propuesto (20 BR)

| BR | Nombre | Tipo | CNST | Estado |
|----|--------|------|------|--------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 | ✅ Mantener |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 | ✅ Mantener |
| BR_003 | Usuario Inactivo 90d | Inferencia | -- | ✅ Mantener |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 | ✅ Mantener |
| BR_005 | Sesión Única | Restricción | CNST_002 | ✅ Mantener |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 | ⚠️ **ACTUALIZAR** |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 | ⚠️ **ACTUALIZAR** |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 | ✅ Mantener |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 | ✅ Mantener |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 | ✅ Mantener |
| BR_011 | Límites Exportación | Restricción | CNST_007 | ✅ Mantener |
| BR_012 | Usuario-Segmento Único | Hecho | -- | ✅ Mantener |
| BR_013 | Username Único | Hecho | -- | ✅ Mantener |
| BR_014 | Alerta por Umbral | Desencadenador | -- | ✅ Mantener |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 | ✅ Mantener |
| BR_016 | Tasa Abandono | Cálculo | -- | ✅ Mantener |
| BR_017 | Tiempo Promedio Espera | Cálculo | -- | ✅ Mantener |
| BR_018 | Índice Eficiencia | Cálculo | -- | ✅ Mantener |
| **BR_019** | **Clasificación Datos** | **Hecho** | **CNST_010** | 🆕 **NUEVA** |
| **BR_020** | **Rango Temporal Reportes** | **Restricción** | **CNST_007** | 🆕 **NUEVA** |

### 6.2 Contenido de BR a Actualizar

#### BR_006: RBAC Flat NIST (ACTUALIZADA)

```rst
BR-006: RBAC Flat NIST
======================

:ID: BR-006
:Tipo: HECHO (Aléctica)
:CNST: CNST_005
:Versión: 2.0.0
:Estado: Vigente

Declaración
-----------

El sistema IACT implementa un modelo RBAC (Role-Based Access Control) 
de tipo Flat (sin jerarquía de roles) con las siguientes características:

Estructura del Modelo
~~~~~~~~~~~~~~~~~~~~~

+------------------+--------+--------------------------------+
| Componente       | Cant.  | Descripción                    |
+==================+========+================================+
| Funciones        | 44     | Atómicas, por módulo IACT      |
| Agrupadores      | 10     | Conjuntos predefinidos (AGR-*) |
| Segmentos        | 5      | OP, FI, TE, SU, CA             |
| Restricciones SoD| 3      | SOD-001, SOD-002, SOD-003      |
+------------------+--------+--------------------------------+

Filosofía "Sin Pretensiones"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona:

- ✅ CORRECTO: ``crea_usuarios``, ``ve_reportes``, ``exporta_csv``
- ❌ INCORRECTO: ``USERS_FULL_MANAGER``, ``SYSTEM_ADMIN``

Precedencia de Permisos
~~~~~~~~~~~~~~~~~~~~~~~

::

    Permiso Directo > Función Asignada > Segmento

Funciones por Módulo
~~~~~~~~~~~~~~~~~~~~

- MOD_Auth (AUT): 4 funciones
- MOD_Users (USR): 10 funciones
- MOD_Access (ACC): 6 funciones
- MOD_Pipeline (PIP): 4 funciones
- MOD_Reports (RPT): 8 funciones
- MOD_Alerts (ALR): 6 funciones
- MOD_Audit (AUD): 4 funciones
- MOD_Logs (LOG): 2 funciones

Trazabilidad
------------

- Origen: MODELO_RBAC_IACT_v5.1.1
- UC Relacionados: UC-010, UC-011, UC-041-047
- Funciones: ACC-001 a ACC-006
```

#### BR_007: Separación Funciones SoD (ACTUALIZADA)

```rst
BR-007: Separación de Funciones (SoD)
=====================================

:ID: BR-007
:Tipo: RESTRICCIÓN (Deóntica)
:CNST: CNST_005
:Versión: 2.0.0
:Estado: Vigente

Declaración
-----------

Un usuario NO DEBE tener asignadas simultáneamente funciones que 
pertenezcan a grupos en conflicto según las restricciones SoD definidas.

Restricciones SoD Obligatorias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**SOD-001: sod_admin_auditoria**

- Razón: Quien opera pipeline NO puede auditar el sistema
- Grupo A (Pipeline): PIP-001, PIP-002, PIP-003, PIP-004
- Grupo B (Auditoría): AUD-001, AUD-002, AUD-003, AUD-004
- Conflicto: A ⚔️ B

**SOD-002: sod_usuarios_auditoria**

- Razón: Quien gestiona usuarios NO puede auditar sus cambios
- Grupo A (Usuarios): USR-001, USR-003, USR-004, USR-007
- Grupo B (Auditoría): AUD-001, AUD-002, AUD-003
- Conflicto: A ⚔️ B

**SOD-003: sod_acceso_auditoria**

- Razón: Quien gestiona acceso NO puede auditar cambios de permisos
- Grupo A (Acceso): ACC-001, ACC-002, ACC-005
- Grupo B (Auditoría): AUD-001, AUD-002
- Conflicto: A ⚔️ B

Enforcement
-----------

- Validación en tiempo de asignación (ACC-001)
- Validación en tiempo de ejecución (SEC_RULES middleware)
- No aplican excepciones

Trazabilidad
------------

- Origen: MODELO_RBAC_IACT_v5.1.1, CNST_005
- UC: UC-043 (Configurar SoD)
- Función: ACC-005 (gestiona_sod)
```

### 6.3 Contenido de BR Nuevas

#### BR_019: Clasificación de Datos (NUEVA)

```rst
BR-019: Clasificación de Datos
==============================

:ID: BR-019
:Tipo: HECHO (Aléctica)
:CNST: CNST_010
:Versión: 1.0.0
:Estado: Vigente

Declaración
-----------

Los datos del sistema IACT están clasificados en 4 niveles según 
su sensibilidad, determinando quién puede acceder y qué tratamiento requieren.

Niveles de Clasificación
~~~~~~~~~~~~~~~~~~~~~~~~

+-------+---------------+------------------------------------------+
| Nivel | Nombre        | Descripción                              |
+=======+===============+==========================================+
| C1    | PÚBLICO       | Cualquier usuario autenticado            |
| C2    | INTERNO       | Usuarios con función específica          |
| C3    | CONFIDENCIAL  | Solo roles supervisión                   |
| C4    | RESTRINGIDO   | Solo auditoría y compliance              |
+-------+---------------+------------------------------------------+

Datos por Clasificación
~~~~~~~~~~~~~~~~~~~~~~~

- **C1 (PÚBLICO):** Métricas agregadas, KPIs generales, dashboards
- **C2 (INTERNO):** Detalle de llamadas, tiempos, centros
- **C3 (CONFIDENCIAL):** Datos de agentes, rendimiento individual
- **C4 (RESTRINGIDO):** Logs de auditoría, datos de acceso

Segmentos de Datos IACT
~~~~~~~~~~~~~~~~~~~~~~~

- OP: Datos operativos (llamadas, tiempos)
- FI: Datos financieros (costos por llamada)
- TE: Datos técnicos (errores, logs)
- SU: Datos de supervisión (rendimiento agentes)
- CA: Datos de calidad (encuestas, NPS)

Tratamiento
-----------

- C3 y C4 requieren enmascaramiento en exportaciones
- PII nunca se exporta en texto plano
- Acceso a C4 genera registro de auditoría nivel CRITICAL

Trazabilidad
------------

- Origen: CNST_010
- Funciones: ACC-006 (gestiona_segmentos)
```

#### BR_020: Rango Temporal Reportes (NUEVA)

```rst
BR-020: Rango Temporal de Reportes
==================================

:ID: BR-020
:Tipo: RESTRICCIÓN (Deóntica)
:CNST: CNST_007
:Versión: 1.0.0
:Estado: Vigente

Declaración
-----------

Los reportes y consultas del sistema NO DEBEN solicitar un rango 
de fechas mayor a 730 días (2 años).

Parámetros
~~~~~~~~~~

- Rango máximo: 730 días
- Validación: API (serializer) + ORM (queryset)
- Mensaje error: "El rango de fechas no puede exceder 2 años"

Enforcement
-----------

.. code-block:: python

    # En ReportSerializer
    def validate(self, data):
        fecha_inicio = data.get('fecha_inicio')
        fecha_fin = data.get('fecha_fin')
        
        if (fecha_fin - fecha_inicio).days > 730:
            raise ValidationError("El rango no puede exceder 2 años")
        
        return data

Funciones Afectadas
~~~~~~~~~~~~~~~~~~~

- RPT-001 (ve_reportes)
- RPT-003 (filtra_reportes)
- RPT-004, RPT-005, RPT-006 (exportaciones)

Trazabilidad
------------

- Origen: CNST_007
- UC: UC-020 (Filtro Fecha)
```

---

## 7. MATRIZ DE TRAZABILIDAD ACTUALIZADA

### 7.1 CNST → BR (Completa)

| CNST | BR | Cobertura |
|------|-----|-----------|
| CNST_001 | BR_004 | ✅ 100% |
| CNST_002 | BR_005 | ✅ 100% |
| CNST_003 | BR_001 | ✅ 100% |
| CNST_004 | BR_002 | ✅ 100% |
| CNST_005 | BR_006, BR_007, BR_008, BR_009, BR_015 | ✅ 100% |
| CNST_006 | N/A (no es BR) | ➖ N/A |
| CNST_007 | BR_011, BR_020 | ✅ 100% |
| CNST_008 | N/A (no es BR) | ➖ N/A |
| CNST_009 | BR_010 | ✅ 100% |
| CNST_010 | BR_019 | ✅ 100% |

### 7.2 BR → Funciones RBAC v5.1.1

| BR | Funciones |
|----|-----------|
| BR_001 | PIP-001, RPT-001 |
| BR_002 | PIP-001, PIP-002, PIP-003, PIP-004 |
| BR_003 | USR-009 |
| BR_004 | AUT-003, ALR-002 |
| BR_005 | AUT-001, AUT-002, AUT-004 |
| BR_006 | ACC-001 a ACC-006 |
| BR_007 | ACC-005 |
| BR_008 | ACC-001 |
| BR_009 | USR-004 |
| BR_010 | AUD-001 a AUD-004 |
| BR_011 | RPT-004, RPT-005, RPT-006 |
| BR_012 | USR-010, ACC-006 |
| BR_013 | USR-001 |
| BR_014 | ALR-002 |
| BR_015 | AUT-001 |
| BR_016-018 | RPT-007 |
| BR_019 | ACC-006 |
| BR_020 | RPT-001, RPT-003 |

### 7.3 BR → UC

| BR | UC Relacionados |
|----|-----------------|
| BR_001 | UC-050, UC-051, UC-052 |
| BR_002 | UC-050, UC-053 |
| BR_003 | UC-007 |
| BR_004 | UC-003, UC-036, UC-037 |
| BR_005 | UC-001, UC-002, UC-005 |
| BR_006 | UC-010, UC-011, UC-041-047 |
| BR_007 | UC-043 |
| BR_008 | UC-042 |
| BR_009 | UC-008 |
| BR_010 | UC-060, UC-061, UC-062, UC-063 |
| BR_011 | UC-022, UC-023, UC-024 |
| BR_012 | UC-006, UC-041 |
| BR_013 | UC-006 |
| BR_014 | UC-036 |
| BR_015 | UC-001 |
| BR_016-018 | UC-025 |
| BR_019 | UC-041, UC-045 |
| BR_020 | UC-020 |

---

## 8. PLAN DE ACCIÓN

### 8.1 Acciones Requeridas

| # | Acción | Prioridad | Esfuerzo |
|---|--------|-----------|----------|
| 1 | Actualizar BR_006 con contenido RBAC v5.1.1 | 🔴 ALTA | 2h |
| 2 | Actualizar BR_007 con 3 SoD específicos | 🔴 ALTA | 2h |
| 3 | Crear BR_019 (Clasificación Datos) | 🟡 MEDIA | 1h |
| 4 | Crear BR_020 (Rango Temporal) | 🟡 MEDIA | 1h |
| 5 | Actualizar MODELO_DOCUMENTAL con 20 BR | 🟡 MEDIA | 1h |
| 6 | Actualizar mapeo CNST→BR | 🟢 BAJA | 30m |

### 8.2 Orden de Ejecución

```
Fase 1 (Crítico): BR_006, BR_007 → Alineación RBAC
Fase 2 (Importante): BR_019, BR_020 → Cobertura completa
Fase 3 (Documentación): Actualizar modelo documental
```

---

## 9. CONCLUSIONES

### 9.1 Estado Actual
- Las 18 BR existentes están **correctamente tipificadas** según TXM_03
- La **cobertura de CNST es incompleta** (falta CNST_010 parcialmente)
- BR_006 y BR_007 **requieren actualización** para alinear con RBAC v5.1.1
- **2 BR nuevas necesarias** para cobertura 100%

### 9.2 Estado Propuesto
- **20 BR totales** (18 existentes + 2 nuevas)
- **Cobertura 100%** de CNST aplicables
- **Alineación completa** con MODELO_RBAC_v5.1.1
- **Trazabilidad completa** BR → CNST → Funciones → UC

---

**FIN DEL DOCUMENTO**

*Análisis Integral BR IACT v1.0*  
*Fecha: 2026-01-03*
