
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch "condadodecastilla.com" }

& {
    foreach ($file in $files) {
        $relativePath = $file.FullName.Substring($rootPath.Length + 1)
        $depth = ($relativePath.Split('\').Count) - 1
        Write-Output "DEBUG: $relativePath (Depth $depth)"
        
        $expectedRoot = ""
        if ($depth -gt 0) {
            $expectedRoot = "../" * $depth
        }
        else {
            $expectedRoot = "./" 
        }

        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        if ($depth -eq 0) {
            continue
        }

        if ($content -match 'window\.siteRoot\s*=\s*["''](.*?)["'']') {
            $actualRoot = $matches[1]
            if ($actualRoot -ne $expectedRoot) {
                Write-Output "MISMATCH: $($file.Name) (Depth $depth). Expected '$expectedRoot', Found '$actualRoot'"
            }
        }
        else {
            Write-Output "MISSING: $($file.Name) (Depth $depth). Expected '$expectedRoot'"
        }
    }
} | Out-File -FilePath siteroot_log.txt -Encoding UTF8
