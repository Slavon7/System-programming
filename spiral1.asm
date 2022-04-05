option casemap:none 	; ������� ����� � ������� ���� 
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD ; �������� ���������
include \masm32\include\windows.inc ; ����� ��������, �������� .
include \masm32\macros\macros.asm
uselib user64,kernel32,fpu,gdi64
.data					
	ClassName db "Class", 0 
	AppName db "������� ��������",0
	MenuName db "FirstMenu",0
infAuthor1 db "��������� �.�., ���. ���, ���, ��� ���",0
infTitle1 db "���������� ������� ��������",0
condition db "- ���������� ������ �� 1 �� 10;",0dh,0ah,
"- ��� ������ �������� ����, ����������� ������;",13,10,"- ��� �������� �������� �����������;",10,
"- ������������� ��� �������� ������ ���������� SSE.",0
	info_caption db "�� ������",0
	usl_caption db "������� ���������� ������� ��������",0
	mas dd 07AB7h	; ���������� ������	
	two dd 2.
	alpha dd 0.0 	; ������� ���������� 
	delta dd 0.001 	; ���������� ����������
	xdiv2 dd ? 		; �������� �� X � Y
	ydiv2 dd ?
	tmp dd 0 		; ��������� ����������
	K1 dd 2.5		; ���������� ������������
	K2 dd 5.0
	divK dd 5.0
	xr dd 0. 		; ���������� �������
	yr dd 0.0
hInstance HINSTANCE ?
CommandLine LPSTR ?
IDM_INFO equ 1
IDM_USL equ 3
IDM_EXIT equ 2
IDM_M1 equ 11
IDM_M2 equ 12
IDM_V1 equ 21
IDM_V2 equ 22
IDM_V0 equ 20
IDI_ICON equ 1001
.code			
start:			
invoke GetModuleHandle,0 ; ��������� ����������� ���������
	mov    hInstance,eax ; ���������� ����������� ���������
	invoke GetCommandLine 
	mov CommandLine,eax
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
invoke ExitProcess,eax 
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,\
  CmdShow:DWORD
LOCAL wc:WNDCLASSEX ; �������������� ����� ��� ���������
LOCAL msg:MSG  	; �������������� ����� ��� ��������� MSG
LOCAL hwnd:HWND	; �������������� ����� ��� ����� ���������
mov   wc.cbSize,SIZEOF WNDCLASSEX ; ���������� ������ ���������
mov   wc.style,CS_HREDRAW or CS_VREDRAW ;����� � ��������� ����
	mov   wc.lpfnWndProc,OFFSET WndProc ; ����� ��������� WndProc
	mov   wc.cbClsExtra,NULL	; ���������� ������ ��� ��������� ������
	mov   wc.cbWndExtra,NULL	; ���������� ������ ��� ��������� ����
	push  hInst		; ���������� � ����� ����������� ���������
	pop   wc.hInstance	; ����������� ����������� � ���� ���������
	mov   wc.hbrBackground,COLOR_WINDOW+1	; ���� ����
	mov   wc.lpszMenuName,OFFSET MenuName	; ��� ������� ����
	mov   wc.lpszClassName,OFFSET ClassName	; ��� ������
	invoke LoadIcon,hInstance,IDI_ICON		; ������ ���������
	mov   wc.hIcon,eax			; ���������� �����������
	mov   wc.hIconSm,eax 	; ���������� ���������� ������
	invoke LoadCursor,NULL,IDC_ARROW    ; ������ 
	mov   wc.hCursor,eax		; ���������� �������
	invoke RegisterClassEx,addr wc	; ����������� ������ ����
	INVOKE CreateWindowEx,0,ADDR ClassName,\ ; ����� � ����� ����� ������
		ADDR AppName,WS_OVERLAPPEDWINDOW,\; ����� ����� ���� � ������� �����
		200,200,650,650,0,0,hInst,0	; ���������� � ����������� 
	mov   hwnd,eax
	INVOKE ShowWindow,hwnd,SW_SHOWNORMAL ; ��������� ����
	INVOKE UpdateWindow, hwnd
	.WHILE TRUE			; ���� �������, ��
invoke GetMessage,ADDR msg,0,0,0 ; ������ ���������
	or eax, eax		; ������������ ���������
	jz Quit			; ������� �� ����� Quit, ���� eax = 0
invoke DispatchMessage, ADDR msg ; ����������� �� ������������
	.ENDW		; ��������� ����� ��������� ���������
Quit:		
	mov   eax,msg.wParam
	ret		 ; ����������� �� ��������� WinMain
