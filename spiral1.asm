option casemap:none 	; отличие малых и больших букв 
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD ; прототип процедуры
include \masm32\include\windows.inc ; файлы структур, констант .
include \masm32\macros\macros.asm
uselib user64,kernel32,fpu,gdi64
.data					
	ClassName db "Class", 0 
	AppName db "Спираль Архимеда",0
	MenuName db "FirstMenu",0
infAuthor1 db "Рысованый А.Н., каф. ВТП, КИТ, НТУ ХПИ",0
infTitle1 db "Построение спирали Архимеда",0
condition db "- количество витков от 1 до 10;",0dh,0ah,
"- три кнопки главного меню, всплывающие кнопки;",13,10,"- два варианта масштаба изображения;",10,
"- использование при расчетах команд технологии SSE.",0
	info_caption db "Об авторе",0
	usl_caption db "Условия построения спирали Архимеда",0
	mas dd 07AB7h	; количество циклов	
	two dd 2.
	alpha dd 0.0 	; угловая координата 
	delta dd 0.001 	; увеличение координаты
	xdiv2 dd ? 		; середина по X и Y
	ydiv2 dd ?
	tmp dd 0 		; временная переменная
	K1 dd 2.5		; масштабные коэффициенты
	K2 dd 5.0
	divK dd 5.0
	xr dd 0. 		; координаты функции
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
invoke GetModuleHandle,0 ; получение дескриптора программы
	mov    hInstance,eax ; сохранение дескриптора программы
	invoke GetCommandLine 
	mov CommandLine,eax
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
invoke ExitProcess,eax 
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,\
  CmdShow:DWORD
LOCAL wc:WNDCLASSEX ; резервирование стека под структуру
LOCAL msg:MSG  	; резервирование стека под структуру MSG
LOCAL hwnd:HWND	; резервирование стека под хендл программы
mov   wc.cbSize,SIZEOF WNDCLASSEX ; количество байтов структуры
mov   wc.style,CS_HREDRAW or CS_VREDRAW ;стиль и поведение окна
	mov   wc.lpfnWndProc,OFFSET WndProc ; адрес процедуры WndProc
	mov   wc.cbClsExtra,NULL	; количество байтов для структуры класса
	mov   wc.cbWndExtra,NULL	; количество байтов для структуры окна
	push  hInst		; сохранение в стеци дескриптора программы
	pop   wc.hInstance	; возвращение дескриптора в поле структуры
	mov   wc.hbrBackground,COLOR_WINDOW+1	; цвет окна
	mov   wc.lpszMenuName,OFFSET MenuName	; имя ресурса меню
	mov   wc.lpszClassName,OFFSET ClassName	; имя класса
	invoke LoadIcon,hInstance,IDI_ICON		; ресурс піктограми
	mov   wc.hIcon,eax			; дескриптор пиктограммы
	mov   wc.hIconSm,eax 	; дескриптор маленького окошка
	invoke LoadCursor,NULL,IDC_ARROW    ; ресурс 
	mov   wc.hCursor,eax		; дескриптор курсору
	invoke RegisterClassEx,addr wc	; регистрация класса окна
	INVOKE CreateWindowEx,0,ADDR ClassName,\ ; стиль и адрес имени класса
		ADDR AppName,WS_OVERLAPPEDWINDOW,\; адрес имени окна и базовый стиль
		200,200,650,650,0,0,hInst,0	; координаты и дескрипторы 
	mov   hwnd,eax
	INVOKE ShowWindow,hwnd,SW_SHOWNORMAL ; видимость окна
	INVOKE UpdateWindow, hwnd
	.WHILE TRUE			; пока истинно, то
invoke GetMessage,ADDR msg,0,0,0 ; чтение сообщения
	or eax, eax		; формирование признаков
	jz Quit			; перейти на метку Quit, если eax = 0
invoke DispatchMessage, ADDR msg ; отправление на обслуживание
	.ENDW		; окончание цикла обработки сообщений
Quit:		
	mov   eax,msg.wParam
	ret		 ; возвращение из процедуры WinMain
WinMain endp ; окончание процедуры с именем WinMain

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM,\
 lParam:LPARAM
