# Powershell 实战：定时任务

>  `2020-02-10` 暂时有效
>
> 遇到了运行时问题，操作员或系统管理员拒绝了请求。就是电脑长时间待机的时候就无效了。
>
>  `2020-07-03` **UDP:** 谜之有效
>
> 惊了，我自己电脑的自动提交服务搭建以来原来一直起效，我说怎么之前commit的时候说all updated。但是这个奏效的实际时间非常模糊，我设定的是若干分钟检查一次的，但是具体运行的没有那么真实。
>
> 可能需要查询文档搞清楚具体的规则。（🕊）

## 背景

我在win10系统本地布置了一个笔记路径，并且不定期push同步到github。

想要一个脚本能帮我实现定时“自动保存”的功能。

## 环境

- Win10
- powershell 5.1

- 已初始化项目Git

## 注释

阅读以下注释，然后确定无误后按照`;`压行。

```powershell
$sb = {                                                     #设置代码块（自行修改）
    Set-Location -path "D:\Twy59sGthb\notes"            ;   #设置你的路径
    git add .                                           ;    
    git commit -m "Auto-Save"                           ;   #设置commit信息
    git push -u origin master                           ;   
}                                                       ;
$when = New-JobTrigger -Once -At "0:02"                     #设置开始时刻
        -RepetitionInterval (New-TimeSpan -Minute 12)       #设置重复间隔（12分钟）
        -RepetitionDuration ([TimeSpan]::MaxValue)      ;   #设置重复时长（无限）
Register-ScheduledJob -Name Git_autosave_notes              #设置定时任务的名称
        -ScriptBlock $sb -Trigger $when                 ;   #绑定代码块和触发器
```

其他：

```powershell
$t = Get-ScheduledJob -Name Git_autosave_notes              #获取任务
$t | Enable-ScheduledJob                                    #启用任务
$t | Disable-ScheduledJob                                   #禁用任务
```

## 安装

以管理员身份`Win+X+A`打开powershell执行压行以后的脚本：

```powershell
$sb = {Set-Location -path "D:\Twy59sGthb\notes";git add . ;git commit -m "Auto-Save";git push -u origin master;};
$when = New-JobTrigger -Once -At "0:02" -RepetitionInterval (New-TimeSpan -Minute 12) -RepetitionDuration ([TimeSpan]::MaxValue); 
Register-ScheduledJob -Name Git_autosave_notes -ScriptBlock $sb -Trigger $when; 
```

## 检查

运行`taskschd.msc` 在`\Microsoft\Windows\PowerShell\ScheduledJobs`目录下查看任务信息。

注意你创建的job的日志和状态默认会以xml形式存在以下目录中：

`C:\Users\...\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs`

如果没有生效可以在这个路径找到报错信息。

然后就是检查git和github是不是出现了有效push。

## 卸载

下面两种方法都可以：

- 运行`taskschd.msc` 在`\Microsoft\Windows\PowerShell\ScheduledJobs`目录下找到目标任务，删除即可。
- 用命令行执行`Unregister-ScheduledTask -TaskName Git_autosave_notes`也可以执行`Unregister-ScheduledJob -Name Git_autosave_notes`但是前者更好一些。

## 参考

[PSScheduledJob](https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/?view=powershell-5.1)【官方手册】

[PowerShell 计划工作（ScheduledJob）](https://www.pstips.net/about-scheduledjob.html)

[Powershell v3 New-JobTrigger daily with repetition](https://stackoverflow.com/questions/12768769/powershell-v3-new-jobtrigger-daily-with-repetition)

## 体会

主要还是对ps的语法障碍比较大，“-Xxx value”这样形式的传参是不能直接乱写变量上去的（可能）。

还有ScriptBlock中的脚本最好一句话用分号隔开，一开始我用了逗号错了。跟在CLI输入的情况是有点不一样的。