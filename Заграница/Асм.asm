;************************************************************************
; Дополнительные задачи на ассемблере. Описание см. в Асм.отд.
;************************************************************************

%include "zadacha.mac"

section .bss
PamSluch resd 1

section .text

;************************************************************************
;ЗАДАЧА СлучНач-(x:ЦЕЛ);
ZADACHA Asm_SluchNach
%$x priem
        MOV     EAX,[EBP+%$x]
        MOV     [PamSluch],EAX
KON Asm_SluchNach

;************************************************************************
;ЗАДАЧА СлучЦел-():ЦЕЛ;
ZADACHA Asm_SluchCjel
        IMUL    EAX,[PamSluch],08088405H
        INC     EAX
        MOV     [PamSluch],EAX
KON Asm_SluchCjel

;************************************************************************
;ЗАДАЧА sin-(x:ВЕЩ64):ВЕЩ64;
ZADACHA Asm_sin
%$x priem 8
        FLD     qword [EBP+%$x]
        FSIN
KON Asm_sin

;************************************************************************
;ЗАДАЧА cos-(x:ВЕЩ64):ВЕЩ64;
ZADACHA Asm_cos
%$x priem 8
        FLD     qword [EBP+%$x]
        FCOS
KON Asm_cos

;************************************************************************
;ЗАДАЧА sincos-(x:ВЕЩ64; sinX+,cosX+:ВЕЩ64);
ZADACHA Asm_sincos
%$cosX priem
%$sinX priem
%$x    priem 8
        FLD     qword [EBP+%$x]
        MOV     ECX,[EBP+%$cosX]
        MOV     EDX,[EBP+%$sinX]
        FSINCOS
        FSTP    qword [ECX]
        FSTP    qword [EDX]
KON Asm_sincos

;************************************************************************
;ЗАДАЧА arctg-(x:ВЕЩ64):ВЕЩ64;
ZADACHA Asm_arctg
%$x    priem 8
        FLD     qword [EBP+%$x]
        FLD1
        FPATAN
KON Asm_arctg

;************************************************************************
;ЗАДАЧА ln-(x:ВЕЩ64):ВЕЩ64;
ZADACHA Asm_ln
%$x priem 8
        FLDLN2
        FLD     qword [EBP+%$x]
        FYL2X
KON Asm_ln

;************************************************************************
;ЗАДАЧА квкор-(x:ВЕЩ64):ВЕЩ64;
ZADACHA Asm_kvkor
%$x priem 8
        FLD     qword [EBP+%$x]
        FSQRT
KON Asm_kvkor

;************************************************************************
;ЗАДАЧА exp-(x:ВЕЩ64):ВЕЩ64;
;  e^x=2^(x.log2(e))=2^z               
;  2^z=2^дz.2^цz, где дz=ДробнаяЧ(z) и цz=ЦелаяЧ(z)    
ZADACHA Asm_exp
%$x priem 8
%define cz2 EBP-14 ; цz^2                 ; st(0)         | st(1)  |          
%define cz  EBP-4  ; цz                   ;---------------+--------|          
        FLDL2E                            ; log2(e)       |        |     
        FLD     qword [EBP+%$x]           ; x             | log2(e)|         
        FMULP   st1, st0                  ; z:=x.log2(e)  |        |     
        MOV     [cz2],   dword 00000000H  ;               |        |
        MOV     [cz2+4], dword 80000000H  ;               |        |
        FIST    dword [cz]                ;               |        |
        FISUB   dword [cz]                ; дz:=z-цz      |        |
        MOV     EAX, [cz]                 ;               |        |
        ADD     EAX, 00003FFFH            ;               |        |
        MOV     [cz2+8], EAX ; cz2:=2^цz  ;               |        | 
        F2XM1                             ; 2^дz-1        |        |
        FLD1                              ; 1             | 2^дz-1 |
        FADDP   st1, st0                  ; 2^дz          |        |               
        FLD     tword [cz2]               ; 2^цz          | 2^дz   |
        FMULP   st1, st0                  ; e^x:=2^цz.2^дz|        |                             
KON Asm_exp

