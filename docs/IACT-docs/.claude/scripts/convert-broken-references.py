#!/usr/bin/env python3
"""
convert-broken-references.py
Intenta corregir referencias rotas automáticamente buscando el archivo
correcto en el proyecto y actualizando el path relativo.

Uso:
    python3 convert-broken-references.py                # Corrige desde directorio actual
    python3 convert-broken-references.py /path          # Corrige en ruta específica
    python3 convert-broken-references.py --dry-run      # Muestra cambios sin aplicar
"""

import os
import re
import sys
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, str(Path(__file__).parent))
from detect_broken_references import ReferenceValidator


class ReferenceConverter:
    """Intenta corregir referencias rotas encontrando el archivo correcto"""

    def __init__(self, root_path=".", dry_run=False):
        self.root_path = Path(root_path).resolve()
        self.dry_run = dry_run
        self.all_files = {}
        self.fixes_applied = 0
        self.fixes_failed = 0

    def index_all_files(self):
        """Indexa todos los archivos del proyecto por nombre"""
        for root, dirs, files in os.walk(self.root_path):
            dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules', '.venv', '__pycache__'}]
            for file in files:
                full_path = Path(root) / file
                rel_path = full_path.relative_to(self.root_path)
                # Indexar por nombre de archivo (puede haber duplicados)
                if file not in self.all_files:
                    self.all_files[file] = []
                self.all_files[file].append(rel_path)

    def find_correct_path(self, broken_ref, source_file):
        """Busca el archivo correcto para una referencia rota"""
        filename = Path(broken_ref).name

        if filename not in self.all_files:
            return None

        candidates = self.all_files[filename]

        if len(candidates) == 1:
            # Solo hay un archivo con ese nombre - calcular path relativo
            source_dir = Path(source_file).parent
            target = candidates[0]
            try:
                rel = os.path.relpath(self.root_path / target, self.root_path / source_dir)
                return rel
            except ValueError:
                return None

        # Múltiples candidatos - intentar match por directorio
        for candidate in candidates:
            if str(candidate).endswith(broken_ref.lstrip('./')):
                source_dir = Path(source_file).parent
                try:
                    rel = os.path.relpath(self.root_path / candidate, self.root_path / source_dir)
                    return rel
                except ValueError:
                    continue

        return None

    def fix_file(self, source_file, broken_refs):
        """Corrige referencias rotas en un archivo"""
        full_path = self.root_path / source_file

        try:
            with open(full_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception:
            return 0

        original = content
        file_fixes = 0

        for ref, error in broken_refs:
            correct_path = self.find_correct_path(ref, source_file)

            if correct_path:
                # Reemplazar en links markdown: [text](old_ref) → [text](correct_path)
                pattern = re.compile(
                    r'(\[[^\]]*\]\()' + re.escape(ref) + r'(\))',
                    re.MULTILINE
                )
                new_content = pattern.sub(r'\1' + correct_path + r'\2', content)

                if new_content != content:
                    content = new_content
                    file_fixes += 1
                    if self.dry_run:
                        print(f"  {ref} → {correct_path}")
                    self.fixes_applied += 1
                else:
                    # Intentar reemplazar como referencia suelta (sin link markdown)
                    if ref in content:
                        file_fixes += 1
                        if self.dry_run:
                            print(f"  {ref} → {correct_path} (referencia suelta)")
                        else:
                            content = content.replace(ref, correct_path, 1)
                        self.fixes_applied += 1
            else:
                self.fixes_failed += 1
                if self.dry_run:
                    print(f"  {ref} → NO ENCONTRADO")

        if not self.dry_run and content != original:
            with open(full_path, 'w', encoding='utf-8') as f:
                f.write(content)

        return file_fixes

    def run(self):
        """Ejecuta detección y corrección"""
        # Detectar rotas
        validator = ReferenceValidator(
            root_path=str(self.root_path),
            debug=False,
            ignore_examples=True
        )
        validator.find_all_files()
        validator.validate_all_files()

        if not validator.broken_refs:
            print("No broken references found. Nothing to convert.")
            return

        # Indexar archivos
        self.index_all_files()

        # Agrupar por archivo fuente
        broken_by_file = defaultdict(list)
        for source, ref, error in validator.broken_refs:
            broken_by_file[source].append((ref, error))

        mode = "DRY RUN" if self.dry_run else "CONVERTING"
        print(f"\n{mode}: {len(validator.broken_refs)} broken references in {len(broken_by_file)} files\n")

        for source_file in sorted(broken_by_file.keys()):
            print(f"{source_file}:")
            self.fix_file(source_file, broken_by_file[source_file])
            print()

        print(f"{'Would fix' if self.dry_run else 'Fixed'}: {self.fixes_applied}")
        print(f"Could not resolve: {self.fixes_failed}")


def main():
    dry_run = '--dry-run' in sys.argv
    root_path = '.'

    for arg in sys.argv[1:]:
        if not arg.startswith('-') and Path(arg).exists():
            root_path = arg
            break

    converter = ReferenceConverter(root_path=root_path, dry_run=dry_run)
    converter.run()


if __name__ == '__main__':
    main()
