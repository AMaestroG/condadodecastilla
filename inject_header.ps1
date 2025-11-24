
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$htmlFiles = Get-ChildItem -Path $rootPath -Recurse -Filter *.html

foreach ($file in $htmlFiles) {
    # Skip the template files themselves
    if ($file.Name -eq "_header.html" -or $file.Name -eq "_footer.html") { continue }

    $content = Get-Content -Path $file.FullName -Raw
    $modified = $false

    # Calculate relative path to root
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    $depth = ($relativePath.Split('\').Count) - 1
    $prefix = ""
    if ($depth -gt 0) {
        $prefix = "../" * $depth
    }

    # 1. Inject Header Placeholder
    if (-not ($content -match 'id="header-placeholder"')) {
        if ($content -match '<body[^>]*>') {
            $content = $content -replace '(<body[^>]*>)', "`$1`n    <div id=""header-placeholder""></div>"
            $modified = $true
            Write-Host "Added header-placeholder to $($file.Name)"
        }
    }

    # 2. Inject SiteRoot and Layout Script
    # We look for the layout script. If it exists, we replace it to ensure siteRoot is defined before it.
    # If it doesn't exist, we append it.
    
    $scriptBlock = "    <script>window.siteRoot = '$prefix';</script>`n    <script src=""$($prefix)js/layout.js""></script>"
    
    if ($content -match '<script src=".*js/layout.js"></script>') {
        # Update existing script tag to include siteRoot
        # Regex to match the existing script tag line
        $content = $content -replace '\s*<script src=".*js/layout.js"></script>', "`n$scriptBlock"
        $modified = $true
        Write-Host "Updated layout.js injection in $($file.Name)"
    }
    elseif (-not ($content -match 'src=".*js/layout.js"')) {
        # Insert before </body> tag if not present
        if ($content -match '</body>') {
            $content = $content -replace '</body>', "$scriptBlock`n</body>"
            $modified = $true
            Write-Host "Added layout.js to $($file.Name)"
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}
