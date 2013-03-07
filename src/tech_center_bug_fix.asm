@HOOK	0x0054EBAC 	_SidebarClass__StripClass__Recalc_Can_Build_Check

; Gets a side based on a country type
; arg: <EAX: country to get side for>
; returns: EAX is 2 if side is Soviet, 0 if Allies
_Side_From_Country:
	cmp		DWORD eax, 2
	je		.Return_Soviet
	cmp		DWORD eax, 4
	je		.Return_Soviet
	cmp		DWORD eax, 9
	je		.Return_Soviet
	
.Return_Allies:
	mov		eax, 0
	retn
	
.Return_Soviet
	mov		eax, 2
	retn
	
_SidebarClass__StripClass__Recalc_Can_Build_Check:
	push	eax
	call    dword [edi+2Ch] ; ObjectTypeClass::Who_Can_Build_Me(int, int, HousesType)
	cmp		DWORD eax, 0
	je		.Ret_Now
	
	pop 	eax

	mov		edx, eax
	mov     eax, [0x00669958]; ds:HouseClass *PlayerPtr
	mov     eax, [eax+3Eh]
	sar     eax, 18h
	call	_Side_From_Country
	mov		ebx, eax
	mov     eax, [0x00669958]; ds:HouseClass *PlayerPtr
	call	0x004D4014 ; const HouseClass::Can_Build(ObjectTypeClass *,HousesType)
	jmp		0x0054EBB9
	
.Ret_Now:
	add		esp, 4
	jmp		0x0054EBB9