@HOOK 0x005BE913 _Print_Sound_Error_Fix_Window_Title

str_redalert db"Red Alert",0

; this function shows a message box with the title "Command & Conquer"
; fix it to show "Red Alert" instead
_Print_Sound_Error_Fix_Window_Title:
    push str_redalert
    jmp  0x005BE918
