# Restore HTML files from backup
# The initial conversion approach was incorrect - files were already UTF-8

$rootPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla"
$backupPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\_encoding_backup"

if (-not (Test-Path $backupPath)) {
    Write-Host "Backup directory not found!" -ForegroundColor Red
    exit 1
}

# Find all backup files
$backupFiles = Get-ChildItem -Path $backupPath -Recurse -Filter "*.html"

$restoredCount = 0

Write-Host "`nRestoring HTML files from backup...`n" -ForegroundColor Cyan

foreach ($backupFile in $backupFiles) {
    $relativePath = $backupFile.FullName.Substring($backupPath.Length + 1)
    $targetFile = Join-Path $rootPath $relativePath
    
    # Restore the file
    Copy-Item -Path $backupFile.FullName -Destination $targetFile -Force
    $restoredCount++
    Write-Host "[RESTORED] $relativePath" -ForegroundColor Green
}

Write-Host "`n=== Restore Summary ===" -ForegroundColor Cyan
Write-Host "Restored: $restoredCount files" -ForegroundColor Green
