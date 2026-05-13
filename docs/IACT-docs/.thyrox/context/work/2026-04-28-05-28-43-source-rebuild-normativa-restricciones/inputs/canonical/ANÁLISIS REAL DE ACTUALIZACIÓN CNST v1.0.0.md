rm -f /tmp/ANALISIS_*.md
cat > /tmp/ANALISIS_REAL_CNST_v1_1_0.md << 'EOF'
# 📊 ANÁLISIS REAL DE ACTUALIZACIÓN CNST v1.0.0 → v1.1.0
## Sistema IACT - IVR Analytics & Customer Tracking

**Fecha:** 2026-01-03  
**Basado en:** REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md  
**Enfoque:** CRÍTICO - Solo lo que el reporte REALMENTE dice

---

## 🎯 LO QUE EL REPORTE DICE vs LO QUE INVENTÉ

### ❌ Lo que INVENTÉ (ERROR)

1. **CNST-005: +345 líneas de "Permisos Temporales"**
   - El reporte NO menciona esto
   - El reporte NO dice que crezca de 994 a 1,339 líneas
   - INVENTADO por mí

2. **CNST-006: +577 líneas de "Patrones Recomendados"**
   - El reporte NO menciona esto
   - El reporte NO dice que crezca de 1,126 a 1,703 líneas
   - INVENTADO por mí

3. **Total líneas: 10,543**
   - El reporte NO menciona este número
   - Basado en mis ampliaciones inventadas
   - INCORRECTO

### ✅ Lo que el reporte REALMENTE dice

**Fase 1: Metadatos**
```
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03
:Estado: Vigente → Vigente (DESCONGELADO)
```
Tiempo: 30 minutos

**Fase 2: Referencias RBAC**
Cambiar en 4 documentos:
```
Modelo RBAC IACT v4.0 → v5.1.1
18 roles funcionales → 44 funciones atómicas
```
Tiempo: 15 minutos

**Fase 3: Sistema de Permisos (SOLO en CNST-005 y CNST-010)**

En CNST-005 (líneas 220-337):
```python
# ANTES
class IsReportsViewer(permissions.BasePermission):
    ALLOWED_ROLES = ['R004', 'R005']

# DESPUÉS
class CanViewReports(permissions.BasePermission):
    REQUIRED_FUNCTION = 've_reportes'
```

En CNST-010 (líneas 180-194):
```python
# ANTES
ACCESS_MATRIX = {
    DataClassification.PUBLIC: {'R003', 'R004', ...}
}

# DESPUÉS
ACCESS_MATRIX = {
    DataClassification.PUBLIC: {'ve_reportes', 've_dashboard', ...}
}
```
Tiempo: 2 horas

**Fase 4: Mapeo CNST ↔ Funciones**
Crear tabla de mapeo
Tiempo: 1 hora

**Fase 5: Index**
Actualizar metadatos y agregar sección de integración RBAC
Tiempo: 30 minutos

**TOTAL: 4 horas 15 minutos**

---

## 📋 CAMBIOS REALES POR DOCUMENTO

### Todos los CNST (10 archivos)
**Cambio:** Solo metadatos
```
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03  
:Estado: Vigente → Vigente (DESCONGELADO)
```

### CNST-001, CNST-005, CNST-006, CNST-010 (4 archivos)
**Cambio adicional:** Referencias RBAC
```
Línea específica: "v4.0" → "v5.1.1"
```

### CNST-001 (líneas ~638)
**Cambio adicional:** Función notify
```python
# ANTES
def notify_by_role(role_id, ...):

# DESPUÉS  
def notify_by_function(function_code, ...):
```

### CNST-005 (líneas 220-337)⚠️ CRÍTICO
**Cambio:** Reemplazar SOLO el código de permisos existente
- NO agregar secciones nuevas
- NO aumentar líneas significativamente
- SOLO cambiar HasRole → HasFunction en el código YA existente

### CNST-006 (líneas 940-947)
**Cambio:** Actualizar SOLO el ejemplo existente
```python
# ANTES
ALLOWED_ROLES = ['R004', 'R005']

# DESPUÉS
REQUIRED_FUNCTIONS = ['ve_reportes', 've_dashboard']
```