;************************************************************************
_Stepen10:
; -> FST(0)  X
; -> EAX     N
; <- FST(0)  X * 10^N
; Эта подпрограмма вычисляет 10^N используя не больше, чем два умножения.
; Для N < 32 умножения вообще не используются.
      TEST    EAX, EAX
      JL      .otr
      JE      near .vozvrat
      CMP     EAX, 5120
      JL      .nebesk
      FLD     tword [.besk]
      JMP     .vozvrat
.nebesk:
      MOV     EDX, EAX
      AND     EDX, byte 01FH
      LEA     EDX, [EDX+EDX*4]
      FLD     tword [.tab0+EDX*2]
      FMULP   st1, st0
      SHR     EAX, byte 5
      JE      .vozvrat
      MOV     EDX, EAX
      AND     EDX, byte 0FH
      JE      .bez2umnoj
      LEA     EDX, [EDX+EDX*4]
      FLD     tword [.tab1-10+EDX*2]
      FMULP   st1, st0
.bez2umnoj:
      SHR     EAX, byte 4
      JE      .vozvrat
      LEA     EAX, [EAX+EAX*4]
      FLD     tword [.tab2-10+EAX*2]
      FMULP   st1, st0
      JMP     short .vozvrat
.otr:
      NEG     EAX
      CMP     EAX, 5120
      JL      .nenol
      FLDZ
      JMP     short .vozvrat
.nenol:
      MOV     EDX, EAX
      AND     EDX, byte 01FH
      LEA     EDX, [EDX+EDX*4]
      FLD     tword [.tab0+EDX*2]
      FDIVP   st1, st0
      SHR     EAX, byte 5
      JE      .vozvrat

      MOV     EDX, EAX
      AND     EDX, byte 0FH
      JE      .skip2ndDiv
      LEA     EDX, [EDX+EDX*4]
      FLD     tword [.tab1-10+EDX*2]
      FDIVP   st1, st0
.skip2ndDiv:
      SHR     EAX, byte 4
      JE      .vozvrat

      LEA     EAX, [EAX+EAX*4]
      FLD     tword [.tab2-10+EAX*2]
      FDIVP   st1, st0
.vozvrat:
      RET

.besk:        DW  $00000,$00000,$00000,$08000,$07FFF
.tab0:        DW  $00000,$00000,$00000,$08000,$03FFF ; 10**0
              DW  $00000,$00000,$00000,$0A000,$04002 ; 10**1
              DW  $00000,$00000,$00000,$0C800,$04005 ; 10**2
              DW  $00000,$00000,$00000,$0FA00,$04008 ; 10**3
              DW  $00000,$00000,$00000,$09C40,$0400C ; 10**4
              DW  $00000,$00000,$00000,$0C350,$0400F ; 10**5
              DW  $00000,$00000,$00000,$0F424,$04012 ; 10**6
              DW  $00000,$00000,$08000,$09896,$04016 ; 10**7
              DW  $00000,$00000,$02000,$0BEBC,$04019 ; 10**8
              DW  $00000,$00000,$02800,$0EE6B,$0401C ; 10**9
              DW  $00000,$00000,$0F900,$09502,$04020 ; 10**10
              DW  $00000,$00000,$0B740,$0BA43,$04023 ; 10**11
              DW  $00000,$00000,$0A510,$0E8D4,$04026 ; 10**12
              DW  $00000,$00000,$0E72A,$09184,$0402A ; 10**13
              DW  $00000,$08000,$020F4,$0B5E6,$0402D ; 10**14
              DW  $00000,$0A000,$0A931,$0E35F,$04030 ; 10**15
              DW  $00000,$00400,$0C9BF,$08E1B,$04034 ; 10**16
              DW  $00000,$0C500,$0BC2E,$0B1A2,$04037 ; 10**17
              DW  $00000,$07640,$06B3A,$0DE0B,$0403A ; 10**18
              DW  $00000,$089E8,$02304,$08AC7,$0403E ; 10**19
              DW  $00000,$0AC62,$0EBC5,$0AD78,$04041 ; 10**20
              DW  $08000,$0177A,$026B7,$0D8D7,$04044 ; 10**21
              DW  $09000,$06EAC,$07832,$08786,$04048 ; 10**22
              DW  $0B400,$00A57,$0163F,$0A968,$0404B ; 10**23
              DW  $0A100,$0CCED,$01BCE,$0D3C2,$0404E ; 10**24
              DW  $084A0,$04014,$05161,$08459,$04052 ; 10**25
              DW  $0A5C8,$09019,$0A5B9,$0A56F,$04055 ; 10**26
              DW  $00F3A,$0F420,$08F27,$0CECB,$04058 ; 10**27
              DW  $00984,$0F894,$03978,$0813F,$0405C ; 10**28
              DW  $00BE5,$036B9,$007D7,$0A18F,$0405F ; 10**29
              DW  $04EDF,$00467,$0C9CD,$0C9F2,$04062 ; 10**30
              DW  $02296,$04581,$07C40,$0FC6F,$04065 ; 10**31

