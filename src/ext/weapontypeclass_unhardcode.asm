@HOOK 0x00536275 _RulesClass__Heap_Maxiums_Set_Weapons_Heap_Count
@HOOK 0x0053668A _RulesClass__Heap_Maxiums_Init_Extra_WeaponTypes

str_Weapons    db"Weapons",0

Init_WeaponTypeClass:
    mov  eax, 26h
    call 0x0058FE18     ; WeaponTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  edx, eax

    pop  eax
    call 0x0058FD98    ; WeaponTypeClass::WeaponTypeClass(char *)
.Ret:
    retn

_RulesClass__Heap_Maxiums_Init_Extra_WeaponTypes:

Loop_Over_RULES_INI_Section_Entries str_Weapons, Init_WeaponTypeClass

.Ret:
    mov  eax, 1
    jmp  0x0053668F

_RulesClass__Heap_Maxiums_Set_Weapons_Heap_Count:
    mov  edx, [esi+1CCh]
    Get_RULES_INI_Section_Entry_Count str_Weapons
    add  edx, eax
    mov  eax,  0x0069164C ; offset TFixedIHeapClass<WeaponTypeClass> Weapons

    jmp  0x0053627B
