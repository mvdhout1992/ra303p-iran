; Remove game single player game mode check when checking for win/lose flags set in HouseClass::AI()
@JMP  0x004D415D 0x004D416A
@JMP  0x004D41D4 0x004D41DD

@HOOK 0x004D41CA _HouseClass__AI_Player_Win_Flag_Set_Remove_Lose
@HOOK 0x004D85A9 _HouseClass__AI_Player_Lose_Flag_Set_Remove_Win
@HOOK 0x00554926 _TActionClass_Operator___ACTION_WIN_Multiplayer
@HOOK 0x00554980 _TActionClass_Operator___ACTION_LOSE_Multiplayer
@HOOK 0x004FE1C1 _LogicClass__AI_Call_HouseClass_AI_For_All_Houses_In_Coop
@HOOK 0x004D4CAF _HouseClass__AI_No_MPlayer_Defeated_Call_In_Coop

@HOOK 0x0053D7BE _Read_Scenario_INI__Read_Is_Coop_Mode_Option
@HOOK 0x004D4F2E _HouseClass__AI_No_Expert_AI_In_Coop_Mode
@HOOK 0x004DA2A5 _HouseClass__AI_Building_Single_Player_AI_In_Coop
@HOOK 0x004DB873 _HouseClass__AI_Unit_Single_Player_AI_In_Coop
@HOOK 0x004DBD35 _HouseClass__AI_Vessel_Single_Player_AI_In_Coop
@HOOK 0x004DC188 _HouseClass__AI_Infantry_Single_Player_AI_In_Coop
@HOOK 0x0053E085 _Assign_Houses_House_Auto_Production_Bit
@HOOK 0x0055C41E _TeamClass__AI_Single_Player_Logic1
@HOOK 0x0055C7AF _TeamClass__AI_Single_Player_Logic2

@HOOK 0x0058109D _UnitClass__Read_INI_Use_Single_Player_Logic
@HOOK 0x004D406A _HouseClass__Use_Single_Player_Logic
@HOOK 0x00568267 _TechnoClass__Is_Allowed_To_Retaliate_Single_Player_Logic
@HOOK 0x0053DDEB _Read_Scenario_INI_Dont_Create_MP_Spawning_Units_In_Coop
@HOOK 0x004D8CAE _HouseClass__Init_Data_Dont_Set_Credits_In_Coop_Mode
@HOOK 0x0053DFDD _Assign_Houses__Dont_Set_Tech_Level_In_Coop_Mode
@HOOK 0x0053E0CB _Assign_Houses__Dont_Set_IQ_Level_In_Coop_Mode
@HOOK 0x00567E58 _TechnoClass__Base_Is_Attacked_Single_Player_Logic3
@HOOK 0x00567BC6 _TechnoClass__Base_Is_Attacked_Single_Player_Logic2
@HOOK 0x0056787B _TechnoClass__Base_Is_Attacked_Single_Player_Logic1
@HOOK 0x0045FF34 _BuildingClass__Repair_AI_Use_Single_Player_Logic2
@HOOK 0x0045FF34 _BuildingClass__Repair_AI_Use_Single_Player_Logic1
@HOOK 0x0053E0EC _Assign_Houses__Dont_Set_Tech_Level_In_Coop_Mode2
@HOOK 0x004AB659 _Owner_From_Name_No_Multi_Houses_Check_In_Coop_Mode

@HOOK 0x00533180 _Do_Reinforcements_Fix_Crash_When_Reinforcing_Nonexistent_Houses

; Crates stuff?

;004A0B5B   EB 13            JMP SHORT ra95-spa.004A0B70
;004FEEA8   E9 7E000000      JMP ra95-spa.004FEF2B
;004FF2B5   90               NOP
;004A04C8   90               NOP
;004A071F   E9 BF010000      JMP ra95-spa.004A08E3

;005272EF     90             NOP
;0052714E     90             NOP

_Do_Reinforcements_Fix_Crash_When_Reinforcing_Nonexistent_Houses:
    push eax

    cmp  DWORD [InCoopMode], 0
    jz   .Normal_Code

    mov  eax, [eax+0x2D]
    sar  eax, 18h
    call 0x004D2CB0 ; HouseClass * HouseClass::As_Pointer(HousesType) proc near

    cmp  eax, 0 ; Check for NULL
    jz   .Out

    test BYTE [eax+0x43], 1 ; test if house is dead or spectator
    jnz  .Out


.Normal_Code:
    pop  eax
    sub  esp, 34h
    mov  [ebp-0x30], eax
    jmp  0x00533186

.Out:
    pop  eax
    jmp  0x00533514

