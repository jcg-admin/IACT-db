"""
Perfil Q04_2025 — Octubre a Diciembre 2025

PROXY de q03_2025 — no hay datos reales de Q04.
Usa la distribución acumulada de Q01+Q02+Q03 (el estado más reciente conocido).
Escala estimada: promedio Q01+Q03 (sin Q02 que es el pico).
"""
from datetime import date
from perfiles.q03_2025 import MENUS, VDN_POR_MENU  # herencia directa

CONFIG = {
    'tabla':       'tbl_historico_t4_2025',
    'quarter':     'Q04_25',
    'fecha_ini':   date(2025, 10, 1),
    'fecha_fin':   date(2025, 12, 31),
    'escala':      0.993,   # estimado: promedio Q01(1.000) + Q03(0.986) / 2
    'error_ceros': True,
}
