@HOOK 0x004BE468 _Custom_Missions_Load_Mission_Name
@HOOK 0x004BE491 _Custom_Missions_Load_Mission_Name2
@HOOK 0x004BE929 _Custom_Missions_Hook_Function_End
@HOOK 0x004BE548 _Custom_Missions_Amount_To_Read
@HOOK 0x004BE732 _Custom_Missions_Amount_To_Read2
@HOOK 0x004BE132 _Custom_Missions_Dont_Prepend_Side
@HOOK 0x004BE147 _Custom_Missions_Dont_Prepend_Side2
@HOOK 0x00501E0E _Custom_Missions_Custom_Missions_Button_Name
@HOOK 0x004BE7C8 _Custom_Missions_Custom_Missions_Dialog_Name
@HOOK 0x004BE7DE _Custom_Missions_Expansion_Missions_Dialog_Name
@HOOK 0x00501E3F _Custom_Missions_Expansion_Missions_Button_Name
@HOOK 0x00501DB3 _Custom_Missions_Enable_Custom_Missions_Button
@HOOK 0x00501DDB _Custom_Missions_Enable_Expansion_Missions_Button
@HOOK 0x0053B520 _Do_Win_Next_Mission_In_Campaign
@HOOK 0x0053B23C _Campaign_Do_Win_Next_mission_In_Campaign
@HOOK 0x00500C62 _Map_Selection_Selection_Animation
@HOOK 0x005011FE _Map_Selection_Selected_Mission_Name

@JMP 0x00538764 0x00538771

_Map_Selection_Selected_Mission_Name:
    cmp  byte [NextCampaignMissionBuf], 0
    jz   .Ret

    cmp  byte al, 'A'
    jnz  .Not_A

    push MapSelectABuf
    jmp  .Start_String_Copy

.Not_A:

    cmp  byte al, 'B'
    jnz  .Not_B

    push MapSelectBBuf
    jmp  .Start_String_Copy

.Not_B:

    cmp  byte al, 'C'
    jnz  .Not_C

    push MapSelectCBuf
    jmp  .Start_String_Copy

.Start_String_Copy:
    push NextCampaignMissionBuf
    call _strcpy

.Not_C:
.Ret:
    mov  BYTE [0x00684F3A], al
    jmp  0x00501203

_Map_Selection_Selection_Animation:
    push 0
    lea  eax, [ebp-0x78]

    cmp  DWORD [MapSelectionAnimationBuf], 0
    jz   .Ret

    lea  eax, [MapSelectionAnimationBuf]

.Ret:
    jmp  0x00500C67

_Campaign_Do_Win_Next_mission_In_Campaign:
    cmp  BYTE [NextCampaignMissionBuf], 0
    jz   .Ret

    ; Copy next campaign mission filename to ScenarioName global char array
    push NextCampaignMissionBuf
    push eax
    call _strcpy

    mov  eax, NextCampaignMissionBuf

.Ret:
    call 0x0053A0A4; Start_Scenario(char *,int) ; Hooked by patch
    jmp  0x0053B241

_Do_Win_Next_Mission_In_Campaign:
    cmp  BYTE [NextCampaignMissionBuf], 0
    jz   .Ret

    ; Copy next campaign mission filename to ScenarioName global char array
    push NextCampaignMissionBuf
    push eax
    call _strcpy

    mov  eax, NextCampaignMissionBuf

.Ret:
    call 0x0053A0A4; Start_Scenario(char *,int) ; Hooked by patch
    jmp  0x0053B525

_Custom_Missions_Enable_Expansion_Missions_Button:
    call 0x004BE090 ;  Expansion_CS_Present(void)
    cmp  eax, 1
    jz   .Return_True

    call 0x004BE09C ;  Expansion_AM_Present(void)
    cmp  eax, 1
    jz   .Return_True

    mov  eax, 0
    jmp  0x00501DE0

.Return_True:
    mov  eax, 1
    jmp  0x00501DE0

_Custom_Missions_Enable_Custom_Missions_Button:
    mov  eax, 1
    jmp  0x00501DB8



_Custom_Missions_Expansion_Missions_Button_Name:
    push edx
    push eax

    Extract_Conquer_Eng_String 119
    mov  ebx, eax

    pop  eax
    pop  edx

    jmp  0x00501E44

_Custom_Missions_Expansion_Missions_Dialog_Name:
    push edx

    Extract_Conquer_Eng_String 119

    pop  edx
    jmp  0x004BE7E3

_Custom_Missions_Custom_Missions_Dialog_Name:
    push edx

    Extract_Conquer_Eng_String 120

    pop  edx
    jmp  0x004BE7CD

_Custom_Missions_Custom_Missions_Button_Name:
    push edx
    push eax

    Extract_Conquer_Eng_String 120
    mov  ebx, eax

    pop  eax
    pop  edx
    jmp  0x00501E13

_Custom_Missions_Load_Mission_Name:
    cmp  DWORD [ebp-24h], 0 ; Expansion type
    jz   .Do_Normal_Read

    Save_Registers
    mov  esi, DWORD [MissionCounter]
    inc  DWORD [MissionCounter]
    push esi             ; Format
    push str_sprintf_format3 ; %d
    lea  esi, [sprintf_buffer3]
    push esi             ; Dest

    call _sprintf
    add  esp, 0Ch
    Restore_Registers
    mov  esi, sprintf_buffer3
    jmp  0x004BE46E

.Do_Normal_Read:
    MOV  ESI, DWORD [ESI+0x601400]
    jmp  0x004BE46E

_Custom_Missions_Load_Mission_Name2:
    cmp  DWORD [ebp-24h], 0 ; Expansion type
    jz   .Do_Normal_Read
    mov  esi, sprintf_buffer3
    jmp  0x004BE497

.Do_Normal_Read:
    MOV  ESI, DWORD [ESI+0x601400]
    jmp  0x004BE497

_Custom_Missions_Hook_Function_End:
    mov  DWORD [MissionCounter], 0
    pop  edi
    pop  esi
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    retn

_Custom_Missions_Amount_To_Read:
    cmp  DWORD [ebp-24h], 0 ; Expansion type
    jz   .Not_Custom_Missions_Dialog

    cmp  edi, 999h
    jge  0x004BE552
    jmp  0x004BE54D

.Not_Custom_Missions_Dialog:
    mov  ebx, 0

    call 0x004BE090 ;  Expansion_CS_Present(void)
    cmp  eax, 1
    jz   .CS_Present

    mov  ebx, 24h

.CS_Present:
    mov  eax, ebx
    cmp  edi, eax
    jge  0x004BE552
    jmp  0x004BE54D

_Custom_Missions_Amount_To_Read2:
    mov  [ebp-30h], ecx

    cmp  DWORD [ebp-24h], 0 ; Expansion type
    jz   .Not_Custom_Missions_Dialog

    cmp  ecx, 900h
    jmp  0x004BE738

.Not_Custom_Missions_Dialog:
    mov  ebx, 36h

    call 0x004BE09C ;  Expansion_AM_Present(void)
    cmp  eax, 1
    jz   .AM_Present

    mov  ebx, 24h

.AM_Present:
    mov  eax, ebx
    cmp  ecx, eax
    jmp  0x004BE738

_Custom_Missions_Dont_Prepend_Side:
    push str_s_format      ; "%s"
    jmp  0x004BE138

_Custom_Missions_Dont_Prepend_Side2:
    mov  ax, [edi+2Ch]
    add  esp, 0Ch
    jmp  0x004BE14E
