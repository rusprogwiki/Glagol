rem ��񬭨�� (��६����) ����ந��.bat:
rem %1        - ���� ��� �ਫ������ (��� ���७�� � ���)
rem %2 %3 %4  - �������⥫�� ����ன�� ��� ���
rem %slujput% - ���� � \������\��㦡�\ �� ����� �ਫ������
rem %tekput%  - ���� � ����� �ਫ������ �⭮�⥫쭮 \������\��㦡�\

cd %slujput%
del %tekput%\%1.exe > nul
��� %tekput%\%1 %2 %3 %4
call ���᮪��.bat
if errorlevel==1 goto vyhod
link @Otdely.spi @MSLinkARM.sbo /out:%tekput%\%1.exe
:vyhod
del Otdely.spi > nul
del ���᮪��.bat > nul
cd %tekput%