_Owner_From_Name_No_Multi_Houses_Check_In_Coop_Mode:
    cmp  DWORD [InCoopMode], 1
    jz   0x004AB661

    cmp  al, 0x0c
    jl   0x004AB661
    jmp  0x004AB65D

str_IsCoopMode db"IsCoopMode",0
InCoopMode    dd 0

_Read_Scenario_INI__Read_Is_Coop_Mode_Option:
    call INIClass__Get_Bool
    Save_Registers

    mov  edx, 0x005EFFA5; "Basic"
    mov  ebx, str_IsCoopMode
    mov  ecx, 0
    lea  eax, [ebp-0x8C] ; Scenario INI file
    call INIClass__Get_Bool

    mov  DWORD [InCoopMode], eax

    Restore_Registers
    jmp  0x0053D7C3

;0045E1BE   EB 4D            JMP SHORT ra95-spa.0045E20D
;0045919B   EB 4C            JMP SHORT ra95-spa.004591E9
;0045924B   EB 4A            JMP SHORT ra95-spa.00459297
;004D4F30   EB 2C            JMP SHORT ra95-spa.004D4F5E



_HouseClass__AI_No_Expert_AI_In_Coop_Mode:
    cmp  DWORD [InCoopMode], 1
    jz   0x004D4F5E

    test eax, eax        ; Hooked by patch
    jnz  0x004D4F5E
    mov  eax, [ebp-0x58]
    jmp  0x004D4F35


;004DA2AC   90               NOP



_HouseClass__AI_Building_Single_Player_AI_In_Coop:
    cmp  DWORD [InCoopMode], 1
    jz   0x004DA2AE

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x004DA2F1
    jmp  0x004DA2AE

;004DB87A   90               NOP



_HouseClass__AI_Unit_Single_Player_AI_In_Coop:
    cmp  DWORD [InCoopMode], 1
    jz   0x004DB880

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x004DBBEE; AI_Skirmish
    jmp  0x004DB880

;004DBD3D   EB 06            JMP SHORT ra95-spa.004DBD45



_HouseClass__AI_Vessel_Single_Player_AI_In_Coop:
    cmp  DWORD [InCoopMode], 1
    jz   0x004DBD45

    mov  dh, BYTE [SessionClass__Session]
    jmp  0x004DBD3B


;004DC18F   90               NOP



_HouseClass__AI_Infantry_Single_Player_AI_In_Coop:
    cmp  DWORD [InCoopMode], 1
    jz   0x004DC195

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x004DC53E ; Skirmish_AI
    jmp  0x004DC195



;0053E08A 90 NOP



_Assign_Houses_House_Auto_Production_Bit:
    mov  edx, 126h

    cmp  DWORD [InCoopMode], 1
    jz   .Ret

    or   ch, 8 ; Auto production bit for house

.Ret:
    jmp  0x0053E08D

;004D4159     90             NOP

;004DBB6A     B8 01000000    MOV EAX,1

;004DBA01  |. 90             NOP
;004DBA06  |. 90             NOP

;005601F8     EB 0B          JMP SHORT ra95-spa.00560205

;0055C425    ^E9 56FFFFFF    JMP ra95-spa.0055C380



_TeamClass__AI_Single_Player_Logic1:
    cmp  DWORD [InCoopMode], 1
    jz   0x0055C380

    cmp  BYTE [SessionClass__Session], 0
    jmp  0x0055C425

;0055C7B6     90             NOP



_TeamClass__AI_Single_Player_Logic2:
    cmp  DWORD [InCoopMode], 1
    jz   0x0055C7BC

    cmp  BYTE [SessionClass__Session], 0
    jmp  0x0055C7B6

;004FE1CC     C645 E4 00     MOV BYTE PTR SS:[EBP-1C],0



_LogicClass__AI_Call_HouseClass_AI_For_All_Houses_In_Coop:
    mov  al, BYTE [SessionClass__Session]

    cmp  DWORD [InCoopMode], 1
    jz   .Set_House_Types_Loop_Variable

    test al, al
    jnz  0x004FE1CC ;
    jmp  0x004FE1CA

.Set_House_Types_Loop_Variable:
    mov  BYTE [ebp-1Ch], 0
    jmp  0x004FE1D0


;004D4CAF     90             NOP



_HouseClass__AI_No_MPlayer_Defeated_Call_In_Coop:
    cmp  DWORD [InCoopMode], 1
    jz   0x004D4CB4

    call 0x004D8270 ; HouseClass::MPlayer_Defeated(void)
    jmp  0x004D4CB4

;005810A4     EB 28          JMP SHORT ra95-spa.005810CE



