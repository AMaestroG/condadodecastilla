# Debug encoding issues - Write to file
$path = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\index.html"
$outputPath = "c:\Users\ablma\Documents\Cerezo\Web\condadodecastilla\debug_output.txt"
$bytes = [System.IO.File]::ReadAllBytes($path)

$output = @()

function Get-Hex($offset, $count) {
    $end = [Math]::Min($offset + $count, $bytes.Length) - 1
    $chunk = $bytes[$offset..$end]
    $hex = $chunk | ForEach-Object { "{0:X2}" -f $_ }
    return "Offset $offset : $($hex -join ' ')"
}

$output += "Analyzing index.html bytes..."

# Find "Cerezo de R"
$s1 = [System.Text.Encoding]::ASCII.GetBytes("Cerezo de R")
for ($i = 0; $i -lt $bytes.Length - $s1.Length; $i++) {
    $match = $true
    for ($j = 0; $j -lt $s1.Length; $j++) {
        if ($bytes[$i + $j] -ne $s1[$j]) { $match = $false; break }
    }
    if ($match) {
        $output += "Found 'Cerezo de R' at $i"
        $output += Get-Hex $i 20
    }
}

# Find "Tir"
$s2 = [System.Text.Encoding]::ASCII.GetBytes("Tir")
for ($i = 0; $i -lt $bytes.Length - $s2.Length; $i++) {
    $match = $true
    for ($j = 0; $j -lt $s2.Length; $j++) {
        if ($bytes[$i + $j] -ne $s2[$j]) { $match = $false; break }
    }
    if ($match) {
        $output += "Found 'Tir' at $i"
        $output += Get-Hex $i 15
    }
}

$output | Out-File -FilePath $outputPath -Encoding UTF8
