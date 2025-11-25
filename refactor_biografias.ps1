$baseDir = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\personajes"
$htmlFiles = Get-ChildItem -Path $baseDir -Recurse -Filter "*.html" | Where-Object { $_.Name -ne "indice_personajes.html" }

Write-Output "Procesando $($htmlFiles.Count) archivos..."

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    $content = $content -replace '<div class="content-wrapper" style="text-align: center;">', '<div class="content-wrapper">'
    $content = $content -replace 'class="personaje-imagen-principal"\s+style="[^"]*"', 'class="personaje-imagen-principal"'
    $content = $content -replace '<div style="text-align: justify; margin-bottom: 2em;">', '<div class="bio-text">'
    $content = $content -replace '<ul style="text-align: left; display: inline-block; margin-bottom: 2em;">', '<ul class="bio-list-wrapper">'
    $content = $content -replace '<div style="text-align:center; margin-top: 2em;">', '<div class="nav-button-wrapper">'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Output "Refactorizado: $($file.Name)"
    }
}

Write-Output "Refactorizacion completada"
