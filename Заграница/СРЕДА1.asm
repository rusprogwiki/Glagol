; �������������� ������ ��� ��� �����:
;   ������� ����� �����;
;   �������������� �������� � ������������� �������.

  AREA  |.text|, CODE, ARM

  EXPORT  |.�����.������|
  EXPORT  |.�����.�������|
  EXPORT  |.�����.���32����32|
  EXPORT  |.�����.���32����32|
  EXPORT  |.�����.���32��������|
  EXPORT  |.�����.���32�������|
  EXPORT  |.�����.���32�������|
  EXPORT  |.�����.���32��������|
  EXPORT  |.�����.���32������|
  EXPORT  |.�����.���32�����|
  EXPORT  |.�����.���32������|
  EXPORT  |.�����.���32������|
  EXPORT  |.�����.���32�������|
  EXPORT  |.�����.���32������|
  EXPORT  |.�����.���32������|
  EXPORT  |.�����.���32���������|
  EXPORT  |.�����.���32������|

|.�����.������| PROC
; ����: ������� ����� ����� (FPC).
; ��:
;   r0 - �������  >=0
;   r1 - �������� >=0
; �����:
;   r0 - ������� >=0
;   r1 - ������� >=0 
; ������:
;   r2,r3
  mov   r3,#0
  rsbs  r2,r1,r0,LSR #3
  bcc   Ldiv_3bits
  rsbs  r2,r1,r0,LSR #8
  bcc   Ldiv_8bits
  mov   r1,r1,LSL #8
  orr   r3,r3,#0xFF000000
  rsbs  r2,r1,r0,LSR #4
  bcc   Ldiv_4bits
  rsbs  r2,r1,r0,LSR #8
  bcc   Ldiv_8bits
  mov   r1,r1,LSL #8
  orr   r3,r3,#0x00FF0000
  rsbs  r2,r1,r0,LSR #8
  movcs r1,r1,LSL #8
  orrcs r3,r3,#0x0000FF00
  rsbs  r2,r1,r0,LSR #4
  bcc   Ldiv_4bits
  rsbs  r2,r1,#0
  bcs   Ldiv_by_0
Ldiv_loop
  movcs r1,r1, LSR #8
Ldiv_8bits
  rsbs  r2,r1,r0,LSR #7
  subcs r0,r0,r1,LSL #7
  adc   r3,r3,r3
  rsbs  r2,r1,r0,LSR #6
  subcs r0,r0,r1,LSL #6
  adc   r3,r3,r3
  rsbs  r2,r1,r0,LSR #5
  subcs r0,r0,r1,LSL #5
  adc   r3,r3,r3
  rsbs  r2,r1,r0,LSR #4
  subcs r0,r0,r1,LSL #4
  adc   r3,r3,r3
Ldiv_4bits
  rsbs  r2,r1,r0,LSR #3
  subcs r0,r0,r1,LSL #3
  adc   r3,r3,r3
Ldiv_3bits
  rsbs  r2,r1,r0,LSR #2
  subcs r0,r0,r1,LSL #2
  adc   r3,r3,r3
  rsbs  r2,r1,r0,LSR #1
  subcs r0,r0,r1,LSL #1
  adc   r3,r3,r3
  rsbs  r2,r1,r0
  subcs r0,r0,r1
  adcs  r3,r3,r3
Ldiv_next
  bcs Ldiv_loop
  mov   r1, r0
  mov   r0, r3
  mov   pc, lr
Ldiv_by_0
;  bl     |.�����.�������|
  mov   pc, lr
  ENDP

; ******************************************************************************
|.�����.������| PROC
; ����: �������� ������
; ��:   
;   r0 - �������
;   r1 - ��������
; ������:
;   r2,r3
  STMDB   sp!,{r4,lr}
  ANDS    r4,r1,#0x80000000 ;
  RSBMI   r1,r1,#0          ; r1:=|r1|
  ANDS    r4,r0,#0x80000000 ; r4:=����(r0)
  RSBMI   r0,r0,#0          ; r0:=|r0|
  BL      |.�����.������|
  TST     r4,#0x80000000 
  BEQ     |.�����.������.���| ; ���� ������� > 0, �� ���
  RSB     r0,r0,#0          ; �������=-�������
  CMP     r1,#0             
  SUBNE   r0,r0,#1          ; ���������(�������)
