@echo off
..\Службы\nasmw -fobj   -dalink -o ..\Службы\Пускач.obj Пускач.asm 
..\Службы\nasmw -fobj   -dalink -o ..\Отделы\Обмен\Код\Заграница.obj Заграница.asm 
..\Службы\nasmw -fwin32 -dalink -o ..\Отделы\Иное\Код\Асм.obj Асм.asm 
