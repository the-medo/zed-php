# PHP highlighting for Zed

This fork of [the PHP extension](https://github.com/zed-extensions/php) uses PHP syntax to distinguish variables, namespaces, classes, constants and members. It includes the **PhpStorm Dark (PHP Fork)** theme. The compiled PHP language server extension and PHP and PHPDoc parsers in the Windows release are the original binaries from Zed's PHP 0.5.4 distribution.

## Install on Windows

Quit Zed, including any other project windows. Run these commands in Windows PowerShell on each PC where you use Zed.

```powershell
$installer = Join-Path $env:TEMP 'Install-ZedPhp.ps1'
Invoke-WebRequest -UseBasicParsing 'https://github.com/the-medo/zed-php/releases/download/v0.5.4-phpstorm.1/Install-ZedPhp.ps1' -OutFile $installer
powershell -NoProfile -ExecutionPolicy Bypass -File $installer
```

Open Zed. With the JetBrains keymap, press **Ctrl+Shift+A**, run **theme selector: toggle**, select **PhpStorm Dark (PHP Fork)** and press **Enter**. In `$Runner = new Runner();`, the variable should be purple and the class name gray.

The installer verifies the prebuilt archive, saves any previous registry installation and links the fork into Zed as a development extension. This pins the PHP extension to this build. During SSH editing, the client performs syntax highlighting and Zed synchronizes its language server extension to the remote host.

## Return to the registry extension

Quit Zed. These commands remove this installation's directory junction and restore the saved extension when available. If you originally had no PHP extension, install **PHP** from Zed's extensions panel after reopening it.

```powershell
$php = "$env:LOCALAPPDATA\Zed\extensions\installed\php"
$store = "$env:LOCALAPPDATA\Zed\phpstorm-php"
$link = Get-Item -LiteralPath $php -ErrorAction Stop
if ($link.LinkType -ne 'Junction' -or @($link.Target)[0] -ne "$store\0.5.4-phpstorm.1") { throw 'Unexpected PHP extension location.' }
[IO.Directory]::Delete($php)
if (Test-Path "$store\original-php") { [IO.Directory]::Move("$store\original-php", $php) }
```
