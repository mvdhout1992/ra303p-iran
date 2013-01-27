@HOOK 0x0056C15A _ThemeClass_Track_Length
@HOOK 0x0056C439 _ThemClass_Scan
@HOOK 0x0056C40C _ThemeClass_Scan_Jump_Over
@HOOK 0x0056C115 _ThemeClass_File_Name
@HOOK 0x0056BEA4 _ThemeClass_Full_Name
@HOOK 0x0056BFC4 _ThemeClass_Next_Song_RNG
@HOOK 0x0056BFF8 _ThemeClass_Next_Song_CMP
@HOOK 0x0056BFA3 _ThemeClass_Next_Song_Cond_Jump
@HOOK 0x0055066B _SoundControlsClass_Process
@HOOK 0x0056C240 _ThemeClass_Is_Allowed
@HOOK 0x0056BFEC _ThemeClass_Next_Song_BL_Register_Change
@HOOK 0x0053A36F _Start_Scenario_Queue_Theme
;@HOOK 0x00550668 _SoundControlClass_Process_Jump_Over_Looping_Themes

bigfoot_str db "outtakes.AUD",0
musicini_str db "MUSIC.INI",0
music_array TIMES 400h db 0
str_filenames db "Filenames",0
str_fullnames db "Fullnames",0
str_tracklength db"Tracklength",0
str_showallmusic db"ShowAllMusic",0
str_options2 db"Options",0
str_redalert_ini db"REDALERT.INI",0

FileClass_this3  TIMES 128 db 0
INIClass_this3 TIMES 128 db 0

FileClass_redalertini  TIMES 128 db 0
INIClass_redalertini TIMES 128 db 0

FileClass_Arazoid	TIMES 128 db 0
str_arazoidaud	db "ARAZOID.AUD",0
str_araziodaud	db "ARAZIOD.AUD",0

str_sprintf_format2 db "%d",0

sprintf_buffer   TIMES 64 db 0
str_empty db 0

str_general db "General",0
str_sprintf_format db "%d",0

sprintf_buffer2   TIMES 64 db 0
music_filenames_buffer TIMES 8192 db 0 ; 128 * 32 bytes

str_twincannonremix db "Twin Cannon (Remix)",0
str_underlyingthoughts db "Underlying Thoughts",0
str_voicerhythm2 db "Voice Rhythm 2",0
str_shutit db "Shut It",0
str_chaos db "Chaos",0
str_thesecondhand db"The Second Hand",0
str_backstab db "Backstab",0
str_twincannon db "Twin Cannon",0

%define INIClass__INIClass                          0x004C7C60 
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define INIClass__Get_Bool							0x004F3ACC
%define INIClass__Entry_Count                     	0x004F31BC
%define FileClass__FileClass                        0x004627D4 
%define FileClass__Is_Available                     0x00462A30
%define	INIClass__Get_Textblock						0x004F3528
%define	sprintf_									0x005B8BAA

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Int 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_this3
    CALL INIClass__Get_Int
%endmacro

; args: <section>, <key>, <default>, <dst>, <dst_len>
%macro INI_Get_String 5
    PUSH %5             ; dst len
    PUSH %4             ; dst
    MOV ECX, DWORD %3   ; default
    MOV EBX, DWORD %2   ; key
    MOV EDX, DWORD %1   ; section
    MOV EAX, INIClass_this3
    CALL INIClass__Get_String
%endmacro

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Bool 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_redalertini
    CALL INIClass__Get_Bool
%endmacro
	
; args: <corrected song full name>, <index>
%macro Correct_Song_Index_Name 2
	cmp		dl, %2
	mov		eax, %1
	je		0x0056BEF8
%endmacro

_Start_Scenario_Queue_Theme:
	xor		edx, edx
	cmp		Byte [randomstartingsong], 0
	jz		.Ret
	mov 	eax, INIClass_this3
	mov		edx, str_filenames
	call	INIClass__Entry_Count
	mov     ebx, 26h
	add		ebx, eax
	mov     eax, 0x00667760
	xor     edx, edx
	call    0x005BC960
	mov		edx, eax
	
.Ret:
	mov		eax, 0x00668248
	call    0x0056C020
	jmp		0x0053A376
	
_SoundControlClass_Process_Jump_Over_Looping_Themes:
	sar     edx, 18h
	cmp		edx, 13h
	jz		0x00550662
	cmp		edx, 14h
	jz		0x00550662
	cmp		edx, 15h
	jz		0x00550662
	cmp		edx, 16h
	jz		0x00550662
	
	cmp     edx, 27h
	jge     0x00550727
	jmp		0x00550674

