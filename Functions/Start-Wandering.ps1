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
    } ElseIf ($Type -eq "RandomLaser") {
        $WanderingLaserLocation = 0
        $WanderingLaserDirection = "right"
        $WanderingLaserRight = "\"
        $WanderingLaserLeft = "/"
        $WanderingLaser = $WanderingLaserRight
        $WanderingLaserCurrentColor = $WanderingWandererColors | Get-Random
        $WanderingWanderer = "●"

        #Main loop
        While ($True) {
            #Moving the laser, turning him when he hits the end.
            If ($WanderingLaserDirection -eq "right") {
                If ($WanderingLaserLocation -eq ($WanderingMaxWidth + 1)) {
                    $WanderingLaserDirection = "left"
                    $WanderingLaser = $WanderingLaserLeft
                    $WanderingLaserCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingLaserLocation++
                }
            } Else {
                If ($WanderingLaserLocation -eq 0) {
                    $WanderingLaserDirection = "right"
                    $WanderingLaser = $WanderingLaserRight
                    $WanderingLaserCurrentColor = $WanderingWandererColors | Get-Random
                } Else {
                    $WanderingLaserLocation--
                }
            }

            #Making the random one's location and color. Excludes laser location.
            Do {
                $WanderingWandererLocation = (0..$WanderingMaxWidth) | Get-Random
            } Until ($WanderingWandererLocation -ne $WanderingLaserLocation)
            $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

            #####
            $WanderingOutputFillerLeft = ""
            $WanderingOutputFillerCenter = ""
            If ($WanderingLaserLocation -lt $WanderingWandererLocation) {
                #Left filler
                For ($I = 0; $I -lt $WanderingLaserLocation; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingWandererLocation - $WanderingLaserLocation - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output string
                $WanderingOutputString = $WanderingOutputFillerLeft, "`e[38;5;", $WanderingLaserCurrentColor, "m", $WanderingLaser, "`e[0m", $WanderingOutputFillerCenter, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m" | Join-String
            } Else {
                #Left filler
                For ($I = 0; $I -lt $WanderingWandererLocation; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingLaserLocation - $WanderingWandererLocation - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output string
                $WanderingOutputString = $WanderingOutputFillerLeft, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m", $WanderingOutputFillerCenter, "`e[38;5;", $WanderingLaserCurrentColor, "m", $WanderingLaser, "`e[0m" | Join-String
            }

            $WanderingOutputString
        }
    } ElseIf ($Type -eq "Argyle") {
        #Multi laser that decreases in width until it's a line and then increases back to max size and so on.
    } Else {
        Write-Host "Sorry, you've entered an invalid type."
        Return
    }
}