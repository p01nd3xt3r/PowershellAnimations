<#
.Synopsis
.Description
.Parameter Text
.Example 
.Inputs
.Outputs
.Notes
.Link
.Component
.Role
.Functionality
#>
Function Start-Annoying {
    While ($True) {
        $RandomInterval = Get-Random -Min 100 -Max 1000
        $RandomPause = Get-Random -Min 30 -Max 300
        [console]::beep(32767,($RandomInterval))

        $NextBeep = (Get-Date) + (New-Timespan -Seconds $RandomPause)
        Write-Host "Next beep at $NextBeep. Press ctrl + c to quit."
        Start-Sleep -Seconds $RandomPause
    }
}