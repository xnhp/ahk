
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;; remap caps to ctrl for emacs
;; https://stackoverflow.com/questions/21162972/autohotkey-how-to-remap-ctrl-with-alt-key-and
CapsLock::Lctrl

; RAlt::Esc