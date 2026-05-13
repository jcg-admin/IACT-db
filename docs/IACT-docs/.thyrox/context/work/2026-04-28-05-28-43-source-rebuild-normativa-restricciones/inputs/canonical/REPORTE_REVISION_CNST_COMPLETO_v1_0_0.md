# 📊 REPORTE DE REVISIÓN COMPLETA - RESTRICCIONES CNST
## Sistema IACT - IVR Analytics & Customer Tracking

**Fecha de Revisión:** 2026-01-03  
**Versión Analizada:** 1.0.0 (fechada 2025-12-17)  
**Documentos Revisados:** 10 CNST + 1 Index + Documentos de Referencia  
**Líneas Totales Analizadas:** 9,621 líneas

---

## 🎯 RESUMEN EJECUTIVO

### ✅ Fortalezas Identificadas

1. **Formato Consistente:** Todos los documentos siguen la misma estructura
2. **Código Limpio:** Ejemplos siguen Clean Code y mejores prácticas
3. **Sin Emojis:** ✅ Cumple con la restricción de no usar emojis
4. **Sin Referencias Externas:** ✅ No hay menciones a ISO, OWASP, NIST, PCI
5. **Completitud:** Documentos muy completos (685-1,126 líneas cada uno)
6. **Ejemplos Prácticos:** Código PROHIBIDO vs CORRECTO en cada caso
7. **Integración RBAC:** Referencias consistentes al modelo de roles

### ⚠️ Hallazgos Críticos

1. **Estado CONGELADO:** Todos los documentos requieren cambio a DESCONGELADO
2. **Fecha Antigua:** 2025-12-17 (17 días desactualizada)
3. **Versión RBAC Desactualizada:** Referencias a "RBAC v4.0" cuando ahora es "v5.1.1"
4. **Número de Roles Obsoleto:** Mencionan "18 roles" cuando RBAC v5.1.1 tiene modelo diferente
5. **Funciones vs Roles:** RBAC v5.1.1 usa "funciones atómicas" (44), no roles tradicionales
6. **Restricciones CNST en RBAC:** El documento RBAC v5.1.1 solo menciona 8 CNST, pero hay 10

---

## 📋 ANÁLISIS POR DOCUMENTO


### CNST-001: Comunicaciones Prohibidas

**Líneas:** 685  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Prohibición clara de email/SMTP
- Implementación completa con `InternalMessage`
- Modelo `SecurityQuestion` para recuperación de contraseña
- Validación automatizada incluida
- Ejemplos de código completos

#### ⚠️ Inconsistencias Detectadas
- **Línea 638:** Referencia a "Modelo RBAC IACT v4.0" → debe ser **v5.1.1**
- **UC-037:** Caso de uso bien documentado pero falta integración con MOD_Alerts

#### 📝 Recomendaciones
1. Actualizar referencia a RBAC v5.1.1
2. Aclarar integración con funciones RBAC (no roles)
3. Agregar sección sobre integración con MOD_Alerts del modelo v5.1.1

---

### CNST-002: Gestión de Sesiones en Base de Datos

**Líneas:** 840  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Prohibición clara de Redis/Memcached
- Implementación completa con Django sessions
- JWT configuración detallada
- Middleware `SingleSessionMiddleware` bien documentado
- Timeout de 15 minutos claro

#### ⚠️ Inconsistencias Detectadas
- **Ninguna detectada** - Este documento está muy bien alineado

#### 📝 Recomendaciones
1. Mantener tal cual
2. Actualizar solo metadatos (fecha, versión)

---

### CNST-003: Base de Datos Dual con Inmutabilidad IVR

**Líneas:** 901  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Arquitectura dual muy clara
- Router implementation completa
- Modelos con `managed=False` correctamente
- Protección mediante `save()` y `delete()` override
- ETL extractor bien documentado

#### ⚠️ Inconsistencias Detectadas
- **Ninguna crítica** - Documento muy sólido

#### 📝 Recomendaciones
1. Mantener tal cual
2. Considerar agregar diagrama UML de la arquitectura dual

---

### CNST-004: Actualización de Datos mediante ETL

**Líneas:** 920  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Prohibición de WebSockets/SSE clara
- APScheduler configuración completa
- Pipeline ETL bien estructurado
- Modelo `ETLExecution` para tracking
- API de estado ETL incluida

#### ⚠️ Inconsistencias Detectadas
- **Frecuencia ETL:** Documento menciona "cada 6 horas" pero en RBAC v5.1.1 tabla de restricciones no especifica frecuencia exacta

#### 📝 Recomendaciones
1. Mantener configuración de 6 horas
2. Aclarar que es configurable entre 6-12 horas

---


### CNST-005: Seguridad Django REST Framework

