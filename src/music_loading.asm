@HOOK 0x0056C154 _ThemeClass_Track_Length
@HOOK 0x0056C439 _ThemClass_Scan
@HOOK 0x0056C40C _ThemeClass_Scan_Jump_Over
@HOOK 0x0056C115 _ThemeClass_File_Name
@HOOK 0x0056BEA4 _ThemeClass_Full_Name
@HOOK 0x0055066B _SoundControlsClass_Process

bigfoot_str db "outtakes.AUD",0
musicini_str db "MUSIC.INI",0
music_array TIMES 400h db 0
;str_general db "General",0

FileClass_this3  TIMES 128 db 0
INIClass_this3 TIMES 128 db 0

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30
%define	INIClass__Get_Textblock						0x004F3528

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
	
	MOV EDX, musicini_str
    MOV EAX, FileClass_this3
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_this3
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
	JE File_Not_Available ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_this3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_this3
    MOV EAX, INIClass_this3
    CALL INIClass__Load
	
	mov eax, INIClass_this3
	mov ecx, 400h
	mov ebx, music_array
	mov edx, DWORD str_general
	call	 INIClass__Get_Textblock
	
	mov eax, music_array
;	mov eax, bigfoot_str
	jmp 0x0056C149
	
File_Not_Available:
	int 3