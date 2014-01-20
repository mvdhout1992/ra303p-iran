%macro TAction__Operator__Epilogue 0
    mov  eax, [ebp+-0x30]
    lea  esp, [ebp-8]
    pop  edi
    pop  esi
    pop  ebp
    retn 4
%endmacro

%define TActionClass_This    -0x24
%define HouseClass_Owner    -0x28

; TAction offset 0x0 = Trigger ID (BYTE)
; Taction offset 0x1 = Trigger Parameter 1 (DWORD)
; Taction offset 0x5 = Trigger Parameter 2 (DWORD)
; Taction offset 0x9 = Trigger Parameter 3 (DWORD)

@HOOK 0x00554125 _TActionClass__operator__New_Trigger_Actions
@HOOK 0x0055E396 _TeamClass__Coordinate_Attack_Chrono_Tank_Check
@HOOK 0x0055E1EE _TeamClass__Coordinate_Attack_Chrono_Tank_Check2
@HOOK 0x0055F9E3 _TeamClass__TMission_Spy_Chrono_Tank_Check

temp_unk8 dd 0
temp_unkC dd 0
temp_unk10 dd 0

_TeamClass__TMission_Spy_Chrono_Tank_Check:
    cmp  DWORD [ChronoReinforceTanks], 1
    jz   .Ret

    cmp  edx, 11h
    jnz  0x0055FA5E

.Ret:
jmp        0x0055F9EC

_TeamClass__Coordinate_Attack_Chrono_Tank_Check2:
    cmp  DWORD [ChronoReinforceTanks], 1
    jz   .Ret

    cmp  eax, 11h
    jnz  0x0055E1FB

.Ret:
    jmp  0x0055E1F3

_TeamClass__Coordinate_Attack_Chrono_Tank_Check:
    cmp  DWORD [ChronoReinforceTanks], 1
    jz   .Ret

    cmp  eax, 11h
    jnz  0x0055E431
.Ret:
    jmp  0x0055E39F


Create_Chronal_Vortex:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+1] ; Parameter 1, waypoint to focus on

    xor  eax, eax
    lea  edx, [edx*2]
    mov  ax, [0x06678F7+edx] ; Get cell location associated with waypoint

;    sub     eax, 40Ah
    mov  word [temp_unk8], ax
    mov  eax, [temp_unk8]
    and  eax, 7Fh
    mov  byte [temp_unk10+1], al
    mov  byte [temp_unk10], 80h
    mov  eax, [temp_unk8]
    shl  eax, 12h
    mov  dl, 80h
    shr  eax, 19h
    mov  byte [temp_unk10+2], dl
    mov  byte [temp_unk10+3], al
    mov  eax, [temp_unk10]
    xor  dh, dh
    mov  [temp_unkC], eax
    mov  byte [temp_unkC], dh
    mov  byte [temp_unkC+2], dh

    MOV  edx, [temp_unkC]
    mov  eax, 0x006904B4 ; offset ChronalVortexClass ChronalVortex
    call 0x0058E0F4 ; ChronalVortexClass::Appear(ulong)

    retn

House_Make_Enemy:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, what color to set to
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to set color for

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  esi, eax

    mov  eax, 1
    mov  cl, dl
    mov  edx, [esi+174Ch]
    shl  eax, cl
    not  eax
    and  edx, eax
    mov  al, [esi+527h]
    mov  [esi+174Ch], edx ; Switch alliance bit for HouseType_Arg

    retn

House_Make_Ally:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, what color to set to
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to set color for

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  esi, eax

    mov  eax, 1
    mov  cl, dl
    mov  edx, [esi+174Ch]
    shl  eax, cl
    or   edx, eax
    mov  al, [esi+527h]
    mov  [esi+174Ch], edx ; Switch alliance bit for HouseType_Arg

    retn

Set_House_IQ:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, turn on/off control
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to take control over

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  esi, eax
    mov  eax, edx

    mov  ebx, [0x00666780] ; ds:nRulesClass_IQ_MaxIQLevels
    cmp  eax, ebx
    jle  .Dont_Clamp_Max_IQ
    mov  edx, 1

.Dont_Clamp_Max_IQ:
    mov  [esi+1Ch], edx
    mov  [esi+46h], edx

.Ret:
    retn

Set_House_Build_Level:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, what color to set to
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to set color for

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  [eax+0x20], edx
    retn

Set_House_Secondary_Color_Scheme:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, what color to set to
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to set color for

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  [eax+0x1802], dl
    retn

Set_House_Primary_Color_Scheme:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, what color to set to
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to set color for

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  [eax+0x178F], dl

    retn

