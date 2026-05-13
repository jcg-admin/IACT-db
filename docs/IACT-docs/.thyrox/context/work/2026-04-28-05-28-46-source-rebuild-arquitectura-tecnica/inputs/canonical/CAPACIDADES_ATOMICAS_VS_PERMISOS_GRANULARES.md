# Capacidades Atómicas vs Permisos Granulares Dentro del Rol

## Guía Comparativa de Modelos RBAC

**Fecha:** 2026-01-03  
**Propósito:** Explicar la diferencia conceptual y práctica entre dos enfoques de control de acceso

---

## 1. INTRODUCCIÓN

Existen dos enfoques principales para implementar RBAC (Role-Based Access Control):

| Enfoque | Modelo | Ejemplo |
|---------|--------|---------|
| **Capacidades Atómicas** | RBAC Granular Puro | Modelo "Sin Pretensiones" |
| **Permisos Granulares Dentro del Rol** | RBAC Híbrido | Modelo IACT v4.0 |

Ambos son válidos, pero tienen diferencias fundamentales en arquitectura, mantenimiento y escalabilidad.

---

## 2. ENFOQUE 1: CAPACIDADES ATÓMICAS (Granular Puro)

### 2.1 Definición

En este modelo, la **unidad mínima asignable** es una **función atómica** que representa UNA sola acción sobre UN solo recurso.

```
FUNCIÓN ATÓMICA = 1 verbo + 1 sustantivo
```

### 2.2 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                     USUARIO                         │
│  (Juan Pérez)                                       │
└─────────────────────────────────────────────────────┘
                        │
                        │ tiene asignadas DIRECTAMENTE
                        │ (muchas funciones individuales)
                        ▼
┌─────────────────────────────────────────────────────┐
│              FUNCIONES ATÓMICAS                     │
│                                                     │
│  ┌──────────────┐ ┌──────────────┐ ┌─────────────┐ │
│  │ crea_usuarios│ │ ve_usuarios  │ │modifica_user│ │
│  └──────────────┘ └──────────────┘ └─────────────┘ │
│  ┌──────────────┐ ┌──────────────┐ ┌─────────────┐ │
│  │ ve_reportes  │ │ exporta_csv  │ │exporta_excel│ │
│  └──────────────┘ └──────────────┘ └─────────────┘ │
│  ┌──────────────┐ ┌──────────────┐                 │
│  │config_alertas│ │ ve_auditoria │                 │
│  └──────────────┘ └──────────────┘                 │
└─────────────────────────────────────────────────────┘
                        │
                        │ cada función contiene
                        ▼
┌─────────────────────────────────────────────────────┐
│                 CAPACIDAD ÚNICA                     │
│  (1 función = 1 capacidad exacta)                   │
│                                                     │
│  crea_usuarios → usuarios:crear                     │
│  ve_usuarios   → usuarios:leer                      │
│  exporta_csv   → reportes:exportar_csv              │
└─────────────────────────────────────────────────────┘
```

### 2.3 Ejemplo Práctico

**Catálogo de Funciones Atómicas (75+ funciones):**

```
DOMINIO: Usuarios
├── crea_usuarios        → usuarios:crear
├── ve_usuarios          → usuarios:leer
├── modifica_usuarios    → usuarios:modificar
├── elimina_usuarios     → usuarios:eliminar
├── activa_usuarios      → usuarios:activar
├── desbloquea_usuarios  → usuarios:desbloquear
└── resetea_passwords    → usuarios:reset_password

DOMINIO: Reportes
├── ve_reportes          → reportes:leer
├── filtra_reportes      → reportes:filtrar
├── exporta_csv          → reportes:exportar_csv
├── exporta_excel        → reportes:exportar_excel
├── exporta_pdf          → reportes:exportar_pdf
└── crea_reportes        → reportes:crear

DOMINIO: Alertas
├── ve_alertas           → alertas:leer
├── configura_alertas    → alertas:configurar
├── pausa_alertas        → alertas:pausar
└── elimina_alertas      → alertas:eliminar

... (75+ funciones en total)
```

### 2.4 Asignación a Usuario

```sql
-- Juan necesita gestionar usuarios y ver reportes
-- Se le asignan 8 funciones INDIVIDUALMENTE

