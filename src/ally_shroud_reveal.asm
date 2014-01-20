@HOOK 0x004B07E0 _DisplayClass__Map_Cell_Share_Shroud
@HOOK 0x00561385 _TechnoClass__Revealed_Reveal_Other_Player_Buildings

_TechnoClass__Revealed_Reveal_Other_Player_Buildings:
    push ebx
    push eax
    push edx

    mov  ebx, [esi+11h]
    mov  eax, esi
    xor  edx, edx
    call DWORD [ebx+98h]

    pop  edx
    pop  eax
    pop  ebx

    cmp  DWORD [0x00669914], 1
    jmp  0x00561392

_DisplayClass__Map_Cell_Share_Shroud:
    cmp  BYTE [SessionClass__Session], 0
    jz   .Shroud_Share

    cmp  BYTE [SessionClass__Session], 5
    jz   .Shroud_Share

    cmp  BYTE [allyreveal], 1
    jz   .Shroud_Share

    jmp  .No_Shroud_Share

.Shroud_Share:
    jmp  0x004B07E9

.No_Shroud_Share:
    jmp  0x004B0800
