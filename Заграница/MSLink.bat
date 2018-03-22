@echo off
..\Службы\nasmw -fwin32 -dmslink -o ..\Службы\Пускач.obj Пускач.asm 
..\Службы\nasmw -fwin32 -dmslink -o ..\Отделы\Обмен\Код\Заграница.obj Заграница.asm 
..\Службы\nasmw -fwin32 -dmslink -o ..\Отделы\Иное\Код\Асм.obj Асм.asm 
