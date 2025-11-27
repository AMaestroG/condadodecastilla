
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$htmlFiles = Get-ChildItem -Path $rootPath -Filter *.html -Recurse

$errors = @()

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    # Regex to find href attributes. Simple version, might miss some edge cases but good for static site.
    $matches = [regex]::Matches($content, 'href=["'']([^"''#]+)(?:#[^"'']*)?["'']')

    foreach ($match in $matches) {
        $link = $match.Groups[1].Value
        
        # Skip external links, mailto, tel, javascript
        if ($link -match "^(http|https|mailto:|tel:|javascript:)") {
            continue
        }

        # Resolve path
        # If it starts with /, it's relative to root (though usually in local dev it might be relative to drive, but let's assume site root)
        # Actually, standard HTML without server treats / as drive root. 
        # But looking at previous code, they use relative paths like ../../
        
        $targetPath = ""
        if ($link.StartsWith("/")) {
            # Assuming / means site root for this check, though locally it fails without a server.
            # Let's treat it as relative to $rootPath
            $targetPath = Join-Path $rootPath $link.TrimStart("/")
        }
        else {
            # Relative to current file
            $targetPath = Join-Path $file.DirectoryName $link
        }

        # Normalize path (resolve ..)
        try {
            $targetPath = [System.IO.Path]::GetFullPath($targetPath)
        }
        catch {
            $errors += "Invalid path format in $($file.Name): $link"
            continue
        }

        # Check existence
        if (-not (Test-Path $targetPath)) {
            $errors += "BROKEN LINK in '$($file.FullName)': points to '$link' (Resolved: $targetPath)"
        }
    }
}

if ($errors.Count -eq 0) {
    Write-Host "No broken links found."
}
else {
    Write-Host "Found $($errors.Count) broken links:"
    $errors | ForEach-Object { Write-Host $_ }
}
