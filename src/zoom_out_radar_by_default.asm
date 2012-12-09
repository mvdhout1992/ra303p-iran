; When you buy a radar the top of the sidebar changes to show the map, but this shows the map zoomed in which isn't so useful, this patch will make it show zoomed out instead.
; Thanks to Nyerguds for showing me how he did it for his C&C95 patch.

@HOOK	0x0052D751	_Zoom_Out_Radar_By_Default

_Zoom_Out_Radar_By_Default:
	or		dl, 1h
	mov     eax, DWORD [0x00668E9A]
	jmp		0x0052D759