.tab1:        DW  $0B59E,$02B70,$0ADA8,$09DC5,$04069 ; 10**32
              DW  $0A6D5,$0FFCF,$01F49,$0C278,$040D3 ; 10**64
              DW  $014A3,$0C59B,$0AB16,$0EFB3,$0413D ; 10**96
              DW  $08CE0,$080E9,$047C9,$093BA,$041A8 ; 10**128
              DW  $017AA,$07FE6,$0A12B,$0B616,$04212 ; 10**160
              DW  $0556B,$03927,$0F78D,$0E070,$0427C ; 10**192
              DW  $0C930,$0E33C,$096FF,$08A52,$042E7 ; 10**224
              DW  $0DE8E,$09DF9,$0EBFB,$0AA7E,$04351 ; 10**256
              DW  $02F8C,$05C6A,$0FC19,$0D226,$043BB ; 10**288
              DW  $0E376,$0F2CC,$02F29,$08184,$04426 ; 10**320
              DW  $00AD2,$0DB90,$02700,$09FA4,$04490 ; 10**352
              DW  $0AA17,$0AEF8,$0E310,$0C4C5,$044FA ; 10**384
              DW  $09C59,$0E9B0,$09C07,$0F28A,$04564 ; 10**416
              DW  $0F3D4,$0EBF7,$04AE1,$0957A,$045CF ; 10**448
              DW  $0A262,$00795,$0D8DC,$0B83E,$04639 ; 10**480

.tab2:        DW  $091C7,$0A60E,$0A0AE,$0E319,$046A3 ; 10**512
              DW  $00C17,$08175,$07586,$0C976,$04D48 ; 10**1024
              DW  $0A7E4,$03993,$0353B,$0B2B8,$053ED ; 10**1536
              DW  $05DE5,$0C53D,$03B5D,$09E8B,$05A92 ; 10**2048
              DW  $0F0A6,$020A1,$054C0,$08CA5,$06137 ; 10**2560
              DW  $05A8B,$0D88B,$05D25,$0F989,$067DB ; 10**3072
              DW  $0F3F8,$0BF27,$0C8A2,$0DD5D,$06E80 ; 10**3584
              DW  $0979B,$08A20,$05202,$0C460,$07525 ; 10**4096
              DW  $059F0,$06ED5,$01162,$0AE35,$07BCA ; 10**4608

