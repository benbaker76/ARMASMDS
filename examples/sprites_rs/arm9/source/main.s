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
	ldr r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_ROTSCALE | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1(0)
	ldr r1, =(OBJ_X(128) | ATTR1_ROTDATA(0) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2(0)
	ldr r1, =(0 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 0 on Sub Screen
	
	ldr r0, =OBJ_ATTRIBUTE0_SUB(0)
	ldrh r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_ROTSCALE | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1_SUB(0)
	ldr r1, =(OBJ_X(128) | ATTR1_ROTDATA(0) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2_SUB(0)
	ldr r1, =(0 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 1 on Main Screen

	ldr r0, =OBJ_ATTRIBUTE0(1)
	ldr r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_ROTSCALE | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1(1)
	ldr r1, =(OBJ_X(0) | ATTR1_ROTDATA(1) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2(1)
	ldr r1, =(16 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Draw Sprite 1 on Sub Screen
	
	ldr r0, =OBJ_ATTRIBUTE0_SUB(1)
	ldrh r1, =(OBJ_Y(64) | ATTR0_COLOR_16 | ATTR0_ROTSCALE | ATTR0_SQUARE)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE1_SUB(1)
	ldr r1, =(OBJ_X(0) | ATTR1_ROTDATA(1) | ATTR1_SIZE_32)
	strh r1, [r0]
	ldr r0, =OBJ_ATTRIBUTE2_SUB(1)
	ldr r1, =(16 | ATTR2_PRIORITY(0) | ATTR2_PALETTE(0))
	strh r1, [r0]
	
@ Set the scaling and rotation defaults
	
	ldr r0, =OBJ_ROTATION_HDX(0)
	ldr r1, =OBJ_ROTATION_VDY(0)
	mov r2, #256
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_VDX(0)
	ldr r1, =OBJ_ROTATION_HDY(0)
	mov r2, #0
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_HDX(1)
	ldr r1, =OBJ_ROTATION_VDY(1)
	mov r2, #256
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_VDX(1)
	ldr r1, =OBJ_ROTATION_HDY(1)
	mov r2, #0
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_HDX_SUB(0)
	ldr r1, =OBJ_ROTATION_VDY_SUB(0)
	mov r2, #256
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_VDX_SUB(0)
	ldr r1, =OBJ_ROTATION_HDY_SUB(0)
	mov r2, #0
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_HDX_SUB(1)
	ldr r1, =OBJ_ROTATION_VDY_SUB(1)
	mov r2, #256
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =OBJ_ROTATION_VDX_SUB(1)
	ldr r1, =OBJ_ROTATION_HDY_SUB(1)
	mov r2, #0
	strh r2, [r0]
	strh r2, [r1]

@ This is the loop that will run the scroll demo

loop:

	ldr r0, =REG_VCOUNT
	mov r1, #16
waitVBlank:									
	ldrh r2, [r0]					@ read REG_VCOUNT into r2
	cmp r2, #(SCREEN_HEIGHT + 1)	@ 193 is, of course, the first scanline of vblank
	bne waitVBlank					@ loop if r2 is not equal to (NE condition) 193
	subs r1, r1, #1
	bne waitVBlank
	
	bl rotateSprite

	b loop							@ our main loop
	
	@ This is my attempt at converting the following C code
	@ http://dev-scene.com/NDS/Tutorials/Captain_Apathy/Tiling#Movement_and_Rotation

rotateSprite:

	stmfd sp!, {r0-r6, lr}

	ldr r0, =SIN_bin				@ Load the address of our SIN table
	ldr r1, =COS_bin				@ Load the address of our COS table
	ldr r2, =angle					@ Load the address of angle
	ldrh r3, [r2]					@ Load r3 with the value of angle
	add r3, #1						@ Add one to angle
	cmp r3, #512					@ Compare our angle to 512
	movpl r3, #0					@ If the angle is greater than 512 then set it to zero
	strh r3, [r2]					@ Write it back to angle
	ldr r4, =0x1FF					@ Load our mask to r4
	and r3, r4						@ And our mask with our angle
	lsl r3, #1						@ Multiply by 2? (16 bit SIN data?)
	add r0, r3						@ Add our offset to our SIN table
	add r1, r3						@ Add our offset to our COS table
	ldrsh r2, [r0]					@ Now read the SIN table
	ldrsh r3, [r1]					@ Now read the COS table
	asr r2, #4						@ Right shift the SIN value 4 bits
	mov r6, r2						@ Make a copy of our SIN value (-SIN[angle & 0x1FF] >> 4)
	rsb r2, r2, #0					@ Reverse subtract to make it negative (r2=#0 - r2)
	asr r3, #4						@ Right shift the COS value 4 bits  (c = COS[angle & 0x1FF] >> 4)
	ldr r4, =OBJ_ROTATION_HDX(0)	@ This is the HDX address of the sprite
	ldr r5, =OBJ_ROTATION_HDY(0)	@ This is the HDY address of the sprite
	strh r3, [r4]					@ Write our COS value to HDX (hdx = c)
	strh r6, [r5]					@ Write our SIN value to HDY (hdy = -s)
	ldr r4, =OBJ_ROTATION_VDX(0)	@ This is the VDX address of the sprite
	ldr r5, =OBJ_ROTATION_VDY(0)	@ This is the VDY address of the sprite
	strh r2, [r4]					@ Write our SIN value to VDX (vdx = s)
	strh r3, [r5]					@ Write our COS value to VDY (vdy = c)
	
	ldmfd sp!, {r0-r6, pc} 		@ restore rgisters and return
	
angle:
	.hword 0

.pool
.end
