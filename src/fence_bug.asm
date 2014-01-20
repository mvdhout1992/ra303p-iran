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

; This fix was originally in AlexB's Arda project, thank you for sharing

@HOOK 0x004A0219 _fence_bug

%define fence_bug_bad 0x004A0227
%define fence_bug_good 0x004A0229

_fence_bug:

    PUSH EAX
    PUSH EBX

    SUB  EAX, DWORD [0x0066826C]
    XOR  EDX,EDX
    MOV  EBX,0x3A
    IDIV EBX
    MOV  EDX,EAX

    POP  EBX
    POP  EAX

    CMP  EDX,0
    JL   fence_bug_bad
    CMP  EDX,0x4000
    JB   fence_bug_good
    JMP  fence_bug_bad
