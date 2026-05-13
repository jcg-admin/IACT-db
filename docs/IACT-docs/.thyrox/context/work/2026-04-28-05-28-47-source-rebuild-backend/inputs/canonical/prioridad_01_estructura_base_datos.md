---
id: DOC-REQ-PRIORIDAD-01
tipo: especificacion_tecnica
titulo: Prioridad 1 - Estructura Base de Datos
version: 1.0.0
fecha_creacion: 2025-11-07
estado: por_implementar
propietario: equipo-backend
prioridad: critica
estandares: ["ISO/IEC/IEEE 29148:2018", "PostgreSQL 12+"]
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "RF-001", "RF-002", "RF-003", "RF-004"]
date: 2025-11-13
---

# PRIORIDAD 1: Estructura Base (Base de Datos)

**Fase:** Definición
**Estado:** Por Implementar
**Prioridad:** [CRÍTICA] - Sin esto, nada funciona

---

## Objetivo

Crear el fundamento de datos del sistema de permisos granular basado en **Grupos de Permisos** (sin roles jerárquicos).

## Por Qué Esta es la Prioridad #1

- **Es el fundamento de todo el sistema**
- **Sin estas tablas, nada más funciona**
- **Define la arquitectura completa**
- **Todas las demás prioridades dependen de esto**

---

## Esquema Completo de Base de Datos

### Diagrama de Relaciones

```

 FUNCIONES (Recursos: dashboards, usuarios, etc)

 1:N

 FUNCION_CAPACIDADES (Relación muchos a muchos)

 N:1

 CAPACIDADES (Acciones: ver, crear, editar, etc)

 N:M

 GRUPO_CAPACIDADES (Relación muchos a muchos)

 N:1

 GRUPOS_PERMISOS (Agrupaciones funcionales sin jerarquía)

 N:M

 USUARIOS_GRUPOS (Usuario puede tener múltiples grupos)

 N:1

 USUARIOS 

 PERMISOS_EXCEPCIONALES (Permisos temporales o permanentes)

 → USUARIOS + CAPACIDADES

 AUDITORIA_PERMISOS (Log de todos los accesos)

```

---

## Definición de Tablas

### Tabla 1: `funciones`
**Propósito:** Recursos del sistema (dashboards, usuarios, métricas, etc.)

```sql
CREATE TABLE funciones (
 -- Identificación
 id SERIAL PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL, -- 'dashboards', 'usuarios', 'metricas'
 nombre_completo VARCHAR(200) UNIQUE NOT NULL, -- 'sistema.vistas.dashboards'

 -- Clasificación
 dominio VARCHAR(100) NOT NULL, -- 'vistas', 'administracion', 'analisis'
 categoria VARCHAR(50), -- 'visualizacion', 'gestion', 'configuracion'

 -- Metadata
 descripcion TEXT,
 icono VARCHAR(50), -- Para UI (ej: 'dashboard-icon')
 orden_menu INTEGER DEFAULT 999, -- Para ordenar en menú

 -- Control
 activa BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT NOW(),
 updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX idx_funciones_dominio ON funciones(dominio);
CREATE INDEX idx_funciones_activa ON funciones(activa);
CREATE INDEX idx_funciones_categoria ON funciones(categoria);
CREATE INDEX idx_funciones_orden_menu ON funciones(orden_menu);

-- Comentarios
COMMENT ON TABLE funciones IS 'Recursos/módulos del sistema (dashboards, usuarios, tickets, etc)';
COMMENT ON COLUMN funciones.nombre IS 'Nombre corto del recurso sin prefijos';
COMMENT ON COLUMN funciones.nombre_completo IS 'Nombre completo con nomenclatura sistema.dominio.recurso';
COMMENT ON COLUMN funciones.dominio IS 'Agrupación lógica: vistas, administracion, operaciones, finanzas, etc';
```

---

### Tabla 2: `capacidades`
**Propósito:** Acciones específicas que se pueden realizar sobre recursos

