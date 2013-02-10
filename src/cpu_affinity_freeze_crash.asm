; Fixes lagging audio and movies
@HOOK	0x005C5AFE	_VQA_Play_SetPriorityClass_NOP_Out
@HOOK	0x005C5D71	_VQA_Play_SetPriorityClass_NOP_Out2

_VQA_Play_SetPriorityClass_NOP_Out2:
	add		esp, 8
	jmp		0x005C5D78

_VQA_Play_SetPriorityClass_NOP_Out
	add		esp, 8
	jmp		0x005C5B05
	