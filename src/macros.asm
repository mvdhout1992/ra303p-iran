%macro Save_Registers 0
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
%endmacro

%macro Restore_Registers 0
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
%endmacro

%macro Extract_Conquer_Eng_String 1
	mov     edx, %1
	mov     eax, [0x0066991C] ; ds:char *SystemStrings
	call    0x005C5070  ; Extract_String(void *,int)
%endmacro 