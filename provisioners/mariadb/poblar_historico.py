#!/usr/bin/env python3
"""
poblar_historico.py — Poblar tablas tbl_historico_t* con datos de producción calibrados

Genera e inserta registros que replican fielmente las distribuciones de producción
(menús, VDNs, proporciones de teléfono, bug G-29 de horas invertidas).

Al contrario de seed_historico_real.sql (que genera los primeros 10K registros),
este script está diseñado para añadir volumen incremental. Cuantos más registros,
menor el error estadístico de las distribuciones.

PROPORCIONES CALIBRADAS (datos reales Q1-Q3 2025, 36.7M llamadas):
    dHoraInicio > dHoraFin          38.8%  (bug G-29, IVR del cliente)
    cTelefono_Digitado IS NULL       21.2%  (no_digito_telefono)
    Digitado = Origen (misma_linea)  28.2%  (número A llama y digita su mismo número)
    Digitado ≠ Origen (linea_dif)    50.6%

ANOMALÍAS DE CALIDAD DE DATOS REPLICADAS (ver TBL-HISTORICO-ANOMALIAS.md):
    CASO_NULL          1.3%   cDID_Centro_Transferencia NULL o vacío
    CLIENTE_COLGO     27.4%   cDID_Centro_Transferencia = 'cliente_colgo'
    NK90 len_17        5.3%   VDN 7 dig + teléfono 10 dig (formato dominante en prod)
    NK90 len_16        0.3%   VDN 6 dig + teléfono 10 dig
    cMENU_ERROR        1.2%   cMenu contiene número de teléfono
    CASO_ERROR_CEROS   3.0%   cDID solo ceros — Puebla Q02+ únicamente
    ERROR_CARACTER     0.05%  cDID con carácter no numérico inicial

TABLAS Y RANGOS:
    tbl_historico_t1_2025   Q01_25   2025-01-01 → 2025-03-31
    tbl_historico_t2_2025   Q02_25   2025-04-01 → 2025-06-30
    tbl_historico_t3_2025   Q03_25   2025-07-01 → 2025-09-30
    tbl_historico_t4_2025   Q04_25   2025-10-01 → 2025-12-31
    tbl_historico_t1_2026   Q01_26   2026-01-01 → 2026-03-31
    tbl_historico_t2_2026   Q02_26   2026-04-01 → 2026-05-06  (parcial)

USO:
    # Default: agrega 50K por tabla completa, 20K en Q2_2026 (parcial)
    python3 poblar_historico.py

    # Personalizado
    python3 poblar_historico.py --rows 100000

    # Solo tablas específicas
    python3 poblar_historico.py --tables Q01_25 Q02_25 --rows 200000

    # Limpiar y repoblar (TRUNCATE + INSERT)
    python3 poblar_historico.py --truncate --rows 100000

    # Solo verificar estado sin insertar
    python3 poblar_historico.py --status

ARGUMENTOS:
    --rows N        Registros a agregar por tabla completa (default: 50000)
    --tables Q...   Quarters a poblar, ej: Q01_25 Q02_25 (default: todos)
    --chunk N       Tamaño del batch de INSERT (default: 200)
    --truncate      TRUNCATE la tabla antes de insertar
    --status        Solo muestra estado actual, sin insertar
    --socket PATH   Socket de MariaDB (default: /run/mysqld/mysqld.sock)
    --host HOST     Host (alternativa a socket)
    --port PORT     Puerto (default: 3306)
    --user USER     Usuario (default: django_user)
    --password PWD  Contraseña (default: django_pass)
    --db DB         Base de datos (default: ivr_legacy)
"""

import argparse
import math
import random
import subprocess
import sys
import tempfile
import os
from datetime import date, datetime, timedelta

# ===========================================================================
# CONFIGURACIÓN DE DISTRIBUCIONES (calibrado con datos reales de producción)
# ===========================================================================

# Proporciones de cTelefono_Digitado
P_NULL   = 0.212   # no_digito_telefono
P_MISMA  = 0.282   # misma_linea (Digitado = Origen)
# P_DIF  = 0.506   # linea_diferente (implícito: 1 - P_NULL - P_MISMA)

# Probabilidad condicional: dado que Digitado no es NULL, P(Digitado = Origen)
P_MISMA_GIVEN_NOT_NULL = P_MISMA / (1 - P_NULL)   # ≈ 0.358

