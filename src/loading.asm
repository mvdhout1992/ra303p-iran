; Load our settings from here

@HOOK	0x004F446C		_Init_Game_Hook_Load

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define INIClass__Get_Int                           0x004F3660
%define INIClass__Get_String                        0x004F3A34
%define INIClass__Get_Bool							0x004F3ACC
%define FileClass__FileClass                        0x004627D4
%define FileClass__Is_Available                     0x00462A30

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

INIClass_redalertini5 TIMES 64 db 0
FileClass_redalertini5	TIMES 128 db 0

extraremaptable TIMES 2400 db 0

%define colorwhiteoffset	0
%define colorblackoffset	282
%define colourbrightyellowoffset 564

aftermathfastbuildspeed	db 0
videointerlacemode	dd 2
skipscorescreen db 0
randomstartingsong db 0
removeaitechupcheck db 0
fixaiparanoid db 0
fixaially db 0
fixformationspeed db 0

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

_Init_Game_Hook_Load:
	push 	ecx
	push 	ebx
	push 	edx
	push 	eax
	
	Load_INIClass str_redalertini5, FileClass_redalertini5, INIClass_redalertini5
	
	INI_Get_Int_ INIClass_redalertini5, str_options5, str_videointerlacemode, 2 ; 2 = deinterlace videos
	mov		[videointerlacemode], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_skipscorescreen, 0
	mov		[skipscorescreen], al
	
	INI_Get_Bool_ INIClass_redalertini5, str_options5, str_randomstartingsong, 0
	mov		[randomstartingsong], al
	
	INI_Get_Bool_ 0x00666688, str_aftermath, str_aftermathfastbuildspeed, 0
	mov		[aftermathfastbuildspeed], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_removeaitechupcheck, 0
	mov		[removeaitechupcheck], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_fixaiparanoid, 0
	mov		[fixaiparanoid], al
	
	INI_Get_Bool_ 0x00666688, str_ai, str_fixaially, 0
	mov		[fixaially], al
	
	INI_Get_Bool_ 0x00666688, str_general, 	str_fixformationspeed, 0
	mov		[fixformationspeed], al
	
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