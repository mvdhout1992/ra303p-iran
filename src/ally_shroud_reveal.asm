@HOOK   0x004B07E0  _DisplayClass__Map_Cell_Share_Shroud

_DisplayClass__Map_Cell_Share_Shroud:
    cmp		BYTE [SessionClass__Session], 0
    jz     .Shroud_Share
    
    cmp		BYTE [SessionClass__Session], 5
    jz     .Shroud_Share
    
    jmp     .No_Shroud_Share
    
.Shroud_Share:
    jmp     0x004B07E9

.No_Shroud_Share:    
    jmp     0x004B0800