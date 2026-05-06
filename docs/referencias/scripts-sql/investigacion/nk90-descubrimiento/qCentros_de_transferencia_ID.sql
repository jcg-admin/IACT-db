
-- Centros de transferencia ID

SELECT 
    SUBSTRING(cDID_Centro_Transferencia, 1, 10) AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025
WHERE 
    cDID_Centro_Transferencia REGEXP '^[0-9]{10}[0-9]*$'  -- Asegura que el formato sea correcto
GROUP BY 
    numero_enrutamiento;


SELECT 
    LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10) AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025
WHERE 
    cDID_Centro_Transferencia REGEXP '^[0-9]+$'  -- Asegúrate de que el formato sea correcto
GROUP BY 
    numero_enrutamiento;


SELECT 
    CASE 
        WHEN cDID_Centro_Transferencia REGEXP '^[0-9]+$' AND LENGTH(cDID_Centro_Transferencia) > 10 
        THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10) 
        ELSE NULL  -- O puedes manejarlo de otra manera si lo prefieres
    END AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025 l
GROUP BY 
    numero_enrutamiento;


SELECT 
    CASE 
        WHEN cDID_Centro_Transferencia REGEXP '^[0-9]+$' AND LENGTH(cDID_Centro_Transferencia) > 10 
        THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10) 
        ELSE cDID_Centro_Transferencia  -- Devuelve el cDID_Centro_Transferencia completo si no cumple las condiciones
    END AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025
GROUP BY 
    numero_enrutamiento;


SELECT 
    CASE 
        WHEN LENGTH(l.cDID_Centro_Transferencia) > 10 
        THEN SUBSTRING(l.cDID_Centro_Transferencia, 1, LENGTH(l.cDID_Centro_Transferencia) - 10)
        ELSE l.cDID_Centro_Transferencia 
    END AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025 l
GROUP BY 
    numero_enrutamiento
ORDER BY 
    total_interacciones DESC;


SELECT 
    CASE 
        WHEN l.cDID_Centro_Transferencia LIKE '%' || l.cTelefono_Digitado
        THEN SUBSTRING(l.cDID_Centro_Transferencia, 1, LENGTH(l.cDID_Centro_Transferencia) - LENGTH(l.cTelefono_Digitado))
        ELSE l.cDID_Centro_Transferencia 
    END AS numero_enrutamiento,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025 l
WHERE 
    l.cDID_Centro_Transferencia LIKE '%' || l.cTelefono_Digitado
GROUP BY 
    numero_enrutamiento
ORDER BY 
    total_interacciones DESC;


SELECT 
    CASE 
        -- Termina con cTelefono_Digitado
        WHEN RIGHT(l.cDID_Centro_Transferencia, LENGTH(l.cTelefono_Digitado)) = l.cTelefono_Digitado
        THEN SUBSTRING(l.cDID_Centro_Transferencia, 1, LENGTH(l.cDID_Centro_Transferencia) - LENGTH(l.cTelefono_Digitado))
        
        -- Comienza con cTelefono_Digitado
        WHEN LEFT(l.cDID_Centro_Transferencia, LENGTH(l.cTelefono_Digitado)) = l.cTelefono_Digitado
        THEN SUBSTRING(l.cDID_Centro_Transferencia, LENGTH(l.cTelefono_Digitado) + 1)
        
        -- Contiene cTelefono_Digitado en alguna parte
        WHEN l.cDID_Centro_Transferencia LIKE '%' || l.cTelefono_Digitado || '%'
        THEN REPLACE(l.cDID_Centro_Transferencia, l.cTelefono_Digitado, '')
        
        -- Si tiene longitud mayor a cTelefono_Digitado
        WHEN LENGTH(l.cDID_Centro_Transferencia) > LENGTH(l.cTelefono_Digitado)
        THEN SUBSTRING(l.cDID_Centro_Transferencia, 1, LENGTH(l.cDID_Centro_Transferencia) - LENGTH(l.cTelefono_Digitado))
        
        -- Caso por defecto: devolver el ID completo
        ELSE l.cDID_Centro_Transferencia 
    END AS numero_enrutamiento,
    l.cDID_Centro_Transferencia,
    COUNT(*) AS total_interacciones
FROM 
    tbl_historico_t1_2025 l
GROUP BY 
    l.cDID_Centro_Transferencia
ORDER BY 
    total_interacciones DESC;
