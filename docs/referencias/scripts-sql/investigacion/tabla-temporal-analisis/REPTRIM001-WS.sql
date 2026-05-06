-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 'EJECUTADO EN:' as info;

SELECT 
    DATABASE() as 'Base de Datos'
    , USER() as 'Usuario'
    , @@version as 'Versión MySQL/MariaDB'
FROM DUAL;

SELECT NOW() as 'FECHA DE INICIO';

/*********************************************************************************************
     Script          : ANÁLISIS_TRIMESTRES_ÚNICOS_DUPLICADOS
     
     Create          : AGOSTO/2025
     Engine          : MariaDB/MySQL
     
     Parámetros Variables:
     
     Notas:
     - Usar ENGINE=MEMORY para mejor rendimiento si los datos caben en RAM
     - Usar ENGINE=InnoDB para volúmenes grandes que excedan memoria disponible
     - Las fechas deben estar en formato ISO (YYYY-MM-DD) para compatibilidad
     
*********************************************************************************************/

-- ====================================================================
-- CONFIGURACIÓN DE VARIABLES DE FECHA POR TRIMESTRE
-- ====================================================================

-- ====================================================================
-- FECHAS FIJAS 
-- ====================================================================

-- Definir variables para rangos de fechas de cada trimestre

SET @OPuebla = 19020084;
SET @ONacional = 19028031;
SET @ONacional02 = 1902001;

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-02-01';
SET @Q1_fin = '2025-03-31';

SET @Q2_nombre = 'Q02_25';
SET @Q2_inicio = '2025-04-01';
SET @Q2_fin = '2025-06-30';

SET @Q3_nombre = 'Q03_25';
SET @Q3_inicio = '2025-07-01';
SET @Q3_fin = '2025-07-31';

-- Mostrar configuración final seleccionada
SELECT 
    'CONFIGURACIÓN DE VARIABLES' as seccion
    , @OPuebla as puebla
    , @ONacional as nacional
    , @ONacional02 as nacional
    , @Q1_nombre
    , @Q1_inicio
    , @Q1_fin
    , @Q2_nombre
    , @Q2_inicio
    , @Q2_fin
    , @Q3_nombre
    , @Q3_inicio
    , @Q3_fin;
	
-- Mostrar estadísticas iniciales para monitoreo
SELECT 
    'INICIO DEL PROCESO' as evento
    , NOW() as timestamp
    , CONNECTION_ID() as connection_id
FROM DUAL;

-- ====================================================================
-- CONTEO DE DATOS EXISTENTES
-- ====================================================================

-- Contar registros por trimestre ANTES del proceso 
SELECT 'ANTES - REGISTROS POR TRIMESTRE EN TABLA FUENTE' as reporte;

SELECT 
    @Q1_nombre as trimestre,
    @Q1_inicio as fecha_inicio,
    @Q1_fin as fecha_fin,
    COUNT(*) as registros_existentes
FROM tbl_historico_t1_2025
WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional, @ONacional02)

UNION ALL

SELECT 
    @Q2_nombre as trimestre,
    @Q2_inicio as fecha_inicio,
    @Q2_fin as fecha_fin,
    COUNT(*) as registros_existentes
FROM tbl_historico_t2_2025
WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional)

UNION ALL

SELECT 
    @Q3_nombre as trimestre,
    @Q3_inicio as fecha_inicio,
    @Q3_fin as fecha_fin,
    COUNT(*) as registros_existentes
FROM tbl_historico_t3_2025
WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional);

-- ====================================================================
-- CREACIÓN DE TABLA TEMPORAL
-- ====================================================================

CREATE TEMPORARY TABLE IF NOT EXISTS temp_historical_quarter
ENGINE=InnoDB  -- Usar InnoDB para soportar BLOB/TEXT

AS
-- TRIMESTRE 1: Usar variable de fecha
SELECT 
	cTelefono_Origen
	, cTelefono_Digitado
	, cMenu
	, cDID_Centro_Transferencia
	, cDID_800Transfer
	, dFecha
	, dHoraInicio
	, dHoraFin
	, @Q1_nombre as trimestre
FROM tbl_historico_t1_2025
WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional, @ONacional02)

UNION ALL

-- TRIMESTRE 2
SELECT 
	cTelefono_Origen
	, cTelefono_Digitado
	, cMenu
	, cDID_Centro_Transferencia
	, cDID_800Transfer
	, dFecha
	, dHoraInicio
	, dHoraFin
	, @Q2_nombre as trimestre
FROM tbl_historico_t2_2025
WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional)

UNION ALL

-- TRIMESTRE 3
SELECT 
	cTelefono_Origen
	, cTelefono_Digitado
	, cMenu
	, cDID_Centro_Transferencia
	, cDID_800Transfer
	, dFecha
	, dHoraInicio
	, dHoraFin
	, @Q3_nombre as trimestre
FROM tbl_historico_t3_2025
WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
AND cDID_800Transfer IN (@OPuebla, @ONacional);

-- Crear índices después de la carga para mejor rendimiento
ALTER TABLE temp_historical_quarter
ADD INDEX idx_phone_origin_trimestre (cTelefono_Origen, trimestre),
ADD INDEX idx_quarter (trimestre),
ADD INDEX idx_phone_origin(cTelefono_Origen);

-- Verificar carga exitosa con logging detallado
SELECT '<<< TABLA TEMPORAL CREADA EXITOSAMENTE >>>' as resultado;

SELECT 
    'CARGA COMPLETADA' as evento,
    COUNT(*) as total_registros,
    COUNT(DISTINCT cTelefono_Origen) as telefono_origen_distintos,
    COUNT(DISTINCT trimestre) as trimestres_distintos,
    MIN(dFecha) as fecha_mas_antigua,
    MAX(dFecha) as fecha_mas_reciente,
    -- Validar que las fechas están en los rangos esperados
    CASE 
        WHEN MIN(dFecha) >= @Q1_inicio 
         AND MAX(dFecha) <= @Q3_fin
        THEN 'FECHAS VÁLIDAS' 
        ELSE 'REVISAR FECHAS'
    END as validacion_fechas,
    NOW() as timestamp
FROM temp_historical_quarter;