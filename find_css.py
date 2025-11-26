file_path = r'c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\css\estilos_condado.css'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if '.sidebar-toggle' in line:
        print(f"Found at line {i+1}: {line.strip()}")
        # Print next few lines to confirm
        for j in range(1, 5):
            if i+j < len(lines):
                print(f"Line {i+1+j}: {lines[i+j].strip()}")
        break
