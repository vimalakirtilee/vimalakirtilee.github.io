
;第一行不能加注释，注释的;必须是英文条件下输入
;UTF-8编码，Unix换行符(LF)
;Notes: #==win !==Alt ^==Ctr +==shift
;XiLock 2018-12-13
;=========================================================================
#!m::Run www.molakirlee.tk
;=========================================================================
;窗口置顶
#SPACE::  Winset, Alwaysontop, , A
;=========================================================================
#!t::
	DetectHiddenWindows, on
	IfWinNotExist ahk_class TTOTAL_CMD
		Run G:\TotalCommanderB\Total Commander v9.21a.514.1_32bit\Totalcmd.exe
	Else
		IfWinNotActive ahk_class TTOTAL_CMD
		WinActivate
	Else
		WinMinimize
Return
;=========================================================================
;运行、隐藏、激活FileGee.exe。可能是因为个人版不支持后台运行，所以WinActivate不能激活，故此处用Run重新打开的方式来激活。
#!g::
	DetectHiddenWindows, on ;可识别隐藏窗口
	Path_Browser_FileGee := "C:\Program Files (x86)\Filegee10.1Green.v\FileGeePersonal\FileGee.exe" ;设置路径
	IfWinNotExist ahk_exe FileGee.exe ;检查文件是否打开
		Run %Path_Browser_FileGee% ;运行程序
	Else
		IfWinNotActive ahk_exe FileGee.exe ;检查文件窗口是否激活
		;WinActivate ;激活窗口
		Run %Path_Browser_FileGee% ;运行程序
		Else
		WinClose ;关闭窗口
Return
;=========================================================================
;一鍵打開、激活、或隱藏Chrome，請先設置Path_Browser
#!c::
Path_Browser := "C:\Users\Administrator\AppData\Local\Google\Chrome\Application\chrome.exe"
hyf_winActiveOrOpen("Ahk_class Chrome_WidgetWin_1", Path_Browser, 1, "Max") ; {{{2
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
;Others
;=========================================================================


