option casemap:none 	; ������� ����� � ������� ���� 
include \masm64\include64\masm64rt.inc ; 

.data?
hInstance dq ? ; ���������� ���������
hWnd dq ? ; ���������� ����
hIcon dq ? ; ���������� ������
hCursor dq ? ; ���������� �������
sWid dq ? ; ������ �������� (�����. �������� �� x)
sHgt dq ? ; ������ �������� (�����. �������� �� y)

.data	
mas dd 07AB7h	; ���������� ������	
	two dd 2.
	alpha dd 0.0 	; ������� ���������� 
	delta dd 0.001 	; ���������� ����������
	xdiv2 dd ? 		; �������� �� X � Y
	ydiv2 dd ?
	temp1 dd 0 		; ��������� ����������
	K1 dd 2.5		; ���������� ������������
	K2 dd 5.0
	divK dd 5.0
	xr dd 0. 		; ���������� �������
	yr dd 0.0
 
 titl1 db " ����������� ������ ��������������� �������",0
 classname db "template_class",0
 
.code
entry_point proc
mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ���������
mov hIcon, rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
call main
invoke ExitProcess,0
entry_point endp

main proc
LOCAL wc :WNDCLASSEX ; ���������� ��������� ����������
LOCAL lft :QWORD ; ���. ���������� ���������� � �����
LOCAL top :QWORD ; � ���������� ������ �� ����� ���. ����.
LOCAL wid :QWORD
LOCAL hgt :QWORD
; �������� ������ ����
mov wc.cbSize,SIZEOF WNDCLASSEX ; �����. ������ ���������
mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ;����� ����
mov wc.lpfnWndProc,ptr$(WndProc) ; ����� ��������� WndProc
mov wc.cbClsExtra,0 ; ���������� ������ ��� ��������� ������
mov wc.cbWndExtra,0 ; ���������� ������ ��� ��������� ����
mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
mrm wc.hIcon, hIcon ; ����� ������
mrm wc.hCursor,hCursor ; ����� �������
mrm wc.hbrBackground,0 ; ���� ����
mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
mov wc.lpszClassName,ptr$(classname) ; ��� ������
mrm wc.hIconSm,hIcon
; ����������� ������
invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
mov wid, 520 ; ������ ����������������� ���� � ��������
mov hgt, 400 ; ������ ����������������� ���� � ��������
mov rax,sWid ; �����. �������� �������� �� x
sub rax,wid ; ������ � = �(��������) - �(���� ������������)
shr rax,1 ; ��������� �������� �
mov lft,rax ;
mov rax, sHgt ; �����. �������� �������� �� y
sub rax, hgt ;
shr rax, 1 ;
mov top, rax ;
; C������� ����
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
ADDR classname,ADDR titl1,WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
lft,top,wid,hgt,0,0,hInstance,0
mov hWnd,rax ; ���������� ����������� ����
call msgloop
ret
main endp

msgloop proc ; ���� ��������� (������� ���������)
LOCAL msg :MSG
LOCAL pmsg :QWORD
mov pmsg,ptr$(msg) ; ��������� ������ ��������� ���������
jmp gmsg ; jump directly to GetMessage()
mloop:
invoke TranslateMessage,pmsg
invoke DispatchMessage,pmsg ; �������� �� ������������ � WndProc
gmsg:
test rax, rv(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
jnz mloop
ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
LOCAL hdc:HDC               ; �������������� ����� ��� ����������� ����
LOCAL ps:PAINTSTRUCT        ; ��� ��������� PAINTSTRUCT
LOCAL rect:RECT             ; ��� ��������� ��������� RECT
.switch uMsg
.case WM_DESTROY            ; ���� ���� ��������� ��� ����������� ����
invoke PostQuitMessage,NULL
.case WM_PAINT              ; ���� ���� ��� � �������������
invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
mov hdc,rax                 ; ���������� ���������
invoke GetClientRect,hWnd,ADDR rect ; ��������� � ��������� rect ������������� ����
invoke TextOut,hdc,100,240,chr$("����� ���������:  �������� ������ "),35
invoke MoveToEx,hdc,xdiv2,ydiv2,0; ����������� ����� ������
mov r10d,mas ; ���������� ���������� ������
mov temp1,r10d
mov ecx,mas

finit    ; �������
l1:	
fld alpha
fcos
fstp xr
movss XMM2,xr
mulss XMM2,alpha
mulss XMM2,divK
cvtss2si eax,XMM2
fadd
mov xr,eax

finit

fld alpha
fsin
fstp yr
movss XMM3,yr
mulss XMM3,alpha
mulss XMM3,divK
cvtss2si ebx,XMM3
fadd
mov yr,ebx

invoke LineTo,hdc,xr,yr; ��������� ������ 
movss XMM4,delta ; ��� ���������� ������� ����������
addss XMM4,alpha
movss alpha,XMM4

invoke SetPixel,hdc, xr, yr, 40001
;invoke SetCursorPos,xr,yr ; ������ �� �������
movss XMM4,delta
addss XMM4,alpha
movss alpha,XMM4
dec temp1   ; ���������� ��������
jz l2       ; ����������� ���������
jmp l1	; ����� �� �����
l2: 

invoke EndPaint,hWnd, ADDR ps ; ���������� ���������
.endsw
invoke DefWindowProc,hWin,uMsg,wParam,lParam
ret
WndProc endp
end
