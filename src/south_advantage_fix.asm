@HOOK 0x0056277D _TechnoClass_In_Range_Long_Int_Distance_Check_Patched ; Check during actual firing
@HOOK 0x005626EA _TechnoClass_In_Range_Long_Int_No_Building_Exception
@HOOK 0x0056285C _TechnoClass_In_Range_ObjectClass_Pointer_Int_Distance_Check_Patched ; For checking if your mouse turns into shooting cursor
@HOOK 0x005627CA _TechnoClass_In_Range_ObjectClass_Pointer_Int_No_Building_Exception

; args: <ObjectClass pointer to check facing for>, <ObjectClass pointer to check facing compared to>
; NOTE:
%macro Get_Facing_For_Objects 2
    push ebx
    push edx
    push ecx

    push %2
    push %1

    pop  eax ; %1
    mov  ebx, [eax+0x11]
    call [ebx+0x0C]
    mov  ebx, eax
    pop  eax ; %2
    mov  ecx, [eax+0x11]
    call [ecx+0x0C]
    xor  ecx, ecx
    mov  WORD cx, ebx
    xor  edx, edx
    and  ebx, 0FFFFh     ; ebx & -1
    mov  WORD dx, eax
    and  eax, 0FFFFh     ; eax & -1
    call 0x004BEA7C ; Desired_Facing256(int,int,int,int)

    pop  ecx
    pop  edx
    pop  ebx
%endmacro

%macro Get_Facing_For_Objects_And_Long 2
    push ebx
    push edx
    push ecx

    push %2
    push %1

    pop  eax ; %1
    mov  ebx, [eax+0x11]
    call [ebx+0x0C]
    mov  ebx, eax
    pop  eax ; %2
    xor  ecx, ecx
    mov  WORD cx, bx
    xor  edx, edx
    and  ebx, 0FFFFh     ; ebx & -1
    mov  WORD dx, ax
    and  eax, 0FFFFh     ; eax & -1
    call 0x004BEA7C ; Desired_Facing256(int,int,int,int)

    pop  ecx
    pop  edx
    pop  ebx
%endmacro

; args: <identifier for unique branch identifiers>, <dirtype to check>
; NOTE: returns 1 or 0 in EAX, destroying its value
%macro Is_Shooting_Northward 2
    mov  al, %2
    cmp  BYTE al, 0xE0
    jz   .Return_True_%1
    cmp  BYTE al, 0x00
    jz   .Return_True_%1
    cmp  BYTE al, 0x20
    jz   .Return_True_%1

    mov  eax, 0
    jmp  .Return_%1

.Return_True_%1:
    mov  eax, 1

.Return_%1:
%endmacro

; args: <identifier for unique branch identifiers>, <dirtype to check>
; NOTE: returns 1 or 0 in EAX, destroying its value
%macro Is_Shooting_Southward 2
    mov  al, %2
    cmp  BYTE al, 0xA0
    jz   .Return_True_%1
    cmp  BYTE al, 0x60
    jz   .Return_True_%1
    cmp  BYTE al, 0x80
    jz   .Return_True_%1

    mov  eax, 0
    jmp  .Return_%1

.Return_True_%1:
    mov  eax, 1

.Return_%1:

%endmacro

%macro Get_Facing_For_Coords 2
    push ebx
    push edx
    push ecx

    push %2
    push %1

    pop  eax ; %1
    mov  ebx, eax
    pop  eax ; %2
    xor  ecx, ecx
    push ebx
    shr  ebx, 16
    mov  WORD cx, bx
    pop  ebx
    xor  edx, edx
    and  ebx, 0FFFFh     ; ebx & -1
    push eax
    shr  eax, 16
    mov  WORD dx, ax
    pop  eax
    and  eax, 0FFFFh     ; eax & -1
    call 0x004BEA20 ; Desired_Facing8(int,int,int,int)

    pop  ecx
    pop  edx
    pop  ebx
%endmacro

_TechnoClass_In_Range_ObjectClass_Pointer_Int_No_Building_Exception:
    cmp  BYTE [southadvantagefix], 0
    jz   .Normal_Code
    jmp  0x00562840

.Normal_Code:
    cmp  al, 5
    jnz  0x00562840
    jmp  0x005627D0

_TechnoClass_In_Range_Long_Int_No_Building_Exception:
    cmp  BYTE [southadvantagefix], 0
    jz   .Normal_Code

    jmp  0x00562762

