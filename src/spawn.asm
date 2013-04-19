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
%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
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
%define strcpy                                      0x005E55C8
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
%define UnitBuildPenalty                            0x006017D8
%define NetPort                                     0x00609DBC
%define htonl                                       0x005E5A30

@HOOK 0x004F44DC Select_Game

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

%define game 0x0067F2B4

str_spawn_arg   db "-SPAWN", 0
str_spawn_ini   db "SPAWN.INI", 0
; optimize a lot of these out by using an offset in the game exe
str_settings    db "Settings", 0
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
str_aftermath   db "Aftermath", 0
str_CTF         db "CaptureTheFlag", 0
str_shroudRegrow db "ShroudRegrows", 0
str_seed        db "Seed", 0
str_slowBuild   db "SlowUnitBuild", 0

str_fmt_other   db "Other%d", 0

; sizes not actually verified
FileClass_SPAWN  TIMES 128 db 0
INIClass_SPAWN   TIMES 64 db 0

var_dword:      dd 0

; args: <section>, <key>, <default>, <dst>
%macro INI_Get_Int 3
    MOV ECX, DWORD %3
    MOV EBX, DWORD %2
    MOV EDX, DWORD %1
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_Int
%endmacro

; args: <section>, <key>, <default>, <dst>, <dst_len>
%macro INI_Get_String 5
    PUSH %5             ; dst len
    PUSH %4             ; dst
    MOV ECX, DWORD %3   ; default
    MOV EBX, DWORD %2   ; key
    MOV EDX, DWORD %1   ; section
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_String
%endmacro

%macro New_Player 0
    MOV EAX,1
    MOV EDX, Player_size
    CALL calloc
    ADD EAX, 0xC
    CALL IPXAddressClass__IPXAddressClass
    SUB EAX, 0xC
%endmacro

Initialize_Spawn:
%push
    PUSH EBP
    MOV EBP, ESP

%define plr EBP-4
%define buf EBP-36
%define sect EBP-68

    SUB ESP,68
    
    ; check -SPAWN exists
    CALL GetCommandLineA

    MOV EDX, str_spawn_arg
    CALL stristr_
    TEST EAX,EAX
    JE .exit_error

    CMP [nameTags], DWORD 0
    JE .first_run

    MOV EAX,0
    JMP .exit

