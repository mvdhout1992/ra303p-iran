@HOOK	0x004BB74A		Slide_Show_Credits_CnCDDraw_Crash_Fix

@HOOK	0x004BC2E5		_Slide_Show_No_Background

str_derppp db "derpppp", 0

Slide_Show_Credits_CnCDDraw_Crash_Fix:
	jmp		0x004BB74F
	
_Slide_Show_No_Background:
	mov 	edi, str_derppp
	jmp		0x004BC2EA