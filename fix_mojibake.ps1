# Fix mojibake characters in HTML files
# Replace Windows-1252 mojibake with correct UTF-8 Spanish characters

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

# Find all HTML files
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { 
    $_.FullName -notmatch "condadodecastilla.com" -and 
    $_.FullName -notmatch "_encoding_backup"
}

$totalFiles = $files.Count
$fixedCount = 0
$unchangedCount = 0

Write-Host "`nFixing mojibake in $totalFiles HTML files...`n" -ForegroundColor Cyan

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    
    # Read file as UTF-8
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Apply replacements for common Spanish mojibake patterns
    $content = $content.Replace('Ã­', 'í')  # i with acute
    $content = $content.Replace('Ã³', 'ó')  # o with acute
    $content = $content.Replace('Ã¡', 'á')  # a with acute
    $content = $content.Replace('Ã©', 'é')  # e with acute
    $content = $content.Replace('Ãº', 'ú')  # u with acute
    $content = $content.Replace('Ã±', 'ñ')  # n with tilde
    $content = $content.Replace('Ã¼', 'ü')  # u with diaeresis
    $content = $content.Replace('Ã', 'Í')  # I with acute
    $content = $content.Replace('Ã"', 'Ó')  # O with acute
    $content = $content.Replace('Ã', 'Á')  # A with acute
    $content = $content.Replace('Ã‰', 'É')  # E with acute
    $content = $content.Replace('Ãš', 'Ú')  # U with acute
    $content = $content.Replace('Ã'', 'Ñ')  # N with tilde
    $content = $content.Replace('Ãœ', 'Ü')  # U with diaeresis
    $content = $content.Replace('Â¿', '¿')  # inverted question mark
    $content = $content.Replace('Â¡', '¡')  # inverted exclamation mark
    
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
