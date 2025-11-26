# Fix double-encoding issues using binary replacement
# Replaces specific byte sequences that represent double-encoded UTF-8 characters

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

# Define replacements (Hex strings)
$replacements = @{
    # Lowercase vowels
    "C383C2AD"   = "C3AD" # í
    "C383C2B3"   = "C3B3" # ó
    "C383C2A1"   = "C3A1" # á
    "C383C2A9"   = "C3A9" # é
    "C383C2BA"   = "C3BA" # ú
    "C383C2B1"   = "C3B1" # ñ
    "C383C2BC"   = "C3BC" # ü
    
    # Symbols
    "C382C2BF"   = "C2BF" # ¿
    "C382C2A1"   = "C2A1" # ¡
    
    # Uppercase (based on Win1252 mapping)
    "C383E28098" = "C391" # Ñ (91 -> ‘ -> E2 80 98)
    "C383E2809C" = "C393" # Ó (93 -> “ -> E2 80 9C)
    "C383C5A1"   = "C39A" # Ú (9A -> š -> C5 A1)
    "C383E280B0" = "C389" # É (89 -> ‰ -> E2 80 B0)
    
    # Á (81) and Í (8D) are undefined in Win1252, so they usually don't get double-encoded 
    # in a reversible way, or they map to nothing. 
    # If we see them, we might need manual fix, but let's start with these.
}

# Find all HTML files
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { 
    $_.FullName -notmatch "condadodecastilla.com" -and 
    $_.FullName -notmatch "_encoding_backup"
}

$totalFiles = $files.Count
$fixedCount = 0
$unchangedCount = 0

Write-Host "`nFixing double-encoding in $totalFiles HTML files...`n" -ForegroundColor Cyan

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    
    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        
        # Convert to hex string
        $hex = [BitConverter]::ToString($bytes).Replace("-", "")
        $originalHex = $hex
        
        # Apply replacements
        foreach ($key in $replacements.Keys) {
            if ($hex.Contains($key)) {
                $hex = $hex.Replace($key, $replacements[$key])
            }
        }
        
        if ($hex -ne $originalHex) {
            # Convert back to bytes
            # Split by 2 chars
            $newBytes = for ($i = 0; $i -lt $hex.Length; $i += 2) {
                [Convert]::ToByte($hex.Substring($i, 2), 16)
            }
            
            [System.IO.File]::WriteAllBytes($file.FullName, $newBytes)
            $fixedCount++
            Write-Host "[FIXED] $relativePath" -ForegroundColor Green
        }
        else {
            $unchangedCount++
            # Write-Host "[OK] $relativePath" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[ERROR] $relativePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Fix Summary ===" -ForegroundColor Cyan
Write-Host "Total files: $totalFiles" -ForegroundColor White
Write-Host "Fixed: $fixedCount" -ForegroundColor Green
Write-Host "Unchanged: $unchangedCount" -ForegroundColor Gray
