$towns = @(
    "Anguta", "Arana", "Arce", "Arceo", "Argote", "Armentia", "Artaza", "Arzubiaga", "Atiega", "Bañares", 
    "Barcina_de_los_Montes", "Barrasa", "Bascuñuelos", "Bellojin", "Castellum", "Castrillo", "Cerraton", 
    "Ciella", "Comunion", "Encio", "Espejo", "Foncea", "Fontecha", "Galbarruli", "Granon", "Guinicio", 
    "Gurendes", "Ibrillos", "Ircio", "La_Nave", "Leiva", "Manzanos", "Molinilla", "Montanana", "Monte", 
    "Moriana", "Nograro", "Ochanduri", "Ocio", "Ojacastro", "Oron", "Pancorbo", "Pazuengos", "Pinedo", 
    "Portilla", "Posada", "Poza_de_la_Sal", "Quejo", "Recilla", "Salcedo", "San_Emilianus", 
    "San_Miguel_de_Pedroso", "San_Millan_de_Yecora", "San_Zadornil", "Santa_Gadea_del_Cid", "Sobron", 
    "Sotillo_de_Rioja", "Suzana", "Tirgo", "Tormantos", "Trevino", "Tuesta", "Turiso", "Valpuesta", 
    "Velasco", "Villafria", "Villalbos", "Villalmondar", "Villamaderne", "Villanueva_de_Gurendes", 
    "Villanueva_de_Teba", "Zubillaga"
)

$template = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TownName}} - Alfoz de Cerezo - Condado de Castilla</title>
    <link rel="icon" href="../../../assets/img/escudo.jpg" type="image/jpeg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Lora:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../../../css/estilos_condado.css">
</head>
<body>
    <div id="header-placeholder"></div>

    <header class="page-header hero" style="background-image: linear-gradient(rgba(var(--condado-primario-rgb), 0.65), rgba(44, 29, 18, 0.8)), url('../../../assets/img/lugares/{{HeroImage}}');">
        <div class="hero-content">
            <h1>{{TownName}}</h1>
            <p>Villa histórica del Alfoz de Cerezo y Lantarón</p>
        </div>
    </header>

    <main>
        <section class="section">
            <div class="container imperial-frame">
                <div class="content-wrapper">
                    <div class="bio-text">
                        <p>
                            <strong>{{TownName}}</strong> es una de las localidades históricas que formaron parte del extenso <strong>Alfoz de Cerezo y Lantarón</strong>.
                            Su historia está ligada a la repoblación y defensa de la primitiva Castilla.
                        </p>
                        <p>
                            Próximamente añadiremos más información detallada sobre su patrimonio, historia y relevancia en la conformación del Condado.
                        </p>
                    </div>
                    
                    <div class="nav-button-wrapper">
                        <a href="../../alfoz.html" class="cta-button">Volver al Alfoz</a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <div id="footer-placeholder"></div>
    <script>window.siteRoot = '../../../';</script>
    <script src="../../../js/layout.js"></script>
</body>
</html>
"@

$alfozFile = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\alfoz\alfoz.html"
$alfozContent = Get-Content $alfozFile -Raw

foreach ($town in $towns) {
    $dirPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\lugares\alfozcerezolantaron\$town"
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
    }

    $heroImage = if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) { "pueblo_castellano_medieval.png" } else { "torre_defensiva_medieval.png" }
    $townNameClean = $town -replace "_", " "
    $pageContent = $template -replace "{{TownName}}", $townNameClean -replace "{{HeroImage}}", $heroImage

    $filePath = "$dirPath\index.html"
    if (-not (Test-Path $filePath)) {
        Set-Content -Path $filePath -Value $pageContent -Encoding UTF8
        Write-Host "Generated page for $town"
    }

    # Update link in alfoz.html
    # Handle variations in town name formatting in the HTML (e.g., "Barcina de los Montes" vs "Barcina\n                        de los Montes")
    # Simple regex to find the link. Assuming the text link matches the town name somewhat or we can find the href="#"
    
    # Strategy: Find href="#" ... >TownName< and replace href
    # This is tricky with regex due to newlines.
    # Let's try a simpler approach: replace specific known strings if possible, or just use a robust regex.
    
    # Constructing a regex that matches the anchor tag for this town
    # We look for href="#" ... and the town name inside.
    # The town name in HTML might have newlines.
    
    # Simplified approach for this script:
    # We will search for the specific line structure seen in the file view:
    # <a href="#" class="town-card-link disabled-link" title="Próximamente"\n                        class="town-card-link">Town Name</a>
    
    # Actually, let's just use the town name to find the block.
    # Note: The town variable uses underscores, HTML uses spaces.
    $townNameHtml = $townNameClean
    
    # Regex to match the href="#" part before the town name
    # We look for: <a href="#" [^>]*>(\s*)$townNameHtml
    # And replace href="#" with href="../lugares/alfozcerezolantaron/$town/index.html" and remove disabled classes/titles
    
    $pattern = 'href="#" class="town-card-link disabled-link" title="Próximamente"\s+class="town-card-link">\s*' + [Regex]::Escape($townNameHtml)
    $replacement = 'href="../lugares/alfozcerezolantaron/' + $town + '/index.html" class="town-card-link">' + $townNameHtml
    
    if ($alfozContent -match $pattern) {
        $alfozContent = $alfozContent -replace $pattern, $replacement
        Write-Host "Updated link for $town"
    }
    else {
        # Try matching with newlines in the name if it failed (e.g. Barcina\n de los Montes)
        # This is a bit complex for a simple script without reading the file line by line or using advanced regex.
        # Let's try a more generic regex for the anchor tag.
        
        # <a href="#" ... > ... TownName ... </a>
        # We can try to match the specific town name and lookbehind.
        
        # Let's just log if not found and we can do manual fix or improved regex later.
        Write-Warning "Could not find link pattern for $town"
    }
}

Set-Content -Path $alfozFile -Value $alfozContent -Encoding UTF8
Write-Host "Alfoz page updated."
