"""
Perfil Q01_2025 — Enero a Marzo 2025

BASE de la cadena de acumulación. Solo contiene los menús y VDNs
confirmados en datos reales de Q01_2025 (11.6M llamadas de producción).

Fuentes:
    prom_llamadas_Q1Q2Q3_2025.csv  — proporciones de menús
    c_menu_Q1Q2Q3_2025.csv         — VDNs dominantes por menú
    TBL-HISTORICO-ANOMALIAS.md     — condiciones de calidad
"""
from datetime import date

CONFIG = {
    'tabla':       'tbl_historico_t1_2025',
    'quarter':     'Q01_25',
    'fecha_ini':   date(2025, 1, 1),
    'fecha_fin':   date(2025, 3, 31),
    'escala':      1.000,     # base — 11,643,679 registros reales
    'error_ceros': False,     # CASO_ERROR_CEROS ausente en Q01 (aparece Q02+)
}

# ---------------------------------------------------------------------------
# MENUS — distribución calibrada con prom_llamadas Q01_2025 (11.6M llamadas)
#
# Formato: (nombre_raw, probabilidad_acumulada, opciones_ponderadas)
# nombre_raw: valor tal como está en tbl_historico — mixed case, sin UPPER()
# El SP de reporte aplica UPPER(TRIM()) — el dato fuente es mixed case.
#
# AUSENTES en Q01 (no agregar aquí):
#   RES_FALLA_STOP, MASI_RepiteBoleta, NoTMX_SinOp, RES-ContratacionInfinitum_FM
#   Tmx_SOMO, ANI (Puebla), Numero Telmex (Puebla), RES-SaldosPagos_FM
#   KIPSOLCOM, SaldoCabecera, Saldos1_Pagar, Saldos3_Otra, MenuSaldosCabecera
# ---------------------------------------------------------------------------
MENUS = [
    # --- Abandono (35.6%) ---
    # cliente_colgo 21.54% Nacional + 1.01% Puebla = 22.55% total
    ('cliente_colgo',               0.226, [None]),
    # NULL/vacío → VACIO: 7.68% Nac + 0.33% Pue = 8.01%
    (None,                          0.306, [None]),
    # SinOpcion_Cabecera: 3.11% Nac + 0.16% Pue = 3.27%
    ('SinOpcion_Cabecera',          0.339, [None]),
    # Marque3: 1.99% Nac + 0.12% Pue = 2.11%
    ('Marque3',                     0.360, [None]),

    # --- Desborde (16.2%) ---
    # Desborde_Cabecera: 13.01% Nac + 0.28% Pue = 13.29%
    ('Desborde_Cabecera',           0.493, [
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
    # Desborde_Promocional: 2.90% Nac + 0.03% Pue = 2.93%
    ('Desborde_Promocional',        0.522, [None]),

    # --- Fallas (17.9%) ---
    # RES-FallaInternet: 14.17% Nac + 0.10% Pue = 14.27%
    ('RES-FallaInternet',           0.665, [
        ('DEFAULT',0.799),('NOBOT',0.870),('POSIBLE_FALLA_DSLAM_P',0.935),
        ('FM_CFE_P',0.952),('FM_ROBO_P',0.968),('FALLA_AMBAS_P',0.981),
        ('ADEUDO22222',0.987),('CECOR',0.993),('FALLA_CENTRAL_P',1.000),
    ]),
    # RES-FallasLinea: 2.86% Nac
    ('RES-FallasLinea',             0.694, [
        ('DEFAULT',0.917),('ML',0.941),('FM_CFE_P',0.957),
        ('FM_ROBO_P',0.971),('CECOR',0.979),('CASE_41',0.987),(None,1.000),
    ]),
    # Puebla: RES-Fallas_2024 0.94% + RES-FallaInternet_2024 0.10%
    ('RES-Fallas_2024',             0.703, [('VSI',0.500),('DEFAULT',1.000)]),
    ('RES-FallaInternet_2024',      0.704, [('DEFAULT',1.000)]),
    ('RES-FallaEntretiene',         0.711, [('DEFAULT',0.770),('NOBOT',1.000)]),
    ('RES-FallaSegQja',             0.721, [
        ('DEFAULT',0.960),('QJA_AB_VOZ_2',0.970),
        ('QJA_AB_DAT_1',0.980),('QJA_AB_VSI_1',1.000),
    ]),

    # --- NOTMX (11.4%) ---
    # NOTMX-SeguimientoInstalacion: 9.52% Nac + 0.35% Pue = 9.87%
    ('NOTMX-SeguimientoInstalacion',0.820, [('DEFAULT',1.000)]),
    # NOTMX-CONT-Contratacion: 2.54% Nac + 0.14% Pue = 2.68%
    ('NOTMX-CONT-Contratacion',     0.847, [('DEFAULT',1.000)]),
    # NOTMX-CONT-Portabilidad: 1.33% Nac + 0.05% Pue = 1.38%
    ('NOTMX-CONT-Portabilidad',     0.861, [('DEFAULT',1.000)]),
    # RES-SegInst_2024: 0.047% (solo Puebla)
    ('RES-SegInst_2024',            0.861, [('DEFAULT',1.000)]),

    # --- Saldos (5.3%) ---
    # RES-SaldooPagos: 4.13% Nac + 0.00% Pue
    ('RES-SaldooPagos',             0.902, [('DEFAULT',1.000)]),
    # RES-SaldosPagos_2024: 0.34% (solo Puebla)
    ('RES-SaldosPagos_2024',        0.906, [('DEFAULT',1.000)]),
    ('RES-Saldos-WT',               0.915, [('DEFAULT',1.000)]),

    # --- MADT y Entr (5.3%) ---
    ('RES-MADT-Detalle',            0.962, [
        ('DEFAULT',0.917),('2L',0.975),('PQ_389',0.990),('CECOR',1.000),
    ]),
    ('RES-Entr',                    0.969, [
        ('DEFAULT',0.920),('NOBOT',0.960),('2L',1.000),
    ]),

    # --- Contrataciones (1.5%) ---
    ('RES-ContratacionInfinitum_2024',0.975,[('DEFAULT',0.860),('2L',0.930),('CECOR',1.000)]),
    ('RES-ContratacionInfinitum',     0.980,[
        ('DEFAULT',0.860),('2L',0.920),('CECOR',0.950),
        ('LAREDO',0.970),('PQ_389',0.985),('SUS_COM',1.000),
    ]),

    # --- Cambios y administración (0.9%) ---
    ('RES_CambioDom',               0.988, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_Cambios',                 0.989, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_CambioTit',               0.990, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),

    # --- cMENU_ERROR (1.2%) ---
    # El SP normaliza estos como 'telefono_cMenu' (reporte c_menu los enruta a 19020086)
    ('__CMENU_ERROR__',             0.990, [None]),

    # --- Cola larga (<0.9% cada uno) ---
    ('RES_Otros',                   0.991, [('DEFAULT',0.910),('2L',0.960),('CECOR',1.000)]),
    ('RES-AsistenciaTelmexcom',     0.991, [('DEFAULT',1.000)]),
    ('RES-Aparatos',                0.991, [('DEFAULT',1.000)]),
    ('RES-DISH',                    0.992, [('DEFAULT',1.000)]),
    ('RES-SegurosInbursa',          0.992, [('DEFAULT',0.960),('CECOR',1.000)]),
    ('RES-TAE',                     0.992, [('DEFAULT',1.000)]),
    ('RES_OcultaVta',               0.992, [None]),
    ('RES-Falla-AntivirusMcAfee',   0.993, [('DEFAULT',1.000)]),
    ('RES-Falla-Dish',              0.993, [('DEFAULT',1.000)]),
    ('RES-Falla-MVSHUB',            0.993, [('DEFAULT',1.000)]),
    ('RES-ClaroDrive',              0.994, [('DEFAULT',1.000)]),
    ('RES-StartGo',                 0.994, [('DEFAULT',1.000)]),
    ('RES-MADT-MVSHUB',             0.994, [('DEFAULT',1.000)]),
    ('RES-MADT-Detalle',            0.997, [('CECOR',0.500),('ACUNA',1.000)]),
    ('RES-Entr',                    0.998, [('2L',1.000)]),
    ('NOTMX-CONT-Portabilidad',     0.999, [('DEFAULT',1.000)]),
    ('default',                     1.000, [None]),
]

# ---------------------------------------------------------------------------
# VDN_POR_MENU — destino dominante por menú (c_menu Q01_2025)
#
# Formato: (vdn, prob_acum) o (vdn,) como tupla si es único
# VDNs NK90 (len>10) son válidos — el seed los genera directamente.
# ---------------------------------------------------------------------------
VDN_POR_MENU = {
    'cliente_colgo':                  ('cliente_colgo',),
    None:                             [('cliente_colgo',0.80),('19020086',0.97),(None,1.0)],
    'SinOpcion_Cabecera':             [('19020086',1.0)],
    'Marque3':                        [('19020086',1.0)],
    # Desborde_Cabecera Q01: Nacional → cliente_colgo, Puebla → 10928253
    'Desborde_Cabecera':              [('cliente_colgo',0.75),('10928253',1.0)],
    'Desborde_Promocional':           [('19020086',1.0)],
    'NOTMX-SeguimientoInstalacion':   [('10728487',1.0)],
    'NOTMX-CONT-Contratacion':        [('15070059',1.0)],
    'NOTMX-CONT-Portabilidad':        [('10728485',1.0)],     # Q01 usa 10728485
    'RES-SegInst_2024':               [('10728487',1.0)],
    'RES-FallaInternet':              [('10828091',0.49),('19010000',0.66),
                                       ('15070019',0.80),('10728000',0.90),('10828091',1.0)],
    'RES-FallaInternet_2024':         [('10828091',1.0)],
    'RES-Fallas_2024':                [('10828091',1.0)],
    'RES-FallasLinea':                [('15070019',0.70),('10828091',0.90),('10228051',1.0)],
    'RES-FallaEntretiene':            [('19020033',1.0)],     # Q01 usa 19020033
    'RES-FallaSegQja':                [('10928253',1.0)],
    'RES-MADT-Detalle':               [('15070013',0.80),('10928253',1.0)],
    'RES-MADT-MVSHUB':                [('10828073',1.0)],
    'RES-SaldooPagos':                [('14929014',0.60),('1309004',0.80),('14929014',1.0)],
    'RES-SaldosPagos_2024':           [('309004',0.70),('14929014',1.0)],
    'RES-Saldos-WT':                  [('14929014',0.70),('1309004',1.0)],
    'RES-ContratacionInfinitum_2024': [('15070013',1.0)],     # Q01 Puebla usa 15070013
    'RES-ContratacionInfinitum':      [('15070013',0.70),('15070006',0.88),('15070059',1.0)],
    'RES_CambioDom':                  [('15070004',1.0)],
    'RES_Cambios':                    [('10628002',1.0)],
    'RES_CambioTit':                  [('15070071',1.0)],
    'RES_OcultaVta':                  [('cliente_colgo',1.0)],  # siempre abandono
    'RES_Otros':                      [('15070002',1.0)],        # Q01 usa 15070002
    'RES-AsistenciaTelmexcom':        [('10728009',1.0)],
    'RES-Aparatos':                   [('15070007',1.0)],        # Q01 usa 15070007
    'RES-Entr':                       [('10728382',1.0)],
    'RES-DISH':                       [('10728494',1.0)],
    'RES-SegurosInbursa':             [('10728493',1.0)],
    'RES-TAE':                        [('14929014',0.60),('1309010',1.0)],
    'RES-Falla-AntivirusMcAfee':      [('10928137',1.0)],
    'RES-Falla-Dish':                 [('10928137',0.50),('10728494',1.0)],
    'RES-Falla-MVSHUB':               [('14928960',1.0)],
    'RES-ClaroDrive':                 [('15070006',1.0)],
    'RES-StartGo':                    [('15070013',1.0)],
}
