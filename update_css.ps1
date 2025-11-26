$file = "css\estilos_condado.css"
$content = Get-Content $file -Raw -Encoding UTF8

$pattern = "(?s)\.sidebar-toggle\s*\{.*?\}"
$newCss = @"
/* Header Controls & Toggles */
.header-controls {
  z-index: 10001;
}

.sidebar-toggle,
.lang-toggle,
.theme-toggle {
  position: fixed;
  top: 20px;
  z-index: 10001;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5em;
  background: linear-gradient(135deg, var(--condado-primario), #2a053d);
  color: var(--condado-acento);
  text-transform: uppercase;
  font-weight: 900;
  border: 2px solid var(--condado-secundario);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  cursor: pointer;
  transition: all 0.3s ease;
}

.sidebar-toggle:hover,
.lang-toggle:hover,
.theme-toggle:hover {
  transform: scale(1.1);
  box-shadow: 0 0 15px var(--condado-acento);
}

.sidebar-toggle {
  left: 20px;
}

.lang-toggle {
  right: 80px;
}

.theme-toggle {
  right: 20px;
}

/* Language Bar */
.language-bar {
  position: fixed;
  top: 80px;
  right: 20px;
  background-color: var(--condado-primario);
  border: 2px solid var(--condado-secundario);
  border-radius: 10px;
  padding: 10px;
  z-index: 10000;
  display: none; /* Hidden by default */
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.language-bar.active {
  display: block;
  animation: fadeIn 0.3s ease-in-out;
}

.close-lang-bar {
  background: none;
  border: none;
  color: var(--condado-acento);
  font-size: 1.2em;
  cursor: pointer;
  position: absolute;
  top: 5px;
  right: 5px;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}
"@

if ($content -match $pattern) {
    $newContent = $content -replace $pattern, $newCss
    Set-Content $file $newContent -Encoding UTF8
    Write-Host "CSS updated successfully."
}
else {
    Write-Host "Pattern not found!"
}
