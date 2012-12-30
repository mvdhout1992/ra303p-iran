@HOOK 0x00052C2B8		_Print_CRCs_Debug_On_Check
@HOOK 0x005C3548		_Mono_Printf_Redirect
@HOOK 0x005CD97B		_Printf_Hook
@HOOK 0x005B3914		_WWDebugString_Hook
@HOOK 0x005C4720		_IconCacheClass__Draw_It_Debug
@HOOK 0x005A8E00		_IPXInterfaceClass__Open_Socket_Debug
@HOOK 0x005A8E72		_IPXInterfaceClass__Open_Socket_Debug2
@HOOK 0x005A8EDA		_IPXInterfaceClass__Open_Socket_Debug3
@HOOK 0x005A8F22		_IPXInterfaceClass__Open_Socket_Debug4
@HOOK 0x005A8F6A		_IPXInterfaceClass__Open_Socket_Debug5
@HOOK 0x005BBE3F		_WinTimerClass__WinTimerClass_Debug
@HOOK 0x005D2A18		_WinModemClass__Serial_Port_Open_Debug 
@HOOK 0x005D2A8C		_WinModemClass__Serial_Port_Open_Debug2
@HOOK 0x005A87DB		_UDPInterfaceClass__Open_Socket_Debug
@HOOK 0x005A84A8		_WinsockInterfaceClass__Set_Socket_Options_Debug
@HOOK 0x005A84F1		_WinsockInterfaceClass__Set_Socket_Options_Debug2
@HOOK 0x005A81FA 		_WinsockInterfaceClass__Init_Debug
@HOOK 0x005A822D		_WinsockInterfaceClass__Init_Debug2
@HOOK 0x0059E770		_OutputDebugStringW95_Hook
@HOOK 0x005CDF08		_assert_Debug

%define fopen				0x005D40B9
%define fprintf				0x005D41A5
%define	fclose				0x005D41C6
%define	AssertionFailed		0x005F588C

str_fopenmode db "a+",0
str_debuglog db "DebugLog.txt",0
str_assertlog db "Assert.txt",0
str_formatstring db "%s",0
str_test db "test",0
str_test2 db "test2",0

; args: <output file>, <format>, <vargs>
%macro Debug_Log 3
	Save_Registers

	push	%3
	push	%2
	push	%1
	
	mov     edx, str_fopenmode
	pop    	eax
	call    fopen
	mov     ebx, eax
	push    ebx
	call    fprintf
	add     esp, 0Ch
	mov     eax, ebx
	call    fclose
	
	Restore_Registers
%endmacro

_assert_Debug:
	
	mov     edx, str_fopenmode
	push    str_assertlog
	call    fopen
	mov		ebx, eax
	
	push	eax
	push    ecx
	push    ebx
	push    edx
	push    AssertionFailed
	push    ebx
	call    fprintf
	add     esp, 14h
	
	mov		eax, ebx
	call	fclose
	
	jmp		0x005CDF21

_OutputDebugStringW95_Hook:
	pop 	eax
	Debug_Log str_debuglog, eax, 0
	sub		esp, 4
	retn

_WinsockInterfaceClass__Init_Debug2:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8234

_WinsockInterfaceClass__Init_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8201

_WinsockInterfaceClass__Set_Socket_Options_Debug2:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A84F8
	
_WinsockInterfaceClass__Set_Socket_Options_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A84AF

_UDPInterfaceClass__Open_Socket_Debug
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A87E2

_WinModemClass__Serial_Port_Open_Debug2:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005D2A93

_WinModemClass__Serial_Port_Open_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005D2A1F

_WinTimerClass__WinTimerClass_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005BBE46

_IPXInterfaceClass__Open_Socket_Debug5:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8F71

_IPXInterfaceClass__Open_Socket_Debug4:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8F29

_IPXInterfaceClass__Open_Socket_Debug3:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8EE1

_IPXInterfaceClass__Open_Socket_Debug2:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8E79

_IPXInterfaceClass__Open_Socket_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005A8DEA

_IconCacheClass__Draw_It_Debug:
	Debug_Log str_debuglog, eax, 0
	jmp		0x005C4727

_WWDebugString_Hook:
	Debug_Log str_debuglog, eax, 0
	retn

_Printf_Hook:
	mov edx, [esp+8]
	Debug_Log str_debuglog, edx, edi
.Ret:
	push    ebx
	push    edx
	sub     esp, 4
	jmp		0x005CD980

;Mono_PrintF() 0x005C3548: arg 1 = format, arg 2 = varargs
_Mono_Printf_Redirect:
	mov eax, [esp+8]
	mov ecx, [esp+12]
	Debug_Log str_debuglog, ecx, ebx
	sub esp, 4
	retn

_Print_CRCs_Debug_On_Check:
	; do cmp
	CMP BYTE [debuglogging], 1
	jz .Debug_On
	
	retn
	
.Debug_On:
	Debug_Log str_debuglog, str_test2, 0

	push    ebp
	mov     ebp, esp
	push    ebx
	push    ecx
	push    edx
	push    esi
	jmp		0x0052C2BF