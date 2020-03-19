#include "system.h"
#include "video.h"
#include "background.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global irqSet
	.global irqInit
	.global irqEnable
	.global irqDisable
	.global irqClear
	.global irqTable
	
irqSet:

	stmfd sp!, {r2-r5, lr}

	@ r0 - Mask
	@ r1 - Handler
	
	ldr r2, =irqTable					@ Address of the interrupt table
	mov r3, #0							@ Interrupt count
	
irqSetLoop:
	
	mov r4, r2							@ Move our irqTable address
	add r4, r3, lsl #3					@ Add iterator * 8
	add r4, #4							@ Add 4 bytes to skip handler address
	ldr r5, [r4]						@ Read irq mask entry
	cmp r5, #0							@ Is mask empty?
	beq irqSetFound						@ yes so we found one
	cmp r5, r0							@ Is mask already there?
	beq irqSetFound						@ Yes so we found one
	
	add r3, #1							@ Add one to our iterator
	cmp r3, #MAX_INTERRUPTS				@ Have we reached our maximum number of interrupts?
	bne irqSetLoop						@ No so Loop
	
	b irqSetDone						@ No spare slot found so return
	
irqSetFound:

	str r0, [r4]						@ Write the mask to our mask entry
	sub r4, #4							@ Sub 4 bytes for handler address
	str r1, [r4]						@ Write the handler address
	
irqSetDone:
	
	ldmfd sp!, {r2-r5, pc}				@ Return
	
	@ ---------------------------------------------

irqInit:

	stmfd sp!, {r0-r5, lr}

	ldr r0, =irqDummy					@ Dummy irq handler
	mov r1, #0							@ Our mask
	ldr r2, =irqTable					@ Address of the interrupt table
	mov r3, #0							@ Interrupt count
	
irqInitLoop:
	
	mov r4, r2							@ Move our irqTable address
	add r4, r3, lsl #3					@ Add iterator * 8
	str r0, [r4]						@ Write the handler address
	add r4, #4							@ Sub 4 bytes for handler address
	str r1, [r4]						@ Write the mask
	
	add r3, #1							@ Add one to our iterator
	cmp r3, #MAX_INTERRUPTS				@ Have we reached our maximum number of interrupts?
	bne irqInitLoop						@ No so Loop

	ldr r0, =IRQ_HANDLER				@ The location of the Irq handler address
	ldr r1, =IntrMain					@ Our Irq handler
	str r1, [r0]						@ Write it
	
	ldr r0, =REG_IE						@ Reset REG_IE
	mov r1, #0							@ To zero
	str r1, [r0]						@ Write it
	
	ldr r0, =REG_IF						@ Write to REG_IF
	mov r1, #IRQ_ALL					@ IRQ_ALL
	str r1, [r0]						@ Write it
	
	ldr r0, =REG_IME					@ REG_IME
	mov r1, #1							@ 1
	str r1, [r0]						@ Write it
	
	ldmfd sp!, {r0-r5, pc}
	
	@ ---------------------------------------------
	
	@ r0 - Mask
	
irqEnable:

	stmfd sp!, {r1-r3, lr}

	ldr r1, =REG_DISPSTAT				@ Load REG_DISPSTAT
	ldr r2, [r1]						@ Read value
	
	ldr r3, =DISP_VBLANK_IRQ			@ VBlank
	tst r0, #IRQ_VBLANK					@ Set?
	orrne r2, r3						@ Or in DISP_VBLANK_IRQ
	
	ldr r3, =DISP_HBLANK_IRQ			@ HBlank
	tst r0, #IRQ_HBLANK					@ Set?
	orrne r2, r3						@ Or in DISP_HBLANK_IRQ
	
	ldr r3, =DISP_YTRIGGER_IRQ			@ VCount
	tst r0, #IRQ_VCOUNT					@ Set?
	orrne r2, r3						@ Or in DISP_YTRIGGER_IRQ
	
	str r2, [r1]						@ Write back to REG_DISPSTAT
	
	ldr r1, =REG_IE						@ Load REG_IE
	ldr r2, [r1]						@ Read value
	orr r2, r0							@ Or in the mask
	str r2, [r1]						@ Write it back

	ldmfd sp!, {r1-r3, pc}
	
	@ ---------------------------------------------
	
	@ r0 - Mask
	
irqDisable:

	stmfd sp!, {r0-r3, lr}

	ldr r1, =REG_DISPSTAT				@ Load REG_DISPSTAT
	ldr r2, [r1]						@ Read value
	
	ldr r3, =~DISP_VBLANK_IRQ			@ VBlank
	tst r0, #IRQ_VBLANK					@ Set?
	andne r2, r3						@ Unset
	
	ldr r3, =~DISP_HBLANK_IRQ			@ HBlank
	tst r0, #IRQ_HBLANK					@ Set?
	andne r2, r3						@ Unset
	
	ldr r3, =~DISP_YTRIGGER_IRQ			@ VCount
	tst r0, #IRQ_VCOUNT					@ Set?
	andne r2, r3						@ Unset
	
	str r2, [r1]						@ Write back to REG_DISPSTAT
	
	ldr r1, =REG_IE						@ Load REG_IE
	ldr r2, [r1]						@ Read value
	bic r2, r0							@ And Not mask
	str r2, [r1]						@ Write it back

	ldmfd sp!, {r0-r3, pc}
	
	@ ---------------------------------------------
	
irqClear:

	stmfd sp!, {r1-r5, lr}

	@ r0 - Mask
	
	ldr r2, =irqTable					@ Address of the interrupt table
	mov r3, #0							@ Interrupt count
	
irqClearLoop:
	
	mov r4, r2							@ Move our irqTable address
	add r4, r3, lsl #3					@ Add iterator * 8
	add r4, #4							@ Add 4 bytes to skip handler address
	ldr r5, [r4]						@ Read irq mask entry
	cmp r5, r0							@ Is mask already there?
	beq irqClearFound					@ Yes so we found one
	
	add r3, #1							@ Add one to our iterator
	cmp r3, #MAX_INTERRUPTS				@ Have we reached our maximum number of interrupts?
	bne irqClearLoop					@ No so Loop
	
	ldmfd sp!, {r1-r5, pc}				@ No spare slot found so return
	
irqClearFound:

	bl irqDisable

	ldr r2, =irqDummy					@ Get a dummy address
	str r1, [r4]						@ Write the the dummy address
	
	ldmfd sp!, {r1-r5, pc}				@ Return
	
irqDummy:

	bx lr
	
#ifdef ARM7
	.text
#endif

#ifdef ARM9
	.section .itcm
#endif
	
	.data
	.align
	
irqTable:
	.space (MAX_INTERRUPTS * 8)			@ MAX_INTERRUPTS * (32 bit handler + 32 bit mask)

	.pool
	.end
	
