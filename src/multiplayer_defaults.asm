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
%define CheckListClass__Check_Item					0x004A24D4
%define BasesOrNoBases								0x0067F2BA
%define OreRegenerates								0x0067F2C2
%define	Crates										0x0067F2C6 
%define Special										0x00669908

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

FirstLoad:			db 1
FirstLoad2:			db 1
FirstLoadLAN:		db 1
FirstLoadPlayers:	db 1
FirstLoadPlayers2:	db 1
ConfigMapIndex:		dd 1

bases:				db 1
crates:				db 1
oreregenerates:		db 1
shroudregrows:		db 1
ctf:				db 1

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

@HOOK 0x00535CE6 _RulesClass_Multiplayer_Defaults
@HOOK 0x005136CE _Skirmish_Players_Slider3
@HOOK 0x00513608 _Skirmish_UnitCount_Slider
@HOOK 0x005138A0 _Skirmish_Selected_Map_Index
@HOOK 0x00513163 _Skirmish_Set_AI_Difficulty
@HOOK 0x00513480 _Skirmish_Unit_Count_Change
@HOOK 0x00513554 _Skirmish_Check_Lists
@HOOK 0x00513534 _Skirmish_Add_CTF_Check_List
@HOOK 0x00514AA8 _Skirmish_Check_CTF_Check_List

@HOOK 0x0050BCDD _LAN_Check_Lists
;@HOOK 0x0050C1AE _LAN_Players_Slider3
@HOOK 0x0050CA4D _LAN_UnitCount_Slider
@HOOK 0x0050BC36 _LAN_Unit_Count_Change
@HOOK 0x0050BF87 _LAN_Selected_Map_Index
@HOOK 0x005135AC _Skirmish_Check_CTF_Check_Item

_LAN_Selected_Map_Index:
	lea 	eax, [ebp-684h]
	mov 	edx, [SelectedMapIndex]

	call 	ListClass_Set_Selected_Index

	jmp		0x0050BF8D

_LAN_Unit_Count_Change:
	jmp		0x0050BC3B

_LAN_UnitCount_Slider:
	mov     edx, [UnitCount]
	lea     eax, [ebp-34Ch]
	jmp		0x0050CA55

_LAN_Players_Slider3:
	push	eax
	cmp  byte [FirstLoadPlayers2], 1
	jne .Not_First_Load_Players
	
	mov DWORD [FirstLoadPlayers2], 0
	INI_Get_Int multiplayer_defaults_str, aiplayers_str, 1
	mov DWORD [Players], eax

.Not_First_Load_Players:
	pop		eax
	mov     edx, [Players]
	jmp 	0x0050C1B4

_LAN_Check_Lists:
	lea  	eax, [ebp-7ACh]
	xor		ebx, ebx
	cmp  byte [FirstLoadLAN], 1
	jnz		.Jump_Over_Bases
	mov 	bl, BYTE [bases]
	mov 	[BasesOrNoBases], ebx
.Jump_Over_Bases:
	mov 	ebx, [BasesOrNoBases]
	mov     edx, 0
	call	CheckListClass__Check_Item
	
	lea  	eax, [ebp-7ACh]
	xor		ebx, ebx
	cmp  byte [FirstLoadLAN], 1
	jnz		.Jump_Over_OreRegenerates
	mov		bl, BYTE [oreregenerates]
	mov		[OreRegenerates], ebx
	
.Jump_Over_OreRegenerates:
	mov		 ebx, [OreRegenerates]
	mov     edx, 1
	call	CheckListClass__Check_Item
	
	lea  	eax, [ebp-7ACh]
	xor		ebx, ebx
	cmp  byte [FirstLoadLAN], 1
	jnz		.Jump_Over_Crates
	mov		bl, BYTE [crates]
	mov		[Crates], ebx

.Jump_Over_Crates:
	mov		ebx, [Crates]
	mov     edx, 2
	call	CheckListClass__Check_Item
	mov		byte [FirstLoadLAN], 0
	jmp		0x0050BD1C

_Skirmish_Check_CTF_Check_Item:
	jmp		0x005135B5

_Skirmish_Check_CTF_Check_List:
	mov     edx, 4
	jmp		0x00514AB1

_Skirmish_Add_CTF_Check_List:
	mov     edx, 12Dh
	jmp		0x0051353D

_Skirmish_Check_Lists:
	lea  	eax, [ebp-97Ch]
	xor		ebx, ebx
	cmp  	byte [FirstLoad2], 1
	jnz		.Jump_Over_Bases
	mov 	bl, BYTE [bases]
	mov 	[BasesOrNoBases], ebx
.Jump_Over_Bases:
	mov 	ebx, [BasesOrNoBases]
	mov     edx, 0
	call	CheckListClass__Check_Item
	
	lea  	eax, [ebp-97Ch]
	xor		ebx, ebx
	cmp  byte [FirstLoad2], 1
	jnz		.Jump_Over_OreRegenerates
	mov		bl, BYTE [oreregenerates]
	mov		[OreRegenerates], ebx
	
