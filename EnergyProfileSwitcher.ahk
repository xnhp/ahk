; TODO: Hotkey to display currently active power plan
; TODO: Change power plan but keep screen brightness

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; https://www.autohotkey.com/docs/commands/TrayTip.htm
; https://www.autohotkey.com/docs/Hotkeys.htm

; list available power plans with
; λ powercfg -l

; # = win key
; + = shift key

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

MuteReliably() {
  ; doesnt work
  ; different ways to manipulate volume, see https://www.autohotkey.com/docs/commands/SoundSet.htm
  ; SoundSet, 0, , mute   ; doesnt seem to have any effect
  ; Send {Volume_Mute}    ; works but only toggles
  ; Loop, 15                ; dirty, dirty hacks
  ; {
  ;   Send {Volume_Mute}
  ; }
  ; SoundSet, +1, ,       ; works, toggles
  ; SoundSet, -100          ; works, but doesnt actually mute
  ; SoundSet, 0, MASTER, MUTE ; doesnt work either
}

DimToMinimum() {
  ; doesnt work, somehow windows gets confused (only sending it once doesnt decrease brightness but shows the GUI overlay with zero brightness, sending it multiple times does the same
  ; Loop, 15
  ; {
  ;   Send {F11}
  ; }
}

#+1::
   Run, powercfg -s a1841308-3541-4fab-bc81-f71556f20b4a
   HideTrayTip()
   MuteReliably()
   DimToMinimum()
   TrayTip, Energiesparmodus, Muted`,  Switched Energy Profile, 1, 1+16
Return

#+2::
   Run, powercfg -s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
   HideTrayTip()
   TrayTip, Höchstleistung, Switched Energy Profile, 1, 1+16
Return

#+3::
  Run, powercfg -s  ea1919d3-b994-4d13-bec7-5c81517f6c6e
  MuteReliably()
  HideTrayTip()
  TrayTip, Study, Muted`, Switched Energy Profile, 1, 1+16
Return

#+4::
   Run, powercfg -s f64f79c6-983d-4e9a-8e3a-47e43a0f9812
   HideTrayTip()
   TrayTip, Sleep Is For The Weak, Switched Energy Profile, 1, 1+16
Return

#+5::
   Run, powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e
   HideTrayTip()
   TrayTip, Ausbalanciert, Switched Energy Profile, 1, 1
Return


