@HOOK 0x004DAFA4 _AI_Tech_Up_Check
@HOOK 0x004D6102 _HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out
@HOOK 0x004DAFD5 _HouseClasss__AI_Building_Build_Radar_Dome_Have_War_Check
@HOOK 0x004DE5D2 _HouseClass__Is_Allowed_To_Ally_AI_Player_Fix
@HOOK 0x004BD1DD _EventClass__Execute_Make_Ally
@HOOK 0x004DDA71 _Fix_AI_Attacking_Top_Left_Bug
@HOOK 0x004DDA00 _Fix_AI_Attacking_Top_Left_Bug2
;@HOOK 0x004D84C4 _HouseClass__MPlayer_Defeated_Check_AI_Allies ; What does this do other than making skirmish games never end as long as AI exist?
@HOOK 0x004DE640 _HouseClass__Computer_Paranoid_Force_Disabled_Skirmish
@HOOK 0x004D62DD _HouseClass__Make_Ally_Show_Computer_Has_Allied
@HOOK 0x0058144B _UnitClass__Load_Credits_Credit_Values_For_AI_Difficulties
@JMP  0x00581460 0x00581466

%define HouseClass__Where_To_Go                0x004DD9FC
%define DriveClass__Assign_Destination        0x004B67C8

Check_AI_Difficulty_Gem_And_Gold_Values:
    cmp  EBX, -1 ; ebx = gold value
    jnz  .Dont_Change_Gold_Value

    mov  ebx, [0x00666888]  ; ds:nRulesClass_General_GoldValue

.Dont_Change_Gold_Value:

    cmp  ECX, -1 ; ebx = gold value
    jnz  .Dont_Gem_Gold_Value

    mov  ecx, [0x0066688C] ; ds:nRulesClass_General_GemValue

.Dont_Gem_Gold_Value:

    retn

_UnitClass__Load_Credits_Credit_Values_For_AI_Difficulties:
    push eax
    mov  DWORD eax, [eax+0x93]
    call 0x004D2CB0 ; HouseClass * HouseClass::As_Pointer(HousesType) proc near

    test BYTE [eax+42h], 2
    jnz  .Not_AI

    cmp  BYTE [eax+9], 0
    jz   .AI_Easy_Dfficulty

    cmp  BYTE [eax+9], 1
    jz   .AI_Normal_Dfficulty

    cmp  BYTE [eax+9], 2
    jz   .AI_Hard_Dfficulty

    jmp  .Not_AI ; Shouldn't be reached ever

.Ret:
    pop  eax
    jmp  0x00581451

.Not_AI:
    mov  ecx, [0x0066688C] ; ds:nRulesClass_General_GemValue
    mov  ebx, [0x00666888]  ; ds:nRulesClass_General_GoldValue
    jmp  .Ret

.AI_Easy_Dfficulty:
    mov  ecx, [EasyAIGemValue] ; ds:nRulesClass_General_GemValue
    mov  ebx, [EasyAIOreValue]  ; ds:nRulesClass_General_GoldValue
    call Check_AI_Difficulty_Gem_And_Gold_Values
    jmp  .Ret

.AI_Normal_Dfficulty:
    mov  ecx, [NormalAIGemValue] ; ds:nRulesClass_General_GemValue
    mov  ebx, [NormalAIOreValue]  ; ds:nRulesClass_General_GoldValue
    call Check_AI_Difficulty_Gem_And_Gold_Values
    jmp  .Ret

.AI_Hard_Dfficulty:
    mov  ecx, [HardAIGemValue] ; ds:nRulesClass_General_GemValue
    mov  ebx, [HardAIOreValue]  ; ds:nRulesClass_General_GoldValue
    call Check_AI_Difficulty_Gem_And_Gold_Values
    jmp  .Ret

_HouseClass__Make_Ally_Show_Computer_Has_Allied:
    jmp  0x004D62E3

_HouseClasss__AI_Building_Build_Radar_Dome_Have_War_Check:
    jnz  0x004DB050

    cmp  BYTE [ReenableAITechUpCheck], 1
    jz   .Normal_Code

    cmp  BYTE [SessionClass__Session], 5
    jz   .War_Check
    cmp  BYTE [removeaitechupcheck], 1
    jz   .War_Check

    jmp  .Normal_Code

.War_Check:
    cmp  dword [ecx+30Eh], 0 ; war factory count
    jz   0x004DB050

.Normal_Code:
    jmp  0x004DAFDB

