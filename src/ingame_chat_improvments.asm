@HOOK 0x00534D59			_Load_MessageDelay
;@HOOK 0x0050559B			_Check_MessageList_Messages_Count
; 004A79A8

_Check_MessageList_Messages_Count:
;	cmp     eax, [edx+0Ch] ; default check is for 6?
	cmp     eax, 12 ; default check is for 6?
	jle     0x005055EB
	jmp		0x005055A0

_Load_MessageDelay:
	mov     ax, 100h ; 200h = 200% -> ~30 secs
;	mov     ax, [eax]
	mov     [edx], ax
	jmp		0x00534D5F