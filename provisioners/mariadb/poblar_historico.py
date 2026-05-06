#!/usr/bin/env python3
"""
poblar_historico.py — Motor de generación de registros para tbl_historico_t*

Genera e inserta registros que replican las condiciones de producción del
sistema IVR. La distribución de menús y los VDNs de destino se cargan desde
perfiles de quarter, lo que permite representar fielmente los cambios en el
catálogo IVR entre trimestres.

ARQUITECTURA — Perfiles por quarter (perfiles/):
    q01_2025.py   BASE: solo menús confirmados en Q01_2025
    q02_2025.py   ACUMULADO q01 + menús nuevos Q02 + cambios de VDN
    q03_2025.py   ACUMULADO q02 + menús nuevos Q03 + cambios de VDN
    q04_2025.py   PROXY de q03 (sin datos reales de Q04)
    q01_2026.py   PROXY de q01_2025
    q02_2026.py   PROXY de q02_2025 (quarter parcial, 36/91 días)

CONDICIONES DE CALIDAD REPLICADAS (ver TBL-HISTORICO-ANOMALIAS.md):
    G-29  dHoraInicio > dHoraFin          38.8%
          cTelefono_Digitado IS NULL       21.2%
          Digitado = Origen (misma_linea)  28.2%
    NK90  len_17 (VDN 7dig + tel 10dig)    5.3%
    NK90  len_16 (VDN 6dig + tel 10dig)    0.3%
    CASO_NULL  cDID_Centro NULL/vacío       1.3%
    CLIENTE_COLGO en cDID_Centro          27.4%
    CASO_ERROR_CEROS (Puebla, Q02+)        3.0% de Puebla
    ERROR_CARACTER_INICIAL                 0.05%
    cMENU_ERROR  teléfono en cMenu         1.2%

USO:
    # Estado actual de las tablas
    python3 poblar_historico.py --status

    # Agregar 50K registros por tabla (escala proporcional entre quarters)
    python3 poblar_historico.py --rows 50000

    # Solo Q01 y Q02, con TRUNCATE
    python3 poblar_historico.py --tables Q01_25 Q02_25 --truncate --rows 100000

ARGUMENTOS:
    --rows N        Base de registros para Q01_25 (default: 50000). Cada quarter
                    se escala según su factor real de producción.
    --tables Q...   Quarters a poblar, ej: Q01_25 Q02_25 (default: todos)
    --chunk N       Tamaño del batch INSERT (default: 200)
    --truncate      TRUNCATE la tabla antes de insertar
    --status        Solo muestra estado actual, sin insertar
    --socket PATH   Socket MariaDB (default: /run/mysqld/mysqld.sock)
    --host HOST     Host (alternativa a socket)
    --port PORT     Puerto (default: 3306)
    --user USER     (default: django_user)
    --password PWD  (default: django_pass)
    --db DB         (default: ivr_legacy)
"""

import argparse
import math
import random
import subprocess
import sys
import tempfile
import os
from datetime import date, datetime, timedelta

# Cargar todos los perfiles
sys.path.insert(0, os.path.dirname(__file__))
from perfiles import PERFILES

# ===========================================================================
# CONSTANTES GLOBALES DE CALIDAD DE DATOS
# (no dependen del quarter — son del sistema IVR del cliente)
# ===========================================================================

P_NULL               = 0.212   # cTelefono_Digitado IS NULL (BR-CLIENT-001)
P_MISMA              = 0.282   # misma_linea: Digitado = Origen
P_MISMA_GIVEN_NOTNULL = P_MISMA / (1 - P_NULL)
P_HORAS_INVERTIDAS   = 0.388   # dHoraInicio > dHoraFin (bug G-29)
P_ERROR_CEROS_PUEBLA = 0.030   # CASO_ERROR_CEROS, solo Puebla Q02+
P_ERROR_CARACTER     = 0.0005  # ERROR_CARACTER_INICIAL
P_NK90               = 0.099   # NK90 total (compensado por elegibles ~57%)
P_NK90_LEN17_COND    = 0.94    # dado NK90, 94% son len_17

VDN_NK90_7DIG = ['1309004', '1308066', '1307200', '1907000', '1308100']
VDN_NK90_6DIG = ['309004']

# DID de entrada → etiqueta de segmento (MAPEO-DID-SEGMENTOS.md)
SEGMENTOS = [
    # (DID, prob_acumulada, etiqueta)
    ('19028031', 0.45, 'nacional_A'),
    ('19020001', 0.75, 'nacional_B'),
    ('19020084', 1.00, 'puebla'),
]

PREFIJOS = [
    ('443',7),('722',7),('222',7),('55',8),('333',7),('81',8),
    ('998',7),('664',7),('618',7),('614',7),('771',7),('442',7),
    ('477',7),('462',7),
]
PESOS_PREFIJOS = [0.15,0.12,0.10,0.18,0.08,0.07,
                  0.05,0.04,0.03,0.03,0.04,0.04,0.04,0.03]

