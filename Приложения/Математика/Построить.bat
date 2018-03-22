@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\Математика

call %slujput%\Построить.bat ПроФункц
call %slujput%\Построить.bat ПроМатем1
call %slujput%\Построить.bat ПроМатем2
call %slujput%\Построить.bat ПроБПФ
call %slujput%\Построить.bat ПроКомпл
call %slujput%\Построить.bat ПроКомплLU
call %slujput%\Построить.bat ЦелОселок
call %slujput%\Построить.bat ВещОселок
