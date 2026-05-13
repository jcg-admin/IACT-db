# ANÁLISIS: _taxonomias_y_metamodelos/taxonomias/

**Fecha:** 2026-01-07  
**Archivos:** 3 TXM

---

## RESULTADO: ⚠️ MUCHAS REFERENCIAS DESACTUALIZADAS

### Archivos Verificados
```
_taxonomias_y_metamodelos/taxonomias/
├── TXM_01_Taxonomia_Requisitos.rst       ⚠️ ~20+ referencias UC-XXX
├── TXM_02_Taxonomia_Artefactos.rst       ✅ (no verificado aún, probablemente OK)
└── TXM_03_Taxonomia_Reglas_Negocio.rst   ⚠️ ~5 referencias UC-XXX
```

---

## REFERENCIAS ENCONTRADAS

### TXM_01: Taxonomía de Requisitos (~13 referencias)

**Ejemplos por tipo (líneas 214-220):**
```rst
UC-006 Crear Usuario
UC-010 Asignar Rol
UC-017 Consultar Reporte
UC-025 Ver Dashboard
UC-022 Exportar CSV
UC-037 Configurar Alerta
UC-ETL Sincronizar Datos
```

**Rangos por dominio funcional (líneas 236-251):**
```rst
- Gestión de Usuarios: UC-005 a UC-011, UC-041, UC-042
- Reportes:           UC-017 a UC-024
- Dashboards:         UC-025 a UC-030
- Análisis:           UC-031 a UC-035
- Alertas:            UC-036 a UC-040
- Administración:     UC-012 a UC-016, UC-043
```

**Nomenclatura FR (líneas 301-303):**
```rst
- FR-10.1:  Primer FR del UC-010
- FR-10.15: Decimoquinto FR del UC-010
- FR-017.5: Quinto FR del UC-017
```

### TXM_03: Taxonomía de Reglas de Negocio (~5 referencias)

**Referencias en ejemplos:**
```rst
Línea 214: Genera: UC-010 (flujo alterno de validacion SoD)
Línea 230: Impacto: Validacion de permisos en UC-006, UC-007, UC-008
Línea 309: Genera: UC-038 (Disparar Alerta)
Línea 319: Genera: Flujo alterno en UC-005 (Login)
```

---

## MAPEO DETALLADO: Antigua → Nueva

### Gestión de Usuarios (UC-005 a UC-011)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-005 | UC_AUTH_03? | Login/Recuperar |
| UC-006 | UC_USR_01 | Crear Usuario |
| UC-007 | UC_USR_02 | Consultar Usuarios |
| UC-008 | UC_USR_03 | Modificar Usuario |
| UC-009 | UC_USR_04 | Eliminar Usuario |
| UC-010 | UC_ACC_01 | Asignar Funciones |
| UC-011 | UC_ACC_02 | Revocar Funciones |

### Acceso (UC-041, UC-042, UC-043)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-041 | UC_ACC_07 | Asignar Segmento |
| UC-042 | (eliminado?) | Revocar Segmento |
| UC-043 | UC_ACC_05 | Gestionar SoD |

### Reportes (UC-017 a UC-024)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-017 | UC_RPT_01 | Consultar Reporte |
| UC-022 | UC_RPT_06 | Exportar CSV |
| ... | ... | ... |

### Dashboards (UC-025 a UC-030)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-025 | UC_RPT_09 | Ver Dashboard |
| ... | ... | ... |

### Alertas (UC-036 a UC-040)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-037 | UC_ALR_01? | Configurar Alerta |
| UC-038 | UC_ALR_XX? | Disparar Alerta |
| ... | ... | ... |

### Administración (UC-012 a UC-016)
| Antigua | Nueva | Nombre |
|---------|-------|--------|
| UC-012 | UC_AUD_XX? | ... |
| ... | ... | ... |

**Nota:** Algunos mapeos son aproximados. Necesito verificar los módulos reales para mapeo exacto.

---

## ANÁLISIS DE IMPACTO

### Características de las Taxonomías

1. **Tipo:** Clasificación jerárquica de requisitos
2. **Estado:** PRIVADO (prefijo `_`)
3. **Audiencia:** Equipo técnico, arquitectos
4. **Uso:** Entender estructura y organización

### Impacto: MEDIO-ALTO

**Razones:**

✅ **Bajo impacto operativo:**
- Documentos privados (no en build HTML)
- No son ejecutables
- Son clasificaciones conceptuales

❌ **Alto impacto en comprensión:**
- Definen rangos de UC por dominio
- Ejemplos usados para explicar conceptos
- Búsqueda de UC retorna taxonomía obsoleta

