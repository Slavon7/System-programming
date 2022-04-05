title создание и запись в файл; masm64
include \masm64\include64\masm64rt.inc ; библиотеки для подключения
BSIZE equ 16
.data

LessOrMore dq 0     ; 
Equals dq 0    ; 

mas1 dq -22,-93,-253,-433,-43,-22,-34,-43,-43,23,-54,22,-23,-43,-50,-60,70,-90,-100,-43,-1
len1 equ ($-mas1) ;  длина массива


const1 dq 512
const2 dq 10
const3 dq 40
const5 dq 0
x1 dq 1
fName BYTE "Lab_FILE.txt",0
fHandle dq ? ;
cWritten dq ? ;
hFile dq ?,0
buf dq 0
temp dq -1
fmt db "maximal minimum number is: %d",0ah,
" ",10,10,
"Автор: Kulish Pavlo cit 120e",0
titl1 db " masm64. Файлы",0
szFileName db "C:\Masm64\bin64\task3-1-sms.exe",0
buf2 dq 10 dup(1),0
fmt2 db "%d",0
.code
entry_point proc

metka1:

mov rax, mas1[rsi]

.if (rax == -22)
inc Equals;
.else
inc LessOrMore
.endif

add rsi, type mas1
xor rax,rax
cmp rsi, len1
jnz metka1

xor rax,rax
mov rax, Equals

invoke WinExec,addr szFileName,SW_SHOW;
invoke wsprintf,addr buf,addr fmt,temp, Equals
invoke MessageBox,0,addr buf,addr titl1,MB_ICONINFORMATION

lea rdi, buf2
mov r13, Equals
mov r14, LessOrMore
invoke wsprintf,addr [rdi],addr fmt2,Equals
add rdi, type buf2
invoke wsprintf,addr [rdi],addr fmt2,LessOrMore


invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
mov fHandle, rax;
invoke WriteFile,fHandle,ADDR buf2,BSIZE,ADDR cWritten,0
invoke CloseHandle,fHandle
;invoke RtlExitUserProcess,0 ; 
ret; 
invoke ExitProcess,0
entry_point endp
end