; TODO: For certain window, make sure they are at a specific position when opened

; globals have to be declared at the very top.

global winExtendIncrement := 100
global utilSizeToggle := false


; useful Win hotkey: alt+esc - send active window to back

; ; modified from:
; ; https://www.howtogeek.com/howto/28663/create-a-hotkey-to-resize-windows-to-a-specific-size-with-autohotkey/
; ; default parameters
; ResizeWin(width=0, height=0) {
;   ; get window size characteristics and save them in variables X,Y,W,H
;   ; A stands for active window, could also be a title or sth else, see doc
;   WinGetPos,X,Y,W,H,A
;   ; if a parameter is omitted, width/height is left unchanged
;   If %width% = 0
;     width := W
;   ; only change height: ResizeWin(0,420)
;   If %height% = 0
;     height := H
;   ; https://autohotkey.com/docs/commands/WinMove.htm
;   WinMove, A, , %X%, %Y%, %width%, %height%
; }

; Win and Shift and Left arrow key
#+Left::
; other offsets are handcrafted to extend the window beyond the visible viewport because
; → setting x and y to 0 still leaves visible desktop space to the left of the window
; → we additionally hide the 1 or 2px window border
winSetTwoThirdsLeft() {
  WinGetPos,X,Y,W,H,A
  ; actually only 64%
  WinMove, A, , -13, -2, (A_ScreenWidth * 0.64), A_ScreenHeight+13
}

#+Right::
winSetTwoThirdsRight() {
  WinGetPos,X,Y,W,H,A
  WinMove, A, , (A_ScreenWidth * (1-0.64)), -2, (A_ScreenWidth * 0.64), A_ScreenHeight+13
}

; isChromeHidden(){
;   WinGet Style, Style, Style, A
;   if (Style & 0xC40000) {
;     Return True
;   } else {
;     Return False
;   }
; }

; ; If a window is moved all the way to the edge of the screen
; ; and there is window chrome shown
; ; we want to move it a bit further to also hide that chrome.
; determineXBorderOffset() {
;   WinGet Style, Style, Style, A
;   if(Style & 0xC40000) {
;     ; chrome and title bar are hidden
;   xOffset := -13
;   } else {
;     xOffset := 0
;   }
;   Return xOffset
; }


; determineYBorderOffset() {
;   WinGet Style, Style, Style, A
;   if(Style & 0xC40000) {
;     ; chrome and title bar are hidden
;   yOffset := -2
;   } else {
;     yOffset := 0
;   }
;   Return yOffset
; }



; win, shift, hash
#+#::
  winSetUtilSize()
Return


; extends the right border of the given
; increment can also be negative
winExtendRight(increment) {
  ; get dimensions of current window
  WinGetPos,X,Y,W,H,A
  ; Set window size, leaving X, Y, H unchanged.
  WinMove, A, , X,Y, W+increment, H
}

winExtendLeft(increment) {
  ; get dimensions of current window
  WinGetPos,X,Y,W,H,A
  ; increment width but move whole window to the left
  WinMove, A, , X-increment,Y, W+increment, H
}

; tells if window is positioned at right or left border of screen, then
; extends it horizontally in size away from the screen border.
; e.g. window's x pos is <=0, then the *right* border is moved
winSmartExtendSide(increment) {
  error:=5
  ; get dimensions of active window
  WinGetPos, X, Y, W, H, A
  ; if window is at the very left of the screen
  if (X <= 0+error) {
    winExtendRight(increment)
  } else
  ; if window is at very right side of screen
  if ( X+W >= A_ScreenWidth-error ) {
    winExtendLeft(-increment)
  }
}

; set the window centrally, "utility-sized"
winSetUtilSize() {
  utilSizeToggle := true
  WinGetPos,X,Y,W,H,A
  width := A_ScreenWidth * 0.4
  xOffset := A_ScreenWidth * 0.55
  height := A_ScreenHeight * 0.8
  yOffset := A_ScreenHeight * 0.1
  WinMove, A, , xOffset, yOffset, width, height
}

; win, alt, right
#!Right::
  winSmartExtendSide(winExtendIncrement)
Return

#!Left::
  winSmartExtendSide(-winExtendIncrement)
Return



; https://www.autohotkey.com/docs/misc/WinTitle.htm
; https://www.autohotkey.com/docs/misc/WinTitle.htm#ActiveWindow
; https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm

; `WinMinimize, A` and `WinClose, A` does not work in some specific cases;
; even for windows that work in other occasions. Maybe it has sth to do with
; their "origin", the way they were opened.

; AltGr and m
<^>!m::
  ; Retrieve title of active window and save in variable specified in arg.
  ; actually works
  ; WinGetActiveTitle, ActiveWindowTitle
  ; MsgBox, The active window is "%ActiveWindowTitle%".

  ; somehow doesnt work like this.
  ; Minimize window, matched by title
  ;  WinMinimize, ActiveWindowTitle

  ; shortcut for using active window
  WinMinimize, A
Return

; AltGr and ,
<^>!,::
  WinClose, A
Return

; send window to back by triggering integrated windows hotkey.
<^>!b::
  Send, !{Esc}
Return

; hide window title bar and any chrome (border, shadow)
; interestingly enough, this also disables animations
; and integrated Win-Arrow functionality.
; Also it doesn't play well with Win-Shift-Arrow from this script.
; Win-Shift-T
#+t::
  ; get window style to tell if title bar is visible or not
  WinGet Style, Style, A
  ; get window position to later reposition window
  ; so window contents are at the same position without chrome
  WinGetPos, X, Y, W, H, A
  ; offset to additionally move the window so that window contents
  ; stay at the same position
  xOffset := 7
  if(Style & 0xC40000) {
    WinSet, Style, -0xC40000, A
    ; WinMove,A,,X+xOffset,Y,W,H
  } else {
    WinSet, Style, +0xC40000, A
    ; WinMove,A,,X-xOffset,Y,W,H
  }
return

; (attempt to) hide tab and address bar from firefox
#w::
  WinGetPos,winx,winy,width,height,A ; get dimensions of currently active window
  WinSet, Region, 0-62 W%width% H%height%, A
return

; restore window to original view area
#+w::
  WinSet, Region, , A
return

; hide menu bar
; doesnt seem to work
; #+m::
;     DllCall("SetMenu", uint, 0, uint, 0)
; return

; ; Win key and r
#r::
  MsgBox, Reloading script
  ; reload script on win r
  Reload
Return
