.text:1000FE90                 public NetworkEvent_HandleEvent_MegaMission_VesselRepair
.text:1000FE90 NetworkEvent_HandleEvent_MegaMission_VesselRepair proc near
.text:1000FE90                                         ; DATA XREF: .rdata:off_100240A8o
.text:1000FE90
.text:1000FE90 HouseClass_pointer2= dword ptr -18h
.text:1000FE90 HouseClass_pointer= dword ptr -14h
.text:1000FE90 Unit_That_Will_Repair= dword ptr -10h
.text:1000FE90 Is_Ally?        = byte ptr -9
.text:1000FE90 Unit_That_Is_Being_Repaired= dword ptr -8
.text:1000FE90 VesselRepair_ESI= dword ptr -4
.text:1000FE90 arg_0           = dword ptr  8
.text:1000FE90
.text:1000FE90                 push    ebp
.text:1000FE91                 mov     ebp, esp
.text:1000FE93                 sub     esp, 18h
.text:1000FE96                 mov     ecx, [ebp+arg_0]
.text:1000FE99                 call    Get_ESI         ; ?what@runtime_error@std@@UBEPBDXZ
.text:1000FE99                                         ; doubtful name
.text:1000FE9E                 mov     [ebp+VesselRepair_ESI], eax
.text:1000FEA1                 push    148h
.text:1000FEA6                 mov     ecx, [ebp+arg_0]
.text:1000FEA9                 call    Get_Stack_Something?
.text:1000FEAE                 mov     [ebp+Unit_That_Is_Being_Repaired], eax
.text:1000FEB1                 push    144h
.text:1000FEB6                 mov     ecx, [ebp+arg_0]
.text:1000FEB9                 call    Get_Stack_Something?
.text:1000FEBE                 mov     [ebp+Unit_That_Will_Repair], eax
.text:1000FEC1                 mov     [ebp+Is_Ally?], 0
.text:1000FEC5                 cmp     [ebp+Unit_That_Will_Repair], 0
.text:1000FEC9                 jz      short HouseClass_Pointer_Is_Zero
.text:1000FECB                 mov     ecx, [ebp+Unit_That_Will_Repair]
.text:1000FECE                 call    Get_Unit_HouseClass
.text:1000FED3                 mov     [ebp+HouseClass_pointer], eax
.text:1000FED6                 cmp     [ebp+HouseClass_pointer], 0
.text:1000FEDA                 jz      short HouseClass_Pointer_Is_Zero
.text:1000FEDC                 mov     ecx, [ebp+Unit_That_Is_Being_Repaired]
.text:1000FEDF                 call    Get_Unit_HouseClass
.text:1000FEE4                 mov     [ebp+HouseClass_pointer2], eax
.text:1000FEE7                 cmp     [ebp+HouseClass_pointer2], 0
.text:1000FEEB                 jz      short HouseClass_Pointer_Is_Zero
.text:1000FEED                 mov     edx, [ebp+HouseClass_pointer2]
.text:1000FEF0                 mov     ecx, [ebp+HouseClass_pointer]
.text:1000FEF3                 call    HouseClass__Is_Ally
.text:1000FEF8                 movzx   eax, al
.text:1000FEFB                 neg     eax
.text:1000FEFD                 sbb     eax, eax
.text:1000FEFF                 add     eax, 1
.text:1000FF02                 mov     [ebp+Is_Ally?], al
.text:1000FF05
.text:1000FF05 HouseClass_Pointer_Is_Zero:             ; CODE XREF: NetworkEvent_HandleEvent_MegaMission_VesselRepair+39j
.text:1000FF05                                         ; NetworkEvent_HandleEvent_MegaMission_VesselRepair+4Aj ...
.text:1000FF05                 mov     ecx, [ebp+VesselRepair_ESI]
.text:1000FF08                 movzx   edx, byte ptr [ecx+9]
.text:1000FF0C                 cmp     edx, 2
.text:1000FF0F                 jnz     short Execute_NULL
.text:1000FF11                 movzx   eax, [ebp+Is_Ally?]
.text:1000FF15                 test    eax, eax
.text:1000FF17                 jz      short Execute_Repairs
.text:1000FF19
.text:1000FF19 Execute_NULL:                           ; CODE XREF: NetworkEvent_HandleEvent_MegaMission_VesselRepair+7Fj
.text:1000FF19                 mov     ecx, [ebp+Unit_That_Is_Being_Repaired]
.text:1000FF1C                 mov     dl, [ecx+160h]  ; eax+160h is related to repair on the move fix
.text:1000FF22                 and     dl, 0FEh
.text:1000FF25                 mov     eax, [ebp+Unit_That_Is_Being_Repaired]
.text:1000FF28                 mov     [eax+160h], dl
.text:1000FF2E                 mov     ecx, [ebp+Unit_That_Is_Being_Repaired]
.text:1000FF31                 mov     dl, [ecx+160h]
.text:1000FF37                 and     dl, 0FDh
.text:1000FF3A                 mov     eax, [ebp+Unit_That_Is_Being_Repaired]
.text:1000FF3D                 mov     [eax+160h], dl
.text:1000FF43                 mov     eax, 4BDFEDh
.text:1000FF48                 jmp     short loc_1000FF4F
.text:1000FF4A ; ---------------------------------------------------------------------------
.text:1000FF4A
.text:1000FF4A Execute_Repairs:                        ; CODE XREF: NetworkEvent_HandleEvent_MegaMission_VesselRepair+87j
.text:1000FF4A                 mov     eax, 4BD89Bh
.text:1000FF4F
.text:1000FF4F loc_1000FF4F:                           ; CODE XREF: NetworkEvent_HandleEvent_MegaMission_VesselRepair+B8j
.text:1000FF4F                 mov     esp, ebp
.text:1000FF51                 pop     ebp
.text:1000FF52                 retn
.text:1000FF52 NetworkEvent_HandleEvent_MegaMission_VesselRepair endp