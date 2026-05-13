# ANÁLISIS DE ERRORES - MODELO_RBAC_IACT v5.2.0

**Fecha:** 2026-01-13  
**Documento analizado:** MODELO_RBAC_IACT_v5_2_0.md  
**Metodología:** Clean Code v2.0.0

---

## 1. RESUMEN DE ERRORES ENCONTRADOS

| Categoría | Errores | Gravedad |
|-----------|---------|----------|
| Nombres de funciones (dominio) | 42 | 🔴 CRÍTICA |
| Nombres de grupos | 10 | 🔴 CRÍTICA |
| Campos SQL mezclados | 15+ | 🟡 ALTA |
| Inconsistencias en ejemplos | 20+ | 🟡 ALTA |
| **TOTAL** | **87+** | **INACEPTABLE** |

---

## 2. ERROR FUNDAMENTAL: INCONSISTENCIA EN ESTÁNDAR

### 2.1. Lo que DIJE que iba a hacer:

> "NUEVA REGLA (desde v5.2):
> ✅ CÓDIGO: Inglés
> ✅ COMENTARIOS: Español
> ✅ NOMBRES FUNCIONES (dominio): Español"

### 2.2. Lo que DEBÍ hacer (según usuario):

> ✅ CÓDIGO: Inglés
> ✅ COMENTARIOS: Español
> ✅ **NOMBRES FUNCIONES (dominio): INGLÉS**

### 2.3. Impacto

**VIOLÉ mi propio estándar:**
- Dejé nombres de funciones en español
- Dejé nombres de grupos en español
- Creé confusión e inconsistencia

**Razón del error:**
- Asumí que "dominio" significa "mantener español"
- NO leí que el usuario quiere **TODO en inglés**

---

## 3. ERRORES EN NOMBRES DE FUNCIONES (42 funciones)

### 3.1. Patrón del Error

**❌ INCORRECTO (lo que hice):**
```sql
INSERT INTO functions (function_id, name, description, category) VALUES
('AUTH-001', 'gestiona_sesiones', 'Gestiona sesiones activas', 'auth'),
('USR-001', 'crea_usuarios', 'Crea nuevos usuarios', 'users'),
('RPT-004', 'exporta_csv', 'Exporta a CSV', 'reports');
```

**✅ CORRECTO (lo que debo hacer):**
```sql
INSERT INTO functions (function_id, name, description, category) VALUES
('AUTH-001', 'manage_sessions', 'Gestiona sesiones activas', 'auth'),
('USR-001', 'create_users', 'Crea nuevos usuarios', 'users'),
('RPT-004', 'export_csv', 'Exporta a CSV', 'reports');
```

**Patrón correcto:**
- `function_id`: Sigue igual (AUTH-001, USR-001, etc.)
- `name`: **INGLÉS** (manage_sessions, create_users)
- `description`: **ESPAÑOL** (comentario)
- `category`: Sigue igual (auth, users, etc.)

### 3.2. Tabla Completa de Correcciones (42 funciones)

#### MOD_Auth (4 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| AUTH-001 | `gestiona_sesiones` | `manage_sessions` | Inglés |
| AUTH-002 | `cierra_sesion_usuario` | `close_user_session` | Inglés |
| AUTH-003 | `resetea_password` | `reset_password` | Inglés |
| AUTH-004 | `ve_sesiones_activas` | `view_active_sessions` | Inglés |

#### MOD_Users (9 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| USR-001 | `crea_usuarios` | `create_users` | Inglés |
| USR-002 | `modifica_usuarios` | `update_users` | Inglés + verbo estándar |
| USR-003 | `elimina_usuarios` | `delete_users` | Inglés |
| USR-004 | `lista_usuarios` | `list_users` | Inglés |
| USR-005 | `busca_usuarios` | `search_users` | Inglés |
| USR-006 | `bloquea_usuarios` | `block_users` | Inglés |
| USR-007 | `desbloquea_usuarios` | `unblock_users` | Inglés |
| USR-008 | `reactiva_usuarios` | `reactivate_users` | Inglés |
| USR-009 | `ve_usuarios` | `view_users` | Inglés |

