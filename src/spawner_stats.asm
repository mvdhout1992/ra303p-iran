@HOOK 0x004D3C95 _HouseClass__HouseClass_Enable_Unit_Trackers_Spawner
@HOOK 0x004D3E52 _HouseClass__Deconstructor_Delete_Unit_Trackers_Spawner
@HOOK 0x0045AF9F _BuildingClass__Captured_Increment_Unit_Total
@HOOK 0x004A0B00 _CellClass__Goodie_Check_Track_Crates_Spawner
@HOOK 0x004A558F _Main_Game__Main_Loop_End_Spawner
@HOOK 0x005B787D _Send_Statistics_Packet_Dump_Statistics
@HOOK 0x00581C98 _UnitTrackerClass__Increment_Unit_Total_Skip_Singleplayer
@HOOK 0x00581CA4 _UnitTrackerClass__Decrement_Unit_Total_Skip_Singleplayer
@HOOK 0x005B6F3B _Send_Statistics_Packet_Fix_Color_Info
@HOOK 0x005B7103 _Send_Statistics_Packet_Fix_VSLx_Byte_Order
@HOOK 0x005B65EB _Send_Statistics_Packet_Fix_NUMP_Human_Player_Count
@HOOK 0x005B7536 _Send_Statistics_Packet_FIX_BLLx_Info
@HOOK 0x005B7493 _Send_Statistics_Packet_Fix_INLx_Info
@HOOK 0x005B74C8 _Send_Statistics_Packet_Fix_UNLx_Info
@HOOK 0x005B74FD _Send_Statistics_Packet_Fix_PLLx_Info
@HOOK 0x005B756B _Send_Statistics_Packet_Fix_VSLx_Info
@HOOK 0x00566C09 _TechnoClass__Record_The_Kill_Vessels_Killed_Fix
@HOOK 0x004DCDD2 _HouseClass__Tracking_Add_New_Vehicle_Tracking
@HOOK 0x004DCBD1 _HouseClass__Tracking_Remove_New_Vehicle_Tracking
@HOOK 0x004DCE40 _HouseClass__Tracking_Add_New_Vessels_Tracking
@HOOK 0x004DCBFB _HouseClass__Tracking_Remove_New_Vessels_Tracking
@HOOK 0x004DCCF8 _HouseClass__Tracking_Add_New_Planes_Tracking
@HOOK 0x004DCB7C _HouseClass__Tracking_Remove_New_Planes_Tracking
@HOOK 0x004DCD5B _HouseClass__Tracking_Add_New_Infantry_Tracking
@HOOK 0x004DCBA7 _HouseClass__Tracking_Remove_New_Infantry_Tracking
@HOOK 0x004DCC8F _HouseClass__Tracking_Add_New_Building_Tracking
@HOOK 0x004DCB5B _HouseClass__Tracking_Remove_New_Building_Tracking
;@HOOK 0x005B712F _Send_Statistics_Packet_Skip_Clear_Unit_Total
@HOOK 0x005B6544 _Send_Statistics_Packet_Send_Only_Once
@HOOK 0x005B7754 _Send_Statistics_Packet_New_Per_Player_Fields
@HOOK 0x0052B8F0 _Execute_DoList_No_Special_End_Game_Statistics_Logic_For_Two_Players_Game
@HOOK 0x00506676 _Destroy_Connection_Add_HouseClass_Connection_Lost_Info
@HOOK 0x004BD1FF _EventClass__Execute_Set_HouseClass_Resign_On_DESTRUCT_Event


@JMP  0x005B654A 0x005B6557 ; jump over pWOLobject == NULL check
@JMP  0x005B6574 0x005B659C ; jump over SDFX WOL code
@JMP  0x005B6636 0x005B666C ; jump over WOL code
@JMP  0x005B6850 0x005B6862 ; jump into WOL code for addresses and ping stuff (might cause crashes in online mode)
@JMP  0x005B6AD2 0x005B6AF0 ; jump over some WOL specific ping code
@JMP  0x005B78DD 0x005B7925 ; jump to exit before WOL packet sending