|.�����.������.���|
  LDMIA   sp!,{r4,pc}
  ENDP

; ******************************************************************************
|.�����.�������| PROC
; ����: �������� ������
; ��:   
;   r0 - �������
;   r1 - ��������
; ������:
;   r2,r3
  STMDB   sp!,{r4,r5,lr}
  MOV     r5,r1             ; r5:=r1
  ANDS    r4,r1,#0x80000000 ;
  RSBMI   r1,r1,#0          ; r1:=|r1|
  ANDS    r4,r0,#0x80000000 ; r4:=����(r0)
  RSBMI   r0,r0,#0          ; r0:=|r0|
  BL      |.�����.������|
  MOV     r0,r1             ; r0:=�������
  TST     r4,#0x80000000 
  BEQ     |.�����.�������.���|; ���� ������� > 0, �� KON
  CMP     r0,#0             
  SUBNE   r0,r5,r0          ; �������:=��������-�������
|.�����.�������.���|
  LDMIA   sp!,{r4,r5,pc}
  ENDP

; ******************************************************************************
  AREA  |.rdata|, DATA, READONLY
|countLeadingZerosHigh|
  DCB 0x8,0x7,0x6,0x6,0x5,0x5,0x5,0x5,0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x3,0x3,0x3,0x3
  DCB 0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
  DCB 0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
  DCB 0x2,0x2,0x2,0x2,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
  DCB 0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
  DCB 0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
  DCB 0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
  DCB 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0

  AREA  |.text|, CODE, ARM

|mul32To64| PROC
  stmdb       sp!, {r4 - r9, lr}
  mov         r4, r3
  mov         r5, r2
  mov         r7, r1, lsl #16
  mov         r7, r7, lsr #16
  mov         r6, r0, lsr #16
  mul         lr, r6, r7
  mov         r8, r0, lsl #16
  mov         r8, r8, lsr #16
  mov         r9, r1, lsr #16
  mla         r0, r9, r8, lr
  cmp         r0, lr
  movcc       r1, #1
  movcs       r1, #0
  mov         r3, r1, lsl #16
  add         r2, r3, r0, lsr #16
  mov         r3, r0, lsl #16
  mla         r1, r8, r7, r3
  mla         r2, r9, r6, r2
  cmp         r1, r3
  bcs         |mul32To64.5|
  mov         r3, #1
  add         r3, r3, r2
  str         r1, [r4]
  str         r3, [r5]
  ldmia       sp!, {r4 - r9, pc}
|mul32To64.5|
  mov         r3, #0
  add         r3, r3, r2
  str         r1, [r4]
  str         r3, [r5]
  ldmia       sp!, {r4 - r9, pc}
  ENDP

|estimateDiv64To32| PROC
  stmdb       sp!, {r4 - r10, lr}
  mov         r6, r2
  mov         r8, r1
  mov         r7, r0
  cmp         r6, r7
  mvnls       r0, #0
  ldmlsia     sp!, {r4 - r10, pc}
  mov         r5, r6, lsr #16
  mov         r10, r5, lsl #16
  cmp         r10, r7
  bhi         |estimateDi.6|
  mvn         r3, #0xFF, 24
  eor         r4, r3, #0xFF
  b           |estimateDi.7|
|estimateDi.6|
  mov         r0, r5
  mov         r1, r7
  bl          |.�����.������|
  mov         r4, r0, lsl #16
