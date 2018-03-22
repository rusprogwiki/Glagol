;************************************************************************
; Низкоуровневая работа с операционной системой (Win32). Описание см. в ОС.отд.
;************************************************************************

%include "zadacha.mac"

segment code public use32 class=CODE

;************************************************************************ 
;ЗАДАЧА ВызовN-(адр,п1,...:ЦЕЛ):ЦЕЛ;
ZADACHA Zagranica_Vyzov0 
%$adr    priem
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov1 
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov2 
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov3
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov4
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov5
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov6
%$p6     priem
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p6] 
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov7
%$p7     priem
%$p6     priem
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p7] 
        push    dword [ebp+%$p6] 
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov8
%$p8     priem
%$p7     priem
%$p6     priem
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p8] 
        push    dword [ebp+%$p7] 
        push    dword [ebp+%$p6] 
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov9
%$p9     priem
%$p8     priem
%$p7     priem
%$p6     priem
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p9] 
        push    dword [ebp+%$p8] 
        push    dword [ebp+%$p7] 
        push    dword [ebp+%$p6] 
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

ZADACHA Zagranica_Vyzov10
%$p10    priem
%$p9     priem
%$p8     priem
%$p7     priem
%$p6     priem
%$p5     priem
%$p4     priem
%$p3     priem
%$p2     priem
%$p1     priem
%$adr    priem
        push    dword [ebp+%$p10] 
        push    dword [ebp+%$p9] 
        push    dword [ebp+%$p8] 
        push    dword [ebp+%$p7] 
        push    dword [ebp+%$p6] 
        push    dword [ebp+%$p5] 
        push    dword [ebp+%$p4] 
        push    dword [ebp+%$p3] 
        push    dword [ebp+%$p2] 
        push    dword [ebp+%$p1] 
        call    [ebp+%$adr] 
KON 

;************************************************************************
global Zagranica__Zapusk
Zagranica__Zapusk:
        ret
