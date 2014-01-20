@HOOK 0x0041C5D8 _AnimTypeClass_Init_Heap_Unhardcode_AnimTypes
@HOOK 0x004F40E9 _Init_Game_Set_AnimTypes_Heap_Count
@HOOK 0x0041C654 _AnimTypeClass__One_Time_UnhardCode_AnimTypes
@HOOK 0x0041C6E3 _AnimTypeClass__Init_UnhardCode_AnimTypes
@HOOK 0x00423EE8 _Anim_From_Name_Unhardcode_AnimTypes


str_AnimTypes db"AnimTypes",0
AnimTypesTypesExtCount    db    0
%define        OriginalAnimTypesHeapCount    0x50

_Anim_From_Name_Unhardcode_AnimTypes:
    mov  al, [AnimTypesTypesExtCount]
    add  al, OriginalAnimTypesHeapCount
    cmp  dl, al
    jl   0x00423EF4
    jmp  0x00423EED

_AnimTypeClass__Init_UnhardCode_AnimTypes:
    mov  al, [AnimTypesTypesExtCount]
    add  al, OriginalAnimTypesHeapCount
    cmp  bl, al
    jl   0x0041C68E
    jmp  0x0041C6E8

_AnimTypeClass__One_Time_UnhardCode_AnimTypes:
    mov  al, [AnimTypesTypesExtCount]
    add  al, OriginalAnimTypesHeapCount
    cmp  dh, al
    jl   0x0041C5F8
    jmp  0x0041C659


_Init_Game_Set_AnimTypes_Heap_Count:
    Get_RULES_INI_Section_Entry_Count str_AnimTypes
    mov  BYTE [AnimTypesTypesExtCount], al
    mov  edx, eax

    add  edx, OriginalAnimTypesHeapCount
    jmp  0x004F40EE

temp_animtypeclass_constructor_arg dd 0

Init_AnimTypeClass:
    mov  eax, 162h
    call 0x00407564 ; AnimTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  ecx, eax
    pop  eax

    mov  edx, ebx
    add  edx, OriginalAnimTypesHeapCount ; AnimType
    mov  ebx, ecx ; Name/ID

    push 0FFFFFFFFh      ; AnimType?
    push 4Dh             ; VocType?
    push 1               ; __int32
    push 0FFFFFFFFh      ; __int32
    push 0FFFFFFFFh      ; __int32
;    xor     eax, eax
    push 0               ; __int32
;    xor     dl, dl
    mov  DWORD [0x005FDF98], 0x15
    push 0               ; __int32
;    mov     [ebp+var_74], dl
;    mov     [ebp+var_73], al
    push 1               ; __int32
;    lea     eax, [ebp+var_74]
    push temp_animtypeclass_constructor_arg        ; originally:    push    eax             ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 1               ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 1               ; __int32
    push 0               ; __int32
    mov  ecx, 43h        ; Either only width or total dimensions (for refresh area?)
;    mov     ebx, offset aFball1 ; "FBALL1"
    push 6               ; __int32
    call 0x00407388 ; AnimTypeClass::AnimTypeClass(AnimType,char                *,int,int,int,int,int,int,int,int,int,int,int,fixed,int,int,int,int,int,int,VocType,AnimType)

.Ret:
    retn

_AnimTypeClass_Init_Heap_Unhardcode_AnimTypes:

Loop_Over_RULES_INI_Section_Entries str_AnimTypes, Init_AnimTypeClass

.Ret:
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    jmp  0x0041C5DE
