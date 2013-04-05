@HOOK 0x004DAFA4	_AI_Tech_Up_Check
@HOOK 0x004D6102	_HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out
@HOOK 0x004DE5D2	_HouseClass__Is_Allowed_To_Ally_AI_Player_Fix
@HOOK 0x004BD1DD 	_EventClass__Execute_Make_Ally
@HOOK 0x004DDA71	_Fix_AI_Attacking_Top_Left_Bug
@HOOK 0x004DDA00	_Fix_AI_Attacking_Top_Left_Bug2
@HOOK 0x004D84C4    _HouseClass__MPlayer_Defeated_Check_AI_Allies
@HOOK 0x004DE640    _HouseClass__Computer_Paranoid_Force_Disabled_Skirmish

%define HouseClass__Where_To_Go 			0x004DD9FC
%define DriveClass__Assign_Destination 		0x004B67C8

_HouseClass__Computer_Paranoid_Force_Disabled_Skirmish:
    cmp		BYTE [SessionClass__Session], 5
    jnz      .Normal_Ret
    
    cmp     BYTE [computerparanoidforcedisabledskirmish], 1
    jnz     .Normal_Ret
    
    retn

.Normal_Ret:
    push    ebp
    mov     ebp, esp        ; hooked by patch
    push    ebx
    push    ecx
    jmp     0x004DE645

_HouseClass__MPlayer_Defeated_Check_AI_Allies:
    cmp		BYTE [SessionClass__Session], 5
    jz      .Ret

    test    BYTE [eax+42h], 2
    jz      0x004D84CD
.Ret:
    jmp     0x004D84CA

_Fix_AI_Attacking_Top_Left_Bug2:
	cmp		BYTE [SessionClass__Session], 5
	je		.Apply_Fix_For_Skirmish

	cmp		BYTE [fixaisendingtankstopleft], 1
	jnz		.Original_Code

.Apply_Fix_For_Skirmish:
	
	push    ecx
	
	push	eax
	push	edx
	
	mov     ecx, eax
	mov     eax, edx
	jmp		0x004DDA05
	
.Original_Code:
	push    ecx
	
	mov     ecx, eax
	mov     eax, edx
	jmp		0x004DDA05
	
_Fix_AI_Attacking_Top_Left_Bug:
	cmp		BYTE [SessionClass__Session], 5
	je		.Apply_Fix_For_Skirmish

	cmp		BYTE [fixaisendingtankstopleft], 1
	jnz		.Original_Code
	
.Apply_Fix_For_Skirmish:

	call	0x004FFAC4 ;  const MapClass::Nearby_Location(short,SpeedType,int,MZoneType)
	cmp		eax, 0
	jz		.Recursive_Call_Where_To_Go
	
	add		esp, 8
	jmp		0x004DDA76 
	
.Recursive_Call_Where_To_Go:
	pop		edx
	pop		eax
	call	0x004DD9FC ; short const HouseClass::Where_To_Go(FootClass *)
	lea     esp, [ebp-8]
	pop     ecx
	pop     ebx
	pop     ebp
	retn
	
.Original_Code:
	call	0x004FFAC4 ;  const MapClass::Nearby_Location(short,SpeedType,int,MZoneType)
	jmp		0x004DDA76 

_EventClass__Execute_Make_Ally:
	push	eax
	push	edx
	call 	0x004D6060
	
	cmp		BYTE [SessionClass__Session], 5
	je		.Apply_Fix_For_Skirmish
	
	cmp BYTE [fixaially], 0
	jz		.Ret
	
.Apply_Fix_For_Skirmish:
	
	pop		eax ; Pop registers in reverse order, HouseType
	call	0x004D2CB0 ; HouseClass::As_Pointer(HousesType)
	mov		ecx, eax  ; now contains new HouseClass
	pop		eax ; HouseClass
	push	ecx
	call	0x004D2C48
	mov		edx, eax ; now contains new HouseType
	pop		eax		; now conains new HouseClass
	
	call 	0x004D6060	
	jmp		0x004BD1E2
	
.Ret:
	add 	esp, 8
	jmp 	0x004BD1E2

_HouseClass__Is_Allowed_To_Ally_AI_Player_Fix:
	cmp		BYTE [SessionClass__Session], 5
	je		.Allow_AI_Ally

	cmp BYTE [fixaially], 1
	jz		.Allow_AI_Ally
	

	cmp		DWORD eax, 0
	jz		0x004DE5D8
	test    byte [eax+42h], 2
	jnz     0x004DE5E2 ; Assemble JMP here to fix?
	jmp		0x004DE5D8

.Allow_AI_Ally:
	jmp		0x004DE5E2

_HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out:
	cmp		BYTE [SessionClass__Session], 5
	je		.Jump_Over

	cmp BYTE [fixaiparanoid], 1
	jz		.Jump_Over
	
	call	0x004DE640 ; call HouseClass::Computer_Paranoid()

.Jump_Over:
	jmp		0x004D6107 ; Jump over

_AI_Tech_Up_Check:
	jnz		0x004DB0E4
	
	cmp		BYTE [SessionClass__Session], 5
	je		.No_Techup_Check
	
	cmp BYTE [removeaitechupcheck], 1
	jz		.No_Techup_Check
	
	jmp		0x004DAFAA
	
.No_Techup_Check:
	jmp		0x004DAFB7