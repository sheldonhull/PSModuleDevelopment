set-location $PSScriptRoot
write-warning "COPY AND RUN THESE LINES IN CMDER DIRECTLY TO AVOID ENCODING ISSUES"

#$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
New-PSMDTemplate -ReferencePath "$PSScriptRoot" -TemplateName BAZINGA

#$Template = GCI "$PSScriptRoot" -Recurse -filter '*þFunctionNameþ.ps1' | select -ExpandProperty FullName
#write-host "Identified Template: $Template" -ForegroundColor Cyan

New-PSMDTemplate -FilePath "C:\GIT\PSModuleDevelopment\templates\PSFProject-sheldonh\þnameþ\tests\functions\þFunctionNameþ.tests.ps1" -TemplateName ProjectPester -force
New-PSMDTemplate -FilePath "C:\GIT\PSModuleDevelopment\templates\PSFProject-sheldonh\þnameþ\functions\þFunctionNameþ.ps1" -TemplateName ProjectFunction -force -verbose
#New-PSMDTemplate -ReferencePath (resolve-path "$PSScriptRoot\þnameþ\tests\functions\þFunctionNameþ.tests.ps1") -TemplateName ProjectPester -force
