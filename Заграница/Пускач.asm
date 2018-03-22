;************************************************************************
; Запуск приложений, написанных на языке Глагол.   
; После подготовительных действий управление передается
; в ОТДЕЛ с '+' в имени (задача _Zapusk).
;************************************************************************

%include "zadacha.mac"

%ifdef mslink
%define ExitProcess __imp__ExitProcess
%else
import ExitProcess kernel32.dll
%endif

extern ExitProcess
extern _Zapusk

;************************************************************************
; Регистры EBP и EIP, сохранённые  при вызове принимаемой задачи,
; нужны для восстановления стека вызовов в передаваемых задачах.
;************************************************************************
section .bss
global GlBP
GlBP resd 1
global GlIP
GlIP resd 1
global DPBHInstance
DPBHInstance resd 1
global DPBReason
DPBReason resd 1
global DPBParam
DPBParam resd 1

section .data
;CW8087: dw 733H ; расширенная точность, округление к -8,
CW8087: dw 333H ; расширенная точность, округление к ближайшему,
                ; исключения при делении на 0 и переполнении

segment code public use32 class=CODE

;************************************************************************
; Точка входа в приложение
;************************************************************************
global _Nachalo
_Nachalo:
             CLD                         ; Сбросить флаг направления
             AND     ESP,byte -4         ; Стек по границе 4 байт
             MOV     AX,DS               ; ES:=DS по умолчанию
             MOV     ES,AX               ; ...
             FNINIT                      ; Сбросить FPU
             FLDCW   word [CW8087]       ; Настройки FPU
             XOR     EBP,EBP             ; EBP:=0 для границы уборки памяти
             MOV     [GlBP],EBP          ; Граница передаваемых задач
             MOV     [GlIP],EBP          ; Граница передаваемых задач
             CALL    _Zapusk             ; Работа приложения
             XOR     EAX,EAX             ; СТОП(0)
;************************************************************************
; Точка выхода из приложения
;************************************************************************
global Stop
Stop:
             PUSH    EAX                 ; ExitProcess(EAX)
             CALL    [ExitProcess]       ; ...

;************************************************************************
; Точка входа в ДПБ-приложение
;************************************************************************
;ЗАДАЧА* _Nachalo-(hInstance,reason,param:ЦЕЛ);
ZADACHA _Nachalo@12
%$hInstance  priem
%$reason     priem
%$param      priem
             PUSH    EBX                 ; сохранить используемые регистры
             PUSH    ESI                 ; ...
             PUSH    EDI                 ; ...
             MOV     EDI,[EBP+%$hInstance] ; перепишем DPBHInstance
             MOV     [DPBHInstance],EDI  ; ...
             MOV     EDI,[EBP+%$reason]  ; перепишем DPBReason
             MOV     [DPBReason],EDI     ; ...
             MOV     EDI,[EBP+%$param]   ; перепишем DPBParam
             MOV     [DPBParam],EDI      ; ...
             XOR     EBP,EBP             ; EBP:=0 для границы уборки памяти
             MOV     [GlBP],EBP          ; Граница передаваемых задач
             MOV     [GlIP],EBP          ; Граница передаваемых задач
             CALL    _Zapusk             ; Работа приложения
             POP     EDI                 ; восстановить регистры
             POP     ESI                 ; ...
             POP     EBX                 ; ...
             MOV     EAX,1               ; всё в порядке
KON _Nachalo@12

;******************************************************************************-
; 'CelChast' целая часть вещественного числа
;
; ДО:        ST(0)        число
;
; ПОСЛЕ:     ST(0)        целая часть
;
;******************************************************************************-
global  CelChast
CelChast:
             SUB     ESP,4
             FNSTCW  word [ESP]          ; сохраним настройки FPU
             FNSTCW  word [ESP+2]
             FWAIT
             OR      [ESP+2], word 0F00H ; округление к 0, расширенная точность
             FLDCW   word [ESP+2]
             FRNDINT
             FWAIT
             FLDCW   word [ESP]          ; восстановим настройки FPU
             ADD     ESP,4
             RET

;******************************************************************************-
; 'ObmenBPIP' обменивает EBP и EIP, сохранённые в стеке при подвызове 
; передаваемой задачи, с EBP и EIP, сохранёнными в памяти при подвызове
; передаваемой задачи.
;
; ДО:        [EBP]        EBP задачи, вызвавшей передаваемую задачу
;            [EBP+4]      EIP задачи, вызвавшей передаваемую задачу
;            [GlBP]       EBP задачи, вызвавшей принимаемую задачу
;            [GlIP]       EIP задачи, вызвавшей принимаемую задачу
;
;******************************************************************************-
global  ObmenBPIP
ObmenBPIP:
             MOV     EBX,    [EBP]
             MOV     ECX,    [GlBP]
             MOV     [GlBP], EBX
             MOV     [EBP],  ECX
             MOV     EBX,    [EBP+4]
             MOV     ECX,    [GlIP]
             MOV     [GlIP], EBX
             MOV     [EBP+4],ECX
             RET                         ; готово

