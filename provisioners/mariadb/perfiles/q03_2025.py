"""
Perfil Q03_2025 — Julio a Septiembre 2025

ACUMULADO: extiende q02_2025 con los menús y cambios de VDN de Q03.

Cambios respecto a Q02:
  NUEVOS menús: KIPSOLCOM (0.32%), SaldoCabecera (Puebla), Saldos1_Pagar,
                Saldos3_Otra, MenuSaldosCabecera (Puebla), ANI/Numero Telmex → Nacional
  CAMBIAN VDNs: NOTMX-SeguimientoInstalacion (10728487→19020088),
                RES-FallaEntretiene (19020033→10728381),
                RES-ContratacionInfinitum (15070012→15070006),
                RES_Otros (15070002→15070012),
                Desborde_Cabecera Nacional (10928253→cliente_colgo),
                Desborde_Cabecera Puebla (10428174→15070013)

Nota: Nacional B tiene volumen residual en Q03 (evento operativo).
"""
from datetime import date
from perfiles.q02_2025 import VDN_POR_MENU as VDN_Q02

CONFIG = {
    'tabla':       'tbl_historico_t3_2025',
    'quarter':     'Q03_25',
    'fecha_ini':   date(2025, 7, 1),
    'fecha_fin':   date(2025, 9, 30),
    'escala':      0.986,     # 11,482,117 registros reales
    'error_ceros': True,
}

MENUS = [
    # --- Abandono (32.2%) ---
    # CLIENTE_COLGO baja a 17.06% Nac + 0.44% Pue = 17.50%
    ('cliente_colgo',               0.175, [None]),
    # VACIO: 8.68% Nac + 0.38% Pue = 9.06%
    (None,                          0.266, [None]),
    # SinOpcion_Cabecera: 3.69% Nac + 0.33% Pue = 4.02%
    ('SinOpcion_Cabecera',          0.306, [None]),
    # Marque3: 1.97% Nac + 0.13% Pue = 2.10%
    ('Marque3',                     0.327, [None]),

    # --- Desborde (16.2%) ---
    # Desborde_Cabecera: 13.22% Nac + 0.46% Pue = 13.68%
    ('Desborde_Cabecera',           0.464, [
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
    # Desborde_Promocional: 2.98% Nac + 0.12% Pue = 3.10%
    ('Desborde_Promocional',        0.495, [None]),

    # --- RES_FALLA_STOP — crece en Q03 (8.69% Nac + 0.42% Pue = 9.11%) ---
    ('RES_FALLA_STOP',              0.586, [('DEFAULT',1.000)]),

    # --- Fallas (8.6%) ---
    # RES-FallaInternet baja a 5.85% Nac (sin versión 2024 relevante en Q03)
    ('RES-FallaInternet',           0.645, [
        ('DEFAULT',0.799),('NOBOT',0.870),('POSIBLE_FALLA_DSLAM_P',0.935),
        ('FM_CFE_P',0.952),('FM_ROBO_P',0.968),('FALLA_AMBAS_P',0.981),
        ('ADEUDO22222',0.987),('CECOR',0.993),('FALLA_CENTRAL_P',1.000),
    ]),
    # RES-FallasLinea: 1.98% Nac
    ('RES-FallasLinea',             0.665, [
        ('DEFAULT',0.917),('ML',0.941),('FM_CFE_P',0.957),
        ('FM_ROBO_P',0.971),('CECOR',0.979),('CASE_41',0.987),(None,1.000),
    ]),
    ('RES-Fallas_2024',             0.672, [('VSI',0.500),('DEFAULT',1.000)]),
    ('RES-FallaEntretiene',         0.679, [('DEFAULT',0.770),('NOBOT',1.000)]),
    ('RES-FallaSegQja',             0.685, [
        ('DEFAULT',0.960),('QJA_AB_VOZ_2',0.970),
        ('QJA_AB_DAT_1',0.980),('QJA_AB_VSI_1',1.000),
    ]),

    # --- NOTMX (12.2%) ---
    # NOTMX-SeguimientoInstalacion crece: 9.72% Nac + 0.25% Pue = 9.97%
    ('NOTMX-SeguimientoInstalacion',0.785, [('DEFAULT',1.000)]),
    ('NOTMX-CONT-Contratacion',     0.810, [('DEFAULT',1.000)]),
    ('NOTMX-CONT-Portabilidad',     0.821, [('DEFAULT',1.000)]),
    ('RES-SegInst_2024',            0.824, [('DEFAULT',1.000)]),
    ('NoTMX_SinOp',                 0.839, [('DEFAULT',1.000)]),
    ('MASI_RepiteBoleta',           0.850, [None]),

    # NUEVO Q03: KIPSOLCOM (0.32% Nac + 0.02% Pue = 0.34%)
    ('KIPSOLCOM',                   0.853, [('DEFAULT',1.000)]),

    # --- Saldos (5.0%) ---
    ('RES-SaldooPagos',             0.888, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_2024',        0.891, [('DEFAULT',1.000)]),
    ('RES-Saldos-WT',               0.896, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_FM',          0.897, [('DEFAULT',1.000)]),
    # NUEVOS Q03: menús de saldo (Puebla dominante)
    ('SaldoCabecera',               0.897, [None]),
    ('Saldos1_Pagar',               0.897, [None]),
    ('Saldos3_Otra',                0.898, [None]),
    ('MenuSaldosCabecera',          0.898, [None]),

    # --- MADT y Entr (5.2%) ---
    ('RES-MADT-Detalle',            0.940, [
        ('DEFAULT',0.917),('2L',0.975),('PQ_389',0.990),('CECOR',1.000),
    ]),
    ('RES-Entr',                    0.947, [
        ('DEFAULT',0.920),('NOBOT',0.960),('2L',1.000),
    ]),

    # --- Contrataciones (1.5%) ---
    ('RES-ContratacionInfinitum_FM',0.955, [('DEFAULT',1.000)]),
    ('RES-ContratacionInfinitum_2024',0.960,[('DEFAULT',0.860),('2L',0.930),('CECOR',1.000)]),
    ('RES-ContratacionInfinitum',   0.963, [
        ('DEFAULT',0.860),('2L',0.920),('CERCOR',0.950),
        ('LAREDO',0.970),('PQ_389',0.985),('SUS_COM',1.000),
    ]),

    # --- Número Telmex / ANI — ahora también en Nacional ---
    ('ANI',                         0.967, [None]),
    ('Numero Telmex',               0.970, [None]),

    # --- Cambios (0.7%) ---
    ('RES_CambioDom',               0.977, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_Cambios',                 0.977, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_CambioTit',               0.978, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),

    # --- cMENU_ERROR (1.2%) ---
    ('__CMENU_ERROR__',             0.978, [None]),

    # --- Cola larga ---
    ('RES_Otros',                   0.979, [('DEFAULT',0.910),('2L',0.960),('CECOR',1.000)]),
    ('RES-AsistenciaTelmexcom',     0.980, [('DEFAULT',1.000)]),
    ('RES-Aparatos',                0.980, [('DEFAULT',1.000)]),
    ('Tmx_SOMO',                    0.981, [None]),
    ('RES-DISH',                    0.982, [('DEFAULT',1.000)]),
    ('RES-SegurosInbursa',          0.982, [('DEFAULT',0.960),('CECOR',1.000)]),
    ('RES-TAE',                     0.983, [('DEFAULT',1.000)]),
    ('RES_OcultaVta',               0.983, [None]),
    ('RES-Falla-AntivirusMcAfee',   0.984, [('DEFAULT',1.000)]),
    ('RES-Falla-Dish',              0.984, [('DEFAULT',1.000)]),
    ('RES-Falla-MVSHUB',            0.985, [('DEFAULT',1.000)]),
    ('RES-ClaroDrive',              0.985, [('DEFAULT',1.000)]),
    ('RES-StartGo',                 0.985, [('DEFAULT',1.000)]),
    ('RES-MADT-MVSHUB',             0.986, [('DEFAULT',1.000)]),
    ('RES-MADT-Detalle',            0.998, [('CECOR',0.500),('ACUNA',1.000)]),
    ('RES-Entr',                    0.999, [('2L',1.000)]),
    ('default',                     1.000, [None]),
]

# ---------------------------------------------------------------------------
# VDN_POR_MENU — hereda de Q02 y aplica los cambios de Q03
# ---------------------------------------------------------------------------
VDN_POR_MENU = {
    **VDN_Q02,
    # CAMBIOS de VDN en Q03:
    'NOTMX-SeguimientoInstalacion':   [('19020088',1.0)],    # era 10728487
    'RES-FallaEntretiene':            [('10728381',1.0)],    # era 19020033
    'RES-ContratacionInfinitum':      [('15070006',1.0)],    # era 15070012
    'RES_Otros':                      [('15070012',1.0)],    # era 15070002
    'RES-Aparatos':                   [('15070007',1.0)],    # vuelve a Q01
    # Desborde_Cabecera Q03: Nacional→cliente_colgo, Puebla→15070013
    'Desborde_Cabecera':              [('cliente_colgo',0.68),('15070013',1.0)],
    # ANI y Numero Telmex ahora también en Nacional → 19020086
    'ANI':                            [('19020086',1.0)],
    'Numero Telmex':                  [('19020086',1.0)],
    # NUEVOS Q03:
    'KIPSOLCOM':                      [('10928357',1.0)],
    'SaldoCabecera':                  [(None,1.0)],           # VDN=0 en producción
    'Saldos1_Pagar':                  [('14928994',1.0)],
    'Saldos3_Otra':                   [('14928994',0.60),(None,1.0)],
    'MenuSaldosCabecera':             [(None,1.0)],           # VDN=0 en producción
}
