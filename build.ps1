$ErrorActionPreference = "Stop"

$srcFiles = @(
    "src/header.lua",
    "src/config.lua",
    "src/utils.lua",
    "src/grid.lua",
    "src/carts.lua",
    "src/stations.lua",
    "src/ui.lua",
    "src/main.lua"
)

# 1. Junta os módulos em memória
$content = (Get-Content $srcFiles) -join "`n"

# 2. Grava em UTF-8 SEM BOM ($false garante que não injeta o Byte Order Mark)
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText("$PSScriptRoot\building_rails.lua", $content, $utf8NoBom)
Write-Host "building_rails.lua gerado com sucesso (UTF-8 sem BOM)!"

# 3. Injeta no .tic
$ticExe = "tools/tic80.exe"
if (Test-Path $ticExe) {
    & $ticExe --cli --fs="." --cmd="load building_rails.tic & import code building_rails.lua & save & exit" | Out-Null
    Write-Host "building_rails.tic atualizado com sucesso!"
} else {
    Write-Warning "Executável tools/tic80.exe não encontrado."
}