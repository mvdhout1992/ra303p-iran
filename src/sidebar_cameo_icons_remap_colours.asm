@HOOK   0x0054E863  _StripClass__Draw_It_Colour_Remap_Icon
@HOOK   0x0054E871  _StripClass__Draw_it_Dont_Destroy_EAX

_StripClass__Draw_it_Dont_Destroy_EAX:
    mov     ecx, [ebp-0x1C]
    jmp     0x0054E87B

_StripClass__Draw_It_Colour_Remap_Icon:
    mov     edx, 0
    mov     ebx, 1
    mov     eax, 0 ; just to be sure
    
    cmp     BYTE [colorremapsidebarcameoicons], 0
    jz      .No_Colour_Remap
    
    mov     eax, [0x00669958] ; HouseClass *PlayerPtr
    call    0x004D6528 ; const HouseClass::Remap_Table(int,RemapType)
    
.No_Colour_Remap:
    push    eax
    test    eax, eax
    jz      0x0054E86F
    jmp     0x0054E868