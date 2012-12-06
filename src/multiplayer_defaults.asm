%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_Bool							0x004F3ACC
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30
%define BuildLevel									0x006016C8
%define UnitCount									0x0067F2CE
%define UnitCountNoBases							0x00604CE0
%define Players										0x0067F2D2
%define SelectedMapIndex							0x0067F2B6
%define ListClass_Set_Selected_Index				0x004FCC40

redalert_ini   db "REDALERT.INI", 0
multiplayer_defaults_str db "MultiplayerDefaults",0
money_str db "Money",0
shroudregrows_str db "ShroudRegrows",0
capturetheflag_str db "CaptureTheFlag",0
crates_str db "Crates",0
bases_str db "Bases",0
oreregenerates_str db "OreRegenerates",0
unitcount_str db "UnitCount",0
techlevel_str db "TechLevel",0
aidifficulty_str db "AIDifficulty",0
aiplayers_str db "AIPlayers",0
mapindex_str db "MapIndex",0

FirstLoad:      db 1
FirstLoadPlayers:      db 1
ConfigMapIndex:      dd 1

; sizes not actually verified
FileClass_this  TIMES 128 db 0
INIClass_this   TIMES 64 db 0

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Int 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_this
    CALL INIClass__Get_Int
%endmacro

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Bool 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_this
    CALL INIClass__Get_Bool
%endmacro

@HOOK 0x00535B64 _RulesClass_Multiplayer_Defaults
;@HOOK 0x005136CE _Skirmish_Players_Slider
;@HOOK 0x0051480E _Skirmish_Players_Slider2
@HOOK 0x005136CE _Skirmish_Players_Slider3
@HOOK 0x00513608 _Skirmish_UnitCount_Slider
@HOOK 0x005138A0 _Skirmish_Selected_Map_Index
@HOOK 0x00513163 _Skirmish_Set_AI_Difficulty
;@HOOK 0x005146FE _Skirmish_Selected_Map_Jump_Over
@hook 0x00513480 _Skirmish_Unit_Count_Change
;@hook 0x00513699 _Skirmish_AI_Players_Count_Change

;_Skirmish_AI_Players_Count_Change:
;
;	jmp		0x0051369E

_Skirmish_Unit_Count_Change:
;	mov DWORD[ebp-48Ch], 3
	jmp 0x00513485

_Skirmish_Players_Slider:
	mov DWORD [Players], 3
;	mov     edx, 3
;	mov     edx, [Players]
	lea     eax, [ebp-574h]
	jmp 	0x005136D6
	
_Skirmish_Players_Slider2:	
	mov DWORD [Players], 8
	;	mov     edx, 2
;	mov     edx, [Players]
	lea     eax, [ebp-574h]
	jmp 	0x00514816
	
_Skirmish_Players_Slider3:
	cmp  byte [FirstLoadPlayers], 1
	jne Not_First_Load_Players
	
	mov DWORD [FirstLoadPlayers], 0
	INI_Get_Int multiplayer_defaults_str, aiplayers_str, 1
	mov DWORD [Players], eax

Not_First_Load_Players:
	mov     edx, [Players]
	lea     eax, [ebp-574h]
	jmp 	0x005136D6

_Skirmish_UnitCount_Slider:
;	mov		DWORD [UnitCount], 100
;	mov 	edx, 100
	mov		edx, [UnitCount]
	lea     eax, [ebp-4C0h]
	jmp 	0x00513610	

_Skirmish_Selected_Map_Index:
	
	cmp BYTE [FirstLoad], 1
	jne Not_First_Load
	
	MOV BYTE [FirstLoad], 0
;	INI_Get_Int multiplayer_defaults_str, mapindex_str, 2
;	mov DWORD [SelectedMapIndex], eax

Not_First_Load:
	lea 	eax, [ebp-854h]
	mov 	edx, [SelectedMapIndex]

	call 	ListClass_Set_Selected_Index

	xor 	eax, eax
	jmp		0x005138A6
	
;_Skirmish_Selected_Map_Jump_Over:
;	jmp		0x00514703
	
