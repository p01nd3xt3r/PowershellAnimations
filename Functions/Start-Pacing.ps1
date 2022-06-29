<#
.Synopsis
.Description
.Parameter Copy
.Parameter Path
.Example 
.Inputs
.Outputs
.Notes
.Link
.Component
.Role
.Functionality
#>
Function Start-Pacing {
    param (
        [Parameter()][string]$Type = "Multi",
        [Parameter()][string]$Precipication = "Rain",
        [Parameter()][int]$Speed = 1,
        [Parameter()][int]$Rain = 3
    )

    $PacingSleepMilliseconds = 100 / $Speed

    If ($Type -eq "Single") {
        # Make this several lines high and make the rain go at an angle. Wind can blow the guy faster. Might do an animation of him walking, if I can.
        $PacingGuyRightHash = @{
            # 0 is the anchor
            0 = '→'
            1 = '_'
            2 = '→'
        }
        $PacingGuyLeftHash = @{
            0 = '←'
            1 = '_'
            2 = '←'
        }
        $PacingRainHash = @{
            0 = '⠁'
            1 = '⠂'
            2 = '⠄'
            3 = '⡀'
        }
        $PacingOutputWidth = ((Get-Host).ui.rawui.windowsize.width) - 3
        $PacingOutputMap = @()
        For ($I = 0; $I -lt $PacingOutputWidth; $I++) {
            # Randomizing raindrop start points for each character
            $PacingOutputMap += (Get-Random -minimum -5 -maximum 3)
        }
        $PacingGuyActiveHash = $PacingGuyRightHash
        $PacingGuyMapLocationAnchorBoundLower = -3
        $PacingGuyMapLocationAnchorBoundUpper = $PacingOutputWidth + 3
        $PacingGuyMapLocationAnchor = $PacingGuyMapLocationAnchorBoundLower
        $PacingRainColor = "`e[48;5;0m`e[38;5;20m"
        $PacingGuyColor = "`e[48;5;0m`e[38;5;22m"
        $PacingColorReset = "`e[0m"
        $PacingInterval = 0

        # Main loop
        ## Handling the visible cursor
        [console]::CursorVisible = $False
        [console]::TreatControlCAsInput = $True
        While ($True) {
            # Configuring the ctrl+c results
            If ([console]::KeyAvailable) {
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the break after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Clear-Host
                    Break
                }
            }

            $PacingInterval++
            $PacingOutput = ""
            # If the guy is farther than index 0
            If ($PacingGuyMapLocationAnchor -gt 0) {
                $PacingOutputInput = ""
                For ($I = 0; $I -lt $PacingGuyMapLocationAnchor; $I++) {
                    If ($PacingOutputMap[$I] -lt 0) {
                        $PacingOutputInput += " "
                    } Else {
                        $PacingOutputInput += $PacingRainHash[$PacingOutputMap[$I]]
                    }
                }
                $PacingOutput = $PacingRainColor,$PacingOutputInput,$PacingColorReset | Join-String
            }
            # If the guy anchor makes him in the map's indexes
            If (($PacingGuyMapLocationAnchor -gt -2) -and ($PacingGuyMapLocationAnchor -lt $PacingOutputMap.count)) {
                $PacingOutput = $PacingOutput,$PacingGuyColor,(-join $PacingGuyActiveHash.values),$PacingColorReset | Join-String
            }

            #If the guy is less than the maps length
            If ($PacingGuyMapLocationAnchor -lt ($PacingOutputMap.count -4)) {
                $PacingOutputInput = ""
                For ($I = ($PacingGuyMapLocationAnchor + 3); $I -lt ($PacingOutputMap.count - 1); $I++) {
                    If ($PacingOutputMap[$I] -lt 0) {
                        $PacingOutputInput += " "
                    } Else {
                        $PacingOutputInput += $PacingRainHash[$PacingOutputMap[$I]]
                    }
                }
                $PacingOutput = $PacingOutput,$PacingRainColor,$PacingOutputInput,$PacingColorReset | Join-String
            }

            # Moving the guy every third interval
            If (($PacingInterval % 5) -eq 0) {
                # Moving to the right
                If ($PacingGuyActiveHash -eq $PacingGuyRightHash) {
                    # Turning him around if he's at the end
                    If (($PacingGuyMapLocationAnchor + 2) -eq $PacingGuyMapLocationAnchorBoundUpper) {
                        $PacingGuyActiveHash = $PacingGuyLeftHash
                    } Else {
                        $PacingGuyMapLocationAnchor++
                    }
                } ElseIf ($PacingGuyActiveHash -eq $PacingGuyLeftHash) {
                    If ($PacingGuyMapLocationAnchor -eq $PacingGuyMapLocationAnchorBoundLower) {
                        $PacingGuyActiveHash = $PacingGuyRightHash
                    } Else {
                        $PacingGuyMapLocationAnchor--
                    }
                }
            }

            # Updating the rain
            For ($I = 0; $I -lt $PacingOutputMap.count; $I++) {
                If ($PacingOutputMap[$I] -eq 3) {
                    $PacingOutputMap[$I] = Get-Random -minimum -5 -maximum -2
                } Else {
                    $PacingOutputMap[$I] = $PacingOutputMap[$I] += 1
                }
            }

            Clear-Host
            $PacingOutput
            Start-Sleep -Milliseconds $PacingSleepMilliseconds
        }
    }

    If ($Type -eq "Multi") {
        # When using width in relation to indexes in the map, remember that the width starts with 1 and the indexes start with 0
        
        If ($Precipication -eq "snow") {
            $PacingRainColor = "`e[48;5;0m`e[97m"
            $PacingGuyColor = "`e[48;5;0m`e[37m"
            $PacingBackgroundColor = "`e[48;5;0m`e[37m"
            $PacingSlopeColor = "`e[48;5;0m`e[90m"
        } ElseIf ($Precipication -eq "rain") {
            $PacingRainColor = "`e[48;5;0m`e[38;5;20m"
            $PacingGuyColor = "`e[48;5;0m`e[38;5;25m"
            $PacingBackgroundColor = "`e[48;5;0m`e[32m" # "`e[48;5;0m`e[38;5;65m"
            $PacingSlopeColor = "`e[48;5;0m`e[38;5;235m"
        }
        $PacingColorReset = "`e[0m"
        $PacingRainChanceDice = @(1..100)
        $PacingRainChanceThreshold = 100 - $Rain
        $PacingOutputWidth = ((Get-Host).ui.rawui.windowsize.width) - 5
        If ($PacingOutputWidth -lt 30) {
            Throw "Please increase the size of your Powershell window to at least thirty-five columns wide."
        }
        $PacingOutputHeight = ((Get-Host).ui.rawui.windowsize.height) - 5
        If ($PacingOutputHeight -lt 10) {
            Throw "Please increase the size of your Powershell windows to at least fifteen rows high."
        }
        $PacingBackgroundHeight = $PacingOutputHeight - 3
        $PacingSlopeHeight = 10

        # All rain chars: ⢀⠠⠐⠈⠁⠂⠄⡀
        $PacingRainHash = @{
            0 = '⠈'
            1 = '⠂'
            2 = '⠠'
            3 = '⡀'
        }
        $PacingBackgroundHash = @{
            0 = ' '
            1 = '⇡'
            2 = '≣'
            3 = '≡'
        }
        $PacingGuyHash = @{
            0 = @("♀","`”")
            1 = @("ϙ","’")
        }
        $PacingSlopeHash = @{
            0 = '⣠'
            1 = '⣾'
            2 = '⣿'
        }

        $PacingOutputMapArray = @()
        $PacingBoundsTop = @()
        $PacingBoundsBottom = @()
        $PacingBoundsLeft = @()
        $PacingBoundsLeft += 0
        $PacingBoundsRight = @()
        $PacingRowsHash = @{
            0 = @()
        } # Keys are the row numbers, starting with 0 at the top, and values are arrays of all the map indexes that are in each.
        $PacingRowsHashI = 0

        # Because I have chars that need to be tracked even when they're not displayed (a background that moves with raindrops that go over it), I need separate arrays.

        # I could have it have the map indexes as the keys and the background hash keys as the values and just calculate if it's in the top row or not by the pacingrowshash. that would be better than a hash of arrays.
        $PacingBackgroundMapHash = @{}

        # Used for knowing the right-most indexes in the background. Key is the row, value is the map index.
        # $PacingSlopeBackgroundJoinIndexes = @()

        # Hash with the key the map index and the value the slope hash key.
        $PacingSlopeMapHash = @{}

        $PacingSlopeMapTopRow = 100 # Arbitrary number because I need it higher than the start row of the ⣿ loop.

        # Might use this for inputing the slope and guy, since they're in front of everything. Can be used for not processing things that I don't need to display.
        $PacingSlopeIndexes = @()

        # Just an array of the two indexes that have the guy. I can track the characters in the display section using the hash keys of that hash.
        $PacingGuyMapArray = @()
        
        For ($I = 0; $I -lt ($PacingOutputWidth * $PacingOutputHeight); $I++) {            
            # Building slope, which should stay the same throughout.
            # Marks the top-right spot and builds the top row.
            If ((($PacingRowsHashI) -eq ($PacingOutputHeight - $PacingSlopeHeight)) -and ($I -gt 2) -and ((($I + 1) % $PacingOutputWidth) -eq 0)) {
                $PacingSlopeMapTopRow = $PacingRowsHashI
                $PacingSlopeMapHash.add($I,$PacingSlopeHash[1])
                $PacingSlopeMapHash.add(($I - 1),$PacingSlopeHash[0])
                $PacingSlopeIndexes += $I
                $PacingSlopeIndexes += ($I - 1)
            }
            # Uses the above mark to build each subsequent row. Gets wider as it goes down.
            If (($PacingRowsHashI -gt $PacingSlopeMapTopRow) -and ($I -gt 2) -and ((($I + 1) % $PacingOutputWidth) -eq 0)) {
                $PacingSlopeIndex = $I
                For ($SlopeI = 0; $SlopeI -lt ($PacingRowsHashI - $PacingSlopeMapTopRow); $SlopeI++) {
                    # Always puts one additional three ⣿ for each new row.
                    $PacingSlopeMapHash.add($PacingSlopeIndex,$PacingSlopeHash[2])
                    $PacingSlopeIndexes += $PacingSlopeIndex
                    $PacingSlopeIndex--
                    $PacingSlopeMapHash.add($PacingSlopeIndex,$PacingSlopeHash[2])
                    $PacingSlopeIndexes += $PacingSlopeIndex
                    $PacingSlopeIndex--
                    $PacingSlopeMapHash.add($PacingSlopeIndex,$PacingSlopeHash[2])
                    $PacingSlopeIndexes += $PacingSlopeIndex
                    $PacingSlopeIndex--
                }
                $PacingSlopeMapHash.add($PacingSlopeIndex,$PacingSlopeHash[1])
                $PacingSlopeIndexes += $PacingSlopeIndex
                $PacingSlopeIndex--
                $PacingSlopeMapHash.add($PacingSlopeIndex,$PacingSlopeHash[0])
                $PacingSlopeIndexes += $PacingSlopeIndex

                # All indexes to the left of the slope.
                
                # Building guy's start point
                If (($PacingRowsHashI + 1) -eq ($PacingOutputHeight - 4)) {
                    $PacingGuyMapArray += ($PacingSlopeIndex - 4)
                    $PacingGuyMapArray += ($PacingGuyMapArray[0] + $PacingOutputWidth)
                }
            }

            # Ignores any that have been put in $PacingSlopeIndexes. 
            # Building background start.
            $PacingBrackgroundFirstGeneratorIndex = ($PacingOutputWidth * ($PacingOutputHeight - 3) - 20) - 1
            $PacingBrackgroundSecondGeneratorIndex = ($PacingOutputWidth * ($PacingOutputHeight - 2) - 23) - 1
            $PacingBrackgroundThirdGeneratorIndex = ($PacingOutputWidth * ($PacingOutputHeight - 1) - 26) - 1
            $PacingBrackgroundFourthGeneratorIndex = ($PacingOutputWidth * ($PacingOutputHeight) - 23) - 1
            If ((($PacingRowsHashI + 1) -eq ($PacingBackgroundHeight)) -and ($I -notin $PacingSlopeIndexes)) {
                $PacingBackgroundRoll = (0,0,0,0,0,0,0,0,0,0,0,0,1,2,3) | Get-Random
                $PacingBackgroundMapHash.add($I,$PacingBackgroundRoll)
            } ElseIf ((($PacingRowsHashI + 1) -gt ($PacingOutputHeight - 3)) -and ($I -notin $PacingSlopeIndexes)) {
                $PacingBackgroundRoll = (1,2,3) | Get-Random
                $PacingBackgroundMapHash.add($I,$PacingBackgroundRoll)
            }

            # Randomizing raindrop start points for each character
            If (($I + 1) -in (1..$PacingOutputWidth)) {
                $PacingBoundsTop += $I
            }
            If (($I + 1) -gt ($PacingOutputWidth * $PacingOutputHeight - $PacingOutputWidth)) {
                $PacingBoundsBottom += $I
            }
            If (($I -gt 1) -and (($I + 1) % $PacingOutputWidth) -eq 0) {
                $PacingBoundsRight += $I
                If (($I + 1) -ne ($PacingOutputWidth * $PacingOutputHeight)) {
                    $PacingBoundsLeft += ($I + 1)
                }
            }
            If (($PacingRainChanceDice | Get-Random) -gt $PacingRainChanceThreshold) {
                $PacingOutputMapArray += 0
            } Else {
                $PacingOutputMapArray += 4
            }
            # Building Rows hash for use later. #####Is this needed?##### Each key is a row, and each value is all the indexes in that row. Might save some calculating.
            If (($I -gt 2) -and (($I + 1) % $PacingOutputWidth) -eq 0) {
                $PacingRowsHashI++ #Leave this even if I remove the pacingrowshash.
                $PacingRowsHash.add($PacingRowsHashI,@())
            }
            $PacingRowsHash[$PacingRowsHashI] += $I
        }

        # Main loop
        $PacingInterval = 0
        $PacingIntervalBackground = 0
        $PacingOutput = ""
        $PacingGuyOutputZero = $True
        ## Handling the visible cursor
        [console]::CursorVisible = $False
        [console]::TreatControlCAsInput = $True
        While ($True) {
            # Configuring the ctrl+c results
            If ([console]::KeyAvailable) {
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the break after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Clear-Host
                    Break
                }
            }

            # Building Output
            # ANSI every char.
            For ($I = 0; $I -lt $PacingOutputMapArray.count; $I++) {
                If ($I -in $PacingSlopeIndexes) {
                    # Slope
                    $PacingOutput = $PacingOutput,$PacingSlopeColor,$PacingSlopeMapHash[$I],$PacingColorReset | Join-String
                } ElseIf ($I -in $PacingGuyMapArray) {
                    # Guy
                    If ($True -eq $PacingGuyOutputZero) {
                        If ($I -eq $PacingGuyMapArray[0]) {
                            $PacingOutput = $PacingOutput,$PacingGuyColor,$PacingGuyHash[0][0],$PacingColorReset | Join-String
                        }
                        If ($I -eq $PacingGuyMapArray[1]) {
                            $PacingOutput = $PacingOutput,$PacingGuyColor,$PacingGuyHash[0][1],$PacingColorReset | Join-String
                            $PacingGuyOutputZero = $False
                        }
                    } Else {
                        If ($I -eq $PacingGuyMapArray[0]) {
                            $PacingOutput = $PacingOutput,$PacingGuyColor,$PacingGuyHash[1][0],$PacingColorReset | Join-String
                        }
                        If ($I -eq $PacingGuyMapArray[1]) {
                            $PacingOutput = $PacingOutput,$PacingGuyColor,$PacingGuyHash[1][1],$PacingColorReset | Join-String
                            $PacingGuyOutputZero = $True
                        }
                    }
                } Else {
                    # Rain
                    If ($PacingOutputMapArray[$I] -lt 4) {
                        $PacingOutput = $PacingOutput,$PacingRainColor,$PacingRainHash[$PacingOutputMapArray[$I]],$PacingColorReset | Join-String
                    } ElseIf ($I -in $PacingBackgroundMapHash.keys) {
                        # Background
                        $PacingOutput = $PacingOutput,$PacingBackgroundColor,$PacingBackgroundHash[$PacingBackgroundMapHash[$I]],$PacingColorReset | Join-String
                    } Else {
                        $PacingOutput = $PacingOutput," " | Join-String
                    }
                }
                # Adding a CRLF if it's at the end of a row.
                If ($I -in $PacingBoundsRight) {
                    $PacingOutput = $PacingOutput,"`n   " | Join-String
                }
            }
            $PacingOutput = "`n   ",$PacingOutput | Join-String
            
            Clear-Host
            $PacingOutput

            # Progressing the animation
            $PacingInterval++
            $PacingIntervalBackground++
            $PacingOutput = ""

            If ($PacingIntervalBackground -eq 7) {
                $PacingBackgroundTrigger = $True
                $PacingIntervalBackground = 0
            } ElseIf ($PacingInterval -eq 3) {
                $PacingInterval = 0
            }

            # Rain
            # Slaves refers to the changes on the next rows and not the changes that go back an index. Need to exclude these from all branches.
            $PacingSlaveIndexes = @()
            For ($I = 0; $I -lt $PacingOutputMapArray.count; $I++) {
                If ($I -notin $PacingSlaveIndexes) {
                    If (($PacingOutputMapArray[$I] -eq 0) -or ($PacingOutputMapArray[$I] -eq 2)) {
                        $PacingOutputMapArray[$I]++
                    } ElseIf ($PacingOutputMapArray[$I] -eq 1) {
                        $PacingOutputMapArray[$I] = 4
                        # Moving to left and continuing rain at 2.
                        $PacingOutputMapArray[($I - 1)] = 2
                    } ElseIf ($PacingOutputMapArray[$I] -eq 3) {
                        $PacingOutputMapArray[$I]++
                        # Set the next interval as 0 as long as it is less than the total count of the array and as long as the master isn't on the left or bottom bounds
                        If ((($I + $PacingOutputWidth) -lt $PacingOutputMapArray.count) -and ($I -notin $PacingBoundsBottom) -and ($I -notin $PacingBoundsLeft)) {
                            $PacingSlaveIndexes += ($I + $PacingOutputWidth - 1)
                            $PacingOutputMapArray[($I + $PacingOutputWidth - 1)] = 0
                        }
                    } ElseIf ((($I -in $PacingBoundsTop) -or ($I -in $PacingBoundsRight)) -and ($PacingOutputMapArray[$I] -gt 3)) {
                        If (($PacingRainChanceDice | Get-Random) -gt $PacingRainChanceThreshold) {
                            $PacingOutputMapArray[$I] = 0
                        }
                    }
                }
            }

            # Background
            If ($PacingBackgroundTrigger -eq $True) {
                # Each index takes the value of the index ahead of it, and if there's none ahead of it, a new one is generated.
                $PacingBackgroundMapHash.keys | Sort-Object | ForEach-Object {
                    If (($_ -eq $PacingBrackgroundFirstGeneratorIndex) -or ($_ -eq $PacingBrackgroundSecondGeneratorIndex) -or ($_ -eq $PacingBrackgroundThirdGeneratorIndex) -or ($_ -eq $PacingBrackgroundFourthGeneratorIndex)) {
                        If ($_ -eq $PacingBrackgroundFirstGeneratorIndex) {
                            $PacingBackgroundMapHash[$_] = (0,0,0,0,0,0,0,0,0,0,0,0,1,2,3) | Get-Random
                        } ElseIf (($_ -eq $PacingBrackgroundSecondGeneratorIndex) -or ($_ -eq $PacingBrackgroundThirdGeneratorIndex) -or ($_ -eq $PacingBrackgroundFourthGeneratorIndex)) {
                            $PacingBackgroundMapHash[$_] = (1,2,3) | Get-Random
                        }
                    } Else {
                        $PacingBackgroundMapHash[$_] = $PacingBackgroundMapHash[($_ + 1)]
                    }
                }
                $PacingBackgroundTrigger = $False
            }
            Start-Sleep -milliseconds $PacingSleepMilliseconds
        }
    }
}