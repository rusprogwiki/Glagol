@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\МПГпр

call %slujput%\Построить.bat Пример -п- -о-
%slujput%\link -dump -ALL -DISASM -OUT:Пример.код .\Код\Пример.obj
rem Пример.exe