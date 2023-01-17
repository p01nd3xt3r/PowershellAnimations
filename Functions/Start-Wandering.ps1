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

    } ElseIf ($Type -eq "Confetti") {
        While ($True) {
            $WanderingWanderer = "□","■","▲","►","▼","◄","○","☻","☺","●" | Get-Random
            $WanderingWandererLocation = (0..$WanderingMaxWidth) | Get-Random
            $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

            $WanderingOutputFiller = ""
            For ($I = 0; $I -lt $WanderingWandererLocation; $I++) {
                $WanderingOutputFiller = $WanderingOutputFiller, " " | Join-String
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
    } ElseIf ($Type -eq "Background") {
        $WanderingMaxWidth
        $WanderingWandererColors
        # Make it show a background color in all spots other than the target spot
        # Maybe do two or three rows and have the indicator move up and over through them with -nonewline
        # Or could do something like the view of a car window while it's driving, with buildings or posts flying by. Maybe that for later.
        # Could also just have the background be empty spaces again and use the dot as the wanderer (with a randomized color).
        # Maybe this should be a square with a set size. Or a max size. I would built the hashtable based on that size. 

        # Location will be a hashtable or row # and column #.
        # Need logic for putting the strings together with and without the guy in it. Perhaps always have left and right, and they fill the whole space unless the wanderer takes up one. If the wanderer isn't there, he still has a place in the join-string, but he will be empty. So maybe the wanderer hash has three rows, and if the value of the row is 0, the wanderer character is nothing.
        # $WanderingOutputString = row1fillerleft + wanderer + row1fillerright + `n + row2fillerleft + wanderer + row2fillerright + `n + row3fillerleft + wanderer + row3fillerright | Join-String
    } ElseIf ($Type -eq "Diver") {
        # Do the random dots.
        # Allow the user to move a vertical bar left and right. When the first time it's moved, it becomes a diagonal and then a vertical bar after that. Disallows user going farther than the edges.
        # Make the dots be random but for where the player is.
        $WanderingDiverLocation = [math]::round($WanderingMaxWidth / 2) - 1
        $WanderingDiverRight = "\"
        $WanderingDiverLeft = "/"
        $WanderingDiverDown = "|"
        $WanderingDiverColor = "`e[91m"
        # $WanderingWanderer = "●"

        [console]::TreatControlCAsInput = $True
        [console]::CursorVisible = $False
        While ($True) {
            $WanderingDiver = $WanderingDiverDown
            # Inside a while loop.
            If ([console]::KeyAvailable) {
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the Return after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Return
                } ElseIf ($Key.key -eq "RightArrow") {
                    $WanderingDiver = $WanderingDiverRight
                    If ($WanderingDiverLocation -ne $WanderingMaxWidth) {
                        $WanderingDiverLocation++
                    }
                } ElseIf ($Key.key -eq "LeftArrow") {
                    $WanderingDiver = $WanderingDiverLeft
                    If ($WanderingDiverLocation -ne 0) {
                        $WanderingDiverLocation--
                    }
                }
            }

            #Making the random one's location and color. Excludes laser location.
            Do {
                $WanderingWandererLocation = (0..$WanderingMaxWidth) | Get-Random
            } Until ($WanderingWandererLocation -ne $WanderingDiverLocation)
            $WanderingWandererCurrentColor = $WanderingWandererColors | Get-Random

            #####
            $WanderingOutputFillerLeft = ""
            $WanderingOutputFillerCenter = ""
            If ($WanderingDiverLocation -lt $WanderingWandererLocation) {
                #Left filler
                For ($I = 0; $I -lt $WanderingDiverLocation; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingWandererLocation - $WanderingDiverLocation - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output string
                $WanderingOutputString = $WanderingOutputFillerLeft, $WanderingDiverColor, $WanderingDiver, "`e[0m", $WanderingOutputFillerCenter, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m" | Join-String
            } Else {
                #Left filler
                For ($I = 0; $I -lt $WanderingWandererLocation; $I++) {
                    $WanderingOutputFillerLeft += " "
                }
                #Center filler
                For ($I = 0; $I -lt ($WanderingDiverLocation - $WanderingWandererLocation - 1); $I++) {
                    $WanderingOutputFillerCenter += " "
                }
                #Building output string
                $WanderingOutputString = $WanderingOutputFillerLeft, "`e[38;5;", $WanderingWandererCurrentColor, "m", $WanderingWanderer, "`e[0m", $WanderingOutputFillerCenter, $WanderingDiverColor, $WanderingDiver, "`e[0m" | Join-String
            }
            $WanderingOutputString
        }
    } Else {
        Write-Host "Sorry, you've entered an invalid type."
        Return
    }
}

# What about something that changes based on user input?
# What about navigating a file system like a gui labyrinth? What about navigating the Graph PowerShell module?

