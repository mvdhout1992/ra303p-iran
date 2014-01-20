@HOOK 0x00425CB9 _Voc_From_Name_Add_Unhardcoded_Sound_Effects
@HOOK 0x00425D0E _Voc_Name_Add_Unhardcoded_Sound_Effects
@HOOK 0x004260AB _Sound_Effect_Call_Voc_Name

SoundEffectsList    TIMES 1024 dd    0 ; Pointer to C-strings
SoundEffectsCount    dd    0

str_SoundEffects db"SoundEffects",0

_Sound_Effect_Call_Voc_Name:
    call 0x00425CF8  ;    char * Voc_Name(VocType)
    mov  ecx, eax
    xor  edx, edx
    jmp  0x004260B4

_Voc_Name_Add_Unhardcoded_Sound_Effects:
    cmp  ax, 165
    jge  .Check_Unhardcoded_Sound_Effects

.Normal_Code:
    lea  edx, [eax*9]
    mov  eax, [0x005FE090+edx] ; ds:SoundEffectName SoundEffectName[][edx+eax*8]
    jmp  0x00425D15

.Check_Unhardcoded_Sound_Effects:
    sub  ax, 165
    cmp  WORD ax, [SoundEffectsCount]
    jge  .Return_False

    xor  edx, edx
    mov  dx, ax
    lea  edx, [SoundEffectsList+edx*4]
    mov  eax, [edx]
    jmp  0x00425D15

.Return_False:
    mov  eax, 0x005E82D4 ; "none"
    jmp  0x00425D15

_Voc_From_Name_Add_Unhardcoded_Sound_Effects:
    cmp  cx, 165
    jl   0x00425CC8

.Check_Unharded_Sound_Effects:
    mov  WORD [ebp-0x10], 0
    mov  ecx, 0

    cmp  WORD [SoundEffectsCount],0
    jz   .Ret_False

    jmp  .Loop

.Next_Loop_Iteration:

    inc  cx

.Loop:
    xor  edx, edx
    mov  dx, WORD [SoundEffectsCount]
;    sub        dx, 1
    cmp  dx, cx
    je   .Ret_False

    lea  edx, [SoundEffectsList+ecx*4]
    mov  edx, [edx]
    mov  eax, ebx
    call _strcmpi
    test eax, eax
    jnz  .Next_Loop_Iteration
    jmp  .Return_VocType

.Ret_False:
    jmp  0x00425CE7

.Return_VocType:
    xor  eax, eax
    mov  ax, cx
    add  ax, 165
    jmp  0x00425CED

Init_SoundEffect:
    ; edx should have the name of the INI section already
    mov  eax, edx
    call 0x005C3900 ; strdup()

    lea  ebx, [ebx*4]
    mov  [SoundEffectsList+ebx], eax
.Ret:
    retn

; called from src/ext/early_rules._ini_load.asm
Rules_INI_Load_Sound_Effects_List:

    Get_RULES_INI_Section_Entry_Count str_SoundEffects
    mov  WORD [SoundEffectsCount], ax

    Loop_Over_RULES_INI_Section_Entries str_SoundEffects, Init_SoundEffect
    retn
