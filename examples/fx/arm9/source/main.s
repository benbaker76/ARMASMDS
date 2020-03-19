#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global initSystem
	.global main

initSystem:
	bx lr

main:
	bl irqInit	
	bl initVideo							@ Initialize Video
	
	@ Comment out the line of the demo you want to see
	
	@bl fxRaster
	@bl fxMosaic
	@bl fxBasicWipes
	@bl fxCrossWipe
	@bl fxFade
	@bl fxScanline
	bl fxSpotlight
	
	ldr r0, =(IRQ_VBLANK | IRQ_HBLANK)
	bl irqEnable
	
mainLoop:

	bl swiWaitForVBlank

	b mainLoop
	
	.pool
	.end
