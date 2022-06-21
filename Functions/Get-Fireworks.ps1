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
Function Get-Fireworks {
    <#
    I probably need to size the PS window before it plays to make sure it's not all jumpy. Then I can resize it to whatever it was afterward in case it's bigger than the user's screen. Or perhaps I can just check the user's screen and throw an error if it's not big enough.
    Get a better fireworks sound.
    The animation seems to need some cleanup as well.
    And this could always be "Get-Animation" instead and have different options to play.

    This doesn't seem to work for Windows Terminal. Terminal also has a much smaller buffer than both PS and WPS. Could I check to see if this is Windows Terminal and then just alter its JSON or something?

    $PSHost = Get-Host
    $PSWindow = $PSHost.ui.rawui
    $OldSize = $PSWindow
    $NewSize = $PSWindow.buffersize
    $NewSize.height = 48
    $NewSize.width = 200
    $PSWindow.buffersize = $NewSize
    $NewSize = $PSWindow.windowsize
    $NewSize.height = 48
    $NewSize.width = 200
    $PSWindow.windowsize = $NewSize


    Then to return it to its original size before the Break.

    $PSWindow.buffersize = $OldSize.buffersize
    $PSWindow.windowsize = $OldSize.windowsize
    #>

    #The curser flashes on non-animation lines and is distracting.
    [console]::CursorVisible = $False
    Clear-Host

    #Initializing paths.
    $VersionPath = (Get-Module "PowershellAnimations").ModuleBase
    $FireworksPath = $VersionPath + '\media\FireworksASCIIAnimationFormatted.txt'
    $FireworksSoundPath = $VersionPath + '\media\smbfireworks.wav'
    If ($Null -eq $VersionPath) {
        Throw "You don't seem to be running this function from the AToolbox module. It's only designed for that context."
    }
    If ((!(Test-Path -pathtype leaf -literalpath $FireworksPath)) -or (!(Test-Path -pathtype leaf -literalpath $FireworksSoundPath))) {
        Throw "You don't seem to have the media files in the right location. They should be in the (module root directory)\(version)\media\ folder."
    }

    #Initializing content for the non-Start-Process way. 
    $FireworksContent = Get-Content $FireworksPath -Delimiter '<del>'
    $PlaySound = New-Object System.Media.SoundPlayer
    $PlaySound.SoundLocation = $FireworksSoundPath
    $I = -1
    $FGC = @('DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White') | Get-Random

    <# This works for opening a new window, but it's super choppy. Using -command instead of -encodedcommand doesn't work because the command is too long. But I think it's -encodedcommand that makes it so choppy. Could I just do -command and use a variable for all the stuff I need to send? 
    
    $Command = "`$FireworksContent = Get-Content `"$FireworksPath`" -Delimiter '<del>'; `$PlaySound = New-Object System.Media.SoundPlayer; `$PlaySound.SoundLocation = `"$FireworksSoundPath`"; `$I = -1; `$FGC = @('DarkBlue','DarkGreen','DarkCyan','DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White') | Get-Random; `$PSHost = Get-Host; `$PSHost.ui.rawui.backgroundcolor = 'Black'; Clear-Host; [console]::TreatControlCAsInput = `$True; While (`$True) {If ([console]::KeyAvailable) {`$Key = [system.console]::readkey(`$True); If ((`$Key.modifiers -band [consolemodifiers]'control') -and (`$Key.key -eq 'C')) {[console]::TreatControlCAsInput = `$False; [console]::CursorVisible = `$True; Break}} If (`$I -eq (`$FireworksContent.count - 1)) {`$I = 0} Else {`$I++} If (`$I -eq 19) {`$PlaySound.play()} Write-Host `$FireworksContent[`$I] -NoNewline -ForegroundColor `$FGC; Start-Sleep -Milliseconds 125; Clear-Host}"
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Command)
    $EncodedCommand = [Convert]::ToBase64String($Bytes)
    Start-Process powershell.exe -argumentlist "-noexit","-encodedCommand $EncodedCommand"
    #>

    #Making it so that if you hit ctrl+c, the script does a couple things before stopping. I'm basically disabling the standard ctrl+c functionality and then just capturing those keys and responding with the things I want to and a Break. Notice that the animation is nested within this, and While ($True) runs infinitely.
    [console]::TreatControlCAsInput = $True
    While ($True) { 
        If ([console]::KeyAvailable) {
            $Key = [system.console]::readkey($True)
            If (($Key.modifiers -band [consolemodifiers]"control") -and ($Key.key -eq "C")) {
                [console]::TreatControlCAsInput = $False
                [console]::CursorVisible = $True
                Break
            }
        }

        #Cycling/recycling the animation when it reaches its end and playing the fireworks sound at slide 20. 
        If ($I -eq ($FireworksContent.count - 1)) {$I = 0} Else {$I++}
        If ($I -eq 19) {$PlaySound.play()}
        Write-Host $FireworksContent[$I] -NoNewline -ForegroundColor $FGC
        Start-Sleep -Milliseconds 125
        Clear-Host
    }
}