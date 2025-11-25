
$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\lugares\alfozcerezolantaron"
$dirs = Get-ChildItem -Path $rootPath -Directory

foreach ($dir in $dirs) {
    $townName = $dir.Name -replace "_", " "
    $indexPath = Join-Path $dir.FullName "index.html"

    if (Test-Path $indexPath) {
        $fileItem = Get-Item $indexPath
        if ($fileItem.Length -gt 2000) {
            Write-Host "Skipping $townName (File too large, likely custom content)"
            continue
        }

        $content = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$townName - Alfoz de Cerezo</title>
    <link rel="icon" href="../../../assets/img/escudo.jpg" type="image/jpeg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Lora:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../../../css/estilos_condado.css">
</head>
<body>
    <div id="header-placeholder"></div>
    
    <header class="page-header hero" style="background-image: linear-gradient(rgba(var(--color-primario-purpura-rgb), 0.7), rgba(var(--color-negro-contraste-rgb), 0.85)), url('../../../assets/img/hero_alfoz_background.jpg');">
        <div class="hero-content">
            <h1>$townName</h1>
            <p>Integrante del histórico Alfoz de Cerezo y Lantarón</p>
        </div>
    </header>

    <main>
        <section class="section">
            <div class="container imperial-frame">
                <p>Bienvenido al archivo del pueblo de <strong>$townName</strong>. Aquí encontrarás información histórica y cultural sobre esta localidad.</p>
                <div class="alert-box" style="background-color: rgba(255, 215, 0, 0.1); border-left: 4px solid var(--condado-secundario); padding: 1em; margin: 1em 0;">
                    <p><em>Esta sección está en construcción. Próximamente añadiremos más detalles.</em></p>
                </div>
                <div style="text-align: center; margin-top: 2em;">
                    <a href="../../alfoz.html" class="cta-button">Volver al Alfoz</a>
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
        Set-Content -Path $indexPath -Value $content -Encoding UTF8
        Write-Host "Updated $townName"
    }
    else {
        Write-Host "No index.html found in $townName"
    }
}