INSERT INTO asignaciones_persona_funcion (persona_id, funcion_id) VALUES
(juan_id, 'crea_usuarios'),
(juan_id, 've_usuarios'),
(juan_id, 'modifica_usuarios'),
(juan_id, 'elimina_usuarios'),
(juan_id, 'resetea_passwords'),
(juan_id, 've_reportes'),
(juan_id, 'filtra_reportes'),
(juan_id, 'exporta_csv');
```

### 2.5 Consulta de Permisos

```
Pregunta: ¿Puede Juan exportar a PDF?

Respuesta: 
1. Buscar en asignaciones de Juan
2. ¿Tiene función "exporta_pdf"? → NO
3. Resultado: NO PUEDE

(Respuesta directa, sin ambigüedad)
```

### 2.6 Uso de Bundles (Agrupador Opcional)

Para simplificar la asignación de muchas funciones, se usan **bundles**:

```sql
-- Bundle = Agrupador de funciones para asignación masiva
-- NO ES UN ROL, es solo un atajo para asignar

CREATE TABLE bundles (
    bundle_id VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
);

CREATE TABLE bundle_funciones (
    bundle_id VARCHAR(50),
    funcion_id VARCHAR(50)
);

-- Bundle para "Gestión de Usuarios"
INSERT INTO bundle_funciones VALUES
('bundle_gestion_usuarios', 'crea_usuarios'),
('bundle_gestion_usuarios', 've_usuarios'),
('bundle_gestion_usuarios', 'modifica_usuarios'),
('bundle_gestion_usuarios', 'elimina_usuarios'),
('bundle_gestion_usuarios', 'resetea_passwords');

-- Asignar bundle a Juan (internamente asigna 5 funciones)
CALL asignar_bundle(juan_id, 'bundle_gestion_usuarios');
```

**Importante:** El bundle es solo un **mecanismo de asignación**. En la base de datos, Juan tiene 5 funciones individuales, NO un "rol".

### 2.7 Ventajas del Enfoque Atómico

| Ventaja | Descripción |
|---------|-------------|
| **Máxima granularidad** | Control preciso de cada acción |
| **Auditoría exacta** | Sabes exactamente qué puede hacer cada usuario |
| **Sin ambigüedad** | "¿Puede X?" → Buscar función → Sí/No |
| **Principio de menor privilegio** | Asignas solo lo necesario |
| **Escalable** | Agregar nueva función no afecta existentes |

### 2.8 Desventajas del Enfoque Atómico

| Desventaja | Descripción |
|------------|-------------|
| **Complejidad de gestión** | 75+ funciones que administrar |
| **Asignaciones masivas** | Usuario típico puede tener 20+ funciones |
| **Requiere bundles** | Sin bundles, asignar es tedioso |
| **Overhead de BD** | Más registros en tabla de asignaciones |

---

## 3. ENFOQUE 2: PERMISOS GRANULARES DENTRO DEL ROL (Híbrido)

### 3.1 Definición

En este modelo, la **unidad asignable** es un **ROL** que agrupa múltiples **permisos granulares** internamente.

```
ROL = Agrupador de permisos relacionados
PERMISO = recurso.acción.scope (granular, pero dentro del rol)
```

### 3.2 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                     USUARIO                         │
│  (Juan Pérez)                                       │
└─────────────────────────────────────────────────────┘
                        │
                        │ tiene asignados ROLES
                        │ (pocos roles)
                        ▼
┌─────────────────────────────────────────────────────┐
│                      ROLES                          │
│                                                     │
│  ┌────────────────────┐  ┌────────────────────┐    │
│  │ USERS_FULL_MANAGER │  │   REPORTS_VIEWER   │    │
│  │      (R001)        │  │      (R004)        │    │
│  └────────────────────┘  └────────────────────┘    │
└─────────────────────────────────────────────────────┘
                        │
                        │ cada rol CONTIENE permisos
                        ▼
┌─────────────────────────────────────────────────────┐
│           PERMISOS GRANULARES (por rol)             │
│                                                     │
│  R001 contiene:              R004 contiene:         │
│  ├── users.create            ├── reports.view.basic│
│  ├── users.read              ├── reports.view.qtrly│
│  ├── users.update            ├── reports.filter.date│
│  ├── users.delete            ├── reports.filter.ctr│
│  ├── users.password.reset    ├── charts.view.basic │
│  ├── roles.assign            └── tables.view.basic │
│  ├── roles.revoke                                   │
│  └── permissions.manage                             │
└─────────────────────────────────────────────────────┘
```

### 3.3 Ejemplo Práctico

**Catálogo de Roles (18 roles):**

