"""
Perfiles de quarter para poblar_historico.py

Estructura de acumulación:
    q01_2025  →  q02_2025  →  q03_2025  →  q04_2025 (proxy q03)
    q01_2025  ←─ q01_2026 (proxy q01)
    q02_2025  ←─ q02_2026 (proxy q02, escala parcial)

Cada perfil define:
    CONFIG       — tabla, fechas, escala, flags
    MENUS        — distribución de menús del quarter (acumulada de anteriores)
    VDN_POR_MENU — destino dominante por menú (acumulado de anteriores)
"""
from perfiles.q01_2025 import CONFIG as CFG_Q01, MENUS as M_Q01, VDN_POR_MENU as V_Q01
from perfiles.q02_2025 import CONFIG as CFG_Q02, MENUS as M_Q02, VDN_POR_MENU as V_Q02
from perfiles.q03_2025 import CONFIG as CFG_Q03, MENUS as M_Q03, VDN_POR_MENU as V_Q03
from perfiles.q04_2025 import CONFIG as CFG_Q04, MENUS as M_Q04, VDN_POR_MENU as V_Q04
from perfiles.q01_2026 import CONFIG as CFG_Q01_26, MENUS as M_Q01_26, VDN_POR_MENU as V_Q01_26
from perfiles.q02_2026 import CONFIG as CFG_Q02_26, MENUS as M_Q02_26, VDN_POR_MENU as V_Q02_26

PERFILES = {
    'Q01_25': (CFG_Q01,    M_Q01,    V_Q01),
    'Q02_25': (CFG_Q02,    M_Q02,    V_Q02),
    'Q03_25': (CFG_Q03,    M_Q03,    V_Q03),
    'Q04_25': (CFG_Q04,    M_Q04,    V_Q04),
    'Q01_26': (CFG_Q01_26, M_Q01_26, V_Q01_26),
    'Q02_26': (CFG_Q02_26, M_Q02_26, V_Q02_26),
}
