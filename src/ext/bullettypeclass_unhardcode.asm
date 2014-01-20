@HOOK 0x004F40D8 _Init_Game_Set_Bullet_Types_Heap_Count
@HOOK 0x00426C90 _BulletTypeClass__Init_Heap_Init_Extra_BulletTypes
@HOOK 0x00463701 _CCINIClass__Get_BulletType_Unhardcode_BulletTypes_Count
@HOOK 0x00426CF5 _BulletTypeClass__One_Time_Unhardcode_BulletTypes

str_BulletTypes    db"BulletTypes",0
BulletTypesExtCount db 0

_BulletTypeClass__One_Time_Unhardcode_BulletTypes:
    mov  al, [BulletTypesExtCount]
    add  al, 0x12
    cmp  dh, al
    jl   0x00426CAD
    jmp  0x00426CFA

_CCINIClass__Get_BulletType_Unhardcode_BulletTypes_Count:
    mov  [ebp-0x4], dl

    mov  al, [BulletTypesExtCount]
    add  al, 0x12

    cmp  dl, al
    jl   0x00463710
    jmp  0x00463709

Init_BulletTypeClass:
    mov  eax, 146h
    call 0x00426AB0 ; BulletTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  edx, eax

    pop  eax

    call 0x00426A20 ; BulletTypeClass::BulletTypeClass(char *)
.Ret:
    retn

_BulletTypeClass__Init_Heap_Init_Extra_BulletTypes:

Loop_Over_RULES_INI_Section_Entries str_BulletTypes, Init_BulletTypeClass

.Ret:
    lea  esp, [ebp-4]
    pop  edx
    pop  ebp
    retn

_Init_Game_Set_Bullet_Types_Heap_Count:
    mov  edx, 12h        ; Amount of objects in heap, HOOKED BY PATCH
    Get_RULES_INI_Section_Entry_Count str_BulletTypes

    mov  [BulletTypesExtCount], al

    add  edx, eax
    jmp  0x004F40DD
