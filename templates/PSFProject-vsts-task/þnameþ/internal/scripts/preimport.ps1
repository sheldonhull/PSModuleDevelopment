# Add all things you want to run before importing the main code
# Ensure all contents are unblocked in case policy sets as blocked if downloaded.
$ModuleFolder = Split-Path $PSScriptRoot -Parent | Split-Path -Parent
Get-ChildItem $ModuleFolder -Recurse | Unblock-File