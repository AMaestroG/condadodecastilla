import os

def analyze_html_files():
    root_dir = r"c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
    
    missing_header = []
    missing_footer = []
    missing_css = []
    missing_js = []
    
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".html") and not filename.startswith("_"):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Check for CSS
                if "estilos_condado.css" not in content:
                    missing_css.append(filepath)
                
                # Check for Header
                if "header-placeholder" not in content:
                    missing_header.append(filepath)
                
                # Check for Footer
                if "footer-placeholder" not in content:
                    missing_footer.append(filepath)
                
                # Check for Layout JS
                if "layout.js" not in content:
                    missing_js.append(filepath)

    print("Files missing CSS link:")
    for f in missing_css: print(f)
    print("\nFiles missing Header Placeholder:")
    for f in missing_header: print(f)
    print("\nFiles missing Footer Placeholder:")
    for f in missing_footer: print(f)
    print("\nFiles missing Layout JS:")
    for f in missing_js: print(f)

if __name__ == "__main__":
    analyze_html_files()