# Probabilidad de que dHoraInicio > dHoraFin (bug G-29)
P_HORAS_INVERTIDAS = 0.388

# ---- Anomalías de cDID_Centro_Transferencia --------------------------------

# CASO_ERROR_CEROS: cDID = solo ceros (ej: '0000000')
# Solo Puebla (DID 19020084), solo Q02_25 en adelante. Ausente en Q01_25.
P_ERROR_CEROS_PUEBLA = 0.030   # 3% del volumen Puebla Q02+

# ERROR_CARACTER_INICIAL: cDID empieza con carácter no numérico
# Presente en todos los quarters, volumen muy bajo (< 0.05% total).
P_ERROR_CARACTER = 0.0005

# NK90 — proporciones reales Q1 2025 (fuente: clasificacion_cDID Q1 2025)
#   len_17 (VDN 7 dig + tel 10 dig) → 5.33% del total = 94% de casos NK90
#   len_16 (VDN 6 dig + tel 10 dig) → 0.34% del total =  6% de casos NK90
#   len_18+ (VDN 8+ dig + tel 10)   → no se observa en producción
#
# P_NK90 debe compensar que solo ~57% de los registros son elegibles para NK90
# (se excluyen: CLIENTE_COLGO ~27%, CASO_NULL ~1%, tel_digitado IS NULL ~21%).
# Elegibles ≈ (1-0.27) × (1-0.013) × (1-0.212) ≈ 0.57
# Target total NK90 = 5.67% → P_NK90 = 0.0567 / 0.57 ≈ 0.099
P_NK90 = 0.099
P_NK90_LEN17_COND = 0.94   # dado NK90, 94% son len_17 (VDN 7 dígitos)
# VDNs de 7 dígitos usados en NK90 (reales de producción)
VDN_NK90_7DIG = ['1309004', '1308066', '1307200', '1907000', '1308100']
# VDN de 6 dígitos usado en NK90 (real de producción)
VDN_NK90_6DIG = ['309004']

# Prefijos telefónicos MX reales observados en producción
PREFIJOS = [
    ('443', 7),   # Morelia / Michoacán — dominante en datos
    ('722', 7),   # Toluca / Edomex
    ('222', 7),   # Puebla
    ('55',  8),   # CDMX
    ('333', 7),   # Guadalajara
    ('81',  8),   # Monterrey
    ('998', 7),   # Cancún
    ('664', 7),   # Tijuana
    ('618', 7),   # Durango
    ('614', 7),   # Chihuahua
    ('771', 7),   # Pachuca
    ('442', 7),   # Querétaro
    ('477', 7),   # León
    ('462', 7),   # Irapuato
]
# Pesos aproximados basados en distribución del seed_historico_real
PESOS_PREFIJOS = [0.15, 0.12, 0.10, 0.18, 0.08, 0.07,
                  0.05, 0.04, 0.03, 0.03, 0.04, 0.04, 0.04, 0.03]

# Segmentos — DIDs de entrada con sus proporciones reales
#
# cDID_800Transfer almacena el número DID numérico crudo. Los reportes
# aplican un CASE WHEN que transforma el DID en una etiqueta de segmento:
#
#   DID en tbl_historico_*   Etiqueta en reportes   Proporcion real Q1-Q3
#   19028031              ->  'nacional_A'           45% del trafico total
#   19020001              ->  'nacional_B'           30% del trafico total
#   19020084              ->  'puebla'               25% del trafico total
#
# CASE canonico en los SPs de reporte:
#   CASE cDID_800Transfer
#       WHEN 19028031 THEN 'nacional_A'
#       WHEN 19020001 THEN 'nacional_B'
#       WHEN 19020084 THEN 'puebla'
#   END AS segmento
#
# ADVERTENCIA — Bug G-30 en scripts originales de produccion:
#   @ONacionalB = 19028031  <- INCORRECTO (duplica Nacional A)
#   @ONacionalB = 19020001  <- CORRECTO
# El bug causo que Q01_25 de clientes_unicos etiquetara Nacional A como
# 'nacional_B', quedando el real Nacional B (19020001) excluido del reporte.
# Este script usa los DIDs correctos.
SEGMENTOS = [
    ('19028031', 0.45),   # nacional_A — linea 800 dominante
    ('19020001', 0.30),   # nacional_B
    ('19020084', 0.25),   # puebla
]

