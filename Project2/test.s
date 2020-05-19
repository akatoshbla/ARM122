.equ SWI_Open, 0x66 @open a file
.equ SWI_Close,0x68 @close a file
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ Stdout, 1 @ Set output target to be Stdout
.equ SWI_Exit, 0x11 @ Stop execution
.equ SWI_PrStr, 0x69
.equ SWI_RdStr,0x6a
.equ SWI_PrInt,0x6b
.global _start
.text

start:
ldr r0,=InFileName
mov r1,#0
swi SWI_Open
ldr r1,=InFileHandle
str r0,[r1]
ldr r1,=FileInput
mov r2,#256
swi SWI_RdStr
ldr r0,=FileInput

loop:
ldrb r2,[r0]
teq r2, #0
beq Exit
add r3,r2,r3
add r0,r0,#1
bal loop

Exit:
mvn r1, r3
and r1, r1, #0x00ff 
mov r0, #Stdout
swi SWI_PrInt
swi SWI_Exit
.data
.align

FileInput: .skip 1024
InFileHandle: .word 0
InFileName: .asciz "udp.dat"
FileOpenInpErrMsg: .asciz "Failed to open input file \n"
EndOfFileMsg: .asciz "End of file reached\n"
ColonSpace: .asciz": "
NL: .asciz "\n "
Message1: .asciz "Project 1 checksum "
.end