**Líneas:** 994  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Configuración JWT completa
- Permisos DRF por rol bien definidos
- Throttling configurado
- Serializers con validación
- Exception handler personalizado

#### ⚠️ Inconsistencias Detectadas
- **Líneas 220-337:** Permisos basados en roles hardcoded (R004, R005, etc.)
  - RBAC v5.1.1 usa **funciones atómicas**, no roles fijos
  - Ejemplo: `HasRole(['R004'])` ya no es el enfoque correcto
  - Debería ser algo como: `has_function('ve_reportes')`

- **Línea 945:** Referencia a "Modelo RBAC IACT v4.0" → debe ser **v5.1.1**

#### 📝 Recomendaciones
1. **CRÍTICO:** Actualizar sistema de permisos para usar funciones atómicas
2. Crear nuevos permisos basados en funciones:
   - `HasFunction('ve_reportes')` en lugar de `HasRole('R004')`
   - `HasFunction('exporta_csv')` en lugar de role-based
3. Mantener compatibilidad con roles para transición
4. Actualizar referencia RBAC

---

### CNST-006: Antipatrones de Arquitectura Prohibidos

**Líneas:** 1,126  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- 10 antipatrones claramente documentados
- Código PROHIBIDO vs CORRECTO para cada uno
- Ejemplos prácticos y realistas
- Clean Code principles aplicados
- Validación automatizada incluida

#### ⚠️ Inconsistencias Detectadas
- **Línea 1082:** Referencia a "Modelo RBAC IACT v4.0" → debe ser **v5.1.1**
- **Líneas 940-947:** Ejemplo usa roles fijos cuando debería usar funciones

#### 📝 Recomendaciones
1. Actualizar ejemplos para usar funciones atómicas
2. Reemplazar `RolePermissions.REPORT_VIEWERS = ['R004', 'R005']`
   por sistema basado en funciones
3. Actualizar referencia RBAC

---

### CNST-007: Límites de Performance y SLA

**Líneas:** 1,061  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- SLAs claramente definidos
- Middlewares de performance
- Timeout decorators
- Queries optimizados
- Exportaciones asíncronas

#### ⚠️ Inconsistencias Detectadas
- **Ninguna crítica** - Documento muy técnico y bien estructurado

#### 📝 Recomendaciones
1. Mantener tal cual
2. Considerar agregar métricas de performance actuales

---

### CNST-008: Infraestructura y Deployment

**Líneas:** 1,019  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Prohibición de Docker/K8s clara
- Apache + mod_wsgi bien configurado
- Scripts de deployment completos
- Excel de control de deployment
- Proceso de rollback documentado

#### ⚠️ Inconsistencias Detectadas
- **Ninguna crítica** - Documento muy completo

#### 📝 Recomendaciones
1. Mantener tal cual
2. Validar que Excel template está actualizado

---


### CNST-009: Logging y Auditoría Inmutable

**Líneas:** 1,077  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- Modelos inmutables bien implementados
- `save()` bloqueado en modelos de log
- Clasificación de logs clara
- Middleware de API logging
- Decorador `@audit_action`

#### ⚠️ Inconsistencias Detectadas
- **Ninguna crítica** - Implementación muy sólida

#### 📝 Recomendaciones
1. Mantener tal cual
2. Verificar integración con MOD_Audit de RBAC v5.1.1

---

### CNST-010: Clasificación y Protección de Datos

**Líneas:** 998  
**Estado Actual:** Vigente (CONGELADO)  
**Calidad:** ⭐⭐⭐⭐⭐ (Excelente)

#### ✅ Aspectos Positivos
- 4 niveles de clasificación (C1-C4)
- Matriz de acceso por rol
- Implementación con Enum
- Decorador `@requires_classification`
- Serializers con filtrado

#### ⚠️ Inconsistencias Detectadas
- **Línea 950:** Referencia a "Modelo RBAC IACT v4.0" → debe ser **v5.1.1**
- **Líneas 180-194:** Matriz de acceso usa roles fijos
  - RBAC v5.1.1 usa funciones atómicas
  - Necesita actualización para mapear clasificación a funciones

#### 📝 Recomendaciones
1. **CRÍTICO:** Actualizar matriz de acceso
2. En lugar de roles en ACCESS_MATRIX, usar funciones
3. Mantener lógica de clasificación C1-C4
4. Actualizar referencia RBAC

---

## 🔄 COMPARACIÓN CON DOCUMENTO MAESTRO

### Documento: `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md`

**Versión:** 1.0.0  
**Fecha:** 21 Octubre 2025

#### ⚠️ Problemas del Documento Maestro

1. **Usa Emojis:** 📜, 🔴, ✅, ❌, ⚠️, 🎯, etc.
   - **Violación:** Los documentos CNST NO deben usar emojis
   