```
R001 - USERS_FULL_MANAGER
├── users.create
├── users.read
├── users.update
├── users.delete
├── users.list
├── users.search
├── users.password.reset
├── users.block
├── users.unblock
├── roles.assign
├── roles.revoke
├── permissions.manage
└── segments.manage
    (13 permisos en este rol)

R004 - REPORTS_VIEWER
├── reports.view.basic
├── reports.view.quarterly
├── reports.view.transfers
├── reports.filter.date
├── reports.filter.center
├── charts.view.basic
└── tables.view.basic
    (7 permisos en este rol)

R005 - REPORTS_EXPORTER
├── [hereda conceptualmente de R004]
├── reports.export.csv
├── reports.export.excel
├── reports.export.pdf
└── files.download
    (4 permisos adicionales)

... (18 roles en total)
```

### 3.4 Asignación a Usuario

```sql
-- Juan necesita gestionar usuarios y ver reportes
-- Se le asignan 2 ROLES

INSERT INTO user_roles (user_id, role_id) VALUES
(juan_id, 'R001'),  -- USERS_FULL_MANAGER
(juan_id, 'R004');  -- REPORTS_VIEWER

-- Juan ahora tiene 13 + 7 = 20 permisos
-- Pero solo 2 registros en user_roles
```

### 3.5 Consulta de Permisos

```
Pregunta: ¿Puede Juan exportar a PDF?

Respuesta: 
1. Obtener roles de Juan → R001, R004
2. Obtener permisos de R001 → No tiene reports.export.pdf
3. Obtener permisos de R004 → No tiene reports.export.pdf
4. Resultado: NO PUEDE

(Requiere JOIN entre tablas, pero respuesta clara)
```

### 3.6 Verificación en Código

```sql
-- Función para verificar permiso
CREATE FUNCTION user_has_permission(p_user_id INT, p_permission VARCHAR(100))
RETURNS BOOLEAN
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        WHERE ur.user_id = p_user_id
          AND ur.is_active = TRUE
          AND rp.permission = p_permission
    );
END;

-- Uso
SELECT user_has_permission(juan_id, 'reports.export.pdf');
-- Resultado: FALSE
```

### 3.7 Ventajas del Enfoque Híbrido

| Ventaja | Descripción |
|---------|-------------|
| **Simplicidad de gestión** | Solo 18 roles que administrar |
| **Asignaciones simples** | Usuario típico tiene 2-4 roles |
| **Menos overhead BD** | Menos registros en asignaciones |
| **Fácil de entender** | "Juan es REPORTS_VIEWER" |
| **Permisos aún granulares** | Internamente detallados |

### 3.8 Desventajas del Enfoque Híbrido

| Desventaja | Descripción |
|------------|-------------|
| **Menos flexible** | Si necesitas solo 3 de 13 permisos, debes crear nuevo rol |
| **Posible over-permissioning** | Rol puede tener permisos no necesarios |
| **Dependencia del catálogo** | Cambiar rol afecta a todos los usuarios |
| **Consulta indirecta** | Requiere JOIN para saber permisos efectivos |

---

## 4. COMPARACIÓN DIRECTA

### 4.1 Tabla Comparativa

| Aspecto | Atómico (Sin Pretensiones) | Híbrido (IACT v4.0) |
|---------|---------------------------|---------------------|
| **Unidad asignable** | Función atómica | Rol |
| **Cantidad de unidades** | 75+ funciones | 18 roles |
| **Permisos por unidad** | 1 (exacto) | 5-20 (agrupados) |
| **Granularidad** | Máxima | Alta (dentro del rol) |
| **Flexibilidad** | Máxima | Media |
| **Complejidad gestión** | Alta | Media |
| **Registros en BD** | Muchos | Pocos |
| **Consulta permisos** | Directa | Requiere JOIN |
| **Auditoría** | Muy precisa | Precisa |
| **Bundles** | Necesarios | No necesarios |

### 4.2 Ejemplo: Mismo Usuario, Ambos Modelos

**Usuario:** María López  
**Necesita:** Crear usuarios, ver reportes, exportar CSV

#### Modelo Atómico:
```sql
-- 5 funciones asignadas individualmente
INSERT INTO asignaciones VALUES
(maria_id, 'crea_usuarios'),
(maria_id, 've_usuarios'),
(maria_id, 've_reportes'),
(maria_id, 'filtra_reportes'),
(maria_id, 'exporta_csv');

-- Registros en BD: 5
-- Permisos efectivos: 5
```

