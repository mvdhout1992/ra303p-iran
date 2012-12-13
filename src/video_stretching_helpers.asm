;keep a global flag telling telling cnc-ddraw patched by me to video stretch or not

@HOOK 0x0053AF3B	_Campaign_Do_Win_ScoreClass__Presentation
@HOOK 0x0053B037	_Campaign_Do_Win_Map_Selection
@HOOK 0x0053ADF6	_Campaign_Do_Win_Multiplayer_Score_Presentation
@HOOK 0x0053B3E6	_Do_Win_Multiplayer_Score_Presentation
@HOOK 0x0053B6CF	_Do_Lose_Multiplayer_Score_Presentation

shouldstretch db 0

_Campaign_Do_Win_ScoreClass__Presentation:
	mov BYTE [shouldstretch], 1
	
	call	0x00540670	; ScoreClass::Presentation()
	mov BYTE [shouldstretch], 0
	JMP	0x0053AF40

_Campaign_Do_Win_Map_Selection:
	mov BYTE [shouldstretch], 1
	
	call	0x00500A68	; Map_Selection()
	mov BYTE [shouldstretch], 0
	JMP	0x0053B03C
	
_Campaign_Do_Win_Multiplayer_Score_Presentation:
	mov BYTE [shouldstretch], 1
	
	call	0x00546678	; Multiplayer_Score_Presentation()
	mov BYTE [shouldstretch], 0
	JMP	0x0053ADFB
	
_Do_Win_Multiplayer_Score_Presentation:
	mov BYTE [shouldstretch], 1
	
	call	0x00546678	; Multiplayer_Score_Presentation()
	mov BYTE [shouldstretch], 0
	JMP	0x0053B3EB
	
_Do_Lose_Multiplayer_Score_Presentation:
	mov BYTE [shouldstretch], 1
	
	call	0x00546678	; Multiplayer_Score_Presentation()
	mov BYTE [shouldstretch], 0
	JMP	0x0053B6D4