LOCAL rect:RECT	; резервирование стека под структуру RECT
LOCAL ps:PAINTSTRUCT ; резервирование стека под структуру 
LOCAL hdc:HDC		; резервирование стека под хендл окна
   .IF uMsg==WM_DESTROY ; если есть сообщение об уничтожении окна
	invoke PostQuitMessage,NULL ; передача сообщения WM_Quit
.ELSEIF uMsg==WM_COMMAND  	; если есть сообщение из меню
	mov eax,wParam  ; формирование признаков сообщения из меню
	.IF ax==IDM_INFO	; вывод информации об авторе
invoke MessageBox,0,ADDR infAuthor1,ADDR infTitle1,MB_ICONINFORMATION
	.ELSEIF ax==IDM_USL		; вывод условия
invoke MessageBox,0,ADDR condition,ADDR usl_caption,MB_ICONINFORMATION
	.ELSEIF ax==IDM_M1 ; определение коэффициента масштаба
	mov ebx,K1		; divK=2.5
	mov divK, ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_M2
	mov ebx,K2		; divK=5.0
	mov divK, ebx
invoke InvalidateRect,hWnd,0,TRUE
	.ELSEIF ax==IDM_V1 ; определение количества циклов 
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
invoke DestroyWindow,hWnd 	; уничтожение окна
	.ENDIF
.ELSEIF uMsg==WM_PAINT ; если есть сообщение о перерисувании
 invoke BeginPaint,hWnd,addr ps ; заполнение структуры
        mov hdc, eax  ; сохранение контекста
 invoke GetClientRect,hWnd,addr rect; занесение в структуру rect характеристик окна
	mov alpha,0	; угловая координата
    cvtsi2ss XMM0,rect.right ;eax
	divss XMM0,two 
	cvtss2si eax,XMM0 ;
	mov xdiv2,eax
 cvtsi2ss XMM1,rect.bottom 
 divss XMM1,two 
 cvtss2si eax,XMM1 ;
 mov ydiv2,eax
invoke MoveToEx,hdc,xdiv2,ydiv2,0; перемещение точки начала 
 ;рисование в середине окна
	mov ecx,mas ; определение количества циклов
	push ecx	; сохранение в стек количества циклов
	finit		; инициирование сопроцессора
l1:	fld alpha ; st(0) := alpha
	fcos      ; st(0) := cos(alpha)
	fstp xr
	movss XMM2,xr    ; cos(alpha)  
	mulss XMM2,alpha ; alpha * cos(alpha)
	mulss XMM2,divK  ; divK * alpha * cos(alpha)
	cvtss2si eax,XMM2 ; преобразование в целое
	add eax,xdiv2 ; xdiv2 + divK * alpha * cos(alpha) PROOOOOOOOOOOOBLEM()()()()()()()()
	mov xr,eax
 finit		; обнуление сопроцессора
   fld alpha ; st(0) := alpha
   fsin      ; st(0) := sin(alpha)
	fstp yr
	movss XMM3,yr    ; sin(alpha)  
	mulss XMM3,alpha ;  alpha * sin(alpha)
	mulss XMM3,divK  ; divK *alpha * sin(alpha)
	cvtss2si ebx,XMM3 ;
	add ebx,ydiv2   ; ydiv2 + divK * alpha * sin(alpha)
	mov yr,ebx
invoke LineTo,hdc,xr,yr; рисование прямой 
	movss XMM4,delta ; для увеличения угловой координаты
	addss XMM4,alpha
	movss alpha,XMM4
 pop ecx	; возвращение из стека количества циклов
 dec ecx	; уменьшение счетчика
	push ecx
	jz l2		; продолжение рисования
	jmp l1		; выход из цикла
l2:	pop ecx
	invoke EndPaint,hWnd,addr ps ; окончание рисования
	mov eax, 0     
	.ELSE 			; иначе
invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; к функции WndProc
	ret
	.ENDIF		; окончание логической структуры .IF - .ELSE
	xor eax,eax
	ret			; возвращение из процедуры
WndProc endp	; окончание процедуры WndProc
end start		; окончание программы с именем start