### CNST-010 (líneas 180-194) ⚠️ CRÍTICO
**Cambio:** Reemplazar SOLO la matriz ACCESS_MATRIX existente
- NO agregar secciones nuevas
- SOLO cambiar roles por funciones en matriz existente

### index.rst
**Cambio:** 
1. Metadatos
2. Agregar sección "Integración con RBAC v5.1.1"
3. Tabla de mapeo CNST ↔ Funciones

---

## 📊 CONTEO REAL DE LÍNEAS

| Documento | v1.0.0 | v1.1.0 Estimado | Cambio Real |
|-----------|--------|-----------------|-------------|
| CNST-001 | 685 | ~690 | +5 (metadatos + notify_by_function) |
| CNST-002 | 840 | ~841 | +1 (metadatos) |
| CNST-003 | 901 | ~902 | +1 (metadatos) |
| CNST-004 | 920 | ~921 | +1 (metadatos) |
| CNST-005 | 994 | ~1,000 | +6 (metadatos + permisos) |
| CNST-006 | 1,126 | ~1,130 | +4 (metadatos + ejemplo) |
| CNST-007 | 1,061 | ~1,062 | +1 (metadatos) |
| CNST-008 | 1,019 | ~1,020 | +1 (metadatos) |
| CNST-009 | 1,077 | ~1,078 | +1 (metadatos) |
| CNST-010 | 998 | ~1,004 | +6 (metadatos + matriz) |
| index.rst | 253 | ~280 | +27 (sección RBAC) |
| **TOTAL** | **9,621** | **~9,675** | **+54** |

**Incremento real:** ~0.6% (no 9.6% como inventé)

---

## ✅ PLAN DE GENERACIÓN REAL

### Método
Generar TODO desde cero con `create_file` en `/tmp`

### Orden
1. CNST-001 (~690 líneas)
2. CNST-002 (~841 líneas)
3. CNST-003 (~902 líneas)
4. CNST-004 (~921 líneas)
5. CNST-005 (~1,000 líneas) - SOLO cambiar código de permisos
6. CNST-006 (~1,130 líneas) - SOLO cambiar ejemplo
7. CNST-007 (~1,062 líneas)
8. CNST-008 (~1,020 líneas)
9. CNST-009 (~1,078 líneas)
10. CNST-010 (~1,004 líneas) - SOLO cambiar matriz
11. index.rst (~280 líneas)

### Confirmación
Después de cada archivo

---

## 🔴 ERRORES EN MI ANÁLISIS ANTERIOR

1. ❌ Inventé "+345 líneas Permisos Temporales" para CNST-005
2. ❌ Inventé "+577 líneas Patrones Recomendados" para CNST-006
3. ❌ Inventé total de 10,543 líneas
4. ❌ Asumí que RBAC v5.1.1 tener permisos temporales = debo agregarlos a CNST
5. ❌ Sesgo de confirmación: busqué justificar mis invenciones

## ✅ ANÁLISIS CORRECTO

El reporte pide:
- Actualizar metadatos (simple)
- Cambiar referencias "v4.0" → "v5.1.1" (buscar/reemplazar)
- Actualizar código de permisos existente de roles a funciones (líneas específicas)
- Agregar tabla de mapeo en index (nueva sección pequeña)

**Total:** Cambios mínimos, ~54 líneas adicionales

---

**Generado:** 2026-01-03  
**Ubicación:** /tmp/ANALISIS_REAL_CNST_v1_1_0.md  
**Estado:** AUTOCRÍTICA COMPLETADA

EOF

wc -l /tmp/ANALISIS_REAL_CNST_v1_1_0.md
echo ""
echo "=========================================="
echo "✓ ANÁLISIS REAL Y AUTOCRÍTICO GENERADO"
echo "=========================================="
Output

208 /tmp/ANALISIS_REAL_CNST_v1_1_0.md

==========================================
✓ ANÁLISIS REAL Y AUTOCRÍTICO GENERADO
==========================================