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
    #The cursor flashes on non-animation lines and is distracting.
    [console]::CursorVisible = $False
    Clear-Host

    #Initializing paths.
    $VersionPath = (Get-Module "PowershellAnimations").ModuleBase
    $FireworksPath = $VersionPath + '\media\FireworksASCIIAnimationFormatted.txt'
    $FireworksSoundPath = $VersionPath + '\media\smbfireworks.wav'
    If ($Null -eq $VersionPath) {
        Throw "You don't seem to be running this function from its module. It's only designed for that context."
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