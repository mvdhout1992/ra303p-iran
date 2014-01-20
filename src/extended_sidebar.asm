; modify call at 0x0054D823 to use custom sidebar graphics and draw it multiple times below each other

@HOOK 0x0054E142 _StripClass_Activate_hires
@HOOK 0x0054E156 _StripClass_Activate_hires2
@HOOK 0x0054E172 _StripClass_Activate_hires3
@HOOK 0x0054CF47 _SidebarClass_fn_init_hires
@HOOK 0x0054DFAE _StripClass_Init_IO_hires
@HOOK 0x0054DFF8 _StripClass_Init_IO_hires2
@HOOK 0x0054E1CC _StripClass_Deactivate_hires
@HOOK 0x0054E1E8 _StripClass_Deactivate_hires2
@HOOK 0x0054E9C2 _StripClass_Draw_It_hires
;@HOOK 0x004A6BA4 _StripClass_Draw_It_hires2
@HOOK 0x0054D0B1 _SidebarClass_One_TIme_Icon_Area_Size_hires
@HOOK 0x0054E425 _StripClass_AI_hires
@HOOK 0x0054E000 _StripClass_Init_IO_Up_Down_Buttons_hires
@HOOK 0x0054E2AD _StripClass_Scroll_hires
@HOOK 0x0054E74F _StripClass_Draw_It_hires3
@HOOK 0x0054D644 _SidebarClass_Add_hires
@HOOK 0x00538FD1 _Load_Game_hires
@HOOK 0x0054D803 _SidebarClass_Draw_It
@HOOK 0x00527756 _PowerClass_Draw_It_hires
@HOOK 0x00527743 _PowerClass_Draw_It_hires2
@HOOK 0x0054EC67 _StripClass_Recalc_hires
@HOOK 0x0052761D _PowerClass_One_Time
@HOOK 0x0054D353 _SidebarClass_Reload_Sidebar_hires
;@HOOK 0x00527C19 _PowerClass_Draw_it_hires4
@HOOK 0x005278B7 _PowerClass_Draw_it_hires5
;@HOOK 0x005277A6 _PowerClass_Draw_It_hires3
;@HOOK 0x00527A67 _PowerClass_Draw_it_hires6
@HOOK 0x00527885 _PowerClass_Draw_it_hires7
@HOOK 0x00527863 _PowerClass_Draw_it_hires8
@HOOK 0x0052789B _PowerClass_Draw_it_hires9
@HOOK 0x00527C19 _PowerClass_Draw_it_hires10
@HOOK 0x00527771 _PowerClass_Draw_it_hires11

CameoItems dd 0 ; Cameo icons to draw the per strip
CurrentStripIndex dd 0 ; variable used for strip.shp drawing
CurrentStripFrame dd 0 ; variable used for strip.shp frame
CurrentStripDrawPosition dd 0 ; variable for strip.shp drawing height position
CurrentPowerBarDrawPosition dd 0 ; variable used for pwrbar.shp no power bar drawing height position
CurrentPowerBarDrawPosition2 dd 0 ; variable used for pwrbar.shp with power bar drawing height position
PowerBarBottomPos dd 0 ; variable used for

powerext_str db "POWEREXT.SHP",0
side4na_str db "SIDE4NA.SHP",0
side4us_str db "SIDE4US.SHP",0
strip2na_str db "STRIP2NA.SHP",0
strip2us_str db "STRIP2US.SHP",0

PowerTileShape dd 0
Side4Shape dd 0
Strip2Shape dd 0

; These are per strip, there's a left and right strip in the sidebar
; 208 / 52 = 4 items
; 30 cameo icons times 48 is 1440 pixels plus 181 (start of icon drawing plus 27 (buttons)
; gives about 1650 vertical height to support

%define CAMEO_ITEMS 30
%define CAMEOS_SIZE    1560 ; memory size of all cameos in byte

%define StripBarAreaVerticalSize 0x00601758
%define MouseClass_Map            0x00668250
%define IngameHeight 0x006016B4

; Height of up and down buttons is 27 pixels
; Drawing of icons starts at height 181, every extra icon is 48 extra pixels
;[23:58:21] <iran> so
;[23:58:42] <iran> IngameHeight-181-27 / 48 for total amount of possible icons

ExtendedSelectButtons TIMES 824 dd 0

_PowerClass_Draw_it_hires11:
    mov  ebx, 18Eh
    add  ebx, [diff_height]
    sub  ebx, 47
    jmp  0x00527776

_PowerClass_Draw_it_hires10:
    mov  eax, [0x006877B8] ; ds:void *PowerClass::PowerShape
    cmp  DWORD [ebp-2Ch], 0
    je   .No_Draw

.Draw:
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)
    jmp  0x00527C23

