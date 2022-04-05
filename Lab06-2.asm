option casemap:none 	; отличие малых и больших букв 
include \masm64\include64\masm64rt.inc ; 

.data?
hInstance dq ? ; дескриптор программы
hWnd dq ? ; дескриптор окна
hIcon dq ? ; дескриптор иконки
hCursor dq ? ; дескриптор курсора
sWid dq ? ; ширина монитора (колич. пикселей по x)
sHgt dq ? ; высота монитора (колич. пикселей по y)

.data	
mas dd 07AB7h	; количество циклов	
	two dd 2.
	alpha dd 0.0 	; угловая координата 
	delta dd 0.001 	; увеличение координаты
	xdiv2 dd ? 		; середина по X и Y
	ydiv2 dd ?
	temp1 dd 0 		; временная переменная
	K1 dd 2.5		; масштабные коэффициенты
	K2 dd 5.0
	divK dd 5.0
	xr dd 0. 		; координаты функции
	yr dd 0.0
 
 titl1 db " Графическая фигура параметрическая спираль",0
 classname db "template_class",0
 
.code
entry_point proc
mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa программы
mov hIcon, rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора
mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
call main
invoke ExitProcess,0
entry_point endp

main proc
LOCAL wc :WNDCLASSEX ; объявление локальных переменных
LOCAL lft :QWORD ; Лок. переменные содержатся в стеке
LOCAL top :QWORD ; и существуют только во время вып. проц.
LOCAL wid :QWORD
LOCAL hgt :QWORD
; Создание образа окна
mov wc.cbSize,SIZEOF WNDCLASSEX ; колич. байтов структуры
mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ;стиль окна
mov wc.lpfnWndProc,ptr$(WndProc) ; адрес процедуры WndProc
mov wc.cbClsExtra,0 ; количество байтов для структуры класса
mov wc.cbWndExtra,0 ; количество байтов для структуры окна
mrm wc.hInstance,hInstance ; заполнение поля дескриптора в структуре
mrm wc.hIcon, hIcon ; хэндл иконки
mrm wc.hCursor,hCursor ; хэндл курсора
mrm wc.hbrBackground,0 ; цвет окна
mov wc.lpszMenuName,0 ; заполнение поля в структуре с именем ресурса меню
mov wc.lpszClassName,ptr$(classname) ; имя класса
mrm wc.hIconSm,hIcon
; Регистрация класса
invoke RegisterClassEx,ADDR wc ; регистрация класса окна
mov wid, 520 ; ширина пользовательского окна в пикселях
mov hgt, 400 ; высота пользовательского окна в пикселях
mov rax,sWid ; колич. пикселей монитора по x
sub rax,wid ; дельта Х = Х(монитора) - х(окна пользователя)
shr rax,1 ; получение середины Х
mov lft,rax ;
mov rax, sHgt ; колич. пикселей монитора по y
sub rax, hgt ;
shr rax, 1 ;
mov top, rax ;
; Cоздание окна
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
ADDR classname,ADDR titl1,WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
lft,top,wid,hgt,0,0,hInstance,0
mov hWnd,rax ; сохранение дескриптора окна
call msgloop
ret
main endp

msgloop proc ; цикл сообщений (очередь сообщений)
LOCAL msg :MSG
LOCAL pmsg :QWORD
mov pmsg,ptr$(msg) ; получение адреса структуры сообщения
jmp gmsg ; jump directly to GetMessage()
mloop:
invoke TranslateMessage,pmsg
invoke DispatchMessage,pmsg ; отправка на обслуживание к WndProc
gmsg:
test rax, rv(GetMessage,pmsg,0,0,0) ; пока GetMessage не вернет ноль
jnz mloop
ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
LOCAL hdc:HDC               ; резервирование стека для дескриптора окна
LOCAL ps:PAINTSTRUCT        ; для структуры PAINTSTRUCT
LOCAL rect:RECT             ; для структуры координат RECT
.switch uMsg
.case WM_DESTROY            ; если есть сообщение про уничтожение окна
invoke PostQuitMessage,NULL
.case WM_PAINT              ; если есть смс о перерисовании
invoke BeginPaint,hWnd, ADDR ps ; вызов подготовительной процедуры
mov hdc,rax                 ; сохранение контекста
invoke GetClientRect,hWnd,ADDR rect ; занесение в структуру rect характеристик окна
invoke TextOut,hdc,100,240,chr$("Автор программы:  Вячеслав Оменюк "),35
invoke MoveToEx,hdc,xdiv2,ydiv2,0; перемещение точки начала
mov r10d,mas ; сохранение количества циклов
mov temp1,r10d
mov ecx,mas

finit    ; СПИРАЛЬ
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

invoke LineTo,hdc,xr,yr; рисование прямой 
movss XMM4,delta ; для увеличения угловой координаты
addss XMM4,alpha
movss alpha,XMM4

invoke SetPixel,hdc, xr, yr, 40001
;invoke SetCursorPos,xr,yr ; Курсор на позицию
movss XMM4,delta
addss XMM4,alpha
movss alpha,XMM4
dec temp1   ; уменьшение счетчика
jz l2       ; продолжение рисование
jmp l1	; выход из цикла
l2: 

invoke EndPaint,hWnd, ADDR ps ; завершение рисования
.endsw
invoke DefWindowProc,hWin,uMsg,wParam,lParam
ret
WndProc endp
end