# Menús con sus proporciones reales — calibrado con prom_llamadas Q1_2025
# Fuente: prom_llamadas_Q1Q2Q3_2025.csv (11.6M llamadas Q1, ambos segmentos)
# Formato: (nombre, probabilidad_acumulada, opciones_ponderadas)
# El SP de reporte normaliza cMenu con UPPER(TRIM()) — ej: RES-FallaInternet → RES-FALLAINTERNET
MENUS = [
    # --- Abandono (35.6%) ---------------------------------------------------
    ('cliente_colgo',               0.225, [None]),  # 22.5% real Q1
    (None,                          0.305, [None]),  # VACIO 8.0% (NULL/vacío/sin cMenu)
    ('SinOpcion_Cabecera',          0.338, [None]),  # 3.3%
    ('Marque3',                     0.359, [None]),  # 2.1%

    # --- Desborde (16.2%) ---------------------------------------------------
    ('Desborde_Cabecera',           0.492, [         # 13.3% real Q1
        ('QJA_AB_DAT_1',0.149),('TELECOBRA',0.300),('TELVICOBRA',0.430),
        ('ECATEPEC',0.514),('QJA_AB_2',0.618),('MES_1',0.649),
        ('QJA_AB_3',0.703),('QJA_AB_VSI_1',0.743),('QJA_AB_VSI_2',0.783),
        ('QJA_AB_DAT_2',0.820),('MIGRAFTTH',0.833),('MES_2',0.848),
        ('QJA_AB_VOZ_1',0.860),('INCLUENCER',0.872),('ECATEPEC_FM',0.885),
        ('ECATEPEC_QJA',0.897),('RETCOMBO',0.907),('QJA_AB_VOZ_2',0.917),
        ('ONT_ECANCELA',0.927),('ECATEPEC_PORTA',0.937),
        ('QJA_ACAPULCO',0.947),('ANALAMCAN',0.955),('SABIVALLE',0.963),
        ('BUSTAVILLAL',0.970),('CASOSDG',0.977),('COD_SUSP_7',0.982),
        ('CLIENTESAPP',0.987),('MEGACABLE',0.990),('RETARGETING',0.993),
        ('QJA_AB_1',0.996),('BLACKLIST',0.998),(None,1.000),
    ]),
    ('Desborde_Promocional',        0.521, [None]),  # 2.9%

    # --- Fallas (22.5%) -----------------------------------------------------
    # RES-FallaInternet: 14.2% real Q1 (CORREGIDO — era 8%)
    ('RES-FallaInternet',           0.663, [
        ('DEFAULT',0.799),('NOBOT',0.870),('POSIBLE_FALLA_DSLAM_P',0.935),
        ('FM_CFE_P',0.952),('FM_ROBO_P',0.968),('FALLA_AMBAS_P',0.981),
        ('ADEUDO22222',0.987),('CECOR',0.993),('FALLA_CENTRAL_P',1.000),
    ]),
    # RES-FallasLinea: 2.9% real Q1 (CORREGIDO — era 4.9%)
    ('RES-FallasLinea',             0.692, [
        ('DEFAULT',0.917),('ML',0.941),('FM_CFE_P',0.957),
        ('FM_ROBO_P',0.971),('CECOR',0.979),('CASE_41',0.987),(None,1.000),
    ]),
    ('RES_FALLA_STOP',              0.714, [('DEFAULT',1.000)]),  # Q02+ 2.2%
    ('RES-Fallas_2024',             0.723, [('VSI',0.500),('DEFAULT',1.000)]),
    ('RES-FallaInternet_2024',      0.730, [('DEFAULT',1.000)]),
    ('RES-FallaEntretiene',         0.737, [('DEFAULT',0.770),('NOBOT',1.000)]),
    ('RES-FallaSegQja',             0.747, [
        ('DEFAULT',0.960),('QJA_AB_VOZ_2',0.970),
        ('QJA_AB_DAT_1',0.980),('QJA_AB_VSI_1',1.000),
    ]),

    # --- NOTMX — instalaciones y contrataciones (13.4%) --------------------
    # NOTMX-SeguimientoInstalacion: 9.9% real Q1 (CORREGIDO — era 7%)
    ('NOTMX-SeguimientoInstalacion',0.846, [('DEFAULT',1.000)]),
    ('NOTMX-CONT-Contratacion',     0.873, [('DEFAULT',1.000)]),  # 2.7%
    ('NOTMX-CONT-Portabilidad',     0.887, [('DEFAULT',1.000)]),  # 1.4%
    ('RES-SegInst_2024',            0.892, [('DEFAULT',1.000)]),  # Puebla

    # --- Saldos y Pagos (5.4%) ---------------------------------------------
    # RES-SaldooPagos: 4.1% real Q1 (CORREGIDO — era 3.2%)
    ('RES-SaldooPagos',             0.933, [('DEFAULT',1.000)]),
    ('RES-Saldos-WT',               0.942, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_2024',        0.945, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_FM',          0.947, [('DEFAULT',1.000)]),

    # --- MADT y Entr (5.3%) ------------------------------------------------
    # RES-MADT-Detalle 4.6%: prev=0.947, cum=0.947+0.046=0.993
    ('RES-MADT-Detalle',            0.993, [
        ('DEFAULT',0.917),('2L',0.975),('PQ_389',0.990),('CECOR',1.000),
    ]),
    # RES-Entr 0.8%: prev=0.993, cum=0.993+0.008=1.001 — los siguientes dividen el 0.7%
    ('RES-Entr',                    0.994, [
        ('DEFAULT',0.920),('NOBOT',0.960),('2L',1.000),
    ]),

    # --- Contrataciones (0.5% combinado — comparten la cola) --------------
    ('RES-ContratacionInfinitum_2024',0.995,[('DEFAULT',0.860),('2L',0.930),('CECOR',1.000)]),
    ('RES-ContratacionInfinitum_FM',  0.996,[('DEFAULT',1.000)]),
    ('RES-ContratacionInfinitum',     0.996,[
        ('DEFAULT',0.860),('2L',0.920),('CECOR',0.950),
        ('LAREDO',0.970),('PQ_389',0.985),('SUS_COM',1.000),
    ]),

    # --- Cambios (0.3%) ----------------------------------------------------
    ('RES_CambioDom',               0.997, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_Cambios',                 0.997, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_CambioTit',               0.997, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),

    # --- Anomalías cMENU_ERROR (1.2%) -------------------------------------
    # El SP de reporte normaliza estos como 'telefono_cMenu' (no MENU_10_NUMEROS)
    ('__CMENU_ERROR__',             0.997, [None]),

    # --- Menús de menor volumen (cola larga) --------------------------------
    ('RES_Otros',                   0.994, [('DEFAULT',0.910),('2L',0.960),('CECOR',1.000)]),
    ('RES-AsistenciaTelmexcom',     0.995, [('DEFAULT',1.000)]),
    ('MASI_RepiteBoleta',           0.995, [None]),
    ('NoTMX_SinOp',                 0.995, [None]),   # NOTMX_SINOP en el reporte (UPPER)
    ('Tmx_SOMO',                    0.995, [None]),
    ('RES-Aparatos',                0.995, [('DEFAULT',1.000)]),
    ('RES-Falla-AntivirusMcAfee',   0.996, [('DEFAULT',1.000)]),
    ('Numero Telmex',               0.996, [None]),   # Puebla Q02+, Nacional Q03+
    ('ANI',                         0.996, [None]),
    ('KIPSOLCOM',                   0.996, [None]),
    ('RES-DISH',                    0.997, [('DEFAULT',1.000)]),
    ('RES-SegurosInbursa',          0.997, [('DEFAULT',0.960),('CECOR',1.000)]),
    ('RES-TAE',                     0.997, [('DEFAULT',1.000)]),
    ('RES_OcultaVta',               0.997, [('DEFAULT',1.000)]),
    ('RES-Falla-Dish',              0.997, [('DEFAULT',1.000)]),
    ('RES-Falla-MVSHUB',            0.998, [('DEFAULT',1.000)]),
    ('RES-ClaroDrive',              0.998, [('DEFAULT',1.000)]),
    ('RES-StartGo',                 0.998, [('DEFAULT',1.000)]),
    ('RES-MADT-MVSHUB',             0.998, [('DEFAULT',1.000)]),
    ('MenuSaldosCabecera',          0.998, [None]),
    ('Saldos1_Pagar',               0.999, [None]),
    ('Saldos3_Otra',                0.999, [None]),
    ('SaldoCabecera',               0.999, [None]),
    ('RES_CAMBIODOMICILIO',         0.999, [('DEFAULT',1.000)]),
    ('default',                     1.000, [None]),   # DEFAULT: 5 registros Puebla Q02
]


