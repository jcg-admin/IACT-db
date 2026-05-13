# PLAN DE ACTUALIZACIÓN: Módulo ACCESS

**Fecha:** 2026-01-07  
**Módulo:** MOD_Access  
**Transición:** v2.0 → v4.0.0

---

## CAMBIOS CONFIRMADOS v2.0 → v4.0.0

### Nomenclatura
```
v2.0: UC-010, UC-011, UC-041...
v4.0: UC_ACC_01, UC_ACC_02, UC_ACC_03...
```

### Mapeo Completo

| v4.0.0 | v2.0 | Nombre | Cambios |
|--------|------|--------|---------|
| UC_ACC_01 | UC-010 | Asignar Funciones | ✅ Renombrado |
| UC_ACC_02 | UC-011 | Revocar Funciones | ✅ Renombrado |
| UC_ACC_03 | UC-044 | Consultar Permisos | ✅ Renombrado + Reordenado |
| UC_ACC_04 | - | Asignar Agrupador | ⭐ NUEVO en v4.0 |
| UC_ACC_05 | UC-043 | Gestionar SoD | ✅ Renombrado + Reordenado |
| UC_ACC_06 | - | Gestionar Segmentos | ⭐ NUEVO (reemplaza UC-046) |
| UC_ACC_07 | UC-041 | Asignar Segmento | ✅ Renombrado |
| UC_ACC_08 | - | Permiso Temporal | ⭐ NUEVO en v4.0 |
| UC_ACC_09 | UC-047 | Auditar Cambios Acceso | ✅ Renombrado |

### UC Eliminados de v2.0

| v2.0 | Nombre | Estado en v4.0 |
|------|--------|----------------|
| UC-042 | Revocar Segmento | ❌ Eliminado (funcionalidad en UC_ACC_07?) |
| UC-045 | Gestionar Agrupadores | ❌ Eliminado (funcionalidad en UC_ACC_04?) |
| UC-046 | Gestionar Funciones | ❌ Eliminado (reemplazado por UC_ACC_06) |

**Total UC:**
- v2.0: 9 UC
- v4.0: 9 UC (pero diferentes)

---

## ARCHIVO A ACTUALIZAR

### Archivo: `source/requisitos/casos_uso/access/index.rst`

**Estado Actual:** v2.0 (desactualizado)  
**Estado Objetivo:** v4.0.0

### Cambios Necesarios

#### 1. Metadatos (líneas 1-10)
```rst
# CAMBIAR
:version: 2.0.0

# POR
:version: 4.0.0
```

#### 2. Título (línea 14)
```rst
# CAMBIAR
MOD_Access: Casos de Uso de Control de Acceso (RBAC)

# POR (mantener, está bien)
MOD_Access: Casos de Uso de Control de Acceso (RBAC)
```

#### 3. Resumen (líneas 28-43)
```rst
# CAMBIAR
   * - **UC Documentados**
     - 9 (UC-010, UC-011, UC-041 a UC-047)
   * - **Version**
     - 2.0.0 (con PlantUML)

# POR
   * - **UC Documentados**
     - 9 (UC_ACC_01 a UC_ACC_09)
   * - **Version**
     - 4.0.0 (con PlantUML)
```

#### 4. Tabla de UC (líneas 50-103)
```rst
# REEMPLAZAR TODA LA TABLA

ANTES:
   * - UC-010
     - Asignar Funciones a Usuario
     ...
   * - UC-047
     - Auditar Cambios de Permisos

DESPUÉS:
   * - UC_ACC_01
     - Asignar Funciones
     - Alta
     - 3
     - Completado
   * - UC_ACC_02
     - Revocar Funciones
     - Media
     - 3
     - Completado
   * - UC_ACC_03
     - Consultar Permisos
     - Media
     - 3
     - Completado
   * - UC_ACC_04
     - Asignar Agrupador
     - Alta
     - 3
     - Completado
   * - UC_ACC_05
     - Gestionar SoD
     - Alta
     - 3
     - Completado
   * - UC_ACC_06
     - Gestionar Segmentos
     - Media
     - 3
     - Completado
   * - UC_ACC_07
     - Asignar Segmento
     - Media
     - 3
     - Completado
   * - UC_ACC_08
     - Permiso Temporal
     - Media
     - 3
     - NUEVO
   * - UC_ACC_09
     - Auditar Cambios Acceso
     - Media
     - 3
     - Completado
```

#### 5. Descripciones de UC (líneas 107-168)
```rst
# ACTUALIZAR NOMBRES Y CÓDIGOS

ANTES:
UC-010: Asignar Funciones
UC-011: Revocar Funciones
UC-041/042: Asignar/Revocar Segmentos
UC-043: Configurar SoD
UC-044: Consultar Permisos
UC-045/046: Gestionar Agrupadores/Funciones
UC-047: Auditar Permisos

DESPUÉS:
UC_ACC_01: Asignar Funciones
UC_ACC_02: Revocar Funciones
UC_ACC_03: Consultar Permisos
UC_ACC_04: Asignar Agrupador
UC_ACC_05: Gestionar SoD
UC_ACC_06: Gestionar Segmentos
UC_ACC_07: Asignar Segmento
UC_ACC_08: Permiso Temporal
UC_ACC_09: Auditar Cambios Acceso
```

