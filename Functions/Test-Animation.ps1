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
Function Test-Animation {
    <#
    I'd like it so that I can call this cmdlet whenever I need a progress identifier, with it running only as long as the input job is running. $Input is an automatic variable that represents pipeline input. 
    #It'd be easy enough to do the $Job = Start-Job portion in other functions and then just call the While loop with this function. 
    #I might also be able to use it for general animations like for Get-Backpat. 
    Also these can play wav files and maybe other sound files for that purpose. 
    #>
    param (
        [Parameter(helpmessage="Your choice of animation type. Choose from: roll, v, mario, horse. Defaults to roll.")][String]$Type = "Roll",
        [parameter(helpmessage="Use to turn off sound.")][Switch]$NoSound
    )

    [console]::CursorVisible = $False
    $VersionPath = (Get-Module "AToolbox").ModuleBase
    $SMBOWSoundPath = $VersionPath + '\media\SMBOverworld.wav'
    If ($Null -eq $VersionPath) {
        Throw "You don't seem to be running this function from the AToolbox module. It's only designed for that context."
    }
    If (!(Test-Path -pathtype leaf -literalpath $SMBOWSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }

    #Horse
    $HorsePath = $VersionPath + '\media\ascii-horse.txt'
    $HorseContent = Get-Content $HorsePath -delimiter "somethingthatdoesn'texistinthefile"
    $HorseContentCharArray = $HorseContent.tochararray()
    $Number = -1
    $Iteration = 0
    $HorseContentCharSubArray = @()
    $HorseContentSpritesArray = @(
        for ($i = 0; $i -lt $HorseContentCharArray.Count; $i++) {
            $Iteration++
            #1
            If ($Iteration -lt 201) {
                $HorseContentCharSubArray += $HorseContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($HorseContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $HorseContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($HorseContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )

    #Fish
    $FishPath = $VersionPath + '\media\ascii-fish.txt'
    $FishContent = Get-Content $FishPath -delimiter "somethingthatdoesn'texistinthefile"
    $FishContentCharArray = $FishContent.tochararray()
    $Number = -1
    $Iteration = 0
    $FishContentCharSubArray = @()
    $FishContentSpritesArray = @(
        for ($i = 0; $i -lt $FishContentCharArray.Count; $i++) {
            $Iteration++
            #1
            If ($Iteration -lt 116) {
                $FishContentCharSubArray += $FishContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($FishContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $FishContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($FishContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )

    #Duck
    $DuckPath = $VersionPath + '\media\ascii-Duck.txt'
    $DuckContent = Get-Content $DuckPath -delimiter "somethingthatdoesn'texistinthefile"
    $DuckContentCharArray = $DuckContent.tochararray()
    $Number = -1
    $Iteration = 0
    $DuckContentCharSubArray = @()
    $DuckContentSpritesArray = @(
        for ($i = 0; $i -lt $DuckContentCharArray.Count; $i++) {
            $Iteration++
            #1
            If ($Iteration -lt 89) {
                $DuckContentCharSubArray += $DuckContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($DuckContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $DuckContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($DuckContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )

    #Maybe change this to randomize the sound.
    $PlaySound = New-Object System.Media.SoundPlayer
    $PlaySound.SoundLocation = $SMBOWSoundPath

    $FGC = @('DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White') | Get-Random
    $BGC = @('Black','DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White') | Get-Random

    If ($Type -eq "roll"){ 
        $ProgressBar = @('|','/','-','\')
        $JobName = Start-Job -ScriptBlock {
            Start-Sleep -seconds 10
        }
        $I = -1
        While($JobName.JobStateInfo.State -eq "Running") {
            If ($I -eq ($ProgressBar.count - 1)) {$I = 0} Else {$I++}
            Write-Host $ProgressBar[$I] -foregroundcolor $FGC -NoNewline
            Start-Sleep -Milliseconds 125
            Write-Host "`b" -NoNewline
        }
        [console]::CursorVisible = $True
    } ElseIf ($Type -eq "V") {
        $VPath = $VersionPath + '\media\ASCII-V-Inverse.txt'
        If (!(Test-Path -pathtype leaf -literalpath $VPath)) {
            Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
        }
        
        $VContent = (Get-Content $VPath -delimiter "astringthatsnotinthefile").ToCharArray()
        $I = -1

        If ($NoSound -eq $True) {$PlaySound.Play()}

        [console]::TreatControlCAsInput = $True
        While ($True) { 
            If ([console]::KeyAvailable) {
                $Key = [system.console]::readkey($True)
                If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                    #Everything that precedes the break after a ctrl+c goes here.
                    [console]::TreatControlCAsInput = $False
                    [console]::CursorVisible = $True
                    If ($NoSound -eq $True) {$PlaySound.stop()}
                    Break
                }
            }
    
            #Cycling/recycling the animation when it reaches its end. 
            If ($I -eq ($VContent.count - 1)) {$I = 0; Clear-Host; $FGC = @('DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White'; $BGC = @('Black','DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White') | Get-Random) | Get-Random} Else {$I++}
            Write-Host $VContent[$I] -NoNewline -ForegroundColor $FGC -BackgroundColor $BGC
        }
    } ElseIf ($Type -eq "mario") {
        $MarioPath = $VersionPath + '\media\ASCII-Mario-Inverse.txt'
        If (!(Test-Path -pathtype leaf -literalpath $MarioPath)) {
            Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
        }
        $MarioContent = Get-Content $MarioPath -delimiter "<d>"

        $I = -1
        [console]::TreatControlCAsInput = $True
        While ($True) { 
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

            If ($I -eq ($MarioContent.count - 1)) {$I = 0} Else {$I++}
            Clear-Host
            Write-Host $MarioContent[$I] -NoNewline -foregroundcolor "red"
            Start-Sleep -Milliseconds 125
        }
    } ElseIf ($Type -eq "horse") {
        While ($True) {
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

            If ($HorseI -eq ($HorseContentSpritesArray.count - 1)) {$HorseI = 0} Else {$HorseI++}
            Clear-Host
            Write-Host $HorseContentSpritesArray.asciicontent[$HorseI] -foregroundcolor "white" -backgroundcolor "darkblue" -nonewline
            Write-Host "                       `n                       `n                       " -backgroundcolor "darkgreen"
            Start-Sleep -Milliseconds 250
        }
    } ElseIf ($Type -eq "fish") {
        While ($True) {
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

            If ($FishI -eq ($FishContentSpritesArray.count - 1)) {$FishI = 0} Else {$FishI++}
            Clear-Host
            Write-Host $FishContentSpritesArray.asciicontent[$FishI] -foregroundcolor "white" -backgroundcolor "darkblue" -nonewline
            Write-Host "                     `n                     " -backgroundcolor "darkyellow" -nonewline
            Start-Sleep -Milliseconds 200
        } 
    } ElseIf ($Type -eq "duck") {
        While ($True) {
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

            If ($DuckI -eq ($DuckContentSpritesArray.count - 1)) {$DuckI = 0} Else {$DuckI++}
            Clear-Host
            Write-Host $DuckContentSpritesArray.asciicontent[$DuckI] -foregroundcolor "white" -backgroundcolor "darkblue" -nonewline
            Start-Sleep -Milliseconds 250
        } 
    } Else {
        Throw "Please enter a valid -type."
    }
}