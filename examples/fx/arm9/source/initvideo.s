#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global initVideo
	
initVideo:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_ALL_2D			@ All power on
	str r1, [r0]
 
	mov r0, #REG_DISPCNT			@ Main screen to Mode 0 with BG0 active
	ldr r1, =(MODE_0_2D | DISPLAY_BG0_ACTIVE)
	str r1, [r0]
	
	ldr r0, =VRAM_A_CR				@ Set VRAM A to be main bg address 0x06000000
	ldr r1, =(VRAM_ENABLE | VRAM_A_MAIN_BG_0x06000000)
	strb r1, [r0]
	
	ldr r0, =VRAM_C_CR				@ Set VRAM C to be sub bg address 0x06200000
	ldr r1, =(VRAM_ENABLE | VRAM_C_SUB_BG_0x06200000)
	strb r1, [r0]
	
	ldr r0, =REG_BG0CNT				@ Set main screen BG0 format to be 32x32 tiles at base address
	ldr r1, =(BG_COLOR_256 | BG_32x32 | BG_MAP_BASE(0) | BG_TILE_BASE(1) | BG_MOSAIC_ON)
	strh r1, [r0]

	@ Load the palette into the palette subscreen area and main

	ldr r0, =picPal
	ldr r1, =BG_PALETTE
	ldr r2, =512
	bl dmaCopy

	@ Write the tile data to VRAM

	ldr r0, =picTiles
	ldr r1, =BG_TILE_RAM(1)
	ldr r2, =41472
	bl dmaCopy

	@ Write map data to map ram

	ldr r0, =picMap
	ldr r1, =BG_MAP_RAM(0)
	ldr r2, =1536
	bl dmaCopy
	
	ldmfd sp!, {r0-r6, pc}
	
	.end
