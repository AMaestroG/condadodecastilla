# Script to fix UTF-8 encoding in all HTML files
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html"

foreach ($file in $files) {
    try {
        # Read file content without BOM
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Write back with UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        
        Write-Host "Fixed: $($file.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nEncoding fix complete!" -ForegroundColor Cyan
