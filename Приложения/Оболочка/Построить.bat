@echo off
rem ��� �맮�� ����ந��.bat ����室���, �⮡�:
rem %1        - ��� �ਫ������ (��� ���७��)
rem %slujput% - ���� � �㦡�� �⭮�⥫쭮 ⥪�饣� ���
rem %tekput%  - ⥪�騩 ���� �⭮�⥫쭮 ��� �㦡

set slujput=..\..\��㦡�
set tekput=..\�ਫ������\�����窠

del �����窠.exe
del %slujput%\�����窠.exe
call %slujput%\����ந��.bat �����窠
move �����窠.exe %slujput%\
move �����窠.pdb %slujput%\
cd %slujput%
�����窠.exe
cd %tekput%
