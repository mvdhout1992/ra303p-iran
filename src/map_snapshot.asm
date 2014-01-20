str_MapSnap_MPR db"MapSnap.MPR",0

%define Basic_Section 0x005EFFA5

; sizes not actually verified
MapSnapshot_CCINIClass  TIMES 256 db 0
MapSnapshot_FileClass   TIMES 256 db 0

Create_Map_Snapshot:
    Save_Registers

    ; Initialize output file
    mov  edx, str_MapSnap_MPR
    mov  eax, MapSnapshot_FileClass
    call 0x004627D4  ;   CCFileClass::CCFileClass(char *)

    ; initialize CCINIClass
    mov  eax, MapSnapshot_CCINIClass
    call CCINIClass__CCINIClass

;===========================
    ; Write [Basic]

    ; Map name
    mov  eax, 0x00667BD8
    call_INIClass__Put_String MapSnapshot_CCINIClass, Basic_Section, 0x005EFFB2, eax

    ; NewINIFormat
    call_INIClass__Put_Int MapSnapshot_CCINIClass, Basic_Section, 0x005F000E, DWORD [0x00665DE8]

    ; Intro
    call_CCINIClass__Put_VQType MapSnapshot_CCINIClass, Basic_Section, 0x005EFFB7, BYTE [0x00667C04]

    ; Brief
    call_CCINIClass__Put_VQType MapSnapshot_CCINIClass, Basic_Section, 0x005EFFBD, BYTE [0x00667C05]

    ; Win
    call_CCINIClass__Put_VQType MapSnapshot_CCINIClass, Basic_Section, 0x005EFFC3, BYTE [0x00667C06]

    ; Lose
    call_CCINIClass__Put_VQType MapSnapshot_CCINIClass, Basic_Section, 0x005EFFC7, BYTE [0x00667C07]

    ; Action
    call_CCINIClass__Put_VQType MapSnapshot_CCINIClass, Basic_Section, 0x005EFFCC, BYTE [0x00667C08]

    ; ToCarryOver
    xor  ecx, ecx
    test byte [0x006680A1], 8 ; ptr ds:Scenario_bool_bitfield_6680A1
    setne cl
    call_INIClass__Put_Bool MapSnapshot_CCINIClass, Basic_Section, 0x005EFFD3, ecx

    ; Theme
    call_CCINIClass__Put_ThemeType MapSnapshot_CCINIClass, Basic_Section, 0x005F0008, BYTE [0x00668009]

    ; CarryOverMoney
    call_INIClass__Put_Fixed MapSnapshot_CCINIClass, Basic_Section, 0x0005F001B, 0x0066800B

    ; CarryOverCap
    call_INIClass__Put_Int MapSnapshot_CCINIClass, Basic_Section, 0x005F002A, DWORD [0x00668011]

;=========================
    ; Write other stuff
    mov  edx, MapSnapshot_CCINIClass
    mov  eax, 0x00668250 ; offset MouseClass Map
    call 0x004B545C   ;  void DisplayClass::Write_INI(CCINIClass &)

    mov  edx, MapSnapshot_CCINIClass
    mov  eax, 0x0067F28C ; offset BaseClass Base
    call 0x00426944     ; void BaseClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x005501E4    ; void SmudgeClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0052736C     ; void OverlayClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0056076C ; void TeamTypeClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0056AD6C     ; void TerrainClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0056D640     ; void TriggerTypeClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x004DDEB0     ; void HouseClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x004F0A84    ; void InfantryClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x00581298     ; void UnitClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0058CC18     ; void VesselClass::Write_INI(CCINIClass &)

    mov  eax, MapSnapshot_CCINIClass
    call 0x0045F07C     ; void BuildingClass::Write_INI(CCINIClass &)

.Save_File:
    xor  ebx, ebx
    mov  edx, MapSnapshot_FileClass
    mov  eax, MapSnapshot_CCINIClass
    call INIClass__Save

.Ret:
    Restore_Registers
    retn
