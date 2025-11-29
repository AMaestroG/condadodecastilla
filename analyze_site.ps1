$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$files = Get-ChildItem -Path $root -Recurse -Filter *.html | Where-Object { $_.Name -notlike "_*" }

$missingCSS = @()
$missingHeader = @()
$missingFooter = @()
$missingJS = @()

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    if ($content -notmatch "estilos_condado.css") {
        $missingCSS += $file.FullName
    }
    if ($content -notmatch "header-placeholder") {
        $missingHeader += $file.FullName
    }
    if ($content -notmatch "footer-placeholder") {
        $missingFooter += $file.FullName
    }
    if ($content -notmatch "layout.js") {
        $missingJS += $file.FullName
    }
}

Write-Host "Files missing CSS link:"
$missingCSS | ForEach-Object { Write-Host $_ }

Write-Host "`nFiles missing Header Placeholder:"
$missingHeader | ForEach-Object { Write-Host $_ }

Write-Host "`nFiles missing Footer Placeholder:"
$missingFooter | ForEach-Object { Write-Host $_ }

Write-Host "`nFiles missing Layout JS:"
$missingJS | ForEach-Object { Write-Host $_ }
