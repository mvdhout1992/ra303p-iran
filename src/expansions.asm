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

; rewritten to check for a file instead of a registry key

@HOOK 0x004AC024 _Is_Aftermath_Installed
@HOOK 0x004ABF88 _Is_Counterstrike_Installed

str_am_file db "SCG43EA.INI",0
str_cs_file db "SCU38EA.INI",0

_Is_Aftermath_Installed:
_Init_Game_Should_Load_AFTRMATH_INI:
    Save_Registers

    CALL GetCommandLineA
    MOV  EDX, str_spawn_arg
    CALL _stristr
    TEST EAX,EAX
    Restore_Registers
    jz   .Non_Spawner_Check

    xor  eax, eax
    mov  BYTE al, [spawner_aftermath]
    retn

.Non_Spawner_Check:
    cmp  BYTE [aftermathenabled], 1
    jz   .Ret_True

.Ret_False:
    mov  eax, 0
    retn
.Ret_True:
    mov  eax, 1
    retn

_Is_Counterstrike_Installed:
    cmp  BYTE [counterstrikeenabled], 1
    jz   .Ret_True

    mov  eax, 0
    retn
.Ret_True:
    mov  eax, 1
    retn
