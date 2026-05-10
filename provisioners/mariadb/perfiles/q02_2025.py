"""
Perfil Q02_2025 — Abril a Junio 2025

ACUMULADO: extiende q01_2025 con los menús y cambios de VDN de Q02.

Cambios respecto a Q01:
  NUEVOS menús: RES_FALLA_STOP (5.89%), NOTMX_SINOP (1.37%), MASI_RepiteBoleta (0.78%),
                RES-ContratacionInfinitum_FM (0.52%), Tmx_SOMO (Puebla), ANI (Puebla),
                Numero Telmex (Puebla), RES-SaldosPagos_FM
  CAMBIAN VDNs: NOTMX-CONT-Portabilidad (10728485→14929014),
                RES-ContratacionInfinitum_2024 (15070013→15070006 Puebla),
                RES-Aparatos (15070007→15070013),
                Desborde_Cabecera Nacional (cliente_colgo→10928253),
                Desborde_Cabecera Puebla  (10928253→10428174)
"""
from datetime import date
from perfiles.q01_2025 import VDN_POR_MENU as VDN_Q01

CONFIG = {
    'tabla':       'tbl_historico_t2_2025',
    'quarter':     'Q02_25',
    'fecha_ini':   date(2025, 4, 1),
    'fecha_fin':   date(2025, 6, 30),
    'escala':      1.169,     # 13,612,375 registros reales (pico del año)
    'error_ceros': True,      # CASO_ERROR_CEROS activo desde Q02 (Puebla ~3%)
}

