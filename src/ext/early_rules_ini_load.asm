@HOOK 0x004F4094 _Init_Game_Early_RULES_INI_Load
@HOOK 0X004F419C _Init_Game_Patch_Out_Later_RULES_INI_Load


_Init_Game_Patch_Out_Later_RULES_INI_Load:
    mov  eax, 1
    jmp  0x004F41BA

_Init_Game_Early_RULES_INI_Load:
    Save_Registers

    CALL GetCommandLineA

    MOV  EDX, str_spawn_arg
    CALL _stristr
    TEST EAX,EAX

    JE   .Ret_RULES_INI

    mov  edx, str_spawn_xdp
    jmp  .Past_Checking_For_Spawner_Active

.Ret_RULES_INI:
    mov  edx, 0x005EBB3B ; "RULES.INI"

.Past_Checking_For_Spawner_Active:

    lea  eax, [ebp-0xD4]
    call 0x004627D4 ; CCFileClass::CCFileClass(char *)
    xor  ebx, ebx
    mov  edx, eax
    mov  eax, 0x00666688 ; offset CCINIClass RuleINI
    call 0x00462F50 ; CCINIClass::Load(FileClass &,int)

    ; Call functions to load lists for certain unhardcoding features
    mov  eax, RuleINI
    call Rules_INI_Load_Sound_Effects_List

.Ret:
    Restore_Registers
    mov  edx, 14h
    jmp  0x004F4099
