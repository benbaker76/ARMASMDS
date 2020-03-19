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
	
	ldr r0, =REG_DISPCNT_SUB		@ Sub screen to Mode 0 with BG0 active
	ldr r1, =(MODE_0_2D | DISPLAY_BG0_ACTIVE)
	str r1, [r0]
 
	ldr r0, =VRAM_A_CR				@ Set VRAM A to be main address 0x06000000
	ldr r1, =(VRAM_ENABLE | VRAM_A_MAIN_BG_0x06000000)
	strb r1, [r0]
	
	ldr r0, =VRAM_C_CR				@ Set VRAM C to be sub bg
	ldr r1, =(VRAM_ENABLE | VRAM_C_SUB_BG)
	strb r1, [r0]
	
	ldr r0, =REG_BG2CNT				@ Set main screen BG2 format to be 256x256x16 bitmap at base address
	ldr r1, =(BG_BMP16_256x256 | BG_BMP_BASE(0))
	strh r1, [r0]
	
	ldr r0, =REG_BG0CNT_SUB			@ Set sub screen format to be tiles
	ldr r1, =(BG_COLOR_16 | BG_32x32 | BG_MAP_BASE(29) | BG_TILE_BASE(0))
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
	
	mov r0, #BG_BMP_RAM(0)			@ make r0 a pointer to screen memory bg bitmap main address 0
	ldr r1, =picBitmap				@ make r1 a pointer to your bitmap data
	mov r3, #0x6000					@ Half of 96k (2 pixels at a time)

picLoop:
	ldr r2, [r1], #4				@ Loads r2 with the next two pixels from the bitmap data (pointed to by r1).
	str r2, [r0], #4				@ Write two pixels
	subs r3, r3, #1					@ Move along one
	bne picLoop						@ And loop back if not done
	
	ldr r1, =fontPal
	ldr r0, =BG_PALETTE_SUB			@ small loop to load the palette
	mov r2, #256					@ 256 * 16 bit color entires

palLoop:
	ldr r3,[r1],#2					@ Read one palette entry at a time
	strh r3,[r0],#2					@ Write palette entry
	subs r2, r2, #1					@ Move along one
	bne palLoop						@ And loop back until done

	ldr r0, =SCREEN_BASE_BLOCK_SUB(29)	@ make r0 a pointer to screen memory bg bitmap sub address
	adr r1, [text]					@ Get address of text characters to draw
	mov r2, #70						@ 70 characters to draw
	
mapLoop:
	ldrb r3,[r1],#1					@ Read r1 [text] and add 1 to [text] offset
	sub r3, #32						@ ASCII character - 32 to get tile offset
	strh r3, [r0], #2				@ Write the tile number to our 32x32 map and move along
	subs r2, r2, #1					@ Move along one
	bne mapLoop						@ And loop back until done

	ldr r0, =CHAR_BASE_BLOCK_SUB(0)	@ make r0 a pointer to screen memory bg bitmap sub address 0
	ldr r1, =fontTiles				@ make r1 a pointer to your bitmap data
	mov r3, #768					@ size of font

fontLoop:
	ldr r2, [r1], #4				@ Loads r2 with the next two pixels from the bitmap data (pointed to by r1).
	str r2, [r0], #4				@ Write two pixels
	subs r3, r3, #1					@ Move along one
	bne fontLoop					@ And loop back if not done

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
	
text:
	.byte '*','*','*','*',' ','C','O','M','M','O','D','O','R','E',' ','6','4',' ','B','A','S','I','C',' ','V','2',' ','*','*','*','*',' '
	.byte '6','4','K',' ','R','A','M',' ','S','Y','S','T','E','M',' ','3','8','9','1','1',' ','B','Y','T','E','S',' ','F','R','E','E',' '
	.byte 'R','E','A','D','Y','.'
