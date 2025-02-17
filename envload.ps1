# Find the directory this script is in
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$scriptPath\envloader.ps1" 