VDN_POR_MENU = {
    'cliente_colgo':                 ('cliente_colgo', 1.0),
    None:                            [('cliente_colgo',0.80),('19020086',0.97),(None,1.0)],
    'SinOpcion_Cabecera':            [('19020086',1.0)],
    'Marque3':                       [('19020086',1.0)],
    'Desborde_Promocional':          [('19020086',1.0)],
    'NOTMX-SeguimientoInstalacion':  [('10728487',1.0)],
    'RES-SegInst_2024':              [('10728487',1.0)],
    'RES-FallaInternet':             [('10828091',0.49),('19010000',0.66),
                                      ('15070019',0.80),('10728000',0.90),('10828091',1.0)],
    'RES-FallaInternet_2024':        [('10828091',0.50),('15070019',1.0)],
    'RES-Fallas_2024':               [('10828091',0.50),('19010000',1.0)],
    'RES-FallasLinea':               [('19010000',0.70),('10828091',0.90),('10228051',1.0)],
    'RES_FALLA_STOP':                [('10928253',1.0)],
    'RES-FallaEntretiene':           [('19020033',0.60),('10728381',1.0)],
    'RES-FallaSegQja':               [('10928253',1.0)],
    'RES-MADT-Detalle':              [('15070013',0.80),('10928253',1.0)],
    'RES-MADT-MVSHUB':               [('15070013',1.0)],
    'NOTMX-CONT-Contratacion':       [('15070059',1.0)],
    'NOTMX-CONT-Portabilidad':       [('10728485',0.80),('14929014',1.0)],
    'RES-ContratacionInfinitum':     [('15070013',0.70),('15070006',0.88),('15070059',1.0)],
    'RES-ContratacionInfinitum_2024':[('15070013',0.70),('15070006',0.88),('15070059',1.0)],
    'RES-ContratacionInfinitum_FM':  [('15070013',0.70),('15070059',1.0)],
    'RES-SaldooPagos':               [('14929014',0.80),('15070013',1.0)],
    'RES-SaldosPagos_2024':          [('14929014',1.0)],
    'RES-SaldosPagos_FM':            [('14929014',1.0)],
    'RES-Saldos-WT':                 [('14929014',1.0)],
    'RES-Entr':                      [('10728382',0.70),('15070013',1.0)],
    'RES_CambioDom':                 [('15070012',0.70),('15070004',1.0)],
    'RES_Cambios':                   [('15070012',1.0)],
    'RES_CambioTit':                 [('15070012',1.0)],
    'RES-Aparatos':                  [('15070013',0.70),('15070007',1.0)],
}

