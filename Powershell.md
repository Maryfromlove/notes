# Powershell 实战：定时任务

> 暂时有效——`2020/02/10`

## 背景

我在win10系统本地布置了一个笔记路径，并且不定期push同步到github。

想要一个脚本能帮我实现定时“自动保存”的功能。

## 安装

打开powershell执行以下脚本：

```powershell
$action = {
	Set-Location -path "D:\Twy59sGthb\notes";    
	git add .                       ;    
	git commit -m "ps auto-save"    ;    
	git push -u origin master;}
$when = New-JobTrigger -Once -At "16:20" -RepetitionInterval (New-TimeSpan -Minute 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name Git_autosave_notes -ScriptBlock $action -Trigger $when
$t = Get-ScheduledJob -Name Git_autosave_notes
$t | Enable-ScheduledJob
```

```
-NoLogo -NonInteractive -WindowStyle Hidden -Command "Import-Module PSScheduledJob; $jobDef = [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]::LoadFromStore('Git_autosave_notes', 'C:\Users\tieway59\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs'); $jobDef.Run()"
```



## 卸载

1. 运行`taskschd.msc` 在根目录下找到目标任务，删除即可。
2. 命令行执行`Unregister-ScheduledTask  -TaskName Git_autosave_notes`

## 参考

[PSScheduledJob](https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/?view=powershell-5.1)

[PowerShell 计划工作（ScheduledJob）](https://www.pstips.net/about-scheduledjob.html)

[Powershell v3 New-JobTrigger daily with repetition](https://stackoverflow.com/questions/12768769/powershell-v3-new-jobtrigger-daily-with-repetition)