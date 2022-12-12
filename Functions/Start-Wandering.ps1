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
                    $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingWandererLocation++
                }
            } Else {
                If ($WanderingWandererLocation -eq 0) {
                    $WanderingWandererDirection = "right"
                    $WanderingWanderer = $WanderingWandererRight
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
    } ElseIf ($Type -eq "twistlaser") {
        #Making it an even number of spaces to keep from having some weird center charater.
        If (($WanderingMaxWidth % 2) -gt 0) {
            $WanderingMaxWidth--
        }
        #The rest of the setup.
        $WanderingWanderersLocationHash = @{
            'One' = 0
            'Two' = $WanderingMaxWidth + 1
        }
        $WanderingWandererOneDirection = "right"
        $WanderingWandererRight = "\"
        $WanderingWandererLeft = "/"
        $WanderingWandererOne = $WanderingWandererRight
        $WanderingWandererTwo = $WanderingWandererLeft
        $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

        #Main loop
        While ($True) {
            #Moving the wanderers.
            If ($WanderingWandererOneDirection -eq "right") {
                If ($WanderingWanderersLocationHash['One'] -eq ($WanderingMaxWidth + 1)) {
                    $WanderingWandererOneDirection = "left"
                    $WanderingWandererOne = $WanderingWandererLeft
                    $WanderingWandererTwo = $WanderingWandererRight
                    $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingWanderersLocationHash['One'] = $WanderingWanderersLocationHash['One'] + 1
                    $WanderingWanderersLocationHash['Two'] = $WanderingWanderersLocationHash['Two'] - 1
                }
            } Else {
                If ($WanderingWanderersLocationHash['One'] -eq -0) {
                    $WanderingWandererOneDirection = "right"
                    $WanderingWandererOne = $WanderingWandererRight
                    $WanderingWandererTwo = $WanderingWandererLeft
                    $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingWanderersLocationHash['One'] = $WanderingWanderersLocationHash['One'] - 1
                    $WanderingWanderersLocationHash['Two'] = $WanderingWanderersLocationHash['Two'] + 1
                }
            }
            #Making the text.
            $WanderingOutputFillerLeft = ""
            $WanderingOutputFillerCenter = ""

            # Filler goes before either one or two - whichever is less than.
            If ($WanderingWanderersLocationHash['One'] -lt $WanderingWanderersLocationHash['Two']) {
                #Left filler
                For ($I = 0; $I -lt $WanderingWanderersLocationHash['One']; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingWanderersLocationHash['Two'] - $WanderingWanderersLocationHash['One'] - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output
                $WanderingOutputString = "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingOutputFillerLeft, $WanderingWandererOne, $WanderingOutputFillerCenter, $WanderingWandererTwo, "`e[0m" | Join-String
            } Else {
                #Left filler
                For ($I = 0; $I -lt $WanderingWanderersLocationHash['Two']; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingWanderersLocationHash['One'] - $WanderingWanderersLocationHash['Two'] - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output
                $WanderingOutputString = "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingOutputFillerLeft, $WanderingWandererTwo, $WanderingOutputFillerCenter, $WanderingWandererOne, "`e[0m" | Join-String
            }

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