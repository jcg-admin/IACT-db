# ANALISIS COMPARATIVO: Modelo RBAC v4.0 vs BR IACT

**Fecha:** 2026-01-03  
**Proposito:** Analisis de consistencia entre documento "Modelo RBAC Sin Pretensiones v4.0" y las Business Rules RBAC creadas para IACT  
**Documentos Analizados:**
- Modelo_RBAC_Sin_Pretensiones_v4_0.txt (Octubre 2025)
- BR_005_Sesion_Unica.rst
- BR_006_RBAC_Flat_NIST.rst
- BR_007_Separacion_Funciones_SoD.rst
- BR_008_Permisos_Vencimiento.rst
- BR_009_Bajas_Logicas.rst
- BR_012_Usuario_Segmento_Unico.rst
- BR_013_Username_Unico.rst
- BR_015_Bloqueo_Intentos_Fallidos.rst

---

## 1. RESUMEN EJECUTIVO

### 1.1 Hallazgos Principales

| Aspecto | Documento v4.0 | BR IACT | Estado |
|---------|---------------|---------|--------|
| Modelo Base | RBAC Granular con Namespace | RBAC Flat NIST Level 0 | DIVERGENCIA |
| Terminologia | Personas, Funciones, Capacidades | Usuarios, Roles, Permisos | DIFERENTE |
| Herencia | Sin herencia (explicita) | Sin herencia (explicita) | CONSISTENTE |
| SoD | Estatico (SSD) con cardinalidad | Estatico simple | PARCIAL |
| Granularidad | 75+ funciones atomicas | 18 roles cerrados | DIFERENTE |
| Bundles | Si (10 predefinidos) | No implementado | GAP |
| Namespace | Si (identity, epm, base) | No (catalogo plano) | GAP |

### 1.2 Conclusion General

El documento "Modelo RBAC Sin Pretensiones v4.0" presenta un modelo **mas avanzado y granular** que el implementado en las BR de IACT. Hay conceptos valiosos que podrian incorporarse, pero tambien hay razones validas para mantener el modelo simplificado de IACT.

---

## 2. ANALISIS DETALLADO POR CONCEPTO

### 2.1 Arquitectura del Modelo

#### Documento v4.0: RBAC Granular con Namespace

```
Persona (usuario del sistema)
   |
   | tiene asignadas (UA)
   v
Funcion (granular, con namespace)
   |
   | contiene (PA)
   v
Capacidad (permiso atomico)
   |
   | sobre
   v
Recurso:Operacion
```

**Caracteristicas:**
- Funciones son atomicas y componibles
- Namespace para evitar colisiones (identity:, epm:, base)
- Nomenclatura verbo_sustantivo (crea_facturas, aprueba_facturas)
- 75+ funciones predefinidas
- Capacidades con formato recurso:operacion

#### BR IACT (BR_006): RBAC Flat NIST

```
Usuario
   |
   | N:N
   v
Rol (catalogo cerrado)
   |
   | 1:N
   v
Permiso
```

**Caracteristicas:**
- 18 roles predefinidos (catalogo cerrado)
- Sin namespace (estructura plana)
- Nomenclatura SCREAMING_SNAKE (USERS_FULL_MANAGER)
- Permisos agrupados por rol, no atomicos

#### Evaluacion

| Criterio | v4.0 | IACT | Mejor Para |
|----------|------|------|------------|
| Escalabilidad | Alta | Media | v4.0 (organizaciones grandes) |
| Simplicidad | Baja | Alta | IACT (50-100 usuarios) |
| Flexibilidad | Alta | Baja | v4.0 (multiples productos) |
| Mantenibilidad | Media | Alta | IACT (equipo pequeno) |
| Auditoria | Precisa | Suficiente | v4.0 (compliance estricto) |

**Recomendacion:** Para IACT con 50-100 usuarios, el modelo Flat es **adecuado**. El v4.0 seria sobreingenieria para el contexto actual.

---

### 2.2 Nomenclatura y Terminologia

#### Documento v4.0

```
Entidades:
- personas (no usuarios)
- funciones (no roles)
- capacidades (no permisos)

Patron de nombres:
- [namespace:]verbo_sustantivo[_calificador]
- Ejemplos: crea_facturas, identity:gestiona_aplicaciones

Verbos estandar:
- crea, ve, modifica, elimina
- aprueba, rechaza
- gestiona, configura, ejecuta
- agrega, remueve
- importa, exporta
```

#### BR IACT

