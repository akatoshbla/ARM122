@ Programmer: David Kopp
@ Project #: Project 4
@ Class: Comp 122 MW 2pm
@ Description: This program uses the embest board plug in for armsim. The program uses the LCD, 8-segment display, 
@ the blue buttons, and the black buttons to act like a hex to decimal adder.(Single digit at a time) 
@ The black buttons will reset the lcd, clear the 8-segment display, and the running sum to 0. 

.equ SWI_SETSEG8, 0x200 @display on 8 Segment
.equ SWI_CheckBlack, 0x202 @check Black button
.equ SWI_CheckBlue, 0x203 @check press Blue button
.equ SWI_DRAW_INT, 0x205 @display an int on LCD
.equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
.equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD
.equ SWI_EXIT, 0x11 @terminate program
.equ SEG_A, 0x80 @ patterns for 8 segment display
.equ SEG_B, 0x40 @byte values for each segment
.equ SEG_C, 0x20 @of the 8 segment display
.equ SEG_D, 0x08
.equ SEG_E, 0x04
.equ SEG_F, 0x02
.equ SEG_G, 0x01
.equ SEG_P, 0x10
.equ LEFT_BLACK_BUTTON,0x02 @bit patterns for black buttons
.equ RIGHT_BLACK_BUTTON,0x01 @and for blue buttons
.equ BLUE_KEY_00, 0x01 @button(0)
.equ BLUE_KEY_01, 0x02 @button(1)
.equ BLUE_KEY_02, 0x04 @button(2)
.equ BLUE_KEY_03, 0x08 @button(3)
.equ BLUE_KEY_04, 0x10 @button(4)
.equ BLUE_KEY_05, 0x20 @button(5)
.equ BLUE_KEY_06, 0x40 @button(6)
.equ BLUE_KEY_07, 0x80 @button(7)
.equ BLUE_KEY_08, 1<<8 @button(8) - different way to set
.equ BLUE_KEY_09, 1<<9 @button(9)
.equ BLUE_KEY_10, 1<<10 @button(10)
.equ BLUE_KEY_11, 1<<11 @button(11)
.equ BLUE_KEY_12, 1<<12 @button(12)
.equ BLUE_KEY_13, 1<<13 @button(13)
.equ BLUE_KEY_14, 1<<14 @button(14)
.equ BLUE_KEY_15, 1<<15 @button(15)

Start:

swi SWI_CLEAR_DISPLAY
mov r5, #0
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #16
BL Display8Segment


BBLoop:
swi SWI_CheckBlack @get button press into R0
cmp r0, #LEFT_BLACK_BUTTON
beq Start
cmp r0, #RIGHT_BLACK_BUTTON
beq Start
swi SWI_CheckBlue @get button press into R0
cmp r0, #BLUE_KEY_15
beq HexF
cmp r0, #BLUE_KEY_14
beq HexE
cmp r0, #BLUE_KEY_13
beq HexD
cmp r0, #BLUE_KEY_12
beq HexC
cmp r0, #BLUE_KEY_11
beq HexB
cmp r0, #BLUE_KEY_10
beq HexA
cmp r0, #BLUE_KEY_09
beq Nine
cmp r0, #BLUE_KEY_08
beq Eight
cmp r0, #BLUE_KEY_07
beq Seven
cmp r0, #BLUE_KEY_06
beq Six
cmp r0, #BLUE_KEY_05
beq Five
cmp r0, #BLUE_KEY_04
beq Four
cmp r0, #BLUE_KEY_03
beq Three
cmp r0, #BLUE_KEY_02
beq Two
cmp r0, #BLUE_KEY_01
beq One
cmp r0, #BLUE_KEY_00
beq Zero
bal BBLoop

Zero:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #0
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #0
BL Display8Segment
bal BBLoop

One:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #1
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #1
BL Display8Segment
bal BBLoop

Two:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #2
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #2
BL Display8Segment
bal BBLoop

Three:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #3
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #3
BL Display8Segment
bal BBLoop

Four:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #4
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #4
BL Display8Segment
bal BBLoop

Five:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #5
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #5
BL Display8Segment
bal BBLoop

Six:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #6
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #6
BL Display8Segment
bal BBLoop

Seven:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #7
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #7
BL Display8Segment
bal BBLoop

Eight:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #8
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #8
BL Display8Segment
bal BBLoop

Nine:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #9
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #9
BL Display8Segment
bal BBLoop

HexA:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #10
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #10
BL Display8Segment
bal BBLoop

HexB:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #11
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #11
BL Display8Segment
bal BBLoop

HexC:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #12
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #12
BL Display8Segment
bal BBLoop

HexD:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #13
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #13
BL Display8Segment
bal BBLoop

HexE:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #14
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #14
BL Display8Segment
bal BBLoop

HexF:
mov r0, #5 @clear previous line
swi SWI_CLEAR_LINE
add r5, r5, #15
mov r0, #0
mov r1, #0
mov r2, r5
swi SWI_DRAW_INT
mov r1, #0
mov r0, #15
BL Display8Segment
bal BBLoop

Display8Segment:
stmfd sp! , {r0-r2, lr}
ldr r2, =Digits
ldr r0, [r2, r0, lsl#2]
swi SWI_SETSEG8
ldmfd sp!, {r0-r2, pc}


Digits:
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
.word SEG_B|SEG_C @1
.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
.word SEG_G|SEG_F|SEG_B|SEG_C @4
.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
.word SEG_A|SEG_B|SEG_C @7
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
.word SEG_A|SEG_B|SEG_C|SEG_E|SEG_G|SEG_F @A
.word SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @B
.word SEG_D|SEG_E|SEG_F @C
.word SEG_B|SEG_C|SEG_D|SEG_E|SEG_F @D
.word SEG_A|SEG_F|SEG_D|SEG_E|SEG_G @E
.word SEG_A|SEG_E|SEG_F|SEG_G @F
.word 0 @Blank display