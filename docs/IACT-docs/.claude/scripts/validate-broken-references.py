#!/usr/bin/env python3
"""
validate-broken-references.py
Valida que no existan referencias rotas en el proyecto.
Retorna exit code 0 si todo está correcto, 1 si hay referencias rotas.

Diseñado para CI/CD y validación automatizada.

Uso:
    python3 validate-broken-references.py              # Valida desde directorio actual
    python3 validate-broken-references.py /path         # Valida desde ruta específica
    python3 validate-broken-references.py --strict      # Falla también con documentales sin resolver
"""

import sys
from pathlib import Path

# Importar la clase compartida
sys.path.insert(0, str(Path(__file__).parent))
from detect_broken_references import ReferenceValidator


def main():
    strict = '--strict' in sys.argv
    root_path = '.'

    for arg in sys.argv[1:]:
        if not arg.startswith('-') and Path(arg).exists():
            root_path = arg
            break

    validator = ReferenceValidator(root_path=root_path, debug=False, ignore_examples=False)
    validator.find_all_files()
    validator.validate_all_files()

    total_broken = len(validator.broken_refs)
    total_valid = len(validator.valid_refs)
    total_documentary = len(validator.documentary_refs)
    total = total_valid + total_broken + total_documentary

    if total == 0:
        print("PASS: No references found")
        sys.exit(0)

    if strict:
        # En modo strict, las documentales sin archivo también cuentan
        issues = total_broken
    else:
        issues = total_broken

    if issues == 0:
        print(f"PASS: All {total_valid} concrete references are valid ({total_documentary} documentary skipped)")
        sys.exit(0)
    else:
        print(f"FAIL: {total_broken} broken references found out of {total}")
        print("Run detect-broken-references.py to see details")
        sys.exit(1)


if __name__ == '__main__':
    main()
