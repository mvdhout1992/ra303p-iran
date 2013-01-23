@HOOK 0x0041CB90	_Count_as_Civ_Evac_Check

%define SessionClass__Session 0x0067F2B4

_Count_as_Civ_Evac_Check:
	cmp    	BYTE [SessionClass__Session], 0
	jnz		.Check_EvacInMP_Keyword
	jmp		.Normal_Function

.Check_EvacInMP_Keyword:
	CMP BYTE [evacinmp], 1
	jz		.Normal_Function
	
	mov		eax, 0
	retn
	
.Normal_Function:
	push    ebp
	mov     ebp, esp
	push    ebx
	push    ecx
	push    edx
	push    edi
	jmp		0x0041CB97