@HOOK 0x0046360D _CCINIClass__Get_WarheadType_Unhardcode_WarheadTypes_Count
@HOOK 0x0053618B _RulesClass__Heap_Maximums_Set_Bullet_Types_Heap_Count
@HOOK 0x00536270 _RulesClass__Heap_Maxiums_Init_Extra_WarheadTypes

str_Warheads db"Warheads",0

Init_WarheadTypeClass:
    mov  eax, 22h
    call 0x0058FA64     ; void * WarheadTypeClass::operator new(unsigned int)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  edx, eax

    pop  eax
    call 0x0058F9D8   ;  WarheadTypeClass::WarheadTypeClass(char *)
.Ret:
    retn

_RulesClass__Heap_Maxiums_Init_Extra_WarheadTypes:

    Loop_Over_RULES_INI_Section_Entries str_Warheads, Init_WarheadTypeClass

    mov  eax, 0x0069164C ; offset TFixedIHeapClass<WeaponTypeClass> Weapons ; Hooked by WARHEADtypeclass unhardcode code
    jmp  0x00536275

_RulesClass__Heap_Maximums_Set_Bullet_Types_Heap_Count:
    mov  edx, [esi+1D0h] ; Hooked by patched warheads unhardcode code
    Get_RULES_INI_Section_Entry_Count str_Warheads
    add  edx, eax
    mov  eax, 0x00691600 ; offset TFixedIHeapClass<WarheadTypeClass> Warheads
    jmp  0x00536191


_CCINIClass__Get_WarheadType_Unhardcode_WarheadTypes_Count:
    mov  [ebp-0x8], dl

    Get_RULES_INI_Section_Entry_Count str_Warheads
    add  al, 9
    cmp  dl, al

    jl   0x0046361C
    jmp  0x00463615
