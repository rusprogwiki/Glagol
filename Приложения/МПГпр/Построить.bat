@echo off
rem ��� �맮�� ����ந��.bat ����室���, �⮡�:
rem %1        - ��� �ਫ������ (��� ���७��)
rem %slujput% - ���� � �㦡�� �⭮�⥫쭮 ⥪�饣� ���
rem %tekput%  - ⥪�騩 ���� �⭮�⥫쭮 ��� �㦡

set slujput=..\..\��㦡�
set tekput=..\�ਫ������\�����

call %slujput%\����ந��.bat �ਬ�� -�- -�-
%slujput%\link -dump -ALL -DISASM -OUT:�ਬ��.��� .\���\�ਬ��.obj
rem �ਬ��.exe