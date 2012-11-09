%define Mix_File_Load_Related_Function 0x005B8F30
%define Mix_File_Load_Related_Function2 0x005B93F0
%define MixFileRelated 0x00665F68

campaignmix_str db"campaign.MIX",0
aftermathmix_str db"aftermath.MIX",0
counterstrikemix_str db"counterstrike.MIX",0
smallinfantrymix_str db"smallinfantry.MIX",0
scoresretaliationmix_str db"scores-retaliation.MIX",0

; args: <mix file name string>
;%macro Load_Mix_File 1
;mov		eax, %1
;mov     edx, eax
;mov     ecx, eax
;mov     eax, 24h
;call    0x005BBF80
;test    eax, eax
;mov     ebx, MixFileRelated
;call    Mix_File_Load_Related_Function
;%endmacro

; args: <mix file name string>
%macro Load_Mix_File 1
mov     edx, %1
mov     ecx, 0x006017D0
mov     eax, 24h
call    0x005BBF80
test    eax, eax
mov     ebx, MixFileRelated
call    Mix_File_Load_Related_Function

;mov     eax, %1
;xor     edx, edx
;call    Mix_File_Load_Related_Function2
%endmacro

@HOOK 0x004F4479 _load_more_mix_files

_load_more_mix_files:

;Load_Mix_File campaignmix_str
;Load_Mix_File aftermathmix_str
;Load_Mix_File counterstrikemix_str
;Load_Mix_File smallinfantrymix_str
Load_Mix_File scoresretaliationmix_str

RETN