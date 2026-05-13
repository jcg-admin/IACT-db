# 📋 ANÁLISIS DE NOMENCLATURA TPL Y PLAN DE GENERACIÓN

**Fecha:** 2026-01-07  
**Propósito:** Definir nomenclatura correcta para Templates y listar los que deben generarse

---

## 1. PROBLEMAS IDENTIFICADOS

### 1.1 Nomenclatura Actual (Incorrecta)

El archivo actual tiene:
```
TPL_002_Plantilla_UC_v2.rst
```

**Problemas:**
1. **Número redundante**: `002` no aporta valor si el nombre es descriptivo
2. **`_v2` en nombre de archivo**: El versionado va DENTRO del documento, no en el nombre
3. **Inconsistencia**: Si aplicamos STD_006 (Versionado Semántico), la versión está en `:version: 2.0.0` dentro del meta

### 1.2 Lo Correcto según STD_006

El versionado semántico aplica al **contenido** del documento, no al nombre del archivo.

```
INCORRECTO: TPL_002_Plantilla_UC_v2.rst     ← versión en nombre
CORRECTO:   TPL_UC.rst                       ← nombre limpio, versión interna
```

**Dentro del archivo:**
```rst
.. meta::
   :version: 2.0.0    ← Aquí va la versión
```

---

## 2. NUEVA NOMENCLATURA PROPUESTA

### 2.1 Formato de Nombre de Archivo

```
TPL_[ARTEFACTO].rst
```

**Sin número secuencial** - El nombre del artefacto es suficientemente descriptivo.

### 2.2 Ejemplos

| Antes (Incorrecto) | Después (Correcto) |
|--------------------|-------------------|
| TPL_001_Plantilla_BR.rst | TPL_BR.rst |
| TPL_002_Plantilla_UC_v2.rst | TPL_UC.rst |
| TPL_003_Plantilla_FR.rst | TPL_FR.rst |
| TPL_004_Plantilla_ADR.rst | TPL_ADR.rst |
| TPL_005_Plantilla_CNST.rst | TPL_CNST.rst |
| TPL_006_Plantilla_MOD.rst | TPL_MOD.rst |

---

## 3. CATÁLOGO COMPLETO DE TPL NECESARIOS

### 3.1 Templates Esenciales (Nivel 1 - Críticos)

| TPL | Para Artefacto | Prioridad | Justificación |
|-----|----------------|-----------|---------------|
| **TPL_BR.rst** | BR_xxx | 🔴 Alta | 20 BR ya generadas |
| **TPL_UC.rst** | UC_xxx | ✅ Existe | 49 UC generados |
| **TPL_FR.rst** | FR_xxx | 🔴 Alta | 55 FR en progreso |
| **TPL_CNST.rst** | CNST_xxx | 🟢 Baja | 10 CNST congelados |
| **TPL_MOD.rst** | MOD_xxx | 🟢 Baja | 8 MOD congelados |

### 3.2 Templates Secundarios (Nivel 2)

| TPL | Para Artefacto | Prioridad | Justificación |
|-----|----------------|-----------|---------------|
| **TPL_ADR.rst** | ADR_xxx | 🟢 Baja | 5 ADR existentes |
| **TPL_STD.rst** | STD_xxx | 🟡 Media | STD_006 ya generado |
| **TPL_BReq.rst** | BReq_xxx | 🟢 Baja | 8 BReq existentes |
| **TPL_TST.rst** | TST_xxx | 🟠 Alta | Próxima fase |
| **TPL_FD.rst** | FD_xxx | 🟢 Baja | 12 FD existentes |

### 3.3 Templates de Gobernanza (Nivel 3)

| TPL | Para Artefacto | Prioridad | Justificación |
|-----|----------------|-----------|---------------|
| **TPL_PROC.rst** | PROC_xxx | 🟠 Alta | 16 PROC pendientes |
| **TPL_POL.rst** | POL_xxx | 🟢 Baja | 2 POL existentes |
| **TPL_RTM.rst** | RTM_xxx | 🟡 Media | Trazabilidad |
| **TPL_INDEX.rst** | index.rst | 🟢 Baja | Índices de subdominios |

### 3.4 Templates Especiales

| TPL | Para Artefacto | Prioridad | Justificación |
|-----|----------------|-----------|---------------|
| **TPL_NFR.rst** | NFR_xxx | 🟡 Media | Requisitos no funcionales |
| **TPL_VIEW.rst** | VIEW_xxx | 🟢 Baja | Vistas arquitectónicas |
| **TPL_API.rst** | API_xxx | 🟢 Baja | Documentación API |

