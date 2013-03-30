; Fix RulesClass data (data loaded from rules.ini) Out of Sync desync while playing online after playing certain mod maps and then playing a normal map.
; This bug happens because Westwood geniuses load the default values once, then use the previous value as default while reading rules.ini when the previous value
; wasn't found. Because Westwood left out a few values in rules.ini that are loaded by this default value, the game will load the previous value of a mod map that does
; specify any value left out by Westwood's rules.ini in their mod map, and if this value is different from the game's default. E.g.:

; Rules.ini doesn't contain value herp=, but a mod map does, and the game does try to load herp=, because it isn't found the default value is loaded instead. The first
; time this happens is when rules.ini is loaded at startup, it will be initialized to the previous variable's value which is specified RulesClass' constructor. Once this ; mod map is loaded however, the value will be set to the mod map's. Whenever the game loads rules.ini again it will load the default value because rules.ini doesn't
; contain herp=, THIS DEFAULT VALUE IS THE PREVIOUS VALUE OF THE VARIABLE WHICH NOW IS THE MOD MAPS' VALUE. So everytime rules.ini is loaded again the value of herp= will
; stay the mod map's value. Because this value is different from the default rules.ini the game goes out of sync with people who have the normal rules.ini value.

; Westwood coding at its finest. This fix loads FunkyFr3sh's OOS-FIX.ini before any other file while loading a scenario. His file contains everything that rules.ini 
; implicitly loads (by not specifying every value and having the game use defaults) but his file explictly states every value the game uses. This explicitly mentioning 
; every value fixes the bug because no wrong default value is loaded.

@HOOK 0x0053D541	_Read_Scenario_INI_Load_OOS_FIX_INI
@HOOK 0x00538B73    _Load_Game_Load_OOS_FIX_INI

%define RulesClass__Rule 0x00666704
%define RuleINI 0x00666688

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define	CCFileClass__CCFileClass					0x004627D4
%define	CCINIClass__Load							0x00462F50

%define RulesClass__General 						0x005342DC
%define RulesClass__Recharge 						0x00535CF0
%define RulesClass__AI		 						0x00536698
%define RulesClass__Powerups 						0x00536D3C
%define RulesClass__Land_Types 						0x00536E8C
%define RulesClass__Themes	 						0x00537164
%define RulesClass__IQ		 						0x00537278
%define RulesClass__Objects 						0x005373DC
%define RulesClass__Difficulty 						0x00537564
%define RulesClass__General 						0x005342DC
%define RulesClass__General 						0x005342DC
%define CCINIClass__CCINIClass 						0x004C7C60
 

str_fixoosini db"OOS-FIX.INI",0

; sizes not actually verified
CCFileClass_OOSFIX  TIMES 256 db 0
CCINIClass_OOSFIX   TIMES 256 db 0

_Load_Game_Load_OOS_FIX_INI:
    Save_Registers
    
    mov     edx, str_fixoosini
	mov    	eax, CCFileClass_OOSFIX
	call    CCFileClass__CCFileClass
	
	mov		eax, CCINIClass_OOSFIX
	call	CCINIClass__CCINIClass 
	
	xor     ebx, ebx
	mov     edx, CCFileClass_OOSFIX
	mov     eax, CCINIClass_OOSFIX
	call    CCINIClass__Load
		
	mov		eax, CCINIClass_OOSFIX
	call	0x00463BD4
	cmp		eax, 0x1539DF28
	jnz		.Ret

	mov 	BYTE [0x00665E02], 55h ; EngineerDamage
	mov 	BYTE [0x00665E04], 40h ; EngineerCaptureLevel
	
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__General
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Recharge
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__AI
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Powerups
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Land_Types
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Themes
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__IQ
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Objects
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Difficulty
	
.Ret:
    
    Restore_Registers
    mov     edx, RuleINI
	mov     eax, RulesClass__Rule
    jmp     0x00538B7D

_Read_Scenario_INI_Load_OOS_FIX_INI:

	mov     edx, str_fixoosini
	mov    	eax, CCFileClass_OOSFIX
	call    CCFileClass__CCFileClass
	
	mov		eax, CCINIClass_OOSFIX
	call	CCINIClass__CCINIClass 
	
	xor     ebx, ebx
	mov     edx, CCFileClass_OOSFIX
	mov     eax, CCINIClass_OOSFIX
	call    CCINIClass__Load
		
	mov		eax, CCINIClass_OOSFIX
	call	0x00463BD4
	cmp		eax, 0x1539DF28
	jnz		.Ret

	mov 	BYTE [0x00665E02], 55h ; EngineerDamage
	mov 	BYTE [0x00665E04], 40h ; EngineerCaptureLevel
	
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__General
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Recharge
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__AI
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Powerups
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Land_Types
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Themes
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__IQ
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Objects
	mov     edx, CCINIClass_OOSFIX
	mov     eax, RulesClass__Rule
	call    RulesClass__Difficulty
	
.Ret:
	mov     edx, RuleINI
	mov     eax, RulesClass__Rule
	jmp		0x0053D546