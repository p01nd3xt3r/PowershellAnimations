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
        [Parameter()][Int]$Type = 1,
        [Parameter()][Switch]$ListTypes,
        [Parameter()][Int]$Slow = 0
    )

    $TypesHash = [ordered]@{
        "Laser" = 1
        "TwistLaser" = 2
        "Random" = 3
        "Confetti" = 4
        "RandomLaser" = 5
        "Background" = 6
        "ThingIn" = 7
        "ThingOut" = 8
        "ThingInOut" = 9
        "Waving" = 10
        "Passing" = 11
    }

    If ($True -eq $ListTypes) {
        $TypesHash
        Return
    }

    $WanderingMaxWidth = ((Get-Host).ui.rawui.windowsize.width) - 3
    $WanderingWandererColors = @(0..255)

    If ($Type -eq 1) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 2) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 3) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 4) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 5) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 6) {
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
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 7) {
        $ThingNewColor = 0
        $Thing = ""
        While ($True) {
            If ($Thing.length -lt (10 + $ThingNewColor.tostring().length)) {
                $ThingNewColor = Get-Random -minimum 0 -maximum 266
                $Thing = "`e[38;5;$ThingNewColor`m"
                For ($I = 0; $I -lt ($WanderingMaxWidth + 1); $I++) {
                    $Thing = $Thing, "⬤" | Join-String
                }
            } Else {
                $ThingRemovalStart = $Thing.length - 1
                $Thing = $Thing.remove($ThingRemovalStart,1)
            }
            $Thing
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 8) {
        $ThingNewColor = 0
        $Thing = ""
        While ($True) {
            If ($Thing.length -lt ($WanderingMaxWidth + 1)) {
                $Thing = $Thing.insert($Thing.length,"⬤")
            } Else {
                $ThingNewColor = Get-Random -minimum 0 -maximum 266
                $Thing = "`e[38;5;$ThingNewColor`m⬤"
            }
            $Thing
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 9) {
        $ThingLeftColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
        $ThingRightColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
        $ThingLeft = ""
        $ThingRight = ""
        For ($I = 0; $I -lt $WanderingMaxWidth; $I++) {
            $ThingRight = $ThingRight.insert($I,"⬤")
        }
        $ThingDirection = ">"
        While ($True) {
            # Whole line all the time. Only move the split.
            # Maybe just maintain two sides, increasing or decreasing both of them each iteration.
            # Insert all into an output string at the end. See if .insert or | join is faster.
            If ($ThingDirection -eq ">") {
                If ($ThingLeft.length -ne $WanderingMaxWidth) {
                    $ThingLeft = $ThingLeft.insert(($ThingLeft.length),"⬤")
                    $ThingRight = $ThingRight.remove(($ThingRight.length - 1),1)
                } Else {
                    $ThingDirection = "<"
                    $ThingLeftColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
                    $ThingRightColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
                    $ThingLeft = $ThingLeft.remove(($ThingLeft.length - 1),1)
                    $ThingRight = $ThingRight.insert($ThingRight.length,"⬤")
                }
            } Else {
                If ($ThingLeft.length -ne 0) {
                    $ThingLeft = $ThingLeft.remove(($ThingLeft.length - 1),1)
                    $ThingRight = $ThingRight.insert($ThingRight.length,"⬤")
                } Else {
                    $ThingDirection = ">"
                    $ThingLeftColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
                    $ThingRightColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) + "m"
                    $ThingLeft = $ThingLeft.insert(($ThingLeft.length),"⬤")
                    $ThingRight = $ThingRight.remove(($ThingRight.length - 1),1)
                }
            }
            $ThingLeftColor, $ThingLeft, $ThingRightColor, $ThingRight | Join-String
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 10) {
        If (($WanderingMaxWidth % 2) -gt 0) {
            $WanderingMaxWidth--
        }
        $WipingLeftString = ""
        $WipingRightString = ""
        For ($I = 0; $I -lt (($WanderingMaxWidth/3)*2); $I++) {
            $WipingRightString = $WipingRightString, " " | Join-String
        }
        $WipingCharacter = "⬤"
        $WipingWiper = ""
        For ($I = 0; $I -lt ($WanderingMaxWidth/3); $I++) {
            $WipingWiper = $WipingWiper,$WipingCharacter | Join-String
        }
        $WipingWiperColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) +"`m"
        $WipingColoredWiper = $WipingWiperColor, $WipingWiper, "`e[0m" | Join-String
        $WipingDirection = ">"

        While ($True) {
            If ($WipingDirection -eq ">") {
                If ($WipingRightString.length -gt 0) {
                    $WipingRightString = $WipingRightString.remove(($WipingRightString.length - 1), 1)
                    $WipingLeftString = $WipingLeftString.insert(0, " ")
                } Else {
                    $WipingDirection = "<"
                    $WipingRightString = $WipingRightString.insert(0, " ")
                    $WipingLeftString = $WipingLeftString.remove(($WipingLeftString.length - 1), 1)
                    $WipingWiperColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) +"`m"
                    $WipingColoredWiper = $WipingWiperColor, $WipingWiper, "`e[0m" | Join-String
                }
            } Else {
                If ($WipingLeftString.length -gt 0) {
                    $WipingRightString = $WipingRightString.insert(0, " ")
                    $WipingLeftString = $WipingLeftString.remove(($WipingLeftString.length - 1), 1)
                } Else {
                    $WipingDirection = ">"
                    $WipingRightString = $WipingRightString.remove(($WipingRightString.length - 1), 1)
                    $WipingLeftString = $WipingLeftString.insert(0, " ")
                    $WipingWiperColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) +"`m"
                    $WipingColoredWiper = $WipingWiperColor, $WipingWiper, "`e[0m" | Join-String
                }
            }
            
            $WipingLeftString, $WipingColoredWiper, $WipingRightString | Join-String
            Start-Sleep -Milliseconds $Slow
        }
    } ElseIf ($Type -eq 11) {
        If (($WanderingMaxWidth % 2) -gt 0) {
            $WanderingMaxWidth--
        }
        $WipingLeftString = ""
        $WipingRightString = ""
        For ($I = 0; $I -lt (($WanderingMaxWidth/3)*2); $I++) {
            $WipingRightStartingString = $WipingRightStartingString, " " | Join-String
        }
        $WipingRightString = $WipingRightStartingString
        $WipingCharacter = "⬤"
        $WipingWiper = ""
        For ($I = 0; $I -lt ($WanderingMaxWidth/3); $I++) {
            $WipingWiper = $WipingWiper,$WipingCharacter | Join-String
        }
        $WipingWiperColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) +"`m"
        $WipingColoredWiper = $WipingWiperColor, $WipingWiper, "`e[0m" | Join-String

        While ($True) {
                If ($WipingRightString.length -gt 0) {
                    $WipingRightString = $WipingRightString.remove(($WipingRightString.length - 1), 1)
                    $WipingLeftString = $WipingLeftString.insert(0, " ")
                } Else {
                    $WipingLeftString = ""
                    $WipingRightString = $WipingRightStartingString
                    $WipingWiperColor = "`e[38;5;" + (Get-Random -minimum 0 -maximum 266) +"`m"
                    $WipingColoredWiper = $WipingWiperColor, $WipingWiper, "`e[0m" | Join-String
                }
            
            $WipingLeftString, $WipingColoredWiper, $WipingRightString | Join-String
            Start-Sleep -Milliseconds $Slow
        }
    } Else {
        Write-Host "Sorry, you've entered an invalid type."
        Return
    }
}
