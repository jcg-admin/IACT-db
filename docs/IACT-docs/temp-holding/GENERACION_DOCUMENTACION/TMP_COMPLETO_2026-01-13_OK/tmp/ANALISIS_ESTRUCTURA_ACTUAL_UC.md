# ANÁLISIS: ESTRUCTURA ACTUAL DE CASOS DE USO

**Fecha:** 2026-01-07  
**Versión Casos de Uso:** 4.0.0  
**Versión RBAC:** 5.1.1  
**Estado:** CORRECTA - Base para sincronización

---

## ESTRUCTURA CONFIRMADA

### Archivos Base (CORRECTOS)
```
source/requisitos/casos_uso/
├── index.rst                    ✅ v4.0.0 (49 UC, 8 módulos)
├── actores.rst                  ✅ RBAC v5.1.1 (10 agrupadores)
├── glosario.rst                 ✅ Términos y definiciones
├── restricciones.rst            ✅ CNST (restricciones arquitectónicas)
└── _static/
    └── plantuml_styles.iuml     ✅ Estilos para diagramas
```

### Distribución de UC por Módulo

| Módulo | Prefijo | Cantidad UC | Rango | Estado |
|--------|---------|-------------|-------|--------|
| MOD_Auth | AUTH | 5 | UC_AUTH_01 → UC_AUTH_05 | ✅ |
| MOD_Users | USR | 4 | UC_USR_01 → UC_USR_04 | ✅ |
| MOD_Access | ACC | 9 | UC_ACC_01 → UC_ACC_09 | ✅ |
| MOD_Pipeline | PIP | 4 | UC_PIP_01 → UC_PIP_04 | ✅ |
| MOD_Reports | RPT | 14 | UC_RPT_01 → UC_RPT_14 | ✅ |
| MOD_Alerts | ALR | 5 | UC_ALR_01 → UC_ALR_05 | ✅ |
| MOD_Audit | AUD | 4 | UC_AUD_01 → UC_AUD_04 | ✅ |
| MOD_Logs | LOG | 4 | UC_LOG_01 → UC_LOG_04 | ✅ |
| **TOTAL** | - | **49** | - | - |

### Agrupadores RBAC v5.1.1

| ID | Código | Descripción | Funciones |
|----|--------|-------------|-----------|
| AGR-001 | agr_operador_basico | Consulta básica | 5 |
| AGR-002 | agr_operador_reportes | Reportes sin exportación | 8 |
| AGR-003 | agr_supervisor | Reportes + exportación | ~12 |
| AGR-004 | (pendiente) | - | - |
| AGR-005 | (alertas) | Gestión de alertas | ~5 |
| AGR-006 | (admin auth) | Autenticación | ~4 |
| AGR-007 | (admin acceso) | Control de acceso | ~6 |
| AGR-008 | (auditor) | Auditoría | ~4 |
| AGR-009 | (admin pipeline) | Supervisión ETL | ~4 |
| AGR-010 | (soporte) | Logs técnicos | ~2 |

### Restricciones CNST (mínimo detectadas)

| CNST | Nombre | Severidad | Módulos |
|------|--------|-----------|---------|
| CNST-001 | Comunicaciones Prohibidas | CRÍTICA | AUTH, USR, ALR, RPT, AUD |
| CNST-002 | Sesión Única y Timeout | ALTA | AUTH |
| CNST-003 | BD Dual Inmutable | CRÍTICA | PIP, RPT |
| CNST-004+ | (otras restricciones) | - | - |

---

## NOMENCLATURA CONFIRMADA

### Formato UC v4.0.0
```
UC_[MOD]_[NN]

Ejemplos:
  UC_AUTH_01  → Iniciar Sesión
  UC_USR_01   → Crear Usuario
  UC_ACC_01   → Asignar Funciones
  UC_RPT_06   → Exportar CSV
```

### Cambio de Versiones Anteriores
```
Antes (v3.x?):  UC_001, UC_002, UC_003...
Ahora (v4.0.0): UC_AUTH_01, UC_AUTH_02, UC_USR_01...
```

**Razón:** Nomenclatura "Clean Code" con prefijo de módulo para mejor organización.

---

## ARCHIVOS INDIVIDUALES ESPERADOS

Por módulo, deberías tener:

```
auth/
├── index.rst
├── UC_AUTH_01_Iniciar_Sesion.rst
├── UC_AUTH_02_Cerrar_Sesion.rst
├── UC_AUTH_03_Recuperar_Contrasena.rst
├── UC_AUTH_04_Cambiar_Contrasena.rst
└── UC_AUTH_05_Gestionar_Sesiones.rst

users/
├── index.rst
├── UC_USR_01_Crear_Usuario.rst
├── UC_USR_02_Consultar_Usuarios.rst
├── UC_USR_03_Modificar_Usuario.rst
└── UC_USR_04_Eliminar_Usuario.rst

access/
├── index.rst
├── UC_ACC_01_Asignar_Funciones.rst
├── UC_ACC_02_Revocar_Funciones.rst
├── UC_ACC_03_Consultar_Permisos.rst
├── UC_ACC_04_Asignar_Agrupador.rst
├── UC_ACC_05_Gestionar_SoD.rst
├── UC_ACC_06_Gestionar_Segmentos.rst
├── UC_ACC_07_Asignar_Segmento.rst
├── UC_ACC_08_Permiso_Temporal.rst
└── UC_ACC_09_Auditar_Cambios_Acceso.rst

[... y así para cada módulo]
```

**Total esperado:** 49 archivos UC + 8 index.rst = 57 archivos

---

## RELACIONES ENTRE ARTEFACTOS

### UC → Funciones RBAC
Cada UC especifica qué funciones atómicas se requieren:

```
UC_RPT_01: Consultar Reporte Trimestral
  └─ Funciones: RPT-001 (ve_reportes)
  └─ Agrupadores: AGR-002, AGR-003

UC_ACC_01: Asignar Funciones
  └─ Funciones: ACC-001 (asigna_funciones)
  └─ Agrupadores: AGR-007
```

### UC → Restricciones CNST
Cada UC debe cumplir las restricciones aplicables:

```
UC_ALR_01: Configurar Alerta
  └─ CNST-001: Solo notificaciones internas (NO email/SMS)

UC_PIP_01: Supervisar ETL
  └─ CNST-003: Solo lectura de BD IVR
```

---

## DOCUMENTOS QUE DEBEN SINCRONIZARSE

Si estos documentos mencionan los UC, deben actualizarse:

### En `source/requisitos/`:
- `requisitos_funcionales/` → Derivados de UC v4.0.0
- `requisitos_no_funcionales/` → Referenciados por UC
- `rtm/` (matriz trazabilidad) → Mapeo UC → FR

### En `source/normativa/`:
- `restricciones/` → Si describe CNST aplicables a UC
- `procedimientos/` → Si tiene procesos de derivación UC → FR

### En `source/arquitectura_tecnica/`:
- `modulos/` → Si describe MOD_Auth, MOD_Users, etc.
- Cualquier documento que referencie UC antiguos

### En `source/gestion/`:
- `evidencia/` → Si tiene trazabilidad UC
- `pm/` → Si tiene planificación basada en UC

---

## SIGUIENTE PASO

**ESPERANDO:** Archivos individuales de UC (ej: UC_AUTH_01_Iniciar_Sesion.rst)

Una vez los reciba, podré:
1. Verificar formato y contenido
2. Identificar qué otros documentos referencian UC antiguos
3. Crear plan CONCRETO de actualización

---

**Estado:** ANÁLISIS COMPLETO  
**Próxima acción:** Esperar casos de uso individuales

