/******************************************************************************
* file: max_weight.s
* author: Pawan Suresh Bathe (CS18M519)
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Given a series of 32-bit numbers (in hexadecimal form), write and 
  assembly program to determine which element ,in the series,
  has the largest weight and store the number in NUM and its weight in WIEGHT

*/

  @ BSS section
      .bss
      NUM: .word 0 
      WEIGHT: .word 0


  @ DATA SECTION
      .data
  data_start: .word 0xFFFFFFFF ;(1111 1111 1111 1111 1111 1111 1111 1111 – 32)
              .word 0xFFFFF0FF ;(1111 1111 1111 1111 1111 0000 1111 1111 – 28)
              .word 0x205A15E3 ;(0010 0000 0101 1010 0001 0101 1101 0011 – 13)
              .word 0x256C8700 ;(0010 0101 0110 1100 1000 0111 0000 0000 – 11) 
  data_end:   .word 0x295468F2 ;(0010 1001 0101 0100 0110 1000 1111 0010 – 14)


  @ TEXT section
      .text

.globl _main
    

_main:
    LDR R0, = data_start
    LDR R1, = data_end
    MOV R2, #0   ; Current max weight
    MOV R7, #0 ; current max weight number
ITERATE:
        CMP R0, R1 @ if data_start is greater than data_end we have reached to end of list
        BGT EXIT
        LDR R3, [R0], #4 @ load current number in R3
        MOV R4, #0    ; initialize R4 to 0, to hold current weight being counted
        MOV R5, R3    ; keep copy of current number in R5

COUNT_WEIGHT: 
            AND R6, R3, #1  @ AND with MSB 1  
            MOV R3, R3, LSR #1 @ logical Right shift current number 
            ADD R4, R4, R6   @ Add to current weight(R4) value of R6,  R6 = 0 if MSB of R3 was zero else R6=1 
            CMP R3, #0     @ if number is zero, no more set bits stop move to next number , else loop to count weight to inspect next bit
            BNE COUNT_WEIGHT
            CMP R4, R2    @ SWAP current max weight and num if needed
            BGT SWAP  
            B ITERATE     @ Iterate to next number

SWAP:
    MOV R2, R4
    MOV R7, R5
    B ITERATE @ continue to next number


EXIT:
    LDR R8, =WEIGHT       @ to Store WEIGHT
    LDR R9, =NUM          @ to Store NUM
    STR R2, [R8]
    STR R7, [R9]
    SWI 0x11
    .end

