#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global flushCaches
	.global breakPoint
	.global drawDebugString
	.global debugString
	
flushCaches:

	@ This will flush the caches

	eor r0, r0, r0
	mcr p15, 0, r0, c7, c5, 0
	mcr p15, 0, r0, c7, c6, 0
	bx lr
	
breakPoint:

	@ This will trigger a breakpoint in NO$GBA

	bl flushCaches
	mov r11, r11
	bx lr

drawDebugString:

	@ This subroutine will output text to the NO$GBA debug screen
	@ r0 = pointer to null terminated text
	
	ldr r1, =Data					@ Get the data pointer

textLoop:

	stmfd sp!, {r1-r8, lr}
	
	ldrb r2, [r0], #1				@ Read the data and add one
	strb r2, [r1], #1				@ Write to buffer and add one
	cmp r2, #0						@ Null character?
	beq textDone					@ Yes so were done
	bl textLoop

textDone:
	bl drawDebugNo$
	
	ldmfd sp!, {r1-r8, pc}

drawDebugNo$:
	mov r12, r12					@ First ID 
    b drawDebugNo$Done				@ Skip the text section 

	.hword 0x6464					@ Second ID 
	.hword 0						@ Flags

Data:

	.space 120						@ Data

drawDebugNo$Done:

	bx lr							@ Return
	
	.pool
	.data

debugString:

	.string "r8 = %r8% ; r9 = %r9% ; r10 = %r10%\0"
