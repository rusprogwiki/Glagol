@echo off
del .\Код\*.obj
del .\Код\*.опг

del ..\..\Отделы\Иное\Код\*.obj
del ..\..\Отделы\Иное\Код\*.опг

del ..\..\Отделы\Обмен\Код\*.obj
del ..\..\Отделы\Обмен\Код\*.опг

del ..\..\Отделы\Среда\Код\*.obj
del ..\..\Отделы\Среда\Код\*.опг

del ..\..\Отделы\Числа\Код\*.obj
del ..\..\Отделы\Числа\Код\*.опг

rem Преобразуем asm в obj
call ..\..\Службы\ВидСборки.bat
cd ..\..\Заграница
if %sborka%==mslink goto mslink
:alink
call ALink.bat
goto vyhod
:mslink
call MSLink.bat
:vyhod
cd ..\Приложения\ПГ
