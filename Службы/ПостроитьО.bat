rem ��񬭨�� (��६����) ����ந��.bat:
rem %1        - ���� ��� �ਫ������ (��� ���७�� � ���)
rem %2 %3 %4  - �������⥫�� ����ன�� ��� ��
rem %slujput% - ���� � \������\��㦡�\ �� ����� �ਫ������
rem %tekput%  - ���� � ����� �ਫ������ �⭮�⥫쭮 \������\��㦡�\

cd %slujput%
del %tekput%\%1.exe > nul

call ������ન.bat
rem ⥯��� � %sborka% �ᯮ��㥬� ᡮ�騪

if %sborka%==mslink goto mslink

:alink
rem �८�ࠧ������ ����� .�� 䠩���, 
rem ᮧ����� � Otdely.spi ᯨ᪠ ��� ��⠢����� �ਫ������ .obj 䠩���,
rem ��⠢����� ���ᠭ�� �ਭ������� ����� � �ਭ�����.asm.
�� -�- %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
nasmw -fobj -o �ਭ�����.obj %tekput%\���\�ਭ�����.asm 
rem ᡮઠ exe 䠩��
alink @Otdely.spi @ALink.sbo -entry _Nachalo -subsys win -o %tekput%\%1.exe
rem 㡮ઠ ��譨� 䠩���
del �ਭ�����.obj > nul
goto vyhod

:mslink
rem �८�ࠧ������ ����� .�� 䠩���, 
rem ᮧ����� � Otdely.spi ᯨ᪠ ��� ��⠢����� �ਫ������ .obj 䠩���,
rem ��⠢����� ���ᠭ�� �ਭ������� ����� � *.def,
rem ᮧ����� � ���᮪��.bat ᯨ᪠ �ਭ������� ������⥪,
rem ᮧ����� � PerZadachi.spi ᯨ᪠ ��।������� �����.
�� -� %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
rem �८�ࠧ������ *.def 䠩��� � *.lib 䠩��,
call ���᮪��.bat
rem ᡮઠ exe 䠩��
link @Otdely.spi @Biblioteki.spi @MSLink.sbo /entry:"Nachalo" /subsystem:windows /out:%tekput%\%1.exe
rem 㡮ઠ ��譨� 䠩���
del PerZadachi.spi > nul
del Biblioteki.spi > nul
del ���᮪��.bat > nul

:vyhod
del Otdely.spi > nul
cd %tekput%
