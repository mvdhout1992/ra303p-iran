@HOOK 0x00513363	_Skirmish_Dialog_DropList_Add_Amount
@HOOK 0x005070BF	_Net_Join_Dialog_DropList_Add_Amount
@HOOK 0x00513399	_Skirmish_Dialog_DropList_Add_Greece_Spain 
@HOOK 0x005070F5	_Net_Join_Dialog_DropList_Add_Greece_Spain
@HOOK 0x00514686	_Skirmish_Dialog_DropList_Get_Index_Fixup
@HOOK 0x005133A8	_Skirmish_Dialog_DropList_Set_Index_Fixup
@HOOK 0x0054AC83	_SessionClass_Jump_Over_Side_Bounds_Check
@HOOK 0x00508759	_Net_Join_Dialog_DropList_Get_Index_Fixup
@HOOK 0x005070FE	_Net_Join_Dialog_DropList_Set_Index_Fixup
@HOOK 0x0050892F	_Net_Join_Dialog_DropList_Set_Index_Fixup2
@HOOK 0x00508C3F	_Net_Join_Dialog_DropList_Set_Index_Fixup3
@HOOK 0x00506C28 	_Net_Join_Dialog_DropList_Increase_Drop_List_Display_Size
;@HOOK 0x0050C154	_Net_New_Dialog_DropList_Set_Index_Fixup

%define	Extract_String					0x005C5070
%define SystemStrings					0x0066991C
%define DropListClass__Add_Item			0x004B8628

_Net_Join_Dialog_DropList_Increase_Drop_List_Display_Size:
	call	0x005B9330
	push    eax
	push    70h
	jmp		0x00506C30

_Net_Join_Dialog_DropList_Set_Index_Fixup:
	lea     eax, [ebp-0BDCh]
;	sub     edx, 2
	
	cmp		edx, 1
	jg		.Jump_Add
	
	add		edx, 8

.Jump_Add:
	sub     edx, 2	
	jmp		0x00507107
	
_Net_Join_Dialog_DropList_Set_Index_Fixup3:
	push 	eax
	cmp		eax, 8
	je 		.Ret_Custom
	cmp		eax, 9
	je		.Ret_Custom
	jmp		.Ret

.Ret_Custom:
	add 	esp, 4
	sub		eax, 8
	mov		[0x0067F314], al
	jmp		0x00508C44
	
.Ret:
	pop		eax
	mov		[0x0067F314], al
	jmp		0x00508C44

_Net_Join_Dialog_DropList_Set_Index_Fixup2:
	push 	eax
	cmp		eax, 8
	je 		.Ret_Custom
	cmp		eax, 9
	je		.Ret_Custom
	jmp		.Ret

.Ret_Custom:
	add 	esp, 4
	sub		eax, 8
	mov		[0x0067F314], al
	jmp		0x00508934
	
.Ret:
	pop		eax
	mov		[0x0067F314], al
	jmp		0x00508934
	
; We added greece and spain to the end, if they're selected the
; wrong countries, we need to fix up the index to get the right country
_Net_Join_Dialog_DropList_Get_Index_Fixup:
	push 	eax
	cmp		eax, 8
	je 		.Ret_Custom
	cmp		eax, 9
	je		.Ret_Custom
	jmp		.Ret

.Ret_Custom:
	add 	esp, 4
	sub		eax, 8
	mov		[0x0067F314], al
	jmp		0x0050875E
	
.Ret:
	pop		eax
	mov		[0x0067F314], al
	jmp		0x0050875E

	
; 371 = Spain, 374 = Greece 
_Net_Join_Dialog_DropList_Add_Greece_Spain:
	mov 	edx, [0x0067F30F+2]
	push	edx
	
	mov     eax, [SystemStrings]
	mov     edx, 371
	call    Extract_String
	mov     edx, eax

	
	lea     eax, [ebp-0BDCh]
	call	DropListClass__Add_Item
	
	mov     eax, [SystemStrings]
	mov     edx, 374
	call    Extract_String
	mov     edx, eax
	
	lea     eax, [ebp-0BDCh]
	call	DropListClass__Add_Item
	
	pop		edx
	jmp		0x005070FB

_Net_Join_Dialog_DropList_Add_Amount:
	mov     [ebp-1Ch], cl
	cmp     cl, 7 ;7
	jmp		0x005070C5

_SessionClass_Jump_Over_Side_Bounds_Check:
	jmp		0x0054ACA3

_Skirmish_Dialog_DropList_Set_Index_Fixup:
	cmp		edx, 1
	jg		.Jump_Add
	
	add		edx, 8

.Jump_Add:
	sub     edx, 2	
	mov     ebx, 1
	jmp		0x005133B0

; We added greece and spain to the end, if they're selected the
; wrong countries, we need to fix up the index to get the right country
_Skirmish_Dialog_DropList_Get_Index_Fixup:
	push 	eax
	cmp		eax, 8
	je 		.Ret_Custom
	cmp		eax, 9
	je		.Ret_Custom
	jmp		.Ret

.Ret_Custom:
	add 	esp, 4
	sub		eax, 8
	mov		[0x0067F314], al
	jmp		0x0051468B
	
.Ret:
	pop		eax
	mov		[0x0067F314], al
	jmp		0x0051468B

_Skirmish_Dialog_DropList_Add_Amount:
	mov     [ebp-20h], ch
	cmp     ch, 7
	jmp		0x00513369
	
; 371 = Spain, 374 = Greece 
_Skirmish_Dialog_DropList_Add_Greece_Spain:
	mov 	edx, [0x0067F30F+2]
	push	edx
	
	mov     eax, [SystemStrings]
	mov     edx, 371
	call    Extract_String
	mov     edx, eax
	
	lea		eax, [ebp-0C64h]
	call	DropListClass__Add_Item
	
	mov     eax, [SystemStrings]
	mov     edx, 374
	call    Extract_String
	mov     edx, eax
	
	lea		eax, [ebp-0C64h]
	call	DropListClass__Add_Item
	
	pop		edx
	jmp		0x0051339F