@JMP  0x00566BB5 0x00566BBE ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x00566B44 0x00566B4D ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x00566AD4 0x00566ADD ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x00566A65 0x00566A6E ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x005669A3 0x005669AC ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total

@JMP  0x004DCCA9 0x004DCCB2  ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x004DCD12 0x004DCD1B  ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x004DCD7E 0x004DCD87  ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x004DCE04 0x004DCE0D  ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total
@JMP  0x004DCE72 0x004DCE77  ; jump over SessionClass == 4 check for UnitTrackerClass::Increment_Unit_Total

%define CCFileClass__CCFileClass    0x004627D4
%define CCFileClass__OpenFile       0x00462AD4
%define CCFileClass__WriteBytes     0x00462860
%define CCFileClass__CloseHandle    0x00462AA8

; PlanetWestwoodStartTime & PlanetWestwoodGameID are global int32 variables that probably need to be filled in by spawner code

; Use Offset +0x1803 to +0x1873 for infantry left
; Use Offset +0x1873 to +0x18E3 for tanks left
; Use Offset +0x1903 to +0x1973 for planes left
; Use Offset +0x1973 to +0x19E3 for vessels left
; Use Offset +0x1A00 to +0x1B60 for buildings left

%define Stats_PacketClass_This    -0x6C

str_stats_dmp: db "stats.dmp",0

Statistics_Packet_Sent: db    0

_EventClass__Execute_Set_HouseClass_Resign_On_DESTRUCT_Event:
    mov  DWORD [eax+EXT_Resigned], 1
    call 0x004D8B40; HouseClass::Flag_To_Die(void)
    jmp  0x004BD204

_Destroy_Connection_Add_HouseClass_Connection_Lost_Info:
    cmp  edx, 0
    jz   .Ret
    mov  DWORD [eax+EXT_ConnectionLost], 1 ; for connection lost

.Ret:
    test byte [eax+42h], 2
    jz   0x00506837
    jmp  0x0050667C

_Execute_DoList_No_Special_End_Game_Statistics_Logic_For_Two_Players_Game:
    jmp  0x0052B916

Ally_Field db "ALY"
Ally_Field_Player db 0x3F
Ally_Field_Null db 0

IsDead_Field db "DED"
IsDead_Field_Player db 0x3F
IsDead_Field_Null db 0

IsSpectator_Field db "SPC"
IsSpectator_Field_Player db 0x3F
IsSpectator_Field_Null db 0

SpawnLocation_Field db "SPA"
SpawnLocation_Field_Player db 0x3F
SpawnLocation_Field_Null db 0

ConnectionLost_Field db "CON"
ConnectionLost_Field_Player db 0x3F
ConnectionLost_Field_Null db 0

Resigned_Field db "RSG"
Resigned_Field_Player db 0x3F
Resigned_Field_Null db 0

_Send_Statistics_Packet_New_Per_Player_Fields:
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [Ally_Field_Player], al

    mov  eax, 10h
    mov  ebx, [esi+0x174C] ; Alliances bit field
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .Ally_Field_Operator_New_Failed
    mov  edx, Ally_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.Ally_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

;ConnectionLost field
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [ConnectionLost_Field_Player], al

    mov  eax, 10h
    mov  ebx, [esi+EXT_ConnectionLost]
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .ConnectionLost_Field_Operator_New_Failed
    mov  edx, ConnectionLost_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.ConnectionLost_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

;Resigned field
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [Resigned_Field_Player], al

    mov  eax, 10h
    mov  ebx, [esi+EXT_Resigned]
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .Resigned_Field_Operator_New_Failed
    mov  edx, Resigned_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.Resigned_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

;SpawnLocation field
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [SpawnLocation_Field_Player], al

    mov  eax, 10h
    mov  ebx, [esi+EXT_SpawnLocation] ; SpawnLocation
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .SpawnLocation_Field_Operator_New_Failed
    mov  edx, SpawnLocation_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.SpawnLocation_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

