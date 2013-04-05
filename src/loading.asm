; Load our settings from here

@HOOK	0x004F446C		_Init_Game_Hook_Load ; For rules.ini stuff
@HOOK 	0x00551A87		_Startup_Function_Hook_Early_Load ; For redalert.ini stuff
@HOOK   0x0053D081      _Map_Load_Before_Hook ; For map loading stuff
@HOOK   0x0053A568      _Map_Load_Late_Hook  ; For map loading stuff
@HOOK   0x00537E08      _Load_Game_Before_Hook ; For savegame loading stuff
@HOOK   0x00538F07      _Load_Game_Late_Hook  ; For savegame loading stuff
@HOOK   0x0055B84B      _Ore_Mine_Foundation_Voodoo

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define INIClass__Get_Bool							0x004F3ACC
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30
%define SessionClass__Session 0x0067F2B4

str_redalertini5 db "REDALERT.INI",0
str_options5 db "Options",0
str_videointerlacemode db "VideoInterlaceMode",0
str_skipscorescreen db "SkipScoreScreen",0
str_randomstartingsong db "RandomStartingSong",0
str_ai db "AI",0
str_removeaitechupcheck db "RemoveAITechupCheck",0
str_fixaiparanoid db "FixAIParanoid",0
str_fixaially db "FixAIAlly",0
str_fixformationspeed db "FixFormationSpeed",0
str_gamelanguage db "GameLanguage",0
str_debuglogging db "DebugLogging",0
str_aftermathenabled db "AftermathEnabled",0
str_counterstrikeenabled db "CounterstrikeEnabled",0
str_usesmallinfantry db "UseSmallInfantry",0
str_nocd db "NoCD", 0
str_displayoriginalmultiplayermaps db "DisplayOriginalMultiplayerMaps",0
str_displayaftermathmultiplayermaps db "DisplayAftermathMultiplayerMaps",0
str_displaycounterstrikemultiplayermaps db "DisplayCounterstrikeMultiplayerMaps",0
str_parabombsinmultiplayer db "ParabombsInMultiplayer",0
str_mousewheelscrolling db "MouseWheelScrolling",0
str_evacinmp db "EvacInMP",0
str_alternativeriflesound db "AlternativeRifleSound",0
str_usegrenadethrowingsound db "UseGrenadeThrowingSound",0
str_usebetateslatank db "UseBetaTeslaTank",0
str_winhotkeys db "WinHotkeys",0
str_keysidebartoggle db "KeySidebarToggle",0
str_fixaisendingtankstopleft db "FixAISendingTanksTopLeft",0
str_generatememorydump db "GenerateMemoryDump",0
str_forceamunitsinmissions db "ForceAMUnitsInMissions",0
str_usebetadestroyer db "UseBetaDestroyer",0
str_usebetacruiser db "UseBetaCruiser",0
str_usebetasubmarine db "UseBetaSubmarine",0
str_usebetagunboat db "UseBetaGunboat",0
str_colorremapsidebarcameoicons db "ColorRemapSidebarIcons",0
str_computerparanoidforcedisabledskirmish db "ComputerParanoidForceDisabledSkirmish",0

INIClass_redalertini5 TIMES 64 db 0
FileClass_redalertini5	TIMES 128 db 0

extraremaptable TIMES 2400 db 0

%define colorwhiteoffset	0
%define colorblackoffset	282
%define colourbrightyellowoffset 564

OreMineFoundation dd 0
computerparanoidforcedisabledskirmish db 1
colorremapsidebarcameoicons db 0
usebetadestroyer db 0
usebetacruiser db 0
usebetasubmarine db 0
usebetagunboat db 0
forceamunitsinmissions db 0
aftermathfastbuildspeed	db 0
videointerlacemode	dd 2
skipscorescreen db 0
randomstartingsong db 0
removeaitechupcheck db 0
fixaiparanoid db 0
fixaially db 0
fixformationspeed db 0
gamelanguage dd 1
debuglogging db 1
counterstrikeenabled db 1
aftermathenabled db 1
nocdmode db 1
usesmallinfantry db 0
displayoriginalmultiplayermaps db 1
displaycounterstrikemultiplayermaps db 1
displayaftermathmultiplayermaps db 1
parabombsinmultiplayer	db 0
mousewheelscrolling db 0
evacinmp db 1
alternativeriflesound db 0
usegrenadethrowingsound db 0
usebetateslatank db 0
keysidebartoggle dw 0
fixaisendingtankstopleft db 0
generatememorydump	db 0

