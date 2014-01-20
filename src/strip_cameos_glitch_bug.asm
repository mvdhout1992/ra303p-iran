; AUTO:004A9CF0     TechnoTypeClass * Fetch_Techno_Type(RTTIType, int) proc near
; AUTO:004BF368     TechnoClass * const FactoryClass::Get_Object(void)const  proc near

; First data member of a TechnoClass object is it's RTTIType, we grab this and grab the TechnoTypeClass, then compare it with the TechnoTypeClass of the cameo being processed in the StripClass::Draw_It() function. If they differ we need to set the "IsBeingBuilt" data member of the TechnoTypeClass to 0xFFFFFFFF to signal the game the object isn't being built.

; Need to also check "Hack_Prevented" local function variable because I patch out a check whether a factory for a TechnoTypeClass actually exists.

@HOOK 0x0054EA90 _SidebarClass__StripClass__Draw_It_Is_TechnoType_Being_Built_By_Its_Factory_Check

@CLEAR 0x0054EA80 0x90 0x0054EA81

; eax = 1, "being built" is set to true, eax = 0xFFFFFFFF, "being built" is set to false
Set_Is_Being_Built:
    push eax

    mov  eax, [ebp-0x44]
    lea  eax, [eax+eax*8]
    cmp  BYTE [esi+eax+3Dh], 0Eh
    mov  edx, [ebp-0x48]
    mov  edx, [edx+21h]
    mov  eax, [ebp-0x48]
    call DWORD [edx+30h]
    mov  edi, eax
    mov  eax, [ebp-0x44]
    lea  eax, [eax+eax*8]
    add  eax, esi
    xor  ecx, ecx

    pop  edx
    MOV  DWORD [eax+3Eh], edx  ; is being built check?
    retn

_SidebarClass__StripClass__Draw_It_Is_TechnoType_Being_Built_By_Its_Factory_Check:
    Save_Registers

;    cmp DWORD [ebp-0x3C], 1 ; Is hack prevented local variable
;    jz  .Hack_Prevented

    ; Get factory
    mov  edx, [ecx+3Ah]
    mov  DWORD eax, [0x00669958] ; ds:HouseClass *PlayerPtr
    sar  edx, 18h
    call 0x004DDBD0; const HouseClass::Fetch_Factory(RTTIType)

    ; If FactoryClass object is NULL goto .Hack_Prevented
    cmp  DWORD eax, 0
    jz   .Hack_Prevented

    ; Get what's being built
    call 0x004BF368 ; TechnoClass * const FactoryClass::Get_Object(void)const
    ; If NULL, goto .Hack_Prevented
    cmp  DWORD eax, 0
    jz   .Hack_Prevented

    ; Get the RTTIType
    mov  ecx, eax
    mov  BYTE al, [ecx] ; RTTIType
    mov  BYTE dl, [ecx+0x15c] ; ObjectType

    ; if RTTIType is 5 it's a building we need to set it to 6 and get ObjectType from a different offset
    cmp  BYTE al, 5
    jnz  .No_Change_For_Building_RTTIType

    ; If RTTIType is 5
    mov  BYTE al, 6
    mov  BYTE dl, [ecx+0xCD] ; ObjectType

.No_Change_For_Building_RTTIType:

    ; if RTTIType is 0x0D it's infantry and uses a different offset for ObjectType
    cmp  BYTE al, 0x0D
    jnz  .No_Change_For_Infantry_RTTIType

    mov  BYTE dl, [ecx+0x141] ; ObjectType

.No_Change_For_Infantry_RTTIType:

    ; if RTTIType is 1 it's aircraft and also uses a different offset for ObjectType
    cmp  BYTE al, 1
    jnz  .No_Change_For_Aircraft_RTTIType

    mov  BYTE dl, [ecx+0x146] ; ObjectType

.No_Change_For_Aircraft_RTTIType:

    ; Get the TechnoTypeClass
    call 0x004A9CF0    ; TechnoTypeClass * Fetch_Techno_Type(RTTIType, int)

    ; compare TechnoTypeClass returned with current TechnoTypeClass, if not the same goto .Hack_Prevented
    cmp  DWORD eax, [ebp-0x48]
    jnz  .Hack_Prevented

    mov  DWORD [ebp-0x3C], 0 ; Hack_Prevented local function variable
    Restore_Registers
    jmp  0x0054EAA0

.Hack_Prevented:
    mov  DWORD eax, [ebp-0x48]

    ; Set that the current cameo isn't being built
    mov  eax, 0xFFFFFFFF
    call Set_Is_Being_Built

    jmp  .Ret

.Ret:
    Restore_Registers
    
    cmp dword [ebp-0x3C], 1 ; Check if Hack_Prevented was set
    jz  0x0054EAA0
    
    call 0x004DE154 ; const HouseClass::Is_Hack_Prevented(RTTIType,int) ; causes crash with aircrafts
;    mov        eax, 0
    jmp  0x0054EA95