```
Entidades:
- users / usuarios
- roles
- permissions / permisos

Patron de nombres:
- CATEGORY_ACTION (SCREAMING_SNAKE_CASE)
- Ejemplos: USERS_FULL_MANAGER, REPORTS_VIEWER
```

#### Tabla de Mapeo Terminologico

| v4.0 | IACT | Equivalencia |
|------|------|--------------|
| persona | user | 1:1 |
| funcion | rol | 1:1 |
| capacidad | permiso | 1:1 |
| asignacion_persona_funcion | user_roles | 1:1 |
| asignacion_capacidad_funcion | role_permissions | 1:1 |
| restriccion_ssd | role_conflicts | 1:1 |
| bundle | (no existe) | GAP |
| namespace | (no existe) | GAP |

**Impacto:** La terminologia diferente no afecta la funcionalidad pero dificulta la trazabilidad entre documentos.

---

### 2.3 Separation of Duties (SoD)

#### Documento v4.0: SSD con Cardinalidad

```sql
CREATE TABLE restricciones_ssd (
    funciones_exclusivas UUID[] NOT NULL,
    cardinalidad INTEGER DEFAULT 1,  -- Max funciones del conjunto
);

-- Ejemplo: cardinalidad = 1 significa max 1 funcion del conjunto
INSERT INTO restricciones_ssd (nombre, funciones_exclusivas, cardinalidad) VALUES
('ssd_crea_aprueba_facturas', ARRAY[func_crea, func_aprueba], 1);
```

**Caracteristicas:**
- 10 restricciones SSD predefinidas
- Cardinalidad configurable (no solo pares)
- Funcion SQL de validacion
- Agrupadas por dominio (base, identity, epm)

**Restricciones v4.0:**
1. ssd_crea_aprueba_facturas
2. ssd_aprueba_procesa_pagos
3. ssd_codigo_deploy_prod
4. ssd_crea_publica_contenido
5. ssd_identity_configura_ve_auditoria
6. ssd_identity_crea_elimina_usuarios
7. ssd_identity_dominio_completo_exclusivo
8. ssd_epm_crea_elimina_grupos
9. ssd_epm_agrega_remueve_miembros
10. ssd_epm_service_admin_exclusivo

#### BR IACT (BR_007): SoD Simple

```sql
CREATE TABLE role_conflicts (
    role_a_id INTEGER REFERENCES roles(id),
    role_b_id INTEGER REFERENCES roles(id),
    reason TEXT
);
```

**Caracteristicas:**
- 3 pares conflictivos definidos
- Solo cardinalidad 1 (pares)
- Sin funcion SQL dedicada (logica en aplicacion)

**Restricciones IACT:**
1. SYSTEM_ADMIN vs AUDIT_VIEWER
2. REPORTS_CREATOR vs REPORTS_EXPORTER
3. USERS_FULL_MANAGER vs SECURITY_ADMIN

#### Comparacion

| Aspecto | v4.0 | IACT | Evaluacion |
|---------|------|------|------------|
| Cantidad restricciones | 10 | 3 | v4.0 mas completo |
| Cardinalidad | Configurable | Solo 1 | v4.0 mas flexible |
| Validacion | Funcion SQL | Aplicacion | v4.0 mas robusto |
| Dominios | Segregados | Plano | v4.0 mas organizado |

**Recomendacion:** Incorporar a BR_007:
1. Funcion SQL `validar_ssd_antes_asignar()` del v4.0
2. Considerar mas restricciones SoD relevantes para IACT

---

### 2.4 Permisos Temporales

#### Documento v4.0

```sql
CREATE TABLE asignaciones_persona_funcion (
    valida_desde TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valida_hasta TIMESTAMP,  -- NULL = permanente
    via_bundle VARCHAR(100)  -- Si fue asignada via bundle
);
```

**Caracteristicas:**
- Toda asignacion puede ser temporal
- No hay limite maximo obligatorio
- Registro de origen (bundle o manual)

#### BR IACT (BR_008): Permisos Directos con Vencimiento

```sql
CREATE TABLE user_direct_permissions (
    expires_at TIMESTAMP NOT NULL,  -- Obligatorio
    CONSTRAINT max_6_months CHECK (expires_at <= granted_at + INTERVAL '6 months')
);
```

**Caracteristicas:**
- Solo permisos DIRECTOS tienen vencimiento obligatorio
- Maximo 6 meses
- Requiere justificacion

#### Evaluacion

