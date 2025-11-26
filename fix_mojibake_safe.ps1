# Fix mojibake characters in HTML files (Safe Version)
# Uses unicode escapes to avoid script encoding issues

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

# Helper to create string from char code
function Char($code) {
    return [char]$code
}

# Define replacements using char codes to be safe
# Ã = 0x00C3, Â = 0x00C2
$A_tilde = Char 0x00C3
$A_circum = Char 0x00C2

# Target characters
$i_acute = Char 0x00ED # í
$o_acute = Char 0x00F3 # ó
$a_acute = Char 0x00E1 # á
$e_acute = Char 0x00E9 # é
$u_acute = Char 0x00FA # ú
$n_tilde = Char 0x00F1 # ñ
$N_tilde = Char 0x00D1 # Ñ
$u_umlaut = Char 0x00FC # ü
$inv_quest = Char 0x00BF # ¿
$inv_excl = Char 0x00A1 # ¡
$I_acute = Char 0x00CD # Í
$O_acute = Char 0x00D3 # Ó
$A_acute = Char 0x00C1 # Á
$E_acute = Char 0x00C9 # É
$U_acute = Char 0x00DA # Ú

# Mojibake second bytes (when interpreted as Win1252)
# These are the characters that follow Ã (0xC3) or Â (0xC2)
# Based on UTF-8 byte sequences interpreted as Win1252

# í (C3 AD) -> Ã + soft hyphen (0xAD)
$pat_i = "$A_tilde$(Char 0x00AD)"

# ó (C3 B3) -> Ã + superscript 3 (0xB3)
$pat_o = "$A_tilde$(Char 0x00B3)"

# á (C3 A1) -> Ã + ¡ (0xA1)
$pat_a = "$A_tilde$(Char 0x00A1)"

# é (C3 A9) -> Ã + © (0xA9)
$pat_e = "$A_tilde$(Char 0x00A9)"

# ú (C3 BA) -> Ã + º (0xBA)
$pat_u = "$A_tilde$(Char 0x00BA)"

# ñ (C3 B1) -> Ã + ± (0xB1)
$pat_n = "$A_tilde$(Char 0x00B1)"

# Ñ (C3 91) -> Ã + ‘ (0x2018) - 0x91 in Win1252 maps to U+2018
$pat_N = "$A_tilde$(Char 0x2018)"

# ü (C3 BC) -> Ã + ¼ (0xBC)
$pat_u_uml = "$A_tilde$(Char 0x00BC)"

# ¿ (C2 BF) -> Â + ¿ (0xBF)
$pat_quest = "$A_circum$(Char 0x00BF)"

# ¡ (C2 A1) -> Â + ¡ (0xA1)
$pat_excl = "$A_circum$(Char 0x00A1)"

# Uppercase vowels (less common but possible)
# É (C3 89) -> Ã + ‰ (0x2030) - 0x89 in Win1252
$pat_E = "$A_tilde$(Char 0x2030)"

# Ú (C3 9A) -> Ã + š (0x0161) - 0x9A in Win1252
$pat_U = "$A_tilde$(Char 0x0161)"

# Ó (C3 93) -> Ã + “ (0x201C) - 0x93 in Win1252
$pat_O = "$A_tilde$(Char 0x201C)"

# Á (C3 81) -> Ã + (0x81) - Undefined in Win1252, often maps to nothing or box. 
# We'll skip Á for now unless we see it, as 0x81 is tricky.

# Find all HTML files
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { 
    $_.FullName -notmatch "condadodecastilla.com" -and 
    $_.FullName -notmatch "_encoding_backup"
}

$totalFiles = $files.Count
$fixedCount = 0
$unchangedCount = 0

Write-Host "`nFixing mojibake in $totalFiles HTML files (Safe Mode)...`n" -ForegroundColor Cyan

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    
    # Read file as UTF-8
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Apply replacements
    $content = $content.Replace($pat_i, $i_acute)
    $content = $content.Replace($pat_o, $o_acute)
    $content = $content.Replace($pat_a, $a_acute)
    $content = $content.Replace($pat_e, $e_acute)
    $content = $content.Replace($pat_u, $u_acute)
    $content = $content.Replace($pat_n, $n_tilde)
    $content = $content.Replace($pat_N, $N_tilde)
    $content = $content.Replace($pat_u_uml, $u_umlaut)
    $content = $content.Replace($pat_quest, $inv_quest)
    $content = $content.Replace($pat_excl, $inv_excl)
    $content = $content.Replace($pat_E, $E_acute)
    $content = $content.Replace($pat_U, $U_acute)
    $content = $content.Replace($pat_O, $O_acute)
    
    # Only write if content changed
    if ($content -ne $originalContent) {
        # Write back as UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        
        $fixedCount++
        Write-Host "[FIXED] $relativePath" -ForegroundColor Green
    }
    else {
        $unchangedCount++
    }
}

Write-Host "`n=== Fix Summary ===" -ForegroundColor Cyan
Write-Host "Total files: $totalFiles" -ForegroundColor White
Write-Host "Fixed: $fixedCount" -ForegroundColor Green
Write-Host "Unchanged: $unchangedCount" -ForegroundColor Gray
