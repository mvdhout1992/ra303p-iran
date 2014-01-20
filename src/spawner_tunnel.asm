;
; Copyright (c) 2012, 2013 Toni Spets <toni.spets@iki.fi>
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

%define sendto 0x005E59D0
%define recvfrom 0x005E59D6

@CALL 0x005A8B31 Tunnel_SendTo
@CALL 0x005A89AE Tunnel_RecvFrom

Tunnel_SendTo:
%push
    PUSH EBP
    MOV  EBP,ESP
    SUB  ESP,1024
    PUSH ESI
    PUSH EDI

%define var_buf     (EBP-1024)

%define addrlen     EBP+28
%define dest_addr   EBP+24
%define flags       EBP+20
%define len         EBP+16
%define buf         EBP+12
%define sockfd      EBP+8

    ; no processing if no tunnel
    CMP  DWORD [tunnel_port],0
    JE   .notunnel

    ; copy packet to our buffer
    MOV  ESI,[buf]
    LEA  EDI,[var_buf + 4]
    MOV  ECX,[len]
    CLD
    REP  MOVSB

    ; pull dest port to header
    LEA  EAX,[var_buf]

    MOV  ECX,[dest_addr]
    LEA  ECX,[ECX + sockaddr_in.sin_port]
    MOV  EDX,[ECX]
    SHL  EDX,16
    MOV  [EAX], EDX

    MOV  EDX,[tunnel_id]
    SHR  EDX,16
    OR   [EAX], EDX

    AND  EDX,0xFFFF
    OR   [EAX], EDX

    ; set dest_addr to tunnel address
    MOV  EAX,[dest_addr]
    LEA  EAX,[EAX + sockaddr_in.sin_port]
    MOV  EDX,[tunnel_port]
    SHR  EDX,16
    MOV  WORD [EAX],DX

    MOV  EAX,[dest_addr]
    LEA  EAX,[EAX + sockaddr_in.sin_addr]
    MOV  EDX,[tunnel_ip]
    MOV  DWORD [EAX],EDX

    MOV  EAX,[addrlen]
    PUSH EAX
    MOV  EAX,[dest_addr]
    PUSH EAX
    MOV  EAX,[flags]
    PUSH EAX
    MOV  EAX,[len]
    ADD  EAX,4
    PUSH EAX
    LEA  EAX,[var_buf]
    PUSH EAX
    MOV  EAX,[sockfd]
    PUSH EAX
    CALL sendto
    JMP  .exit

.notunnel:
    MOV  EAX,[addrlen]
    PUSH EAX
    MOV  EAX,[dest_addr]
    PUSH EAX
    MOV  EAX,[flags]
    PUSH EAX
    MOV  EAX,[len]
    PUSH EAX
    MOV  EAX,[buf]
    PUSH EAX
    MOV  EAX,[sockfd]
    PUSH EAX
    CALL sendto

.exit:
    POP  EDI
    POP  ESI
    MOV  ESP,EBP
    POP  EBP
    RETN 24
%pop

Tunnel_RecvFrom:
%push
    PUSH EBP
    MOV  EBP,ESP
    SUB  ESP,1024
    PUSH ESI
    PUSH EDI

%define var_buf     (EBP-1024)

%define addrlen     EBP+28
%define src_addr    EBP+24
%define flags       EBP+20
%define len         EBP+16
%define buf         EBP+12
%define sockfd      EBP+8

    ; no processing if no tunnel
    CMP  DWORD [tunnel_port],0
    JE   .notunnel

    ; call recvfrom first to get the packet
    MOV  EAX,[addrlen]
    PUSH EAX
    MOV  EAX,[src_addr]
    PUSH EAX
    MOV  EAX,[flags]
    PUSH EAX
    MOV  EAX,1024        ; len
    PUSH EAX
    LEA  EAX,[var_buf]
    PUSH EAX
    MOV  EAX,[sockfd]
    PUSH EAX
    CALL recvfrom

    ; no processing if returnng error
    CMP  EAX,-1
    JE   .exit

    ; no processing if less than 5 bytes of data
    CMP  EAX,5
    JL   .error

    ; remove header from return length
    SUB  EAX,4

    ; copy real packet after header to game buf
    LEA  ESI,[var_buf + 4]
    MOV  EDI,[buf]
    MOV  ECX,EAX
    CLD
    REP  MOVSB

    ; pull our header
    LEA  EDX,[var_buf]
    MOV  EDX,[EDX]

    ; FIXME: going to assume packets are meant for me, someone can validate the "to" part later...
    ; leaving just from here
    AND  EDX,0xFFFF

    ; set from port to header identifier
    MOV  ECX,[src_addr]
    LEA  ECX,[ECX + sockaddr_in.sin_port]
    MOV  WORD [ECX],DX

    XOR  EDX,EDX
    MOV  ECX,[src_addr]
    LEA  ECX,[ECX + sockaddr_in.sin_addr]
    MOV  DWORD [ECX],EDX

    JMP  .exit

.notunnel:
    ; call recvfrom first to get the packet
    MOV  EAX,[addrlen]
    PUSH EAX
    MOV  EAX,[src_addr]
    PUSH EAX
    MOV  EAX,[flags]
    PUSH EAX
    MOV  EAX,[len]
    PUSH EAX
    MOV  EAX,[buf]
    PUSH EAX
    MOV  EAX,[sockfd]
    PUSH EAX
    CALL recvfrom
    JMP  .exit

.error:
    MOV  EAX,-1
.exit:
    POP  EDI
    POP  ESI
    MOV  ESP,EBP
    POP  EBP
    RETN 24
%pop
