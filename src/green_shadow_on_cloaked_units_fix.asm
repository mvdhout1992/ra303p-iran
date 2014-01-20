@HOOK 0x005672D9 _Green_Shadow_On_Cloaked_Units_Fix

_Green_Shadow_On_Cloaked_Units_Fix:

    push 0x00657EE4
    MOV  ESI, DWORD [EBP-24h]
    push esi
    MOV  EAX,DWORD [EBP+9h]
    push 1130h
    jmp  0x005672EA
