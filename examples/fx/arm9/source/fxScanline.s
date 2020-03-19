#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxScanline

fxScanline:

	stmfd sp!, {r0-r6, lr}
	
	mov r0, #REG_DISPCNT
	ldr r1, [r0]
	ldr r2, =DISPLAY_WIN0_ON
	orr r1, r2
	str r1, [r0]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	strb r3, [r2]
	
	ldr r0, =IRQ_VBLANK
	ldr r1, =fxScanlineVBlank
	
	bl irqSet
	
	ldr r0, =IRQ_HBLANK
	ldr r1, =fxScanlineHBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

fxScanlineVBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =scanx
	ldrb r1, [r0]
	add r1, #3
	strb r1, [r0]
	
	mov r2, #0
	cmp r1, #255
	strgt r2, [r0]

	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------
	
fxScanlineHBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =REG_VCOUNT
	ldrh r1, [r0]
	and r1, #0x1
	
	cmp r1, #0
	bne fxScanlineShow
	
	ldr r2, =WIN0_X0						@ Right pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Left pos
	ldr r3, =scanx
	ldrb r3, [r3]
	strb r3, [r2]
	
	b fxScanlineDone
	
fxScanlineShow:

	ldr r2, =WIN0_X0						@ Right pos
	ldr r3, =255
	ldr r4, =scanx
	ldrb r4, [r4]
	sub r3, r4
	strb r3, [r2]

	ldr r2, =WIN0_X1						@ Left pos
	ldr r3, =255
	strb r3, [r2]
	
fxScanlineDone:

	ldmfd sp!, {r0-r6, pc}

	@ ---------------------------------------

	.data
	.align

scanx:
	.word 0

	.pool
	.end