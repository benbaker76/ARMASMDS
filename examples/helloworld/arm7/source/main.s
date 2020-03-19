#include "system.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global main
	
main:
	bl irqInit									@ Initialize Interrupts
	
	ldr r0, =IRQ_VBLANK							@ Interrupts
	bl irqEnable								@ Enable
		
mainLoop:

	bl swiWaitForVBlank
	
	b mainLoop
	
	.pool
	.end
