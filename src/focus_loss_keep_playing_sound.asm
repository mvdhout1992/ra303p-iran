@HOOK 0x005B3491 _Focus_Loss
;@HOOK 0x005B3624 _Check_For_Focus_Loss
;@HOOK 0x005BF220 _Attempt_Audio_Restore

; Fixes the "music changes when alt+tabbing out" bug for some reason
_Focus_Loss:
    jmp  0x005B349B

_Check_For_Focus_Loss:
    mov  ebp, 800000
    mov  eax, 0
    retn

_Attempt_Audio_Restore:
    retn
