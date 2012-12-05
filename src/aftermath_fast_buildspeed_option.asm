;reads the keyword boolean AftermathFastBuildSpeed from the section [Aftermath] in rules.ini to enable quick build spede with the Aftermath expansion enabled (it's normally disabled if the expansion is enabled)

@HOOK	0x005611F3		_Time_To_Build_NewUnitsEnabled_Check

FileClass_rulesini TIMES 128 db 0
INIClass_rulesini TIMES 128 db 0
str_rules_ini db "RULES.INI",0
str_aftermathfastbuildspeed db "AftermathFastBuildSpeed",0
str_aftermath db "Aftermath",0

str_orespreads db "OreSpreads",0
str_general3 db "General",0

; args: <INI Name>, <FileClass>, <INIClass>
%macro Load_INIClass 3
	MOV EDX, %1
    MOV EAX, %2
    CALL FileClass__FileClass

    ; check ini exists
    MOV EAX, %2
    XOR EDX, EDX
    CALL FileClass__Is_Available
;    TEST EAX,EAX
;    JE .exit_error

    ; initialize INIClass
    MOV EAX, %3
    CALL INIClass__INIClass

    ; load FileClass to INIClass
    MOV EDX, %2
    MOV EAX, %3
    CALL INIClass__Load
%endmacro

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro INI_Get_Bool_ 4
    MOV ECX, DWORD %4
    MOV EBX, DWORD %3
    MOV EDX, DWORD %2
    MOV EAX, %1
    CALL INIClass__Get_Bool
%endmacro

_Time_To_Build_NewUnitsEnabled_Check:

	cmp		BYTE [aftermathfastbuildspeed], 1
	

	
	JZ		0x00561206
	
	cmp     DWORD [0x00665DE0], 0
	jz      0x00561206
	jmp		0x005611FC