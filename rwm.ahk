#noenv
sendmode input
setwindelay, 2
coordmode, mouse
setworkingdir %a_scriptdir%
#singleinstance, force
#notrayicon

; Set Icon
icon := a_scriptdir . "\icons\icon.ico"
if fileexist(icon)
{
    menu, tray, icon, %icon%
}

; Run As Administrator
if (!a_isadmin)
{
    run *runas "%a_scriptfullpath%", , useerrorlevel
    exitapp
}

; Disable Error
ComObjError(false)

; Functions
shellrun(prms*)
{
    shellwindows := comobjcreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")
    desktop := shellwindows.item(comobj(19, 8))
    if ptlb := comobjquery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"
        , "{000214E2-0000-0000-C000-000000000046}")
    {
        if dllcall(numget(numget(ptlb+0)+15*a_ptrsize), "ptr", ptlb, "ptr*", psv:=0) = 0
        {
            varsetcapacity(iid_idispatch, 16)
            numput(0x46000000000000c0, numput(0x20400, iid_idispatch, "int64"), "int64")
            dllcall(numget(numget(psv+0)+15*a_ptrsize), "ptr", psv, "uint", 0, "ptr", &iid_idispatch, "ptr*", pdisp:=0)
            shell := comobj(9, pdisp, 1).application
            shell.shellexecute(prms*)
            objrelease(psv)
        }
        objrelease(ptlb)
    }
}

; Include User Configuration
#include %a_scriptdir%\rwm.config

; Window Manager Actions
#lbutton::
if doublealt
{
    mousegetpos, , , window_id
    postmessage, 0x112, 0xf020, , , ahk_id %window_id%
    doublealt := false
    return
}
mousegetpos, window_x1, window_y1, window_id
winget, window_win, minmax, ahk_id %window_id%
if window_win
    winrestore, a
wingetpos, window_winx1, window_winy1, , , ahk_id %window_id%
loop
{
    getkeystate, window_button, lbutton, p
    if window_button = u
        break
    mousegetpos, window_x2, window_y2
    window_x2 -= window_x1
    window_y2 -= window_y1
    window_winx2 := (window_winx1 + window_x2)
    window_winy2 := (window_winy1 + window_y2)
    winmove, ahk_id %window_id%, , %window_winx2%, %window_winy2%
}
return
wingetpos, window_winx1, window_winy1, , , ahk_id %window_id%
loop
{
    getkeystate, window_button, lbutton, p
    if window_button = u
        break
    mousegetpos, window_x2, window_y2
    window_x2 -= window_x1
    window_y2 -= window_y1
    window_winx2 := (window_winx1 + window_x2)
    window_winy2 := (window_winy1 + window_y2)
    winmove, ahk_id %window_id%, , %window_winx2%, %window_winy2%
}
return

#rbutton::
if doublealt
{
    mousegetpos, , , window_id
    winget, window_win, minmax, ahk_id %window_id%
    if window_win
        winrestore, ahk_id %window_id%
    else
        winmaximize, ahk_id %window_id%
    doublealt := false
    return
}
mousegetpos, window_x1, window_y1, window_id
winget, window_win, minmax, ahk_id %window_id%
if window_win
    winrestore, a
wingetpos, window_winx1, window_winy1, window_winw, window_winh, ahk_id %window_id%
if (window_x1 < window_winx1 + window_winw / 2)
    window_winleft := 1
else
    window_winleft := -1
if (window_y1 < window_winy1 + window_winh / 2)
    window_winup := 1
else
    window_winup := -1
loop
{
    getkeystate, window_button, rbutton, p
    if window_button = u
        break
    mousegetpos, window_x2, window_y2
    wingetpos, window_winx1, window_winy1, window_winw, window_winh, ahk_id %window_id%
    window_x2 -= window_x1
    window_y2 -= window_y1
    winmove, ahk_id %window_id%, , window_winx1 + (window_winleft+1)/2*window_x2
    , window_winy1 +   (window_winup+1)/2*window_y2
    , window_winw  -     window_winleft  *window_x2
    , window_winh  -       window_winup  *window_y2
    window_x1 := (window_x2 + window_x1)
    window_y1 := (window_y2 + window_y1)
}
return
wingetpos, window_winx1, window_winy1, window_winw, window_winh, ahk_id %window_id%
if (window_x1 < window_winx1 + window_winw / 2)
    window_winleft := 1
else
    window_winleft := -1
if (window_y1 < window_winy1 + window_winh / 2)
    window_winup := 1
else
    window_winup := -1
loop
{
    getkeystate, window_button, rbutton, p
    if window_button = u
        break
    mousegetpos, window_x2, window_y2
    wingetpos, window_winx1, window_winy1, window_winw, window_winh, ahk_id %window_id%
    window_x2 -= window_x1
    window_y2 -= window_y1
    winmove, ahk_id %window_id%, , window_winx1 + (window_winleft+1)/2*window_x2
    , window_winy1 +   (window_winup+1)/2*window_y2
    , window_winw  -     window_winleft  *window_x2
    , window_winh  -       window_winup  *window_y2
    window_x1 := (window_x2 + window_x1)
    window_y1 := (window_y2 + window_y1)
}
return
