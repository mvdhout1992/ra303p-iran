@HOOK 0x004C9F62 _RedrawOptionsMenu_Skirmish_Savegames
@HOOK 0x004C9F80 _RedrawOptionsMenu_Skirmish_Savegames2
@HOOK 0x004C9F93 _RedrawOptionsMenu_Skirmish_Savegames3
@HOOK 0x004C9FA7 _RedrawOptionsMenu_Skirmish_Savegames4
@HOOK 0x004C9FB5 _RedrawOptionsMenu_Skirmish_Savegames5
@HOOK 0x004CA2CD _RedrawOptionsMenu_Skirmish_Savegames6
@HOOK 0x004CA953 _RedrawOptionsMenu_Skirmish_Savegames7
@HOOK 0x004CA9D0 _RedrawOptionsMenu_Skirmish_Savegames8
@HOOK 0x00538267 _Load_Game_Set_Session_Type_Hack
@HOOK 0x00537A3C _Save_Game_House_Type_Get
@HOOK 0x004FDB92 _LoadOptionsClass__Fill_Prepend_Skirmish_Text

DotMPR_str db ".mpr",0
str_skirmish db "Skirmish",0

; Gets a side based on a country type
; arg: <EAX: country to get side for>
; returns: EAX is 2 if side is Soviet, 0 if Allies
_Side_From_Country_Savegames:
    cmp  DWORD eax, 2
    je   .Return_Soviet
    cmp  DWORD eax, 4
    je   .Return_Soviet
    cmp  DWORD eax, 9
    je   .Return_Soviet

.Return_Allies:
    mov  eax, 0
    retn

.Return_Soviet:
    mov  eax, 2
    retn

_LoadOptionsClass__Fill_Prepend_Skirmish_Text:
    mov  dh, [ebp-0x14]
    cmp  dh, 0xDD
    jz   .Prepend_Skirmish_Text
    cmp  dh, 2
    jz   0x004FDB9F

    jmp  0x004FDB9A

.Prepend_Skirmish_Text:
    mov  eax, str_skirmish
    push eax
    push 0x005EC0D0     ; "(%s) "
    mov  ebx, [ebp-0x34]
    push ebx
    jmp  0x004FDBD3

_Save_Game_House_Type_Get:
    mov  al, [eax+25h]
    mov  [ebp-10h], al

    cmp  BYTE [SessionClass__Session], 5
    jne  .Not_Skirmish_Save

    mov  al, 0xDD
    mov  [ebp-10h], al

.Not_Skirmish_Save:
    jmp  0x00537A42

_Load_Game_Set_Session_Type_Hack:
    call 0x005D5BF4 ; LZOStraw::Get(void *,int)
    Save_Registers

    cmp  BYTE [SessionClass__Session], 5
    jz   .Modify_Session_Type_Check
    cmp  BYTE [SessionClass__Session], 0
    jz   .Modify_Session_Type_Check

    jmp  .Ret

.Modify_Session_Type_Check:
    mov  BYTE [SessionClass__Session], 0

    mov  edx, DotMPR_str
    mov  eax, 0x006679D8
    call 0x005CEC59 ; strstr()

    CMP  eax, 0 ; if eax == 0 the substring wasn't found
    jnz  .Set_Skirmish

    cmp  BYTE [0x006679D8], 'S'
    jne  .Ret
    cmp  BYTE [0x006679D9], 'C'
    jne  .Ret
    cmp  BYTE [0x006679DA], 'M'
    jne  .Ret

.Set_Skirmish:
    mov  BYTE [SessionClass__Session], 5

.Ret:
    Restore_Registers
    jmp  0x0053826C

_RedrawOptionsMenu_Skirmish_Savegames:
    mov  [eax+ebp-11Ch], edx ; Hooked by patch
    cmp  BYTE cl, 0
    jz   0x004C9F7A
    cmp  BYTE cl, 5
    jnz  .Ret
    cmp  esi, 0
    jz   0x004C9F7A

.Ret:
    jmp  0x004C9F6D

_RedrawOptionsMenu_Skirmish_Savegames2:
    jmp  0x004C9F85

_RedrawOptionsMenu_Skirmish_Savegames3:
    cmp  BYTE [SessionClass__Session], 0
    jz   0x004C9FA7
    cmp  BYTE [SessionClass__Session], 5
    jz   0x004C9FA7

    jmp  0x004C9F9C

_RedrawOptionsMenu_Skirmish_Savegames4:
    jmp  0x004C9FB5

_RedrawOptionsMenu_Skirmish_Savegames5:
    cmp  BYTE [SessionClass__Session], 0
    jz   0x004C9FC8
    cmp  BYTE [SessionClass__Session], 5
    jz   0x004C9FC8

    jmp  0x004C9FBE

_RedrawOptionsMenu_Skirmish_Savegames6:
    mov  ch, BYTE [SessionClass__Session]
    test ch, ch
    jz   0x004CA2DC
    cmp  BYTE ch, 5
    jz   0x004CA2DC

    jmp  0x004CA2D7

_RedrawOptionsMenu_Skirmish_Savegames7:
    test ch, ch
    jz   short .Ret

    cmp  BYTE ch, 5
    jz   .Ret

    jmp  0x004CA97E

.Ret:
    mov  edx, 2
    jmp  0x004CA95C

_RedrawOptionsMenu_Skirmish_Savegames8:
    cmp  DWORD [ResignKeyPressed], 1
    jz   0x004CA9D9

    cmp  BYTE [SessionClass__Session], 0
    jz   0x004CAA2E
    cmp  BYTE [SessionClass__Session], 5
    jz   0x004CAA2E

    jmp  0x004CA9D9
