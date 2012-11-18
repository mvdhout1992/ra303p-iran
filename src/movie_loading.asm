@HOOK 0x004A8DE2 _Play_Movie
@HOOK 0x004637FF _CCINIClass_Get_VQType
@Hook 0x0053A1D3 _Start_Scenario_VQName

%define strcmpi_ 0x005B8B50

derp_str db "derp",0

_Start_Scenario_VQName:
	mov     edi, 0
	jmp 	0x0053A1DA

_CCINIClass_Get_VQType:
	xor     ah, ah
	mov     [ebp-8h], ah
	
	lea eax, [ebp-88h]
	lea edx, [derp_str]
	call    strcmpi_
;	mov eax, 0 ; debug crap
	test    eax, eax
	
	jnz 0x00463804
	
	mov al, 150
	jmp 0x00463828
	
;	jmp		0x00463804

_Play_Movie:

	movsx   eax, al
	movsx   edx, dl
	cmp al, 150
	je Load_Custom_String

	jmp 0x004A8DE8

Load_Custom_String:
	mov eax, derp_str
	xor     esi, esi
	call	0x004A88AC
	jmp 0x004A8DF6