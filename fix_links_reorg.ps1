$root = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"

# 1. Fix references INSIDE moved files (they are now 1 level deeper)
# Targets: historia/, cultura/, patrimonio/, blog/
$subdirs = @("historia", "cultura", "patrimonio", "blog")

foreach ($dir in $subdirs) {
    $files = Get-ChildItem -Path "$root\$dir" -Filter "*.html"
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        $original = $content
        
        # Fix assets, css, js, etc.
        # Simple regex to prepend ../ to root-relative paths that don't have it
        # We look for src="assets/..." and make it src="../assets/..."
        # But NOT if it's already ../assets/
        
        $content = $content -replace 'src="assets/', 'src="../assets/'
        $content = $content -replace "url\('assets/", "url('../assets/"
        $content = $content -replace 'href="assets/', 'href="../assets/'
        $content = $content -replace 'href="css/', 'href="../css/'
        $content = $content -replace 'href="js/', 'href="../js/'
        $content = $content -replace 'src="js/', 'src="../js/'
        $content = $content -replace 'href="index.html"', 'href="../index.html"'
        $content = $content -replace 'href="favicon.ico"', 'href="../favicon.ico"'
        
        # Fix siteRoot
        $content = $content -replace "window.siteRoot = '';", "window.siteRoot = '../';"
        
        # Fix links to other top-level folders that are now siblings
        # e.g. href="alfoz/..." -> href="../alfoz/..."
        $content = $content -replace 'href="alfoz/', 'href="../alfoz/'
        $content = $content -replace 'href="galeria/', 'href="../galeria/'
        $content = $content -replace 'href="contacto/', 'href="../contacto/'
        
        if ($content -ne $original) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8
            Write-Host "Updated internal links in: $($file.Name)"
        }
    }
}

# 2. Fix links TO moved files in ALL files
$allFiles = Get-ChildItem -Path $root -Include "*.html" -Recurse

foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw
    $original = $content
    
    # Map of Old -> New (relative to root)
    # If file is in root: href="timeline.html" -> href="historia/timeline.html"
    # If file is in subdir: href="../timeline.html" -> href="../historia/timeline.html"
    
    # Timeline
    $content = $content -replace 'href="timeline.html"', 'href="historia/timeline.html"'
    $content = $content -replace 'href="\.\./timeline.html"', 'href="../historia/timeline.html"'
    
    # Vida Cotidiana
    $content = $content -replace 'href="vida_cotidiana.html"', 'href="historia/vida_cotidiana.html"'
    $content = $content -replace 'href="\.\./vida_cotidiana.html"', 'href="../historia/vida_cotidiana.html"'
    
    # Leyendas
    $content = $content -replace 'href="leyendas.html"', 'href="cultura/leyendas.html"'
    $content = $content -replace 'href="\.\./leyendas.html"', 'href="../cultura/leyendas.html"'
    
    # Arquitectura
    $content = $content -replace 'href="arquitectura.html"', 'href="patrimonio/arquitectura.html"'
    $content = $content -replace 'href="\.\./arquitectura.html"', 'href="../patrimonio/arquitectura.html"'
    
    # Blog Index
    $content = $content -replace 'href="blog.html"', 'href="blog/blog.html"'
    $content = $content -replace 'href="\.\./blog.html"', 'href="../blog/blog.html"'
    
    # Blog Posts (wildcard-ish)
    # href="blog_foo.html" -> href="blog/blog_foo.html"
    # Regex: href="(blog_[^"]+\.html)" -> href="blog/$1"
    $content = $content -replace 'href="(blog_[^"]+\.html)"', 'href="blog/$1"'
    $content = $content -replace 'href="\.\./(blog_[^"]+\.html)"', 'href="../blog/$1"'
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated references in: $($file.Name)"
    }
}
