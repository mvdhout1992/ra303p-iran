;@HOOK 0x005C19FE	_WWMouseClass__Process_Mouse_Jump_Over_Check

; Patch out a check that might be causing issue, no idea what the check does
; Seems to cause menu mouse to be laggy, but ingame it's fine

_WWMouseClass__Process_Mouse_Jump_Over_Check:
	jmp		0x005C1A03
