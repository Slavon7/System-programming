.DATA ; ????????? ?????? ???????? ??????
x1 db 1; ?????????????? ? ?????? ?????? ????? ??? ?????????? ?
x2 dw 3 ; ?????????????? ? ?????? 2-? ?????? (?????) ??? ?2 
x3 dd 4 ; ? 4-? ?????? (32 ???????) 
x4 dq 5 ; ? ?????? ?????? (64 ????????) 
x5 db 0
y1 db -1 ; ????????????? ?????
y2 dw -2
y3 dd -3
y4 dq -5
y5 dq 5
.code ; ????????? ?????? ???????? ??????
WinMain proc
 mov al,x1; ????????? ? al ?????????? ?1
 mov bx,x2;????????? ????? (16 ????????)
 mov ecx,x3; ????????? ??. ????? (32 ???????)
 mov rdx,x4;????????? 64-????????? ??????
 mov r10b,y1; ????????? ????
 mov r11w,y2; ????????? ????? (16 ????????)
 mov r12d,y3; ????????? 32-????. ??????
 mov r13,y4 ; ????????? 64-????. ??????
 mov r14,y5 ; ????????? 64-????. ??????     
ret   ; ????? ?? ?? Windows
WinMain endp
end
