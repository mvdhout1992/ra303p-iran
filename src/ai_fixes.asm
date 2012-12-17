@HOOK 0x004DAFA4	_AI_Tech_Up_Check
@HOOK 0x004D6102	_HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out
@HOOK 0x004DE5D2	_HouseClass__Is_Allowed_To_Ally_AI_Player_Fix

_HouseClass__Is_Allowed_To_Ally_AI_Player_Fix:
	cmp BYTE [fixaiparanoid], 1
	jz		.Allow_AI_Ally

	test    byte [eax+42h], 2
	jnz     0x004DE5E2 ; Assemble JMP here to fix?
	jmp		0x004DE5D8

.Allow_AI_Ally:
	jmp		0x004DE5E2

_HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out:
	cmp BYTE [fixaiparanoid], 1
	jz		.Jump_Over

	call	0x004DE640 ; call HouseClass::Computer_Paranoid()

.Jump_Over:
	jmp		0x004D6107 ; Jump over

_AI_Tech_Up_Check:
	jnz		0x004DB0E4
	
	cmp BYTE [removeaitechupcheck], 1
	jz		.No_Techup_Check
	
	jmp		0x004DAFAA
	
.No_Techup_Check:
	jmp		0x004DAFB7