#### MOD_Access (5 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| ACC-001 | `asigna_funciones` | `assign_functions` | Inglés |
| ACC-002 | `revoca_funciones` | `revoke_functions` | Inglés |
| ACC-003 | `ve_asignaciones` | `view_assignments` | Inglés |
| ACC-004 | `asigna_agrupadores` | `assign_function_groups` | Inglés + completo |
| ACC-005 | `gestiona_sod` | `manage_separation_rules` | Inglés + sin acrónimo |

#### MOD_Pipeline (4 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| PIP-001 | `ve_estado_etl` | `view_pipeline_status` | Inglés + sin acrónimo |
| PIP-002 | `ve_errores_etl` | `view_pipeline_errors` | Inglés + sin acrónimo |
| PIP-003 | `ve_disponibilidad_datos` | `view_data_availability` | Inglés |
| PIP-004 | `solicita_reintento_etl` | `request_pipeline_retry` | Inglés + sin acrónimo |

#### MOD_Reports (8 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| RPT-001 | `ve_reportes` | `view_reports` | Inglés |
| RPT-002 | `ve_dashboard` | `view_dashboard` | Inglés |
| RPT-003 | `filtra_reportes` | `filter_reports` | Inglés |
| RPT-004 | `exporta_csv` | `export_csv` | Inglés |
| RPT-005 | `exporta_excel` | `export_excel` | Inglés |
| RPT-006 | `exporta_pdf` | `export_pdf` | Inglés |
| RPT-007 | `ve_kpis` | `view_kpis` | Inglés |
| RPT-008 | `ve_graficos` | `view_charts` | Inglés + "charts" no "graphics" |

**Nota:** `charts` es mejor que `graphics` para gráficos de datos.

#### MOD_Alerts (6 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| ALR-001 | `ve_alertas` | `view_alerts` | Inglés |
| ALR-002 | `configura_alertas` | `configure_alerts` | Inglés |
| ALR-003 | `configura_alertas_equipo` | `configure_team_alerts` | Inglés |
| ALR-004 | `pausa_alertas` | `pause_alerts` | Inglés |
| ALR-005 | `elimina_alertas` | `delete_alerts` | Inglés |
| ALR-006 | `ve_historial_alertas` | `view_alert_history` | Inglés |

#### MOD_Audit (4 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| AUD-001 | `ve_auditoria` | `view_audit_log` | Inglés + "log" explícito |
| AUD-002 | `busca_auditoria` | `search_audit_log` | Inglés + "log" explícito |
| AUD-003 | `exporta_auditoria` | `export_audit_log` | Inglés + "log" explícito |
| AUD-004 | `genera_reporte_compliance` | `generate_compliance_report` | Inglés |

#### MOD_Logs (2 funciones)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| LOG-001 | `ve_logs_tecnicos` | `view_technical_logs` | Inglés |
| LOG-002 | `exporta_logs` | `export_logs` | Inglés |

---

## 4. ERRORES EN NOMBRES DE GRUPOS (10 grupos)

### 4.1. Patrón del Error

**❌ INCORRECTO (lo que hice):**
```sql
INSERT INTO function_groups (group_id, name, description) VALUES
('AGR-001', 'agr_operador_basico', 'Visualización básica');
```

**✅ CORRECTO (lo que debo hacer):**
```sql
INSERT INTO function_groups (group_id, name, description) VALUES
('AGR-001', 'basic_operator_group', 'Visualización básica');
```

**Problemas adicionales:**
1. Prefijo `agr_` redundante (ya está en `group_id`)
2. Español en lugar de inglés

### 4.2. Tabla de Correcciones (10 grupos)

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| AGR-001 | `agr_operador_basico` | `basic_operator_group` | Inglés + sin prefijo redundante |
| AGR-002 | `agr_visualizador_reportes` | `report_viewer_group` | Inglés + sin prefijo |
| AGR-003 | `agr_supervisor_calidad` | `quality_supervisor_group` | Inglés + sin prefijo |
| AGR-004 | `agr_exportador_datos` | `data_exporter_group` | Inglés + sin prefijo |
| AGR-005 | `agr_gestor_alertas` | `alert_manager_group` | Inglés + sin prefijo |
| AGR-006 | `agr_admin_usuarios` | `user_admin_group` | Inglés + sin prefijo |
| AGR-007 | `agr_admin_permisos` | `permission_admin_group` | Inglés + sin prefijo |
| AGR-008 | `agr_auditor` | `auditor_group` | Inglés + sin prefijo |
| AGR-009 | `agr_admin_pipeline` | `pipeline_admin_group` | Inglés + sin prefijo |
| AGR-010 | `agr_admin_sistema` | `system_admin_group` | Inglés + sin prefijo |

