%define MixFileClass_CCFileClass_Retrieve 0x005B8F30
%define MixFileClass_CCFileClass_Cache 0x005B93F0
%define PKey__FastKey 0x00665F68

campaignmix_str db"campaign.MIX",0
aftermathmix_str db"aftermath.MIX",0
counterstrikemix_str db"counterstrike.MIX",0
smallinfantrymix_str db"smallinfantry.MIX",0
oosfixmix_str db"oos-fix.MIX",0
germanlanguagepack_str db"germanlanguagepack.MIX",0
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
mov     ebx, PKey__FastKey
call    MixFileClass_CCFileClass_Retrieve
%endmacro

%macro Load_Mix_File_Cached 1
mov     edx, %1
mov     ecx, 0x006017D0
mov     eax, 24h
call    0x005BBF80
test    eax, eax
mov     ebx, PKey__FastKey
call    MixFileClass_CCFileClass_Retrieve
mov     eax, %1
xor     edx, edx
call    MixFileClass_CCFileClass_Cache
%endmacro

@HOOK 0x004F7E13 _load_more_mix_files

_load_more_mix_files:
	; The load order is important, files loaded first can't have their file content overwritten by files loaded later
	
	; TRANSLATION STUFF
	Load_Mix_File_Cached 	germanlanguagepack_str
	
	; SMALL INFANTRY
	Load_Mix_File_Cached	smallinfantrymix_str
	
	; OTHER
	Load_Mix_File_Cached 	campaignmix_str
	Load_Mix_File_Cached 	aftermathmix_str
	Load_Mix_File_Cached 	counterstrikemix_str
	Load_Mix_File_Cached 	moviestlf_str
	Load_Mix_File_Cached 	oosfixmix_str

	Load_Mix_File_Cached 	expand3_str
	Load_Mix_File_Cached 	expand4_str
	Load_Mix_File_Cached 	expand5_str
	Load_Mix_File_Cached 	expand6_str
	Load_Mix_File_Cached 	expand7_str
	Load_Mix_File_Cached	expand8_str
	Load_Mix_File_Cached 	expand9_str 

	mov     edx, 0FFFFFFFEh
	mov     ecx, [0x006017D0]
	mov     [0x006017D0], edx
	mov     edx, 0x005EBE41
	lea     eax, [ebp-0CCh]
	jmp		0x004F7E18