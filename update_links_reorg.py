import os
import re

# Configuration: Old Path -> New Path (relative to root)
MOVES = {
    "_header.html": "layout/_header.html",
    "_footer.html": "layout/_footer.html",
    "timeline.html": "historia/timeline.html",
    "vida_cotidiana.html": "historia/vida_cotidiana.html",
    "leyendas.html": "cultura/leyendas.html",
    "arquitectura.html": "patrimonio/arquitectura.html",
    "blog.html": "blog/blog.html",
}

# Add blog posts dynamically if needed, but let's assume standard pattern
# For now, let's just handle the explicit moves and general link fix logic.

ROOT_DIR = r"c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

def get_all_html_files(root_dir):
    html_files = []
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".html"):
                html_files.append(os.path.join(dirpath, filename))
    return html_files

def update_links_in_file(file_path, moves, root_dir):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    
    # Calculate depth of current file to determine root relative path
    rel_path_from_root = os.path.relpath(file_path, root_dir)
    depth = rel_path_from_root.count(os.sep)
    
    # 1. Update links TO moved files
    for old_name, new_rel_path in moves.items():
        # Regex to find links to old_name (e.g., href="timeline.html", href="../timeline.html")
        # This is tricky because we need to resolve the link to see if it matches the old file.
        
        # Simplified approach: Look for the filename in href/src
        # If found, check if it resolves to the old file location.
        
        def replace_link(match):
            link = match.group(1)
            quote = match.group(2) # ending quote
            
            # Skip external links, anchors, mailto
            if link.startswith(('http', '//', '#', 'mailto:')):
                return match.group(0)

            # Resolve absolute path of the link target
            # Assuming link is relative to current file
            try:
                link_abs_path = os.path.normpath(os.path.join(os.path.dirname(file_path), link))
                
                # Check if this link pointed to the OLD location of the moved file
                # The old location was ROOT_DIR + old_name
                old_file_abs_path = os.path.normpath(os.path.join(root_dir, old_name))
                
                if link_abs_path == old_file_abs_path:
                    # It pointed to the old file! Update it to point to the NEW file.
                    new_file_abs_path = os.path.join(root_dir, new_rel_path)
                    new_link = os.path.relpath(new_file_abs_path, os.path.dirname(file_path))
                    return f'href="{new_link.replace(os.sep, "/")}"'
            except Exception as e:
                pass
                
            return match.group(0)

        # Regex for href attributes
        content = re.sub(r'href="([^"]+)"', replace_link, content)

    # 2. Update links FROM moved files (fix relative paths to assets/other pages)
    # Check if THIS file is one of the moved files
    # We need to know if it WAS moved.
    # Actually, the file is already at the NEW location when we run this script.
    # So we need to know where it CAME FROM to adjust links?
    # No, if we just moved the file, the links inside it are broken because they are relative to the OLD location.
    
    # Identify if this file is a moved file
    # We can check if its current path matches a target in MOVES
    current_rel_path = os.path.relpath(file_path, root_dir).replace("\\", "/")
    
    old_rel_path = None
    for old, new in moves.items():
        if new == current_rel_path:
            old_rel_path = old
            break
            
    # Also check for blog posts which were moved via wildcard
    if not old_rel_path and "blog/" in current_rel_path and current_rel_path != "blog/blog.html":
         # Assume it came from root if it's in blog/ and not blog.html (which is in MOVES)
         # and filename starts with blog_
         filename = os.path.basename(file_path)
         if filename.startswith("blog_"):
             old_rel_path = filename

    if old_rel_path:
        # This file was moved!
        # We need to adjust ALL relative links inside it.
        # Logic: Link was relative to OLD_DIR. Now needs to be relative to NEW_DIR.
        # Target_Abs_Path = OLD_DIR + Link
        # New_Link = relpath(Target_Abs_Path, NEW_DIR)
        
        old_dir = os.path.join(root_dir, os.path.dirname(old_rel_path))
        new_dir = os.path.dirname(file_path)
        
        def fix_relative_link(match):
            attr = match.group(1) # href or src
            link = match.group(2)
            
            if link.startswith(('http', '//', '#', 'mailto:', 'data:')):
                return match.group(0)
                
            # Calculate where the link pointed to originally
            target_abs_path = os.path.normpath(os.path.join(old_dir, link))
            
            # Calculate new relative path from new location
            new_link = os.path.relpath(target_abs_path, new_dir)
            return f'{attr}="{new_link.replace(os.sep, "/")}"'

        content = re.sub(r'(href|src)="([^"]+)"', fix_relative_link, content)

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {file_path}")

def main():
    files = get_all_html_files(ROOT_DIR)
    for file in files:
        update_links_in_file(file, MOVES, ROOT_DIR)

if __name__ == "__main__":
    main()
