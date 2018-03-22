rem Преобразование def-файла в lib-файл
link -lib -nologo -machine:ix86 -def:%1def -out:%1lib > nul
del %1exp > nul
