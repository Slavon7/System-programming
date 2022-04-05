.686	; ��������� ����������� ���� ���������������
.XMM
.model flat,stdcall ; ������� �������� ������ ������ � ���������� ��
option casemap:none ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, ��������
include \masm32\macros\macros.asm
uselib user32,kernel32,fpu,gdi32
.data	
 mas dd 360 ; 
 alpha dd 0.0 ; ������� ���������� 
 delta dd 0.0175 ; ���� ������
 xdiv2 dd ?    ; �������� �� X 
 ydiv2 dd ?    ; �������� �� Y
 tmp dd 0      ; ��������� ����������
 divK dd 10.0 ; ���������� �����������
 xr dd 0. 	  ; ���������� �������
 yr dd 0
.code
_st:
 invoke GetSystemMetrics,SM_CXSCREEN ; ��������� ������ ������ � ��������
  shr eax,1 ; ������� �� 2 � ����������� �������� ������ �� �
  mov xdiv2,eax
 invoke GetSystemMetrics,SM_CYSCREEN ; ��������� ������ ������ � ��������
  shr eax,1 ; ������� �� 2 � ����������� �������� ������ �� Y
  mov ydiv2,eax
 mov ecx,mas ; ����������� ���������� ������
push ecx  	 ; ���������� � ����� ���������� ������
finit
l1:                         ; x = x0 + �fcosf
fld alpha  ; st(0) := alpha
fcos       ; st(0) := cos(alpha)
fstp xr
	movss XMM2,xr    ; cos(alpha)  
	mulss XMM2,alpha ; alpha * cos(alpha)
	mulss XMM2,divK  ; divK * alpha * cos(alpha)
	cvtss2si eax,XMM2 ; �������������� � �����
	add eax,xdiv2 ; xdiv2 + divK * alpha * cos(alpha)
	mov xr,eax
 finit		; ��������� ������������
   fld alpha ; st(0) := alpha
   fsin      ; st(0) := sin(alpha)
	fstp yr
	movss XMM3,yr    ; sin(alpha)  
	mulss XMM3,alpha ; alpha * sin(alpha)
	mulss XMM3,divK  ; divK *alpha * sin(alpha)
	cvtss2si ebx,XMM3 ;
	add ebx,ydiv2    ; ydiv2 + divK * alpha * sin(alpha)
	mov yr,ebx
invoke Sleep,1            ; ��������
invoke SetCursorPos,xr,yr ; ������������ ������� �� xr, yr 
movss XMM3,delta
addss XMM3,alpha
movss alpha,XMM3
pop ecx   ; ����������� �� ����� ���������� ������
dec ecx   ; ���������� ��������
push ecx
jz l2       ; ����������� ���������
jmp l1	; ����� �� �����
l2: pop ecx
invoke  ExitProcess,0 ; 
end _st          ;
