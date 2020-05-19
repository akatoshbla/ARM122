@ Programmer: David Kopp
@ Project #: Project 1
@ Class: Comp 122 MW 2pm
@ Description: This program opens and reads a string from a file. It then performs an add of the individual bytes in memory.
@					By performing a one's complement and by truncating the result we arrive at a base 10 checksum.

.equ SWI_Open,  0x66 
.equ SWI_Close, 0x68 
.equ SWI_PrStr, 0x69 
.equ SWI_PrInt, 0x6b 
.equ SWI_RdStr, 0x6a 
.equ SWI_RdInt, 0x6c
.equ Stdout, 1 
.equ SWI_Exit,  0x11 
.global _start
.text

_Start:
ldr r0, =InFileName
mov r1, #0
swi SWI_Open
bcs InFileError
ldr r1, =InFileHandle
str r0, [r1]
ldr r1, =MyString
mov r2, #1040
swi SWI_RdStr
ldr r0, =MyString

RLoop:
ldrb r1, [r0]
cmp r1, #0
beq CheckSum
add r3, r1, r3
add r0, r0, #1
b RLoop

CheckSum:
mov r0, #Stdout
ldr r1, =Message1
swi SWI_PrStr
mvn r1, r3
and r1, r1, #0x00ff 
mov r0, #Stdout
swi SWI_PrInt

Exit:
swi SWI_Exit @ stop executing

InFileError:
mov R0, #Stdout
ldr R1, =FileOpenInpErrMsg
swi SWI_PrStr
bal Exit 
.data
.align

MyString: .skip 1040
InFileHandle: .skip 4
InFileName: .asciz "udp.dat"
Message1: .asciz "Your checksum is: "
FileOpenInpErrMsg: .asciz "Failed to open input file \n"
ColonSpace: .asciz": "
NL: .asciz "\n" @ new line
.end