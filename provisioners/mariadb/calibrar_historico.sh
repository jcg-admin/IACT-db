#!/bin/bash
# =============================================================================
# provisioners/mariadb/calibrar_historico.sh  v2.0.0
# Calibra las tablas tbl_historico_t* para replicar condiciones de producción
# =============================================================================
# CONDICIÓN                        SEED     PRODUCCIÓN   TARGET
# dHoraInicio > dHoraFin           0.3%     38.8%        38.8%
# cTelefono_Digitado IS NULL       29-31%   21.2%        21.2%
# Digitado = Origen (misma línea)  44-46%   28.2%        28.2%
#
# ORDEN: fill_null → fix_misma → inv_horas
#
# USO:
#   sudo bash provisioners/mariadb/calibrar_historico.sh
# =============================================================================
set -euo pipefail
SOCK="/run/mysqld/mysqld.sock"
DB_USER="django_user"; DB_PASS="django_pass"; DB_NAME="ivr_legacy"
VER="2.0.0"

if ! mysql --socket="${SOCK}" -u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" \
     -e "SELECT 1;" &>/dev/null; then
    echo "ERROR: Sin conexión a MariaDB en ${SOCK}"; exit 1
fi

echo "============================================================"
echo "  calibrar_historico.sh v${VER}"
echo "============================================================"

python3 << PYEOF
import subprocess, random, tempfile, os

SOCK="${SOCK}"; USER="${DB_USER}"; PASS="${DB_PASS}"; DB="${DB_NAME}"; VER="${VER}"
T_INV=0.388; T_NULL=0.212; T_MISMA=0.282
PREFIJOS=['443','722','222','55','333','81','998','664','618','614']
TABLAS=[
    'tbl_historico_t1_2025','tbl_historico_t2_2025','tbl_historico_t3_2025',
    'tbl_historico_t4_2025','tbl_historico_t1_2026','tbl_historico_t2_2026'
]

def qry(stmt):
    r=subprocess.run(['mysql','--socket='+SOCK,'-u'+USER,'-p'+PASS,DB,'-N','-e',stmt],
        capture_output=True,text=True)
    return r.stdout.strip()

def run_file(path):
    with open(path) as f:
        r=subprocess.run(['mysql','--socket='+SOCK,'-u'+USER,'-p'+PASS,DB],
            stdin=f,capture_output=True,text=True)
    return r.returncode, r.stderr[:300]

def phone():
    p=random.choice(PREFIJOS); d=10-len(p)
    return p+str(random.randint(0,10**d-1)).zfill(d)

def elt(phones):
    n=len(phones)
    lst=','.join(f"'{p}'" for p in phones)
    return f"ELT(1+FLOOR(RAND()*{n}),{lst})"

for tabla in TABLAS:
    print(f"\n--- {tabla} ---")
    row=qry(f"SELECT COUNT(*),SUM(CASE WHEN dHoraInicio>dHoraFin THEN 1 ELSE 0 END),"
            f"SUM(CASE WHEN cTelefono_Digitado IS NULL THEN 1 ELSE 0 END),"
            f"SUM(CASE WHEN cTelefono_Digitado=cTelefono_Origen THEN 1 ELSE 0 END) FROM {tabla}")
    if not row: print("  SKIP: sin datos"); continue
    total,inv,null,misma=[int(x) for x in row.split('\t')]

    fill=max(0,null -round(total*T_NULL))
    fix =max(0,misma-round(total*T_MISMA))
    ninv=max(0,round(total*T_INV)-inv)

    print(f"  Actual: inv={inv/total*100:.1f}% null={null/total*100:.1f}% misma={misma/total*100:.1f}%")
    print(f"  Delta:  fill_null={fill} fix_misma={fix} inv_horas={ninv}")

    if fill==fix==ninv==0:
        print("  Ya calibrado — sin cambios")
        qry(f"INSERT INTO seed_executions(tabla,accion,filas_antes,filas_despues,"
            f"seed_rows_cfg,script_version) VALUES('{tabla}','CALIBRAR-SKIP',"
            f"{total},{total},0,'{VER}')")
        continue

    lines=[]

    # PASO 1: Rellenar NULLs con teléfono diferente al origen
    chunk=50
    for i in range(0,fill,chunk):
        cnt=min(chunk,fill-i)
        ph=[phone() for _ in range(cnt)]
        lines.append(f"UPDATE {tabla} SET cTelefono_Digitado={elt(ph)} "
                     f"WHERE cTelefono_Digitado IS NULL ORDER BY RAND() LIMIT {cnt};")

    # PASO 2: Cambiar misma_linea → linea_diferente
    for i in range(0,fix,chunk):
        cnt=min(chunk,fix-i)
        ph=[phone() for _ in range(cnt)]
        lines.append(f"UPDATE {tabla} SET cTelefono_Digitado={elt(ph)} "
                     f"WHERE cTelefono_Digitado IS NOT NULL "
                     f"AND cTelefono_Digitado=cTelefono_Origen ORDER BY RAND() LIMIT {cnt};")

    # PASO 3: Invertir dHoraInicio/dHoraFin (replica bug G-29)
    chunk2=200
    for i in range(0,ninv,chunk2):
        cnt=min(chunk2,ninv-i)
        lines.append(f"UPDATE {tabla} SET "
                     f"dHoraFin=DATE_SUB(dHoraInicio,INTERVAL(5+FLOOR(RAND()*890)) SECOND) "
                     f"WHERE dHoraInicio<=dHoraFin ORDER BY RAND() LIMIT {cnt};")

    with tempfile.NamedTemporaryFile(mode='w',suffix='.sql',delete=False) as f:
        fname=f.name
        f.write('\n'.join(lines)+'\n')

    code,err=run_file(fname)
    os.unlink(fname)

    if code==0:
        row2=qry(f"SELECT SUM(CASE WHEN dHoraInicio>dHoraFin THEN 1 ELSE 0 END),"
                 f"SUM(CASE WHEN cTelefono_Digitado IS NULL THEN 1 ELSE 0 END),"
                 f"SUM(CASE WHEN cTelefono_Digitado=cTelefono_Origen THEN 1 ELSE 0 END) FROM {tabla}")
        i2,n2,m2=[int(x) for x in row2.split('\t')]
        print(f"  Result: inv={i2/total*100:.1f}% null={n2/total*100:.1f}% misma={m2/total*100:.1f}%")
        qry(f"INSERT INTO seed_executions(tabla,accion,filas_antes,filas_despues,"
            f"seed_rows_cfg,script_version) VALUES('{tabla}','CALIBRAR',"
            f"{total},{total},0,'{VER}')")
        print(f"  OK")
    else:
        print(f"  ERROR: {err}")

print("\n=== Calibración completada ===")
PYEOF