.No_Draw:
;    cmp        DWORD [IngameHeight], 400
;    jne        .Draw
    jmp  0x00527C23


_PowerClass_Draw_it_hires9:
;    mov     edx, 15Fh
;    add        edx, [diff_height]
    mov  DWORD edx, [PowerBarBottomPos]
    jmp  0x005278A0

_PowerClass_Draw_it_hires8:
    push ebx
    push edx

    imul eax, 100
    mov  ebx, 130
    cdq  ; sign-extend EAX into EDX
    idiv ebx
    mov  DWORD ebx, [PowerBarBottomPos]
    sub  ebx, 220
    imul eax, ebx

    mov  ebx, 100
    cdq  ; sign-extend EAX into EDX
    idiv ebx

    pop  edx
    pop  ebx

    add  eax, edx
    mov  edx, eax
    shl  eax, 4
    jmp  0x0052786A

_PowerClass_Draw_it_hires7:
    push ebx
    push edx

    imul eax, 100
    mov  ebx, 130
    cdq  ; sign-extend EAX into EDX
    idiv ebx
    mov  DWORD ebx, [PowerBarBottomPos]
    sub  ebx, 220
    imul eax, ebx

    mov  ebx, 100
    cdq  ; sign-extend EAX into EDX
    idiv ebx

    pop  edx
    pop  ebx

    add  eax, esi
    mov  edx, eax
    shl  edx, 4
    jmp  0x0052788C

_PowerClass_Draw_it_hires6:
    mov  ecx, [0x0060BA70] ; ds:int HardwareFills
    add  eax, [diff_height]
    mov  [ebp-34h], eax
    jmp  0x00527A70

_PowerClass_Draw_it_hires5:
;    mov     eax, 15Fh
;    add        eax, [diff_height]
    mov  DWORD eax, [PowerBarBottomPos]
    jmp  0x005278BC

_PowerClass_Draw_it_hires4:
    mov  eax, [0x006877B8] ; ds:void *PowerClass::PowerShape
    add  ecx, [diff_height]
    jmp  0x00527C1E

_SidebarClass_Reload_Sidebar_hires: ; Load side specific graphics
    mov  eax, [edx+3Eh]
    sar  eax, 18h
    push eax        ; save eax

    CMP  DWORD eax, 2
    jz   .Load_Soviet_Sidebar

    CMP  DWORD eax, 4
    jz   .Load_Soviet_Sidebar

    CMP  DWORD eax, 9
    jz   .Load_Soviet_Sidebar

    mov  eax, side4na_str
    call 0x005B9330 ; MixFileClass<CCFileClass>::Finder(char *)
    mov  [Side4Shape], eax

    mov  eax, strip2na_str
    call 0x005B9330 ; MixFileClass<CCFileClass>::Finder(char *)
    mov  [Strip2Shape], eax

    pop  eax    ; restore eax
    jmp  0x0054D359

.Load_Soviet_Sidebar:

    mov  eax, side4us_str
    call 0x005B9330 ; MixFileClass<CCFileClass>::Finder(char *)
    mov  [Side4Shape], eax

    mov  eax, strip2us_str
    call 0x005B9330 ; MixFileClass<CCFileClass>::Finder(char *)
    mov  [Strip2Shape], eax

    pop  eax    ; restore eax
    jmp  0x0054D359

_PowerClass_One_Time:
    mov  [0x006877BC], eax ; ds:void *PowerClass::PowerBarShape

    mov  eax, powerext_str
    call 0x005B9330 ; MixFileClass<CCFileClass>::Finder(char *)
    mov  [PowerTileShape], eax

    jmp  0x00527622

_PowerClass_Draw_It_hires2: ; Draw the whole powerbar graphics with power bar till bottom of screen
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)
    mov  ecx, 288
;    mov        ecx, 0xB4
;    add        ecx, 64h
    mov  [CurrentPowerBarDrawPosition2], ecx

.Loop:

    push 100h            ; zoom?
    push 0               ; Rotation
    push 0               ; __int32
    mov  edx, [ebp-28h]
    push edx             ; __int32
    push esi             ; __int32
    mov  ecx, DWORD [CurrentPowerBarDrawPosition2]
    mov  ebx, 1E0h
    add  ebx, [diff_width]
    push 0               ; __int32
    mov  eax, [PowerTileShape]
;    mov     eax, [0x006877BC]
    mov  edx, 0
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)

    mov  DWORD ecx, [CurrentPowerBarDrawPosition2]
    add  DWORD [CurrentPowerBarDrawPosition2], 48

    mov  DWORD ebx, [CameoItems]
    imul ebx, 48
;    add        ebx, 27
    add  ebx, 181
    sub  ebx, 48

    cmp  ecx, ebx
    jl   .Loop

    mov  DWORD [CurrentPowerBarDrawPosition2], 0
    jmp  0x00527748

