
 
#NoEnv
;warn
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 5
#MaxThreadsPerHotkey, 99000000
ListLines Off
Process, Priority, , A_Script
SetBatchLines, -1
SetKeyDelay, 0, 50
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
coordmode, mouse
settitlematchmode 2
winset, transcolor, off, - IMVU
winset, alwaysontop, off,  - IMVU
WinSet, Exstyle, -0x20, - IMVU
WinSet, Style, +0x040000,- IMVU ; WS_THICKFRAME
WinSet, Style, +0x400000,- IMVU ; WS_DLGFRAME
WinSet, Region,, - IMVU
dwin := winexist("A")
enb := 0

active := 0
overlay := 0
settimer, activecheck, 10

; Register shell hook to detect flashing windows.
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), "ShellEvent")

OnExit handle_exit

return


activecheck:
if overlay = 1
{
if winactive("- IMVU")
{
if active = 1
{
}
else
{

active := 1
winset, transcolor, off, ahk_class ImvuNativeWindow
winset, alwaysontop, off,  ahk_class ImvuNativeWindow
WinSet, Exstyle, -0x20, ahk_class ImvuNativeWindow
winset, transcolor, 111111 200, ahk_class ImvuNativeWindow
winset, transparent, 1,- IMVU
WinMove,- IMVU,,,,800,600
sleep 100
WinMove,- IMVU,,,,,355
winset, transcolor, 111111 180, ahk_class ImvuNativeWindow
WinGetPos,,,W,H,  - IMVU
	H -= (135)
	W -= 5
WinSet, Region, 0-108 h%H% w%W%  ,ahk_class ImvuNativeWindow	
}
}
else
{
if active = 1
{
active := 0

winset, alwaysontop, on, ahk_class ImvuNativeWindow
WinSet, Exstyle, +0x20, ahk_class ImvuNativeWindow
winset, transcolor, 111111 180, ahk_class ImvuNativeWindow
WinMove,- IMVU,,,,,355
WinGetPos,,,W,H,  - IMVU
	H -= (182)
	W -= 46
WinSet, Region, 4-108 h%H% w%W%  , ahk_class ImvuNativeWindow

}
}
}
else
{
winset, transcolor, off, ahk_class ImvuNativeWindow
winset, alwaysontop, off,  ahk_class ImvuNativeWindow
WinSet, Exstyle, -0x20, ahk_class ImvuNativeWindow
WinSet, Region,, - IMVU
}
return

#i::
winactivate, - IMVU
if overlay = 0
{
overlay = 1

WinMove,- IMVU,,,,,355
WinGetPos,,,W,H,  - IMVU
WinSet, Style, -0x040000,ahk_class ImvuNativeWindow ; WS_THICKFRAME
WinSet, Style, -0x400000,ahk_class ImvuNativeWindow ; WS_DLGFRAME
}
else
{
overlay = 0
WinSet, Style, +0x040000,ahk_class ImvuNativeWindow ; WS_THICKFRAME
WinSet, Style, +0x400000,ahk_class ImvuNativeWindow ; WS_DLGFRAME
}
return



IsDesktopActive() {
    MouseGetPos,,,win
    WinGetClass, class, ahk_id %win%
    If class in Progman,WorkerW
        Return True
    Return False
}

GuiClose:
handle_exit:
if enB = 1
{
enB := 0
dblur( hwnd )
}
winset, transcolor, off, ahk_class ImvuNativeWindow
winset, alwaysontop, off,  ahk_class ImvuNativeWindow
WinSet, Exstyle, -0x20, ahk_class ImvuNativeWindow
WinSet, Style, +0x040000,ahk_class ImvuNativeWindow ; WS_THICKFRAME
WinSet, Style, +0x400000,ahk_class ImvuNativeWindow ; WS_DLGFRAME
WinSet, Region,, ahk_class ImvuNativeWindow

   DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
   DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
   DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
   DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
ExitApp 


;============================================================================

