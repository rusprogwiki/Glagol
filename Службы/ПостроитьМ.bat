rem Приёмники (переменные) ПостроитьМ.bat:
rem %1        - просто имя приложения (без расширения и пути)
rem %2 %3 %4  - дополнительные настройки для МПГ
rem %slujput% - путь к \Глагол\Службы\ от папки приложения
rem %tekput%  - путь к папке приложения относительно \Глагол\Службы\

cd %slujput%
del %tekput%\%1.exe > nul
МПГ %tekput%\%1 %2 %3 %4
call СписокПК.bat
if errorlevel==1 goto vyhod
link @Otdely.spi @MSLinkARM.sbo /out:%tekput%\%1.exe
:vyhod
del Otdely.spi > nul
del СписокПК.bat > nul
cd %tekput%
