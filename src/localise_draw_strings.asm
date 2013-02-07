@HOOK	0x0053B623	_Do_Lose_The_Game_Is_A_Draw_Text
@HOOK	0x004BDF6B	_Localise_Has_Rectracted_The_Offer_Of_A_Draw
@HOOK	0x004BDF2B  _Localise_You_Have_Rectracted_Your_Offer_Of_A_Draw
@HOOK	0x004BDE55	_Localise_Has_Proposed_That_The_Game_Be_Declared_A_Draw
@HOOK	0x004BDE04	_Localise_You_Have_Proposed_That_The_Game_Be_Declared_A_Draw
@HOOK	0x004CAB93	_Localise_Are_You_Sure_You_Want_To_Accept_A_Draw
@HOOK	0x004CAB34 	_Localise_Are_You_Sure_You_Want_To_Propose_A_Draw
@HOOK	0x004CA0F7	_Localise_Accept_Proposed_Draw
@HOOK	0x004CA090	_Localise_Retract_Draw_Proposal
@HOOK	0x004CA0CC	_Localise_Propose_A_Draw

_Do_Lose_The_Game_Is_A_Draw_Text:
	Extract_Conquer_Eng_String 118
	push	eax
	jmp		0x0053B628
	
_Localise_Has_Rectracted_The_Offer_Of_A_Draw:
	Extract_Conquer_Eng_String 117
	push	eax
	jmp		0x004BDF70
	
_Localise_You_Have_Rectracted_Your_Offer_Of_A_Draw:
	push	edx
	push	eax
	
	Extract_Conquer_Eng_String 115
	mov		ecx, eax
	
	pop		eax
	pop		edx
	jmp		0x004BDF30 
	
_Localise_Has_Proposed_That_The_Game_Be_Declared_A_Draw:
	Extract_Conquer_Eng_String 114
	push	eax
	jmp		0x004BDE5A
	
_Localise_You_Have_Proposed_That_The_Game_Be_Declared_A_Draw
	Extract_Conquer_Eng_String 113
	mov		ecx, eax
	jmp		0x004BDE09
	
_Localise_Are_You_Sure_You_Want_To_Accept_A_Draw:
	Extract_Conquer_Eng_String 112
	jmp		0x004CAB98
	
_Localise_Are_You_Sure_You_Want_To_Propose_A_Draw:
	Extract_Conquer_Eng_String 111
	jmp		0x004CAB39
	
_Localise_Accept_Proposed_Draw:
	push	edx
	push	eax
	
	Extract_Conquer_Eng_String 110
	mov		ebx, eax
	
	pop		eax
	pop		edx
	jmp		0x004CA0FC
	
_Localise_Retract_Draw_Proposal:
	push	edx
	push	eax
	
	Extract_Conquer_Eng_String 109
	mov		ebx, eax
	
	pop		eax
	pop		edx
	jmp		0x004CA095
	
_Localise_Propose_A_Draw:
	push	edx
	push	eax
	
	Extract_Conquer_Eng_String 108
	mov		ebx, eax
	
	pop		eax
	pop		edx
	jmp		0x004CA0D1