; IsDead field
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [IsDead_Field_Player], al

    mov  eax, 10h
    xor  ebx, ebx
    test BYTE [esi+0x43], 1 ; IsDead bit field
    setnz bl
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .IsDead_Field_Operator_New_Failed
    mov  edx, IsDead_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.IsDead_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

; IsSpectator Field
    mov  al, byte [ebp-0x48]
    add  al, 31h
    mov  BYTE [IsSpectator_Field_Player], al

    mov  eax, 10h
    mov  ebx, [esi+EXT_IsSpectator] ; Alliances bit field
    call 0x005BBF80 ; operator new(uint)
    test eax, eax
    jz   .IsSpectator_Field_Operator_New_Failed
    mov  edx, IsSpectator_Field
    call 0x005B8878 ; FieldClass::FieldClass(char *,ulong)

.IsSpectator_Field_Operator_New_Failed:
    mov  edx, eax
    lea  eax, [ebp+Stats_PacketClass_This]
    call 0x005B7A14 ; PacketClass::Add_Field(FieldClass *)

.Ret:
    mov  al, byte [ebp-0x48]
    add  al, 31h
    jmp  0x005B7759

_TechnoClass__Record_The_Kill_Vessels_Killed_Fix:
    mov  eax, [eax+0x1C3]
    jmp  0x00566C0F

_Send_Statistics_Packet_Send_Only_Once:
    cmp  BYTE [SessionClass__Session], 0 ; if single player dont send statistics
    jz   .Early_Ret

    cmp  DWORD [SaveGameVersion], 0 ; if we loaded from savegame dont send statistics
    jnz  .Early_Ret

    cmp  DWORD [spawner_is_active], 0
    jz   .Normal_Code
    cmp  BYTE [Statistics_Packet_Sent], 0
    jz   .First_Time

.Early_Ret:
    sub  esp, 0x5DC
    jmp  0x005B7940

.First_Time:
    mov  BYTE [Statistics_Packet_Sent], 1
    jmp  .Normal_Code

.Normal_Code:
    sub  esp, 0x5DC
    jmp  0x005B654A

_Send_Statistics_Packet_Skip_Clear_Unit_Total:
    xor  ecx, ecx
    xor  ebx, ebx

    jmp  0x005B716A

_HouseClass__Tracking_Remove_New_Building_Tracking:
    dec  dword [ebx+eax*4+0x1A00]

    dec  dword [ebx+eax*4+306h]
    jmp  0x004DCB62

_HouseClass__Tracking_Add_New_Building_Tracking:
    inc  dword [esi+0x1A00]

    inc  dword [esi+306h]
    jmp  0x004DCC95

_HouseClass__Tracking_Remove_New_Infantry_Tracking:
    sar  eax, 18h

    dec  dword [ebx+eax*4+0x1803]

    cmp  eax, 18h
    jmp  0x004DCBAD

_HouseClass__Tracking_Add_New_Infantry_Tracking:
    movsx eax, cl

    inc  dword [ebx+eax*4+0x1803]

    cmp  eax, 18h
    jmp  0x004DCD61

_HouseClass__Tracking_Remove_New_Planes_Tracking:
    dec  dword [ebx+eax*4+0x1903]

    dec  dword [ebx+eax*4+4EEh]
    jmp  0x004DCB83

_HouseClass__Tracking_Add_New_Planes_Tracking:
    inc  dword [esi+0x1903]

    inc  dword [esi+4EEh]
    jmp  0x004DCCFE

_HouseClass__Tracking_Remove_New_Vessels_Tracking:
    sar  eax, 18h

    dec  DWORD [ebx+eax*4+0x1973]

    cmp  eax, 5
    jmp  0x004DCC01

_HouseClass__Tracking_Add_New_Vessels_Tracking:
    movsx eax, cl

    inc  DWORD [ebx+eax*4+0x1973]

    cmp  eax, 5
    jmp  0x004DCE46

