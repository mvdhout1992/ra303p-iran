;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
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

; derived from ra95-hires

@HOOK 0x00552974 _hires_ini
@HOOK 0x004A9EA9 _hires_Intro
@HOOK 0x005B3DBF _hires_MainMenu
@HOOK 0x004F479B _hires_MainMenuClear
@HOOK 0x004F75FB _hires_MainMenuClearPalette
@HOOK 0x005518A3 _hires_NewGameText
@HOOK 0x005128D4 _hires_SkirmishMenu
@HOOK 0x0054D009 _hires_StripClass
@HOOK 0x004BE377 _NewMissions_Handle_Hires_Buttons_A
@HOOK 0x004BE39E _NewMissions_Handle_Hires_Buttons_B
@HOOK 0x0050692B _hires_NetworkJoinMenu
;@HOOK 0x0050223E _Blacken_Screen_Border_Menu
;@HOOK 0x0050228E _Blacken_Screen_Border_Menu2
;@HOOK 0x0054DFF5 _StripClass_Add

%define ScreenWidth     0x006016B0
%define ScreenHeight    0x006016B4

AdjustedWidth           dd 0

diff_width              dd 0
diff_height             dd 0
diff_top                dd 0
diff_left               dd 0

str_options             db "Options",0
str_width               db "Width",0
str_height              db "Height",0

left_strip_offset       dd 0
right_strip_offset      dd 0

%macro _hires_adjust_width 1
    MOV ECX, [diff_width]
    MOV EAX, %1
    ADD [EAX], ECX
%endmacro

%macro _hires_adjust_height 1
    MOV ECX, [diff_height]
    MOV EAX, %1
    ADD [EAX], ECX
%endmacro

%macro _hires_adjust_top 1
    MOV ECX, [diff_top]
    MOV EAX, %1
    ADD [EAX], ECX
%endmacro

%macro _hires_adjust_left 1
    MOV ECX, [diff_left]
    MOV EAX, %1
    ADD [EAX], ECX
%endmacro

; handles Width and Height redalert.ini options
_hires_ini:

    PUSH EBX
    PUSH EDX

.width:
    MOV ECX, 640            ; default
    MOV EDX, str_options    ; section
    MOV EBX, str_width      ; key
    LEA EAX, [EBP-0x54]     ; this
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .height
    MOV DWORD [ScreenWidth], EAX

.height:
    MOV ECX, 400
    MOV EDX, str_options
    MOV EBX, str_height
    LEA EAX, [EBP-0x54]
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .cleanup
    MOV DWORD [ScreenHeight], EAX