.Normal_Code:
    test eax, eax
    jz   0x00562762
    jmp  0x005626F0

; 0x80 = shooting southward, 0x00 = shooting northward, 0xc0 = westward, 0x40 = eastward
_TechnoClass_In_Range_Long_Int_Distance_Check_Patched:
    cmp  BYTE [southadvantagefix], 0
    jz   .Normal_Code

    mov  ebx, eax
    call 0x004AC41C ; Distance()
    push eax
;    mov     ebx, [ecx+11h]
;    call    dword [ebx+164h] ; TechnoClass::Turret_Facing()

    Get_Facing_For_Coords esi, ebx
    mov  bl, al

    Is_Shooting_Northward derplong, bl
    cmp  al, 0
    pop  eax

    jz   .Dont_Patch_South_Range


    add  eax, 256    ; eax is the distance, edi contains range, we increase the distance because this unit
            ; has south advantage, 256 = one cell

.Dont_Patch_South_Range:

    cmp  BYTE [ecx], 5 ; Check for building
    jnz  .Merge_Point ; If not building goto Merge_Point

    cmp  BYTE [ecx+0xcd], 0x1f
    push eax
    jz   .Tesla_Coil_Adjustments

    pop  eax
    jmp  .Merge_Point

;.Dont_Patch_Range:
;    pop     eax
;    jmp     .Merge_Point

.Tesla_Coil_Adjustments:

    Is_Shooting_Northward derpnorth, bl
    cmp  al, 0
    pop  eax
    jz   .Dont_Reduce_Tesla_Coil_North_Range

    add  eax, 256 ; Reduce distance by increasing distance

.Dont_Reduce_Tesla_Coil_North_Range:
    push eax

;    Is_Shooting_Southward  derpsouth, bl
;    cmp     al, 0
;    pop     eax
;    jz      .Dont_Increase_Tesla_Coil_South_Range


;    cmp     eax, 256
;    jl      .Dont_Increase_Tesla_Coil_South_Range
;    sub     eax, 256 ; Reduce distance by increasing distance

;.Dont_Increase_Tesla_Coil_South_Range:


    jmp  .Merge_Point
    int  3 ; not reached

.Merge_Point:
    jmp  0x00562782

.Normal_Code:
    call 0x004AC41C ; Distance()
    jmp  0x00562782


_TechnoClass_In_Range_ObjectClass_Pointer_Int_Distance_Check_Patched:
    cmp  BYTE [southadvantagefix], 0
    jz   .Normal_Code

    mov  ebx, eax
    push edx
    call 0x004AC41C ; Distance()
    pop  edx
    push eax

    Get_Facing_For_Coords edx, ebx
    mov  bl, al

    Is_Shooting_Northward derpobject, bl
    cmp  al, 0
    pop  eax

    jz   .Dont_Patch_South_Range


    add  eax, 256    ; eax is the distance, edi contains range, we increase the distance because this unit
            ; has south advantage, 256 = one cell

.Dont_Patch_South_Range:

    cmp  BYTE [esi], 5 ; Check for building
    jnz  .Merge_Point ; If not building goto Merge_Point

    cmp  BYTE [esi+0xcd], 0x1f
    push eax
    jz   .Tesla_Coil_Adjustments

    pop  eax
    jmp  .Merge_Point

    jmp  .Merge_Point

.Dont_Patch_Range:
    pop  eax

.Tesla_Coil_Adjustments:

    Is_Shooting_Northward derpnorth2, bl
    cmp  al, 0
    pop  eax
    jz   .Dont_Reduce_Tesla_Coil_North_Range

    add  eax, 256 ; Reduce distance by increasing distance

.Dont_Reduce_Tesla_Coil_North_Range:
;    push    eax

;    Is_Shooting_Southward  derpsouth2, bl
;    cmp     al, 0
;    pop     eax
;    jz      .Dont_Increase_Tesla_Coil_South_Range


;    cmp     eax, 256
;    jl      .Dont_Increase_Tesla_Coil_South_Range
;    sub     eax, 256 ; Reduce distance by increasing distance

;.Dont_Increase_Tesla_Coil_South_Range:


    jmp  .Merge_Point
    int  3 ; not reached

.Merge_Point:
    jmp  0x00562861

.Normal_Code:
    call 0x004AC41C ; Distance()
    jmp  0x00562861