```sql
CREATE TABLE capacidades (
 -- Identificación
 id SERIAL PRIMARY KEY,
 nombre_completo VARCHAR(200) UNIQUE NOT NULL, -- 'sistema.vistas.dashboards.ver'

 -- Clasificación
 accion VARCHAR(50) NOT NULL, -- 'ver', 'crear', 'editar', 'eliminar'
 recurso VARCHAR(100) NOT NULL, -- 'dashboards', 'usuarios'
 dominio VARCHAR(100) NOT NULL, -- 'vistas', 'administracion'

 -- Metadata
 descripcion TEXT,

 -- Seguridad
 nivel_sensibilidad VARCHAR(20) DEFAULT 'normal', -- 'bajo', 'normal', 'alto', 'critico'
 requiere_auditoria BOOLEAN DEFAULT FALSE,

 -- Control
 activa BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX idx_capacidades_accion ON capacidades(accion);
CREATE INDEX idx_capacidades_recurso ON capacidades(recurso);
CREATE INDEX idx_capacidades_dominio ON capacidades(dominio);
CREATE INDEX idx_capacidades_sensibilidad ON capacidades(nivel_sensibilidad);
CREATE INDEX idx_capacidades_activa ON capacidades(activa);

-- Índice compuesto para búsquedas comunes
CREATE INDEX idx_capacidades_recurso_accion ON capacidades(recurso, accion);

-- Comentarios
COMMENT ON TABLE capacidades IS 'Acciones específicas sobre recursos (ver, crear, editar, eliminar, etc)';
COMMENT ON COLUMN capacidades.nombre_completo IS 'Identificador único de la capacidad con nomenclatura completa';
COMMENT ON COLUMN capacidades.nivel_sensibilidad IS 'Nivel de criticidad: bajo (lectura), normal (escritura), alto (borrado), critico (admin)';
COMMENT ON COLUMN capacidades.requiere_auditoria IS 'Si TRUE, cada uso de esta capacidad se registra en auditoria_permisos';
```

---

### Tabla 3: `funcion_capacidades`
**Propósito:** Relación entre funciones y sus capacidades disponibles

```sql
CREATE TABLE funcion_capacidades (
 -- Identificación
 id SERIAL PRIMARY KEY,
 funcion_id INTEGER NOT NULL,
 capacidad_id INTEGER NOT NULL,

 -- Configuración
 requerida BOOLEAN DEFAULT FALSE, -- Si es obligatoria para usar la función
 visible_en_ui BOOLEAN DEFAULT TRUE, -- Si se muestra en la interfaz
 orden INTEGER DEFAULT 999, -- Orden de presentación

 -- Control
 created_at TIMESTAMP DEFAULT NOW(),

 -- Relaciones
 FOREIGN KEY (funcion_id) REFERENCES funciones(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES capacidades(id) ON DELETE CASCADE,

 -- Constraint único
 UNIQUE (funcion_id, capacidad_id)
);

-- Índices
CREATE INDEX idx_funcion_capacidades_funcion ON funcion_capacidades(funcion_id);
CREATE INDEX idx_funcion_capacidades_capacidad ON funcion_capacidades(capacidad_id);
CREATE INDEX idx_funcion_capacidades_requerida ON funcion_capacidades(requerida);

-- Comentarios
COMMENT ON TABLE funcion_capacidades IS 'Relaciona funciones con sus capacidades disponibles';
COMMENT ON COLUMN funcion_capacidades.requerida IS 'Si TRUE, esta capacidad es obligatoria para acceder a la función';
```

---

### Tabla 4: `grupos_permisos`
**Propósito:** Agrupaciones lógicas de capacidades SIN jerarquía

```sql
CREATE TABLE grupos_permisos (
 -- Identificación
 id SERIAL PRIMARY KEY,
 codigo VARCHAR(100) UNIQUE NOT NULL, -- 'atencion_cliente', 'gestion_equipos'
 nombre_display VARCHAR(200) NOT NULL, -- 'Atención al Cliente', 'Gestión de Equipos'

 -- Metadata
 descripcion TEXT,
 tipo_acceso VARCHAR(50), -- 'operativo', 'gestion', 'estrategico', 'tecnico'
 color_hex VARCHAR(7), -- '#3B82F6' para UI
 icono VARCHAR(50), -- Para UI

 -- Control
 activo BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT NOW(),
 updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_grupos_permisos_tipo ON grupos_permisos(tipo_acceso);
CREATE INDEX idx_grupos_permisos_activo ON grupos_permisos(activo);
CREATE INDEX idx_grupos_permisos_codigo ON grupos_permisos(codigo);

-- Comentarios
COMMENT ON TABLE grupos_permisos IS 'Grupos funcionales de permisos sin jerarquía (reemplazan roles tradicionales)';
COMMENT ON COLUMN grupos_permisos.codigo IS 'Identificador único en snake_case para código';
COMMENT ON COLUMN grupos_permisos.nombre_display IS 'Nombre amigable para mostrar en UI';
COMMENT ON COLUMN grupos_permisos.tipo_acceso IS 'Clasificación del tipo de grupo para organización';

-- IMPORTANTE: Esta tabla NO tiene campo "nivel" ni "jerarquía"
-- Los grupos son iguales entre sí, solo agrupan capacidades diferentes
```

---

### Tabla 5: `grupo_capacidades`
**Propósito:** Relación muchos-a-muchos entre grupos y capacidades

```sql
CREATE TABLE grupo_capacidades (
 -- Identificación
 id SERIAL PRIMARY KEY,
 grupo_id INTEGER NOT NULL,
 capacidad_id INTEGER NOT NULL,

 -- Control
 created_at TIMESTAMP DEFAULT NOW(),

 -- Relaciones
 FOREIGN KEY (grupo_id) REFERENCES grupos_permisos(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES capacidades(id) ON DELETE CASCADE,

 -- Constraint único
 UNIQUE (grupo_id, capacidad_id)
);

-- Índices
CREATE INDEX idx_grupo_capacidades_grupo ON grupo_capacidades(grupo_id);
CREATE INDEX idx_grupo_capacidades_capacidad ON grupo_capacidades(capacidad_id);

-- Comentarios
COMMENT ON TABLE grupo_capacidades IS 'Asocia capacidades específicas a grupos de permisos';
```

---

### Tabla 6: `usuarios_grupos`
**Propósito:** Asignación de grupos a usuarios (un usuario puede tener múltiples grupos)

```sql
CREATE TABLE usuarios_grupos (
 -- Identificación
 id SERIAL PRIMARY KEY,
 usuario_id INTEGER NOT NULL,
 grupo_id INTEGER NOT NULL,

 -- Metadata de asignación
 fecha_asignacion TIMESTAMP DEFAULT NOW(),
 fecha_expiracion TIMESTAMP, -- NULL = permanente, fecha = temporal
 asignado_por INTEGER, -- Usuario que hizo la asignación
 motivo TEXT, -- Razón de la asignación

 -- Control
 activo BOOLEAN DEFAULT TRUE,

 -- Relaciones
 FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
 FOREIGN KEY (grupo_id) REFERENCES grupos_permisos(id) ON DELETE CASCADE,
 FOREIGN KEY (asignado_por) REFERENCES usuarios(id) ON DELETE SET NULL,

 -- Constraint único
 UNIQUE (usuario_id, grupo_id)
);

-- Índices
CREATE INDEX idx_usuarios_grupos_usuario ON usuarios_grupos(usuario_id);
CREATE INDEX idx_usuarios_grupos_grupo ON usuarios_grupos(grupo_id);
CREATE INDEX idx_usuarios_grupos_activo ON usuarios_grupos(activo);
CREATE INDEX idx_usuarios_grupos_expiracion ON usuarios_grupos(fecha_expiracion);

-- Índice compuesto para consultas frecuentes
CREATE INDEX idx_usuarios_grupos_usuario_activo ON usuarios_grupos(usuario_id, activo);

-- Comentarios
COMMENT ON TABLE usuarios_grupos IS 'Asigna grupos de permisos a usuarios. Un usuario puede tener N grupos simultáneos';
COMMENT ON COLUMN usuarios_grupos.fecha_expiracion IS 'NULL = asignación permanente, FECHA = asignación temporal';
COMMENT ON COLUMN usuarios_grupos.activo IS 'Permite desactivar sin borrar el registro histórico';
```