def _vdn_default(menu):
    return [('19020086',0.30),('19010000',0.42),('10828091',0.54),
            ('10928253',0.64),('15070013',0.72),('10728487',0.79),
            ('14929014',0.85),('19020088',0.91),('309004',0.95),(None,1.0)]

ETIQUETAS = [None,'VIP','REGULAR','MOROSO','NUEVO','BAJA_RIESGO','RETENCION']
PESOS_ETQ  = [0.05,0.10,0.30,0.15,0.15,0.12,0.13]


# ===========================================================================
# GENERACIÓN DE REGISTROS
# ===========================================================================

def gen_phone():
    pref, digs = random.choices(PREFIJOS, weights=PESOS_PREFIJOS)[0]
    return pref + str(random.randint(0, 10**digs - 1)).zfill(digs)

def pick_from(tabla_acum):
    """Selecciona un valor de una tabla (valor, prob_acum)."""
    r = random.random()
    for val, cum in tabla_acum:
        if r < cum:
            return val
    return tabla_acum[-1][0]

def gen_menu_opcion():
    r = random.random()
    for nombre, cum, opciones in MENUS:
        if r < cum:
            if nombre == '__CMENU_ERROR__':
                # Anomalía: cMenu = número de teléfono (caso real de producción)
                return gen_phone(), None
            if opciones == [None]:
                return nombre, None
            op = pick_from(opciones)
            return nombre, op
    return None, None

def gen_vdn(menu):
    tabla = VDN_POR_MENU.get(menu)
    if tabla is None:
        tabla = _vdn_default(menu)
    if isinstance(tabla, tuple):
        return tabla[0]
    return pick_from(tabla)

