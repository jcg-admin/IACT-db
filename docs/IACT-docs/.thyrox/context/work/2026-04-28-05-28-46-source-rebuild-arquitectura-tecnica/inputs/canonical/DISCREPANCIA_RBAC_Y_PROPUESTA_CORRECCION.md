# ANALISIS DE DISCREPANCIA: Enfoque RBAC

**Fecha:** 2026-01-03  
**Problema:** Las BR creadas usan enfoque tradicional cuando el proyecto requiere enfoque funcional granular

---

## 1. EL PROBLEMA

### 1.1 Lo que se implemento (INCORRECTO)

Las BR creadas usan **enfoque tradicional basado en roles**:

```
BR_006 define 18 roles:
- R001 USERS_FULL_MANAGER
- R002 USERS_VIEWER
- R004 REPORTS_VIEWER
- R005 REPORTS_EXPORTER
- R010 DATA_ANALYST
- R016 SYSTEM_ADMIN
- R017 AUDIT_VIEWER
- R018 SECURITY_ADMIN
... etc
```

**Problemas de este enfoque:**
- Basado en titulos/cargos organizacionales
- No describe QUE PUEDE HACER cada rol
- Cambio de estructura organizacional requiere cambiar roles
- Dificil de auditar (que permisos tiene USERS_FULL_MANAGER?)
- No es granular ni componible

### 1.2 Lo que se requiere (CORRECTO)

El proyecto IACT requiere **enfoque funcional granular** segun documento v4.0:

```
Funciones granulares:
- crea_usuarios
- modifica_usuarios
- elimina_usuarios
- ve_usuarios
- asigna_funciones
- revoca_funciones
- ve_reportes
- exporta_reportes_csv
- exporta_reportes_excel
- configura_alertas
- ve_auditoria
... etc
```

**Ventajas de este enfoque:**
- Describe QUE PUEDE HACER cada funcion
- Titulos organizacionales no afectan el modelo
- Escalable y componible (como LEGO)
- Facil de auditar
- Cumple regulaciones (SOX, ISO 27001)
- Principio de menor privilegio aplicado

---

## 2. IMPACTO EN BR EXISTENTES

### 2.1 BR que requieren REESCRITURA COMPLETA

| BR | Estado Actual | Problema |
|----|---------------|----------|
| BR_006 | 18 roles tradicionales | Debe ser catalogo de funciones granulares |
| BR_007 | SoD entre roles | Debe ser SoD entre funciones |

### 2.2 BR que requieren AJUSTES MENORES

| BR | Estado Actual | Ajuste Necesario |
|----|---------------|------------------|
| BR_008 | Permisos directos | Cambiar terminologia rol->funcion |
| BR_011 | Limites por rol | Cambiar a limites por funcion/bundle |
| BR_012 | Usuario-Segmento | OK, no depende de roles |

### 2.3 BR que NO requieren cambios

| BR | Razon |
|----|-------|
| BR_005 | Sesion unica - independiente del modelo RBAC |
| BR_009 | Bajas logicas - independiente del modelo RBAC |
| BR_010 | Auditoria - independiente del modelo RBAC |
| BR_013 | Username unico - independiente del modelo RBAC |
| BR_015 | Bloqueo intentos - independiente del modelo RBAC |

---

## 3. PROPUESTA DE CORRECCION

### 3.1 Nueva Estructura de BR_006

**Antes (incorrecto):**
```
BR_006: Modelo RBAC Flat NIST
- 18 roles cerrados
- Permisos agrupados por rol
```

**Despues (correcto):**
```
BR_006: Modelo RBAC Funcional Granular
- Catalogo de funciones atomicas
- Patron: verbo_sustantivo
- Sin namespace (IACT es dominio unico)
- Componible via bundles
```

### 3.2 Catalogo de Funciones para IACT

Aplicando el patron del documento v4.0 al contexto de IACT:

#### Dominio: Usuarios

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| crea_usuarios | Crea nuevos usuarios en el sistema | usuarios:crear |
| modifica_usuarios | Modifica datos de usuarios | usuarios:modificar |
| elimina_usuarios | Da de baja usuarios (logica) | usuarios:eliminar |
| ve_usuarios | Consulta lista de usuarios | usuarios:leer |
| activa_usuarios | Reactiva usuarios inactivos | usuarios:activar |
| desbloquea_usuarios | Desbloquea cuentas bloqueadas | usuarios:desbloquear |

#### Dominio: Funciones (RBAC)

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| asigna_funciones | Asigna funciones a usuarios | asignaciones:crear |
| revoca_funciones | Revoca funciones de usuarios | asignaciones:eliminar |
| ve_funciones | Consulta catalogo de funciones | funciones:leer |
| configura_sod | Configura restricciones SoD | sod:configurar |

#### Dominio: Reportes

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_reportes | Visualiza reportes | reportes:leer |
| filtra_reportes | Aplica filtros a reportes | reportes:filtrar |
| exporta_csv | Exporta reportes a CSV | reportes:exportar_csv |
| exporta_excel | Exporta reportes a Excel | reportes:exportar_excel |
| exporta_pdf | Exporta reportes a PDF | reportes:exportar_pdf |
| crea_reportes | Crea reportes personalizados | reportes:crear |

#### Dominio: Dashboard

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_dashboard | Visualiza dashboard | dashboard:leer |
| personaliza_dashboard | Personaliza widgets | dashboard:modificar |