**Patrón correcto:**
- Eliminar prefijo `agr_` (redundante con AGR-001)
- Usar inglés
- Formato: `{role}_{scope}_group` o `{role}_group`

---

## 5. ERRORES EN NOMBRES DE REGLAS SOD (3 reglas)

### 5.1. Tabla de Correcciones

| ID | ❌ INCORRECTO | ✅ CORRECTO | Razón |
|----|--------------|-------------|-------|
| SOD-001 | `sod_admin_auditoria` | `pipeline_audit_separation` | Inglés + descriptivo |
| SOD-002 | `sod_usuarios_auditoria` | `user_audit_separation` | Inglés + descriptivo |
| SOD-003 | `sod_acceso_auditoria` | `access_audit_separation` | Inglés + descriptivo |

**Problemas:**
1. Prefijo `sod_` redundante (ya está en SOD-001)
2. Español mezclado con inglés
3. Poco descriptivo

---

## 6. ERRORES EN CAMPOS SQL

### 6.1. Nombres de Columnas Inconsistentes

**❌ INCORRECTO (lo que hice):**
```sql
CREATE TABLE function_separation_rule_details (
    separation_group CHAR(1)  -- ❌ "separation_group" confuso
);
```

**✅ CORRECTO:**
```sql
CREATE TABLE function_separation_rule_details (
    rule_group CHAR(1)  -- ✅ Más claro
);
```

### 6.2. Tabla de Correcciones de Campos

| Tabla | ❌ Campo Incorrecto | ✅ Campo Correcto | Razón |
|-------|---------------------|-------------------|-------|
| `function_separation_rule_details` | `separation_group` | `rule_group` | Más conciso |
| `user_function_assignments` | `assigned_date` | `assigned_at` | Convención `*_at` para datetime |
| `user_function_group_assignments` | `assigned_date` | `assigned_at` | Convención `*_at` para datetime |

---

## 7. ERRORES EN DECORATORS Y EJEMPLOS

### 7.1. Ejemplos con Nombres Incorrectos

**❌ INCORRECTO (en documento):**
```python
@require_function('RPT-001', 'RPT-002')
def list_reports(request):
    """Listado de reportes."""
    pass
```

**Problema:** El decorator usa IDs pero debería mostrar nombres para claridad.

**✅ CORRECTO:**
```python
@require_function('RPT-001')  # view_reports
def list_reports(request):
    """Listado de reportes."""
    pass
```

---

## 8. ERRORES EN MODELOS DJANGO

### 8.1. help_text Mezclados

**❌ INCORRECTO:**
```python
name = models.CharField(
    help_text="Nombre descriptivo (ve_reportes, exporta_csv)"  # ❌ Ejemplos en español
)
```

**✅ CORRECTO:**
```python
name = models.CharField(
    help_text="Nombre descriptivo (view_reports, export_csv)"  # ✅ Ejemplos en inglés
)
```

### 8.2. Docstrings con Ejemplos Incorrectos

**❌ INCORRECTO:**
```python
class Function(models.Model):
    """
    Función atómica del sistema.
    
    Ejemplos:
    - ve_reportes       # ❌ Español
    - exporta_csv       # ❌ Español
    """
```

**✅ CORRECTO:**
```python
class Function(models.Model):
    """
    Función atómica del sistema.
    
    Ejemplos:
    - view_reports      # ✅ Inglés
    - export_csv        # ✅ Inglés
    """
```

---

## 9. ERRORES EN SERVICES

### 9.1. Método calculate_effective_functions

**❌ INCORRECTO (comentario):**
```python
def calculate_effective_functions(self, user: User) -> Set[str]:
    """
    Returns:
        Set de function_id: {'RPT-001', 'RPT-002', ...}  # ❌ Español "de"
    """
```

