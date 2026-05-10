-- ====================================================================
-- Script          : Clientes Únicos por DID y Trimestre (CORREGIDO)
-- Original        : q_REPTRIM011_CLIENTES_UNICOS_POR_DID.sql
-- Correcciones    :
--   C-01 CRÍTICO: @ONacionalB = 19020001 agregado — estaba ausente.
--                 Nacional B (DID 19020001) quedaba excluido del conteo.
--   C-02 MEDIO:   Separar nacional_A y nacional_B en el resultado.
--                 El original colapsaba ambos como 'Nacional'.
--   C-03 MENOR:   cTelefono_Origen → confirmar si debe ser cTelefono_Digitado
--                 (pendiente decisión de negocio — ver README).
-- Engine          : MariaDB/MySQL
-- ====================================================================

SET @OPuebla   = 19020084;
SET @ONacionalA = 19028031;   -- C-01: renombrado de @ONacional
SET @ONacionalB = 19020001;   -- C-01: AGREGADO — estaba ausente en el original

SET @Q1_nombre = 'Q01_25'; SET @Q1_inicio = '2025-01-01'; SET @Q1_fin = '2025-03-31';
SET @Q2_nombre = 'Q02_25'; SET @Q2_inicio = '2025-04-01'; SET @Q2_fin = '2025-06-30';
SET @Q3_nombre = 'Q03_25'; SET @Q3_inicio = '2025-07-01'; SET @Q3_fin = '2025-09-30';

SELECT
    -- C-02: separar nacional_A y nacional_B en lugar de colapsar como 'Nacional'
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                       AS segmento,
    trimestre,
    COUNT(DISTINCT cTelefono_Origen)          AS clientes_unicos
    -- C-03 PENDIENTE: evaluar si debe ser COUNT(DISTINCT cTelefono_Digitado)
    --      cTelefono_Origen  = el número desde el que llamó (siempre tiene valor)
    --      cTelefono_Digitado = el número que ingresó en el IVR (30% NULL)
FROM (
    SELECT @Q1_nombre AS trimestre, cDID_800Transfer, cTelefono_Origen
    FROM tbl_historico_t1_2025
    WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)   -- C-01: incluye B

    UNION ALL

    SELECT @Q2_nombre AS trimestre, cDID_800Transfer, cTelefono_Origen
    FROM tbl_historico_t2_2025
    WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)

    UNION ALL

    SELECT @Q3_nombre AS trimestre, cDID_800Transfer, cTelefono_Origen
    FROM tbl_historico_t3_2025
    WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
) datos
GROUP BY cDID_800Transfer, trimestre
ORDER BY trimestre, segmento;