Set_Player_Control:
    mov  esi, [ebp+HouseClass_Owner]
    cmp  esi, [0x00669958] ; ds:HouseClass *PlayerPtr
    jnz  .Ret

    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+5] ; Parameter 2, turn on/off control
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType to take control over

    push edx

    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)
    mov  esi, eax

    mov  dl, [esi+42h]
    and  dl, 0FBh
    pop  eax
    and  eax, 1
    mov  [esi+42h], dl
    shl  eax, 2
    mov  ecx, [esi+42h]
    or   ecx, eax
    mov  [esi+42h], ecx

.Ret:
    retn

Set_View_Port_Location:
    Save_Registers

    mov  esi, [ebp+HouseClass_Owner]
    cmp  esi, [0x00669958] ; ds:HouseClass *PlayerPtr
    jnz  .Ret

    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+1] ; Parameter 1, waypoint to focus on

    xor  eax, eax
    lea  edx, [edx*2]
    mov  ax, [0x06678F7+edx] ; Get cell location associated with waypoint

;    sub     eax, 40Ah
    mov  word [temp_unk8], ax
    mov  eax, [temp_unk8]
    and  eax, 7Fh
    mov  byte [temp_unk10+1], al
    mov  byte [temp_unk10], 80h
    mov  eax, [temp_unk8]
    shl  eax, 12h
    mov  dl, 80h
    shr  eax, 19h
    mov  byte [temp_unk10+2], dl
    mov  byte [temp_unk10+3], al
    mov  eax, [temp_unk10]
    xor  dh, dh
    mov  [temp_unkC], eax
    mov  byte [temp_unkC], dh
    mov  byte [temp_unkC+2], dh

    xor  ecx, ecx
    mov  WORD cx, [temp_unkC+2]

    xor  esi, esi
    mov  WORD si, [temp_unkC]

    xor  edx, edx
    mov  dx, [0x00668E9E] ; __GScreen_PosX
    mov  eax, edx
    sar  edx, 1Fh
    sub  eax, edx
    sar  eax, 1
    sub  esi, eax
    mov  eax, [0x00668258] ; DisplayClass offset +0x08
    mov  dh, al
    xor  dl, dl
    and  edx, 0FFFFh
    cmp  esi, edx
    jge  .loc_jmp_Adjust_mid
    mov  ah, al
    xor  esi, esi
    xor  al, al
    mov  si, ax

.loc_jmp_Adjust_mid:
    xor  edx, edx
    mov  dx, [0x00668EA0] ; __GScreen_PosY
    mov  eax, edx
    sar  edx, 1Fh
    sub  eax, edx
    sar  eax, 1
    sub  ecx, eax
    mov  eax, [0x00668258] ; DisplayClass offset +0x08
    mov  dh, al
    xor  dl, dl
    and  edx, 0FFFFh
    cmp  ecx, edx
    jge  .loc_jmp_Adjust_mid2
    mov  ah, al
    xor  ecx, ecx
    xor  al, al
    mov  cx, ax

.loc_jmp_Adjust_mid2:
    mov  WORD [temp_unkC+2], cx

    xor  esi, esi
    mov  WORD [temp_unkC], si

    mov  edx, [temp_unkC]
    mov  eax, 0x00668250 ; offset MouseClass Map
    call 0x004D2BC0; HelpClass::Set_Tactical_Position(ulong)

.Ret:
    Restore_Registers
    retn

Add_To_Sidebar_Action:
    mov  esi, [ebp+HouseClass_Owner]
    cmp  esi, [0x00669958] ; ds:HouseClass *PlayerPtr
    jnz  .Ret

    mov  eax, [ebp+TActionClass_This]

;    mov        DWORD edx, [eax+1] ; Paramater 1, RTTIType
    mov  DWORD ebx, [eax+1] ; Parameter 1, Object ID


    mov  eax, 0x00668250 ; offset MouseClass Map
    call 0x0054D61C     ; int SidebarClass::Add(RTTIType, int)

    mov  eax, 0x0066928E ; offset __LEFT_STRIP
    call 0x0054E2CC    ;  void SidebarClass::StripClass::Flag_To_Redraw(void)
    mov  eax, 0x0066956A ; offset __RIGHT_STRIP
    call 0x0054E2CC    ;  void SidebarClass::StripClass::Flag_To_Redraw(void)

.Ret:
    retn

Give_Credits_Action:
    mov  eax, [ebp+TActionClass_This]

    mov  DWORD edx, [eax+5] ; Parameter 2, amount of credits
    mov  DWORD eax, [eax+1] ; Paramater 1, HouseType
    call 0x004D2CB0   ;  HouseClass * HouseClass::As_Pointer(HousesType)

    add  [eax+197h], edx

    retn

NukeCellTarget dd  0
Nuke_unk34 dd 0
Nuke_unk18 dd 0
Nuke_unk44 dd 0
Nuke_unk1C dd 0

