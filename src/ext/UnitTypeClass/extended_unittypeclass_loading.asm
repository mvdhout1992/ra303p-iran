; Extended memory size of the class, with save and load support
;@HOOK 0x0056E298 _UnitTypeClass_operator_new_Hard_Code_New_Size
@HOOK 0x004C9685 _TFixedIHeapClass__UnitTypeClass__Constructor_New_Size
@HOOK 0x004D1333 _TFixedIHeapClass__UnitTypeClass__Save_New_Size
@HOOK 0x004D1416 _TFixedIHeapClass__UnitTypeClass__Load_New_Size
@HOOK 0x004C74D2 _TFixedIHeapClass__fn_init_New_UnitTypes_Heap_Size

; Clear memory
@HOOK 0x004D1431 _TFixedIHeapClass__UnitTypeClass__Load_Clear_Memory

;Read INI settings
@HOOK 0x00578DCE _UnitTypeClass__Read_INI_Extended

%define        Old_UnitTypeClass_Size        0x19E
%define        New_UnitTypeClass_Size        0x39E

%define        UnitTypeExt_Crusher            0x19F    ; BYTE
%define        UnitTypeExt_FirstLoadDone    0x200    ; BYTE

str_Crusher db"Crusher",0

UnitTypeClass_First_Load:
    ; Set UnitTypeExt_Crusher
    Get_Bit BYTE [esi+0x192], 2 ; Crusher, hooked by extend unit type class code
    mov  BYTE [esi+UnitTypeExt_Crusher], al

.Ret:
    mov  BYTE [esi+UnitTypeExt_FirstLoadDone], 1
    retn

UnitTypeClass_Clear_Extended_Memory:

    ; Use original 'can crush' bit flag
    Set_Bit_Byte [esi+0x192], 2, [esi+UnitTypeExt_Crusher]

.Ret:
    retn

_UnitTypeClass__Read_INI_Extended:
    cmp  BYTE [esi+UnitTypeExt_FirstLoadDone], 1
    jz   .Dont_Do_First_Load

    call UnitTypeClass_First_Load

.Dont_Do_First_Load:

    cmp  edi, RulesINI
    jnz  .Dont_Clear_Extended_Memory

    call UnitTypeClass_Clear_Extended_Memory

.Dont_Clear_Extended_Memory:

;========= start loading from INI ==============
    push esi

    lea  edx, [esi+5]
    Get_Bit BYTE [esi+0x192], 2
    xor  ecx, ecx
    mov  cl, al
    call_INIClass__Get_Bool edi, edx, str_Crusher, ecx
    ; set crusher flag
    Set_Bit_Byte [esi+0x192], 2, al

    pop  esi


.Ret:
    lea  esp, [ebp-10h]
    pop  edi
    pop  esi
    pop  ecx
    jmp  0x00578DD4

_TFixedIHeapClass__UnitTypeClass__Load_Clear_Memory:
    Clear_Extended_Class_Memory_For_Old_Saves ecx, New_UnitTypeClass_Size, Old_UnitTypeClass_Size

    mov  BYTE [UnitTypeExt_FirstLoadDone], 1
.Ret:
    lea  edx, [ebp-0x14]
    mov  eax, ecx
    jmp  0x004D1436

_TFixedIHeapClass__fn_init_New_UnitTypes_Heap_Size:
    mov  edx, New_UnitTypeClass_Size
    jmp  0x004C74D7

_TFixedIHeapClass__UnitTypeClass__Load_New_Size:
    mov  ebx, New_UnitTypeClass_Size
    jmp  0x004D141B

_TFixedIHeapClass__UnitTypeClass__Save_New_Size:
    mov  ebx, New_UnitTypeClass_Size
    jmp  0x004D1338

_TFixedIHeapClass__UnitTypeClass__Constructor_New_Size:
    mov  edx, New_UnitTypeClass_Size
    jmp  0x004C968A
