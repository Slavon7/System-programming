.686	; директива определения типа микропроцессора
.XMM
.model flat,stdcall ; задание линейной модели памяти и соглашения ОС
option casemap:none ; отличие малых и больших букв
include \masm32\include\windows.inc ; файлы структур, констант
include \masm32\macros\macros.asm
uselib user32,kernel32,fpu,gdi32
.data	
 mas dd 360 ; 
 alpha dd 0.0 ; угловая координата 
 delta dd 0.0175 ; один градус
 xdiv2 dd ?    ; середина по X 
 ydiv2 dd ?    ; середина по Y
 tmp dd 0      ; временная переменная
 divK dd 10.0 ; масштабный коэффициент
 xr dd 0. 	  ; координаты функции
 yr dd 0
.code
_st:
 invoke GetSystemMetrics,SM_CXSCREEN ; получение ширины экрана в пикселях
  shr eax,1 ; деление на 2 – определение середины экрана по Х
  mov xdiv2,eax
 invoke GetSystemMetrics,SM_CYSCREEN ; получение высоты экрана в пикселях
  shr eax,1 ; деление на 2 – определение середины экрана по Y
  mov ydiv2,eax
 mov ecx,mas ; определение количества циклов
push ecx  	 ; сохранение в стеке количества циклов
finit
l1:                         ; x = x0 + Кfcosf
fld alpha  ; st(0) := alpha
fcos       ; st(0) := cos(alpha)
fstp xr
	movss XMM2,xr    ; cos(alpha)  
	mulss XMM2,alpha ; alpha * cos(alpha)
	mulss XMM2,divK  ; divK * alpha * cos(alpha)
	cvtss2si eax,XMM2 ; преобразование в целое
	add eax,xdiv2 ; xdiv2 + divK * alpha * cos(alpha)
	mov xr,eax
 finit		; обнуление сопроцессора
   fld alpha ; st(0) := alpha
   fsin      ; st(0) := sin(alpha)
	fstp yr
	movss XMM3,yr    ; sin(alpha)  
	mulss XMM3,alpha ; alpha * sin(alpha)
	mulss XMM3,divK  ; divK *alpha * sin(alpha)
	cvtss2si ebx,XMM3 ;
	add ebx,ydiv2    ; ydiv2 + divK * alpha * sin(alpha)
	mov yr,ebx
invoke Sleep,1            ; задержка
invoke SetCursorPos,xr,yr ; установление курсора по xr, yr 
movss XMM3,delta
addss XMM3,alpha
movss alpha,XMM3
pop ecx   ; возвращение из стека количества циклов
dec ecx   ; уменьшение счетчика
push ecx
jz l2       ; продолжение рисование
jmp l1	; выход из цикла
l2: pop ecx
invoke  ExitProcess,0 ; 
end _st          ;