;******************************************************************************-
; 'Umnojenie64' вычисляет произведение двух ЦЕЛ64 величин. При переполнении
; ЦЕЛ64 OF флаг не выставляется !!
;
; ДО:        EDX:EAX      множимое
;            EBX:ECX      множитель
;
; ПОСЛЕ:     EDX:EAX      произведение, если нет переполнения
;
;******************************************************************************-
global  Umnojenie64
Umnojenie64:
             PUSH    ESI                 ; сохранить используемые
             PUSH    EDI                 ;  регистры
             MOV     EDI, EDX            ; сохранить СТ множимое
             OR      EDI, EBX            ; оба числа положительные и <= 0FFFFFFFFH?
             JZ      prostUmn            ; достаточно простого умножения   
             MOV     EDI, EDX            ; сохранить СТ множимое
             MOV     ESI, EAX            ; сохранить МЛ множимое
             MUL     EBX                 ; множитель СТ * множимое МЛ
             XCHG    EAX, EDI            ; сохранить произв1 МЛ, взять СТ множимое
             MUL     ECX                 ; множитель МЛ * множимое СТ
             XCHG    EAX, ESI            ; сохранить произв2 МЛ, взять МЛ множимое
             ADD     ESI, EDI            ; сложить произв1 и произв2 (результат СТ)
             JO      vyhodUmn            ; переполнение
             MUL     ECX                 ; множитель МЛ * множимое МЛ
             ADD     EDX, ESI            ; сложить произв3 СТ и результат СТ
             JMP     vyhodUmn            ; готово
prostUmn:    MUL     ECX                 ; МЛ множимое * МЛ множитель
             AND     EAX,EAX             ; переполнения нет
vyhodUmn:    POP     EDI                 ; восстановить ранее сохраненные
             POP     ESI                 ;  регистры
             RET                         ; готово

;******************************************************************************-
; 'Delenie64' делит два ЦЕЛ64 числа, и получает частное и остаток.
;
; ДО:         EDX:EAX     делимое
;             EBX:ECX     делитель
;
; ПОСЛЕ:      EDX:EAX     частное
;             EBX:ECX     остаток
;
;******************************************************************************-
global  Delenie64
Delenie64:
             PUSH    ESI                 ; сохранить используемые
             PUSH    EDI                 ;  регистры
             XOR     EDX, EBX            ; SF вкл если частное отрицательное
             PUSHF                       ; сохранить flag
             XOR     EDX, EBX            ; делимое отрицательное ?
             PUSHF                       ; SF вкл если делимое (и остаток) отрицательное
             JNS     dividnd_pos         ; нет, ->
             NOT     EDX                 ; меняем знак
             NEG     EAX                 ;  делимого
             SBB     EDX, byte -1        ;   в EDX:EAX
dividnd_pos: OR      EBX, EBX            ; делитель отрицательный ?
             JNS     divisor_pos         ; нет, ->
             NOT     EBX                 ; меняем знак
             NEG     ECX                 ;  делителя
             SBB     EBX, byte -1        ;   в EBX:ECX
divisor_pos: MOV     ESI, ECX            ; сохранить
             MOV     EDI, EBX            ;  делитель
             JNZ     big_divisor         ; делитель > 0FFFFFFFFH
             CMP     EDX, ECX            ; необходимо только одно деление ?
             JB      one_div             ; да, одного деления достаточно
             XCHG    EAX, EBX            ; сохранить МЛ делимого в EBX
             XCHG    EAX, EDX            ; взять СТ делимого, загрузить в EDX 0
             DIV     ECX                 ; СТ частного в EAX
             XCHG    EAX, EBX            ; EBX = СТ частного, EAX = МЛ делимого
one_div:     DIV     ECX                 ; EAX = частное МЛ
             MOV     ECX, EDX            ; ECX = остаток МЛ,
             MOV     EDX, EBX            ; EDX = частное СТ
             XOR     EBX, EBX            ; очистить СТ остаток (остаток в EBX:ECX)
             JMP     set_sign            ; присвоить знак
big_divisor: PUSH    EDX                 ; сохранить
             PUSH    EAX                 ;  делимое
