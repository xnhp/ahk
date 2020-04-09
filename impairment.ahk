CapsLock::
  Send, {Enter}
Return

global WASDMode := False

toggleWASDMode() {
	if (WASDMode) {
		WASDMode := False
	} else {
		WASDMode := True
	}
}

!+w::
	toggleWASDMode()
Return



$d::
fooD() {
	if (WASDMode) {
		Send, {Right}
	} else {
		Send, d
	}
}

$a::
fooA() {
	if (WASDMode) {
		Send, {Left}
	} else {
		Send, a
	}
}

$s::
fooS() {
	if (WASDMode) {
		Send, {Down}
	} else {
		Send, s
	}
}

$w::
fooW() {
	if (WASDMode) {
		Send, {Up}
	} else {
		Send, w
	}
}

; ctrl alt v
^+v::
	; shift insert
	Send +{Ins}
Return

^+c::
	; ctrl insert
	Send ^{Ins}
Return

;;alt shift r
!+r::
	Send, ^+p
Return

;alt r
!r::
	Send, ^p
Return