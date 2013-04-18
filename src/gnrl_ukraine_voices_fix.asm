@HOOK   0x004EF7B5  _InfantryClass__Response_Move_GNRL_Is_Soviet
@HOOK   0x004EF554  _InfantryClass__Response_Select_GNRL_Is_Soviet
@HOOK   0x004EFA1D  _InfantryClass__Response_Attack_GNRL_Is_Soviet

_InfantryClass__Response_Attack_GNRL_Is_Soviet
    cmp     dl, 2
    jz      0x004EFA33
    cmp     dl, 4
    jz      0x004EFA33
    jmp     0x004EFA22

_InfantryClass__Response_Select_GNRL_Is_Soviet:
    cmp     dl, 2
    jz      0x004EF56A
    cmp     dl, 4
    jz      0x004EF56A
    jmp     0x004EF559

_InfantryClass__Response_Move_GNRL_Is_Soviet:
    cmp     dl, 2
    jz      0x004EF7CB
    cmp     dl, 4
    jz      0x004EF7CB
    jmp     0x004EF7BA