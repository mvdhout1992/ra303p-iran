@HOOK 0x004D4C79 _HouseClass__AI_Is_House_Multiplayer_Defeated_Check

_HouseClass__AI_Is_House_Multiplayer_Defeated_Check:
    cmp  BYTE [shortgame], 1
    jz   .Short_Game

    cmp  dword [eax+13Bh], 0 ; Does player still have buildings left?
    jmp  0x004D4C80

.Short_Game:
    cmp  dword [eax+13Bh], 0 ; Does player still have buildings left?
    jnz  0x004D4CB4
    cmp  dword [eax+0x482], 0 ; Does player still have an MCV left?
    jnz  0x004D4CB4

    call 0x004D8814  ; HouseClass::Blowup_All(void)

    mov  eax, [ebp-0x58] ; move HouseClass this pointer into eax again
    call 0x004D8270  ; HouseClass::MPlayer_Defeated(void)

    jmp  0x004D4CB4
