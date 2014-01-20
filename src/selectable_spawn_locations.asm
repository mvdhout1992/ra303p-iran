;@HOOK 0x0053DDEB _Read_Scenario_INI_Spawn_Locations
@HOOK 0x0053E6A9 _Create_Units_Spawn_Location
@HOOK 0x0053E534 _Create_Units_First_Spawn_Save_Waypoint_number_In_ECX
@HOOK 0x0053E6B0 _Create_Units_Save_Spawn_Location_In_HouseClass
@HOOK 0x0053E4CE _Create_Units_Set_Selected_Spawn_Locations
@HOOK 0x0053E511 _Create_Units_First_Spawn_Check_If_Not_Selected

str_SpawnLocations        db "SpawnLocations",0
str_multi1                db "Multi1",0
str_multi2                db "Multi2",0
str_multi3                db "Multi3",0
str_multi4                db "Multi4",0
str_multi5                db "Multi5",0
str_multi6                db "Multi6",0
str_multi7                db "Multi7",0
str_multi8                db "Multi8",0

multi1_spawn    dd -1
multi2_spawn    dd -1
multi3_spawn    dd -1
multi4_spawn    dd -1
multi5_spawn    dd -1
multi6_spawn    dd -1
multi7_spawn    dd -1
multi8_spawn    dd -1

_Create_Units_First_Spawn_Check_If_Not_Selected:
    call 0x005BC960

    push esi
    push edi

;; uncomment this code if there are issues with every player selecting spawns
;    mov     esi, DWORD [multi1_spawn]
;    cmp     esi, -1
;    jnz     .First_Spawn_Selected

    mov  esi, 0

.Loop:
    cmp  esi, 7
    jg   .Ret

    mov  edi, DWORD [multi1_spawn+esi*4]
    cmp  edi, eax
    jz   .Find_Another_Spawn

    inc  esi
    jmp  .Loop

.Ret:
    pop  edi
    pop  esi
    jmp  0x0053E516

.Find_Another_Spawn:
    pop  edi
    pop  esi
    jmp  0x0053E4D9

;.First_Spawn_Selected:
;    mov eax, esi
;    pop     edi
;    pop     esi
;    jmp     0x0053E516

_Create_Units_Set_Selected_Spawn_Locations:
    mov  DWORD [ebp-0x84], eax
    Save_Registers

    mov  esi, 0

.Loop:
    cmp  esi, 7
    jg   .Ret

    mov  edi, DWORD [multi1_spawn+esi*4]
    cmp  edi, -1
    jz   .Dont_Set_Spawn_As_Used
    mov  DWORD [ebp+edi*4-0x1BC], 1

.Dont_Set_Spawn_As_Used:
    inc  esi
    jmp  .Loop

.Ret:
    Restore_Registers
    jmp  0x0053E4D4

; Save spawn location in EXTENDED HouseClass so we can dump this info for statistics
_Create_Units_Save_Spawn_Location_In_HouseClass:
    xor  eax, eax ; just to be sure
    mov  ax, [ebp-0x30] ; SpawnLocation
    mov  DWORD [esi+EXT_SpawnLocation], eax

.Ret:
    mov  eax, [ebp-0x1C]
    and  eax, 7Fh
    jmp  0x0053E6B6

_Create_Units_First_Spawn_Save_Waypoint_number_In_ECX:
    mov  ecx, eax
    jmp  0x0053E6A9

_Read_Scenario_INI_Spawn_Locations:
    push eax
    Save_Registers

    lea  esi, [ebp-140]

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi1, -1
    mov  DWORD [multi1_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi2, -1
    mov  DWORD [multi2_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi3, -1
    mov  DWORD [multi3_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi4, -1
    mov  DWORD [multi4_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi5, -1
    mov  DWORD [multi5_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi6, -1
    mov  DWORD [multi6_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi7, -1
    mov  DWORD [multi7_spawn], eax

    call_INIClass__Get_Int esi, str_SpawnLocations, str_multi8, -1
    mov  DWORD [multi8_spawn], eax

    Restore_Registers
    pop  eax
    call 0x0053E204 ; Create_Units(int)
    jmp  0x0053DDF0


_Create_Units_Spawn_Location:
; [ebp-0x30] is spawn location local variable
    mov  ebx, DWORD [ebp-0x1B]
    sar  ebx, 18h
    cmp  DWORD ebx, 0x0c
    je   .Spawn_Multi1

    cmp  DWORD ebx, 0x0d
    je   .Spawn_Multi2

    cmp  DWORD ebx, 0x0e
    je   .Spawn_Multi3

    cmp  DWORD ebx, 0x0f
    je   .Spawn_Multi4

    cmp  DWORD ebx, 0x10
    je   .Spawn_Multi5

    cmp  DWORD ebx, 0x11
    je   .Spawn_Multi6

    cmp  DWORD ebx, 0x12
    je   .Spawn_Multi7

    cmp  DWORD ebx, 0x13
    je   .Spawn_Multi8

.Ret:
    mov  eax, DWORD [ebp-0x30]
    mov  word [ebp-0x1C], ax
    jmp  0x0053E6B0

.Spawn_Multi1:
    mov  eax, DWORD [multi1_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi2:
    mov  eax, DWORD [multi2_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi3:
    mov  eax, DWORD [multi3_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi4:
    mov  eax, DWORD [multi4_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi5:
    mov  eax, DWORD [multi5_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi6:
    mov  eax, DWORD [multi6_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi7:
    mov  eax, DWORD [multi7_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0

.Spawn_Multi8:
    mov  eax, DWORD [multi8_spawn]

    cmp  eax, DWORD -1
    jz   .Ret

    ; Fix up "used spawn locations" local array
    mov  DWORD [ebp+ecx*4-0x1BC], 0 ; Set previously game selected spawn location as free
    mov  DWORD [ebp+eax*4-0x1BC], 1 ; Set the spawn location we just loaded from the ini as used

    add  eax, eax
    add  eax, 2
    add  eax, 0x006678F5 ; Waypoints

    xor  edi, edi
    mov  WORD di, [eax]
    mov  eax, edi

    mov  DWORD [ebp-0x30], eax
    jmp  0x0053E6B0