ETIQUETAS = [None,'VIP','REGULAR','MOROSO','NUEVO','BAJA_RIESGO','RETENCION']
PESOS_ETQ  = [0.05,0.10,0.30,0.15,0.15,0.12,0.13]

COLS = ("(dFecha,dHoraInicio,dHoraFin,cDID_800Transfer,"
        "cDID_Centro_Transferencia,cMenu,cOpcion,"
        "cTelefono_Origen,cTelefono_Digitado,cEtiquetacliente)")

# ===========================================================================
# FUNCIONES DE GENERACIÓN
# ===========================================================================

def gen_phone():
    pref, digs = random.choices(PREFIJOS, weights=PESOS_PREFIJOS)[0]
    return pref + str(random.randint(0, 10**digs - 1)).zfill(digs)

def pick_from(tabla_acum):
    r = random.random()
    for val, cum in tabla_acum:
        if r < cum:
            return val
    return tabla_acum[-1][0]

def gen_menu_opcion(menus_perfil):
    r = random.random()
    for nombre, cum, opciones in menus_perfil:
        if r < cum:
            if nombre == '__CMENU_ERROR__':
                return gen_phone(), None
            if opciones == [None]:
                return nombre, None
            op = pick_from(opciones)
            return nombre, op
    return None, None

def gen_vdn(menu, vdn_perfil):
    tabla = vdn_perfil.get(menu)
    if tabla is None:
        # Default pool: bucket de abandono + VDNs comunes
        tabla = [('19020086',0.30),('19010000',0.42),('10828091',0.54),
                 ('10928253',0.64),('15070013',0.72),('10728487',0.79),
                 ('14929014',0.85),('19020088',0.91),('309004',0.95),(None,1.0)]
    if isinstance(tabla, tuple):
        return tabla[0]
    return pick_from(tabla)

def gen_registro(fecha_ini, fecha_fin, menus_perfil, vdn_perfil, error_ceros=False):
    dias  = (fecha_fin - fecha_ini).days + 1
    fecha = fecha_ini + timedelta(days=random.randint(0, dias - 1))
    base  = datetime(fecha.year, fecha.month, fecha.day)

    h   = 7 * 3600 + random.randint(0, 50400)   # 07:00–21:00
    dur = random.randint(5, 895)
    ts_ini = base + timedelta(seconds=h)
    ts_fin = base + timedelta(seconds=h + dur)

    # Bug G-29
    if random.random() < P_HORAS_INVERTIDAS:
        ts_fin = base + timedelta(seconds=max(0, h - random.randint(5, 890)))

    # Segmento (DID de entrada)
    r_seg = random.random()
    did = '19020084'
    for d, cum, _ in SEGMENTOS:
        if r_seg < cum:
            did = d
            break

    # Teléfonos (BR-CLIENT-001)
    tel_origen = gen_phone()
    r_tel = random.random()
    if r_tel < P_NULL:
        tel_digitado = None
    elif r_tel < P_NULL + P_MISMA:
        tel_digitado = tel_origen
    else:
        tel_digitado = gen_phone()

    # Menú y opción (desde el perfil del quarter)
    menu, opcion = gen_menu_opcion(menus_perfil)

    # VDN destino (desde el perfil del quarter)
    centro_raw = gen_vdn(menu, vdn_perfil)

    # Anomalías de cDID_Centro_Transferencia
    if (error_ceros and did == '19020084'
            and random.random() < P_ERROR_CEROS_PUEBLA):
        centro_raw = '0' * random.choice([7, 8])
    elif (centro_raw and centro_raw not in ('cliente_colgo', None)
            and random.random() < P_ERROR_CARACTER):
        prefijo = random.choice(['@', ' ', '#', '!', 'E', 'X'])
        centro_raw = prefijo + (centro_raw[:6] if len(centro_raw) >= 6 else centro_raw)
    elif (centro_raw and centro_raw not in ('cliente_colgo',)
            and not (isinstance(centro_raw, str) and centro_raw.startswith('0'*4))
            and tel_digitado and random.random() < P_NK90):
        if random.random() < P_NK90_LEN17_COND:
            centro_raw = random.choice(VDN_NK90_7DIG) + tel_digitado
        else:
            centro_raw = random.choice(VDN_NK90_6DIG) + tel_digitado

    etiqueta = random.choices(ETIQUETAS, weights=PESOS_ETQ)[0]

    return (fecha, ts_ini, ts_fin, did, centro_raw, menu, opcion,
            tel_origen, tel_digitado, etiqueta)

# ===========================================================================
# SQL
# ===========================================================================

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