def gen_registro(fecha_ini, fecha_fin, error_ceros=False):
    """
    Genera un registro que replica las condiciones de producción.

    error_ceros : True si el quarter/segmento puede generar CASO_ERROR_CEROS
                  (Puebla, Q02_25 en adelante). False para Q01_25.
    """
    dias = (fecha_fin - fecha_ini).days + 1
    fecha = fecha_ini + timedelta(days=random.randint(0, dias - 1))
    base  = datetime(fecha.year, fecha.month, fecha.day)

    # Horario 07:00-21:00 (main window)
    # ~0.3% de llamadas cruzan medianoche (23:45 → 00:05) — impacto mínimo
    h   = 7 * 3600 + random.randint(0, 50400)
    dur = random.randint(5, 895)
    ts_ini = base + timedelta(seconds=h)
    ts_fin = base + timedelta(seconds=h + dur)

    # Bug G-29: 38.8% de registros con dHoraInicio > dHoraFin
    if random.random() < P_HORAS_INVERTIDAS:
        ts_fin = base + timedelta(seconds=max(0, h - random.randint(5, 890)))

    # Segmento — DID de entrada
    did_opts = []
    cum = 0
    for s, w in SEGMENTOS:
        cum += w
        did_opts.append((s, cum))
    did = pick_from(did_opts)

    # Teléfonos (BR-CLIENT-001)
    tel_origen = gen_phone()
    r_tel = random.random()
    if r_tel < P_NULL:
        tel_digitado = None
    elif r_tel < P_NULL + P_MISMA:
        tel_digitado = tel_origen          # misma_linea: número A confirma su número
    else:
        tel_digitado = gen_phone()         # linea_diferente

    # Menú y opción
    menu, opcion = gen_menu_opcion()

    # VDN destino — puede ser sobreescrito por anomalías abajo
    centro_raw = gen_vdn(menu)

    # ---- Anomalías de cDID_Centro_Transferencia ----------------------------

    # CASO_ERROR_CEROS: solo Puebla, solo Q02+ (documentado en P-22)
    if (error_ceros
            and did == '19020084'          # solo Puebla
            and random.random() < P_ERROR_CEROS_PUEBLA):
        centro_raw = '0' * random.choice([7, 8])   # '0000000' o '00000000'

    # ERROR_CARACTER_INICIAL: carácter no numérico al inicio (muy raro, todos los quarters)
    elif (centro_raw
            and centro_raw not in ('cliente_colgo', None)
            and random.random() < P_ERROR_CARACTER):
        # Caracteres no numéricos observados en producción (errores de encoding/captura).
        # Solo ASCII imprimible — evitar byte nulo (\x00) que MariaDB rechaza en SQL.
        prefijo = random.choice(['@', ' ', '#', '!', 'E', 'X'])
        centro_raw = prefijo + (centro_raw[:6] if len(centro_raw) >= 6 else centro_raw)

    # NK90 — concatenar VDN + teléfono (BR-ROUTING-001)
    # Usar VDNs de 7 u 8 dígitos según proporciones reales:
    #   len_17 (7-dig VDN) = 94% de casos NK90
    #   len_16 (6-dig VDN) =  6% de casos NK90
    elif (centro_raw
            and centro_raw not in ('cliente_colgo',)
            and not centro_raw.startswith('0' * 4)   # no NK90 sobre CASO_ERROR_CEROS
            and tel_digitado
            and random.random() < P_NK90):
        if random.random() < P_NK90_LEN17_COND:
            # len_17: VDN de 7 dígitos + 10 dígitos de teléfono
            vdn_7 = random.choice(VDN_NK90_7DIG)
            centro_raw = vdn_7 + tel_digitado
        else:
            # len_16: VDN de 6 dígitos + 10 dígitos de teléfono
            vdn_6 = random.choice(VDN_NK90_6DIG)
            centro_raw = vdn_6 + tel_digitado

    # -----------------------------------------------------------------------

    etiqueta = random.choices(ETIQUETAS, weights=PESOS_ETQ)[0]

    return (fecha, ts_ini, ts_fin, did, centro_raw, menu, opcion,
            tel_origen, tel_digitado, etiqueta)


# ===========================================================================
# SQL
# ===========================================================================

COLS = ("(dFecha,dHoraInicio,dHoraFin,cDID_800Transfer,"
        "cDID_Centro_Transferencia,cMenu,cOpcion,"
        "cTelefono_Origen,cTelefono_Digitado,cEtiquetacliente)")

def q(v):
    if v is None:
        return 'NULL'
    return "'" + str(v).replace("\\","\\\\").replace("'","\\'") + "'"

