@HOOK 0x0049FE2C _CellCass__Reduce_Tiberium_Last_Longer

ReduceEveryOneCell dd 0

; NOTE THIS FILE IS ONLY FOR TESTING AND COMMENTED OUT IN MAIN.ASM

_CellCass__Reduce_Tiberium_Last_Longer:
    cmp  BYTE [SessionClass__Session], 5
    jnz  .Normal_Code

    cmp  DWORD [ReduceEveryOneCell], 0
    jz   .Custom_Reduce

    mov  DWORD [ReduceEveryOneCell], 0

.Normal_Code:
    inc  ebx
    cmp  ebx, edx
    jle  0x0049FE3D
    jmp  0x0049FE31

.Custom_Reduce:
    mov  DWORD [ReduceEveryOneCell], 1
    mov  ebx, 1
    jmp  0x0049FE4F