| Aspecto | v4.0 | IACT | Mejor |
|---------|------|------|-------|
| Scope | Todas las asignaciones | Solo directos | IACT (mas especifico) |
| Obligatoriedad | Opcional | Obligatorio | IACT (mas seguro) |
| Limite maximo | Sin limite | 6 meses | IACT (mejor control) |
| Justificacion | Opcional (razon) | Obligatoria | IACT (mas auditoria) |

**Conclusion:** BR_008 es **mas restrictiva y apropiada** para permisos excepcionales.

---

### 2.5 Bundles (Grupos de Funciones)

#### Documento v4.0

```sql
CREATE TABLE bundles_funciones (
    nombre VARCHAR(100),
    display_name VARCHAR(255),
    descripcion TEXT,
    categoria VARCHAR(50)
);

CREATE TABLE bundle_contiene_funciones (
    bundle_id UUID REFERENCES bundles_funciones(id),
    funcion_id UUID REFERENCES funciones(id)
);

-- Funcion de asignacion
SELECT asignar_bundle(persona_id, bundle_id, razon);
```

**Bundles predefinidos:**
- bundle_ingresa_facturas
- bundle_aprueba_gastos
- bundle_procesa_tesoreria
- bundle_desarrollador
- bundle_identity_help_desk
- bundle_identity_security_admin
- bundle_epm_help_desk
- bundle_epm_admin_grupos
- bundle_epm_service_admin

#### BR IACT

**No implementado.** Los 18 roles funcionan como bundles fijos de permisos.

#### Evaluacion

El concepto de Bundles NO es necesario en IACT porque:
1. Los 18 roles YA SON bundles de permisos
2. El catalogo es cerrado (no se crean roles nuevos)
3. La escala (50-100 usuarios) no justifica complejidad adicional

**Recomendacion:** No incorporar bundles. Los roles actuales son suficientes.

---

### 2.6 Namespaces

#### Documento v4.0

```
Estructura: [namespace:]nombre_funcion

Namespaces definidos:
- (null) - Funciones base del sistema
- identity: - Funciones Oracle Identity
- epm: - Funciones EPM Automate

Ejemplos:
- crea_facturas (base)
- identity:gestiona_aplicaciones
- epm:agrega_miembros
```

**Ventajas:**
- Evita colisiones de nombres
- Agrupa funciones por dominio/producto
- Facilita filtrado y busqueda

#### BR IACT

**No implementado.** Catalogo plano de 18 roles.

#### Evaluacion

Namespaces NO son necesarios en IACT porque:
1. Solo hay un dominio (IACT Dashboard)
2. 18 roles no requieren agrupacion compleja
3. La nomenclatura con prefijo (USERS_, REPORTS_, etc.) ya agrupa logicamente

**Recomendacion:** No incorporar namespaces formales. Mantener agrupacion por prefijo.

---

### 2.7 Auditoria

#### Documento v4.0

```sql
CREATE TABLE log_auditoria (
    persona_id UUID,
    sesion_id UUID,
    accion_tipo VARCHAR(100),
    recurso_tipo VARCHAR(100),
    recurso_id VARCHAR(255),
    detalles JSONB,
    exitosa BOOLEAN,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP
);
```

#### BR IACT (BR_010)

```sql
CREATE TABLE audit_log (
    user_id INTEGER,
    session_id UUID,
    action VARCHAR(100),
    resource_type VARCHAR(50),
    resource_id VARCHAR(100),
    details JSONB,
    response_status INTEGER,
    ip_address INET,
    user_agent TEXT,
    checksum VARCHAR(64),  -- Integridad
    timestamp TIMESTAMP
);
```

#### Comparacion

| Campo | v4.0 | IACT | Evaluacion |
|-------|------|------|------------|
| checksum | No | Si | IACT mejor (integridad) |
| response_status | No | Si | IACT mejor (resultado HTTP) |
| request_body_hash | No | Si | IACT mejor (forense) |
| Inmutabilidad | Implica | Explicita (trigger) | IACT mejor |

**Conclusion:** BR_010 tiene implementacion **superior** para auditoria inmutable.

---

### 2.8 Gestion de Sesiones

#### Documento v4.0

Menciona `sesion_id` en auditoria pero no define modelo de sesiones.

#### BR IACT (BR_005)