%macro Initialize_Remap_Table 1
	xor		eax, eax

.Loop_Initialize_Remap_Table%1:
	mov		BYTE [extraremaptable+2+eax+%1], al
	inc		eax
	cmp		BYTE AL, 0x100
	jnz		.Loop_Initialize_Remap_Table%1
	
	xor		eax, eax
	mov		eax, 258

.Loop_Initialize_Black_Part%1:
	mov		BYTE [extraremaptable+eax+%1], 00
	inc		eax
	cmp		eax, 268
	jnz		.Loop_Initialize_Black_Part%1	
%endmacro

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro INI_Get_Bool_ 4
    MOV ECX, DWORD %4
    MOV EBX, DWORD %3
    MOV EDX, DWORD %2
    MOV EAX, %1
    CALL INIClass__Get_Bool
%endmacro

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro INI_Get_Int_ 4
    MOV ECX, DWORD %4
    MOV EBX, DWORD %3
    MOV EDX, DWORD %2
    MOV EAX, %1
    CALL INIClass__Get_Int
%endmacro

; args: <INI Name>, <FileClass>, <INIClass>
%macro Load_INIClass 3
	MOV EDX, %1
    MOV EAX, %2
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, %2
    XOR EDX, EDX
    CALL FileClass__Is_Available

    ; initialize INIClass
    MOV EAX, %3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, %2
    MOV EAX, %3
    CALL INIClass__Load
%endmacro

_Load_Game_Late_Hook:
    Save_Registers
    
    ; Enable AM units for skirmish savegames
    cmp		BYTE [SessionClass__Session], 5
    jne     .No_Enable_New_Units
    call    0x004AC024 ; Is_Aftermath_Installed(void)
    cmp     DWORD eax, 1
    jne     .No_Enable_New_Units
    
    mov     DWORD [0X00665DE0], 1 ; NewUnitsEnabled
    
.No_Enable_New_Units:

    ; Enable AM units in single player if option is turned on
    cmp		BYTE [SessionClass__Session], 0
    jne     .Dont_Force_AM_Units_In_Missions
    cmp     BYTE [forceamunitsinmissions], 1
    jne     .Dont_Force_AM_Units_In_Missions
    call    0x004AC024 ; Is_Aftermath_Installed(void)
    cmp     DWORD eax, 1
    jne     .Dont_Force_AM_Units_In_Missions
        
    mov     DWORD [0X00665DE0], 1 ; NewUnitsEnabled
    
.Dont_Force_AM_Units_In_Missions:
    
    Restore_Registers
    call    0x004F25D0 ; INIClass::~INIClass(void)
    jmp     0x00538F0C

_Load_Game_Before_Hook:
    Save_Registers
    
    ;Remove any active Chrono Vortex
    mov     eax, 0x006904B4 ; ChronoVortex instance
    call    0x0058E304 ; ChronalVortexClass::Stop(void)

    ; Ore Mine foundation fix code
    mov     eax, DWORD [OreMineFoundation]
    mov     DWORD [eax], 0x1000080 ; Set to normal, bugged Ore Mine foundation
    
    cmp		BYTE [SessionClass__Session], 5
    jne     .No_Skirmish_Mine_Fix
   
    mov     DWORD [eax], 0x800080 ; Set to fixed Ore Mine foundation
    
.No_Skirmish_Mine_Fix:

    cmp		BYTE [SessionClass__Session], 0
    jne     .No_Skirmish_Mine_Fix2
  
    mov     DWORD [eax], 0x800080 ; Set to fixed Ore Mine foundation
   
