;************************************************************************
; �������������� ������ �� ����������. �������� ��. � ���.���.
;************************************************************************

%include "zadacha.mac"

section .bss
PamSluch resd 1

section .text

;************************************************************************
;������ �������-(x:���);
ZADACHA Asm_SluchNach
%$x priem
        MOV     EAX,[EBP+%$x]
        MOV     [PamSluch],EAX
KON Asm_SluchNach

;************************************************************************
;������ �������-():���;
ZADACHA Asm_SluchCjel
        IMUL    EAX,[PamSluch],08088405H
        INC     EAX
        MOV     [PamSluch],EAX
KON Asm_SluchCjel

;************************************************************************
;������ sin-(x:���64):���64;
ZADACHA Asm_sin
%$x priem 8
        FLD     qword [EBP+%$x]
        FSIN
KON Asm_sin

;************************************************************************
;������ cos-(x:���64):���64;
ZADACHA Asm_cos
%$x priem 8
        FLD     qword [EBP+%$x]
        FCOS
KON Asm_cos

;************************************************************************
;������ sincos-(x:���64; sinX+,cosX+:���64);
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
;������ arctg-(x:���64):���64;
ZADACHA Asm_arctg
%$x    priem 8
        FLD     qword [EBP+%$x]
        FLD1
        FPATAN
KON Asm_arctg

;************************************************************************
;������ ln-(x:���64):���64;
ZADACHA Asm_ln
%$x priem 8
        FLDLN2
        FLD     qword [EBP+%$x]
        FYL2X
KON Asm_ln

;************************************************************************
;������ �����-(x:���64):���64;
ZADACHA Asm_kvkor
%$x priem 8
        FLD     qword [EBP+%$x]
        FSQRT
KON Asm_kvkor

;************************************************************************
;������ exp-(x:���64):���64;
;  e^x=2^(x.log2(e))=2^z               
;  2^z=2^�z.2^�z, ��� �z=��������(z) � �z=������(z)    
ZADACHA Asm_exp
%$x priem 8
%define cz2 EBP-14 ; �z^2                 ; st(0)         | st(1)  |          
%define cz  EBP-4  ; �z                   ;---------------+--------|          
        FLDL2E                            ; log2(e)       |        |     
        FLD     qword [EBP+%$x]           ; x             | log2(e)|         
        FMULP   st1, st0                  ; z:=x.log2(e)  |        |     
        MOV     [cz2],   dword 00000000H  ;               |        |
        MOV     [cz2+4], dword 80000000H  ;               |        |
        FIST    dword [cz]                ;               |        |
        FISUB   dword [cz]                ; �z:=z-�z      |        |
        MOV     EAX, [cz]                 ;               |        |
        ADD     EAX, 00003FFFH            ;               |        |
        MOV     [cz2+8], EAX ; cz2:=2^�z  ;               |        | 
        F2XM1                             ; 2^�z-1        |        |
        FLD1                              ; 1             | 2^�z-1 |
        FADDP   st1, st0                  ; 2^�z          |        |               
        FLD     tword [cz2]               ; 2^�z          | 2^�z   |
        FMULP   st1, st0                  ; e^x:=2^�z.2^�z|        |                             
KON Asm_exp

;************************************************************************
_Stepen10:
; -> FST(0)  X
; -> EAX     N
; <- FST(0)  X * 10^N
; ��� ������������ ��������� 10^N ��������� �� ������, ��� ��� ���������.
; ��� N < 32 ��������� ������ �� ������������.
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
;������ ������-(x:���64; ����:���; �����+:����);
;* ��������� <x> � ���������� �������������
;******************************************************************************
;* ��:    <x>     - �������� ����� (0 <= x < 10)
;*        <����>  - ��������� ���� ����� �������
;*        ��(<�����>) ������ ���� ������ <����> � ������ 18 !!
;* �����: <�����[0]> - ������� <x>
;*        <�����[1]> - ������� <x>
;*        <�����[2..����]> - ����� <x> ����� �������   
ZADACHA Asm_VCifry
%$cifry   priem
%$dlcifry priem
%$cifr    priem
%$x       priem 8
      FLD     qword [EBP+%$x]    ; FST(0)  X,  0 <= X < 10.0
      MOV     ECX, [EBP+%$cifr]  ; ECX:=����
      MOV     EDI, [EBP+%$cifry] ; EDI:=���(�����)
      SUB     ESP, byte 10     ; ��� bcd:��� 10 �� ������
      MOV     word [EDI], '0'  ; �����[0] := '0';
      FMUL    qword [.1.E17]   ; X:=��������(X*1.e17);
      FRNDINT
      FCOM    qword [.1.E18]   ; ���� X >= 1.e18 ��
      FSTSW   AX
      SAHF
      JB      .1
      FSUB    qword [.1.E18]   ; X:=X-1.e18;
      MOV     word [EDI], '1'  ; �����[0]:='1';
.1:
      INC     EDI              ; �������� 1-� �����
      INC     EDI              ; �������� 1-� �����
      FBSTP   tword [ESP]      ; ���������� ����������� BCD ����� � bcd
      MOV     EDX, 8
.2:
      MOVZX   EAX, byte [ESP+EDX] ; ������������� 18 BCD ���� �� 9 ����
      MOV     EBX, EAX            ; � 9 ���� (18 ����)
      SHR     EAX, byte 4
      AND     EBX, byte 0FH
      ADD     EAX, byte '0'
      ADD     EBX, byte '0'
      STOSW
      MOV     EAX, EBX
      STOSW
      DEC     EDX
      JNS     .2
      SUB     ECX, byte 18     ; ����� �� ������� ���� <����> ����
      JL      .3               ; � �� ����� 18 ����
      MOV     AX, '0'          ; ���� ����� ������������,  �� ��������� 0-��
      REP     STOSW
      JMP     .5               ; � ��� �� ����� ������ ����������
