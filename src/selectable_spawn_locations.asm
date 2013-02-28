@HOOK 0x0053DDEB	_Read_Scenario_INI_Spawn_Locations
@HOOK 0x0053E6A9	_Create_Units_Spawn_Location

str_SpawnLocations 		db "SpawnLocations",0
str_multi1				db "Multi1",0
str_multi2				db "Multi2",0
str_multi3				db "Multi3",0
str_multi4				db "Multi4",0
str_multi5				db "Multi5",0
str_multi6				db "Multi6",0
str_multi7				db "Multi7",0
str_multi8				db "Multi8",0

multi1_spawn	dd 0
multi2_spawn	dd 0
multi3_spawn	dd 0
multi4_spawn	dd 0
multi5_spawn	dd 0
multi6_spawn	dd 0
multi7_spawn	dd 0
multi8_spawn	dd 0

_Read_Scenario_INI_Spawn_Locations:
	push	eax
	Save_Registers
	
	lea     esi, [ebp-140]
	
	INI_Get_Int_ esi, str_SpawnLocations, str_multi1, -1
	mov		DWORD [multi1_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi2, -1
	mov		DWORD [multi2_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi3, -1
	mov		DWORD [multi3_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi4, -1
	mov		DWORD [multi4_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi5, -1
	mov		DWORD [multi5_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi6, -1
	mov		DWORD [multi6_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi7, -1
	mov		DWORD [multi7_spawn], eax
	
	INI_Get_Int_  esi, str_SpawnLocations, str_multi8, -1
	mov		DWORD [multi8_spawn], eax
	
	Restore_Registers
	pop		eax
	call 	0x0053E204 ; Create_Units(int)
	jmp		0x0053DDF0
	

_Create_Units_Spawn_Location:
; [ebp-0x30] is spawn location local variable
	mov     ebx, DWORD [ebp-0x1B]
	sar     ebx, 18h
	cmp		DWORD ebx, 0x0c
	je		.Spawn_Multi1
	
	cmp		DWORD ebx, 0x0d
	je		.Spawn_Multi2
	
	cmp		DWORD ebx, 0x0e
	je		.Spawn_Multi3
	
	cmp		DWORD ebx, 0x0f
	je		.Spawn_Multi4
	
	cmp		DWORD ebx, 0x10
	je		.Spawn_Multi5
	
	cmp		DWORD ebx, 0x11
	je		.Spawn_Multi6
	
	cmp		DWORD ebx, 0x12
	je		.Spawn_Multi7
	
	cmp		DWORD ebx, 0x13
	je		.Spawn_Multi8
	
.Ret:
	mov     eax, DWORD [ebp-0x30]
	mov     word [ebp-0x1C], ax
	jmp		0x0053E6B0
	
.Spawn_Multi1:
	mov		eax, DWORD [multi1_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0

.Spawn_Multi2:
	mov		eax, DWORD [multi2_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi3:
	mov		eax, DWORD [multi3_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi4:
	mov		eax, DWORD [multi4_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi5:
	mov		eax, DWORD [multi5_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi6:
	mov		eax, DWORD [multi6_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi7:
	mov		eax, DWORD [multi7_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0
	
.Spawn_Multi8:
	mov		eax, DWORD [multi8_spawn]
	
	cmp		eax, DWORD -1
	jz		.Ret
	
	add		eax, eax
	add		eax, 2
	add		eax, 0x006678F5 ; Waypoints
	
	xor		edi, edi
	mov		WORD di, [eax]
	mov		eax, edi
	
	mov		DWORD [ebp-0x30], eax
	jmp		0x0053E6B0