;************************************************************************
;ЗАДАЧА ВЦифры-(x:ВЕЩ64; цифр:ЦЕЛ; цифры+:ЦЕПЬ);
;* Переводит <x> в десятичное представление
;******************************************************************************
;* До:    <x>     - исходное число (0 <= x < 10)
;*        <цифр>  - требуется цифр после запятой
;*        ДЛ(<цифры>) должна быть больше <цифр> и больше 18 !!
;* После: <цифры[0]> - десятки <x>
;*        <цифры[1]> - единицы <x>
;*        <цифры[2..цифр]> - цифры <x> после запятой   
ZADACHA Asm_VCifry
%$cifry   priem
%$dlcifry priem
%$cifr    priem
%$x       priem 8
      FLD     qword [EBP+%$x]    ; FST(0)  X,  0 <= X < 10.0
      MOV     ECX, [EBP+%$cifr]  ; ECX:=цифр
      MOV     EDI, [EBP+%$cifry] ; EDI:=адр(цифры)
      SUB     ESP, byte 10     ; ПЕР bcd:РЯД 10 ИЗ ЯЧЕЙКА
      MOV     word [EDI], '0'  ; цифры[0] := '0';
      FMUL    qword [.1.E17]   ; X:=ЦЕЛЧАСТЬ(X*1.e17);
      FRNDINT
      FCOM    qword [.1.E18]   ; ЕСЛИ X >= 1.e18 ТО
      FSTSW   AX
      SAHF
      JB      .1
      FSUB    qword [.1.E18]   ; X:=X-1.e18;
      MOV     word [EDI], '1'  ; цифры[0]:='1';
.1:
      INC     EDI              ; записали 1-ю цифру
      INC     EDI              ; записали 1-ю цифру
      FBSTP   tword [ESP]      ; записываем упакованные BCD цифры в bcd
      MOV     EDX, 8
.2:
      MOVZX   EAX, byte [ESP+EDX] ; распаковываем 18 BCD цифр из 9 байт
      MOV     EBX, EAX            ; в 9 слов (18 байт)
      SHR     EAX, byte 4
      AND     EBX, byte 0FH
      ADD     EAX, byte '0'
      ADD     EBX, byte '0'
      STOSW
      MOV     EAX, EBX
      STOSW
      DEC     EDX
      JNS     .2
      SUB     ECX, byte 18     ; нужно по крайней мере <цифр> цифр
      JL      .3               ; а мы имеем 18 цифр
      MOV     AX, '0'          ; если этого недостаточно,  то добавляем 0-ли
      REP     STOSW
      JMP     .5               ; и нам не нужно делать округления
.3:
      ADD     EDI, ECX         ; указываем EDI на цифру округления
      ADD     EDI, ECX
      CMP     byte [EDI], '5'
      JL      .5
.4:
      DEC     EDI
      DEC     EDI
      INC     byte [EDI]
      CMP     byte [EDI], '9'
      JLE     .5
      MOV     word [EDI], '0'
      JMP     .4
.5:
      ADD     ESP, byte 10
KON Asm_VCifry
.1.E17:      DQ  1.e17
.1.E18:      DQ  1.e18

;************************************************************************
;ЗАДАЧА Порядок-(x+:ВЕЩ64):ЦЕЛ;
;* Выделить мантиссу и порядок у числа <x>
;************************************************************************
;* До:    <x> - исходное число
;* После: <x> - мантисса <x>
;* Ответ: порядок <x>   
ZADACHA Asm_Porjadok
%$x priem
      MOV     ESI, [EBP+%$x]
      FLD     qword [ESI]
      SUB     ESP, byte 12 ; резервируем ~80 бит
      XOR     EBX, EBX
.norm:                    ; цикл для денормализации
      FLD     st0
      FSTP    tword [ESP]
      MOV     AX, [ESP+8]
      TEST    AX, AX
;      TEST    AX, 7FFFH
      JE      .proverit0 ;
.dalshe:
      SUB     AX, 3FFFH
      MOV     DX, 4D10H    ; log10(2) * 2**16
      IMUL    DX
      MOVSX   EAX, DX      ; exp10 = exp2 * log10(2)
      NEG     EAX
      JE      .vozvrat
      SUB     EBX, EAX
      CALL    _Stepen10
      JMP     .norm
.proverit0:
      CMP     dword [ESP+4], byte 0
      JNE     .dalshe
      CMP     dword [ESP+0], byte 0
      JNE     .dalshe
.vozvrat:
      ADD     ESP, byte 12 ; возвращаем память
      MOV     EAX, EBX
; EAX показатель степени 10
; FST(0)  X / 10^eax
      FSTP    qword [ESI]
KON Asm_Porjadok

