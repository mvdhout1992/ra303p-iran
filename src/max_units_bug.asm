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

@HOOK 0x004BEFED _max_units_bug
;@HOOK 0x004BEE93 _FactorClass__Set_Speak_Unable_To_Build_More ; causes desyncs online, need to use EventClass:: stuff for abandon

_max_units_bug:

    JE   0x004BF21B
    CMP  DWORD [ECX+0x2A], 0
    JE   .Abandon_Production
    JMP  0x004BEFF3

.Abandon_Production:
;    mov eax, ecx
;    call 0x004BF228
    mov  eax, 17
    call 0x00426158 ; void Speak(VoxType)
    JMP  0x004BF21B

_FactorClass__Set_Speak_Unable_To_Build_More:
    mov  edi, [ecx+22h]

    CMP  edi, 0
    jnz  .Dont_Speak
    mov  eax, [0x00669958] ; PlayerPtr
    CMP  DWORD ebx, eax
    jnz  .Dont_Speak

    Save_Registers

    xor  edx, edx
    mov  ebx, [ebp-0x10]
    mov  BYTE dl, [ebx]
    call 0x004D671C  ; ProdFailType HouseClass::Abandon_Production(RTTIType)

    mov  eax, 17
    call 0x00426158 ; void Speak(VoxType)

    Restore_Registers

.Dont_Speak:
    test edi, edi
    jmp  0x004BEE98
