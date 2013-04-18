; Crashes sometimes with 7 AI players, seems to try to get an eight one then

;@HOOK	0x0053E052 		_Assign_Houses_Color_Remaps_Indexes
;@HOOK	0x0053E069		_Assign_Houses_Color_Remaps_Index_Check
;@HOOK	0x0053DFCE		_Assign_Houses_Color_Remaps_Index_Check2
;@HOOK	0x0053B81D		_Assign_Houses_Colour_Remaps_Cleanup
;@HOOK	0x0053E158		_Assign_Houses_Colour_Remaps_NULL_Check
@HOOK	0x004D654B		_HouseClass__Remap_Table_Return_Custom_Remaps
@HOOK	0x0052E4E7		_RadarClass__Draw_It_Custom_Remaps
@HOOK	0x00532767		_RadarClass__Draw_Names_Custom_Remaps
@HOOK	0x0049EF65		_CellClass__Cell_Color
@HOOK	0x0052EAB1		_RadarClass__Render_Infantry
@HOOK	0x0052EBC3		_RadarClass__Render_Infantry2

usedremaps: TIMES 25 db 0
%define amountofremaps	10	; Total amount of remaps starting from 0, the default is 7 (so 8 remaps)

_RadarClass__Render_Infantry2:
	xor     ecx, ecx
	cmp		eax, 7
	jg		.Custom_Remap
	
	imul    eax, 11Ah
	jmp		0x0052EBCB
	
.Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	add		eax, 119h
	mov     BYTE cl, [eax]
	jmp		0x0052EBD1

_RadarClass__Render_Infantry:
	xor     ecx, ecx
	mov     esi, [ebp-30h]

	cmp		eax, 7
	jg		.Custom_Remap
	
	imul    eax, 11Ah
	jmp		0x0052EABC
	
.Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	add		eax, 119h
	mov     BYTE cl, [eax]
	jmp		0x0052EAC2
	
_CellClass__Cell_Color:
	cmp		eax, 7
	jg		.Custom_Remap

	imul    eax, 11Ah
	jmp		0x0049EF6B
	
.Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	add		eax, 119h
	mov     al, [eax]
	jmp		0x0049EF71

_RadarClass__Draw_Names_Custom_Remaps:
	cmp		eax, 7
	jg		.Custom_Remap
	
	imul    eax, 11Ah
	jmp		0x0053276D
	
.Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	mov		edx, eax
	jmp		0x00532774

_RadarClass__Draw_It_Custom_Remaps:
	cmp		eax, 7
	jg		.Custom_Remap

	imul    eax, 11Ah
	jmp		0x0052E4ED

.Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	push    136h
	push    0
	jmp		0x0052E4F9

_HouseClass__Remap_Table_Return_Custom_Remaps:

	cmp		eax, 7
	jg		.Return_Custom_Remap
	
	imul    eax, 11Ah
	jmp		0x004D6551

.Return_Custom_Remap:
	sub		eax, 8
	imul    eax, 11Ah
	add		eax, extraremaptable
	add		eax, 2
	mov     esp, ebp
	pop     ebp
	retn

_Assign_Houses_Colour_Remaps_NULL_Check:
	cmp		eax, 14h
	jz		0x0053E184
	call 	0x004D2CB0

	jmp		0x0053E15D

_Assign_Houses_Colour_Remaps_Cleanup:
	mov		edx, 0
	
.Loop:
	mov		BYTE [usedremaps+edx], 0
	inc		edx
	cmp		edx, 24
	jnz		.Loop

	pop     edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	pop     ebp
	jmp		0x0053B823

_Assign_Houses_Color_Remaps_Index_Check2
	mov		BYTE [usedremaps+edx], 1
	call	0x004D8CA8
	jmp		0x0053DFD3

_Assign_Houses_Color_Remaps_Indexes:
	mov     edi, amountofremaps
	jmp		0x0053E057
	
_Assign_Houses_Color_Remaps_Index_Check:

	cmp     BYTE cl, [usedremaps+ebx]
	jnz		0x0053E059
	
	mov     BYTE [usedremaps+ebx], 1
	
	jmp		0x0053E06F
	
