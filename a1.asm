include \masm64\include64\masm64rt.inc

.data

a1 dq 2 ; ������� a
b1 dq 4 ; ������� b
c1 dq 2 ; ������� c
d1 dq 5 ; ������� d
e1 dq 2 ; ������� e - 2 - ����� �������
f1 dq 18 ; ������� f - 18 - ����� �������

res1 dq 0 ; �������� ���'�� ��� ��������� ����������
title1 db "�������� �������. masm64",0
txt1 db "г������ eab � fc/d",10,
"���������: %d",10,"����� ����� � ���'��: %ph",10,10,
"�����: ������ �.�. 18��� ",0
buf1 dq 3 dup(0),0

.code
entry_point proc

mov rax, f1 ; ����������� f1 � rax
mul c1 ; �������� rax �� c1
div d1 ; f1*c1/d1
mov rsi, rax ; ���������� rax � rsi
mov rax, e1 ; ����������� e1 � rax
mul a1 ; �������� rax �� a1
mul b1 ; e1*a1*b1
sub rax, rsi ; e1*a1*b1 - f1*c1/d1

mov res1,rax ; ����������

invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1; ������� ������������
invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION; ������� ��������� ���
invoke ExitProcess,0
entry_point endp
end
