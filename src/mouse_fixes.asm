@HOOK	0x005D8F79		_ASM_Set_Mouse_Cursor_Mouse_Coords_Check

_ASM_Set_Mouse_Cursor_Mouse_Coords_Check:
	CMP		DWORD eax, [ScreenWidth]
	JG		.Crash
	
	CMP		DWORD ebx, [ScreenHeight]
	JG		.Crash

	mov     [ebp-4h], eax ; y
	mov     [ebp-8h], ebx ; x
	jmp		0x005D8F7F
	
.Crash:
	int 3
