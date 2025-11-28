
$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$alfozDir = Join-Path $root "lugares\alfozcerezolantaron"

# Get all town directories
$townDirs = Get-ChildItem -Path $alfozDir -Directory | Sort-Object Name
$towns = @()

foreach ($dir in $townDirs) {
    $indexFile = Join-Path $dir.FullName "index.html"
    if (Test-Path $indexFile) {
        # Extract town name from title or folder name
        $content = Get-Content $indexFile -Raw
        $townName = $dir.Name -replace "_", " "
        if ($content -match '<title>(.*?) -') {
            $townName = $matches[1]
        }
        
        $towns += [PSCustomObject]@{
            Name    = $townName
            DirName = $dir.Name
            Path    = $indexFile
        }
    }
}

$count = $towns.Count
for ($i = 0; $i -lt $count; $i++) {
    $current = $towns[$i]
    $prev = $towns[($i - 1 + $count) % $count]
    $next = $towns[($i + 1) % $count]
    
    $navHtml = @"
<div class="town-navigation" style="display: flex; justify-content: space-between; align-items: center; margin-top: 2em; flex-wrap: wrap; gap: 1em;">
                    <a href="../$($prev.DirName)/index.html" class="cta-button prev-town" title="Ir a $($prev.Name)">← $($prev.Name)</a>
                    <a href="../../../alfoz/alfoz.html" class="cta-button">Volver al Alfoz</a>
                    <a href="../$($next.DirName)/index.html" class="cta-button next-town" title="Ir a $($next.Name)">$($next.Name) →</a>
                </div>
"@
    
    $content = Get-Content $current.Path -Raw
    
    # Regex to find the existing navigation or the "Volver al Alfoz" button container
    # We look for the specific div structure we saw earlier
    $pattern = '(?s)<div style="text-align: center; margin-top: 2em;">\s*<a href=".*?alfoz\.html".*?>.*?</a>\s*</div>'
    
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $navHtml
        Set-Content -Path $current.Path -Value $content
        Write-Host "Updated navigation for $($current.Name)"
    }
    elseif ($content -match '<div class="town-navigation".*?</div>') {
        # Already has nav, update it
        $content = $content -replace '(?s)<div class="town-navigation".*?</div>', $navHtml
        Set-Content -Path $current.Path -Value $content
        Write-Host "Refreshed navigation for $($current.Name)"
    }
    else {
        Write-Warning "Could not find navigation placeholder in $($current.Name)"
    }
}
