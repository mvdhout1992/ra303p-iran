@HOOK 0x00589960 _Version_Name

%ifndef __GIT_REVISION__
%define __GIT_REVISION__ "????"
%endif

%ifndef __GIT_COMMIT__
%define __GIT_COMMIT__ "unknown"
%endif

str_version db "3.03p r", __GIT_REVISION__, 0x0D, "git~", __GIT_COMMIT__, 0

_Version_Name:
    mov  eax, str_version
    retn
