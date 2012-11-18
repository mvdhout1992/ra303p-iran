@HOOK 0x0056C154 _ThemeClass_Track_Length
@HOOK 0x0056C439 _ThemClass_Scan
@HOOK 0x0056C40C _ThemeClass_Scan_Jump_Over
@HOOK 0x0056C115 _ThemeClass_File_Name
@HOOK 0x0056BEA4 _ThemeClass_Full_Name
@HOOK 0x0055066B _SoundControlsClass_Process

bigfoot_str db "outtakes.AUD",0

_SoundControlsClass_Process:
	cmp     edx, 35h
	jge     0x00550727
	jmp		0x00550674

_ThemeClass_Full_Name:
	cmp     dl, 30h
	je		Return_Custom_Name
	
	cmp     dl, 27h
	jge     0x0056BEF6
	
	jmp		0x0056BEA7
	
Return_Custom_Name:
	mov eax, bigfoot_str
	jmp 0x0056BEF8
_ThemeClass_Scan_Jump_Over:
	jmp 0x0056C412

_ThemeClass_Track_Length:
	mov eax, 5
	retn

_ThemClass_Scan:	
	mov     [ebp-0Ch], dl
	cmp     dl, 30h
	jmp		0x0056C43F
	
_ThemeClass_File_Name:
	push    edx
	test    al, al
	jl      0x0056C144
	
	cmp 	al, 30h
	je Return_Custom_String
	cmp     al, 27h
	jge     0x0056C144
	jmp		0x0056C11E

Return_Custom_String:
	mov eax, bigfoot_str
	jmp 0x0056C149