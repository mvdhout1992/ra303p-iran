; skipscorescreen
@HOOK 	0x0053AF3B		_Campaign_Do_Win_Score_Screen
@HOOK	0x00546678		_Multiplayer_Score_Presentation_Start

_Campaign_Do_Win_Score_Screen:
	cmp		BYTE [skipscorescreen], 1
	jz		.Ret
	
	call	0x00540670	; call ScoreClass::Presentation()
.Ret:
	jmp		0x0053AF40
	
_Multiplayer_Score_Presentation_Start:
	cmp		BYTE [skipscorescreen], 1
	jnz		.No_Early_Ret
	retn

.No_Early_Ret:
	push    ebp
	mov     ebp, esp
	push    ebx
	push    ecx
	push    edx
	push    esi
	push    edi
	jmp		0x00546680