_ThemeClass_Next_Song_BL_Register_Change:
	mov     [ebp-0CH], dl
	jmp     0x0056C013
	
_ThemeClass_Is_Allowed:
	cmp		dl, 13h
	jz		.Ret_False2
	cmp		dl, 14h
	jz		.Ret_False2
	cmp		dl, 15h
	jz		.Ret_False2
	cmp		dl, 16h
	jz		.Ret_False2
	
	push edx
	push edx

	mov eax, [FileClass_redalertini]
	test eax, eax
	jnz .Done_INIClass_Loading
	
	MOV EDX, str_redalert_ini
    MOV EAX, FileClass_redalertini
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_redalertini
    XOR EDX, EDX
    CALL FileClass__Is_Available
;    TEST EAX,EAX
;    JE .exit_error

    ; initialize INIClass
    MOV EAX, INIClass_redalertini
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_redalertini
    MOV EAX, INIClass_redalertini
    CALL INIClass__Load
	
.Done_INIClass_Loading:
	INI_Get_Bool str_options2, str_showallmusic, 1
	pop edx	
	cmp eax, 0
	je .Ret_Original_Function
	
	pop edx
	mov eax, 1
	retn
.Ret_False:
	pop edx
	mov eax, 0
	retn
	
.Ret_False2:
	mov eax, 0
	retn

.Ret_Original_Function:
	pop edx
	
	push    ebp
	mov     ebp, esp
	push    ebx
	push    ecx
	push    esi
	push    edi
	
	jmp		0x0056C247

_ThemeClass_Next_Song_Cond_Jump:
	sar     eax, 18h
	shl     eax, 5
	
	cmp		dl, 26h
	jge		0x0056BFB2
	
	jmp		0x0056BFA9

_ThemeClass_Next_Song_CMP:
	mov     [ebp-0Ch], al
	
	push	ebx
	push	eax
	push	edx
	
	mov 	eax, INIClass_this3
	mov		edx, str_filenames
	call	INIClass__Entry_Count

	mov		ebx, 26h
	add		ebx, eax
	
	pop		edx
	pop		eax
	
	cmp     al, bl
	pop		ebx
	jle     0x0056C002
	
	jmp		0x0056BFFD

_ThemeClass_Next_Song_RNG:

	mov 	eax, INIClass_this3
	mov		edx, str_filenames
	call	INIClass__Entry_Count

	mov     ebx, 26h
	add		ebx, eax
	
	jmp		0x0056BFC9

_SoundControlsClass_Process:
;	cmp		edx, 13h
;	jz		0x00550662
;	cmp		edx, 14h
;	jz		0x00550662
;	cmp		edx, 15h
;	jz		0x00550662
;	cmp		edx, 16h
;	jz		0x00550662
	
	push 	edx
;	push 	ebx
	
	mov 	eax, INIClass_this3
	mov		edx, str_filenames
	call	INIClass__Entry_Count
;	add		ebx, eax
	
	mov		ebx, 26h
	add		ebx, eax
	pop		edx
	cmp     edx, ebx

	jge     0x00550727
	jmp		0x00550674

_ThemeClass_Full_Name:
;	Correct_Song_Index_Name str_twincannon, 17
;	Correct_Song_Index_Name str_thesecondhand, 23
;	Correct_Song_Index_Name str_backstab, 25
;	Correct_Song_Index_Name str_chaos, 26
;	Correct_Song_Index_Name str_shutit, 27
;	Correct_Song_Index_Name str_twincannonremix, 28
;	Correct_Song_Index_Name str_underlyingthoughts, 29
;	Correct_Song_Index_Name str_voicerhythm2, 30
	
;	cmp     dl, 26h
;	jge		Return_Custom_Name
	
	cmp     dl, 27h
	jge     Return_Custom_Name
	
	jmp		0x0056BEA9
	
Return_Custom_Name:
;	mov eax, bigfoot_str

	push edx
	push ebx
	push ecx
	push esi
	push edi

	push edx ; save value of index
	
	mov eax, [FileClass_this3]
	test eax, eax
	jnz .Done_INIClass_Loading
	
	MOV EDX, musicini_str
    MOV EAX, FileClass_this3
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_this3
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
;	JE File_Not_Available ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_this3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_this3
    MOV EAX, INIClass_this3
    CALL INIClass__Load