.No_Skirmish_Mine_Fix2: 
    
    Restore_Registers
    call    0x004A765C ; Call_Back(void)
    jmp     0x00537E0D

_Ore_Mine_Foundation_Voodoo:
    push    ecx
    lea     ecx, [eax+0x139]
    mov     DWORD [OreMineFoundation], ecx
    mov     [eax+139h], edx
    
    pop     ecx
    jmp     0x0055B851

 _Map_Load_Before_Hook:
    call    0x0053AA94 ; Clear_Scenario(void)
    Save_Registers
    
    ;Remove any active Chrono Vortex
    mov     eax, 0x006904B4 ; ChronoVortex instance
    call    0x0058E304 ; ChronalVortexClass::Stop(void)
    
    ; Ore Mine foundation fix code,
   mov     eax, DWORD [OreMineFoundation]
   mov     DWORD [eax], 0x1000080 ; Set to normal, bugged Ore Mine foundation
    
   cmp		BYTE [SessionClass__Session], 5
   jne     .No_Skirmish_Mine_Fix
   
   mov     DWORD [eax], 0x800080 ; Set to fixed Ore Mine foundation
    
.No_Skirmish_Mine_Fix:

   cmp		BYTE [SessionClass__Session], 0
   jne     .No_Skirmish_Mine_Fix2
   
    mov     DWORD [eax], 0x800080 ; Set to fixed Ore Mine foundation
   
.No_Skirmish_Mine_Fix2:

    Restore_Registers
    jmp     0x0053D086
    
_Map_Load_Late_Hook:
    Save_Registers
    
    ; Enable AM units in single player if option is turned on
    cmp		BYTE [SessionClass__Session], 0
    jne     .Dont_Force_AM_Units_In_Missions
    cmp     BYTE [forceamunitsinmissions], 1
    jne     .Dont_Force_AM_Units_In_Missions
    call    0x004AC024 ; Is_Aftermath_Installed(void)
    cmp     DWORD eax, 1
    jne     .Dont_Force_AM_Units_In_Missions
        
    mov     DWORD [0X00665DE0], 1 ; NewUnitsEnabled
    
.Dont_Force_AM_Units_In_Missions:
    
    Restore_Registers
    call    0x0053A5C8 ; Fill_In_Data(void)
    jmp     0x0053A56D

_Startup_Function_Hook_Early_Load:
	xor		edx, edx
	mov		[0x006ABBC8], edx
	Save_Registers
	
	Load_INIClass str_redalertini5, FileClass_redalertini5, INIClass_redalertini5
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_mousewheelscrolling, 0
	mov		[mousewheelscrolling], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_displaycounterstrikemultiplayermaps, 1
	mov		[displaycounterstrikemultiplayermaps], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_displayaftermathmultiplayermaps, 1
	mov		[displayaftermathmultiplayermaps], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_displayoriginalmultiplayermaps, 1
	mov		[displayoriginalmultiplayermaps], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usesmallinfantry, 0
	mov		[usesmallinfantry], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_aftermathenabled, 1
	mov		[aftermathenabled], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_counterstrikeenabled, 1
	mov		[counterstrikeenabled], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_nocd, 1
	mov		[nocdmode], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_debuglogging, 1
	mov		[debuglogging], al
	
	INI_Get_Int_ INIClass_redalertini5, str_options5, str_videointerlacemode, 2 ; 2 = deinterlace videos
	mov		[videointerlacemode], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_skipscorescreen, 0
	mov		[skipscorescreen], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_randomstartingsong, 0
	mov		[randomstartingsong], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_alternativeriflesound, 0
	mov		[alternativeriflesound], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usegrenadethrowingsound, 0
	mov		[usegrenadethrowingsound], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usebetateslatank, 0
	mov		[usebetateslatank], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usebetadestroyer, 0
	mov		[usebetadestroyer], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usebetacruiser, 0
	mov		[usebetacruiser], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usebetasubmarine, 0
	mov		[usebetasubmarine], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_usebetagunboat, 0
	mov		[usebetagunboat], al
	
	INI_Get_Int_ INIClass_redalertini5, str_winhotkeys, str_keysidebartoggle, 9
	mov		[keysidebartoggle], ax
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_generatememorydump, 0
	mov		[generatememorydump], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_forceamunitsinmissions, 0
	mov		[forceamunitsinmissions], al
    
    INI_Get_Bool_ INIClass_redalertini5, str_options5, str_colorremapsidebarcameoicons, 0
	mov		[colorremapsidebarcameoicons], al
	
	Restore_Registers
	mov     ebx, [0x006ABC10]
	jmp		0x00551A8D

