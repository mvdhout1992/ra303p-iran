;
; Copyright (c) 2012, 2013 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

; Spawn code for CnCNet, reads SPAWN.INI for options

%define GetCommandLineA                             0x005E5904
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30
%define calloc                                      0x005E1EF6
%define operator_new                                0x005BBF80
%define IPXAddressClass__IPXAddressClass            0x004F9950
%define DynamicVectorClass__Add                     0x004B9DA0
%define nameTags                                    0x0068043A
%define Start_Scenario                              0x0053A0A4
%define SessionClass__Create_Connections            0x0054A4F8
%define GameActive                                  0x00669924
%define Init_Random                                 0x004F5EC4
%define MessageListClass__Init                      0x00505244
%define inet_addr                                   0x005E59B8
%define SidebarClass_this                           0x00668250
%define SidebarClass__Activate                      0x0054DA70
%define GScreenClass__Flag_To_Redraw                0x004CB110
%define GScreenClass__Render                        0x004CB110
%define BlackPalette                                0x00669F5C
%define PaletteClass__Set                           0x005BCF44
%define GraphicBuffer_HiddenPage                    0x00680700
%define GraphicBuffer_VisiblePage                   0x0068065C
%define GraphicBufferClass__Lock                    0x005C101A
%define GraphicBufferClass__Unlock                  0x005C1191
%define _Buffer_Clear                               0x005C4DE0
%define pWinsock_this                               0x0069172C
%define UDPInterfaceClass__UDPInterfaceClass        0x005A8560
%define WinsockInterfaceClass__Init                 0x005A817C
%define UDPInterfaceClass__Open_Socket              0x005A8698
%define WinsockInterfaceClass__Start_Listening      0x005A80AC
%define WinsockInterfaceClass__Discard_In_Buffers   0x005A812C
%define WinsockInterfaceClass__Discard_Out_Buffers  0x005A8154
%define Init_Network                                0x005063C8
%define FrameSendRate                               0x0067F329
%define MaxAhead                                    0x0067F325
%define chatColor                                   0x0067F313
%define TechLevel                                   0x006016C8
%define NewUnitsEnabled                             0x00665DE0
%define Version107InMix                             0x00680538
%define DifficultyMode1                             0x006678EC
%define DifficultyMode2                             0x006678ED
%define GameFlags                                   0x00669908
%define Seed                                        0x00680658
%define Seed2                                       0x00680654
%define UnitBuildPenalty                            0x006017D8
%define NetPort                                     0x00609DBC
%define htonl                                       0x005E5A30
%define IPXManagerClass__Set_Timing                 0x004FA910
%define IPXManagerClass__Ipx                        0x006805B0
%define PlanetWestwoodStartTime                     0x006ABBB0
%define time_                                       0x005CEDA1
%define PlanetWestwoodGameID                        0x006ABBAC
%define ScenarioName                                0x006679D8

@HOOK 0x004F44DC Select_Game
; these force the game to use the actual port for sending and receiving packets rather than the default 1234
@HOOK 0x005A8ADF SendFix
@HOOK 0x005A8A75 ReceiveFix
@HOOK 0x0052971B _Wait_For_Players_Hack_Wait_Time

;@jmp  0x0052A2DB 0x0052A2E0
;@jmp  0x0052BF02 0x0052BF0B ; Make version protocol 0 netcode also use frame limiter
@HOOK 0x004A7D3D _Main_Loop_Use_Normal_Gamespeed_Code_With_Other_Network_Protocols
@HOOK 0x005292E5 _Queue_AI_Multiplayer_Do_Timing_Related_Code_With_Other_Network_Protocols

_Queue_AI_Multiplayer_Do_Timing_Related_Code_With_Other_Network_Protocols:
    cmp  DWORD [spawner_is_active], 0 ; if spawner is active jump over version protocol check
    jnz  .Ret

    cmp  BYTE [0x0067F2B5], 2
    jnz  0x00529317

