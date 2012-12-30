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