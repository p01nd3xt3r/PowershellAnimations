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
Function Start-Labyrinth {
    param (
        [Parameter()][string]$Type = "Box"
    )
    # 1) Make a map that you can move around. Only refresh when the user moves. Make a hashtable of each character in the viewable area. Each row is a separate hashtable? I'm guessing so.
    # 2) Map something the user can actually make use of. File system or something.

    Clear-Host

    #Dimensions assignment
    $LabMaxWidth = ((Get-Host).ui.rawui.windowsize.width) - 3
    $LabMaxHeight = ((Get-Host).ui.rawui.windowsize.height) - 3

    #Character assignment
    $LabOutsideWallHorizontalCharacter = "═"
    $LabOutsideWallVerticalCharacter = "║"
    $LabOutsideWallTopLeftCornerCharacter = "╔"
    $LabOutsideWallTopRightCornerCharacter = "╗"
    $LabOutsideWallBottomLeftCornerCharacter = "╚"
    $LabOutsideWallBottomRightCornerCharacter = "╝"
    # $LabOutsideWallVerticalLeftInsideWallHorizontalIntersectionCharacter = "╟"
    # $LabOutsideWallVerticalRightInsideWallHorizontalIntersectionCharacter = "╢"
    # $LabOutsideWallHorizontalTopInsideWallVerticalIntersectionCharacter = "╤"
    # $LabOutsideWallHorizontalBottomInsideWallVerticalIntersectionCharacter = "╧"
    # $LabInsideWallHorizontalCharacter = "─"
    # $LabInsideWallVerticalCharacter = "│"
    # $LabInsideWallTopLeftCornerCharacter = "┌"
    # $LabInsideWallTopRightCornerCharacter = "┐"
    # $LabInsideWallBottomLeftCornerCharacter = "└"
    # $LabInsideWallBottomRightCornerCharacter = "┘"
    # $LabInsideWallVerticalLeftInsideWallHorizontalIntersectionCharacter = "├"
    # $LabInsideWallVerticalRightInsideWallHorizontalIntersectionCharacter = "┤"
    # $LabInsideWallHorizontalTopInsideWallVerticalIntersectionCharacter = "┬"
    # $LabInsideWallHorizontalBottomInsideWallVerticalIntersectionCharacter = "┴"
    # $LabInsideWallHorizontalInsideWallVerticalIntersectionCharacter = "┼"
    $LabUserCharacter = "●"
    # "`u{1F57A}" # or ‽ or ☻ -- could have the user select or enter their own.

    If ($Type -eq "box") {
        #Initializing the user's location.
        $LabUserCoords = New-Object -type "System.Management.Automation.Host.Coordinates"
        $LabUserCoords.y = [math]::round($LabMaxWidth / 2)
        $LabUserCoords.x = [math]::round($LabMaxHeight / 2)

        #Create coordinate system based on dimensions and filling in with appropriate characters.
        $LabCoordHashtable = [ordered]@{}
        For ($RowI = 0; $RowI -lt $LabMaxHeight; $RowI++) {
            $LabCoordHashtable.Add($RowI, [ordered]@{})
            For ($ColumnI = 0; $ColumnI -lt $LabMaxWidth; $ColumnI++) {
                If (($RowI -eq 0) -and ($ColumnI -eq 0)) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallTopLeftCornerCharacter)
                } ElseIf (($RowI -eq 0) -and ($ColumnI -eq ($LabMaxWidth - 1))) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallTopRightCornerCharacter)
                } ElseIf (($RowI -eq ($LabMaxHeight - 1)) -and ($ColumnI -eq 0)) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallBottomLeftCornerCharacter)
                } ElseIf (($RowI -eq ($LabMaxHeight - 1)) -and ($ColumnI -eq ($LabMaxWidth - 1))) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallBottomRightCornerCharacter)
                } ElseIf (($RowI -eq 0) -or ($RowI -eq ($LabMaxHeight - 1))) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallHorizontalCharacter)
                } ElseIf (($ColumnI -eq 0) -or ($ColumnI -eq ($LabMaxWidth - 1))) {
                    $LabCoordHashtable[$RowI].add($ColumnI,$LabOutsideWallVerticalCharacter)
                } Else {
                    $LabCoordHashtable[$RowI].add($ColumnI," ")
                }
            }
        }

        Function BuildOutput {
            #Building Initial Output
            $LabOutputString = ""
            For ($RowI = 0; $RowI -lt $LabMaxHeight; $RowI++) {
                If ($RowI -ne $LabUserCoords.x) {
                    $LabOutputString = $LabOutputString + ($LabCoordHashtable[$RowI].values | Join-String) | Join-String
                } Else {
                    For ($ColumnI = 0; $ColumnI -lt $LabMaxWidth; $ColumnI++) {
                        If ($ColumnI -eq $LabUserCoords.y) {
                            $LabOutputString = $LabOutputString + $LabUserCharacter | Join-String
                        } Else {
                            $LabOutputString = $LabOutputString + $LabCoordHashtable[$RowI][$ColumnI] | Join-String
                        }
                    }
                }
                If ($RowI -ne ($LabMaxHeight - 1)) {
                    $LabOutputString = $LabOutputString + "`n" | Join-String
                }
            }

            #Outputting
            $LabOutputString
        }

        BuildOutput

        #Create while loop that does everything within the keypress logic.
        [console]::TreatControlCAsInput = $True
        [console]::CursorVisible = $False
        While ($True) {
            #Opening key reader
            If ([console]::KeyAvailable) {
                #Assessing keypress and moving user if needed.
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the Return after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Clear-Host
                    Return
                } ElseIf (($Key.key -eq "RightArrow") -and ($LabUserCoords.y -ne ($LabMaxWidth - 2))) {
                    $LabUserCoords.y = $LabUserCoords.y + 1
                    Clear-Host
                } ElseIf (($Key.key -eq "LeftArrow") -and ($LabUserCoords.y -ne 1)) {
                    $LabUserCoords.y = $LabUserCoords.y - 1
                    Clear-Host
                } ElseIf (($Key.key -eq "UpArrow") -and ($LabUserCoords.x -ne 1)) {
                    $LabUserCoords.x = $LabUserCoords.x - 1
                    Clear-Host
                } ElseIf (($Key.key -eq "DownArrow") -and ($LabUserCoords.x -ne ($LabMaxHeight - 2))) {
                    $LabUserCoords.x = $LabUserCoords.x + 1
                    Clear-Host
                } Else {
                    Clear-Host
                }
                
                BuildOutput
            }
        }
    } ElseIf ($Type -eq "Map1") {
        #Simple map in which the user can move.
        $LabUserCharacter = "●"

        $LabModulePath = (Get-Module "PowershellAnimations").modulebase
        If (!(Test-Path $LabModulePath)) {
            Write-Host "You don't appear to be running this function from the PowerShellAnimations module."
            Return
        } Else {
            $LabMap1Raw = Get-Content ($LabModulePath + "\Media\Start-Labyrinth-Map1.txt")
        }

        #Initializing the user's location.
        $LabMap1UserCoords = New-Object -type "System.Management.Automation.Host.Coordinates"
        #Rows. Go down 1 in y, go up 1 in rows.
        $LabMap1UserCoords.y = 1
        #Columns. Go up 1 in x, go right in columns.
        $LabMap1UserCoords.x = 1

        # Building raw hashtable
        $LabMap1WorkingHash = [ordered]@{}
        For ($LabMap1RawRowI = 0; $LabMap1RawRowI -lt ($LabMap1Raw.length); $LabMap1RawRowI++) {
            $LabMap1RawRowArray = $LabMap1Raw[$LabMap1RawRowI].tochararray()
            $LabMap1RawRowHash = [ordered]@{}
            For ($LabMap1RawColumnI = 0; $LabMap1RawColumnI -lt $LabMap1RawRowArray.length; $LabMap1RawColumnI++) {
                $LabMap1RawRowHash.add($LabMap1RawColumnI,($LabMap1RawRowArray[$LabMap1RawColumnI]))
            }
            $LabMap1WorkingHash.Add($LabMap1RawRowI,$LabMap1RawRowHash)
        }

        #Inputting user char
        $LabMap1WorkingHash[$LabMap1UserCoords.y][$LabMap1UserCoords.x] = $LabUserCharacter

        Function BuildOutput {
            $LabOutputString = ""
            For ($RowI = 0; $RowI -lt $LabMap1WorkingHash.count; $RowI++) {
                $LabOutputString = $LabOutputString + ($LabMap1WorkingHash[$RowI].values | Join-String) | Join-String
                If ($RowI -ne ($LabMap1WorkingHash.count - 1)) {
                    $LabOutputString = $LabOutputString + "`n" | Join-String
                }
            }

            #Outputting
            $LabOutputString
        }
        #Displaying initial screen
        BuildOutput

        #Create while loop that does everything within the keypress logic.
        [console]::TreatControlCAsInput = $True
        [console]::CursorVisible = $False
        While ($True) {
            #Opening key reader
            If ([console]::KeyAvailable) {
                # Wiping the user character from the room.
                $LabMap1WorkingHash[$LabMap1UserCoords.y][$LabMap1UserCoords.x] = " "

                #Assessing keypress and moving user if needed.
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the Return after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Clear-Host
                    Return
                } ElseIf ($Key.key -eq "DownArrow") {
                    If ($LabMap1WorkingHash[($LabMap1UserCoords.y + 1)][$LabMap1UserCoords.x] -eq " ") {
                        $LabMap1UserCoords.y = $LabMap1UserCoords.y + 1
                    }
                    Clear-Host
                } ElseIf ($Key.key -eq "UpArrow") {
                    If ($LabMap1WorkingHash[($LabMap1UserCoords.y - 1)][$LabMap1UserCoords.x] -eq " ") {
                        $LabMap1UserCoords.y = $LabMap1UserCoords.y - 1
                    }
                    Clear-Host
                } ElseIf ($Key.key -eq "LeftArrow") {
                    If ($LabMap1WorkingHash[($LabMap1UserCoords.y)][($LabMap1UserCoords.x - 1)] -eq " ") {
                        $LabMap1UserCoords.x = $LabMap1UserCoords.x - 1
                    }
                    Clear-Host
                } ElseIf ($Key.key -eq "RightArrow") {
                    If ($LabMap1WorkingHash[($LabMap1UserCoords.y)][($LabMap1UserCoords.x + 1)] -eq " ") {
                        $LabMap1UserCoords.x = $LabMap1UserCoords.x + 1
                    }
                    Clear-Host
                } Else {
                    Clear-Host
                }

                $LabMap1WorkingHash[$LabMap1UserCoords.y][$LabMap1UserCoords.x] = $LabUserCharacter
                BuildOutput
            }
        }
    } ElseIf ($Type -eq "Map2") {
        # Bigger map, only displays a portion of it. Shows 11 horizontal and 5 vertical cells around the user.
        $LabUserCharacter = "●"

        $LabModulePath = (Get-Module "PowershellAnimations").modulebase
        If (!(Test-Path $LabModulePath)) {
            Write-Host "You don't appear to be running this function from the PowerShellAnimations module."
            Return
        } Else {
            $LabMap2Raw = Get-Content ($LabModulePath + "\Media\Start-Labyrinth-Map2.txt")
        }

        #Initializing the user's location.
        $LabMap2UserCoords = New-Object -type "System.Management.Automation.Host.Coordinates"
        #Rows. Go down 1 in y, go up 1 in rows.
        $LabMap2UserCoords.y = 1
        #Columns. Go up 1 in x, go right in columns.
        $LabMap2UserCoords.x = 1

        # Building raw hashtable
        $LabMap2WorkingHash = [ordered]@{}
        For ($LabMap2RawRowI = 0; $LabMap2RawRowI -lt ($LabMap2Raw.length); $LabMap2RawRowI++) {
            $LabMap2RawRowArray = $LabMap2Raw[$LabMap2RawRowI].tochararray()
            $LabMap2RawRowHash = [ordered]@{}
            For ($LabMap2RawColumnI = 0; $LabMap2RawColumnI -lt $LabMap2RawRowArray.length; $LabMap2RawColumnI++) {
                $LabMap2RawRowHash.add($LabMap2RawColumnI,($LabMap2RawRowArray[$LabMap2RawColumnI]))
            }
            $LabMap2WorkingHash.Add($LabMap2RawRowI,$LabMap2RawRowHash)
        }

        #Inputting user char
        $LabMap2WorkingHash[$LabMap2UserCoords.y][$LabMap2UserCoords.x] = $LabUserCharacter

        Function BuildOutput {
            #Building a hashtable of just the cells around the user character.
            $LabOutputHashtable = [ordered]@{}
            $LabOutputRangeX = @{"Min" = $LabMap2UserCoords.x - 8; "Max" = $LabMap2UserCoords.x + 8}
            $LabOutputRangeY = @{"Min" = $LabMap2UserCoords.y - 8; "Max" = $LabMap2UserCoords.y + 8}
            
            For ($RowI = $LabOutputRangeY.min; $RowI -le $LabOutputRangeY.max; $RowI++) {
                $LabOutputHashtableColumns = [ordered]@{}
                If ($LabMap2WorkingHash.contains($RowI)) {
                    For ($ColumnI = $LabOutputRangeX.min; $ColumnI -le $LabOutputRangeX.max; $ColumnI++) {
                        If ($LabMap2WorkingHash[$RowI].contains($ColumnI)) {
                            $LabOutputHashtableColumns.add($ColumnI,($LabMap2WorkingHash[$RowI][$ColumnI])) | Out-Null
                        } Else {
                            $LabOutputHashtableColumns.add($ColumnI," ")
                        } 
                    }
                } Else {
                    For ($ColumnI = $LabOutputRangeX.min; $ColumnI -le $LabOutputRangeX.max; $ColumnI++) {
                        $LabOutputHashtableColumns.add($ColumnI," ")
                    }
                }
                $LabOutputHashtable.add($RowI,$LabOutputHashtableColumns)
            }
            
            #Building output string
            $LabOutputString = $LabOutputHashtable.keys | Foreach-Object {$LabOutputHashtable.$_.values | Join-String}

            #Outputting
            Clear-Host
            $LabOutputString
        }
        #Displaying initial screen
        BuildOutput

        #Create while loop that does everything within the keypress logic.
        [console]::TreatControlCAsInput = $True
        [console]::CursorVisible = $False
        While ($True) {
            #Opening key reader
            If ([console]::KeyAvailable) {
                # Wiping the user character from the room.
                $LabMap2WorkingHash[$LabMap2UserCoords.y][$LabMap2UserCoords.x] = " "

                #Assessing keypress and moving user if needed.
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the Return after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    Clear-Host
                    Return
                } ElseIf ($Key.key -eq "DownArrow") {
                    If ($LabMap2WorkingHash[($LabMap2UserCoords.y + 1)][$LabMap2UserCoords.x] -eq " ") {
                        $LabMap2UserCoords.y = $LabMap2UserCoords.y + 1
                    }
                } ElseIf ($Key.key -eq "UpArrow") {
                    If ($LabMap2WorkingHash[($LabMap2UserCoords.y - 1)][$LabMap2UserCoords.x] -eq " ") {
                        $LabMap2UserCoords.y = $LabMap2UserCoords.y - 1
                    }
                } ElseIf ($Key.key -eq "LeftArrow") {
                    If ($LabMap2WorkingHash[($LabMap2UserCoords.y)][($LabMap2UserCoords.x - 1)] -eq " ") {
                        $LabMap2UserCoords.x = $LabMap2UserCoords.x - 1
                    }
                } ElseIf ($Key.key -eq "RightArrow") {
                    If ($LabMap2WorkingHash[($LabMap2UserCoords.y)][($LabMap2UserCoords.x + 1)] -eq " ") {
                        $LabMap2UserCoords.x = $LabMap2UserCoords.x + 1
                    }
                }
                
                $LabMap2WorkingHash[$LabMap2UserCoords.y][$LabMap2UserCoords.x] = $LabUserCharacter
                BuildOutput
            }
        }
    } ElseIf ($Type -eq "Directory") {
        #Navigating directories by a simple up/down marker and hitting enter to go to them. Hitting enter on a file opens it with the default program. Maybe make a way to open with a different program.
        

    } Else {
        Write-Host "You haven't entered a valid type."
    }
}