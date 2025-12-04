$blogFiles = Get-ChildItem -Path "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\blog" -Filter "blog_*.html"

foreach ($file in $blogFiles) {
    $content = Get-Content $file.FullName -Raw
    $original = $content
    
    # Fix link back to blog index
    $content = $content -replace 'href="blog/blog.html"', 'href="blog.html"'
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Fixed link in $($file.Name)"
    }
}
