@HOOK	0x004A5753		_Keyboard_Process_Home_Key_Overwrite
@HOOK	0x0054D916		_Patch_Out_Erroneous_Sidebar_Activate_CALL
@HOOK 	0x004C9F46		_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check
@HOOK	0x004CAA29		_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check2
@HOOK	0x004A6206		_UnhardCode_Keyboard_Key0
@HOOK	0x004A61D3		_UnhardCode_Keyboard_Key9
@HOOK	0x004A61A0		_UnhardCode_Keyboard_Key8
@HOOK	0x004A616D		_UnhardCode_Keyboard_Key7
@HOOK	0x004A613A		_UnhardCode_Keyboard_Key6
@HOOK	0x004A6107		_UnhardCode_Keyboard_Key5
@HOOK	0x004A60D4		_UnhardCode_Keyboard_Key4
@HOOK	0x004A60A1		_UnhardCode_Keyboard_Key3
@HOOK	0x004A606E		_UnhardCode_Keyboard_Key2
@HOOK	0x004A603E		_UnhardCode_Keyboard_Key1

%define SessionClass__Session 0x0067F2B4
%define KeyResign	0x006681C0

ResignKeyPressed: dd 0

_UnhardCode_Keyboard_Key1:
	jmp		0x004A6056

_UnhardCode_Keyboard_Key2:
	jmp		0x004A6089

_UnhardCode_Keyboard_Key3:
	jmp		0x004A60BC

_UnhardCode_Keyboard_Key4:
	jmp		0x004A60EF

_UnhardCode_Keyboard_Key5:
	jmp		0x004A6122

_UnhardCode_Keyboard_Key6:
	jmp		0x004A6155

_UnhardCode_Keyboard_Key7:
	jmp		0x004A6188

_UnhardCode_Keyboard_Key8:
	jmp		0x004A61BB

_UnhardCode_Keyboard_Key9:
	jmp		0x004A61EE

_UnhardCode_Keyboard_Key0:
	jmp		0x004A6221

_Keyboard_Process_Home_Key_Overwrite:
	cmp		WORD ax, [keysidebartoggle]
	jz		.Toggle_Sidebar
	
	cmp		WORD ax, [KeyResign]
	jz		.Resign_Key

.Out:
	cmp     ax, [0x006681B4] ; KeyNext
	jnz     0x004A57DF
	jmp		0x004A5760

.Toggle_Sidebar:
	push	eax
	
	mov eax, 0 ; Crash	
;	mov     eax, MouseClass_Map
	mov		edx, 0FFFFFFFFh
	call   	0x0054DA70 ;  SidebarClass::Activate(int)
	
	pop		eax
	jmp		.Out

.Resign_Key:
	push	eax

	cmp		BYTE [SessionClass__Session],0
	jz		.Out
	mov		DWORD [ResignKeyPressed], 1
	call	0x00528DCC ; Queue_Options(void)
	
	pop		eax
	jmp		.Out
	
_Patch_Out_Erroneous_Sidebar_Activate_CALL:
	jmp		0x0054D91B

_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check:
	cmp		DWORD [ResignKeyPressed], 0
	jnz		0x004CA9C9

.Out:
	test    eax, eax
	jle     0x004CA15E
	jmp		0x004C9F4E
	
_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check2
	cmp		DWORD [ResignKeyPressed], 0
	jz		0x004CA7A5 
		
	mov		DWORD [ResignKeyPressed], 0
	lea     esp, [ebp-14h]
	pop     edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	pop     ebp
	retn	