_Skirmish_Set_AI_Difficulty:
	
	INI_Get_Int multiplayer_defaults_str, aidifficulty_str, 1
	mov     edx, eax
	jmp		0x00513168
		
_RulesClass_Multiplayer_Defaults:
		push    ebp
		mov     ebp, esp
		push    ebx
		push    ecx
		push    esi
		push    edi

		mov esi, eax
		
	; initialize FileClass
    MOV EDX, redalert_ini
    MOV EAX, FileClass_this
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_this
    XOR EDX, EDX
    CALL FileClass__Is_Available
;    TEST EAX,EAX
;    JE .exit_error

    ; initialize INIClass
    MOV EAX, INIClass_this
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_this
    MOV EAX, INIClass_this
    CALL INIClass__Load
	
	
	INI_Get_Int multiplayer_defaults_str, unitcount_str, 0
	mov	DWORD [UnitCount], eax
	INI_Get_Int multiplayer_defaults_str, techlevel_str, 10
	mov DWORD [BuildLevel], eax

	INI_Get_Int multiplayer_defaults_str, money_str, 10000
		mov dword [esi+0B5h], eax ; Money
		mov dword [esi+0B9h], 10000 ; MaxMoney, used as the max on the Credits slider
		; modifying MaxMoney causes network desync

		; Hurrpp bitfields are fun and so useful, for the following 1 = true (enable), 0 = false (disable)
		mov     ecx, [esi+0BDh]
		and     ecx, 1
		INI_Get_Bool multiplayer_defaults_str, shroudregrows_str, 0 ; ShadowGrow
;		mov		eax, 0 
		and     [esi+0BDh], dword 0FEh
		and     eax, 1
		mov     edx, [esi+0BDh]
		or      edx, eax

		mov     ecx, edx
		mov     [esi+0BDh], edx
		shl     ecx, 1Eh
		shr     ecx, 1Fh

		INI_Get_Bool multiplayer_defaults_str, bases_str, 1 ; Bases
;		mov eax, 1 
		mov     dh, [esi+0BDh]
		and     dh, 0FDh
		and     eax, 1
		mov     [esi+0BDh], dh
		add     eax, eax
		mov     ebx, dword [esi+0BDh]
		or      ebx, eax
		mov     ecx, ebx
		mov     eax, edi
		mov     [esi+0BDh], ebx
		shl     ecx, 1Dh
		shr     ecx, 1Fh
		
		INI_Get_Bool multiplayer_defaults_str, oreregenerates_str, 1 ; Ore Grows
;		mov eax, 1 
		mov     bl, [esi+0BDh]
		and     bl, 0FBh
		and     eax, 1
		mov     [esi+0BDh], bl
		shl     eax, 2
		mov     ecx, [esi+0BDh]
		or      ecx, eax
		mov     [esi+0BDh], ecx
		shl     ecx, 1Ch
		mov     eax, edi
		shr     ecx, 1Fh
		INI_Get_Bool multiplayer_defaults_str, crates_str, 0 ; Crates
;		mov	  eax, 0
		mov     bh, [esi+0BDh]
		and     bh, 0F7h
		and     eax, 1
		mov     [esi+0BDh], bh
		shl     eax, 3
		mov     edx, [esi+0BDh]
		or      edx, eax
		mov     ecx, edx
		mov     eax, edi
		mov     [esi+0BDh], edx
		shl     ecx, 1Ah
		shr     ecx, 1Fh
		INI_Get_Bool multiplayer_defaults_str, capturetheflag_str, 0 ; CaptureTheFlag
;		mov	  eax, 0 
		mov     cl, [esi+0BDh]
		and     cl, 0DFh
		and     eax, 1
		mov     [esi+0BDh], cl
		shl     eax, 5
		mov     ebx, [esi+0BDh]
		or      ebx, eax
		mov     eax, 1
		mov     [esi+0BDh], ebx

		mov eax, 1 ; return value

		pop     edi
		pop     esi
		pop     ecx
		pop     ebx
		mov     esp, ebp
		pop     ebp
		RETN