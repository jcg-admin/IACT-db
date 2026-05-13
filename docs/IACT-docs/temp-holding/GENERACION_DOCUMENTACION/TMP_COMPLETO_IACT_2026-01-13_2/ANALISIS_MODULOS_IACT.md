# ANALISIS DE MODULOS DEL SISTEMA IACT
## Busqueda de Definiciones MOD-01 a MOD-09

Fecha: 2025-12-22
Consulta: Busqueda de modulos AUTH, USER_IDENTITY, RBAC_CORE, ETL_MONITORING, 
          VIS_REPORTS, ALERTS, AUDIT, SYS_LOGS, SEC_RULES

--------------------------------------------------------------------------------

## 1. RESULTADO DE BUSQUEDA

### 1.1 Busqueda de IDs Especificos (MOD-01 a MOD-09)

NO SE ENCONTRARON referencias a los identificadores:
- MOD-01 AUTH
- MOD-02 USER_IDENTITY
- MOD-03 RBAC_CORE
- MOD-04 ETL_MONITORING
- MOD-05 VIS_REPORTS
- MOD-06 ALERTS
- MOD-07 AUDIT
- MOD-08 SYS_LOGS
- MOD-09 SEC_RULES

Estos IDs NO existen en la documentacion actual del proyecto.

--------------------------------------------------------------------------------

## 2. MODULOS IDENTIFICADOS EN LA DOCUMENTACION

### 2.1 Definicion en SBVR_01_Conceptos_Nucleares.rst

Ubicacion: /mnt/user-data/outputs/SBVR_01_Conceptos_Nucleares.rst
Seccion: 6.1 Modulo

MODULOS IDENTIFICADOS (6 modulos):
1. Gestion de Usuarios
2. Reportes
3. Dashboard
4. Alertas
5. Auditoria
6. Administracion del Sistema

CARACTERISTICAS:
- Tiene un codigo unico
- Tiene permisos asociados
- Puede habilitarse/deshabilitarse por usuario


### 2.2 Definicion en SBVR_03_Reglas_Estructurales.rst

Ubicacion: /mnt/user-data/outputs/SBVR_03_Reglas_Estructurales.rst
Seccion: 7.3 Catalogo de Modulos

MODULOS (6 modulos fijos):
1. Gestion de Usuarios
2. Reportes
3. Dashboard
4. Alertas
5. Auditoria
6. Administracion del Sistema

EXPRESION FORMAL: COUNT(Modulo) = 6


### 2.3 Definicion en GOB_02_Roles_y_RACI.rst

Ubicacion: /mnt/user-data/outputs/GOB_02_Roles_y_RACI.rst
Seccion: 4.2 Modulos del Sistema

CATEGORIAS DE MODULOS:

**Categoria: Basicos**
- Dashboard Principal (obligatorio)
- Mi Perfil (obligatorio)
- Reportes Basicos

**Categoria: Reportes**
- Reportes Avanzados (requiere: Reportes Basicos)
- Reportes Personalizados (requiere: Reportes Basicos)
- Reportes Ejecutivos
- Reportes Operativos

**Categoria: Visualizacion**
- Dashboards Estandar
- Dashboards Personalizados (requiere: Dashboards Estandar)

**Categoria: Exportacion**
- Exportacion Basica (CSV, Excel)
- Exportacion Avanzada (PDF)

**Categoria: Alertas**
- Alertas Basicas
- Configuracion de Alertas (requiere: Alertas Basicas)
- Alertas de Equipo (requiere: Configuracion de Alertas)

--------------------------------------------------------------------------------

## 3. ESTRUCTURA DE APPS DJANGO (CODIGO)

### 3.1 Apps Identificadas en CNST

Basado en imports y referencias en los archivos CNST_*.rst:

| App Django | Archivos Referenciados | Proposito |
|------------|----------------------|-----------|
| apps.users | models.py, views.py | Gestion de usuarios, sesiones, login |
| apps.common | models.py, middleware.py, permissions.py, notifications.py, validators.py, exceptions.py, pagination.py, throttling.py, serializers.py, decorators.py, classification.py, constants.py, routers.py, monitoring.py, views.py | Utilidades compartidas |
| apps.analytics | models.py, repositories.py, serializers.py, views.py | Metricas y analiticos |
| apps.etl | apps.py, extractors.py, loaders.py, transformers.py, tasks.py, scheduler.py, models.py, views.py, urls.py, monitoring.py | Pipeline ETL |
| apps.reports | serializers.py, views.py | Reportes |
| apps.exports | models.py, services.py | Exportacion de datos |
| apps.ivr | models.py | Modelos IVR (solo lectura) |
| apps.monitoring | metrics.py, views.py | Monitoreo del sistema |


### 3.2 Mapeo Apps Django a Modulos Logicos

| Modulo Logico SBVR | App Django Correspondiente |
|-------------------|---------------------------|
| Gestion de Usuarios | apps.users |
| Reportes | apps.reports + apps.exports |
| Dashboard | apps.analytics |
| Alertas | (no identificado explicitamente) |
| Auditoria | apps.common (parcial) |
| Administracion del Sistema | apps.common + config |

--------------------------------------------------------------------------------

## 4. ROLES RELACIONADOS CON MODULOS

### 4.1 Rol R015 - MODULES_ADMIN

Ubicacion: Modelo_RBAC_Completo_-_Sistema_IACT_-_v_0_0_1.md

