; Load our settings from here

@HOOK	0x004F446C		_Init_Game_Hook_Load

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define INIClass__Get_Bool							0x004F3ACC
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30

str_redalertini5 db "REDALERT.INI",0
str_options5 db "Options",0
str_videointerlacemode db "VideoInterlaceMode",0
str_skipscorescreen db "SkipScoreScreen",0

INIClass_redalertini5 TIMES 64 db 0
FileClass_redalertini5	TIMES 128 db 0

aftermathfastbuildspeed	db 0
videointerlacemode	dd 2
skipscorescreen db 0

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro INI_Get_Bool_ 4
    MOV ECX, DWORD %4
    MOV EBX, DWORD %3
    MOV EDX, DWORD %2
    MOV EAX, %1
    CALL INIClass__Get_Bool
%endmacro

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro INI_Get_Int_ 4
    MOV ECX, DWORD %4
    MOV EBX, DWORD %3
    MOV EDX, DWORD %2
    MOV EAX, %1
    CALL INIClass__Get_Int
%endmacro

; args: <INI Name>, <FileClass>, <INIClass>
%macro Load_INIClass 3
	MOV EDX, %1
    MOV EAX, %2
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, %2
    XOR EDX, EDX
    CALL FileClass__Is_Available

    ; initialize INIClass
    MOV EAX, %3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, %2
    MOV EAX, %3
    CALL INIClass__Load
%endmacro

_Init_Game_Hook_Load:
	push 	ecx
	push 	ebx
	push 	edx
	push 	eax
	
	Load_INIClass str_redalertini5, FileClass_redalertini5, INIClass_redalertini5
	
	INI_Get_Int_ INIClass_redalertini5, str_options5, str_videointerlacemode, 2 ; 2 = deinterlace videos
	mov		[videointerlacemode], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_skipscorescreen, 0
	mov		[skipscorescreen], al
	
	INI_Get_Bool_ 0x00666688, str_aftermath, str_aftermathfastbuildspeed, 0
	mov		[aftermathfastbuildspeed], al
	
	INIClass__Get_Int_
	
	pop		eax
	pop		edx
	pop		ebx
	pop		ecx
	
	mov     eax, 1
	jmp		0x004F4471