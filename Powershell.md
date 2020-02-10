# Powershell 实战：定时任务

> 但到目前为止都还没生效。

## 背景

我在win10系统本地布置了一个笔记路径，并且不定期push同步到github

想要一个脚本能帮我实现一个定时“自动保存”的功能。

## 安装

src: [Powershell v3 New-JobTrigger daily with repetition](https://stackoverflow.com/questions/12768769/powershell-v3-new-jobtrigger-daily-with-repetition)

```powershell
#$principal = New-ScheduledTaskPrincipal -UserID MyDomain\MyGMSA$ -LogonType Password -RunLevel Highest
$action = {
	Set-Location -path "D:\Twy59sGthb\notes";    
	git add .                       ;    
	git commit -m "ps auto-save"    ;    
	git push -u origin master;}
$when = New-JobTrigger -Daily -At "15:28" -DaysInterval 1
Register-ScheduledJob -Name Git_autosave_notes -ScriptBlock $action -Trigger $when
$t = Get-ScheduledJob -Name Git_autosave_notes
#$t.Triggers.repetition.Interval = "PT5M"    	# every 15 mins
#$t.Triggers.repetition.Duration = "PT7H30M" 	# for 7 hours 30
$t | Enable-ScheduledJob
```

```
-NoLogo -NonInteractive -WindowStyle Hidden -Command "Import-Module PSScheduledJob; $jobDef = [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]::LoadFromStore('Git_autosave_notes', 'C:\Users\tieway59\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs'); $jobDef.Run()"
```



## 卸载

1. 运行`taskschd.msc` 在根目录下找到目标任务，删除即可。
2. 命令行执行`Unregister-ScheduledTask  -TaskName Git_autosave_notes`