2. **Menciona Estándares Externos:**
   - Línea 1124: "NIST RBAC: Modelo de roles"
   - Línea 1125: "OWASP Top 10: Vulnerabilidades comunes"
   - Línea 1126: "Django Security: Best practices oficiales"
   - **Violación:** Documentos CNST no deben referenciar estándares externos

3. **Fecha Anterior a CNST:**
   - Maestro: 21 Octubre 2025
   - CNST: 2025-12-17
   - **Inconsistencia temporal:** ¿CNST posteriores al maestro?

#### ✅ Contenido Consistente

- Las 10 restricciones en maestro coinciden con los 10 CNST
- Contenido técnico es compatible
- Prohibiciones están alineadas

#### 📝 Recomendación

**El documento maestro NO debe usarse como fuente para actualizar los CNST** debido a:
1. Violaciones de formato (emojis)
2. Referencias externas no permitidas
3. Puede ser un documento de marketing/presentación, no técnico

---


## 🔄 INTEGRACIÓN CON RBAC v5.1.1

### Documento: `MODELO_RBAC_IACT_v5_1_1.md`

**Versión:** 5.1.1  
**Fecha:** 03 Enero 2026 (HOY)  
**Estado:** Listo para Implementación

### Cambios Clave RBAC v4.0 → v5.1.1

| Aspecto | v4.0 (Referenciado en CNST) | v5.1.1 (Actual) |
|---------|---------------------------|-----------------|
| **Modelo** | 18 roles funcionales | 44 funciones atómicas |
| **Enfoque** | Basado en roles (R001-R018) | Basado en funciones (sin pretensiones) |
| **Nomenclatura** | Roles con títulos | Funciones descriptivas |
| **Módulos** | Implícitos | 8 módulos explícitos IACT |
| **Restricciones** | No especificadas | 8 CNST mencionadas |

### 🚨 Impacto en CNST

#### Documentos Críticos a Actualizar

1. **CNST-005 (Seguridad DRF)**
   - Permisos actuales: `HasRole(['R004', 'R005'])`
   - Nuevo enfoque: `HasFunction('ve_reportes')`
   - **Impacto:** ALTO - Cambio arquitectónico

2. **CNST-010 (Clasificación de Datos)**
   - Matriz actual: Basada en roles
   - Nuevo enfoque: Basada en funciones
   - **Impacto:** ALTO - Lógica de acceso

3. **CNST-001, 006** (Referencias a RBAC)
   - Actualizar menciones "v4.0" → "v5.1.1"
   - **Impacto:** BAJO - Solo referencias

### Restricciones Mencionadas en RBAC v5.1.1

Según líneas 53-65 del documento RBAC:

```
CNST_001: NO email bajo ninguna circunstancia
CNST_002: Sesión única, 15 min timeout
CNST_003: BD IVR solo lectura, NO real-time
CNST_004: Alertas solo buzón interno, máx 50 dest.
CNST_005: Flat RBAC, SoD, permisos con vencimiento
CNST_006: Reportes: rango máx 2 años
CNST_007: Límites exportación, throttling
CNST_008: Audit inmutable, logs sin PII
```

#### ⚠️ Discrepancia Detectada

**RBAC v5.1.1 solo menciona 8 CNST, pero existen 10:**

- ✅ CNST-001: Mencionado (email)
- ✅ CNST-002: Mencionado (sesión)
- ✅ CNST-003: Mencionado (BD IVR)
- ⚠️ CNST-004: **CONFUSIÓN** - RBAC dice "Alertas" pero CNST-004 es "ETL"
- ✅ CNST-005: Mencionado (RBAC)
- ⚠️ CNST-006: **CONFUSIÓN** - RBAC dice "Reportes 2 años" pero CNST-006 es "Antipatrones"
- ✅ CNST-007: Mencionado (límites)
- ⚠️ CNST-008: **CONFUSIÓN** - RBAC dice "Audit" pero CNST-008 es "Infraestructura"
- ❌ CNST-009: **NO MENCIONADO** en RBAC (Logging y Auditoría)
- ❌ CNST-010: **NO MENCIONADO** en RBAC (Clasificación de Datos)

**Conclusión:** Hay un **desalineamiento** entre la tabla de CNST en RBAC v5.1.1 y los documentos CNST reales.

---

## 📊 ESTADÍSTICAS DE CALIDAD

### Métricas Generales

| Métrica | Valor |
|---------|-------|
| Documentos analizados | 10 CNST |
| Líneas totales | 9,621 |
| Promedio por documento | 962 líneas |
| Documento más extenso | CNST-006 (1,126 líneas) |
| Documento más corto | CNST-001 (685 líneas) |

### Cumplimiento de Estándares

| Estándar | Cumplimiento |
|----------|-------------|
| Sin emojis | ✅ 100% |
| Sin referencias externas | ✅ 100% |
| Formato consistente | ✅ 100% |
| Ejemplos de código | ✅ 100% |
| Validación automatizada | ✅ 100% |
| Integración RBAC | ⚠️ 70% (desactualizado) |


