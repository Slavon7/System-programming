title ����� ������  � MessageBox; masm64
include \masm64\include64\masm64rt.inc
.data
titl db "��������� � ���������� ���������",0; �������� ����������� ����
inf1 db "�������� ������� ��������� �����", 10,
"invoke WinExec,addr szFileName,SW_SHOW � masm64",10,10,
"����� ���������: Omenyuk Vyacheslav",0
.code
entry_point proc
;sub rsp,28h; ������������ ����� 28h=32d+8; 8 � �������
;mov rbp,rsp
invoke MessageBox,0,addr inf1,addr titl, MB_ICONINFORMATION;
;invoke RtlExitUserProcess,0 ;
ret;   
invoke ExitProcess,0
entry_point endp
end