@HOOK	0x004BE468 		_Custom_Missions_Load_Mission_Name
@HOOK	0x004BE491 		_Custom_Missions_Load_Mission_Name2
@HOOK	0x004BE929		_Custom_Missions_Hook_Function_End
@HOOK	0x004BE548		_Custom_Missions_Amount_To_Read
@HOOK	0x004BE732		_Custom_Missions_Amount_To_Read2
@HOOK	0x004BE132		_Custom_Missions_Dont_Prepend_Side
@HOOK	0x004BE147		_Custom_Missions_Dont_Prepend_Side2
@HOOK	0x00501E0E		_Custom_Missions_Custom_Missions_Button_Name
@HOOK	0x004BE7C8		_Custom_Missions_Custom_Missions_Dialog_Name
@HOOK	0x004BE7DE		_Custom_Missions_Expansion_Missions_Dialog_Name
@HOOK	0x00501E3F		_Custom_Missions_Expansion_Missions_Button_Name
@HOOK	0x0053D6AA 		_Custom_Missions_Load_Map_Specific_Tutorial_Text
@HOOK	0x00501DB3		_Custom_Missions_Enable_Custom_Missions_Button
@HOOK	0x00501DDB		_Custom_Missions_Enable_Expansion_Missions_Button

%define	strdup_		0x005C3900

str_sprintf_format3 db "cmu%dea",0
str_s_format  db "%s",0
sprintf_buffer3 TIMES 512 db 0
sprintf_key_buffer TIMES 512 db 0
strdup_text_buffer TIMES 512 db 0
MissionCounter	dd	0
tutorial_text_buffer  TIMES 512 db 0
FileClass_TutorialText  TIMES 128 db 0
INIClass_TutorialText TIMES 128 db 0

str_custommissions db "Custom Missions",0
str_expansionissions db "Expansions Missions",0
str_tutorialFile db "TutorialFile",0

_Custom_Missions_Enable_Expansion_Missions_Button:
	call	0x004BE090 ;  Expansion_CS_Present(void)
	cmp		eax, 1
	jz		.Return_True
	
	call	0x004BE09C ;  Expansion_AM_Present(void)
	cmp		eax, 1
	jz		.Return_True
	
	mov 	eax, 0
	jmp		0x00501DE0
	
.Return_True:
	mov 	eax, 1
	jmp		0x00501DE0

_Custom_Missions_Enable_Custom_Missions_Button:
	mov		eax, 1
	jmp		0x00501DB8	

_Custom_Missions_Load_Map_Specific_Tutorial_Text:
	Save_Registers

	PUSH 512             ; dst len
    PUSH tutorial_text_buffer             ; dst
    MOV ECX, 0x005EC00F   ; default, "TUTORIAL.INI"
    MOV EBX, str_tutorialFile   ; key, "TutorialFile"
    MOV EDX, 0x005EFFA5  ; section, "Basic"
	lea     eax, [ebp-8Ch] ; ScenarioFileClass
    CALL INIClass__Get_String
	
	mov eax, [FileClass_TutorialText]
	test eax, eax
	
	MOV EDX, tutorial_text_buffer
    MOV EAX, FileClass_TutorialText
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_TutorialText
    XOR EDX, EDX
;	JE File_Not_Available ; on file not available

    ; initialize INIClass
    MOV EAX, INIClass_TutorialText
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_TutorialText
    MOV EAX, INIClass_TutorialText
    CALL INIClass__Load
	
	xor		edi, edi
	xor		esi, esi
	jmp		.LoopStart
	
.Loop:
	inc     edi
	add     esi, 4
	cmp     edi, 0E1h
	jge     .Out
	
