@HOOK 0x00589960 _Version_Name

str_version db "303p-i Beta2", 0

_Version_Name:
	mov		eax, str_version
	retn