Nuke_Strike_On_Waypoint:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD edx, [eax+1] ; Parameter 1, waypoint to focus on

    xor  eax, eax
    lea  edx, [edx*2]
    mov  ax, [0x06678F7+edx] ; Get cell location associated with waypoint

    mov  WORD [NukeCellTarget], ax

    mov  eax, 4Bh
    call 0x00460EAC ; BulletClass::operator new(uint)
    mov  esi, eax
    test eax, eax
    jz   .Past_Creating_BulletClass
    push 64h
    push 7               ; warhead type?
    xor  eax, eax
    mov  WORD ax, [NukeCellTarget]
    mov  edx, 11h        ; ; Bullet type
    push 0C8h
    xor  ecx, ecx
    call 0x005558E8 ; As_Target(short)
    mov  ebx, eax
    mov  eax, esi
    call 0x00460B90 ; BulletClass::BulletClass(BulletType,long,TechnoClass *,int,WarheadType,int)

.Past_Creating_BulletClass:
    mov  esi, eax
    test eax, eax
    jz   .jt_SpecialWeaponAI_Out
    mov  eax, [NukeCellTarget]
    mov  word [Nuke_unk1C], ax
    mov  eax, [Nuke_unk1C]
    shl  eax, 12h
    shr  eax, 19h
    sub  eax, 0Fh
    cmp  eax, 1
    jge  .Dont_Set_EAX
    mov  eax, 1

.Dont_Set_EAX:
    xor  ecx, ecx
    mov  word [Nuke_unk34], cx
    mov  edx, [NukeCellTarget]
    mov  cl, byte [Nuke_unk34]
    mov  word [Nuke_unk18], dx
    and  cl, 80h
    mov  edx, [Nuke_unk18]
    mov  byte [Nuke_unk34], cl
    and  edx, 7Fh
    or   [Nuke_unk34], edx
    mov  edi, [Nuke_unk34]
    and  edi, 0C07Fh
    and  eax, 7Fh
    mov  word [Nuke_unk34], di
    shl  eax, 7
    or   [Nuke_unk34], eax
    mov  eax, [Nuke_unk34]
    mov  word [NukeCellTarget], ax
    mov  eax, [NukeCellTarget]
    and  eax, 7Fh
    xor  ebx, ebx
    mov  bl, 80h
    mov  byte [Nuke_unk44+1], al
    mov  eax, [NukeCellTarget]
    mov  ch, 80h
    shl  eax, 12h
    mov  byte [Nuke_unk44], ch
    shr  eax, 19h
    mov  byte [Nuke_unk44+2], ch
    mov  byte [Nuke_unk44+3], al
    mov  edi, [esi+11h]
    mov  edx, [Nuke_unk44]
    mov  eax, esi
    call dword [edi+64h] ; int BulletClass::Unlimbo(unsigned long, DirType)
    test eax, eax
    jnz  .Dont_Call_Destructor
    mov  ebx, [esi+11h]
    mov  edx, 2
    mov  eax, esi
    call dword [ebx] ; BulletClass::~BulletClass(void) proc near

.Dont_Call_Destructor:
.jt_SpecialWeaponAI_Out:

retn

HouseClass_Which_Captures dd 0
Capture_Attached_unk6C dd 0
Capture_Attached_unk68 dd 0
Capture_Attached_unk34 dd 0
Capture_Attached_unk38 dd 0
Capture_Attached_unk3C dd 0

What_Heap1 dd 0
What_Heap2 dd 0

Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached:
.Setup_Buildings_Loop:
    xor  ecx, ecx
    mov  [Capture_Attached_unk6C], ecx
    mov  [Capture_Attached_unk68], ecx
    jmp  .Buildings_Loop

.Next_Loop_Iteration:
    mov  ebx, [Capture_Attached_unk68]
    mov  ecx, [Capture_Attached_unk6C]
    add  ebx, 4
    inc  ecx
    mov  [Capture_Attached_unk68], ebx
    mov  [Capture_Attached_unk6C], ecx

    .Buildings_Loop:
    mov  edi, [Capture_Attached_unk6C]
    mov  edx, [What_Heap1]
    mov  edx, [edx]
;    cmp     edi, [0x0065D8BC] ; ds:dword_0065D8BC
    cmp  edi, edx
    jge  .Ret ; RETURN
    mov  edx, [Capture_Attached_unk68]
    mov  eax, [What_Heap2]
    mov  eax, [eax]
;    mov     eax, [0x0065D8E4] ; ds:BuildingClass_Heap_Related?
    add  eax, edx
    mov  edi, [eax]
    test edi, edi
    jz   .Next_Loop_Iteration
    lea  ebx, [edi+21h]
    mov  edx, esi
    mov  eax, ebx
    call 0x00500A20 ; Find_Trigger_On_Object?
    test eax, eax
    jz   .Next_Loop_Iteration

    lea  eax, [Capture_Attached_unk3C]
    xor  edx, edx
    call 0x00463D70 ; CCPtr<TriggerClass>::CCPtr(TriggerClass *)
    mov  eax, [eax]
    mov  [ebx], eax
    mov  eax, [edi+23h]
    sar  eax, 10h
    mov  [Capture_Attached_unk38], eax
    mov  ecx, 2
    mov  eax, [edi+11h]
    mov  [Capture_Attached_unk34], eax
    mov  eax, edi
    mov  edi, [Capture_Attached_unk34]
    mov  edx, [HouseClass_Which_Captures]
