;@HOOK 0x004D6D3B _Paradrop_Superweapon_Custom

_Paradrop_Superweapon_Custom:

    ; Amount to paradrop
    mov  BYTE [eax+0A9h], 30

    mov  esi, eax

    ; Paradrop Demo Trucks
    mov  eax, 0x14
    call 0x00578C24 ; UnitTypeClass::As_Reference(UnitType)

    ; Paradrop Cruisers
;    mov        eax, 2
;    call    0x00584858 ; VesselTypeClass::As_Reference(VesselType)

    ; Paradrop dogs
;    mov        eax, 10
;    call    0x004EB1B8 ; InfantryTypeClass::As_Reference(InfantryType)

    ; Paradrop HELI
;    mov        eax, 5
;    call    0x004040F0 ; AircraftTypeClass::As_Reference(AircraftType)

    mov  DWORD [esi+0ADh], eax
    mov  eax, esi
    call 0x00533178 ; Do_Reinforcements(TeamTypeClass *)
    jmp  0x004D6D40