#### Dominio: Alertas

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_alertas | Consulta alertas | alertas:leer |
| configura_alertas | Configura umbrales y destinatarios | alertas:configurar |
| pausa_alertas | Pausa alertas temporalmente | alertas:pausar |

#### Dominio: Auditoria

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_auditoria | Consulta logs de auditoria | auditoria:leer |
| exporta_auditoria | Exporta logs para auditores | auditoria:exportar |

#### Dominio: ETL/Pipeline

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_etl | Consulta estado del ETL | etl:leer |
| ejecuta_etl | Ejecuta ETL manualmente | etl:ejecutar |

#### Dominio: Configuracion

| Funcion | Descripcion | Capacidades |
|---------|-------------|-------------|
| ve_configuracion | Consulta configuracion del sistema | configuracion:leer |
| modifica_configuracion | Modifica configuracion | configuracion:modificar |

### 3.3 Resumen de Funciones

| Dominio | Cantidad | Ejemplo |
|---------|----------|---------|
| Usuarios | 6 | crea_usuarios, ve_usuarios |
| Funciones (RBAC) | 4 | asigna_funciones, revoca_funciones |
| Reportes | 6 | ve_reportes, exporta_csv |
| Dashboard | 2 | ve_dashboard, personaliza_dashboard |
| Alertas | 3 | configura_alertas, pausa_alertas |
| Auditoria | 2 | ve_auditoria, exporta_auditoria |
| ETL/Pipeline | 2 | ve_etl, ejecuta_etl |
| Configuracion | 2 | ve_configuracion, modifica_configuracion |
| **TOTAL** | **27** | Funciones granulares |

### 3.4 Bundles Sugeridos para IACT

Para simplificar asignacion de funciones comunes:

| Bundle | Funciones Incluidas | Para Quien |
|--------|---------------------|------------|
| bundle_operador_basico | ve_reportes, filtra_reportes, ve_dashboard | Operadores call center |
| bundle_supervisor | ve_reportes, filtra_reportes, exporta_csv, ve_dashboard, ve_alertas | Supervisores |
| bundle_analista | ve_reportes, filtra_reportes, exporta_csv, exporta_excel, ve_dashboard, personaliza_dashboard, ve_alertas, configura_alertas | Analistas de datos |
| bundle_admin_usuarios | crea_usuarios, modifica_usuarios, ve_usuarios, asigna_funciones | Admin de usuarios |
| bundle_auditor | ve_auditoria, exporta_auditoria, ve_usuarios | Auditores internos/externos |
| bundle_admin_sistema | Todas las funciones | Administrador del sistema |

### 3.5 Nueva SoD (BR_007)

Restricciones entre FUNCIONES, no roles:

| Restriccion | Funciones Conflictivas | Razon |
|-------------|------------------------|-------|
| ssd_crea_elimina_usuarios | crea_usuarios, elimina_usuarios | Quien crea no debe eliminar |
| ssd_asigna_configura_sod | asigna_funciones, configura_sod | Separacion de poderes |
| ssd_ve_configura_auditoria | ve_auditoria, modifica_configuracion | Auditor no modifica config |
| ssd_ejecuta_ve_etl | ejecuta_etl, modifica_configuracion | Operador ETL no cambia config |

---

## 4. PLAN DE ACCION

### Fase 1: Reescribir BR Core (Inmediato)

| Tarea | Entregable |
|-------|------------|
| Reescribir BR_006 | BR_006_Modelo_RBAC_Funcional_Granular.rst |
| Reescribir BR_007 | BR_007_SoD_Funciones.rst |
| Crear BR_019 | BR_019_Bundles_Funciones.rst |

### Fase 2: Ajustar BR Dependientes

| Tarea | Entregable |
|-------|------------|
| Ajustar BR_008 | Terminologia funcion en lugar de rol |
| Ajustar BR_011 | Limites por funcion/bundle |

### Fase 3: Actualizar Artefactos Relacionados

| Artefacto | Cambio |
|-----------|--------|
| MTM_03 | Actualizar metamodelo RBAC |
| GLOS_001 | Agregar terminologia funcional |
| index.rst | Actualizar referencias |

---

## 5. DECISION REQUERIDA

Antes de proceder con la correccion, confirmar:

1. Adoptar enfoque funcional granular del documento v4.0?
2. Usar los 27 funciones propuestas o ajustar catalogo?
3. Implementar bundles para simplificar asignaciones?
4. Mantener estructura sin namespace (IACT es dominio unico)?

---

## 6. COMPARACION VISUAL

### Enfoque Actual (a descartar)

```
Usuario: Juan
Roles: [REPORTS_EXPORTER, DASHBOARD_VIEWER]

Pregunta: Puede Juan exportar a PDF?
Respuesta: No se sabe sin revisar que permisos tiene REPORTS_EXPORTER
```

### Enfoque Propuesto (a adoptar)

```
Usuario: Juan
Funciones: [ve_reportes, filtra_reportes, exporta_csv, exporta_excel, ve_dashboard]

Pregunta: Puede Juan exportar a PDF?
Respuesta: NO - no tiene funcion exporta_pdf
           (Claro, explicito, auditable)
```

---

*Documento generado: 2026-01-03*
*Requiere decision para proceder con correccion de BR*