```sql
CREATE TABLE sessions (
    id UUID PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token_hash VARCHAR(255),
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP,
    last_activity_at TIMESTAMP,
    expires_at TIMESTAMP,
    is_active BOOLEAN,
    invalidated_by VARCHAR(50)
);

-- Constraint: Solo una sesion activa por usuario
CREATE UNIQUE INDEX idx_one_active_session ON sessions (user_id) WHERE is_active = TRUE;
```

**Conclusion:** BR_005 cubre gestion de sesiones que v4.0 no detalla.

---

### 2.9 Operaciones Masivas

#### Documento v4.0

```sql
CREATE TABLE operaciones_masivas (
    tipo_operacion VARCHAR(100),
    nombre_archivo VARCHAR(255),
    contexto JSONB,
    estado VARCHAR(50),
    total_registros INTEGER,
    registros_exitosos INTEGER,
    registros_fallidos INTEGER
);

CREATE TABLE operaciones_masivas_detalle (
    numero_linea INTEGER,
    datos JSONB,
    exitoso BOOLEAN,
    error_mensaje TEXT
);
```

#### BR IACT

**No implementado explicitamente.** No hay BR para operaciones masivas.

#### Evaluacion

Para IACT con 50-100 usuarios, operaciones masivas son:
- Poco frecuentes
- Manejables manualmente
- No criticas para MVP

**Recomendacion:** No priorizar. Documentar como posible NFR futuro.

---

## 3. GAPS Y OPORTUNIDADES

### 3.1 Gaps en BR IACT respecto a v4.0

| Gap | Impacto | Prioridad | Accion Sugerida |
|-----|---------|-----------|-----------------|
| Funcion SQL validar_ssd | Medio | Media | Incorporar en BR_007 |
| Catalogo de verbos estandar | Bajo | Baja | Documentar en STD |
| Operaciones masivas | Bajo | Baja | NFR futuro |
| Trazabilidad via_bundle | N/A | N/A | No aplica |

### 3.2 Fortalezas de BR IACT sobre v4.0

| Fortaleza | BR | Descripcion |
|-----------|-----|-------------|
| Checksum auditoria | BR_010 | Integridad verificable |
| Permisos con vencimiento obligatorio | BR_008 | Mayor control |
| Sesion unica explicita | BR_005 | Seguridad mejorada |
| Bloqueo por intentos | BR_015 | Proteccion fuerza bruta |
| Segmento de datos | BR_012 | Segregacion por centro |

---

## 4. INCONSISTENCIAS DETECTADAS

### 4.1 Terminologia

| Concepto | v4.0 | BR IACT | Riesgo |
|----------|------|---------|--------|
| Usuario | persona | user | Confusion documental |
| Rol | funcion | role | Confusion documental |
| Permiso | capacidad | permission | Confusion documental |

**Recomendacion:** Crear tabla de mapeo en GLOS_001.

### 4.2 Cantidad de Roles/Funciones

- v4.0: 75+ funciones granulares
- BR_006: 18 roles fijos

Esto NO es inconsistencia sino decision arquitectonica diferente (granular vs agrupado).

### 4.3 Restricciones SoD

| v4.0 | IACT Equivalente | Match |
|------|------------------|-------|
| ssd_crea_aprueba_facturas | (no aplica - IACT no tiene facturas) | N/A |
| ssd_codigo_deploy_prod | (no aplica - IACT no tiene deploy) | N/A |
| ssd_identity_configura_ve_auditoria | SYSTEM_ADMIN vs AUDIT_VIEWER | SI |
| ssd_identity_crea_elimina_usuarios | (no definido) | GAP |

**Recomendacion:** Evaluar agregar SoD para crear/eliminar usuarios.

---

## 5. RECOMENDACIONES

### 5.1 Cambios Sugeridos a BR Existentes

#### BR_007 - Separacion de Funciones SoD

Agregar:
1. Funcion SQL `validar_ssd_antes_asignar()` del v4.0
2. Nuevo par conflictivo: USERS_FULL_MANAGER vs USERS_TEAM_MANAGER (crear vs dar de baja)

#### BR_006 - RBAC Flat NIST

Agregar seccion de comparacion con modelo granular explicando:
- Por que Flat es suficiente para IACT
- Cuando considerar migracion a granular

### 5.2 Nuevos Artefactos Sugeridos

| Artefacto | Contenido | Prioridad |
|-----------|-----------|-----------|
| GLOS_001 (actualizar) | Mapeo terminologico v4.0 vs IACT | Media |
| ADR_006 | Decision RBAC Flat vs Granular con referencia a v4.0 | Baja |

