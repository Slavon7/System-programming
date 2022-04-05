include \masm64\include64\masm64rt.inc

Computer STRUCT
    serialNum1 dq ?
    price1 dq ?    
    name1 dd ?
    ownerSurname1 dd ?
    size1 dq ?    
Computer ENDS

.data
hInstance dq ?  ; ���������� ��������
hWnd      dq ?  ; ���������� ����
hIcon     dq ?  ; ���������� ������
hCursor   dq ?  ; ���������� �������
sWid      dq ?  ; ������ �������� (�����. �������� �� x)
sHgt      dq ?  ; ������ �������� (�����. �������� �� y) 
classname db "template_class",0
caption db "������������ ������ 4-1-2. ���������",0

.code
entry_point proc
    mov hInstance,rv(GetModuleHandle,0)         ; ��������� � ���������� ����������a ��������
    mov hIcon,  rv(LoadIcon,hInstance,10)       ; �������� � ���������� ����������a ������
    mov hCursor,rv(LoadCursor,0,IDC_ARROW)      ; �������� ������� � ����������
    mov sWid,rv(GetSystemMetrics,SM_CXSCREEN)   ; ��������� ���. �������� �� � �������� 
    mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN)   ; ��������� ���. �������� �� y ��������
    call main                                   ; ����� ��������� main
    invoke ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX               ; ���������� ��������� ����������
    LOCAL lft :QWORD                    ;  ���. ���������� ���������� � ����� 
    LOCAL top :QWORD                    ; � ���������� ������ �� ����� ���. ����.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX     ; �����. ������ ���������
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; ����� ����
    mov wc.lpfnWndProc,ptr$(WndProc)    ; ����� ��������� WndProc
    mov wc.cbClsExtra,0                 ; ���������� ������ ��� ��������� ������
    mov wc.cbWndExtra,0                 ; ���������� ������ ��� ��������� ����
    mrm wc.hInstance,hInstance          ; ���������� ���� ����������� � ���������
    mrm wc.hIcon,  hIcon                ; ����� ������
    mrm wc.hCursor,hCursor              ; ����� �������
    mrm wc.hbrBackground,0              ; ���� ����
    mov wc.lpszMenuName,0               ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname); ��� ������
    mrm wc.hIconSm,hIcon
    invoke RegisterClassEx,ADDR wc      ; ����������� ������ ����
    mov wid, 900                        ; ������ ����������������� ���� � ��������
    mov hgt, 300                        ; ������ ����������������� ���� � ��������
    mov rax,sWid                        ; �����. �������� �������� �� x
    sub rax,wid                         ; ������ � = �(��������) - �(���� ������������)
    shr rax,1                           ; ��������� �������� �
    mov lft,rax                         ;

    mov rax, sHgt       ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
    ADDR classname,ADDR caption, \
    WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
    lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax        ; ���������� ����������� ����
    call msgloop
    ret
main endp

msgloop proc
    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD
    mov pmsg, ptr$(msg) ; ��������� ������ ��������� ���������
    jmp gmsg            ; jump directly to GetMessage()
    mloop:
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg
    
    gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
    jnz mloop
    ret
msgloop endp

.data		; ������ ����������
    task db "������ ������������������ ��������. ��������� �������� ���� ������ � ����������: �������� �����, ����, ��������,",0
    task1 db "������� ���������, ������ �������� � ������. ��������� ������� ���� ����������.",0

    inf db "  ��������           ����",0    ; ���������� � ����������
    inf1 db "��������� 1           2",0
    inf2 db "��������� 2           4",0
    inf3 db "��������� 3           3",0

    buf dq 30 dup(?),0      ; ������ ��� ������
    buf1 db 80 dup(?),0     ; ������ ��� ������
    buf2 db 80 dup(?),0     ; ������ ��� ������
    buf3 db 80 dup(?),0     ; ������ ��� ������
    buf4 db 80 dup(?),0     ; ������ ��� ������
    buf5 db 200 dup(?),0    ; ������ ��� ������
    buf6 db 150 dup(?),0    ; ������ ��� ������
    ifmt db "������� ���� �����������: %d",0

    PC1 Computer <1,2,"Best PC","Kulish",5>    
    PC2 Computer <5,7,"123","Korcum",4>
    PC3 Computer <3,3,"142","Vasilev",1>

    num1 dq 3 	; ���������� ���������
    res1 dq ? 	; ���������� ����������

.code                   ; ������ ����
    WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    LOCAL hdc:HDC                   ; �������������� ����� ��� ����������� ����
    LOCAL ps:PAINTSTRUCT            ; ��� ��������� PAINTSTRUCT
    LOCAL rect:RECT                 ; ��� ��������� ��������� RECT
    LOCAL leng:QWORD
    .switch uMsg
    .case WM_DESTROY
    invoke PostQuitMessage,NULL
    .case WM_PAINT                  ; ���� ���� ��� � �������������
    invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
    mov hdc,rax                     ; ���������� ���������

    xor rax,rax         ; ������� �������� RAX
    mov rax,PC1.price1  ; ������ ����� ������� ��
    add rax,PC2.price1  ; ����������� ���� ������� ��
    add rax,PC3.price1  ; ����������� ���� �������� ��
    xor rdx,rdx         ; ������� �������� RDX
    div num1            ; /3
    mov res1,rax        ; ������ ���������� � ���������� ����������
	
    invoke wsprintf,ADDR buf5,ADDR task         ; �������������� ������ � �����
    invoke wsprintf,ADDR buf6,ADDR task1        ; �������������� ������ � �����
    invoke wsprintf,ADDR buf,ADDR ifmt,res1   	; �������������� ������ � �����
    invoke wsprintf,ADDR buf1,ADDR inf          ; �������������� ������ � �����
    invoke wsprintf,ADDR buf2,ADDR inf1         ; �������������� ������ � �����
    invoke wsprintf,ADDR buf3,ADDR inf2         ; �������������� ������ � �����
    invoke wsprintf,ADDR buf4,ADDR inf3         ; �������������� ������ � �����

    invoke TextOut,hdc,20,0,addr buf5,112       ; ����� ������ � ����
    invoke TextOut,hdc,20,20,addr buf6,140      ; ����� ������ � ����
    invoke TextOut,hdc,20,60,addr buf1,30       ; ����� ������ � ����
    invoke TextOut,hdc,20,80,addr buf2,30       ; ����� ������ � ����
    invoke TextOut,hdc,20,100,addr buf3,30      ; ����� ������ � ����
    invoke TextOut,hdc,20,120,addr buf4,30      ; ����� ������ � ����
    invoke TextOut,hdc,20,160,addr buf,60       ; ����� ������ � ����
    invoke TextOut,hdc,20,200,chr$("Author: Kulish Pavlo cit120e"),28   ; ������� ����� � ����
    invoke EndPaint, hWnd, ADDR ps
    .endsw                                      ; ����� ��������� �� ���������
    invoke DefWindowProc,hWin,uMsg,wParam,lParam

ret
WndProc endp
end