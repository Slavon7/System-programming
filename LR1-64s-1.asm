include \masm64\include64\masm64rt.inc

.data

a1 dq 2 ; операнд a
b1 dq 4 ; операнд b
c1 dq 2 ; операнд c
d1 dq 5 ; операнд d
e1 dq 2 ; операнд e - 2 - згідно варіанту
f1 dq 18 ; операнд f - 18 - згідно варіанту

res1 dq 0 ; осередок пам'яті для зберігання результату
title1 db "Вирішення рівняння. masm64",0
txt1 db "Рівняння eab – fc/d",10,
"Результат: %d",10,"Адрес змінної в пам'яті: %ph",10,10,
"Автор: Оменюк В.І. 18лет ",0
buf1 dq 3 dup(0),0

.code
entry_point proc

mov rax, f1 ; пересилання f1 у rax
mul c1 ; множення rax на c1
div d1 ; f1*c1/d1
mov rsi, rax ; збереження rax у rsi
mov rax, e1 ; пересилання e1 у rax
mul a1 ; множення rax на a1
mul b1 ; e1*a1*b1
sub rax, rsi ; e1*a1*b1 - f1*c1/d1

mov res1,rax ; збереження

invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1; функція перетворення
invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION; функція виведення смс
invoke ExitProcess,0
entry_point endp
end
