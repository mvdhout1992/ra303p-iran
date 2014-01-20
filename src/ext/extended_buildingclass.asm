@HOOK 0x0045E429 _BuildingClass__Building_Crew_House_NoBuildingCrew
@HOOK 0x004EC58F _InfantryClass__Per_Cell_Process_House_Instant_Capture
@HOOK 0x004EFC9E _InfantryClass__What_Action_House_Instant_Capture

; no buildingcrew if the house has no building crew set
; this requires the extended houseclass option NoBuildingCrew
; which is EXTENDED HouseClass + offset 0x1801
_BuildingClass__Building_Crew_House_NoBuildingCrew:
    Save_Registers

    mov  edx, [eax+0x11]  ; vtable
    call DWORD [edx+8] ; HousesType const TechnoClass::Owner(void)
    call 0x004D2CB0 ;  HouseClass * HouseClass::As_Pointer(HousesType)
    cmp  BYTE [eax+0x1801], 1
    Restore_Registers
    jz   .No_Building_Crew

.Ret:
    mov  edx, [eax+0CDh]
    jmp  0x0045E42F

.No_Building_Crew:
    jmp  0x0045E542

;edi = buildingclass, HouseClass + offset 0x1800 = BuildingsGetInstantlyCaptured
_InfantryClass__Per_Cell_Process_House_Instant_Capture:
    Save_Registers

    mov  eax, edi ; make sure eax has this pointer
    mov  edx, [eax+0x11]  ; vtable
    call DWORD [edx+8] ; HousesType const TechnoClass::Owner(void)
    call 0x004D2CB0 ;  HouseClass * HouseClass::As_Pointer(HousesType)
    cmp  BYTE [eax+0x1800], 1
    Restore_Registers
    jz   .Capture_Building

.Normal_Code:
    and  eax, 0FFh
    jmp  0x004EC594

.Capture_Building:
    jmp  0x004EC59A

;ebx = buildingclass, HouseClass + offset 0x1800 = BuildingsGetInstantlyCaptured
_InfantryClass__What_Action_House_Instant_Capture:
    Save_Registers

    mov  eax, ebx ; make sure eax has this pointer
    mov  edx, [eax+0x11]  ; vtable
    call DWORD [edx+8] ; HousesType const TechnoClass::Owner(void)
    call 0x004D2CB0 ;  HouseClass * HouseClass::As_Pointer(HousesType)
    cmp  BYTE [eax+0x1800], 1
    Restore_Registers
    jz   .Capture_Building

.Normal_Code:
    mov  bx, [0x00665E04] ; EngineerCaptureLevel
    mov  ax, [eax]
    cmp  ax, bx
    setbe al
    and  eax, 0FFh
    jmp  0x004EFCB3

.Capture_Building:
    jmp  0x004EFCB5