### Calidad de Código

| Aspecto | Estado |
|---------|--------|
| Clean Code | ✅ Excelente |
| Type hints | ✅ Incluidos |
| Docstrings | ✅ Completos |
| Excepciones customizadas | ✅ Bien manejadas |
| Separación de concerns | ✅ Correcta |

---

## 🎯 PLAN DE ACTUALIZACIÓN RECOMENDADO

### Fase 1: Actualización de Metadatos (URGENTE)

**Archivos a modificar:** Todos los CNST + index.rst

**Cambios:**
```rst
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03
:Estado: Vigente → Vigente (DESCONGELADO)
```

**Justificación:**
- Versión 1.1.0 porque hay cambios funcionales (RBAC v5.1.1)
- No es solo 1.0.1 (patch) porque afecta implementación

**Tiempo estimado:** 30 minutos

---

### Fase 2: Actualización de Referencias RBAC (ALTA PRIORIDAD)

**Archivos a modificar:**
- CNST-001 (línea 638)
- CNST-005 (línea 945)
- CNST-006 (línea 1082)
- CNST-010 (línea 950)

**Cambios:**
```rst
# ANTES
- Modelo RBAC IACT v4.0 (18 roles funcionales)

# DESPUÉS
- Modelo RBAC IACT v5.1.1 (44 funciones atómicas, 8 módulos)
```

**Tiempo estimado:** 15 minutos

---

### Fase 3: Actualización del Sistema de Permisos (CRÍTICO)

**Archivos a modificar:**
- CNST-005 (Permisos DRF)
- CNST-010 (Clasificación de datos)

**Cambios Arquitectónicos:**

#### En CNST-005:

```python
# ANTES (basado en roles)
class IsReportsViewer(permissions.BasePermission):
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R015']
    
    def has_permission(self, request, view):
        user_roles = get_user_roles(request.user)
        return any(role in user_roles for role in self.ALLOWED_ROLES)

# DESPUÉS (basado en funciones)
class CanViewReports(permissions.BasePermission):
    """
    Permiso basado en función atómica.
    
    Verifica si el usuario tiene la función 've_reportes'.
    Compatible con RBAC v5.1.1 (MOD_Reports).
    """
    REQUIRED_FUNCTION = 've_reportes'
    
    def has_permission(self, request, view):
        return request.user.has_function(self.REQUIRED_FUNCTION)
```

#### En CNST-010:

```python
# ANTES (matriz basada en roles)
ACCESS_MATRIX = {
    DataClassification.PUBLIC: {
        'R003', 'R004', 'R005', ...  # Lista de roles
    },
    ...
}

# DESPUÉS (matriz basada en funciones)
ACCESS_MATRIX = {
    DataClassification.PUBLIC: {
        've_reportes', 've_dashboard', 'lista_usuarios', ...
    },
    DataClassification.INTERNAL: {
        've_reportes', 'exporta_csv', 'crea_alertas', ...
    },
    DataClassification.RESTRICTED: {
        'analiza_datos', 'exporta_excel', 'configura_roles', ...
    },
    DataClassification.CONFIDENTIAL: {
        'administra_sistema', 'audita_accesos', ...
    }
}
```

**Tiempo estimado:** 2 horas

---

### Fase 4: Sincronización con RBAC v5.1.1 (IMPORTANTE)

**Acción:** Crear tabla de mapeo CNST ↔ Funciones

#### Tabla de Mapeo Propuesta

| CNST | Funciones RBAC v5.1.1 Afectadas | Módulo |
|------|--------------------------------|--------|
| CNST-001 | `notifica_usuario`, `crea_mensaje_interno` | MOD_Alerts |
| CNST-002 | `inicia_sesion`, `cierra_sesion` | MOD_Auth |
| CNST-003 | `extrae_datos_ivr` | MOD_Pipeline |
| CNST-004 | `supervisa_etl`, `ejecuta_etl` | MOD_Pipeline |
| CNST-005 | Todas (middleware de autenticación) | Todos |
| CNST-006 | Todas (calidad de código) | Todos |
| CNST-007 | `exporta_csv`, `exporta_excel`, `genera_reporte` | MOD_Reports |
| CNST-008 | N/A (infraestructura) | N/A |
| CNST-009 | `registra_auditoria`, `consulta_logs` | MOD_Audit, MOD_Logs |
| CNST-010 | `ve_reportes`, `analiza_datos`, `administra_sistema` | Todos |

**Tiempo estimado:** 1 hora

---

ENDOFPART6
cat >> /tmp/REPORTE_REVISION_CNST_COMPLETO.md << 'ENDOFPART7'

