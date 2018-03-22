;************************************************************************
; ������ ����������, ���������� �� ����� ������.   
; ����� ���������������� �������� ���������� ����������
; � ����� � '+' � ����� (������ _Zapusk).
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
; �������� EBP � EIP, ����������  ��� ������ ����������� ������,
; ����� ��� �������������� ����� ������� � ������������ �������.
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
;CW8087: dw 733H ; ����������� ��������, ���������� � -8,
CW8087: dw 333H ; ����������� ��������, ���������� � ����������,
                ; ���������� ��� ������� �� 0 � ������������

segment code public use32 class=CODE

;************************************************************************
; ����� ����� � ����������
;************************************************************************
global _Nachalo
_Nachalo:
             CLD                         ; �������� ���� �����������
             AND     ESP,byte -4         ; ���� �� ������� 4 ����
             MOV     AX,DS               ; ES:=DS �� ���������
             MOV     ES,AX               ; ...
             FNINIT                      ; �������� FPU
             FLDCW   word [CW8087]       ; ��������� FPU
             XOR     EBP,EBP             ; EBP:=0 ��� ������� ������ ������
             MOV     [GlBP],EBP          ; ������� ������������ �����
             MOV     [GlIP],EBP          ; ������� ������������ �����
             CALL    _Zapusk             ; ������ ����������
             XOR     EAX,EAX             ; ����(0)
;************************************************************************
; ����� ������ �� ����������
;************************************************************************
global Stop
Stop:
             PUSH    EAX                 ; ExitProcess(EAX)
             CALL    [ExitProcess]       ; ...

;************************************************************************
; ����� ����� � ���-����������
;************************************************************************
;������* _Nachalo-(hInstance,reason,param:���);
ZADACHA _Nachalo@12
%$hInstance  priem
%$reason     priem
%$param      priem
             PUSH    EBX                 ; ��������� ������������ ��������
             PUSH    ESI                 ; ...
             PUSH    EDI                 ; ...
             MOV     EDI,[EBP+%$hInstance] ; ��������� DPBHInstance
             MOV     [DPBHInstance],EDI  ; ...
             MOV     EDI,[EBP+%$reason]  ; ��������� DPBReason
             MOV     [DPBReason],EDI     ; ...
             MOV     EDI,[EBP+%$param]   ; ��������� DPBParam
             MOV     [DPBParam],EDI      ; ...
             XOR     EBP,EBP             ; EBP:=0 ��� ������� ������ ������
             MOV     [GlBP],EBP          ; ������� ������������ �����
             MOV     [GlIP],EBP          ; ������� ������������ �����
             CALL    _Zapusk             ; ������ ����������
             POP     EDI                 ; ������������ ��������
             POP     ESI                 ; ...
             POP     EBX                 ; ...
             MOV     EAX,1               ; �� � �������
KON _Nachalo@12

;******************************************************************************-
; 'CelChast' ����� ����� ������������� �����
;
; ��:        ST(0)        �����
;
; �����:     ST(0)        ����� �����
;
;******************************************************************************-
global  CelChast
CelChast:
             SUB     ESP,4
             FNSTCW  word [ESP]          ; �������� ��������� FPU
             FNSTCW  word [ESP+2]
             FWAIT
             OR      [ESP+2], word 0F00H ; ���������� � 0, ����������� ��������
             FLDCW   word [ESP+2]
             FRNDINT
             FWAIT
             FLDCW   word [ESP]          ; ����������� ��������� FPU
             ADD     ESP,4
             RET

;******************************************************************************-
; 'ObmenBPIP' ���������� EBP � EIP, ���������� � ����� ��� ��������� 
; ������������ ������, � EBP � EIP, ����������� � ������ ��� ���������
; ������������ ������.
;
; ��:        [EBP]        EBP ������, ��������� ������������ ������
;            [EBP+4]      EIP ������, ��������� ������������ ������
;            [GlBP]       EBP ������, ��������� ����������� ������
;            [GlIP]       EIP ������, ��������� ����������� ������
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
             RET                         ; ������

