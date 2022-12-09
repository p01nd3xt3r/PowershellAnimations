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
Function Start-Wandering {
    param (
        [Parameter()][String]$Type = "Laser"
    )

    $WanderingMaxWidth = ((Get-Host).ui.rawui.windowsize.width) - 3
    $WanderingWandererColors = @(0..255)

    If ($Type -eq "laser") {
        $WanderingWandererLocation = 0
        $WanderingWandererDirection = "right"
        $WanderingWandererRight = "\"
        $WanderingWandererLeft = "/"
        $WanderingWanderer = $WanderingWandererRight
        $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

        #Main loop
        While ($True) {
            #Moving the wanderer, turning him when he hits the end.
            If ($WanderingWandererDirection -eq "right") {
                If ($WanderingWandererLocation -eq ($WanderingMaxWidth + 1)) {
                    $WanderingWandererDirection = "left"
                    $WanderingWanderer = $WanderingWandererLeft
                    $WanderingWandererLocation--
                    $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingWandererLocation++
                }
            } Else {
                If ($WanderingWandererLocation -eq 0) {
                    $WanderingWandererDirection = "right"
                    $WanderingWanderer = $WanderingWandererRight
                    $WanderingWandererLocation++
                    $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingWandererLocation--
                }
            }
            $WanderingOutputFiller = ""

            For ($I = 0; $I -lt $WanderingWandererLocation; $I++) {
                $WanderingOutputFiller += " "
            }

            $WanderingOutputString = $WanderingOutputFiller, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m" | Join-String
            $WanderingOutputString
        }
    } ElseIf ($Type -eq "Random") {
        $WanderingWanderer = "●"
        While ($True) {
            $WanderingWandererLocation = (0..$WanderingMaxWidth) | Get-Random
            $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

            $WanderingOutputFiller = ""
            For ($I = 0; $I -lt $WanderingWandererLocation; $I++) {
                $WanderingOutputFiller += " "
            }

            $WanderingOutputString = $WanderingOutputFiller, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m" | Join-String
            $WanderingOutputString
        }
    }
}