@HOOK 0x005293EF _Queue_AI_Multiplayer_Mid_Game_Reconnect_Time
@HOOK 0X005291EA _Queue_AI_Multiplayer_Game_Start_Reconnect_Time

_Queue_AI_Multiplayer_Mid_Game_Reconnect_Time:
    push esi             ; __int32
    mov  edx, [ebp-0x1C]
    push 1020    ; 17 seconds, 2 for time out period
    jmp  0x005293F4

_Queue_AI_Multiplayer_Game_Start_Reconnect_Time:
;    push    7200    ; 7200 / 60 = 120 seconds
    push 1620 ; 1500 / 60 = 25 seconds, put it to 1620 for the 2 sec time out period
    jmp  0x005291EF
