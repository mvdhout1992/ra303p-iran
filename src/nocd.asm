;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

@HOOK 0x004AAC58 _Force_CD_Available
@HOOK 0x004F7A10 _Init_CDROM_Access
@HOOK 0x005CDD6E _GetCDClass__GetCDClass_GetDriveType
@HOOK 0x004C7B2A _Patch_Out_Early_GetCDClass_Init
@HOOK 0x00551FC8 _Patch_In_Later_GetCDClass_Init
;@HOOK 0x004AAE0C _Fix_CDROM_Name_Get_Crash

%define GetCDClass__GetCDClass 	0x005CDD10
%define CDList					0x00680884

_Fix_CDROM_Name_Get_Crash:
	cmp		eax, 12
	jng		.No_EAX_Adjust
	mov		eax, 0
	
.No_EAX_Adjust:
	cmp     esi, 0FFFFFFFFh
	jnz     0x004AAE25
	jmp		0x004AAE11

_Force_CD_Available:
	cmp BYTE [nocdmode], 1
	jz	.Ret_Now
	
	push    ebp
	mov     ebp, esp
	push    ebx
	push    ecx
	push    edx
	push    esi
	jmp		0x004AAC5F
	
.Ret_Now:
    MOV EAX,1
    RETN

_Init_CDROM_Access:
	cmp BYTE [nocdmode], 1
	jz	.Ret_Now
	
	sub     esp, 1Ch
	xor     ah, ah
	jmp		0x004F7A15

.Ret_Now:
	lea     esp, [ebp-14h]
	pop		edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	pop     ebp
	
    RETN

_GetCDClass__GetCDClass_GetDriveType:
	cmp BYTE [nocdmode], 1
	jz		.Get_Hard_Drive

	cmp     eax, 5
	jnz     0x005CDD50
	mov     eax, [esi+68h]
	jmp		0x005CDD76

.Get_Hard_Drive:
	cmp     eax, 3
	jnz     0x005CDD50
	mov     eax, [esi+68h]
	jmp		0x005CDD76
	
_Patch_Out_Early_GetCDClass_Init:
	jmp		0x004C7B40
	
_Patch_In_Later_GetCDClass_Init:

	mov     eax, CDList
	call    GetCDClass__GetCDClass
	mov     eax, CDList
	jmp		0x00551FCD