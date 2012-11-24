@HOOK 0x004A8DE2 _Play_Movie
@HOOK 0x004637FF _CCINIClass_Get_VQType
@HOOK 0x0053A1D3 _Start_Scenario_VQName ; Might cause movie loading issues
@HOOK 0x004F5061 _Extra_Sneak_Peaks

%define strcmpi_ 		0x005B8B50
%define	_Play_Movie_		0x004A8DCC

derp_str db "derp",0
ALLX1_str db "ALLX1",0
ALLX2_str db "ALLX2",0
ALLX3_str db "ALLX3",0
ALLX4_str db "ALLX4",0
ALLX1W_str db "ALLX1W",0
ALLX2W_str db "ALLX2W",0
ALLX3W_str db "ALLX3W",0
ALLX4W_str db "ALLX4W",0
ALLXEND_str db "ALLXEND",0
ANTBRF_str db "ANTBRF",0
CHRONTNK_str db "CHRONTNK",0
GPSLNCH_str db "GPSLNCH",0
INTROX_str db "INTROX",0
NUKETRUK_str db "NUKETRUK",0
SNOWFILD_str db "SNOWFILD_str",0
SOVEXP1_str db "SOVEXP1",0
SOVEXP2_str db "SOVEXP2",0
SOVEXP3_str db "SOVEXP3",0
SOVEXP4_str db "SOVEXP4",0
SOVEXP1W_str db "SOVEXP1W",0
SOVEXP2W_str db "SOVEXP2W",0
SOVEXP3W_str db "SOVEXP3W",0
SOVEXP4W_str db "SOVEXP4W",0
SOVXEND_str db "SOVXEND",0
TANESCP_str db "TANESCP",0
TESLATNK_str db "TESLATNK",0
SIZZLE3_str db "SIZZLE3",0
SIZZLE4_str db "SIZZLE4",0

; args: <video name no extension>, <index to return>
%macro Video_Name_To_Index 2
	lea eax, [ebp-88h]
	MOV edx, %1
	call    strcmpi_
	test    eax, eax
	mov al, %2
	jz 0x00463828 
%endmacro

; args: <video name no extension>, <index to return>
%macro Index_To_Video_Name 2
	cmp al, %2
	push eax
	mov eax, %1
	je Load_Custom_String
	pop eax
%endmacro

; args: <video index>
%macro Play_Movie 1
	mov     ebx, 1
	mov     edx, 0FFFFFFFFh
	mov     eax, %1
	call    _Play_Movie_
%endmacro

_Extra_Sneak_Peaks:
	call	_Play_Movie_
	
	Play_Movie 176 ; SIZZLE3.VQA
	Play_Movie 177 ; SIZZLE4.VQA
	Play_Movie 162 ; INTROX.VQA
	
	jmp		0x004F5066

_Start_Scenario_VQName:
	mov     edi, 0
	jmp 	0x0053A1DA

_CCINIClass_Get_VQType:
	
	xor     ah, ah
	mov     [ebp-8h], ah
	
	Video_Name_To_Index ALLX2_str, 151
	Video_Name_To_Index ALLX1_str, 150  
	Video_Name_To_Index ALLX3_str, 152
	Video_Name_To_Index ALLX4_str, 153
	Video_Name_To_Index ALLX2W_str, 154
	Video_Name_To_Index ALLX1W_str, 155  
	Video_Name_To_Index ALLX3W_str, 156
	Video_Name_To_Index ALLX4W_str, 157
	Video_Name_To_Index ALLXEND_str, 158
	Video_Name_To_Index ANTBRF_str, 159 
	Video_Name_To_Index CHRONTNK_str, 160
	Video_Name_To_Index GPSLNCH_str, 161
	Video_Name_To_Index INTROX_str, 162
	Video_Name_To_Index NUKETRUK_str, 163
	Video_Name_To_Index SNOWFILD_str, 164
	Video_Name_To_Index SOVEXP1_str, 165
	Video_Name_To_Index SOVEXP2_str, 166
	Video_Name_To_Index SOVEXP3_str, 167
	Video_Name_To_Index SOVEXP4_str, 168
	Video_Name_To_Index SOVEXP1W_str, 169
	Video_Name_To_Index SOVEXP2W_str, 170
	Video_Name_To_Index SOVEXP3W_str, 171
	Video_Name_To_Index SOVEXP4W_str, 172 
	Video_Name_To_Index SOVXEND_str, 173 
	Video_Name_To_Index TANESCP_str, 174
	Video_Name_To_Index TESLATNK_str, 175
	Video_Name_To_Index SIZZLE3_str, 176
	Video_Name_To_Index SIZZLE4_str, 177
	
	jmp 0x00463804
	
_Play_Movie:
	movsx   eax, al
	movsx   edx, dl
	push eax
	
	Index_To_Video_Name ALLX2_str, 151
	Index_To_Video_Name ALLX1_str, 150
	Index_To_Video_Name ALLX3_str, 152
	Index_To_Video_Name ALLX4_str, 153
	Index_To_Video_Name ALLX2W_str, 154
	Index_To_Video_Name ALLX1W_str, 155
	Index_To_Video_Name ALLX3W_str, 156
	Index_To_Video_Name ALLX4W_str, 157
	Index_To_Video_Name ALLXEND_str, 158
	Index_To_Video_Name ANTBRF_str, 159
	Index_To_Video_Name CHRONTNK_str, 160
	Index_To_Video_Name GPSLNCH_str, 161
	Index_To_Video_Name INTROX_str, 162
	Index_To_Video_Name NUKETRUK_str, 163
	Index_To_Video_Name SNOWFILD_str, 164
	Index_To_Video_Name SOVEXP1_str, 165
	Index_To_Video_Name SOVEXP2_str, 166
	Index_To_Video_Name SOVEXP3_str, 167
	Index_To_Video_Name SOVEXP4_str, 168
	Index_To_Video_Name SOVEXP1W_str, 169
	Index_To_Video_Name SOVEXP2W_str, 170
	Index_To_Video_Name SOVEXP3W_str, 171
	Index_To_Video_Name SOVEXP4W_str, 172
	Index_To_Video_Name SOVXEND_str, 173
	Index_To_Video_Name TANESCP_str, 174
	Index_To_Video_Name TESLATNK_str, 175
	Index_To_Video_Name SIZZLE3_str, 176
	Index_To_Video_Name SIZZLE4_str, 177
	
	pop eax
	jmp 0x004A8DE8

Load_Custom_String:
	pop		esi
	pop		esi
	xor     esi, esi
	call	0x004A88AC
	jmp 0x004A8DF6