# ---------------------------------------------------------------------------
# MENUS — distribución calibrada con prom_llamadas Q02_2025 (13.6M llamadas)
#
# Diferencias principales vs Q01:
#   RES_FALLA_STOP: NUEVO (5.89%) — entra como cuarto menú por volumen
#   NOTMX_SINOP:    NUEVO (1.37%)
#   MASI_RepiteBoleta: NUEVO (0.78%) — siempre va a cliente_colgo
# ---------------------------------------------------------------------------
MENUS = [
    # --- Abandono (33.3%) ---
    # CLIENTE_COLGO baja de 22.55% a 20.22% + Puebla 0.90% = 21.12%
    ('cliente_colgo',               0.211, [None]),
    # VACIO: 8.21% Nac + 0.44% Pue = 8.65%
    (None,                          0.298, [None]),
    # SinOpcion_Cabecera: 3.08% Nac + 0.29% Pue = 3.37%
    ('SinOpcion_Cabecera',          0.331, [None]),
    # Marque3: 1.90% Nac + 0.15% Pue = 2.05%
    ('Marque3',                     0.352, [None]),

    # --- Desborde (16.7%) ---
    # Desborde_Cabecera: 13.83% Nac + 1.01% Pue = 14.84%
    ('Desborde_Cabecera',           0.500, [
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
    # Desborde_Promocional: 2.81% Nac + 0.17% Pue = 2.98%
    ('Desborde_Promocional',        0.530, [None]),

    # --- NUEVO Q02: RES_FALLA_STOP (5.89% Nac + 0.45% Pue = 6.34%) ---
    ('RES_FALLA_STOP',              0.593, [('DEFAULT',1.000)]),

    # --- Fallas (11.5%) ---
    # RES-FallaInternet: 8.28% Nac
    ('RES-FallaInternet',           0.676, [
        ('DEFAULT',0.799),('NOBOT',0.870),('POSIBLE_FALLA_DSLAM_P',0.935),
        ('FM_CFE_P',0.952),('FM_ROBO_P',0.968),('FALLA_AMBAS_P',0.981),
        ('ADEUDO22222',0.987),('CECOR',0.993),('FALLA_CENTRAL_P',1.000),
    ]),
    # RES-FallasLinea: 2.11% Nac
    ('RES-FallasLinea',             0.697, [
        ('DEFAULT',0.917),('ML',0.941),('FM_CFE_P',0.957),
        ('FM_ROBO_P',0.971),('CECOR',0.979),('CASE_41',0.987),(None,1.000),
    ]),
    ('RES-Fallas_2024',             0.704, [('VSI',0.500),('DEFAULT',1.000)]),
    ('RES-FallaEntretiene',         0.711, [('DEFAULT',0.770),('NOBOT',1.000)]),
    ('RES-FallaSegQja',             0.720, [
        ('DEFAULT',0.960),('QJA_AB_VOZ_2',0.970),
        ('QJA_AB_DAT_1',0.980),('QJA_AB_VSI_1',1.000),
    ]),

    # --- NOTMX (11.9%) ---
    # NOTMX-SeguimientoInstalacion: 9.05% Nac + 0.29% Pue = 9.34%
    ('NOTMX-SeguimientoInstalacion',0.813, [('DEFAULT',1.000)]),
    # NOTMX-CONT-Contratacion: 2.49% Nac + 0.10% Pue = 2.59%
    ('NOTMX-CONT-Contratacion',     0.839, [('DEFAULT',1.000)]),
    # NOTMX-CONT-Portabilidad: 1.07% Nac + 0.03% Pue = 1.10%
    ('NOTMX-CONT-Portabilidad',     0.850, [('DEFAULT',1.000)]),
    ('RES-SegInst_2024',            0.854, [('DEFAULT',1.000)]),
    # NUEVO Q02: NOTMX_SINOP (1.37% Nac + 0.03% Pue = 1.40%)
    ('NoTMX_SinOp',                 0.868, [('DEFAULT',1.000)]),

    # --- NUEVO Q02: MASI_RepiteBoleta (0.78% Nac + 0.03% Pue = 0.81%) ---
    ('MASI_RepiteBoleta',           0.876, [None]),

    # --- Saldos (4.5%) ---
    ('RES-SaldooPagos',             0.910, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_2024',        0.913, [('DEFAULT',1.000)]),
    ('RES-Saldos-WT',               0.920, [('DEFAULT',1.000)]),
    # NUEVO Q02: RES-SaldosPagos_FM (0.08% Nac + 0.01% Pue)
    ('RES-SaldosPagos_FM',          0.921, [('DEFAULT',1.000)]),

    # --- MADT y Entr (5.2%) ---
    ('RES-MADT-Detalle',            0.960, [
        ('DEFAULT',0.917),('2L',0.975),('PQ_389',0.990),('CECOR',1.000),
    ]),
    ('RES-Entr',                    0.967, [
        ('DEFAULT',0.920),('NOBOT',0.960),('2L',1.000),
    ]),

    # --- Contrataciones (1.6%) ---
    # NUEVO Q02: RES-ContratacionInfinitum_FM (0.52% Nac + 0.05% Pue)
    ('RES-ContratacionInfinitum_FM',0.974, [('DEFAULT',1.000)]),
    ('RES-ContratacionInfinitum_2024',0.979,[('DEFAULT',0.860),('2L',0.930),('CECOR',1.000)]),
    ('RES-ContratacionInfinitum',     0.983,[
        ('DEFAULT',0.860),('2L',0.920),('CECOR',0.950),
        ('LAREDO',0.970),('PQ_389',0.985),('SUS_COM',1.000),
    ]),

    # --- Cambios (0.7%) ---
    ('RES_CambioDom',               0.989, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_Cambios',                 0.990, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_CambioTit',               0.990, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),

    # --- cMENU_ERROR (1.2%) ---
    ('__CMENU_ERROR__',             0.990, [None]),

    # --- Cola larga ---
    ('RES_Otros',                   0.991, [('DEFAULT',0.910),('2L',0.960),('CERCOR',1.000)]),
    ('RES-AsistenciaTelmexcom',     0.991, [('DEFAULT',1.000)]),
    ('RES-Aparatos',                0.992, [('DEFAULT',1.000)]),
    # NUEVOS Q02: Puebla
    ('Tmx_SOMO',                    0.992, [None]),
    ('ANI',                         0.993, [None]),
    ('Numero Telmex',               0.993, [None]),
    # Cola resto igual Q01
    ('RES-DISH',                    0.994, [('DEFAULT',1.000)]),
    ('RES-SegurosInbursa',          0.994, [('DEFAULT',0.960),('CERCOR',1.000)]),
    ('RES-TAE',                     0.994, [('DEFAULT',1.000)]),
    ('RES_OcultaVta',               0.994, [None]),
    ('RES-Falla-AntivirusMcAfee',   0.995, [('DEFAULT',1.000)]),
    ('RES-Falla-Dish',              0.995, [('DEFAULT',1.000)]),
    ('RES-Falla-MVSHUB',            0.995, [('DEFAULT',1.000)]),
    ('RES-ClaroDrive',              0.996, [('DEFAULT',1.000)]),
    ('RES-StartGo',                 0.996, [('DEFAULT',1.000)]),
    ('RES-MADT-MVSHUB',             0.997, [('DEFAULT',1.000)]),
    ('RES-MADT-Detalle',            0.999, [('CECOR',0.500),('ACUNA',1.000)]),
    ('RES-Entr',                    0.999, [('2L',1.000)]),
    ('default',                     1.000, [None]),
]

# ---------------------------------------------------------------------------
# VDN_POR_MENU — hereda de Q01 y aplica los cambios de Q02
# ---------------------------------------------------------------------------
VDN_POR_MENU = {
    **VDN_Q01,   # hereda todo de Q01
    # CAMBIOS de VDN en Q02:
    'NOTMX-CONT-Portabilidad':        [('14929014',1.0)],    # era 10728485
    'RES-ContratacionInfinitum_2024': [('15070006',1.0)],    # era 15070013 (Puebla)
    'RES-ContratacionInfinitum_FM':   [('15070006',1.0)],    # NUEVO Q02
    'RES-ContratacionInfinitum':      [('15070012',0.70),('15070006',0.88),('15070059',1.0)],  # cambia
    'RES-Aparatos':                   [('15070013',1.0)],    # era 15070007
    'RES-StartGo':                    [('15070006',1.0)],    # era 15070013
    # Desborde_Cabecera Q02: Nacional→10928253, Puebla→10428174
    'Desborde_Cabecera':              [('10928253',0.60),('10428174',0.85),(None,1.0)],
    'RES_Otros':                      [('15070002',1.0)],    # igual Q01
    # NUEVOS Q02:
    'RES_FALLA_STOP':                 [('19010000',1.0)],
    'NoTMX_SinOp':                    [('15070013',1.0)],
    'MASI_RepiteBoleta':              [('cliente_colgo',1.0)],
    'RES-SaldosPagos_FM':             [('309004',0.70),('14929014',1.0)],
    'Tmx_SOMO':                       [('14929961',1.0)],
    'ANI':                            [('19020086',0.50),(None,1.0)],   # 0 en Puebla
    'Numero Telmex':                  [('19020086',0.50),(None,1.0)],   # 0 en Puebla
}
