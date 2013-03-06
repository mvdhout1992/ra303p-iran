@HOOK	0x004DBD3D	_HouseClass__AI_Vessel_Remove_Multiplayer_AI_Disable_Jump
@HOOK	0x004DBD95	_HouseClass__AI_Vessel_Can_Build_Force_True
@HOOK	0x004DC11E	_HouseClass__AI_Vessel_Fix_Crash
@HOOK	0x004DBD10	_HouseClass__AI_Vessel_Fix_Crash2

VesselAIHouseClassPointer dd 0

_HouseClass__AI_Vessel_Remove_Multiplayer_AI_Disable_Jump:
	jmp		0x004DBD43
	
_HouseClass__AI_Vessel_Can_Build_Force_True
		mov		eax, 1
		jmp		0x004DBD9A
		
_HouseClass__AI_Vessel_Fix_Crash:
	mov		DWORD eax, [VesselAIHouseClassPointer]
	test    byte [eax+42h], 20h
	jmp		0x004DC125
	
_HouseClass__AI_Vessel_Fix_Crash2:
	sub     esp, 44h
	mov     [ebp-20h], eax
	mov		DWORD [VesselAIHouseClassPointer], eax
	jmp		0x004DBD16