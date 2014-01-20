@HOOK 0x00040409D _AircraftTypeClass__Max_Pips_Show_Actual_Max_Pips

_AircraftTypeClass__Max_Pips_Show_Actual_Max_Pips:
    mov  DWORD edx, [eax+0x15E]
    mov  eax, 5

    cmp  eax, edx
    mov  eax, 3
    jg   .Dont_Set_Max_To_Five

    mov  eax, 5

.Dont_Set_Max_To_Five:

    jmp  0x004040A2
