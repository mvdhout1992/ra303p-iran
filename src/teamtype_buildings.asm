@HOOK 0x0056069C _TeamTypeClass__Read_Add_BuildingTypes_Reading

_TeamTypeClass__Read_Add_BuildingTypes_Reading
	mov     eax, ebx
	call    0x004537B4   ;  StructType BuildingTypeClass::From_Name(char *)
	cmp     al, 0FFh
	jz      .Read_AircraftType
	movsx   eax, al
	call    0x00453A6C   ;  BuildingTypeClass & BuildingTypeClass::As_Reference(StructType) proc near
	jmp     0x005606C4

.Read_AircraftType:
	mov eax, ebx
	call 0x00403EF0; AircraftTypeClass::From_Name(char *)
	jmp 0x005606A3