;    mov        ebx, eax
    call dword [edi+1D4h]    ; Call ::Captured()
;    call    Iron_Curtain_Object
    lea  edx, [Capture_Attached_unk38]
    jmp  .Next_Loop_Iteration
.Ret:
    retn

Capture_Attached_Objects:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD eax, [eax+1] ; Parameter 1, HouseType of that captures this object
    call 0x004D2CB0     ; HouseClass * HouseClass::As_Pointer(HousesType)
    mov  [HouseClass_Which_Captures], eax

    ; Buildings
    mov  DWORD [What_Heap1], 0x0065D8BC
    mov  DWORD [What_Heap2], 0x0065D8E4
    call Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached

    ; Units
    mov  DWORD [What_Heap1], 0x0065DC4C
    mov  DWORD [What_Heap2], 0x0065DC74
    call Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached

    ; Infantry
    mov  DWORD [What_Heap1], 0x0065D9EC
    mov  DWORD [What_Heap2], 0x0065DA14
    call Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached

    ; Aircrafts
    mov  DWORD [What_Heap1], 0x0065D824
    mov  DWORD [What_Heap2], 0x0065D84C
    call Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached

    ; Ships
    mov  DWORD [What_Heap1], 0x0065DC98
    mov  DWORD [What_Heap2], 0x0065DCC0
    call Loop_Over_Object_Heap_And_Call_Captured_If_Trigger_Attached
.Ret:
    retn

IronCurtain_unk20 db 0
IronCurtain_unk1F dd 0
IronCurtain_unk1B dd 0
IronCurtain_Frames dd 0

Iron_Curtain_Object:
    Save_Registers

    cmp  DWORD [IronCurtain_Frames], -1
    jnz  .Dont_Use_RulesClass_Iron_Curtain_Duration

    xor  edi, edi
    mov  di, [0x006668EA] ; ds:nRulesClass_General_IronCurtain
    imul edi, 384h

    lea  eax, [edi+80h]

    lea  esi, [IronCurtain_unk20]
    mov  edi, [0x006680C4] ; ds:long Frame
    shr  eax, 8
    mov  [IronCurtain_unk1F], edi
    lea  edi, [ebx+82h]
    mov  [IronCurtain_unk1B], eax
    movsd
    movsd
    movsb

.Past_Setting_Iron_Curtain_Duration:
    mov  edi, [ebx+11h]
    mov  edx, 2
    mov  eax, ebx
    call dword [edi+9Ch]

    mov  edx, [ebx+11h]
    mov  eax, ebx
    mov  ecx, 0FFFFFFFFh
    call dword [edx+0Ch] ;  unsigned long const ObjectClass::Center_Coord(void)
    mov  ebx, 1
    mov  edx, eax
    mov  eax, 1Eh
;    call    0x00425D1C ; Sound_Effect(VocType,ulong,int,HousesType)

    Restore_Registers
    retn

.Dont_Use_RulesClass_Iron_Curtain_Duration:
    xor  edi, edi
    mov  di, [IronCurtain_Frames]
    mov  WORD [ebx+87h], di
    xor  edi, edi
    mov  edi, [0x006680C4] ; ds:long Frame
    mov  WORD [ebx+82h], di
    jmp  .Past_Setting_Iron_Curtain_Duration

Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached:
.Setup_Buildings_Loop:
    xor  ecx, ecx
    mov  [Capture_Attached_unk6C], ecx
    mov  [Capture_Attached_unk68], ecx
    jmp  .Buildings_Loop

.Next_Loop_Iteration:
    mov  ebx, [Capture_Attached_unk68]
    mov  ecx, [Capture_Attached_unk6C]
    add  ebx, 4
    inc  ecx
    mov  [Capture_Attached_unk68], ebx
    mov  [Capture_Attached_unk6C], ecx

    .Buildings_Loop:
    mov  edi, [Capture_Attached_unk6C]
    mov  edx, [What_Heap1]
    mov  edx, [edx]
;    cmp     edi, [0x0065D8BC] ; ds:dword_0065D8BC
    cmp  edi, edx
    jge  .Ret ; RETURN
    mov  edx, [Capture_Attached_unk68]
    mov  eax, [What_Heap2]
    mov  eax, [eax]
