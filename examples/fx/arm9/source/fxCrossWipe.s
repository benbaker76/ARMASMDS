#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxCrossWipe

fxCrossWipe:

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
	ldr r1, =fxCrossWipeVBlank
	
	bl irqSet
	
	ldr r0, =IRQ_HBLANK
	ldr r1, =fxCrossWipeHBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

fxCrossWipeVBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =vtimer								@ Speed of wipe
	ldr r1, [r0]
	add r1, #4
	str r1, [r0]
	
	mov r2, #0
	cmp r1, #248
	strgt r2, [r0]
	
	ldmfd sp!, {r0-r6, pc}

	@ ---------------------------------------
	
fxCrossWipeHBlank:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #16
	bge fxCrossWipeHBlank2
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank2:

	cmp r1, #32
	bge fxCrossWipeHBlank3
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #16
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------

fxCrossWipeHBlank3:
	
	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #48
	bge fxCrossWipeHBlank4
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #32
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank4:

	cmp r1, #64
	bge fxCrossWipeHBlank5
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #48
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank5:

	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #80
	bge fxCrossWipeHBlank6
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #64
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank6:

	cmp r1, #96
	bge fxCrossWipeHBlank7
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #80
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------

fxCrossWipeHBlank7:

	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #112
	bge fxCrossWipeHBlank8
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #96
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank8:

	cmp r1, #128
	bge fxCrossWipeHBlank9
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #112
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank9:

	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #144
	bge fxCrossWipeHBlank10
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #128
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank10:

	cmp r1, #160
	bge fxCrossWipeHBlank11
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #144
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank11:

	ldr r0, =REG_VCOUNT
	ldrb r1, [r0]
	
	cmp r1, #176
	bge fxCrossWipeHBlank12
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #160
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =255
	sub r3, r4
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossWipeHBlank12:

	cmp r1, #192
	bge fxCrossDefault
	
	ldr r2, =WIN_OUT						@ Reset the WIN_OUT reg
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =0
	strh r3, [r2]
	
	ldr r2, =vtimer
	ldr r2, [r2]
	ldr r3, =tip
	sub r1, #176
	ldrb r3, [r3, r1]
	add r4, r2, r3
	
	ldr r2, =WIN0_X0						@ Left pos
	strb r4, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =255
	strb r3, [r2]
	
	b fxCrossWipeDone
	
	@ ---------------------------------------
	
fxCrossDefault:
	
	ldr r2, =WIN0_X0						@ Left pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_X1						@ Right pos
	ldr r3, =0
	strb r3, [r2]

fxCrossWipeDone:

	ldmfd sp!, {r0-r6, pc}

	@ ---------------------------------------

	.data
	.align

vtimer:
	.word 0
	
tip:
	.byte 0, 1, 2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2, 1, 0

	.pool
	.end
