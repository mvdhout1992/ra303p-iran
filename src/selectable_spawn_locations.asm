;@HOOK 0x0053E6A9	_Create_Units_Spawn_Location

_Create_Units_Spawn_Location:
; [ebp-0x30] is spawn location local variable
	mov     ebx, DWORD [ebp-0x1B]
	sar     ebx, 18h
	cmp		DWORD ebx, 0x0c
	je		.Spawn_Multi1
	
	cmp		DWORD ebx, 0x0d
	je		.Spawn_Multi2
	
.Ret:
	mov     eax, DWORD [ebp-0x30]
	mov     word [ebp-0x1C], ax
	jmp		0x0053E6B0
	
.Spawn_Multi1:
	mov		eax, 0
	mov		DWORD [ebp-0x30], 0
	jmp		0x0053E6B0
	
.Spawn_Multi2:
	mov		eax, 9003
	mov		DWORD [ebp-0x30], 9003
	jmp		0x0053E6B0