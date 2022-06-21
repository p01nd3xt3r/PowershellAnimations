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
Function Start-Reminder {
    Param (
        [parameter()][int]$Minutes = 2,
        [parameter()][string]$SoundPath = "C:\Windows\Media\chord.wav"
    )

    $ReminderSeconds = $Minutes * 60
    $ReminderSoundPlayer = New-Object System.Media.SoundPlayer
    $ReminderSoundPlayer.SoundLocation = $SoundPath
    $PSStyle.Progress.Style = "`e[104;1m"

    While ($True) {
        For ($I = 1; $I -le $ReminderSeconds; $I++) {
            Write-Progress -activity "Next reminder in" -status "$($ReminderSeconds - $I) seconds" -PercentComplete ($I/$ReminderSeconds*100)
            Start-Sleep -seconds 1
        }
        $ReminderSoundPlayer.play()
    }
}