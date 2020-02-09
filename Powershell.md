# Powershell 实战：定时任务

## 背景

我在win10系统本地布置了一个笔记路径，并且不定期push同步到github

想要一个脚本能帮我实现一个定时“自动保存”的功能。=

## 安装

src: [Powershell v3 New-JobTrigger daily with repetition](https://stackoverflow.com/questions/12768769/powershell-v3-new-jobtrigger-daily-with-repetition)

```powershell
#$principal = New-ScheduledTaskPrincipal -UserID MyDomain\MyGMSA$ -LogonType Password -RunLevel Highest
$action = New-ScheduledTaskAction  {
	Set-Location D:\Twy59sGthb\notes,    
	git add .                       ,    
	git commit -m "ps auto-save"    ,    
	git push -u origin master}
$when = New-ScheduledTaskTrigger -Daily -At "12:02" -DaysInterval 1
Register-ScheduledTask -TaskName Git_autosave_notes -Action $action -Trigger $when
$t = Get-ScheduledTask -TaskName Git_autosave_notes
$t.Triggers.repetition.Interval = "PT15M"    	# every 15 mins
$t.Triggers.repetition.Duration = "PT11H30M" 	# for 11 hours 30
$t | Set-ScheduledTask
```

## 卸载

1. 运行`taskschd.msc` 在根目录下找到目标任务，删除即可。
2. 命令行执行`Unregister-ScheduledTask  -TaskName Git_autosave_notes`