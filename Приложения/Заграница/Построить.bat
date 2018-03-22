@echo off
rem Для вызова Построить.bat необходимо, чтобы:
rem %1        - имя приложения (без расширения)
rem %slujput% - путь к службам относительно текущего пути
rem %tekput%  - текущий путь относительно пути служб

set slujput=..\..\Службы
set tekput=..\Приложения\Заграница

call %slujput%\ПостроитьО.bat Окно
call %slujput%\Построить.bat  ИспБиблиотеки
call %slujput%\ПостроитьБ.bat Biblioteka
