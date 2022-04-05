ml /c /coff "spiral1.asm"
rc "spiral1.rc"
link /SUBSYSTEM:windows "spiral1.obj" "spiral1.res"
pause
del "spiral1.obj" "spiral1.res"
start spiral1.exe
