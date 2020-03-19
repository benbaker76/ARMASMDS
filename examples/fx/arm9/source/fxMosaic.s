#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxMosaic

fxMosaic:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =IRQ_VBLANK
	ldr r1, =fxMosaicVBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------
	
fxMosaicVBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =mode						@ Read the mode address
	ldr r0, [r0]						@ Read mode value
	
	cmp r0, #0							@ mode 0?
	beq mosaicOut						@ Then branch
	cmp r0, #1							@ mode 1?
	beq mosaicIn						@ Then branch
	
	b fxMosaicDone						@ Done

	@ ---------------------------------------
	
mosaicOut:

	ldr r0, =pos						@ Get our position
	ldrb r1, [r0]

	mov r4, r1, lsr #2					@ Divide by 4 to make value 0-15
	
	ldr r2, =MOSAIC_CR					@ Mosaic register

	mov r3, r4							@ MOSAIC_BG_H
	add r3, r4, lsl #4					@ MOSAIC_BG_V
	strh r3, [r2]						@ Write to MOSAIC_CR
	
	ldr r2, =mode						@ Get mode address
	ldr r3, =1							@ Load 1
	add r1, #1							@ Add 1 to pos
	cmp r1, #64							@ Is our pos 64?
	moveq r1, #0						@ Yes so reset pos
	streq r3, [r2]						@ Yes so write 1 to mode
	strb r1, [r0]						@ Write pos back
	
	b fxMosaicDone

	@ ---------------------------------------
	
mosaicIn:

	ldr r0, =pos						@ Get our position
	ldrb r1, [r0]
	
	ldr r3, =15							@ Subtract from 15 to reverse value
	sub r4, r3, r1, lsr #2				@ Divide by 4 to make value 0-15
	
	ldr r2, =MOSAIC_CR					@ Mosaic register

	mov r3, r4							@ MOSAIC_BG_H
	add r3, r4, lsl #4					@ MOSAIC_BG_V
	strh r3, [r2]						@ Write to MOSAIC_CR
	
	ldr r2, =mode						@ Get mode address
	ldr r3, =0							@ Load 0
	add r1, #1							@ Add 1 to pos
	cmp r1, #64							@ Is our pos 64?
	moveq r1, #0						@ Yes so reset pos
	streq r3, [r2]						@ Yes so write 0 to mode
	strb r1, [r0]						@ Write pos back
	
fxMosaicDone:

	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

	.data
	.align

pos:
	.word 0

mode:
	.word 0
	
	.pool
	.end

