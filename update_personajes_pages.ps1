
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\personajes"
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html"

foreach ($file in $files) {
    if ($file.Name -eq "indice_personajes.html") { continue }

    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace footer
    if ($content -match '<footer[\s\S]*?</footer>') {
        $content = $content -replace '<footer[\s\S]*?</footer>', '<div id="footer-placeholder"></div>'
        Write-Host "Updated footer in $($file.Name)"
    }

    # Ensure siteRoot is present if not already
    if (-not ($content -match 'window.siteRoot')) {
        $content = $content -replace '<script src="\.\./\.\./js/layout.js"></script>', '<script>window.siteRoot = "../../";</script><script src="../../js/layout.js"></script>'
        Write-Host "Added siteRoot to $($file.Name)"
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}