---

## 4. RESUMEN DE TEMPLATES

### 4.1 Totales

| Categoría | Cantidad |
|-----------|----------|
| Nivel 1 (Críticos) | 5 |
| Nivel 2 (Secundarios) | 5 |
| Nivel 3 (Gobernanza) | 4 |
| Especiales | 3 |
| **TOTAL** | **17** |

### 4.2 Estado Actual

| Estado | Cantidad | Templates |
|--------|----------|-----------|
| ✅ Existe | 1 | TPL_UC (como TPL_002_Plantilla_UC_v2.rst) |
| ❌ Falta | 16 | Resto |

### 4.3 Por Generar (Ordenados por Prioridad)

**🔴 Prioridad Alta (P0):**
1. TPL_FR.rst - Actualmente generando FR
2. TPL_BR.rst - 20 BR ya generadas (retroactivo)
3. TPL_PROC.rst - 16 PROC pendientes
4. TPL_TST.rst - Próxima fase

**🟡 Prioridad Media (P1):**
5. TPL_STD.rst - Para futuros estándares
6. TPL_NFR.rst - Requisitos no funcionales
7. TPL_RTM.rst - Trazabilidad

**🟢 Prioridad Baja (P2):**
8. TPL_CNST.rst
9. TPL_MOD.rst
10. TPL_ADR.rst
11. TPL_BReq.rst
12. TPL_FD.rst
13. TPL_POL.rst
14. TPL_VIEW.rst
15. TPL_API.rst
16. TPL_INDEX.rst

---

## 5. ACCIÓN SOBRE TPL_UC EXISTENTE

### 5.1 Archivo Actual
```
TPL_002_Plantilla_UC_v2.rst
```

### 5.2 Acción Recomendada

**Opción A: Renombrar**
```bash
mv TPL_002_Plantilla_UC_v2.rst TPL_UC.rst
```
- Actualizar `:artefacto:` dentro del archivo de `TPL_002` a `TPL_UC`
- Mantener `:version: 2.0.0` sin cambios

**Opción B: Crear nuevo y deprecar**
- Crear `TPL_UC.rst` con contenido actualizado
- Marcar `TPL_002_Plantilla_UC_v2.rst` como deprecado

### 5.3 Recomendación

**Opción A (Renombrar)** - Es más simple y mantiene historial.

---

## 6. ESTRUCTURA FINAL PROPUESTA

```
normativa/
└── estandares/
    └── plantillas/
        ├── index.rst
        │
        ├── TPL_BR.rst           # Business Rules
        ├── TPL_UC.rst           # Casos de Uso (renombrado)
        ├── TPL_FR.rst           # Requisitos Funcionales
        ├── TPL_CNST.rst         # Restricciones
        ├── TPL_MOD.rst          # Módulos
        ├── TPL_ADR.rst          # Decisiones Arquitectónicas
        ├── TPL_STD.rst          # Estándares
        ├── TPL_BReq.rst         # Business Requirements
        ├── TPL_TST.rst          # Tests/Pruebas
        ├── TPL_FD.rst           # Flujos de Datos
        ├── TPL_PROC.rst         # Procedimientos
        ├── TPL_POL.rst          # Políticas
        ├── TPL_RTM.rst          # Matrices Trazabilidad
        ├── TPL_NFR.rst          # Requisitos No Funcionales
        ├── TPL_VIEW.rst         # Vistas Arquitectónicas
        ├── TPL_API.rst          # Documentación API
        └── TPL_INDEX.rst        # Índices de subdominios
```

---

## 7. PLAN DE GENERACIÓN

### Sesión Actual (si procede)

1. ✅ Confirmar nueva nomenclatura
2. ⏳ Generar TPL_FR.rst (crítico para fase actual)
3. ⏳ Generar TPL_BR.rst (retroactivo)
4. ⏳ Generar TPL_PROC.rst (para crear PROC_006)

### Sesiones Posteriores

5. Generar TPL_TST.rst (antes de fase TST)
6. Generar resto según necesidad

---

## 8. DECISIÓN REQUERIDA

**Pregunta al usuario:**

¿Confirmas la nueva nomenclatura sin números?

| Antes | Después |
|-------|---------|
| TPL_001_Plantilla_BR.rst | TPL_BR.rst |
| TPL_002_Plantilla_UC_v2.rst | TPL_UC.rst |
| ... | ... |

**Si confirmas, procedo a generar los 16 TPL faltantes en orden de prioridad.**

---

*Documento: Análisis de Nomenclatura TPL*  
*Fecha: 2026-01-07*  
*Proyecto IACT*
