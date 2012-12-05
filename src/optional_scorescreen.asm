; skipscorescreen
@HOOK 	0x0053AF3B		_Campaign_Do_Win_Score_Screen

_Campaign_Do_Win_Score_Screen:
	cmp		BYTE [skipscorescreen], 1
	jz		.Ret
	
	call	0x00540670	; call ScoreClass::Presentation()
.Ret:
	jmp		0x0053AF40