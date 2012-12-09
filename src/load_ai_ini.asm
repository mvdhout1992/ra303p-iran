;Load an AI.ini containing AI settings after loading aftermath.ini before loading a scenario's rules changes

@HOOK 0x0053D645 _Read_Scenario_INI_Load_AI_INI

%define RulesClass__Rule 0x00666704
%define RuleINI 0x00666688

%define INIClass__INIClass                          0x004C7C60
%define INIClass__Load                              0x004F28C4
%define	CCFileClass__CCFileClass					0x004627D4
%define	CCINIClass__Load							0x00462F50
%define CCINIClass__CCINIClass 						0x004C7C60
%define RulesClass__AI		 						0x00536698

str_aiini db"AI.INI",0

; sizes not actually verified
CCFileClass_AIINI  TIMES 256 db 0
CCINIClass_AIINI    TIMES 256 db 0

_Read_Scenario_INI_Load_AI_INI:
	call 	0x00537564
	
	mov     edx, str_aiini
	mov    	eax, CCFileClass_AIINI
	call    CCFileClass__CCFileClass
	
	mov		eax, CCINIClass_AIINI
	call	CCINIClass__CCINIClass
	
	xor     ebx, ebx
	mov     edx, CCFileClass_AIINI
	mov     eax, CCINIClass_AIINI
	call    CCINIClass__Load
	
	mov     edx, CCINIClass_AIINI
	mov     eax, RulesClass__Rule
	call    RulesClass__AI
	
	jmp		0x0053D64A