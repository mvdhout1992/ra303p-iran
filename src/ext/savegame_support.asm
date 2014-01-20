@HOOK 0x00537B32 _Save_Game_Save_Game_Version
@HOOK 0x00537FED _Load_Game_Patch_Version_Check
@HOOK 0x005396AF _Get_Savefile_Info_Is_Old_Savegame
@HOOK 0x0053903A _Save_Misc_Values_Extended_Savegames
@HOOK 0x00539106 _Load_Misc_Values_Extended_Savegames

%define New_Savegame_Version    0x1007000
%define Old_Savegame_Version    0x100618B
%define SaveGameVersion            0x0065D7C0 ; global variable

;ARGS: <offset/pointer to value to SAVE>, <size in byte>
%macro Save_Global_Value 2
    mov  ebx, %2
    mov  esi, [ecx+8]
    mov  edx, %1
    mov  eax, ecx
    call dword [esi+10h]
%endmacro

;ARGS: <offset/pointer to value to LOAD>, <size in byte>
%macro Load_Global_Value 2
    mov  ebx, %2
    mov  esi, [ecx+8]
    mov  edx, %1
    mov  eax, ecx
    call dword [esi+8]
%endmacro

; For early map load, to prevent savegame values from working on
; next map load
Clear_Extended_Savegame_Values:
    mov  BYTE [buildoffally], 0
    mov  BYTE [aftermathfastbuildspeed], 0
    mov  BYTE [deadplayersradar], 0
    mov  BYTE [spawner_aftermath], 0
    mov  BYTE [shortgame], 0
    mov  BYTE [noteslazapeffectdelay], 0
    mov  BYTE [noscreenshake], 0
    mov  BYTE [techcenterbugfix], 0
    mov  BYTE [forcedalliances], 0
    mov  BYTE [allyreveal], 0
    mov  BYTE [mcvundeploy], 0
    mov  BYTE [buildingcrewstuckfix], 0
    mov  BYTE [magicbuildfix], 0
    mov  BYTE [infantryrangeexploitfix], 0
    mov  BYTE [computerparanoidforcedisabledskirmish], 1
    mov  BYTE [removeaitechupcheck], 0
    mov  BYTE [fixaiparanoid], 0
    mov  BYTE [fixaially], 0
    mov  BYTE [fixformationspeed], 0
    mov  BYTE [parabombsinmultiplayer], 0
    mov  BYTE [evacinmp], 1
    mov  BYTE [fixaisendingtankstopleft], 0
    mov  DWORD [InCoopMode], 0
    mov  DWORD [fixnavalexploits], 0
    retn

; Loading and saving data in Save- and Load_Misc_Values_Extended_Savegames
; need to be in the same order or else the game will crash or stuff with corrupt
_Save_Misc_Values_Extended_Savegames:
    call dword [esi+10h]

    Save_Global_Value SessionClass__Session, 1
    Save_Global_Value buildoffally, 1
    Save_Global_Value aftermathfastbuildspeed, 1
    Save_Global_Value deadplayersradar, 1
    Save_Global_Value spawner_aftermath, 1
    Save_Global_Value shortgame, 1
    Save_Global_Value noteslazapeffectdelay, 1
    Save_Global_Value noscreenshake, 1
    Save_Global_Value techcenterbugfix, 1
    Save_Global_Value forcedalliances, 1
    Save_Global_Value allyreveal, 1
    Save_Global_Value mcvundeploy, 1
    Save_Global_Value buildingcrewstuckfix, 1
    Save_Global_Value magicbuildfix, 1
    Save_Global_Value infantryrangeexploitfix, 1
    Save_Global_Value computerparanoidforcedisabledskirmish, 1
    Save_Global_Value removeaitechupcheck, 1
    Save_Global_Value fixaiparanoid, 1
    Save_Global_Value fixaially, 1
    Save_Global_Value fixformationspeed, 1
    Save_Global_Value parabombsinmultiplayer, 1
    Save_Global_Value evacinmp, 1
    Save_Global_Value fixaisendingtankstopleft, 1
    Save_Global_Value InCoopMode, 4
    Save_Global_Value fixnavalexploits, 1

.Ret:
    mov  eax, [0x00667808]; ds:Objects_Selected?
    jmp  0x00539042

_Load_Misc_Values_Extended_Savegames:
    call dword [esi+8]

    cmp  DWORD [SaveGameVersion], New_Savegame_Version
    jnz  .Ret ; SaveGameVersion != New_Savegame_Version so return

    Load_Global_Value SessionClass__Session, 1
    Load_Global_Value buildoffally, 1
    Load_Global_Value aftermathfastbuildspeed, 1
    Load_Global_Value deadplayersradar, 1
    Load_Global_Value spawner_aftermath, 1
    Load_Global_Value shortgame, 1
    Load_Global_Value noteslazapeffectdelay, 1
    Load_Global_Value noscreenshake, 1
    Load_Global_Value techcenterbugfix, 1
    Load_Global_Value forcedalliances, 1
    Load_Global_Value allyreveal, 1
    Load_Global_Value mcvundeploy, 1
    Load_Global_Value buildingcrewstuckfix, 1
    Load_Global_Value magicbuildfix, 1
    Load_Global_Value infantryrangeexploitfix, 1
    Load_Global_Value computerparanoidforcedisabledskirmish, 1
    Load_Global_Value removeaitechupcheck, 1
    Load_Global_Value fixaiparanoid, 1
    Load_Global_Value fixaially, 1
    Load_Global_Value fixformationspeed, 1
    Load_Global_Value parabombsinmultiplayer, 1
    Load_Global_Value evacinmp, 1
    Load_Global_Value fixaisendingtankstopleft, 1
    Load_Global_Value InCoopMode, 4
    Load_Global_Value fixnavalexploits, 1

.Ret:
    mov  ebx, 4
    jmp  0x0053910E

; Save as new version
_Save_Game_Save_Game_Version:
    mov  eax, New_Savegame_Version
    jmp  0x00537B37

_Load_Game_Patch_Version_Check:
;    jmp        0x0053805E ; HACK: always pass check

    cmp  eax, New_Savegame_Version
    jz   0x0053805E

    cmp  eax, New_Savegame_Version
    jz   0x0053805E

.Normal_Code:
    cmp  eax, 100618Ah
    jmp  0x00537FF2

_Get_Savefile_Info_Is_Old_Savegame:
;    jmp        0x005396E3 ; HACK: never an old savegame

    cmp  DWORD EDI, New_Savegame_Version
    jz   0x005396E3

    cmp  DWORD edi, 100618Ah
    jmp  0x005396B5

; args: <register or address of object>, <new size of object>, <old size of object>
%macro    Clear_Memory 3
    mov  eax, %1
    add  eax, %3
    mov  edx, 0
    mov  ebx, %2-%3

    call 0x005C4E50 ; memset_
%endmacro

; args: <register or address of object>, <new size of object>, <old size of object>
%macro Clear_Extended_Class_Memory_For_Old_Saves 3
    cmp  DWORD [SaveGameVersion], New_Savegame_Version
    jz   .Ret ; SaveGameVersion == New_Savegame_Version so return
    Save_Registers

    Clear_Memory %1, %2, %3

    Restore_Registers
%endmacro
