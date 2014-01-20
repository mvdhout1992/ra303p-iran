; Remove serial/modem menu dialogs by making "Modem/Serial" button in
; the "Multiplayer Game" menu not do anything

@HOOK 0x00503C20 _Select_MPlayer_Game_Serial_Menu

_Select_MPlayer_Game_Serial_Menu:
    mov  eax, 0
    jmp  0x00503C25
