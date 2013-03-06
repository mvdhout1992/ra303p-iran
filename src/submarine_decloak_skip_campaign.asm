@HOOK 0x004D4AE8	_HouseClass__AI_Submarine_Decloak_Check

_HouseClass__AI_Submarine_Decloak_Check:
	cmp		BYTE [SessionClass__Session], 0
	je		0x004D4C67

.Ret:
	test    eax, eax
	jnz     0x004D4C67
	jmp		0x004D4AF0