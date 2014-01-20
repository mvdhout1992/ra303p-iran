; With no tesla zap effect delay the effect doesn't show up most of the time, it's why they probably added it.
; If I remember correctly the Nod Obelisk from C&C1 suffers from it some times not showing up, maybe because
; that game doesn't have the call to Delay(int)

@HOOK 0x005656DD _TechnoClass__Fire_At_No_Tesla_Zap_Effect_Delay

_TechnoClass__Fire_At_No_Tesla_Zap_Effect_Delay:
    cmp  BYTE [noteslazapeffectdelay], 1
    jz   .Dont_Call_Delay

    call 0x005D0F10 ; Delay(int)

.Dont_Call_Delay:
    jmp  0x005656E2
