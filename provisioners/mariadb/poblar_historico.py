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
    # H-F3-001 (2026-05-10): randint(0, 10**digs - 1).zfill(digs) producía
    # ceros de padding cuando el número tenía menos de `digs` dígitos:
    #   randint(0, 9_999_999) = 123  →  str(123).zfill(7) = '0000123'
    #   CONCAT('443', '0000123') = '4430000123' — número irreal.
    # Corrección: iniciar el rango en 10**(digs-1) garantiza exactamente
    # `digs` dígitos y primer dígito siempre 1-9, sin necesidad de zfill.
    #   randint(1_000_000, 9_999_999) → siempre 7 dígitos, sin cero inicial.
    return pref + str(random.randint(10**(digs - 1), 10**digs - 1))

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

# ===========================================================================
# FUNCIONES DE DIAGNÓSTICO, VERIFICACIÓN Y DIFF
# ===========================================================================

def estado_tabla(conn, tabla):
    """Retorna métricas de calidad de datos de la tabla."""
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


def verificar_quarter(conn, q_name):
    """
    Verifica que el contenido real de la tabla coincide con el perfil esperado.

    Compara las proporciones observadas (cMenu, cDID_Centro_Transferencia,
    condiciones G-29/null/misma_linea) contra los targets del perfil.

    Retorna lista de tuplas (metrica, target, observado, delta, ok).
    """
    if q_name not in PERFILES:
        raise ValueError(f"Quarter desconocido: {q_name}")

    cfg, menus, vdns = PERFILES[q_name]
    tabla = cfg['tabla']

    code, out, _ = run_mysql(conn, stmt=f"""
        SELECT COUNT(*),
          SUM(CASE WHEN dHoraInicio > dHoraFin THEN 1 ELSE 0 END),
          SUM(CASE WHEN cTelefono_Digitado IS NULL THEN 1 ELSE 0 END),
          SUM(CASE WHEN cTelefono_Digitado = cTelefono_Origen THEN 1 ELSE 0 END),
          SUM(CASE WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 1 ELSE 0 END),
          SUM(CASE WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 1 ELSE 0 END),
          SUM(CASE WHEN LENGTH(cDID_Centro_Transferencia) = 17 THEN 1 ELSE 0 END),
          SUM(CASE WHEN LENGTH(cDID_Centro_Transferencia) = 16 THEN 1 ELSE 0 END),
          SUM(CASE WHEN cMenu REGEXP '^[0-9]+$' AND cMenu IS NOT NULL THEN 1 ELSE 0 END)
        FROM {tabla}""")

    if code != 0 or not out:
        return []

    vals = [int(x) for x in out.split('\t')]
    n, inv, null_t, misma, err_ceros, cc, nk17, nk16, cmenu_err = vals

    if n == 0:
        return []

    resultados = [
        # (métrica, target%, observado%, tolerancia)
        ('dHoraInicio > dHoraFin (G-29)', P_HORAS_INVERTIDAS*100, inv/n*100, 1.5),
        ('cTelefono_Digitado IS NULL',     P_NULL*100,            null_t/n*100, 1.5),
        ('misma_linea (D=Origen)',          P_MISMA*100,           misma/n*100, 1.5),
        ('NK90 len_17',                    5.3,                   nk17/n*100, 1.5),
        ('NK90 len_16',                    0.3,                   nk16/n*100, 0.5),
        ('cMenu = numero telefono',         1.2,                   cmenu_err/n*100, 0.8),
        ('CLIENTE_COLGO en cDID_Centro',   27.4,                  cc/n*100, 3.0),
    ]

    # CASO_ERROR_CEROS: solo si error_ceros activo (~0.75% del total = 3% Puebla * 25%)
    target_ceros = 0.75 if cfg['error_ceros'] else 0.0
    resultados.append(('CASO_ERROR_CEROS (Puebla)', target_ceros, err_ceros/n*100, 0.5))

    return [(m, t, o, abs(o-t), abs(o-t) <= tol)
            for m, t, o, tol in resultados]


def mostrar_verificacion(q_name, resultados):
    """Imprime el resultado de verificar_quarter() en formato tabla."""
    print(f"\n  Verificación {q_name}:")
    print(f"  {'Métrica':40} {'Target':>8}  {'Observado':>10}  {'Delta':>7}  OK")
    print("  " + "-"*75)
    for metrica, target, obs, delta, ok in resultados:
        flag = "✓" if ok else "✗ REVISAR"
        print(f"  {metrica:40} {target:>7.1f}%  {obs:>9.1f}%  {delta:>6.2f}pp  {flag}")


