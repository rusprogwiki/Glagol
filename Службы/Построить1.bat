rem ��� �맮�� ����ந��.bat ����室���, �⮡�:
rem %1        - ��� �ਫ������ (��� ���७��)
rem %slujput% - ���� � �㦡�� �⭮�⥫쭮 ⥪�饣� ���
rem %tekput%  - ⥪�騩 ���� �⭮�⥫쭮 ��� �㦡

cd %slujput%
��1 -� %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
call ���᮪��.bat
link @Otdely.spi @Biblioteki.spi @MSLink.sbo /entry:"Nachalo" /subsystem:console /out:%tekput%\%1.exe
del Biblioteki.spi > nul
del ���᮪��.bat > nul
:vyhod
cd %tekput%
