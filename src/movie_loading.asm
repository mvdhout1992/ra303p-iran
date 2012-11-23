@HOOK 0x004A8DE2 _Play_Movie
@HOOK 0x004637FF _CCINIClass_Get_VQType
@Hook 0x0053A1D3 _Start_Scenario_VQName

%define strcmpi_ 0x005B8B50

derp_str db "derp",0

FileClass_moviesini  TIMES 128 db 0
INIClass_moviesini TIMES 128 db 0


; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Int 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_moviesini
    CALL INIClass__Get_Int
%endmacro

; args: <section>, <key>, <default>, <dst>, <dst_len>
%macro INI_Get_String 5
    PUSH %5             ; dst len
    PUSH %4             ; dst
    MOV ECX, DWORD %3   ; default
    MOV EBX, DWORD %2   ; key
    MOV EDX, DWORD %1   ; section
    MOV EAX, INIClass_moviesini
    CALL INIClass__Get_String
%endmacro

_Start_Scenario_VQName:
	mov     edi, 0
	jmp 	0x0053A1DA

_CCINIClass_Get_VQType:

	push eax ; save value of index
	
	MOV EDX, musicini_str
    MOV EAX, FileClass_moviesini
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_moviesini
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
	JE File_Not_Available ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_moviesini
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_moviesini
    MOV EAX, INIClass_moviesini
    CALL INIClass__Load
	
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