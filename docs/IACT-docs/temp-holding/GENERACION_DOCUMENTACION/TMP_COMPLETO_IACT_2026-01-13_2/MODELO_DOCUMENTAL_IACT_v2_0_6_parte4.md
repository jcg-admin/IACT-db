---

## 6. LOS 8 MÓDULOS FUNCIONALES

### 6.1 Catálogo de Módulos

| Código | Nombre | App Django | UC Asociados | Funciones RBAC |
|--------|--------|------------|--------------|----------------|
| MOD_Auth | Auth | apps.auth | UC-001 a UC-005 | AUT-001 a AUT-004 |
| MOD_Users | Users | apps.users | UC-006 a UC-009 | USR-001 a USR-010 |
| MOD_Access | Access | apps.access | UC-010, UC-011, UC-041-047 | ACC-001 a ACC-006 |
| MOD_Pipeline | Pipeline | apps.pipeline | UC-050 a UC-053 | PIP-001 a PIP-004 |
| MOD_Reports | Reports | apps.reports | UC-017 a UC-030 | RPT-001 a RPT-008 |
| MOD_Alerts | Alerts | apps.alerts | UC-036 a UC-040 | ALR-001 a ALR-006 |
| MOD_Audit | Audit | apps.audit | UC-060 a UC-063 | AUD-001 a AUD-004 |
| MOD_Logs | Logs | apps.logs | UC-070 a UC-072 | LOG-001 a LOG-002 |

### 6.2 Mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1

> **NOTA:** FND_03 define actores como Roles (R001-R018). 
> RBAC v5.1.1 usa Agrupadores (AGR-001 a AGR-010) con filosofía "Sin Pretensiones".

| Actor FND_03 | Rol Legacy | Agrupador RBAC | Funciones |
|--------------|------------|----------------|-----------|
| Gestión Usuarios | R001 | AGR-001 administrador_usuarios | USR-001 a USR-010 |
| Visor Usuarios | R002 | AGR-002 visor_usuarios | USR-005, USR-006 |
| Reportes | R004-R007 | AGR-003 analista_reportes | RPT-001 a RPT-008 |
| Dashboard | R008-R009 | AGR-004 visor_dashboard | RPT-001, RPT-007, RPT-008 |
| Alertas | R011-R014 | AGR-005 gestor_alertas | ALR-001 a ALR-006 |
| Supervisor | R003 | AGR-006 supervisor_equipo | USR-005/06, RPT-001/07 |
| Auditor | R017 | AGR-007 auditor | AUD-001 a AUD-004 |
| Admin Seguridad | R018 | AGR-008 admin_seguridad | ACC-001 a ACC-006 |
| Admin Sistema | R016 | AGR-009 admin_sistema | PIP-*, LOG-*, config |
| Operador ETL | (nuevo) | AGR-010 operador_etl | PIP-001 a PIP-004 |

**Uso en UC:** Actor Primario = Agrupador (ej: `AGR-001 administrador_usuarios`)

### 6.3 SEC_RULES (Integrado en MOD_Access)

SEC_RULES NO es módulo separado. Es subcapa interna de MOD_Access:

| Componente | Visibilidad | Descripción |
|------------|-------------|-------------|
| RBAC_CORE | Usuario ve UI | Administración roles/permisos |
| SEC_RULES | Automático | Enforcement middleware/decoradores |

---

## 7. MÉTRICAS DE COBERTURA RTM

### 7.1 Umbrales Mínimos IACT

| Cobertura | Umbral | Fórmula |
|-----------|--------|---------|
| BReq → UC | 100% | BReq con UC derivados / Total BReq |
| BR → UC | 100% | BR con impacto / Total BR |
| UC → FR | 100% | UC con FR derivados / Total UC |
| FR → CODE | 90% | FR implementados / Total FR |
| FR → TEST | 80% | FR con test / Total FR |

> **REFERENCIA:** Ver FND_07 para criterios SMART que cada FR debe cumplir.

### 7.2 Estado Actual v2.0.6

| Métrica | Valor | Estado |
|---------|-------|--------|
| BReq identificados | 5 | ✅ Completo |
| BR identificadas | 20 | ✅ Completo |
| UC identificados | 49 | ✅ Completo |
| FR derivados | 0 | ❌ Pendiente |
| Cobertura BReq→UC | 100% | ✅ Verificado |
| Cobertura BR→UC | Pendiente | ⏳ RTM |
| Cobertura CNST→BR | 100% | ✅ Completo |

---

## 8. MAPEO CNST → BR

### 8.1 Matriz de Cobertura Completa

| CNST | Descripción | BR Derivada | Tipo BR |
|------|-------------|-------------|---------|
| CNST_001 | Sin email | BR_004 | Restricción |
| CNST_002 | Sesiones BD | BR_005 | Restricción |
| CNST_003 | BD readonly | BR_001 | Restricción |
| CNST_004 | ETL batch | BR_002 | Desencadenador |
| CNST_005 | RBAC/Seguridad | BR_006, BR_007, BR_008, BR_009, BR_015 | Varios |
| CNST_006 | Antipatrones | ➖ NO genera BR | → STD_001 |
| CNST_007 | Límites/Performance | BR_011, BR_020 | Restricción |
| CNST_008 | Infraestructura | ➖ NO genera BR | → PROC_004 |
| CNST_009 | Auditoría | BR_010 | Restricción |
| CNST_010 | Clasificación datos | BR_019 | Hecho |

### 8.2 Resumen

```
CNST que generan BR:     8/10 (80%)
CNST que no aplican:     2/10 (20%) → normativa/
Cobertura efectiva:      100%
```

---

## 9. MAPEO BR → FUNCIONES RBAC v5.1.1

| BR | Funciones RBAC Afectadas |
|----|--------------------------|
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
| BR_019 | ACC-006 (gestiona_segmentos) |
| BR_020 | RPT-001 (ve_reportes), RPT-003 (filtra_reportes) |
