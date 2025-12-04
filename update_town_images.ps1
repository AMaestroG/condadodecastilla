$townsDir = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\lugares\alfozcerezolantaron"
$genericImage1 = "../../../assets/img/lugares/pueblo_castellano_medieval.png"
$genericImage2 = "../../../assets/img/lugares/torre_defensiva_medieval.png"

$towns = Get-ChildItem -Path $townsDir -Directory

foreach ($town in $towns) {
    $indexPath = Join-Path $town.FullName "index.html"
    if (Test-Path $indexPath) {
        $content = Get-Content $indexPath -Raw
        
        # Check if it has a specific image or needs a generic one
        # Assuming we want to replace placeholders or specific patterns
        # Or just inject into the hero section if it's missing
        
        # Simple logic: Alternate between the two generic images
        $imageToUse = if ($town.Name.Length % 2 -eq 0) { $genericImage1 } else { $genericImage2 }
        
        # Replace hero image if it's a placeholder or default
        # Regex to find hero style background-image
        if ($content -match "url\('(\.\./)+assets/img/hero_default_background\.jpg'\)") {
            $content = $content -replace "url\('(\.\./)+assets/img/hero_default_background\.jpg'\)", "url('$imageToUse')"
            Set-Content -Path $indexPath -Value $content -Encoding UTF8
            Write-Host "Updated hero image for $($town.Name)"
        }
        
        # Also look for <img src="..."> that might be a placeholder
        # This is riskier without specific targets, so we'll stick to the hero background for now
        # unless we find a specific "placeholder.jpg"
    }
}
