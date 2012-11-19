%define Mix_File_Load_Related_Function 0x005B8F30
%define Mix_File_Load_Related_Function2 0x005B93F0
%define MixFileRelated 0x00665F68

campaignmix_str db"campaign.MIX",0
aftermathmix_str db"aftermath.MIX",0
counterstrikemix_str db"counterstrike.MIX",0
smallinfantrymix_str db"smallinfantry.MIX",0
scoresretaliationmix_str db"scores-retaliation.MIX",0
moviestlf_str db"movies-tlf.MIX",0
expand3_str db"expand3.MIX",0
expand4_str db"expand4.MIX",0
expand5_str db"expand5.MIX",0
expand6_str db"expand6.MIX",0
expand7_str db"expand7.MIX",0
expand8_str db"expand8.MIX",0
expand9_str db"expand9.MIX",0


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

Load_Mix_File campaignmix_str
Load_Mix_File aftermathmix_str
Load_Mix_File counterstrikemix_str
Load_Mix_File smallinfantrymix_str
Load_Mix_File scoresretaliationmix_str 
Load_Mix_File moviestlf_str

Load_Mix_File expand3_str
Load_Mix_File expand4_str
Load_Mix_File expand5_str
Load_Mix_File expand6_str
Load_Mix_File expand7_str
Load_Mix_File expand8_str
Load_Mix_File expand9_str
RETN