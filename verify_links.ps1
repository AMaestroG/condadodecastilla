$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$htmlFiles = Get-ChildItem -Path $root -Include "*.html" -Recurse

$brokenLinks = @()

foreach ($file in $htmlFiles) {
    # Skip layout templates which are dynamically loaded
    if ($file.Name -like "_*.html") {
        continue
    }

    $content = Get-Content $file.FullName -Raw
    
    # Regex to find href and src
    $links = [regex]::Matches($content, '(href|src)="([^"]+)"')
    
    foreach ($match in $links) {
        $type = $match.Groups[1].Value
        $link = $match.Groups[2].Value
        
        # Strip query strings and anchors
        $link = $link -replace '[?#].*$', ''

        # Skip external links, mailto, data, and empty links
        if ($link -match "^(http|//|mailto:|data:)" -or [string]::IsNullOrWhiteSpace($link)) {
            continue
        }
        
        # Resolve path
        $currentDir = $file.DirectoryName
        
        # Handle root-relative links
        if ($link.StartsWith("/")) {
            $targetPath = Join-Path $root $link.TrimStart("/")
        }
        else {
            $targetPath = Join-Path $currentDir $link
        }
        
        # Normalize path
        try {
            $targetPath = [System.IO.Path]::GetFullPath($targetPath)
        }
        catch {
            $brokenLinks += [PSCustomObject]@{
                SourceFile = $file.FullName
                Link       = $link
                Reason     = "Invalid Path Syntax"
            }
            continue
        }
        
        # Check if file exists
        if (-not (Test-Path $targetPath)) {
            # Check if it's a directory (some links might point to folders, expecting index.html)
            if (-not (Test-Path "$targetPath\index.html")) {
                $brokenLinks += [PSCustomObject]@{
                    SourceFile   = $file.FullName
                    Link         = $link
                    ResolvedPath = $targetPath
                    Reason       = "File Not Found"
                }
            }
        }
    }
}

if ($brokenLinks.Count -gt 0) {
    $report = $brokenLinks | Format-List | Out-String
    Set-Content -Path "broken_links_report.txt" -Value $report -Encoding UTF8
    Write-Host "Found $($brokenLinks.Count) broken links. Report saved to broken_links_report.txt" -ForegroundColor Red
}
else {
    Write-Host "No broken internal links found!" -ForegroundColor Green
}