.Ret:
jmp        0x005292EE

_Main_Loop_Use_Normal_Gamespeed_Code_With_Other_Network_Protocols:
    mov  BYTE dh, [0x0067F2B5]
    cmp  DWORD [spawner_is_active], 0 ; if spawner isn't active do normal code
    jz   .Ret
    cmp  BYTE dh, 2 ; if protocol version isn't 2 jump to protocol 2 speed
    jnz  0x004A7D82

.Ret:
    cmp  dh, 2
    jmp  0x004A7D46

struc NetAddress
    .port:      RESD 1
    .ip:        RESD 1
    .zero:      RESW 1
endstruc

struc Player
    .name       RESB 12
    .address    RESB NetAddress_size
    .side       RESB 1
    .color      RESB 1
    .pad        RESB 5
endstruc

struc Session
    .type       RESB 1
    .protocol   RESB 1
    .mission    RESD 1
    .bases      RESD 1
    .credits    RESD 1
    .oreRegen   RESD 1
    .crates     RESD 1
    .unk1       RESD 1
    .unitCount  RESD 1
    .aiPlayers  RESD 1
    .scenario   RESB 44
endstruc

struc sockaddr_in
    .sin_family RESW 1
    .sin_port   RESW 1
    .sin_addr   RESD 1
    .sin_zero   RESB 8
endstruc

%define game 0x0067F2B4

str_spawn_arg   db "-SPAWN", 0
str_spawn_ini   db "SPAWN.INI", 0
; optimize a lot of these out by using an offset in the game exe
str_NetworkVersionProtocol db "NetworkVersionProtocol",0
str_isspectator  db "IsSpectator",0
str_settings    db "Settings", 0
str_LoadSaveGame    db "LoadSaveGame",0
str_SaveGameNumber db "SaveGameNumber",0
str_IsSinglePlayer db "IsSinglePlayer",0
str_name        db "Name", 0
str_side        db "Side", 0
str_color       db "Color", 0
str_ip          db "Ip", 0
str_port        db "Port", 0
str_bases       db "Bases", 0
str_credits     db "Credits", 0
str_oreRegen    db "OreRegenerates", 0
str_crates      db "Crates", 0
str_scenario    db "Scenario", 0
str_unitCount   db "UnitCount", 0
str_aiPlayers   db "AIPlayers", 0
str_aiDiff      db "AIDifficulty", 0
str_empty       db 0
str_techLevel   db "TechLevel", 0
str_CTF         db "CaptureTheFlag", 0
str_shroudRegrow db "ShroudRegrows", 0
str_seed        db "Seed", 0
str_slowBuild   db "SlowUnitBuild", 0
str_gamespeed   db "GameSpeed",0
str_ishost      db "IsHost",0
str_gameid      db "GameID",0
str_basic       db "Basic",0
str_MaxAhead    db "MaxAhead",0
str_FrameSendRate db "FrameSendRate",0
;str_aftermathfastbuildspeed db "AftermathFastBuildSpeed",0
str_tunnel      db "Tunnel",0
str_id          db "Id",0

str_fmt_other   db "Other%d", 0

; sizes not actually verified
FileClass_SPAWN  TIMES 128 db 0
CCINIClass_SPAWN   TIMES 64 db 0

; sizes not actually verified
FileClass_Map  TIMES 128 db 0
CCINIClass_Map   TIMES 64 db 0

SpectatorsArray  TIMES 32 db 0

tunnel_ip dd 0
tunnel_port dd 0
tunnel_id dd 0

var_dword:          dd 0
HumanPlayers        dd 0 ; Need to read it from here for spawner stats

; args: <section>, <key>, <default>
%macro spawn_INI_Get_Bool 3
    call_INIClass__Get_Bool CCINIClass_SPAWN, {%1}, {%2}, {%3}
%endmacro