return

 
DBlur( hWnd ){
   Local WindowCompositionAttributeData
   , AccentPolicy
   Local WCA_ACCENT_POLICY := 19
   Local ACCENT_DISABLED := 0
   , ACCENT_ENABLE_GRADIENT := 3
   , ACCENT_ENABLE_TRANSPARENTGRADIENT := 3
   , ACCENT_ENABLE_BLURBEHIND := 0
   , ACCENT_INVALID_STATE := 4
   Local accentStructSize := VarSetCapacity( AccentPolicy, 4 * 4, 0 )
   NumPut( ACCENT_ENABLE_BLURBEHIND, AccentPolicy, 0, "UInt" )
   Local padding := ( A_PtrSize == 8 ? 4 : 0 )
   VarSetCapacity( WindowCompositionAttributeData, 4 + padding + A_PtrSize + 4 + padding )
   NumPut( WCA_ACCENT_POLICY, WindowCompositionAttributeData, 0, "UInt" )
   NumPut( &AccentPolicy, WindowCompositionAttributeData, 4 + padding, "Ptr" )
   NumPut( accentStructSize, WindowCompositionAttributeData, 4 + padding + A_PtrSize, "UInt" )
   DllCall( "User32.dll\SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WindowCompositionAttributeData )
   return
}
 
 
EBlur( hWnd ) {
   Local WindowCompositionAttributeData
   , AccentPolicy
   Local WCA_ACCENT_POLICY := 19
   Local ACCENT_DISABLED := 0
   , ACCENT_ENABLE_GRADIENT := 3
   , ACCENT_ENABLE_COLORGADIENT := 2
   , ACCENT_ENABLE_TRANSPARENTGRADIENT :=  3
   , ACCENT_ENABLE_BLURBEHIND := 3
   , ACCENT_INVALID_STATE := 4
   Local accentStructSize := VarSetCapacity( AccentPolicy, 8 * 8, 0 )
   NumPut( ACCENT_ENABLE_BLURBEHIND, AccentPolicy, 0, "UInt" )
   Local padding := ( A_PtrSize == 8 ? 4 : 0 )
   VarSetCapacity( WindowCompositionAttributeData, 8 + padding + A_PtrSize + 8 + padding )
   NumPut( WCA_ACCENT_POLICY, WindowCompositionAttributeData, 0, "UInt" )
   NumPut( &AccentPolicy, WindowCompositionAttributeData, 4 + padding, "Ptr" )
   NumPut( accentStructSize, WindowCompositionAttributeData, 4 + padding + A_PtrSize, "UInt" )
   DllCall( "User32.dll\SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WindowCompositionAttributeData )
   return
}
 
 

^!B::
hwnd := winexist( "ahk_class ImvuNativeWindow" )
if enB = 0
{
enb := 1
eblur( hwnd  )

}
else
{
enB := 0
dblur( hwnd )

}
return





LAlt & RButton::
EWD_MouseWin:= winexist( "PrintScreen" )
   WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY
   WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
   WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
   if EWD_WinState = 0  ; Only if the window isn't maximized 
   SetTimer, EWD_WatchMouse, 1 ; Track the mouse as the user drags it.
return



EWD_WatchMouse:
   GetKeyState, EWD_LButtonState, RButton, P
   if EWD_LButtonState = U  ; Button has been released, so drag is complete.
   {
      SetTimer, EWD_WatchMouse, off
      return
   }
   GetKeyState, EWD_EscapeState, Escape, P
   if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
   {
      SetTimer, EWD_WatchMouse, off
      WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
      return
   }
   ; Otherwise, reposition the window to match the change in mouse coordinates
   ; caused by the user having dragged the mouse:
   CoordMode, Mouse
   MouseGetPos, EWD_MouseX, EWD_MouseY
   WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
   SetWinDelay, -1   ; Makes the below move faster/smoother.
   WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
   EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
   EWD_MouseStartY := EWD_MouseY
return






FHex( int, pad=0 ) { ; Function by [VxE]. Formats an integer (decimals are truncated) as hex.
  ; "Pad" may be the minimum number of digits that should appear on the right of the "0x".
  Static hx := "0123456789ABCDEF"
  If !( 0 < int |= 0 )
    Return !int ? "0x0" : "-" FHex( -int, pad )
  s := 1 + Floor( Ln( int ) / Ln( 16 ) )
  h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )
  u := A_IsUnicode = 1
  Loop % s
    NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4
  Return h
}

FlashWindowEx( hWnd=0, Flags=0, TI=0, TO=0 ) {
  Static FW="0123456789ABCDEF01234" ; FLASHWINFO Structure
  ; UINT cbSize; HWND hwnd; DWORD dwFlags; UINT uCount; DWORD dwTimeout; } *PFLASHWINFO;
  NumPut(20,FW), NumPut(hWnd,FW,4), NumPut(Flags,FW,8), NumPut(TI,FW,12), NumPut(TO,FW,16)
  Return DllCall( "FlashWindowEx", Ptr, &FW )
}

ShellEvent(wParam, lParam) {
    _wParam := FHex(wParam)
    _lParam := FHex(lParam)
    X := 0
    Y := 0
    MouseGetPos, X, Y
    
    ;ToolTip % "1: (" . X . ", " . Y . ") Trying to activate " . _wParam . ", " . _lParam . ".", (X+1), (Y+1),1 
    if (wParam = 0x8006) ; HSHELL_FLASH
    {   ; lParam contains the ID of the window which flashed:
        FlashWindowEx(lParam)
        ;ToolTip % "2: (" . X . ", " . Y . ") Trying to activate " _wParam . ", " . _lParam . ".", (X+1), (Y+21),2
        ;WinActivate, ahk_id %lParam%
        ;DLLCall("SetFocus", "Ptr", lParam, "Ptr")
    }
}	



!Lbutton::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; Get the initial window position.
WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
}
return