;    mov     eax, [0x0065D8E4] ; ds:BuildingClass_Heap_Related?
    add  eax, edx
    mov  edi, [eax]
    test edi, edi
    jz   .Next_Loop_Iteration
    lea  ebx, [edi+21h]
    mov  edx, esi
    mov  eax, ebx
    call 0x00500A20 ; Find_Trigger_On_Object?
    test eax, eax
    jz   .Next_Loop_Iteration

    lea  eax, [Capture_Attached_unk3C]
    xor  edx, edx
    call 0x00463D70 ; CCPtr<TriggerClass>::CCPtr(TriggerClass *)
    mov  eax, [eax]
    mov  [ebx], eax
    mov  eax, [edi+23h]
    sar  eax, 10h
    mov  [Capture_Attached_unk38], eax
    mov  ecx, 2
    mov  eax, [edi+11h]
    mov  [Capture_Attached_unk34], eax
    mov  eax, edi
    mov  edi, [Capture_Attached_unk34]
    mov  edx, [HouseClass_Which_Captures]
    mov  ebx, eax
    call Iron_Curtain_Object
    lea  edx, [Capture_Attached_unk38]
    jmp  .Next_Loop_Iteration
.Ret:
    retn

Iron_Curtain_Attached_Objects:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD eax, [eax+1] ; Parameter 1, Frames duration of Iron Curtain effect
    mov  DWORD [IronCurtain_Frames], eax

    ; Buildings
    mov  DWORD [What_Heap1], 0x0065D8BC
    mov  DWORD [What_Heap2], 0x0065D8E4
    call Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached

    ; Units
    mov  DWORD [What_Heap1], 0x0065DC4C
    mov  DWORD [What_Heap2], 0x0065DC74
    call Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached

    ; Infantry
    mov  DWORD [What_Heap1], 0x0065D9EC
    mov  DWORD [What_Heap2], 0x0065DA14
    call Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached

    ; Aircrafts
    mov  DWORD [What_Heap1], 0x0065D824
    mov  DWORD [What_Heap2], 0x0065D84C
    call Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached

    ; Ships
    mov  DWORD [What_Heap1], 0x0065DC98
    mov  DWORD [What_Heap2], 0x0065DCC0
    call Loop_Over_Object_Heap_And_Iron_Curtain_If_Trigger_Attached
.Ret:
    retn

Create_Building_At_Waypoint:
    mov  eax, [ebp+TActionClass_This]

    mov  DWORD ebx, [eax+9] ; Parameter 3, HouseType to create building for
    mov  DWORD ecx, [eax+5] ; Parameter 2, waypoint to create at
    mov  DWORD eax, [eax+1] ; Paramater 1, StructType to create

    call 0x00453A6C     ; BuildingTypeClass & BuildingTypeClass::As_Reference(StructType)

    xor  edx, edx
    lea  ecx, [ecx*2]
    mov  dx, [0x06678F7+ecx] ; Get cell location associated with waypoint


    call 0x00453804     ; int const BuildingTypeClass::Create_And_Place(short, HousesType)

    retn

MissionToSet dd 0

Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached:
.Setup_Buildings_Loop:
    xor  ecx, ecx
    mov  [Capture_Attached_unk6C], ecx
    mov  [Capture_Attached_unk68], ecx
    jmp  .Buildings_Loop

.Next_Loop_Iteration:
    mov  ebx, [Capture_Attached_unk68]
    mov  ecx, [Capture_Attached_unk6C]
    add  ebx, 4
    inc  ecx
    mov  [Capture_Attached_unk68], ebx
    mov  [Capture_Attached_unk6C], ecx

    .Buildings_Loop:
    mov  edi, [Capture_Attached_unk6C]
    mov  edx, [What_Heap1]
    mov  edx, [edx]
;    cmp     edi, [0x0065D8BC] ; ds:dword_0065D8BC
    cmp  edi, edx
    jge  .Ret ; RETURN
    mov  edx, [Capture_Attached_unk68]
    mov  eax, [What_Heap2]
    mov  eax, [eax]
;    mov     eax, [0x0065D8E4] ; ds:BuildingClass_Heap_Related?
    add  eax, edx
    mov  edi, [eax]
    test edi, edi
    jz   .Next_Loop_Iteration
    lea  ebx, [edi+21h]
    mov  edx, esi
    mov  eax, ebx
    call 0x00500A20 ; Find_Trigger_On_Object?
    test eax, eax
    jz   .Next_Loop_Iteration

    lea  eax, [Capture_Attached_unk3C]
    xor  edx, edx
    call 0x00463D70 ; CCPtr<TriggerClass>::CCPtr(TriggerClass *)
    mov  eax, [eax]
    mov  [ebx], eax
    mov  eax, [edi+23h]
    sar  eax, 10h
    mov  [Capture_Attached_unk38], eax
    mov  ecx, 2
    mov  eax, [edi+11h]
    mov  [Capture_Attached_unk34], eax
    mov  eax, edi ; ObjectClass *
    mov  DWORD edx, [MissionToSet]
    mov  edi, [Capture_Attached_unk34]
    call 0x00502798   ;   void MissionClass::Set_Mission(MissionType)
    lea  edx, [Capture_Attached_unk38]
    jmp  .Next_Loop_Iteration
