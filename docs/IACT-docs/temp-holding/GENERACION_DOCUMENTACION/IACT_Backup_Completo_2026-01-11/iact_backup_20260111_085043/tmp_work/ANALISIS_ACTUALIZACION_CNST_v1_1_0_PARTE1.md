# 📊 ANÁLISIS DEFINITIVO DE ACTUALIZACIÓN CNST v1.0.0 → v1.1.0
## Sistema IACT - IVR Analytics & Customer Tracking

**Fecha del Análisis:** 2026-01-08  
**Versión Origen:** 1.0.0 (CONGELADO, 2025-12-17)  
**Versión Destino:** 1.1.0 (VIGENTE, 2026-01-08)  
**Documentos Base:**
- REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md (1,130 líneas)
- MODELO_RBAC_IACT_v5_1_1.md (1,655 líneas)
- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md (1,136 líneas - Referencia)

---

## 🎯 RESUMEN EJECUTIVO

### Situación Actual

**10 documentos CNST** en estado CONGELADO desde 2025-12-17:

| Documento | Líneas | Estado | Última Actualización |
|-----------|--------|--------|---------------------|
| CNST_001 | 685 | CONGELADO | 2025-12-17 |
| CNST_002 | 840 | CONGELADO | 2025-12-17 |
| CNST_003 | 901 | CONGELADO | 2025-12-17 |
| CNST_004 | 920 | CONGELADO | 2025-12-17 |
| CNST_005 | 994 | CONGELADO | 2025-12-17 |
| CNST_006 | 1,126 | CONGELADO | 2025-12-17 |
| CNST_007 | 1,061 | CONGELADO | 2025-12-17 |
| CNST_008 | 1,019 | CONGELADO | 2025-12-17 |
| CNST_009 | 1,077 | CONGELADO | 2025-12-17 |
| CNST_010 | 998 | CONGELADO | 2025-12-17 |
| **TOTAL** | **9,621** | - | - |

### Problemas Identificados

#### 1. Desactualización de Referencias RBAC

**Problema:** Los CNST referencian RBAC v4.0 (18 roles) cuando el modelo actual es v5.1.1 (44 funciones atómicas).

**Documentos afectados:**
- CNST_001 (línea 638): "Modelo RBAC IACT v4.0"
- CNST_005 (línea 945): "Modelo RBAC IACT v4.0"
- CNST_006 (línea 1082): "Modelo RBAC IACT v4.0"
- CNST_010 (línea 950): "Modelo RBAC IACT v4.0"

#### 2. Sistema de Permisos Obsoleto

**Problema:** Los CNST usan sistema basado en roles fijos (R001-R018) cuando RBAC v5.1.1 usa funciones atómicas.

**Cambio arquitectónico requerido:**

```python
# ANTES (v4.0 - Basado en roles)
class HasRole(permissions.BasePermission):
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R015']
    
    def has_permission(self, request, view):
        user_roles = get_user_roles(request.user)
        return any(role in user_roles for role in self.ALLOWED_ROLES)

# DESPUÉS (v5.1.1 - Basado en funciones atómicas)
class HasFunction(permissions.BasePermission):
    required_functions = ['ve_reportes']  # Funciones del catálogo de 44
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(request.user)
        return any(func in user_functions for func in required_functions)
```

**Documentos afectados:**
- CNST_005 (líneas 220-337): Permisos DRF hardcoded con roles
- CNST_010 (líneas 180-194): Matriz ACCESS_MATRIX basada en roles
- CNST_006 (líneas 940-947): Ejemplos con roles

#### 3. Desalineamiento Tabla CNST en RBAC v5.1.1

**Problema:** La tabla de CNST en RBAC v5.1.1 (líneas 54-64) menciona 8 restricciones con descripciones INCORRECTAS:

| CNST | Descripción en RBAC v5.1.1 | CNST Real | Error |
|------|---------------------------|-----------|-------|
| CNST_001 | NO email | ✅ CORRECTO | - |
| CNST_002 | Sesión única, 15 min | ✅ CORRECTO | - |
| CNST_003 | BD IVR solo lectura | ✅ CORRECTO | - |
| CNST_004 | "Alertas solo buzón interno" | ❌ ETL cada 6-12 horas | **INCORRECTO** |
| CNST_005 | Flat RBAC, SoD, permisos | ✅ CORRECTO | - |
| CNST_006 | "Reportes: rango máx