;******************************************************************************-
; 'Umnojenie64' ��������� ������������ ���� ���64 �������. ��� ������������
; ���64 OF ���� �� ������������ !!
;
; ��:        EDX:EAX      ��������
;            EBX:ECX      ���������
;
; �����:     EDX:EAX      ������������, ���� ��� ������������
;
;******************************************************************************-
global  Umnojenie64
Umnojenie64:
             PUSH    ESI                 ; ��������� ������������
             PUSH    EDI                 ;  ��������
             MOV     EDI, EDX            ; ��������� �� ��������
             OR      EDI, EBX            ; ��� ����� ������������� � <= 0FFFFFFFFH?
             JZ      prostUmn            ; ���������� �������� ���������   
             MOV     EDI, EDX            ; ��������� �� ��������
             MOV     ESI, EAX            ; ��������� �� ��������
             MUL     EBX                 ; ��������� �� * �������� ��
             XCHG    EAX, EDI            ; ��������� ������1 ��, ����� �� ��������
             MUL     ECX                 ; ��������� �� * �������� ��
             XCHG    EAX, ESI            ; ��������� ������2 ��, ����� �� ��������
             ADD     ESI, EDI            ; ������� ������1 � ������2 (��������� ��)
             JO      vyhodUmn            ; ������������
             MUL     ECX                 ; ��������� �� * �������� ��
             ADD     EDX, ESI            ; ������� ������3 �� � ��������� ��
             JMP     vyhodUmn            ; ������
prostUmn:    MUL     ECX                 ; �� �������� * �� ���������
             AND     EAX,EAX             ; ������������ ���
vyhodUmn:    POP     EDI                 ; ������������ ����� �����������
             POP     ESI                 ;  ��������
             RET                         ; ������

;******************************************************************************-
; 'Delenie64' ����� ��� ���64 �����, � �������� ������� � �������.
;
; ��:         EDX:EAX     �������
;             EBX:ECX     ��������
;
; �����:      EDX:EAX     �������
;             EBX:ECX     �������
;
;******************************************************************************-
global  Delenie64
Delenie64:
             PUSH    ESI                 ; ��������� ������������
             PUSH    EDI                 ;  ��������
             XOR     EDX, EBX            ; SF ��� ���� ������� �������������
             PUSHF                       ; ��������� flag
             XOR     EDX, EBX            ; ������� ������������� ?
             PUSHF                       ; SF ��� ���� ������� (� �������) �������������
             JNS     dividnd_pos         ; ���, ->
             NOT     EDX                 ; ������ ����
             NEG     EAX                 ;  ��������
             SBB     EDX, byte -1        ;   � EDX:EAX
dividnd_pos: OR      EBX, EBX            ; �������� ������������� ?
             JNS     divisor_pos         ; ���, ->
             NOT     EBX                 ; ������ ����
             NEG     ECX                 ;  ��������
             SBB     EBX, byte -1        ;   � EBX:ECX
divisor_pos: MOV     ESI, ECX            ; ���������
             MOV     EDI, EBX            ;  ��������
             JNZ     big_divisor         ; �������� > 0FFFFFFFFH
             CMP     EDX, ECX            ; ���������� ������ ���� ������� ?
             JB      one_div             ; ��, ������ ������� ����������
             XCHG    EAX, EBX            ; ��������� �� �������� � EBX
             XCHG    EAX, EDX            ; ����� �� ��������, ��������� � EDX 0
             DIV     ECX                 ; �� �������� � EAX
             XCHG    EAX, EBX            ; EBX = �� ��������, EAX = �� ��������
one_div:     DIV     ECX                 ; EAX = ������� ��
             MOV     ECX, EDX            ; ECX = ������� ��,
             MOV     EDX, EBX            ; EDX = ������� ��
             XOR     EBX, EBX            ; �������� �� ������� (������� � EBX:ECX)
             JMP     set_sign            ; ��������� ����
big_divisor: PUSH    EDX                 ; ���������
             PUSH    EAX                 ;  �������
scale_down:  SHR     EDX, byte 1         ; ��������������
             RCR     EAX, byte 1         ;  ��������
             SHR     EBX, byte 1         ;   �
             RCR     ECX, byte 1         ;    ������� ��
             JNZ     scale_down          ;     �������� <= 0FFFFFFFFH
             DIV     ECX                 ; ��������� �������
             MOV     ECX, EAX            ; ��������� �������
             MOV     EBX, EAX            ; ��������� �������
             MUL     EDI                 ; ������� * �������� ��
             XCHG    EAX, ECX            ; ��������� ��������� � ECX, ����� ������� �� EAX
             MUL     ESI                 ; ������� * �������� ��
             ADD     EDX, ECX            ; EDX:EAX = ������� * ��������
             POP     ECX                 ; ����� �� ��������
             SUB     ECX, EAX            ; �� ������� - (������� * ��������)��
             MOV     EAX, EBX            ; ����� �������
             POP     EBX                 ; ������������ �� �������
             SBB     EBX, EDX            ;  ������� �������� * ������� �� ��������
             JNB     remaindr_ok         ; ok ���� ������� > 0
             ADD     ECX, ESI            ; ���������
             ADC     EBX, EDI            ;  �������� ������� (0.095% ���� �������)
             DEC     EAX                 ; ��������� �������   
