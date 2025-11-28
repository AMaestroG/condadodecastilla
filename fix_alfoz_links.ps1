
$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$targetDir = Join-Path $root "lugares\alfozcerezolantaron"

# Get all index.html files in subdirectories
$files = Get-ChildItem -Path $targetDir -Recurse -Filter "index.html"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Fix the specific broken link to alfoz.html
    if ($content -match 'href="\.\./\.\./alfoz\.html"') {
        $content = $content -replace 'href="\.\./\.\./alfoz\.html"', 'href="../../../alfoz/alfoz.html"'
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Fixed link in $($file.FullName)"
    }
    
    # Also fix any other common broken links if found, e.g. to css/estilos_condado.css if depth is wrong
    # But primarily the alfoz one was flagged.
}
