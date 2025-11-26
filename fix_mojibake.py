#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fix mojibake characters in HTML files
Replace Windows-1252 mojibake with correct UTF-8 Spanish characters
"""

import os
from pathlib import Path

# Root path
root_path = Path(r"c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla")

# Mojibake to correct character mapping
replacements = {
    'Ã­': 'í',  # i with acute
    'Ã³': 'ó',  # o with acute
    'Ã¡': 'á',  # a with acute
    'Ã©': 'é',  # e with acute
    'Ãº': 'ú',  # u with acute
    'Ã±': 'ñ',  # n with tilde
    'Ã¼': 'ü',  # u with diaeresis
    'Ã': 'Í',  # I with acute
    'Ã"': 'Ó',  # O with acute
    'Ã': 'Á',  # A with acute
    'Ã‰': 'É',  # E with acute
    'Ãš': 'Ú',  # U with acute
    'Ã'': 'Ñ',  # N with tilde
    'Ãœ': 'Ü',  # U with diaeresis
    'Â¿': '¿',  # inverted question mark
    'Â¡': '¡',  # inverted exclamation mark
}

# Find all HTML files
html_files = []
for html_file in root_path.rglob("*.html"):
    # Skip backup directory and condadodecastilla.com
    if "_encoding_backup" not in str(html_file) and "condadodecastilla.com" not in str(html_file):
        html_files.append(html_file)

total_files = len(html_files)
fixed_count = 0
unchanged_count = 0

print(f"\nFixing mojibake in {total_files} HTML files...\n")

for file_path in html_files:
    relative_path = file_path.relative_to(root_path)
    
    try:
        # Read file as UTF-8
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Apply all replacements
        for mojibake, correct in replacements.items():
            content = content.replace(mojibake, correct)
        
        # Only write if content changed
        if content != original_content:
            # Write back as UTF-8
            with open(file_path, 'w', encoding='utf-8', newline='\r\n') as f:
                f.write(content)
            
            fixed_count += 1
            print(f"[FIXED] {relative_path}")
        else:
            unchanged_count += 1
    
    except Exception as e:
        print(f"[ERROR] {relative_path}: {e}")

print(f"\n=== Fix Summary ===")
print(f"Total files: {total_files}")
print(f"Fixed: {fixed_count}")
print(f"Unchanged: {unchanged_count}")