#### 6. Funciones RBAC (líneas 196-232)
```rst
# ACTUALIZAR TABLA

ANTES:
   * - ACC-001
     - Asignar Funciones
     - UC-010
   * - ACC-002
     - Revocar Funciones
     - UC-011
   ...

DESPUÉS:
   * - ACC-001
     - Asignar Funciones
     - UC_ACC_01
   * - ACC-002
     - Revocar Funciones
     - UC_ACC_02
   * - ACC-003
     - Consultar Permisos
     - UC_ACC_03
   * - ACC-004
     - Asignar Agrupador
     - UC_ACC_04
   * - ACC-005
     - Gestionar SoD
     - UC_ACC_05
   * - ACC-006
     - Gestionar Segmentos
     - UC_ACC_06
   * - ACC-007
     - Asignar Segmento
     - UC_ACC_07
   * - ACC-008
     - Permiso Temporal
     - UC_ACC_08
   * - ACC-009
     - Auditar Cambios Acceso
     - UC_ACC_09
```

#### 7. Trazabilidad BR → UC (líneas 236-255)
```rst
# ACTUALIZAR REFERENCIAS

ANTES:
   * - BR_010
     - SoD
     - UC-010, UC-043

DESPUÉS:
   * - BR_010
     - SoD
     - UC_ACC_01, UC_ACC_05
```

#### 8. Toctree (líneas 258-270)
```rst
# REEMPLAZAR COMPLETAMENTE

ANTES:
   UC_010_Asignar_Funciones
   UC_011_Revocar_Funciones
   UC_041_Asignar_Segmento
   UC_042_Revocar_Segmento
   UC_043_Configurar_SoD
   UC_044_Consultar_Permisos
   UC_045_Gestionar_Agrupadores
   UC_046_Gestionar_Funciones
   UC_047_Auditar_Permisos

DESPUÉS:
   UC_ACC_01_Asignar_Funciones
   UC_ACC_02_Revocar_Funciones
   UC_ACC_03_Consultar_Permisos
   UC_ACC_04_Asignar_Agrupador
   UC_ACC_05_Gestionar_SoD
   UC_ACC_06_Gestionar_Segmentos
   UC_ACC_07_Asignar_Segmento
   UC_ACC_08_Permiso_Temporal
   UC_ACC_09_Auditar_Cambios_Acceso
```

#### 9. Historial (líneas 277-287)
```rst
# AGREGAR NUEVA ENTRADA

   * - Version
     - Fecha
     - Cambios
   * - 4.0.0
     - 2026-01-07
     - Actualización a nomenclatura v4.0: UC_ACC_01 a UC_ACC_09
   * - 2.0.0
     - 2026-01-06
     - Fase 3 completada: 9 UC con PlantUML embebido
```

---

## OTROS ARCHIVOS A VERIFICAR

Una vez actualizado el index.rst de access, verificar:

### 1. `source/requisitos/casos_uso/index.rst` (principal)
- ✅ Ya usa nomenclatura v4.0.0 (UC_ACC_01, etc.)
- ⚠️ Verificar que los links a `:doc:` apunten correctamente

### 2. `source/requisitos/requisitos_funcionales/`
- ⚠️ Verificar si hay FR derivados que referencien UC antiguos
- Ejemplo: FR-ACC-001 derivado de UC-010 → debe ser UC_ACC_01

### 3. `source/requisitos/rtm/` (matriz trazabilidad)
- ⚠️ Actualizar mapeos UC → FR
- ⚠️ Actualizar mapeos UC → BR

### 4. Otros módulos (auth, users, pipeline, etc.)
- ⚠️ Verificar si también tienen index.rst desactualizados
- Aplicar el mismo patrón de actualización

---

## MÉTRICAS ACTUALIZADAS

```
ANTES (v2.0):
- UC-010 a UC-011 (2 UC)
- UC-041 a UC-047 (7 UC)
- Total: 9 UC

DESPUÉS (v4.0):
- UC_ACC_01 a UC_ACC_09 (9 UC secuenciales)
- Total: 9 UC
```

---

## PRÓXIMOS PASOS

1. ✅ Generar `index.rst` actualizado para access/
2. ⏳ Verificar otros 7 módulos (auth, users, etc.)
3. ⏳ Actualizar requisitos_funcionales/ si es necesario
4. ⏳ Actualizar rtm/ si es necesario

---

**Estado:** Plan completo  
**Tiempo estimado:** 30 min por módulo × 8 módulos = 4 horas

