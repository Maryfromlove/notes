$sb = {                                                     #设置代码块（自行修改）
    Set-Location -path "D:\Twy59sGthb\notes"            ;   #设置你的路径
    git add .                                           ;    
    git commit -m "Auto-Save"                           ;   #设置commit信息
    git push -u origin master                           ;   
}                                                       ;
$when = New-JobTrigger -Once -At "0:02"                     #设置开始时刻
        -RepetitionInterval (New-TimeSpan -Minute 12)       #设置重复间隔
        -RepetitionDuration ([TimeSpan]::MaxValue)      ;   #设置重复时长（无限）
Register-ScheduledJob -Name Git_autosave_notes              #设置定时任务的名称
        -ScriptBlock $sb -Trigger $when                 ;   #绑定代码块和触发器