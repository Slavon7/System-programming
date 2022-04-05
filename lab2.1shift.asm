include \masm64\include64\masm64rt.inc
.data;
g1 dq 64;
f1 dq 32;
d1 dq 16;
c1 dq 8;
b1 dq 4;
a1 dq 2;
result1 dq ?;
result2 dq ?;
result3 dq ?;
result4 dq ?;
result5 dq ?;
titl db "Лабораторна робота №2.1 (Операції сдвигу), Середенко Олег КІТ-120В",0;
st1 dq 1 dup(0),0;
ifmt db "Виконати g + f/d + cb - a за допомогою арифметичних операцій та ", 
"за допомогою команд сдвигу та вивести кількість тактів. a, b, c, d, f, g — ступінь двійки.",0ah, 0ah,
"Мої вхідні дані: ",0ah,
"g = 64",0ah, "f = 32",0ah, "d = 16" ,0ah, "c = 8",0ah, "b = 4",0ah, 
"a = 2",0ah,0ah, "64 + 32 / 16 + 8 * 4 - 2 = " ,0ah, 0ah,
"Резульат другий (операції сдвигу): %d",0ah, "Кількість тактів: %i", 0ah;

.code;
entry_point proc;

rdtsc; 
xchg rdi, rax;

mov rax, f1;
sar rax, 4
mov result1, rax;
add rax, g1;
mov result2, rax;

mov rax, c1;
sal rax, 2;
mov result3, rax;
sub rax, a1;
mov result3, rax;
add rax, result2;
mov result4, rax;

rdtsc;
sub rax, rdi;
mov result5, rax;

invoke wsprintf, ADDR st1, ADDR ifmt, result4, rax;
invoke MessageBox,0,addr st1,addr titl, MB_ICONINFORMATION;
invoke ExitProcess,0;

entry_point endp;
end;