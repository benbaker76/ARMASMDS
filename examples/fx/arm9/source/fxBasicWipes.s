#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxBasicWipes

fxBasicWipes:

	stmfd sp!, {r0-r6, lr}
	
	mov r0, #REG_DISPCNT
	ldr r1, [r0]
	ldr r2, =DISPLAY_WIN0_ON
	orr r1, r2
	str r1, [r0]
	
	ldr r0, =IRQ_VBLANK
	ldr r1, =fxBasicWipesVBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

fxBasicWipesVBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =mode
	ldr r0, [r0]
	cmp r0, #0
	beq rightSideWipe
	cmp r0, #1
	beq downSideWipe
	cmp r0, #2
	beq leftSideWipe
	cmp r0, #3
	beq upSideWipe
	
	bl fxBasicWipesDone
	
	@ ---------------------------------------
	
rightSideWipe:								@ Right side wipe

	ldr r0, =scroll							@ Get our scroll position
	ldr r1, [r0]

	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]

	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	strb r1, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	strb r3, [r2]
	
	ldr r2, =mode
	mov r3, #1
	add r1, #4								@ Speed of the wipe
	cmp r1, #255							@ Switch mode when the wipe is done
	movgt r1, #0
	strgt r3, [r2]
	str r1, [r0]
	bl fxBasicWipesDone
	
	@ ---------------------------------------
	
downSideWipe:

	ldr r0, =scroll							@ Get our scroll position
	ldr r1, [r0]

	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]

	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	strb r1, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	strb r3, [r2]
	
	ldr r2, =mode
	mov r3, #2
	add r1, #4								@ Speed of the wipe
	cmp r1, #192							@ Switch mode when the wipe is done
	movgt r1, #0
	strgt r3, [r2]
	str r1, [r0]
	bl fxBasicWipesDone
	
	@ ---------------------------------------
	
leftSideWipe:

	ldr r0, =scroll							@ Get our scroll position
	ldr r1, [r0]

	ldr r2, =WIN_OUT						@ make bg0 appear outside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ reset the winin reg
	ldr r3, =0
	strh r3, [r2]

	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	sub r4, r3, r1
	strb r4, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	strb r3, [r2]
	
	ldr r2, =mode
	mov r3, #3
	add r1, #4								@ Speed of the wipe
	cmp r1, #255							@ Switch mode when the wipe is done
	movgt r1, #0
	strgt r3, [r2]
	str r1, [r0]
	bl fxBasicWipesDone
	
	@ ---------------------------------------
	
upSideWipe:

	ldr r0, =scroll							@ Get our scroll position
	ldr r1, [r0]

	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]

	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	sub r4, r3, r1
	strb r4, [r2]
	
	ldr r2, =mode
	mov r3, #0
	add r1, #4								@ Speed of the wipe
	cmp r1, #192							@ Switch mode when the wipe is done
	movgt r1, #0
	strgt r3, [r2]
	str r1, [r0]
	
	@ ---------------------------------------

fxBasicWipesDone:

	ldmfd sp!, {r0-r6, pc}

	@ ---------------------------------------

	.data
	.align

scroll:
	.word 0

mode:
	.word 0

	.pool
	.end