.Ret:
    retn


Set_Mission_Attached_Objects:
    mov  eax, [ebp+TActionClass_This]
    mov  DWORD eax, [eax+1] ; Parameter 1, mission to set objects to
    mov  DWORD [MissionToSet], eax

    ; Buildings
    mov  DWORD [What_Heap1], 0x0065D8BC
    mov  DWORD [What_Heap2], 0x0065D8E4
    call Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached

    ; Units
    mov  DWORD [What_Heap1], 0x0065DC4C
    mov  DWORD [What_Heap2], 0x0065DC74
    call Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached

    ; Infantry
    mov  DWORD [What_Heap1], 0x0065D9EC
    mov  DWORD [What_Heap2], 0x0065DA14
    call Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached

    ; Aircrafts
    mov  DWORD [What_Heap1], 0x0065D824
    mov  DWORD [What_Heap2], 0x0065D84C
    call Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached

    ; Ships
    mov  DWORD [What_Heap1], 0x0065DC98
    mov  DWORD [What_Heap2], 0x0065DCC0
    call Loop_Over_Object_Heap_And_Set_Mission_Trigger_Attached
.Ret:
    retn

Loop_Over_Object_Heap_And_Repair_Trigger_Attached:
.Setup_Buildings_Loop:
    xor  ecx, ecx
    mov  [Capture_Attached_unk6C], ecx
    mov  [Capture_Attached_unk68], ecx
    jmp  .Buildings_Loop

.Next_Loop_Iteration:
    mov  ebx, [Capture_Attached_unk68]
    mov  ecx, [Capture_Attached_unk6C]
    add  ebx, 4
    inc  ecx
    mov  [Capture_Attached_unk68], ebx
    mov  [Capture_Attached_unk6C], ecx

    .Buildings_Loop:
    mov  edi, [Capture_Attached_unk6C]
    mov  edx, [What_Heap1]
    mov  edx, [edx]
;    cmp     edi, [0x0065D8BC] ; ds:dword_0065D8BC
    cmp  edi, edx
    jge  .Ret ; RETURN
    mov  edx, [Capture_Attached_unk68]
    mov  eax, [What_Heap2]
    mov  eax, [eax]
;    mov     eax, [0x0065D8E4] ; ds:BuildingClass_Heap_Related?
    add  eax, edx
    mov  edi, [eax]
    test edi, edi
    jz   .Next_Loop_Iteration
    lea  ebx, [edi+21h]
    mov  edx, esi
    mov  eax, ebx
    call 0x00500A20 ; Find_Trigger_On_Object?
    test eax, eax
    jz   .Next_Loop_Iteration

    lea  eax, [Capture_Attached_unk3C]
    xor  edx, edx
    call 0x00463D70 ; CCPtr<TriggerClass>::CCPtr(TriggerClass *)
    mov  eax, [eax]
    mov  [ebx], eax
    mov  eax, [edi+23h]
    sar  eax, 10h
    mov  [Capture_Attached_unk38], eax
    mov  ecx, 2
    mov  eax, [edi+11h]
    mov  [Capture_Attached_unk34], eax
    mov  eax, edi ; ObjectClass *
    or   BYTE [eax+0D6h], 0x10
    mov  edi, [Capture_Attached_unk34]
    lea  edx, [Capture_Attached_unk38]
    jmp  .Next_Loop_Iteration
.Ret:
    retn

Repair_Attached_Buildings:
    mov  eax, [ebp+TActionClass_This]

    ; Buildings
    mov  DWORD [What_Heap1], 0x0065D8BC
    mov  DWORD [What_Heap2], 0x0065D8E4
    call Loop_Over_Object_Heap_And_Repair_Trigger_Attached

    retn

ChronoShiftDest dd 0

Chrono_Shift_Object:
    Save_Registers

    mov  bl, [eax]

    cmp  bl, 0x1E ; RTTIType == VESSEL
    jz   .Do_Chrono_Shift
    cmp  bl,    0x1C    ; RTTIType == VEHICLE
    jz   .Do_Chrono_Shift

    jmp  .Ret

.Do_Chrono_Shift:
    mov  edx, [ChronoShiftDest]

    mov  [eax+0x14E], dx

    mov  edi, eax
    call 0x004B653C ; int DriveClass::Teleport_To(short)

    mov  eax, edi
    mov  dh, [eax+141h]
    or   dh, 2
    mov  [eax+141h], dh

    mov  eax, 0x006678E8 ; offset ScenarioClass ScenOrRandom
    call 0x00539BF8 ; ScenarioClass::Do_BW_Fade(void)

    mov  ecx, 0FFFFFFFFh
    mov  eax, 1Bh
    mov  edx, [ebx+5]
    mov  ebx, 1
    call 0x00425D1C ; Sound_Effect(VocType,ulong,int,HousesType)

