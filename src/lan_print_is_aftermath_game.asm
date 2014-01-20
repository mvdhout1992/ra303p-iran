@HOOK 0x0050C2B0 _LAN_New_Dialog_Aftermath_Text
@HOOK 0x0050C748 _LAN_New_Dialog_Aftermath_Text2
@HOOK 0x0050DB55 _LAN_New_Dialog_Aftermath_Text3

%define    Fancy_Text_Print 0x004AE7FC
%define bAftermathMultiplayer 0x00680538

;str_aftermathgame db "Aftermath game",0

startedasam: db 0

_LAN_New_Dialog_Aftermath_Text:
    call Fancy_Text_Print
    add  esp, 18h

    cmp  DWORD [bAftermathMultiplayer], 1
    jnz  .Ret

    MOV  BYTE [startedasam], 1
    push 216h
    push 0
    mov  eax, [ebp-70h]
    push eax
    mov  edx, 195 ; Decimal
    push edx
    mov  ebx, 200 ; Decimal
    push ebx
    push 74h
    call Fancy_Text_Print
    add  esp, 18h

.Ret:
    jmp  0x0050C2B8

_LAN_New_Dialog_Aftermath_Text2:
    cmp  DWORD [bAftermathMultiplayer], 1
    jz   .Ret
    CMP  BYTE [startedasam], 1
    jnz  .Ret

    push 216h
    push 0
    mov  eax, [ebp-70h]
    push eax
    mov  edx, 195 ; Decimal
    push edx
    mov  ebx, 260 ; Decimal
    push ebx
    push 79h
    call Fancy_Text_Print
    add  esp, 18h

.Ret:
    mov  edx, [0x00680875]
    jmp  0x0050C74E

_LAN_New_Dialog_Aftermath_Text3:
    mov  eax, [ebp-08Ch]
    MOV  BYTE [startedasam], 1
    jmp  0x0050DB5B
