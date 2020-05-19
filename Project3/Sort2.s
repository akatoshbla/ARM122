@ Programmer: David Kopp
@ Project #: Project 3
@ Class: Comp 122 MW 2pm
@ Description: This program opens and reads a group of ints and stores them into memory. Then the ints are sorted and print into a text file.

.equ SWI_Open,  0x66 
.equ SWI_Close, 0x68  
.equ SWI_PrInt, 0x6b
.equ SWI_PrStr, 0x69
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
ldr r3, =IntArray  @End of the Array after the file in.txt is read
mov r4, r3         @Start of the array
mov r5, r4         @setup for next int pointer
@ldr r6, =IntArray @Current position in array
@ldr r5, =IntArray @Next position in the array
@ldr r7, #0        @Temp
@ldr r8, #0        @Temp for membase to int compare
@mov r9, #0        @Temp position Saved from r6

FileReadLoop:
ldr r0, =InFileHandle
ldr r0, [r0]
swi SWI_RdInt
bcs EofFileReached 
str r0, [r3]
add r3, r3, #4
bal FileReadLoop

TraverseSortLoop:
ldr r6, [r4] @setup for current int pointer at the begining of the IntArray
add r5, r5, #4
ldr r7, [r5]
cmp r5, r3
beq MoveCurrentPointer
cmp r7, r6
blt SwapInts
bal TraverseSortLoop

SwapInts:
ldr r8, [r5]
ldr r9, [r4]
str r8, [r4]
str r9, [r5]
bal TraverseSortLoop

MoveCurrentPointer:
add r4, r4, #4
cmp r4, r3
beq PrintOutputFile
mov r5, r4
bal TraverseSortLoop

EofFileReached:
mov r0, #Stdout
ldr r1, =EndOfFileMsg
swi SWI_PrStr
ldr r0, =InFileHandle 
ldr r0, [r0]
swi SWI_Close
bal TraverseSortLoop

PrintOutputFile:
ldr r0, =OutFileName
mov r1, #1
swi SWI_Open
ldr r2, =IntArray
 

IntPrintLoop:
ldr r1, [r2]
cmp r2, r3
beq FinishSort
swi SWI_PrInt
ldr r1, =NL
swi SWI_PrStr
add r2, r2, #4
bal IntPrintLoop

FinishSort:
swi SWI_Close
mov r0, #Stdout
ldr r1, =MessageFinish
swi SWI_PrStr
bal Exit

Exit:
swi SWI_Exit

InFileError:
mov R0, #Stdout
ldr R1, =FileOpenInpErrMsg
swi SWI_PrStr 
bal Exit
.data
.align

InFileHandle: .skip 4
OutFileHandle: .skip 4
InFileName: .asciz "in.txt"
OutFileName: .asciz "sorted.txt"
MessageFinish: .asciz "Your in.txt file has been sorted! Please see sorted.txt. \n"
FileOpenInpErrMsg: .asciz "Failed to open input file in.txt. \n"
EndOfFileMsg: .asciz "End of file in.txt reached. \n"
ColonSpace: .asciz ": "
NL: .asciz "\n" @ new line
.align
IntArray:
.end