@HOOK 0x005B38DD	_Mouse_Wheel_Sidebar_Scrolling

Scrolling db 0

%define HouseClass_PlayerPtr 	0x00669958
%define GameActive				0x00669924

_Mouse_Wheel_Sidebar_Scrolling:
	cmp		BYTE [mousewheelscrolling], 1
	jnz		.out
	mov     esi, [ebp+0Ch]
	cmp     esi, 20Ah               ;WM_MOUSEHWHEEL
	jnz 	.out
 
	mov     ecx, HouseClass_PlayerPtr
	test    ecx, ecx
	jz		.out
 
	mov 	cl, byte [Scrolling]
	test    cl, cl
	jnz 	.out
 
	mov 	byte [Scrolling], 1
	mov     edx, [ebp+10h]
	shr     edx, 10h
	test    dx, dx
	jl		.scroll
 
	mov     ebx, 0FFFFFFFFh
	mov     edx, 1
	mov     eax, MouseClass_Map
	call    0x0054D684      ;//SidebarClass::Scroll
 
	jmp		.done
 
;-----------------------------------------------
.scroll:
	mov     ebx, 0FFFFFFFFh
	xor		edx, edx
	mov     eax, MouseClass_Map
	call    0x0054D684      ;//SidebarClass::Scroll
 
.done:
	mov   	byte [Scrolling], 0
 
.out:
	cmp     esi, 1Ch
	jb		0x5B38EE
 
	jmp		0x5B38E2