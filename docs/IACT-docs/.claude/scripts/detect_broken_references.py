#!/usr/bin/env python3
"""
THYROX Reference Validator v3 - IMPROVED
Valida referencias distinguiendo entre reales y documentales.
- Ignora referencias dentro de bloques de código
- Ignora referencias en comentarios HTML
- Detecta ejemplos vs referencias concretas
- Exporta reporte detallado en .txt

Uso:
    python3 validate-references-v3.py                  # Valida desde directorio actual
    python3 validate-references-v3.py /path            # Valida desde ruta específica
    python3 validate-references-v3.py --debug          # Muestra contexto detallado
    python3 validate-references-v3.py --ignore-examples # Solo referencias concretas
"""

import os
import re
import sys
from pathlib import Path
from collections import defaultdict
from datetime import datetime


class ReferenceValidator:
    """Valida referencias a archivos distinguiendo reales de documentales"""
    
    PLACEHOLDERS = {
        'YYYY-MM-DD', 'HH-MM', 'HH:MM', 'TIMESTAMP', 'NNN', 'XXX', 
        'NOMBRE', 'PROYECTO', 'DESCRIPCION', 'PATH',
        'nombre-proyecto', 'proyecto-x', 'feature-x', 'proyecto',
        'PHASE', 'TASK', 'STEP', 'TASK-NNN', 'SPEC-NNN',
        'archivo', 'directorio', 'referencia', '*', '...', 'YYYY',
        'NOMBRE_ARCHIVO', 'RUTA', 'EXTENSIÓN', 'fecha'
    }
    
    # Palabras que indican contexto de ejemplo/documentación
    EXAMPLE_KEYWORDS = {
        'ejemplo', 'por ejemplo', 'e.g', 'como', 'tal como', 'similar a',
        'parecido', 'puede ser', 'podría ser', 'estructura', 'formato',
        'tipo de', 'como en', 'como el', 'digamos', 'supongamos',
        'imagina', 'considera', 'template', 'plantilla', 'pattern'
    }
    
    def __init__(self, root_path=".", debug=False, ignore_examples=False):
        self.root_path = Path(root_path).resolve()
        self.debug = debug
        self.ignore_examples = ignore_examples
        self.files_found = {}
        self.references = defaultdict(list)
        self.broken_refs = []
        self.valid_refs = []
        self.ignored_refs = []
        self.documentary_refs = []
        self.report_lines = []
        
    def log_report(self, line=""):
        """Agregar línea al reporte"""
        self.report_lines.append(line)
        if self.debug:
            print(line)
    
    def is_placeholder(self, ref):
        """Detecta si una referencia es un placeholder/ejemplo"""
        upper_ref = ref.upper()
        
        for placeholder in self.PLACEHOLDERS:
            if placeholder in upper_ref:
                return True
        
        return False
    
    def is_inside_code_block(self, content, position):
        """Detecta si una posición está dentro de un bloque de código.
        Usa state machine línea por línea para manejar correctamente bloques anidados.
        Soporta backticks (```) y tildes (~~~) como delimitadores de fence.
        Una fence de cierre debe tener >= fence_len del mismo carácter, sin info string."""
        in_code_block = False
        fence_char = None
        fence_len = 0
        current_pos = 0

        for line in content.split('\n'):
            line_start = current_pos
            line_end = current_pos + len(line)

            # Si la posición está en esta línea, retornar estado actual
            # (antes de procesar cambios de estado de esta línea)
            if line_start <= position <= line_end:
                return in_code_block

            if current_pos > position:
                break

            # Actualizar estado según la línea actual
            if not in_code_block:
                m = re.match(r'^(`{3,}|~{3,})', line)
                if m:
                    fence_char = m.group(1)[0]
                    fence_len = len(m.group(1))
                    in_code_block = True
            else:
                # Closing fence: mismo carácter, >= fence_len, sin info string
                closing_pattern = r'^' + re.escape(fence_char) + r'{' + str(fence_len) + r',}\s*$'
                if re.match(closing_pattern, line):
                    in_code_block = False
                    fence_char = None
                    fence_len = 0

            current_pos += len(line) + 1  # +1 por newline


        return False
    
    def is_inside_html_comment(self, content, position):
        """Detecta si una posición está dentro de un comentario HTML"""
        # Encontrar todos los comentarios HTML
        comment_blocks = []
        pattern = r'<!--(.*?)-->'
        
        for match in re.finditer(pattern, content, re.DOTALL):
            start, end = match.span()
            comment_blocks.append((start, end))
        
        # Verificar si la posición está dentro de algún comentario
        for start, end in comment_blocks:
            if start <= position <= end:
                return True
        
        return False
    
    def is_likely_example(self, content, start_pos, ref):
        """Detecta si una referencia es probablemente un ejemplo documentacional"""
        # Buscar contexto alrededor de la referencia (200 caracteres antes)
        context_start = max(0, start_pos - 200)
        context = content[context_start:start_pos].lower()
        
        # Buscar palabras clave de ejemplo
        for keyword in self.EXAMPLE_KEYWORDS:
            if keyword in context:
                return True
        
        # Si está en una línea que empieza con "- " o "*", podría ser ejemplo
        line_start = content.rfind('\n', 0, start_pos)
        if line_start == -1:
            line_start = 0
        else:
            line_start += 1
        
        line_text = content[line_start:start_pos].lstrip()
        if line_text.startswith(('- ', '* ', '+ ')):
            # Verificar si es una lista de ejemplos
            if 'ejemplo' in content[line_start:start_pos + 100].lower():
                return True
        
        return False
    
    def is_documentary_context(self, ref_path, source_rel_path):
        """
        Returns True si la referencia debe tratarse como documental por contexto.

        Reglas:
        1. Bare filename (sin ./ o ../ y sin componente de directorio) en cualquier
           archivo bajo .claude/ → mención textual, no link navegable. Las SKILL.md,
           templates y documentación de referencias mencionan nombres de archivo como
           conceptos. Solo se consideran navegables los que tienen prefijo explícito.
        2. Cualquier referencia en archivos .template → documentación de ejemplo.
        3. Absolute /tmp/ paths → source material citations, no parte del repo.
        """
        ref_clean = ref_path.strip()
        # Construir path absoluto para checks confiables independiente del root_path
        source_abs = str(self.root_path / source_rel_path)

        # Regla 3: absolute /tmp/ paths → source material citations
        if ref_clean.startswith('/tmp/'):
            return True

        # Regla 2: en archivos .template todo es contenido de ejemplo
        if source_abs.endswith('.template'):
            return True

        # Regla 4: en .claude/references/, refs sin prefijo explícito son documentales.
        # Los docs de references/ son abstractos; mencionan paths como ejemplos/conceptos.
        # Los links reales (navegables) usan ./ o ../ explícito.
        # Excepción adicional: refs a .txt en .claude/references/ son args de CLI o ejemplos.
        if '/.claude/references/' in source_abs:
            if not ref_clean.startswith('./') and not ref_clean.startswith('../'):
                return True
            if ref_clean.endswith('.txt'):
                return True

        # Regla 5: archivos .json → las refs son valores de datos, no links navegables
        if source_abs.endswith('.json'):
            return True

        # Regla 1: bare filename (sin directorio) en .claude/ → documental
        # Los que tienen ./ ../ o / son refs concretas y se validan normalmente
        is_bare = (
            not ref_clean.startswith('./')
            and not ref_clean.startswith('../')
            and '/' not in ref_clean
        )
        if is_bare and '/.claude/' in source_abs:
            return True

        return False

    def find_all_files(self):
        """Encuentra todos los archivos MD relevantes"""
        self.log_report("Escaneando archivos...")
        count = 0
        
        for root, dirs, files in os.walk(self.root_path):
            # Ignorar directorios comunes
            dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules', '.venv', '__pycache__'}]
            
            for file in files:
                if file.endswith(('.md', '.json')) and not file.startswith('.'):
                    full_path = Path(root) / file
                    rel_path = full_path.relative_to(self.root_path)
                    self.files_found[str(rel_path)] = full_path
                    count += 1
        
        self.log_report(f"Encontrados: {count} archivos\n")
    
    def extract_references_with_context(self, content):
        """Extrae referencias con información de contexto"""
        refs = []
        
        # Patrón 1: Links Markdown [texto](ruta/archivo.md)
        for match in re.finditer(r'\[([^\]]+)\]\(([^)]+\.(?:md|txt|template))\)', content):
            text, path = match.groups()
            start_pos = match.start()
            
            # Validar que no sea placeholder ni esté en bloque de código
            if (not path.startswith('http') and 
                not self.is_placeholder(path) and
                not self.is_inside_code_block(content, start_pos) and
                not self.is_inside_html_comment(content, start_pos)):
                
                is_example = self.is_likely_example(content, start_pos, path)
                refs.append(('markdown', path, start_pos, is_example))
        
        # Patrón 2: Referencias a archivos con extensión
        # Pero SOLO si están en contexto de referencia real (no documentación)
        # Lookbehind incluye [a-zA-Z0-9.] para evitar fragmentos: LAUDE.md desde CLAUDE.md,
        # y el phantom "./../" que surge del segundo "." de "../../".
        # Lookahead incluye "." para evitar falso match "adr.md" desde "adr.md.template".
        for match in re.finditer(r'(?<![a-zA-Z0-9`\[\(/.])(?:\.\.?/)?[a-zA-Z0-9._/-]*\.(?:md|template|json|txt)(?![a-zA-Z0-9`\]\).])', content):
            ref = match.group(0).strip()
            start_pos = match.start()
            
            # Validaciones
            if (len(ref) < 3 or  # ignorar referencias muy cortas
                ref.startswith('http') or
                self.is_placeholder(ref) or
                self.is_inside_code_block(content, start_pos) or
                self.is_inside_html_comment(content, start_pos) or
                ref in [r[1] for r in refs]):  # ya fue agregada
                continue
            
            # Ignorar patrones que son claramente ejemplos
            if any(x in ref.lower() for x in ['.md', '.template', '.json']) and \
               (ref.startswith('.') and not ref.startswith('./')):
                # Referencia que empieza con punto (como .template) es probablemente documentacional
                is_example = True
            else:
                is_example = self.is_likely_example(content, start_pos, ref)
            
            refs.append(('file', ref, start_pos, is_example))
        
        return list(set(refs))
    
    def resolve_reference(self, ref, source_file):
        """Resuelve una referencia a ruta absoluta"""
        source_dir = Path(source_file).parent
        ref = ref.strip()
        
        try:
            # Si empieza con ./ o ../, es relativa
            if ref.startswith('./') or ref.startswith('../'):
                target = (source_dir / ref).resolve()
            # Si no empieza con /, es relativa al directorio del archivo
            elif not ref.startswith('/'):
                target = (source_dir / ref).resolve()
            # Si empieza con /, es absoluta desde raíz
            else:
                target = self.root_path / ref.lstrip('/')
            
            return target
        except Exception as e:
            return None
    
    def validate_all_files(self):
        """Valida referencias en todos los archivos MD"""
        self.log_report("Validando referencias...\n")
        
        for rel_path, file_path in sorted(self.files_found.items()):
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
            except Exception as e:
                self.log_report(f"ERROR: No se puede leer {file_path}: {e}")
                continue
            
            refs = self.extract_references_with_context(content)
            
            for ref_type, ref_path, start_pos, is_example in refs:
                # Aplicar regla documental por contexto de fuente
                if not is_example:
                    is_example = self.is_documentary_context(ref_path, rel_path)

                # Clasificar la referencia
                if is_example and self.ignore_examples:
                    self.ignored_refs.append((rel_path, ref_path, "documentacional"))
                    continue
                
                self.references[rel_path].append((ref_type, ref_path, is_example))
                
                try:
                    resolved = self.resolve_reference(ref_path, file_path)
                    
                    if resolved and resolved.exists():
                        self.valid_refs.append((rel_path, ref_path, is_example))
                        if self.debug:
                            self.log_report(f"  [VÁLIDA] {ref_path}")
                    else:
                        if is_example:
                            self.documentary_refs.append((rel_path, ref_path))
                            if self.debug:
                                self.log_report(f"  [DOCUMENTAL] {ref_path}")
                        else:
                            self.broken_refs.append((rel_path, ref_path, "No existe"))
                            if self.debug:
                                self.log_report(f"  [ROTA] {ref_path}")
                
                except Exception as e:
                    self.broken_refs.append((rel_path, ref_path, str(e)))
                    if self.debug:
                        self.log_report(f"  [ERROR] {ref_path}: {e}")
    
    def print_summary(self):
        """Imprime y retorna resumen de validación"""
        self.log_report("")
        self.log_report("="*90)
        self.log_report("THYROX - VALIDACIÓN DE REFERENCIAS v3")
        self.log_report("="*90)
        self.log_report("")
        
        # Estadísticas generales
        total_valid = len(self.valid_refs)
        total_broken = len(self.broken_refs)
        total_documentary = len(self.documentary_refs)
        total_refs = total_valid + total_broken + total_documentary
        
        self.log_report(f"Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        self.log_report(f"Directorio analizado: {self.root_path}")
        self.log_report("")
        
        if total_refs == 0:
            self.log_report("No se encontraron referencias.\n")
            return True
        
        # Tabla de resultados
        self.log_report("RESULTADOS POR CATEGORÍA:")
        self.log_report("-" * 90)
        self.log_report(f"  Referencias válidas (archivos existentes):     {total_valid:>4}")
        self.log_report(f"  Referencias documentales (ejemplos/patrones):  {total_documentary:>4}")
        self.log_report(f"  Referencias rotas (archivos no encontrados):   {total_broken:>4}")
        self.log_report(f"                                                 {'─' * 6}")
        self.log_report(f"  TOTAL:                                         {total_refs:>4}")
        self.log_report("")
        
        # Tasas de éxito
        if total_refs > 0:
            valid_rate = (total_valid / total_refs) * 100
            success_rate = ((total_valid + total_documentary) / total_refs) * 100
            
            self.log_report("TASAS:")
            self.log_report(f"  Referencias concretas válidas: {valid_rate:.1f}%")
            self.log_report(f"  Integridad general (válidas + documentales): {success_rate:.1f}%")
            self.log_report("")
        
        # Estado
        if total_broken == 0:
            status = "TODAS LAS REFERENCIAS CONCRETAS SON VÁLIDAS"
        elif total_broken <= 5:
            status = "BUENO - Pocas referencias rotas"
        else:
            status = "REQUIERE ATENCIÓN - Múltiples referencias rotas"
        
        self.log_report(f"Status: {status}")
        self.log_report("")
        
        # Archivos más complejos
        files_with_refs = sum(1 for refs in self.references.values() if refs)
        self.log_report(f"Archivos con referencias: {files_with_refs}")
        
        if self.references:
            top_files = sorted(
                [(f, len(refs)) for f, refs in self.references.items() if refs],
                key=lambda x: x[1],
                reverse=True
            )[:5]
            
            if top_files:
                self.log_report("\nArchivos con más referencias:")
                for file, count in top_files:
                    file_name = Path(file).name
                    self.log_report(f"  • {file_name:50} {count} referencias")
        
        # DETALLE: Referencias válidas
        if self.valid_refs:
            self.log_report("")
            self.log_report("="*90)
            self.log_report("REFERENCIAS VÁLIDAS (archivos existentes)")
            self.log_report("="*90)
            valid_by_file = defaultdict(list)
            for file, ref, is_ex in self.valid_refs:
                valid_by_file[file].append(ref)
            
            for file in sorted(valid_by_file.keys()):
                file_name = Path(file).name
                self.log_report(f"\n{file_name}:")
                for ref in sorted(set(valid_by_file[file])):
                    self.log_report(f"  -> {ref}")
        
        # DETALLE: Referencias documentales
        if self.documentary_refs:
            self.log_report("")
            self.log_report("="*90)
            self.log_report("REFERENCIAS DOCUMENTALES (ejemplos/patrones)")
            self.log_report("="*90)
            doc_by_file = defaultdict(list)
            for file, ref in self.documentary_refs:
                doc_by_file[file].append(ref)
            
            for file in sorted(doc_by_file.keys()):
                file_name = Path(file).name
                self.log_report(f"\n{file_name}:")
                for ref in sorted(set(doc_by_file[file])):
                    self.log_report(f"  [DOC] {ref}")
        
        # DETALLE: Referencias rotas
        if self.broken_refs:
            self.log_report("")
            self.log_report("="*90)
            self.log_report("REFERENCIAS ROTAS - REQUIERE ACCIÓN INMEDIATA")
            self.log_report("="*90)
            
            broken_by_file = defaultdict(list)
            for file, ref, error in self.broken_refs:
                broken_by_file[file].append((ref, error))
            
            for file in sorted(broken_by_file.keys()):
                file_name = Path(file).name
                self.log_report(f"\n{file_name}:")
                for ref, error in sorted(broken_by_file[file]):
                    self.log_report(f"  [ROTA] {ref}")
                    if error != "No existe":
                        self.log_report(f"         Detalle: {error}")
        
        self.log_report("")
        self.log_report("="*90 + "\n")
        
        return total_broken == 0
    
    def export_report(self, output_file="reference-validation-report.txt"):
        """Exporta reporte completo a archivo .txt"""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(self.report_lines))
        
        return output_file


def main():
    """Punto de entrada principal"""
    debug = '--debug' in sys.argv
    ignore_examples = '--ignore-examples' in sys.argv
    root_path = '.'
    
    # Parse argumentos
    for arg in sys.argv[1:]:
        if not arg.startswith('-') and Path(arg).exists():
            root_path = arg
            break
    
    # Ejecutar validación
    validator = ReferenceValidator(root_path=root_path, debug=debug, ignore_examples=ignore_examples)
    validator.find_all_files()
    validator.validate_all_files()
    validator.print_summary()
    
    # Exportar reporte
    report_file = validator.export_report("reference-validation-report.txt")
    print(f"\nReporte guardado en: {report_file}\n")
    
    # Exit code
    sys.exit(0 if len(validator.broken_refs) == 0 else 1)


if __name__ == '__main__':
    main()
