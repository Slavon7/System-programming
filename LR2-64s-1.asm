include \masm64\include64\masm64rt.inc

.data

_a1 dq 2 ; операнд a
_b1 dq 4 ; операнд b
_c1 dq 2 ; операнд c
_d1 dq 5 ; операнд d
_e1 dq 3 ; операнд e 
_f1 dq 18 ; операнд f
_g1 dq 10 ; операнд g
x1 dq 0,1,2,4,5,8,2,7,10,2
len1 equ ($-x1)/type x1
l1 dq 2
m2 dq 10


res1 dq 0 ; осередок пам'яті для зберігання результату
title1 db "Вирішення рівняння. masm64",0
frmt db "количество элементов",0ah
st5 db "удовлетворяюших условие = %d",0ah,0ah

txt1 db "Рівняння g + fe/d/cb — a;",10,
"Результат: %d",10,"Адрес змінної в пам'яті: %ph",10,10,
"Автор: Оменюк В.І. 18лет ",0

buf1 dq 3 dup(0),0

.code

count proc arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD,
arg_e:QWORD, arg_f:QWORD,arg_g:QWORD,arg_len1:QWORD


; g + fe/d/cb — a;


mov rax,_f1
mul _e1
div _d1
xor rdx, rdx
div _c1
mul _b1
add rax, _g1
sub rax, _a1

lea rdi,x1
xor rcx,rcx 
mov rcx,len1
xor r8,r8
xor r9,r9
xor r9,r9
mov r8,l1

mov rax,[rdi]
add rdi,8
cmp rax,r8

cmp rax,r9
inc res1

mov res1,rax ; збереження

ret
count endp

entry_point proc
invoke count ,_a1,_b1,_c1,_d1,_e1,_f1,_g1,len1

invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1,ADDR frmt,ebx; функція перетворення
invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION; функція виведення смс
invoke ExitProcess,0
entry_point endp
end