#### Modelo Híbrido:
```sql
-- 3 roles asignados
INSERT INTO user_roles VALUES
(maria_id, 'R001'),  -- USERS_FULL_MANAGER (13 permisos)
(maria_id, 'R004'),  -- REPORTS_VIEWER (7 permisos)
(maria_id, 'R005');  -- REPORTS_EXPORTER (4 permisos)

-- Registros en BD: 3
-- Permisos efectivos: 24 (incluyendo algunos no solicitados)
```

### 4.3 Diagrama Visual

```
MODELO ATÓMICO:
═══════════════

Usuario ──┬── crea_usuarios    → usuarios:crear
          ├── ve_usuarios      → usuarios:leer
          ├── ve_reportes      → reportes:leer
          ├── filtra_reportes  → reportes:filtrar
          └── exporta_csv      → reportes:exportar_csv

(5 asignaciones directas = 5 capacidades exactas)


MODELO HÍBRIDO:
═══════════════

Usuario ──┬── R001 (USERS_FULL_MANAGER) ──┬── users.create
          │                               ├── users.read
          │                               ├── users.update
          │                               ├── users.delete
          │                               ├── ... (9 más)
          │
          ├── R004 (REPORTS_VIEWER) ──────┬── reports.view.basic
          │                               ├── reports.filter.date
          │                               ├── ... (5 más)
          │
          └── R005 (REPORTS_EXPORTER) ────┬── reports.export.csv
                                          ├── reports.export.excel
                                          └── reports.export.pdf

(3 asignaciones = 24 permisos, algunos no solicitados)
```

---

## 5. ¿CUÁNDO USAR CADA MODELO?

### 5.1 Usar Modelo Atómico cuando:

- ✅ Organización grande (500+ usuarios)
- ✅ Múltiples productos/dominios
- ✅ Requisitos estrictos de compliance (SOX, ISO 27001)
- ✅ Necesidad de auditoría extremadamente precisa
- ✅ Usuarios con combinaciones únicas de permisos
- ✅ Equipo técnico capaz de gestionar complejidad

### 5.2 Usar Modelo Híbrido cuando:

- ✅ Organización mediana (50-500 usuarios)
- ✅ Un solo producto/dominio
- ✅ Usuarios con perfiles similares (operadores, supervisores, etc.)
- ✅ Equipo de TI pequeño
- ✅ Tiempo de implementación limitado
- ✅ Permisos relativamente estables

### 5.3 Caso IACT

IACT eligió el **Modelo Híbrido** porque:

1. **260-503 usuarios estimados** → No justifica 75+ funciones
2. **Un solo dominio** (IVR Analytics) → Sin colisiones de nombres
3. **Perfiles claros** → Operadores, Supervisores, Analistas, Admins
4. **Equipo pequeño** → Gestionar 18 roles es manejable
5. **Permisos granulares internos** → Auditoría suficientemente precisa

---

## 6. CONCLUSIÓN

### 6.1 Resumen

| Modelo | Filosofía | Mejor para |
|--------|-----------|------------|
| **Atómico** | "Cada acción es independiente" | Máximo control, alta complejidad |
| **Híbrido** | "Roles agrupan acciones relacionadas" | Balance control/simplicidad |

### 6.2 No son Mutuamente Excluyentes

Es posible combinar ambos enfoques:

```
Usuario
  ├── Rol R004 (REPORTS_VIEWER)     → 7 permisos del rol
  └── Permiso Directo (temporal)     → 1 permiso atómico adicional
      └── reports.export.pdf (expira en 30 días)
```

El modelo IACT v4.0 implementa esto con la tabla `direct_permissions` para casos excepcionales.

### 6.3 Recomendación Final

Para IACT, el **Modelo Híbrido es correcto** porque:

- Los 18 roles cubren el 95% de los casos de uso
- Los permisos directos cubren el 5% de excepciones
- La auditoría sigue siendo granular (se registra cada permiso usado)
- La gestión es manejable para el equipo

---

## ANEXO: Glosario

| Término | Definición |
|---------|------------|
| **Capacidad Atómica** | Permiso único e indivisible (1 acción, 1 recurso) |
| **Función Atómica** | Unidad asignable en modelo granular puro |
| **Rol** | Agrupador de permisos en modelo híbrido |
| **Permiso Granular** | Permiso detallado dentro de un rol |
| **Bundle** | Agrupador de funciones para asignación masiva (no es rol) |
| **Flat RBAC** | RBAC sin herencia automática entre roles |
| **SoD** | Separation of Duties - Roles mutuamente excluyentes |

---

*Documento generado: 2026-01-03*
