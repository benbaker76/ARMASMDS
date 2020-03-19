#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"
#include "sprite.h"

	.arm
	.align
	.global initSystem
	.global main

initSystem:
	bx lr

main:
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_ALL_2D			@ All power on
	str r1, [r0]
 
	mov r0, #REG_DISPCNT			@ Main screen to Mode 0 with BG2 active
	ldr r1, =(MODE_0_2D | DISPLAY_SPR_ACTIVE | DISPLAY_SPR_1D_LAYOUT)
	str r1, [r0]
	
	ldr r0, =REG_DISPCNT_SUB		@ Sub screen to Mode 0 with BG0 active
	ldr r1, =(MODE_0_2D | DISPLAY_SPR_ACTIVE | DISPLAY_SPR_1D_LAYOUT)
	str r1, [r0]
 
	ldr r0, =VRAM_A_CR				@ Use this for sprite data
	ldr r1, =(VRAM_ENABLE | VRAM_A_MAIN_SPRITE)
	strb r1, [r0]
	
	ldr r0, =VRAM_D_CR				@ Use this for sprite data
	ldr r1, =(VRAM_ENABLE | VRAM_D_SUB_SPRITE)
	strb r1, [r0]

@ Load the palette into the palette subscreen area and main

	ldr r0, =SpritesPal
	ldr r1, =SPRITE_PALETTE
	ldr r2, =512
	bl dmaCopy
	ldr r1, =SPRITE_PALETTE_SUB
	bl dmaCopy

@ Write the tile data to VRAM

	ldr r0, =SpritesTiles
	ldr r1, =SPRITE_GFX
	ldr r2, =1024
	bl dmaCopy
	ldr r1, =SPRITE_GFX_SUB
	bl dmaCopy
	
@ Clear the OAM (disable all 128 sprites for both screens)

	ldr r0, =ATTR0_DISABLED			@ Set OBJ_ATTRIBUTE0 to ATTR0_DISABLED
	ldr r1, =OAM
	ldr r2, =1024					@ 3 x 16bit attributes + 16 bit filler = 8 bytes x 128 entries in OAM
	bl dmaFillWords
	ldr r1, =OAM_SUB
	bl dmaFillWords
	
@ Write OAM Attributes

@ Draw Sprite 0 on Main Screen

	ldr r0, =OBJ_ATTRIBUTE0(0)
	ldr r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1(0)
	ldr r1, =(OBJ_X(128) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2(0)
	ldr r1, =(0 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 0 on Sub Screen
	
	ldr r0, =OBJ_ATTRIBUTE0_SUB(0)
	ldrh r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1_SUB(0)
	ldr r1, =(OBJ_X(128) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2_SUB(0)
	ldr r1, =(0 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 1 on Main Screen

	ldr r0, =OBJ_ATTRIBUTE0(1)
	ldr r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1(1)
	ldr r1, =(OBJ_X(0) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2(1)
	ldr r1, =(16 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 1 on Sub Screen
	
	ldr r0, =OBJ_ATTRIBUTE0_SUB(1)
	ldrh r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1_SUB(1)
	ldr r1, =(OBJ_X(0) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2_SUB(1)
	ldr r1, =(16 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]

@ This is the loop that will run the scroll demo

loop:

	b loop							@ our main loop

.pool
.end
