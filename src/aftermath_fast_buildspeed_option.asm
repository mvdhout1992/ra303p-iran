;reads the keyword boolean AftermathFastBuildSpeed from the section [Aftermath] in rules.ini to enable quick build spede with the Aftermath expansion enabled (it's normally disabled if the expansion is enabled)

@HOOK 0x005611F3 _Time_To_Build_NewUnitsEnabled_Check

FileClass_rulesini TIMES 128 db 0
INIClass_rulesini TIMES 128 db 0
str_rules_ini db "RULES.INI",0
str_aftermathfastbuildspeed db "AftermathFastBuildSpeed",0
;str_aftermath db "Aftermath",0

str_orespreads db "OreSpreads",0
str_general3 db "General",0


_Time_To_Build_NewUnitsEnabled_Check:

    cmp  BYTE [aftermathfastbuildspeed], 1

    JZ   0x00561206

    cmp  BYTE [fastambuildspeed], 1
    jz   .Fast_AM_For_Skirmish_And_Singleplayer

.Normal_Code:
    cmp  DWORD [0x00665DE0], 0 ; NewUnitsEnabled
    jz   0x00561206
    jmp  0x005611FC

.Fast_AM_For_Skirmish_And_Singleplayer:
    cmp  BYTE [SessionClass__Session], 0
    jz   .Fast_Speed
    cmp  BYTE [SessionClass__Session], 5
    jz   .Fast_Speed

    jmp  .Normal_Code

.Fast_Speed:
    jmp  0x00561206