_HouseClass__Tracking_Remove_New_Vehicle_Tracking:
    sar  eax, 18h

    dec  DWORD [ebx+eax*4+0x1873]

    cmp  eax, 11h
    jmp  0x004DCBD7

_HouseClass__Tracking_Add_New_Vehicle_Tracking:
    movsx eax, cl

    inc  DWORD [ebx+eax*4+0x1873]

    cmp  eax, 11h
    jmp  0x004DCDD8

_Send_Statistics_Packet_Fix_VSLx_Info:
    lea  eax, [ESI+0x1973]
    mov  DWORD ecx, 7
    call Dword_Swap_Memory

    lea  ebx, [ESI+0x1973]
    MOV  DWORD ECX, 0x1c
    MOV  EAX, 0x10

    jmp  0x005B7587

_Send_Statistics_Packet_Fix_PLLx_Info:
    lea  eax, [ESI+0x1903]
    mov  DWORD ecx, 7
    call Dword_Swap_Memory

    lea  ebx, [ESI+0x1903]
    MOV  DWORD ECX, 0x1c
    MOV  EAX, 0x10
    jmp  0x005B7519

_Send_Statistics_Packet_Fix_UNLx_Info:
    lea  eax, [ESI+0x1873]
    mov  DWORD ecx, 0x16
    call Dword_Swap_Memory

    lea  ebx, [ESI+0x1873]
    MOV  DWORD ECX, 88
    MOV  EAX, 0x10

    jmp  0x005B74E0

_Send_Statistics_Packet_Fix_INLx_Info:

    lea  eax, [ESI+0x1803]
    mov  DWORD ecx, 26
    call Dword_Swap_Memory

    lea  ebx, [ESI+0x1803]
    MOV  DWORD ECX, 0x68
    MOV  EAX, 0x10
    jmp  0x005B74AB

_Send_Statistics_Packet_FIX_BLLx_Info:
    lea  eax, [ESI+0x1A00]
    mov  DWORD ecx, 87
    call Dword_Swap_Memory

    LEA  EBX, [ESI+0x1A00]
    MOV  DWORD ECX, 0x15C
    MOV  EAX, 0x10
    jmp  0x005B754E

; eax = memory address to start swapping, ecx = count
Dword_Swap_Memory:
    Save_Registers
    mov  esi, eax
    mov  ebx, 0
    mov  edi, 0

.Loop:
    lea  eax, [esi]
    mov  eax, [ebx+eax]
    push ecx
    push eax             ; hostlong
    call 0x005E5A30 ; htonl(x)
    pop  ecx
    lea  edx, [esi]
    mov  [edx+ebx], eax
    inc  edi
    add  ebx, 4
    cmp  edi, ecx
    jl   .Loop

    Restore_Registers
    retn

_Send_Statistics_Packet_Fix_NUMP_Human_Player_Count:
    mov  DWORD ebx, [HumanPlayers]
    jmp  0x005B65F6

_Send_Statistics_Packet_Fix_VSLx_Byte_Order:
    mov  eax, [esi+1AFh]
    call 0x00581D20 ; UnitTrackerClass::To_PC_Format(void)

    mov  eax, [esi+1A3h]
    jmp  0x005B7109

_Send_Statistics_Packet_Fix_Color_Info:
    mov  BYTE dl, [eax+0x25]
    xor  eax, eax
    mov  al, dl
    call 0x004D2CB0 ; HouseClass * HouseClass::As_Pointer(HousesType)
    mov  BYTE dl, [eax+0x178F]
    mov  eax, 0x10
    jmp  0x005B6F46

; Prevent crash when playing in singleplayer
_UnitTrackerClass__Decrement_Unit_Total_Skip_Singleplayer:
    cmp  BYTE [SessionClass__Session], 0
    jz   .Early_Return

    cmp  BYTE [SessionClass__Session], 5
    jz   .Hack_For_Old_Skirmish_Savegames

.Normal_Code:
    push ebp
    mov  ebp, esp
    mov  eax, [eax]
    dec  dword [eax+edx*4]
    mov  esp, ebp
    pop  ebp

