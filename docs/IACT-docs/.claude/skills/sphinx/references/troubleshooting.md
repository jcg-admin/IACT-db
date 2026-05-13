# Troubleshooting Sphinx Builds

## "Unknown directive" or "Unknown role"

**Cause:** Directive/role not registered

**Solution:**
1. Check if extension is in `conf.py` extensions list
2. Verify extension is importable: `python -c "import myext"`
3. Check directive name matches `app.add_directive()`
4. Run `make clean html` to clear cache

## Broken Cross-References (`:ref:`, `:doc:`)

**Cause:** Label doesn't exist or is misnamed

**Solution:**
```rst
.. _my-section-label:

My Section
==========

Reference it as: :ref:`my-section-label`
```

## Build Takes Too Long

**Cause:** Processing all files or slow extensions

**Solution:**
- Use parallel: `make html -j 4`
- Run `make clean` first
- Check slow extensions: `sphinx-build -v ...`

## PDF Generation Fails

**Cause:** LaTeX not installed

**Solution:**
```bash
# Ubuntu/Debian
sudo apt install texlive-latex-full

# macOS
brew install basictex

# Windows
# Install MiKTeX from https://miktex.org/
```

## Theme Not Applying

**Cause:** Theme not installed or wrong name

**Solution:**
```python
# conf.py
html_theme = 'sphinx_rtd_theme'
# Then: pip install sphinx-rtd-theme
```

## Autodoc Not Finding Module

**Cause:** Module not in Python path

**Solution:**
```python
# conf.py
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent.parent / 'src'))
```

## "toctree node doesn't match any files"

**Cause:** Document referenced in toctree doesn't exist

**Solution:**
- Check spelling of filenames
- Make sure files are in same directory or use correct paths
- Check extension: `.rst` or `.md`

## Lessons Learned: Bulk RST File Generation

### Lesson: Avoid Python heredoc to generate RST files

**Anti-pattern:**

Using a Python script with embedded heredocs/multi-line strings to
batch-generate RST files. Example:

```python
content = make_meta(...) + heading('Title', '=') + ...
Path('file.rst').write_text(content)
```

**Why it fails:**

1. **Title underline accuracy.** Python `len()` counts characters
   correctly (UTF-8 aware), but if the heading function has off-by-one
   logic, every file gets the same bug. RST is strict — a title with
   `=` underline shorter than the title text causes
   `Title underline too short` warning.
2. **String escaping fragility.** RST uses backticks heavily. Embedded
   in Python heredocs (especially f-strings), backticks must be
   escaped with backslashes, doubling complexity per artifact.
3. **Whitespace sensitivity.** RST literal blocks (`::`),
   list-table indentation, and `.. note::` directives all require
   exact whitespace. Generating via Python concatenation creates
   subtle whitespace bugs hard to debug.
4. **No incremental feedback.** A single bad template multiplies
   the bug across N generated files.

**Correct pattern:**

Use the Write tool directly per file. Each file gets:

- Manual visual verification of the title underline length.
- Direct RST authoring without escape complications.
- Immediate Sphinx build feedback when problems exist.

**When Python script DOES make sense:**

- Bulk **renaming** of files (preserving content).
- Bulk **find-and-replace** with regex (modifying existing files).
- **Validation** scripts (read-only checks of underline lengths,
  metadata presence, etc.).

**Verification heuristic before saving an RST file:**

```
For each title heading in the file:
    Title text length (in characters, UTF-8 aware) <= underline length
    Underline character is one of: = - ^ " ~ ` * + #
    Underline character is consistent for the same hierarchical level
```

**Recovery script for batch-generated files with title underline bugs:**

```python
from pathlib import Path

UNDERLINE_CHARS = set('=-^"~`*+#')

def fix_underlines(path):
    text = path.read_text()
    lines = text.split('\n')
    for i in range(len(lines) - 1):
        title, underline = lines[i], lines[i+1]
        if (underline and len(set(underline)) == 1
            and underline[0] in UNDERLINE_CHARS
            and len(underline) >= 3 and len(title) > 0
            and len(underline) < len(title)):
            lines[i+1] = underline[0] * len(title)
    path.write_text('\n'.join(lines))
```

This lesson was registered after generating the
`source/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/`
saga in the IACT-docs project (16 RST files), where Python heredoc
generation introduced 6 title-underline bugs that had to be fixed
post-hoc.