;************************************************************************
;ЗАДАЧА Особенность-(x:ВЕЩ64):ЦЕЛ; 
;* Определяет состояние <x>
;************************************************************************
;* Ответ: {Число=0,МинусБеск=1,ПлюсБеск=2,НеЧисло=3} *)
ZADACHA Asm_Osobjennoste
%$x priem 8
      SUB     ESP, byte 12 ; резервируем ~80 бит
      FLD     qword [EBP+%$x]
      FSTP    tword [ESP]  ; записываем число в 80 бит
      XOR     EAX, EAX
      MOV     AX, [ESP+8]
      MOV     EDI, EAX
      SHR     EDI, 15      ; знак в EDI
      AND     EAX, 7FFFH   ; убираем знак из EAX
      CMP     EAX, 7FFFH
      MOV     EAX, 0       ; Ответ:=Число
      JNE     .vozvrat
      CMP     dword [ESP+4], 80000000H
      MOV     EAX, 3       ; Ответ:=НеЧисло
      JNE     .vozvrat
      DEC     EDI
      MOV     EAX, 2       ; Ответ:=ПлюсБеск
      JNZ     .vozvrat
      MOV     EAX, 1       ; Ответ:=МинусБеск
.vozvrat:
      ADD     ESP, byte 12 ; возвращаем память
KON Asm_Osobjennoste

;************************************************************************
;ЗАДАЧА Сдвиг-(ч:ЦЕЛ; р:ЦЕЛ):ЦЕЛ;
ZADACHA Asm_Sdvig
%$r      priem
%$h      priem
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        OR      ECX, ECX
        JS      .rOtr
        SHL     EAX, CL
        JMP     .Kon
.rOtr:
        NEG     ECX
        SHR     EAX, CL
.Kon:
KON Asm_Sdvig

;************************************************************************
;ЗАДАЧА ЗнаковыйСдвиг-(ч:ЦЕЛ; р:ЦЕЛ):ЦЕЛ;
ZADACHA Asm_ZnakovyjSdvig
%$r      priem
%$h      priem
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        OR      ECX, ECX
        JS      .rOtr
        SHL     EAX, CL
        JMP     .Kon
.rOtr:
        NEG     ECX
        SAR     EAX, CL
.Kon:
KON Asm_ZnakovyjSdvig

;************************************************************************
;ЗАДАЧА Вращение-(ч:ЦЕЛ; р:ЦЕЛ):ЦЕЛ;
ZADACHA Asm_Vrascjenije
%$r      priem
%$h      priem
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        OR      ECX, ECX
        JS      .rOtr
        ROL     EAX, CL
        JMP     .Kon
.rOtr:
        NEG     ECX
        ROR     EAX, CL
.Kon:
KON Asm_Vrascjenije

;************************************************************************
;ЗАДАЧА Сдвиг64-(ч:ЦЕЛ64; р:ЦЕЛ):ЦЕЛ64;
;ЗАДАЧА ШирСдвиг-(ч:ШИРЦЕЛ; р:ЦЕЛ):ШИРЦЕЛ;
global Asm_SHirSdvig
Asm_SHirSdvig:
ZADACHA Asm_Sdvig64
%$r      priem
%$h      priem 8
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        MOV     EDX, [EBP+%$h+4]
        AND     ECX, ECX            ; сдвигов < 0
        JS      .shr64              ; да
        JZ      .Kon                ; сдвигов = 0
.shl64:       
        AND     ECX, byte 3FH       ; выделяем 5 бит сдвига
        CMP     ECX, byte 32        ; 32 сдвигов или больше ?
        JAE     .more32Shl          ; да
        PUSH    EBX                 ; сохранить EBX
        MOV     EBX, EAX            ; сохранить МЛ
        SHL     EDX, CL             ; сдвиг СТ
        SHL     EAX, CL             ; сдвиг МЛ
        NEG     ECX                 ; число невыдвинутых битов это
        ADD     ECX, byte 32        ;  32 - сдвиг
        SHR     EBX, CL             ; получить выдвинутые из МЛ биты
        OR      EDX, EBX            ; вставить их в СТ
        POP     EBX                 ; восстановить EBX
        JMP     short .Kon
