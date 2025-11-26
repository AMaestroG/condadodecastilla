# Convert HTML files from Windows-1252 to UTF-8
# This script fixes mojibake issues with Spanish accents

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$backupPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\_encoding_backup"

# Create backup directory
if (-not (Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    Write-Host "Created backup directory: $backupPath" -ForegroundColor Green
}

# Find all HTML files
$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.html" | Where-Object { 
    $_.FullName -notmatch "condadodecastilla.com" -and 
    $_.FullName -notmatch "_encoding_backup"
}

$totalFiles = $files.Count
$convertedCount = 0
$errorCount = 0

Write-Host "`nFound $totalFiles HTML files to process`n" -ForegroundColor Cyan

foreach ($file in $files) {
    try {
        $relativePath = $file.FullName.Substring($rootPath.Length + 1)
        
        # Create backup subdirectory structure
        $backupFile = Join-Path $backupPath $relativePath
        $backupDir = Split-Path $backupFile -Parent
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        
        # Backup original file
        Copy-Item -Path $file.FullName -Destination $backupFile -Force
        
        # Read file with Windows-1252 encoding (default for Spanish Windows)
        $content = Get-Content -Path $file.FullName -Raw -Encoding Default
        
        # Write back as UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        
        $convertedCount++
        Write-Host "[OK] $relativePath" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "[ERROR] $relativePath - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Conversion Summary ===" -ForegroundColor Cyan
Write-Host "Total files: $totalFiles" -ForegroundColor White
Write-Host "Converted: $convertedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "Backups saved to: $backupPath" -ForegroundColor Yellow
