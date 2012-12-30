@HOOK 0x004D5B13	_Paraboms_Single_Player_Check

%define SessionClass__Session 0x0067F2B4

_Paraboms_Single_Player_Check:
	cmp BYTE [parabombsinmultiplayer], 1
	jz		0x004D5B1C

	cmp     DWORD [SessionClass__Session], 0
	jmp		0x004D5B1A
	