WinMain endp ; ��������� ��������� � ������ WinMain

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM,\
 lParam:LPARAM
LOCAL rect:RECT	; �������������� ����� ��� ��������� RECT
LOCAL ps:PAINTSTRUCT ; �������������� ����� ��� ��������� 
LOCAL hdc:HDC		; �������������� ����� ��� ����� ����
   .IF uMsg==WM_DESTROY ; ���� ���� ��������� �� ����������� ����
	invoke PostQuitMessage,NULL ; �������� ��������� WM_Quit
.ELSEIF uMsg==WM_COMMAND  	; ���� ���� ��������� �� ����
	mov eax,wParam  ; ������������ ��������� ��������� �� ����
	.IF ax==IDM_INFO	; ����� ���������� �� ������
invoke MessageBox,0,ADDR infAuthor1,ADDR infTitle1,MB_ICONINFORMATION
	.ELSEIF ax==IDM_USL		; ����� �������
invoke MessageBox,0,ADDR condition,ADDR usl_caption,MB_ICONINFORMATION
	.ELSEIF ax==IDM_M1 ; ����������� ������������ ��������
	mov ebx,K1		; divK=2.5
	mov divK, ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_M2
	mov ebx,K2		; divK=5.0
	mov divK, ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_V1 ; ����������� ���������� ������ 
	mov ebx,0188Bh 	; mas=1*Pi*2000
	mov mas,ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_V2
	mov ebx,03116h		; mas=2*Pi*2000
	mov mas,ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_V0
	mov ebx,0F56Fh		; mas=10*Pi*2000
	mov mas,ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSE
invoke DestroyWindow,hWnd 	; ����������� ����
	.ENDIF
.ELSEIF uMsg==WM_PAINT ; ���� ���� ��������� � �������������
 invoke BeginPaint,hWnd,addr ps ; ���������� ���������
        mov hdc, eax  ; ���������� ���������
 invoke GetClientRect,hWnd,addr rect; ��������� � ��������� rect ������������� ����
	mov alpha,0	; ������� ����������
    cvtsi2ss XMM0,rect.right ;eax
	divss XMM0,two 
	cvtss2si eax,XMM0 ;
	mov xdiv2,eax
 cvtsi2ss XMM1,rect.bottom 
 divss XMM1,two 
 cvtss2si eax,XMM1 ;
 mov ydiv2,eax
invoke MoveToEx,hdc,xdiv2,ydiv2,0; ����������� ����� ������ 
 ;��������� � �������� ����
	mov ecx,mas ; ����������� ���������� ������
	push ecx	; ���������� � ���� ���������� ������
	finit		; ������������� ������������
l1:	fld alpha ; st(0) := alpha
	fcos      ; st(0) := cos(alpha)
	fstp xr
	movss XMM2,xr    ; cos(alpha)  
	mulss XMM2,alpha ; alpha * cos(alpha)
	mulss XMM2,divK  ; divK * alpha * cos(alpha)
	cvtss2si eax,XMM2 ; �������������� � �����
	add eax,xdiv2 ; xdiv2 + divK * alpha * cos(alpha) PROOOOOOOOOOOOBLEM()()()()()()()()
	mov xr,eax
 finit		; ��������� ������������
   fld alpha ; st(0) := alpha
   fsin      ; st(0) := sin(alpha)
	fstp yr
	movss XMM3,yr    ; sin(alpha)  
	mulss XMM3,alpha ;  alpha * sin(alpha)
	mulss XMM3,divK  ; divK *alpha * sin(alpha)
	cvtss2si ebx,XMM3 ;
	add ebx,ydiv2   ; ydiv2 + divK * alpha * sin(alpha)
	mov yr,ebx
invoke LineTo,hdc,xr,yr; ��������� ������ 
	movss XMM4,delta ; ��� ���������� ������� ����������
	addss XMM4,alpha
	movss alpha,XMM4
 pop ecx	; ����������� �� ����� ���������� ������
 dec ecx	; ���������� ��������
	push ecx
	jz l2		; ����������� ���������
	jmp l1		; ����� �� �����
l2:	pop ecx
	invoke EndPaint,hWnd,addr ps ; ��������� ���������
	mov eax, 0     
	.ELSE 			; �����
invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; � ������� WndProc
	ret
	.ENDIF		; ��������� ���������� ��������� .IF - .ELSE
	xor eax,eax
	ret			; ����������� �� ���������
WndProc endp	; ��������� ��������� WndProc
end start		; ��������� ��������� � ������ start
