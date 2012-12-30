;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

%define LoadLibraryA        0x005E5892
%define FreeLibrary         0x005E65C0
%define GetProcAddress      0x005E588C
%define GetCurrentProcess   0x005E65D0
%define GetCurrentProcessId 0x005E58BC
%define GetCurrentThreadId  0x005E587A
%define CreateFile          0x005E658C
%define WinMain             0x00551A70
%define MessageBoxA         0x005E6864
%define _exit               0x005DE63D

%define GENERIC_WRITE           0x40000000 
%define CREATE_ALWAYS           2
%define FILE_ATTRIBUTE_NORMAL   128

str_exception_title         db "C&C Red Alert just crashed!",0
str_exception_message       db "A crash dump file with the name 'ra95.mdmp' has been saved. Give it to Iran for debugging, thanks.",0
str_dbghelp_dll             db "dbghelp.dll",0
str_MiniDumpWriteDump       db "MiniDumpWriteDump",0
str_dump_name               db "ra95.mdmp",0

dbghelp_dll                 dd 0
hFile                       dd 0
hProcess                    dd 0
ProcessId                   dd 0
ThreadId                    dd 0
MiniDumpWriteDump           dd 0

struc MINIDUMP_EXCEPTION_INFORMATION
    .ThreadId           RESD 1
    .ExceptionPointers  RESD 1
    .ClientPointers     RESD 1
endstruc

struc EXCEPTION_POINTERS
    .ExceptionRecord    RESD 1
    .ContextRecord      RESD 1
endstruc

exception_info:
    istruc MINIDUMP_EXCEPTION_INFORMATION
        at MINIDUMP_EXCEPTION_INFORMATION.ThreadId,           dd 0
        at MINIDUMP_EXCEPTION_INFORMATION.ExceptionPointers,  dd 0
        at MINIDUMP_EXCEPTION_INFORMATION.ClientPointers,     dd 1
    iend

exception_pointers:
    istruc EXCEPTION_POINTERS
        at EXCEPTION_POINTERS.ExceptionRecord,  dd 0
        at EXCEPTION_POINTERS.ContextRecord,    dd 0
    iend

@HOOK 0x005DE636 _try_WinMain

_try_WinMain:

 ;   INT3
    ; load minidump stuff
    PUSHAD

    PUSH str_dbghelp_dll
    CALL LoadLibraryA

    TEST EAX,EAX
    JZ .nodebug

    MOV [dbghelp_dll], EAX

    PUSH str_MiniDumpWriteDump
    PUSH EAX
    CALL GetProcAddress

    TEST EAX,EAX
    JZ .nodebug

    MOV [MiniDumpWriteDump], EAX

    CALL [GetCurrentProcess]
    MOV [hProcess], EAX

    CALL GetCurrentProcessId
    MOV [ProcessId], EAX

    POPAD

    ; install exception handler
    PUSHAD
    MOV ESI, _exception_handler
    PUSH ESI
    PUSH DWORD [FS:0]
    MOV [FS:0], ESP

    ; continue normal program execution
    PUSH EAX
    CALL WinMain

    ; clean up our exception handler
    POP DWORD [FS:0]
    ADD ESP, 32 + 4

    ; free minidump library if loaded
    CMP DWORD [dbghelp_dll], 0
    JE .nodebugdll

    PUSH DWORD [dbghelp_dll]
    CALL [FreeLibrary]

.nodebugdll:
    JMP _exit

.nodebug:
    CALL WinMain
    JMP _exit

_exception_handler:

    MOV EBX, [ESP + 0x4]
    MOV ESI, [ESP + 0xC]
    MOV [exception_pointers + EXCEPTION_POINTERS.ExceptionRecord], EBX
    MOV [exception_pointers + EXCEPTION_POINTERS.ContextRecord], ESI

    MOV DWORD [exception_info + MINIDUMP_EXCEPTION_INFORMATION.ExceptionPointers], exception_pointers

    CALL GetCurrentThreadId
    MOV [exception_info + MINIDUMP_EXCEPTION_INFORMATION.ThreadId], EAX

    PUSH 0
    PUSH FILE_ATTRIBUTE_NORMAL
    PUSH CREATE_ALWAYS
    PUSH 0
    PUSH 0
    PUSH GENERIC_WRITE
    PUSH str_dump_name
    CALL [CreateFile]

    PUSH 0                  ; CallbackParam
    PUSH 0                  ; UserStreamParam
    PUSH exception_info     ; ExceptionParam
    PUSH 0                  ; DumpType
    PUSH EAX                ; hFile
    PUSH DWORD [ProcessId]
    PUSH DWORD [hProcess]
    CALL [MiniDumpWriteDump]

    PUSH 0
    PUSH str_exception_title
    PUSH str_exception_message
    PUSH 0
    CALL [MessageBoxA]

    MOV ESP,[ESP + 8]
    POP DWORD [FS:0]
    ADD ESP, 4

    ; I shouldn't probably do this, but what the hell
    JMP _exit