def run_mysql(args, stmt=None, file_path=None):
    cmd = ['mysql'] + args + ['-N']
    if stmt:
        cmd += ['-e', stmt]
    if file_path:
        with open(file_path) as f:
            r = subprocess.run(cmd, stdin=f, capture_output=True, text=True)
    else:
        r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, r.stdout.strip(), r.stderr.strip()


# ===========================================================================
# TABLAS Y RANGOS
# ===========================================================================
#
# Factor de escala relativo a Q01_25 (base = 1.000).
# Refleja el volumen relativo real de producción por quarter.
#
# Fuente de los factores:
#   Q01_25: 11,643,679 registros reales  → base 1.000
#   Q02_25: 13,612,375 registros reales  → 1.169  (Q2 es el pico del año)
#   Q03_25: 11,482,117 registros reales  → 0.986
#   Q04_25: sin dato real                → 0.993  (estimado: promedio Q1+Q3)
#   Q01_26: sin dato real                → 1.000  (proxy Q01_25)
#   Q02_26: parcial 36/91 días           → 0.462  (Q02_25 × 36/91)
#
# Con --rows 50000 el script genera:
#   Q01_25: 50,000   Q02_25: ~58,450   Q03_25: ~49,300
#   Q04_25: ~49,650  Q01_26: ~50,000   Q02_26: ~23,125

TABLAS_CONFIG = [
    # (quarter, tabla, fecha_ini, fecha_fin, escala, error_ceros)
    # error_ceros: CASO_ERROR_CEROS aplica a Puebla Q02_25 en adelante.
    #              Ausente en Q01_25 (no se observó en datos reales de Q1).
    ('Q01_25', 'tbl_historico_t1_2025', date(2025, 1, 1),  date(2025, 3, 31),  1.000, False),
    ('Q02_25', 'tbl_historico_t2_2025', date(2025, 4, 1),  date(2025, 6, 30),  1.169, True),
    ('Q03_25', 'tbl_historico_t3_2025', date(2025, 7, 1),  date(2025, 9, 30),  0.986, True),
    ('Q04_25', 'tbl_historico_t4_2025', date(2025, 10, 1), date(2025, 12, 31), 0.993, True),
    ('Q01_26', 'tbl_historico_t1_2026', date(2026, 1, 1),  date(2026, 3, 31),  1.000, True),
    ('Q02_26', 'tbl_historico_t2_2026', date(2026, 4, 1),  date(2026, 5, 6),   0.462, True),
]


# ===========================================================================
# MAIN
# ===========================================================================

def parse_args():
    p = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    p.add_argument('--rows',     type=int,   default=50_000,
                   help='Registros a agregar por tabla completa (default: 50000)')
    p.add_argument('--tables',   nargs='+',  default=None,
                   help='Quarters a poblar, ej: Q01_25 Q02_25')
    p.add_argument('--chunk',    type=int,   default=200,
                   help='Tamaño del batch de INSERT (default: 200)')
    p.add_argument('--truncate', action='store_true',
                   help='TRUNCATE la tabla antes de insertar')
    p.add_argument('--status',   action='store_true',
                   help='Solo muestra estado actual, sin insertar')
    p.add_argument('--socket',   default='/run/mysqld/mysqld.sock')
    p.add_argument('--host',     default=None)
    p.add_argument('--port',     type=int,   default=3306)
    p.add_argument('--user',     default='django_user')
    p.add_argument('--password', default='django_pass')
    p.add_argument('--db',       default='ivr_legacy')
    return p.parse_args()


def build_conn_args(args):
    if args.host:
        return [f'-h{args.host}', f'-P{args.port}',
                f'-u{args.user}', f'-p{args.password}', args.db]
    return [f'--socket={args.socket}',
            f'-u{args.user}', f'-p{args.password}', args.db]


def estado_tabla(conn, tabla):
    code, out, _ = run_mysql(conn, stmt=f"""
        SELECT COUNT(*),
          SUM(CASE WHEN dHoraInicio > dHoraFin THEN 1 ELSE 0 END),
          SUM(CASE WHEN cTelefono_Digitado IS NULL THEN 1 ELSE 0 END),
          SUM(CASE WHEN cTelefono_Digitado = cTelefono_Origen THEN 1 ELSE 0 END)
        FROM {tabla}""")
    if code != 0 or not out:
        return None
    total, inv, null, misma = [int(x) for x in out.split('\t')]
    return dict(total=total, inv=inv, null=null, misma=misma)


