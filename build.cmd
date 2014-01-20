copy ra95.dat ra95.exe
tools\petool.exe ra95.exe edit AUTO rwxc
::tools\petool.exe ra95.exe add .patch rwxci 131072
tools\linker.exe src\main.asm src\main.inc ra95.exe tools\nasm.exe -I./include/
