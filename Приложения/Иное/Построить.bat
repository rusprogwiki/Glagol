@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\Иное

call %slujput%\Построить.bat Привет
call %slujput%\Построить.bat УниВин
call %slujput%\Построить.bat РусЛат
call %slujput%\Построить.bat ОберГла
call %slujput%\Построить.bat ЧислоЕ
call %slujput%\Построить.bat ЧислоПи
call %slujput%\ПостроитьО.bat Секундомер