### Fase 5: Actualización del index.rst (FINAL)

**Archivo:** `arquitectura_tecnica/restricciones/index.rst`

**Cambios:**

```rst
# ANTES
:Estado: CONGELADO
:Documentos: 10
:Lineas Totales: 9,621
:Ultima Actualizacion: 2025-12-17

# DESPUÉS
:Estado: VIGENTE (Actualizado)
:Documentos: 10
:Lineas Totales: 9,800 (aprox.)
:Ultima Actualizacion: 2026-01-03
:Version RBAC: v5.1.1 (44 funciones atómicas)
```

**Agregar sección:**

```rst
Integración con RBAC v5.1.1
---------------------------

Este conjunto de restricciones está alineado con el Modelo RBAC v5.1.1
que utiliza funciones atómicas en lugar de roles tradicionales.

Cambios respecto a versión anterior:

- Migración de permisos basados en roles a funciones atómicas
- 44 funciones distribuidas en 8 módulos funcionales
- Sistema "sin pretensiones" (funciones describen QUÉ HACE, no QUIÉN ES)
- Integración con SEC_RULES para enforcement automático

Ver: :ref:`modelo-rbac-v5.1` para detalles completos.
```

**Tiempo estimado:** 30 minutos

---

## ⏱️ TIEMPO TOTAL ESTIMADO

| Fase | Tiempo | Prioridad |
|------|--------|-----------|
| Fase 1: Metadatos | 30 min | 🔴 URGENTE |
| Fase 2: Referencias | 15 min | 🟠 ALTA |
| Fase 3: Permisos | 2 horas | 🔴 CRÍTICO |
| Fase 4: Mapeo | 1 hora | 🟡 IMPORTANTE |
| Fase 5: Index | 30 min | 🟢 FINAL |
| **TOTAL** | **4 horas 15 min** | |

---

## 📝 CHECKLIST DE ACTUALIZACIÓN

### Pre-Actualización

- [ ] Backup de todos los archivos CNST actuales
- [ ] Crear rama Git `feature/cnst-rbac-v5.1`
- [ ] Revisar documento RBAC v5.1.1 completo
- [ ] Identificar funciones atómicas relevantes

### Durante Actualización

#### Fase 1: Metadatos
- [ ] CNST-001: Actualizar encabezado
- [ ] CNST-002: Actualizar encabezado
- [ ] CNST-003: Actualizar encabezado
- [ ] CNST-004: Actualizar encabezado
- [ ] CNST-005: Actualizar encabezado
- [ ] CNST-006: Actualizar encabezado
- [ ] CNST-007: Actualizar encabezado
- [ ] CNST-008: Actualizar encabezado
- [ ] CNST-009: Actualizar encabezado
- [ ] CNST-010: Actualizar encabezado
- [ ] index.rst: Actualizar metadatos generales

#### Fase 2: Referencias
- [ ] CNST-001: Cambiar "v4.0" → "v5.1.1"
- [ ] CNST-005: Cambiar "v4.0" → "v5.1.1"
- [ ] CNST-006: Cambiar "v4.0" → "v5.1.1"
- [ ] CNST-010: Cambiar "v4.0" → "v5.1.1"

#### Fase 3: Permisos
- [ ] CNST-005: Crear nuevos permisos basados en funciones
- [ ] CNST-005: Mantener compatibilidad con roles (transición)
- [ ] CNST-010: Actualizar ACCESS_MATRIX a funciones
- [ ] CNST-010: Actualizar serializers
- [ ] CNST-006: Actualizar ejemplos de antipatrones

#### Fase 4: Mapeo
- [ ] Crear tabla CNST ↔ Funciones RBAC
- [ ] Documentar en cada CNST las funciones afectadas
- [ ] Validar con documento RBAC v5.1.1

#### Fase 5: Index
- [ ] Actualizar sección de integración RBAC
- [ ] Agregar historial de versiones
- [ ] Actualizar matriz de impacto

### Post-Actualización

- [ ] Generar diff de cambios
- [ ] Revisar consistencia entre documentos
- [ ] Validar todos los ejemplos de código
- [ ] Ejecutar scripts de validación incluidos
- [ ] Commit y push
- [ ] Code review
- [ ] Merge a main

---

## 🚨 RIESGOS Y MITIGACIONES

### Riesgo 1: Ruptura de Implementación Existente

**Descripción:** Cambiar de roles a funciones puede romper código existente

**Mitigación:**
1. Mantener compatibilidad dual durante transición
2. Deprecar gradualmente sistema de roles
3. Crear adaptadores de compatibilidad

**Código de Ejemplo:**

```python
# Adaptador de compatibilidad RBAC v4.0 → v5.1.1
class LegacyRoleAdapter:
    """
    Adaptador para mantener compatibilidad con sistema de roles antiguo.
    
    Mapea roles de v4.0 a funciones de v5.1.1.
    Permite transición gradual sin romper código existente.
    """
    
    ROLE_TO_FUNCTIONS = {
        'R004': ['ve_reportes', 've_dashboard'],
        'R005': ['ve_reportes', 've_dashboard', 'exporta_csv'],
        'R010': ['analiza_datos', 've_reportes', 'exporta_excel'],
        'R015': ['administra_sistema']  # Acceso total
    }
    
    @classmethod
    def has_role(cls, user, role_code):
        """
        Método legacy que verifica rol.
        
        Internamente usa el nuevo sistema de funciones.
        """
        required_functions = cls.ROLE_TO_FUNCTIONS.get(role_code, [])
        if role_code == 'R015':  # SYSTEM_ADMIN
            return user.is_superuser
        return all(user.has_function(func) for func in required_functions)
```

### Riesgo 2: Inconsistencia en Tabla de CNST del RBAC

**Descripción:** RBAC v5.1.1 menciona 8 CNST con descripciones que no coinciden

**Mitigación:**
1. Actualizar tabla en RBAC v5.1.1
2. Sincronizar descripciones
3. Validar referencias cruzadas

**Tabla Correcta Propuesta para RBAC v5.1.1:**

```markdown
| CNST | Restricción | Impacto en RBAC |
|------|-------------|-----------------|
| CNST_001 | NO email bajo ninguna circunstancia | Notificaciones solo buzón interno |
| CNST_002 | Sesión única, 15 min timeout | Gestión de sesiones en MOD_Auth |
| CNST_003 | BD IVR solo lectura, NO real-time | Sin funciones de escritura IVR |
| CNST_004 | ETL cada 6-12 horas, NO real-time | Actualización periódica de datos |
| CNST_005 | Flat RBAC, JWT, permisos DRF | Modelo base de seguridad |
| CNST_006 | 10 antipatrones prohibidos | Calidad de código obligatoria |
| CNST_007 | Límites performance, SLA | Control de recursos |
| CNST_008 | Apache + mod_wsgi, NO Docker | Infraestructura de deployment |
| CNST_009 | Audit inmutable, logs sin PII | Funciones de auditoría solo lectura |
| CNST_010 | 4 niveles clasificación (C1-C4) | Permisos por nivel de datos |
```

### Riesgo 3: Pérdida de Trazabilidad

**Descripción:** Cambios pueden afectar documentación de trazabilidad

**Mitigación:**
1. Mantener matriz de trazabilidad actualizada
2. Documentar cada cambio en historial
3. Validar con RTM (Requirements Traceability Matrix)

---

## 📚 DOCUMENTOS DE REFERENCIA

### Analizados en esta Revisión

1. **Árbol Completo v2.0.6**
   - Ubicación: `/mnt/user-data/uploads/ÁRBOL_COMPLETO_v2_0_6.md`
   - Estado: Base para estructura

2. **CNST-001 a CNST-010** (10 documentos)
   - Ubicación: `/mnt/user-data/uploads/CNST_*.rst`
   - Estado: CONGELADO (a actualizar)

3. **Index de Restricciones**
   - Ubicación: `/mnt/user-data/uploads/index.rst`
   - Estado: CONGELADO (a actualizar)

4. **Modelo RBAC v5.1.1**
   - Ubicación: `/mnt/user-data/uploads/MODELO_RBAC_IACT_v5_1_1.md`
   - Estado: VIGENTE (03 Enero 2026)

5. **Restricciones Completas (Maestro)**
   - Ubicación: `/mnt/user-data/uploads/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md`
   - Estado: OBSOLETO (no usar para actualizar CNST)

### No Disponibles pero Necesarios

- TPL_005_Plantilla_CNST.rst (debe crearse)
- Casos de Uso UC-001 a UC-072
- Documentos de ADR
- Diagramas UML actualizados

---

## 🎯 RECOMENDACIÓN FINAL

### Estrategia Propuesta: ACTUALIZACIÓN INCREMENTAL

**Opción Recomendada:** Fase por fase con validación continua

**Razón:** 
- Minimiza riesgo de errores
- Permite validación en cada etapa
- Mantiene sistema funcionando durante transición

### Orden de Ejecución

1. ✅ **PRIMERO:** Fase 1 (Metadatos) - Bajo riesgo, alta visibilidad
2. ✅ **SEGUNDO:** Fase 2 (Referencias) - Bajo riesgo, rápido
3. ⚠️ **TERCERO:** Fase 4 (Mapeo) - Documentación antes de código
4. 🔴 **CUARTO:** Fase 3 (Permisos) - Cambio arquitectónico con adaptador
5. ✅ **QUINTO:** Fase 5 (Index) - Cierre y validación final

### Criterios de Éxito