Permisos del rol MODULES_ADMIN:
- modules.assign.user - Asignar modulos a usuarios
- modules.view.available - Ver catalogo de modulos
- modules.enable - Habilitar modulo
- modules.disable - Deshabilitar modulo
- modules.configure - Configurar modulo
- modules.permissions.configure - Configurar permisos de modulo
- modules.dependencies.view - Ver dependencias
- modules.profile.create - Crear perfil de modulos
- modules.profile.edit - Editar perfil
- modules.profile.delete - Eliminar perfil (no predefinidos)
- modules.profile.assign - Asignar perfil a usuario
- modules.profile.view - Ver perfiles
- users.modules.view - Ver modulos de usuario


### 4.2 Otros Roles Relacionados

| ID | Rol | Categoria |
|----|-----|-----------|
| R011 | ALERTS_VIEWER | Alertas |
| R012 | ALERTS_CONFIGURATOR | Alertas |
| R013 | ALERTS_TEAM_MANAGER | Alertas |
| R014 | ALERTS_GLOBAL_ADMIN | Alertas |
| R017 | AUDIT_VIEWER | Administracion |

--------------------------------------------------------------------------------

## 5. CASOS DE USO DE MODULOS

### 5.1 UC Identificados en FND_03_Casos_de_Uso.rst

- UC-012: Asignar Modulos a Usuario
- UC-013: Crear Perfil de Modulos
- UC-015: Ver Modulos Disponibles
- UC-016: Configurar Permisos de Modulo

--------------------------------------------------------------------------------

## 6. COMPARATIVA: MODULOS SOLICITADOS vs EXISTENTES

### 6.1 Mapeo Tentativo

| MOD Solicitado | Equivalente Encontrado | Estado |
|----------------|----------------------|--------|
| MOD-01 AUTH | apps.users (login, sesiones) | Parcial - sin ID formal |
| MOD-02 USER_IDENTITY | apps.users (modelos usuario) | Parcial - sin ID formal |
| MOD-03 RBAC_CORE | apps.common.permissions | Parcial - sin ID formal |
| MOD-04 ETL_MONITORING | apps.etl + apps.monitoring | Parcial - sin ID formal |
| MOD-05 VIS_REPORTS | apps.reports + apps.analytics | Parcial - sin ID formal |
| MOD-06 ALERTS | Modulo "Alertas" (logico) | Solo conceptual |
| MOD-07 AUDIT | apps.common.audit (parcial) | Solo parcial |
| MOD-08 SYS_LOGS | CNST_009 (logging) | Solo restricciones |
| MOD-09 SEC_RULES | apps.common.permissions | Parcial - sin ID formal |


### 6.2 Gaps Identificados

1. NO existe un catalogo formal de modulos con IDs (MOD-XX)
2. Los 6 modulos logicos de SBVR NO tienen identificadores unicos asignados
3. Las apps Django NO estan mapeadas formalmente a modulos de negocio
4. Falta documentacion de modulos a nivel de arquitectura (ARQ_MOD_*)
5. No hay trazabilidad explicita Modulo -> App -> Componente

--------------------------------------------------------------------------------

## 7. RECOMENDACIONES

### 7.1 Crear Catalogo Formal de Modulos

Se sugiere crear un artefacto CAT_MOD_Catalogo_Modulos.rst con:

| ID | Nombre | Apps Django | Descripcion |
|----|--------|-------------|-------------|
| MOD-01 | AUTH | apps.users | Autenticacion y login |
| MOD-02 | USER_MGMT | apps.users | Gestion de usuarios |
| MOD-03 | RBAC | apps.common.permissions | Control de acceso |
| MOD-04 | ETL | apps.etl | Pipeline de datos |
| MOD-05 | ANALYTICS | apps.analytics | Dashboard y metricas |
| MOD-06 | REPORTS | apps.reports, apps.exports | Reportes y exportacion |
| MOD-07 | ALERTS | (por definir) | Sistema de alertas |
| MOD-08 | AUDIT | apps.common.audit | Auditoria de acciones |
| MOD-09 | MONITORING | apps.monitoring | Monitoreo del sistema |


### 7.2 Actualizar SBVR con IDs

Modificar SBVR_03_Reglas_Estructurales.rst para incluir IDs formales:

MODULOS:
1. MOD-01: Autenticacion (AUTH)
2. MOD-02: Gestion de Usuarios (USER_MGMT)
3. MOD-03: Control de Acceso (RBAC)
4. MOD-04: Pipeline ETL (ETL)
5. MOD-05: Dashboard y Analiticos (ANALYTICS)
6. MOD-06: Reportes (REPORTS)
7. MOD-07: Alertas (ALERTS)
8. MOD-08: Auditoria (AUDIT)
9. MOD-09: Monitoreo (MONITORING)


### 7.3 Crear Documentacion ARQ_MOD

Segun ESTRUCTURA v2.0.0, se podrian crear:
- ARQ_MOD_001_Modulo_Auth.rst
- ARQ_MOD_002_Modulo_Users.rst
- etc.

--------------------------------------------------------------------------------

## 8. CONCLUSION

Los modulos MOD-01 a MOD-09 con los nombres especificos consultados 
(AUTH, USER_IDENTITY, RBAC_CORE, etc.) NO EXISTEN en la documentacion actual.

Sin embargo, el sistema SI tiene definidos:
- 6 modulos logicos en SBVR (sin IDs formales)
- 8 apps Django con estructura de codigo
- Permisos de modulos en RBAC (R015 MODULES_ADMIN)
- Casos de uso relacionados (UC-012 a UC-016)

La brecha principal es la FALTA DE IDENTIFICADORES FORMALES para modulos
y la FALTA DE TRAZABILIDAD explicita entre:
  Modulo Logico <-> App Django <-> Componentes <-> Restricciones

Se recomienda crear un catalogo formal de modulos (CAT_MOD_) que unifique
estos conceptos y asigne IDs consistentes.

--------------------------------------------------------------------------------

Fin del Analisis
