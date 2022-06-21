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
Function Start-Timer {
    param (
        [Parameter()][string]$Time = 10
    )
    [console]::CursorVisible = $False

    $VersionPath = (Get-Module "AToolbox").ModuleBase
    If ($Null -eq $VersionPath) {
        Throw "You don't seem to be running this function from the AToolbox module. It's only designed for that context."
    }
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
    
    $Seconds = $Time #Temporary
    $TotalTime = New-Timespan -seconds $Seconds #For later -hours $Hours -minutes $Minutes 
    $OneSecondAdjustment = New-TimeSpan -Seconds 1 #This is used later in the loop.
    $Stopwatch = New-Object -TypeName System.Diagnostics.Stopwatch
    $StopwatchMillisecondsForInterval = 125
    #Alternate way to do New-Timespan, since that cmdlet doesn't have a -milliseconds parameter.
    $StopwatchInterval = [TimeSpan]::FromMilliseconds($StopwatchMillisecondsForInterval)
    [console]::TreatControlCAsInput = $True

    $Stopwatch.start()
    While ($Stopwatch.elapsed -lt $TotalTime) {
        If ([console]::KeyAvailable) {
            $Key = [system.console]::readkey($True)
            If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                #Everything that precedes the break after a ctrl+c goes here.
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Clear-Host
                $Stopwatch.stop()
                Break
            }
        }

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
        Clear-Host
        Write-Host $ASCIICountdown
        $RowedCharactersArray.clear()
        
        #This is supposed to make the sleep time follow the actual stopwatch more closely instead of just a rote 125 milliseconds every time, which doesn't account for time bloat as a result of all the different commands.
        While ($Stopwatch.elapsed -lt $StopwatchInterval) {
            Start-Sleep -Milliseconds 5
        }
        $StopwatchMillisecondsForInterval = $StopwatchMillisecondsForInterval + 125
        $StopwatchInterval = [TimeSpan]::FromMilliseconds($StopwatchMillisecondsForInterval)
    }
    Clear-Host
    Write-Host $ClockContentFinale

    [console]::TreatControlCAsInput = $False
    [console]::CursorVisible = $True
    $Stopwatch.stop()
}


