@ECHO OFF
ECHO  ________________
ECHO ^< Loading þnameþ. Please wait... ^>
ECHO  ----------------
ECHO    \\
ECHO     \\
ECHO         .--.
ECHO        ^|o_o ^|
ECHO        :_/ ^|
ECHO       //   \\ \\
ECHO      ^(^|     ^| ^)
ECHO     /'\\_   _/^`\\
ECHO     \\___^)^=^(___/
ECHO
echo Running %~nx1 to launch interactive session on %~n0
Set posh_nested_statement="Write-Host ""Loading %~n0.. please wait.."" -ForegroundColor Green; Import-Module %~dpn0.psd1; get-command -module þnameþ ^| Format-table -autosize^| Out-string;"
Set command_statement="& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -NoExit -ExecutionPolicy Bypass -Command "%posh_nested_statement%"' -Verb RunAs}"
PowerShell.exe -ExecutionPolicy Bypass -NoProfile -Command %command_statement%
exit
echo "Done loading interactive session.. closing in 5"
SLEEP 5