scale_down:  SHR     EDX, byte 1         ; масштабировать
             RCR     EAX, byte 1         ;  делитель
             SHR     EBX, byte 1         ;   и
             RCR     ECX, byte 1         ;    делимое до
             JNZ     scale_down          ;     делитель <= 0FFFFFFFFH
             DIV     ECX                 ; вычислить частное
             MOV     ECX, EAX            ; сохранить частное
             MOV     EBX, EAX            ; сохранить частное
             MUL     EDI                 ; частное * делитель СТ
             XCHG    EAX, ECX            ; сохранить результат в ECX, взять частное из EAX
             MUL     ESI                 ; частное * делитель МЛ
             ADD     EDX, ECX            ; EDX:EAX = частное * делитель
             POP     ECX                 ; взять МЛ делимого
             SUB     ECX, EAX            ; МЛ делимое - (частное * делитель)МЛ
             MOV     EAX, EBX            ; взять частное
             POP     EBX                 ; восстановить СТ делимое
             SBB     EBX, EDX            ;  вычесть делитель * частное из делимого
             JNB     remaindr_ok         ; ok если остаток > 0
             ADD     ECX, ESI            ; вычислить
             ADC     EBX, EDI            ;  поточнее остаток (0.095% всех случаев)
             DEC     EAX                 ; поправить частное   
remaindr_ok: XOR     EDX, EDX            ; очистить СТ частного (EAX 7FFFFFFFh)
set_sign:    POPF                        ; остаток отрицательный ?
             JNS     pos_remaind         ; нет, ->
             NOT     EBX                 ; меняем знак
             NEG     ECX                 ;  остатка
             SBB     EBX, byte -1        ;   в EBX:ECX
pos_remaind: POPF                        ; частное отрицательное ?
             JNS     pos_result          ; нет, ->
             NOT     EDX                 ; меняем знак
             NEG     EAX                 ;  частного
             SBB     EDX, byte -1        ;   в EDX:EAX
             OR      EBX, EBX            ; СТ остаток # 0 ?
             JNE     corr_result         ; да, нужна коррекция результата
             OR      ECX, ECX            ; и МЛ остаток = 0 ?
             JZ      pos_result          ; да, тогда коррекция не нужна
corr_result: SUB     EAX, byte 1         ; уменьшить частное
             SBB     EDX, byte 0         ;   на 1
             ADD     ECX, ESI            ; прибавить к остатку
             ADC     EBX, EDI            ;   делитель
pos_result:  POP     EDI                 ; восстановить ранее сохраненные
             POP     ESI                 ;  регистры
             RET                         ; готово

;******************************************************************************-
; 'Sdvig64' выполняет арифметический сдвиг ЦЕЛ64 числа таким образом, что
; знак числа сохраняется, а переполнение не проверяется. Число сдвигов может
; быть произвольным, но в действительности число сдвигов маскируется от 0 до 63.
;
; ДО:         EDX:EAX     аргумент
;             ECX         сдвигов
;
; ПОСЛЕ:      EDX:EAX     результат
;
; РАЗРУШЕНИЕ: ECX
;******************************************************************************-
global  Sdvig64
Sdvig64:
             AND     ECX, ECX            ; сдвигов < 0
             JS      shr64               ; да
             JZ      zeroShl             ; сдвигов = 0
shl64:       AND     ECX, byte 3FH       ; выделяем 5 бит сдвига
             CMP     ECX, byte 32        ; 32 сдвигов или больше ?
             JAE     more32Shl           ; да
             PUSH    EBX                 ; сохранить EBX
             MOV     EBX, EAX            ; сохранить МЛ
             SHL     EDX, CL             ; сдвиг СТ
             SHL     EAX, CL             ; сдвиг МЛ
             NEG     ECX                 ; число невыдвинутых битов это
             ADD     ECX, byte 32        ;  32 - сдвиг
             SHR     EBX, CL             ; получить выдвинутые из МЛ биты
             OR      EDX, EBX            ; вставить их в СТ
             POP     EBX                 ; восстановить EBX
zeroShl:     RET                         ; готово
more32Shl:   MOV     EDX, EAX            ; сдвиг
             XOR     EAX, EAX            ;  на 32 бита
             SUB     ECX, byte 32        ; уже сделали 32 сдвига
             SHL     EDX, CL             ; оставшиеся сдвиги
             RET                         ; готово
shr64:       NEG     ECX                 ; сдвигов = МОД(сдвигов)
             AND     ECX, byte 3FH       ; выделяем 5 бит сдвига
             CMP     ECX, byte 32        ; 32 сдвигов или больше ?
             JAE     more32Shr           ; да
             PUSH    EBX                 ; сохранить EBX
             MOV     EBX, EDX            ; сохранить СТ
             SAR     EDX, CL             ; сдвиг СТ
             SHR     EAX, CL             ; сдвиг МЛ
             NEG     ECX                 ; число невыдвинутых битов это
             ADD     ECX, byte 32        ; 32 - сдвиг
             SHL     EBX, CL             ; получить выдвинутые из СТ биты
             OR      EAX, EBX            ; вставить их в МЛ
             POP     EBX                 ; восстановить EBX
             RET                         ; готово
more32Shr:   MOV     EAX, EDX            ; сдвиг
             CDQ                         ;  на 32 бита
             SUB     ECX, byte 32        ; уже сделали 32 сдвига
             SAR     EAX, CL             ; оставшиеся сдвиги
             RET                         ; готово
