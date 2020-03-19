#include "system.h"
#include "video.h"
#include "background.h"

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
 
	mov r0, #REG_DISPCNT			@ Main screen to Mode 5 with BG2 active
	ldr r1, =(MODE_5_2D | DISPLAY_BG2_ACTIVE)
	str r1, [r0]
	
	ldr r0, =REG_DISPCNT_SUB		@ Sub screen to Mode 5 with BG2 active
	ldr r1, =(MODE_5_2D | DISPLAY_BG2_ACTIVE)
	str r1, [r0]
 
	ldr r0, =VRAM_A_CR				@ Set VRAM A to be main address 0x06000000
	ldr r1, =(VRAM_ENABLE | VRAM_A_MAIN_BG_0x06000000)
	strb r1, [r0]
	
	ldr r0, =VRAM_C_CR				@ Set VRAM C to be sub address 0x06200000
	ldr r1, =(VRAM_ENABLE | VRAM_C_SUB_BG_0x06200000)
	strb r1, [r0]
	
	ldr r0, =REG_BG2CNT				@ Set main screen BG2 format to be 256x256x16 bitmap at base address
	ldr r1, =(BG_BMP16_256x256 | BG_BMP_BASE(0))
	strh r1, [r0]
	
	ldr r0, =REG_BG2CNT_SUB			@ Set sub screen BG2 format to be 256x256x16 bitmap at base address
	ldr r1, =(BG_BMP16_256x256 | BG_BMP_BASE(0))
	strh r1, [r0]
	
	ldr r0, =REG_BG2PA				@ these are rotation backgrounds so you must set the rotation attributes: 
	ldr r1, =(1 << 8)				@ these are fixed point numbers with the low 8 bits the fractional part
	strh r1, [r0]					@ this basicaly gives it a 1:1 translation in x and y so you get a nice flat bitmap
	
	ldr r0, =REG_BG2PB
	ldr r1, =0
	strh r1, [r0]
	
	ldr r0, =REG_BG2PC
	ldr r1, =0
	strh r1, [r0]
	
	ldr r0, =REG_BG2PD
	ldr r1, =(1 << 8)
	strh r1, [r0]
	
	ldr r0, =REG_BG2X				@ set scroll registers to zero
	ldr r1, =0
	strh r1, [r0]

	ldr r0, =REG_BG2Y
	ldr r1, =0
	strh r1, [r0]
	
	ldr r0, =REG_BG2PA_SUB			@ these are rotation backgrounds so you must set the rotation attributes: 
	ldr r1, =(1 << 8)				@ these are fixed point numbers with the low 8 bits the fractional part
	strh r1, [r0]					@ this basicaly gives it a 1:1 translation in x and y so you get a nice flat bitmap
	
	ldr r0, =REG_BG2PB_SUB
	ldr r1, =0
	strh r1, [r0]
	
	ldr r0, =REG_BG2PC_SUB
	ldr r1, =0
	strh r1, [r0]
	
	ldr r0, =REG_BG2PD_SUB
	ldr r1, =(1 << 8)
	strh r1, [r0]
	
	ldr r0, =REG_BG2X_SUB			@ set scroll registers to zero
	ldr r1, =0
	strh r1, [r0]

	ldr r0, =REG_BG2Y_SUB
	ldr r1, =0
	strh r1, [r0]
	
	mov r0, #BG_BMP_RAM(0)			@ make r0 a pointer to screen memory bg bitmap main address 0
	ldr r1, =picBitmap				@ make r1 a pointer to your bitmap data
	mov r3, #0x6000					@ Half of 96k (2 pixels at a time)

mainPicLoop:
	ldr r2, [r1], #4				@ Loads r2 with the next two pixels from the bitmap data (pointed to by r1).
	str r2, [r0], #4				@ Write two pixels
	subs r3, r3, #1					@ Move along one
	bne mainPicLoop					@ And loop back if not done
	
	ldr r0, =BG_BMP_RAM_SUB(0)		@ make r0 a pointer to screen memory bg bitmap sub address 0
	ldr r1, =picBitmap				@ make r1 a pointer to your bitmap data
	mov r3, #0x6000					@ Half of 96k (2 pixels at a time)

subPicLoop:
	ldr r2, [r1], #4				@ Loads r2 with the next two pixels from the bitmap data (pointed to by r1).
	str r2, [r0], #4				@ Write two pixels
	subs r3, r3, #1					@ Move along one
	bne subPicLoop					@ And loop back if not done

	ldr r0, =REG_VCOUNT				@ This will actually make the assembler put the number REG_VCOUNT in the "pool" and
									@ the actual operation performed is a load from memory (likely ROM if you're not writting code to be
									@ copied to RAM). This is an operation you want to avoid if you want speed (in that case, mov 0x4000000
									@ and then add 6. The C compiler chooses this over an LDR quite often).

loop:

waitVBlank:									
	ldrh r1, [r0]					@ read REG_VCOUNT
	
	cmp r1, #(SCREEN_HEIGHT + 1)	@ 193 is, of course, the first scanline of vblank
	bne waitVBlank					@ loop if r1 is not equal to (NE condition) 193
									@ (CMP does a compare (it's purpose is to set the status)).
	b loop
