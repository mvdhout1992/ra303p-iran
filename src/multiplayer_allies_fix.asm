;@HOOK	0x0053DC0B	_Read_Scenario_INI_Ally_Test

_Read_Scenario_INI_Ally_Test:
	call    0x0053DED4  ; Assign_Houses(void)
	
	Save_Registers
	
	; Have Multi1 ally Multi2
	mov		eax, 0x0c ; Multi1
	call	0x004D2CB0 ; HouseClass::As_Pointer()
	mov		edx, 0x0d	; Multi 2
	call	0x004D6060 ; HouseClass::Make_Ally(HousesType)
	
	; Have Multi2 ally Multi1
	mov		eax, 0x0d ; Multi2
	call	0x004D2CB0 ; HouseClass::As_Pointer()
	mov		edx, 0x0c	; Multi 1
	call	0x004D6060 ; HouseClass::Make_Ally(HousesType)
	
	Restore_Registers
	
	jmp		0x0053DC10
	
	
	