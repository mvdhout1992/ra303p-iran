;@HOOK 0x00567343 _TechnoClass__Remap_Table_Building_Check

_TechnoClass__Remap_Table_Building_Check:
    cmp  DWORD [eax+93h], 2
    jne  .Ret_Normal

    cmp  DWORD [eax+10h], 0x5F73E000
;    je        .Ret_Custom_Building_Colour_Scheme
    jne  .Ret_Custom_Building_Unit_Scheme

.Ret_Normal:
    mov  edx, eax
    mov  ebx, [eax+11h]
    jmp  0x00567348

.Ret_Custom_Building_Colour_Scheme:
;    mov        eax, 0x00666B3E ; Red colour remap
    mov  eax, 0x0066690A ; Civilian yellow colour remap
    jmp  0x005673A1

.Ret_Custom_Building_Unit_Scheme:
    mov  eax, 0x00666A24 ; blue remap
;    mov        eax, extraremaptable+colorblackoffset
    jmp  0x005673A1
