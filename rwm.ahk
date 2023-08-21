SendMode("input")
SetWorkingDir(A_ScriptDir)
#SingleInstance force
#NoTrayIcon

; SET ICON
icon := A_ScriptDir . "\icons\icon.ico"
if FileExist(icon)
{
    TraySetIcon(icon)
}

; RUN AS ADMINISTRATOR
if (!A_IsAdmin){
    {
        ErrorLevel := "ERROR"
        Try ErrorLevel := Run("*RunAs `"" A_ScriptFullPath "`"", , "", )
    }
    ExitApp()
}

; OPTIONS
SetWinDelay(2)
CoordMode("Mouse")
A_HotkeyInterval := 0

; FUNCTIONS
ShellRun(Prms*)
{
    ShellWindows := ComObject("Shell.Application").Windows
    Desktop := ShellWindows.FindWindowSW(0, 0, 8, 0, 1)

    TLB := ComObjQuery(Desktop, "{4C96BE40-915C-11CF-99D3-00AA004AE837}", "{000214E2-0000-0000-C000-000000000046}")

    ComCall(15, TLB, "ptr*", SV := ComValue(13, 0))
    NumPut("int64", 0x20400, "int64", 0x46000000000000C0, IID_IDispatch := Buffer(16))
    ComCall(15, SV, "uint", 0, "ptr", IID_IDispatch, "ptr*", SFVD := ComValue(9, 0))

    Shell := SFVD.Application
    Shell.ShellExecute(Prms*)
}

; WINDOW MANAGER ACTIONS
#LButton::
{
    MouseGetPos(&Window_X1, &Window_Y1, &Window_id)
    Window_Win := WinGetMinMax("ahk_id " Window_id)

    if !Window_Win
    {
        WinGetPos(&Window_WinX1, &Window_WinY1, , , "ahk_id " Window_id)

        Loop
        {
            Window_Button := GetKeyState("LButton", "P") ? "D" : "U"

            if (Window_Button = "U")
                break

            MouseGetPos(&Window_X2, &Window_Y2)
            Window_X2 -= Window_X1
            Window_Y2 -= Window_Y1
            Window_WinX2 := (Window_WinX1 + Window_X2)
            Window_WinY2 := (Window_WinY1 + Window_Y2)
            WinMove(Window_WinX2, Window_WinY2, , , "ahk_id " Window_id)
        }
    }
}

#RButton::
{
    MouseGetPos(&Window_X1, &Window_Y1, &Window_id)
    Window_Win := WinGetMinMax("ahk_id " Window_id)

    if !Window_Win
    {
        WinGetPos(&Window_WinX1, &Window_WinY1, &Window_WinW, &Window_WinH, "ahk_id " Window_id)

        if (Window_X1 < Window_WinX1 + Window_WinW / 2)
            Window_WinLeft := 1
        else
            Window_WinLeft := -1

        if (Window_Y1 < Window_WinY1 + Window_WinH / 2)
            Window_WinUp := 1
        else
            Window_WinUp := -1

        Loop
        {
            Window_Button := GetKeyState("RButton", "P") ? "D" : "U"

            if (Window_Button = "U")
                break

            MouseGetPos(&Window_X2, &Window_Y2)
            WinGetPos(&Window_WinX1, &Window_WinY1, &Window_WinW, &Window_WinH, "ahk_id " Window_id)
            Window_X2 -= Window_X1
            Window_Y2 -= Window_Y1
            WinMove(Window_WinX1 + (Window_WinLeft+1)/2*Window_X2, Window_WinY1 +   (Window_WinUp+1)/2*Window_Y2, Window_WinW  -     Window_WinLeft  *Window_X2, Window_WinH  -       Window_WinUp  *Window_Y2, "ahk_id " Window_id)
            Window_X1 := (Window_X2 + Window_X1)
            Window_Y1 := (Window_Y2 + Window_Y1)
        }
    }
}

; INCLUDE USER CONFIGURATION
#Include "rwm.config"
