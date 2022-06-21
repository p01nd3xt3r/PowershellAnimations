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
Function Start-PlumberTimer {
    param (
        [Parameter(helpmessage="asd")][string]$Time = 10,
        [Parameter(helpmessage="asd")][switch]$NoSound
    )

    [console]::CursorVisible = $False

    #Formatting $Time parameter input. 
    [long[]]$TimeSplit = $Time -split ':'
    If ($TimeSplit.count -gt 4) {
        Throw "Sorry, you can only enter up to the unit of day. Please use the format (days):(hours):(minutes):(seconds), and don't go over three colons."
    }
    ForEach ($Obj in $TimeSplit) {
        If (!($Time -match '\d{1,}')) {
            Throw "Please enter only numbers."
        }
    }
    For (($TimeSplitIndex = ($TimeSplit.count - 1)); $TimeSplitIndex -ge 0; $TimeSplitIndex--) {
        If ($TimeSplitIndex -eq ($TimeSplit.count - 1)) {
            $TotalTime += New-Timespan -seconds $TimeSplit[$TimeSplitIndex]
        } ElseIf ($TimeSplitIndex -eq ($TimeSplit.count - 2)) {
            $TotalTime += New-Timespan -minutes $TimeSplit[$TimeSplitIndex]
        } ElseIf ($TimeSplitIndex -eq ($TimeSplit.count - 3)) {
            $TotalTime += New-Timespan -hours $TimeSplit[$TimeSplitIndex]
        } Else {
            $TotalTime += New-Timespan -days $TimeSplit[$TimeSplitIndex]
        }
    }

    #General content
    $VersionPath = (Get-Module "PowershellAnimations").ModuleBase
    If ($Null -eq $VersionPath) {
        Throw "You don't seem to be running this function from the AToolbox module. It's only designed for that context."
    }

    #Sound content
    $SMBOverWorldSoundPath = $VersionPath + '\media\SMBOverworld.wav'
    If (!(Test-Path -pathtype leaf -literalpath $SMBOverWorldSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $SMBOverWorldSoundPlayer = New-Object System.Media.SoundPlayer
    $SMBOverWorldSoundPlayer.SoundLocation = $SMBOverWorldSoundPath
    
    $SMBFireworksSoundPath = $VersionPath + '\media\SMBFireworks.wav'
    If (!(Test-Path -pathtype leaf -literalpath $SMBFireworksSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $SMBFireworksSoundPlayer = New-Object System.Media.SoundPlayer
    $SMBFireworksSoundPlayer.SoundLocation = $SMBFireworksSoundPath

    $SMBFanfareSoundPath = $VersionPath + '\media\SMBFanfare.wav'
    If (!(Test-Path -pathtype leaf -literalpath $SMBFanfareSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $SMBFanfareSoundPlayer = New-Object System.Media.SoundPlayer
    $SMBFanfareSoundPlayer.SoundLocation = $SMBFanfareSoundPath

    $SMBHurryUpSoundPath = $VersionPath + '\media\SMBHurryUp.wav'
    If (!(Test-Path -pathtype leaf -literalpath $SMBHurryUpSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $SMBHurryUpSoundPlayer = New-Object System.Media.SoundPlayer
    $SMBHurryUpSoundPlayer.SoundLocation = $SMBHurryUpSoundPath

    $SMBOverworldRapidSoundPath = $VersionPath + '\media\SMBOverworldRapid.wav'
    If (!(Test-Path -pathtype leaf -literalpath $SMBOverworldRapidSoundPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $SMBOverworldRapidSoundPlayer = New-Object System.Media.SoundPlayer
    $SMBOverworldRapidSoundPlayer.SoundLocation = $SMBOverworldRapidSoundPath

    #Mario animation content
    $MarioPath = $VersionPath + '\media\ASCII-Mario-Inverse.txt'
    If (!(Test-Path -pathtype leaf -literalpath $MarioPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $MarioContent = Get-Content $MarioPath -delimiter "somethingthatdoesn'texistinthefile"
    $MarioContentCharArray = $MarioContent.tochararray()
    $Number = -1
    $Iteration = 0
    $MarioContentCharSubArray = @()
    $MarioContentSpritesArray = @(
        for ($i = 0; $i -lt $MarioContentCharArray.Count; $i++) {
            $Iteration++
            If ($Iteration -lt 1551) {
                $MarioContentCharSubArray += $MarioContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($MarioContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $MarioContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($MarioContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )
    #$MarioContentFinale = ""
    $MarioI = 0


    #Clock content
    $ClockPath = $VersionPath + '\media\ASCII-ClockDigits.txt'
    If (!(Test-Path -pathtype leaf -literalpath $ClockPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
        #Creating a variable of an array of objects of the ASCII characters called $ClockContentDigitsArray.
    $ClockContent = Get-Content $ClockPath -delimiter "somethingthatdoesn'texistinthefile"
    $ClockContentCharArray = $ClockContent.tochararray()
    $Number = -1
    $Iteration = 0
    $ClockContentCharSubArray = @()
    $ClockContentDigitsArray = @(
        for ($i = 0; $i -lt $ClockContentCharArray.Count; $i++) {
            $Iteration++
            #1
            If ($Iteration -lt 37) {
                $ClockContentCharSubArray += $ClockContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($ClockContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $ClockContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($ClockContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )
    $ClockContentFinale = "   __     __      _     __     __      _     __     __      _     __     __  `n  /  \   /  \    (_)   /  \   /  \    (_)   /  \   /  \    (_)   /  \   /  \ `n | () | | () |    _   | () | | () |    _   | () | | () |    _   | () | | () |`n  \__/   \__/    (_)   \__/   \__/    (_)   \__/   \__/    (_)   \__/   \__/ "
        #Creating a Unicode number to Int cipher for using the strings of the time objects as indexes of the array of ASCII digits I have. 
    $Int = -1
    $Chars = ('0123456789').tochararray()
    $UnicodeToASCIICipher = @(
        ForEach ($Char in $Chars) {
            $Int++
            $ConversionProperties = @{
                Int = $Int
                Unicode = $Char
            }
            New-Object psobject -property $ConversionProperties
        }
    )

    $TitleContent = " ______  ___ _   _   _ __  __ ___ ___ ___   _____ ___ __  __ ___ ___  ______ `n|______|| _ \ | | | | |  \/  | _ ) __| _ \ |_   _|_ _|  \/  | __| _ \|______|`n \____/ |  _/ |_| |_| | |\/| | _ \ _||   /   | |  | || |\/| | _||   / \____/ `n  |  |  |_| |____\___/|_|  |_|___/___|_|_\   |_| |___|_|  |_|___|_|_\  |  |  `n  |__|  =============================================================  |__|  "

    #Fireworks Content
    $FWPath = $VersionPath + '\media\ASCII-Mario-Fireworks-Inverse.txt'
    If (!(Test-Path -pathtype leaf -literalpath $FWPath)) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }
    $FWContent = Get-Content $FWPath -delimiter "somethingthatdoesn'texistinthefile"
    $FWContentCharArray = $FWContent.tochararray()
    $Number = -1
    $Iteration = 0
    $FWContentCharSubArray = @()
    $FWContentSpritesArray = @(
        for ($i = 0; $i -lt $FWContentCharArray.Count; $i++) {
            $Iteration++
            #1
            If ($Iteration -lt 1676) {
                $FWContentCharSubArray += $FWContentCharArray[$i]
            } Else {
                $Number++
                $CharIdentity = @{
                    Number = $Number
                    ASCIIContent = ($FWContentCharSubArray -join "")
                }
                New-Object psobject -property $CharIdentity
                $Iteration = 0
                $FWContentCharSubArray.clear()
                $i--
            }
        }
        $Number++
        $CharIdentity = @{
            Number = $Number
            ASCIIContent = ($FWContentCharSubArray -join "")
        }
        New-Object psobject -property $CharIdentity
    )

    
    $RapidTotalTime = New-Timespan -seconds 28
    $RegularSpeedTime = $TotalTime - $RapidTotalTime
    $OneSecondAdjustment = New-TimeSpan -Seconds 1 #This is used later in the loop.
    $Stopwatch = New-Object -TypeName System.Diagnostics.Stopwatch
    $StopwatchMillisecondsForInterval = 125
    #Alternate way to do New-Timespan, since that cmdlet doesn't have a -milliseconds parameter.
    $StopwatchInterval = [TimeSpan]::FromMilliseconds($StopwatchMillisecondsForInterval)
    $SMBHurryUpTimerMarkInterval = New-Timespan -seconds 3
    [console]::TreatControlCAsInput = $True

    $Stopwatch.start()
    If ($False -eq $NoSound) {$SMBOverWorldSoundPlayer.playlooping()}
    $LoopSpeedSwitch = $False
    While ($Stopwatch.elapsed -le $TotalTime) {
        If ([console]::KeyAvailable) {
            $Key = [system.console]::readkey($True)
            If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                #Everything that precedes the Return after a ctrl+c goes here.
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Clear-Host
                $Stopwatch.stop()
                If ($False -eq $NoSound) {
                    $SMBOverWorldSoundPlayer.stop()
                    $SMBFireworksSoundPlayer.stop()
                    $SMBFanfareSoundPlayer.stop()
                    $SMBHurryUpSoundPlayer.stop()
                    $SMBOverworldRapidSoundPlayer.stop()
                }
                Return
            }
        }


        #Clock Countdown loops
        $RemainingTime = ($TotalTime - $Stopwatch.elapsed + $OneSecondAdjustment)
        $RemainingTimeFormatted = "{0:dd}:{0:hh}:{0:mm}:{0:ss}" -f ($RemainingTime)
        $RemainingTimeCharArray = $RemainingTimeFormatted.tochararray()
        $RowedCharactersArray = @(
            [string]"",
            [string]"",
            [string]"",
            [string]""
        )

        ForEach ($CharDigit in $RemainingTimeCharArray) {
            $ColumnIteration = 0
            $RowArrayIndex = 0
            If ($CharDigit -eq ':') {
                For ($CCDigitsArrayIndex = 0; $CCDigitsArrayIndex -lt 36; $CCDigitsArrayIndex++) {
                    $RowedCharactersArray[$RowArrayIndex] += [string]$ClockContentDigitsArray[10].asciicontent[$CCDigitsArrayIndex]
                    $ColumnIteration++
                    If ($ColumnIteration -eq 7) {
                        $ColumnIteration = 0
                        $RowArrayIndex++
                        #This is for skipping past the CRLF at characters 8 and 9.
                        $CCDigitsArrayIndex++
                        $CCDigitsArrayIndex++
                    }
                }
            } Else {
                For ($CCDigitsArrayIndex = 0; $CCDigitsArrayIndex -lt 36; $CCDigitsArrayIndex++) {
                    $RowedCharactersArray[$RowArrayIndex] += [string]$ClockContentDigitsArray[($UnicodeToASCIICipher | Where-Object {$_.unicode -eq $CharDigit}).int].asciicontent[$CCDigitsArrayIndex]
                    $ColumnIteration++
                    If ($ColumnIteration -eq 7) {
                        $ColumnIteration = 0
                        $RowArrayIndex++
                        #This is for skipping past the CRLF at characters 8 and 9.
                        $CCDigitsArrayIndex++
                        $CCDigitsArrayIndex++
                    }
                }
            }
        }
        $ASCIICountdown = $RowedCharactersArray -join "`n"

        #Mario animation prep
        If ($MarioI -eq ($MarioContentSpritesArray.count - 1)) {$MarioI = 0} Else {$MarioI++}

        #Writing
        Clear-Host
        Write-Host $TitleContent -foregroundcolor "red"
        Write-Host $MarioContentSpritesArray.asciicontent[$MarioI] -foregroundcolor "red"
        Write-Host $ASCIICountdown -foregroundcolor "darkyellow"
        $RowedCharactersArray.clear()
        
        If ($LoopSpeedSwitch -eq $True) {
            $StopwatchMillisecondsForInterval += 65
            $StopwatchInterval = [TimeSpan]::FromMilliseconds($StopwatchMillisecondsForInterval)
            If (($Stopwatch.elapsed -ge $SMBHurryUpTimerMark) -and ($SMBHurryUpTimerMarkFlag -eq $False)) {
                If ($False -eq $NoSound) {$SMBOverworldRapidSoundPlayer.PlayLooping()}
                $SMBHurryUpTimerMarkFlag = $True
            }
        } Else {
            $StopwatchMillisecondsForInterval += 125
            $StopwatchInterval = [TimeSpan]::FromMilliseconds($StopwatchMillisecondsForInterval)
            If ($Stopwatch.elapsed -ge $RegularSpeedTime) {
                If ($False -eq $NoSound) {
                    $SMBOverWorldSoundPlayer.stop()
                    $SMBHurryUpSoundPlayer.play()
                    $SMBHurryUpTimerMark = $Stopwatch.elapsed + $SMBHurryUpTimerMarkInterval
                    $SMBHurryUpTimerMarkFlag = $False 
                }
                $LoopSpeedSwitch = $True
            }
        }
            
            #This makes the sleep time follow the actual stopwatch more closely instead of just a rote 125 milliseconds every time, which doesn't account for time bloat as a result of all the different commands.
        While ($Stopwatch.elapsed -lt $StopwatchInterval) {
            Start-Sleep -Milliseconds 5
        }
    }

    #Fanfare and blinking 00:00:00:00
    If ($False -eq $NoSound) {
        $SMBOverWorldSoundPlayer.stop()
        $SMBFanfareSoundPlayer.play()
    }
    Clear-Host
    $ClockOn = $False
    For ($i = 0; $i -lt 7; $i++) {
        If ([console]::KeyAvailable) {
            $Key = [system.console]::readkey($True)
            If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                #Everything that precedes the Return after a ctrl+c goes here.
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Clear-Host
                $Stopwatch.stop()
                If ($False -eq $NoSound) {
                    $SMBOverWorldSoundPlayer.stop()
                    $SMBFireworksSoundPlayer.stop()
                    $SMBFanfareSoundPlayer.stop()
                    $SMBHurryUpSoundPlayer.stop()
                    $SMBOverworldRapidSoundPlayer.stop()
                }
                Return
            }
        }
        Clear-Host
        If ($ClockOn -eq $True) {
            Write-Host $TitleContent -foregroundcolor "red"
            Write-Host $FWContentSpritesArray.asciicontent[0] -foregroundcolor "red"
            Write-Host $ClockContentFinale -foregroundcolor "darkyellow"
            $ClockOn = $False
        } Else {
            $ClockOn = $True
        }
        Start-Sleep -milliseconds 850
    }

    #Fireworks. $FWI is FireworksIndex.
    $FWI = 0
    for ($i = 0; $i -lt 25; $i++) {
        If ([console]::KeyAvailable) {
            $Key = [system.console]::readkey($True)
            If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                #Everything that precedes the Return after a ctrl+c goes here.
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Clear-Host
                $Stopwatch.stop()
                If ($False -eq $NoSound) {
                    $SMBOverWorldSoundPlayer.stop()
                    $SMBFireworksSoundPlayer.stop()
                    $SMBFanfareSoundPlayer.stop()
                    $SMBHurryUpSoundPlayer.stop()
                    $SMBOverworldRapidSoundPlayer.stop()
                }
                Return
            }
        }
        Clear-Host 
        $i++
        If (($FWI -eq 1) -and ($False -eq $NoSound)){
            $SMBFireworksSoundPlayer.play()
        }
        Write-Host $TitleContent -foregroundcolor "red"
        Write-Host $FWContentSpritesArray.asciicontent[$FWI] -foregroundcolor "red"
        Write-Host $ClockContentFinale -foregroundcolor "darkyellow"
        If ($FWI -eq 3) {$FWI = 0} Else {$FWI++}
        Start-Sleep -Milliseconds 500
    }

    #Cleaning up before closing.
    [console]::TreatControlCAsInput = $False
    [console]::CursorVisible = $True
    $Stopwatch.stop()
    If ($False -eq $NoSound) {
        $SMBOverWorldSoundPlayer.stop()
        $SMBFireworksSoundPlayer.stop()
        $SMBFanfareSoundPlayer.stop()
        $SMBHurryUpSoundPlayer.stop()
        $SMBOverworldRapidSoundPlayer.stop()
    }
}