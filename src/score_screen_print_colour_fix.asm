@HOOK 0x005431C0 _ScoreClass__Do_GDI_Graph_Force_Font_Colour

_ScoreClass__Do_GDI_Graph_Force_Font_Colour:
    Save_Registers

    push 0Fh
    push 0

    mov  eax, 0x00604C74 ; offset Score_Soviet_Red
    cmp  DWORD [ebp-0xC8], 1
    je   .Soviet_Colour

    mov  eax, 0x00604C54 ; offset Score_Allies_Blue

.Soviet_Colour:

    push eax
    call 0x005CC454; Set_Font_Colour?
    add  esp, 0x0C

    Restore_Registers
    mov  eax, [ebp-0xB8]
    jmp  0x005431C6
