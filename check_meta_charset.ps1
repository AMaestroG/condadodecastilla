# Check and add missing <meta charset="UTF-8"> tags

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

# Find all HTML files
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { 
    $_.FullName -notmatch "condadodecastilla.com" -and 
    $_.FullName -notmatch "_encoding_backup"
}

$totalFiles = $files.Count
$hasCharset = 0
$missingCharset = 0
$fixedCount = 0

Write-Host "`nChecking $totalFiles HTML files for charset meta tag`n" -ForegroundColor Cyan

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Check if charset meta tag exists (simple string search)
    if ($content -like '*<meta charset="UTF-8">*' -or $content -like "*<meta charset='UTF-8'>*") {
        $hasCharset++
        Write-Host "[OK] $relativePath" -ForegroundColor Green
    }
    else {
        $missingCharset++
        Write-Host "[MISSING] $relativePath" -ForegroundColor Yellow
        
        # Try to add charset meta tag after <head>
        $headPattern = '<head>'
        if ($content.Contains($headPattern)) {
            $newContent = $content.Replace($headPattern, "$headPattern`r`n    <meta charset=`"UTF-8`">")
            
            # Write back with UTF-8 encoding
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $newContent, $utf8NoBom)
            
            $fixedCount++
            Write-Host "  -> Added charset meta tag" -ForegroundColor Cyan
        }
        else {
            Write-Host "  -> Could not find <head> tag to insert charset" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== Charset Check Summary ===" -ForegroundColor Cyan
Write-Host "Total files: $totalFiles" -ForegroundColor White
Write-Host "Already has charset: $hasCharset" -ForegroundColor Green
Write-Host "Missing charset: $missingCharset" -ForegroundColor Yellow
Write-Host "Fixed: $fixedCount" -ForegroundColor Cyan