_Init_Game_Hook_Load:
	push 	ecx
	push 	ebx
	push 	edx
	push 	eax
	
	
	INI_Get_Bool_ 0x00666688, str_aftermath, str_aftermathfastbuildspeed, 0
	mov		[aftermathfastbuildspeed], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_removeaitechupcheck, 0
	mov		[removeaitechupcheck], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_fixaiparanoid, 0
	mov		[fixaiparanoid], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_fixaially, 0
	mov		[fixaially], al
	
	INI_Get_Bool_ 0x00666688, str_general, str_fixformationspeed, 0
	mov		[fixformationspeed], al
	
	INI_Get_Bool_ 0x00666688, str_general, str_parabombsinmultiplayer, 0
	mov		[parabombsinmultiplayer], al
	
	INI_Get_Bool_ 0x00666688, str_general, str_evacinmp, 1
	mov		[evacinmp], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_fixaisendingtankstopleft, 0
	mov		[fixaisendingtankstopleft], al
    
    INI_Get_Bool_ 0x00666688, str_ai, str_computerparanoidforcedisabledskirmish, 1
	mov [computerparanoidforcedisabledskirmish], al
    
	
;  EXTRA COLOUR REMAP WHITE
	Initialize_Remap_Table colorwhiteoffset
		
	mov		BYTE [extraremaptable+0x0], 0x0F 
	mov		BYTE [extraremaptable+0x1], 0x0F ; Name in radar logo color bits, this is for a yellow name
	
	; Remap colours for name in the name list on the radar
	mov		BYTE [extraremaptable+268], 0x0F
	mov		BYTE [extraremaptable+269], 0x0E
	mov		BYTE [extraremaptable+270], 0x0F
	mov		BYTE [extraremaptable+271], 0x0E
	mov		BYTE [extraremaptable+272], 0x0F
	mov		BYTE [extraremaptable+273], 0x0E
	mov		BYTE [extraremaptable+274], 0x0F
	mov		BYTE [extraremaptable+275], 0x0E
	mov		BYTE [extraremaptable+276], 0x0F
	mov		BYTE [extraremaptable+277], 0x0E
	mov		BYTE [extraremaptable+278], 0x0F
	mov		BYTE [extraremaptable+279], 0x0E
	
	; Remap colour on radar map
	mov		BYTE [extraremaptable+280], 0x4F
	mov		BYTE [extraremaptable+281], 0x4F
		
	; Remap colours on units, from lighest shade to darkest
	MOV     BYTE [extraremaptable+82], 0x0F
	MOV     BYTE [extraremaptable+83], 0x0F
	MOV     BYTE [extraremaptable+84], 0x80
	MOV     BYTE [extraremaptable+85], 0x80
	MOV     BYTE [extraremaptable+86], 0x80
	MOV     BYTE [extraremaptable+87], 0x84
	MOV     BYTE [extraremaptable+88], 0x84
	MOV     BYTE [extraremaptable+89], 0x85
	MOV     BYTE [extraremaptable+90], 0x88
	MOV     BYTE [extraremaptable+91], 0x89
	MOV     BYTE [extraremaptable+92], 0x8A
	MOV     BYTE [extraremaptable+93], 0x8A
	MOV     BYTE [extraremaptable+94], 0x8B
	MOV     BYTE [extraremaptable+95], 0x8B
	MOV     BYTE [extraremaptable+96], 0x8D
	MOV     BYTE [extraremaptable+97], 0x8F
	
