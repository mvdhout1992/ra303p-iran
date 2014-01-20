@HOOK 0x004B3F80 _Formation_Speed_Glitched_Loop
@HOOK 0x004B45FD _DisplayClass__Mouse_Left_Release_Function_End

%define FormSpeed        0x0065E0D0
%define FormMaxSpeed    0x0065E0D1

firstformationunit: db 1

_Formation_Speed_Glitched_Loop:
    cmp  BYTE [SessionClass__Session], 5
    jz   .Apply_Fix
    cmp  BYTE [SessionClass__Session], 0
    jz   .Apply_Fix
    cmp  BYTE [fixformationspeed], 1
    jz   .Apply_Fix

    jmp  .Dont_Fix

.Apply_Fix:
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  byte al, [eax+15Ch]
    cmp  BYTE [firstformationunit], 1
    jnz  .Not_First_Unit_FormMaxSpeed
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  BYTE al, [eax+15Ch]
    mov  BYTE [FormMaxSpeed], al

.Not_First_Unit_FormMaxSpeed:
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  BYTE al, [eax+15Ch]

    cmp  BYTE [FormMaxSpeed], al
    jle  .Dont_Set_As_MaxFormSpeed
    mov  BYTE [FormMaxSpeed], al

.Dont_Set_As_MaxFormSpeed:
    mov  esi, [ecx+11h]
    mov  eax, ecx
    add  ebx, 4
    call [esi+34h]
    mov  BYTE al, [eax+15Dh]
    inc  edx
    cmp  BYTE [firstformationunit], 1
    jnz  .Not_First_Unit_FormSpeed
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  BYTE al, [eax+15Dh]
    mov  BYTE [FormSpeed], al
.Not_First_Unit_FormSpeed:
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  BYTE al, [eax+15Dh]
    cmp  BYTE [FormSpeed], al
    jle  .Dont_Set_As_FormSpeed
    mov  BYTE [FormSpeed], al

.Dont_Set_As_FormSpeed:
    mov  BYTE [firstformationunit], 0
    jmp  0x004B3FAA


.Dont_Fix:
    mov  esi, [ecx+11h]
    mov  eax, ecx
    call [esi+34h]
    mov  al, [eax+15Ch]
    mov  esi, [ecx+11h]
    mov  [FormMaxSpeed], al
    mov  eax, ecx
    add  ebx, 4
    call [esi+34h]
    mov  al, [eax+15Dh]
    inc  edx
    mov  [FormSpeed], al
    jmp  0x004B3FAA

_DisplayClass__Mouse_Left_Release_Function_End:
    mov  BYTE [firstformationunit], 1
    lea  esp, [ebp-8]
    pop  edi
    pop  esi
    jmp  0x004B4602
