@HOOK 0x005B38DD _Mouse_Wheel_Sidebar_Scrolling
;@HOOK 0x0054E3BB _SidebarClass_StripClass__AI_Scroll_Check

Scrolling db 0
ProcessingSidebar dd 0

%define HouseClass_PlayerPtr    0x00669958


_Mouse_Wheel_Sidebar_Scrolling:
    cmp  BYTE [mousewheelscrolling], 1
    jnz  .out
    mov  esi, [ebp+0Ch]
    cmp  esi, 20Ah               ;WM_MOUSEHWHEEL
    jnz  .out

    mov  ecx, [HouseClass_PlayerPtr]
    test ecx, ecx
    jz   .out

    mov  cl, byte [Scrolling]
    test cl, cl
    jnz  .out


;    mov        ebx, 2
;    mov        eax, [0x00665EB0]
;    call    0x005BBF30 ;   WinTimerClass::Get_System_Tick_Count(void)
;    cdq
;    idiv    ebx
;    cmp        DWORD edx, 0
;    jnz        .out

    mov  byte [Scrolling], 1
    mov  edx, [ebp+10h]
    shr  edx, 10h
    test dx, dx
    jl   .scroll

    mov  ebx, 0FFFFFFFFh
    mov  edx, 1
    mov  eax, MouseClass_Map
    call 0x0054D684      ;//SidebarClass::Scroll

    jmp  .done

;-----------------------------------------------
.scroll:
    mov  ebx, 0FFFFFFFFh
    xor  edx, edx
    mov  eax, MouseClass_Map
    call 0x0054D684      ;//SidebarClass::Scroll

.done:
    mov  byte [Scrolling], 0

.out:
    cmp  esi, 1Ch
    jb   0x5B38EE

    jmp  0x5B38E2
