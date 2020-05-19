@ Programmer: David Kopp
@ Project #: Project 5
@ Class: Comp 122 MW 2pm
@ Description: This program uses the embest board plug in for armsim. The program acts like a safe - left black button locks and right black button will program. 
@              The safe keeps a memory of all the codes and checks them everytime someone tries to unlock. If a code is used when the right black is pressed it will delete it.
@              When entering a new code it is confirmed. Coder's note to self: (Used pc, lr, stack, and some other tricks with conditionals.) 

.equ SWI_SETSEG8, 0x200 @display on 8 Segment
.equ SWI_CheckBlack, 0x202 @check Black button
.equ SWI_CheckBlue, 0x203 @check press Blue button
.equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
.equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD
.equ SEG_A, 0x80 @ patterns for 8 segment display
.equ SEG_B, 0x40 @byte values for each segment
.equ SEG_C, 0x20 @of the 8 segment display
.equ SEG_D, 0x08
.equ SEG_E, 0x04
.equ SEG_F, 0x02
.equ SEG_G, 0x01

ldr r8, =Array @ Top of array
mov r6, r8     @ first code
mov r5, r8     @ second code (confirmation)
mov r7, r8     @ temp holder code traversals
mov r4, #0     @ 0 = unlocked, 1 = locked, 2 = was in programming, 3 = second code in programming, 4 = deletion case, 5 = second code in deletion case
mov r9, #0     @ 0 = no valid codes, 1 = valid codes
mov r1, #0     @ toggle for forget mode
ldr r0, =SEG_G|SEG_E|SEG_D|SEG_C|SEG_B @ Display U
swi SWI_SETSEG8

start:
swi SWI_CheckBlack
cmp r0, #0x01
beq rightbutton
cmp r0, #0x02
beq leftbutton
swi SWI_CheckBlue
cmp r0, #0
blne bluebuttons
b start

leftbutton:
cmp r4, #1
beq trylock
cmp r9, #0
beq start
mov r7, r6
mov r5, r6
mov r4, #1
ldr r0, =SEG_G|SEG_E|SEG_D @ Display L
swi SWI_SETSEG8
b start

trylock:
mov r7, r8
mov r5, r6
reloop:
ldr r2, [r7]
ldr r3, [r5]
cmp r7, r6
beq failcode
cmp r5, r1
beq unlock
cmp r2, #0
beq nextcode
cmp r2, r3
beq nextnum  
b mismatch

mismatch:
mov r5, r6
add r7, r7, #4
ldr r2, [r7]
cmp r2, #0
beq nextcode
cmp r7, r6
beq failcode
b mismatch

nextnum:
add r7, r7, #4
add r5, r5, #4
b reloop

nextcode:
add r7, r7, #4
mov r5, r6
b reloop

unlock:
mov r7, r6
mov r5, r6
mov r4, #0
ldr r0, =SEG_G|SEG_E|SEG_D|SEG_C|SEG_B @ Display U
swi SWI_SETSEG8
b start

failcode:
mov r7, r6
mov r5, r6
b start

bluebuttons:
add sp, sp, #4
str r0, [r7], #4
mov r0, #0
mov r1, r7
stmfd sp!, {r7}
mov pc, lr

rightbutton:
mov r7, r6
cmp r4, #1
beq start
mov r4, #3
ldr r0, =SEG_G|SEG_E|SEG_A|SEG_B|SEG_F @ Display P
swi SWI_SETSEG8
ploop:
swi SWI_CheckBlack
cmp r0, #0x02
beq leftbutton
cmp r0, #0x01
beq checkcase
swi SWI_CheckBlue
cmp r0, #0
blne bluebuttons
b ploop

checkcase:
cmp r4, #4 @ if deleting
moveq r4, #5
moveq r0, #0
streq r0, [r7]
beq pisvalid
cmp r9, #0  @ if there is no codes stored 
beq confirm
mov r0, #0
str r0, [r7] 
mov r1, r7
mov r7, r8
dcloop:
ldr r2, [r7]
ldr r3, [r5]
cmp r7, r8
beq skip
cmp r7, r6
beq dfailcode
skip:
cmp r5, r1
beq delete
cmp r2, #0
beq dnextcode
cmp r2, r3
beq dnextnum  
b dmismatch

dmismatch:
mov r5, r6
add r7, r7, #4
ldr r2, [r7]
cmp r2, #0
beq dnextcode
cmp r7, r6
beq dfailcode
b dmismatch

dnextnum:
add r7, r7, #4
add r5, r5, #4
b dcloop

dnextcode:
add r7, r7, #4
mov r5, r6
b dcloop

delete:
mov r9, r7
mov r7, r1
add r7, r7, #4
mov r5, r7
ldr r0, =SEG_A|SEG_G|SEG_F|SEG_E @ Display F
swi SWI_SETSEG8
mov r4, #4
b ploop

dfailcode:
ldmfd sp!, {r7}
beq confirm

confirm:
mov r0, #0
str r0, [r7], #4
cmp r4, #2  
beq pisvalid 
mov r5, r7
mov r4, #2
ldr r0, =SEG_A|SEG_G|SEG_E|SEG_D @ Display C
swi SWI_SETSEG8
b ploop

pisvalid:
mov r7, r6
cvalid:
ldr r2, [r7]
ldr r3, [r5]
cmp r3, r2
bne error
cmp r2, #0
cmpeq r3, #0
beq addcode
add r7, r7, #4
add r5, r5, #4
b cvalid

addcode:
ldr r0, =SEG_A|SEG_G|SEG_B|SEG_F|SEG_E|SEG_C @ Display A
swi SWI_SETSEG8
cmp r4, #5
moveq r1, r9
beq dczeroed
add r7, r7, #4
mov r6, r7
mov r5, r7
mov r4, #0
mov r9, #1
b start

dczeroed:
mov r0, #0
str r0, [r9], #-4
ldr r2, [r9]
cmp r9, r8
streq r0, [r9]
beq cmemory
cmp r2, #0
beq cback
b dczeroed

cback:
ldr r2, [r9]
cmp r9, r8
beq cforward
cmp r2, #0          
addeq r9, r9, #-4
beq cback
movne r9, #1
movne r7, r6
movne r5, r7
movne r4, #0
bne start

cforward:
add r9, r9, #4
ldr r2, [r9]
cmp r9, r6
moveq r9, #0
moveq r7, r8 
moveq r5, r7 
moveq r6, r7 
moveq r4, #0
beq start
cmp r2, #0
beq cforward
movne r9, #1
movne r7, r6
movne r5, r7
movne r4, #0
bne start


cmemory:
ldr r2, [r9]
cmp r9, r6 
moveq r9, #0
moveq r7, r8
moveq r5, r8
moveq r6, r8
beq start
add r9, r9, #4
cmp r2, #0
beq cmemory
mov r7, r6
mov r5, r6
b start


error:
ldr r0, =SEG_A|SEG_G|SEG_F|SEG_E|SEG_D @ Display E
swi SWI_SETSEG8
mov r7, r6
mov r5, r6
mov r4, #0
cmp r9, #0
movgt r9, #1
b start

.data
.align
Array: