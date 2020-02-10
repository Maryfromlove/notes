$sb = {Set-Location -path "D:\Twy59sGthb\notes";git add . ;git commit -m "Auto-Save";git push -u origin master;};
$when = New-JobTrigger -Once -At "0:02" -RepetitionInterval (New-TimeSpan -Minute 12) -RepetitionDuration ([TimeSpan]::MaxValue); 
Register-ScheduledJob -Name Git_autosave_notes -ScriptBlock $sb -Trigger $when; 