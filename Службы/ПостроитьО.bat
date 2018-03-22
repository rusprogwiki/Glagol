rem Приёмники (переменные) Построить.bat:
rem %1        - просто имя приложения (без расширения и пути)
rem %2 %3 %4  - дополнительные настройки для ПГ
rem %slujput% - путь к \Глагол\Службы\ от папки приложения
rem %tekput%  - путь к папке приложения относительно \Глагол\Службы\

cd %slujput%
del %tekput%\%1.exe > nul

call ВидСборки.bat
rem теперь в %sborka% используемый сборщик

if %sborka%==mslink goto mslink

:alink
rem Преобразование новых .отд файлов, 
rem создание в Otdely.spi списка всех составляющих приложение .obj файлов,
rem составление описаний принимаемых задач в ПринЗадачи.asm.
ПГ -м- %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
nasmw -fobj -o ПринЗадачи.obj %tekput%\Код\ПринЗадачи.asm 
rem сборка exe файла
alink @Otdely.spi @ALink.sbo -entry _Nachalo -subsys win -o %tekput%\%1.exe
rem уборка лишних файлов
del ПринЗадачи.obj > nul
goto vyhod

:mslink
rem Преобразование новых .отд файлов, 
rem создание в Otdely.spi списка всех составляющих приложение .obj файлов,
rem составление описаний принимаемых задач в *.def,
rem создание в СписокПБ.bat списка принимаемых библиотек,
rem создание в PerZadachi.spi списка передаваемых задач.
ПГ -м %tekput%\%1 %2 %3 %4
if errorlevel==1 goto vyhod
rem преобразование *.def файлов в *.lib файлы,
call СписокПБ.bat
rem сборка exe файла
link @Otdely.spi @Biblioteki.spi @MSLink.sbo /entry:"Nachalo" /subsystem:windows /out:%tekput%\%1.exe
rem уборка лишних файлов
del PerZadachi.spi > nul
del Biblioteki.spi > nul
del СписокПБ.bat > nul

:vyhod
del Otdely.spi > nul
cd %tekput%