|estimateDi.7|
  mov         r0, r4, lsl #16
  mov         r0, r0, lsr #16
  mul         r3, r5, r0
  mov         lr, r6, lsl #16
  mov         lr, lr, lsr #16
  mov         r9, r4, lsr #16
  mla         r1, r9, lr, r3
  cmp         r1, r3
  movcc       r3, #1
  movcs       r3, #0
  mov         r3, r3, lsl #16
  add         r2, r3, r1, lsr #16
  mov         r3, r1, lsl #16
  mla         r0, lr, r0, r3
  mla         r2, r9, r5, r2
  cmp         r0, r3
  movcc       r3, #1
  movcs       r3, #0
  cmp         r8, r0
  add         r2, r3, r2
  movcc       r3, #1
  movcs       r3, #0
  sub         r3, r7, r3
  sub         r1, r8, r0
  subs        r0, r3, r2
  bpl         |estimateDi.1|
|estimateDi.2L|
  mov         r2, r1
  add         r3, r1, r6, lsl #16
  cmp         r3, r2
  mov         r1, r3
  movcc       r3, #1
  movcs       r3, #0
  add         r3, r3, r0
  adds        r0, r3, r5
  sub         r4, r4, #1, 16
  bmi         |estimateDi.2L|
|estimateDi.1|
  mov         r3, r0, lsl #16
  orr         r1, r3, r1, lsr #16
  cmp         r10, r1
  bhi         |estimateDi.8|
  mov         r3, #0xFF, 24
  orr         r0, r3, #0xFF
  orr         r0, r0, r4
  ldmia       sp!, {r4 - r10, pc}
|estimateDi.8|
  mov         r0, r5
  bl          |.�����.������|
  orr         r0, r0, r4
  ldmia       sp!, {r4 - r10, pc}
  ENDP