.LoopStart:
	push    edi             ; Format
	push    0x005EC01C    ; "%d"
	mov    eax, sprintf_key_buffer
	xor     ecx, ecx
	push    eax             ; Dest
	MOV 	DWORD [ESI+0x666304], ECX
	call    sprintf_

	add     esp, 0Ch
	mov    ebx, sprintf_key_buffer
	push    80h
	mov    eax, strdup_text_buffer
	mov     edx, 0x005EC020 ; "Tutorial"
	push    eax
	mov     ecx, 0x005EC01F ; offset empty_string
	mov     eax, INIClass_TutorialText
	CALL INIClass__Get_String
	test    eax, eax
	jz      .Loop
	mov     eax, strdup_text_buffer
	call    strdup_
	MOV 	DWORD [ESI+0x666304],EAX
	jmp     .Loop

.Out:
	Restore_Registers
	lea     edx, [ebp-8Ch]
	jmp		0x0053D6B0

_Custom_Missions_Expansion_Missions_Button_Name
	mov		ebx, str_expansionissions
	jmp		0x00501E44

_Custom_Missions_Expansion_Missions_Dialog_Name:
	mov		eax, str_expansionissions
	jmp		0x004BE7E3

_Custom_Missions_Custom_Missions_Dialog_Name
	mov		eax, str_custommissions
	jmp		0x004BE7CD

_Custom_Missions_Custom_Missions_Button_Name:
	mov		ebx, str_custommissions
	jmp		0x00501E13

_Custom_Missions_Load_Mission_Name:
	cmp		DWORD [ebp-24h], 0 ; Expansion type
	jz		.Do_Normal_Read
	
	Save_Registers
	mov		esi, DWORD [MissionCounter]
	inc		DWORD [MissionCounter]
	push    esi             ; Format
	push    str_sprintf_format3 ; %d
	lea     esi, [sprintf_buffer3]
	push    esi             ; Dest
	
	call    sprintf_
	add     esp, 0Ch
	Restore_Registers
	mov		esi, sprintf_buffer3
	jmp		0x004BE46E
	
.Do_Normal_Read:
	MOV ESI, DWORD [ESI+0x601400]
	jmp		0x004BE46E
	
_Custom_Missions_Load_Mission_Name2:
	cmp		DWORD [ebp-24h], 0 ; Expansion type
	jz		.Do_Normal_Read
	mov		esi, sprintf_buffer3
	jmp		0x004BE497

.Do_Normal_Read:	
	MOV ESI, DWORD [ESI+0x601400]
	jmp		0x004BE497
	
_Custom_Missions_Hook_Function_End:
	mov		DWORD [MissionCounter], 0
	pop     edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	pop     ebp
	retn
	
_Custom_Missions_Amount_To_Read:
	cmp		DWORD [ebp-24h], 0 ; Expansion type
	jz		.Not_Custom_Missions_Dialog
	
	cmp     edi, 999h
	jge     0x004BE552
	jmp		0x004BE54D

.Not_Custom_Missions_Dialog:
	mov		ebx, 0
	
	call	0x004BE090 ;  Expansion_CS_Present(void)
	cmp		eax, 1
	jz		.CS_Present
	
	mov		ebx, 24h
	
.CS_Present:
	mov		eax, ebx
	cmp     edi, eax
	jge     0x004BE552
	jmp		0x004BE54D
	
_Custom_Missions_Amount_To_Read2:	
	mov     [ebp-30h], ecx
	
	cmp		DWORD [ebp-24h], 0 ; Expansion type
	jz		.Not_Custom_Missions_Dialog
	
	cmp     ecx, 900h
	jmp		0x004BE738 
	
.Not_Custom_Missions_Dialog:
	mov		ebx, 36h

	call	0x004BE09C ;  Expansion_AM_Present(void)
	cmp		eax, 1
	jz		.AM_Present

	mov		ebx, 24h
	
.AM_Present:
	mov		eax, ebx
	cmp     ecx, eax
	jmp		0x004BE738 
	
_Custom_Missions_Dont_Prepend_Side:
	push    str_s_format      ; "%s"
	jmp		0x004BE138
	
_Custom_Missions_Dont_Prepend_Side2:
	mov     ax, [edi+2Ch]
	add     esp, 0Ch
	jmp		0x004BE14E