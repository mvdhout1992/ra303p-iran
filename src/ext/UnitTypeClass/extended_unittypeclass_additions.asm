; No need to enable this
;@HOOK 0x005814A4 _UnitClass_Should_Crush_It_Crusher_Addition

_UnitClass_Should_Crush_It_Crusher_Addition:
    cmp  BYTE [eax+UnitTypeExt_Crusher], 0 ; Crusher, hooked by extend unit type class code
    jz   0x005814C2 ; Dont_Crush
    jmp  0x005814AD