.more32Shl:   
        MOV     EDX, EAX            ; сдвиг
        XOR     EAX, EAX            ;  на 32 бита
        SUB     ECX, byte 32        ; уже сделали 32 сдвига
        SHL     EDX, CL             ; оставшиеся сдвиги
        JMP     short .Kon
.shr64:       
        NEG     ECX                 ; сдвигов = МОД(сдвигов)
        AND     ECX, byte 3FH       ; выделяем 5 бит сдвига
        CMP     ECX, byte 32        ; 32 сдвигов или больше ?
        JAE     .more32Shr          ; да
        PUSH    EBX                 ; сохранить EBX
        MOV     EBX, EDX            ; сохранить СТ
        SHR     EDX, CL             ; сдвиг СТ
        SHR     EAX, CL             ; сдвиг МЛ
        NEG     ECX                 ; число невыдвинутых битов это
        ADD     ECX, byte 32        ; 32 - сдвиг
        SHL     EBX, CL             ; получить выдвинутые из СТ биты
        OR      EAX, EBX            ; вставить их в МЛ
        POP     EBX                 ; восстановить EBX
        JMP     short .Kon
.more32Shr:   
        MOV     EAX, EDX            ; сдвиг
        XOR     EDX, EDX            ;  на 32 бита
        SUB     ECX, byte 32        ; уже сделали 32 сдвига
        SHR     EAX, CL             ; оставшиеся сдвиги
.Kon:
KON Asm_Sdvig64

;************************************************************************
;ЗАДАЧА ЗнаковыйСдвиг64-(ч:ЦЕЛ64; р:ЦЕЛ):ЦЕЛ64;
;ЗАДАЧА ШирЗнаковыйСдвиг-(ч:ШИРЦЕЛ; р:ЦЕЛ):ШИРЦЕЛ;
global Asm_SHirZnakovyjSdvig
Asm_SHirZnakovyjSdvig:
ZADACHA Asm_ZnakovyjSdvig64
extern Sdvig64
%$r      priem
%$h      priem 8
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        MOV     EDX, [EBP+%$h+4]
        CALL    Sdvig64
KON Asm_ZnakovyjSdvig64

;************************************************************************
;ЗАДАЧА Вращение64-(ч:ЦЕЛ64; р:ЦЕЛ):ЦЕЛ64;
;ЗАДАЧА ШирВращение-(ч:ШИРЦЕЛ; р:ЦЕЛ):ШИРЦЕЛ;
global Asm_SHirVrascjenije
Asm_SHirVrascjenije:
ZADACHA Asm_Vrascjenije64
%$r      priem
%$h      priem 8
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        OR      ECX, ECX
        JS      .rOtr
        ROL     EAX, CL
        JMP     .Kon
.rOtr:
        NEG     ECX
        ROR     EAX,CL
.Kon:
KON Asm_Vrascjenije64

;************************************************************************
;ЗАДАЧА ОбнулитьПамять-(адрес,размер:ЦЕЛ);
ZADACHA Asm_ObnulitePamjate
%$razmer priem
%$adres  priem
        MOV     ECX, [EBP+%$razmer]
        MOV     EDI, [EBP+%$adres]
        SHR     ECX, byte 2
        XOR     EAX, EAX
        REP STOSD
KON Asm_ObnulitePamjate

;************************************************************************
;ЗАДАЧА ПриёмникиДПБ-(hInstance+,reason+,param+:ЦЕЛ);
ZADACHA Asm_PrijomnikiDPB
%$param     priem
%$reason    priem
%$hInstance priem
extern  DPBHInstance
extern  DPBReason
extern  DPBParam
        MOV     EAX,[EBP+%$hInstance]
        MOV     EBX,[DPBHInstance]
        MOV     [EAX],EBX         
        MOV     EAX,[EBP+%$reason]
        MOV     EBX,[DPBReason]  
        MOV     [EAX],EBX         
        MOV     EAX,[EBP+%$param] 
        MOV     EBX,[DPBParam]    
        MOV     [EAX],EBX         
KON Asm_PrijomnikiDPB

;************************************************************************
global Asm__Zapusk
Asm__Zapusk:
        RET
