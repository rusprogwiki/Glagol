@echo off
del .\���\*.obj
del .\���\*.���

del ..\..\�⤥��\����\���\*.obj
del ..\..\�⤥��\����\���\*.���

del ..\..\�⤥��\�����\���\*.obj
del ..\..\�⤥��\�����\���\*.���

del ..\..\�⤥��\�।�\���\*.obj
del ..\..\�⤥��\�।�\���\*.���

del ..\..\�⤥��\��᫠\���\*.obj
del ..\..\�⤥��\��᫠\���\*.���

rem �८�ࠧ㥬 asm � obj
call ..\..\��㦡�\������ન.bat
cd ..\..\���࠭��
if %sborka%==mslink goto mslink
:alink
call ALink.bat
goto vyhod
:mslink
call MSLink.bat
:vyhod
cd ..\�ਫ������\��
