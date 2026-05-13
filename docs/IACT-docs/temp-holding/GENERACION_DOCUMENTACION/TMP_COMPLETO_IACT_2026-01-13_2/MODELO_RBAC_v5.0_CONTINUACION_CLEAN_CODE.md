# MODELO RBAC v5.0 - CONTINUACIÓN (Clean Code)

## Documento: IACT-RBAC-001-v5.0
## Continuación desde Sección 9.3

---

**NOTA CLEAN CODE APLICADO:**
- Tablas normalizadas (3FN)
- Sin JSON arrays
- Nomenclatura consistente en español
- Relaciones explícitas mediante tablas intermedias
- Nombres descriptivos sin anglicismos innecesarios

---

## 9. IMPLEMENTACIÓN SQL COMPLETA (Continuación)

### 9.3 Tabla: agrupador_funciones (continúa inserts)

```sql
-- B03: agrupador_supervisor (12 funciones) - continuación
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-003', 'RPT-001', 1),   -- ve_reportes
('AGR-003', 'RPT-002', 2),   -- ve_reportes_avanzados
('AGR-003', 'RPT-004', 3),   -- filtra_reportes
('AGR-003', 'RPT-005', 4),   -- exporta_csv
('AGR-003', 'RPT-006', 5),   -- exporta_excel
('AGR-003', 'DSH-001', 6),   -- ve_dashboard
('AGR-003', 'DSH-002', 7),   -- personaliza_dashboard
('AGR-003', 'DSH-003', 8),   -- guarda_vistas
('AGR-003', 'ALR-001', 9),   -- ve_alertas
('AGR-003', 'ALR-002', 10),  -- configura_alertas
('AGR-003', 'ALR-003', 11),  -- configura_alertas_equipo
('AGR-003', 'ALR-007', 12);  -- ve_historial_alertas

-- B04: agrupador_analista (18 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-004', 'RPT-001', 1),
('AGR-004', 'RPT-002', 2),
('AGR-004', 'RPT-003', 3),
('AGR-004', 'RPT-004', 4),
('AGR-004', 'RPT-005', 5),
('AGR-004', 'RPT-006', 6),
('AGR-004', 'RPT-007', 7),
('AGR-004', 'RPT-008', 8),
('AGR-004', 'RPT-009', 9),
('AGR-004', 'DSH-001', 10),
('AGR-004', 'DSH-002', 11),
('AGR-004', 'DSH-003', 12),
('AGR-004', 'DSH-004', 13),
('AGR-004', 'ANL-001', 14),
('AGR-004', 'ANL-002', 15),
('AGR-004', 'ANL-003', 16),
('AGR-004', 'ANL-004', 17),
('AGR-004', 'ANL-005', 18);

-- B05: agrupador_exportador (4 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-005', 'RPT-005', 1),   -- exporta_csv
('AGR-005', 'RPT-006', 2),   -- exporta_excel
('AGR-005', 'RPT-007', 3),   -- exporta_pdf
('AGR-005', 'RPT-010', 4);   -- comparte_reportes

-- B06: agrupador_gestor_alertas (6 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-006', 'ALR-001', 1),
('AGR-006', 'ALR-002', 2),
('AGR-006', 'ALR-003', 3),
('AGR-006', 'ALR-005', 4),
('AGR-006', 'ALR-006', 5),
('AGR-006', 'ALR-008', 6);

-- B07: agrupador_admin_usuarios (12 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-007', 'USR-001', 1),
('AGR-007', 'USR-002', 2),
('AGR-007', 'USR-003', 3),
('AGR-007', 'USR-004', 4),
('AGR-007', 'USR-005', 5),
('AGR-007', 'USR-006', 6),
('AGR-007', 'USR-007', 7),
('AGR-007', 'USR-008', 8),
('AGR-007', 'USR-009', 9),
('AGR-007', 'USR-010', 10),
('AGR-007', 'FUN-001', 11),
('AGR-007', 'FUN-002', 12);

-- B08: agrupador_admin_funciones (6 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-008', 'FUN-001', 1),
('AGR-008', 'FUN-002', 2),
('AGR-008', 'FUN-003', 3),
('AGR-008', 'FUN-004', 4),
('AGR-008', 'FUN-005', 5),
('AGR-008', 'FUN-006', 6);

-- B09: agrupador_auditor (4 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-009', 'AUD-001', 1),
('AGR-009', 'AUD-002', 2),
('AGR-009', 'AUD-003', 3),
('AGR-009', 'AUD-004', 4);

-- B10: agrupador_admin_sistema (8 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-010', 'SYS-001', 1),
('AGR-010', 'SYS-002', 2),
('AGR-010', 'SYS-003', 3),
('AGR-010', 'SYS-004', 4),
('AGR-010', 'SYS-005', 5),
('AGR-010', 'USR-002', 6),
('AGR-010', 'USR-005', 7),
('AGR-010', 'USR-006', 8);

-- B11: agrupador_seguridad (5 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-011', 'SEC-001', 1),
('AGR-011', 'SEC-002', 2),
('AGR-011', 'SEC-003', 3),
('AGR-011', 'AUD-001', 4),
('AGR-011', 'AUD-002', 5);
```

---

### 9.4 Tabla: usuarios_funciones (Asignación Usuario-Función)

```sql
CREATE TABLE usuarios_funciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    funcion_id VARCHAR(50) NOT NULL,
    asignado_por INT NOT NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    justificacion VARCHAR(500) NOT NULL,
    origen_agrupador VARCHAR(50) NULL COMMENT 'NULL si asignación directa',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_revocacion DATETIME NULL,
    revocado_por INT NULL,
    
    CONSTRAINT fk_uf_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_uf_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT fk_uf_asignador FOREIGN KEY (asignado_por) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_uf_revocador FOREIGN KEY (revocado_por) 
        REFERENCES usuarios(usuario_id),
    
    CONSTRAINT uk_usuario_funcion UNIQUE (usuario_id, funcion_id),
    
    INDEX idx_usuario_activo (usuario_id, activo),
    INDEX idx_funcion (funcion_id),
    INDEX idx_origen (origen_agrupador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 9.5 Tabla: separacion_funciones (SoD - Normalizada)

**Clean Code:** En lugar de JSON arrays, usamos tabla relacional.

```sql
-- Tabla maestra de restricciones SoD
CREATE TABLE separacion_funciones (
    restriccion_id VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500) NOT NULL,
    cardinalidad_maxima TINYINT NOT NULL DEFAULT 1 
        COMMENT 'Máximo de funciones del grupo conflictivo que puede tener un usuario',
    razon VARCHAR(500) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_activa (activa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de funciones en conflicto (relación N:M normalizada)
CREATE TABLE separacion_funciones_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restriccion_id VARCHAR(50) NOT NULL,
    funcion_id VARCHAR(50) NOT NULL,
    grupo CHAR(1) NOT NULL COMMENT 'A o B - grupos mutuamente excluyentes',
    
    CONSTRAINT fk_sfd_restriccion FOREIGN KEY (restriccion_id) 
        REFERENCES separacion_funciones(restriccion_id),
    CONSTRAINT fk_sfd_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    
    CONSTRAINT uk_restriccion_funcion UNIQUE (restriccion_id, funcion_id),
    CONSTRAINT chk_grupo CHECK (grupo IN ('A', 'B')),
    
    INDEX idx_restriccion (restriccion_id),
    INDEX idx_funcion (funcion_id),
    INDEX idx_grupo (restriccion_id, grupo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar restricciones SoD
INSERT INTO separacion_funciones 
    (restriccion_id, nombre, descripcion, cardinalidad_maxima, razon) 
VALUES
('SOD-001', 'sod_admin_auditoria', 
 'Quien opera el sistema NO debe auditarlo', 1,
 'Principio de independencia del auditor. Cumplimiento ISO 27001, SOC 2'),

('SOD-002', 'sod_usuarios_auditoria',
 'Quien gestiona usuarios NO debe auditar sus acciones', 1,
 'Prevenir ocultamiento de acciones propias. Garantizar trazabilidad'),

('SOD-003', 'sod_crea_elimina_usuarios',
 'Quien crea usuarios NO debe poder eliminarlos', 1,
 'Control de cuatro ojos. Prevenir fraude en ciclo de vida'),

('SOD-004', 'sod_asigna_gestiona_sod',
 'Quien asigna funciones NO debe modificar restricciones SoD', 1,
 'Separación de poderes. Prevenir auto-asignación'),

('SOD-005', 'sod_configura_ve_auditoria',
 'Quien configura políticas NO debe ver sus propios logs', 1,
 'Independencia de configuración y auditoría');

-- Insertar detalle de funciones en conflicto
-- SOD-001: administra_sistema vs ve_auditoria
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-001', 'SYS-001', 'A'),  -- administra_sistema
('SOD-001', 'SYS-002', 'A'),  -- gestiona_sesiones
('SOD-001', 'SYS-003', 'A'),  -- ejecuta_etl
('SOD-001', 'SYS-004', 'A'),  -- configura_parametros
('SOD-001', 'AUD-001', 'B'),  -- ve_auditoria
('SOD-001', 'AUD-002', 'B'),  -- busca_auditoria
('SOD-001', 'AUD-003', 'B'),  -- exporta_auditoria
('SOD-001', 'AUD-004', 'B');  -- genera_compliance

-- SOD-002: gestión usuarios vs auditoría
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-002', 'USR-001', 'A'),  -- crea_usuarios
('SOD-002', 'USR-003', 'A'),  -- modifica_usuarios
('SOD-002', 'USR-004', 'A'),  -- elimina_usuarios
('SOD-002', 'USR-008', 'A'),  -- bloquea_usuarios
('SOD-002', 'AUD-001', 'B'),  -- ve_auditoria
('SOD-002', 'AUD-002', 'B'),  -- busca_auditoria
('SOD-002', 'AUD-003', 'B');  -- exporta_auditoria

-- SOD-003: crea vs elimina usuarios
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-003', 'USR-001', 'A'),  -- crea_usuarios
('SOD-003', 'USR-004', 'B');  -- elimina_usuarios

-- SOD-004: asigna funciones vs gestiona SoD
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-004', 'FUN-001', 'A'),  -- asigna_funciones
('SOD-004', 'FUN-006', 'B');  -- gestiona_sod

-- SOD-005: configura políticas vs ve auditoría
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-005', 'SEC-001', 'A'),  -- configura_politicas
('SOD-005', 'AUD-001', 'B');  -- ve_auditoria
```

---

### 9.6 Tabla: permisos_temporales

```sql
CREATE TABLE permisos_temporales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    funcion_id VARCHAR(50) NOT NULL,
    otorgado_por INT NOT NULL,
    fecha_otorgamiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATETIME NOT NULL,
    justificacion VARCHAR(500) NOT NULL,
    estado ENUM('ACTIVO', 'EXPIRADO', 'REVOCADO') NOT NULL DEFAULT 'ACTIVO',
    revocado_por INT NULL,
    fecha_revocacion DATETIME NULL,
    
    CONSTRAINT fk_pt_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_pt_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT fk_pt_otorgante FOREIGN KEY (otorgado_por) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_pt_revocador FOREIGN KEY (revocado_por) 
        REFERENCES usuarios(usuario_id),
    
    INDEX idx_usuario_estado (usuario_id, estado),
    INDEX idx_vencimiento (fecha_vencimiento),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Restricción: máximo 6 meses (aplicada en aplicación, no en BD)
-- La validación se hace en el procedimiento almacenado
```

---

### 9.7 Tabla: segmentos_datos

```sql
CREATE TABLE segmentos_datos (
    segmento_id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_codigo (codigo),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO segmentos_datos (codigo, nombre, descripcion) VALUES
('OP', 'DATOS_OPERATIVOS', 'Datos de operación del IVR: llamadas, menús, opciones'),
('FI', 'DATOS_FINANCIEROS', 'Datos para análisis de costos y facturación'),
('TE', 'DATOS_TECNICOS', 'Datos técnicos de infraestructura y rendimiento'),
('SU', 'DATOS_SUPERVISION', 'Datos para supervisión y control'),
('CA', 'DATOS_CALIDAD', 'Datos de métricas de calidad del servicio'),
('GE', 'DATOS_CONSOLIDADOS', 'Datos agregados de todos los segmentos');
```

---

### 9.8 Tabla: usuarios (Actualizada)

```sql
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO', 'ELIMINADO') NOT NULL DEFAULT 'ACTIVO',
    segmento_id INT NOT NULL,
    intentos_fallidos TINYINT NOT NULL DEFAULT 0,
    bloqueado_hasta DATETIME NULL,
    debe_cambiar_password BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_ultimo_acceso DATETIME NULL,
    creado_por INT NULL,
    
    CONSTRAINT fk_usuario_segmento FOREIGN KEY (segmento_id) 
        REFERENCES segmentos_datos(segmento_id),
    CONSTRAINT fk_usuario_creador FOREIGN KEY (creado_por) 
        REFERENCES usuarios(usuario_id),
    
    INDEX idx_username (username),
    INDEX idx_estado (estado),
    INDEX idx_segmento (segmento_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 9.9 Tabla: log_auditoria (Inmutable)

```sql
CREATE TABLE log_auditoria (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    direccion_ip VARCHAR(45) NULL,
    agente_usuario VARCHAR(500) NULL,
    tipo_accion VARCHAR(100) NOT NULL,
    modulo VARCHAR(100) NOT NULL,
    tipo_recurso VARCHAR(100) NULL,
    recurso_id VARCHAR(100) NULL,
    resultado ENUM('EXITO', 'FALLO', 'PARCIAL') NOT NULL,
    mensaje_error TEXT NULL,
    datos_adicionales TEXT NULL COMMENT 'Datos en formato clave=valor, no JSON',
    id_sesion VARCHAR(255) NULL,
    checksum_registro VARCHAR(64) NOT NULL COMMENT 'SHA-256 del registro',
    
    INDEX idx_fecha (fecha_evento),
    INDEX idx_usuario_fecha (usuario_id, fecha_evento),
    INDEX idx_tipo_accion (tipo_accion, fecha_evento),
    INDEX idx_resultado (resultado, fecha_evento),
    INDEX idx_modulo (modulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Trigger: Calcular checksum antes de insertar
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_checksum
BEFORE INSERT ON log_auditoria
FOR EACH ROW
BEGIN
    SET NEW.checksum_registro = SHA2(
        CONCAT_WS('|',
            NEW.fecha_evento,
            NEW.usuario_id,
            NEW.username,
            COALESCE(NEW.direccion_ip, ''),
            NEW.tipo_accion,
            NEW.modulo,
            COALESCE(NEW.tipo_recurso, ''),
            COALESCE(NEW.recurso_id, ''),
            NEW.resultado
        ), 256
    );
END$$
DELIMITER ;

-- Trigger: Prevenir modificación
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_no_update
BEFORE UPDATE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'ERROR: Los registros de auditoría son inmutables';
END$$
DELIMITER ;

-- Trigger: Prevenir eliminación
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_no_delete
BEFORE DELETE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'ERROR: Los registros de auditoría no se pueden eliminar';
END$$
DELIMITER ;
```

---

## 10. FUNCIONES Y PROCEDIMIENTOS

### 10.1 Función: usuario_tiene_funcion

```sql
DELIMITER $$
CREATE FUNCTION usuario_tiene_funcion(
    p_usuario_id INT,
    p_nombre_funcion VARCHAR(100)
) RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_funcion_id VARCHAR(50);
    DECLARE v_tiene BOOLEAN DEFAULT FALSE;
    
    -- Obtener ID de la función por nombre
    SELECT funcion_id INTO v_funcion_id
    FROM funciones
    WHERE nombre = p_nombre_funcion
      AND activa = TRUE;
    
    IF v_funcion_id IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- 1. Verificar permiso temporal activo (mayor precedencia)
    SELECT TRUE INTO v_tiene
    FROM permisos_temporales
    WHERE usuario_id = p_usuario_id
      AND funcion_id = v_funcion_id
      AND estado = 'ACTIVO'
      AND fecha_vencimiento > NOW()
    LIMIT 1;
    
    IF v_tiene = TRUE THEN
        RETURN TRUE;
    END IF;
    
    -- 2. Verificar asignación directa de función
    SELECT TRUE INTO v_tiene
    FROM usuarios_funciones
    WHERE usuario_id = p_usuario_id
      AND funcion_id = v_funcion_id
      AND activo = TRUE
    LIMIT 1;
    
    RETURN COALESCE(v_tiene, FALSE);
END$$
DELIMITER ;
```

**Uso:**
```sql
SELECT usuario_tiene_funcion(123, 'exporta_pdf') AS puede_exportar;
-- Resultado: 1 (TRUE) o 0 (FALSE)
```

---

### 10.2 Función: validar_sod

```sql
DELIMITER $$
CREATE FUNCTION validar_sod_antes_asignar(
    p_usuario_id INT,
    p_funcion_id VARCHAR(50)
) RETURNS VARCHAR(500)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_restriccion_nombre VARCHAR(100);
    DECLARE v_grupo_nuevo CHAR(1);
    DECLARE v_funciones_conflicto INT;
    DECLARE v_cardinalidad INT;
    DECLARE v_mensaje VARCHAR(500);
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor para verificar cada restricción SoD activa
    DECLARE cur_sod CURSOR FOR
        SELECT sf.restriccion_id, sf.nombre, sf.cardinalidad_maxima, sfd.grupo
        FROM separacion_funciones sf
        INNER JOIN separacion_funciones_detalle sfd 
            ON sf.restriccion_id = sfd.restriccion_id
        WHERE sf.activa = TRUE
          AND sfd.funcion_id = p_funcion_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET v_mensaje = 'OK';
    
    OPEN cur_sod;
    
    verificar_loop: LOOP
        FETCH cur_sod INTO v_restriccion_nombre, v_restriccion_nombre, 
                          v_cardinalidad, v_grupo_nuevo;
        
        IF done THEN
            LEAVE verificar_loop;
        END IF;
        
        -- Contar funciones del grupo opuesto que ya tiene el usuario
        SELECT COUNT(*) INTO v_funciones_conflicto
        FROM usuarios_funciones uf
        INNER JOIN separacion_funciones_detalle sfd 
            ON uf.funcion_id = sfd.funcion_id
        INNER JOIN separacion_funciones sf 
            ON sfd.restriccion_id = sf.restriccion_id
        WHERE uf.usuario_id = p_usuario_id
          AND uf.activo = TRUE
          AND sf.nombre = v_restriccion_nombre
          AND sfd.grupo != v_grupo_nuevo;
        
        IF v_funciones_conflicto > 0 THEN
            SET v_mensaje = CONCAT('VIOLACION SoD: ', v_restriccion_nombre, 
                                   ' - Usuario ya tiene funciones del grupo conflictivo');
            LEAVE verificar_loop;
        END IF;
    END LOOP;
    
    CLOSE cur_sod;
    
    RETURN v_mensaje;
END$$
DELIMITER ;
```

**Uso:**
```sql
SELECT validar_sod_antes_asignar(123, 'AUD-001') AS resultado_validacion;
-- Resultado: 'OK' o 'VIOLACION SoD: ...'
```

---

### 10.3 Procedimiento: asignar_funcion

```sql
DELIMITER $$
CREATE PROCEDURE asignar_funcion(
    IN p_usuario_id INT,
    IN p_funcion_id VARCHAR(50),
    IN p_asignado_por INT,
    IN p_justificacion VARCHAR(500),
    OUT p_resultado VARCHAR(500)
)
BEGIN
    DECLARE v_estado_usuario VARCHAR(20);
    DECLARE v_funcion_activa BOOLEAN;
    DECLARE v_sod_resultado VARCHAR(500);
    DECLARE v_ya_asignada BOOLEAN DEFAULT FALSE;
    
    -- Validar que usuario existe y está activo
    SELECT estado INTO v_estado_usuario
    FROM usuarios
    WHERE usuario_id = p_usuario_id;
    
    IF v_estado_usuario IS NULL THEN
        SET p_resultado = 'ERROR: Usuario no existe';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;
    
    IF v_estado_usuario != 'ACTIVO' THEN
        SET p_resultado = 'ERROR: Usuario no está activo';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no está activo';
    END IF;
    
    -- Validar que función existe y está activa
    SELECT activa INTO v_funcion_activa
    FROM funciones
    WHERE funcion_id = p_funcion_id;
    
    IF v_funcion_activa IS NULL OR v_funcion_activa = FALSE THEN
        SET p_resultado = 'ERROR: Función no existe o no está activa';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Función no válida';
    END IF;
    
    -- Validar justificación mínima
    IF LENGTH(TRIM(p_justificacion)) < 20 THEN
        SET p_resultado = 'ERROR: Justificación debe tener al menos 20 caracteres';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Justificación muy corta';
    END IF;
    
    -- Verificar si ya tiene la función asignada
    SELECT TRUE INTO v_ya_asignada
    FROM usuarios_funciones
    WHERE usuario_id = p_usuario_id
      AND funcion_id = p_funcion_id
      AND activo = TRUE
    LIMIT 1;
    
    IF v_ya_asignada = TRUE THEN
        SET p_resultado = 'INFO: Usuario ya tiene esta función asignada';
    ELSE
        -- Validar SoD
        SET v_sod_resultado = validar_sod_antes_asignar(p_usuario_id, p_funcion_id);
        
        IF v_sod_resultado != 'OK' THEN
            SET p_resultado = v_sod_resultado;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Violación de SoD';
        END IF;
        
        -- Insertar asignación
        INSERT INTO usuarios_funciones 
            (usuario_id, funcion_id, asignado_por, justificacion, origen_agrupador)
        VALUES 
            (p_usuario_id, p_funcion_id, p_asignado_por, p_justificacion, NULL);
        
        -- Registrar en auditoría
        INSERT INTO log_auditoria 
            (usuario_id, username, tipo_accion, modulo, tipo_recurso, 
             recurso_id, resultado, datos_adicionales)
        SELECT 
            p_asignado_por,
            (SELECT username FROM usuarios WHERE usuario_id = p_asignado_por),
            'ASIGNAR_FUNCION',
            'RBAC',
            'funcion',
            p_funcion_id,
            'EXITO',
            CONCAT('usuario_destino=', p_usuario_id, 
                   '|justificacion=', LEFT(p_justificacion, 100));
        
        SET p_resultado = 'OK: Función asignada correctamente';
    END IF;
END$$
DELIMITER ;
```

**Uso:**
```sql
CALL asignar_funcion(123, 'RP