|countLeadingZeros32| PROC
  cmp         r0, #1, 16
  movcc       r0, r0, lsl #16
  mov         r2, #0
  ldr         r3, [pc, #0x1C]
  movcc       r2, #0x10
  cmp         r0, #1, 8
  movcc       r0, r0, lsl #8
  add         r3, r3, r0, lsr #24
  ldrsb       r3, [r3]
  addcc       r2, r2, #8
  add         r0, r3, r2
  mov         pc, lr
  DCD         |countLeadingZerosHigh|
  ENDP

|roundAndPackFloat32| PROC
  mov         r3, r1, lsl #16
  mov         r3, r3, lsr #16
  cmp         r3, #0xFD
  and         r3, r2, #0x7F
  bcc         |roundAndPa.2|
  cmp         r1, #0
  bpl         |roundAndPa.2|
  rsbs        r1, r1, #0
  beq         |roundAndPa.17|
  cmp         r1, #0x20
  bge         |roundAndPa.9|
  rsb         r3, r1, #0
  and         r3, r3, #0x1F
  movs        r3, r2, lsl r3
  beq         |roundAndPa.14|
  mov         r3, #1
  orr         r2, r3, r2, lsr r1
  b           |roundAndPa.17|
|roundAndPa.14|
  mov         r3, #0
  orr         r2, r3, r2, lsr r1
  b           |roundAndPa.17|
|roundAndPa.9|
  cmp         r2, #0
  movne       r2, #1
  moveq       r2, #0
|roundAndPa.17|
  mov         r1, #0
  and         r3, r2, #0x7F
|roundAndPa.2|
  teq         r3, #0x40
  moveq       r3, #1
  movne       r3, #0
  mvn         r3, r3
  add         r2, r2, #0x40
  ands        r2, r3, r2, lsr #7
  moveq       r1, #0
  add         r3, r1, r0, lsl #8
  add         r0, r2, r3, lsl #23
  mov         pc, lr
  ENDP

|.�����.���32����32| PROC
  stmdb       sp!, {r4, r5, lr}
  movs        r4, r0
  moveq       r0, #0
  ldmeqia     sp!, {r4, r5, pc}
  cmp         r4, #2, 2
  moveq       r0, #0xCF, 8
  ldmeqia     sp!, {r4, r5, pc}
  cmp         r4, #0
  bpl         |.�����.���32����32.5|
  rsb         r4, r4, #0
  mov         r0, r4
  mov         r5, #1
  bl          countLeadingZeros32
  sub         r3, r0, #1
  mov         r2, r4, lsl r3
  rsb         r1, r3, #0x9C
  mov         r0, r5
  ldmia       sp!, {r4, r5, lr}
  b           roundAndPackFloat32
|.�����.���32����32.5|
  mov         r0, r4
  mov         r5, #0
  bl          countLeadingZeros32
  sub         r3, r0, #1
  mov         r2, r4, lsl r3
  rsb         r1, r3, #0x9C
  mov         r0, r5
  ldmia       sp!, {r4, r5, lr}
  b           roundAndPackFloat32
  ENDP

|.�����.���32����32| PROC
  stmdb       sp!, {r4, lr}
  mvn         r2, #0xFF, 8
  mov         r3, r0, lsl #1
  eor         r2, r2, #2, 10
  mov         r3, r3, lsr #24
  and         r2, r0, r2
  subs        r4, r3, #0x96
  mov         lr, r0, lsr #31
  bmi         |.�����.���32����32.12|
  cmp         r3, #0x9E
  blt         |.�����.���32����32.11|
  cmp         r0, #0xCF, 8
  beq         |.�����.���32����32.9|
  cmp         lr, #0
  beq         |.�����.���32����32.8|
  cmp         r3, #0xFF
  bne         |.�����.���32����32.9|
  cmp         r2, #0
  beq         |.�����.���32����32.9|
|.�����.���32����32.8|
  mvn         r0, #2, 2
  ldmia       sp!, {r4, pc}
|.�����.���32����32.9|
  mov         r0, #2, 2
  ldmia       sp!, {r4, pc}
|.�����.���32����32.11|
  orr         r3, r2, #2, 10
  mov         r0, r3, lsl r4
  b           |.�����.���32����32.2|
|.�����.���32����32.12|
  cmp         r3, #0x7E
  bge         |.�����.���32����32.5|
  orr         r3, r3, r2
  mov         r0, #0
  b           |.�����.���32����32.4|
|.�����.���32����32.5|
  orr         r1, r2, #2, 10
  rsb         r2, r4, #0
  and         r3, r4, #0x1F
  mov         r0, r1, lsr r2
  mov         r3, r1, lsl r3
|.�����.���32����32.4|
  cmp         r3, #0
  bpl         |.�����.���32����32.2|
  bics        r12, r3, #2, 2
  add         r0, r0, #1
  biceq       r0, r0, #1
|.�����.���32����32.2|
  cmp         lr, #0
  rsbne       r0, r0, #0
  ldmia       sp!, {r4, pc}
  ENDP

|.�����.���32��������| PROC
  mov         r3, r0, lsl #1
  mov         r3, r3, lsr #24
  cmp         r3, #0x96
  bge         |.�����.���32��������.6|
  cmp         r3, #0x7E
  bgt         |.�����.���32��������.4|
  bics        r12, r0, #2, 2
  beq         |.�����.���32��������.6|
  mov         r2, r0, lsr #31
  cmp         r3, #0x7E
  bne         |.�����.���32��������.2|
  mvn         r3, #0xFF, 8
  eor         r3, r3, #2, 10
  tst         r0, r3
  beq         |.�����.���32��������.2|
  rsb         r3, r2, #0
  mov         r3, r3, lsl #31
  add         r0, r3, #0xFE, 10
  mov         pc, lr
|.�����.���32��������.2|
  mov         r0, r2, lsl #31
  mov         pc, lr
|.�����.���32��������.4|
  rsb         r3, r3, #0x96
  mov         r2, #1
  mov         r2, r2, lsl r3
  sub         r1, r2, #1
  add         r3, r0, r2, lsr #1
  tst         r3, r1
  biceq       r3, r3, r2
  bic         r0, r3, r1
|.�����.���32��������.6|
  mov         pc, lr
  ENDP

|addFloat32Sigs| PROC
  stmdb       sp!, {r4 - r6, lr}
  mov         r6, r2
  mov         r3, r0, lsl #1
  mov         r4, r3, lsr #24
  mvn         r3, #0xFF, 8
  mov         lr, r1, lsl #1
  eor         r3, r3, #2, 10
  mov         r5, lr, lsr #24
  and         r0, r0, r3
  and         r3, r1, r3
  sub         lr, r4, r5
  mov         r1, r0, lsl #6
  mov         r0, r3, lsl #6
  cmp         lr, #0
  ble         |addFloat32.43|
  cmp         r5, #0
  subeq       lr, lr, #1
  orrne       r0, r0, #2, 4
  cmp         lr, #0
  beq         |addFloat32.3|
  cmp         lr, #0x20
  bge         |addFloat32.22|
  rsb         r3, lr, #0
  and         r3, r3, #0x1F
  movs        r3, r0, lsl r3
  beq         |addFloat32.27|
  mov         r3, #1
  orr         r0, r3, r0, lsr lr
  b           |addFloat32.3|
|addFloat32.27|
  mov         r3, #0
  orr         r0, r3, r0, lsr lr
  b           |addFloat32.3|
|addFloat32.22|
  cmp         r0, #0
  movne       r0, #1
  bne         |addFloat32.3|
  mov         r0, #0
  b           |addFloat32.3|
|addFloat32.43|
  bpl         |addFloat32.6|
  cmp         r4, #0
  addeq       lr, lr, #1
  orrne       r1, r1, #2, 4
  rsbs        r2, lr, #0
  beq         |addFloat32.40|
  cmp         r2, #0x20
  bge         |addFloat32.32|
  rsb         r3, r2, #0
  and         r3, r3, #0x1F
  movs        r3, r1, lsl r3
  beq         |addFloat32.37|
  mov         r3, #1
  orr         r1, r3, r1, lsr r2
  b           |addFloat32.40|
|addFloat32.37|
  mov         r3, #0
  orr         r1, r3, r1, lsr r2
  b           |addFloat32.40|
|addFloat32.32|
  cmp         r1, #0
  movne       r1, #1
  moveq       r1, #0
|addFloat32.40|
  mov         r4, r5
|addFloat32.3|
  orr         r3, r1, #2, 4
  add         r3, r0, r3
  movs        r2, r3, lsl #1
  sub         r4, r4, #1
  bpl         |$roundAndPack$689|
  add         r4, r4, #1
  mov         r1, r4
  mov         r2, r3
  mov         r0, r6
  ldmia       sp!, {r4 - r6, lr}
  b           roundAndPackFloat32
|addFloat32.6|
  cmp         r4, #0
  add         r3, r0, r1
  bne         |addFloat32.2|
  mov         r2, r3, lsr #6
  rsb         r3, r6, #0
  add         r0, r2, r3, lsl #31
  ldmia       sp!, {r4 - r6, pc}
|addFloat32.2|
  add         r2, r3, #1, 2
|$roundAndPack$689|
  mov         r1, r4
  mov         r0, r6
  ldmia       sp!, {r4 - r6, lr}
  b           roundAndPackFloat32
  ENDP

|subFloat32Sigs| PROC
  stmdb       sp!, {r4 - r7, lr}
  mov         r7, r2
  mov         r3, r0, lsl #1
  mov         r4, r3, lsr #24
  mvn         r3, #0xFF, 8
  mov         lr, r1, lsl #1
  eor         r3, r3, #2, 10
  mov         r6, lr, lsr #24
  and         r0, r0, r3
  and         r3, r1, r3
  sub         lr, r4, r6
  mov         r1, r0, lsl #7
  mov         r0, r3, lsl #7
  cmp         lr, #0
  ble         |subFloat32.44|
  cmp         r6, #0
  subeq       lr, lr, #1
  orrne       r0, r0, #1, 2
  cmp         lr, #0
|$aExpBigger$708|
  beq         |subFloat32.41|
  cmp         lr, #0x20
  bge         |subFloat32.33|
  rsb         r3, lr, #0
  and         r3, r3, #0x1F
  movs        r3, r0, lsl r3
  beq         |subFloat32.38|
  mov         r3, #1
  orr         r0, r3, r0, lsr lr
  orr         r1, r1, #1, 2
  sub         r5, r1, r0
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.38|
  mov         r3, #0
  orr         r0, r3, r0, lsr lr
  orr         r1, r1, #1, 2
  sub         r5, r1, r0
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.33|
  cmp         r0, #0
  beq         |subFloat32.40|
  mov         r0, #1
  orr         r1, r1, #1, 2
  sub         r5, r1, r0
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.40|
  mov         r0, #0
|subFloat32.41|
  orr         r1, r1, #1, 2
  sub         r5, r1, r0
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.44|
  bpl         |subFloat32.8|
  cmp         r4, #0
  addeq       lr, lr, #1
  orrne       r1, r1, #1, 2
  rsbs        r2, lr, #0
|$bExpBigger$710|
  beq         |subFloat32.31|
  cmp         r2, #0x20
  bge         |subFloat32.23|
  rsb         r3, r2, #0
  and         r3, r3, #0x1F
  movs        r3, r1, lsl r3
  beq         |subFloat32.28|
  mov         r3, #1
  orr         r1, r3, r1, lsr r2
  orr         r0, r0, #1, 2
  b           |$bBigger$715|
|subFloat32.28|
  mov         r3, #0
  orr         r1, r3, r1, lsr r2
  orr         r0, r0, #1, 2
  b           |$bBigger$715|
|subFloat32.23|
  cmp         r1, #0
  beq         |subFloat32.30|
  mov         r1, #1
  orr         r0, r0, #1, 2
  b           |$bBigger$715|
|subFloat32.30|
  mov         r1, #0
|subFloat32.31|
  orr         r0, r0, #1, 2
  b           |$bBigger$715|
|subFloat32.8|
  cmp         r4, #0
  moveq       r4, #1
  moveq       r6, #1
  cmp         r1, r0
  bls         |subFloat32.45|
  sub         r5, r1, r0
  mov         r0, r5
|$aBigger$713|
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.45|
  bcs         |subFloat32.5|
|$bBigger$715|
  sub         r5, r0, r1
  mov         r0, r5
  mov         r4, r6
  eor         r7, r7, #1
|$normalizeRoundAndPack$718|
  bl          countLeadingZeros32
  sub         r2, r0, #1
  sub         r3, r4, r2
  sub         r1, r3, #1
  mov         r2, r5, lsl r2
  mov         r0, r7
  ldmia       sp!, {r4 - r7, lr}
  b           roundAndPackFloat32
|subFloat32.5|
  mov         r0, #0
  ldmia       sp!, {r4 - r7, pc}
  ENDP

|.�����.���32�������| PROC
  mov         r2, r0, lsr #31
  cmp         r2, r1, lsr #31
  beq         addFloat32Sigs
  b           subFloat32Sigs
  ENDP

|.�����.���32�������| PROC
  mov         r2, r0, lsr #31
  cmp         r2, r1, lsr #31
  beq         subFloat32Sigs
  b           addFloat32Sigs
  ENDP

|.�����.���32��������| PROC
  stmdb       sp!, {r4 - r9, lr}
  mvn         r4, #0xFF, 8
  eor         r4, r4, #2, 10
  mov         r3, r0, lsl #1
  mov         r2, r1, lsl #1
  eor         lr, r0, r1
  and         r5, r0, r4
  and         r4, r1, r4
  movs        r8, r3, lsr #24
  mov         r7, r2, lsr #24
  mov         r6, lr, lsr #31
  bne         |.�����.���32��������.24|
  cmp         r5, #0
  bne         |.�����.���32��������.4|
|.�����.���32��������.36|
  mov         r0, r6, lsl #31
  ldmia       sp!, {r4 - r9, pc}
|.�����.���32��������.4|
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r3, r0, #8
  mov         r5, r5, lsl r3
  rsb         r8, r3, #1
|.�����.���32��������.24|
  cmp         r7, #0
  bne         |.�����.���32��������.28|
  cmp         r4, #0
  beq         |.�����.���32��������.36|
  mov         r0, r4
  bl          countLeadingZeros32
  sub         r3, r0, #8
  mov         r4, r4, lsl r3
  rsb         r7, r3, #1
|.�����.���32��������.28|
  mov         r3, #0xFF, 8
  orr         r3, r3, #2, 10
  orr         r3, r4, r3
  mov         r1, r3, lsl #8
  orr         r2, r5, #2, 10
  mov         lr, r1, lsl #16
  mov         r3, r2, lsl #7
  mov         lr, lr, lsr #16
  mov         r4, r3, lsr #16
  mul         r2, r4, lr
  mov         r5, r3, lsl #16
  mov         r5, r5, lsr #16
  mov         r9, r1, lsr #16
  mla         r0, r9, r5, r2
  add         r3, r7, r8
  cmp         r0, r2
  sub         r1, r3, #0x7F
  movcc       r3, #1
  movcs       r3, #0
  mov         r3, r3, lsl #16
  add         r2, r3, r0, lsr #16
  mov         r3, r0, lsl #16
  mla         r0, r5, lr, r3
  mla         r2, r9, r4, r2
  cmp         r0, r3
  movcc       r3, #1
  movcs       r3, #0
  cmp         r0, #0
  add         r2, r3, r2
  movne       r3, #1
  moveq       r3, #0
  orr         r2, r3, r2
  movs        r3, r2, lsl #1
  movpl       r2, r3
  subpl       r1, r1, #1
  mov         r0, r6
  ldmia       sp!, {r4 - r9, lr}
  b           roundAndPackFloat32
  ENDP

|.�����.���32������| PROC
  stmdb       sp!, {r4 - r9, lr}
  sub         sp, sp, #8
  mvn         r4, #0xFF, 8
  eor         r4, r4, #2, 10
  mov         r3, r0, lsl #1
  mov         r2, r1, lsl #1
  eor         lr, r0, r1
  and         r5, r0, r4
  and         r4, r1, r4
  mov         r7, r3, lsr #24
  movs        r8, r2, lsr #24
  mov         r9, lr, lsr #31
  bne         |.�����.���32������.27|
  cmp         r4, #0
  bne         |.�����.���32������.7|
  mov         r3, #0x7F, 8
  orr         r2, r3, #2, 10
  rsb         r3, r9, #0
  add         r0, r2, r3, lsl #31
  add         sp, sp, #8
  ldmia       sp!, {r4 - r9, pc}
|.�����.���32������.7|
  mov         r0, r4
  bl          countLeadingZeros32
  sub         r3, r0, #8
  mov         r4, r4, lsl r3
  rsb         r8, r3, #1
|.�����.���32������.27|
  cmp         r7, #0
  bne         |.�����.���32������.31|
  cmp         r5, #0
  bne         |.�����.���32������.5|
  mov         r0, r9, lsl #31
  add         sp, sp, #8
  ldmia       sp!, {r4 - r9, pc}
|.�����.���32������.5|
  mov         r0, r5
  bl          countLeadingZeros32
  sub         r3, r0, #8
  mov         r5, r5, lsl r3
  rsb         r7, r3, #1
|.�����.���32������.31|
  mov         r3, #0xFF, 8
  orr         r3, r3, #2, 10
  orr         r3, r4, r3
  orr         r2, r5, #2, 10
  mov         r6, r3, lsl #8
  mov         r5, r2, lsl #7
  cmp         r6, r5, lsl #1
  sub         r3, r7, r8
  movls       r5, r5, lsr #1
  add         r7, r3, #0x7D
  mov         r0, r5
  mov         r2, r6
  mov         r1, #0
  addls       r7, r7, #1
  bl          estimateDiv64To32
  mov         r4, r0
  and         r3, r4, #0x3F
  cmp         r3, #2
  bhi         |.�����.���32������.3|
  add         r3, sp, #0
  add         r2, sp, #4
  mov         r1, r4
  mov         r0, r6
  bl          mul32To64
  ldr         r3, [sp]
  ldr         r2, [sp, #4]
  cmp         r3, #0
  rsb         r1, r3, #0
  movne       r3, #1
  moveq       r3, #0
  sub         r3, r5, r3
  subs        r0, r3, r2
  bpl         |.�����.���32������.1|
|.�����.���32������.2L|
  mov         r2, r1
  add         r3, r1, r6
  cmp         r3, r2
  mov         r1, r3
  movcc       r3, #1
  movcs       r3, #0
  adds        r0, r0, r3
  sub         r4, r4, #1
  bmi         |.�����.���32������.2L|
|.�����.���32������.1|
  cmp         r1, #0
  beq         |.�����.���32������.11|
  mov         r3, #1
  orr         r4, r3, r4
  mov         r2, r4
  mov         r1, r7
  mov         r0, r9
  bl          roundAndPackFloat32
  add         sp, sp, #8
  ldmia       sp!, {r4 - r9, pc}
|.�����.���32������.11|
  mov         r3, #0
  orr         r4, r3, r4
|.�����.���32������.3|
  mov         r2, r4
  mov         r1, r7
  mov         r0, r9
  bl          roundAndPackFloat32
  add         sp, sp, #8
  ldmia       sp!, {r4 - r9, pc}
  ENDP

|.�����.���32�����| PROC
  cmp         r0, r1
  orrne       r3, r0, r1
  bicnes      r12, r3, #2, 2
  movne       r0, #0
  moveq       r0, #1
  mov         pc, lr
  ENDP

|.�����.���32������| PROC
  mov         r2, r0, lsr #31
  cmp         r2, r1, lsr #31
  beq         |.�����.���32������.1|
  cmp         r2, #0
  bne         |.�����.���32������.8|
  orr         r3, r0, r1
  bics        r12, r3, #2, 2
  bne         |.�����.���32������.14|
|.�����.���32������.8|
  mov         r0, #1
  mov         pc, lr
|.�����.���32������.1|
  cmp         r0, r1
  beq         |.�����.���32������.8|
  movcc       r3, #1
  movcs       r3, #0
  teq         r3, r2
  bne         |.�����.���32������.8|
|.�����.���32������.14|
  mov         r0, #0
  mov         pc, lr
  ENDP

|.�����.���32������| PROC
  mov         r2, r0, lsr #31
  cmp         r2, r1, lsr #31
  beq         |.�����.���32������.1|
  cmp         r2, #0
  beq         |.�����.���32������.8|
  orr         r3, r0, r1
  bics        r12, r3, #2, 2
  b           |.�����.���32������.15|
|.�����.���32������.1|
  cmp         r0, r1
  beq         |.�����.���32������.8|
  movcc       r3, #1
  movcs       r3, #0
  teq         r3, r2
|.�����.���32������.15|
  movne       r0, #1
  movne       pc, lr
|.�����.���32������.8|
  mov         r0, #0
  mov         pc, lr
  ENDP

|.�����.���32�������| PROC
  str         lr, [sp, #-4]!
  bl          |.�����.���32�����|
  cmp         r0, #0
  moveq       r0, #1
  movne       r0, #0
  ldr         pc, [sp], #4
  ENDP

|.�����.���32������| PROC
  str         lr, [sp, #-4]!
  bl          |.�����.���32������|
  cmp         r0, #0
  moveq       r0, #1
  movne       r0, #0
  ldr         pc, [sp], #4
  ENDP

|.�����.���32������| PROC
  str         lr, [sp, #-4]!
  bl          |.�����.���32������|
  cmp         r0, #0
  moveq       r0, #1
  movne       r0, #0
  ldr         pc, [sp], #4
  ENDP

|.�����.���32���������| PROC
  str         lr, [sp, #-4]!
  mov         r1, r0
  mov         r0, #0
  bl          |.�����.���32�������|
  cmp         r0, #0
  moveq       r0, #1
  movne       r0, #0
  ldr         pc, [sp], #4
  ENDP

|.�����.���32������| PROC
  stmdb       sp!, {r4, lr}
  mov         r4, r0
  mov         r1, #0
  bl          |.�����.���32������|
  cmp         r0, #0
  beq         |.�����.���32������.���|
  mov         r1, r4
  mov         r0, #0
  bl          |.�����.���32�������|
  cmp         r0, #0
  moveq       r0, #1
  movne       r0, #0
  ldmia       sp!, {r4, pc}
|.�����.���32������.���|
  mov         r0, r4
  ldmia       sp!, {r4, pc}
  ENDP
  
  END
