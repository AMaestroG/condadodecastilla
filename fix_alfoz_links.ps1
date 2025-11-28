
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\lugares\alfozcerezolantaron"
$townDirs = Get-ChildItem -Path $rootPath -Directory

foreach ($dir in $townDirs) {
    $indexFile = Join-Path $dir.FullName "index.html"
    if (Test-Path $indexFile) {
        $content = Get-Content $indexFile -Raw
        # Replace broken relative link ../../alfoz.html with ../../../alfoz/alfoz.html
        # Also check for other variations if any
        if ($content -match 'href="\.\./\.\./alfoz\.html"') {
            $newContent = $content -replace 'href="\.\./\.\./alfoz\.html"', 'href="../../../alfoz/alfoz.html"'
            Set-Content -Path $indexFile -Value $newContent -Encoding UTF8
            Write-Host "Updated $indexFile"
        }
    }
}
