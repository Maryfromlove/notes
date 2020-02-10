$sb = {$d = "D:\Twy59sGthb\notes";$m = "Auto-Save"; Set-Location -path $d;git add . ;git commit -m $m;git push -u origin master;}
$when = New-JobTrigger -Once -At "0:02" -RepetitionInterval (New-TimeSpan -Minute 12) -RepetitionDuration ([TimeSpan]::MaxValue) ;  
Register-ScheduledJob -Name Git_autosave_notes -ScriptBlock $sb -Trigger $when;