### 5.3 NO Incorporar

Los siguientes elementos de v4.0 NO deben incorporarse:

1. **Namespaces** - Innecesario para un solo dominio
2. **Bundles** - Los 18 roles ya funcionan como bundles
3. **75+ funciones granulares** - Sobreingenieria para 50-100 usuarios
4. **Operaciones masivas** - Fuera de scope MVP

---

## 6. MATRIZ DE TRAZABILIDAD

### 6.1 Conceptos v4.0 -> BR IACT

| Concepto v4.0 | BR IACT | Estado |
|---------------|---------|--------|
| personas | (implicito en todas) | OK |
| funciones | BR_006 (roles) | MAPEADO |
| capacidades | BR_006 (permisos) | MAPEADO |
| asignaciones_persona_funcion | BR_006 (user_roles) | MAPEADO |
| restricciones_ssd | BR_007 (role_conflicts) | MAPEADO |
| log_auditoria | BR_010 (audit_log) | MAPEADO |
| bundles_funciones | N/A | NO APLICA |
| operaciones_masivas | N/A | NO APLICA |

### 6.2 BR IACT sin equivalente en v4.0

| BR IACT | Descripcion | v4.0 |
|---------|-------------|------|
| BR_005 | Sesion Unica | No detallado |
| BR_008 | Permisos Vencimiento | Parcial (menos estricto) |
| BR_012 | Segmento Unico | No existe |
| BR_015 | Bloqueo Intentos | No existe |

---

## 7. CONCLUSION FINAL

### 7.1 Compatibilidad

Las BR IACT son **conceptualmente compatibles** con el Modelo RBAC v4.0, aunque usan terminologia diferente y un nivel de granularidad menor.

### 7.2 Suficiencia

Para el contexto de IACT (50-100 usuarios, un solo producto, equipo pequeno), el modelo implementado en las BR es **suficiente y apropiado**.

### 7.3 Evolucion Futura

Si IACT crece significativamente (500+ usuarios, multiples productos), considerar:
1. Migracion a modelo granular
2. Implementacion de namespaces
3. Bundles para simplificar asignaciones

### 7.4 Accion Inmediata

1. Actualizar GLOS_001 con mapeo terminologico
2. Incorporar funcion SQL de validacion SoD a BR_007
3. Documentar decision en ADR_006

---

## ANEXO A: Tabla de Roles IACT vs Funciones v4.0

| Rol IACT | Funciones v4.0 Equivalentes |
|----------|----------------------------|
| R001 USERS_FULL_MANAGER | gestiona_usuarios + asigna_funciones |
| R002 USERS_VIEWER | ve_usuarios (solo lectura) |
| R004 REPORTS_VIEWER | ve_reportes_financieros |
| R005 REPORTS_EXPORTER | ve_reportes + exporta_datos |
| R010 DATA_ANALYST | ve_reportes + ve_metricas + exporta_datos |
| R016 SYSTEM_ADMIN | configura_sistema + gestiona_usuarios + asigna_funciones |
| R017 AUDIT_VIEWER | ve_auditoria |
| R018 SECURITY_ADMIN | configura_politicas_seguridad + ve_auditoria |

---

## ANEXO B: SQL de Validacion SoD (para BR_007)

```sql
-- Funcion recomendada a incorporar en BR_007
CREATE OR REPLACE FUNCTION validar_sod_antes_asignar(
    p_user_id INTEGER,
    p_role_id INTEGER
)
RETURNS TABLE (
    valido BOOLEAN,
    conflicto_con INTEGER,
    razon TEXT
) AS $$
BEGIN
    -- Verificar si hay conflicto con roles existentes
    RETURN QUERY
    SELECT 
        false,
        rc.role_b_id,
        rc.reason
    FROM role_conflicts rc
    JOIN user_roles ur ON (
        (rc.role_a_id = p_role_id AND rc.role_b_id = ur.role_id)
        OR
        (rc.role_b_id = p_role_id AND rc.role_a_id = ur.role_id)
    )
    WHERE ur.user_id = p_user_id
      AND ur.is_active = true;
    
    -- Si no hay filas, retornar valido
    IF NOT FOUND THEN
        RETURN QUERY SELECT true, NULL::INTEGER, NULL::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

---

*Analisis generado: 2026-01-03*
*Documentos comparados: Modelo RBAC v4.0, BR_005-BR_015 IACT*
*Conclusion: BR IACT son adecuadas para contexto actual, con mejoras menores sugeridas*
