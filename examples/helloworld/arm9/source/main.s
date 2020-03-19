#include "system.h"
#include "video.h"
#include "background.h"
#include "interrupts.h"

	.arm
	.align
	.global initSystem
	.global main

initSystem:
	bx lr

main:
	bl irqInit								@ Initialize Interrupts
	
	ldr r0, =IRQ_VBLANK						@ Interrupts
	bl irqEnable							@ Enable
		
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_ALL_2D					@ All power on
	str r1, [r0]
 
	mov r0, #REG_DISPCNT					@ Main screen to Mode 5 with BG2 active
	ldr r1, =(MODE_0_2D | DISPLAY_BG0_ACTIVE)
	str r1, [r0]
	
	ldr r0, =REG_DISPCNT_SUB				@ Sub screen to Mode 0 with BG0 active
	ldr r1, =(MODE_0_2D | DISPLAY_BG0_ACTIVE)
	str r1, [r0]
 
	ldr r0, =VRAM_A_CR						@ Set VRAM A to be main address 0x06000000
	ldr r1, =(VRAM_ENABLE | VRAM_A_MAIN_BG_0x06000000)
	strb r1, [r0]
	
	ldr r0, =VRAM_C_CR						@ Set VRAM C to be sub bg
	ldr r1, =(VRAM_ENABLE | VRAM_C_SUB_BG_0x06200000)
	strb r1, [r0]
	
	ldr r0, =REG_BG0CNT						@ Set main screen BG2 format to be 256x256x16 bitmap at base address
	ldr r1, =(BG_COLOR_16 | BG_32x32 | BG_MAP_BASE(2) | BG_TILE_BASE(0) | BG_PRIORITY(0))
	strh r1, [r0]
	
	ldr r0, =REG_BG0CNT_SUB					@ Set sub screen format to be tiles
	ldr r1, =(BG_COLOR_16 | BG_32x32 | BG_MAP_BASE(2) | BG_TILE_BASE(0) | BG_PRIORITY(0))
	strh r1, [r0]
	
	mov r0, #0								@ Clear BG0
	ldr r1, =BG_MAP_RAM(2)
	ldr r2, =32*32*2
	bl dmaFillWords
	ldr r1, =BG_MAP_RAM_SUB(2)
	bl dmaFillWords
	
	ldr r0, =fontPal						@ Source
	ldr r1, =BG_PALETTE						@ Dest
	mov r2, #512							@ Size
	bl dmaCopy								@ DMA Copy
	ldr r1, =BG_PALETTE_SUB					@ Dest
	bl dmaCopy								@ DMA Copy

	ldr r0, =fontTiles						@ Source
	ldr r1, =BG_TILE_RAM(0)					@ Dest
	mov r2, #3072							@ Size
	bl dmaCopy								@ DMA Copy
	ldr r1, =BG_TILE_RAM_SUB(0)				@ Dest
	bl dmaCopy								@ DMA Copy
	
	ldr r0, =BG_MAP_RAM(2)					@ make r0 a pointer to map memory
	ldr r1, =BG_MAP_RAM_SUB(2)				@ make r1 a pointer to map memory
	ldr r2, =helloWorldText					@ Get address of text characters to draw
	
drawText:
	ldrb r3, [r2],#1						@ Read r2 [text] and add 1 to [text] offset
	cmp r3, #0								@ Null character?
	beq drawTextDone						@ Yes were done
	sub r3, #32								@ ASCII character - 32 to get tile offset
	strh r3, [r0], #2						@ Write the tile number to our 32x32 map and move along
	strh r3, [r1], #2						@ Write the tile number to our 32x32 map and move along
	b drawText								@ And loop back until done
	
drawTextDone:

mainLoop:

	bl swiWaitForVBlank
	
	b mainLoop
	
helloWorldText:
	.asciz "Hello, world!"
