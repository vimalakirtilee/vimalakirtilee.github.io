
/*
XiLock 2018-12-13
|-------------------|
|   ！！！注意！！！|
|   ！！！注意！！！|
|   ！！！注意！！！|
|-------------------|
1. 第一行不能加注释;
1. 注释的";"必须是英文条件下输入;
1. 必须是Unicode编码;
1. 采用Unix换行符(LF);
1. Notes: #==win !==Alt ^==Ctr +==shift
*/

;=========================================================================
#!m::Run www.molakirlee.tk
#!f::Run D:\Desktop\TaggieEverything\Taggie.html

;=========================================================================
;窗口置顶
#SPACE::  Winset, Alwaysontop, , A

;=========================================================================
;激活YoudaoDicMini。
#!d::WinActivate ahk_class YdMiniModeWndClassName

;=========================================================================
;运行、隐藏、激活Total Commander。因为隐藏后在“任务管理器 >> 应用程序”里面显示，所以可以用WinAcitve激活。
#!t::
	DetectHiddenWindows, on
	Path_TC := "C:\Program Files (x86)\Total Commander v9.21a.514.1_64bit\Totalcmd64.exe" ;设置路径
	Title_TC := "hk_class TTOTAL_CMD" ;设置Title，即别称
	IfWinNotExist %Title_TC%
		Run %Path_TC%
	Else
		IfWinNotActive %Title_TC%
		WinActivate
	Else
		WinMinimize
Return

;=========================================================================
;运行文件标签管理工具Taggie。
#!l::
	DetectHiddenWindows, on
	Path_Taggie := "D:\Desktop\TaggieEverything\taggie.exe" ;设置路径
	Title_Taggie := "ahk_exe taggie.exe" ;设置Title，即别称
	IfWinNotExist %Title_Taggie%
		Run %Path_Taggie%
	Else
		Process,Close,taggie.exe
Return

;=========================================================================
;运行、隐藏、激活Everything。
#!s::
	DetectHiddenWindows, on
	Path_Everything := "D:\Desktop\TaggieEverything\Everything.exe" ;设置路径
	Title_Everything := "ahk_class EVERYTHING" ;设置Title，即别称
	IfWinNotExist %Title_Everything%
		Run %Path_Everything%
	Else
		IfWinNotActive %Title_Everything%
		WinActivate
	Else
		WinClose ;关闭窗口
Return

;=========================================================================
;运行、隐藏、激活WeChat。因为隐藏后在“任务管理器 >> 应用程序”里面不显示，所以只能用Run而非WinAcitve激活。
;通过%%调用变量
#!w::
	DetectHiddenWindows, on ;可识别隐藏窗口
	Path_WeChat := "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe" ;设置路径
	Title_Wechat := "ahk_exe WeChat.exe" ;设置Title，即别称
	IfWinNotExist %Title_Wechat% ;检查文件是否打开
		Run %Path_WeChat% ;运行程序
	Else
		IfWinNotActive %Title_Wechat% ;检查文件窗口是否激活
		;WinActivate ;激活窗口
		Run %Path_WeChat% ;运行程序
		Else
		WinClose ;关闭窗口
Return

;=========================================================================
;运行、隐藏、激活FileGee.exe。因为隐藏后在“任务管理器 >> 应用程序”里面不显示，所以只能用Run而非WinAcitve激活。
;通过%%调用变量
#!g::
	DetectHiddenWindows, on ;可识别隐藏窗口
	Path_FileGee := "C:\Program Files (x86)\Filegee10.1Green.v\FileGeePersonal\FileGee.exe" ;设置路径
	Title_Filegee := "ahk_exe FileGee.exe"
	IfWinNotExist %Title_Filegee% ;检查文件是否打开
		Run %Path_FileGee% ;运行程序
	Else
		IfWinNotActive %Title_Filegee% ;检查文件窗口是否激活
		;WinActivate ;激活窗口
		Run %Path_FileGee% ;运行程序
		Else
		WinClose ;关闭窗口
Return

