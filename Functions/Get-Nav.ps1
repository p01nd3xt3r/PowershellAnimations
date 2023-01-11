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

Function Get-Nav {
    # Navigating directories by a simple up/down marker and hitting left or right to go to them. Hitting enter on a file opens it with the default program. Space changes the PS session's location to the function's current location.

    # Note that PS7 has colorized results for get-childitem. It probably uses $psstyle and ascii escapes. To make this compatible with ps5, though, I'm withholding coloring.
    
    $NavUserCharacter = "●"
    $NavMountedDrivesArray = (Get-PSDrive -psprovider filesystem).name
    
    Function BuildLocationHash {
        param (
            [Parameter()][String]$Path
        )
        #Building hash.
        $NavLocationItems = Get-ChildItem $Path
        $NavHash = [ordered]@{}
        For ($NavI = 0; $NavI -lt $NavLocationItems.count; $NavI++) {
            $NavHash.add($NavI,$NavLocationItems[$NavI])
        }
        Return $NavHash
    }

    # Getting content size.
    $NavHeaderPlusLocationRowCount = 6
    $NavHeader = (Prompt).tostring() + "`n"
    $NavFooterRowCount = 5
    $NavFooter = "↑↓ Navigate list   ← Back to parent folder   → Enter selected folder`nSPACE End the function at the current location   ENTER Open the selected file or folder`nChange volume with its drive letter`n"
    $NavContentTopRow = $NavHeaderPlusLocationRowCount
    $NavContentMaxBottomRow = ((Get-Host).ui.rawui.windowsize.height) - $NavFooterRowCount - 2
    If (($NavContentMaxBottomRow - $NavContentTopRow) -lt 3) {
        $NavContentMaxBottomRow = $NavContentTopRow + 3
    }
    $NavContentSpread = $NavContentMaxBottomRow - $NavContentTopRow
    
    #Initiating hash, so it's accessible outside the following function. Is that necessary?
    $NavContentKeysHash = @{
        Top = 0
        BottomMax = 0
    }
    
    Function BuildKeyAnchors {
        param (
            [Parameter()][int]$Top = 0,
            [Parameter()][int]$BottomMax = $Top + $NavContentSpread
        )

        $NavContentKeysHash["Top"] = $Top
        
        # If there are less results than the max allowed bottom row, set the bottom row to the bottom result.
        If (($NavHash.count - 1) -le $BottomMax) {
            $NavContentKeysHash["BottomMax"] = $NavHash.count - 1
        } Else {
            $NavContentKeysHash["BottomMax"] = $BottomMax
        }
    }

    Function BuildOutput {
        #Hashtable of objects with properties of Item, Type, and Selection, with the Selection having the user character if it's where the user has it.

        $NavOutputHash = [ordered]@{}

        If (($NavContentKeysHash["Top"] -gt 0) -and ($NavContentKeysHash["BottomMax"] -lt ($NavHash.count - 1))) {
            $NavSelectorColumnHeader = "↕"
        } ElseIf ($NavContentKeysHash["Top"] -gt 0) {
            $NavSelectorColumnHeader = "↑"
        } ElseIf ($NavContentKeysHash["BottomMax"] -lt ($NavHash.count - 1)) {
            $NavSelectorColumnHeader = "↓"
        } Else {
            $NavSelectorColumnHeader = $NavUserCharacter
        }

        For ($NavHashI = $NavContentKeysHash["Top"]; $NavHashI -le $NavContentKeysHash["BottomMax"]; $NavHashI++) {
            
            If (($NavHash[$NavHashI]).mode -notlike "d*") {
                $NavHashILength = ($NavHash[$NavHashI]).length
            } Else {
                $NavHashILength = " "
            }

            If ($NavHashI -eq $NavUserLocation) {
                $NavHashISelection = $NavUserCharacter
            } Else {
                $NavHashISelection = " "
            }

            $NavHashObjectProperties = [ordered]@{
                $NavSelectorColumnHeader = $NavHashISelection
                Mode = ($NavHash[$NavHashI]).mode
                LastWriteTime = ($NavHash[$NavHashI]).lastwritetime
                Length = $NavHashILength
                Name = ($NavHash[$NavHashI]).name
            }

            $NavOutputHash.add($NavHashI,(New-Object -typename psobject -property $NavHashObjectProperties))
        }

        If ($NavOutputHash.count -gt 0) {
            $NavOutputContents = $NavOutputHash.values | Format-Table
        } Else {
            $NavOutputContents = "`nThis directory is empty or otherwise unreadable.`n"
        }

        $NavOutputArray = @($NavHeader, ("    Directory: " + $NavHashCurrentLocation + "   Item Count: " + $NavHash.count), $NavOutputContents, $NavFooter)

        Clear-Host
        $NavOutputArray
    }
    
    $NavUserLocation = 0
    $NavHashCurrentLocation = Get-Item (Get-Location)
    $NavHash = BuildLocationHash -path $NavHashCurrentLocation
    BuildKeyAnchors
    BuildOutput

    #Create while loop that does everything within the keypress logic.
    [console]::TreatControlCAsInput = $True
    [console]::CursorVisible = $False
    While ($True) {
        #Opening key reader
        If ([console]::KeyAvailable) {
            #Assessing keypress and moving user if needed.
            $Key = [system.console]::readkey($True)
            If ((($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) -or ($Key.key -eq "escape")) {
                #Everything that precedes the Return after a ctrl+c goes here.
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Clear-Host
                Return
            } ElseIf (($Key.key -eq "DownArrow") -and ($NavUserLocation -lt ($NavHash.count - 1))) {
                $NavUserLocation++
                If ($NavUserLocation -gt $NavContentKeysHash["BottomMax"]) {
                    BuildKeyAnchors -top ($NavContentKeysHash["Top"] + 1)
                }
                BuildOutput
            } ElseIf (($Key.key -eq "UpArrow") -and ($NavUserLocation -gt 0)) {
                $NavUserLocation--
                If ($NavUserLocation -lt $NavContentKeysHash["Top"]) {
                    BuildKeyAnchors -top ($NavContentKeysHash["Top"] - 1)
                }
                BuildOutput
            } ElseIf ($Key.key -eq "LeftArrow") {
                # Go up a directory.
                If ($Null -ne $NavHashCurrentLocation.parent) {
                    $NavUserLocation = 0
                    $NavHashCurrentLocation = $NavHashCurrentLocation.parent
                    $NavHash = BuildLocationHash -path $NavHashCurrentLocation
                    BuildKeyAnchors
                    BuildOutput
                }
            } ElseIf ($Key.key -eq "RightArrow") {
                # Go down a directory.
                $NavHashResolvedSelection = $NavHash[($NavUserLocation)]
                If (($NavHashResolvedSelection.mode -like "d*") -or ($NavHashResolvedSelection.mode -like "l*")) {
                    $NavUserLocation = 0
                    $NavHashCurrentLocation = Get-Item ($NavHashResolvedSelection.fullname)
                    $NavHash = BuildLocationHash -path $NavHashCurrentLocation
                    BuildKeyAnchors
                    BuildOutput
                }
            } ElseIf ($Key.key -eq "Enter") {
                #If a file, opens the file with the default program. If a directory, opens the directory in Explorer.
                $NavHashResolvedSelection = $NavHash[($NavUserLocation)]
                If ($NavHashResolvedSelection.mode -like "d*") {
                    Start-Process $NavHashResolvedSelection
                } ElseIf ($Null -ne $NavHashResolvedSelection.fullname) {
                    &($NavHashResolvedSelection.fullname)
                }
            } ElseIf ($Key.key -eq "Space") {
                # Do a cd into the current directory and end this function.
                Set-Location $NavHashCurrentLocation
                Return
            } ElseIf ($Key.key -in $NavMountedDrivesArray) {
                # Change volumes. Only works for single-letter drives.
                $NavDrive = $Key.key, ":" | Join-String
                $NavUserLocation = 0
                $NavHashCurrentLocation = $NavDrive
                $NavHash = BuildLocationHash -path $NavHashCurrentLocation
                BuildKeyAnchors
                BuildOutput
            }
            
            # Sort options?
        }
    }
}