- [ ] Todos los CNST con versión 1.1.0 y fecha 2026-01-03
- [ ] Referencias a RBAC v5.1.1 consistentes
- [ ] Sistema de permisos migrado a funciones atómicas
- [ ] Compatibilidad backward con adaptador
- [ ] Documentación sincronizada
- [ ] Validación automatizada pasando
- [ ] Code review aprobado

---

## 📊 ANEXOS

### Anexo A: Estadísticas Detalladas por Documento

```
CNST-001: 685 líneas (7.1% del total)
CNST-002: 840 líneas (8.7% del total)
CNST-003: 901 líneas (9.4% del total)
CNST-004: 920 líneas (9.6% del total)
CNST-005: 994 líneas (10.3% del total) ← Más complejo
CNST-006: 1,126 líneas (11.7% del total) ← Más extenso
CNST-007: 1,061 líneas (11.0% del total)
CNST-008: 1,019 líneas (10.6% del total)
CNST-009: 1,077 líneas (11.2% del total)
CNST-010: 998 líneas (10.4% del total)
────────────────────────────────────────
TOTAL: 9,621 líneas (100%)
```

### Anexo B: Palabras Clave por Documento

**CNST-001:**
- PROHIBIDO: email, SMTP, send_mail
- OBLIGATORIO: InternalMessage, SecurityQuestion

**CNST-002:**
- PROHIBIDO: Redis, Memcached, caché
- OBLIGATORIO: Django sessions, UserSession

**CNST-003:**
- PROHIBIDO: INSERT, UPDATE, DELETE en IVR
- OBLIGATORIO: managed=False, IVRReadOnlyRouter

**CNST-004:**
- PROHIBIDO: WebSockets, SSE, real-time
- OBLIGATORIO: APScheduler, ETLExecution

**CNST-005:**
- OBLIGATORIO: JWT, IsAuthenticated, Throttling
- REQUERIDO: Permisos por endpoint

**CNST-006:**
- PROHIBIDO: 10 antipatrones específicos
- OBLIGATORIO: Clean Code, SOLID

**CNST-007:**
- LÍMITES: SLA, timeouts, paginación
- OBLIGATORIO: Performance middleware

**CNST-008:**
- PROHIBIDO: Docker, Kubernetes, Cloud
- OBLIGATORIO: Apache, mod_wsgi

**CNST-009:**
- PROHIBIDO: UPDATE/DELETE en logs
- OBLIGATORIO: Inmutabilidad, auditoría

**CNST-010:**
- NIVELES: C1, C2, C3, C4
- OBLIGATORIO: Clasificación, permisos por nivel


### Anexo C: Ejemplos de Código Actualizado

#### Ejemplo 1: Permiso Basado en Funciones (CNST-005)

```python
# api/apps/common/permissions.py

from rest_framework import permissions
from apps.access.models import UserFunction  # Nuevo modelo RBAC v5.1.1

class HasFunction(permissions.BasePermission):
    """
    Permiso basado en función atómica RBAC v5.1.1.
    
    Uso:
        class ReportView(APIView):
            permission_classes = [IsAuthenticated, HasFunction]
            required_functions = ['ve_reportes']
    """
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        required_functions = getattr(view, 'required_functions', [])
        if not required_functions:
            return True  # Sin restricción específica
        
        user_functions = UserFunction.get_user_functions(request.user)
        return any(func in user_functions for func in required_functions)

# Compatibilidad con sistema antiguo
class HasRole(permissions.BasePermission):
    """
    DEPRECATED: Usar HasFunction en su lugar.
    
    Mantener solo para compatibilidad con código legacy.
    Será removido en v2.0.0.
    """
    
    def has_permission(self, request, view):
        import warnings
        warnings.warn(
            "HasRole está deprecado. Usar HasFunction.",
            DeprecationWarning,
            stacklevel=2
        )
        
        required_roles = getattr(view, 'required_roles', [])
        from apps.common.adapters import LegacyRoleAdapter
        return all(
            LegacyRoleAdapter.has_role(request.user, role)
            for role in required_roles
        )
```

#### Ejemplo 2: Clasificación con Funciones (CNST-010)