_StripClass_Recalc_hires: ; Fix graphical glitching when selling conyard and other situations
;    mov        esi, MouseClass_Map
;    lea     eax, [esi+103Eh]
;    call    0x0054E2CC ; StripClass::Flag_To_Redraw

    mov  eax, MouseClass_Map
    call 0x004CAFF4 ; GScreenClass::Flag_To_Redraw(int)
;    mov     eax, MouseClass_Map
;    call    0x004CB110 ; GScreenClass::Render(void)

;    mov        esi, MouseClass_Map
;    lea     eax, [esi+131Ah]
;    call    0x0054E2CC ; StripClass::Flag_To_Redraw

    pop  edi
    pop  esi
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    retn

_PowerClass_Draw_It_hires:
    mov  DWORD ecx, [CameoItems]
    imul ecx, 48
    add  ecx, 27
    add  ecx, 181
    sub  ecx, 112
    jmp  0x0052775B

_SidebarClass_Draw_It:
;    mov        DWORD [0], 276 ; crash
    mov  DWORD [CurrentStripDrawPosition], 276
.Loop:

    push 100h            ; __int32
    push 0               ; Rotation
    push 0               ; __int32
    push 0               ; __int32
    push 10h             ; __int32
    mov  DWORD ecx, [CurrentStripDrawPosition]
    mov  ebx, 1E0h
    add  ebx, [diff_width]
    push 0               ; __int32
    mov  eax, [Side4Shape]
    mov  edx, edi
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)

    add  DWORD [CurrentStripDrawPosition], 48
    mov  DWORD ecx, [CurrentStripDrawPosition]
    mov  DWORD ebx, [IngameHeight]
    sub  ebx, 75
    cmp  ecx, ebx
    jle  .Loop

    mov  DWORD [CurrentStripDrawPosition], 0
    jmp  0x0054D828

_Load_Game_hires: ; Fix up button vertical position and visible icon area size when loading save games
    push ebx

    mov  eax, [CameoItems]
    mov  edx, 48
    imul eax, edx
    mov  DWORD [StripBarAreaVerticalSize], eax

    mov  DWORD ebx, [CameoItems]
    imul ebx, 48
    add  ebx, 180
    mov  [downbuttons+16], ebx ; Up and down buttons height
    mov  [downbuttons+16+56], ebx
    mov  [upbuttons+16], ebx
    mov  [upbuttons+16+56], ebx

    ;Scroll up cameo list to top for right sidebar if it would be glitched
    mov  eax, MouseClass_Map
    lea  eax, [eax+131Ah]

    mov  edx, [eax+25h] ; Current cameo item in sidebar
    mov  ebx, [eax+35h] ; Max cameo item in sidebar
    add  edx, [CameoItems]
    cmp  edx, ebx
    jle  .No_Cameo_list_Right_Strip_Reset

;    mov        ebx, [eax+35h]
;    sub        ebx, [CameoItems]
;    mov        DWORD [eax+25h], ebx ; Set it to the legit max scroll
    mov  DWORD [eax+25h], 0 ; Reset it

.No_Cameo_list_Right_Strip_Reset:

    ;Scroll up cameo list to top for left sidebar if it would be glitched
    mov  eax, MouseClass_Map
    lea  eax, [eax+103Eh]

    mov  edx, [eax+25h] ; Current cameo item in sidebar
    mov  ebx, [eax+35h] ; Max cameo item in sidebar
    add  edx, [CameoItems]
    cmp  edx, ebx
    jle  .No_Cameo_list_Left_Strip_Reset

;    mov        ebx, [eax+35h]
;    sub        ebx, [CameoItems]
;    mov        DWORD [eax+25h], ebx ; Set it to the legit max scroll
    mov  DWORD [eax+25h], 0 ; Reset it

.No_Cameo_list_Left_Strip_Reset:

    pop  ebx
    mov  eax, ebx
    lea  esp, [ebp-14h]
    jmp  0x00538FD6

_SidebarClass_Add_hires: ; Fix graphical glitching when new icons are added to sidebar
    mov  edx, esi
    call 0x0054E1F8 ; SidebarClass::StripClass::Add(RTTIType,int)
    push eax

    mov  esi, MouseClass_Map
    lea  eax, [esi+103Eh]
    call 0x0054E2CC ; StripClass::Flag_To_Redraw

    mov  esi, MouseClass_Map
    lea  eax, [esi+131Ah]
    call 0x0054E2CC ; StripClass::Flag_To_Redraw

    pop  eax
    jmp  0x0054D64B

_StripClass_Draw_It_hires3: ; Draw strip.shp background over each cameo
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)

    mov  DWORD [CurrentStripIndex], 372
.Loop:

    push 100h
    push 0
    push 0
    push 0
    mov  eax, [Strip2Shape]