; args: <section>, <key>, <default>
%macro spawn_INI_Get_Int 3
    call_INIClass__Get_Int CCINIClass_SPAWN, {%1}, {%2}, {%3}
%endmacro

; args: <section>, <key>, <default>, <dst>, <dst_len>
%macro spawn_INI_Get_String 5
    call_INIClass__Get_String CCINIClass_SPAWN, {%1}, {%2}, {%3}, {%4}, {%5}
%endmacro

%macro New_Player 0
    MOV  EAX,1
    MOV  EDX, Player_size
    CALL calloc
    ADD  EAX, 0xC
    CALL IPXAddressClass__IPXAddressClass
    SUB  EAX, 0xC
%endmacro

Initialize_Spawn:
%push
    PUSH EBP
    MOV  EBP, ESP

%define plr EBP-4
%define buf EBP-36
%define sect EBP-68

    SUB  ESP,68

    ; check -SPAWN exists
    CALL GetCommandLineA

    MOV  EDX, str_spawn_arg
    CALL _stristr
    TEST EAX,EAX
    JE   .exit_error

    CMP  [nameTags], DWORD 0
    JE   .first_run

    MOV  EAX,0
    JMP  .exit

.first_run:

    ; initialize FileClass
    MOV  EDX, str_spawn_ini
    MOV  EAX, FileClass_SPAWN
    CALL FileClass__FileClass

    ; check ini exists
    MOV  EAX, FileClass_SPAWN
    XOR  EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
    JE   .exit_error

    ; initialize CCINIClass
    MOV  EAX, CCINIClass_SPAWN
    CALL CCINIClass__CCINIClass

    ; load FileClass to CCINIClass
    MOV  EDX, FileClass_SPAWN
    MOV  EAX, CCINIClass_SPAWN
    CALL CCINIClass__Load

    ; Set spawner_is_running global variable to 'true'
    MOV  DWORD [spawner_is_active], 1

    ; load settings from ini
    MOV  [game + Session.type], BYTE 5 ; Set to type skirmish

    MOV  [game + Session.protocol], BYTE 2
    MOV  [game + Session.mission], DWORD 0

    ; tunnel ip
    LEA  EAX, [buf]
    spawn_INI_Get_String str_tunnel, str_ip, str_empty, EAX, 32

    LEA  EAX, [buf]
    PUSH EAX
    CALL inet_addr
    MOV  [tunnel_ip], EAX

    ; tunnel port
    spawn_INI_Get_Int str_tunnel, str_port, 0
    AND  EAX, 0xFFFF
    PUSH EAX
    CALL htonl
    MOV  [tunnel_port], EAX

    ; tunnel id
    spawn_INI_Get_Int str_settings, str_port, 0
    AND  EAX, 0xFFFF
    PUSH EAX
    CALL htonl
    MOV  [tunnel_id], EAX

    ; spawn locations
    spawn_INI_Get_Int str_SpawnLocations, str_multi1, -1
    mov  DWORD [multi1_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi2, -1
    mov  DWORD [multi2_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi3, -1
    mov  DWORD [multi3_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi4, -1
    mov  DWORD [multi4_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi5, -1
    mov  DWORD [multi5_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi6, -1
    mov  DWORD [multi6_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi7, -1
    mov  DWORD [multi7_spawn], eax

    spawn_INI_Get_Int str_SpawnLocations, str_multi8, -1
    mov  DWORD [multi8_spawn], eax

    ; multi1-8 colours
    spawn_INI_Get_Int str_housecolors, str_multi1, 0xFF
    mov  BYTE [Multi1_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi2, 0xFF
    mov  BYTE [Multi2_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi3, 0xFF
    mov  BYTE [Multi3_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi4, 0xFF
    mov  BYTE [Multi4_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi5, 0xFF
    mov  BYTE [Multi5_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi6, 0xFF
    mov  BYTE [Multi6_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi7, 0xFF
    mov  BYTE [Multi7_Colour], al

    spawn_INI_Get_Int str_housecolors, str_multi8, 0xFF
    mov  BYTE [Multi8_Colour], al

    ; multi1-8 countries
    spawn_INI_Get_Int str_housecountries, str_multi1, 0xFF
    mov  BYTE [Multi1_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi2, 0xFF
    mov  BYTE [Multi2_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi3, 0xFF
    mov  BYTE [Multi3_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi4, 0xFF
    mov  BYTE [Multi4_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi5, 0xFF
    mov  BYTE [Multi5_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi6, 0xFF
    mov  BYTE [Multi6_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi7, 0xFF
    mov  BYTE [Multi7_Country], al

    spawn_INI_Get_Int str_housecountries, str_multi8, 0xFF
    mov  BYTE [Multi8_Country], al

    ; multi1-8 handicaps
    spawn_INI_Get_Int str_househandicaps, str_multi1, 0xFF
    mov  BYTE [Multi1_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi2, 0xFF
    mov  BYTE [Multi2_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi3, 0xFF
    mov  BYTE [Multi3_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi4, 0xFF
    mov  BYTE [Multi4_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi5, 0xFF
    mov  BYTE [Multi5_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi6, 0xFF
    mov  BYTE [Multi6_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi7, 0xFF
    mov  BYTE [Multi7_Handicap], al

    spawn_INI_Get_Int str_househandicaps, str_multi8, 0xFF
    mov  BYTE [Multi8_Handicap], al

    ; Spectators
    spawn_INI_Get_Bool str_isspectator, str_multi1, 0
    mov  BYTE [SpectatorsArray+0x0C], al

    spawn_INI_Get_Bool str_isspectator, str_multi2, 0
    mov  BYTE [SpectatorsArray+0x0D], al

    spawn_INI_Get_Bool str_isspectator, str_multi3, 0
    mov  BYTE [SpectatorsArray+0x0E], al

    spawn_INI_Get_Bool str_isspectator, str_multi4, 0
    mov  BYTE [SpectatorsArray+0x0F], al

    spawn_INI_Get_Bool str_isspectator, str_multi5, 0
    mov  BYTE [SpectatorsArray+0x10], al

    spawn_INI_Get_Bool str_isspectator, str_multi6, 0
    mov  BYTE [SpectatorsArray+0x11], al

    spawn_INI_Get_Bool str_isspectator, str_multi7, 0
    mov  BYTE [SpectatorsArray+0x12], al

    spawn_INI_Get_Bool str_isspectator, str_multi8, 0
    mov  BYTE [SpectatorsArray+0x13], al

    ; generic stuff
    spawn_INI_Get_Int str_settings, str_port, 1234
    CMP  DWORD [tunnel_port],0
    JNE  .nosetport
    MOV  [NetPort], EAX
.nosetport:

    spawn_INI_Get_Bool str_settings, str_bases, 1
    MOV  [game + Session.bases], EAX

    spawn_INI_Get_Int str_settings, str_credits, 10000
    MOV  [game + Session.credits], EAX

    spawn_INI_Get_Bool str_settings, str_oreRegen, 0
    MOV  [game + Session.oreRegen], EAX
    TEST EAX,EAX
    JE   .noregen
    MOV  [GameFlags], DWORD 0xC0

.noregen:

    spawn_INI_Get_Bool str_settings, str_crates, 0
    MOV  [game + Session.crates], EAX

    spawn_INI_Get_Int str_settings, str_unitCount, 0
    MOV  [game + Session.unitCount], EAX

    spawn_INI_Get_Int str_settings, str_aiPlayers, 0
    MOV  [game + Session.aiPlayers], EAX

    spawn_INI_Get_Int str_settings, str_seed, 0
    MOV  [Seed], EAX
    MOV  [Seed2], EAX

    spawn_INI_Get_Bool str_settings, str_slowBuild, 0
    TEST EAX,EAX

    MOV  [UnitBuildPenalty], DWORD 0x64

    JE   .nopenalty
    MOV  [UnitBuildPenalty], DWORD 0xFA
.nopenalty:

    spawn_INI_Get_Bool str_settings, str_CTF, 0
    TEST EAX,EAX
    JE   .noctf
    MOV  EDX, [GameFlags]
    OR   EDX, 8
    MOV  [GameFlags], EDX
    MOV  [game + Session.bases], DWORD 1
.noctf:

    spawn_INI_Get_Bool str_settings, str_shroudRegrow, 0
    TEST EAX,EAX
    JE   .noregrow
    MOV  EDX, [GameFlags]
    OR   EDX, 1
    MOV  [GameFlags], EDX
.noregrow:

    spawn_INI_Get_Int str_settings, str_techLevel, 10
    MOV  [TechLevel], EAX

    spawn_INI_Get_Int str_settings, str_aiDiff, 2

    CMP  EAX, 2
    JL   .diff_easy
    JG   .diff_hard

    ; 2 = normal
    MOV  [DifficultyMode1], BYTE 1
    MOV  [DifficultyMode2], BYTE 1
    JMP  .diff_end

.diff_easy:
    ; <2 = easy
    MOV  [DifficultyMode1], BYTE 0
    MOV  [DifficultyMode2], BYTE 2

    JMP  .diff_end

.diff_hard:
    ; >2 = hard
    MOV  [DifficultyMode1], BYTE 2
    MOV  [DifficultyMode2], BYTE 0

.diff_end:

    ; Note: works only in session type 4
    spawn_INI_Get_Bool str_settings, str_aftermath, 0
    MOV  [NewUnitsEnabled], EAX
    MOV  [Version107InMix], EAX
    MOV  BYTE [aftermathenabled], AL

    ; create self
    New_Player
    MOV  [plr], EAX

    ; copy name
    LEA  EAX, [buf]
    spawn_INI_Get_String str_settings, str_name, str_empty, EAX, 32

    LEA  EAX, [buf]
    PUSH EAX
    MOV  EAX, [plr]
    ADD  EAX, Player.name
    PUSH EAX
    CALL _strcpy

    spawn_INI_Get_Int str_settings, str_side, 0
    MOV  EBX, [plr]
    MOV  [EBX + Player.side], AL

    spawn_INI_Get_Int str_settings, str_color, 0
    MOV  EBX, [plr]
    MOV  [EBX + Player.color], AL
    MOV  [chatColor], AL

    LEA  EDX, [plr]
    MOV  EAX, nameTags
    CALL DynamicVectorClass__Add

    ; copy opponents
    XOR  ECX,ECX

.next_opp:
    ADD  ECX,1
    LEA  EAX, [sect]
    call_sprintf EAX, str_fmt_other, ECX

    PUSH ECX
    LEA  EAX, [buf]
    PUSH 32
    PUSH EAX
    MOV  ECX, str_empty
    MOV  EBX, str_name
    LEA  EDX, [sect]
    MOV  EAX, CCINIClass_SPAWN
    CALL INIClass__Get_String
    POP  ECX

    TEST EAX,EAX
    ; if no name present for this section, this is the last
    JE   .last_opp

    PUSH ECX

    ; name found, create player
    New_Player
    MOV  [plr], EAX

    ; also make sure we're in online mode if more players than self
    MOV  [game + Session.type], BYTE 4

    ; copy name
    LEA  EAX, [buf]
    PUSH EAX
    MOV  EAX, [plr]
    ADD  EAX, Player.name
    PUSH EAX
    CALL _strcpy

    ; set side
    MOV  ECX, -1
    MOV  EBX, str_side
    LEA  EDX, [sect]
    MOV  EAX, CCINIClass_SPAWN
    CALL INIClass__Get_Int

    CMP  EAX,-1
    JE   .next_opp

    MOV  EBX, [plr]
    MOV  [EBX + Player.side], AL

    ; set color
    MOV  ECX, -1
    MOV  EBX, str_color
    LEA  EDX, [sect]
    MOV  EAX, CCINIClass_SPAWN
    CALL INIClass__Get_Int

    CMP  EAX,-1
    JE   .next_opp

    MOV  EBX, [plr]
    MOV  [EBX + Player.color], AL

    ; ip
    LEA  EAX, [buf]
    PUSH 32
    PUSH EAX
    MOV  ECX, str_empty
    MOV  EBX, str_ip
    LEA  EDX, [sect]
    MOV  EAX, CCINIClass_SPAWN
    CALL INIClass__Get_String

    LEA  EAX, [buf]
    PUSH EAX
    CALL inet_addr

    MOV  EBX, [plr]
    MOV  [EBX + Player.address + NetAddress.zero], WORD 0
    MOV  [EBX + Player.address + NetAddress.ip], EAX

    ; port
    MOV  ECX, 1234
    MOV  EBX, str_port
    LEA  EDX, [sect]
    MOV  EAX, CCINIClass_SPAWN
    CALL INIClass__Get_Int

    MOV  EBX, [plr]
    AND  EAX, 0xFFFF

    PUSH EAX
    CALL htonl

    MOV  [EBX + Player.address + NetAddress.port], EAX

    ; add to nameTags vector
    LEA  EDX, [plr]
    MOV  EAX, nameTags
    CALL DynamicVectorClass__Add

    POP  ECX

    JMP  .next_opp

.last_opp:

    ; Copy the amount of human players for spawner stats
    mov  eax, DWORD [0x0068044A]
    mov  DWORD [HumanPlayers], eax

    ; force gamespeed to fastest
    spawn_INI_Get_Int str_settings, str_gamespeed, 1
    MOV  DWORD   [0x00668188], eax

    ; start game
    MOV  [GameActive], DWORD 1


    ; initialize network
    CMP  BYTE [game + Session.type], 4
    JNE  .nonet

    spawn_INI_Get_Int str_settings, str_NetworkVersionProtocol, 0
    MOV  [game + Session.protocol], al

    MOV  EAX,1
    MOV  EDX, 0x471
    CALL calloc
    MOV  [pWinsock_this], EAX

    CALL UDPInterfaceClass__UDPInterfaceClass

    MOV  EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Init

    XOR  EDX,EDX
    MOV  EAX, [pWinsock_this]
    CALL UDPInterfaceClass__Open_Socket

    MOV  EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Start_Listening

    MOV  EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Discard_In_Buffers

    MOV  EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Discard_Out_Buffers

    CALL Init_Network

    ; Added this to hopefully correct any timing issues
    spawn_INI_Get_Int str_settings, str_MaxAhead, 15
    MOV  [MaxAhead], eax

    spawn_INI_Get_Int str_settings, str_FrameSendRate, 3
    MOV  [FrameSendRate], eax

    MOV  ECX, 0x2E8
    mov  EBX, 0FFFFFFFFh
    mov  EDX, 0x19
    mov  EAX, IPXManagerClass__Ipx
    CALL IPXManagerClass__Set_Timing

.nonet:

    ; Initialize some stuff for statistics code
    XOR  EAX, EAX
    CALL time_
    MOV  [PlanetWestwoodStartTime], EAX

    spawn_INI_Get_Int str_settings, str_gameid, 0
    MOV  [PlanetWestwoodGameID], EAX

    ; Init random number generator and related data
    CALL Init_Random

    ; fade to black
    XOR  EBX,EBX
    MOV  EAX, BlackPalette
    MOV  EDX, 0xF
    CALL PaletteClass__Set

    MOV  EAX,GraphicBuffer_HiddenPage
    CALL GraphicBufferClass__Lock

    PUSH 0
    PUSH GraphicBuffer_HiddenPage
    CALL _Buffer_Clear
    ADD  ESP,8

    MOV  EAX,GraphicBuffer_HiddenPage
    CALL GraphicBufferClass__Unlock

    MOV  EAX,GraphicBuffer_VisiblePage
    CALL GraphicBufferClass__Lock

    PUSH 0
    PUSH GraphicBuffer_VisiblePage
    CALL _Buffer_Clear
    ADD  ESP,8

    MOV  EAX,GraphicBuffer_VisiblePage
    CALL GraphicBufferClass__Unlock

    LEA  EAX, [ScenarioName]
    spawn_INI_Get_String str_settings, str_scenario, str_empty, EAX, 32

    ; copy secnario name
    LEA  EAX, [buf]
    spawn_INI_Get_String str_settings, str_scenario, str_empty, EAX, 32

    ; Initialize MapName char array for spawner stats
    LEA  EAX, [buf]
    call_CCINIClass__Load EAX, FileClass_Map, CCINIClass_Map

    call_INIClass__Get_String CCINIClass_Map, str_basic, str_name, str_empty, 0x0067F2D6, 0x2A

    spawn_INI_Get_Bool str_settings, str_aftermathfastbuildspeed, 0
    mov  [aftermathfastbuildspeed], al

    spawn_INI_Get_Bool str_settings, str_fixformationspeed, 0
    mov  [fixformationspeed], al

    spawn_INI_Get_Bool str_settings, str_fixrangeexploit, 0
    mov  BYTE [infantryrangeexploitfix], al

    spawn_INI_Get_Bool str_settings, str_fixmagicbuild, 0
    mov  BYTE [magicbuildfix], al

    spawn_INI_Get_Bool str_settings, str_parabombsinmultiplayer, 0
    mov  [parabombsinmultiplayer], al

    spawn_INI_Get_Bool str_settings, str_fixaially, 0
    mov  [fixaially], al

    spawn_INI_Get_Bool str_settings, str_mcvundeploy, 0
    mov  [mcvundeploy], al

    spawn_INI_Get_Bool str_settings, str_allyreveal, 0
    mov  [allyreveal], al

    spawn_INI_Get_Bool str_settings, str_forcedalliances, 0
    mov  [forcedalliances], al

    spawn_INI_Get_Bool str_settings, str_techcenterbugfix, 0
    mov  [techcenterbugfix], al

    spawn_INI_Get_Bool str_settings, str_buildoffally, 0
    mov  [buildoffally], al

    spawn_INI_Get_Bool str_settings, str_southadvantagefix, 0
    mov  [southadvantagefix], al

    spawn_INI_Get_Bool str_settings, str_noscreenshake, 0
    mov  [noscreenshake], al

    spawn_INI_Get_Bool str_settings, str_noteslazapeffectdelay, 0
    mov  [noteslazapeffectdelay], al

    spawn_INI_Get_Bool str_settings, str_shortgame, 0
    mov  [shortgame], al

    spawn_INI_Get_Bool str_settings, str_deadplayersradar, 0
    mov  [deadplayersradar], al

    ; For an AI paranoid setting?
;    spawn_INI_Get_Bool 0x00666688, str_ai, str_fixaiparanoid, 0
;    mov        [fixaiparanoid], al


    ; Fixes
    mov  BYTE [fixaisendingtankstopleft], 1
    mov  BYTE [evacinmp], 0
    mov  BYTE [fixnavalexploits], 1

    ; Frag1 Explosion Anim fix should be enabled via loading.asm's hook for map start
    ; But enable it here just in case
    mov  eax, DWORD [FRAG1AnimData]
    mov  BYTE [eax], 0xC1 ; Fix invisible FRAG1 explosion

    ; Ore mine foundation fix should be enabled via loading.asm's hook for map start
    ; But enable it here just in case
    mov  eax, DWORD [OreMineFoundation]
    mov  DWORD [eax], 0x800080 ; Set to fixed Ore Mine foundation

    mov  BYTE [buildingcrewstuckfix], 1


    ; I have little knowledge what these values are, the first one pushed is screen height, sort of
    PUSH 0x1E0
    PUSH 0x6A
    PUSH 0x14
    PUSH 0
    PUSH -1
    PUSH -1
    PUSH 0xE
    PUSH 0x6A
    MOV  ECX,0x6
    MOV  EBX,0x10
    MOV  EAX,0x67F5A8
    MOV  EDX, 0
    CALL MessageListClass__Init

    spawn_INI_Get_Bool str_settings, str_LoadSaveGame, 0
    cmp  al, 0
    jz   .Dont_Load_Save_Game

    spawn_INI_Get_Int str_settings, str_SaveGameNumber, 1000

    mov  eax, 803
    CALL 0x00537D10 ; Load_Game
    TEST EAX,EAX
    JE   .exit

    jmp  .Dont_Load_Scenario

.Dont_Load_Save_Game:

    spawn_INI_Get_Bool str_settings, str_IsSinglePlayer, 0
    cmp  al, 0
    jz   .Dont_Set_Single_Player

    mov  BYTE [SessionClass__Session], 0

.Dont_Set_Single_Player:

    MOV  EDX, 1
    LEA  EAX, [buf]
    CALL Start_Scenario
    TEST EAX,EAX
    JE   .exit

.Dont_Load_Scenario:

    MOV  EAX, game
    CALL SessionClass__Create_Connections

    MOV  EAX,SidebarClass_this
    MOV  EDX,1
    CALL SidebarClass__Activate

    MOV  EAX,SidebarClass_this
    XOR  EDX,EDX
    CALL GScreenClass__Flag_To_Redraw

    MOV  EAX,SidebarClass_this
    CALL GScreenClass__Render

    call 0x004A765C ; call back (is this needed?)

    call 0x00528EDC ; queue ai

    call 0x004A765C ; callback (is this needed?)

    ; Refresh screen again (don't think this is working)
    MOV  EAX,SidebarClass_this
    XOR  EDX,EDX
    CALL GScreenClass__Flag_To_Redraw

    MOV  EAX,SidebarClass_this
    CALL GScreenClass__Render

    MOV  EAX,1
    JMP  .exit

.exit_error:
    MOV  EAX,-1

.exit:
    MOV  ESP,EBP
    POP  EBP
    RETN
%pop

Select_Game:
    PUSH EBP
    MOV  EBP,ESP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI

    CALL Initialize_Spawn
    CMP  EAX,-1

    ; if spawn not initialized, go to main menu
    JE   0x004F44E4

    POP  EDI
    POP  ESI
    POP  EDX
    POP  ECX
    POP  EBX
    POP  EBP
    RETN

SendFix:
    PUSH EBX
    MOV  EBX,DWORD [EBP-18h]
    MOV  EAX,[EBX]

    PUSH EAX
    CALL htonl

    TEST EAX,EAX
    JNE  .have_port
    MOV  AX,1234
.have_port:
    POP  EBX
    JMP  0x005A8AE5

ReceiveFix:
    SUB  ESI,4
    LEA  EDX,[EBP-18h]

    ; cleanup crap from port as using it as dword
    MOV  EAX,[ESI]
    AND  EAX,0xFFFF0000
    MOV  [ESI],EAX

    PUSH EDI
    MOV  EAX,ECX
    MOV  ECX,2
    JMP  0x005A8A81

_Wait_For_Players_Hack_Wait_Time:
    CMP  DWORD [spawner_is_active], 0
    jz   .Ret
    mov  edx, 120 ; NOT HEX

.Ret:
    sub  eax, [ebx+1]
    cmp  eax, edx
    jmp  0x00529720
