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
    } Else {
        Write-Host "You haven't entered a valid type."
    }
}