title вывод текста  в MessageBox; masm64
include \masm64\include64\masm64rt.inc
.data
titl db "—ообщение о завершении программы",0; название упрощенного окна
inf1 db "«апущена внешн€€ программа через", 10,
"invoke WinExec,addr szFileName,SW_SHOW в masm64",10,10,
"јвтор программы: Omenyuk Vyacheslav",0
.code
entry_point proc
;sub rsp,28h; выравнивание стека 28h=32d+8; 8 Ч возврат
;mov rbp,rsp
invoke MessageBox,0,addr inf1,addr titl, MB_ICONINFORMATION;
;invoke RtlExitUserProcess,0 ;
ret;   
invoke ExitProcess,0
entry_point endp
end