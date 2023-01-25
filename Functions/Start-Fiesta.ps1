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
Function Start-Fiesta {
    $FiestaMaxWidthCount = ((Get-Host).ui.rawui.windowsize.width / 8) - 1
    $FiestaCount = ""
    For ($I = 0; $I -lt $FiestaMaxWidthCount; $I++) {
        $FiestaCount += "¡Fiesta!"
    }
    $FiestaColor = @(0..255)
    ForEach ($FiestaBGColor in $FiestaColor) {
        ForEach ($FiestaFGColor in $FiestaColor) {
            "`u{07}`e[5m`e[1m`e[48;5;", $FiestaBGColor, "m`e[38;5;", $FiestaFGColor, "m", $FiestaCount, "`e[0m" | Join-String
        }
    }
    Clear-Host
    "¡Olé!"
}