.Done_INIClass_Loading:	
;	cmp dword [mission_index_counter], 3 ; hard-coded max to read inis
;	jz	Ret_Empty_String2
	
	pop esi ; pop saved value of index into esi
	sub esi, 25h	; substract so we get 1 for the first index..
	push esi
		
	push    esi             ; Format
	push    str_sprintf_format ; %d
	lea     esi, [sprintf_buffer]
	push    esi             ; Dest
	
	call    sprintf_
	add     esp, 0Ch
	
;	mov esi, DWORD newmissions_array
	pop esi ; pop saved value of index-minus 25h (index 1 into ini) into esi
	sub esi, 1 ;need to substract 1 for 0-based indexing for the filenames_buffer
	push esi ; push again for later use
	imul esi, 32
	lea esi, [music_filenames_buffer+esi]
	
	INI_Get_String str_fullnames, sprintf_buffer, str_empty, ESI, 32
	
	pop esi ; get our 0-based indexed index
	imul esi, 32
	lea eax, [music_filenames_buffer+esi]
;	lea eax, [bigfoot_str]
	
	pop edi
	pop esi
	pop ecx
	pop ebx
	pop edx
	
	jmp 0x0056BEF8
	
_ThemeClass_Scan_Jump_Over:
	jmp 0x0056C412

_ThemeClass_Track_Length:
	cmp     eax, 27h
	jnb     .Return_Custom_Length
	jmp		0x0056C15F

.Return_Custom_Length:
	push edx
	push ebx
	push ecx
	push esi
	push edi

	sub 	eax, 25h	; substract so we get 1 for the first index..
	
	push    eax             ; Format
	push    str_sprintf_format ; %d
	lea     esi, [sprintf_buffer]
	push    esi             ; Dest
	
	call    sprintf_
	add     esp, 0Ch

	INI_Get_Int str_tracklength, sprintf_buffer, 0
	
	pop edi
	pop esi
	pop ecx
	pop ebx
	pop edx
	
	mov     esp, ebp
	pop     ebp
	retn
	
_ThemClass_Scan:	
	mov     [ebp-0Ch], dl
	cmp     dl, 100 ; Amount of indexes to scan for?
	jmp		0x0056C43F
	
_ThemeClass_File_Name:
	push    edx
	test    al, al
	jl      0x0056C144
	
	cmp		al, 18h
	je		.Arazoid_Fix
	
	cmp 	al, 27h
	jge Return_Custom_String
;	cmp     al, 27h
;	jge     0x0056C144
	jmp		0x0056C11E
	
.Arazoid_Fix:
	MOV EDX, str_arazoidaud
    MOV EAX, FileClass_Arazoid
    CALL FileClass__FileClass
	
	MOV EAX, FileClass_Arazoid
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
	jnz	.Arazoid
	
	MOV		EAX, str_araziodaud
	JMP		.Ret_Arazoid_Fix
	
.Arazoid:
	MOV		EAX, str_arazoidaud
	JMP		.Ret_Arazoid_Fix

.Ret_Arazoid_Fix:
	lea     esp, [ebp-0Ch]
	pop     edx
	pop     ecx
	pop     ebx
	pop     ebp
	retn

Return_Custom_String:

	push eax ; save value of index
	
	mov eax, [FileClass_this3]
	test eax, eax
	jnz .Done_INIClass_Loading
	
	MOV EDX, musicini_str
    MOV EAX, FileClass_this3
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_this3
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
;	JE File_Not_Available ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_this3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_this3
    MOV EAX, INIClass_this3
    CALL INIClass__Load

.Done_INIClass_Loading:	
;	cmp dword [mission_index_counter], 3 ; hard-coded max to read inis
;	jz	Ret_Empty_String2
	
	pop esi ; pop saved value of index into esi
	sub esi, 25h	; substract so we get 1 for the first index..
	push esi
		
	push    esi             ; Format
	push    str_sprintf_format ; %d
	lea     esi, [sprintf_buffer]
	push    esi             ; Dest
	
	call    sprintf_
	add     esp, 0Ch
	
;	mov esi, DWORD newmissions_array
	pop esi ; pop saved value of index-minus 25h (index 1 into ini) into esi
	sub esi, 1 ;need to substract 1 for 0-based indexing for the filenames_buffer
	push esi
	imul esi, 32
	lea esi, [music_filenames_buffer+esi]
	
	INI_Get_String str_filenames, sprintf_buffer, str_empty, ESI, 32
	
	pop esi ; get our 0-based indexed index
	imul esi, 32
	lea eax, [music_filenames_buffer+esi]
;	mov eax, bigfoot_str
	jmp 0x0056C149
	
File_Not_Available:
	int 3