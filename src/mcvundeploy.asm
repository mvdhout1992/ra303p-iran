@HOOK 0x0045A71A BuildingClass__What_Action_MCV_Undeploy
@HOOK 0x0045C1CE BuildingClass__Mission_Deconstruction_MCV_Undeploy

BuildingClass__What_Action_MCV_Undeploy:
    cmp  BYTE [mcvundeploy], 1
    jz   0x0045A725

    test BYTE [0x00666831], 80h
    jnz  0x0045A725

    jmp  0x0045A723

BuildingClass__Mission_Deconstruction_MCV_Undeploy:
    cmp  BYTE [mcvundeploy], 1
    jz   .Ret

    test BYTE [0x00666831], 80h
    jz   0x0045C204

.Ret:
    mov  ebx, [edx]
    jmp  0x0045C1D9
