@HOOK 0x0058FF40 _Change_Weapon_Sounds

_Change_Weapon_Sounds:
    call 0x00463428

    cmp  BYTE [esi], 12
    jz   .Modify_Grenade_Sound

    cmp  BYTE [esi], 9
    jz   .Modify_Rifle_Sound

.No_Change:
    jmp  0x0058FF45

.Modify_Grenade_Sound:
    cmp  BYTE [usegrenadethrowingsound], 1
    jnz  .No_Change

    mov  WORD [esi+23h], 41
    jmp  0x0058FF49

.Modify_Rifle_Sound:
    cmp  BYTE [alternativeriflesound], 1
    jnz  .No_Change

    mov  WORD [esi+23h], 56
    jmp  0x0058FF49
