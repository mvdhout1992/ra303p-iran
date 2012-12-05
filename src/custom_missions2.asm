@HOOK 0x004BE468 _Hook_Expansion_Mission_Loading
;@HOOK 0x004BE491 _Hook_Expansion_Mission_Loading2
;@HOOK 0x004BE72F _Hook_Expansion_Mission_Aftermath_Counter
@HOOK 0x004BE548 _Hook_Expansion_Mission_Counterstrike_Counter
@HOOK 0x004BE7C8 _Hook_Expansion_Mission_Counterstrike_Caption
@HOOK 0x00501E0E _Hook_Expansion_Mission_Counterstrike_Title

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30
%define	INIClass__Get_Textblock						0x004F3528 
%define	INIClass__Get_UUBlock						0x004F3338
%define	sprintf_									0x005B8BAA

herpini_str db "ffg101ea",0
newmissions_str db "New Missions",0
str_newmissions_ini db "NEWMISSIONS.INI",0
str_general db "General",0
str_one db "1",0
str_empty db 0
str_sprintf_format db "%d",0
mission_index_counter dd 0

FileClass_this2  TIMES 128 db 0
INIClass_this2 TIMES 128 db 0

sprintf_buffer   TIMES 64 db 0
newmissions_array TIMES 4096h db 0; char newmissions_array[256][64]

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Int 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_this
    CALL INIClass__Get_Int
%endmacro

%macro INI_Get_String 5
    PUSH %5             ; dst len
    PUSH %4             ; dst
    MOV ECX, DWORD %3   ; default
    MOV EBX, DWORD %2   ; key
    MOV EDX, DWORD %1   ; section
    MOV EAX, INIClass_this2
    CALL INIClass__Get_String
%endmacro

;EXTERN newmissionsenabled ; defined in arguments.asm

_Hook_Expansion_Mission_Loading:
	cmp byte [ebp-24h], 1 ; Expansion type check
	jne Ret_Normal
	cmp byte [newmissionsenabled], 1
	je New_Missions_Loading

Ret_Normal:	
	mov esi, [esi+00601400h]
	jmp 0x004BE46E

New_Missions_Loading:
;	inc		eax
	cmp	 ecx, 1
	je		.No_Substract
	sub		ecx, 13h
	
	.No_Substract
	push	ecx ; eax is our  counter
	
	;initialize FileClass
    MOV EDX, str_newmissions_ini
    MOV EAX, FileClass_this2
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_this2
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
	JE Ret_Normal ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_this2
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_this2
    MOV EAX, INIClass_this2
    CALL INIClass__Load
	
	pop	esi
	push esi ; esi contains counter

	
;	cmp esi, 3 ; hard-coded max to read inis
;	jz	Ret_Empty_String
	
;	mov		DWORD [mission_index_counter], esi
		
	push    esi             ; Format
	push    str_sprintf_format ; %d
	lea     esi, [sprintf_buffer]
	push    esi             ; Dest
	
	call    sprintf_
	add     esp, 0Ch
	
;	mov esi, DWORD newmissions_array
	pop	esi
	push esi
	imul esi, esi, 32
	lea esi, [newmissions_array+esi]
	INI_Get_String str_general, sprintf_buffer, str_empty, ESI, 32

	pop esi
	push esi
	imul esi, esi, 32
	lea esi, [newmissions_array+esi]
;	mov al, esi
	cmp byte esi, 0
	je Ret_Empty_String
	
;	mov eax, newmissions_array
	
;	mov esi, eax
;	cmp dword [ebp-30h], 14h
;	jnz Ret_Empty_String

	pop esi
	imul esi, esi, 32
	lea esi, [newmissions_array+esi]
	push esi
	jmp 0x004BE46E

Ret_Empty_String:
	lea esi, [str_empty]
;	jnz 0x004BE46E
	jmp 0x004BE46E
	
_Hook_Expansion_Mission_Loading2:
	lea esi, [herpini_str]
	jmp 0x004BE497
	
_Hook_Expansion_Mission_Aftermath_Counter:
	mov     [ebp-1CH], ebx
	mov     [ebp-30h], ecx ; Counter, starts at 20
	cmp     ecx, 60h
	jmp		0x004BE738


_Hook_Expansion_Mission_Counterstrike_Counter:
	cmp byte [ebp-24h], 1 ; Expansion type check
	jne Ret_Normal2
	cmp byte [newmissionsenabled], 1
	je New_Missions_Counter

Ret_Normal2:
	cmp     edi, 24h ; Counter, starts at 20 (14h)
	jge     0x004BE552
	jmp 	0x004BE54D
	
New_Missions_Counter:
	cmp     edi, 600h ; Counter, starts at 20 (14h)
	jge     0x004BE552
	jmp 	0x004BE54D
	
_Hook_Expansion_Mission_Counterstrike_Caption:
	cmp byte [newmissionsenabled], 1
	je New_Missions_Caption
	
	mov		eax, 0x00607260
	jmp 	0x004BE7CD	
	
New_Missions_Caption:
	mov 	eax, newmissions_str
	jmp 	0x004BE7CD
	
_Hook_Expansion_Mission_Counterstrike_Title:
	cmp byte [newmissionsenabled], 1
	je New_Missions_Title
	
	mov		ebx, 0x00607260
	jmp		0x00501E13
	
New_Missions_Title:
	lea		ebx, [newmissions_str]
	jmp		0x00501E13