;=========================================================================
;运行、隐藏、激活Outlook.exe。因为隐藏后在“任务管理器 >> 应用程序”里面不显示，所以只能用Run而非WinAcitve激活。
;通过%%调用变量
#!e::
	DetectHiddenWindows, on ;可识别隐藏窗口
	Path_Outlook := "C:\Program Files\Microsoft Office\Office15\OUTLOOK.exe" ;设置路径
	Title_Outlook := "ahk_exe OUTLOOK.exe"
	IfWinNotExist %Title_Outlook% ;检查文件是否打开
		Run %Path_Outlook% ;运行程序
	Else
		IfWinNotActive %Title_Outlook% ;检查文件窗口是否激活
		;WinActivate ;激活窗口
		Run %Path_Outlook% ;运行程序
		Else
		;WinClose ;关闭窗口
		WinMinimize ;最小化窗口
Return

;=========================================================================
;一鍵打開、激活、或隱藏Chrome，請先設置Path_Browser,請先設置Path_Browser，必须是源文件路径。
#!c::
Path_Browser := "C:\Users\Administrator\AppData\Local\Google\Chrome\Application\chrome.exe"
;hyf_winActiveOrOpen("Ahk_class Chrome_WidgetWin_1", Path_Browser, 1, "Max") ; {{{2
hyf_winActiveOrOpen("ahk_exe chrome.exe", Path_Browser, 1, "Max") ; {{{2
Return

hyf_winActiveOrOpen(title, path, m := 0, size := "", args := "") ;激活title的窗口，如不存在則打開path   {{{3
{ ;像火狐和chrome的多線程，要提取主進程ID才能激活，請設置m=1，size為Run命令的窗口尺寸, args為path後面的參數
    Static Arr_MainID := {} ;記錄ID的值
    DetectHiddenWindows, On
    SplitPath, path, exeName, , ext
    If size
        size .= " UseErrorLevel"
    If ((ext = "CHM") && !WinExist(title)) || ((ext != "CHM") && !hyf_winExist(exeName)) ;用這個會導致chm文檔判斷錯誤
    {
        Run, %path% %args%, , %size%
        hyf_tooltipAndRemoveOrExit("啟動中，請稍等...")
        WinWaitActive %title%
    }
    Else IfWinActive %title%
    {
        If (m = 1)
        {
            WinGet, ID_A, ID, A
            If (Arr_MainID[exeName] != ID_A)
                Arr_MainID[exeName] := ID_A
        }
        If (exeName = "chrome.exe")
            WinMinimize
        WinHide
        MouseGetPos, , , ID_A
        WinActivate Ahk_id %ID_A%
    }
    Else
    {
        If (m = 1)
        {
            If !(d := Arr_MainID[exeName]) || !WinExist("Ahk_id " . d) ;d不存在或窗口被關閉，則重新獲取
            {
                Arr_MainID[exeName] := d := hyf_getMainIDOfProcess(title) ;寫入數組，下次不用重新獲取
                If !d
                    hyf_msgBox("沒找到進程" . exeName . "激活的窗口，請檢查腳本", , 1)
                WinGetTitle, Title_A, Ahk_id %d%
            }
            Else
                WinGetTitle, Title_A, Ahk_id %d%
            ;hyf_tooltipAndRemoveOrExit("獲取數組數據" . exeName . "`n標題：" . Title_A . "`nAhk_id " . d, 3)
            WinShow Ahk_id %d%
            WinActivate Ahk_id %d%
            ;hyf_processCloseWhenNotActive(exeName)
        }
        Else
        {
            WinShow %title%
            WinActivate %title%
        }
        If InStr(size, "Max")
            WinMaximize
    }
}

hyf_winExist(n) ;判斷進程是否存在（返回PID）   {{{3
{ ;n為進程名
    Process, Exist, %n% ;比IfWinExist可靠
    Return ErrorLevel
}

hyf_tooltipAndRemoveOrExit(str, t := 1, ExitScript := 0, x := "", y := "")  ;提示t秒並自動消失   {{{3
{
    t *= 1000
    ToolTip, %str%, %x%, %y%
    SetTimer, hyf_removeToolTip, -%t%
    If ExitScript
    {
        Gui, Destroy
        Exit
    }
}

hyf_getMainIDOfProcess(Win) ;獲取類似chrome等多進程的主進程ID {{{3
{ ;Win為完整類名, v為判斷的值，tp為v的類型
    DetectHiddenWindows, On
    If InStr(Win, "Ahk_class")
        RegExMatch(Win, "i)Ahk_class\s\S+", WinTitle)
    Else If InStr(Win, "Ahk_exe")
        RegExMatch(Win, "i)Ahk_exe\s\S+", WinTitle)
    If !(Win ~= "i)^ahk_")
        RegExMatch(Win, "i)\S+", TitleMatch)
    WinGet, Arr, List, %WinTitle%
    ;str := ",Default IME,MSCTFIME UI,關閉標籤頁,nsAppShell:EventWindow" ;排除標題列表 todo 待完善
    Loop,% Arr
    {
        n := Arr%A_Index%
        ;If (hyf_winGet("MinMax", "Ahk_id " . n) = 0) ;跳過不是最大化也不是最小化的
        WinGetTitle, TitleLoop, Ahk_id %n%
        If (TitleLoop = "") || (TitleMatch && (TitleLoop != TitleMatch))
            Continue
        Return n
    }
    Return 0
}

hyf_msgBox(str, o := 262144, ExitScript := 0, TimeOut := "", title := "")  ;彈窗  {{{3
;o:4為是否，3為是/否/取消，256/512設置第2/3按鈕為默認, 262144為置頂（默認）
{
    MsgBox,% o, %title%, %str%, %TimeOut%
    If (ExitScript = 1)
    {
        Gui, Destroy
        Exit
    }
    Else If (ExitScript = 2)
        ExitApp
}

hyf_processCloseWhenNotActive(n := "chrome.exe") ;窗口激活失敗則關閉進程  {{{3
{
    WinWaitActive, Ahk_exe %n%, , 1 ;激活失敗
    If ErrorLevel ;激活失敗
    {
        hyf_msgBox("窗口激活失敗，是否結束所有進程", 4)
        IfMsgBox No
            Return
        Loop
        {
            Process, Close, %n%
            Sleep, 200
        }
        Until (ErrorLevel = 0)
        Run, %Path_Browser%, , Max
        hyf_tooltipAndRemoveOrExit("軟件重啟中...", 2)
    }
}

hyf_removeToolTip() ;清除ToolTip {{{2
{
    ToolTip
}

hyf_winGet(cmd := "title", WinTitle := "A") ;不支持Pos等多變量輸出命令  {{{3
{
    If (cmd = "title")
        WinGetTitle, v, %WinTitle%
    Else If (cmd = "Class")
        WinGetClass, v, %WinTitle%
    Else If (cmd = "Text")
        WinGetText, v, %WinTitle%
    Else
        WinGet, v, %cmd%, %WinTitle%
    Return v
}

;=========================================================================
;一鍵打開、激活、或隱藏Chrome_VPN，請先設置Path_Browser，必须是源文件路径。此处调用了上面Chrome中的函数。
;记得将VPN版的Chrome重命名为Chrome_VPN。
#!x::
Path_Browser := "C:\Program Files (x86)\Chromium-70.0.3538.9\chrome_VPN.exe"
;hyf_winActiveOrOpen("Ahk_class Chrome_WidgetWin_1", Path_Browser, 1, "Max") ; {{{2
hyf_winActiveOrOpen("ahk_exe chrome_VPN.exe", Path_Browser, 1, "Max") ; {{{2
Return

;=========================================================================
;用键盘控制鼠标
;1.短距离移动鼠标
*#^k::MouseMove, 0, -10, 0, R  ; Win+UpArrow 热键 => 上移光标
*#^j::MouseMove, 0, 10, 0, R  ; Win+DownArrow => 下移光标
*#^h::MouseMove, -10, 0, 0, R  ; Win+LeftArrow => 左移光标
*#^l::MouseMove, 10, 0, 0, R  ; Win+RightArrow => 右移光标
;2.长距离移动鼠标
*#!k::MouseMove, 0, -50, 0, R  ; Win+UpArrow 热键 => 上移光标
*#!j::MouseMove, 0, 50, 0, R  ; Win+DownArrow => 下移光标
*#!h::MouseMove, -50, 0, 0, R  ; Win+LeftArrow => 左移光标
*#!l::MouseMove, 50, 0, 0, R  ; Win+RightArrow => 右移光标
;3.左右键控制
*<#RCtrl::  ; LeftWin + RightControl => Left-click (按住 Control/Shift 来进行 Control-Click 或 Shift-Click).
SendEvent {Blind}{LButton down}
KeyWait RCtrl  ; 防止键盘自动重复导致的重复鼠标点击.
SendEvent {Blind}{LButton up}
return

*<#AppsKey::  ; LeftWin + AppsKey => Right-click
SendEvent {Blind}{RButton down}
KeyWait AppsKey  ; 防止键盘自动重复导致重复的鼠标点击.
SendEvent {Blind}{RButton up}
return
;=========================================================================
;Others
;=========================================================================


