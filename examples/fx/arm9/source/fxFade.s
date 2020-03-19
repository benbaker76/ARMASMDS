#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxFade

fxFade:

	stmfd sp!, {r0-r6, lr}
		   
	ldr r0, =BLEND_CR
	ldr r1, =(BLEND_SRC_BG0 | BLEND_FADE_BLACK);
	str r1, [r0]
	
	ldr r0, =IRQ_VBLANK
	ldr r1, =fxFadeVBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------
	
fxFadeVBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =mode						@ Read the mode address
	ldr r0, [r0]						@ Read mode value
	
	cmp r0, #0							@ mode 0?
	beq fadeOut							@ Then branch
	cmp r0, #1							@ mode 1?
	beq fadeIn							@ Then branch
	
	b fxFadeDone						@ Done

	@ ---------------------------------------
	
fadeOut:

	ldr r0, =value						@ Get our value
	ldrb r1, [r0]

	mov r4, r1, lsr #2					@ Divide by 4 to make value 0-15
	
	ldr r2, =BLEND_Y					@ Blend register
	strh r4, [r2]						@ Write to BLEND_Y
	
	ldr r2, =mode						@ Get mode address
	ldr r3, =1							@ Load 1
	add r1, #1							@ Add 1 to pos
	cmp r1, #64							@ Is our pos 64?
	moveq r1, #0						@ Yes so reset pos
	streq r3, [r2]						@ Yes so write 1 to mode
	strb r1, [r0]						@ Write pos back
	
	b fxFadeDone

	@ ---------------------------------------
	
fadeIn:

	ldr r0, =value						@ Get our value
	ldrb r1, [r0]
	
	ldr r3, =15							@ Subtract from 15 to reverse value
	sub r4, r3, r1, lsr #2				@ Divide by 4 to make value 0-15
	
	ldr r2, =BLEND_Y					@ Blend register
	strh r4, [r2]						@ Write to BLEND_Y
	
	ldr r2, =mode						@ Get mode address
	ldr r3, =0							@ Load 0
	add r1, #1							@ Add 1 to pos
	cmp r1, #64							@ Is our pos 64?
	moveq r1, #0						@ Yes so reset pos
	streq r3, [r2]						@ Yes so write 0 to mode
	strb r1, [r0]						@ Write pos back
	
fxFadeDone:

	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

	.data
	.align
	
mode:
	.word 0

value:
	.word 0
	
	.pool
	.end