.Jump_Over_OreRegenerates:
	mov		 ebx, [OreRegenerates]
	mov     edx, 1
	call	CheckListClass__Check_Item
	
	lea  	eax, [ebp-97Ch]
	xor		ebx, ebx
	cmp  byte [FirstLoad2], 1
	jnz		.Jump_Over_Crates
	mov		bl, BYTE [crates]
	mov		[Crates], ebx

.Jump_Over_Crates:
	mov		ebx, [Crates]
	mov     edx, 2
	call	CheckListClass__Check_Item
	
;	lea  	eax, [ebp-97Ch]
;	push	eax
;	xor		ebx, ebx
	
;	and     byte [Special], 0FEh
;	xor		eax, eax
;	cmp  byte [FirstLoad2], 1
;	jnz		.Jump_Over_ShroudRegrows
;	mov		al, BYTE [shroudregrows]
;	and     eax, 1
;	mov     edx, [Special]
;	or      edx, eax

;	mov     [Special], edx
	
;.Jump_Over_ShroudRegrows:
;	mov     ebx, [Special]
;	and     ebx, 1
;	mov     edx, 3
;	pop		eax
;	call	CheckListClass__Check_Item
	
;	lea  	eax, [ebp-97Ch]
;	push	eax
	
;	xor		ebx, ebx
;	cmp  byte [FirstLoad2], 1
;	jnz		.Jump_Over_CTF
;	mov     bh, [Special]
;	and     bh, 0F7h
;	xor		eax, eax
	
;	mov		al, BYTE [ctf]
;	and     eax, 1
;	mov     byte [Special], bh
;	shl     eax, 3
;	or      [Special], eax

;.Jump_Over_CTF:	
;	xor		ebx, ebx
;	mov     ebx, [Special]
;	shl     ebx, 1Ch
;	shr     ebx, 1Fh
;	mov     edx, 4
;	pop		eax
;	call	CheckListClass__Check_Item
	
;	mov		byte [FirstLoad2], 0
;	jmp		0x005135D1
	mov		byte [FirstLoad2], 0
	jmp		0x00513593
	
_Skirmish_Unit_Count_Change:
	jmp 0x00513485

	
_Skirmish_Players_Slider3:
	cmp  byte [FirstLoadPlayers], 1
	jne .Not_First_Load_Players
	
	mov DWORD [FirstLoadPlayers], 0
	INI_Get_Int multiplayer_defaults_str, aiplayers_str, 1
	mov DWORD [Players], eax

.Not_First_Load_Players:
	mov     edx, [Players]
	lea     eax, [ebp-574h]
	jmp 	0x005136D6

_Skirmish_UnitCount_Slider:
	mov		edx, [UnitCount]
	lea     eax, [ebp-4C0h]
	jmp 	0x00513610	

_Skirmish_Selected_Map_Index:
	
	cmp BYTE [FirstLoad], 1
	jne Not_First_Load
	
	MOV BYTE [FirstLoad], 0

Not_First_Load:
	lea 	eax, [ebp-854h]
	mov 	edx, [SelectedMapIndex]

	call 	ListClass_Set_Selected_Index

	xor 	eax, eax
	jmp		0x005138A6
	
_Skirmish_Set_AI_Difficulty:
	
	INI_Get_Int multiplayer_defaults_str, aidifficulty_str, 1
	mov     edx, eax
	jmp		0x00513168
		
_RulesClass_Multiplayer_Defaults:
		push	eax
		push    ebx
		push	edx
		push    ecx
		push    esi
		push    edi

;		mov esi, eax
		
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
		
	INI_Get_Bool multiplayer_defaults_str, shroudregrows_str, 0 ; ShadowGrow
	mov BYTE [shroudregrows], al

	INI_Get_Bool multiplayer_defaults_str, bases_str, 1 ; Bases
	mov BYTE [bases], al

	INI_Get_Bool multiplayer_defaults_str, oreregenerates_str, 1 ; Ore Grows
	mov BYTE [oreregenerates], al

	INI_Get_Bool multiplayer_defaults_str, crates_str, 0 ; Crates
	mov BYTE [crates], al

	INI_Get_Bool multiplayer_defaults_str, capturetheflag_str, 0 ; CaptureTheFlag
	mov BYTE [ctf], al
	
			INI_Get_Bool multiplayer_defaults_str, shroudregrows_str, 0 ; ShadowGrow
;		mov		eax, 0 
		and     [esi+0BDh], dword 0FEh
		and     eax, 1
		mov     edx, [esi+0BDh]
		or      edx, eax

		mov     ecx, edx
		mov     [esi+0BDh], edx

		INI_Get_Bool multiplayer_defaults_str, capturetheflag_str, 0 ; CaptureTheFlag 
		mov     cl, [esi+0BDh]
		and     cl, 0DFh
		and     eax, 1
		mov     [esi+0BDh], cl
		shl     eax, 5
		mov     ebx, [esi+0BDh]
		or      ebx, eax
		mov     eax, 1
		mov     [esi+0BDh], ebx
	
	pop     edi
	pop     esi
	pop     ecx
	pop		edx
	pop     ebx
	pop		eax
		
	mov eax, 1 ; return value
	lea     esp, [ebp-10h]
	pop     edi
	pop     esi
	pop     ecx
	pop     ebx
	pop     ebp
	jmp		0x00535CEE