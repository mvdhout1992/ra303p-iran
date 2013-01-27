@HOOK 0x004F80D4	_Init_Secondary_Mixfiles_Movies1_Check_NOP
@HOOK 0x004F80F5	_Init_Secondary_Mixfiles_Movies1_Jump_NOP

_Init_Secondary_Mixfiles_Movies1_Check_NOP:
	mov     eax, 24h
	jmp		0x004F80DD
	
_Init_Secondary_Mixfiles_Movies1_Jump_NOP:
	 mov	eax, 24h
	 jmp	0x004F80FC