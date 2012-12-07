@HOOK	0x0051614C		_Skirmish_Menu_Write_Multiplayer_Settings
@HOOK	0x00509C22		_Network_Menu_Write_Multiplayer_Settings

_Skirmish_Menu_Write_Multiplayer_Settings:
	mov     eax, 0x0067F2B4
	jmp		0x00516153

_Network_Menu_Write_Multiplayer_Settings	
	call	0x005C21E0
	
	mov     eax, 0x0067F2B4
	call    0x0054B510

	jmp		0x00509C27