```python
# api/apps/common/classification.py

from enum import Enum

class DataClassification(Enum):
    PUBLIC = 'C1'
    INTERNAL = 'C2'
    RESTRICTED = 'C3'
    CONFIDENTIAL = 'C4'

class DataAccessControl:
    """
    Control de acceso basado en funciones RBAC v5.1.1.
    
    ACTUALIZADO: Ahora usa funciones atómicas en lugar de roles.
    """
    
    # Matriz actualizada: Clasificación → Funciones requeridas
    ACCESS_MATRIX = {
        DataClassification.PUBLIC: [
            # Cualquier usuario autenticado
            # No requiere funciones específicas
        ],
        DataClassification.INTERNAL: [
            've_reportes',
            've_dashboard',
            'lista_usuarios',
            'consulta_pipeline',
        ],
        DataClassification.RESTRICTED: [
            'analiza_datos',
            'exporta_excel',
            'configura_roles',
            'gestiona_alertas',
        ],
        DataClassification.CONFIDENTIAL: [
            'administra_sistema',
            'audita_accesos',
            'configura_permisos',
        ]
    }
    
    @classmethod
    def can_access(cls, user, classification: DataClassification) -> bool:
        """Verificar si usuario puede acceder a nivel de clasificación."""
        if not user or not user.is_authenticated:
            return False
        
        if classification == DataClassification.PUBLIC:
            return True  # Todos los autenticados
        
        if user.is_superuser:
            return True  # Admins acceden a todo
        
        required_functions = cls.ACCESS_MATRIX.get(classification, [])
        if not required_functions:
            return True
        
        from apps.access.models import UserFunction
        user_functions = UserFunction.get_user_functions(user)
        
        # Usuario necesita AL MENOS UNA de las funciones requeridas
        return any(func in user_functions for func in required_functions)
```

#### Ejemplo 3: Vista con Funciones (CNST-005 + CNST-010)

```python
# api/apps/analytics/views.py

from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from apps.common.permissions import HasFunction
from apps.common.classification import DataClassification, DataAccessControl
from apps.common.audit import audit_action

class CallMetricsViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet de métricas de llamadas.
    
    Actualizado con RBAC v5.1.1:
    - Permisos basados en funciones atómicas
    - Clasificación de datos por nivel
    - Auditoría completa
    """
    
    permission_classes = [IsAuthenticated, HasFunction]
    required_functions = ['ve_reportes']  # Función base
    
    def get_queryset(self):
        # Filtrar según nivel de clasificación del usuario
        max_classification = DataAccessControl.get_max_classification(
            self.request.user
        )
        
        queryset = CallMetric.objects.all()
        
        # C3/C4: Acceso a datos detallados
        if max_classification.value < 'C3':
            # Solo datos agregados para C1/C2
            queryset = queryset.values('metric_date').annotate(
                total=Sum('total_calls')
            )
        
        return queryset
    
    @action(
        detail=False,
        methods=['post'],
        required_functions=['exporta_excel']  # Función específica
    )
    @audit_action('DATA_EXPORT', lambda r, *a, **k: 'metrics:excel')
    def export_excel(self, request):
        """
        Exportar a Excel.
        
        Requiere función: exporta_excel
        Nivel mínimo: C2 (INTERNAL)
        """
        # Validar clasificación
        if not DataAccessControl.can_access(
            request.user,
            DataClassification.INTERNAL
        ):
            return Response(
                {'error': 'Clasificación insuficiente'},
                status=403
            )
        
        # Exportar usando servicio clasificado
        from apps.exports.services import ClassifiedExporter
        exporter = ClassifiedExporter(request.user)
        
        queryset = self.get_queryset()
        file_path = exporter.export(queryset, format='excel')
        
        return Response({
            'file': file_path,
            'classification': exporter.max_classification.value
        })
```

---

## 🏁 CONCLUSIONES

### Hallazgos Principales

1. ✅ **Calidad Excepcional:** Los documentos CNST están muy bien escritos
2. ⚠️ **Desactualización RBAC:** Necesitan migración a v5.1.1
3. 🔴 **Cambio Arquitectónico:** Permisos deben migrar a funciones
4. ✅ **Sin Problemas de Formato:** Cumplen estándares (sin emojis, sin refs externas)

### Esfuerzo Requerido

- **Total:** 4 horas 15 minutos
- **Criticidad:** ALTA (afecta implementación)
- **Complejidad:** MEDIA-ALTA (cambio arquitectónico)

### Próximos Pasos

1. **Inmediato:** Actualizar metadatos (Fase 1)
2. **Corto Plazo:** Actualizar referencias RBAC (Fase 2)
3. **Mediano Plazo:** Crear mapeo CNST-Funciones (Fase 4)
4. **Planificado:** Migrar sistema de permisos (Fase 3)
5. **Final:** Actualizar index y validar (Fase 5)

### Valor Agregado

Esta actualización:
- ✅ Alinea documentación con arquitectura actual
- ✅ Facilita implementación del sistema de permisos
- ✅ Mejora trazabilidad entre CNST y RBAC
- ✅ Establece base sólida para desarrollo

---

**Fin del Reporte de Revisión Completa**

**Generado:** 2026-01-03  
**Analista:** Sistema Automatizado de Revisión Documental  
**Versión del Reporte:** 1.0.0

---

## 📞 CONTACTO

Para preguntas sobre este reporte:
- Revisar con equipo de arquitectura
- Validar con Product Owner
- Consultar documento RBAC v5.1.1