.Ret:
    Restore_Registers
    retn

Loop_Over_Object_Heap_And_Chrono_Shift_If_Trigger_Attached:
.Setup_Buildings_Loop:
    xor  ecx, ecx
    mov  [Capture_Attached_unk6C], ecx
    mov  [Capture_Attached_unk68], ecx
    jmp  .Buildings_Loop

.Next_Loop_Iteration:
    mov  ebx, [Capture_Attached_unk68]
    mov  ecx, [Capture_Attached_unk6C]
    add  ebx, 4
    inc  ecx
    mov  [Capture_Attached_unk68], ebx
    mov  [Capture_Attached_unk6C], ecx

    .Buildings_Loop:
    mov  edi, [Capture_Attached_unk6C]
    mov  edx, [What_Heap1]
    mov  edx, [edx]
;    cmp     edi, [0x0065D8BC] ; ds:dword_0065D8BC
    cmp  edi, edx
    jge  .Ret ; RETURN
    mov  edx, [Capture_Attached_unk68]
    mov  eax, [What_Heap2]
    mov  eax, [eax]
;    mov     eax, [0x0065D8E4] ; ds:BuildingClass_Heap_Related?
    add  eax, edx
    mov  edi, [eax]
    test edi, edi
    jz   .Next_Loop_Iteration
    lea  ebx, [edi+21h]
    mov  edx, esi
    mov  eax, ebx
    call 0x00500A20 ; Find_Trigger_On_Object?
    test eax, eax
    jz   .Next_Loop_Iteration

    lea  eax, [Capture_Attached_unk3C]
    xor  edx, edx
    call 0x00463D70 ; CCPtr<TriggerClass>::CCPtr(TriggerClass *)
    mov  eax, [eax]
    mov  [ebx], eax
    mov  eax, [edi+23h]
    sar  eax, 10h
    mov  [Capture_Attached_unk38], eax
    mov  ecx, 2
    mov  eax, [edi+11h]
    mov  [Capture_Attached_unk34], eax
    mov  eax, edi
    mov  edi, [Capture_Attached_unk34]
    mov  edx, [HouseClass_Which_Captures]
    mov  ebx, eax
    call Chrono_Shift_Object
    lea  edx, [Capture_Attached_unk38]
    jmp  .Next_Loop_Iteration
.Ret:
    retn

Chrono_Shift_Attached_Objects:
    mov  eax, [ebp+TActionClass_This]
    mov  ecx, [eax+1] ; Parameter 1, waypoint to chronoshift to

    xor  edx, edx
    lea  ecx, [ecx*2]
    mov  dx, [0x06678F7+ecx] ; Get cell location associated with waypoint

    mov  DWORD [ChronoShiftDest], edx

    ; Units
    mov  DWORD [What_Heap1], 0x0065DC4C
    mov  DWORD [What_Heap2], 0x0065DC74
    call Loop_Over_Object_Heap_And_Chrono_Shift_If_Trigger_Attached

    ; Ships
    mov  DWORD [What_Heap1], 0x0065DC98
    mov  DWORD [What_Heap2], 0x0065DCC0
    call Loop_Over_Object_Heap_And_Chrono_Shift_If_Trigger_Attached

    retn

Chrono_Shift_Trigger_Object:
    test edi, edi
    jz   .Ret

    mov  eax, [ebp+TActionClass_This]
    mov  ecx, [eax+1] ; Parameter 1, waypoint to chronoshift to

    xor  edx, edx
    lea  ecx, [ecx*2]
    mov  dx, [0x06678F7+ecx] ; Get cell location associated with waypoint

    mov  DWORD [ChronoShiftDest], edx

    mov  eax, edi
    call Chrono_Shift_Object

    mov  eax, edi

.Ret:
    retn

Iron_Curtain_Trigger_Object:
    test edi, edi
    jz   .Ret

    mov  eax, [ebp+TActionClass_This]
    mov  DWORD eax, [eax+1] ; Parameter 1, Frames duration of Iron Curtain effect
    mov  DWORD [IronCurtain_Frames], eax

    mov  eax, edi
    call Iron_Curtain_Object

    mov  eax, edi

.Ret:
    retn


