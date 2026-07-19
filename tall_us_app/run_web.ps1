# =============================================================================
# Lance l'app Tall Us en web en injectant les variables du .env via --dart-define
# =============================================================================
# Usage:
#   .\run_web.ps1              # port 8080
#   .\run_web.ps1 -Port 9090   # port personnalise
#   .\run_web.ps1 -BuildOnly   # build sans lancer (pour Vercel/déploiement)
# =============================================================================
param(
    [int]$Port = 8080,
    [switch]$BuildOnly
)

$ErrorActionPreference = "Stop"

# Localise Flutter
$env:PATH = "$env:USERPROFILE\flutter\bin;$env:PATH"
Set-Location $PSScriptRoot

$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "Fichier .env introuvable. Cree-le a partir de .env.example" -ForegroundColor Red
    exit 1
}

# Liste des variables lues par l'app via String.fromEnvironment
$keys = @(
    "APP_URL", "JWT_SECRET", "JWT_REFRESH_SECRET",
    "GOOGLE_CLIENT_ID", "APPLE_CLIENT_ID",
    "FCM_SERVER_KEY", "COURIER_AUTH_TOKEN"
)

# Parse le .env (ignore commentaires et lignes vides)
$vars = @{}
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
        $idx = $line.IndexOf("=")
        $k = $line.Substring(0, $idx).Trim()
        $v = $line.Substring($idx + 1).Trim()
        # retire les guillemets eventuels
        if ($v.StartsWith('"') -and $v.EndsWith('"')) { $v = $v.Substring(1, $v.Length - 2) }
        $vars[$k] = $v
    }
}

# Construit la liste --dart-define=KEY=value
$defines = @()
foreach ($k in $keys) {
    $val = if ($vars.ContainsKey($k)) { $vars[$k] } else { "" }
    $defines += "--dart-define=$k=$val"
}

Write-Host "Lancement Tall Us web (port $Port) avec $($keys.Count) variables d'env..." -ForegroundColor Cyan
foreach ($k in $keys) {
    $masked = if ($vars.ContainsKey($k) -and $vars[$k].Length -gt 6 -and $k -match "SECRET|KEY|TOKEN") {
        $vars[$k].Substring(0, 4) + "..." + $vars[$k].Substring($vars[$k].Length - 3)
    } elseif ($vars.ContainsKey($k)) { $vars[$k] } else { "(vide)" }
    Write-Host "  $k = $masked" -ForegroundColor DarkGray
}
Write-Host ""

if ($BuildOnly) {
    Write-Host "Build web en cours..." -ForegroundColor Cyan
    & flutter build web --release @defines
} else {
    & flutter run -d web-server --web-port $Port --web-hostname 0.0.0.0 @defines
}
