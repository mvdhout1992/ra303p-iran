@HOOK 0x00425BC9 _AnimClass__Do_Atom_Damage
@HOOK 0x00425C26 _AnimClass__Do_Atom_Damage2

_AnimClass__Do_Atom_Damage2:
    cmp  DWORD [UseAtomWhiteScreenEffectInMP], 1
    jz   .Jump_Past

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x00425C43

.Jump_Past:
    jmp  0x00425C2F

_AnimClass__Do_Atom_Damage:
    cmp  DWORD [UseAtomWhiteScreenEffectInMP], 0
    jz   .No_Whiten_Screen_Effect

    mov  ebx, 0x004A765C ; offset Call_Back(void)
    mov  edx, 1Eh
    mov  eax, 0x0066A25C ; offset PaletteClass WhitePalette

    call 0x005BCF44 ; const PaletteClass::Set(int,(*)(void))

.No_Whiten_Screen_Effect:
    cmp  DWORD [UseSinglePlayerAtomDamage], 1
    mov  ecx, 4
    mov  esi, [0x006667EB] ; ds:int RulesClass.AtomDamage
    jz   0x00425BE1

.Normal_Code:
    mov  eax, [0x006667EB] ; ds:int RulesClass.AtomDamage
    jmp  0x00425BCE
