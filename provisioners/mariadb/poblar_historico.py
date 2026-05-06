#!/usr/bin/env python3
"""
poblar_historico.py — Poblar tablas tbl_historico_t* con datos de producción calibrados

Genera e inserta registros que replican fielmente las distribuciones de producción
(menús, VDNs, proporciones de teléfono, bug G-29 de horas invertidas).

Al contrario de seed_historico_real.sql (que genera los primeros 10K registros),
este script está diseñado para añadir volumen incremental. Cuantos más registros,
menor el error estadístico de las distribuciones.

PROPORCIONES CALIBRADAS (datos reales Q1-Q3 2025, 36.7M llamadas):
    dHoraInicio > dHoraFin          38.8%  (bug G-29, MariaDB IVR del cliente)
    cTelefono_Digitado IS NULL       21.2%  (no_digito_telefono)
    Digitado = Origen (misma_linea)  28.2%  (número A llama y digita su mismo número)
    Digitado ≠ Origen (linea_dif)    50.6%

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

# Segmentos: DIDs de entrada con sus proporciones reales
SEGMENTOS = [
    ('19028031', 0.45),   # Nacional A — dominante
    ('19020001', 0.30),   # Nacional B
    ('19020084', 0.25),   # Puebla
]

# Menús con sus proporciones reales (Q1-Q3 2025)
# Formato: (nombre, probabilidad_acumulada, opciones_ponderadas)
MENUS = [
    # Abandono (35%)
    ('cliente_colgo',               0.220, [None]),
    (None,                          0.290, [None]),           # NULL/VACIO
    ('SinOpcion_Cabecera',          0.320, [None]),
    ('Marque3',                     0.340, [None]),
    # Desborde (16.4%)
    ('Desborde_Cabecera',           0.454, [
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
    ('Desborde_Promocional',        0.484, [None]),
    # Fallas (20.1%)
    ('RES-FallaInternet',           0.564, [
        ('DEFAULT',0.799),('NOBOT',0.870),('POSIBLE_FALLA_DSLAM_P',0.935),
        ('FM_CFE_P',0.952),('FM_ROBO_P',0.968),('FALLA_AMBAS_P',0.981),
        ('ADEUDO22222',0.987),('CECOR',0.993),('FALLA_CENTRAL_P',1.000),
    ]),
    ('RES-FallasLinea',             0.613, [
        ('DEFAULT',0.917),('ML',0.941),('FM_CFE_P',0.957),
        ('FM_ROBO_P',0.971),('CECOR',0.979),('CASE_41',0.987),(None,1.000),
    ]),
    ('RES_FALLA_STOP',              0.635, [('DEFAULT',1.000)]),
    ('RES-Fallas_2024',             0.648, [('VSI',0.500),('DEFAULT',1.000)]),
    ('RES-FallaInternet_2024',      0.657, [('DEFAULT',1.000)]),
    ('RES-FallaEntretiene',         0.666, [('DEFAULT',0.770),('NOBOT',1.000)]),
    ('RES-FallaSegQja',             0.675, [
        ('DEFAULT',0.960),('QJA_AB_VOZ_2',0.970),
        ('QJA_AB_DAT_1',0.980),('QJA_AB_VSI_1',1.000),
    ]),
    # NOTMX — instalaciones y contrataciones (14.1%)
    ('NOTMX-SeguimientoInstalacion',0.746, [('DEFAULT',1.000)]),
    ('NOTMX-CONT-Contratacion',     0.773, [('DEFAULT',1.000)]),
    ('NOTMX-CONT-Portabilidad',     0.787, [('DEFAULT',1.000)]),
    ('RES-SegInst_2024',            0.794, [('DEFAULT',1.000)]),
    # Saldos (5.5%)
    ('RES-SaldooPagos',             0.820, [('DEFAULT',1.000)]),
    ('RES-Saldos-WT',               0.832, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_2024',        0.838, [('DEFAULT',1.000)]),
    ('RES-SaldosPagos_FM',          0.843, [('DEFAULT',1.000)]),
    # MADT y Entr (6%)
    ('RES-MADT-Detalle',            0.865, [
        ('DEFAULT',0.917),('2L',0.975),('PQ_389',0.990),('CECOR',1.000),
    ]),
    ('RES-Entr',                    0.876, [
        ('DEFAULT',0.920),('NOBOT',0.960),('2L',1.000),
    ]),
    # Contrataciones (4%)
    ('RES-ContratacionInfinitum_2024',0.886,[('DEFAULT',0.860),('2L',0.930),('CECOR',1.000)]),
    ('RES-ContratacionInfinitum_FM',  0.892,[('DEFAULT',1.000)]),
    ('RES-ContratacionInfinitum',     0.895,[
        ('DEFAULT',0.860),('2L',0.920),('CECOR',0.950),
        ('LAREDO',0.970),('PQ_389',0.985),('SUS_COM',1.000),
    ]),
    # Cambios (1%)
    ('RES_CambioDom',               0.900, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_Cambios',                 0.904, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    ('RES_CambioTit',               0.907, [('DEFAULT',0.920),('2L',0.960),('CECOR',1.000)]),
    # Anomalías cMENU_ERROR (1.2%): cMenu = número de teléfono
    ('__CMENU_ERROR__',             0.919, [None]),
    # Resto
    ('RES_Otros',                   0.925, [('DEFAULT',0.910),('2L',0.960),('CECOR',1.000)]),
    ('RES-AsistenciaTelmexcom',     0.930, [('DEFAULT',1.000)]),
    ('MASI_RepiteBoleta',           0.934, [None]),
    ('NoTMX_SinOp',                 0.938, [None]),
    ('Tmx_SOMO',                    0.942, [None]),
    ('RES-Aparatos',                0.945, [('DEFAULT',1.000)]),
    ('RES-Falla-AntivirusMcAfee',   0.948, [('DEFAULT',1.000)]),
    ('Numero Telmex',               0.952, [None]),
    ('ANI',                         0.956, [None]),
    ('KIPSOLCOM',                   0.960, [None]),
    ('RES-DISH',                    0.963, [('DEFAULT',1.000)]),
    ('RES-SegurosInbursa',          0.966, [('DEFAULT',0.960),('CECOR',1.000)]),
    ('RES-TAE',                     0.968, [('DEFAULT',1.000)]),
    ('RES_OcultaVta',               0.970, [('DEFAULT',1.000)]),
    ('RES-Falla-Dish',              0.972, [('DEFAULT',1.000)]),
    ('RES-Falla-MVSHUB',            0.974, [('DEFAULT',1.000)]),
    ('RES-ClaroDrive',              0.976, [('DEFAULT',1.000)]),
    ('RES-StartGo',                 0.978, [('DEFAULT',1.000)]),
    ('RES-MADT-MVSHUB',             0.980, [('DEFAULT',1.000)]),
    ('MenuSaldosCabecera',          0.982, [None]),
    ('Saldos1_Pagar',               0.984, [None]),
    ('Saldos3_Otra',                0.986, [None]),
    ('RES_CAMBIODOMICILIO',         0.988, [('DEFAULT',1.000)]),
    ('RES-FallaInternet',           0.990, [('CECOR',0.500),('ACUNA',1.000)]),  # variante extra
    ('RES-Entr',                    0.992, [('2L',1.000)]),
    ('SaldoCabecera',               0.994, [None]),
    ('default',                     1.000, [None]),
]

# VDNs por menú (correspondencia real de producción)
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

def gen_registro(fecha_ini, fecha_fin):
    dias = (fecha_fin - fecha_ini).days + 1
    fecha = fecha_ini + timedelta(days=random.randint(0, dias - 1))
    base  = datetime(fecha.year, fecha.month, fecha.day)

    # Horario 07:00-21:00
    h   = 7 * 3600 + random.randint(0, 50400)
    dur = random.randint(5, 895)
    ts_ini = base + timedelta(seconds=h)
    ts_fin = base + timedelta(seconds=h + dur)

    # Bug G-29: 38.8% de registros con dHoraInicio > dHoraFin
    if random.random() < P_HORAS_INVERTIDAS:
        ts_fin = base + timedelta(seconds=h - random.randint(5, 890))

    # Segmento
    did = pick_from([(s, w) for s, w in SEGMENTOS])
    # Convertir a tabla de acumulados
    did_opts = []
    cum = 0
    for s, w in SEGMENTOS:
        cum += w
        did_opts.append((s, cum))
    did = pick_from(did_opts)

    # Teléfonos
    tel_origen = gen_phone()
    r_tel = random.random()
    if r_tel < P_NULL:
        tel_digitado = None
    elif r_tel < P_NULL + P_MISMA:
        tel_digitado = tel_origen          # misma_linea
    else:
        tel_digitado = gen_phone()         # linea_diferente

    # Menú y opción
    menu, opcion = gen_menu_opcion()

    # VDN destino
    centro_raw = gen_vdn(menu)

    # NK90: ~6.5% de registros con teléfono embebido en el VDN
    if (centro_raw and centro_raw != 'cliente_colgo'
            and tel_digitado and random.random() < 0.065):
        centro_raw = centro_raw + tel_digitado

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
    ('Q01_25', 'tbl_historico_t1_2025', date(2025, 1, 1),  date(2025, 3, 31),  1.000),
    ('Q02_25', 'tbl_historico_t2_2025', date(2025, 4, 1),  date(2025, 6, 30),  1.169),
    ('Q03_25', 'tbl_historico_t3_2025', date(2025, 7, 1),  date(2025, 9, 30),  0.986),
    ('Q04_25', 'tbl_historico_t4_2025', date(2025, 10, 1), date(2025, 12, 31), 0.993),
    ('Q01_26', 'tbl_historico_t1_2026', date(2026, 1, 1),  date(2026, 3, 31),  1.000),
    ('Q02_26', 'tbl_historico_t2_2026', date(2026, 4, 1),  date(2026, 5, 6),   0.462),
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
    print("=" * 70)
    print(f"\n  {'Quarter':7}  {'Tabla':25}  {'Estado':>7}  "
          f"{'inv':>6}  {'null':>6}  {'msm':>5}  {'dif':>5}  σ_inv")
    print("  " + "-"*65)

    for q_name, tabla, d_ini, d_fin, escala in tablas:
        st = estado_tabla(conn, tabla)
        print_estado(q_name, tabla, st)

    if args.status:
        print("\n  Usa --rows N para agregar registros.")
        return

    # Poblar
    print()
    for q_name, tabla, d_ini, d_fin, escala in tablas:
        n_objetivo = max(1, round(args.rows * escala))
        print(f"\n  [{q_name}] {tabla} — generando {n_objetivo:,} registros...")

        if args.truncate:
            run_mysql(conn, stmt=f"TRUNCATE TABLE {tabla};")
            print(f"    TRUNCATE ejecutado")

        total_insertado = 0
        rows = [gen_registro(d_ini, d_fin) for _ in range(n_objetivo)]

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
            total_insertado = n_objetivo
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
