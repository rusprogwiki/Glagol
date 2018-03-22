rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

cd %slujput%
ПГ1 -м %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
call СписокПБ.bat
link @Otdely.spi @Biblioteki.spi @MSLink.sbo /entry:"Nachalo" /subsystem:console /out:%tekput%\%1.exe
del Biblioteki.spi > nul
del СписокПБ.bat > nul
:vyhod
cd %tekput%
