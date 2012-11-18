@HOOK 0x005B3491 _Focus_Loss
;@HOOK 0x005B3624 _Check_For_Focus_Loss
;@HOOK 0x005BF220 _Attempt_Audio_Restore
@HOOK 0x005B3895 _test 
@HOOK 0x005B30C7 _test2

; Fixes the "music changes when alt+tabbing out" bug for some reason
_Focus_Loss:
;int 3
jmp		0x005B349B


_Check_For_Focus_Loss:
	mov		ebp, 800000
	mov eax, 0
	retn

_Attempt_Audio_Restore:
	retn

_test:
	mov DWORD [0x00665F64], 1
	jmp		0x005B389A
	
_test2:
	lea     ebx, [eax*3]
	jmp		0x005B30CE