.cleanup:

    ; adjust width
    MOV EAX, [ScreenWidth]
    SUB EAX, 160
    MOV EBX, 24
    XOR EDX,EDX
    DIV EBX

    ; width of the game area, in tiles, 1 tile = 24px
    MOV BYTE [0x0054DB15], AL

    XOR EDX,EDX
    MOV EBX, 24
    MUL EBX

    ADD EAX, 160
    MOV [AdjustedWidth], EAX

    ; adjusted width in EAX
    MOV EDX, [AdjustedWidth]
    MOV EBX, [ScreenHeight]

    SUB EDX, 640
    SUB EBX, 400

    MOV [diff_width], EDX
    MOV [diff_height], EBX

    ; adjust top and left
    MOV EAX, [ScreenHeight]
    SHR EAX, 1
    SUB EAX, 200
    MOV [diff_top], EAX

    MOV EAX, [ScreenWidth]
    SHR EAX, 1
    SUB EAX, 320
    MOV [diff_left], EAX

    MOV EDX, [AdjustedWidth]
    MOV EBX, [ScreenHeight]

    ; main menu please wait...
    _hires_adjust_top 0x004F43BF
    _hires_adjust_left 0x004F43C4

    ; main menu version
    _hires_adjust_top 0x00501D68
    _hires_adjust_left 0x00501D63

    ; main menu buttons
    _hires_adjust_top 0x00501DBE
    _hires_adjust_left 0x00501DB9

    ; new game skill select
    ; ... ok button
    _hires_adjust_top 0x005517CB
    _hires_adjust_left 0x005517DA

    ; ... dialog
    _hires_adjust_top 0x0055188A
    _hires_adjust_left 0x0055188F

    ; ... slider
    _hires_adjust_top 0x005517F0
    _hires_adjust_left 0x005517F5

    ; load/save game dialogs
    _hires_adjust_top 0x004FCED5
    _hires_adjust_left 0x004FCED0

    ; ... list
    _hires_adjust_top 0x004FCF00
    _hires_adjust_left 0x004FCEFB

    ; ... mission description
    _hires_adjust_top 0x004FCF05
    _hires_adjust_left 0x004FCEDA

    ; ... buttons
    _hires_adjust_top 0x004FCF36
    _hires_adjust_left 0x004FCF31
    _hires_adjust_left 0x004FCF0A

    ; multiplayer dialog
    _hires_adjust_top 0x0050347D
    _hires_adjust_left 0x00503482

    ; ... modem/serial
    _hires_adjust_top 0x005034F5
    _hires_adjust_left 0x00503502

    ; ... skirmish
    _hires_adjust_top 0x0050351D
    _hires_adjust_left 0x0050352C

    ; ... network
    _hires_adjust_top 0x0050354A
    _hires_adjust_left 0x00503559

    ; ... internet
    _hires_adjust_top 0x00503577
    _hires_adjust_left 0x00503586

    ; ... cancel
    _hires_adjust_top 0x005034C9
    _hires_adjust_left 0x0050349D

    ; skirmish dialog
    ; ... all items offset top
    _hires_adjust_top 0x00512907

    ; ... some items offset left
    _hires_adjust_left 0x00512902
    _hires_adjust_left 0x0051293A
    _hires_adjust_left 0x00512944
    _hires_adjust_left 0x0051296B

    ; sound controls dialog
    _hires_adjust_top 0x005502A9
    _hires_adjust_left 0x005503BA

    ; ... song list
    _hires_adjust_top 0x00550304
    _hires_adjust_left 0x005502E4

    ; ... ok button
    _hires_adjust_top 0x00550331
    _hires_adjust_left 0x00550341

    ; ... stop button
    _hires_adjust_top 0x00550356
    _hires_adjust_left 0x00550360

    ; ... play button
    _hires_adjust_top 0x0055037C
    _hires_adjust_left 0x00550386

    ; ... shuffle button
    _hires_adjust_top 0x005503B5
    _hires_adjust_left 0x005503C2

    ; ... repeat button
    _hires_adjust_top 0x005503E7
    _hires_adjust_left 0x005503F6

    ; ... music volume slider
    _hires_adjust_top 0x0055040F
    _hires_adjust_left 0x00550414

    ; ... sound volume slider
    _hires_adjust_top 0x00550432
    _hires_adjust_left 0x00550437

    ; ... gadget offset top
    _hires_adjust_top 0x0055045A

    ; surrender dialog
    _hires_adjust_top 0x00503F0D
    _hires_adjust_left 0x00503F05

    ; ... ok button
    _hires_adjust_top 0x00503E3C
    _hires_adjust_left 0x00503E4B

    ; ... cancel button
    _hires_adjust_top 0x00503E66
    _hires_adjust_left 0x00503E75

    ; ... caption
    _hires_adjust_top 0x00503F3A
    _hires_adjust_left 0x00503F3F

    ; scrolling
    _hires_adjust_width 0x00547119
    _hires_adjust_width 0x00547129
    _hires_adjust_width 0x00547130
    _hires_adjust_width 0x0054713D
    _hires_adjust_left 0x00547144
    _hires_adjust_height 0x00547177
    _hires_adjust_height 0x00547187
    _hires_adjust_height 0x0054718E
    _hires_adjust_left 0x00547193
    _hires_adjust_top 0x0054719A

    ; buffer1
    _hires_adjust_height 0x00552629
    _hires_adjust_width 0x00552638

    ; buffer2
    _hires_adjust_height 0x00552646
    _hires_adjust_width 0x00552655

    ; power bar background
    _hires_adjust_width 0x00527736
    _hires_adjust_width 0x0052775C

    ; side bar background position
    _hires_adjust_width 0x0054D7CB
    _hires_adjust_width 0x0054D7F1
    _hires_adjust_width 0x0054D816
	
;	_hires_adjust_height 0x0054D811

    ; credits tab background position
    _hires_adjust_width 0x00553758

    ; power bar current position
    _hires_adjust_width 0x005275D9

    ; repair button left offset
    _hires_adjust_width 0x0054D166

    ; sell button left offset
    _hires_adjust_width 0x0054D1DA

    ; map button left offset
    _hires_adjust_width 0x0054D238

    ; side bar strip offset left (left bar)
    _hires_adjust_width [left_strip_offset]

    ; side bar strip icons offset
    _hires_adjust_width 0x0054D08C 

    ; side bar strip offset left (right bar)
    _hires_adjust_width [right_strip_offset]

    ; power indicator (darker shadow)
    _hires_adjust_width 0x005278A4
    _hires_adjust_width 0x005278AE
    _hires_adjust_width 0x00527A4D
    _hires_adjust_width 0x00527A52

    ; power usage indicator
    _hires_adjust_width 0x00527C0F
	
	; new missions dialog
	_hires_adjust_top 0x004BE7A5
	_hires_adjust_left 0x004BE7AA
	
	; new missions list
	_hires_adjust_top 0x004BE3DD
	_hires_adjust_left 0x004BE3E7
	
	; new missions 'Aftermath missions' caption
	_hires_adjust_top 0x004BE7D5
	_hires_adjust_left 0x004BE7DA
	
	; new missions 'Counterstrike missions' caption
	_hires_adjust_top 0x004BE7BF
	_hires_adjust_left 0x004BE7C4
	
	; network new dialog
;	_hires_adjust_left 0x0050B6E7
;	_hires_adjust_top  0x0050B6EC
	
	; network join dialog
	_hires_adjust_width 0x0050691A
;	_hires_adjust_height  0x00506910

	; sidebar stuff
;	_hires_adjust_left 0x0054D7EC 
;	_hires_adjust_left 0x0054D7F1
    
    ; kill original sidebar area (halp)
    MOV BYTE [0x0054F380], 0xC3
	
    POP EDX
    POP EBX

    JMP 0x00552979

_hires_StripClass:
    MOV DWORD [EBX+0x104F], 0x1F0 ; left strip offset left
    MOV DWORD [EBX+0x1053], 0x0B4 ; left strip offset top
    MOV DWORD [EBX+0x132F], 0x0B4 ; right strip offset top
    MOV DWORD [EBX+0x132B], 0x236 ; right strip offset left

    LEA EAX, [EBX+0x104F]
    MOV [left_strip_offset], EAX
    LEA EAX, [EBX+0x132B]
    MOV [right_strip_offset], EAX

    MOV EAX,EBX
    JMP 0x0054D033

_hires_MainMenu:
    MOV EAX, [diff_top]
    PUSH EAX
    MOV EAX, [diff_left]
    PUSH EAX
    PUSH 0
    PUSH 0
    JMP 0x005B3DC7

_hires_Intro:
    MOV EAX, [diff_top]
    PUSH EAX
    MOV EAX, [diff_left]
    PUSH EAX
    PUSH 0
    PUSH 0
    JMP 0x004A9EB1

_hires_NewGameText_top  dd 0x96
_hires_NewGameText_left dd 0x6E

_hires_NewGameText:
    _hires_adjust_top _hires_NewGameText_top
    MOV EAX, [_hires_NewGameText_top]
    PUSH EAX
    _hires_adjust_left _hires_NewGameText_left
    MOV EAX, [_hires_NewGameText_left]
    PUSH EAX
    JMP 0x005518AA

_hires_SkirmishMenu:
    MOV ECX, [diff_left]
    MOV DWORD [EBP-0x1D4], ECX
    MOV ECX, [diff_top]
    MOV DWORD [EBP-0x1D0], ECX
    XOR ECX,ECX
    JMP 0x005128E0

_hires_NetworkJoinMenu:
    MOV ECX, [diff_top]
    MOV DWORD [EBP-0x1D4], ECX
    MOV ECX, [diff_left]
    MOV DWORD [EBP-0x1D0], ECX
    XOR ECX,ECX
	JMP 0x0050693D
	
%define _Buffer_Clear 0x005C4DE0

%define GraphicsViewPortClass_HidPage 0x006807CC
%define GraphicBufferClass_VisiblePage 0x0068065C
%define GraphicsViewPortClass_SeenBuff 0x006807A4

%macro _hires_Clear 0
    PUSH 0
    PUSH GraphicsViewPortClass_HidPage
    CALL _Buffer_Clear
    ADD ESP,8
%endmacro

%macro _hires_Clear_2 0
    PUSH 0
    PUSH GraphicBufferClass_VisiblePage
;	PUSH GraphicBufferClass_SeenBuffer
    CALL _Buffer_Clear
    ADD ESP,8
%endmacro

_hires_MainMenuClear:
    _hires_Clear
    MOV EAX,1
    JMP 0x004F47A0

_hires_MainMenuClearPalette:
    _hires_Clear
    MOV EAX, [0x006807E8]
    JMP 0x004F7600

%define Set_Logic_Page 0x005C0FE7
	
_Blacken_Screen_Border_Menu:
	call 0x005C9E60
	mov eax, 1

	jmp 0x00502243
	
_Blacken_Screen_Border_Menu2:
	_hires_Clear2
	mov eax, 1

	jmp 0x00502293

_NewMissions_Handle_Hires_Buttons_A:
	mov		edx, 13Ch
	add		edx, [diff_top]
	push	edx
	
	mov     ecx, 116h
	mov     ebx, 17h
	
	mov		edx, 50h
	add		edx, [diff_left]
	push	edx
	
	jmp		0x004BE388

_NewMissions_Handle_Hires_Buttons_B:
	mov		edx, 13Ch
	add		edx, [diff_top]
	push	edx
	
	mov     ecx, 116h
	mov     ebx, 13h
	
	mov		edx, 203h
	add		edx, [diff_left]
	push	edx
	
	jmp		0x004BE3B2