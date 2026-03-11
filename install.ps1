# Instala o plugin jc da JusCash no Claude Code
# Uso: .\install.ps1 [--scope user|project|local]
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
node "$ScriptDir\install.js" @args