.Early_Return:
    jmp  0x00581CAF ; jmp to RETN instruction at tend of function

.Hack_For_Old_Skirmish_Savegames:
    cmp  DWORD [spawner_is_active], 0
    jz   .Early_Return

    cmp  DWORD [SaveGameVersion], 0
    jnz  .Early_Return

    jmp  .Normal_Code

; Prevent crash when playing in singleplayer
_UnitTrackerClass__Increment_Unit_Total_Skip_Singleplayer:
    cmp  BYTE [SessionClass__Session], 0
    jz   .Early_Return

    cmp  BYTE [SessionClass__Session], 5
    jz   .Hack_For_Old_Skirmish_Savegames


.Normal_Code:
    push ebp
    mov  ebp, esp
    mov  eax, [eax]
    inc  dword [eax+edx*4]
    mov  esp, ebp
    pop  ebp

.Early_Return:
    jmp  0x00581CA3 ; jmp to RETN instruction at tend of function

.Hack_For_Old_Skirmish_Savegames:
    cmp  DWORD [spawner_is_active], 0
    jz   .Early_Return

    cmp  DWORD [SaveGameVersion], 0
    jnz  .Early_Return

    jmp  .Normal_Code

_BuildingClass__Captured_Increment_Unit_Total:
    jmp  0x0045AFA8

_Send_Statistics_Packet_Dump_Statistics:
    Save_Registers

    ; char* buffer with all the statistics is in EAX
    mov  edx, 0x006ABC14 ; offset int Send_Statistics_Packet(void)::.0::packet_size
    CALL Write_Stats_File

.Ret:
    Restore_Registers
    mov  ebx, eax
    mov  edx, esi
    mov  [ebp-0xEC], esi
    jmp  0x005B7887

Write_Stats_File:

    PUSH EBP
    MOV  EBP,ESP

%define stats_buf     EBP-4
%define stats_length  EBP-4-4
%define stats_file    EBP-4-4-100
    SUB  ESP,4+4+100

    LEA  EBX,[stats_buf]
    MOV  [EBX],EAX
    LEA  EBX,[stats_length]
    MOV  [EBX],EDX

    LEA  EAX,[stats_file]
    MOV  EDX,str_stats_dmp
    CALL CCFileClass__CCFileClass

    MOV  EDX,3
    LEA  EAX,[stats_file]
    CALL CCFileClass__OpenFile
    TEST EAX,EAX
    JE   .exit

    mov  EBX,[stats_length]
    MOV  EBX,[EBX]
    mov  EDX,[stats_buf]

    LEA  EAX,[stats_file]
    CALL CCFileClass__WriteBytes

    LEA  EAX,[stats_file]
    CALL CCFileClass__CloseHandle

.exit:
    MOV  EAX,1

    MOV  ESP,EBP
    POP  EBP
    RETN

_Main_Game__Main_Loop_End_Spawner:
    cmp  DWORD [spawner_is_active], 1
    jz   0x004A55A1

    cmp  DWORD [0x006ABBB8], 0 ; GameStatisticsPacketSent
    jmp  0x004A5596


_HouseClass__HouseClass_Enable_Unit_Trackers_Spawner:
;;    cmp  DWORD [spawner_is_active], 1
;;    jz   .Continue

;;    cmp  ah, 4
;;    jnz  0x004D3E2A

.Continue:
    jmp  0x004D3C9E

_CellClass__Goodie_Check_Track_Crates_Spawner:
    jmp  0x004A0B09

;;    cmp  DWORD [spawner_is_active], 1
;;    jz   0x004A0B09

;;    cmp  BYTE [SessionClass__Session], 4
;;    jmp  0x004A0B07

_HouseClass__Deconstructor_Delete_Unit_Trackers_Spawner:
    jmp  0x004D3E5F
;;    cmp  DWORD [spawner_is_active], 1
;;    jz   0x004D3E5F

;;    cmp  BYTE [SessionClass__Session], 4
;;    jmp  0x004D3E59
