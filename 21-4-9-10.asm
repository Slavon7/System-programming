include \masm64\include64\masm64rt.inc
.data?
  hInstance dq ?
  hIcon     dq ?
  hIcon2 dq ?
  hIcon3 dq ?
  hIcon4 dq ?
  hImg2  dq ?;
  hImg3  dq ?;
  hImg4  dq ?;
.data
szFileName db "Lab06-2.exe",0
szRun4 db "PolPx4m3.exe",0
szRun9 db "PolPx9m3.exe",0 
szRun10 db "PolPx10m3.exe",0 

szTitle9 db "Выполнение расчетов",0
szInf9 db "Нажмите Оk  и примерно через 30 С ожидайте окончания расчетов.",10,10,
"Размер файла расчетов: 551 124 байта.",0
szInf10 db "Нажмите Оk и ожидайте размера файла",10, "расчетов: 1 653 372 байта. ",10,10,
"Время ожидания - до 7 минут.",0

szTitle5 db "О программе",0
szInf5 db "Программа для курсового проекта ",10,
"XX ASCII",10,10,"64-bit",10,"Version 0.1",0

szTitleA db "Автор",0
szInfA db "КІТ-120Є",10,10,"Оменюк Вячеслав Ігорович",10,
"Кафедра ВТП НТУ ХПІ",0


.code
entry_point proc
 mov hInstance,rv(GetModuleHandle,0)
 mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,256,256,LR_DEFAULTCOLOR)
 invoke DialogBoxParam,hInstance,1000,0,ADDR main,hIcon
 invoke WinExec,addr szInf9,SW_SHOW
invoke ExitProcess,0
    ret
entry_point endp

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
.switch uMsg
.case WM_INITDIALOG
invoke SendMessage,hWin,WM_SETICON,1,lParam ; значок для диалога
invoke SendMessage,rv(GetDlgItem,hWin,1001),\ ; значок в клиентской области
               STM_SETIMAGE,IMAGE_ICON,lParam
.case WM_COMMAND
   .switch wParam
     .case 1002
	      invoke WinExec,ADDR szRun4,SW_HIDE

     .case 1015       ;   
     invoke WinExec,addr szFileName,SW_SHOW
     	 
     .case 1003       ;  
invoke MsgboxI,0,ADDR szInf10,ADDR szTitle9,MB_OK,12
    
    .case 1005; Основные
mov hIcon2,rv(LoadImage,hInstance,11,IMAGE_ICON,256,256,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,200,0,ADDR Dial2,hIcon2

    .case 1006; Дополнительные
mov hIcon3,rv(LoadImage,hInstance,12,IMAGE_ICON,256,256, LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,300,0,ADDR Dial3,hIcon3	

    .case 1017; Основные
mov hIcon4,rv(LoadImage,hInstance,11,IMAGE_ICON,256,256,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,400,0,ADDR Dial4,hIcon4

 .case 1007; Дополнительные
mov hIcon4,rv(LoadImage,hInstance,12,IMAGE_ICON,256,256, LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,400,0,ADDR Dial4,hIcon4	

    .case 1010; О программе
    invoke MsgboxI,0,ADDR szInf5,ADDR szTitle5,MB_OK,13
	
	.case 1016   ; кнопка <EXIT>
            jmp exit1  
   .endsw
.case WM_CLOSE
 exit1: invoke EndDialog,hWin,0 ; 
 .endsw
    xor rax, rax
    ret
main endp

; Окно 2 Осн возм интерфейса
Dial2 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG
rcall SendMessage,hWin,WM_SETICON,1,lParam ; установить иконку в строке заголовка
mov hImg2,rvcall(GetDlgItem,hWin,202)
rcall SendMessage,hImg2,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области

.case WM_COMMAND
   .switch wParam
     .case 220
   jmp exit2
   .endsw
 .case WM_CLOSE
 exit2:
    rcall EndDialog,hWin,0 
 .endsw
    xor rax, rax
    ret
Dial2 endp

; Окно 3 Доп возм интерфейса
Dial3 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG
rcall SendMessage,hWin,WM_SETICON,1,lParam ; установить иконку в строке заголовка
mov hImg3,rvcall(GetDlgItem,hWin,302)
rcall SendMessage,hImg3,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области

.case WM_COMMAND
   .switch wParam
     .case 320
 jmp exit3  
   .endsw

 .case WM_CLOSE
exit3:
    rcall EndDialog,hWin,0 
 .endsw
    xor rax, rax
    ret
Dial3 endp

; Окно 4 Доп возм интерфейса
Dial4 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG
rcall SendMessage,hWin,WM_SETICON,1,lParam ; установить иконку в строке заголовка
mov hImg4,rvcall(GetDlgItem,hWin,402)
rcall SendMessage,hImg4,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области

.case WM_COMMAND
   .switch wParam
     .case 403
     invoke MsgboxI,0,ADDR szInfA,ADDR szTitleA,MB_OK,12

   .endsw

 .case WM_CLOSE

    rcall EndDialog,hWin,0 
 .endsw
    xor rax, rax
    ret
Dial4 endp


end

