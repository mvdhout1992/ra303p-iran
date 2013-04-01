@HOOK 0x004F7E13 _load_more_mix_files
@HOOK 0x004F7F26 _Conditionally_Load_Small_Infantry_MIX

%define MixFileClass_CCFileClass_Retrieve 0x005B8F30
%define MixFileClass_CCFileClass_Cache 0x005B93F0
%define PKey__FastKey 0x00665F68

campaignmix_str db"campaign.MIX",0
aftermathmix_str db"aftermath.MIX",0
counterstrikemix_str db"counterstrike.MIX",0
smallinfantrymix_str db"smallinfantry.MIX",0
betateslatankmix_str db"betateslatank.MIX",0
betadestroyermix_str db"betadestroyer.MIX",0
betagunboatmix_str db"betagunboat.MIX",0
betasubmarinemix_str db"betasubmarine.MIX",0
betacruisermix_str db"betacruiser.MIX",0
oosfixmix_str db"oos-fix.MIX",0
moviestlf_str db"movies-tlf.MIX",0

germanlanguagepack_str db"germanlanguagepack.MIX",0
germancensoredlanguagepack_str db"germancensoredlanguagepack.MIX",0
germanuncensoredlanguagepack_str db"germanuncensoredlanguagepack.MIX",0
frenchlanguagepack_str db"frenchlanguagepack.MIX",0
spanishlanguagepack_str db"spanishlanguagepack.MIX",0
russianlanguagepack_str db"russianlanguagepack.MIX",0

expand3_str db"expand3.MIX",0
expand4_str db"expand4.MIX",0
expand5_str db"expand5.MIX",0
expand6_str db"expand6.MIX",0
expand7_str db"expand7.MIX",0
expand8_str db"expand8.MIX",0
expand9_str db"expand9.MIX",0
movies_1_str db "movies-1.MIX",0
movies_2_str db "movies-2.MIX",0
movies_3_str db "movies-3.MIX",0
movies_4_str db "movies-4.MIX",0
movies_5_str db "movies-5.MIX",0
movies_6_str db "movies-6.MIX",0
movies_7_str db "movies-7.MIX",0
movies_8_str db "movies-8.MIX",0
movies_9_str db "movies-9.MIX",0
movies_10_str db "movies-10.MIX",0

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

; Loads without caching in memory
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


; args: <mix file name string>
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

_Conditionally_Load_Small_Infantry_MIX:
	Save_Registers
		
	call    MixFileClass_CCFileClass_Retrieve
    
    cmp	BYTE [usebetacruiser], 0
	jz	.Load_Beta_Gunboat
    
    Load_Mix_File_Cached	betacruisermix_str
   
.Load_Beta_Gunboat:
   
    cmp	BYTE [usebetagunboat], 0
	jz	.Load_Beta_Submarine
    
    Load_Mix_File_Cached	betagunboatmix_str
    
.Load_Beta_Submarine:  
    
    cmp	BYTE [usebetasubmarine], 0
	jz	.Load_Destroyer_Mix
    
    Load_Mix_File_Cached	betasubmarinemix_str
    
.Load_Destroyer_Mix:

    cmp	BYTE [usebetadestroyer], 0
	jz	.Load_Beta_Tesla_Tank_Mix
    
    Load_Mix_File_Cached	betadestroyermix_str

.Load_Beta_Tesla_Tank_Mix:
	
	cmp	BYTE [usebetateslatank], 0
	jz	.Load_Smallinfantry_MIX
	
	Load_Mix_File_Cached	betateslatankmix_str
	
.Load_Smallinfantry_MIX:
	cmp	BYTE [usesmallinfantry], 0
	jz	.Ret
	
	Load_Mix_File_Cached	smallinfantrymix_str

.Ret:
	Restore_Registers
	jmp		0x004F7F2B 

_load_more_mix_files:
	; The load order is important, files loaded first can't have their file content overwritten by files loaded later
		
	; LANGUAGE PACKS STUFF
	Load_INIClass str_redalertini5, FileClass_redalertini5, INIClass_redalertini5
	
	INI_Get_Int_ INIClass_redalertini5, str_options5, str_gamelanguage, 1
	mov		[gamelanguage], eax
	
	CMP DWORD [gamelanguage], 1
	jz	.Jump_Over
	
	CMP DWORD [gamelanguage], 2
	JNZ	.No_German
	Load_Mix_File_Cached	germanlanguagepack_str

.No_German:
	CMP DWORD [gamelanguage], 3
	JNZ	.No_German_Censored
	Load_Mix_File_Cached 	germancensoredlanguagepack_str

.No_German_Censored
	CMP DWORD [gamelanguage], 4
	JNZ	.No_German_Uncensored
	Load_Mix_File_Cached 	germanuncensoredlanguagepack_str
.No_German_Uncensored:
	CMP DWORD [gamelanguage], 5
	JNZ	.No_French
	Load_Mix_File_Cached 	frenchlanguagepack_str

.No_French:
	CMP DWORD [gamelanguage], 6
	JNZ	.No_Spanish
	Load_Mix_File_Cached 	spanishlanguagepack_str
.No_Spanish:
	CMP DWORD [gamelanguage], 7
	JNZ	.No_Russian
	Load_Mix_File_Cached 	russianlanguagepack_str
.No_Russian:
	
.Jump_Over:
	
	; SMALL INFANTRY
;	Load_Mix_File_Cached	smallinfantrymix_str
	
	; OTHER
	Load_Mix_File_Cached 	campaignmix_str
	Load_Mix_File_Cached 	aftermathmix_str
	Load_Mix_File_Cached 	counterstrikemix_str
	Load_Mix_File		 	moviestlf_str
	Load_Mix_File_Cached 	oosfixmix_str
	
	; EXTRA MOVIES-xx.MIX
	Load_Mix_File 	movies_10_str
	Load_Mix_File 	movies_9_str
	Load_Mix_File 	movies_8_str
	Load_Mix_File 	movies_7_str
	Load_Mix_File 	movies_6_str
	Load_Mix_File 	movies_5_str
	Load_Mix_File 	movies_4_str
	Load_Mix_File 	movies_3_str
	Load_Mix_File 	movies_2_str
	Load_Mix_File 	movies_1_str
	
	; EXTRA EXPANDxx.MIX
	Load_Mix_File_Cached 	expand9_str 
	Load_Mix_File_Cached	expand8_str
	Load_Mix_File_Cached 	expand7_str
	Load_Mix_File_Cached 	expand6_str
	Load_Mix_File_Cached 	expand5_str
	Load_Mix_File_Cached 	expand4_str
	Load_Mix_File_Cached 	expand3_str
	
	mov     edx, 0FFFFFFFEh
	mov     ecx, [0x006017D0]
	mov     [0x006017D0], edx
	mov     edx, 0x005EBE41
	lea     eax, [ebp-0CCh]
	jmp		0x004F7E18