;    mov     eax, [0x0068A464]; ds:void *SidebarClass::StripClass::LogoShapes
    push 10h             ; __int32

    mov  ecx, [CurrentStripIndex]

    mov  ebx, [esi+11h]
    push 0               ; __int32
    mov  edx, [esi+19h]
    add  ebx, 4
    call 0x004A96E8 ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)

    add  DWORD [CurrentStripIndex], 48
    mov  DWORD ecx, [CurrentStripIndex]
    mov  DWORD ebx, [IngameHeight]
    sub  ebx, 75
    cmp  ecx, ebx
    jle  .Loop

    mov  DWORD [CurrentStripIndex], 0

    jmp  0x0054E754

_StripClass_Scroll_hires:
    add  edx, [CameoItems]
    cmp  edx, ebx
    jmp  0x0054E2B2

_StripClass_Init_IO_Up_Down_Buttons_hires: ; Fix up up and down buttons vertical height
    mov  DWORD ebx, [CameoItems]
    imul ebx, 48
;    add        ebx, 27
    add  ebx, 181

    mov  [downbuttons+16], ebx ; Up and down buttons height
    mov  [downbuttons+16+56], ebx
    mov  [upbuttons+16], ebx
    mov  [upbuttons+16+56], ebx

    pop  edi
    pop  esi
    pop  ecx
    pop  ebx
    pop  ebp
    retn

_StripClass_AI_hires:
    add  eax, [CameoItems]
    cmp  eax, [edx+35h]
    jmp  0x0054E42B

_StripClass_Activate_hires:
    imul eax, [ecx+19h], CAMEOS_SIZE
    add  eax, ExtendedSelectButtons
    jmp  0x0054E14E

_StripClass_Activate_hires2:
    imul edx, [ecx+19h], CAMEOS_SIZE
    add  edx, ExtendedSelectButtons
    jmp  0x0054E163

_StripClass_Activate_hires3:
    mov  edx, [CameoItems]
    imul edx, edx, 52
    cmp  ebx, edx
    jmp  0x0054E178

_SidebarClass_fn_init_hires: ; Initialize extended invisible select buttons
    mov  edx, CAMEO_ITEMS*2 ; amount of total items to init
    mov  eax, ExtendedSelectButtons
    mov  [0x00604D68], eax
    jmp  0x0054CF51

    ;[23:58:21] <iran> so
;[23:58:42] <iran> IngameHeight-181-27 / 48

_StripClass_Init_IO_hires:
    imul eax, [ecx+19h], CAMEOS_SIZE
    add  eax, ExtendedSelectButtons
    jmp  0x0054DFBA

_StripClass_Init_IO_hires2:
    cmp  esi, [CameoItems] ; items check
    jl   0x0054DFAE
    jmp  0x0054DFFD

_StripClass_Deactivate_hires:
    imul edx, [ecx+19h], CAMEOS_SIZE
    add  edx, ExtendedSelectButtons
    jmp  0x0054E1D9

_StripClass_Deactivate_hires2:
    cmp  ebx, CAMEOS_SIZE
    jmp  0x0054E1EE

_StripClass_Draw_It_hires:
    add  eax, [CameoItems]
    cmp  eax, edx
    jmp  0x0054E9C7

_StripClass_Draw_It_hires2:
;    add     eax, CAMEO_ITEMS*2; items to draw
    mov  DWORD edi, [CameoItems]
    imul edi, 2
    add  eax, edi ; items to draw
    cmp  eax, ecx
    jmp  0x004A6BA9

_SidebarClass_One_TIme_Icon_Area_Size_hires: ; Calculate CameoItems and set StripBarAreaVerticalSize
    push ecx
    push edx
    push ebx
    push eax
    push esi
    push edi

    mov  eax, [IngameHeight]
    sub  eax, 180
    sub  eax, 27
    cdq  ; sign-extend EAX into EDX
    mov  ebx, 48
    idiv ebx

    ; If CameoItems would be higher than the max cameo items hardcoded to support
    ; set CameoItems to CAMEO_ITEMS instead of the value we calculated
    cmp  eax, CAMEO_ITEMS
    jl   .Dont_Set_Max_Cameos

    mov  eax, CAMEO_ITEMS

.Dont_Set_Max_Cameos:

    mov  DWORD [CameoItems], eax

    mov  eax, [CameoItems]
    mov  edx, 48
    imul eax, edx
    mov  DWORD [StripBarAreaVerticalSize], eax

    mov  DWORD ecx, [CameoItems]
    imul ecx, 48
    add  ecx, 27
    add  ecx, 181
    sub  ecx, 42
    mov  DWORD [PowerBarBottomPos], ecx

    pop  edi
    pop  esi
    pop  eax
    pop  ebx
    pop  edx
    pop  ecx
    jmp  0x0054D0B7