_UnitClass__Read_INI_Use_Single_Player_Logic:
    CMP  DWORD [InCoopMode], 1
    jz   0x005810CE

    cmp  BYTE [SessionClass__Session], 0
    jz   0x005810CE

    jmp  0x005810A6



_HouseClass__Use_Single_Player_Logic:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x004D407D

.Ret:
    jmp  0x004D4073

;0056826E     90             NOP



_TechnoClass__Is_Allowed_To_Retaliate_Single_Player_Logic:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x005682B6

.Ret:
    jmp  0x00568270

;00562F4C     90             NOP
;0056316E     90             NOP
;005631AF     EB 1A          JMP SHORT ra95-spa.005631CB

;0053DDEB     90             NOP



_Read_Scenario_INI_Dont_Create_MP_Spawning_Units_In_Coop:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    call 0x0053E204 ; Create_Units(int)

.Ret:
    jmp  0x0053DDF0

;004D8CAE NOP CREDITS



_HouseClass__Init_Data_Dont_Set_Credits_In_Coop_Mode:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    mov  [eax+197h], ecx ; Credits

.Ret:
    jmp  0x004D8CB4

;0053DFEC NOP BUILDLEVEL



_Assign_Houses__Dont_Set_Tech_Level_In_Coop_Mode:
    mov  eax, DWORD [0x006016C8] ; ds:int BuildLevel

    CMP  DWORD [InCoopMode], 1
    jz   0x0053DFEF

    jmp  0x0053DFE2

;0053E0D0   90               NOP IQLEEL



_Assign_Houses__Dont_Set_IQ_Level_In_Coop_Mode:
    mov  eax, DWORD [0x00666780] ; ds:nRulesClass_IQ_MaxIQLevels

    CMP  DWORD [InCoopMode], 1
    jz   0x0053E0D3

    jmp  0x0053E0D0

;0053E0FB NOP BUILDLEVEL AGAIN



_Assign_Houses__Dont_Set_Tech_Level_In_Coop_Mode2:
    mov  eax, DWORD [0x006016C8] ; ds:int BuildLevel

    CMP  DWORD [InCoopMode], 1
    jz   0x0053E0FE

    jmp  0x0053E0F1


_BuildingClass__Repair_AI_Use_Single_Player_Logic1:
    CMP  DWORD [InCoopMode], 1
    jz   0x00460176

    cmp  BYTE [SessionClass__Session], 0
    jz   0x00460176

    jmp  0x0045FF41



_BuildingClass__Repair_AI_Use_Single_Player_Logic2:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x00460089

.Ret:
    jmp  0x0046007C




_TechnoClass__Base_Is_Attacked_Single_Player_Logic1:
    CMP  DWORD [InCoopMode], 1
    jz   .Ret

    cmp  BYTE [SessionClass__Session], 0
    jnz  0x0056789D

.Ret:
    jmp  0x00567884



_TechnoClass__Base_Is_Attacked_Single_Player_Logic2:
    CMP  DWORD [InCoopMode], 1
    jz   0x00567B4E

    cmp  BYTE [SessionClass__Session], 0
    jz   0x00567B4E

    jmp  0x00567BD3



_TechnoClass__Base_Is_Attacked_Single_Player_Logic3:
    CMP  DWORD [InCoopMode], 1
    jz   0x00567DDF

    cmp  BYTE [SessionClass__Session], 0
    jz   0x00567DDF

    jmp  0x00567E65

_TActionClass_Operator___ACTION_LOSE_Multiplayer:
    cmp  DWORD [InCoopMode], 1 ; if coop don't set PlayeWins to true
    jz   0x00554941

    cmp  bl, [edx+9]
    jz   0x00554941
.Ret:
    jmp  0x00554985

_TActionClass_Operator___ACTION_WIN_Multiplayer:
    cmp  DWORD [InCoopMode], 1 ; if coop don't set PlayerLoses to true
    jz   .Ret

    cmp  bh, [edx+9]
    jnz  0x00554941

.Ret:
    jmp  0x0055492B

_HouseClass__AI_Player_Lose_Flag_Set_Remove_Win:
    cmp  DWORD [InCoopMode], 1 ; if coop don't set PlayerLoses to true
    jz   .Ret

    mov  DWORD [0x006680C8], 1 ; PlayerWins

.Ret:
    jmp  0x004D85B3



_HouseClass__AI_Player_Win_Flag_Set_Remove_Lose:
    cmp  DWORD [InCoopMode], 1 ; if coop don't set PlayerLoses to true
    jz   .Ret

    mov  DWORD [0x006680CC], 1 ; PlayerLoses

.Ret:
    jmp  0x04D41D4
