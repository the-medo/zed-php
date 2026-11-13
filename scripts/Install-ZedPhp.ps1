# Install the prebuilt PHP extension. Close Zed before running this script.
[CmdletBinding()]
param([string]$ArchivePath)

$ErrorActionPreference = 'Stop'
if (Get-Process -Name zed, zed-editor -ErrorAction SilentlyContinue) {
    throw 'Please quit Zed (all windows), then run this script again.'
}

$version = '0.5.4-phpstorm.1'
$digest = 'c3b7ff32c223261c248b3246a211802f28d4de58a87d311ee66e40af072e5b2e'
$release = "https://github.com/the-medo/zed-php/releases/download/v$version"
$destination = Join-Path $env:LOCALAPPDATA 'Zed/extensions/installed/php'
$store = Join-Path $env:LOCALAPPDATA 'Zed/phpstorm-php'
$build = Join-Path $store $version
$backup = Join-Path $store 'original-php'
$stage = Join-Path $store ([Guid]::NewGuid().ToString())

New-Item -ItemType Directory -Force -Path (Split-Path $destination), $stage | Out-Null
try {
    if (!$ArchivePath) {
        $ArchivePath = Join-Path $stage 'extension.zip'
        Invoke-WebRequest -UseBasicParsing -Uri "$release/zed-php-$version.zip" -OutFile $ArchivePath
    }
    if ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash -ne $digest) {
        throw 'The PHP extension archive does not match this release.'
    }
    if (!(Test-Path -LiteralPath $build)) {
        $unpacked = Join-Path $stage 'extension'
        Expand-Archive -LiteralPath $ArchivePath -DestinationPath $unpacked
        [IO.Directory]::Move($unpacked, $build)
    }
    $installed = Get-Item -LiteralPath $destination -ErrorAction SilentlyContinue
    if ($installed -and ($installed.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        if (($installed.LinkType -ne 'Junction') -or (@($installed.Target)[0] -ne $build)) {
            throw "An existing development extension is linked at $destination. It was left in place."
        }
    } else {
        if ($installed) {
            if (Test-Path -LiteralPath $backup) { throw "A backup already exists at $backup. It was left in place." }
            [IO.Directory]::Move($destination, $backup)
        }
        try {
            # Zed recognizes linked extensions as development installs and skips registry updates.
            New-Item -ItemType Junction -Path $destination -Target $build | Out-Null
        } catch {
            if ($installed -and !(Test-Path -LiteralPath $destination)) {
                [IO.Directory]::Move($backup, $destination)
            }
            throw
        }
    }
    Write-Output 'Installed. Open Zed and select the theme "PhpStorm Dark (PHP Fork)".'
} finally {
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
}
