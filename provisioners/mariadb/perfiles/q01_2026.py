"""
Perfil Q01_2026 — Enero a Marzo 2026

PROXY de q01_2025 — no hay datos reales de Q01_2026.
Reutiliza la distribución base de Q01_2025 (sin los menús nuevos de Q02/Q03).
El catálogo de menús del IVR puede haber crecido, pero sin datos reales
se usa Q01_2025 como aproximación conservadora.
"""
from datetime import date
from perfiles.q01_2025 import MENUS, VDN_POR_MENU  # referencia al base

CONFIG = {
    'tabla':       'tbl_historico_t1_2026',
    'quarter':     'Q01_26',
    'fecha_ini':   date(2026, 1, 1),
    'fecha_fin':   date(2026, 3, 31),
    'escala':      1.000,   # proxy Q01_2025
    'error_ceros': True,    # se asume activo (apareció en Q02_2025)
}