def print_estado(q_name, tabla, st):
    if st is None:
        print(f"  {q_name:7}  {tabla:25}  ERROR: no se pudo leer")
        return
    n = st['total']
    if n == 0:
        print(f"  {q_name:7}  {tabla:25}  (vacía)")
        return
    inv_p  = st['inv']  / n * 100
    null_p = st['null'] / n * 100
    msm_p  = st['misma']/ n * 100
    dif_p  = 100 - null_p - msm_p
    err_inv  = math.sqrt(P_HORAS_INVERTIDAS * (1-P_HORAS_INVERTIDAS) / n) * 100
    print(f"  {q_name:7}  {tabla:25}  n={n:>7,}"
          f"  inv={inv_p:4.1f}%  null={null_p:4.1f}%"
          f"  msm={msm_p:4.1f}%  dif={dif_p:4.1f}%"
          f"  (σ_inv=±{err_inv:.2f}pp)")


def main():
    args    = parse_args()
    conn    = build_conn_args(args)

    # Verificar conexión
    code, _, err = run_mysql(conn, stmt="SELECT 1;")
    if code != 0:
        print(f"ERROR: Sin conexión — {err}")
        sys.exit(1)

    # Filtrar tablas
    tablas = TABLAS_CONFIG
    if args.tables:
        tablas = [t for t in TABLAS_CONFIG if t[0] in args.tables]
        if not tablas:
            print(f"ERROR: Ninguna tabla válida en {args.tables}")
            sys.exit(1)

    # Modo status
    print("=" * 70)
    print(f"  poblar_historico.py")
    if not args.status:
        print(f"  rows={args.rows:,}  chunk={args.chunk}  truncate={args.truncate}")
    print(f"  Objetivos: inv={P_HORAS_INVERTIDAS*100:.1f}%  "
          f"null={P_NULL*100:.1f}%  misma={P_MISMA*100:.1f}%")
    print(f"  NK90: len_17={P_NK90*P_NK90_LEN17_COND*100:.1f}%  "
          f"len_16={P_NK90*(1-P_NK90_LEN17_COND)*100:.1f}%  "
          f"CASO_ERROR_CEROS Puebla Q02+={P_ERROR_CEROS_PUEBLA*100:.1f}%")
    print("=" * 70)
    print(f"\n  {'Quarter':7}  {'Tabla':25}  {'Estado':>7}  "
          f"{'inv':>6}  {'null':>6}  {'msm':>5}  {'dif':>5}  σ_inv")
    print("  " + "-"*65)

    for q_name, tabla, d_ini, d_fin, escala, err_ceros in tablas:
        st = estado_tabla(conn, tabla)
        print_estado(q_name, tabla, st)

    if args.status:
        print("\n  Usa --rows N para agregar registros.")
        return

    # Poblar
    print()
    for q_name, tabla, d_ini, d_fin, escala, err_ceros in tablas:
        n_objetivo = max(1, round(args.rows * escala))
        print(f"\n  [{q_name}] {tabla} — generando {n_objetivo:,} registros"
              f"{' (CASO_ERROR_CEROS activo para Puebla)' if err_ceros else ''}...")

        if args.truncate:
            run_mysql(conn, stmt=f"TRUNCATE TABLE {tabla};")
            print(f"    TRUNCATE ejecutado")

        rows = [gen_registro(d_ini, d_fin, error_ceros=err_ceros)
                for _ in range(n_objetivo)]

        with tempfile.NamedTemporaryFile(mode='w', suffix='.sql', delete=False) as f:
            fname = f.name
            for i in range(0, len(rows), args.chunk):
                chunk = rows[i:i+args.chunk]
                vals  = ','.join(
                    f"({q(r[0])},{q(r[1])},{q(r[2])},{q(r[3])},{q(r[4])},"
                    f"{q(r[5])},{q(r[6])},{q(r[7])},{q(r[8])},{q(r[9])})"
                    for r in chunk
                )
                f.write(f"INSERT INTO {tabla} {COLS} VALUES {vals};\n")

        code, _, err = run_mysql(conn, file_path=fname)
        os.unlink(fname)

        if code == 0:
            st_post = estado_tabla(conn, tabla)
            if st_post:
                n = st_post['total']
                print(f"    OK — total en tabla: {n:,}")
                print_estado(q_name, tabla, st_post)
        else:
            print(f"    ERROR: {err[:200]}")

    print("\n" + "=" * 70)
    print("  Completado")
    print("=" * 70)


if __name__ == '__main__':
    main()