_HouseClass__Computer_Paranoid_Force_Disabled_Skirmish:
    cmp  BYTE [SessionClass__Session], 5
    jz   .Ret

    cmp  BYTE [computerparanoidforcedisabledskirmish], 1
    jz   .Ret

    cmp  BYTE [forcedalliances], 1
    jz   .Ret

    jmp  .Normal_Ret

    retn

.Normal_Ret:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    jmp  0x004DE645

.Ret:
    retn

_HouseClass__MPlayer_Defeated_Check_AI_Allies:
    cmp  BYTE [SessionClass__Session], 5
    jz   .Ret

    test BYTE [eax+42h], 2
    jz   0x004D84CD
.Ret:
    jmp  0x004D84CA

_Fix_AI_Attacking_Top_Left_Bug2:
    cmp  BYTE [SessionClass__Session], 5
    je   .Apply_Fix_For_Skirmish

    cmp  BYTE [fixaisendingtankstopleft], 1
    jnz  .Original_Code

.Apply_Fix_For_Skirmish:

    push ecx

    push eax
    push edx

    mov  ecx, eax
    mov  eax, edx
    jmp  0x004DDA05

.Original_Code:
    push ecx

    mov  ecx, eax
    mov  eax, edx
    jmp  0x004DDA05

_Fix_AI_Attacking_Top_Left_Bug:
    cmp  BYTE [SessionClass__Session], 5
    je   .Apply_Fix_For_Skirmish

    cmp  BYTE [fixaisendingtankstopleft], 1
    jnz  .Original_Code

.Apply_Fix_For_Skirmish:

    call 0x004FFAC4 ;  const MapClass::Nearby_Location(short,SpeedType,int,MZoneType)
    cmp  eax, 0
    jz   .Recursive_Call_Where_To_Go

    add  esp, 8
    jmp  0x004DDA76

.Recursive_Call_Where_To_Go:
    pop  edx
    pop  eax
    call 0x004DD9FC ; short const HouseClass::Where_To_Go(FootClass *)
    lea  esp, [ebp-8]
    pop  ecx
    pop  ebx
    pop  ebp
    retn

.Original_Code:
    call 0x004FFAC4 ;  const MapClass::Nearby_Location(short,SpeedType,int,MZoneType)
    jmp  0x004DDA76

_EventClass__Execute_Make_Ally:
    push eax
    push edx
    call 0x004D6060 ;  HouseClass::Make_Ally(HousesType)

    cmp  BYTE [SessionClass__Session], 5
    je   .Apply_Fix_For_Skirmish

    cmp  BYTE [fixaially], 0
    jz   .Ret

.Apply_Fix_For_Skirmish:

    pop  eax ; Pop registers in reverse order, HouseType
    call 0x004D2CB0 ; HouseClass::As_Pointer(HousesType)
    mov  ecx, eax  ; now contains new HouseClass
    pop  eax ; HouseClass
    push ecx
    call 0x004D2C48
    mov  edx, eax ; now contains new HouseType
    pop  eax        ; now conains new HouseClass

    test BYTE [eax+42h], 2
    jnz  .Ret2

    call 0x004D6060
    jmp  0x004BD1E2

.Ret:
    add  esp, 8
    jmp  0x004BD1E2

.Ret2:
    jmp  0x004BD1E2

_HouseClass__Is_Allowed_To_Ally_AI_Player_Fix:
    cmp  BYTE [SessionClass__Session], 5
    je   .Allow_AI_Ally

    cmp  BYTE [fixaially], 1
    jz   .Allow_AI_Ally


    cmp  DWORD eax, 0
    jz   0x004DE5D8
    test byte [eax+42h], 2
    jnz  0x004DE5E2 ; Assemble JMP here to fix?
    jmp  0x004DE5D8

.Allow_AI_Ally:
    jmp  0x004DE5E2

_HouseClass__Make_Ally_Computer_Paranoid_Call_Patch_Out:
    cmp  BYTE [SessionClass__Session], 5
    je   .Jump_Over

    cmp  BYTE [fixaiparanoid], 1
    jz   .Jump_Over

    call 0x004DE640 ; call HouseClass::Computer_Paranoid()

.Jump_Over:
    jmp  0x004D6107 ; Jump over

_AI_Tech_Up_Check:
    jnz  0x004DB0E4

    cmp  BYTE [ReenableAITechUpCheck], 1
    jz   .Normal_Code

    cmp  BYTE [SessionClass__Session], 5
    je   .No_Techup_Check

    cmp  BYTE [removeaitechupcheck], 1
    jz   .No_Techup_Check

.Normal_Code:
    jmp  0x004DAFAA

.No_Techup_Check:
    jmp  0x004DAFB7