def diff_perfiles(q_from, q_to):
    """
    Retorna los cambios entre dos perfiles de quarter.

    Retorna dict con:
        menus_nuevos   — menús que aparecen en q_to pero no en q_from
        menus_quitados — menús que estaban en q_from pero no en q_to
        vdns_cambiados — menús cuyo VDN dominante cambió entre perfiles
    """
    if q_from not in PERFILES or q_to not in PERFILES:
        raise ValueError(f"Quarters desconocidos: {q_from}, {q_to}")

    _, menus_f, vdns_f = PERFILES[q_from]
    _, menus_t, vdns_t = PERFILES[q_to]

    nombres_f = {m[0] for m in menus_f}
    nombres_t = {m[0] for m in menus_t}

    nuevos   = nombres_t - nombres_f
    quitados = nombres_f - nombres_t

    # VDNs cambiados: comparar el VDN dominante (primer elemento de la lista)
    vdns_cambiados = {}
    for menu in nombres_f & nombres_t:
        def primer_vdn(vdns, m):
            v = vdns.get(m)
            if v is None:
                return '(default)'
            if isinstance(v, tuple):
                return v[0]
            return v[0][0] if v else '?'

        vdn_f = primer_vdn(vdns_f, menu)
        vdn_t = primer_vdn(vdns_t, menu)
        if vdn_f != vdn_t:
            vdns_cambiados[menu] = (vdn_f, vdn_t)

    return dict(menus_nuevos=nuevos, menus_quitados=quitados,
                vdns_cambiados=vdns_cambiados)


def mostrar_diff(q_from, q_to):
    """Imprime el diff entre dos perfiles en formato legible."""
    resultado = diff_perfiles(q_from, q_to)
    _, menus_t, _ = PERFILES[q_to]

    # Probabilidades del quarter destino
    probs = {}
    prev = 0
    for nombre, cum, _ in menus_t:
        probs[nombre] = (cum - prev) * 100
        prev = cum

    print(f"\n  DIFF {q_from} → {q_to}")
    print("  " + "="*50)

    if resultado['menus_nuevos']:
        print(f"\n  Menús NUEVOS en {q_to}:")
        for m in sorted(resultado['menus_nuevos'], key=lambda x: -probs.get(x,0)):
            p = probs.get(m, 0)
            print(f"    + {m:40}  {p:.2f}%")
    else:
        print(f"\n  Sin menús nuevos en {q_to}")

    if resultado['menus_quitados']:
        print(f"\n  Menús QUITADOS en {q_to}:")
        for m in sorted(resultado['menus_quitados']):
            print(f"    - {m}")
    else:
        print(f"  Sin menús quitados")

    if resultado['vdns_cambiados']:
        print(f"\n  VDNs que CAMBIAN en {q_to}:")
        for menu, (vdn_f, vdn_t) in sorted(resultado['vdns_cambiados'].items()):
            print(f"    ~ {menu:40}  {vdn_f} → {vdn_t}")
    else:
        print(f"  Sin cambios de VDN")


def mostrar_catalogo_perfiles():
    """Muestra el catálogo completo de perfiles y su cadena de acumulación."""
    print("\n  Catálogo de perfiles:")
    print(f"  {'Quarter':8} {'Tabla':28} {'Menús':>6} {'VDNs':>5} {'Escala':>7} "
          f"{'error_c':>8}  Tipo")
    print("  " + "-"*75)
    proxies = {
        'Q04_25': 'proxy → q03_2025',
        'Q01_26': 'proxy → q01_2025',
        'Q02_26': 'proxy → q02_2025',
    }
    for q_name, (cfg, menus, vdns) in PERFILES.items():
        tipo = proxies.get(q_name, 'acumulado')
        print(f"  {q_name:8} {cfg['tabla']:28} {len(menus):>6} {len(vdns):>5} "
              f"{cfg['escala']:>7.3f} {str(cfg['error_ceros']):>8}  {tipo}")

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
    p.add_argument('--status',   action='store_true',
                   help='Estado actual de las tablas sin insertar')
    p.add_argument('--verify',   action='store_true',
                   help='Verificar proporciones de las tablas vs perfiles esperados')
    p.add_argument('--diff',     nargs=2, metavar=('DESDE','HASTA'),
                   help='Mostrar cambios entre dos perfiles, ej: --diff Q01_25 Q02_25')
    p.add_argument('--catalog',  action='store_true',
                   help='Mostrar catálogo completo de perfiles')
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

    if args.catalog:
        mostrar_catalogo_perfiles()
        return

    if args.diff:
        mostrar_diff(args.diff[0], args.diff[1])
        return

    if args.status:
        mostrar_catalogo_perfiles()
        return

    if args.verify:
        print("\n  Verificando proporciones de calidad de datos...")
        for q_name in quarters:
            cfg, menus, _ = PERFILES[q_name]
            resultados = verificar_quarter(conn, q_name)
            if resultados:
                mostrar_verificacion(q_name, resultados)
            else:
                print(f"\n  {q_name}: tabla vacía o sin conexión")
        print()
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
