
$path = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\lugares\alfozcerezolantaron"
$files = Get-ChildItem -Path $path -Recurse -Filter "index.html"
foreach ($file in $files) {
    if ($file.Length -gt 2000) {
        Write-Output "$($file.FullName) - $($file.Length) bytes"
    }
}
