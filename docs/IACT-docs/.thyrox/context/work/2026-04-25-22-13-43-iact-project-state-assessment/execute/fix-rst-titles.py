#!/usr/bin/env python3
"""
RST Title Format Auto-Fix Script

Fixes reStructuredText title formatting violations where overline/underline
characters don't match the title length.

Pattern 1: Fixed 78-character overline on titles of varying lengths
Pattern 2: Off-by-one errors in overline/underline

Usage:
    python fix-rst-titles.py [--preview|--execute] [--dir SOURCE_DIR]

Options:
    --preview    Show changes without modifying files (default)
    --execute    Apply changes to all files
    --dir DIR    Source directory (default: ./source/)
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Optional


class RSTTitleFixer:
    """Fixes RST title formatting violations."""

    # Characters used for RST underlines/overlines
    UNDERLINE_CHARS = set('=-~^`#*+\'\"')

    def __init__(self, preview_mode: bool = True):
        self.preview_mode = preview_mode
        self.files_processed = 0
        self.fixes_applied = 0
        self.errors = []
        self.log = []

    def is_underline(self, line: str) -> bool:
        """Check if a line is an RST underline."""
        stripped = line.strip()
        if not stripped:
            return False
        # All characters must be the same underline char
        char = stripped[0]
        return char in self.UNDERLINE_CHARS and all(c == char for c in stripped)

    def fix_file(self, file_path: Path) -> bool:
        """
        Fix a single RST file.

        Returns True if file was modified, False otherwise.
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except Exception as e:
            self.errors.append(f"{file_path}: Read error: {e}")
            return False

        modified = False
        new_lines = lines.copy()

        i = 0
        while i < len(lines) - 1:
            # Check for pattern: [overline] title [underline]
            line = lines[i]
            next_line = lines[i + 1] if i + 1 < len(lines) else ""

            # Look for a line that is an underline
            if self.is_underline(next_line):
                # This might be a title with underline
                title = line.rstrip('\n')
                underline = next_line.rstrip('\n')

                # Skip if title is empty or only whitespace
                if not title or not title.strip():
                    i += 1
                    continue

                underline_char = underline[0]

                # Calculate correct lengths (use actual visible characters)
                title_len = len(title)
                underline_len = len(underline)

                # Fix underline if needed
                if underline_len != title_len:
                    new_underline = underline_char * title_len
                    new_lines[i + 1] = new_underline + '\n'
                    modified = True
                    self.fixes_applied += 1
                    self.log.append(f"  Line {i+2}: Fixed underline length {underline_len} → {title_len}")

                # Check for overline (2 lines above)
                if i >= 1:
                    potential_overline = lines[i - 1].rstrip('\n')
                    if self.is_underline(potential_overline):
                        overline_char = potential_overline[0]
                        overline_len = len(potential_overline)

                        # Overline should match underline char and be same length as title
                        if overline_len != title_len or overline_char != underline_char:
                            new_overline = underline_char * title_len
                            new_lines[i - 1] = new_overline + '\n'
                            modified = True
                            self.fixes_applied += 1
                            self.log.append(f"  Line {i}: Fixed overline length {overline_len} → {title_len}")

            i += 1

        # Write back if modified and in execute mode
        if modified:
            if not self.preview_mode:
                try:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.writelines(new_lines)
                except Exception as e:
                    self.errors.append(f"{file_path}: Write error: {e}")
                    return False

        return modified

    def process_directory(self, source_dir: Path) -> None:
        """Process all RST files in directory."""
        rst_files = sorted(source_dir.rglob('*.rst'))

        print(f"\n{'='*70}")
        print(f"RST Title Format Fixer — {'PREVIEW' if self.preview_mode else 'EXECUTE'} MODE")
        print(f"{'='*70}")
        print(f"Source directory: {source_dir}")
        print(f"Files to process: {len(rst_files)}")
        print(f"{'='*70}\n")

        for rst_file in rst_files:
            relative_path = rst_file.relative_to(source_dir)
            self.files_processed += 1

            self.log = []  # Reset per-file log
            modified = self.fix_file(rst_file)

            if modified:
                status = "FIXED" if not self.preview_mode else "WOULD FIX"
                print(f"[{self.files_processed:3d}] {status:10s} {relative_path}")
                for log_entry in self.log:
                    print(log_entry)

            # Print progress every 50 files
            if self.files_processed % 50 == 0:
                print(f"\nProgress: {self.files_processed}/{len(rst_files)} files processed...")

        # Summary
        print(f"\n{'='*70}")
        print(f"SUMMARY")
        print(f"{'='*70}")
        print(f"Files processed: {self.files_processed}")
        print(f"Files modified: {self.fixes_applied // max(1, self.fixes_applied // self.files_processed)}")
        print(f"Fixes applied: {self.fixes_applied}")

        if self.errors:
            print(f"\nErrors encountered: {len(self.errors)}")
            for error in self.errors:
                print(f"  - {error}")

        if self.preview_mode:
            print(f"\n*** PREVIEW MODE: Use --execute to apply changes ***")
        else:
            print(f"\n*** Changes applied to {self.fixes_applied} locations ***")

        print(f"{'='*70}\n")


def main():
    """Main entry point."""
    # Parse arguments
    preview_mode = "--execute" not in sys.argv
    source_dir = Path('./source')

    # Check for custom directory
    if "--dir" in sys.argv:
        idx = sys.argv.index("--dir")
        if idx + 1 < len(sys.argv):
            source_dir = Path(sys.argv[idx + 1])

    # Verify directory exists
    if not source_dir.exists():
        print(f"Error: Directory not found: {source_dir}")
        sys.exit(1)

    # Run fixer
    fixer = RSTTitleFixer(preview_mode=preview_mode)
    fixer.process_directory(source_dir)

    # Exit with error if any errors occurred
    if fixer.errors:
        sys.exit(1)


if __name__ == "__main__":
    main()
