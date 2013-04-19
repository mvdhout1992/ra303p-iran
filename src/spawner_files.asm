@HOOK   0x004F4197  _Init_Game_RULES_File
@HOOK   0x0054C013  _SessionClass__Read_Scenario_Descriptions_Map_Extension

str_spawn_xdp: db"spawn.xdp",0
str_mmm_ext: db".MMM",0
spawnmix_str db"spawn1.MIX",0

_Init_Game_RULES_File:
    CALL    0x00547810 ; SmudgeTypeClass::Init_Heap(void)
        
    Save_Registers
    
    ; SPAWN1.MIX
    Load_Mix_File_Cached    spawnmix_str
    
    CALL GetCommandLineA

    MOV EDX, str_spawn_arg
    CALL stristr_
    TEST EAX,EAX
    
    JE .Ret_RULES_INI
    
    Restore_Registers
    mov     edx, str_spawn_xdp
    jmp     0x004F41A1
    
.Ret_RULES_INI:
    Restore_Registers
    jmp     0x004F419C
    
_SessionClass__Read_Scenario_Descriptions_Map_Extension:

    CALL GetCommandLineA

    MOV EDX, str_spawn_arg
    CALL stristr_
    TEST EAX,EAX
    
    JE .Ret_MPR_extension
    
    push    str_mmm_ext ; ".MMM"
    jmp     0x0054C018
    
.Ret_MPR_extension:
    push    0x005F0798 ; ".MPR"
    jmp     0x0054C018
    