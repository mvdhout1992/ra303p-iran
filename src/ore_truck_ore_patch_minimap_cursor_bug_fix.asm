@HOOK 0x00531207 _RadarClass__RTacticalClass__Action_Ore_Truck_Ore_Patch_Minimap_Cursor

;When selecting a Ore patch in the radar minimap with an Ore Truck selecting the cursor would
; turn into a "Can't move there" cursor instead of an "Attack" cursor. This fixes it.
_RadarClass__RTacticalClass__Action_Ore_Truck_Ore_Patch_Minimap_Cursor:
    mov  ah, [ebp-0x10]

    ; Add check for 'Harvest' ActionType
    cmp  ah, 6
    jz   0x00531235

    cmp  ah, 5
    jmp  0x00531235
