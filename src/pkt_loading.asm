@HOOK 0x0054BA32 _Conditionally_Load_Missions_PKT
@HOOK 0x0054BD30 _Patch_Out_Counterstrike_Installed_Check
@HOOK 0x0054BD3D _Conditionally_Load_Cstrike_PKT
@HOOK 0x0054BE9E _Patch_Out_Aftermath_Installed_Check
@HOOK 0x0054BEAB _Conditionally_Load_Aftmath_PKT

str_blankpkt db"BLANK.PKT",0

%define missionspkt_str 0x005F06FD
%define cstrikepkt_str    0x005F0748
%define aftmathpkt_str    0x005F0770

_Conditionally_Load_Missions_PKT:
    cmp  BYTE [displayoriginalmultiplayermaps], 1
    jnz  .No_Load

    mov  edx, missionspkt_str
    jmp  0x0054BA37

.No_Load:
    mov  edx, str_blankpkt
    jmp  0x0054BA37

_Patch_Out_Counterstrike_Installed_Check:
    jmp  0x0054BD3D

_Conditionally_Load_Cstrike_PKT:
    cmp  BYTE [displaycounterstrikemultiplayermaps], 1
    jnz  .No_Load

    mov  edx, cstrikepkt_str
    jmp  0x0054BD42

.No_Load:
    mov  edx, str_blankpkt
    jmp  0x0054BD42

_Patch_Out_Aftermath_Installed_Check:
    jmp  0x0054BEAB

_Conditionally_Load_Aftmath_PKT:
    cmp  BYTE [displayaftermathmultiplayermaps], 1
    jnz  .No_Load

    mov  edx, aftmathpkt_str
    jmp  0x0054BEB0

.No_Load:
    mov  edx, str_blankpkt
    jmp  0x0054BEB0
