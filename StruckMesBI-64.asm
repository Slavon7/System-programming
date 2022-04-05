include \masm64\include64\masm64rt.inc; библиотеки
IDI_ICON EQU 1001
MSGBOXPARAMSA STRUCT
cbSize DWORD ? , ?
hwndOwner QWORD ?
hInstance QWORD ?
lpszText QWORD ?
lpszCaption QWORD ?
MB_USERICON; DWORD ? , ?
IDI_ICON QWORD ?
dwContextHelpId QWORD ?
lpfnMsgBoxCallback QWORD ?
dwLanguageId DWORD ? , ?
MSGBOXPARAMSA ENDS
.data
