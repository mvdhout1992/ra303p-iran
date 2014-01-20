@HOOK 0x004A5753 _Keyboard_Process_Home_Key_Overwrite
@HOOK 0x0054D916 _Patch_Out_Erroneous_Sidebar_Activate_CALL
@HOOK 0x004C9F46 _RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check
@HOOK 0x004CAA29 _RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check2
@HOOK 0x004A6206 _UnhardCode_Keyboard_Key0
@HOOK 0x004A61D3 _UnhardCode_Keyboard_Key9
@HOOK 0x004A61A0 _UnhardCode_Keyboard_Key8
@HOOK 0x004A616D _UnhardCode_Keyboard_Key7
@HOOK 0x004A613A _UnhardCode_Keyboard_Key6
@HOOK 0x004A6107 _UnhardCode_Keyboard_Key5
@HOOK 0x004A60D4 _UnhardCode_Keyboard_Key4
@HOOK 0x004A60A1 _UnhardCode_Keyboard_Key3
@HOOK 0x004A606E _UnhardCode_Keyboard_Key2
@HOOK 0x004A603E _UnhardCode_Keyboard_Key1

%define SessionClass__Session 0x0067F2B4
%define KeyResign    0x006681C0

ResignKeyPressed: dd 0

_UnhardCode_Keyboard_Key1:
    jmp  0x004A6056

_UnhardCode_Keyboard_Key2:
    jmp  0x004A6089

_UnhardCode_Keyboard_Key3:
    jmp  0x004A60BC

_UnhardCode_Keyboard_Key4:
    jmp  0x004A60EF

_UnhardCode_Keyboard_Key5:
    jmp  0x004A6122

_UnhardCode_Keyboard_Key6:
    jmp  0x004A6155

_UnhardCode_Keyboard_Key7:
    jmp  0x004A6188

_UnhardCode_Keyboard_Key8:
    jmp  0x004A61BB

_UnhardCode_Keyboard_Key9:
    jmp  0x004A61EE

_UnhardCode_Keyboard_Key0:
    jmp  0x004A6221

_Keyboard_Process_Home_Key_Overwrite:
    cmp  WORD ax, [keysidebartoggle]
    jz   .Toggle_Sidebar
    cmp  WORD ax, [keymapsnapshot]
    jz   .Map_Snapshot

    cmp  WORD ax, [KeyResign]
    jz   .Resign_Key

.Out:
    cmp  ax, [0x006681B4] ; KeyNext
    jnz  0x004A57DF
    jmp  0x004A5760

.Toggle_Sidebar:
    push eax

.Lock_Graphics_Buffer:
;    mov eax, 0 ; Crash
    mov  eax, MouseClass_Map
    mov  edx, 0FFFFFFFFh
    call 0x0054DA70 ;  SidebarClass::Activate(int)

    mov  eax, [0x006807E8] ; ds:GraphicBufferClass__Something
    call 0x005C101A ; GraphicBufferClass::Lock(void)
    test eax, eax
    jz   .Clear_Buffer
    mov  edx, [0x006807E8] ;  ds:GraphicBufferClass__Something
    cmp  edx, 0x006807CC ; offset GraphicViewPortClass HidPage
    jz   .EAX_One
    mov  ebx, [0x006807D4]
    push ebx             ; __int32
    mov  ecx, [0x006807D0]
    mov  eax, 0x006807CC ; offset GraphicViewPortClass HidPage
    push ecx             ; __int32
    mov  ebx, [0x006807DC]
    mov  ecx, [0x006807E0]
    call 0x005C094F ; GraphicViewPortClass::Attach(GraphicBufferClass *,int,int,int,int)

.EAX_One:
    mov  eax, 1

.Clear_Buffer:
    push 0
    push 0x006807CC; offset GraphicViewPortClass HidPage
    call 0x005C4DE0 ; _Buffer_Clear
    add  esp, 8

.Unlock_Graphics_Buffer:
    mov  eax, [0x006807E8] ; ds:GraphicBufferClass__Something
    call 0x005C1191 ; GraphicBufferClass::Unlock(void)
    test eax, eax
    jz   .Redraw_Screen
    mov  eax, [0x006807E8] ; ds:GraphicBufferClass__Something
    cmp  eax, 0x006807CC ; offset GraphicViewPortClass HidPage
    jz   .Redraw_Screen
    cmp  DWORD [0x006807EC], 0
    jz   .Redraw_Screen
    mov  ebx, [eax+24h]
    test ebx, ebx
    jnz  .Redraw_Screen
    mov  [0x006807CC], ebx

.Redraw_Screen:
    mov  edx, 1
    mov  eax, 0x00668250 ; MouseClass Map
    call 0x004CAFF4 ; GScreenClass::Flag_To_Redraw(int)

    mov  eax, 0x00668250 ; MouseClass Map
    call 0x004CB110 ; GScreenClass::Render()

    pop  eax
    jmp  .Out

.Resign_Key:
    push eax

    cmp  BYTE [SessionClass__Session],0
    jz   .Out
    mov  DWORD [ResignKeyPressed], 1
    call 0x00528DCC ; Queue_Options(void)

    pop  eax
    jmp  .Out

.Map_Snapshot:
    call Create_Map_Snapshot
    jmp  .Out

_Patch_Out_Erroneous_Sidebar_Activate_CALL:
    jmp  0x0054D91B

_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check:
    cmp  DWORD [ResignKeyPressed], 0
    jnz  0x004CA9C9

.Out:
    test eax, eax
    jle  0x004CA15E
    jmp  0x004C9F4E

_RedrawOptionsMenu_Add_Surrender_Dialog_Flag_Check2:
    cmp  DWORD [ResignKeyPressed], 0
    jz   0x004CA7A5

    mov  DWORD [ResignKeyPressed], 0
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    retn
