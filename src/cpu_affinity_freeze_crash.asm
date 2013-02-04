@HOOK	0x005C5AED	_VQA_Play_SetPriorityClass_Fix

; Fixes lagging audio and movies
_VQA_Play_SetPriorityClass_Fix:
	push	DWORD 20h
	jmp		0x005C5AF2
	