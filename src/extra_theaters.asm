@HOOK	0x0056AAE9 	_TerrainClass__TerrainClass_Jump_Over
@HOOK	0x004F7805	_Init_Heaps_Larger_Theater_Buffer
;@HOOK	0x0041C6A1 	_AnimTypeClass__Init_Theater_Check_NOP
@HOOK	0x0056AAE9	_TerrainClass__Unlimbo_Theater_Check_NOP
;@HOOK	0x00524B68  _OverlayTypeClass__Init_Theater_Check_NOP
@HOOK	0x0049EAF3	_TemplateTypeClass__Init_Theater_Check_NOP
@HOOK	0x0055B8FA  _TerrainTypeClass__Init_Theater_Check_NOP
@HOOK	0x0055B909  _TerrainTypeClass__Init_Theater
@HOOK	0x00549E0A  _SmudgeTypeClass__Init_Theater
@HOOK	0x00524B76  _OverlayTypeClass__Init_Theater
@HOOK	0x004AF0D4  _DisplayClass__Init_Theater2
@HOOK	0x004AF057  _DisplayClass__Init_Theater
@HOOK	0x004A9450  _Fading_Table_Name_Theater
@HOOK	0x0049EB02  _TemplateTypeClass__Init_Theater
@HOOK	0x004638A4  _CCINIClass__Put_TheaterType_Theater
@HOOK	0x00453988  _BuildingTypeClass__Init_Theater2
@HOOK	0x00453943  _BuildingTypeClass__Init_Theater
@HOOK	0x0041C6AF 	_AnimTypeClass__Init_Theater
@HOOK	0x004A7AEB	_Theater_From_Name_New_Theaters_Array
@HOOK	0x004A7AD4 	_Theater_From_Name_New_Theaters_Counter_Check

; NEED TO PATCH OUT A FEW CHECKS IN A BUNCH OF FUNCTIONS

; need to patch in a jmp at 0x0056A4D2 and check call stack at 0x0056A4D0

;Theaters array
Temperate db "TEMPERATE", 0, 0, 0, 0, 0, 0, 0 ; 16 bytes
Temperat db "TEMPERAT", 0, 0 ; 10 bytes
Tem db "TEM", 0 ; 4 bytes
Snow db "SNOW", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; 16 bytes
Snow_2 db "SNOW", 0, 0, 0, 0, 0, 0 ; 10 bytes
Sno db "SNO", 0 ; 4 bytes
Interior db "INTERIOR", 0, 0, 0, 0, 0, 0, 0, 0 ; 16 bytes
Interior_2 db "INTERIOR", 0, 0 ; 10 bytes
Int_ db "INT", 0 ; 4 bytes
Winter db "WINTER", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; 16 bytes
Winter2 db "WINTER", 0, 0, 0, 0 ; 10 bytes
Win_ db "WIN", 0 ; 4 bytes, needs to be changed back to WIN
Desert db "DESERT", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; 16 bytes
Desert2 db "DESERT", 0, 0, 0, 0 ; 10 bytes
Des	db "DES", 0 ; 4 bytes

_TerrainClass__Unlimbo_Theater_Check_NOP:
	jmp		0x0056AAF1 

_TerrainClass__TerrainClass_Jump_Over:
	jmp		0x0056A4E0

_AnimTypeClass__Init_Theater_Check_NOP:
	jmp		0x0041C6A6

_OverlayTypeClass__Init_Theater_Check_NOP:
	jmp		0x00524B8B

_Init_Heaps_Larger_Theater_Buffer:
	mov     edx, 5500000
	jmp		0x004F780A

_TemplateTypeClass__Init_Theater_Check_NOP:
	shl     eax, cl
	jmp		0x0049EAF9

_TerrainTypeClass__Init_Theater_Check_NOP:
	shl     eax, cl
	jmp		0x0055B900

_TerrainTypeClass__Init_Theater:
	add     eax, Temperate
	jmp		0x0055B90E

_SmudgeTypeClass__Init_Theater:
	add     eax, Temperate
	jmp		0x00549E0F

_OverlayTypeClass__Init_Theater:
	add     eax, Temperate
	jmp		0x00524B7B

_DisplayClass__Init_Theater2:
	add     eax, Temperate
	jmp		0x004AF0D9

_DisplayClass__Init_Theater:
	add     eax, Temperate
	jmp		0x004AF05C

_Fading_Table_Name_Theater:
	add     eax, Temperate
	jmp		0x004A9455

_TemplateTypeClass__Init_Theater:
	add     eax, Temperate
	jmp		0x0049EB07

_CCINIClass__Put_TheaterType_Theater:
	mov     ecx, Temperate
	jmp		0x004638A9

_Theater_From_Name_New_Theaters_Array:
	add     edx, Temperate
	jmp		0x004A7AF1
	
_Theater_From_Name_New_Theaters_Counter_Check
	cmp     dl, 5           ; 3 theaters originally, 5 now
	jl      0x004A7AE0
	jmp     0x004A7AFF
	
_AnimTypeClass__Init_Theater:
	add     eax, Temperate
	jmp		0x0041C6B4
	
_BuildingTypeClass__Init_Theater:
	add     edx, Temperate
	jmp		0x00453949

_BuildingTypeClass__Init_Theater2:	
	add     eax, Temperate
	jmp		0x0045398D