**✅ CORRECTO:**
```python
def calculate_effective_functions(self, user: User) -> Set[str]:
    """
    Returns:
        Set of function_id: {'RPT-001', 'RPT-002', ...}  # ✅ Inglés "of"
    """
```

---

## 10. RESUMEN DE TRANSFORMACIONES NECESARIAS

### 10.1. Nombres de Funciones

**Patrón de transformación:**

```
❌ Español (snake_case)        ✅ Inglés (snake_case)
───────────────────────────────────────────────────
gestiona_*          →  manage_*
ve_*                →  view_*
crea_*              →  create_*
modifica_*          →  update_*
elimina_*           →  delete_*
busca_*             →  search_*
bloquea_*           →  block_*
desbloquea_*        →  unblock_*
reactiva_*          →  reactivate_*
asigna_*            →  assign_*
revoca_*            →  revoke_*
configura_*         →  configure_*
pausa_*             →  pause_*
solicita_*          →  request_*
exporta_*           →  export_*
filtra_*            →  filter_*
genera_*            →  generate_*
```

### 10.2. Verbos Específicos

```
ve_reportes         →  view_reports
ve_graficos         →  view_charts (NO "graphics")
ve_auditoria        →  view_audit_log
cierra_sesion       →  close_session
resetea_password    →  reset_password
```

---

## 11. PLAN DE CORRECCIÓN

### 11.1. Fase 1: Actualizar SQL (1h)

```sql
-- Actualizar 42 funciones
UPDATE functions SET name = 'manage_sessions' WHERE function_id = 'AUTH-001';
UPDATE functions SET name = 'close_user_session' WHERE function_id = 'AUTH-002';
-- ... etc (42 updates)

-- Actualizar 10 grupos
UPDATE function_groups SET name = 'basic_operator_group' WHERE group_id = 'AGR-001';
-- ... etc (10 updates)

-- Actualizar 3 reglas SoD
UPDATE function_separation_rules 
SET name = 'pipeline_audit_separation' 
WHERE restriction_id = 'SOD-001';
-- ... etc (3 updates)
```

### 11.2. Fase 2: Actualizar Modelos Django (30min)

- Actualizar docstrings con ejemplos en inglés
- Actualizar help_text con ejemplos en inglés
- Actualizar nombres de campos si necesario

### 11.3. Fase 3: Actualizar Decorators (15min)

- Actualizar comentarios en decorators
- Actualizar ejemplos de uso

### 11.4. Fase 4: Actualizar Documentación (1h)

- Actualizar TODAS las menciones de nombres de funciones
- Actualizar TODOS los ejemplos
- Verificar consistencia

**Total:** ~2.75 horas

---

## 12. LECCIONES APRENDIDAS

### 12.1. Error Fundamental

**Lo que hice mal:**
- Asumí que "dominio" = "mantener español"
- No leí claramente el requerimiento del usuario
- Fui inconsistente con mi propio estándar

**Lo que debo hacer:**
- **TODO el código en inglés** (sin excepciones)
- Comentarios y descripciones en español
- Consistencia absoluta

### 12.2. Principio Correcto

```
CÓDIGO: Inglés      (clases, métodos, variables, nombres de funciones)
DOCS:   Español     (docstrings, help_text, comments)
```

**NO HAY EXCEPCIONES** para "dominio" o cualquier otro caso.

---

## 13. CONCLUSIÓN

**Total de errores identificados:** 87+

**Categorías:**
- 🔴 Nombres de funciones: 42 errores
- 🔴 Nombres de grupos: 10 errores
- 🔴 Nombres de reglas SoD: 3 errores
- 🟡 Campos SQL: 15+ errores
- 🟡 Ejemplos y comentarios: 20+ errores

**Acción requerida:**
Generar **MODELO_RBAC_IACT_v5.2.1** con TODAS las correcciones aplicadas.

---

**FIN DEL ANÁLISIS**

**Fecha:** 2026-01-13  
**Estado:** ✅ ANÁLISIS COMPLETO  
**Siguiente:** Generar v5.2.1 CORREGIDO