_TActionClass__operator__New_Trigger_Actions:

    cmp  al, 40
    jz   .New_Give_Credits_Action
    cmp  al, 41
    jz   .New_Add_Vehicle_To_Sidebar_Action
    cmp  al, 42
    jz   .New_Add_Infantry_To_Sidebar_Action
    cmp  al, 43
    jz   .New_Add_Building_To_Sidebar_Action
    cmp  al, 44
    jz   .New_Add_Aircraft_To_Sidebar_Action
    cmp  al, 45
    jz   .New_Add_Vessel_To_Sidebar_Action
    cmp  al, 50
    jz   .New_Set_View_Port_Location
    cmp  al, 51
    jz   .New_Set_Player_Control
    cmp  al, 52
    jz   .New_Set_House_Primary_Color_Scheme
    cmp  al, 53
    jz   .New_Set_House_Secondary_Color_Scheme
    cmp  al, 54
    jz   .New_Set_House_Build_Level
    cmp  al, 55
    jz   .New_Set_House_IQ
    cmp  al, 56
    jz   .New_House_Make_Ally
    cmp  al, 57
    jz   .New_House_Make_Enemy
    cmp  al, 58
    jz   .New_Create_Chronal_Vortex
    cmp  al, 59
    jz   .New_Nuke_Strike_On_Waypoint
    cmp  al, 60
    jz   .New_Capture_Attached_Objects
    cmp  al, 61
    jz   .New_Iron_Curtain_Attached_Objects
    cmp  al, 62
    jz   .New_Create_Building_At_Waypoint
    cmp  al, 63
    jz   .New_Set_Mission_Attached_Objects
    cmp  al, 64
    jz   .New_Repair_Attached_Buildings
    cmp  al, 65
    jz   .New_Chrono_Shift_Attached_Objects
    cmp  al, 66
    jz   .New_Chrono_Shift_Trigger_Object
    cmp  al, 67
    jz   .New_Iron_Curtain_Trigger_Object

    cmp  al, 24h         ; Check to see if action ID is less than 37
    ja   0x0055418A ; NO_ACTION
    jmp  0x0055412D

.New_Give_Credits_Action:
    call Give_Credits_Action
    TAction__Operator__Epilogue

.New_Add_Vehicle_To_Sidebar_Action:
    mov  edx, 0x1D ; RTTIType == VEHICLETYPE
    call Add_To_Sidebar_Action
    TAction__Operator__Epilogue

.New_Set_View_Port_Location:
    call Set_View_Port_Location
    TAction__Operator__Epilogue

.New_Set_Player_Control:
    call Set_Player_Control
    TAction__Operator__Epilogue

.New_Set_House_Primary_Color_Scheme:
    call Set_House_Primary_Color_Scheme
    TAction__Operator__Epilogue

.New_Set_House_Secondary_Color_Scheme:
    call Set_House_Secondary_Color_Scheme
    TAction__Operator__Epilogue

.New_Set_House_Build_Level:
    call Set_House_Build_Level
    TAction__Operator__Epilogue

.New_Set_House_IQ:
    call Set_House_IQ
    TAction__Operator__Epilogue

.New_House_Make_Ally:
    call House_Make_Ally
    TAction__Operator__Epilogue

.New_House_Make_Enemy:
    call House_Make_Enemy
    TAction__Operator__Epilogue

.New_Create_Chronal_Vortex:
    call Create_Chronal_Vortex
    TAction__Operator__Epilogue

.New_Nuke_Strike_On_Waypoint:
    call Nuke_Strike_On_Waypoint
    TAction__Operator__Epilogue

.New_Capture_Attached_Objects:
    call Capture_Attached_Objects
    TAction__Operator__Epilogue

.New_Iron_Curtain_Attached_Objects:
    call Iron_Curtain_Attached_Objects
    TAction__Operator__Epilogue

.New_Create_Building_At_Waypoint:
    call Create_Building_At_Waypoint
    TAction__Operator__Epilogue

.New_Set_Mission_Attached_Objects:
    call Set_Mission_Attached_Objects
    TAction__Operator__Epilogue

.New_Repair_Attached_Buildings:
    call Repair_Attached_Buildings
    TAction__Operator__Epilogue

.New_Chrono_Shift_Attached_Objects:
    call Chrono_Shift_Attached_Objects
    TAction__Operator__Epilogue

.New_Chrono_Shift_Trigger_Object:
    call Chrono_Shift_Trigger_Object
    TAction__Operator__Epilogue

.New_Iron_Curtain_Trigger_Object:
    call Iron_Curtain_Trigger_Object
    TAction__Operator__Epilogue

.New_Add_Infantry_To_Sidebar_Action:
    mov  edx, 0x0E ; RTTIType == INFANTRYTYPE
    call Add_To_Sidebar_Action
    TAction__Operator__Epilogue

.New_Add_Building_To_Sidebar_Action:
    mov  edx, 0x6 ; RTTIType == BUILDINGTYPE
    call Add_To_Sidebar_Action
    TAction__Operator__Epilogue

.New_Add_Aircraft_To_Sidebar_Action:
    mov  edx, 0x2 ; RTTIType == AIRCRAFTTYPE
    call Add_To_Sidebar_Action
    TAction__Operator__Epilogue

.New_Add_Vessel_To_Sidebar_Action:
    mov  edx, 0x1F ; RTTIType == VESSELTYPE
    call Add_To_Sidebar_Action
    TAction__Operator__Epilogue
