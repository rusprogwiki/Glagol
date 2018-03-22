@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\Оболочка

del Оболочка.exe
del %slujput%\Оболочка.exe
call %slujput%\ПостроитьО.bat Оболочка
move Оболочка.exe %slujput%\
move Оболочка.pdb %slujput%\
cd %slujput%
Оболочка.exe
cd %tekput%