.first_run:

    ; initialize FileClass
    MOV EDX, str_spawn_ini
    MOV EAX, FileClass_SPAWN
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, FileClass_SPAWN
    XOR EDX, EDX
    CALL FileClass__Is_Available
    TEST EAX,EAX
    JE .exit_error

    ; initialize INIClass
    MOV EAX, INIClass_SPAWN
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, FileClass_SPAWN
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Load

    ; load settings from ini
    MOV [game + Session.type], BYTE 5
    MOV [game + Session.protocol], BYTE 2
    MOV [game + Session.mission], DWORD 0
    
    ; spawn locations
    INI_Get_Int str_SpawnLocations, str_multi1, -1
	mov		DWORD [multi1_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi2, -1
	mov		DWORD [multi2_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi3, -1
	mov		DWORD [multi3_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi4, -1
	mov		DWORD [multi4_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi5, -1
	mov		DWORD [multi5_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi6, -1
	mov		DWORD [multi6_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi7, -1
	mov		DWORD [multi7_spawn], eax
	
	INI_Get_Int  str_SpawnLocations, str_multi8, -1
	mov		DWORD [multi8_spawn], eax
    
    ; multi1-8 colours   
    INI_Get_Int str_housecolours, str_multi1, 0xFF
	mov		BYTE [Multi1_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi2, 0xFF
	mov		BYTE [Multi2_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi3, 0xFF
	mov		BYTE [Multi3_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi4, 0xFF
	mov		BYTE [Multi4_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi5, 0xFF
	mov		BYTE [Multi5_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi6, 0xFF
	mov		BYTE [Multi6_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi7, 0xFF
	mov		BYTE [Multi7_Colour], al
	
	INI_Get_Int  str_housecolours, str_multi8, 0xFF
	mov		BYTE [Multi8_Colour], al
    
    ; multi1-8 countries    
    INI_Get_Int str_housecountries, str_multi1, 0xFF
	mov		BYTE [Multi1_Country], al
	
	INI_Get_Int  str_housecountries, str_multi2, 0xFF
	mov		BYTE [Multi2_Country], al
	
	INI_Get_Int  str_housecountries, str_multi3, 0xFF
	mov		BYTE [Multi3_Country], al
	
	INI_Get_Int  str_housecountries, str_multi4, 0xFF
	mov		BYTE [Multi4_Country], al
	
	INI_Get_Int  str_housecountries, str_multi5, 0xFF
	mov		BYTE [Multi5_Country], al
	
	INI_Get_Int  str_housecountries, str_multi6, 0xFF
	mov		BYTE [Multi6_Country], al
	
	INI_Get_Int  str_housecountries, str_multi7, 0xFF
	mov		BYTE [Multi7_Country], al
	
	INI_Get_Int  str_housecountries, str_multi8, 0xFF
	mov		BYTE [Multi8_Country], al
    
    ; multi1-8 handicaps
    INI_Get_Int str_househandicaps, str_multi1, 0xFF
	mov		BYTE [Multi1_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi2, 0xFF
	mov		BYTE [Multi2_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi3, 0xFF
	mov		BYTE [Multi3_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi4, 0xFF
	mov		BYTE [Multi4_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi5, 0xFF
	mov		BYTE [Multi5_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi6, 0xFF
	mov		BYTE [Multi6_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi7, 0xFF
	mov		BYTE [Multi7_Handicap], al
	
	INI_Get_Int  str_househandicaps, str_multi8, 0xFF
	mov		BYTE [Multi8_Handicap], al

    ; generic stuff
    INI_Get_Int str_settings, str_port, 1234
    MOV [NetPort], EAX

    INI_Get_Int str_settings, str_bases, 1
    MOV [game + Session.bases], EAX

    INI_Get_Int str_settings, str_credits, 10000
    MOV [game + Session.credits], EAX

    INI_Get_Int str_settings, str_oreRegen, 0
    MOV [game + Session.oreRegen], EAX
    TEST EAX,EAX
    JE .noregen
    MOV [GameFlags], DWORD 0xC0
    
.noregen:

    INI_Get_Int str_settings, str_crates, 0
    MOV [game + Session.crates], EAX

    INI_Get_Int str_settings, str_unitCount, 0
    MOV [game + Session.unitCount], EAX

    INI_Get_Int str_settings, str_aiPlayers, 0
    MOV [game + Session.aiPlayers], EAX

    INI_Get_Int str_settings, str_seed, 0
    MOV [Seed], EAX

    INI_Get_Int str_settings, str_slowBuild, 0
    TEST EAX,EAX

    MOV [UnitBuildPenalty], DWORD 0x64

    JE .nopenalty
    MOV [UnitBuildPenalty], DWORD 0xFA
.nopenalty:

    INI_Get_Int str_settings, str_CTF, 0
    TEST EAX,EAX
    JE .noctf
    MOV EDX, [GameFlags]
    OR EDX, 8
    MOV [GameFlags], EDX
    MOV [game + Session.bases], DWORD 1
.noctf:

    INI_Get_Int str_settings, str_shroudRegrow, 0
    TEST EAX,EAX
    JE .noregrow
    MOV EDX, [GameFlags]
    OR EDX, 1
    MOV [GameFlags], EDX
.noregrow:

    INI_Get_Int str_settings, str_techLevel, 10
    MOV [TechLevel], EAX

    INI_Get_Int str_settings, str_aiDiff, 1

    CMP EAX, 2
    JL .diff_easy
    JG .diff_hard

    ; 2 = normal
    MOV [DifficultyMode1], BYTE 2
    MOV [DifficultyMode2], BYTE 2
    JMP .diff_end

.diff_easy:
    ; <2 = easy
    MOV [DifficultyMode1], BYTE 0
    MOV [DifficultyMode2], BYTE 2

.diff_hard:
    ; >2 = hard
    MOV [DifficultyMode1], BYTE 2
    MOV [DifficultyMode2], BYTE 0

.diff_end:

    ; Note: works only in session type 4
    INI_Get_Int str_settings, str_aftermath, 0
    MOV [NewUnitsEnabled], EAX
    MOV [Version107InMix], EAX

    ; create self
    New_Player
    MOV [plr], EAX

    ; copy name
    LEA EAX, [buf]
    INI_Get_String str_settings, str_name, str_empty, EAX, 32

    LEA EAX, [buf]
    PUSH EAX
    MOV EAX, [plr]
    ADD EAX, Player.name
    PUSH EAX
    CALL strcpy

    INI_Get_Int str_settings, str_side, 0
    MOV EBX, [plr]
    MOV [EBX + Player.side], AL

    INI_Get_Int str_settings, str_color, 0
    MOV EBX, [plr]
    MOV [EBX + Player.color], AL
    MOV [chatColor], AL

    LEA EDX, [plr]
    MOV EAX, nameTags
    CALL DynamicVectorClass__Add

    ; copy opponents
    XOR ECX,ECX

.next_opp:
    ADD ECX,1
    LEA EAX, [sect]
    sprintf EAX, str_fmt_other, ECX

    PUSH ECX
    LEA EAX, [buf]
    PUSH 32
    PUSH EAX
    MOV ECX, str_empty
    MOV EBX, str_name
    LEA EDX, [sect]
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_String
    POP ECX

    TEST EAX,EAX
    ; if no name present for this section, this is the last
    JE .last_opp

    PUSH ECX

    ; name found, create player
    New_Player
    MOV [plr], EAX

    ; also make sure we're in online mode if more players than self
    MOV [game + Session.type], BYTE 4

    ; copy name
    LEA EAX, [buf]
    PUSH EAX
    MOV EAX, [plr]
    ADD EAX, Player.name
    PUSH EAX
    CALL strcpy

    ; set side
    MOV ECX, -1
    MOV EBX, str_side
    LEA EDX, [sect]
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_Int

    CMP EAX,-1
    JE .next_opp

    MOV EBX, [plr]
    MOV [EBX + Player.side], AL

    ; set color
    MOV ECX, -1 
    MOV EBX, str_color
    LEA EDX, [sect]
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_Int

    CMP EAX,-1
    JE .next_opp

    MOV EBX, [plr]
    MOV [EBX + Player.color], AL

    ; ip
    LEA EAX, [buf]
    PUSH 32
    PUSH EAX
    MOV ECX, str_empty
    MOV EBX, str_ip
    LEA EDX, [sect]
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_String

    LEA EAX, [buf]
    PUSH EAX
    CALL inet_addr

    MOV EBX, [plr]
    MOV [EBX + Player.address + NetAddress.zero], WORD 0
    MOV [EBX + Player.address + NetAddress.ip], EAX

    ; port
    MOV ECX, 1234
    MOV EBX, str_port
    LEA EDX, [sect]
    MOV EAX, INIClass_SPAWN
    CALL INIClass__Get_Int

    MOV EBX, [plr]
    AND EAX, 0xFFFF

    PUSH EAX
    CALL htonl

    MOV [EBX + Player.address + NetAddress.port], EAX

    ; add to nameTags vector
    LEA EDX, [plr]
    MOV EAX, nameTags
    CALL DynamicVectorClass__Add

    POP ECX
     
    JMP .next_opp

.last_opp:

    ; start game
    MOV [GameActive], DWORD 1

    ; initialize network
    CMP BYTE [game + Session.type], 4
    JNE .nonet

    MOV EAX,1
    MOV EDX, 0x471
    CALL calloc
    MOV [pWinsock_this], EAX

    CALL UDPInterfaceClass__UDPInterfaceClass

    MOV EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Init

    XOR EDX,EDX
    MOV EAX, [pWinsock_this]
    CALL UDPInterfaceClass__Open_Socket

    MOV EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Start_Listening

    MOV EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Discard_In_Buffers

    MOV EAX, [pWinsock_this]
    CALL WinsockInterfaceClass__Discard_Out_Buffers

    CALL Init_Network

    MOV [FrameSendRate], DWORD 3
    MOV [MaxAhead], DWORD 15

.nonet:
    CALL Init_Random

    ; fade to black
    XOR EBX,EBX
    MOV EAX, BlackPalette
    MOV EDX, 0xF
    CALL PaletteClass__Set

    MOV EAX,GraphicBuffer_HiddenPage
    CALL GraphicBufferClass__Lock

    PUSH 0
    PUSH GraphicBuffer_HiddenPage
    CALL _Buffer_Clear
    ADD ESP,8

    MOV EAX,GraphicBuffer_HiddenPage
    CALL GraphicBufferClass__Unlock

    MOV EAX,GraphicBuffer_VisiblePage
    CALL GraphicBufferClass__Lock

    PUSH 0
    PUSH GraphicBuffer_VisiblePage
    CALL _Buffer_Clear
    ADD ESP,8

    MOV EAX,GraphicBuffer_VisiblePage
    CALL GraphicBufferClass__Unlock

    ; copy name
    LEA EAX, [buf]
    INI_Get_String str_settings, str_scenario, str_empty, EAX, 32

    MOV EDX, 1
    LEA EAX, [buf]
    CALL Start_Scenario
    TEST EAX,EAX
    JE .exit

    ; I have little knowledge what these values are, the first one pushed is screen height, sort of
    PUSH 0x1E0
    PUSH 0x6A
    PUSH 0x14
    PUSH 0
    PUSH -1
    PUSH -1
    PUSH 0xE
    PUSH 0x6A
    MOV ECX,0x6
    MOV EBX,0x10
    MOV EAX,0x67F5A8
    CALL MessageListClass__Init

    MOV EAX, game
    CALL SessionClass__Create_Connections

    MOV EAX,SidebarClass_this
    MOV EDX,1
    CALL SidebarClass__Activate

    MOV EAX,SidebarClass_this
    XOR EDX,EDX
    CALL GScreenClass__Flag_To_Redraw

    MOV EAX,SidebarClass_this
    CALL GScreenClass__Render
    
    call 0x004A765C ; call back (is this needed?)
    
    call 0x00528EDC ; queue ai
    
    call 0x004A765C ; callback (is this needed?)
    
    ; Refresh screen again (don't think this is working)
    MOV EAX,SidebarClass_this
    XOR EDX,EDX
    CALL GScreenClass__Flag_To_Redraw

    MOV EAX,SidebarClass_this
    CALL GScreenClass__Render

    MOV EAX,1
    JMP .exit

.exit_error:
    MOV EAX,-1

.exit:
    MOV ESP,EBP
    POP EBP
    RETN
%pop

Select_Game:
    PUSH EBP
    MOV EBP,ESP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI

    CALL Initialize_Spawn
    CMP EAX,-1

    ; if spawn not initialized, go to main menu
    JE 0x004F44E4

    POP EDI
    POP ESI
    POP EDX
    POP ECX
    POP EBX
    POP EBP
    RETN

; these force the game to use the actual port for sending and receiving packets rather than the default 1234
@HOOK 0x005A8ADF SendFix
@HOOK 0x005A8A75 ReceiveFix

SendFix:
    PUSH EBX
    MOV EBX,DWORD [EBP-18h]
    MOV EAX,[EBX]

    PUSH EAX
    CALL htonl

    TEST EAX,EAX
    JNE .have_port
    MOV AX,1234
.have_port:
    POP EBX
    JMP 0x005A8AE5

ReceiveFix:
    SUB ESI,4
    LEA EDX,[EBP-18h]

    ; cleanup crap from port as using it as dword
    MOV EAX,[ESI]
    AND EAX,0xFFFF0000
    MOV [ESI],EAX

    PUSH EDI
    MOV EAX,ECX
    MOV ECX,2
    JMP 0x005A8A81