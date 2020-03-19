#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxRaster
	
fxRaster:

	stmfd sp!, {r0-r6, lr}

	ldr r0, =IRQ_HBLANK
	ldr r1, =fxRasterHBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

fxRasterHBlank:

	stmfd sp!, {r0-r6, lr}

	ldr r0, =sinTable				@ Address of sine table
	
	ldr r2, =sineOffset				@ Sine offset address
	ldr r3, [r2]					@ Sine offset
	
	ldr r4, =REG_BG0HOFS			@ Horizontal scroll register offset
	ldr r5, [r0, r3]				@ Load the sine value offset
	strh r5, [r4]					@ Write it to the scroll register
	
	add r3, #1						@ Add one to the count
	cmp r3, #256					@ Have we reached the end of the sin table?
	moveq r3, #0					@ Yes so reset
	str r3, [r2]					@ Write it back to our sineOffset
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

	.data
	.align

sineOffset:
	.word 0

	.pool
	.end