def print_estado(quarter, tabla, st, perfil_menus):
    if st is None:
        print(f"  {quarter:7}  {tabla:25}  ERROR")
        return
    n = st['total']
    perfil_tag = f"[{len(perfil_menus)}menus]"
    if n == 0:
        print(f"  {quarter:7}  {tabla:25}  (vacía) {perfil_tag}")
        return
    inv_p  = st['inv']  / n * 100
    null_p = st['null'] / n * 100
    msm_p  = st['misma']/ n * 100
    err    = math.sqrt(P_HORAS_INVERTIDAS * (1-P_HORAS_INVERTIDAS) / n) * 100
    print(f"  {quarter:7}  {tabla:25}  n={n:>7,}  "
          f"inv={inv_p:4.1f}%  null={null_p:4.1f}%  msm={msm_p:4.1f}%  "
          f"σ=±{err:.2f}pp  {perfil_tag}")

# ===========================================================================
# MAIN
# ===========================================================================

def parse_args():
    p = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    p.add_argument('--rows',     type=int,   default=50_000)
    p.add_argument('--tables',   nargs='+',  default=None)
    p.add_argument('--chunk',    type=int,   default=200)
    p.add_argument('--truncate', action='store_true')
    p.add_argument('--status',   action='store_true')
    p.add_argument('--socket',   default='/run/mysqld/mysqld.sock')
    p.add_argument('--host',     default=None)
    p.add_argument('--port',     type=int,   default=3306)
    p.add_argument('--user',     default='django_user')
    p.add_argument('--password', default='django_pass')
    p.add_argument('--db',       default='ivr_legacy')
    return p.parse_args()

def build_conn(args):
    if args.host:
        return [f'-h{args.host}',f'-P{args.port}',
                f'-u{args.user}',f'-p{args.password}',args.db]
    return [f'--socket={args.socket}',
            f'-u{args.user}',f'-p{args.password}',args.db]

def main():
    args = parse_args()
    conn = build_conn(args)

    code, _, err = run_mysql(conn, stmt="SELECT 1;")
    if code != 0:
        print(f"ERROR: Sin conexión — {err}")
        sys.exit(1)

    quarters = list(PERFILES.keys())
    if args.tables:
        quarters = [q for q in quarters if q in args.tables]
        if not quarters:
            print(f"ERROR: Quarters no válidos: {args.tables}")
            sys.exit(1)

    print("=" * 72)
    print(f"  poblar_historico.py")
    if not args.status:
        print(f"  rows_base={args.rows:,}  chunk={args.chunk}  truncate={args.truncate}")
    print(f"  G-29={P_HORAS_INVERTIDAS*100:.0f}%  null={P_NULL*100:.0f}%  "
          f"misma={P_MISMA*100:.0f}%  NK90={P_NK90*100:.1f}%")
    print("=" * 72)
    print(f"\n  {'Quarter':7}  {'Tabla':25}  Estado")
    print("  " + "-" * 68)

    for q_name in quarters:
        cfg, menus, vdns = PERFILES[q_name]
        st = estado_tabla(conn, cfg['tabla'])
        print_estado(q_name, cfg['tabla'], st, menus)

    if args.status:
        print("\n  Catálogo de perfiles:")
        for q_name, (cfg, menus, vdns) in PERFILES.items():
            src = q_name  # podría detectar si es proxy comparando id(menus)
            print(f"    {q_name}: {len(menus)} menús, error_ceros={cfg['error_ceros']}, "
                  f"escala={cfg['escala']:.3f}")
        return

    print()
    for q_name in quarters:
        cfg, menus, vdns = PERFILES[q_name]
        tabla       = cfg['tabla']
        n_objetivo  = max(1, round(args.rows * cfg['escala']))
        error_ceros = cfg['error_ceros']
        d_ini       = cfg['fecha_ini']
        d_fin       = cfg['fecha_fin']

        print(f"\n  [{q_name}] {tabla} — {n_objetivo:,} registros "
              f"(escala={cfg['escala']:.3f}, {len(menus)} menús, "
              f"error_ceros={error_ceros})...")

        if args.truncate:
            run_mysql(conn, stmt=f"TRUNCATE TABLE {tabla};")
            print(f"    TRUNCATE ejecutado")

        rows = [gen_registro(d_ini, d_fin, menus, vdns, error_ceros)
                for _ in range(n_objetivo)]

        with tempfile.NamedTemporaryFile(mode='w', suffix='.sql', delete=False) as f:
            fname = f.name
            for i in range(0, len(rows), args.chunk):
                chunk = rows[i:i+args.chunk]
                vals = ','.join(
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
                print(f"    OK — total: {st_post['total']:,}")
                print_estado(q_name, tabla, st_post, menus)
        else:
            print(f"    ERROR: {err[:200]}")

    print("\n" + "=" * 72)
    print("  Completado")
    print("=" * 72)

if __name__ == '__main__':
    main()
