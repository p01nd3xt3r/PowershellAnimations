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
    
    $LabUserCharacter = "●"
    
    Function BuildLocationHash {
        param (
            [Parameter()][String]$Path
        )
        #Building hash.
        $LabDirLocationItems = Get-ChildItem $Path
        $LabDirHash = [ordered]@{}
        For ($LabDirI = 0; $LabDirI -lt $LabDirLocationItems.count; $LabDirI++) {
            $LabDirHash.add($LabDirI,$LabDirLocationItems[$LabDirI])
        }
        Return $LabDirHash
    }

    Function BuildOutput {
        #Hashtable of objects with properties of Item, Type, and Selection, with the Selection having the user character if it's where the user has it.
        $LabDirOutputArray = @()
        For ($LabDirHashI = 0; $LabDirHashI -lt $LabDirHash.count; $LabDirHashI++) {
            If (($LabDirHash[$LabDirHashI]).mode -notlike "d*") {
                $LabDirHashILength = ($LabDirHash[$LabDirHashI]).length
            } Else {
                $LabDirHashILength = " "
            }
            If (($LabDirHashI + 1) -eq $LabDirUserLocation) {
                $LabDirHashISelection = $LabUserCharacter
            } Else {
                $LabDirHashISelection = " "
            }
            $LabDirHashObjectProperties = [ordered]@{
                $LabUserCharacter = $LabDirHashISelection
                Mode = ($LabDirHash[$LabDirHashI]).mode
                LastWriteTime = ($LabDirHash[$LabDirHashI]).lastwritetime
                Length = $LabDirHashILength
                Name = ($LabDirHash[$LabDirHashI]).name
            }
            $LabDirOutputArray += New-Object -typename psobject -property $LabDirHashObjectProperties
        }

        Clear-Host
        Start-Sleep -Milliseconds 5
        If ($LabDirOutputArray.count -gt 0) {
            Prompt
            "`n    Directory: " + $LabDirHashCurrentLocation + "`n"
            $LabDirOutputArray | Format-Table
        } Else {
            Prompt
            "`n    Directory: " + $LabDirHashCurrentLocation + "`n"
            "`nThe current directory is either empty or otherwise unreadable.`n"
        }
        "↑↓ Navigate list `n← Back to parent folder  → Enter selected folder`nSPACE End the function at the current location`nENTER Open the selected file or folder with its app`n"
    }
    
    $LabDirUserLocation = 1
    $LabDirHashCurrentLocation = Get-Item (Get-Location)
    $LabDirHash = BuildLocationHash -path $LabDirHashCurrentLocation
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
            } ElseIf (($Key.key -eq "DownArrow") -and ($LabDirUserLocation -lt $LabDirHash.count)) {
                $LabDirUserLocation++
                $LabDirHash = BuildLocationHash -path $LabDirHashCurrentLocation
                BuildOutput
            } ElseIf (($Key.key -eq "UpArrow") -and ($LabDirUserLocation -gt 1)) {
                $LabDirUserLocation--
                $LabDirHash = BuildLocationHash -path $LabDirHashCurrentLocation
                BuildOutput
            } ElseIf ($Key.key -eq "LeftArrow") {
                # Go up a directory.
                If ($Null -ne $LabDirHashCurrentLocation.parent) {
                    $LabDirUserLocation = 1
                    $LabDirHashCurrentLocation = $LabDirHashCurrentLocation.parent
                    $LabDirHash = BuildLocationHash -path $LabDirHashCurrentLocation
                    BuildOutput
                }
            } ElseIf ($Key.key -eq "RightArrow") {
                # Go down a directory.
                $LabDirHashResolvedSelection = $LabDirHash[($LabDirUserLocation - 1)]
                If ($LabDirHashResolvedSelection.mode -like "d*") {
                    $LabDirUserLocation = 1
                    $LabDirHashCurrentLocation = Get-Item ($LabDirHashResolvedSelection.fullname)
                    $LabDirHash = BuildLocationHash -path $LabDirHashCurrentLocation
                    BuildOutput
                }
            } ElseIf ($Key.key -eq "Enter") {
                #If a file, opens the file with the default program. If a directory, opens the directory in Explorer.
                $LabDirHashResolvedSelection = $LabDirHash[($LabDirUserLocation - 1)]
                If ($LabDirHashResolvedSelection.mode -like "d*") {
                    Start-Process $LabDirHashResolvedSelection
                } ElseIf ($Null -ne $LabDirHashResolvedSelection.fullname) {
                    &($LabDirHashResolvedSelection.fullname)
                }
            } ElseIf ($Key.key -eq "Space") {
                # Do a cd into the current directory and end this function.
                Set-Location $LabDirHashCurrentLocation
                Return
            } 
            # ElseIf ($Key.key -eq ":") {
            #     # Change volumes.
                
            # }
        }
    }
}