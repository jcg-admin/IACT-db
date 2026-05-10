"""
Perfil Q02_2026 — Abril a Mayo 2026 (parcial: 36/91 días)

PROXY de q02_2025 — no hay datos reales de Q02_2026.
Reutiliza la distribución acumulada Q01+Q02 de 2025.
Escala reducida por ser un quarter parcial (36 días de 91).
"""
from datetime import date
from perfiles.q02_2025 import MENUS, VDN_POR_MENU  # referencia a Q02_2025

CONFIG = {
    'tabla':       'tbl_historico_t2_2026',
    'quarter':     'Q02_26',
    'fecha_ini':   date(2026, 4, 1),
    'fecha_fin':   date(2026, 5, 6),    # parcial: 36 días
    'escala':      0.486,   # SUPUESTO: Q02_26_full con +5% YoY sobre Q02_25.
                            # Q02_25=13,612,375 x 1.05 = 14,293,000 llamadas full.
                            # Parcial 36/91 dias: 14,293,000 x (36/91) = 5,654,000.
                            # Escala vs Q01_25 real: 5,654,000 / 11,643,679 = 0.486.
    'error_ceros': True,
}