;  EXTRA COLOUR REMAP BLACK
	Initialize_Remap_Table colorblackoffset
	
	mov		BYTE [extraremaptable+colorblackoffset+0x0], 0x0F 
	mov		BYTE [extraremaptable+colorblackoffset+0x1], 0x0F ; Name in radar logo color bits, this is for a yellow name
	
	; Remap colours for name in the name list on the radar
	mov		BYTE [extraremaptable+colorblackoffset+268], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+269], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+270], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+271], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+272], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+273], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+274], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+275], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+276], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+277], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+278], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+279], 0x12
	
	; Remap colour on radar map
	mov		BYTE [extraremaptable+colorblackoffset+280], 0x12
	mov		BYTE [extraremaptable+colorblackoffset+281], 0x12
		
	; Remap colours on units, from lighest shade to darkest
	MOV     BYTE [extraremaptable+colorblackoffset+82], 0x8A
	MOV     BYTE [extraremaptable+colorblackoffset+83], 0x8B
	MOV     BYTE [extraremaptable+colorblackoffset+84], 0x8C
	MOV     BYTE [extraremaptable+colorblackoffset+85], 0x8C
	MOV     BYTE [extraremaptable+colorblackoffset+86], 0x8D
	MOV     BYTE [extraremaptable+colorblackoffset+87], 0x8D
	MOV     BYTE [extraremaptable+colorblackoffset+88], 0x8E
	MOV     BYTE [extraremaptable+colorblackoffset+89], 0x8E
	MOV     BYTE [extraremaptable+colorblackoffset+90], 0x8F
	MOV     BYTE [extraremaptable+colorblackoffset+91], 0x8F
	MOV     BYTE [extraremaptable+colorblackoffset+92], 0x13
	MOV     BYTE [extraremaptable+colorblackoffset+93], 0x12
	MOV     BYTE [extraremaptable+colorblackoffset+94], 0x11
	MOV     BYTE [extraremaptable+colorblackoffset+95], 0x11
	MOV     BYTE [extraremaptable+colorblackoffset+96], 0x0C
	MOV     BYTE [extraremaptable+colorblackoffset+97], 0x0C
	
	;  EXTRA COLOUR REMAP BRIGHT YELLOW
	Initialize_Remap_Table colourbrightyellowoffset
	
	; Remap colours for name in the name list on the radar
	mov		BYTE [extraremaptable+colourbrightyellowoffset+268], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+269], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+270], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+271], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+272], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+273], 183
	mov		BYTE [extraremaptable+colourbrightyellowoffset+274], 184
	mov		BYTE [extraremaptable+colourbrightyellowoffset+275], 184
	mov		BYTE [extraremaptable+colourbrightyellowoffset+276], 184
	mov		BYTE [extraremaptable+colourbrightyellowoffset+277], 184
	mov		BYTE [extraremaptable+colourbrightyellowoffset+278], 184
	mov		BYTE [extraremaptable+colourbrightyellowoffset+279], 184
	
	; Remap colour on radar map
	mov		BYTE [extraremaptable+colourbrightyellowoffset+280], 18
	mov		BYTE [extraremaptable+colourbrightyellowoffset+281], 18
		
	; Remap colours on units, from lighest shade to darkest
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+82], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+83], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+84], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+85], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+86], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+87], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+88], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+89], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+90], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+91], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+92], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+93], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+94], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+95], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+96], 0x9C
	MOV     BYTE [extraremaptable+colourbrightyellowoffset+97], 0x9C
	
	mov		BYTE [extraremaptable+colourbrightyellowoffset+0x0], 0x0F 
	mov		BYTE [extraremaptable+colourbrightyellowoffset+0x1], 0x12 ; Name in radar logo color bits, this is for a yellow name
		
;	INIClass__Get_Int_
	
	pop		eax
	pop		edx
	pop		ebx
	pop		ecx
	
	mov     eax, 1
	jmp		0x004F4471