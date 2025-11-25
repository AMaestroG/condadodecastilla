# -*- coding: utf-8 -*-
"""
Script para refactorizar las páginas de biografías
Elimina estilos inline y los reemplaza con clases CSS
"""
import os
import re
import glob

# Directorio base
base_dir = r"c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\personajes"

# Patrones de reemplazo
replacements = [
    # content-wrapper con style
    (r'<div class="content-wrapper" style="text-align: center;">',
     '<div class="content-wrapper">'),
    
    # personaje-imagen-principal con todos los estilos inline
    (r'class="personaje-imagen-principal"\s+style="[^"]*"',
     'class="personaje-imagen-principal"'),
    
    # div con text-align justify
    (r'<div style="text-align: justify; margin-bottom: 2em;">',
     '<div class="bio-text">'),
    
    # ul con estilos inline  
    (r'<ul style="text-align: left; display: inline-block; margin-bottom: 2em;">',
     '<ul class="bio-list-wrapper">'),
    
    # div con text-align center y margin-top
    (r'<div style="text-align:center; margin-top: 2em;">',
     '<div class="nav-button-wrapper">'),
]

# Encontrar todos los archivos HTML en personajes y subdirectorios
html_files = glob.glob(os.path.join(base_dir, "**", "*.html"), recursive=True)

# Excluir indice_personajes.html
html_files = [f for f in html_files if "indice_personajes" not in f]

print(f"Procesando {len(html_files)} archivos...")

for filepath in html_files:
    try:
        # Leer el archivo
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Aplicar reemplazos
        original_content = content
        for pattern, replacement in replacements:
            content = re.sub(pattern, replacement, content)
        
        # Solo escribir si hubo cambios
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✓ Refactorizado: {os.path.basename(filepath)}")
        else:
            print(f"- Sin cambios: {os.path.basename(filepath)}")
            
    except Exception as e:
        print(f"✗ Error procesando {filepath}: {e}")

print("\n¡Refactorización completada!")
