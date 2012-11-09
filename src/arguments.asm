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

; Original -LAN code was in CCHyper's 3.04, love you <3

@HOOK 0x004F5B38 _arguments

;skirmish =     MOV BYTE [0x0067F2B4], 5

arg_lan: db "-LAN",0
arg_internet: db "-INTERNET",0
arg_skirmish: db "-SKIRMISH",0

_arguments:
.lan:
    MOV EDX, arg_lan
    MOV EAX,ESI
    CALL stristr_
    TEST EAX,EAX
    JE .skirmish
    MOV BYTE [0x0067F2B4], 3
    JMP .ret
	
.skirmish:
    MOV EDX, arg_skirmish
    MOV EAX,ESI
    CALL stristr_
    TEST EAX,EAX
    JE .internet
    MOV BYTE [0x0067F2B4], 5
    JMP .ret 

.internet:
    MOV EDX, arg_internet
    MOV EAX,ESI
    CALL stristr_
    TEST EAX,EAX
    JE .ret
    MOV BYTE [0x0067F2B4], 4

.ret:
    JMP 0x004F5B54