---

### Tabla 7: `permisos_excepcionales`
**Propósito:** Permisos individuales que sobrescriben grupos (conceder o revocar)

```sql
CREATE TABLE permisos_excepcionales (
 -- Identificación
 id SERIAL PRIMARY KEY,
 usuario_id INTEGER NOT NULL,
 capacidad_id INTEGER NOT NULL,

 -- Configuración
 tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('conceder', 'revocar')),
 fecha_inicio TIMESTAMP DEFAULT NOW(),
 fecha_fin TIMESTAMP, -- NULL = permanente

 -- Metadata
 motivo TEXT NOT NULL,
 autorizado_por INTEGER,
 notas TEXT,

 -- Control
 activo BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT NOW(),

 -- Relaciones
 FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES capacidades(id) ON DELETE CASCADE,
 FOREIGN KEY (autorizado_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Índices
CREATE INDEX idx_permisos_excepcionales_usuario ON permisos_excepcionales(usuario_id);
CREATE INDEX idx_permisos_excepcionales_capacidad ON permisos_excepcionales(capacidad_id);
CREATE INDEX idx_permisos_excepcionales_tipo ON permisos_excepcionales(tipo);
CREATE INDEX idx_permisos_excepcionales_activo ON permisos_excepcionales(activo);
CREATE INDEX idx_permisos_excepcionales_fecha_fin ON permisos_excepcionales(fecha_fin);

-- Índice compuesto para verificación de permisos
CREATE INDEX idx_permisos_excepcionales_usuario_activo
 ON permisos_excepcionales(usuario_id, activo, fecha_fin);

-- Comentarios
COMMENT ON TABLE permisos_excepcionales IS 'Permisos individuales que sobrescriben los permisos de grupo';
COMMENT ON COLUMN permisos_excepcionales.tipo IS 'conceder: añade permiso adicional | revocar: quita permiso del grupo';
COMMENT ON COLUMN permisos_excepcionales.motivo IS 'Justificación obligatoria del permiso excepcional';
```

---

### Tabla 8: `auditoria_permisos`
**Propósito:** Registro completo de intentos de acceso (concedidos y denegados)

```sql
CREATE TABLE auditoria_permisos (
 -- Identificación
 id BIGSERIAL PRIMARY KEY,

 -- Usuario y acción
 usuario_id INTEGER NOT NULL,
 capacidad_solicitada VARCHAR(200) NOT NULL, -- La capacidad que intentó usar
 accion_realizada VARCHAR(100) NOT NULL, -- 'acceso_concedido' o 'acceso_denegado'

 -- Contexto
 recurso_accedido VARCHAR(200), -- Recurso específico accedido
 metodo_http VARCHAR(10), -- GET, POST, PUT, DELETE, etc
 endpoint VARCHAR(500), -- URL del endpoint

 -- Metadata técnica
 ip_address VARCHAR(50),
 user_agent TEXT,
 session_id VARCHAR(200),

 -- Datos adicionales
 metadata JSONB, -- Datos flexibles adicionales

 -- Timestamp
 timestamp TIMESTAMP DEFAULT NOW(),

 -- Relación
 FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índices para queries comunes
CREATE INDEX idx_auditoria_usuario ON auditoria_permisos(usuario_id);
CREATE INDEX idx_auditoria_timestamp ON auditoria_permisos(timestamp DESC);
CREATE INDEX idx_auditoria_accion ON auditoria_permisos(accion_realizada);
CREATE INDEX idx_auditoria_capacidad ON auditoria_permisos(capacidad_solicitada);

-- Índice compuesto para análisis de seguridad
CREATE INDEX idx_auditoria_usuario_timestamp
 ON auditoria_permisos(usuario_id, timestamp DESC);

-- Índice para búsquedas por fecha
CREATE INDEX idx_auditoria_fecha
 ON auditoria_permisos(CAST(timestamp AS DATE));

-- Índice GIN para búsquedas en JSONB
CREATE INDEX idx_auditoria_metadata ON auditoria_permisos USING GIN (metadata);

-- Comentarios
COMMENT ON TABLE auditoria_permisos IS 'Log completo de todos los intentos de acceso al sistema';
COMMENT ON COLUMN auditoria_permisos.accion_realizada IS 'Resultado del intento: acceso_concedido o acceso_denegado';
COMMENT ON COLUMN auditoria_permisos.metadata IS 'Campo JSONB para almacenar datos adicionales flexibles';

-- Particionamiento por fecha (opcional, para volúmenes grandes)
-- CREATE TABLE auditoria_permisos_2025_11 PARTITION OF auditoria_permisos
-- FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');
```

---

## Scripts Auxiliares

### Vista: Capacidades por Usuario

```sql
-- Vista que simplifica consulta de todas las capacidades de un usuario
CREATE OR REPLACE VIEW vista_capacidades_usuario AS
SELECT DISTINCT
 u.id AS usuario_id,
 u.nombre AS usuario_nombre,
 u.email AS usuario_email,
 c.id AS capacidad_id,
 c.nombre_completo AS capacidad,
 c.accion,
 c.recurso,
 c.dominio,
 c.nivel_sensibilidad,
 'grupo' AS origen
FROM usuarios u
JOIN usuarios_grupos ug ON u.id = ug.usuario_id
JOIN grupo_capacidades gc ON ug.grupo_id = gc.grupo_id
JOIN capacidades c ON gc.capacidad_id = c.id
WHERE ug.activo = TRUE
 AND (ug.fecha_expiracion IS NULL OR ug.fecha_expiracion > NOW())
 AND c.activa = TRUE

UNION

-- Permisos excepcionales concedidos
SELECT DISTINCT
 u.id AS usuario_id,
 u.nombre AS usuario_nombre,
 u.email AS usuario_email,
 c.id AS capacidad_id,
 c.nombre_completo AS capacidad,
 c.accion,
 c.recurso,
 c.dominio,
 c.nivel_sensibilidad,
 'excepcional_concedido' AS origen
FROM usuarios u
JOIN permisos_excepcionales pe ON u.id = pe.usuario_id
JOIN capacidades c ON pe.capacidad_id = c.id
WHERE pe.tipo = 'conceder'
 AND pe.activo = TRUE
 AND (pe.fecha_fin IS NULL OR pe.fecha_fin > NOW())
 AND c.activa = TRUE

EXCEPT

-- Menos permisos excepcionales revocados
SELECT DISTINCT
 u.id AS usuario_id,
 u.nombre AS usuario_nombre,
 u.email AS usuario_email,
 c.id AS capacidad_id,
 c.nombre_completo AS capacidad,
 c.accion,
 c.recurso,
 c.dominio,
 c.nivel_sensibilidad,
 'excepcional_revocado' AS origen
FROM usuarios u
JOIN permisos_excepcionales pe ON u.id = pe.usuario_id
JOIN capacidades c ON pe.capacidad_id = c.id
WHERE pe.tipo = 'revocar'
 AND pe.activo = TRUE
 AND (pe.fecha_fin IS NULL OR pe.fecha_fin > NOW())
 AND c.activa = TRUE;

COMMENT ON VIEW vista_capacidades_usuario IS 'Vista consolidada de todas las capacidades efectivas de cada usuario';
```

---

### Vista: Grupos por Usuario

```sql
CREATE OR REPLACE VIEW vista_grupos_usuario AS
SELECT
 u.id AS usuario_id,
 u.nombre AS usuario_nombre,
 u.email AS usuario_email,
 gp.id AS grupo_id,
 gp.codigo AS grupo_codigo,
 gp.nombre_display AS grupo_nombre,
 gp.tipo_acceso,
 ug.fecha_asignacion,
 ug.fecha_expiracion,
 ug.activo,
 CASE
 WHEN ug.fecha_expiracion IS NULL THEN TRUE
 WHEN ug.fecha_expiracion > NOW() THEN TRUE
 ELSE FALSE
 END AS vigente
FROM usuarios u
JOIN usuarios_grupos ug ON u.id = ug.usuario_id
JOIN grupos_permisos gp ON ug.grupo_id = gp.id
WHERE ug.activo = TRUE;

COMMENT ON VIEW vista_grupos_usuario IS 'Vista de grupos asignados a usuarios con estado de vigencia';
```

---

## Queries de Verificación

### Query 1: Verificar Permiso de Usuario

```sql
-- Función para verificar si un usuario tiene una capacidad específica
CREATE OR REPLACE FUNCTION usuario_tiene_permiso(
 p_usuario_id INTEGER,
 p_capacidad VARCHAR(200)
) RETURNS BOOLEAN AS $$
DECLARE
 v_tiene_permiso BOOLEAN;
BEGIN
 -- Verificar si existe en la vista de capacidades del usuario
 SELECT EXISTS (
 SELECT 1
 FROM vista_capacidades_usuario
 WHERE usuario_id = p_usuario_id
 AND capacidad = p_capacidad
 ) INTO v_tiene_permiso;

 RETURN v_tiene_permiso;
END;
$$ LANGUAGE plpgsql;

-- Uso:
-- SELECT usuario_tiene_permiso(1, 'sistema.vistas.dashboards.ver');
```

---

### Query 2: Obtener Todas las Capacidades de un Usuario

```sql
-- Obtener capacidades agrupadas por dominio
SELECT
 dominio,
 recurso,
 array_agg(DISTINCT accion ORDER BY accion) AS acciones,
 array_agg(DISTINCT capacidad ORDER BY capacidad) AS capacidades
FROM vista_capacidades_usuario
WHERE usuario_id = :usuario_id
GROUP BY dominio, recurso
ORDER BY dominio, recurso;
```

---

### Query 3: Auditoría - Accesos Denegados por Usuario

```sql
-- Encontrar intentos de acceso denegados en las últimas 24 horas
SELECT
 u.nombre AS usuario,
 u.email,
 ap.capacidad_solicitada,
 ap.recurso_accedido,
 ap.timestamp,
 ap.ip_address
FROM auditoria_permisos ap
JOIN usuarios u ON ap.usuario_id = u.id
WHERE ap.accion_realizada = 'acceso_denegado'
 AND ap.timestamp > NOW() - INTERVAL '24 hours'
ORDER BY ap.timestamp DESC;
```

---

## Checklist de Implementación

### Fase 1: Crear Estructura (Día 1)

```sql
-- ORDEN DE EJECUCIÓN:

-- 1. Tabla base de usuarios (si no existe)
-- CREATE TABLE usuarios (...);

-- 2. Crear tablas principales
-- [ ] CREATE TABLE funciones
-- [ ] CREATE TABLE capacidades
-- [ ] CREATE TABLE funcion_capacidades
-- [ ] CREATE TABLE grupos_permisos
-- [ ] CREATE TABLE grupo_capacidades
-- [ ] CREATE TABLE usuarios_grupos
-- [ ] CREATE TABLE permisos_excepcionales
-- [ ] CREATE TABLE auditoria_permisos

-- 3. Crear índices
-- [ ] Aplicar todos los CREATE INDEX

-- 4. Crear vistas auxiliares
-- [ ] CREATE VIEW vista_capacidades_usuario
-- [ ] CREATE VIEW vista_grupos_usuario

-- 5. Crear funciones auxiliares
-- [ ] CREATE FUNCTION usuario_tiene_permiso()
```

### Fase 2: Validar Estructura (Día 1-2)

```sql
-- [ ] Verificar todas las foreign keys
-- [ ] Verificar todos los índices creados
-- [ ] Verificar todas las constraints
-- [ ] Probar inserción de datos de prueba
-- [ ] Validar vistas funcionan correctamente
```

---

## Datos de Prueba

```sql
-- Script de prueba básico (SOLO para desarrollo/testing)

-- Insertar función de prueba
INSERT INTO funciones (nombre, nombre_completo, dominio, descripcion, activa)
VALUES ('dashboards', 'sistema.vistas.dashboards', 'vistas', 'Acceso a dashboards', TRUE);

-- Insertar capacidades de prueba
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, nivel_sensibilidad, activa)
VALUES
 ('sistema.vistas.dashboards.ver', 'ver', 'dashboards', 'vistas', 'bajo', TRUE),
 ('sistema.vistas.dashboards.exportar', 'exportar', 'dashboards', 'vistas', 'normal', TRUE);

-- Insertar grupo de prueba
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, activo)
VALUES ('visualizacion_basica', 'Visualización Básica', 'Acceso de solo lectura', 'operativo', TRUE);

-- Relacionar grupo con capacidades
INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT
 (SELECT id FROM grupos_permisos WHERE codigo = 'visualizacion_basica'),
 id
FROM capacidades
WHERE nombre_completo IN ('sistema.vistas.dashboards.ver');

-- Asignar grupo a usuario (asumiendo usuario con id=1 existe)
-- INSERT INTO usuarios_grupos (usuario_id, grupo_id, asignado_por)
-- VALUES (1, (SELECT id FROM grupos_permisos WHERE codigo = 'visualizacion_basica'), 1);
```

---

## Métricas de Performance Esperadas

### Consultas Críticas y sus Tiempos Objetivo

| Query | Tiempo Objetivo | Índice Usado |
|-------|----------------|--------------|
| `usuario_tiene_permiso()` | < 10ms | idx_usuarios_grupos_usuario_activo |
| Obtener capacidades de usuario | < 50ms | vista_capacidades_usuario |
| Generar menú de usuario | < 100ms | Multiple indexes |
| Registrar auditoría | < 5ms | Async/batch insert |
| Buscar accesos denegados | < 200ms | idx_auditoria_usuario_timestamp |

---

## Consideraciones Importantes

### Seguridad
- Todas las foreign keys tienen `ON DELETE CASCADE` o `ON DELETE SET NULL` apropiado
- Campos sensibles documentados con comentarios
- Auditoría completa de accesos
- Sin contraseñas o datos sensibles en estas tablas

### Performance
- Índices en todas las foreign keys
- Índices compuestos para queries frecuentes
- Vista materializada opcional para usuarios con muchos grupos
- Considerar particionamiento de `auditoria_permisos` si crece mucho

### Escalabilidad
- Diseño permite millones de usuarios
- Sin límites artificiales en número de grupos por usuario
- Campos JSONB para flexibilidad futura

---

## Próximos Pasos

Una vez completada esta prioridad:

**Estructura de datos COMPLETA**
**Siguiente: PRIORIDAD 2 - Funciones Core**

Estaremos listos para:
- Insertar datos reales (funciones + capacidades)
- Implementar lógica de negocio
- Crear APIs
- Construir UI

---

**Documento:** Prioridad 1 - Estructura Base
**Fecha:** 07 de Noviembre, 2025
**Estado:** Listo para Implementación

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - Adaptación sin emojis | equipo-ba |