.3:
      ADD     EDI, ECX         ; ��������� EDI �� ����� ����������
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
;������ �������-(x+:���64):���;
;* �������� �������� � ������� � ����� <x>
;************************************************************************
;* ��:    <x> - �������� �����
;* �����: <x> - �������� <x>
;* �����: ������� <x>   
ZADACHA Asm_Porjadok
%$x priem
      MOV     ESI, [EBP+%$x]
      FLD     qword [ESI]
      SUB     ESP, byte 12 ; ����������� ~80 ���
      XOR     EBX, EBX
.norm:                    ; ���� ��� ��������������
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
      ADD     ESP, byte 12 ; ���������� ������
      MOV     EAX, EBX
; EAX ���������� ������� 10
; FST(0)  X / 10^eax
      FSTP    qword [ESI]
KON Asm_Porjadok

;************************************************************************
;������ �����������-(x:���64):���; 
;* ���������� ��������� <x>
;************************************************************************
;* �����: {�����=0,���������=1,��������=2,�������=3} *)
ZADACHA Asm_Osobjennoste
%$x priem 8
      SUB     ESP, byte 12 ; ����������� ~80 ���
      FLD     qword [EBP+%$x]
      FSTP    tword [ESP]  ; ���������� ����� � 80 ���
      XOR     EAX, EAX
      MOV     AX, [ESP+8]
      MOV     EDI, EAX
      SHR     EDI, 15      ; ���� � EDI
      AND     EAX, 7FFFH   ; ������� ���� �� EAX
      CMP     EAX, 7FFFH
      MOV     EAX, 0       ; �����:=�����
      JNE     .vozvrat
      CMP     dword [ESP+4], 80000000H
      MOV     EAX, 3       ; �����:=�������
      JNE     .vozvrat
      DEC     EDI
      MOV     EAX, 2       ; �����:=��������
      JNZ     .vozvrat
      MOV     EAX, 1       ; �����:=���������
.vozvrat:
      ADD     ESP, byte 12 ; ���������� ������
KON Asm_Osobjennoste

;************************************************************************
;������ �����-(�:���; �:���):���;
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
;������ �������������-(�:���; �:���):���;
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
;������ ��������-(�:���; �:���):���;
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
;������ �����64-(�:���64; �:���):���64;
;������ ��������-(�:������; �:���):������;
global Asm_SHirSdvig
Asm_SHirSdvig:
ZADACHA Asm_Sdvig64
%$r      priem
%$h      priem 8
        MOV     ECX, [EBP+%$r]
        MOV     EAX, [EBP+%$h]
        MOV     EDX, [EBP+%$h+4]
        AND     ECX, ECX            ; ������� < 0
        JS      .shr64              ; ��
        JZ      .Kon                ; ������� = 0
.shl64:       
        AND     ECX, byte 3FH       ; �������� 5 ��� ������
        CMP     ECX, byte 32        ; 32 ������� ��� ������ ?
        JAE     .more32Shl          ; ��
        PUSH    EBX                 ; ��������� EBX
        MOV     EBX, EAX            ; ��������� ��
        SHL     EDX, CL             ; ����� ��
        SHL     EAX, CL             ; ����� ��
        NEG     ECX                 ; ����� ������������ ����� ���
        ADD     ECX, byte 32        ;  32 - �����
        SHR     EBX, CL             ; �������� ���������� �� �� ����
        OR      EDX, EBX            ; �������� �� � ��
        POP     EBX                 ; ������������ EBX
        JMP     short .Kon
.more32Shl:   
        MOV     EDX, EAX            ; �����
        XOR     EAX, EAX            ;  �� 32 ����
        SUB     ECX, byte 32        ; ��� ������� 32 ������
        SHL     EDX, CL             ; ���������� ������
        JMP     short .Kon
.shr64:       
        NEG     ECX                 ; ������� = ���(�������)
        AND     ECX, byte 3FH       ; �������� 5 ��� ������
        CMP     ECX, byte 32        ; 32 ������� ��� ������ ?
        JAE     .more32Shr          ; ��
        PUSH    EBX                 ; ��������� EBX
        MOV     EBX, EDX            ; ��������� ��
        SHR     EDX, CL             ; ����� ��
        SHR     EAX, CL             ; ����� ��
        NEG     ECX                 ; ����� ������������ ����� ���
        ADD     ECX, byte 32        ; 32 - �����
        SHL     EBX, CL             ; �������� ���������� �� �� ����
        OR      EAX, EBX            ; �������� �� � ��
        POP     EBX                 ; ������������ EBX
        JMP     short .Kon
.more32Shr:   
        MOV     EAX, EDX            ; �����
        XOR     EDX, EDX            ;  �� 32 ����
        SUB     ECX, byte 32        ; ��� ������� 32 ������
        SHR     EAX, CL             ; ���������� ������
.Kon:
KON Asm_Sdvig64

;************************************************************************
;������ �������������64-(�:���64; �:���):���64;
;������ ����������������-(�:������; �:���):������;
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
;������ ��������64-(�:���64; �:���):���64;
;������ �����������-(�:������; �:���):������;
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
;������ ��������������-(�����,������:���);
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
;������ �����������-(hInstance+,reason+,param+:���);
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
