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
        [parameter()][int]$Minutes = 15,
        [parameter()][string]$SoundPath = "C:\Windows\Media\chord.wav",
        [parameter()][string]$ProgressStyle = "`e[97;42m"
    )
    
    $ReminderSeconds = $Minutes * 60
    $ReminderSoundPlayer = New-Object System.Media.SoundPlayer
    $ReminderSoundPlayer.SoundLocation = $SoundPath
    $PSStyle.Progress.Style = $ProgressStyle
    $RemindersSoFar = 0

    While ($True) {
        $RemindersSoFar++
        For ($I = 1; $I -le $ReminderSeconds; $I++) {
            $ReminderStatus = ""
            $ReminderTimerspan = New-Timespan -seconds ($ReminderSeconds - $I)
            If ($ReminderTimerspan.Days -gt 0) {
                $ReminderStatus = [String]$ReminderTimerspan.Days + "d " | Join-String
            }
            If ($ReminderTimerspan.Hours -gt 0) {
                $ReminderStatus = $ReminderStatus + $ReminderTimerspan.Hours + "h " | Join-String
            }
            If ($ReminderTimerspan.Minutes -gt 0) {
                $ReminderStatus = $ReminderStatus + $ReminderTimerspan.Minutes + "m " | Join-String
            }
            $ReminderStatus = $ReminderStatus + $ReminderTimerspan.Seconds + "s" | Join-String

            If (($I/$ReminderSeconds*100) -lt 1) {
                $ReminderPercent = 1
            } Else {
                $ReminderPercent = ($I/$ReminderSeconds*100)
            }

            Write-Progress -Activity "Reminder #$RemindersSoFar in" -Status $ReminderStatus -PercentComplete $ReminderPercent
            Start-Sleep -seconds 1
        }
        $ReminderSoundPlayer.play()
    }
}