remaindr_ok: XOR     EDX, EDX            ; �������� �� �������� (EAX 7FFFFFFFh)
set_sign:    POPF                        ; ������� ������������� ?
             JNS     pos_remaind         ; ���, ->
             NOT     EBX                 ; ������ ����
             NEG     ECX                 ;  �������
             SBB     EBX, byte -1        ;   � EBX:ECX
pos_remaind: POPF                        ; ������� ������������� ?
             JNS     pos_result          ; ���, ->
             NOT     EDX                 ; ������ ����
             NEG     EAX                 ;  ��������
             SBB     EDX, byte -1        ;   � EDX:EAX
             OR      EBX, EBX            ; �� ������� # 0 ?
             JNE     corr_result         ; ��, ����� ��������� ����������
             OR      ECX, ECX            ; � �� ������� = 0 ?
             JZ      pos_result          ; ��, ����� ��������� �� �����
corr_result: SUB     EAX, byte 1         ; ��������� �������
             SBB     EDX, byte 0         ;   �� 1
             ADD     ECX, ESI            ; ��������� � �������
             ADC     EBX, EDI            ;   ��������
pos_result:  POP     EDI                 ; ������������ ����� �����������
             POP     ESI                 ;  ��������
             RET                         ; ������

;******************************************************************************-
; 'Sdvig64' ��������� �������������� ����� ���64 ����� ����� �������, ���
; ���� ����� �����������, � ������������ �� �����������. ����� ������� �����
; ���� ������������, �� � ���������������� ����� ������� ����������� �� 0 �� 63.
;
; ��:         EDX:EAX     ��������
;             ECX         �������
;
; �����:      EDX:EAX     ���������
;
; ����������: ECX
;******************************************************************************-
global  Sdvig64
Sdvig64:
             AND     ECX, ECX            ; ������� < 0
             JS      shr64               ; ��
             JZ      zeroShl             ; ������� = 0
shl64:       AND     ECX, byte 3FH       ; �������� 5 ��� ������
             CMP     ECX, byte 32        ; 32 ������� ��� ������ ?
             JAE     more32Shl           ; ��
             PUSH    EBX                 ; ��������� EBX
             MOV     EBX, EAX            ; ��������� ��
             SHL     EDX, CL             ; ����� ��
             SHL     EAX, CL             ; ����� ��
             NEG     ECX                 ; ����� ������������ ����� ���
             ADD     ECX, byte 32        ;  32 - �����
             SHR     EBX, CL             ; �������� ���������� �� �� ����
             OR      EDX, EBX            ; �������� �� � ��
             POP     EBX                 ; ������������ EBX
zeroShl:     RET                         ; ������
more32Shl:   MOV     EDX, EAX            ; �����
             XOR     EAX, EAX            ;  �� 32 ����
             SUB     ECX, byte 32        ; ��� ������� 32 ������
             SHL     EDX, CL             ; ���������� ������
             RET                         ; ������
shr64:       NEG     ECX                 ; ������� = ���(�������)
             AND     ECX, byte 3FH       ; �������� 5 ��� ������
             CMP     ECX, byte 32        ; 32 ������� ��� ������ ?
             JAE     more32Shr           ; ��
             PUSH    EBX                 ; ��������� EBX
             MOV     EBX, EDX            ; ��������� ��
             SAR     EDX, CL             ; ����� ��
             SHR     EAX, CL             ; ����� ��
             NEG     ECX                 ; ����� ������������ ����� ���
             ADD     ECX, byte 32        ; 32 - �����
             SHL     EBX, CL             ; �������� ���������� �� �� ����
             OR      EAX, EBX            ; �������� �� � ��
             POP     EBX                 ; ������������ EBX
             RET                         ; ������
more32Shr:   MOV     EAX, EDX            ; �����
             CDQ                         ;  �� 32 ����
             SUB     ECX, byte 32        ; ��� ������� 32 ������
             SAR     EAX, CL             ; ���������� ������
             RET                         ; ������
