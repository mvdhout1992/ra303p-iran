;keep a global flag telling telling the cnc-ddraw version patched by me (iran) to video stretch or not
;use the unused 'Processor' byte at 0x00607D78, this is supposed to be used to store CPU procressor info
;but isn't actually used

@HOOK 0x0053AF3B _Campaign_Do_Win_ScoreClass__Presentation
@HOOK 0x0053B037 _Campaign_Do_Win_Map_Selection
@HOOK 0x0053ADF6 _Campaign_Do_Win_Multiplayer_Score_Presentation
@HOOK 0x0053B3E6 _Do_Win_Multiplayer_Score_Presentation
@HOOK 0x0053B6CF _Do_Lose_Multiplayer_Score_Presentation

%define __processor 0x00607D78

_Campaign_Do_Win_ScoreClass__Presentation:
    mov  BYTE [__processor], 1

    call 0x00540670    ; ScoreClass::Presentation()
    mov  BYTE [__processor], 0
    JMP  0x0053AF40

_Campaign_Do_Win_Map_Selection:
    mov  BYTE [__processor], 1

    call 0x00500A68    ; Map_Selection()
    mov  BYTE [__processor], 0
    JMP  0x0053B03C

_Campaign_Do_Win_Multiplayer_Score_Presentation:
    mov  BYTE [__processor], 1

    call 0x00546678    ; Multiplayer_Score_Presentation()
    mov  BYTE [__processor], 0
    JMP  0x0053ADFB

_Do_Win_Multiplayer_Score_Presentation:
    mov  BYTE [__processor], 1

    call 0x00546678    ; Multiplayer_Score_Presentation()
    mov  BYTE [__processor], 0
    JMP  0x0053B3EB

_Do_Lose_Multiplayer_Score_Presentation:
    mov  BYTE [__processor], 1

    call 0x00546678    ; Multiplayer_Score_Presentation()
    mov  BYTE [__processor], 0
    JMP  0x0053B6D4
