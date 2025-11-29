$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$files = Get-ChildItem -Path $root -Recurse -Filter *.html | Where-Object { $_.Name -notlike "_*" }

Write-Host "--- ANALYSIS START ---"

Write-Host "Checking for missing CSS (estilos_condado.css)..."
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "estilos_condado.css") {
        Write-Host "MISSING CSS: $($file.FullName)"
    }
}

Write-Host "`nChecking for missing Header Placeholder..."
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "header-placeholder") {
        Write-Host "MISSING HEADER: $($file.FullName)"
    }
}

Write-Host "`nChecking for missing Footer Placeholder..."
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "footer-placeholder") {
        Write-Host "MISSING FOOTER: $($file.FullName)"
    }
}

Write-Host "`nChecking for missing Layout JS..."
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "layout.js") {
        Write-Host "MISSING JS: $($file.FullName)"
    }
}

Write-Host "--- ANALYSIS END ---"
