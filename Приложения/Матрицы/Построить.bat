@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\Матрицы

call %slujput%\Построить.bat ПроОпред
call %slujput%\Построить.bat ПроLL
call %slujput%\Построить.bat ПроSV
call %slujput%\Построить.bat ПроLU
call %slujput%\Построить.bat ПроQR
call %slujput%\Построить.bat ПроГаусс
call %slujput%\Построить.bat ПроСВект
call %slujput%\Построить.bat ПроСЗнач
call %slujput%\Построить.bat ПроССим