❌ **Alto impacto en onboarding:**
- Nuevos miembros consultan taxonomías
- Ven UC-010, buscan en proyecto, no existe
- Confusión sobre estructura actual

---

## TIPOS DE REFERENCIAS

### 1. Ejemplos Ilustrativos
```rst
UC-010 Asignar Rol
UC-017 Consultar Reporte
```

**Tipo:** Casos concretos como ejemplos
**Acción:** Actualizar a nomenclatura v4.0.0

### 2. Rangos de Dominio
```rst
UC-005 a UC-011, UC-041, UC-042
UC-017 a UC-024
```

**Tipo:** Agrupación por módulo funcional
**Acción:** Actualizar a rangos nuevos (UC_USR_XX, UC_RPT_XX)

### 3. Referencias en Reglas
```rst
Genera: UC-010 (flujo alterno de validacion SoD)
Impacto: UC-006, UC-007, UC-008
```

**Tipo:** Trazabilidad BR → UC
**Acción:** Actualizar a UC actuales

---

## DECISIÓN REQUERIDA

### Opción A: Actualizar Referencias (~2-3 horas) ← **Recomendado**

**Acción:**
- Actualizar ~25 referencias individuales
- Actualizar rangos de dominio (6 rangos)
- Cambiar ejemplos de nomenclatura FR
- Actualizar fecha de última modificación

**Pros:**
- ✅ Taxonomías actualizadas y útiles
- ✅ Onboarding sin confusión
- ✅ Búsquedas no ambiguas

**Contras:**
- ⏱️ Trabajo manual (25+ referencias)
- 📝 Requiere conocer mapeo exacto v2.0 → v4.0

**Esfuerzo:** 2-3 horas

### Opción B: Agregar Nota de Advertencia (~15 min)

**Acción:**
```rst
.. warning::

   Esta taxonomía contiene ejemplos con nomenclatura v2.0.
   La nomenclatura actual del proyecto es v4.0.0:
   
   - UC-010 → UC_ACC_01
   - UC-005 a UC-011 → UC_USR_01 a UC_USR_04, UC_ACC_01-02
   - Ver: requisitos/casos_uso/index.rst para nomenclatura vigente
```

**Pros:**
- ✅ Rápido
- ✅ Informa sobre la situación

**Contras:**
- ❌ Taxonomía sigue obsoleta
- ❌ Rangos incorrectos

**Esfuerzo:** 15 minutos

### Opción C: Reescribir con Referencias Genéricas (~3-4 horas)

**Acción:**
- Cambiar UC-010 → UC_ModAccess_01 (genérico)
- Cambiar rangos a descripciones: "Módulo de Usuarios (4 UC)"

**Pros:**
- ✅ Atemporal (no depende de nomenclatura)

**Contras:**
- ❌ Pierde concreción
- ❌ Menos útil como referencia

**Esfuerzo:** 3-4 horas

---

## RECOMENDACIÓN

### ⭐ Opción A: Actualizar Referencias

**Razón:**
- Taxonomías se consultan frecuentemente
- Definen estructura del proyecto (deben estar correctas)
- Ejemplos concretos son más útiles que genéricos
- Esfuerzo justificado para documento importante

**PERO:** Requiere conocer mapeo exacto v2.0 → v4.0

**Alternativa si no tengo todos los módulos:**
- Actualizar solo lo que sé con certeza (access, users)
- Agregar nota para el resto

---

## DEPENDENCIAS

Para actualizar correctamente, necesito:
1. ✅ access/ - Ya verificado (UC_ACC_01 a UC_ACC_09)
2. ⏳ auth/ - Verificar UC_AUTH_01 a UC_AUTH_05
3. ⏳ users/ - Verificar UC_USR_01 a UC_USR_04
4. ⏳ reports/ - Verificar UC_RPT_01 a UC_RPT_14
5. ⏳ alerts/ - Verificar UC_ALR_01 a UC_ALR_05
6. ⏳ audit/ - Verificar UC_AUD_01 a UC_AUD_04
7. ⏳ logs/ - Verificar UC_LOG_01 a UC_LOG_04
8. ⏳ pipeline/ - Verificar UC_PIP_01 a UC_PIP_04

Sin estos, el mapeo es parcial/aproximado.

---

**Estado:** ⚠️ MUCHAS REFERENCIAS DESACTUALIZADAS (~25+)  
**Esperando:** 
1. Decisión (A, B o C)
2. Archivos de otros módulos para mapeo exacto

